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
#   HARBOR_PROJECT   Harbor project           (default: rockchip)
#   IMAGE_NAME       repository name           (default: github-runner)
#   RUNNER_VERSION   actions/runner base tag   (default: Dockerfile ARG)
#   PUSH             set 0 to build only       (default: 1)
#   FORCE_ARCH       set 1 to skip arm64 guard (default: 0)
#
# Pushes two tags to <HARBOR_HOST>/<project>/<image> :
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

DATE_TAG="$(date +%Y%m%d)-arm64"
REPO="${HARBOR_HOST}/${HARBOR_PROJECT}/${IMAGE_NAME}"

build_args=()
[[ -n "${RUNNER_VERSION:-}" ]] && build_args+=(--build-arg "RUNNER_VERSION=${RUNNER_VERSION}")

echo "==> Building ${REPO}"
echo "    tags: ${DATE_TAG}, arm64"
docker build "${build_args[@]}" \
    -t "${REPO}:${DATE_TAG}" \
    -t "${REPO}:arm64" \
    "${CONTEXT}"

if [[ "${PUSH:-1}" == "1" ]]; then
    echo "==> Pushing (run 'docker login ${HARBOR_HOST}' first if needed)"
    docker push "${REPO}:${DATE_TAG}"
    docker push "${REPO}:arm64"
else
    echo "==> PUSH=0 — skipping push"
fi

echo "==> Done"
echo "    ${REPO}:${DATE_TAG}"
echo "    ${REPO}:arm64"
