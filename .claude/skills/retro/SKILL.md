---
name: retro
description: Post-session retrospective — scan transcripts for mistakes, corrections, and missed instructions; turn them into durable rules (CLAUDE.md) and memories, audit existing memories, and improve skills + itself. Invoke after a session or anytime with "/retro".
user-invocable: true
---
# retro — Session Retrospective & Self-Improvement

Post-session analysis skill. Scans this project's session transcripts, **audits**
the auto-memory store, reads `CLAUDE.md` and the other skills for gaps — then
records findings in the **right durable place** and improves the relevant skill.

Invoke: **`/retro`** or **`/retro <session-id-prefix>`** (target one session).

## Two hard rules

1. **Route each finding to the correct durable store — don't dump everything in
   one place.** This environment has a first-class file-based auto-memory system;
   use it. Decide per finding:
   - **CLAUDE.md** — project-wide *working rules* for operating in this repo
     (build/verify workflow, commit conventions, build-system gotchas, issue
     workflow). Things every future session here must follow.
   - **Auto-memory file** (`…/memory/<slug>.md` + a `MEMORY.md` pointer line) —
     per the memory taxonomy: `user` (who the user is / prefs), `feedback`
     (how I should work, with **Why**/**How to apply**), `project` (ongoing
     goals/constraints), `reference` (external URLs/dashboards/tickets).
   Many retro findings are `feedback`-type — those belong in a memory file, not
   necessarily CLAUDE.md. **Creating a correctly-typed memory is expected here**
   (this is the opposite of the source repo's "CLAUDE.md only, never memory" rule —
   that rule does NOT apply in this environment).
2. **Scan the CURRENT session by default — one session per invocation.** Run this
   right after a session completes: capture that session's corrections, record
   them, improve this skill, commit the repo-tracked changes. The `--all`
   historical sweep is an opt-in backfill (see "Iteration Protocol").

## Paths (this environment)

- Session transcripts: `/home/ubuntu/.claude/projects/-home-ubuntu-work-ubuntu-rockchip/`
- Auto-memory store: `/home/ubuntu/.claude/projects/-home-ubuntu-work-ubuntu-rockchip/memory/`
  (files + the `MEMORY.md` index). **Memory files live OUTSIDE the repo and are
  not git-tracked** — creating/editing/deleting them is a filesystem op, not a commit.
- Project rules: `/home/ubuntu/work/ubuntu-rockchip/CLAUDE.md` (git-tracked).

## Skill Version

<!-- retro:version:17 -->
Track version here. Each self-improvement pass increments this counter and logs
what changed in the commit message. (v16 = adapted from the source repo to
ubuntu-rockchip: GitHub-only, repo paths, auto-memory respected, attribution
trailer kept. v17 = restored the provisioned `ctx`/`semble` tooling for
transcript analysis.)

## Tooling note

Provisioned by `scripts/init-claude.sh`:
- `ctx_execute` / `ctx_execute_file` for all transcript analysis — raw JSONL bytes
  never enter main context.
- `ctx_search` for recall of already-indexed findings.
- `mcp__semble__search` to verify a memory's referenced files/functions still exist.
- Only `Read` a file you intend to `Edit`. Subagents default to **sonnet**;
  escalate to **opus** only if the analysis genuinely needs it.

---

## Phase 0: Gather Session Data

### 0a. Determine scope

**Default = the current session only** — the conversation that just finished.
Do NOT batch-scan the whole history by default.
- No argument → analyze only the current session (use its corrections directly).
- Session-id prefix → analyze that one historical session.
- `--all` → opt-in full historical sweep (one session at a time).

### 0b. Extract correction signals

Run `ctx_execute` with JavaScript to scan the session JSONL files (raw bytes stay
out of main context). The scan must:
1. Read the `.jsonl` files from the project transcript dir (see Paths).
2. Parse each line; for `type: "user"` entries, extract `message.content[].text`.
3. Strip IDE/harness context tags (`<ide_*>`, `<system-reminder>`, `<task-notification>`, etc.).
4. Classify each correction using the pattern table (see "Detection Pattern Reference").
5. For each correction, also capture the **preceding assistant action** it corrected.
6. Return `{category, userMsg, assistantContext, sessionId, timestamp}` rows.

### 0c. Extract assistant errors

Also scan for: tool calls that returned errors; repeated identical tool calls
within 3 turns (thrashing); tasks that took >10 turns (inefficiency).

---

## Phase 1: Audit Existing Memories

Read every file in the memory store. For each:
1. **Staleness** — does it reference files/functions/flags that still exist?
   Verify with `mcp__semble__search`/`grep`. If the referent is gone, mark stale.
2. **Redundancy** — two memories saying the same thing, or a memory now fully
   covered by a CLAUDE.md rule → flag.
3. **Accuracy** — does it still match current CLAUDE.md / repo reality?
4. **Coverage** — compare Phase 0 corrections against existing memories: recurring
   corrections with no memory are gaps to fill (as new memories or CLAUDE.md rules).

Actions (NOT wholesale deletion):
- **Update** a memory whose content drifted.
- **Delete** only genuinely stale/wrong/duplicate memories (and remove their
  `MEMORY.md` pointer line).
- **Keep** accurate memories as-is.
- **Create** a new correctly-typed memory for an uncovered durable finding.

Produce an audit report:
```
KEEP:    <slug> — still accurate
UPDATE:  <slug> — <what drifted>
DELETE:  <slug> — stale/duplicate/wrong (+ remove MEMORY.md line)
CREATE:  <slug> (<type>) — <new finding to capture>
```

---

## Phase 2: Analyze Rules & Skills

### 2a. CLAUDE.md / memory gap analysis
For each correction category with 2+ occurrences and no matching durable rule:
draft the rule and decide its home (CLAUDE.md working-rule vs. `feedback` memory).
For corrections that DO have a matching rule but keep recurring: the rule isn't
prominent/specific enough — draft a strengthened version with an example.

### 2b. Skill gap analysis
For each project skill (`.claude/skills/*/SKILL.md` and `.claude/agents/*.md`):
are there corrections tied to that skill's workflow (e.g. fix-issue gate
violations → strengthen its gate language)? Draft targeted edits.

### 2c. Self-analysis (this skill)
Compare retro's detection patterns against what it found vs. missed. Add/refine
patterns, add noise filters, bump the version counter.

---

## Phase 3: Present Findings

**Always present findings to the user before making any changes.**

```markdown
## Retro Report — [date] ([N] session(s) analyzed)

### Corrections Found
| # | Category | Session | User said | What went wrong |
|---|----------|---------|-----------|-----------------|

### Memory Audit
- KEEP / UPDATE / DELETE / CREATE (per Phase 1)

### Proposed Changes
1. New CLAUDE.md rule: [section] — [text]
2. Update CLAUDE.md rule: [section] — [strengthened text]
3. New memory: [slug] ([type]) — [content]
4. Update/Delete memory: [slug] — [why]
5. Update skill/agent: [name] — [change]
6. Update retro skill: [self-change]

### Skipped (noise)
[false positives / already addressed]
```

**Gate**: Wait for user approval. The user may select a subset (`apply 1,3,5`) or
`apply all`.

---

## Phase 4: Apply Changes

### 4a. CLAUDE.md (project working rules)
Read the target section; add/strengthen rules with minimal targeted edits. Match
the existing imperative, concise style. Pick the right section; don't invent one
unless none fits.

### 4b. Memory store (create / update / delete — by type)
- **Create**: write `…/memory/<slug>.md` with the required frontmatter
  (`name`, `description`, `metadata.type`); for `feedback`/`project` include
  **Why** and **How to apply**; add a one-line pointer to `MEMORY.md`.
- **Update**: edit the file in place.
- **Delete**: `rm` the file and remove its `MEMORY.md` pointer line.
- These are filesystem ops outside git — not part of the commit.

### 4c. Skill / agent changes
Read then Edit the target file. For self-updates, bump the version counter.

### 4d. Commit (repo-tracked changes only)
```bash
git add -A .claude/ CLAUDE.md
git commit -m "chore(retro): <session-id> findings, skill vN→vN+1

- [findings applied to CLAUDE.md]
- [skill/agent improvements]

Co-Authored-By: Claude Opus 4.8 (1M context) <noreply@anthropic.com>"
```
Commit rules:
- **Conventional Commits** (`chore(retro): …`) — and if this lands on `main` via a
  PR, the PR title must be conventional too.
- **Keep the `Co-Authored-By` trailer** — this repo uses AI attribution (verify in
  `git log`). Do NOT strip it.
- No CI-skip marker needed: doc/skill commits don't trigger this repo's manual
  `build.yml` pipeline. (Do not paste `[ci skip]` into commit messages here.)
- If currently on `main`, branch first (`chore/retro-<session>`), then PR — per the
  repo's branch-first convention.

---

## Phase 5: Verify

1. Every approved CLAUDE.md rule actually landed, with valid markdown.
2. Memory store reflects the audit (creates/updates/deletes done; `MEMORY.md`
   pointers consistent with the files present).
3. Skill/agent files have valid frontmatter; retro's version counter bumped.
4. Report a compact summary of what was applied.

---

## Iteration Protocol

### Normal mode — current session only (the standing rule)
Scan only the session that just finished, record findings in the right place,
improve this skill if a pattern was missed, commit repo changes. Re-invoke
`/retro` fresh next time — one invocation = one session, loaded fresh so the
just-improved version reads the next session.

**Re-invokable within a session — idempotent.** Can run many times in one session;
every run dedups against current CLAUDE.md + memory and applies only new findings.
A run that finds nothing new makes no changes and no commit — reports "0 new findings."

### One-time backfill — `--all` (not recurring)
Exists only to seed the initial rule/memory set: list sessions oldest-first, scan
each once, fold every NEW lesson into its right home, commit. Then stop.

---

## Detection Pattern Reference

Regex patterns used to classify user corrections. Phase 2c may add/refine entries.

<!-- retro:patterns:start -->
```javascript
const PATTERNS = {
  workflow_order: [
    /\bwait\s+(for|till|until)\b/i, /\bstop\b/i, /\bnot yet\b/i,
    /\bhold\b/i, /\bdo not.*yet\b/i, /\bbefore I\b/i, /\btill I\b/i,
    /\blet me\b.*\bfirst\b/i, /\bpause\b/i,
    /\bdo not\s+(start|create|push|merge)\b/i
  ],
  tool_misuse: [
    /\byou\b.*\binstead\b/i, /\bshould.*use\b/i, /\bwrong\b/i,
    /\bdon'?t use\b/i, /\bnot\s+correct\b/i,
    /\bdoes not seem\b/i, /\bnot.*right\b/i
  ],
  scope_drift: [
    /\bnot what I\b/i, /\bI said\b/i, /\bI didn'?t say\b/i,
    /\bI asked\b/i, /\bnot what I asked\b/i, /\bthat'?s not what\b/i,
    /\bI did not say\b/i, /\bI meant\b/i, /\byou added.*not.*ask/i,
    /\bnot.*respect.*what I\b/i,
    /\bjust\s+continue\b.*\b(on|this|one)\b/i, /\bONLY\s+#?\d/i
  ],
  rule_violation: [
    /\balready told\b/i, /\bwe agreed\b/i,
    /\bwe said\b/i, /\bdon'?t.*again\b/i,
    /\bmake this a rule\b/i, /\byou include.*auto.*generat/i
  ],
  missed_instruction: [
    /\bforgot\b/i, /\bshould have\b/i,
    /\byou need to\b/i, /\bwas supposed to\b/i,
    /\bdo not forget\b/i, /\bensure that\b.*\bshould\b/i,
    /\bensure.*all\b/i, /\bcover all\b/i, /\bat least cover\b/i,
    /\bhave you (updated|checked|done|added|posted)\b/i,
    /\bdid you (update|check|do|add|post)\b/i
  ],
  unrequested_addition: [
    /\bwhy\s+(is|was)\s+this\s+added\b/i, /\bshould not have been added\b/i,
    /\bnot\s+asked\s+for\b/i, /\bwho\s+asked\b/i,
    /\bI\s+didn'?t\s+(ask|request)\b/i
  ],
  premature_action: [
    /\bdo not\s+start\b/i, /\bjust\s+(analyze|plan|check)\b/i,
    /\bprepare.*don'?t\b/i, /\banalyze.*not.*implement\b/i,
    /\bplan.*wait\b/i, /\bpresent.*wait\b/i
  ],
  cost_concern: [
    /\bcheaper\b/i, /\bwaste.*token/i, /\bsubagent.*model\b/i,
    /\btoo.*expensive\b/i
  ],
  pipeline_abort: [
    /\bif.*not.*green.*(stop|abort)\b/i, /\bstop and abort\b/i,
    /\bif\b.*\bfail\b.*\b(stop|diagnose|abort)\b/i,
    /\babort\b.*\b(release|tag|pipeline)\b/i
  ],
  positive_signal: [
    /\byes exactly\b/i, /\bperfect\b/i, /\bgood\b.*\bapproach\b/i,
    /\bcorrect\b/i, /\bthat'?s right\b/i,
    /\byes,?\s*(go|do|proceed|continue)\b/i, /\bapproved\b/i
  ],
  preference_signal: [
    /\bmight be better\b/i, /\bprefer\b.*\b(to|if|that)\b/i,
    /\bshould we\b/i, /\bwhat if we\b/i, /\bwhat about\b/i,
    /\blet'?s\s+(try|do|use|go with)\b/i, /\bcan we\b.*\binstead\b/i
  ],
  workaround_before_fix: [
    /\bdo we need\b.*\bretry\b/i, /\binstead of.*\bactual fix\b/i,
    /\banalyse?\b.*\bbefore\b.*\b(timing|retry|sleep|delay)\b/i,
    /\broot cause\b.*\bnot\b.*\bworkaround\b/i,
    /\bfix\b.*\bnot\b.*\b(retry|sleep|mask)\b/i,
    /\bactual\s+(fix|cause|bug)\b/i
  ],
  frustration: [
    /\bidiot\b/i, /\bmoron\b/i, /\bstupid\b/i, /\bdumb\b/i,
    /\bwtf\b/i, /\bffs\b/i, /\bfor f.ck.? sake\b/i,
    /\bf.cking\b/i, /\bgod ?damn\b/i
  ]
};
```
<!-- retro:patterns:end -->

---

## Noise Filters

Skip messages that match a pattern but are NOT user feedback:
- Inside `<task-notification>`, `<system-reminder>`, or `<local-command-caveat>` tags.
- Quoting external content (issue bodies, PR comments, CI logs).
- Shorter than 10 chars after tag stripping.
- Bare approvals ("yes" / "go" / "continue").
- References to upstream/fork issues (describing external bugs, not correcting me).
- Session-resume context ("This session is being continued from a previous").
- Skill-loading preambles ("Base directory for this skill:" / "Launching skill:").
- Code-context "wait" (e.g. `void(wait(`).
- Terminal-output pastes (lines starting with `$` / `ubuntu@` / `+ `).
- "I will wait" / "waiting for X to be merged" — patience/context, not a correction.
- Bare `\bnever\b` in instructional context (CLAUDE.md rules inject "never" into
  context → false positives; require `already told` / `make this a rule`).
- "do not X yet" / "do not push/start" without frustration markers ("I said",
  "already told", "again", "!") — a proactive gate, not a correction.

---

## Self-Improvement Protocol

When updating itself (Phase 2c):
1. Scope: detection patterns, noise filters, ambiguous phase instructions, new
   categories.
2. Never remove core phases (0–5) or the Phase 3 gate.
3. Never revert the memory-routing model (CLAUDE.md AND typed memories) — this
   environment uses auto-memory.
4. Always bump the version counter; log the change in the commit body.

---

## TodoWrite Checklist

Create on invocation (normal mode = current session only):
1. Scan the CURRENT session transcript — extract corrections + errors
2. Audit auto-memories — keep/update/delete/create (by type)
3. Analyze CLAUDE.md rules — gaps, weak rules
4. Analyze skills/agents — workflow gaps, missed gates
5. Self-analyze — pattern gaps, false positives
6. Present findings report — get user approval (Gate)
7. Apply approved changes — CLAUDE.md + memories + skill improvements
8. Commit repo-tracked changes (`.claude/` + CLAUDE.md) with Co-Authored-By trailer
9. Verify — rules landed, memory store consistent, valid markdown, version bumped

(`--all` backfill only: loop the above over every session once, then stop.)
