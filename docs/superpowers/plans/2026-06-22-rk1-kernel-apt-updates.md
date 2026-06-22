# Ubuntu-Style Kernel Updates via Signed APT Repo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let already-running Rockchip nodes (RK1 / Turing Pi) upgrade their kernel with `apt upgrade` + reboot — co-installable ABI-versioned kernels, a meta-package that tracks the latest, old kernel kept for rollback — exactly like stock Ubuntu on x86, instead of reflashing.

**Architecture:** `Joshua-Riek/linux-rockchip` already builds Ubuntu kernel packaging (ABI-versioned `linux-image-6.1.0-NNNN-rockchip`; boot via `u-boot-update`/extlinux which enumerates every installed kernel = the `update-grub` equivalent). Three gaps remain: (1) no meta-package to track "latest", (2) no hosting channel, (3) shipped kernel is `apt-mark hold`'d. We add a `packages/linux-meta-rockchip/` source, a `packages/rockchip-archive-keyring/` source (the one-`dpkg`-install bootstrap), publish them + the kernel debs to a **new GPG-signed APT repo on the existing MinIO**, bake the (pinned, opt-in) channel into images, and ship a fleet-enable script for the existing RK1 nodes.

**Serving:** MinIO direct — an apt repo is just static files (`dists/` + `pool/`) and MinIO is an S3-compatible HTTPS server; `deb-s3` writes the layout and apt fetches exact paths from the signed `Release` (no directory listing needed). **No nginx, no package-registry daemon** — they would only add a vanity host / edge cache, unnecessary at this fleet size and addable later without changing the repo layout.

**Dual-mirror with fallback:** hosted on **two** MinIO instances — `s3.timmertech.nl` (NL, fast — nodes hit it first) and `s3.timmertech.io` (CAN, the authoritative origin-of-truth / backup). `deb-s3` publishes to **CAN only**; CI then `mc mirror`s the tree byte-for-byte to NL, so both serve the *identical signed `Release`*. The GPG signature is over `Release` *content*, not URL, so one key covers both mirrors. Clients list both URLs in one deb822 `URIs:` stanza (NL first); apt falls back to CAN automatically if NL is unreachable. **Never run `deb-s3` independently against both** — each run stamps a different `Release` `Date:`, which breaks apt's hashsum check on fallback.

**Tech Stack:** Bash, Debian packaging (debhelper 13, native source format), `deb-s3` (Ruby gem) → MinIO/S3, `mc mirror`, GPG-signed `Release`, GitHub Actions (`workflow_dispatch`), apt deb822 sources + apt pinning, an `*-archive-keyring` bootstrap deb.

## Global Constraints

Copied verbatim from CLAUDE.md / repo conventions — every task implicitly inherits these:

- **NEVER** run any destructive `mc` op (`mc rm`/`rb`/`mv`) against the MinIO `rockchip` bucket — read-only only. The new repo lives in a **separate `apt` bucket** on each mirror; never touch `rockchip`. `mc mirror` is scoped to `.../apt` paths only.
- The env var is misspelled **`RELASE_VERSION`** / `RELASE_NAME` (no second "E") throughout. **Do NOT "fix" it** — it is a load-bearing convention across every script; renaming breaks the build and is out of scope for this feature.
- Final node-facing kernel images stay co-installable; **never** overwrite-in-place.
- **Never `apt upgrade`/`dist-upgrade` for currency inside the build pipeline.** Images ship the pinned monthly snapshot; upgrading is the end-user's job. This feature is the *end-user upgrade channel* — it does not change build-time currency.
- Commits + PR titles are **Conventional Commits** (`feat fix build chore ci docs perf refactor revert style test`). CI validates PR titles.
- The rootfs is **board-agnostic**. The kernel APT channel is common to all boards → it goes in the common section of `config-image.sh`, **not** a board hook.
- No PII in committed files: maintainer identity is the generic `Ubuntu Rockchip CI <ci@timmertech.io>`, never a personal address.
- Verification cannot run locally (build needs arm64 + root). Local gates = `shellcheck` + deb inspection; full gates = CI `workflow_dispatch` + a canary node.

## Security (read before Task 1)

The signing key is the trust root for every node's kernel. Compromise = arbitrary-root on the whole fleet.

- Private signing key lives **only** in GitHub Actions secrets (`APT_GPG_PRIVATE_KEY`, `APT_GPG_PASSPHRASE`). Never committed, never written to a bucket, never printed in logs.
- The **public** key is committed (`packages/rockchip-archive-keyring/rockchip-archive-keyring.asc`) — public by nature — and also published to both buckets for direct bootstrap.
- The `Release` file is GPG-signed (`deb-s3 --sign`); clients pin the key with `Signed-By` (no unauthenticated `apt-key`).
- Both mirrors served over **HTTPS** only.
- Use a **dedicated** signing subkey for this repo, not a personal GPG identity. Rotate before the 2y expiry by committing a new public key + bumping the keyring deb version.

