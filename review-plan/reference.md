# Review Plan — Reference

Read this file when emitting triage or plan-review reports (workflow steps 4 and 7).

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

### Reliability

- **[plan section / todo id]** Deterministic procedure that would run more reliably as a script. **Recommendation only** (gated by Precision + scope-expansion Ambiguity trigger) — do not bake the script into scope without user approval.

## Proposed Changes

- **Body** — <section>: <one-line description>
- **Frontmatter** — todo `<id>`: <add | remove | edit content | change status from X to Y>

## Summary

<2–3 sentences: overall state of the plan, what's left. End with: "Apply these changes? (yes / no / subset)"
```

Drop gate subsections with zero findings (including **Reliability**). Drop **Findings** or **Proposed Changes** entirely if empty (clean post-update review is valid — say so in summary). Reliability findings are recommendations: list them, but never auto-add the script work to the plan without user approval.

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
