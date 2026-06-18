# syntax=docker/dockerfile:1
#
# Native arm64 GitHub Actions runner for gjrtimmer/ubuntu-rockchip image builds.
#
# Build + push for arm64 ONLY (no QEMU). The simplest path is to build it natively
# on one of the RK1 nodes; or with buildx --platform=linux/arm64. See ../README.md.
#
#   <harbor-host>/rockchip/github-runner:arm64        (Harbor project: rockchip)
#
# The toolchain below is the ubuntu-rockchip workflow "Install dependencies" set,
# baked in so each job skips a multi-minute apt-get install (speed lever, §7).
# >>> KEEP IN SYNC with .github/workflows/build.yml in gjrtimmer/ubuntu-rockchip;
#     rebuild + re-push this image whenever that package list changes. <<<
#
# Base is the official multi-arch runner agent (arm64 variant pulled natively).
ARG RUNNER_VERSION=2.319.1
FROM ghcr.io/actions/actions-runner:${RUNNER_VERSION}

USER root

# Keep downloaded .debs so the node-local apt-cache hostPath survives across jobs.
RUN printf 'Binary::apt::APT::Keep-Downloaded-Packages "true";\n' \
      > /etc/apt/apt.conf.d/01keep-debs

# Runner essentials + the prebaked ubuntu-rockchip build toolchain (verbatim list).
# NOTE: installed WITH recommends on purpose — the upstream workflow installs on
# GitHub-hosted runners without --no-install-recommends, so dropping recommends
# here could omit a build-time dep and cause failures that don't repro on hosted.
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      sudo curl ca-certificates jq git \
      build-essential gcc-aarch64-linux-gnu bison qemu-user-static qemu-system-arm \
      qemu-efi u-boot-tools binfmt-support debootstrap flex libssl-dev bc rsync kmod \
      cpio xz-utils fakeroot parted udev dosfstools uuid-runtime git-lfs \
      device-tree-compiler python2 python3 python-is-python3 fdisk debhelper \
      python3-pyelftools python3-setuptools python3-distutils python3-pkg-resources \
      swig libfdt-dev libpython3-dev dctrl-tools \
      `# kernel BTF + compression: preinstalled on GitHub-hosted runners, NOT in` \
      `# the workflow's explicit apt list, so they must be baked in here.` \
      libelf-dev dwarves zstd lz4 \
 && git lfs install --system \
 && rm -rf /var/lib/apt/lists/*

# Passwordless sudo for the runner user: the agent runs unprivileged, jobs escalate
# via `sudo ./build.sh` (build.sh hard-exits unless uid 0). Container is privileged
# so root-in-pod then holds the caps loop/mount/chroot/dd need.
RUN echo 'runner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/runner \
 && chmod 0440 /etc/sudoers.d/runner

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

USER runner
WORKDIR /home/runner
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
