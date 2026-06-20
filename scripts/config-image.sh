#!/bin/bash

set -eE 
trap 'echo Error: in $0 on line $LINENO' ERR

if [ "$(id -u)" -ne 0 ]; then 
    echo "Please run as root"
    exit 1
fi

cd "$(dirname -- "$(readlink -f -- "$0")")" && cd ..
mkdir -p build && cd build

if [[ -z ${BOARD} ]]; then
    echo "Error: BOARD is not set"
    exit 1
fi

# shellcheck source=/dev/null
source "../config/boards/${BOARD}.sh"

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

if [[ ${LAUNCHPAD} != "Y" ]]; then
    uboot_package="$(basename "$(find u-boot-"${BOARD}"_*.deb | sort | tail -n1)")"
    if [ ! -e "$uboot_package" ]; then
        echo 'Error: could not find the u-boot package'
        exit 1
    fi

    linux_image_package="$(basename "$(find linux-image-*.deb | sort | tail -n1)")"
    if [ ! -e "$linux_image_package" ]; then
        echo "Error: could not find the linux image package"
        exit 1
    fi

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

setup_mountpoint() {
    local mountpoint="$1"

    if [ ! -c /dev/mem ]; then
        mknod -m 660 /dev/mem c 1 1
        chown root:kmem /dev/mem
    fi

    mount dev-live -t devtmpfs "$mountpoint/dev"
    mount devpts-live -t devpts -o nodev,nosuid "$mountpoint/dev/pts"
    mount proc-live -t proc "$mountpoint/proc"
    mount sysfs-live -t sysfs "$mountpoint/sys"
    mount securityfs -t securityfs "$mountpoint/sys/kernel/security"
    # Provide more up to date apparmor features, matching target kernel
    # cgroup2 mount for LP: 1944004
    mount -t cgroup2 none "$mountpoint/sys/fs/cgroup"
    mount -t tmpfs none "$mountpoint/tmp"
    mount -t tmpfs none "$mountpoint/var/lib/apt/lists"
    mount -t tmpfs none "$mountpoint/var/cache/apt"
    mv "$mountpoint/etc/resolv.conf" resolv.conf.tmp
    cp /etc/resolv.conf "$mountpoint/etc/resolv.conf"
    mv "$mountpoint/etc/nsswitch.conf" nsswitch.conf.tmp
    sed 's/systemd//g' nsswitch.conf.tmp > "$mountpoint/etc/nsswitch.conf"
}

teardown_mountpoint() {
    # Reverse the operations from setup_mountpoint
    local mountpoint
    mountpoint=$(realpath "$1")

    # ensure we have exactly one trailing slash, and escape all slashes for awk
    mountpoint_match=$(echo "$mountpoint" | sed -e's,/$,,; s,/,\\/,g;')'\/'
    # sort -r ensures that deeper mountpoints are unmounted first
    awk </proc/self/mounts "\$2 ~ /$mountpoint_match/ { print \$2 }" | LC_ALL=C sort -r | while IFS= read -r submount; do
        mount --make-private "$submount"
        umount "$submount"
    done
    mv resolv.conf.tmp "$mountpoint/etc/resolv.conf"
    mv nsswitch.conf.tmp "$mountpoint/etc/nsswitch.conf"
}

# Prevent dpkg interactive dialogues
export DEBIAN_FRONTEND=noninteractive

# Override localisation settings to address a perl warning
export LC_ALL=C

# Debootstrap options
chroot_dir=rootfs
overlay_dir=../overlay

# Defence-in-depth: if the build is cancelled (SIGINT/SIGTERM) or dies between setup_mountpoint
# and teardown_mountpoint, unmount everything under the chroot AT CANCEL TIME so we never leave a
# live kernel-global devtmpfs at rootfs/dev for a later rm to recurse into. Captures an absolute
# path so it resolves regardless of cwd; deepest-first; lazy + best-effort. The --one-file-system
# rm guards below remain the backstop for SIGKILL (which no trap can catch).
chroot_abs="$(pwd)/${chroot_dir}"
trap '
  for _m in $(awk -v d="${chroot_abs}" "\$2 ~ \"^\"d\"(/|\$)\" {print \$2}" /proc/self/mounts 2>/dev/null | LC_ALL=C sort -r); do
    umount -lf "${_m}" 2>/dev/null || true
  done
' EXIT INT TERM

