---
name: review-plan
description: >-
  Two-phase plan review: triage feedback against gates 1–4, apply only after user
  approval, then re-review against all five gates (Clarity primary post-update,
  including Resumability sub-lens for cold-start executable plans). Create from
  session: internal session synthesis while authoring, mandatory post-author review.
  Ask user on ambiguity (forks, scope, assumptions). Triggers: "review this plan",
  "check this plan against the gates", "triage this review feedback",
  "incorporate feedback into the plan", "update the plan based on the review",
  "create a plan from this session", "draft plan", "turn this into a plan".
---

# Review Plan

Triage plan feedback against quality gates; apply approved items; re-review. **Two-phase:** report first, edit only after explicit approval. Output must pass all gates and be cold-start implementable. Harness-agnostic — use host file/search/VCS tools.

**Load [reference.md](reference.md) on demand** — not whole-file at skill start. C1 → § Session synthesis; subroutine → § Cold-start implementable; steps 4/7 → report templates.

**Args:**

- **Review / Update:** `[plan-path-or-name] [-- feedback-path-or-text]` — first arg is an existing plan to read.
- **Create:** `[--output plan-path-or-name]` — session from conversation; optional `--output` sets write target (else Inputs table). Do **not** pass an existing plan path as the create target unless naming the output file.

Slash `/review-plan` equivalent when host supports it.

## Modes

Pick mode **before** any steps. If create vs review is ambiguous, ask.

| Mode | Signal | Flow |
| ---- | ------ | ---- |
| **Create from session** | Create triggers in description; intent is to **author** | C1 → C2 → subroutine → 7–8. Do **not** glob for an existing plan |
| **Update from session** | Plan exists + session adds scope or corrections | Review 1–8; session deltas → Feedback |
| **Review** | Plan exists; triage, standalone, or `--` feedback | 1–8, or 1 → subroutine → 7–8 |

## Quality Gates

1. **Accuracy** — Paths, lines, claims, PR/branch refs, quoted code match reality. Falsify negative claims; don't assume.
2. **Completeness** — Adjacent paths, sibling consumers, variant surfaces, legacy, downstream effects — in scope or explicitly out. Implementation steps missing a deterministic verify are Completeness findings (reference.md § Finding placement).
3. **Concision** — Short as possible with enough context. Drop restated history unless it changes execution. Token-efficiency anti-patterns: reference.md.
4. **Precision** — Smallest change set. No bundled refactors or unrelated todos.
5. **Clarity** — Top-to-bottom coherent: no stale steps, todo↔body match, valid frontmatter, execution order. Includes **Resumability** sub-lens: zero-context agent can execute without chat history (see `reference.md` § Cold-start implementable). **Primary post-update lens.**

| Phase | Gates |
| ----- | ----- |
| Triage feedback | 1–4 |
| Session synthesis (C1, internal) | 1–4 |
| Plan authoring (C2) | Resumability bake-in — reference.md § Session synthesis |
| Plan review subroutine | 1–5 (Clarity primary) |

## Execution-reliability lens (recommend-only)

