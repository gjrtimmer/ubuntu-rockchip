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
sudo ./build.sh --board=orangepi-5-plus --suite=noble --flavor=server --base-only # -> build/base/*.base.tar.xz (RK3588 only; needs kernel+rootfs present)

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
config/suites/<suite>.sh    ─┐  (RELEASE_VERSION, KERNEL_REPO/BRANCH, EXTRA_PPAS)
config/flavors/<flavor>.sh  ─┼─ sourced into env by build.sh / each script
config/boards/<board>.sh    ─┘  (UBOOT_PACKAGE, UBOOT_RULES_TARGET, COMPATIBLE_*, hooks)
config/bases/<group>.sh        (BASE_SOCS, BASE_SUITES/FLAVORS, config_base_hook__<group> — shared SoC firmware layer)
        │
        ▼
scripts/build-kernel.sh   clones Joshua-Riek/linux-rockchip @ KERNEL_BRANCH (vendor 6.1), builds linux-*.deb
scripts/build-u-boot.sh   grafts our packages/u-boot-*/debian onto upstream U-Boot, builds u-boot-<board>_*.deb
scripts/build-rootfs.sh   builds a <suite>/<flavor> rootfs via Ubuntu live-build (Joshua-Riek/livecd-rootfs)  [BOARD-AGNOSTIC]
scripts/build-base.sh     [RK3588 only] extracts rootfs, installs kernel + shared GPU firmware + initramfs, repacks -> build/base/*.base.tar.xz  [per suite x flavor]
scripts/config-image.sh   extracts the base (if present) else the rootfs, chroots in, installs u-boot (+ kernel only when NOT from base), runs config_image_hook__<board>, repacks
scripts/build-image.sh    partitions a loopback image, lays down rootfs, dd's u-boot to raw disk, runs build_image_hook__<board>, compresses -> images/*.img.xz
```

**Key invariant (inherited from upstream): the rootfs is board-independent.** Everything board-specific happens
in `config-image.sh` (software/firmware via the chroot hook) and `build-image.sh` (partition layout + bootloader).

**Configured-base tier (RK3588 family).** All 28 RK3588/RK3588S/RK3588S2 boards install an identical shared
firmware layer (panfork-mesa PPA + `mali-g610-firmware` + `libmali-g610-x11` + `camera-engine-rkaiq-rk3588`).
`build-base.sh` bakes that layer **once per suite × flavor** into `build/base/*.base.tar.xz` — kernel installed,
GPU stack installed (incl. `linux-headers-<ver>`, so board-hook DKMS modules build against the rockchip kernel
instead of the host's `uname -r`), and initramfs built. `config-image.sh` auto-detects `build/base/*.base.tar.xz`
and starts from it instead of the raw rootfs, **skipping** the per-board kernel install + initramfs; the board
hook's GPU `apt-get install`s then run as fast no-ops. The base group is derived from `BOARD_SOC` via
`resolve_base_group` (`scripts/lib/base.sh`); boards with no group (RK3566/RK3576) build straight from the rootfs
as before. The devtmpfs-safe mount/teardown helpers are shared via `scripts/lib/chroot.sh`. Net: median
board-build time ~25m → ~15m (the remaining time is the per-board xz compression floor, which the base can't cut).

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
- Job graph: `config → {rootfs, kernel, uboot} → base → build`. The `base` job builds the RK3588
  configured-base once per suite×flavor (persistent S3 cache `cache/base/...` + per-run handoff
  `ci/<run>/base/<group>/<suite>-<flavor>`); the `build` job pulls it for RK3588 boards (`build/base/`) and
  skips it for others. The `build` matrix sets `fail-fast: false` so one board failure doesn't cancel the rest.
- `conventional-commits.yml` — validates that every PR **title** follows Conventional Commits (squash merges
  turn the PR title into the commit on `main`). Allowed types: `feat fix build chore ci docs perf refactor
  revert style test`.
- `stale.yml` — issue/PR housekeeping.

The `apt-get install …` block in the workflows is the authoritative host-build-dependency set.

## Conventions / gotchas

- **NEVER delete anything from the MinIO `rockchip` bucket** (mc alias `can`, `s3.timmertech.io`). It holds the
  only copies of published images, manifests, and build caches. Do **not** run `mc rm`, `mc rb`, `mc mv`, or any
  destructive mc operation against it — `mc rm`/`mc rb` are denied in `.claude/settings.json`. Read-only analysis
  only (`mc ls`, `mc du`, `mc stat`). Current-version pruning is owned solely by the dedicated CI steps
  (`ci-s3.sh prune` / `prune-month` in `cleanup.yml`, every 12h) — never delete by hand. The bucket has
  **versioning enabled**; noncurrent versions self-purge **server-side** via ILM lifecycle rules
  (`scripts/s3-ilm-setup.sh`, applied by the `s3-lifecycle.yml` manual workflow): 1 day for the non-synced
  prefixes (`build/ cache/ ci/ rootfs/`), 365 days for the synced ones (`releases/ images/`, mirrored to NL).
- Final images are **`.img.xz`** (never `.zst` — balenaEtcher cannot read zstd). Compression is `xz -3 -T0`
  in `build-image.sh` — tuned for build speed over ratio; `-T0` already saturates all cores, so the preset is
  the only lever.
- **Never `apt upgrade` / `dist-upgrade` for currency in the pipeline.** Images ship the pinned monthly rootfs
  snapshot; upgrading is the end-user's job post-install. (The panfork `dist-upgrade` in the base/board hook is a
  mesa→panfork firmware swap, not a currency upgrade — that one stays.)
- The release env vars are **`RELEASE_VERSION`** / `RELEASE_NAME` (defined in `config/suites/*.sh`). Upstream
  `Joshua-Riek/ubuntu-rockchip` spells these `RELASE_*` (no second "E"); this fork corrected them (#70), so expect
  merge conflicts on these lines when syncing upstream — keep the corrected spelling.
- Commits and PR titles must be **Conventional Commits** (enforced on PR titles by CI; see above).
- Scripts assume a re-entrant `build/`: each stage guards work with `find … | tail -n1` existence checks and
  skips recompiling if the artifact exists. To force a rebuild of one stage, delete its `build/` artifact or `--clean`.
- Kernel, U-Boot and the GPU/multimedia stack are pinned to upstream-maintained sources
  (`Joshua-Riek/linux-rockchip`, `Joshua-Riek/livecd-rootfs`, and the `jjriek` Launchpad PPAs — panfork Mesa,
  libmali, camera-engine, pinned at priority 1001 for jammy/noble in `build-rootfs.sh`).
- U-Boot `rkbin/*.bin|*.elf` blobs are committed directly; any `git lfs` steps in CI are no-ops here.
- `.work/` is local scratch (gitignored) — fork-analysis artifacts and reports, not part of the build.