## File Structure

| Path | Responsibility | New? |
| --- | --- | --- |
| `packages/linux-meta-rockchip/debian/control.in` | Meta-package definitions with `@ABI@` placeholder | Create |
| `packages/linux-meta-rockchip/debian/rules` | Trivial `dh` rules (arch:arm64, no build) | Create |
| `packages/linux-meta-rockchip/debian/source/format` | `3.0 (native)` | Create |
| `packages/linux-meta-rockchip/gen-and-build.sh` | Stamp ABI from built kernel → build meta debs into `build/` | Create |
| `packages/rockchip-archive-keyring/debian/control` | Keyring/source bootstrap package (arch:all) | Create |
| `packages/rockchip-archive-keyring/debian/rules` | Dearmor committed pubkey into `/usr/share/keyrings` | Create |
| `packages/rockchip-archive-keyring/debian/postinst` | Write `.sources` (multi-URI) from `/etc/os-release` suite | Create |
| `packages/rockchip-archive-keyring/debian/postrm` | Remove the `.sources` on remove/purge | Create |
| `packages/rockchip-archive-keyring/debian/{changelog,source/format}` | Native pkg, manually-bumped version | Create |
| `packages/rockchip-archive-keyring/rockchip-archive-keyring.asc` | Committed **public** signing key | Create |
| `packages/rockchip-archive-keyring/build.sh` | Build the keyring deb into `build/` (idempotent) | Create |
| `scripts/build-kernel.sh` | Call the meta builder after the kernel build | Modify |
| `.github/workflows/apt-publish.yml` | Build kernel+meta+keyring, GPG-sign, `deb-s3`→CAN, `mc mirror`→NL | Create |
| `scripts/config-image.sh` | Build+install keyring deb, write pin=100, drop kernel `hold` (common section) | Modify |
| `scripts/enable-kernel-updates.sh` | Fleet one-shot: download keyring deb, pin=500, unhold, install meta | Create |
| `docs/kernel-updates.md` | End-user + operator runbook (bootstrap, rollback, keep-N, BMC recovery, canary) | Create |

---

### Task 1: Provision the signed APT repo + signing key (one-time bootstrap)

Manual operator setup, run once on a trusted workstation with `mc` + `gpg`. Produces: the `apt` bucket on **both** mirrors, a signing keypair, the GitHub secrets/vars, the published public key, and the committed public key for the keyring deb.

**Files:** none committed here except the public key in Task 3 (`rockchip-archive-keyring.asc`).

**Interfaces:**
- Produces: bucket `apt` (public-read) on both mirrors; `https://s3.timmertech.{nl,io}/apt/rockchip-archive-keyring.asc`; GH secrets `APT_GPG_PRIVATE_KEY`, `APT_GPG_PASSPHRASE`, `APT_S3_ACCESS_KEY`/`APT_S3_SECRET_KEY` (CAN), `APT_NL_ACCESS_KEY`/`APT_NL_SECRET_KEY` (NL); GH var `APT_GPG_KEY_ID`. Consumed by Tasks 3/5/6.

- [ ] **Step 1: Create the dedicated signing key (non-personal identity)**

```bash
cat > /tmp/keyparams <<'EOF'
%no-protection
Key-Type: eddsa
Key-Curve: ed25519
Subkey-Type: ecdh
Subkey-Curve: cv25519
Name-Real: Ubuntu Rockchip Kernel Archive
Name-Email: ci@timmertech.io
Expire-Date: 2y
EOF
gpg --batch --gen-key /tmp/keyparams
shred -u /tmp/keyparams
KEYID=$(gpg --list-keys --with-colons ci@timmertech.io | awk -F: '/^pub:/{print $5; exit}')
echo "APT_GPG_KEY_ID=$KEYID"
```

Expected: a 16-hex-char key ID printed. Record it.

- [ ] **Step 2: Configure the NL alias and create the `apt` bucket on BOTH mirrors (NOT `rockchip`)**

```bash
# `can` (s3.timmertech.io) is the existing origin-of-truth alias. Add `nld` (s3.timmertech.nl).
mc alias set nld https://s3.timmertech.nl "$NL_ACCESS_KEY" "$NL_SECRET_KEY"
for a in can nld; do
  mc mb "$a/apt"
  mc anonymous set download "$a/apt"     # read-only public; uploads still need creds
  mc ls "$a/apt"                          # expect: empty
done
```

Expected: both buckets created + empty. (Never target `*/rockchip`.)

- [ ] **Step 3: Publish the public key to BOTH mirrors**

```bash
gpg --armor --export "$KEYID" > /tmp/rockchip-archive-keyring.asc
mc cp /tmp/rockchip-archive-keyring.asc can/apt/rockchip-archive-keyring.asc
mc cp /tmp/rockchip-archive-keyring.asc nld/apt/rockchip-archive-keyring.asc
for h in s3.timmertech.nl s3.timmertech.io; do
  curl -fsSL "https://$h/apt/rockchip-archive-keyring.asc" | gpg --show-keys
done
```

