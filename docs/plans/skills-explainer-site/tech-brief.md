# Tech brief - current state and gaps

## Current architecture (verified)

- Skill suite - README + four skill dirs (`start-interview/`, `plan-build/`, `review-plan/`, `orchestrate-build/`) + SCRIPTS.md
- This plan tree - `docs/plans/skills-explainer-site/`
- Suite default plan path: `docs/plans/<effort-slug>/`; bus: `<plan-root>/_bus/` (legacy `docs/_plan/` noted only)
- No public site HTML yet

## Execution gaps (ordered)

1. **Phase 6:** vanilla site on GH Pages `/docs` per design-lock + content-outline

## Locked site stack

| Decision | Choice |
|---|---|
| Hosting | GitHub Pages, source = `/docs` |
| Entry | `docs/index.html` |
| Assets | `docs/assets/css/`, `js/`, `img/` |
| Stack | Vanilla HTML/CSS/JS only |
| Browsers | ~2024+ desktop + mobile |
| JS | Smooth-scroll; install clipboard copy; light CSS motion; `prefers-reduced-motion` |
| Art | Optional for v1; prompt pack in Design lock |

## Design tokens & paths (Phase 5 ✅ locked 2026-07-11)

**Authority:** [`design-lock.md`](design-lock.md) (full tables). Summary:

| Concern | Lock |
|---|---|
| Direction | Dark workbench; signature = lifecycle continuity rail |
| Accent | `#5b8def` on ink `#0c0e12` (not purple / not acid-green) |
| Type | Plus Jakarta Sans + JetBrains Mono |
| CSS | `docs/assets/css/site.css` (`:root` custom properties) |
| JS | `docs/assets/js/site.js` |
| Img | `docs/assets/img/` (empty OK v1) |
| Motion | Hero fade; rail draw-once; smooth-scroll; reduced-motion off |

## Locked plan-path convention (implemented)

- **Default:** `docs/plans/<effort-slug>/` (HANDOFF.md + leaves)
- **This effort:** `docs/plans/skills-explainer-site/`
- **Bus (orchestrate-build):** under the active plan root, e.g. `docs/plans/<slug>/_bus/`
- **Scripts:** `checkpoint.sh` / `rollback.sh` take plan root as arg 1 or `PLAN_ROOT`
- **Migration note:** legacy `docs/_plan/` documented in skill docs for existing projects

## Content / IA (see content-outline.md)

Single page: Hero → Lifecycle skim strip → Connect → Skills (×4 equal, orchestrate optional) → Install → Principles → Footer (plan HANDOFF link).

## Hard invariants

- Vanilla only for visitors
- Install snippet stays identical to README
- Skill behavior claims stay faithful to SKILL.md
- Commit only when asked
