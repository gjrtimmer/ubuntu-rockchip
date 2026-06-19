# Download Site Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a branded GitHub Pages download site for `gjrtimmer/ubuntu-rockchip` that lists every released board image from a `manifest.json` published with each release.

**Architecture:** Static page (`download-site/`) fetches `releases/latest/download/manifest.json` (GitHub's always-latest redirect) and renders a filterable board → suite → flavor download grid with sizes + SHA-256. The release workflow generates the manifest from per-build part files. `base_url` in the manifest is the single seam to later repoint downloads at S3 — no page-code change needed.

**Tech Stack:** Plain HTML/CSS/JS (no framework, no build step). GitHub Actions (`actions/deploy-pages`, `jq`, `xresloader/upload-to-github-release`, `gh` CLI).

## Global Constraints

- Repo slug: `gjrtimmer/ubuntu-rockchip`. Pages URL: `https://gjrtimmer.github.io/ubuntu-rockchip/`.
- Manifest source URL (production): `https://github.com/gjrtimmer/ubuntu-rockchip/releases/latest/download/manifest.json`.
- Release tag is hardcoded `v2.4.2` in [.github/workflows/release.yml](.github/workflows/release.yml) — match it; do not introduce a different tag.
- Env var spelling is `RELASE_VERSION` (no second "E") — match existing.
- Image artifact pattern: `ubuntu-<RELASE_VERSION>-preinstalled-<flavor>-arm64-<board>.img.xz` plus a sibling `.img.xz.sha256`.
- Board metadata vars (in `config/boards/<board>.sh`): `BOARD_NAME`, `BOARD_MAKER`, `BOARD_SOC`.
- No unit-test framework in this repo (per CLAUDE.md). Verification = `jq` schema gate in CI + local page load against `sample-manifest.json`.
- Conventional Commits required on every commit / PR title.

---

### Task 1: Static download front-end (`download-site/`)

**Files:**
- Create: `download-site/index.html`
- Create: `download-site/style.css`
- Create: `download-site/app.js`
- Create: `download-site/sample-manifest.json`

**Interfaces:**
- Consumes: a `manifest.json` of shape `{version, generated, base_url, images:[{board,board_name,soc,maker,suite,suite_version,flavor,filename,size,sha256}]}`.
- Produces: a deployable static directory consumed by Task 3 (`actions/upload-pages-artifact path: download-site`).

- [ ] **Step 1: Create `download-site/index.html`**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ubuntu Rockchip — Downloads</title>
  <meta name="description" content="Download Ubuntu disk images for Rockchip ARM single-board computers.">
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <header class="site-header">
    <div class="wrap">
      <h1><span class="dot"></span> Ubuntu&nbsp;Rockchip</h1>
      <p class="tagline">Bootable Ubuntu images for Rockchip ARM single-board computers</p>
      <p class="release-line" id="release-line" hidden>
        Latest release <strong id="release-version">—</strong>
        <span id="release-generated" class="muted"></span>
      </p>
    </div>
  </header>

  <main class="wrap">
    <section class="controls" id="controls" hidden>
      <input type="search" id="search" placeholder="Search board, SoC, maker…" autocomplete="off" aria-label="Search">
      <select id="filter-maker" aria-label="Filter by maker"><option value="">All makers</option></select>
      <select id="filter-soc" aria-label="Filter by SoC"><option value="">All SoCs</option></select>
      <select id="filter-suite" aria-label="Filter by Ubuntu release"><option value="">All releases</option></select>
    </section>

    <p id="status" class="status">Loading available images…</p>

    <div id="boards" class="boards"></div>
  </main>

  <footer class="site-footer">
    <div class="wrap">
      <p>Maintained fork of <a href="https://github.com/Joshua-Riek/ubuntu-rockchip">Joshua-Riek/ubuntu-rockchip</a>.
      Source &amp; issues: <a href="https://github.com/gjrtimmer/ubuntu-rockchip">gjrtimmer/ubuntu-rockchip</a>.</p>
      <p class="muted">Verify your download with the listed SHA-256 before flashing.</p>
    </div>
  </footer>

  <script src="app.js"></script>
</body>
</html>
```

- [ ] **Step 2: Create `download-site/style.css`**

```css
:root{
  --aubergine:#2c001e; --aubergine2:#5e2750; --orange:#e95420;
  --ink:#111; --bg:#f7f7f7; --card:#fff; --muted:#6b6b6b; --line:#e3e3e3;
}
*{box-sizing:border-box}
body{margin:0;font:16px/1.5 -apple-system,Segoe UI,Roboto,Ubuntu,Helvetica,Arial,sans-serif;color:var(--ink);background:var(--bg)}
.wrap{width:100%;max-width:1100px;margin:0 auto;padding:0 20px}
a{color:var(--orange)}
.muted{color:var(--muted)}
.site-header{background:linear-gradient(135deg,var(--aubergine),var(--aubergine2));color:#fff;padding:34px 0 28px}
.site-header h1{margin:0;font-size:30px;display:flex;align-items:center;gap:12px}
.site-header .dot{width:18px;height:18px;border-radius:50%;background:var(--orange);box-shadow:0 0 0 5px rgba(233,84,32,.25)}
.tagline{margin:6px 0 0;opacity:.9}
.release-line{margin:14px 0 0;font-size:14px;opacity:.95}
.release-line .muted{color:#d9c7d2}
.controls{display:flex;flex-wrap:wrap;gap:12px;margin:24px 0 8px}
.controls input,.controls select{padding:10px 12px;border:1px solid var(--line);border-radius:8px;background:var(--card);font:inherit}
.controls input{flex:1 1 260px}
.status{margin:24px 0;color:var(--muted)}
.status.error{color:#b3261e}
.boards{display:grid;grid-template-columns:repeat(auto-fill,minmax(330px,1fr));gap:18px;margin:18px 0 50px}
.board{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:18px;display:flex;flex-direction:column}
.board h2{margin:0 0 2px;font-size:18px}
.board .meta{margin:0 0 14px;font-size:13px;color:var(--muted)}
.board .meta .chip{display:inline-block;background:#f0eef0;border-radius:20px;padding:1px 10px;margin-right:6px}
.suite{border-top:1px solid var(--line);padding:12px 0 0;margin-top:8px}
.suite:first-of-type{border-top:0;margin-top:0}
.suite h3{margin:0 0 8px;font-size:14px}
.dl{display:flex;align-items:center;justify-content:space-between;gap:10px;padding:7px 0}
.dl .label{font-size:14px;text-transform:capitalize}
.dl .right{display:flex;align-items:center;gap:10px}
.dl .size{font-size:12px;color:var(--muted);min-width:64px;text-align:right}
.btn{background:var(--orange);color:#fff;text-decoration:none;border:0;border-radius:8px;padding:8px 14px;font-size:14px;cursor:pointer}
.btn:hover{filter:brightness(1.05)}
.sha{display:block;font:12px/1.4 ui-monospace,SFMono-Regular,Menlo,monospace;color:var(--muted);word-break:break-all;margin-top:2px;cursor:pointer}
.sha:hover{color:var(--ink)}
.site-footer{border-top:1px solid var(--line);padding:24px 0 40px;font-size:14px;color:var(--muted)}
@media (max-width:480px){.boards{grid-template-columns:1fr}}
```

- [ ] **Step 3: Create `download-site/app.js`**

```js
// Production: GitHub's "latest release" redirect. Single seam for an S3 move later.
const MANIFEST_URL = "https://github.com/gjrtimmer/ubuntu-rockchip/releases/latest/download/manifest.json";
// Local dev (file:// or localhost) loads the committed sample so the page renders without a release.
const isLocal = !location.hostname || ["localhost", "127.0.0.1"].includes(location.hostname);

const $ = (id) => document.getElementById(id);
let IMAGES = [];

function fmtSize(bytes) {
  if (!bytes && bytes !== 0) return "";
  const u = ["B", "KiB", "MiB", "GiB"];
  let i = 0, n = bytes;
  while (n >= 1024 && i < u.length - 1) { n /= 1024; i++; }
  return `${n.toFixed(n < 10 && i > 0 ? 1 : 0)} ${u[i]}`;
}

function uniqueSorted(arr) { return [...new Set(arr)].sort((a, b) => a.localeCompare(b)); }

function fillSelect(sel, values) {
  for (const v of values) {
    const o = document.createElement("option");
    o.value = v; o.textContent = v; sel.appendChild(o);
  }
}

function copySha(el, sha) {
  navigator.clipboard?.writeText(sha).then(() => {
    const old = el.textContent;
    el.textContent = "✓ copied sha256";
    setTimeout(() => { el.textContent = old; }, 1200);
  });
}

function render() {
  const q = $("search").value.trim().toLowerCase();
  const fMaker = $("filter-maker").value;
  const fSoc = $("filter-soc").value;
  const fSuite = $("filter-suite").value;

  const rows = IMAGES.filter((im) => {
    if (fMaker && im.maker !== fMaker) return false;
    if (fSoc && im.soc !== fSoc) return false;
    if (fSuite && im.suite !== fSuite) return false;
    if (q && ![im.board_name, im.board, im.soc, im.maker].join(" ").toLowerCase().includes(q)) return false;
    return true;
  });

  const boards = new Map();
  for (const im of rows) {
    if (!boards.has(im.board)) boards.set(im.board, { info: im, suites: new Map() });
    const b = boards.get(im.board);
    if (!b.suites.has(im.suite)) b.suites.set(im.suite, []);
    b.suites.get(im.suite).push(im);
  }

  const host = $("boards");
  host.innerHTML = "";
  if (boards.size === 0) { $("status").textContent = "No images match your filters."; $("status").hidden = false; return; }
  $("status").hidden = true;

  const sorted = [...boards.values()].sort((a, b) => a.info.board_name.localeCompare(b.info.board_name));
  for (const b of sorted) {
    const card = document.createElement("div");
    card.className = "board";
    card.innerHTML = `<h2>${b.info.board_name}</h2>
      <p class="meta"><span class="chip">${b.info.maker}</span><span class="chip">${b.info.soc}</span></p>`;

    const suiteNames = [...b.suites.keys()].sort();
    for (const s of suiteNames) {
      const imgs = b.suites.get(s).sort((a, c) => a.flavor.localeCompare(c.flavor));
      const ver = imgs[0].suite_version;
      const sec = document.createElement("div");
      sec.className = "suite";
      sec.innerHTML = `<h3>Ubuntu ${ver} <span class="muted">(${s})</span></h3>`;
      for (const im of imgs) {
        const url = (MANIFEST.base_url || "") + im.filename;
        const row = document.createElement("div");
        row.className = "dl";
        row.innerHTML = `<span class="label">${im.flavor}</span>
          <span class="right"><span class="size">${fmtSize(im.size)}</span>
          <a class="btn" href="${url}">Download</a></span>`;
        const sha = document.createElement("span");
        sha.className = "sha";
        sha.title = "Click to copy full SHA-256";
        sha.textContent = `sha256: ${im.sha256.slice(0, 16)}…`;
        sha.addEventListener("click", () => copySha(sha, im.sha256));
        const block = document.createElement("div");
        block.appendChild(row); block.appendChild(sha);
        sec.appendChild(block);
      }
      card.appendChild(sec);
    }
    host.appendChild(card);
  }
}

let MANIFEST = {};
function init(manifest) {
  MANIFEST = manifest;
  IMAGES = manifest.images || [];
  $("release-version").textContent = "v" + manifest.version;
  if (manifest.generated) $("release-generated").textContent = "· built " + manifest.generated.slice(0, 10);
  $("release-line").hidden = false;
  fillSelect($("filter-maker"), uniqueSorted(IMAGES.map((i) => i.maker)));
  fillSelect($("filter-soc"), uniqueSorted(IMAGES.map((i) => i.soc)));
  fillSelect($("filter-suite"), uniqueSorted(IMAGES.map((i) => i.suite)));
  $("controls").hidden = false;
  for (const el of ["search", "filter-maker", "filter-soc", "filter-suite"]) $(el).addEventListener("input", render);
  render();
}

function fail() {
  const s = $("status");
  s.className = "status error";
  s.innerHTML = `Couldn't load the image list. See the <a href="https://github.com/gjrtimmer/ubuntu-rockchip/releases">GitHub releases page</a>.`;
}

(async () => {
  try {
    const res = await fetch(isLocal ? "./sample-manifest.json" : MANIFEST_URL, { redirect: "follow" });
    if (!res.ok) throw new Error(res.status);
    init(await res.json());
  } catch (e) { fail(); }
})();
```

- [ ] **Step 4: Create `download-site/sample-manifest.json`**

```json
{
  "version": "2.4.2",
  "generated": "2026-06-18T00:00:00Z",
  "base_url": "https://github.com/gjrtimmer/ubuntu-rockchip/releases/download/v2.4.2/",
  "images": [
    { "board": "orangepi-5-plus", "board_name": "Orange Pi 5 Plus", "soc": "Rockchip RK3588", "maker": "Xunlong",
      "suite": "noble", "suite_version": "24.04", "flavor": "server",
      "filename": "ubuntu-24.04-preinstalled-server-arm64-orangepi-5-plus.img.xz", "size": 1402160284,
      "sha256": "0000000000000000000000000000000000000000000000000000000000000000" },
    { "board": "orangepi-5-plus", "board_name": "Orange Pi 5 Plus", "soc": "Rockchip RK3588", "maker": "Xunlong",
      "suite": "noble", "suite_version": "24.04", "flavor": "desktop",
      "filename": "ubuntu-24.04-preinstalled-desktop-arm64-orangepi-5-plus.img.xz", "size": 2913456120,
      "sha256": "1111111111111111111111111111111111111111111111111111111111111111" },
    { "board": "rock-5b", "board_name": "Radxa ROCK 5B", "soc": "Rockchip RK3588", "maker": "Radxa",
      "suite": "noble", "suite_version": "24.04", "flavor": "server",
      "filename": "ubuntu-24.04-preinstalled-server-arm64-rock-5b.img.xz", "size": 1399123456,
      "sha256": "2222222222222222222222222222222222222222222222222222222222222222" },
    { "board": "turing-rk1", "board_name": "Turing RK1", "soc": "Rockchip RK3588", "maker": "Turing Machines",
      "suite": "jammy", "suite_version": "22.04", "flavor": "server",
      "filename": "ubuntu-22.04-preinstalled-server-arm64-turing-rk1.img.xz", "size": 1340012345,
      "sha256": "3333333333333333333333333333333333333333333333333333333333333333" }
  ]
}
```

- [ ] **Step 5: Verify the page renders locally**

Run: `cd download-site && python3 -m http.server 8099 >/dev/null 2>&1 & sleep 1 && curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8099/ && curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8099/sample-manifest.json ; kill %1`
Expected: `200` then `200`. (Page logic loads `sample-manifest.json` on localhost; manual browser check: board picker, three filters, download buttons, and clickable sha256 all render.)

- [ ] **Step 6: Commit**

```bash
git add download-site/
git commit -m "feat: add static download site front-end"
```

---

### Task 2: Manifest generation in the release workflow

**Files:**
- Modify: `.github/workflows/release.yml` — add a manifest-part step to the `build` job (after the existing `Upload` step, before `Clean cache`), and add a new `manifest` job after `build`.

**Interfaces:**
- Consumes: the built image `images/ubuntu-*-preinstalled-<flavor>-arm64-<board>.img.xz` + its `.sha256`, board vars from `config/boards/<board>.sh`, `RELASE_VERSION` from `config/suites/<suite>.sh`.
- Produces: `manifest.json` (shape consumed by Task 1) uploaded as a release asset; the release published (un-drafted) so `releases/latest/download/manifest.json` resolves.

- [ ] **Step 1: Add the manifest-part step to the `build` job**

In `.github/workflows/release.yml`, insert these two steps between the `Upload` step and the `Clean cache` step of the `build` job:

```yaml
      - name: Manifest part
        if: needs.prepare_release.outputs.release_id != ''
        shell: bash
        run: |
          source config/boards/${{ matrix.board }}.sh
          source config/suites/${{ matrix.suite }}.sh
          img=$(ls images/ubuntu-*-preinstalled-${{ matrix.flavor }}-arm64-${{ matrix.board }}.img.xz | head -n1)
          fn=$(basename "$img")
          size=$(stat -c%s "$img")
          sha=$(awk '{print $1}' "${img}.sha256")
          mkdir -p manifest-parts
          jq -n \
            --arg board       "${{ matrix.board }}" \
            --arg board_name  "$BOARD_NAME" \
            --arg soc         "$BOARD_SOC" \
            --arg maker       "$BOARD_MAKER" \
            --arg suite       "${{ matrix.suite }}" \
            --arg suite_version "$RELASE_VERSION" \
            --arg flavor      "${{ matrix.flavor }}" \
            --arg filename    "$fn" \
            --argjson size    "$size" \
            --arg sha256      "$sha" \
            '{board:$board,board_name:$board_name,soc:$soc,maker:$maker,suite:$suite,suite_version:$suite_version,flavor:$flavor,filename:$filename,size:$size,sha256:$sha256}' \
            > "manifest-parts/${{ matrix.board }}-${{ matrix.suite }}-${{ matrix.flavor }}.json"

      - name: Upload manifest part
        if: needs.prepare_release.outputs.release_id != ''
        uses: actions/upload-artifact@v4.3.3
        with:
          name: manifest-part-${{ matrix.board }}-${{ matrix.suite }}-${{ matrix.flavor }}
          path: manifest-parts/*.json
          if-no-files-found: error
```

- [ ] **Step 2: Add the `manifest` job**

Append this job to `.github/workflows/release.yml` (top-level, sibling of `build`):

```yaml
  manifest:
    runs-on: ubuntu-latest
    needs: [build, prepare_release]
    if: needs.prepare_release.outputs.release_id != ''
    name: Generate manifest
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Download manifest parts
        uses: actions/download-artifact@v4.1.2
        with:
          pattern: manifest-part-*
          path: manifest-parts
          merge-multiple: true

      - name: Assemble and validate manifest.json
        shell: bash
        run: |
          tag="v2.4.2"
          base="https://github.com/${GITHUB_REPOSITORY}/releases/download/${tag}/"
          generated="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
          jq -s --arg version "${tag#v}" --arg generated "$generated" --arg base_url "$base" \
            '{version:$version, generated:$generated, base_url:$base_url, images:.}' \
            manifest-parts/*.json > manifest.json
          count=$(jq '.images | length' manifest.json)
          echo "images in manifest: $count"
          [ "$count" -gt 0 ] || { echo "ERROR: manifest has no images"; exit 1; }
          # Fail if any image is missing a required key.
          bad=$(jq '[.images[] | select(
            (has("board") and has("board_name") and has("soc") and has("maker")
             and has("suite") and has("suite_version") and has("flavor")
             and has("filename") and has("size") and has("sha256")) | not)] | length' manifest.json)
          [ "$bad" -eq 0 ] || { echo "ERROR: $bad image entries missing required keys"; exit 1; }

      - name: Upload manifest to release
        uses: xresloader/upload-to-github-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        with:
          release_id: ${{ needs.prepare_release.outputs.release_id }}
          file: manifest.json
          draft: true
          overwrite: true

      - name: Publish release
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: gh release edit v2.4.2 --draft=false --repo "${GITHUB_REPOSITORY}"
```

- [ ] **Step 3: Validate the workflow YAML parses and the manifest logic is sound**

Run:
```bash
python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/release.yml')); print('yaml ok')"
# dry-run the assemble/validate logic against the plan's sample parts
mkdir -p /tmp/mtest/manifest-parts && cd /tmp/mtest
for f in a b; do echo '{"board":"x","board_name":"X","soc":"S","maker":"M","suite":"noble","suite_version":"24.04","flavor":"server","filename":"f.img.xz","size":1,"sha256":"d"}' > manifest-parts/$f.json; done
jq -s '{version:"2.4.2",images:.}' manifest-parts/*.json | jq '.images|length'
```
Expected: `yaml ok` then `2`.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/release.yml
git commit -m "feat: generate and publish download manifest.json on release"
```

---

### Task 3: GitHub Pages deploy workflow

**Files:**
- Create: `.github/workflows/pages.yml`

**Interfaces:**
- Consumes: `download-site/` (Task 1).
- Produces: a deployed Pages site at `https://gjrtimmer.github.io/ubuntu-rockchip/`.

- [ ] **Step 1: Create `.github/workflows/pages.yml`**

```yaml
name: Pages
run-name: Deploy download site

on:
  push:
    branches: [main]
    paths:
      - 'download-site/**'
      - '.github/workflows/pages.yml'
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: false

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Checkout code
        uses: actions/checkout@v4
      - name: Configure Pages
        uses: actions/configure-pages@v5
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: download-site
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 2: Validate the workflow YAML parses**

Run: `python3 -c "import yaml; yaml.safe_load(open('.github/workflows/pages.yml')); print('yaml ok')"`
Expected: `yaml ok`

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/pages.yml
git commit -m "ci: add GitHub Pages deploy workflow for download site"
```

**Manual step (one-time, owner only — cannot be scripted):** Repo → Settings → Pages → Build and deployment → Source → **GitHub Actions**.

---

### Task 4: Repoint README branding to the fork

**Files:**
- Modify: `README.md:3-5` (badges) and `README.md:24` (download link).

**Interfaces:**
- Consumes: nothing. Produces: README pointing at `gjrtimmer/ubuntu-rockchip` + the new Pages download URL.

- [ ] **Step 1: Replace the three badges (lines 3-5)**

Change each `Joshua-Riek/ubuntu-rockchip` in the badge URLs to `gjrtimmer/ubuntu-rockchip`:

```markdown
[![Latest GitHub Release](https://img.shields.io/github/release/gjrtimmer/ubuntu-rockchip.svg?label=Latest%20Release)](https://github.com/gjrtimmer/ubuntu-rockchip/releases/latest)
[![Total GitHub Downloads](https://img.shields.io/github/downloads/gjrtimmer/ubuntu-rockchip/total.svg?&color=E95420&label=Total%20Downloads)](https://github.com/gjrtimmer/ubuntu-rockchip/releases)
[![Nightly GitHub Build](https://github.com/gjrtimmer/ubuntu-rockchip/actions/workflows/nightly.yml/badge.svg)](https://github.com/gjrtimmer/ubuntu-rockchip/actions/workflows/nightly.yml)
```

- [ ] **Step 2: Repoint the download link (line 24)**

Replace the upstream release + download-site URLs with the fork's release page and the new Pages site. New text:

```markdown
Download the Ubuntu image for your specific board from the latest [release](https://github.com/gjrtimmer/ubuntu-rockchip/releases) on GitHub or from the dedicated download [website](https://gjrtimmer.github.io/ubuntu-rockchip/). Then write the xz compressed image (no previous unpacking necessary) to your SD card using [USBimager](https://bztsrc.gitlab.io/usbimager/) or [balenaEtcher](https://www.balena.io/etcher) since, unlike other tools, these can validate burning results, saving you from corrupted SD card contents.
```

- [ ] **Step 3: Verify no stray upstream references remain in the changed lines**

Run: `sed -n '3,5p;24p' README.md | grep -c 'gjrtimmer/ubuntu-rockchip'`
Expected: `4` (three badges + the release link on line 24). The download-site link is `gjrtimmer.github.io`.

- [ ] **Step 4: Commit**

```bash
git add README.md
git commit -m "docs: point README badges and download link to the fork"
```

---

## Self-Review

**Spec coverage:**
- Front-end (`download-site/`, Ubuntu-themed, board picker, size + sha256, sample-manifest) → Task 1. ✔
- Manifest generation + jq gate + publish → Task 2. ✔
- Pages deploy workflow → Task 3. ✔
- README branding → Task 4. ✔
- "S3 later" seam (`base_url`) → present in manifest (Task 2) and used in `app.js` (Task 1). ✔
- Out-of-scope items (S3, CloudFront, custom domain, nightly/next manifests, Debian Maintainer) → not implemented, by design. ✔

**Placeholder scan:** No TBD/TODO. The `0000…`/`1111…` sha values in `sample-manifest.json` are intentional fixtures for local dev, not production placeholders. Real shas come from the `.sha256` files in Task 2.

**Type consistency:** Manifest shape `{version, generated, base_url, images:[{board, board_name, soc, maker, suite, suite_version, flavor, filename, size, sha256}]}` is identical across `app.js` (Task 1), `sample-manifest.json` (Task 1), and the `jq` assembly + validation (Task 2). `base_url + filename` URL composition matches between `app.js` and the manifest. ✔