Beyond gates 1–5, scan the plan for **deterministic procedure** — fixed checklists, ordered command sequences, exact format templates — that would run more reliably as a **script** (single source of truth, same result every run) than as prose re-followed each time. Surface it as a **Reliability** finding (recommend only); never expand scope yourself. Bound by **Precision** (gate 4 — don't bundle a refactor) and the **scope-expansion** Ambiguity trigger (ask before adding script work to the plan). Skip one-off, non-repeated steps — the win is repeated-run determinism, not token savings. Authoring conventions for any recommended script: repo-root `SCRIPTS.md`.

## Ambiguity Protocol

Silent guesses become hidden plan assumptions. **Stop and ask** when plan, feedback, session, or codebase can't answer — before triage row, finding, or edit. "Let the agent decide" is valid user answer; agent can't choose unilaterally.

| Trigger | Why |
| ------- | --- |
| **Forking decision** (A or B step/finding) | Plan = one path, not a tree. Clarity + Precision. |
| **System-relationship claim** (only caller, purely UI, etc.) | Verify blast radius. Accuracy + Completeness. |
| **Scope expansion** (files outside plan, "also fix") | User owns scope. Precision. |
| **Destructive simplification** (drop test, assertion, deprecation, doc comment) | Codebase asserts facts. User intent required. |
| **Embedded assumption** (flag state, rollout, env, future commit) | Surface; don't bake in. |

**How:** Batch all ambiguities in one structured round (multiple-choice tool if available). Offer obvious options + `Let the agent decide — pick simpler path, record in plan`. Cite plan section, feedback item, or session excerpt. Block report until answered. Clarification asks ≠ approval gates (steps 4, 7).

**Not ambiguity:** cheap verification (read line 44); repo agent docs already answer (`AGENTS.md`, `CLAUDE.md`, etc.); intentional deferred follow-ups in plan.

## Inputs

| Input | Resolve order | Modes |
| ----- | ------------- | ----- |
| **Plan** | arg → context (open/attached/named) → newest `**/*.plan.md` / `plans/**/*.md` / host plan store → ask | Review, Update |
| **Plan output path** | arg → context (named path) → `plans/<topic>.plan.md` under skill or project → ask | Create |
| **Session** | current conversation → attached transcript → prior chat summary → ask | Create |
| **Feedback** | path after `--` → inline message → prior agent output → session deltas (Update) → none (standalone) | Review, Update |

Confirm path + input source if ambiguous.

## Plan Invariants

Valid YAML frontmatter when present. Stable todo `id`s; valid status values. Don't touch protected metadata (`name`, `isProject`, etc.). Keep body order unless Clarity requires restructure. Review-mode: add cold-start sections only when findings require them. **C2:** bake-in per reference.md § Session synthesis.

## Workflow

### Review mode

Feedback supplied: steps 1–8. No feedback: step 1 → **Plan review subroutine** → steps 7–8.

1. **Read plan** — full file; parse frontmatter; stop on malformed YAML.
2. **Ingest feedback** — numbered items, verbatim quotes, split combined paragraphs. None → **Plan review subroutine**, then step 7.
3. **Triage (gates 1–4)** — per item: `approved` / `declined`, 1–2 sentences naming gate(s). Read cited code/plan before either verdict. Partial approve → scope in rationale. Apply Ambiguity Protocol first.
4. **Triage report → stop** — template in [reference.md](reference.md). Ask: apply all approved? (yes / no / subset). **No plan edits this turn.**
5. **Apply approved** — traceable to triage rows; respect invariants; re-parse YAML. New ambiguity → Ambiguity Protocol, pause.
6. **Plan review subroutine** — see below.
7. **Plan-review report → stop** — template in [reference.md](reference.md). Mode: Post-update review, Standalone review, or Post-author review (Create C2 only). Ask: apply changes? (yes / no / subset).
8. **Apply + confirm** — path updated; one-line per change; deferred/skipped items + why.

### Create from session

**C1. Session synthesis (internal)** — reference.md § Session synthesis (C1 table). Gates 1–4 on session only. Ambiguity Protocol on triggers. No files emitted; synthesis stays in context for C2. Resolve output path via Inputs.

**C2. Author plan** — Write plan; apply reference.md § Session synthesis (C2 bake-in). No session-only refs. Subroutine → step 7 (Mode: **Post-author review**) → step 8 on approval.

### Subroutine: Plan review (gates 1–5)

Used by standalone review, post-update review, and post-author review. **Never edit the plan in the same turn as emitting the plan-review report.**

1. Run `scripts/check-refs.py <plan>` to verify cited paths/lines; it is the single source of truth for link refs and feeds gate 1 (Accuracy). Only if you cannot execute it, read it as a spec and spot-check refs by hand (read/verify tier: execute-or-infer). Hand-check inline/prose path refs it does not parse; resolve PR/branch refs via VCS tools.
2. Falsify negative claims; flag `Unverified` when expensive.
3. Apply the Execution-reliability lens (above).
4. Apply **Resumability** sub-lens (`reference.md` § Cold-start implementable). If plan references `docs/plans/`, `docs/_plan/` (legacy), or `HANDOFF.md`, also run plan-build integration checks (reference.md).
5. Propose missing recommended sections as localized edits, not wholesale restructure. Ambiguity Protocol on findings.

## Anti-patterns

- Edit plan same turn as report.
- Skip triage when feedback exists; skip post-author review after C2.
- Enter Review when Create was requested (glob instead of C1→C2).

Extended list: [reference.md](reference.md).
