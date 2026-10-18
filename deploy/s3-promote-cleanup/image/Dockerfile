# Minimal image for the verified CA->NL promote-cleanup CronJob: mc + jq + the script.
# Built from the REPO ROOT (so COPY can reach scripts/) by scripts/build-docker-images.sh:
#   ./scripts/build-docker-images.sh s3-promote-cleanup
# RK1 nodes are arm64; the mc binary below matches.
FROM alpine:3.20

# dl.min.io now returns HTTP 410 (mc client archived upstream), so fetch the pinned last
# GitHub release and verify its sha256. Pinned: no further security updates.
ARG MC_VERSION=RELEASE.2025-08-13T08-35-41Z
ARG MC_SHA256=14c8c9616cfce4636add161304353244e8de383b2e2752c0e9dad01d4c27c12c
RUN apk add --no-cache bash jq ca-certificates curl \
 && curl -fsSL "https://github.com/minio/mc/releases/download/${MC_VERSION}/mc.linux-arm64.${MC_VERSION}" -o /usr/local/bin/mc \
 && echo "${MC_SHA256}  /usr/local/bin/mc" | sha256sum -c - \
 && chmod +x /usr/local/bin/mc

COPY scripts/s3-promote-cleanup.sh /usr/local/bin/s3-promote-cleanup.sh
COPY deploy/s3-promote-cleanup/image/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/s3-promote-cleanup.sh /usr/local/bin/entrypoint.sh

# entrypoint builds $MC_CONFIG_DIR/config.json from the injected creds, then runs cleanup.
ENV MC_CONFIG_DIR=/root/.mc
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
