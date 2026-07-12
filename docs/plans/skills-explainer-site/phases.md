# Phases

**Execution order:**  
6 → 7. Phases 1–5 are done.

## Phase 1 - Discovery ✅

- Locked audience, hosting, stack, tone, visual (2026-07-11).
- Verify: product-brief + tech-brief.

## Phase 2 - Content outline + decision interview ✅

- IA/section jobs locked; decisions.md; tree at `docs/plans/skills-explainer-site/`.
- Verify: decisions.md + content-outline match locks.

## Phase 3 - Rename grill-me → start-interview ✅

- Folder `start-interview/`; SKILL name + invoke; README + cross-refs; local symlinks.
- Verify: `rg` clean except history/migration notes; lifecycle order uses `start-interview`; **UAT passed** (`/start-interview`).

## Phase 4 - Suite convention update (named plans) ✅

- Default plan path `docs/plans/<effort-slug>/`; bus at `<plan-root>/_bus/`; checkpoint/rollback take plan root; README/SCRIPTS + review-plan examples updated; legacy `docs/_plan/` notes only.
- Verify: skill-facing defaults cite named plans; this effort’s path is the living example.

## Phase 5 - Design lock ✅

- [`design-lock.md`](design-lock.md) approved 2026-07-11 — tokens, skim-strip + skill-block layout, motion, illustration prompt pack; summary in tech-brief.
- Verify: user approved written lock.

## Phase 6 - Build & deploy (current)

- `docs/index.html` + `docs/assets/{css,js,img}/` per content-outline.md + decisions.md.
- GH Pages from `/docs`; install snippet === README; copy button; footer → `plans/skills-explainer-site/HANDOFF.md`.
- Verify: local preview; deploy URL; mobile smoke; clipboard; footer link; install diff vs README clean.

## Phase 7 - Review & handoff

- `review-plan` on residual work; refresh HANDOFF for maintenance.
- Verify: gates addressed/deferred; next action = maintenance or done.
