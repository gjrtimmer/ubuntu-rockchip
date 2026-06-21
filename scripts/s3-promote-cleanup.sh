#!/usr/bin/env bash
#
# s3-promote-cleanup.sh — reclaim space on the CA MinIO by deleting published release
# objects that are VERIFIED-replicated to the NL MinIO. This makes CA->NL a "move"
# instead of a clone: CA is staging, NL is the permanent public copy.
#
# SAFETY MODEL (read before changing):
#   - A CA object is deleted ONLY after the identical object (same byte size) is
#     confirmed present on NL. Anything not yet on NL is KEPT, never touched.
#   - Dry run by default. Pass --delete to actually remove. Always read a dry run first.
#   - Relies on the CA->NL replication rules having delete replication DISABLED
#     (DeleteReplication + DeleteMarkerReplication = Disabled), so removing from CA
#     can never propagate the delete to NL. Verify with:
#       mc replicate export can/rockchip | jq '.Rules[] | {ID,DeleteReplication,DeleteMarkerReplication}'
#
# Covers BOTH replicated data prefixes: images/ and releases/. manifest.json (the
# root "latest" pointer) is intentionally left on CA — it is tiny and rewritten each
# release.
#
# Requires: mc (with an alias for each site), jq.
#
# Config via env (defaults match the rockchip setup):
#   SRC_ALIAS    CA (source/staging) mc alias                 [can]
#   DST_ALIAS    NL (dest/permanent) mc alias                 [nld]
#   BUCKET       bucket name (same on both sites)             [rockchip]
#   PREFIXES     space-separated prefixes to drain            [images/ releases/]
#   HARD_PURGE   1 = remove all versions now (instant reclaim, safe here because each
#                object is verified on NL first); 0 = write a delete marker and let the
#                NoncurrentVersionExpiration ILM rule free the space within a day  [0]
#
# Usage:
#   ./scripts/s3-promote-cleanup.sh            # dry run: print decisions, delete nothing
#   ./scripts/s3-promote-cleanup.sh --delete   # delete CA copies verified present on NL
set -euo pipefail

SRC_ALIAS="${SRC_ALIAS:-can}"
DST_ALIAS="${DST_ALIAS:-nld}"
BUCKET="${BUCKET:-rockchip}"
PREFIXES="${PREFIXES:-images/ releases/}"
HARD_PURGE="${HARD_PURGE:-0}"

do_delete=0
[ "${1:-}" = "--delete" ] && do_delete=1

command -v mc >/dev/null || { echo "ERROR: mc not found in PATH" >&2; exit 1; }
command -v jq >/dev/null || { echo "ERROR: jq not found in PATH" >&2; exit 1; }

# exact object size in bytes, or empty if the object does not exist
obj_size() { mc stat --json "$1" 2>/dev/null | jq -r '.size // empty'; }

remove_ca() {
  # $1 = full source path. delete-replication is OFF, so neither form reaches NL.
  if [ "${HARD_PURGE}" = "1" ]; then
    mc rm --versions --force "$1" >/dev/null   # free space immediately (object is verified on NL)
  else
    mc rm "$1" >/dev/null                       # delete marker; ILM noncurrent purge frees it
  fi
}

[ "${do_delete}" = "1" ] || echo "DRY RUN — no objects will be deleted. Re-run with --delete to act."

for prefix in ${PREFIXES}; do
  src_base="${SRC_ALIAS}/${BUCKET}/${prefix}"
  # mc find prints full object paths; tolerate an absent/empty prefix
  mc find "${src_base}" 2>/dev/null | while IFS= read -r src; do
    rel="${src#"${SRC_ALIAS}/${BUCKET}/"}"          # e.g. images/<ver>/<board>/<file>
    dst="${DST_ALIAS}/${BUCKET}/${rel}"
    ssize="$(obj_size "${src}")"
    dsize="$(obj_size "${dst}")"
    if [ -n "${dsize}" ] && [ "${ssize}" = "${dsize}" ]; then
      if [ "${do_delete}" = "1" ]; then
        remove_ca "${src}"
        echo "FREED CA  (verified on NL, ${ssize}B): ${rel}"
      else
        echo "WOULD FREE (on NL, ${ssize}B): ${rel}"
      fi
    else
      echo "KEEP       (not confirmed on NL: src=${ssize:-?} dst=${dsize:-MISSING}): ${rel}"
    fi
  done
done
