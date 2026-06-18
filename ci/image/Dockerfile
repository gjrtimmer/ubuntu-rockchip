# syntax=docker/dockerfile:1
#
# Native arm64 GitHub Actions runner for gjrtimmer/ubuntu-rockchip image builds.
#
# Build + push for arm64 ONLY (no QEMU). The simplest path is to build it natively
# on one of the RK1 nodes. See ../../scripts/build-runner-image.sh.
#
#   <harbor-host>/rockchip/github-runner:arm64        (Harbor project: rockchip)
#
# Base is Ubuntu 22.04 (jammy) ON PURPOSE: the build's curated package set is
# jammy-era (python2, python3-distutils, qemu-efi, ...). The official
# actions/runner image moved to a noble (24.04) base, where those packages are
# dropped/renamed and the u-boot-turing build (python3-distutils Build-Depends)
# breaks. We install the runner agent manually instead; it bundles its own Node
# (node24), so checkout@v7 etc. still run. The agent self-updates the agent
# binaries on connect but the OS stays jammy.
#
# The toolchain below is the ubuntu-rockchip workflow "Install dependencies" set,
# baked in so each job skips a multi-minute apt-get install.
# >>> KEEP IN SYNC with .github/workflows/build.yml; rebuild on changes. <<<
FROM ubuntu:22.04

ARG RUNNER_VERSION=2.335.1
ARG RUNNER_ARCH=arm64
ENV DEBIAN_FRONTEND=noninteractive

# Keep downloaded .debs so a node-local apt-cache volume can survive across jobs.
RUN printf 'Binary::apt::APT::Keep-Downloaded-Packages "true";\n' \
      > /etc/apt/apt.conf.d/01keep-debs

# Runner essentials + the prebaked ubuntu-rockchip build toolchain (jammy names).
# Installed WITH recommends to match the GitHub-hosted environment the upstream
# workflow assumed.
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      ca-certificates curl jq git sudo unzip tar gzip \
 && apt-get install -y \
      rclone git-lfs \
      build-essential gcc-aarch64-linux-gnu bison qemu-user-static qemu-system-arm \
      qemu-efi u-boot-tools binfmt-support debootstrap flex libssl-dev bc rsync kmod \
      cpio xz-utils fakeroot parted udev dosfstools uuid-runtime \
      device-tree-compiler python2 python3 python-is-python3 fdisk debhelper \
      python3-pyelftools python3-setuptools python3-distutils python3-pkg-resources \
      swig libfdt-dev libpython3-dev dctrl-tools \
      libelf-dev dwarves zstd lz4 \
 && git lfs install --system \
 && rm -rf /var/lib/apt/lists/*

# Unprivileged runner user with passwordless sudo: the agent runs as `runner`,
# jobs escalate via `sudo ./build.sh` (build.sh hard-exits unless uid 0). The pod
# is privileged so root-in-container then holds the caps loop/mount/chroot/dd need.
RUN useradd -m -s /bin/bash runner \
 && echo 'runner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/runner \
 && chmod 0440 /etc/sudoers.d/runner

# Install the GitHub Actions runner agent (bundles node24) + its .NET deps.
RUN cd /home/runner \
 && curl -fsSL -o runner.tar.gz \
      "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" \
 && tar xzf runner.tar.gz \
 && rm runner.tar.gz \
 && ./bin/installdependencies.sh \
 && chown -R runner:runner /home/runner

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

USER runner
WORKDIR /home/runner
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
