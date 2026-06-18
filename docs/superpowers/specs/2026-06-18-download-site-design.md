# Design: self-hosted Ubuntu-Rockchip download site

**Date:** 2026-06-18
**Status:** Approved (design phase)
**Repo:** `gjrtimmer/ubuntu-rockchip` (fork of `Joshua-Riek/ubuntu-rockchip`)

## Problem

The project README still advertises Joshua Riek's release assets and his download
front-end (`joshua-riek.github.io/ubuntu-rockchip-download`). This fork (`gjrtimmer/ubuntu-rockchip`)
has no download site of its own — users are pointed at upstream's releases instead of ours.

We want our own branded download site, hosted by us, that lists every board image
this fork produces and links to *our* release artifacts.

## Decisions (from brainstorming)

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Role of S3 (now) | **Front-end only** | GitHub Release egress is free; S3 egress (~$0.09/GB on ~1–2 GB images, ~240 files/release) is costly. Defer artifact hosting. |
| Future direction | Keep a clean seam to **move artifacts to S3 later** | Avoid a rewrite when/if we self-host the binaries. |
| Page hosting | **GitHub Pages** (default `github.io` URL) | Free, zero-maintenance, lives in this repo. No custom domain yet. |
| Data source | **`manifest.json`** published as a release asset | Stable interface; no GitHub API rate limits; carries checksums; trivial S3 swap. |
| Visual style | **Clean Ubuntu-themed** (built from scratch) | We don't have the original site's source. |
| Scope | **`release.yml` only** (stable releases) | A download page should show stable releases, not nightly/next. |

## Architecture

```
release.yml (build matrix: board × suite × flavor)
   │  each build job: builds img.xz + .sha256, emits part-<board>-<suite>-<flavor>.json artifact
   ▼
manifest job  ── downloads all parts ──▶  manifest.json  (version, base_url, images[])
   │            ── jq schema validation (fails release if invalid) ──
   ▼  uploads manifest.json as a release asset, then publishes the draft release
GitHub Release  vX.Y.Z   (images + manifest.json)

download-site/ (static, on GitHub Pages)
   app.js fetches  …/releases/latest/download/manifest.json   ← always-latest redirect, no API, no rate limit
   renders board picker (filter by maker / SoC) → suite + flavor download buttons (size + sha256)
```

### The "S3 later" seam

`manifest.json` carries a top-level `base_url` plus a relative `filename` per image.
The page composes the download URL as `base_url + filename`. Switching to S3 later is:

1. Mirror the image files to S3/CloudFront.
2. Regenerate the manifest with `base_url = https://downloads.example/…/`.

**The page code does not change.** This is the entire payoff of the manifest approach.

## Components

### 1. `download-site/` — static front-end
- `index.html`, `style.css`, `app.js` (no framework, no build step).
- Ubuntu/Rockchip-themed. Filter by maker / SoC, then per-suite + per-flavor download
  buttons showing file size and a copyable `sha256`.
- Fetches `https://github.com/gjrtimmer/ubuntu-rockchip/releases/latest/download/manifest.json`.
- Ships a committed `sample-manifest.json` so the page can be developed/loaded locally
  without a live release.

### 2. Manifest generation in `.github/workflows/release.yml`
- **Per `build` job:** after building, write `part-<board>-<suite>-<flavor>.json` containing
  `board, board_name, soc, maker, suite, suite_version, flavor, filename, size, sha256`
  (derived from the board config that's already sourced + the existing `.sha256` file +
  file size). Upload it as a workflow artifact.
- **New final `manifest` job** (depends on `build`): download all `part-*` artifacts,
  assemble `manifest.json` (top-level `version`, `generated` timestamp, `base_url`, `images[]`),
  validate with `jq`, upload it to the release as an asset, then publish the draft release.

### 3. `.github/workflows/pages.yml` — Pages deploy
- Deploys `download-site/` to GitHub Pages via `actions/configure-pages` +
  `actions/upload-pages-artifact` + `actions/deploy-pages`.
- Triggers: push to `main` touching `download-site/**`, plus `workflow_dispatch`.
- Resulting URL: `https://gjrtimmer.github.io/ubuntu-rockchip/`.

### 4. `README.md` update
- Repoint badges (release / downloads / nightly) and the download link from
  `Joshua-Riek` / `joshua-riek.github.io` to **`gjrtimmer/ubuntu-rockchip`** + the new Pages URL.
- Closes the README branding gap.

## `manifest.json` schema

```json
{
  "version": "2.4.2",
  "generated": "2026-06-18T00:00:00Z",
  "base_url": "https://github.com/gjrtimmer/ubuntu-rockchip/releases/download/v2.4.2/",
  "images": [
    {
      "board": "orangepi-5-plus",
      "board_name": "Orange Pi 5 Plus",
      "soc": "RK3588",
      "maker": "Xunlong",
      "suite": "noble",
      "suite_version": "24.04",
      "flavor": "server",
      "filename": "ubuntu-24.04-preinstalled-server-arm64-orangepi-5-plus.img.xz",
      "size": 1402160284,
      "sha256": "…"
    }
  ]
}
```

Required keys per image: `board, board_name, soc, maker, suite, suite_version, flavor,
filename, size, sha256`. The `manifest` job's `jq` check fails the release if any are
missing or if `images` is empty.

## Error handling

- **Page:** if the manifest fetch fails (e.g. no published release yet, or network error),
  show a friendly fallback that links to the GitHub releases page. All filtering is
  client-side; there is no server component.
- **CI:** the `jq` schema sanity-check in the `manifest` job is a hard gate — a malformed
  or empty manifest fails the release rather than shipping.

## Testing

This repo has no unit-test framework (per `CLAUDE.md`). Verification is therefore:
1. The `jq` schema validation in the `manifest` CI job.
2. Loading `download-site/index.html` locally against the committed `sample-manifest.json`
   and confirming the board picker, filters, download links, and sha256 display render correctly.

## Out of scope (YAGNI / deferred)

- S3 / CloudFront artifact hosting (the seam is in place; the work is not).
- Custom domain + TLS cert.
- Manifests for `nightly.yml` / `next.yml` (stable releases only).
- Changing Debian package `Maintainer:`/changelog/patch authorship (separate concern).
