#!/usr/bin/env bash
# checkpoint.sh - capture a known-good WIP checkpoint of the working tree
# (tracked + untracked) before dispatching a chunk, WITHOUT creating a real
# commit on any branch. Records the checkpoint SHA so rollback.sh can restore it.
#
# Tier: MUTATING -> execute-or-STOP. If you cannot run this, STOP and surface a
# blocker to the user. Never free-hand a git checkpoint from the prose.
set -uo pipefail

# Intent: this only makes sense inside a git work tree.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "CHECKPOINT FAIL: not inside a git work tree" >&2
  exit 1
fi
echo "CHECKPOINT: git work tree confirmed"

# Intent: where the checkpoint pointer lives, written AFTER the stash below.
# (git stash --include-untracked cleans untracked dirs, so creating the bus dir
# beforehand would just be deleted again.)
bus_dir="docs/_handoff/_bus"
checkpoint_file="$bus_dir/.checkpoint"

label="orchestrate-checkpoint $(date -u +%Y-%m-%dT%H:%M:%SZ)"

# Intent: detect whether there is anything to snapshot (tracked changes or
# untracked files). 'git stash push' exits 0 even when nothing is saved, so its
# exit code cannot be trusted; an empty porcelain status means a clean tree.
if [ -z "$(git status --porcelain)" ]; then
  head_sha=$(git rev-parse HEAD)
  mkdir -p "$bus_dir"
  echo "$head_sha" > "$checkpoint_file"
  echo "CHECKPOINT RESULT: OK (no local changes; checkpoint = HEAD $head_sha)"
  exit 0
fi

# Intent: snapshot tracked + untracked work into a stash entry. This moves no
# branch and creates no real commit.
git stash push --include-untracked --message "$label" >/dev/null

# Intent: restore the working tree to exactly what it was (apply, do NOT pop),
# leaving the stash entry intact as the recoverable checkpoint.
git stash apply --index >/dev/null 2>&1 || git stash apply >/dev/null 2>&1

# Intent: record the stash commit SHA (stable even as the stash stack grows).
# Written after the stash so the pointer is not itself part of the snapshot.
checkpoint_sha=$(git rev-parse "stash@{0}")
mkdir -p "$bus_dir"
echo "$checkpoint_sha" > "$checkpoint_file"
echo "CHECKPOINT RESULT: OK (recorded $checkpoint_sha; working tree restored)"
