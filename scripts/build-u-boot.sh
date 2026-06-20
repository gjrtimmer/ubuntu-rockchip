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

if [[ -z ${UBOOT_PACKAGE} ]]; then
    echo "Error: UBOOT_PACKAGE is not set"
    exit 1
fi

if [ ! -d "${UBOOT_PACKAGE}" ]; then
    # shellcheck source=/dev/null
    source ../packages/"${UBOOT_PACKAGE}"/debian/upstream
    git_clone_retry "${GIT}" "${UBOOT_PACKAGE}" --single-branch --progress -b "${BRANCH}"
    git -C "${UBOOT_PACKAGE}" checkout "${COMMIT}"
    cp -r ../packages/"${UBOOT_PACKAGE}"/debian "${UBOOT_PACKAGE}"
fi
cd "${UBOOT_PACKAGE}"

# Target package to build
rules=${UBOOT_RULES_TARGET},package-${UBOOT_RULES_TARGET}
if [[ -n ${UBOOT_RULES_TARGET_EXTRA} ]]; then
    rules=${UBOOT_RULES_TARGET_EXTRA},${rules}
fi

# Compile u-boot into a deb package
dpkg-source --before-build .
dpkg-buildpackage -a "$(cat debian/arch)" -d -b -nc -uc --rules-target="${rules}"
dpkg-source --after-build .

rm -f ../*.buildinfo ../*.changes
