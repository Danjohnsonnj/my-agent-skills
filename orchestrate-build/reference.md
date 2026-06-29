# Orchestrate-build - reference

Operational detail behind [SKILL.md](SKILL.md). Read on demand. Rationale for the
model and every locked decision lives in
[the proposal](../plan-build/proposals/orchestrated-subagents.md); this file does
not restate it, it tells you how to run the loop.

## Chunk sizing

Floor and ceiling (proposal, "Chunking"): small enough for one runnable verify,
big enough to be worth one cold-start onboarding.

- Start from `phases.md`. Each phase's `Verify:` line is the natural exit test;
  a chunk is usually one phase or a slice of one with its own verify.
- **Cluster** trivially small adjacent steps into one chunk so you do not pay an
  onboarding tax for near-zero work.
- **Split** a phase whose work clearly exceeds one budget into ordered sub-chunks,
  each with its own verify.
- **Refine from signal:** a high `partial`-handback rate means chunks are too big;
  shrink them. Frequent trivial `complete`s mean you can cluster more.

### Coupled-unit hazard

The coupling override (keep tightly coupled work whole) collides with the budget
when a coupled unit is *larger* than one subagent can comfortably do. Any split -
budget-split or `partial` continuation - puts the second subagent on the far side
of a context boundary it cannot see, so it re-derives intent from files alone.

- Detect it: the work cannot be cut into independently verifiable pieces without
  one piece depending on undocumented intent from another.
- Do **not** split silently. Flag the unit to the user and decide together: invest
  in a richer `handoff.md` that carries the cross-cut intent explicitly, accept a
  larger budget for one chunk, or restructure the plan so the seam moves.

## Git checkpoint & rollback

The orchestrator owns git; subagents never commit (proposal, "Workspace state &
git"). Use a WIP mechanism that respects "real commits only when the user asks":

- **Checkpoint before each dispatch.** A dedicated WIP branch with throwaway WIP
  commits, or `git stash create`/tags, captures a known-good tree. Record the ref.
- **On re-verify pass:** advance the checkpoint to the new tree (the chunk's edits
  are now the known-good baseline) and fold durable state into `HANDOFF.md` +
  `progress-log.md`.
- **On re-verify fail:** roll back the working tree to the last checkpoint before
  retry or re-dispatch, so the next subagent starts from green, not from the
  broken edits of the failed one.
- **Green-on-exit** is the target for `complete` chunks. A `partial` may
  legitimately leave mid-edit state; distinguish "in progress, keep" from
  "broken, roll back" by the handback status, not by inspecting the diff.
- When the user later asks to commit, squash the WIP history into real commits per
  `plan-build`'s active adoption mode.

## Partial / continuation re-dispatch

When a handback is `partial` (budget hit or not converging, proposal decision 2):

1. Do not roll back - the partial edits are real progress; keep the tree.
2. Read the handback's **Remaining** section; that is the continuation chunk.
3. Size the continuation like any chunk, then overwrite `handoff.md` for it
   (label it e.g. `02b`) with required reading that points at what the prior
   subagent already changed, so the continuation does not redo it.
4. Re-verify the continuation against the *original* chunk's verify; a chunk is
   only `complete` when its deterministic verify passes end-to-end.

If the same chunk goes `partial` repeatedly without converging, treat it like a
coupled-unit-too-big hazard and surface it to the user.

## Verification protocol

Ground truth is an orchestrator-side re-run, not the handback's claim (proposal,
"Verification & trust").

1. Read the handback status and `Verify evidence`.
2. If the chunk's verify is **deterministic and runnable**, run it yourself now.
   Trust your result over the subagent's claim. A `complete` claim whose verify
   fails on re-run is a failure - roll back.
3. If it is **not runnable** here, inspect the verbatim evidence in the handback
   (command output / exit code). Absent or vague evidence is not a pass.
4. If the verify is **subjective**, route it to the user gate; do not self-certify.
5. Only after a real pass do you advance the checkpoint and fold state.

## Planning-phase recon subagents

During planning the orchestrator talks to the user directly and dispatches
**read-only** subagents for legwork (proposal, "Planning phase"):

- Use them for token-heavy reads: codebase mapping, "how does X work today",
  gathering constraints across many files. Their large reads are discarded; only
  findings return.
- Frame them with the same cold-start preamble as the dispatch prompt (steps 1-2)
  but with a research goal and an explicit "do not edit files" instruction.
- Decisions and trade-offs stay with the orchestrator+user and land in an approved
  `phases.md`/spec via `plan-build`. Then hand off to a fresh orchestrator so build
  starts lean.

## Continuity signals

Handing off to a fresh orchestrator is user-initiated on a deterministic proxy
(proposal, "Orchestrator continuity"):

- **Primary signal:** a chunks-completed count or a phase boundary, plus the user
  watching a real usage/context meter. Pick a starting count (see Budget defaults)
  and pause for the user at it.
- **Not a signal:** the model's own "context feels large" - it cannot introspect
  token use, so treat it as a soft early warning only.
