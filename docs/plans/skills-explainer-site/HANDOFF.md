# Skills explainer site - Handoff

**Goal:** Public overview site for my-agent-skills (what / how / why), dogfooding the suite.

**Current phase:** Phase 4 — Suite convention update (named plans) - pending
**Next action:** Execute Phase 4 named-plan defaults across plan-build / orchestrate-build / review-plan + README/SCRIPTS (see phases.md verify); do not start Design/Build until Phase 4 is done.

**Build sequence:** 3 rename ✅ → 4 named plans (`docs/plans/<slug>/`) → 5 Design lock → 6 Build & deploy → 7 Review. Decisions are locked (decisions.md); no open forks block execution.

**Hard invariants:** Do not commit unless asked. Do not invent skill behavior. Overview ≠ docs replacement. Control-plane edits human-gated; Phase 4 before site UI.

**Required reading (this phase):**

- docs/plans/skills-explainer-site/lessons.md - toolkit before re-deriving
- docs/plans/skills-explainer-site/decisions.md - full lock table (G14–G15 named plans)
- docs/plans/skills-explainer-site/phases.md - Phase 4 surfaces + verify

**Index (load on demand):**

- product-brief.md - audience, tone, visual, success bar
- tech-brief.md - stack, hosting, plan-path, JS/art
- content-outline.md - IA / section jobs (site Build input)
- phases.md - all phases + verify
- process.md - read before committing
- progress-log.md - history
- lessons.md - toolkit
- decisions.md - locks

**Open decisions:** none blocking (custom domain deferred; art fast-follow).
**Last updated:** 2026-07-11 — Phase 3 rename complete; UAT passed (`/start-interview`)
