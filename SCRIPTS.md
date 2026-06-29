# SCRIPTS.md - authoring conventions for executable skills

Author-facing conventions for the "executable over prose" layer in this suite.
This file is read by the human author when adding or editing a skill's scripts.
It is **not** loaded at agent runtime, so it does not introduce a shared runtime
dependency (see the self-contained rule below).

The goal is **execution reliability/determinism**, not token savings: a script
runs the same way every time, where free-form prose re-derived each run does not.

## Where scripts live (self-contained)

Each skill owns its scripts under its **own** `scripts/` directory
(`<skill>/scripts/*.sh`, `*.py`). There is **no** shared repo-root script
directory: skills are installed individually as per-skill symlinks, so a shared
directory would not resolve from an installed skill. If real duplication appears
across skills, promote a dedicated "toolkit" skill rather than a loose shared
folder.

## The script is the single source of truth (B-prime)

A skill never describes a scripted step in prose and *also* keeps the script as
an optional extra. The script is the source of truth; the SKILL.md text is the
thin spec the script encodes. Invocation is **execution-first, never a free
choice**. Use this phrasing wherever a SKILL.md reaches a scripted step:

> Run `scripts/<name>`. It is the single source of truth for this step. Only if
> you cannot execute it, read it and perform the equivalent steps it documents.

Do not write "you may run the script" or "optionally run". The agent runs it by
default and only falls back to reading-as-spec when execution is genuinely
unavailable.

## Tiered fallback: read/verify vs mutating

The fallback when execution is unavailable depends on what the script does.

- **read/verify scripts** (inspect state, run a verify, emit structured output):
  tier is **execute-or-infer**. If you cannot run it, read it as a spec and
  perform the equivalent inspection by hand. Failing over is safe because the
  script changes nothing.

  > ...Only if you cannot execute it, read it as a spec and perform the
  > equivalent checks yourself.

- **mutating scripts** (git checkpoint/rollback, scaffolding, overwriting the
  bus, any destructive op): tier is **execute-or-STOP**. If you cannot run it,
  **stop and surface a blocker / user gate** - never free-hand a destructive
  operation from the prose.

  > ...This step is mutating: if you cannot execute it, STOP and surface a
  > blocker to the user. Never free-hand a destructive operation.

State the tier in a comment at the top of every script so the fallback is
unambiguous at the point of use.

## Legible-spec style

Scripts are read as specs when they cannot be run, so they must read like one.

- **Clear names.** `checkpoint.sh`, `rollback.sh`, `run-verify.sh` - the name is
  the intent. No abbreviations that need decoding.
- **One intent comment per check/step**, stating *why*, not restating the code.
- **Explicit echo of each step's result** so a run produces a legible log and a
  reader can follow the sequence without executing it.
- **No clever one-liners.** Prefer a few obvious lines over a dense pipeline.
  Avoid plumbing tricks (`write-tree`/`commit-tree` gymnastics, nested
  substitutions) where a plain command reads clearly.
- **Structured, greppable output** for verify scripts: a single result line the
  caller can branch on (e.g. `VERIFY RESULT: OK (...) exit=0` /
  `VERIFY RESULT: FAIL (...) exit=2`) plus the underlying exit code.

## Runtime: bash-dominant, python on demand (D8)

The suite is polyglot but **bash-dominant**.

- Use `*.sh` (`#!/usr/bin/env bash`) for glue, git mechanics, and verify wrappers.
- Use `*.py` (`#!/usr/bin/env python3`) only when parsing or structured output
  genuinely demands it - e.g. walking a plan file to extract and validate
  `path:line` references. Reach for python because the task needs a parser, not
  by default.

Make every script executable (`chmod +x`) and runnable from the skill directory
with a relative path (`scripts/<name>`).

## Harvesting lessons into the suite (human-gated)

The suite improves in two tiers, and only the first is automatic.

- **Type-1 (automatic, per project):** `plan-build` accretes a `lessons.md` leaf
  under each project's `docs/_handoff/` - reusable gotchas, script/verify
  outcomes, and crystallization candidates - and carries it in cold-start
  Required reading. This is local learning; it changes no skill.
- **Type-2 (manual, the harvest ritual):** periodically review the accumulated
  `lessons.md` files across projects. Where a signal **recurs** - the same gotcha
  bites repeatedly, or the same `Crystallize?` candidate keeps appearing - turn it
  into a **proposed** edit to a skill's `SKILL.md` or `scripts/`.

The cage (D7): the control plane (skills and their scripts) is **never auto-edited
from learnings**. A harvested signal becomes a written proposal that goes through
`review-plan` - whose execution-reliability lens is built to flag exactly these
crystallization candidates - and lands only after the usual user-gated approval.
This section documents a process; it adds no automation.
