---
name: fix-issue
description: End-to-end workflow for fixing a GitHub issue in ubuntu-rockchip — triage, plan, implement, verify via CI, ship. Invoke with "Fix Issue #NR".
user-invocable: true
---
# fix-issue

Fix a GitHub issue end-to-end for **gjrtimmer/ubuntu-rockchip**. Invoke: **"Fix Issue #NR"**.

This repo builds Ubuntu images for Rockchip boards (see `CLAUDE.md`). It is
**Bash + declarative shell-config + Debian packaging — no application code and no
unit tests.** The build runs as root on arm64 and is **not runnable on a dev box**,
so "verification" means dispatching the CI build and reading its result, not
running a local test suite.

## Optional skill activation

If these superpowers skills are installed, they help here (skip silently if not):
- `superpowers:brainstorming` — when the fix approach is non-obvious.
- `superpowers:systematic-debugging` — when the root cause is unclear.
- `superpowers:verification-before-completion` — before marking done.

## Context discipline (MANDATORY)

The main context is the **orchestrator**: it delegates, synthesizes, and decides.
It does NOT do bulk reading.

| Want to… | Use this | NOT this |
|----------|----------|----------|
| Locate code / find root cause | `Agent` subagent, `subagent_type: "Explore"` | Grep + Read in main context |
| Make 1–2 file surgical edits in parallel | `Agent` subagent, `subagent_type: "general-purpose"` | inline editing of many files |
| Run verbose `gh`/wiki commands | `Agent` subagent, `subagent_type: "vcs-cli"` | raw JSON in main context |
| Read a file you are about to Edit | `Read` then `Edit` | a subagent (it can't carry the edit) |

- Subagents MUST return **structured findings only** — `file:line` references and
  short summaries, never file contents.
- Default subagent model: **sonnet**. Escalate to **opus** only when sonnet can't
  determine root cause or the reasoning is genuinely hard.
- Each phase produces a compact artifact (summary, plan, result). Only that
  artifact carries forward; raw investigation stays inside the subagent.

## Issue communication

**Every phase posts a status comment on the GitHub issue** (`gh issue comment NR
-R gjrtimmer/ubuntu-rockchip --body "…"`). This creates a public audit trail.
Delegate the actual `gh` calls to the `vcs-cli` agent to keep output compact.

| Phase | Comment content |
|-------|----------------|
| 0 Triage | "Triaging — confirmed actionable, no existing PR/branch" |
| 1 Plan | Full implementation plan (root cause, files, affected boards/suites, risks) |
| 2 Implement | "Implementation started on branch `fix/NR-short-desc`" |
| 3 Verify | CI dispatch result (`build.yml`: board/suite/flavor → success/failure + run URL) |
| 4 Ship | Full resolution comment (commits, files, root cause, CI evidence) |
| 5 Upstream | Comment on related open upstream/fork issues (if applicable) |

Failure comments matter just as much — if a phase fails, post what failed and the
fix approach. Silence on an issue = abandoned work.

---

## Phase 0: Triage

Fetch the issue + check for prior work (delegate to `vcs-cli`):

```bash
gh issue view NR -R gjrtimmer/ubuntu-rockchip --json number,title,body,labels,comments,assignees
gh pr list   -R gjrtimmer/ubuntu-rockchip --search "#NR" --state open --json number,url,headRefName
git branch -a | grep -i "NR"
```

**Gate**: If a PR exists or the issue is already fixed → STOP and report. Note any
upstream (`Joshua-Riek/ubuntu-rockchip`) or fork references for Phase 5.

## Phase 1: Investigate & Plan

### 1a. Investigation (Explore subagent — sonnet)

Spawn an `Explore` subagent with:
- The issue title + body (from the Phase 0 artifact).
- Label/text-derived search areas. Map the symptom to the build layer:
  - board-specific (one board misbehaves) → `config/boards/<board>.sh` + its hooks
  - firmware/wifi/bt/audio runtime → `overlay/` + `config_image_hook__<board>`
  - partitioning / bootloader / dtb / extlinux → `build_image_hook__<board>` + `scripts/build-image.sh`
  - kernel → `scripts/build-kernel.sh` (pinned `Joshua-Riek/linux-rockchip`)
  - u-boot → `packages/u-boot-*/` debian overlay + `scripts/build-u-boot.sh`
  - rootfs / suite-wide → `scripts/build-rootfs.sh`, `config/suites/<suite>.sh`

The subagent returns ONLY:
```
Root cause: <1-2 sentences>
Files: <path:line list>
Boards/suites/flavors affected: <list, or "all">
New behavior needed: <what>
Risk: <what could break across the matrix>
```

If sonnet can't determine the root cause → re-run at **opus**.

### 1b. Plan & post

Synthesize into a plan and post it on the issue (via `vcs-cli`). The plan covers:
root cause, files to change, which board/suite/flavor it affects, the CI matrix
slice you'll verify, and risks.

**Gate**: Ask the user for "go". A "go" approves the presented plan. If execution
reveals a material scope change → stop and re-confirm.

## Phase 2: Branch & Implement

### Branch naming
`fix/{NR}-{short-desc}` — kebab-case from the issue title, max 40 chars.
```bash
git checkout -b fix/NR-short-desc main
```
Post the "work started" comment on the issue.

### Implementation rules (this build system)
- **Minimal change. No scope creep.**
- Keep the **rootfs board-independent**: board-specific firmware/drivers/services
  go in `config_image_hook__<board>` (chroot) or `build_image_hook__<board>`
  (image), never baked into the rootfs build. (See `CLAUDE.md` → "the two board hooks".)
- **Never "fix" the `RELASE_VERSION` / `RELASE_NAME` misspelling** — it's load-bearing.
- Don't hand-edit committed upstream blobs (`packages/u-boot-*/rkbin/*`); pin via
  the `debian/upstream`/`patches/` overlay instead.
- Only `Read` files you are about to `Edit`. For independent multi-file edits, use
  parallel `general-purpose` subagents (sonnet).
- If you add a board, mirror the structure of an existing `config/boards/*.sh`
  (metadata + `UBOOT_PACKAGE`/`UBOOT_RULES_TARGET` + `COMPATIBLE_*` + hooks).

## Phase 3: Verify via CI

There is no local build and no test matrix. Verify by dispatching the reference
pipeline for the affected slice and reading the result (delegate to `vcs-cli`):

```bash
gh workflow run build.yml -R gjrtimmer/ubuntu-rockchip \
  -f board=<affected-board> -f suite=<suite> -f flavor=<flavor>
# poll until completed, then report conclusion + run URL
gh run list -R gjrtimmer/ubuntu-rockchip --workflow=build.yml --limit 1 \
  --json databaseId,status,conclusion,headBranch
```

- For a config/script-only change you can reason about, a single representative
  board/suite/flavor dispatch is enough; for matrix-wide changes, dispatch the
  most-affected slice and say so explicitly.
- On failure: `gh run view <id> --log-failed`, find the failing step, fix, re-dispatch.
- **Gate**: CI green required before shipping. Never ship on a red or unreviewed run.
- Post the CI result (conclusion + run URL) on the issue.

> If the change is unverifiable via CI (e.g. needs physical hardware to confirm a
> wifi/audio fix), say so plainly in the comment and mark it "needs hardware
> validation" rather than claiming it's verified.

## Phase 4: Commit & Ship

### 4a. Commit (ask first)
**Ask the user for confirmation before committing.** Show the diff summary and the
proposed message. Conventional Commits, with a `Fixes #NR` footer and the repo's
attribution trailer:
```bash
git add <specific files>
git commit -m "fix(scope): description

Fixes #NR

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```

### 4b. Evidence comment on the issue
Post resolution details (via `vcs-cli`): commits, files changed, root cause, fix
summary, and the CI run URL/conclusion as evidence.

### 4c. Push & PR (ask first)
**Ask the user for confirmation before pushing.**
```bash
git push -u origin fix/NR-short-desc
```
Create the PR against `main` (delegate to `vcs-cli`). The **PR title must be
Conventional Commits** — it becomes the squash commit on `main` and is validated
by `conventional-commits.yml`:
```bash
gh pr create -R gjrtimmer/ubuntu-rockchip --base main --head fix/NR-short-desc \
  --title "fix(scope): description" \
  --body "$(cat <<'PR_EOF'
## Summary
- <what and why>

## Verification
- build.yml dispatched for <board>/<suite>/<flavor> → <conclusion> (<run URL>)

Fixes #NR
PR_EOF
)"
gh pr merge <n> -R gjrtimmer/ubuntu-rockchip --squash --auto   # let required checks gate the merge
```
Never force-merge or merge while required checks are pending.

## Phase 5: Upstream & Fork Notification

This issue may relate to issues on the upstream repo (`Joshua-Riek/ubuntu-rockchip`)
or on forks in the network. The fork-analysis is tracked in **GitHub Project #6
"Ubuntu RockChip"** and on the wiki
([Fork Analysis Overview](https://github.com/gjrtimmer/ubuntu-rockchip/wiki/Fork-Analysis-Overview)).

### 5a. Discover related issues
1. Parse the issue body for references: `owner/repo#XX`, full GitHub URLs, `#XX`.
2. Check the wiki Fork-Analysis pages and Project #6 for the cluster this issue
   belongs to.

### 5b. Notify open issues only
For each **open** issue on the upstream/fork repo:
```bash
gh issue view XX -R owner/ubuntu-rockchip --json state -q '.state'   # must be OPEN
gh issue comment XX -R owner/ubuntu-rockchip --body "$(cat <<'UP_EOF'
Addressed in the [gjrtimmer/ubuntu-rockchip](https://github.com/gjrtimmer/ubuntu-rockchip) fork:

- **Issue**: gjrtimmer/ubuntu-rockchip#NR
- **Commit**: [`<hash>`](https://github.com/gjrtimmer/ubuntu-rockchip/commit/<hash>)
- **Fix**: <one-line summary>
- **CI**: build.yml <board>/<suite>/<flavor> → success (<run URL>)
UP_EOF
)"
```
- **Skip closed issues** — do not comment on them.
- If the fix consolidates work from multiple forks, say so.

## TodoWrite Checklist

Create on invocation:
1. Triage issue #NR — post triage status on the issue
2. Investigate root cause (Explore subagent)
3. Post implementation plan on the issue, get user approval
4. Create branch `fix/NR-short-desc` from main + post "work started"
5. Implement the fix (board hooks / scripts / packages — keep rootfs board-agnostic)
6. Verify via CI — dispatch build.yml for the affected slice, post the result
7. Commit with `Fixes #NR` + Co-Authored-By trailer (ask first)
8. Post resolution/evidence comment on the issue
9. Push branch + create PR (ask first)
10. Upstream/fork notification (if applicable)
