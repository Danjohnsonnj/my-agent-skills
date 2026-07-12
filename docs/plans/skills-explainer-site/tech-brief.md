# Tech brief - current state and gaps

## Current architecture (verified)

- Skill suite - README + four skill dirs (`start-interview/`, `plan-build/`, `review-plan/`, `orchestrate-build/`) + SCRIPTS.md
- This plan tree - `docs/plans/skills-explainer-site/`
- Suite still documents default `docs/_plan/` in places — **Phase 4** migrates to named plans
- No public site HTML yet

## Execution gaps (ordered)

1. **Phase 4:** named plan default + plan-root-relative orchestrate bus
2. **Phases 5–6:** design tokens/prompt pack → vanilla site on GH Pages `/docs`

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

## Locked plan-path convention (to implement in suite)

- **Default:** `docs/plans/<effort-slug>/` (HANDOFF.md + leaves)
- **This effort:** `docs/plans/skills-explainer-site/`
- **Bus (orchestrate-build):** under the active plan root, e.g. `docs/plans/<slug>/_bus/` (replace hard-coded `docs/_plan/_bus/`)
- **Migration note:** document rename from legacy `docs/_plan/` for existing projects

## Content / IA (see content-outline.md)

Single page: Hero → Lifecycle skim strip → Connect → Skills (×4 equal, orchestrate optional) → Install → Principles → Footer (plan HANDOFF link).

## Hard invariants

- Vanilla only for visitors
- Install snippet stays identical to README
- Skill behavior claims stay faithful to SKILL.md
- Commit only when asked
