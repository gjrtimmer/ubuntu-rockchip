#!/usr/bin/env bash
#
# Ephemeral GitHub Actions runner entrypoint.
#
#   Each iteration of the main loop:
#   1. Exchange the long-lived PAT for a short-lived runner *registration token*
#      via the GitHub REST API (the registration token is never baked/stored).
#   2. config.sh --ephemeral --unattended --replace
#   3. run.sh  -> serves exactly ONE job, deregisters itself, exits 0.
#   4. Loop — re-register and wait for the next job.
#
# Looping inside the container avoids Kubernetes CrashLoopBackOff backoff:
# k8s restartPolicy:Always applies exponential backoff even on clean (exit-0)
# exits, causing runners to sit idle for minutes between jobs. Keeping the
# container alive and re-registering internally eliminates the backoff entirely.
# Non-zero exit from run.sh still exits the container so k8s can restart it.
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

deregister() {
  echo "[entrypoint] caught signal — deregistering ${RUNNER_NAME}..."
  ./config.sh remove --token "$(gh_token remove-token)" || true
  exit 0
}
trap deregister INT TERM

while true; do
  echo "[entrypoint] requesting registration token for ${GITHUB_OWNER}/${GITHUB_REPO}..."
  REG_TOKEN="$(gh_token registration-token)"

  echo "[entrypoint] configuring ephemeral runner ${RUNNER_NAME} (labels: ${RUNNER_LABELS})..."
  ./config.sh \
    --url "${REPO_URL}" \
    --token "${REG_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --work "${RUNNER_WORKDIR}" \
    --ephemeral \
    --unattended \
    --replace

  echo "[entrypoint] starting run.sh (serves one job, then exits)..."
  if ! ./run.sh; then
    echo "[entrypoint] run.sh exited non-zero — exiting container for k8s restart"
    exit 1
  fi

  echo "[entrypoint] job complete — re-registering for next job..."
done
