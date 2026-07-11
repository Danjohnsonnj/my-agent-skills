# orchestrate-build

An installable Cursor/agent skill that **drives** a `plan-build` effort: a
long-lived orchestrator session breaks approved work into chunks and dispatches
each to a serialized cold-start subagent over a handoff/handback bus
(`docs/_plan/_bus/*`), independently re-verifying, git-checkpointing, and
gating on the user via explicit escape hatches. It is the opt-in DRIVE side of
session continuity and depends on `plan-build`, the WRITE/maintain side, whose
artifacts it consumes unchanged.

## Install

Symlink this directory into a skills path:

```bash
ln -s "$PWD" ~/.agents/skills/orchestrate-build
# optionally also:
ln -s "$PWD" ~/.cursor/skills/orchestrate-build
```

Never place it under `~/.cursor/skills-cursor/` - that directory is reserved for
Cursor's built-in skills.

## Use

Invoke explicitly by asking to "orchestrate the build", "run the dispatch loop",
or "drive the subagents" against a project that has (or is about to have) a
`plan-build` tree. The orchestrator sizes each chunk from `phases.md`, writes the
dispatch brief to `docs/_plan/_bus/handoff.md`, launches one subagent at a
time, re-runs each chunk's verify itself, and folds durable state back into
`HANDOFF.md` / `progress-log.md`. See `SKILL.md` for the loop and `reference.md`
for chunk sizing, git mechanics, verification, and budget defaults.

This skill sets `disable-model-invocation: true`, so it only loads when named
explicitly - orchestration is consequential and should be chosen, not ambient.

## Layout

- `SKILL.md` - slim skill body (entry point: loop, bus, rules).
- `reference.md` - operational detail (chunk sizing, git checkpoint/rollback,
  continuation re-dispatch, verification protocol, budget defaults, worked session).
- `scripts/` - executable single-source-of-truth steps: `checkpoint.sh`,
  `rollback.sh` (mutating, execute-or-STOP) and `run-verify.sh` (read/verify,
  execute-or-infer). Authoring conventions live in the repo-root `SCRIPTS.md`.
- `templates/` - the bus contracts (`handoff.md`, `handback.md`) and the literal
  cold-start `dispatch-prompt.md`.
