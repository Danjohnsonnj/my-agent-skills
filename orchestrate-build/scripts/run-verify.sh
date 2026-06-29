#!/usr/bin/env bash
# run-verify.sh - run a chunk's deterministic verify command and emit a single
# structured pass/fail line plus the command's own exit code, so the
# orchestrator can branch on ground truth instead of a subagent's claim.
#
# Tier: read/verify -> execute-or-infer. This mutates nothing. If you cannot run
# it, read it as a spec and run the verify command yourself, treating its exit
# code as ground truth.
#
# Usage: scripts/run-verify.sh <command> [args...]
#   e.g. scripts/run-verify.sh npm test
set -uo pipefail

# Intent: a verify with no command is a usage error, not a pass.
if [ "$#" -eq 0 ]; then
  echo "VERIFY ERROR: no command given (usage: run-verify.sh <command...>)" >&2
  exit 2
fi

# Intent: echo the exact command so the run is reproducible from the log.
echo "VERIFY RUN: $*"

# Intent: run the verify, streaming its output, and capture its exit code.
# (No 'set -e' so a non-zero exit reaches the structured line below.)
"$@"
status=$?

# Intent: emit one greppable result line the orchestrator can branch on.
if [ "$status" -eq 0 ]; then
  echo "VERIFY RESULT: OK ($*) exit=0"
else
  echo "VERIFY RESULT: FAIL ($*) exit=$status"
fi

# Intent: propagate the verify's own exit code as ground truth.
exit "$status"
