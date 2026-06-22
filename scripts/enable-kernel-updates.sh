#!/bin/bash
# Enable Ubuntu-style kernel updates on an already-running Rockchip node.
# Run as root ON THE NODE. Idempotent. Reboot afterwards to use the new kernel.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "run as root"; exit 1; }

# Bootstrap: download the keyring deb (NL fast, CAN fallback) and install it.
# It drops the signing key + the apt source; afterwards it updates itself via apt.
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://s3.timmertech.nl/rockchip/apt/rockchip-archive-keyring.deb -o "$tmp/k.deb" \
  || curl -fsSL https://s3.timmertech.io/rockchip/apt/rockchip-archive-keyring.deb -o "$tmp/k.deb"
dpkg -i "$tmp/k.deb"

# Priority 500 = normal: this node tracks the latest kernel on apt upgrade. Pin both mirror hosts.
cat > /etc/apt/preferences.d/rockchip-kernel.pref <<EOF
Package: *
Pin: origin "s3.timmertech.nl"
Pin-Priority: 500

Package: *
Pin: origin "s3.timmertech.io"
Pin-Priority: 500
EOF

# Release any kernel holds left from the shipped image.
held="$(apt-mark showhold | grep -E '^linux-(image|headers|modules|rockchip)' || true)"
# shellcheck disable=SC2086
[ -z "${held}" ] || apt-mark unhold ${held}

apt-get update
apt-get install -y linux-rockchip   # meta: tracks latest ABI, keeps prior kernel for rollback

echo
echo "Done. Current: $(uname -r). Installed kernels:"
dpkg --list 'linux-image-*-rockchip' | awk '/^ii/{print "  " $2}'
echo "Reboot to boot the newest kernel. Previous kernel stays in the boot menu for rollback."
