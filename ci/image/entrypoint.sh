#!/usr/bin/env bash
#
# Ephemeral GitHub Actions runner entrypoint.
#
#   Each iteration of the main loop:
#   1. Exchange the long-lived PAT for a short-lived runner *registration token*
#      via the GitHub REST API (the registration token is never baked/stored).
#   2. config.sh --ephemeral --unattended --replace, registering under a name
#      that gets a fresh short hash suffix every iteration (node1-a1b2c3d4).
#   3. run.sh  -> serves exactly ONE job, deregisters itself, exits.
#   4. Loop — re-register (new hash) and wait for the next job.
#
# The per-registration hash suffix avoids a runner-name collision on rollout:
# the DaemonSet fixes RUNNER_NAME to the node name (fieldRef spec.nodeName), so
# a killed pod's listener session (held by GitHub for ~2 min) would otherwise
# block the replacement pod with "A session for this runner already exists",
# delaying job pickup. A unique suffix means the lingering session can never
# collide; the stale entry ages out as an offline ephemeral runner (auto-reaped).
#
# Looping inside the container avoids Kubernetes CrashLoopBackOff backoff:
# k8s restartPolicy:Always applies exponential backoff even on clean (exit-0)
# exits, causing runners to sit idle for minutes between jobs. Keeping the
# container alive and re-registering internally eliminates the backoff entirely.
#
# run.sh exit code is intentionally NOT treated as fatal: the runner agent
# exits non-zero to request a restart after an in-place self-update, so a hard
# exit there would kill the container on every agent update. Any non-zero exit
# just re-loops and re-registers. Truly fatal conditions (revoked PAT, GitHub
# unreachable) surface at gh_token/config.sh, where `set -e` exits the container
# and lets k8s restart it — the correct escalation path.
#
# Graceful shutdown: run.sh is started in the BACKGROUND and waited on, so a
# SIGTERM from k8s (rollout/drain) runs the deregister trap immediately instead
# of being deferred until the foreground run.sh returns (which it would not,
# while idle-listening — k8s signals only PID 1, not the agent child). The trap
# forwards TERM to the agent so it stops the current job and releases its
# listener session, then removes the runner registration. This frees the
# session and prunes the offline entry on rollout instead of leaving it to age
# out (~2 min session / ~24h ephemeral entry).
set -euo pipefail

: "${GITHUB_OWNER:?GITHUB_OWNER is required}"
: "${GITHUB_REPO:?GITHUB_REPO is required}"
: "${GITHUB_PAT:?GITHUB_PAT is required}"

# Keep the PAT only as a non-exported shell var, then scrub it from the
# environment. The job runs in THIS container (containerMode=default), so an
# inherited GITHUB_PAT would be readable by every job step via printenv /
# /proc/self/environ. After unset it is gone from the env handed to run.sh and
# its children; the deregister trap below still reads $_PAT.
_PAT="${GITHUB_PAT}"
unset GITHUB_PAT

RUNNER_LABELS="${RUNNER_LABELS:-rk1-arm64}"
RUNNER_NAME="${RUNNER_NAME:-$(hostname)}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-/home/runner/_work}"

API="https://api.github.com"
REPO_URL="https://github.com/${GITHUB_OWNER}/${GITHUB_REPO}"

gh_token() {
  # $1 = registration-token | remove-token
  curl -fsSL -X POST \
    -H "Authorization: Bearer ${_PAT}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "${API}/repos/${GITHUB_OWNER}/${GITHUB_REPO}/actions/runners/${1}" \
    | jq -r '.token'
}

# Fresh 8-hex token, regenerated per registration, for a unique runner name.
# /proc/sys/kernel/random/uuid is always present in the Linux container; the
# $RANDOM line is a no-dependency fallback (no openssl/xxd needed).
short_hash() {
  local u
  u="$(cat /proc/sys/kernel/random/uuid 2>/dev/null)"; u="${u//-/}"
  [ -n "$u" ] && printf '%s' "${u:0:8}" || printf '%04x%04x' "$RANDOM" "$RANDOM"
}

# PID of the backgrounded run.sh for the current iteration ("" when none).
RUN_PID=""

deregister() {
  echo "[entrypoint] caught signal — deregistering ${RUNNER_REG_NAME:-$RUNNER_NAME}..."
  # Stop the agent first so it cancels the in-flight job and drops its listener
  # session, then remove the registration while it is idle.
  if [ -n "${RUN_PID}" ] && kill -0 "${RUN_PID}" 2>/dev/null; then
    kill -TERM "${RUN_PID}" 2>/dev/null || true
    wait "${RUN_PID}" 2>/dev/null || true
  fi
  ./config.sh remove --token "$(gh_token remove-token)" || true
  exit 0
}
trap deregister INT TERM

while true; do
  echo "[entrypoint] requesting registration token for ${GITHUB_OWNER}/${GITHUB_REPO}..."
  REG_TOKEN="$(gh_token registration-token)"

  # Fresh unique name per registration (node1-a1b2c3d4) so a stale session from
  # a just-killed pod with the same node name can never block this one.
  RUNNER_REG_NAME="${RUNNER_NAME}-$(short_hash)"

  echo "[entrypoint] configuring ephemeral runner ${RUNNER_REG_NAME} (labels: ${RUNNER_LABELS})..."
  ./config.sh \
    --url "${REPO_URL}" \
    --token "${REG_TOKEN}" \
    --name "${RUNNER_REG_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --work "${RUNNER_WORKDIR}" \
    --ephemeral \
    --unattended \
    --replace

  echo "[entrypoint] starting run.sh (serves one job, then exits)..."
  # Background + wait so a SIGTERM interrupts `wait` and runs the deregister
  # trap at once, rather than being queued behind a foreground run.sh.
  ./run.sh &
  RUN_PID=$!
  wait "${RUN_PID}" || echo "[entrypoint] run.sh exited non-zero (agent self-update or transient) — re-registering..."
  RUN_PID=""

  echo "[entrypoint] job cycle complete — re-registering for next job..."
  sleep 2
done
