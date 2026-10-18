#!/bin/bash
# Configure the bucket's object-lifecycle (ILM) so noncurrent versions self-purge server-side.
#
# Versioning is enabled BUCKET-WIDE and cannot be disabled per folder, so we control version
# retention per prefix via NoncurrentVersionExpiration:
#
#   build/ cache/ ci/ rootfs/   -> 1 day    NOT synced to NL; versions there are useless, so
#                                            reclaim aggressively (+ drop zombie delete markers).
#   releases/ images/           -> 365 days synced/mirrored to NL; keep versions as a safety net.
#                                            (These are published immutably and rarely overwritten,
#                                             so they accumulate almost no versions anyway.)
#
# This is SERVER-SIDE: MinIO applies the rules on its own ILM scan (~24h), so there is no
# per-run cleanup command and NO container image is needed — mc is a single static binary,
# fetched here if the host lacks it. Idempotent: clears existing rules and re-adds, so it is
# safe to re-run (e.g. after editing the retention policy).
#
# Env (same secrets as scripts/ci-s3.sh): S3_HOST S3_CLIENT_ID S3_CLIENT_SECRET S3_BUCKET
set -euo pipefail

: "${S3_HOST:?S3_HOST required}"
: "${S3_CLIENT_ID:?S3_CLIENT_ID required}"
: "${S3_CLIENT_SECRET:?S3_CLIENT_SECRET required}"
: "${S3_BUCKET:?S3_BUCKET required}"

# mc binary: use the system client, else fetch the static one (no container image required).
if command -v mc >/dev/null 2>&1; then
  MC=mc
else
  case "$(uname -m)" in aarch64|arm64) MA=arm64;; x86_64|amd64) MA=amd64;; *) MA="$(uname -m)";; esac
  # dl.min.io now returns HTTP 410 (mc client archived upstream), so fetch the pinned last
  # GitHub release and verify its sha256. Pinned: no further security updates.
  MC_VERSION=RELEASE.2025-08-13T08-35-41Z
  case "${MA}" in
    amd64) MC_SHA256=01f866e9c5f9b87c2b09116fa5d7c06695b106242d829a8bb32990c00312e891;;
    arm64) MC_SHA256=14c8c9616cfce4636add161304353244e8de383b2e2752c0e9dad01d4c27c12c;;
    *) echo "unsupported arch for mc: ${MA}" >&2; exit 1;;
  esac
  MC="$(mktemp -d)/mc"
  curl -fsSL "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-${MA}.${MC_VERSION}" -o "${MC}"
  echo "${MC_SHA256}  ${MC}" | sha256sum -c -
  chmod +x "${MC}"
fi

# Honor an explicit scheme in S3_HOST (http:// for an in-cluster plaintext endpoint); bare => https.
case "${S3_HOST}" in
  http://*|https://*) url="${S3_HOST}";;
  *)                  url="https://${S3_HOST}";;
esac

alias_name="ilm-$$"
"${MC}" alias set "${alias_name}" "${url}" "${S3_CLIENT_ID}" "${S3_CLIENT_SECRET}" --api s3v4 >/dev/null
trap '"${MC}" alias rm "${alias_name}" >/dev/null 2>&1 || true' EXIT
target="${alias_name}/${S3_BUCKET}"

echo "Resetting lifecycle rules on ${S3_BUCKET} ..."
"${MC}" ilm rule rm --all --force "${target}" 2>/dev/null || true

# Non-synced build-pipeline prefixes: noncurrent versions are dead weight -> purge after 1 day,
# and clean up the zombie delete markers the prune steps leave behind.
for p in build cache ci rootfs; do
  echo "  + ${p}/   noncurrent-expire 1d (+ expire-delete-marker)"
  "${MC}" ilm rule add "${target}" --prefix "${p}/" --noncurrent-expire-days 1 --expire-delete-marker
done

# Synced/published prefixes (mirrored to NL): keep versions as a long safety net.
for p in releases images; do
  echo "  + ${p}/   noncurrent-expire 365d (retained — NOT aggressively reclaimed)"
  "${MC}" ilm rule add "${target}" --prefix "${p}/" --noncurrent-expire-days 365
done

echo
echo "Resulting lifecycle:"
"${MC}" ilm rule ls "${target}"
