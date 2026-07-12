# Product brief - Skills explainer site

## Background

`my-agent-skills` is a suite of installable Cursor/agent skills covering multi-session software work: start-interview → plan-build → review-plan → orchestrate-build. Today the story lives mainly in repo markdown. This effort ships a public overview site and updates the suite so durable plans live under `docs/plans/<effort-slug>/` (multi-plan safe). Migration note: starter skill renamed from `grill-me` (Phase 3, 2026-07-11).

## Audience

- Software developers — professionals and hobbyists
- Desktop and mobile
- Primarily USA; ~95% on modern (~2024+) browsers

## Goal

Public site that answers:

1. **What for** — cold-start continuity, decision quality, execution reliability
2. **How to use** — install, lifecycle order, when to invoke each skill
3. **Why useful** — vs free-form agent chat (resumability, human gates, executable scripts)

Success: cold visitor can install and run a first skill without reading the full tree; returning visitor gets lifecycle map + doc deep links. Skim legibility / fast “I get it” is a first-class goal; lifecycle mental model is the main focus.

## Tone & content depth

- Friendly, approachable, professional
- Overview only — does not supersede SKILL.md / reference.md / SCRIPTS.md
- Deep-link to GitHub for authority

## Visual direction

- Modern, clean, dark
- Inspo: Linear, Superset (craft/typography; do not copy brand marks)
- Text + illustrations; v1 can ship without bitmaps; Design lock produces a prompt pack for fast-follow

## Non-goals

- Not a docs portal or skill runner
- Not inventing a separate product brand name (v1 uses `my-agent-skills`)
- Not gating launch on generated art
- Not auto-editing skills outside the sequenced convention update + explicit asks

## Boundaries

- Always: claims match README/SKILL.md; overview depth; human-gated commits
- Ask first: custom domain; scope beyond four skills + SCRIPTS throughline; shipping illustration assets
- Never: invent capabilities; commit/push unasked

## Success criteria

- Lifecycle skim strip + connect makes the suite understandable in one short scroll
- Four compact skill blocks; orchestrate marked optional
- Install matches README; copy-to-clipboard works
- Footer links to `docs/plans/skills-explainer-site/HANDOFF.md`
- Suite docs/skills: `start-interview` naming + `docs/plans/<effort-slug>/` before site is treated done
- Desktop + mobile; GH Pages from `/docs`
