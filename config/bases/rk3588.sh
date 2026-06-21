# shellcheck shell=bash
#
# Configured-base group: rk3588
#
# Pre-bakes the firmware layer that is IDENTICAL across all 28 RK3588-family boards
# (verified: every one installs the same panfork-mesa PPA + mali-g610-firmware +
# libmali-g610-x11 + camera-engine-rkaiq-rk3588). Building it once per suite x flavor
# means the per-board image build skips the expensive panfork dist-upgrade + GPU
# install + kernel install + initramfs (done ~4x instead of ~28x).
#
# IMPORTANT: the per-board config_image_hook__<board> functions are NOT modified.
# They still call `apt-get install mali-g610-firmware ...` etc., which become fast
# no-ops ("already newest version") because this base already installed them. Boards
# with extra firmware (wiringpi, aic8800, RTL/AP BT) still add it in their own hook.

export BASE_NAME="rk3588"
# BOARD_SOC strings this base covers.
export BASE_SOCS=("Rockchip RK3588" "Rockchip RK3588S" "Rockchip RK3588S2")
# Suite/flavor combinations to pre-bake (matches what the RK3588 boards support).
export BASE_SUITES=("jammy" "noble")
export BASE_FLAVORS=("server" "desktop")

# config_base_hook__rk3588 <chroot_dir> <suite>
# Runs inside build-base.sh with the chroot mounted and the kernel already installed.
# Mirrors the shared GPU/camera block that every RK3588 board hook performs, so it is
# already present (and idempotent) by the time the board hook runs.
function config_base_hook__rk3588() {
    local rootfs="$1"
    local suite="$2"

    if [ "${suite}" == "jammy" ] || [ "${suite}" == "noble" ]; then
        # Install panfork
        chroot "${rootfs}" add-apt-repository -y ppa:jjriek/panfork-mesa
        chroot "${rootfs}" apt-get update
        chroot "${rootfs}" apt-get -y install mali-g610-firmware
        # Firmware install (mesa -> panfork swap), NOT a currency upgrade.
        chroot "${rootfs}" apt-get -y dist-upgrade

        # Install libmali blobs alongside panfork
        chroot "${rootfs}" apt-get -y install libmali-g610-x11

        # Install the rockchip camera engine
        chroot "${rootfs}" apt-get -y install camera-engine-rkaiq-rk3588
    fi

    return 0
}
