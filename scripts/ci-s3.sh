#!/bin/bash
# S3/MinIO helper for CI: build-cache restore/save + image publishing, via rclone.
#
# Reads repo Actions secrets from the environment:
#   S3_HOST           bare host, no scheme (e.g. minio.example.com) — scheme is added
#   S3_CLIENT_ID      access key
#   S3_CLIENT_SECRET  secret key
#   S3_BUCKET         target bucket (must already exist)
#   S3_REGION         optional, default eu-west-1 (MinIO ignores it)
#
# MinIO needs path-style addressing. Multipart chunk is capped at 64M so no single
# HTTP request body exceeds Cloudflare's 100M tunnel limit (no direct-IP needed).
#
# Usage:
#   ci-s3.sh get <remote-prefix> <local-dest-dir>     # cache restore (tolerant: miss = no-op)
#   ci-s3.sh put <local-src> <remote-prefix> [glob]   # cache save / publish (fails loud)
set -euo pipefail

: "${S3_HOST:?S3_HOST required}"
: "${S3_CLIENT_ID:?S3_CLIENT_ID required}"
: "${S3_CLIENT_SECRET:?S3_CLIENT_SECRET required}"
: "${S3_BUCKET:?S3_BUCKET required}"

# Normalise to a bare host, then force https.
host="${S3_HOST#http://}"; host="${host#https://}"; host="${host%/}"

export RCLONE_CONFIG_S3_TYPE=s3
export RCLONE_CONFIG_S3_PROVIDER=Minio
export RCLONE_CONFIG_S3_ACCESS_KEY_ID="${S3_CLIENT_ID}"
export RCLONE_CONFIG_S3_SECRET_ACCESS_KEY="${S3_CLIENT_SECRET}"
export RCLONE_CONFIG_S3_ENDPOINT="https://${host}"
export RCLONE_CONFIG_S3_REGION="${S3_REGION:-eu-west-1}"
export RCLONE_CONFIG_S3_FORCE_PATH_STYLE=true
# Cloudflare-tunnel safe: every multipart part is a separate request body < 100M.
# 64M keeps well under the 100M cap while minimising request count on fast (1Gbps) links.
export RCLONE_CONFIG_S3_CHUNK_SIZE=64M
export RCLONE_CONFIG_S3_UPLOAD_CUTOFF=64M

verb="${1:?verb required: get|put}"; shift

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
  *)
    echo "ci-s3.sh: unknown verb '${verb}' (expected get|put)" >&2
    exit 1
    ;;
esac
