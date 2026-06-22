#!/bin/bash
# Stamp the current kernel ABI into the meta source and build the metapackages.
# Usage: gen-and-build.sh <BUILD_DIR>   (BUILD_DIR holds the kernel .debs and receives the meta .debs)
set -eEo pipefail
trap 'echo "Error: in $0 on line $LINENO"' ERR

cd "$(dirname -- "$(readlink -f -- "$0")")"
BUILD_DIR="$(readlink -f -- "${1:?usage: gen-and-build.sh <BUILD_DIR>}")"

img_deb="$(find "${BUILD_DIR}" -maxdepth 1 -name 'linux-image-*-rockchip_*.deb' ! -name '*-dbg_*' | sort -V | tail -n1)"
[ -n "${img_deb}" ] || { echo "Error: no linux-image-*-rockchip deb in ${BUILD_DIR}"; exit 1; }

abi_pkg="$(dpkg-deb -f "${img_deb}" Package)"   # e.g. linux-image-6.1.0-1025-rockchip
abi="${abi_pkg#linux-image-}"                   # e.g. 6.1.0-1025-rockchip
kver="$(dpkg-deb -f "${img_deb}" Version)"      # e.g. 6.1.0-1025.25

sed "s|@ABI@|${abi}|g" debian/control.in > debian/control

cat > debian/changelog <<EOF
linux-meta-rockchip (${kver}) ${SUITE:-noble}; urgency=medium

  * Metapackages tracking Rockchip kernel ${abi}.

 -- Ubuntu Rockchip CI <ci@timmertech.io>  $(date -R)
EOF

dpkg-buildpackage -b -us -uc
# dpkg-buildpackage writes the binaries to the parent dir; fail loudly if they're not there.
ls ../linux-image-rockchip_*.deb ../linux-headers-rockchip_*.deb ../linux-rockchip_*.deb >/dev/null
mv ../linux-image-rockchip_*.deb ../linux-headers-rockchip_*.deb ../linux-rockchip_*.deb "${BUILD_DIR}/"
echo "Built metapackages for ${abi} -> ${BUILD_DIR}"
