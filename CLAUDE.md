# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

This repo builds bootable **Ubuntu** disk images for **Rockchip ARM SoC** single-board computers and dev boards
(RK3588 / RK3588S / RK3588S2 / RK3576 / RK3566 …). It is a maintained fork of `Joshua-Riek/ubuntu-rockchip`.
It currently supports **31 boards** (`config/boards/*.sh`), **2 LTS Ubuntu suites** (jammy 22.04, noble 24.04),
and **2 flavors** (server, desktop). Output is a per-board `*.img.xz` (+ `.sha256`). Interim (non-LTS) suites are
intentionally not built — they EOL in 9 months and their archives vanish from `ports.ubuntu.com`, breaking builds.

It is **not** an application codebase — there is no compiled app and no unit tests. Almost everything is Bash
plus declarative shell-config files and Debian packaging.

## Build commands

The build **must run as root on an `arm64`-capable Linux host** (CI uses `ubuntu-*` runners with
`qemu-user-static` for the chroot). It will not run on a non-arm64 / non-root dev machine — treat local
"builds" as not runnable; verify changes by reading the scripts and CI logs instead.

```bash
# Full image: kernel (if missing) -> u-boot (if missing) -> rootfs -> config-image -> disk image
sudo ./build.sh --board=orangepi-5-plus --suite=noble --flavor=server

# Partial builds (each maps to a script in scripts/)
sudo ./build.sh --suite=noble --kernel-only                 # -> build/linux-*.deb
sudo ./build.sh --board=orangepi-5-plus --uboot-only        # -> build/u-boot-*_*.deb
sudo ./build.sh --suite=noble --flavor=server --rootfs-only # -> build/ubuntu-*.rootfs.tar.xz

# Enumerate valid argument values
./build.sh --board=help     # lists config/boards/*
./build.sh --suite=help     # lists config/suites/*
./build.sh --flavor=help    # lists config/flavors/*

./build.sh --clean ...      # wipe build/ first (also unmounts stale chroot mounts)
./build.sh --launchpad ...  # pull prebuilt kernel/u-boot from the jjriek PPA instead of compiling
./build.sh --verbose ...    # set -x
```

Intermediate `.deb`/`.tar.xz` land in `build/` (gitignored); final images in `images/` (gitignored).
Every run tees its full log to `build/logs/build-<timestamp>.log`.

## Architecture: the build pipeline

`build.sh` is an argument parser + orchestrator. It sources the matching config files (which only `export`
env vars and define shell-function hooks), then calls the `scripts/` in order. State lives only in env vars
and files under `build/`.

```
config/suites/<suite>.sh    ─┐  (RELASE_VERSION, KERNEL_REPO/BRANCH, EXTRA_PPAS)
config/flavors/<flavor>.sh  ─┼─ sourced into env by build.sh / each script
config/boards/<board>.sh    ─┘  (UBOOT_PACKAGE, UBOOT_RULES_TARGET, COMPATIBLE_*, hooks)
        │
        ▼
scripts/build-kernel.sh   clones Joshua-Riek/linux-rockchip @ KERNEL_BRANCH (vendor 6.1), builds linux-*.deb
scripts/build-u-boot.sh   grafts our packages/u-boot-*/debian onto upstream U-Boot, builds u-boot-<board>_*.deb
scripts/build-rootfs.sh   builds a <suite>/<flavor> rootfs via Ubuntu live-build (Joshua-Riek/livecd-rootfs)  [BOARD-AGNOSTIC]
scripts/config-image.sh   extracts rootfs, chroots in, installs the kernel+u-boot .debs, runs config_image_hook__<board>, repacks
scripts/build-image.sh    partitions a loopback image, lays down rootfs, dd's u-boot to raw disk, runs build_image_hook__<board>, compresses -> images/*.img.xz
```

**Key invariant (inherited from upstream): the rootfs is board-independent.** Everything board-specific happens
in `config-image.sh` (software/firmware via the chroot hook) and `build-image.sh` (partition layout + bootloader).

### The config layer (the main extension surface)

