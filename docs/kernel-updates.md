# Rockchip kernel updates (apt channel)

Nodes upgrade their kernel with apt instead of reflashing. Kernels are
ABI-versioned (`linux-image-6.1.0-NNNN-rockchip`) and co-installable; the
`linux-rockchip` metapackage tracks the latest and keeps the previous one.
Repo: NL `https://s3.timmertech.nl/rockchip/apt` (fast) with CAN
`https://s3.timmertech.io/rockchip/apt` fallback; suite = noble | jammy,
component main, arm64. CAN is the publish origin; NL is a replicated mirror.

## Bootstrap a node
    curl -fsSL https://s3.timmertech.nl/rockchip/apt/rockchip-kernel-channel.sh | sudo bash
    sudo reboot
Fetches the one-shot bootstrap from the public mirror; it installs the GPG-signed keyring
deb + apt source, unholds the kernel, and installs the `linux-rockchip` metapackage.
CAN fallback URL: https://s3.timmertech.io/rockchip/apt/rockchip-kernel-channel.sh

## Routine update
    sudo apt update && sudo apt upgrade   # pulls a new kernel if one was published
    sudo reboot

## Keep-N / autoremove
Ubuntu's /etc/kernel/postinst.d/apt-auto-removal hook marks the running and
latest kernels NeverAutoRemove. Verify it kept >= 2:
    apt-config dump | grep -i NeverAutoRemove
    dpkg --list 'linux-image-*-rockchip' | grep '^ii'
Purge an old one only after the new kernel is confirmed good:
    sudo apt-get purge linux-image-6.1.0-<OLD>-rockchip

## Rollback (headless — READ FIRST)
extlinux/u-boot does NOT auto-fall-back on a kernel panic. If a new kernel
fails to boot you must select the previous entry at the serial console.
1. Connect to the node's serial console via the Turing Pi BMC.
2. Reset the node; at the u-boot/extlinux menu pick the previous kernel LABEL.
3. Once booted on the known-good kernel:
       sudo apt-get purge linux-image-<BAD>-rockchip   # regenerates extlinux
Always keep >= 2 kernels installed so a rollback target exists.

## Canary
Update one node, reboot, confirm uname -r + dkms status, THEN fan out.

## Signing key / rotation
Key: https://s3.timmertech.nl/rockchip/apt/rockchip-archive-keyring.asc  (ID: <APT_GPG_KEY_ID>)
Private key lives only in GitHub Actions secrets. To rotate: generate a new key,
replace packages/rockchip-archive-keyring/rockchip-archive-keyring.asc, bump the
keyring deb version, re-run apt-publish. Nodes pick up the new key via apt before
the old one is retired.
