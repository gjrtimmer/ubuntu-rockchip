#!/bin/bash
# Build the rockchip-archive-keyring deb into BUILD_DIR (skip if it already exists).
# Usage: build.sh <BUILD_DIR>
set -eEo pipefail
trap 'echo "Error: in $0 on line $LINENO"' ERR

cd "$(dirname -- "$(readlink -f -- "$0")")"
BUILD_DIR="$(readlink -f -- "${1:?usage: build.sh <BUILD_DIR>}")"

if find "${BUILD_DIR}" -maxdepth 1 -name 'rockchip-archive-keyring_*_all.deb' | grep -q .; then
    echo "keyring deb already present in ${BUILD_DIR}; skipping"
    exit 0
fi

dpkg-buildpackage -b -us -uc
mv ../rockchip-archive-keyring_*_all.deb "${BUILD_DIR}/"
echo "Built rockchip-archive-keyring -> ${BUILD_DIR}"
