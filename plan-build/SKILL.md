---
name: plan-build
description: Creates and maintains a durable, cold-start-resumable handoff brief tree (HANDOFF plus product/tech briefs, phases, progress log) for multi-session discovery and delivery in any project, using progressive disclosure. Use when starting a multi-session effort, standing up a project brief or handoff, wrapping up or handing off a session, or making work resumable across sessions. Pairs with resume-work, which reads what this writes.
---

# Plan-build

Produces and maintains the durable artifacts that let any cold-start agent resume long-running work. This is the WRITE/maintain side; resume-work and research-repo are the READ side and consume the AGENTS.md pointer and HANDOFF.md this skill creates.

## When to use

- Init: starting a multi-session discovery/delivery effort with no handoff yet.
- Maintain: at a user-initiated wrap-up ("hand off", "wrap up the session").
- Resume: a session points only at HANDOFF.md and continues.

## Core model (progressive disclosure)

A thin tree under docs/\_handoff/: HANDOFF.md (always-read entry) plus on-demand leaves process.md, product-brief.md, tech-brief.md, phases.md, progress-log.md. A root AGENTS.md pointer makes it auto-discoverable. On cold start, load only HANDOFF.md plus the leaves named in its per-phase "Required reading".

## Init workflow

1. Pick adoption mode: own-project (default; commit artifacts) or contributor (keep out of upstream PR). See reference.md.
2. Create docs/\_handoff/ from templates/ (HANDOFF, process, product-brief, tech-brief, phases, progress-log). Fill the {{placeholders}}; delete guidance comments.
3. Add the AGENTS.md pointer: if AGENTS.md exists, append the block from templates/AGENTS.snippet.md without clobbering existing content; else create AGENTS.md from the snippet.
4. Set process.md "Adoption mode" and HANDOFF.md current phase + next action.
5. Do not commit unless the user asks.

## Cold-start protocol

Read AGENTS.md, then HANDOFF.md, then only the leaves under "Required reading (this phase)". Read process.md before committing.

## Session-handoff ritual (wrap-up)

1. Overwrite affected brief(s) in place. 2. Refresh HANDOFF.md (phase, next action, next-phase required reading, open decisions, last-updated). 3. Append a dated progress-log.md entry (happened / learned / overwrote). 4. Commit artifacts per the active adoption mode, only when the user asks.

## Rules

- Single source of truth per fact: the next action lives only in HANDOFF.md.
- Briefs hold current truth (overwrite in place); progress-log.md is append-only history.
- Keep HANDOFF.md at roughly 50 lines or fewer.

## Resources

- Methodology detail, adoption-mode procedures, AGENTS.md merge logic, worked example: see reference.md.
- Artifact templates: see templates/.