- **The handoff:** refresh `HANDOFF.md` (current phase, next action, next-phase
  required reading), leave the bus and brief tree on disk, and let the user start
  a fresh orchestrator that cold-starts from `AGENTS.md -> HANDOFF.md`.

## Budget defaults (observe and refine)

No formal metrics are imposed (proposal decision 8); these are starting points to
tune from first runs, not fixed limits:

- **Subagent effort budget (decision 2):** a small countable cap - on the order of
  ~15-25 tool calls or ~3 attempts at the chunk's verify - then emit `partial`.
- **Runaway/loop cap (escape hatch 4):** ~5-8 auto-dispatched chunks before a
  mandatory user check-in.
- **Continuity proxy (escape hatch 2):** offer an orchestrator handoff around a
  phase boundary or every ~8-12 completed chunks, whichever comes first.

Raise or lower each from observation: frequent `partial`s -> budgets too tight or
chunks too big; long silent runs -> tighten the loop cap.

## Worked session (vertical; time flows down)

One subagent at a time. The orchestrator overwrites `handoff.md`, waits for the
subagent to overwrite `handback.md` and return, re-verifies, checkpoints, folds
state, then dispatches the next chunk. Near the end, on a proxy signal, the user
starts a fresh orchestrator from `HANDOFF.md`.

```
 time
  │
  │   ┌───────────────────────────────────────────────┐
  │   │ Orchestrator A  (cold start)                   │
  │   │  conducts planning interview WITH USER         │
  │   │  (read-only recon subagents for legwork)       │
  │   │  user approves phases.md                       │
  │   └───────────────────────┬───────────────────────┘
  │                           │ git checkpoint; overwrite handoff.md (chunk 01)
  │                           ▼
  │                   ┌───────────────────┐
  │                   │ Subagent 1        │  own context (discarded);
  │                   │  do chunk 01       │  file edits persist
  │                   │  within budget     │
  │                   │  overwrite          │
  │                   │  handback.md=done   │
  │                   └─────────┬─────────┘
  │                             │ returns
  │   ┌─────────────────────────▼───────────────────────┐
  │   │ Orchestrator A                                   │
  │   │  RE-RUN verify (ground truth) → PASS             │
  │   │  advance checkpoint                              │
  │   │  fold into HANDOFF.md + append progress-log.md   │
  │   └─────────────────────────┬───────────────────────┘
  │                             │ overwrite handoff.md (chunk 02)
  │                             ▼
  │                   ┌───────────────────┐
  │                   │ Subagent 2        │
  │                   │  hits budget       │
  │                   │  handback.md=      │
  │                   │  PARTIAL+remaining │
  │                   └─────────┬─────────┘
  │                             │ returns
  │   ┌─────────────────────────▼───────────────────────┐
  │   │ Orchestrator A                                   │
  │   │  dispatch CONTINUATION (chunk 02b)               │
  │   └─────────────────────────┬───────────────────────┘
  │                             │ overwrite handoff.md (chunk 02b)
  │                             ▼
  │                   ┌───────────────────┐
  │                   │ Subagent 3        │
  │                   │  verify → FAIL     │
  │                   │  handback.md=failed│
  │                   └─────────┬─────────┘
  │                             │ returns
  │   ┌─────────────────────────▼───────────────────────┐
  │   │ Orchestrator A                                   │
  │   │  ROLL BACK to checkpoint                         │
  │   │  retry once; still fails → circuit-breaker       │
  │   │  ESCAPE HATCH → ASK USER, get decision           │
  │   │  fold decision; (proxy: N chunks done)           │
  │   │  refresh HANDOFF.md; signal: time to hand off    │
  │   └─────────────────────────┬───────────────────────┘
  │                             │ user starts fresh orchestrator
  │   ┌─────────────────────────▼───────────────────────┐
  │   │ Orchestrator B  (cold start, fresh ctx)          │
  │   │  reads AGENTS.md → HANDOFF.md → leaves           │
  │   │  resumes where A stopped                         │
  │   └─────────────────────────┬───────────────────────┘
  │                             │ overwrite handoff.md (chunk 04) …
  │                             ▼
  │                   ┌───────────────────┐
  │                   │ Subagent 4 …      │
  │                   └───────────────────┘
  ▼
```

## End of build

When the plan is delivered, delete the bus directory `docs/_handoff/_bus/`; the
durable record lives in `HANDOFF.md` and `progress-log.md`. Commit per the active
`plan-build` adoption mode, only when the user asks.

## Interop

- Consumes `plan-build` surfaces unchanged: `HANDOFF.md` "Required reading" -> what
  a subagent loads; `phases.md` `Verify:` -> the chunk exit test; the HANDOFF shape
  -> the handback schema.
- `plan-build` stays the human-driveable WRITE side; this skill is the opt-in DRIVE
  side. It adds only the bus, dispatch loop, re-verify, checkpointing, and escape
  hatches - it changes nothing in `plan-build`.
