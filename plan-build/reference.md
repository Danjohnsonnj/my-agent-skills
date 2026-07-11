# Plan-build - reference

Detailed methodology behind `SKILL.md`. Read on demand. The skill writes a durable
handoff brief tree (`docs/_plan/*`) so any cold-start agent can resume
long-running, multi-session work. This is the WRITE side; `resume-work`
and `research-repo` are the READ side.

## Adoption modes

Pick a mode at init and record it in `docs/_plan/process.md` under **Adoption mode**.

### own-project (default)

You own the repo, so the handoff artifacts are first-class.

- Track and commit `docs/_plan/*` normally, alongside code.
- No special branch handling.

### contributor (someone else's repo)

You are contributing to an upstream repo and the handoff artifacts must not leak into
the PR.

- Keep artifacts OUT of any upstream PR.
- Do NOT add the artifacts to the tracked `.gitignore` (that would change upstream's
  file). Use a local exclude (`.git/info/exclude`) or a personal global ignore if you
  want them ignored locally.
- Keep code and artifacts in SEPARATE commits so the lanes never mix.
- Open PRs from a fresh branch off the upstream base, cherry-picking only the code
  commits; the branch must omit the artifact commits.
- Upstream-facing design docs go in the host repo's house style and location, separate
  from `docs/_plan/`.

## Cold-start protocol (expanded)

This skill does not write an `AGENTS.md` pointer; entry is explicit.

1. Start from `HANDOFF.md` — the explicit entry point an agent is pointed at directly.
   It states the current phase, the single next action, any hard invariants, and the
   per-phase required reading.
2. Load ONLY the leaves named under **Required reading (this phase)**. Do not read the
   whole tree.
3. Pull any other leaf from the **Index** on demand.
4. Read `process.md` before committing.

### Single source of truth

- The next action lives ONLY in `HANDOFF.md`. Do not duplicate it into leaves.
- Briefs (`product-brief.md`, `tech-brief.md`, `phases.md`) hold CURRENT truth:
  overwrite in place; correct mistakes directly.
- `progress-log.md` holds HISTORY: append-only dated entries; never rewritten.

## Configuration knobs

- **Folder name:** default `docs/_plan/`. Override allowed; if you move it, update
  the paths in `HANDOFF.md` accordingly.
- **Hard invariants:** the `HANDOFF.md` invariants line is optional; delete it if the
  effort has no tripwire rules.
- **Extra leaves:** add project-specific leaves (e.g. `data-model.md`); list them in
  the `HANDOFF.md` Index and reference them from **Required reading** when relevant.

## Interop

- `HANDOFF.md` IS the hand-off document that `resume-work` consumes; an agent is
  pointed at it explicitly.
- Do not duplicate their read logic here; this skill only writes the surfaces they read.
- `orchestrate-build` is the opt-in DRIVE side: it consumes these same surfaces
  (`HANDOFF.md`, `phases.md` verifies) to run a serialized subagent dispatch loop;
  it adds no behavior here and changes nothing in this skill.

## Worked example (generic)

A multi-session macOS/Cursor effort ("token-goat") adopted this tree.

**Init.** Contributor mode (upstream repo). Created `docs/_plan/` from the templates,
filled placeholders (PROJECT, goal, phase 1), and set `process.md` adoption mode to
`contributor`. Nothing was committed until asked; code and artifacts were committed in
separate lanes.

**Discovery phase entry.** `HANDOFF.md` current phase = "Discovery - in progress", next
action = "confirm the build config in tech-brief.md", required reading =
`tech-brief.md` (where the unverified findings live). A cold-start agent was pointed at
`HANDOFF.md` -> `tech-brief.md` and resumed without re-reading the codebase.

**Wrap-up.** Overwrote `tech-brief.md` with the confirmed findings, refreshed
`HANDOFF.md` (new phase, new next action, next-phase required reading), and appended a
dated `progress-log.md` entry recording what happened, what was learned, and what was
overwritten.
