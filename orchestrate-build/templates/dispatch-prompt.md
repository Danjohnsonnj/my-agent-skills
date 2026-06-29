<!-- The literal cold-start prompt the orchestrator launches a subagent with,
     after overwriting docs/_handoff/_bus/handoff.md for this chunk. Pass it
     verbatim. For discovery legwork during planning, launch a read-only
     subagent with the same step 1-2 framing but a research goal and no edits. -->

Cold-start sub-session. Do not assume any prior context.

1. Read AGENTS.md -> docs/\_handoff/HANDOFF.md -> the "Required reading" listed
   in docs/\_handoff/\_bus/handoff.md.
2. Do exactly the chunk described in docs/\_handoff/\_bus/handoff.md. Stay in
   scope; the brief names what is out of scope.
3. Exit when the chunk's deterministic verify passes. Budget: stop if you exceed
   it or stop converging -> emit a `partial` handback with the remaining work.
4. STOP and hand back early on any of: blocked, ambiguous, 2nd failure on the
   same step, scope-creep.
5. Do NOT commit. Leave the working tree green if your status is `complete`.
6. Final action: overwrite docs/\_handoff/\_bus/handback.md from
   templates/handback.md, then return that handback as your message.
