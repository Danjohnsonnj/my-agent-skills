# Phases

**Execution order (do not skip ahead to Design/Build):**  
4 → 5 → 6 → 7. Phases 1–3 are done (discovery + locks + start-interview rename).

## Phase 1 - Discovery ✅

- Locked audience, hosting, stack, tone, visual (2026-07-11).
- Verify: product-brief + tech-brief.

## Phase 2 - Content outline + decision interview ✅

- IA/section jobs locked; decisions.md; tree at `docs/plans/skills-explainer-site/`.
- Verify: decisions.md + content-outline match locks.

## Phase 3 - Rename grill-me → start-interview ✅

- Folder `start-interview/`; SKILL name + invoke; README + cross-refs; local symlinks.
- Verify: `rg` clean except history/migration notes; lifecycle order uses `start-interview`; **UAT passed** (`/start-interview`).

## Phase 4 - Suite convention update (named plans) (current)

**Surfaces:**

1. `plan-build` — SKILL, reference, templates, README → default `docs/plans/<effort-slug>/`.
2. `orchestrate-build` — SKILL, reference, README, templates, `checkpoint.sh` / `rollback.sh` → bus under plan root (`<plan>/_bus/`), not hard-coded `docs/_plan/_bus/`.
3. `review-plan` — refs/examples for plan paths.
4. Root README + SCRIPTS.md — `docs/_plan/` → named plans (+ short legacy migration note).

**Verify:**

- Stale `docs/_plan` defaults gone from skill-facing docs/scripts (legacy notes only).
- Examples cite `docs/plans/<slug>/` pattern; this effort’s path is the living example.

## Phase 5 - Design lock

- Dark CSS tokens (palette, type, spacing); skim-strip + skill-block layout; motion notes; **illustration prompt pack** (assets optional for v1).
- Verify: user approves written lock (± mock); tech-brief records tokens/paths.

## Phase 6 - Build & deploy

- `docs/index.html` + `docs/assets/{css,js,img}/` per content-outline.md + decisions.md.
- GH Pages from `/docs`; install snippet === README; copy button; footer → `plans/skills-explainer-site/HANDOFF.md`.
- Verify: local preview; deploy URL; mobile smoke; clipboard; footer link; install diff vs README clean.

## Phase 7 - Review & handoff

- `review-plan` on residual work; refresh HANDOFF for maintenance.
- Verify: gates addressed/deferred; next action = maintenance or done.
