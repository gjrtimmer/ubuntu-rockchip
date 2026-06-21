#!/bin/bash
# Build + push the project's container images to Harbor (+ Docker Hub).
# (Named build-docker-images.sh to avoid confusion with build-image.sh, which builds
# the bootable OS disk image — a different thing entirely.)
#
# Images (arm64-ONLY — build on an RK1/arm64 host):
#   github-runner       context ci/image                    self-hosted Actions runner + build toolchain
#   s3-promote-cleanup  Dockerfile deploy/s3-promote-cleanup verified CA->NL promote-cleanup CronJob (mc+jq)
#
# Usage:
#   ./scripts/build-docker-images.sh                      # build+push ALL images
#   ./scripts/build-docker-images.sh github-runner        # only the named image(s)
#   ./scripts/build-docker-images.sh s3-promote-cleanup
#
# Env overrides:
#   HARBOR_HOST      Harbor registry host        (default: harbor.local)
#   HARBOR_PROJECT   Harbor project              (default: rockchip)
#   DOCKERHUB_USER   Docker Hub user/org         (default: gjrtimmer)
#   RUNNER_VERSION   actions/runner base tag     (default: Dockerfile ARG; github-runner only)
#   PUSH             0 = build only              (default: 1)
#   PUSH_HARBOR      0 = skip Harbor             (default: 1)
#   PUSH_DOCKERHUB   0 = skip Docker Hub         (default: 1)
#   FORCE_ARCH       1 = skip arm64 guard        (default: 0)
#
# Each image is pushed with two tags to every enabled registry:
#   YYYYMMDD-arm64   dated, arch-suffixed pin
#   arm64            rolling tag the cluster pulls

set -eE
trap 'echo "Error: in $0 on line $LINENO"' ERR

# Run from the repo root regardless of where the script is invoked from.
cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..

HARBOR_HOST="${HARBOR_HOST:-harbor.local}"
HARBOR_PROJECT="${HARBOR_PROJECT:-rockchip}"
DOCKERHUB_USER="${DOCKERHUB_USER:-gjrtimmer}"

# Image registry:  name | build-context | dockerfile (empty => <context>/Dockerfile)
images=(
    "github-runner|ci/image|"
    "s3-promote-cleanup|.|deploy/s3-promote-cleanup/image/Dockerfile"
)

# Optional positional filter: build only the named images (default: all).
select=("$@")
want() {
    [[ ${#select[@]} -eq 0 ]] && return 0
    local n="$1" s
    for s in "${select[@]}"; do [[ "${s}" == "${n}" ]] && return 0; done
    return 1
}

# arm64-only: both images bake arm64 binaries; building on x86 produces the wrong arch.
arch="$(uname -m)"
if [[ "${arch}" != "aarch64" && "${arch}" != "arm64" ]]; then
    echo "Error: host arch is '${arch}', not arm64 — these images must be arm64."
    echo "Build on an RK1/arm64 node, or set FORCE_ARCH=1 to override."
    [[ "${FORCE_ARCH:-0}" == "1" ]] || exit 1
    echo "FORCE_ARCH=1 set — continuing on ${arch} anyway."
fi

DATE_TAG="$(date +%Y%m%d)-arm64"   # dated, arch-suffixed version pin
ROLLING_TAG="arm64"                # rolling tag the cluster pulls

build_one() {
    local name="$1" context="$2" dockerfile="$3"

    local repos=()
    [[ "${PUSH_HARBOR:-1}" == "1" ]]    && repos+=("${HARBOR_HOST}/${HARBOR_PROJECT}/${name}")
    [[ "${PUSH_DOCKERHUB:-1}" == "1" ]] && repos+=("docker.io/${DOCKERHUB_USER}/${name}")
    if [[ ${#repos[@]} -eq 0 ]]; then
        echo "Error: PUSH_HARBOR and PUSH_DOCKERHUB are both 0 — nothing to do."
        exit 1
    fi

    local build_args=()
    [[ "${name}" == "github-runner" && -n "${RUNNER_VERSION:-}" ]] && build_args+=(--build-arg "RUNNER_VERSION=${RUNNER_VERSION}")
    [[ -n "${dockerfile}" ]] && build_args+=(-f "${dockerfile}")

    local tag_args=() r
    for r in "${repos[@]}"; do
        tag_args+=(-t "${r}:${DATE_TAG}" -t "${r}:${ROLLING_TAG}")
    done

    echo "==> Building ${name} (context ${context}, tags: ${DATE_TAG}, ${ROLLING_TAG})"
    for r in "${repos[@]}"; do echo "    ${r}"; done
    docker build "${build_args[@]}" "${tag_args[@]}" "${context}"

    if [[ "${PUSH:-1}" == "1" ]]; then
        for r in "${repos[@]}"; do
            echo "==> Pushing ${r}  (run 'docker login' for its registry first if needed)"
            docker push "${r}:${DATE_TAG}"
            docker push "${r}:${ROLLING_TAG}"
        done
    else
        echo "==> PUSH=0 — skipping push for ${name}"
    fi
}

built=0
for entry in "${images[@]}"; do
    IFS='|' read -r name context dockerfile <<<"${entry}"
    want "${name}" || continue
    df="${dockerfile:-${context}/Dockerfile}"
    if [[ ! -f "${df}" ]]; then
        echo "Error: Dockerfile '${df}' not found for image '${name}'."
        exit 1
    fi
    build_one "${name}" "${context}" "${dockerfile}"
    built=$((built + 1))
done

if [[ ${built} -eq 0 ]]; then
    echo "Error: no images matched filter: ${select[*]}"
    exit 1
fi

echo "==> Done (${built} image(s))"