Board behaviour lives entirely in `config/boards/<board>.sh`. It exports metadata (`BOARD_NAME`, `BOARD_SOC`,
`BOARD_MAKER`, `BOARD_CPU`), the U-Boot build target (`UBOOT_PACKAGE` + `UBOOT_RULES_TARGET`),
`COMPATIBLE_SUITES`/`COMPATIBLE_FLAVORS` arrays, and up to two hook functions:

- `config_image_hook__<board>(rootfs, overlay, suite)` — runs **inside `config-image.sh`** with the chroot
  mounted, after kernel/u-boot are installed. `chroot ... apt-get install`s board firmware (panfork Mesa,
  libmali, camera-engine), copies files from `overlay/`, and `systemctl enable`s board services
  (e.g. wifi/bt reload units). **This is where board-specific runtime setup goes.**
- `build_image_hook__<board>(writable)` — runs in `build-image.sh` after the rootfs is on the image and right
  *before* `u-boot-update`, with `$1` = the mounted writable root. **Use this for anything touching the final
  on-disk image** (dtbs, dtbo overlays via `U_BOOT_FDT_OVERLAYS` in `/etc/default/u-boot`, extlinux/bootloader).

To **add a board**: create `config/boards/<board>.sh` with the metadata + `UBOOT_PACKAGE`/`UBOOT_RULES_TARGET`
+ compatible suites/flavors + hook(s). Put firmware/drivers in the hook, never in the (board-agnostic) rootfs.

`UBOOT_PACKAGE` points at one of `packages/u-boot-*` (currently `u-boot-radxa-rk3588`, `u-boot-mixtile-rk3588`,
`u-boot-turing-rk3588`, `u-boot-rk3576`) — a Debian `debian/` overlay (`rules`, `targets.mk`, `upstream`
pinning a git commit/branch, `patches/`, `rkbin/` blobs) grafted onto upstream U-Boot. `UBOOT_RULES_TARGET`
selects which board target inside that tree to build.

### overlay/

Static files the hooks copy into images: cloud-init seed (`boot/firmware/{meta-data,user-data,network-config}`),
plus WiFi/BT bring-up helpers and systemd units (AP6256/AP6275P/AP6611S/RTL8852BE/RTL8821CS/AIC8800/…),
`alsa-audio-config`, `enable-usb2`, and BT firmware loaders. Files here are **not** installed automatically —
a board's `config_image_hook__` must explicitly `cp` them in and enable the service.

## CI (`.github/workflows/`)

- `build.yml` — manual (`workflow_dispatch`); the reference pipeline. **Dispatch this to verify a change**
  (`gh workflow run build.yml`).
- `nightly.yml`, `release.yml` — generate their board/suite/flavor matrix dynamically by sourcing
  every `config/*` file, so they self-trim to whatever configs exist (`release.yml` uses `--launchpad`).
- `conventional-commits.yml` — validates that every PR **title** follows Conventional Commits (squash merges
  turn the PR title into the commit on `main`). Allowed types: `feat fix build chore ci docs perf refactor
  revert style test`.
- `stale.yml` — issue/PR housekeeping.

The `apt-get install …` block in the workflows is the authoritative host-build-dependency set.

## Conventions / gotchas

- The env var is misspelled **`RELASE_VERSION`** / `RELASE_NAME` (no second "E") throughout — match the existing
  spelling; do **not** "fix" it or you break every script that reads it.
- Commits and PR titles must be **Conventional Commits** (enforced on PR titles by CI; see above).
- Scripts assume a re-entrant `build/`: each stage guards work with `find … | tail -n1` existence checks and
  skips recompiling if the artifact exists. To force a rebuild of one stage, delete its `build/` artifact or `--clean`.
- Kernel, U-Boot and the GPU/multimedia stack are pinned to upstream-maintained sources
  (`Joshua-Riek/linux-rockchip`, `Joshua-Riek/livecd-rootfs`, and the `jjriek` Launchpad PPAs — panfork Mesa,
  libmali, camera-engine, pinned at priority 1001 for jammy/noble in `build-rootfs.sh`).
- U-Boot `rkbin/*.bin|*.elf` blobs are committed directly; any `git lfs` steps in CI are no-ops here.
- `.work/` is local scratch (gitignored) — fork-analysis artifacts and reports, not part of the build.
