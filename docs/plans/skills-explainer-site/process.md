# Process - how we work on this effort

Durable methodology. Read once per session before committing. Reached from HANDOFF.md.

**Adoption mode:** own-project

**Plan root:** `docs/plans/skills-explainer-site/`

## Cold-start protocol

1. Start from HANDOFF.md — the explicit entry point you are pointed at directly; read it always (phase, next action, required reading).
2. Load ONLY the leaves under HANDOFF.md "Required reading (this phase)".
3. Pull any other leaf from the Index on demand.

## Update discipline

- Briefs hold CURRENT truth: overwrite in place; correct mistakes directly.
- progress-log.md holds HISTORY: append-only dated entries; never rewritten.
- lessons.md holds the CURATED TOOLKIT: reusable gotchas and script/verify outcomes; add when useful, prune when obsolete.
- decisions.md holds the decision lock table for this effort.
- Single source of truth per fact: the next action lives only in HANDOFF.md.

## Session-handoff ritual (user-initiated wrap-up)

1. Overwrite affected brief(s) in place.
2. Refresh HANDOFF.md (phase, next action, next-phase required reading, open decisions, last-updated).
3. Append a dated progress-log.md entry (happened / verified / learned / overwrote).
4. Fold any reusable gotcha or script/verify outcome into lessons.md (prune obsolete ones).
5. Commit per the active adoption mode below, only when the user asks.

## Adoption mode: own-project (default)

- Artifacts are tracked and committed normally alongside code.

## Dogfood note

start-interview → plan-build (this tree) → review-plan → optional orchestrate-build. Control-plane: Phase 3 rename ✅; Phase 4 named plans ✅ (`docs/plans/<slug>/`, bus under plan root).
