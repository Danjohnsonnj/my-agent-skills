# Decision locks - Skills explainer site

Locked 2026-07-11 (Discovery + decision interview). Single source for locks; briefs/outline mirror these.

**Build gate:** No open decisions. Execute phases 3→4→5→6→7 in order.

## Prior Discovery (user directives)

| # | Decision | Lock |
|---|---|---|
| D1 | Audience | Software developers (pro + hobby); desktop + mobile; USA-heavy ~95% |
| D2 | Location / host | In-repo; GitHub Pages |
| D3 | Stack | Vanilla HTML/CSS/JS; browsers ~2024+ |
| D4 | Depth / tone | Friendly, approachable, professional overview; does not supersede docs |
| D5 | Visual | Modern, clean, dark; inspo Linear + Superset; text + illustrations (prompts for fast-follow) |

## Decision interview locks

*(Locked via the former `grill-me` skill, now `start-interview` — see G16.)*

| # | Decision | Lock |
|---|---|---|
| G1 | IA | Single page with section anchors |
| G2 | Pages path | Source = `/docs` (`docs/index.html`, `docs/assets/…`) |
| G3 | Hero CTA | Primary Install (`#install`); secondary View on GitHub |
| G4 | Skills treatment | Compact equal blocks (what/when/why/how-to-start + SKILL.md link) |
| G5 | Section order | Mental model first: lifecycle narrative → how they connect → then pieces |
| G6 | Problem section | None standalone; fold pain into Hero + Lifecycle/Connect |
| G7 | Lifecycle skim | Hybrid skim strip (four verbs + one-liners); illustration supports, doesn’t block |
| G8 | Public name | `my-agent-skills` (rename later if needed) |
| G9 | Illustrations v1 | Ship text/CSS first; craft prompt pack for fast-follow |
| G10 | JS / motion | Minimal: smooth-scroll, install copy, light CSS motion, `prefers-reduced-motion` |
| G11 | orchestrate-build | Equal peer block; copy marks optional/opt-in |
| G12 | Dogfood link | Quiet footer → this plan’s `HANDOFF.md` |
| G13 | Principles | Brief strip after Install (3 principles + harvest one-liner; link out) |
| G14 | Plan folder | Named: `docs/plans/skills-explainer-site/` |
| G15 | Suite update | Same effort, sequenced: **Phase 3** rename → **Phase 4** named plans → Design/Build |
| G16 | Rename grill-me | **`start-interview`** — start + interview; fits plan-build / review-plan / orchestrate-build. First execution phase. |

## Post-ship preference (agentmemory)

After the site is complete, repo changes that affect the public story (skill names, lifecycle steps, install, principles, new skills) should trigger a check whether the site needs updating.
