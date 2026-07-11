# Review Plan — Reference

Read at workflow step 6 (Resumability checklist, Finding placement) and when emitting reports (steps 4 and 7).

## Triage Report Template

```markdown
# Plan Feedback Triage: <plan name>

**Plan:** `<plan path>`
**Feedback source:** <inline | path | prior agent output>
**Items:** <N approved · M declined>

## Approved

| #   | Item             | Gate(s)                | Rationale / proposed edit |
| --- | ---------------- | ---------------------- | ------------------------- |
| 1   | "verbatim quote" | Accuracy, Completeness | …                         |

## Declined

| #   | Item             | Gate(s) failed | Rationale (factual reason) |
| --- | ---------------- | -------------- | -------------------------- |
| 2   | "verbatim quote" | Accuracy       | …                          |

## Summary

<2–3 sentences: themes in the feedback, how the plan held up. End with: "Apply all approved items? (yes / no / subset: list item numbers)"
```

Drop any section that would be empty.

## Plan-Review Report Template

```markdown
# Plan Review: <plan name>

**Plan:** `<plan path>`
**Mode:** <Post-update review | Standalone review>
**Verification:** <check-refs.py: X/Y link refs OK · M PR/branch refs resolved · K items unverified>

## Findings

### Accuracy

- **[plan section / todo id]** Finding. Proposed edit.

### Completeness

- **[plan section / todo id]** Finding. Proposed edit.

### Concision

- **[plan section / todo id]** Finding. Proposed edit.

### Precision

- **[plan section / todo id]** Finding. Proposed edit.

### Clarity

- **[plan section / todo id]** Finding. Proposed edit.

General coherence findings stay under `### Clarity`. Cold-start checklist failures go under `#### Resumability`.

#### Resumability

- **[plan section / todo id]** Cold-start finding. Proposed edit.

### Reliability

- **[plan section / todo id]** Deterministic procedure that would run more reliably as a script. **Recommendation only** (gated by Precision + scope-expansion Ambiguity trigger) — do not bake the script into scope without user approval.

## Proposed Changes

- **Body** — <section>: <one-line description>
- **Frontmatter** — todo `<id>`: <add | remove | edit content | change status from X to Y>

## Summary

<2–3 sentences: overall state of the plan, what's left. End with: "Apply these changes? (yes / no / subset)"
```

Drop gate subsections with zero findings (including **Reliability**). Drop `#### Resumability` if empty. Drop **Findings** or **Proposed Changes** entirely if empty (clean post-update review is valid — say so in summary). Reliability findings are recommendations: list them, but never auto-add the script work to the plan without user approval.

## Cold-start implementable

Operational meaning of the intro promise _"cold-start implementable"_. Apply as the **Resumability** sub-lens under Clarity at workflow step 6.

| Check | Pass criterion |
| ----- | -------------- |
| Entry | Plan states start file + section (or `HANDOFF.md`) |
| Load set | Required context as markdown links; optional "do not load" when progressive disclosure applies |
| Zero chat deps | No "as discussed", "above approach", or session-only refs without durable pointer |
| Prerequisites | Branch, env, tools, user gates — stated or explicitly N/A |
| Per step/chunk | Action + deterministic verify (command, script, test, observable state). _Verify gaps → Completeness only (Finding placement)._ |
| Out of scope | Explicit, not implied |
| One path | No A/B forks (Ambiguity Protocol + Clarity) |
| Link form | Paths the executor must load → markdown links (machine-checked by `check-refs.py`). Exception: under HANDOFF **Required reading (this phase)**, plain `docs/_plan/*.md` paths are OK (plan-build convention). Elsewhere, use markdown links. |

## Finding placement

| Finding type | Gate / section |
| ------------ | -------------- |
| Missing per-step verify | Completeness only |
| Entry, load set, chat deps, prerequisites, out of scope, one path, link form (non-excepted) | Clarity → `#### Resumability` |
| todo↔body, execution order, stale steps | `### Clarity` only |
| Token bloat, duplication, unscoped explore | Concision only |
| Overlap | One primary gate; cross-ref the other in prose |

### Recommended plan sections

Optional — propose localized additions when a check fails; not forced schema:

```markdown
## Required reading
- [tech-brief](docs/_plan/tech-brief.md) — why load it

## Prerequisites
- Branch: `feature/foo`; env: N/A

## Out of scope
- …
```

### plan-build integration

Run only when the plan references `docs/_plan/` or `HANDOFF.md`:

- HANDOFF names current phase + single next action
- "Required reading" matches what steps actually need; agent loads only those leaves, not the whole tree
- Other leaves pulled from Index on demand only
- `process.md` read before commit
- No fact duplicated outside its canonical brief
- `lessons.md` in load set when phase reuses prior gotchas

## Extended Anti-patterns

Beyond workflow rules — common failure modes:

- Skip Phase 1 triage when feedback supplied — hides which items shaped edits.
- Reword feedback into agent voice when listing — keep verbatim quotes.
- Introduce todos for scope not in feedback or a genuine completeness finding — flag added scope explicitly.
- Restructure body wholesale — localized edits only unless Clarity is the gate violation.
- Change todo `id` values — breaks chat history, status files, cross-plan refs.
- Record `A or B` forks in steps/findings — ask user first; plan reads as one path.
- Delete/weaken tests, assertions, `@deprecated`, or behavior comments without user confirmation.
- Widen scope on feedback/finding alone — surface scope question before touching files outside plan.

Concision / token-efficiency — see Finding placement; file under Concision unless the issue is load-set/entry omission (then Resumability):

- Restated motivation/history that does not change execution
- Duplicated facts across body, todos, frontmatter
- Unscoped "explore the codebase" without paths
- Large inline code where a markdown link suffices
