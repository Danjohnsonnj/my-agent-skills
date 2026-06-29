# Proposal: Orchestrated subagents over a handoff/handback bus

Status: draft / accepted-direction. Not yet implemented. Defines a new sibling
skill, `orchestrate-build`, that depends on `plan-build`. This document is
self-contained: it states the motivation, the model, every locked decision with
its rationale, a worked session, and the assumptions still to validate.

## Summary

`plan-build` already lets a cold-start agent resume long-running work by writing
a durable handoff tree (`AGENTS.md` pointer + `docs/_handoff/*`). Today the
*user* drives the loop: decide when to wrap up, start a fresh session, feed it
the handoff. This proposal automates that loop with a long-lived **orchestrator**
session that breaks work into discrete **chunks** and dispatches each to a
**subagent** that runs as a self-contained cold-start sub-session. The subagent's
isolated context is discarded on return; only a structured **handback** comes
back. The orchestrator verifies, folds durable state into the brief tree, and
dispatches the next chunk.

Verdict from design review: feasible, and structurally a good fit, because a
subagent already does mechanically what a manual cold-start handoff does by hand.
It is expected to be roughly as token-efficient as manual handoffs and far more
efficient than one monolithic session — **if** chunk granularity is tuned and the
orchestrator has disciplined escape hatches. That efficiency claim is reasoned,
not yet measured (see Validation).

## Motivation

The cheapest token lever we already use is **short sessions plus cold-start
handoffs**: rather than carry one ever-growing transcript, keep each session
short and hand off context, status, and next steps via `HANDOFF.md`. The cost
today is purely ergonomic — the user has to manage that loop by hand. Automating
it preserves the token savings while removing the manual babysitting.

## Why subagents fit

A subagent already provides the property that makes cold-start handoffs cheap:

- A subagent runs in **its own context window**. The orchestrator never sees the
  subagent's internal transcript (file reads, tool calls, intermediate
  reasoning) — only its **final return message**. That discard *is* the
  compression a manual handoff buys.
- The return is structurally a handoff: what was done, what changed, what's next,
  what's blocked. So `plan-build`'s existing HANDOFF shape is the right return
  contract, and `phases.md`'s per-phase `Verify:` steps are the right exit
  criteria. We reuse this format rather than inventing one.

Mental model: **each subagent = one cold-start sub-session; its handback = a
handoff; the orchestrator = the user who reads handoffs and dispatches the next
session.**

Caveat that shapes the whole design: a subagent's *context* is discarded on
return, but its **file edits persist** (it operates on the real workspace), and a
subagent **cannot talk to the user** (it is headless and one-shot). Most
decisions below follow from those two facts.

## Locked decisions

| # | Decision | Choice |
| - | -------- | ------ |
| 1 | Orchestrator→orchestrator handoff trigger | **User-initiated on agent signals.** Signal = deterministic proxy (chunks-completed / phase boundary) + user watching a real usage meter. Self-assessed "context feels large" is a soft early warning only, never the primary trigger. |
| 2 | Bounding a subagent | **Pre-sized scope + a good-enough self-budget** (countable tool-call / attempt count) that, when exceeded or not converging, makes the subagent STOP and emit a **partial/continuation handback**. Best-effort; refine the budget from observation. |
| 3 | Verification trust | Orchestrator **independently re-runs** any deterministic verify (ground truth). Evidence-in-handback is the fallback when a verify isn't runnable; genuinely subjective verifies go to the **user gate**. |
| 4 | Bus persistence | **Durable, not ephemeral** — the bus is persisted on disk for the life of the plan+build, then deleted. |
| 5 | Bus shape | **Role-split pair, overwritten in place:** `docs/_handoff/_bus/handoff.md` (orchestrator-only writer) + `handback.md` (subagent-only writer). History lives in `progress-log.md`. |
| 6 | Chunk granularity | **Orchestrator-sized** within bounds (cluster tiny steps, split big ones, refine from the partial-handback rate), anchored on *"smallest unit with one deterministic verify, worth one onboarding."* **Coupling override:** tightly coupled work (technical or conceptual) is kept whole in a single chunk. |
| 7 | Planning phase | **Hybrid with a strong user-in-the-loop.** The orchestrator conducts the (grill-me-style) planning interview *itself*, because only it can talk to the user; read-only research subagents do discovery legwork; decisions stay in the orchestrator. |
| 8 | Validation approach | **Build it; the user observes informally.** No formal metrics or kill criterion for now. |
| 9 | Workspace state | **Git checkpoint + rollback** via an orchestrator-owned WIP mechanism (dedicated branch or stash/tags, not real commits). Green-on-exit is the target for completed chunks. **Subagents never commit; the orchestrator owns git.** |
| 10 | Packaging | **New sibling skill `orchestrate-build`** that depends on `plan-build`. The bus, dispatch template, re-verify loop, checkpointing, and escape hatches live in the new skill; the artifact templates stay in `plan-build`. |

## Roles

