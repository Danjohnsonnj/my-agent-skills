#!/usr/bin/env python3
"""check-refs.py - verify every file reference in a plan points at a real file
(and, when a line is cited, that the line is in range). Feeds gate 1 (Accuracy)
of review-plan at workflow step 6.

Tier: read/verify -> execute-or-infer. This mutates nothing. If you cannot run
it, read it as a spec and spot-check the cited paths/lines by hand.

Python (not bash) because the job is parsing structured references out of text
and range-checking line numbers - exactly the case where D8 calls for python.

What counts as a reference (the one deterministic, unambiguous form):
  - Markdown link targets:  [label](path), [label](path:line),
                            [label](path#Lstart-Lend)
Inline backtick mentions (`AGENTS.md`, `scripts/`, `*.sh`) and free-prose
mentions ("SKILL.md line 18") are deliberately NOT machine-parsed: they are
ambiguous between a concrete file reference and a concept mention, so checking
them mechanically yields false failures. The reviewer spot-checks those by hand
under gate 1; this script gives a trustworthy verdict on the explicit links.

Usage: check-refs.py <plan-file> [--base <dir>]
  --base defaults to the current working directory (references in these plans
  are usually repo-root-relative). The plan's own directory is tried as a
  fallback resolution base.
"""
import os
import re
import sys

URL_PREFIXES = ("http://", "https://", "mailto:", "ftp://")


def parse_line_spec(target):
    """Split a raw target into (path, max_line_or_None).

    Recognises a trailing ':N', ':N-M', '#LN', or '#LN-LM'. Anything else after
    a '#' is treated as a section anchor and dropped (path only, no line check).
    """
    # Line form: path#Lstart or path#Lstart-Lend
    m = re.search(r"#L(\d+)(?:-L?(\d+))?$", target)
    if m:
        path = target[: m.start()]
        hi = int(m.group(2)) if m.group(2) else int(m.group(1))
        return path, hi

    # Section anchor (not a line): drop it, no line check.
    if "#" in target:
        return target.split("#", 1)[0], None

    # Line form: path:N or path:N-M  (only when the suffix is purely numeric)
    m = re.search(r":(\d+)(?:-(\d+))?$", target)
    if m:
        path = target[: m.start()]
        hi = int(m.group(2)) if m.group(2) else int(m.group(1))
        return path, hi

    return target, None


def strip_fenced_code(text):
    """Remove ``` fenced code blocks so example links/markup inside them are not
    mistaken for real references."""
    return re.sub(r"```.*?```", "", text, flags=re.DOTALL)


def collect_targets(text):
    """Return a de-duplicated, order-preserving list of markdown link targets,
    excluding glob patterns (a '*' means a pattern, not a concrete file)."""
    targets = []
    seen = set()
    for t in re.findall(r"\[[^\]]*\]\(([^)]+)\)", strip_fenced_code(text)):
        t = t.strip()
        if t and "*" not in t and t not in seen:
            seen.add(t)
            targets.append(t)
    return targets


def resolve(path, bases):
    """Return the first existing resolution of path across the given bases, or
    None. Absolute paths are checked as-is."""
    candidate = os.path.expanduser(path)
    if os.path.isabs(candidate):
        return candidate if os.path.exists(candidate) else None
    candidate = candidate[2:] if candidate.startswith("./") else candidate
    for base in bases:
        full = os.path.join(base, candidate)
        if os.path.exists(full):
            return full
    return None


def file_line_count(path):
    with open(path, "r", encoding="utf-8", errors="replace") as fh:
        return sum(1 for _ in fh)


def main(argv):
    base = os.getcwd()
    args = []
    rest = argv[1:]
    i = 0
    while i < len(rest):
        if rest[i] == "--base" and i + 1 < len(rest):
            base = rest[i + 1]
            i += 2
        else:
            args.append(rest[i])
            i += 1

    if len(args) != 1:
        print("CHECK-REFS ERROR: usage: check-refs.py <plan-file> [--base <dir>]",
              file=sys.stderr)
        return 2

    plan_path = args[0]
    if not os.path.isfile(plan_path):
        print(f"CHECK-REFS ERROR: plan file not found: {plan_path}",
              file=sys.stderr)
        return 2

    with open(plan_path, "r", encoding="utf-8", errors="replace") as fh:
        text = fh.read()

    plan_dir = os.path.dirname(os.path.abspath(plan_path))
    bases = [base, plan_dir]

    print(f"CHECK-REFS: {plan_path}")
    targets = collect_targets(text)

    ok = missing = out_of_range = 0
    skipped = 0

    for raw in targets:
        # Intent: skip URLs and bare anchors - they are not local file refs.
        if raw.startswith(URL_PREFIXES) or raw.startswith("#"):
            skipped += 1
            continue

        path, max_line = parse_line_spec(raw)
        resolved = resolve(path, bases)

        if resolved is None:
            print(f"REF MISSING: {raw}")
            missing += 1
            continue

        if max_line is None or os.path.isdir(resolved):
            print(f"REF OK: {raw}")
            ok += 1
            continue

        total = file_line_count(resolved)
        if max_line <= total:
            print(f"REF OK: {raw} (file has {total} lines)")
            ok += 1
        else:
            print(f"REF LINE-OUT-OF-RANGE: {raw} (file has {total} lines)")
            out_of_range += 1

    problems = missing + out_of_range
    if problems == 0:
        print(f"CHECK-REFS RESULT: OK ({ok} refs present, {skipped} non-file skipped)")
        return 0

    print(f"CHECK-REFS RESULT: FAIL ({ok} OK, {missing} missing, "
          f"{out_of_range} out-of-range, {skipped} non-file skipped)")
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
