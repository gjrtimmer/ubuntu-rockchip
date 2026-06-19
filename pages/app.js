// Images are published to S3 (MinIO) by the build pipeline; the manifest rides along.
// Single seam: change this URL (and the build job's base_url) to repoint distribution.
const MANIFEST_URL = "https://s3.timmertech.nl/rockchip/manifest.json";
// Local dev (file:// or localhost) loads the committed sample so the page renders without a release.
const isLocal = !location.hostname || ["localhost", "127.0.0.1"].includes(location.hostname);

const POLL_MS = 30000;        // re-check syncing images every 30s
const HEAD_CONCURRENCY = 8;   // cap simultaneous HEAD requests

const $ = (id) => document.getElementById(id);
let IMAGES = [];
let MANIFEST = {};
const AVAIL = new Map();      // url -> "available" | "syncing" (undefined = not checked yet)
let pollTimer = null;

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

const urlFor = (im) => (MANIFEST.base_url || "") + im.filename;

// Render the download cell for an image based on its known availability.
function actionHTML(url) {
  const st = AVAIL.get(url);
  if (st === "available") return `<a class="btn" href="${url}">Download</a>`;
  if (st === "syncing")   return `<span class="btn btn-sync" title="Replicating to the download mirror — not yet available">⏳ Syncing…</span>`;
  return `<span class="btn btn-checking" title="Checking availability…">checking…</span>`;
}

// Repaint just the action cells in place (no full re-render → keeps filter/scroll state).
function paintActions() {
  document.querySelectorAll(".dl-action").forEach((el) => { el.innerHTML = actionHTML(el.dataset.url); });
}

function updateBanner() {
  const total = IMAGES.length;
  const avail = IMAGES.filter((im) => AVAIL.get(urlFor(im)) === "available").length;
  const checked = IMAGES.filter((im) => AVAIL.has(urlFor(im))).length;
  const b = $("sync-banner");
  if (!b || total === 0) return;
  if (checked < total) {
    b.className = "sync-banner wait";
    b.innerHTML = `Checking availability… <strong>${avail}/${total}</strong> ready.`;
  } else if (avail === total) {
    b.className = "sync-banner ok";
    b.innerHTML = `✓ All <strong>${total}</strong> images available.`;
  } else {
    b.className = "sync-banner wait";
    b.innerHTML = `⏳ <strong>${avail}/${total}</strong> images available — the rest are still replicating to the download mirror and will appear once synced. <span class="muted">This page rechecks every 30s.</span>`;
  }
}

async function headCheck(url) {
  if (isLocal) return "available";               // sample manifest: assume present
  try {
    const r = await fetch(url, { method: "HEAD" });
    return r.ok ? "available" : "syncing";        // 200 = present, 404/403 = not yet
  } catch {
    return "syncing";                             // network/CORS hiccup → treat as not-yet
  }
}

// Concurrency-limited availability sweep over the given urls.
async function checkAll(urls) {
  const queue = [...urls];
  const worker = async () => { while (queue.length) { const u = queue.shift(); AVAIL.set(u, await headCheck(u)); } };
  await Promise.all(Array.from({ length: Math.min(HEAD_CONCURRENCY, queue.length) }, worker));
}

// Re-check anything not yet confirmed available; repaint; stop polling once all are up.
async function refresh() {
  const pending = IMAGES.map(urlFor).filter((u) => AVAIL.get(u) !== "available");
  if (pending.length) await checkAll(pending);
  paintActions();
  updateBanner();
  if (pollTimer && !IMAGES.map(urlFor).some((u) => AVAIL.get(u) !== "available")) {
    clearInterval(pollTimer); pollTimer = null;   // everything available → stop polling
  }
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
        const url = urlFor(im);
        const row = document.createElement("div");
        row.className = "dl";
        row.innerHTML = `<span class="label">${im.flavor}</span>
          <span class="right"><span class="size">${fmtSize(im.size)}</span>
          <span class="dl-action" data-url="${url}">${actionHTML(url)}</span></span>`;
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

function ensureBanner() {
  if ($("sync-banner")) return;
  const main = document.querySelector("main.wrap") || document.body;
  const b = document.createElement("div");
  b.id = "sync-banner";
  b.className = "sync-banner";
  main.insertBefore(b, main.firstChild);
}

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
  ensureBanner();
  render();
  updateBanner();
  refresh();                                   // kick the first availability sweep
  pollTimer = setInterval(refresh, POLL_MS);   // then re-check syncing images periodically
}

function fail() {
  const s = $("status");
  s.className = "status error";
  s.innerHTML = `No images available yet, or the image list couldn't be loaded. See the <a href="https://github.com/gjrtimmer/ubuntu-rockchip">project on GitHub</a>.`;
}

(async () => {
  try {
    const res = await fetch(isLocal ? "./sample-manifest.json" : MANIFEST_URL, { redirect: "follow" });
    if (!res.ok) throw new Error(res.status);
    init(await res.json());
  } catch (e) { fail(); }
})();
