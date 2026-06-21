# s3-promote-cleanup

Automatic, **verification-gated** cleanup of the CA MinIO. After a release replicates
CA→NL, this deletes the CA copy so the CA disk doesn't fill — but **only** for objects
confirmed present on NL (matching byte size). NL is the permanent public copy.

Engine: [`scripts/s3-promote-cleanup.sh`](../../scripts/s3-promote-cleanup.sh)
(dry-run by default; covers `images/` and `releases/`). Runs in namespace **`storage`**
(next to MinIO — direct in-cluster access, avoids the `coding` runner NetworkPolicy).

## Layout

- `image/` — Dockerfile + entrypoint for the `s3-promote-cleanup` container (mc + jq +
  the engine script). Built/pushed by `scripts/build-docker-images.sh`.
- `k3s/` — the `storage`-namespace manifests: `secrets.yaml` (ESO ExternalSecret) and
  `cronjob.yaml`.

## How creds flow

Both MinIO credential sets live in the **shared** Vault and are pulled by one ESO
ExternalSecret (`k3s/secrets.yaml`, store `vault-shared`) into the `s3-promote-cleanup`
Secret. The CronJob `envFrom`'s it; the image entrypoint writes `mc` config from those
values. Endpoints + regions are baked (CA `ca-central-1`, NL `eu-west-1`; MinIO needs
path-style) — `mc alias set` can't carry a region, so the entrypoint writes config.json.

## Preconditions

1. CA→NL replication is one-way and **delete replication is disabled** on every CA rule
   (deleting from CA never reaches NL):

   ```bash
   mc replicate export can/rockchip | jq '.Rules[] | {ID,DeleteReplication,DeleteMarkerReplication}'
   # all must be Disabled / Disabled
   ```

2. ESO installed; the `vault-shared` ClusterSecretStore resolves the CA/NL paths and its
   Vault policy permits the `storage` namespace ServiceAccount.

## Deploy

Build + push the image (from the repo root):

```bash
./scripts/build-docker-images.sh s3-promote-cleanup
```

Edit `k3s/secrets.yaml` (CA/NL `remoteRef.key` paths in vault-shared) and
`k3s/cronjob.yaml` (`.image` = your registry), then apply:

```bash
kubectl apply -f deploy/s3-promote-cleanup/k3s/secrets.yaml
kubectl apply -f deploy/s3-promote-cleanup/k3s/cronjob.yaml
```

## Enable deletion (deliberately)

Ships as a **dry run** (`args: []`) — logs `WOULD FREE` / `KEEP`, deletes nothing.
Validate first:

```bash
kubectl -n storage create job --from=cronjob/s3-promote-cleanup promote-dryrun-1
kubectl -n storage logs job/promote-dryrun-1
```

When decisions look right, flip the CronJob:

```yaml
args: ["--delete"]
env:
  - name: HARD_PURGE
    value: "1"   # instant reclaim; safe — each object is verified on NL first
```

`HARD_PURGE=0` instead leaves a delete marker for the `NoncurrentVersionExpiration` ILM
rule to free within a day.

## Behaviour

- Published to CA → replicates to NL → next tick sees a same-size copy on NL → deletes
  the CA copy. Idempotent; not-yet-replicated objects are kept.
- Leaves the root `manifest.json` (tiny "latest" pointer) on CA.
- Tune `schedule` for how long CA may hold replicated data.
