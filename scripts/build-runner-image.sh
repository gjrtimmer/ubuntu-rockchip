#!/bin/bash
# Build + push the self-hosted GitHub Actions runner image (ci/image) to Harbor.
#
# The image bakes the ubuntu-rockchip build toolchain on top of the GitHub runner
# agent so the k3s DaemonSet runners build images natively on arm64 (RK1) with no
# per-job apt install. It is arm64-ONLY: build it on an RK1/arm64 host.
#
# Usage:
#   ./scripts/build-runner-image.sh                       # -> harbor.local
#   ./scripts/build-runner-image.sh harbor.example.com    # override host
#   HARBOR_HOST=harbor.example.com ./scripts/build-runner-image.sh
#
# Env overrides:
#   HARBOR_HOST      Harbor registry host      (default: harbor.local)
#   HARBOR_PROJECT   Harbor project            (default: rockchip)
#   IMAGE_NAME       repository name           (default: github-runner)
#   DOCKERHUB_USER   Docker Hub user/org       (default: gjrtimmer)
#   RUNNER_VERSION   actions/runner base tag   (default: Dockerfile ARG)
#   PUSH             set 0 to build only       (default: 1)
#   PUSH_HARBOR      set 0 to skip Harbor      (default: 1)
#   PUSH_DOCKERHUB   set 0 to skip Docker Hub  (default: 1)
#   FORCE_ARCH       set 1 to skip arm64 guard (default: 0)
#
# Pushes two tags to BOTH harbor.local/rockchip/github-runner and
# docker.io/gjrtimmer/github-runner :
#   - YYYYMMDD-arm64   dated, arch-suffixed version pin
#   - arm64            rolling tag the runner DaemonSet pulls

set -eE
trap 'echo "Error: in $0 on line $LINENO"' ERR

# Run from the repo root regardless of where the script is invoked from.
cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..

HARBOR_HOST="${HARBOR_HOST:-${1:-harbor.local}}"
HARBOR_PROJECT="${HARBOR_PROJECT:-rockchip}"
IMAGE_NAME="${IMAGE_NAME:-github-runner}"
CONTEXT="ci/image"

if [ ! -f "${CONTEXT}/Dockerfile" ]; then
    echo "Error: ${CONTEXT}/Dockerfile not found (run from the repo, build context missing)."
    exit 1
fi

# The image is arm64-only (RK1 target). Building on x86 produces the wrong arch.
arch="$(uname -m)"
if [[ "${arch}" != "aarch64" && "${arch}" != "arm64" ]]; then
    echo "Error: host arch is '${arch}', not arm64 — the runner image must be arm64."
    echo "Build it on an RK1/arm64 node, or set FORCE_ARCH=1 to override."
    [[ "${FORCE_ARCH:-0}" == "1" ]] || exit 1
    echo "FORCE_ARCH=1 set — continuing on ${arch} anyway."
fi

DATE_TAG="$(date +%Y%m%d)-arm64"   # dated, arch-suffixed version pin
ROLLING_TAG="arm64"                # rolling tag the runner DaemonSet pulls

DOCKERHUB_USER="${DOCKERHUB_USER:-gjrtimmer}"
HARBOR_REPO="${HARBOR_HOST}/${HARBOR_PROJECT}/${IMAGE_NAME}"
DOCKERHUB_REPO="docker.io/${DOCKERHUB_USER}/${IMAGE_NAME}"

# Target registries (toggle either off).
repos=()
[[ "${PUSH_HARBOR:-1}" == "1" ]]    && repos+=("${HARBOR_REPO}")
[[ "${PUSH_DOCKERHUB:-1}" == "1" ]] && repos+=("${DOCKERHUB_REPO}")
if [[ ${#repos[@]} -eq 0 ]]; then
    echo "Error: PUSH_HARBOR and PUSH_DOCKERHUB are both 0 — nothing to do."
    exit 1
fi

build_args=()
[[ -n "${RUNNER_VERSION:-}" ]] && build_args+=(--build-arg "RUNNER_VERSION=${RUNNER_VERSION}")

# Build once, tag for every target registry (both tags each).
tag_args=()
for r in "${repos[@]}"; do
    tag_args+=(-t "${r}:${DATE_TAG}" -t "${r}:${ROLLING_TAG}")
done

echo "==> Building (tags: ${DATE_TAG}, ${ROLLING_TAG})"
for r in "${repos[@]}"; do echo "    ${r}"; done
docker build "${build_args[@]}" "${tag_args[@]}" "${CONTEXT}"

if [[ "${PUSH:-1}" == "1" ]]; then
    for r in "${repos[@]}"; do
        echo "==> Pushing ${r}  (run 'docker login' for its registry first if needed)"
        docker push "${r}:${DATE_TAG}"
        docker push "${r}:${ROLLING_TAG}"
    done
else
    echo "==> PUSH=0 — skipping push"
fi

echo "==> Done"
for r in "${repos[@]}"; do
    echo "    ${r}:${DATE_TAG}"
    echo "    ${r}:${ROLLING_TAG}"
done