- **Orchestrator** — a live, user-attended session. Owns: the planning interview
  (decision 7), chunk sizing (6), dispatch, independent re-verification (3), the
  canonical brief tree (`HANDOFF.md` / `progress-log.md`), git and checkpoints
  (9), and all user-facing escape hatches. Must have the same workspace/tool
  access as subagents so it can re-run verifies and manage git.
- **Subagent** — a headless, one-shot, cold-start sub-session. Reads what the
  handoff tells it to, does exactly one chunk, may edit files, then writes its
  handback and returns. Never commits. Read-only subagents are used for
  discovery legwork during planning.

## The handoff/handback bus

Conceptually a two-direction message bus with a **single writer per direction**;
serialization (below) means there is never contention. Both files are overwritten
each cycle and live for the duration of the plan+build, then deleted.

- **`docs/_handoff/_bus/handoff.md`** (orchestrator → subagent; orchestrator is
  the only writer). The dispatch brief for one chunk:
  - scope ("do exactly X; if you find yourself doing Y, stop and return"),
  - required reading (which `docs/_handoff/` leaves + which code to load),
  - the concrete deterministic verify for this chunk,
  - the effort budget and return-early triggers,
  - hard constraints / invariants.
- **`docs/_handoff/_bus/handback.md`** (subagent → orchestrator; subagent is the
  only writer). The structured return:
  - status: `complete` | `partial` | `blocked` | `failed`,
  - what was done; for `partial`, the remaining work for a continuation chunk,
  - verify evidence (output/exit code) when a verify was run,
  - files changed; open decisions / blockers needing a human,
  - proposed next action.

The canonical project state stays in `HANDOFF.md` (current truth, overwritten)
and `progress-log.md` (append-only history). The orchestrator is the sole writer
of both: it reads each handback, re-verifies, then folds durable bits in.
Overwriting the bus files loses nothing durable because `progress-log.md` carries
the audit trail — the same "overwrite current truth / append history" split
`plan-build` already uses.

## Execution model: strictly serialized (for now)

**Exactly one subagent runs at a time. Re-evaluate parallelism later.**

The escape hatches only hold under serial execution:

- The failure circuit-breaker, runaway/loop cap, and phase-boundary pause all
  assume a single in-flight chunk the orchestrator can stop before starting the
  next. Concurrent subagents could each blow past a limit before the orchestrator
  reacts.
- The user-in-the-loop gate needs a single point of control: when a handback
  reports `blocked`, the orchestrator pauses the whole effort and asks the user.
  Parallel subagents would force suspending or discarding in-flight work, wasting
  the tokens already spent.
- Serialization preserves single-writer discipline on shared *code* and on the
  bus files: serial chunks cannot race, so no merge step is needed.

Parallelism is a later optimisation, allowed only on provably disjoint work, and
only once serial behaviour is proven reliable.

## Chunking (granularity + coupling)

A chunk is **the smallest piece of work that has a single deterministic verify
and is worth one subagent onboarding.** Decision 3 sets the floor (small enough
for one runnable verify); the onboarding re-read tax sets the ceiling (big enough
to be worth a cold start).

- The orchestrator sizes chunks within those bounds: it clusters trivially small
  adjacent steps and splits oversized ones, refining from the observed
  partial-handback rate (same best-effort ethos as decision 2).
- **Coupling override:** when work is tightly coupled technically or
  conceptually, the coupling defines the seam — the orchestrator keeps that unit
  whole in one chunk rather than cutting it to fit a budget.
- **Hazard to surface:** a coupled unit *larger* than a subagent's comfortable
  budget is dangerous, because any split (budget-split or partial-handback
  continuation) crosses a context boundary the next subagent cannot see. The
  orchestrator flags these to the user rather than splitting silently.

## Verification & trust

The correctness backbone. A subagent might report `complete` / verify-passed
without actually running the check; trusting a false pass bakes corruption into
the brief tree and compounds across chunks.

- For any **deterministic** verify (tests, build, file exists), the orchestrator
  **re-runs it itself** after the handback, before advancing. This is the only
  true ground truth and is a cheap, short-output call relative to the cost of a
  compounding false pass.
- When a verify is not runnable, require **verbatim evidence** in the handback
  and inspect it.
- **Subjective** verifies ("the design reads well") go to the **user gate** — the
  orchestrator does not self-certify them.

Testing is not a separate stage in this model: writing and running tests is
modeled as verifiable chunks like any other, where a chunk's deterministic verify
is typically its test.

## Workspace state & git

Because subagent edits persist in the shared tree, a failed or `partial` chunk
can leave the working tree physically broken for the next chunk. Re-verification
*detects* breakage but does not recover it.

- The orchestrator records a **known-good checkpoint** before dispatching each
  chunk, using a WIP mechanism it owns (a dedicated branch with WIP commits, or
  `git stash`/tags) that respects the rule "real commits only when the user
  asks."
- If a chunk's re-verify fails, the orchestrator **rolls back** to the checkpoint
  before retry/re-dispatch. Successful chunks advance the checkpoint.
- **Green-on-exit** is the target for completed chunks. Partial handbacks are
  allowed to leave mid-edit state, distinguished from "broken, roll back."
- **Subagents never commit; the orchestrator owns git** (single-writer discipline
  extended to version control).

