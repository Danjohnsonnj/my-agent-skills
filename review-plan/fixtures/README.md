# review-plan fixtures

## `resumability-stub.plan.md`

Deliberately weak plan for dogfooding the **Resumability** sub-lens. Run standalone `/review-plan` on it (no feedback).

**Expected routing:**

| Finding | Gate / section |
| ------- | -------------- |
| Steps lack deterministic verify | **Completeness** |
| Chat deps ("as discussed", "approach above"), no entry/load set | **Clarity → Resumability** |

## `plans/create-from-session.plan.md`

Plan authored via **Create from session** flow (internal session synthesis → post-author review). Dogfood target for the create-from-session + mandatory post-author review workflow.

**Expected routing:**

| Phase | What to verify |
| ----- | -------------- |
| Session synthesis | Grill-me decisions encoded in Prerequisites table; no chat-only refs |
| Post-author review | Gates 1–5 on finished plan; Mode: Post-author review |
