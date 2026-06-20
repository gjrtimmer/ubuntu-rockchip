#!/bin/bash
# Shared retry helpers for network operations.
# Source this file; do not execute it directly.
#
# Usage in scripts (after cd to repo root):
#   source scripts/lib/retry.sh
#
# Usage in workflow run: blocks (repo root is the working directory):
#   source scripts/lib/retry.sh

# git_clone_retry <url> <dest> [extra git-clone flags...]
# Clones <url> into <dest>; retries up to 3 times with 15s delay.
# Removes any partial <dest> before each attempt so a mid-clone drop
# cannot poison subsequent runs.
git_clone_retry() {
    local url="${1:?git_clone_retry: url required}"
    local dest="${2:?git_clone_retry: dest required}"
    shift 2
    local attempt
    for attempt in 1 2 3; do
        # --one-file-system: never cross a mount boundary while clearing a partial clone,
        # so this can never recurse into a stray mount and damage the host.
        rm -rf --one-file-system "${dest}"
        git clone "$@" "${url}" "${dest}" && return 0
        [ "${attempt}" -lt 3 ] || { echo "Error: git clone ${url} failed after 3 attempts"; return 1; }
        echo "git clone attempt ${attempt}/3 failed — retrying in 15s"
        sleep 15
    done
}

# git_ls_remote_sha <url> <refspec>
# Prints the 12-char short SHA for <refspec> at <url>.
# Retries up to 3 times with 15s delay between attempts.
# Prints an empty string after 3 failures — callers use ${var:-unknown}.
git_ls_remote_sha() {
    local url="${1:?git_ls_remote_sha: url required}"
    local ref="${2:?git_ls_remote_sha: ref required}"
    local sha attempt
    for attempt in 1 2 3; do
        sha=$(git ls-remote "${url}" "${ref}" 2>/dev/null | awk 'NR==1{print substr($1,1,12)}')
        [ -n "${sha}" ] && { printf '%s' "${sha}"; return 0; }
        [ "${attempt}" -lt 3 ] && sleep 15
    done
    printf ''
    return 0
}

# git_lfs_retry
# Fetches and checks out LFS objects; retries once on failure.
git_lfs_retry() {
    git lfs fetch && git lfs checkout || (sleep 10 && git lfs fetch && git lfs checkout)
}

# with_apt_proxy <command> [args...]
# Verifies APT_PROXY is reachable (3 s timeout); clears it if not so the
# command falls back to a direct connection instead of failing immediately.
# APT_PROXY must be exported by the caller before invoking this function.
with_apt_proxy() {
    if [ -n "${APT_PROXY:-}" ]; then
        local _h _p
        _h=$(echo "${APT_PROXY}" | sed 's|.*://||;s|[:/].*||')
        _p=$(echo "${APT_PROXY}" | sed 's|.*://[^:]*:||;s|/.*||')
        timeout 3 bash -c ">/dev/tcp/${_h}/${_p}" 2>/dev/null \
            || { echo "APT proxy ${APT_PROXY} unreachable — building without proxy"; APT_PROXY=""; }
    fi
    sudo http_proxy="${APT_PROXY:-}" https_proxy="${APT_PROXY:-}" \
        no_proxy="localhost,127.0.0.1,::1,github.com,.github.com,.githubusercontent.com,codeload.github.com" \
        "$@"
}