## Planning phase

Planning is the most critical phase and is interactive by nature, so it keeps a
strong user-in-the-loop:

- The **orchestrator conducts the planning interview itself** (a grill-me-style
  back-and-forth), because a headless subagent cannot talk to the user.
- The **token-heavy legwork** of planning — codebase mapping, "how does X work
  today," gathering constraints — is dispatched to **read-only research
  subagents** whose large reads are discarded on return; only findings come back.
- Planning **decisions and trade-offs stay in the orchestrator-with-user** and
  produce the approved `phases.md` / spec.
- Once the plan is approved, the orchestrator does a deliberate handoff (decision
  1) so build starts on a fresh, lean orchestrator.

## Orchestrator continuity (handoff signals)

The orchestrator is itself a long-lived session that grows. Handing off to a
fresh orchestrator is **user-initiated, on signals from the agent**:

- Primary signal: a deterministic proxy — a chunks-completed count or reaching a
  phase boundary — plus the user watching a real usage/context meter.
- "Context feels large" self-assessment is unreliable (models cannot introspect
  token usage), so it is only a soft early warning, never the trigger.
- The handoff itself reuses `plan-build`: the orchestrator refreshes `HANDOFF.md`
  and a fresh orchestrator cold-starts from it. The bus files and brief tree are
  on disk, so nothing in flight is lost.

## Escape hatches the orchestrator needs

1. **User-in-the-loop gate.** Subagents cannot ask the user. On a `blocked`
   handback the orchestrator surfaces the decision to the user rather than
   guessing.
2. **Orchestrator handoff (user-initiated).** On the signals above, the user
   starts a fresh orchestrator from a refreshed `HANDOFF.md`.
3. **Failure circuit-breaker.** After two failed attempts on the same chunk
   (matching the standing "stop after two failures" rule), stop and ask.
4. **Runaway/loop cap.** Limit auto-dispatched chunks before a mandatory
   check-in, so a drifting plan cannot silently burn tokens.
5. **Phase-boundary pause.** Auto-run within an approved phase plan; pause at
   phase boundaries for approval. This reconciles automation with planning-first:
   the user approves `phases.md` once, the orchestrator runs chunk-by-chunk
   inside it.

## Hypothetical session (time flows downward)

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

## Where the cost moves (it is relocated, not removed)

1. **Orchestrator bloat.** Bounded by the user-initiated orchestrator handoff
   (decision 1); the pattern is recursive — handoff applies at the project level
   and the chunk level.
2. **Onboarding tax per chunk.** Each subagent re-reads its required context on
   cold start; the granularity rule (Chunking) keeps each chunk worth that tax.
3. **Re-verification overhead.** Decision 3 adds an orchestrator-side verify run
   per chunk — deliberate insurance against compounding false passes.
4. **Strict overhead vs. manual handoff.** Per chunk this is strictly more tokens
   than a manual handoff (it adds the orchestrator's read + reason + dispatch +
   verify layer a human did for free). The trade is removing human management
   latency while still winning big against one monolithic session.

## Packaging

A new sibling skill, **`orchestrate-build`**, depending on `plan-build`:

- Reuses `plan-build` artifacts unchanged: `HANDOFF.md` "Required reading" →
  what a subagent loads; `phases.md` `Verify:` → the chunk exit test; the HANDOFF
  format → the handback schema.
- Adds: the `_bus/` pair convention, the dispatch prompt template, the
  re-verify loop, git checkpointing, and the escape hatches.
- Mirrors the existing read-side split (`plan-build` already pairs with
  `resume-work` / `research-repo`); `orchestrate-build` is the opt-in "drive"
  side, so `plan-build` stays slim and usable by a plain human-driven session.

Dispatch prompt template (orchestrator writes into `handoff.md`, then launches a
subagent pointed at it):

> Cold-start. Read `AGENTS.md → HANDOFF.md → [required reading]`. Do `[chunk]`.
> Exit when `[verify]` passes. Budget: `[N]` — if exceeded or not converging,
> STOP and write a `partial` handback with remaining work. On block / ambiguity /
> 2nd failure / scope-creep, STOP and write a `blocked` handback. Do not commit.
> Final action: overwrite `docs/_handoff/_bus/handback.md`, then return it.

## Validation approach

Build the skill and let the user observe efficiency and reliability informally in
real use (decision 8). No formal metrics or kill criterion are imposed now; the
budget numbers (decision 2) and chunk sizing (decision 6) are refined from
observation.

## Open questions / assumptions still to validate

- **Token measurability.** Whether the harness exposes per-subagent token counts
  for even informal observation, or whether only proxies (turn counts, session
  size) are available.
- **Budget defaults.** Starting values for the subagent effort budget (decision
  2) and the runaway/loop cap (escape hatch 4) — to be set from first runs.
- **Coupled-unit-too-big.** The mitigation for a coupled unit larger than one
  subagent budget is "flag to user" (Chunking); a better structural answer may
  emerge with use.
- **Subagent write capability.** Build/test subagents must be write-capable to
  edit files and overwrite `handback.md`; discovery subagents are read-only.
  Confirm both modes are available in the target harness.
