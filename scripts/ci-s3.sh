#!/bin/bash
# S3/MinIO helper for CI: build-cache restore/save + image publishing, via rclone.
#
# Reads repo Actions secrets from the environment:
#   S3_HOST           host with optional scheme; bare host => https. Use http:// for an
#                     in-cluster plaintext endpoint, e.g. http://minio.storage.svc:9000
#   S3_CLIENT_ID      access key
#   S3_CLIENT_SECRET  secret key
#   S3_BUCKET         target bucket (must already exist)
#   S3_REGION         optional, default ca-central-1 (the CA MinIO enforces region in SigV4)
#
# MinIO needs path-style addressing. Multipart chunk is capped at 64M so no single
# HTTP request body exceeds Cloudflare's 100M tunnel limit (no direct-IP needed).
#
# Usage:
#   ci-s3.sh get <remote-prefix> <local-dest-dir>     # cache restore (tolerant: miss = no-op)
#   ci-s3.sh put <local-src> <remote-prefix> [glob]   # cache save / publish (fails loud)
#   ci-s3.sh prune <remote-prefix> <max-age>          # delete objects older than max-age (e.g. 7d)
#   ci-s3.sh cp <remote-src> <remote-dst>             # server-side copy within the bucket (atomic dst replace)
set -euo pipefail

: "${S3_HOST:?S3_HOST required}"
: "${S3_CLIENT_ID:?S3_CLIENT_ID required}"
: "${S3_CLIENT_SECRET:?S3_CLIENT_SECRET required}"
: "${S3_BUCKET:?S3_BUCKET required}"

# Honor an explicit scheme in S3_HOST: http:// for in-cluster plaintext
# (e.g. http://minio.storage.svc:9000), https for a bare host.
case "${S3_HOST}" in
  http://*)  scheme=http;  host="${S3_HOST#http://}";;
  https://*) scheme=https; host="${S3_HOST#https://}";;
  *)         scheme=https; host="${S3_HOST}";;
esac
host="${host%/}"

export RCLONE_CONFIG_S3_TYPE=s3
export RCLONE_CONFIG_S3_PROVIDER=Minio
export RCLONE_CONFIG_S3_ACCESS_KEY_ID="${S3_CLIENT_ID}"
export RCLONE_CONFIG_S3_SECRET_ACCESS_KEY="${S3_CLIENT_SECRET}"
export RCLONE_CONFIG_S3_ENDPOINT="${scheme}://${host}"
export RCLONE_CONFIG_S3_REGION="${S3_REGION:-ca-central-1}"
export RCLONE_CONFIG_S3_FORCE_PATH_STYLE=true
# Cloudflare-tunnel safe: every multipart part is a separate request body < 100M.
# 64M keeps well under the 100M cap while minimising request count on fast (1Gbps) links.
export RCLONE_CONFIG_S3_CHUNK_SIZE=64M
export RCLONE_CONFIG_S3_UPLOAD_CUTOFF=64M
# Resilience for the Cloudflare-tunnelled endpoint: ride out transient 502s with backoff,
# and cap concurrent parts so several simultaneous uploads don't saturate the tunnel.
export RCLONE_RETRIES=5
export RCLONE_RETRIES_SLEEP=20s
export RCLONE_LOW_LEVEL_RETRIES=20
export RCLONE_CONFIG_S3_UPLOAD_CONCURRENCY=2

verb="${1:?verb required: get|put|prune|cp}"; shift

case "${verb}" in
  get)
    prefix="${1:?remote prefix required}"; dest="${2:?local dest dir required}"
    mkdir -p "${dest}"
    # A missing prefix on S3 is an empty listing => cache miss, not an error.
    rclone copy "s3:${S3_BUCKET}/${prefix}" "${dest}" --transfers=8 --s3-no-check-bucket || true
    ;;
  put)
    src="${1:?local src required}"; prefix="${2-}"; glob="${3:-}"   # empty prefix => bucket root
    if [ -n "${glob}" ]; then
      # --max-depth 1: match the glob at the top of <src> only; never descend into
      # huge subtrees like build/linux-rockchip (the kernel source, full of symlinks).
      rclone copy "${src}" "s3:${S3_BUCKET}/${prefix}" --include "${glob}" --max-depth 1 --transfers=8 --s3-no-check-bucket
    else
      rclone copy "${src}" "s3:${S3_BUCKET}/${prefix}" --transfers=8 --s3-no-check-bucket
    fi
    ;;
  prune)
    prefix="${1:?remote prefix required}"; age="${2:?max-age required, e.g. 7d}"
    # delete handoff objects older than <age>, then drop the emptied dirs (keep the prefix root)
    rclone delete "s3:${S3_BUCKET}/${prefix}" --min-age "${age}" --s3-no-check-bucket || true
    rclone rmdirs "s3:${S3_BUCKET}/${prefix}" --leave-root --s3-no-check-bucket || true
    ;;
  cp)
    src="${1:?remote src required}"; dst="${2:?remote dst required}"
    # server-side copy within the bucket; dst is replaced atomically (single PUT)
    rclone copyto "s3:${S3_BUCKET}/${src}" "s3:${S3_BUCKET}/${dst}" --s3-no-check-bucket
    ;;
  *)
    echo "ci-s3.sh: unknown verb '${verb}' (expected get|put|prune|cp)" >&2
    exit 1
    ;;
esac
