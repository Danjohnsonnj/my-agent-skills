---
name: start-interview
description: >-
  Interview the user relentlessly about a plan or design until reaching shared
  understanding, resolving each branch of the decision tree. Use when user wants
  to stress-test a plan, get interviewed on their design, or invokes
  /start-interview.
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time in the native chat session (no IDE Questions UI). Use this proceedure when the interview surfaces a decision with multiple viable paths, structuring the turn as:

1. **Decision** — plain language: what we are choosing and why it matters for scope, risk, or implementation
2. **Options** — for each path: short title, then **Pros** and **Cons** (use **Tradeoffs** when two paths are both reasonable). Option letters (A, B, …) are optional reply handles **only after** this substance exists
3. **Recommendation** — name the preferred path. **Because:** one to three short sentences tied to ticket, research, Change size, or out-of-scope limits
4. **Wait** — user chooses before the next beat

**Shortcuts:**

- **User directive:** user states a requirement without a prior question — acknowledge and continue; no synthetic options beat
- **X-Small / obvious path:** recommendation + brief because may suffice without full pros/cons
- **Explore:** same format when forks exist; fewer beats overall

If a question can be answered by exploring the codebase, explore the codebase instead.

When the session is over, recommend switching to plan mode before implementation.
