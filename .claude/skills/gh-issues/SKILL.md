---
name: gh-issues
description: Batch issue-to-PR automation for ubuntu-rockchip — fetch GitHub issues, pick candidates, spawn background fix workers, open PRs, and optionally process PR review comments. For a single issue end-to-end, prefer the fix-issue skill.
user-invocable: true
---
# gh-issues

Batch issue-to-PR automation. Use `gh` CLI; fall back to `gh api` only when a
high-level command lacks a needed field. For deep work on **one** issue, use the
`fix-issue` skill — this skill is the multi-issue / watch driver and hands each
issue to a background worker.

> This is the repo's own adapted copy of the openclaw `gh-issues` skill. The
> devcontainer bootstrap (`scripts/init-claude.sh`) **skips** installing the
> upstream openclaw version so this repo-tuned one is canonical (no shadowing).

This repo is **GitHub-only** (`gjrtimmer/ubuntu-rockchip`, upstream
`Joshua-Riek/ubuntu-rockchip`) and **has no unit tests**; worker "verification"
means dispatching the `build.yml` CI pipeline (build is root + arm64, not runnable
locally). See `CLAUDE.md`.

## Tooling (provisioned stack)

- `/caveman full` for terse output; keep raw `gh`/JSON out of main context.
- `ctx_batch_execute` to run the `gh` queries below and `ctx_search`/`ctx_execute`
  to parse them — never dump raw issue/PR JSON into context.
- `mcp__semble__search` inside workers for code location.
- Workers are spawned with the **`Agent` tool** (`run_in_background: true`) — Claude
  Code has no external `coding-agent`/message bus. (If `ruflo` orchestration is
  available you may drive the fan-out through it, but the Agent tool is the baseline.)

## Arguments

- positional `owner/repo`: optional; else infer from `git remote get-url origin`.
- `--label`, `--milestone`, `--assignee`, `--state` (default open), `--limit` (default 10): filters.
- `--fork <owner/repo>`: push branches to a fork, open the PR against the source.
- `--watch` / `--interval <minutes>` (default 5): poll issues + reviews.
- `--reviews-only`: skip issue fixing; handle PR reviews.
- `--dry-run`: list only. `--yes`: no confirmation. `--model <id>`: worker model.

## Phase 1: resolve repo

```bash
git remote get-url origin            # → gjrtimmer/ubuntu-rockchip (origin); upstream is Joshua-Riek
gh auth status                       # if not authenticated, stop and ask the user to `gh auth login`
gh repo view OWNER/REPO --json nameWithOwner,defaultBranchRef
```
Derived: `SOURCE_REPO` (issue repo) · `PUSH_REPO` (fork if `--fork`, else source) ·
`BASE_BRANCH` (default `main`) · `PUSH_REMOTE` (`fork` in fork mode, else `origin`).

Stop on a dirty worktree unless the user confirms workers should ignore uncommitted
changes. In fork mode, do not mutate remotes during `--dry-run` or before confirmation.

## Phase 2: fetch issues

```bash
gh issue list --repo "$SOURCE_REPO" --state open --limit 10 \
  --json number,title,labels,url,body,assignees,milestone
```
Add `--label`/`--milestone`/`--assignee`/`--state`/`--limit` as requested.
`gh issue list` already excludes PRs. None found → report no matches. `--dry-run` →
show a compact list and stop.

## Phase 3: avoid duplicate work

For each candidate:
```bash
gh pr list --repo "$SOURCE_REPO" --search "#<n>" --state open --json number,url,title,headRefName
gh pr list --repo "$SOURCE_REPO" --head "fix/<n>-" --state open --json number,url
git ls-remote --exit-code "$PUSH_REMOTE" "refs/heads/fix/<n>-*"
```
Skip candidates with an open PR, an existing `fix/<n>-*` branch, or an active claim.

Claim files (gitignored scratch, created if missing):
```text
.work/.gh-issues-claims/<owner>-<repo>-<n>.json
```
Expire claims older than 2 hours. Write before spawning a worker; remove/update
after the worker reports a PR or failure (prevents watch-mode overlap).

## Phase 4: confirm

Unless `--yes`, ask the user: `all` / comma-separated issue numbers / `cancel`. In
fork mode, after confirmation, set up the push remote:
```bash
gh auth setup-git
git remote get-url fork || git remote add fork "https://github.com/$PUSH_REPO.git"
git remote set-url fork "https://github.com/$PUSH_REPO.git"
git ls-remote --exit-code fork HEAD
```

## Phase 5: spawn workers

Launch background workers with the **`Agent` tool** (`run_in_background: true`), up
to ~8 concurrent, default `subagent_type: "general-purpose"` (or have the worker
follow the **`fix-issue`** skill for heavier issues). Write the claim file with the
current ISO timestamp before each spawn.

Each worker prompt MUST include the issue URL/title/body/labels, `SOURCE_REPO`,
`PUSH_REPO`, `BASE_BRANCH`, `PUSH_REMOTE`, fork mode, target branch
`fix/<n>-short-desc`, and:

```text
Repo: gjrtimmer/ubuntu-rockchip — Bash image-builder, NO unit tests, build is
root+arm64 (not runnable locally). See CLAUDE.md.

Use gh, git, ctx, and semble. Do not handwave.
Checkout/create fix/<n>-short-desc from BASE_BRANCH.
Implement the MINIMAL fix. Keep the rootfs board-independent: board-specific
  changes go in config/boards/<board>.sh hooks or scripts/, never baked into the
  rootfs build. Release vars are RELEASE_VERSION/RELEASE_NAME (corrected from upstream RELASE_*, #70).
Verify by dispatching CI: gh workflow run build.yml -f board=.. -f suite=.. -f flavor=..
  then poll the run; if the change is hardware-only, say so instead of claiming verified.
Commit with a Conventional Commits message + footer:
  Fixes SOURCE_REPO#<n>
  Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>
Push to PUSH_REMOTE.
Open a PR against SOURCE_REPO BASE_BRANCH. PR TITLE must be Conventional Commits
  (it becomes the squash commit on main; conventional-commits.yml validates it).
  PR body: Summary + Verification (CI run URL/conclusion) + Fixes SOURCE_REPO#<n>.
Report the PR URL or the failure reason.
```

## Phase 6: collect

Gather worker results (they return when their background task completes). Report per
issue: number + title, status (PR opened / skipped / failed / timed out), PR URL or
reason. Keep the final summary compact.

## Reviews-only / watch reviews

Discover open workflow PRs:
```bash
gh pr list --repo "$SOURCE_REPO" --state open --json number,title,url,headRefName,reviewDecision \
  --jq '[.[] | select(.headRefName | startswith("fix/"))]'
```
Fetch review threads/comments:
```bash
gh pr view <n> --repo "$SOURCE_REPO" --json url,headRefName,comments,reviews
gh api "repos/$SOURCE_REPO/pulls/<n>/comments"
```
Only process `fix/*` PRs created by this workflow unless the user names PR numbers.
Group actionable comments per PR; ignore praise/status/duplicates/already-addressed.
Spawn one background worker per scoped PR:
```text
Checkout the PR branch.
Read all actionable review comments.
Patch minimal changes. Re-verify via build.yml CI if behavior changed.
Commit and push normally; do NOT force-push unless explicitly told.
Reply to addressed comments with the fix + commit/file reference.
Report comments addressed/skipped and the proof.
```

## Watch mode

Loop: fetch issues → spawn eligible workers → process actionable PR reviews → sleep
`--interval` → stop when the user says stop. Keep the cumulative summary small.
