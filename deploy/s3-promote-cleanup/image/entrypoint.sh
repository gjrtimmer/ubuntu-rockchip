#!/usr/bin/env bash
# Container entrypoint: configure the mc aliases from injected creds, then run the
# verified CA->NL promote-cleanup.
#
# CA creds come from the cluster-local `vault` store; NL creds from `vault-shared`
# (see externalsecret-can.yaml / externalsecret-nld.yaml). URLs + region are config,
# not secrets, and default to the in-cluster CA service + public NL host.
#
# We write config.json directly rather than `mc alias set` because CA enforces a SigV4
# region (ca-central-1) and `mc alias set` has no region flag.
set -euo pipefail

: "${CAN_ACCESS_KEY:?CAN_ACCESS_KEY required}"
: "${CAN_SECRET_KEY:?CAN_SECRET_KEY required}"
: "${NLD_ACCESS_KEY:?NLD_ACCESS_KEY required}"
: "${NLD_SECRET_KEY:?NLD_SECRET_KEY required}"

CAN_URL="${CAN_URL:-http://minio.storage.svc:9000}"
NLD_URL="${NLD_URL:-https://s3.timmertech.nl}"
CAN_REGION="${CAN_REGION:-ca-central-1}"
NLD_REGION="${NLD_REGION:-eu-west-1}"
cfg_dir="${MC_CONFIG_DIR:-/root/.mc}"

mkdir -p "${cfg_dir}"
cat > "${cfg_dir}/config.json" <<EOF
{
  "version": "10",
  "aliases": {
    "can": { "url": "${CAN_URL}", "accessKey": "${CAN_ACCESS_KEY}", "secretKey": "${CAN_SECRET_KEY}", "api": "S3v4", "path": "on", "region": "${CAN_REGION}" },
    "nld": { "url": "${NLD_URL}", "accessKey": "${NLD_ACCESS_KEY}", "secretKey": "${NLD_SECRET_KEY}", "api": "S3v4", "path": "on", "region": "${NLD_REGION}" }
  }
}
EOF
chmod 600 "${cfg_dir}/config.json"

exec /usr/local/bin/s3-promote-cleanup.sh "$@"
