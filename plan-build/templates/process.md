# Process - how we work on this effort

Durable methodology. Read once per session before committing. Reached via AGENTS.md -> HANDOFF.md.

**Adoption mode:** {{own-project | contributor}}

## Cold-start protocol

1. Read AGENTS.md (auto-loaded); it points here and to HANDOFF.md.
2. Read HANDOFF.md (always).
3. Load ONLY the leaves under HANDOFF.md "Required reading (this phase)".
4. Pull any other leaf from the Index on demand.

## Update discipline

- Briefs hold CURRENT truth: overwrite in place; correct mistakes directly.
- progress-log.md holds HISTORY: append-only dated entries; never rewritten.
- Single source of truth per fact: the next action lives only in HANDOFF.md.

## Session-handoff ritual (user-initiated wrap-up)

1. Overwrite affected brief(s) in place.
2. Refresh HANDOFF.md (phase, next action, next-phase required reading, open decisions, last-updated).
3. Append a dated progress-log.md entry (happened / learned / overwrote).
4. Commit per the active adoption mode below, only when the user asks.

## Adoption mode: own-project (default)

- Artifacts are tracked and committed normally alongside code.

## Adoption mode: contributor (someone else's repo)

- Keep artifacts OUT of any upstream PR. Do NOT add them to the tracked .gitignore.
- Keep code and artifacts in SEPARATE commits.
- Open PRs from a fresh branch off the upstream base that omits artifact + AGENTS commits.
- Upstream-facing design docs go in the host repo's house style/location, separate from these artifacts.