# Extract the compressed root filesystem.
# A prior cancelled build can leave a kernel-global devtmpfs mounted at ${chroot_dir}/dev
# (setup_mountpoint, never torn down on cancel). Detach any leftover mounts first, then
# delete with --one-file-system as a hard guard: rm stops at every mount boundary, so it
# can never recurse into the live devtmpfs and unlink the host's /dev/null.
if [ -d "${chroot_dir}" ]; then
    for m in $(awk -v d="$(realpath "${chroot_dir}")" '$2 ~ "^"d"(/|$)" {print $2}' /proc/self/mounts | LC_ALL=C sort -r); do
        umount -lf "$m" 2>/dev/null || true
    done
fi
rm -rf --one-file-system ${chroot_dir} && mkdir -p ${chroot_dir}
rootfs_tar=$(find . -maxdepth 1 -name "ubuntu-*-preinstalled-${FLAVOR}-arm64.rootfs.tar.xz" | sort | tail -n1)
[ -n "${rootfs_tar}" ] || { echo "Error: rootfs tar not found for flavor=${FLAVOR}"; exit 1; }
# Extract YYYYMM from filename: ubuntu-VERSION-YYYYMM-preinstalled-...; fall back to current month
rootfs_month=$(basename "${rootfs_tar}" | cut -d- -f3)
[[ "${rootfs_month}" =~ ^[0-9]{6}$ ]] || rootfs_month=$(date -u +%Y%m)
tar -xpJf "${rootfs_tar}" -C ${chroot_dir}

# Mount the root filesystem
setup_mountpoint $chroot_dir

# Set apt retry policy for ALL chroot apt calls (update, upgrade, board hooks, launchpad installs)
printf 'Acquire::Retries "3";\nAcquire::http::Timeout "60";\n' > "${chroot_dir}/etc/apt/apt.conf.d/99-ci-retries"

# Update packages
chroot $chroot_dir apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 update
chroot $chroot_dir apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 -y upgrade
    
# Run config hook to handle board specific changes
if [[ $(type -t config_image_hook__"${BOARD}") == function ]]; then
    config_image_hook__"${BOARD}" "${chroot_dir}" "${overlay_dir}" "${SUITE}"
fi 

# Download and install U-Boot
if [[ ${LAUNCHPAD} == "Y" ]]; then
    chroot ${chroot_dir} apt-get -o Acquire::Retries=3 -o Acquire::http::Timeout=60 -y install "u-boot-${BOARD}"
else
    cp "${uboot_package}" ${chroot_dir}/tmp/
    chroot ${chroot_dir} dpkg -i "/tmp/${uboot_package}"
    chroot ${chroot_dir} apt-mark hold "$(echo "${uboot_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"

    cp "${linux_image_package}" "${linux_headers_package}" "${linux_modules_package}" "${linux_buildinfo_package}" "${linux_rockchip_headers_package}" ${chroot_dir}/tmp/
    chroot ${chroot_dir} /bin/bash -c "apt-get -y purge \$(dpkg --list | grep -Ei 'linux-image|linux-headers|linux-modules|linux-rockchip' | awk '{ print \$2 }')"
    chroot ${chroot_dir} /bin/bash -c "dpkg -i /tmp/{${linux_image_package},${linux_modules_package},${linux_buildinfo_package},${linux_rockchip_headers_package}}"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_image_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_modules_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_buildinfo_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
    chroot ${chroot_dir} apt-mark hold "$(echo "${linux_rockchip_headers_package}" | sed -rn 's/(.*)_[[:digit:]].*/\1/p')"
fi

# Update the initramfs
chroot ${chroot_dir} update-initramfs -u

# Remove packages
chroot ${chroot_dir} apt-get -y clean
chroot ${chroot_dir} apt-get -y autoclean
chroot ${chroot_dir} apt-get -y autoremove

# Umount the root filesystem
teardown_mountpoint $chroot_dir

# Compress the root filesystem and then build a disk image.
# --one-file-system guards the post-teardown delete: if teardown_mountpoint left anything
# mounted under ${chroot_dir} (e.g. the devtmpfs at ${chroot_dir}/dev), rm stops at the
# mount boundary instead of recursing into the kernel-global devtmpfs and unlinking host /dev/null.
cd ${chroot_dir} && tar -cpf "../ubuntu-${RELASE_VERSION}-${rootfs_month}-preinstalled-${FLAVOR}-arm64-${BOARD}.rootfs.tar" . && cd .. && rm -rf --one-file-system ${chroot_dir}
../scripts/build-image.sh "ubuntu-${RELASE_VERSION}-${rootfs_month}-preinstalled-${FLAVOR}-arm64-${BOARD}.rootfs.tar"
rm -f "ubuntu-${RELASE_VERSION}-${rootfs_month}-preinstalled-${FLAVOR}-arm64-${BOARD}.rootfs.tar"
