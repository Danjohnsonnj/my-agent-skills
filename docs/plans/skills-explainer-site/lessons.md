# Lessons (reusable toolkit; accreted across sessions)

## Site claims follow skill docs

- Context: Any marketing or how-to copy for this site
- Lesson: Treat `README.md` and each skill's `SKILL.md` / `reference.md` as the behavior source of truth; never invent capabilities for the site.
- Evidence: plan-build init (2026-07-11); HANDOFF hard invariants
- Crystallize?: no (process invariant)

## Overview site, docs remain canonical

- Context: Content depth and IA
- Lesson: Site is friendly professional overview; deep-link to GitHub for SKILL.md / SCRIPTS.md. Lifecycle skim-first; no standalone Problem section.
- Evidence: grill-me 2026-07-11
- Crystallize?: no

## Vanilla + GH Pages from docs/

- Context: Build & deploy
- Lesson: No framework; Pages source `/docs`. Install snippet byte-identical to README. Illustrations are prompted for fast-follow; v1 can ship text/CSS only.
- Evidence: Discovery + grill-me 2026-07-11
- Crystallize?: candidate verify step: diff install block vs README in Build phase

## Named plan folders

- Context: plan-build / orchestrate-build / multi-effort repos
- Lesson: Use `docs/plans/<effort-slug>/` not a single forever `docs/_plan/`. Bus lives under that plan root (`_bus/`). Update suite docs/skills accordingly; migrate legacy `_plan` with a note.
- Evidence: grill-me G14–G15; tree move 2026-07-11
- Crystallize?: yes — Phase 4 suite convention update

## start-interview (ex-grill-me)

- Context: Suite naming / site copy / install
- Lesson: Public and skill name is `start-interview`. Treat `grill-me` as legacy only in history/migration notes. Invoke `/start-interview`.
- Evidence: G16 lock 2026-07-11
- Crystallize?: yes — Phase 3 rename across all surfaces

## Post-ship site sync check

- Context: After explainer site exists
- Lesson: When skill names, lifecycle steps, install, or principles change, check whether `docs/index.html` (and assets) need updating.
- Evidence: user directive 2026-07-11 (agentmemory)
- Crystallize?: candidate checklist item in SCRIPTS harvest or README maintainer note
