# Dispatch brief - chunk {{CHUNK_ID}}

<!-- Orchestrator is the ONLY writer of this file. Overwrite it in place each
     cycle. The subagent reads it and does exactly this one chunk. -->

**Chunk:** {{ONE_LINE_WHAT_THIS_CHUNK_IS}}

**Scope:** Do exactly {{X}}. If you find yourself doing {{Y_OUT_OF_SCOPE}}, STOP
and hand back.

**Required reading (load only these):**

- `docs/_plan/HANDOFF.md`
- {{LEAF_OR_CODE_PATH}} - {{WHY}}

**Deterministic verify (the chunk exit test):** {{COMMAND_OR_CHECK}}

**Budget:** {{N}} tool-calls/attempts. If exceeded or not converging, STOP and
emit a `partial` handback with the remaining work.

**Return-early triggers:** blocked / ambiguous / 2nd failure on the same step /
scope-creep (report any of these via the `blocked` status).

**Hard constraints / invariants:** {{INVARIANTS_OR_NONE}}. Do NOT commit.

**Final action:** overwrite `docs/_plan/_bus/handback.md` from
templates/handback.md, then return it.