Expected: both hosts return the same key ID. Keep `/tmp/rockchip-archive-keyring.asc` for Task 3 (commit it).

- [ ] **Step 4: Store secrets/vars in GitHub**

```bash
gpg --armor --export-secret-keys "$KEYID" | gh secret set APT_GPG_PRIVATE_KEY
gh secret set APT_GPG_PASSPHRASE        # empty here (key has %no-protection); set if you add one
gh secret set APT_S3_ACCESS_KEY         # CAN (s3.timmertech.io) write key, apt bucket only
gh secret set APT_S3_SECRET_KEY
gh secret set APT_NL_ACCESS_KEY         # NL (s3.timmertech.nl) write key, apt bucket only
gh secret set APT_NL_SECRET_KEY
gh variable set APT_GPG_KEY_ID --body "$KEYID"
```

Expected: `gh secret list` shows the six secrets; `gh variable list` shows `APT_GPG_KEY_ID`.

- [ ] **Step 5: Remove the private key from the workstation keyring**

```bash
gpg --batch --yes --delete-secret-keys "$KEYID"
```

Expected: `gpg --list-secret-keys ci@timmertech.io` → no result. (Private key now exists only in the GH secret.)

> No commit in this task. Record the key ID for Tasks 3 + 8.

---

### Task 2: Create the `linux-meta-rockchip` source package

The meta-package is the heart of "like Ubuntu does it": `linux-image-rockchip` `Depends:` the current ABI package, so `apt upgrade` pulls a new ABI kernel while leaving the old one installed.

**Files:**
- Create: `packages/linux-meta-rockchip/debian/control.in`
- Create: `packages/linux-meta-rockchip/debian/rules`
- Create: `packages/linux-meta-rockchip/debian/source/format`
- Create: `packages/linux-meta-rockchip/gen-and-build.sh`

**Interfaces:**
- Consumes: a built `linux-image-*-rockchip_*.deb` in a build dir.
- Produces: `linux-image-rockchip_<ver>_arm64.deb`, `linux-headers-rockchip_<ver>_arm64.deb`, `linux-rockchip_<ver>_arm64.deb` in the build dir. Entry point: `gen-and-build.sh <BUILD_DIR>` (called by Task 4).

- [ ] **Step 1: Write `debian/source/format`**

```
3.0 (native)
```

- [ ] **Step 2: Write `debian/rules` (make executable)**

```makefile
#!/usr/bin/make -f
%:
	dh $@
```

- [ ] **Step 3: Write `debian/control.in`** (the `@ABI@` placeholder is filled per-build)

```
Source: linux-meta-rockchip
Section: kernel
Priority: optional
Maintainer: Ubuntu Rockchip CI <ci@timmertech.io>
Build-Depends: debhelper-compat (= 13)
Standards-Version: 4.6.2

Package: linux-image-rockchip
Architecture: arm64
Depends: ${misc:Depends}, linux-image-@ABI@
Description: Rockchip kernel image metapackage
 This metapackage always depends on the latest Rockchip kernel image.
 Upgrading it pulls a newer kernel while leaving the previous one installed,
 so a known-good kernel remains available for rollback.

Package: linux-headers-rockchip
Architecture: arm64
Depends: ${misc:Depends}, linux-headers-@ABI@
Description: Rockchip kernel headers metapackage
 Pulls the headers matching the latest Rockchip kernel so that DKMS modules
 (GPU, Wi-Fi) rebuild against the running kernel on upgrade.

Package: linux-rockchip
Architecture: arm64
Depends: ${misc:Depends},
 linux-image-rockchip (= ${binary:Version}),
 linux-headers-rockchip (= ${binary:Version})
Description: Rockchip kernel metapackage (image + headers)
 Convenience metapackage pulling both the image and headers metapackages.
 Install this on a node to track the latest Rockchip kernel via apt.
```

- [ ] **Step 4: Write `gen-and-build.sh` (make executable)**

```bash
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

sed "s/@ABI@/${abi}/g" debian/control.in > debian/control

cat > debian/changelog <<EOF
linux-meta-rockchip (${kver}) ${SUITE:-noble}; urgency=medium

  * Metapackages tracking Rockchip kernel ${abi}.

 -- Ubuntu Rockchip CI <ci@timmertech.io>  $(date -R)
EOF

dpkg-buildpackage -b -us -uc
mv ../linux-image-rockchip_*.deb ../linux-headers-rockchip_*.deb ../linux-rockchip_*.deb "${BUILD_DIR}/"
echo "Built metapackages for ${abi} -> ${BUILD_DIR}"
```

- [ ] **Step 5: Lint (local gate)** — `shellcheck packages/linux-meta-rockchip/gen-and-build.sh` → no errors (SC2086 on the `mv` globs is acceptable).

