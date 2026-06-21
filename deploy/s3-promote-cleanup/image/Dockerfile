# Minimal image for the verified CA->NL promote-cleanup CronJob: mc + jq + the script.
# Built from the REPO ROOT (so COPY can reach scripts/) by scripts/build-docker-images.sh:
#   ./scripts/build-docker-images.sh s3-promote-cleanup
# RK1 nodes are arm64; the mc binary below matches.
FROM alpine:3.20

RUN apk add --no-cache bash jq ca-certificates curl \
 && curl -fsSL https://dl.min.io/client/mc/release/linux-arm64/mc -o /usr/local/bin/mc \
 && chmod +x /usr/local/bin/mc

COPY scripts/s3-promote-cleanup.sh /usr/local/bin/s3-promote-cleanup.sh
COPY deploy/s3-promote-cleanup/image/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/s3-promote-cleanup.sh /usr/local/bin/entrypoint.sh

# entrypoint builds $MC_CONFIG_DIR/config.json from the injected creds, then runs cleanup.
ENV MC_CONFIG_DIR=/root/.mc
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
