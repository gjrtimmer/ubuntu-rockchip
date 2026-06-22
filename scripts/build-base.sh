#!/bin/bash

set -eE
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
mkdir -p build && cd build

if [[ -z ${SUITE} ]]; then
    echo "Error: SUITE is not set"
    exit 1
fi

# shellcheck source=/dev/null
source "../config/suites/${SUITE}.sh"

if [[ -z ${FLAVOR} ]]; then
    echo "Error: FLAVOR is not set"
    exit 1
fi

# shellcheck source=/dev/null
source "../config/flavors/${FLAVOR}.sh"

if [[ -z ${BASE_GROUP} ]]; then
    echo "Error: BASE_GROUP is not set"
    exit 1
fi

# shellcheck source=/dev/null
source "../config/bases/${BASE_GROUP}.sh"

# shellcheck source=../scripts/lib/chroot.sh
source ../scripts/lib/chroot.sh

# The base bakes the locally-built kernel; with --launchpad the rockchip kernel is
# already pulled into the rootfs from the PPA, so no kernel .deb is needed here.
if [[ ${LAUNCHPAD} != "Y" ]]; then
    linux_image_package="$(basename "$(find linux-image-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_image_package" ]; then
        echo "Error: could not find the linux image package"
        exit 1
    fi

    # The per-flavor kernel headers create /lib/modules/<ver>/build, which board-hook DKMS
    # modules (e.g. bcmdhd-sdio-dkms, aic8800) need to build against the rockchip kernel.
    # Without them, DKMS in the chroot falls back to the host's `uname -r` and fails.
    linux_headers_package="$(basename "$(find linux-headers-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_headers_package" ]; then
        echo "Error: could not find the linux headers package"
        exit 1
    fi

    linux_modules_package="$(basename "$(find linux-modules-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_modules_package" ]; then
        echo "Error: could not find the linux modules package"
        exit 1
    fi

    linux_buildinfo_package="$(basename "$(find linux-buildinfo-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_buildinfo_package" ]; then
        echo "Error: could not find the linux buildinfo package"
        exit 1
    fi

    linux_rockchip_headers_package="$(basename "$(find linux-rockchip-headers-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_rockchip_headers_package" ]; then
        echo "Error: could not find the linux rockchip headers package"
        exit 1
    fi
fi

# Prevent dpkg interactive dialogues
export DEBIAN_FRONTEND=noninteractive

# Override localisation settings to address a perl warning
export LC_ALL=C

chroot_dir=rootfs-base
overlay_dir=../overlay

# Defence-in-depth: unmount everything under the chroot AT CANCEL TIME so a cancelled
# build never leaves a live kernel-global devtmpfs at ${chroot_dir}/dev for a later rm
# to recurse into. Absolute path so it resolves regardless of cwd; deepest-first.
chroot_abs="$(pwd)/${chroot_dir}"
trap '
  for _m in $(awk -v d="${chroot_abs}" "\$2 ~ \"^\"d\"(/|\$)\" {print \$2}" /proc/self/mounts 2>/dev/null | LC_ALL=C sort -r); do
    umount -lf "${_m}" 2>/dev/null || true
  done
' EXIT INT TERM

# Detach any leftover mounts from a prior cancelled run, then delete with
# --one-file-system so rm stops at every mount boundary (never recurses into a live
# devtmpfs and unlinks host /dev/null).
if [ -d "${chroot_dir}" ]; then
    for m in $(awk -v d="$(realpath "${chroot_dir}")" '$2 ~ "^"d"(/|$)" {print $2}' /proc/self/mounts | LC_ALL=C sort -r); do
        umount -lf "$m" 2>/dev/null || true
    done
fi
rm -rf --one-file-system ${chroot_dir} && mkdir -p ${chroot_dir}

# Extract the board-agnostic rootfs.
rootfs_tar=$(find . -maxdepth 1 -name "ubuntu-*-preinstalled-${FLAVOR}-arm64.rootfs.tar.xz" | sort | tail -n1)
[ -n "${rootfs_tar}" ] || { echo "Error: rootfs tar not found for flavor=${FLAVOR}"; exit 1; }
# Extract YYYYMM from filename so the base inherits the rootfs's monthly snapshot stamp.
rootfs_month=$(basename "${rootfs_tar}" | cut -d- -f3)
[[ "${rootfs_month}" =~ ^[0-9]{6}$ ]] || rootfs_month=$(date -u +%Y%m)
tar -xpJf "${rootfs_tar}" -C ${chroot_dir}

# Mount the root filesystem
setup_mountpoint $chroot_dir

# Set apt retry policy for ALL chroot apt calls
printf 'Acquire::Retries "3";\nAcquire::http::Timeout "60";\n' > "${chroot_dir}/etc/apt/apt.conf.d/99-ci-retries"

# Refresh package lists (apt lists dir is a fresh tmpfs). No `apt upgrade`: the rootfs
# is the pinned monthly snapshot; currency upgrades are post-install (end-user).
chroot $chroot_dir apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 update

# Install the locally-built kernel (skipped for --launchpad: already in the rootfs).
if [[ ${LAUNCHPAD} != "Y" ]]; then
    cp "${linux_image_package}" "${linux_headers_package}" "${linux_modules_package}" "${linux_buildinfo_package}" "${linux_rockchip_headers_package}" ${chroot_dir}/tmp/
    chroot ${chroot_dir} /bin/bash -c "apt-get -y purge \$(dpkg --list | grep -Ei 'linux-image|linux-headers|linux-modules|linux-rockchip' | awk '{ print \$2 }')"
    # linux-rockchip-headers before linux-headers-<ver>: the per-flavor headers depend on it.
    chroot ${chroot_dir} /bin/bash -c "dpkg -i /tmp/{${linux_image_package},${linux_modules_package},${linux_buildinfo_package},${linux_rockchip_headers_package},${linux_headers_package}}"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_image_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_headers_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_modules_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_buildinfo_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_rockchip_headers_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
fi

# Bake the shared firmware layer for this base group (panfork PPA + GPU/camera stack).
if [[ $(type -t config_base_hook__"${BASE_GROUP}") == function ]]; then
    config_base_hook__"${BASE_GROUP}" "${chroot_dir}" "${SUITE}"
fi

# Update the initramfs against the installed kernel.
chroot ${chroot_dir} update-initramfs -u

# Remove packages / clean apt caches
chroot ${chroot_dir} apt-get -y clean
chroot ${chroot_dir} apt-get -y autoclean
chroot ${chroot_dir} apt-get -y autoremove

# Umount the root filesystem
teardown_mountpoint $chroot_dir

# Pack the configured base into build/base/. Named *.base.tar.xz so config-image.sh
# prefers it over the raw *.rootfs.tar.xz. xz -3 -T0 matches the image-compression
# speed/size tradeoff.
mkdir -p base
base_tar="ubuntu-${RELASE_VERSION}-${rootfs_month}-preinstalled-${FLAVOR}-arm64.base.tar"
cd ${chroot_dir} && tar -cpf "../base/${base_tar}" . && cd .. && rm -rf --one-file-system ${chroot_dir}
xz -3 --force --quiet --threads=0 "base/${base_tar}"
echo "Built base/${base_tar}.xz"