- [ ] **Step 6: Commit**

```bash
chmod +x packages/linux-meta-rockchip/debian/rules packages/linux-meta-rockchip/gen-and-build.sh
git add packages/linux-meta-rockchip
git commit -m "feat(kernel): add linux-meta-rockchip metapackages for apt kernel tracking"
```

---

### Task 3: Create the `rockchip-archive-keyring` bootstrap package

One `dpkg -i` installs the signing key + the multi-URI apt source. Once it's in the repo it self-updates, so key rotation ships as a new package version. The deb is **policy-neutral** (no pin — the pin is written by the installer). Universal `arch:all`: the `postinst` fills the suite from `/etc/os-release`, so one deb works on jammy + noble and inside the build chroot.

**Files:**
- Create: `packages/rockchip-archive-keyring/rockchip-archive-keyring.asc` (the public key from Task 1 Step 3)
- Create: `packages/rockchip-archive-keyring/debian/{control,rules,postinst,postrm,changelog,source/format}`
- Create: `packages/rockchip-archive-keyring/build.sh`

**Interfaces:**
- Consumes: the committed public key.
- Produces: `build/rockchip-archive-keyring_<ver>_all.deb`. Installs `/usr/share/keyrings/rockchip-archive-keyring.gpg` + (via postinst) `/etc/apt/sources.list.d/rockchip-kernel.sources`. Entry point: `build.sh <BUILD_DIR>` (idempotent — skips if the deb already exists). Consumed by Tasks 4/5/6.

- [ ] **Step 1: Commit the public key**

```bash
mkdir -p packages/rockchip-archive-keyring/debian/source
cp /tmp/rockchip-archive-keyring.asc packages/rockchip-archive-keyring/rockchip-archive-keyring.asc
gpg --show-keys packages/rockchip-archive-keyring/rockchip-archive-keyring.asc   # confirm key ID
```

- [ ] **Step 2: Write `debian/source/format`** → `3.0 (native)`

- [ ] **Step 3: Write `debian/control`**

```
Source: rockchip-archive-keyring
Section: misc
Priority: optional
Maintainer: Ubuntu Rockchip CI <ci@timmertech.io>
Build-Depends: debhelper-compat (= 13), gnupg
Standards-Version: 4.6.2

Package: rockchip-archive-keyring
Architecture: all
Depends: ${misc:Depends}
Description: GnuPG archive keyring and APT source for the Rockchip kernel repo
 Installs the signing key and the apt source (NL fast mirror, CAN fallback)
 for the Ubuntu Rockchip kernel archive, so apt can fetch signed kernel updates.
```

- [ ] **Step 4: Write `debian/rules`** (dearmor the committed key into the package; make executable)

```makefile
#!/usr/bin/make -f
%:
	dh $@

override_dh_install:
	install -d debian/rockchip-archive-keyring/usr/share/keyrings
	gpg --dearmor < rockchip-archive-keyring.asc \
	  > debian/rockchip-archive-keyring/usr/share/keyrings/rockchip-archive-keyring.gpg
```

- [ ] **Step 5: Write `debian/postinst`** (NL first, CAN fallback; suite from os-release; make executable)

```sh
#!/bin/sh
set -e
case "$1" in
  configure)
    . /etc/os-release
    cat > /etc/apt/sources.list.d/rockchip-kernel.sources <<EOF
Types: deb
URIs: https://s3.timmertech.nl/apt https://s3.timmertech.io/apt
Suites: ${VERSION_CODENAME}
Components: main
Architectures: arm64
Signed-By: /usr/share/keyrings/rockchip-archive-keyring.gpg
EOF
    ;;
esac
#DEBHELPER#
exit 0
```

- [ ] **Step 6: Write `debian/postrm`** (clean up on remove/purge; make executable)

```sh
#!/bin/sh
set -e
case "$1" in
  remove|purge)
    rm -f /etc/apt/sources.list.d/rockchip-kernel.sources
    ;;
esac
#DEBHELPER#
exit 0
```

- [ ] **Step 7: Write `debian/changelog`** (manual version — bump only on key/source change)

```
rockchip-archive-keyring (1.0) noble; urgency=medium

  * Initial keyring + apt source for the Rockchip kernel repo (NL + CAN mirrors).

 -- Ubuntu Rockchip CI <ci@timmertech.io>  Mon, 22 Jun 2026 00:00:00 +0000
```

- [ ] **Step 8: Write `build.sh`** (idempotent; make executable)

```bash
#!/bin/bash
# Build the rockchip-archive-keyring deb into BUILD_DIR (skip if it already exists).
# Usage: build.sh <BUILD_DIR>
set -eEo pipefail
trap 'echo "Error: in $0 on line $LINENO"' ERR

cd "$(dirname -- "$(readlink -f -- "$0")")"
BUILD_DIR="$(readlink -f -- "${1:?usage: build.sh <BUILD_DIR>}")"

if find "${BUILD_DIR}" -maxdepth 1 -name 'rockchip-archive-keyring_*_all.deb' | grep -q .; then
    echo "keyring deb already present in ${BUILD_DIR}; skipping"
    exit 0
fi

dpkg-buildpackage -b -us -uc
mv ../rockchip-archive-keyring_*_all.deb "${BUILD_DIR}/"
echo "Built rockchip-archive-keyring -> ${BUILD_DIR}"
```

