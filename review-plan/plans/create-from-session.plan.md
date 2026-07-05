---
name: review-plan create-from-session
overview: >-
  Extend review-plan with a Create-from-session mode: internal session synthesis
  (gates 1–4 + proactive Resumability) while authoring, mandatory post-author
  review (gates 1–5). Update-from-session keeps existing triage path.
todos:
  - id: skill-mode-router
    content: Add mode router, create-from-session workflow, and Plan review subroutine to SKILL.md
    status: completed
  - id: reference-session-synthesis
    content: Add Session Synthesis checklist and Post-author review mode to reference.md
    status: completed
  - id: reference-anti-patterns
    content: Add create-from-session anti-patterns to reference.md Extended Anti-patterns
    status: completed
  - id: fixtures-readme
    content: Document create-from-session dogfooding in fixtures/README.md
    status: completed
  - id: verify-skill
    content: Dogfood standalone review on updated SKILL.md via check-refs and manual gate scan
    status: completed
isProject: false
---

# Extend review-plan with Create-from-session

## Required reading

- [SKILL.md](../SKILL.md) — current workflow, gates, Ambiguity Protocol
- [reference.md](../reference.md) — report templates, Cold-start implementable, anti-patterns
- [fixtures/README.md](../fixtures/README.md) — existing dogfooding pattern

## Prerequisites

- Branch: any; env: N/A
- Locked decisions from grill-me session (authoritative spec — not chat-dependent):

| Topic | Decision |
| ----- | -------- |
| Session assessment (create) | Internal only — gates 1–4 on conversation, synthesized into plan while writing; **no** user-facing Session Assessment Report; **no** saved synthesis artifact |
| User validation loop | Mandatory post-author review — full gates 1–5, plan-review report, stop for approval, then apply (subroutine steps 6→7→8) |
| Ambiguity during create | Stop on Ambiguity Protocol triggers; do not pick forks unilaterally |
| Update existing plan | Triage path unchanged — session deltas as feedback → steps 1–8 |
| Resumability during create | Proactively bake cold-start sections while writing; post-author review still re-checks all gates |
| Documentation | Internal Session Synthesis checklist in `reference.md` (agent-only, not emitted or saved) |

## Out of scope

- Changes to `plan-build`, `grill-me`, or `orchestrate-build`
- Changes to `scripts/check-refs.py`
- New fixture plan files (optional follow-up)
- Root [README.md](../../README.md) lifecycle diagram (defer unless review finds Completeness gap)
- Symlink targets under `~/.cursor/skills/` (repo is source of truth per install docs)

## Step 1 — Update `SKILL.md` frontmatter and intro

**Action:** Extend `description` triggers and intro paragraph to cover three modes: Review, Create from session, Update from session.

Add triggers: `"create a plan from this session"`, `"draft plan"`, `"turn this into a plan"`.

Replace intro line that says "No feedback → generate honest self-feedback, then step 6" with mode router:

| Mode | When | Flow |
| ---- | ---- | ---- |
| **Review** | Plan exists; standalone or post-triage | Existing steps 1–8 or 1→6→7→8 |
| **Create from session** | No plan; session is source | C1→C2→6→7→8 |
| **Update from session** | Plan exists; session has deltas | Steps 1–8 (session → feedback) |

Add row to gates phase table (see Quality Gates section in [SKILL.md](../SKILL.md)).

Extend **Inputs** table: add **Session** row (current conversation → attached transcript → prior chat summary → ask) for Create mode; add **Plan output path** row; note **Feedback** applies to Review and Update modes only.

**Verify:** Read updated `description`, mode table, and Inputs table; confirm all three modes, phase rows, and Session input row present.

## Step 2 — Extract Plan review subroutine in `SKILL.md`

**Action:** Rename/refactor current step 6 into `## Subroutine: Plan review (gates 1–5)` with note: *Used by standalone review, post-update review, and post-author review. Never edit the plan in the same turn as emitting the plan-review report.*

