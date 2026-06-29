# plan-build

An installable Cursor/agent skill that creates and maintains a durable,
cold-start-resumable handoff brief tree (`docs/_handoff/*`) for
multi-session discovery and delivery in any project. It is the WRITE/maintain side of
session continuity and pairs with `resume-work` / `research-repo`, which read what it
writes.

## Install

Symlink this directory into a skills path:

```bash
ln -s "$PWD" ~/.agents/skills/plan-build
# optionally also:
ln -s "$PWD" ~/.cursor/skills/plan-build
```

Never place it under `~/.cursor/skills-cursor/` - that directory is reserved for
Cursor's built-in skills.

## Use

Invoke by asking to "set up a handoff", "stand up a project brief", or "wrap up the
session". The skill scaffolds the brief tree from `templates/` and maintains the
artifacts on each wrap-up. See `SKILL.md` for the workflow and `reference.md` for
adoption modes and a worked example.

## Layout

- `SKILL.md` - slim skill body (entry point).
- `reference.md` - methodology detail (adoption modes, worked example).
- `templates/` - parameterized artifact templates (`HANDOFF.md`,
  `process.md`, `product-brief.md`, `tech-brief.md`, `phases.md`, `progress-log.md`).
