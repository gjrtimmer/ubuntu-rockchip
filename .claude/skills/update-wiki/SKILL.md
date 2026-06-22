---
name: update-wiki
description: Create, update, or regenerate the gjrtimmer/ubuntu-rockchip GitHub wiki. Use when build scripts, config schema, CI workflows, U-Boot packages, overlay, or the .work fork-analysis change and the wiki is now stale; or to add/restructure wiki pages. Validates links and pushes. Invoke with "/update-wiki".
user-invocable: true
---
# update-wiki

Maintain the project's GitHub wiki for **gjrtimmer/ubuntu-rockchip**. Invoke: **`/update-wiki`** (optionally name what changed, e.g. `/update-wiki build-rootfs.sh changed`).

The wiki is the **published home** for the docs. It has **30 content pages in 6 categories** plus `Home.md`, `_Sidebar.md`, `_Footer.md`. It lives in a **separate git repo** from the code: `https://github.com/gjrtimmer/ubuntu-rockchip.wiki.git` (branch `master`). Editing the code repo does **not** touch the wiki — you must clone the wiki repo, edit, and push it.

This repo is Bash + declarative shell-config + Debian packaging (see `CLAUDE.md`); the wiki documents that build system and the fork-network analysis.

## Procedure

1. **Clone the wiki** to a scratch dir and set identity:
   ```bash
   cd /tmp && rm -rf wiki_clone
   git clone https://github.com/gjrtimmer/ubuntu-rockchip.wiki.git wiki_clone
   cd wiki_clone && git config user.name gjrtimmer && git config user.email gjrtimmer@users.noreply.github.com
   ```
2. **Find what changed** in the code repo (`git log`/`git diff` since the wiki's last update) and map each changed source file to its page(s) using the table below. Read the *current* source files — never document from memory.
3. **Edit the matching page(s)** in `/tmp/wiki_clone/<Page-Title>.md`. Keep prose grounded only in the source files. If you **add / remove / rename** a page, also update `_Sidebar.md`, `Home.md`, and any `## See also` links that reference it.
4. **Validate** before committing (see Validation). Fix every broken link and missing H1.
5. **Commit + push** with a conventional `docs:` message:
   ```bash
   cd /tmp/wiki_clone && git add -A
   git commit -m "docs: <what changed>

   Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
   git push origin master
   ```

For a **full rebuild** (many pages at once), drive it with a Workflow: cheapest agents (haiku) draft the reference pages from verified facts + source paths, sonnet drafts the synthesis keystones, then a sonnet QA pass per page verifies facts against the sources and fixes links. Pages are written to `/tmp/wiki_clone/<Page>.md`; you author `Home`/`_Sidebar`/`_Footer`.

## Source → page map

When you touch the left, update the right.

| Changed source | Wiki page(s) |
|----------------|--------------|
| `README.md` | Installation · First Boot and Login · FAQ and Troubleshooting · Glossary |
| `build.sh` | Build System Overview · Build Script Reference · Build Prerequisites |
| `scripts/build-kernel.sh` | Building the Kernel · Build System Overview |
| `scripts/build-u-boot.sh` | Building U-Boot · Build System Overview |
| `scripts/build-rootfs.sh` | Building the Root Filesystem · Image Flavors · Build System Overview |
| `scripts/config-image.sh` | Image Assembly and Partitioning · Board Configuration · Build System Overview |
| `scripts/build-image.sh` | Image Assembly and Partitioning · Image Flavors · Board Configuration · Building U-Boot |
| `config/boards/*.sh` | Supported Boards · Board Configuration |
| `config/suites/*.sh` | Ubuntu Suites · Building the Kernel |
| `config/flavors/*.sh` | Image Flavors |
| `packages/*` (U-Boot) | U-Boot Packages · Building U-Boot |
| `overlay/*` | Overlay Files |
| `.github/workflows/*` | GitHub Actions Workflows · Release Process · Build Prerequisites |
| `.github/workflows/conventional-commits.yml`, `cliff.toml`, `CHANGELOG.md` | Conventional Commits and Changelog · Release Process |
| `.github/ISSUE_TEMPLATE/*` | Contributing |
| repo structure / new top-level dirs | Repository Layout |
| `.work/FORKS_RESULT.md` | Fix Clusters · Feature Clusters · Board Support Clusters · Port Roadmap and Priorities |
| `.work/FORKS.md`, `baseline.md`, `CLAUDE_CONFIGS_REPORT.md`, `fork_value_table.md`, `FORKS_REPORT.md`, `findings/*.md` | Fork Analysis Overview · Fork and Upstream Relationship · Upstream Issue Tracking |
| `.work/ISSUE_MAP.md`, `newissues/*.md` | Issue Tracker and Project Board · Upstream Issue Tracking |

Categories (sidebar order): **Getting Started** · **Build System** · **Configuration Reference** · **CI/CD & Release** · **Project & Contributing** · **Fork Network Analysis**.

## Page & link rules

- Each page starts with a single `# <Page Title>` H1 then a 1–2 sentence summary, and ends with `## See also` (2–5 links).
- File name = page title with spaces → hyphens (`Board Configuration` → `Board-Configuration.md`).
- Cross-link with **plain** `[[Page Title]]` only — **no** `|alias` or `#anchor` forms (GitHub wiki resolves them unreliably). Only link to titles that have a real `.md` file.

## Validation (run before push)

```bash
cd /tmp/wiki_clone
python3 - <<'PY'
import re, glob, os
valid = {os.path.basename(f)[:-3] for f in glob.glob("*.md")}
tok = re.compile(r"\[\[([^\]]+)\]\]")
bad = 0
for p in glob.glob("*.md"):
    txt = open(p, encoding="utf-8").read()
    for m in tok.finditer(txt):
        side = m.group(1).replace("\\|","|").split("|")[0].split("#")[0].strip().replace(" ","-")
        if side not in valid:
            print("BROKEN", p, m.group(1)); bad += 1
    if p not in ("_Sidebar.md","_Footer.md"):
        first = next((l for l in txt.splitlines() if l.strip()), "")
        if not first.startswith("# "):
            print("NO H1", p)
print("broken links:", bad)
PY
```

## Conventions & guardrails

- **Never publish secrets**: no passwords, tokens, private emails, or PII — refer to such things generically (e.g. "contains hardcoded passwords that must be removed before porting"). GitHub usernames as contribution attribution are fine. (Org policy: privacy/security first.)
- The `.work` corpus is **gitignored local scratch**; the wiki is its published home. Don't assume readers can see `.work`.
- Use `RELEASE_VERSION` / `RELEASE_NAME` (corrected from upstream's `RELASE_*` misspelling in #70).
- Keep the rootfs-is-board-independent framing: board specifics live in `config_image_hook__` / `build_image_hook__`, never in the shared rootfs.
- Verification of the build itself is "dispatch CI and read the result," not local runs (root + arm64 only) — see `CLAUDE.md` and the `fix-issue` skill.