Renumber workflow steps so Review mode references the subroutine by name. **Review mode routing:** feedback supplied → steps 1–8; no feedback → step 1 → Subroutine (Standalone review) → steps 7–8. Keep subroutine content identical to former step 6 (check-refs, falsify, reliability lens, Resumability, localized proposals).

**Verify:** Grep `SKILL.md` for `Subroutine: Plan review`; confirm Review mode standalone path is `1 → Subroutine → 7–8`.

## Step 3 — Add Create-from-session workflow in `SKILL.md`

**Action:** Add steps C1 and C2 before the subroutine:

**C1. Session synthesis (internal)** — Follow [reference.md § Session synthesis](../reference.md#session-synthesis) checklist. Apply gates 1–4 to session conversation; proactively bake Resumability (entry, load set, prerequisites, per-step verify, out of scope). Apply Ambiguity Protocol — **stop and ask** on triggers; do not emit or save a synthesis artifact. Resolve plan output path via Inputs table.

**C2. Author plan** — Write plan file respecting Plan Invariants. Encode resolved decisions; no session-only refs ("as discussed", "above approach"). **Plan Invariants exception:** proactively add Required reading / Prerequisites / Out of scope per reference.md § Session synthesis. Then invoke **Subroutine: Plan review** → plan-review report (Mode: Post-author review) → stop → apply on approval.

Add anti-patterns to `SKILL.md`:

- Skip post-author review after authoring ("I just wrote it").
- Save session synthesis as a separate file.
- Unilateral ambiguity resolution during create.

**Verify:** Trace create flow C1→C2→6→7→8 in `SKILL.md`; confirm no user stop between C1 and C2 except Ambiguity Protocol.

## Step 4 — Add Session Synthesis section to `reference.md`

**Action:** Add `## Session synthesis` section (read at create-from-session C1; **not** a user-facing report template). Update reference.md intro line to mention C1 read point. Include:

| Gate | Session lens |
| ---- | ------------ |
| Accuracy | Verify technical claims, paths, decisions against codebase/VCS |
| Completeness | Adjacent paths, verifies, prerequisites discussed but unresolved |
| Concision | Drop motivation-only session history from plan |
| Precision | Bound minimal scope; flag scope creep in chat |

Plus proactive Resumability bake-in checklist (mirror Cold-start implementable table — entry, load set, zero chat deps, prerequisites, per-step verify, out of scope, one path, link form).

Explicit: synthesis is internal; only the plan file is written to disk.

**Verify:** Grep `reference.md` for `## Session synthesis`; confirm table present and "not emitted" stated.

## Step 5 — Update plan-review report template in `reference.md`

**Action:** Change Mode line to:

`**Mode:** <Post-update review | Standalone review | Post-author review>`

Add note: Post-author review uses same gate checklist as Standalone; provenance differs.

**Verify:** Read Plan-Review Report Template; confirm three mode values.

## Step 6 — Extend Extended Anti-patterns in `reference.md`

**Action:** Add create-from-session failures:

- Skip post-author review after authoring.
- Emit or persist session synthesis as a file/report when user chose internal-only synthesis.
- Pick forks unilaterally during create (Ambiguity Protocol violation).
- Bake unresolved session A/B forks into plan body.

**Verify:** Grep Extended Anti-patterns for "post-author" and "session synthesis".

## Step 7 — Update `fixtures/README.md`

**Action:** Add entry for `plans/create-from-session.plan.md` — dogfood target for create-from-session + post-author review flow.

**Verify:** Read fixtures README; confirm both stub and create-from-session plans documented.

## Step 8 — Dogfood review on updated skill

**Action:** After all edits, run:

```bash
python3 review-plan/scripts/check-refs.py review-plan/SKILL.md
python3 review-plan/scripts/check-refs.py review-plan/reference.md
```

Run standalone `/review-plan` on `review-plan/SKILL.md` to confirm gates pass. Optionally re-run on this plan.

**Verify:** `check-refs.py` exits 0 on SKILL.md and reference.md; standalone review of SKILL.md produces no blocking findings.
