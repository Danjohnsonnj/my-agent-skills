#!/usr/bin/env bash
# rollback.sh - restore the working tree to the last checkpoint recorded by
# checkpoint.sh, used after a failed re-verify so the next subagent starts from
# green rather than from the broken edits of the failed chunk.
#
# DESTRUCTIVE: discards current tracked changes and removes untracked files
# created since the checkpoint.
# Tier: MUTATING -> execute-or-STOP. If you cannot run this, STOP and surface a
# blocker to the user. Never free-hand a rollback from the prose.
set -uo pipefail

# Intent: this only makes sense inside a git work tree.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ROLLBACK FAIL: not inside a git work tree" >&2
  exit 1
fi

checkpoint_file="docs/_plan/_bus/.checkpoint"

# Intent: refuse to guess a restore point; a checkpoint must already exist.
if [ ! -f "$checkpoint_file" ]; then
  echo "ROLLBACK FAIL: no checkpoint recorded at $checkpoint_file" >&2
  exit 1
fi
checkpoint_sha=$(cat "$checkpoint_file")
echo "ROLLBACK: restoring to checkpoint $checkpoint_sha"

# Intent: discard tracked modifications back to the base commit (HEAD).
git reset --hard HEAD >/dev/null
echo "ROLLBACK: tracked changes reset to HEAD"

# Intent: remove untracked files/dirs created since the checkpoint.
# No -x, so git-ignored files (build output, caches) are left untouched.
git clean -fd >/dev/null
echo "ROLLBACK: untracked files cleaned"

# Intent: re-apply the checkpoint's saved tree only if it differs from HEAD.
# When checkpoint = HEAD (the "no local changes" case) the reset+clean above
# has already restored the exact state, so there is nothing to re-apply.
head_sha=$(git rev-parse HEAD)
if [ "$checkpoint_sha" != "$head_sha" ]; then
  git stash apply "$checkpoint_sha" >/dev/null
  echo "ROLLBACK: checkpoint changes re-applied"
else
  echo "ROLLBACK: checkpoint was clean HEAD; nothing to re-apply"
fi

echo "ROLLBACK RESULT: OK (restored to $checkpoint_sha)"
