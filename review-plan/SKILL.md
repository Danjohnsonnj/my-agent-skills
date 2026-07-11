---
name: review-plan
description: >-
  Two-phase plan review: triage feedback against gates 1–4, apply only after user
  approval, then re-review against all five gates (Clarity primary post-update,
  including Resumability sub-lens for cold-start executable plans). Ask user on
  ambiguity (forks, scope, assumptions). No feedback → standalone review. Triggers:
  "review this plan", "check this plan against the gates", "triage this review
  feedback", "incorporate feedback into the plan", "update the plan based on the review".
---

# Review Plan

Triage plan feedback against quality gates; apply approved items; re-review. **Two-phase:** report first, edit only after explicit approval. No feedback → generate honest self-feedback, then step 6. Output must pass all gates and be cold-start implementable. Harness-agnostic — use host file/search/VCS tools. Preserve plan format; may add minimal cold-start sections when findings require them (see Plan Invariants).

**Args:** `[plan-path-or-name] [-- feedback-path-or-text]`. Slash `/review-plan` equivalent when host supports it.

## Quality Gates

1. **Accuracy** — Paths, lines, claims, PR/branch refs, quoted code match reality. Falsify negative claims; don't assume.
2. **Completeness** — Adjacent paths, sibling consumers, variant surfaces, legacy, downstream effects — in scope or explicitly out. Implementation steps missing a deterministic verify are Completeness findings (reference.md § Finding placement).
3. **Concision** — Short as possible with enough context. Drop restated history unless it changes execution. Token-efficiency anti-patterns: reference.md.
4. **Precision** — Smallest change set. No bundled refactors or unrelated todos.
5. **Clarity** — Top-to-bottom coherent: no stale steps, todo↔body match, valid frontmatter, execution order. Includes **Resumability** sub-lens: zero-context agent can execute without chat history (see `reference.md` § Cold-start implementable). **Primary post-update lens.**

| Phase              | Gates      |
| ------------------ | ---------- |
| Triage feedback    | 1–4        |
| Post-update review | 1–5 (5 primary) |
| Standalone review  | 1–5        |

## Execution-reliability lens (recommend-only)

Beyond gates 1–5, scan the plan for **deterministic procedure** — fixed checklists, ordered command sequences, exact format templates — that would run more reliably as a **script** (single source of truth, same result every run) than as prose re-followed each time. Surface it as a **Reliability** finding (recommend only); never expand scope yourself. Bound by **Precision** (gate 4 — don't bundle a refactor) and the **scope-expansion** Ambiguity trigger (ask before adding script work to the plan). Skip one-off, non-repeated steps — the win is repeated-run determinism, not token savings. Authoring conventions for any recommended script: repo-root `SCRIPTS.md`.

## Ambiguity Protocol

Silent guesses become hidden plan assumptions. **Stop and ask** when plan, feedback, or codebase can't answer — before triage row, finding, or edit. "Let the agent decide" is valid user answer; agent can't choose unilaterally.

| Trigger | Why |
| ------- | --- |
| **Forking decision** (A or B step/finding) | Plan = one path, not a tree. Clarity + Precision. |
| **System-relationship claim** (only caller, purely UI, etc.) | Verify blast radius. Accuracy + Completeness. |
| **Scope expansion** (files outside plan, "also fix") | User owns scope. Precision. |
| **Destructive simplification** (drop test, assertion, deprecation, doc comment) | Codebase asserts facts. User intent required. |
| **Embedded assumption** (flag state, rollout, env, future commit) | Surface; don't bake in. |

**How:** Batch all ambiguities in one structured round (multiple-choice tool if available). Offer obvious options + `Let the agent decide — pick simpler path, record in plan`. Cite plan section or feedback item. Block report until answered. Clarification asks ≠ approval gates (steps 4, 7).

**Not ambiguity:** cheap verification (read line 44); repo agent docs already answer (`AGENTS.md`, `CLAUDE.md`, etc.); intentional deferred follow-ups in plan.

## Inputs

| Input | Resolve order |
| ----- | ------------- |
| **Plan** | arg → context (open/attached/named) → newest `**/*.plan.md` / `plans/**/*.md` / host plan store → ask |
| **Feedback** | path after `--` → inline message → prior agent output → none (standalone) |

Confirm path + feedback source if ambiguous.

## Plan Invariants

Valid YAML frontmatter when present. Stable todo `id`s; valid status values. Don't touch protected metadata (`name`, `isProject`, etc.). Keep body order unless Clarity requires restructure. No frontmatter/todos → preserve structure; may add minimal cold-start sections (Required reading, Prerequisites, Out of scope) when Resumability or Completeness findings require them — no wholesale restructure.

## Workflow

Feedback supplied: steps 1–8. No feedback: 1 → 6.

1. **Read plan** — full file; parse frontmatter; stop on malformed YAML.
2. **Ingest feedback** — numbered items, verbatim quotes, split combined paragraphs. None → step 6.
3. **Triage (gates 1–4)** — per item: `approved` / `declined`, 1–2 sentences naming gate(s). Read cited code/plan before either verdict. Partial approve → scope in rationale. Apply Ambiguity Protocol first.
4. **Triage report → stop** — template in [reference.md](reference.md). Ask: apply all approved? (yes / no / subset). **No plan edits this turn.**
5. **Apply approved** — traceable to triage rows; respect invariants; re-parse YAML. New ambiguity → Ambiguity Protocol, pause.
6. **Plan review (gates 1–5)** —
   1. Run `scripts/check-refs.py <plan>` to verify cited paths/lines; it is the single source of truth for link refs and feeds gate 1 (Accuracy). Only if you cannot execute it, read it as a spec and spot-check refs by hand (read/verify tier: execute-or-infer). Hand-check inline/prose path refs it does not parse; resolve PR/branch refs via VCS tools.
   2. Falsify negative claims; flag `Unverified` when expensive.
   3. Apply the Execution-reliability lens (above).
   4. Apply **Resumability** sub-lens (`reference.md` § Cold-start implementable). If plan references `docs/_plan/` or `HANDOFF.md`, also run plan-build integration checks (reference.md).
   5. Propose missing recommended sections as localized edits, not wholesale restructure. Ambiguity Protocol on findings.
7. **Plan-review report → stop** — template in [reference.md](reference.md). Ask: apply changes? (yes / no / subset).
8. **Apply + confirm** — path updated; one-line per change; deferred/skipped items + why.

## Anti-patterns

- Edit plan same turn as report.
- Decline/approve without reading cited code — "looks wrong" not a rationale.
- Skip triage when feedback exists.

Extended list: [reference.md](reference.md).