- [ ] **Step 9: Lint (local gate)** — `shellcheck packages/rockchip-archive-keyring/build.sh` → no errors.

- [ ] **Step 10: Commit**

```bash
chmod +x packages/rockchip-archive-keyring/debian/{rules,postinst,postrm} packages/rockchip-archive-keyring/build.sh
git add packages/rockchip-archive-keyring
git commit -m "feat(apt): add rockchip-archive-keyring bootstrap package (key + multi-mirror source)"
```

---

### Task 4: Build the metapackages from `build-kernel.sh`

**Files:**
- Modify: `scripts/build-kernel.sh:39` (append a meta-build step after the kernel build)

**Interfaces:**
- Consumes: `gen-and-build.sh <BUILD_DIR>` (Task 2).
- Produces: meta debs alongside the kernel debs in `build/`.

- [ ] **Step 1: Append the meta build after the `fakeroot debian/rules ...` line** at [scripts/build-kernel.sh:39](../../scripts/build-kernel.sh#L39)

```bash

# Build the Ubuntu-style kernel metapackages (linux-image-rockchip etc.) so nodes can
# track the latest ABI via apt and keep the prior kernel installed for rollback.
# Kernel .debs land in build/ (the parent of this kernel source tree).
cd ..
../packages/linux-meta-rockchip/gen-and-build.sh "$(pwd)"
```

(After `cd linux-rockchip` at line 29 the cwd is `build/linux-rockchip`; `cd ..` returns to `build/`, where the kernel debs were emitted.)

- [ ] **Step 2: Lint (local gate)** — `shellcheck scripts/build-kernel.sh` → no new errors.

- [ ] **Step 3: Commit**

```bash
git add scripts/build-kernel.sh
git commit -m "build(kernel): build linux-meta-rockchip after the kernel"
```

- [ ] **Step 4: Full gate — dispatch a kernel build and confirm the meta debs exist**

```bash
gh workflow run build.yml -f suite=noble --ref "$(git branch --show-current)"
gh run watch "$(gh run list --workflow=build.yml --limit=1 --json databaseId -q '.[0].databaseId')"
```

Expected: log shows `Built metapackages for 6.1.0-NNNN-rockchip`; artifacts include `linux-image-rockchip_*.deb`, `linux-headers-rockchip_*.deb`, `linux-rockchip_*.deb`.

---

### Task 5: CI workflow — build, sign, publish to CAN, mirror to NL

**Files:**
- Create: `.github/workflows/apt-publish.yml`

**Interfaces:**
- Consumes: Task 1 secrets/vars; meta debs (Tasks 2/4); keyring `build.sh` (Task 3).
- Produces: a signed repo on CAN at `https://s3.timmertech.io/apt`, mirrored byte-identical to NL at `https://s3.timmertech.nl/apt`, plus a stable-named `…/apt/rockchip-archive-keyring.deb` on both for bootstrap.

- [ ] **Step 1: Write the workflow**

```yaml
name: apt-publish
on:
  workflow_dispatch:
    inputs:
      suite:
        description: Ubuntu suite to build + publish
        type: choice
        options: [jammy, noble]
        default: noble

jobs:
  publish:
    runs-on: [self-hosted, linux, arm64]   # arm64 required to build the kernel natively
    steps:
      - uses: actions/checkout@v4

      - name: Install host build deps, deb-s3, mc
        run: |
          sudo apt-get update
          # NOTE: keep this list in sync with the authoritative apt-get block in build.yml.
          sudo apt-get install -y build-essential gcc-aarch64-linux-gnu bison \
            qemu-user-static qemu-system-arm qemu-efi u-boot-tools binfmt-support \
            debootstrap flex libssl-dev bc rsync kmod cpio xz-utils fakeroot parted \
            udev dosfstools uuid-runtime git-lfs device-tree-compiler python3 \
            python3-pyelftools python3-setuptools gpg gnupg ruby ruby-dev
          sudo gem install deb-s3 --no-document
          sudo curl -fsSL https://dl.min.io/client/mc/release/linux-arm64/mc -o /usr/local/bin/mc
          sudo chmod +x /usr/local/bin/mc

      - name: Build kernel + metapackages
        run: sudo ./build.sh --suite=${{ inputs.suite }} --kernel-only

      - name: Build keyring bootstrap deb
        run: sudo ./packages/rockchip-archive-keyring/build.sh "$PWD/build"

      - name: Import GPG signing key
        env:
          APT_GPG_PRIVATE_KEY: ${{ secrets.APT_GPG_PRIVATE_KEY }}
        run: echo "$APT_GPG_PRIVATE_KEY" | gpg --batch --import

      - name: Publish to CAN (origin-of-truth)
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.APT_S3_ACCESS_KEY }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.APT_S3_SECRET_KEY }}
          APT_GPG_KEY_ID: ${{ vars.APT_GPG_KEY_ID }}
          APT_GPG_PASSPHRASE: ${{ secrets.APT_GPG_PASSPHRASE }}
        run: |
          deb-s3 upload \
            --bucket apt \
            --endpoint https://s3.timmertech.io \
            --s3-region us-east-1 \
            --force-path-style \
            --codename ${{ inputs.suite }} \
            --component main \
            --arch arm64 \
            --preserve-versions \
            --sign "$APT_GPG_KEY_ID" \
            --gpg-options "--batch --pinentry-mode loopback --passphrase '$APT_GPG_PASSPHRASE'" \
            build/linux-image-*-rockchip_*.deb \
            build/linux-modules-*-rockchip_*.deb \
            build/linux-headers-*-rockchip_*.deb \
            build/linux-rockchip-headers-*.deb \
            build/linux-image-rockchip_*.deb \
            build/linux-headers-rockchip_*.deb \
            build/linux-rockchip_*.deb \
            build/rockchip-archive-keyring_*_all.deb

      - name: Mirror CAN -> NL (byte-identical signed tree; do NOT re-run deb-s3 against NL)
        env:
          MC_HOST_can: https://${{ secrets.APT_S3_ACCESS_KEY }}:${{ secrets.APT_S3_SECRET_KEY }}@s3.timmertech.io
          MC_HOST_nld: https://${{ secrets.APT_NL_ACCESS_KEY }}:${{ secrets.APT_NL_SECRET_KEY }}@s3.timmertech.nl
        run: mc mirror --overwrite --quiet can/apt nld/apt

      - name: Publish stable-named keyring deb for bootstrap (both mirrors)
        env:
          MC_HOST_can: https://${{ secrets.APT_S3_ACCESS_KEY }}:${{ secrets.APT_S3_SECRET_KEY }}@s3.timmertech.io
          MC_HOST_nld: https://${{ secrets.APT_NL_ACCESS_KEY }}:${{ secrets.APT_NL_SECRET_KEY }}@s3.timmertech.nl
        run: |
          deb=$(ls build/rockchip-archive-keyring_*_all.deb | sort -V | tail -n1)
          mc cp "$deb" can/apt/rockchip-archive-keyring.deb
          mc cp "$deb" nld/apt/rockchip-archive-keyring.deb
```

`--preserve-versions` keeps older ABI debs in the pool (required for rollback + co-install). `--force-path-style` is needed for MinIO; if `deb-s3` rejects it, fall back to a virtual-host CNAME and drop the flag. `mc mirror --overwrite` (no `--remove`) makes NL a superset replica — never deletes — and is scoped to `apt` only.

- [ ] **Step 2: Validate the workflow YAML (local gate)** — `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/apt-publish.yml'))"` → no output.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/apt-publish.yml
git commit -m "ci(apt): publish kernel + metapackages to signed CAN repo, mirror to NL"
```

- [ ] **Step 4: Full gate — dispatch and verify both mirrors are signed + identical**

```bash
gh workflow run apt-publish.yml -f suite=noble --ref "$(git branch --show-current)"
gh run watch "$(gh run list --workflow=apt-publish.yml --limit=1 --json databaseId -q '.[0].databaseId')"
# After success:
curl -fsSI https://s3.timmertech.io/apt/dists/noble/Release.gpg     # 200 (signed)
diff <(curl -fsSL https://s3.timmertech.nl/apt/dists/noble/Release) \
     <(curl -fsSL https://s3.timmertech.io/apt/dists/noble/Release) && echo IDENTICAL
curl -fsSI https://s3.timmertech.nl/apt/rockchip-archive-keyring.deb # 200
```

Expected: `Release.gpg` exists; NL and CAN `Release` are byte-identical (`IDENTICAL`); the bootstrap deb is downloadable from NL.

---

### Task 6: Bake the (pinned, opt-in) channel into images

Images keep shipping the pinned monthly kernel snapshot (no build-time currency). We install the keyring deb (key + source), **pin to priority 100** so `apt upgrade` will NOT auto-pull a kernel (critical for unattended headless nodes), and **drop the `apt-mark hold`** so a deliberate `apt install linux-rockchip` works. The meta is NOT installed by default — opting into tracking is the node owner's action (Task 7).

**Files:**
- Modify: `scripts/config-image.sh` (common section, after the kernel install / before initramfs)

**Interfaces:**
- Consumes: `packages/rockchip-archive-keyring/build.sh` (Task 3); `${SUITE}` (already sourced).
- Produces: an image with the keyring deb installed + a priority-100 pin.

- [ ] **Step 1: Build + install the keyring deb and write the pin; drop the kernel hold**

In [scripts/config-image.sh](../../scripts/config-image.sh), in the non-launchpad `FROM_BASE != "Y"` kernel block, **remove** the four kernel `apt-mark hold` lines ([config-image.sh:168-171](../../scripts/config-image.sh#L168-L171)) — the pin now governs upgrade behavior, and the hold would block the deliberate opt-in upgrade. Leave the u-boot hold at line 160 untouched.

Then, just before the initramfs step ([config-image.sh:177](../../scripts/config-image.sh#L177)), add (board-agnostic — every image):

```bash
# Install the Rockchip kernel APT channel via the keyring bootstrap deb (key + multi-mirror
# source), then pin it to 100 so it is available but never auto-upgraded on headless nodes.
# The node owner opts into tracking via scripts/enable-kernel-updates.sh. Board-agnostic.
../packages/rockchip-archive-keyring/build.sh "$(pwd)"
keyring_deb="$(basename "$(find rockchip-archive-keyring_*_all.deb | sort -V | tail -n1)")"
cp "${keyring_deb}" "${chroot_dir}/tmp/"
chroot "${chroot_dir}" dpkg -i "/tmp/${keyring_deb}"
cat > "${chroot_dir}/etc/apt/preferences.d/rockchip-kernel.pref" <<EOF
Package: *
Pin: origin "s3.timmertech.nl"
Pin-Priority: 100

Package: *
Pin: origin "s3.timmertech.io"
Pin-Priority: 100
EOF
```

(`build.sh` is idempotent and `cwd` here is `build/`, so the keyring deb is reused if a prior stage built it.)

- [ ] **Step 2: Lint (local gate)** — `shellcheck scripts/config-image.sh` → no new errors.

- [ ] **Step 3: Commit**

```bash
git add scripts/config-image.sh
git commit -m "feat(image): install rockchip-archive-keyring, pin kernel repo to 100, drop kernel hold"
```

- [ ] **Step 4: Full gate — build one image and inspect the channel**

```bash
gh workflow run build.yml -f board=turing-rk1 -f suite=noble -f flavor=server --ref "$(git branch --show-current)"
```

On the built image (boot or loop-mount):

```bash
apt-cache policy linux-rockchip                  # candidate from s3.timmertech.{nl,io}, priority 100
apt-mark showhold | grep -c '^linux-'            # expect 0
cat /etc/apt/sources.list.d/rockchip-kernel.sources   # multi-URI, suite matches image
```

Expected: channel present (both URIs), kernel not held, priority 100 → `apt upgrade` is a kernel no-op.

---

### Task 7: Fleet-enable script for the existing RK1 nodes

Flips an already-flashed node from "pinned, not tracking" to "tracks latest kernel". Bootstrap = download the keyring deb directly (NL, fall back to CAN), `dpkg -i`, then pin=500 + install meta. After the first install the keyring updates itself via apt.

**Files:**
- Create: `scripts/enable-kernel-updates.sh`

**Interfaces:**
- Consumes: the published bootstrap deb + repo (Tasks 1/5).
- Produces: a node tracking `linux-rockchip`.

- [ ] **Step 1: Write the script (make executable)**

```bash
#!/bin/bash
# Enable Ubuntu-style kernel updates on an already-running Rockchip node.
# Run as root ON THE NODE. Idempotent. Reboot afterwards to use the new kernel.
set -euo pipefail

[ "$(id -u)" -eq 0 ] || { echo "run as root"; exit 1; }

# Bootstrap: download the keyring deb (NL fast, CAN fallback) and install it.
# It drops the signing key + the apt source; afterwards it updates itself via apt.
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
curl -fsSL https://s3.timmertech.nl/apt/rockchip-archive-keyring.deb -o "$tmp/k.deb" \
  || curl -fsSL https://s3.timmertech.io/apt/rockchip-archive-keyring.deb -o "$tmp/k.deb"
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
[ -z "${held}" ] || apt-mark unhold ${held}

apt-get update
apt-get install -y linux-rockchip   # meta: tracks latest ABI, keeps prior kernel for rollback

echo
echo "Done. Current: $(uname -r). Installed kernels:"
dpkg --list 'linux-image-*-rockchip' | awk '/^ii/{print "  " $2}'
echo "Reboot to boot the newest kernel. Previous kernel stays in the boot menu for rollback."
```

- [ ] **Step 2: Lint (local gate)** — `shellcheck scripts/enable-kernel-updates.sh` → no errors (the `unhold ${held}` word-split is intentional; add `# shellcheck disable=SC2086` to silence).

- [ ] **Step 3: Commit**

```bash
chmod +x scripts/enable-kernel-updates.sh
git add scripts/enable-kernel-updates.sh
git commit -m "feat(nodes): add enable-kernel-updates.sh to opt a node into apt kernel tracking"
```

- [ ] **Step 4: Full gate — canary ONE RK1 node** (operator, with BMC serial access ready)

```bash
sudo ./enable-kernel-updates.sh
uname -r                                   # note the OLD version
sudo reboot
# After reboot:
uname -r                                   # expect the NEW ABI version
dpkg --list 'linux-image-*-rockchip' | grep -c '^ii'   # expect >= 2 (old kept)
dkms status                                # GPU/Wi-Fi modules built for the new kernel
```

Expected: node boots the new kernel, old kernel still installed + in the extlinux menu, DKMS rebuilt. **Do not roll out to the other nodes until the canary survives a reboot.**

---

### Task 8: Keep-N kernels + operator runbook

**Files:**
- Create: `docs/kernel-updates.md`

- [ ] **Step 1: Write the runbook**

```markdown
# Rockchip kernel updates (apt channel)

Nodes upgrade their kernel with apt instead of reflashing. Kernels are
ABI-versioned (`linux-image-6.1.0-NNNN-rockchip`) and co-installable; the
`linux-rockchip` metapackage tracks the latest and keeps the previous one.
Repo: NL `https://s3.timmertech.nl/apt` (fast) with CAN
`https://s3.timmertech.io/apt` fallback; suite = noble | jammy, component main, arm64.

## Bootstrap a node
    sudo ./scripts/enable-kernel-updates.sh && sudo reboot
(Downloads `rockchip-archive-keyring.deb`, installs key + source, then tracks via apt.)

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
Key: https://s3.timmertech.nl/apt/rockchip-archive-keyring.asc  (ID: <APT_GPG_KEY_ID>)
Private key lives only in GitHub Actions secrets. To rotate: generate a new key,
replace packages/rockchip-archive-keyring/rockchip-archive-keyring.asc, bump the
keyring deb version, re-run apt-publish. Nodes pick up the new key via apt before
the old one is retired.
```

Fill `<APT_GPG_KEY_ID>` and `<OLD>/<BAD>` are operator-fill values.

- [ ] **Step 2: Verify** — `grep -n 's3.timmertech' docs/kernel-updates.md` matches Tasks 5–7; key ID matches `gh variable get APT_GPG_KEY_ID`.

- [ ] **Step 3: Commit**

```bash
git add docs/kernel-updates.md
git commit -m "docs(kernel): runbook for apt kernel updates, rollback, and keep-N"
```

---

## Self-Review

**Spec coverage:**
- "like x86 / co-installable" → native ABI naming + `--preserve-versions` (Task 5) + drop hold (Task 6).
- "meta tracks latest" → Tasks 2/4 (`linux-rockchip`), installed in Task 7.
- "host the channel / MinIO + nginx? + registry?" → MinIO direct, no nginx/registry (Architecture); Tasks 1/5.
- "dual S3 with fallback (NL fast, CAN backup)" → CAN origin-of-truth + `mc mirror` to NL (Task 5); multi-URI source + dual-host pin (Tasks 3/6/7); apt client-side fallback.
- ".deb that installs repo + GPG" → Task 3 `rockchip-archive-keyring`; bootstrap in Tasks 6/7.
- "old kernel kept for rollback" → keep-N + runbook (Task 8); canary verifies >= 2 (Task 7).
- "DKMS still works" → meta pulls `linux-headers-rockchip` (Task 2); canary checks `dkms status` (Task 7).
- "don't break headless nodes" → image pin=100, node opt-in pin=500, BMC rollback runbook.
- "fix RELASE_VERSION?" → explicitly out of scope (Global Constraints) — load-bearing typo, untouched.

**Placeholder scan:** `<APT_GPG_KEY_ID>`, `<OLD>`, `<BAD>` are intentional operator-fill values, documented as such. All code blocks complete.

**Type/name consistency:** package names `linux-image-rockchip` / `linux-headers-rockchip` / `linux-rockchip` / `rockchip-archive-keyring` consistent across Tasks 2–7. Keyring path `/usr/share/keyrings/rockchip-archive-keyring.gpg` and source file `/etc/apt/sources.list.d/rockchip-kernel.sources` consistent between the deb postinst (Task 3) and the inspections (Tasks 6/7). Mirror URLs `s3.timmertech.nl` (NL) + `s3.timmertech.io` (CAN) consistent everywhere; deb-s3 endpoint = CAN only.

**Known residual risks (flagged, not gaps):**
- `deb-s3 --force-path-style` support varies by version — Task 5 documents the CNAME fallback.
- Mid-mirror window (NL has a new `Release` but a pool deb not yet copied) → apt's CAN fallback covers it; `mc mirror` never deletes (`--overwrite`, no `--remove`).
- apt-auto-removal keys on `linux-image-[0-9]` names; our ABI names match, but Task 8 has the operator verify rather than assume.
- `dpkg -i` of the keyring deb on a fresh node has no deps (arch:all, `${misc:Depends}` only), so no `apt --fix-broken` is needed before `apt-get update`.
