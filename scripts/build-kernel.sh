#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
# shellcheck source=scripts/lib/retry.sh
source scripts/lib/retry.sh
mkdir -p build && cd build

if [[ -z ${SUITE} ]]; then
    echo "Error: SUITE is not set"
    exit 1
fi

# shellcheck source=/dev/null
source "../config/suites/${SUITE}.sh"

# Clone the kernel repo
if ! git -C linux-rockchip pull 2>/dev/null; then
    git_clone_retry "${KERNEL_REPO}" linux-rockchip --progress -b "${KERNEL_BRANCH}" --depth=2
fi

cd linux-rockchip
git checkout "${KERNEL_BRANCH}"

# shellcheck disable=SC2046
export $(dpkg-architecture -aarm64)
export CROSS_COMPILE=aarch64-linux-gnu-
export CC=aarch64-linux-gnu-gcc
export LANG=C

# Compile the kernel into a deb package
fakeroot debian/rules clean binary-headers binary-rockchip do_mainline_build=true
