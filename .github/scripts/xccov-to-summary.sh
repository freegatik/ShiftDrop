#!/bin/bash
# Writes human-readable coverage from an .xcresult bundle to stdout and $GITHUB_STEP_SUMMARY when set.
set -euo pipefail
RESULT="${1:?path to .xcresult}"
OUT_JSON="${2:?path to write coverage JSON}"

if [[ ! -d "$RESULT" ]]; then
  echo "error: xcresult not found at $RESULT" >&2
  exit 1
fi

xcrun xccov view --report --json "$RESULT" >"$OUT_JSON"

BODY="$(python3 - "$OUT_JSON" <<'PY'
import json, sys

path = sys.argv[1]
with open(path, encoding="utf-8") as f:
    data = json.load(f)
lines = ["# Coverage by target", ""]
for t in sorted(data.get("targets", []), key=lambda x: float(x.get("lineCoverage") or 0)):
    name = t.get("name", "")
    line_cov = t.get("lineCoverage")
    if line_cov is None:
        continue
    pct = float(line_cov) * 100.0
    lines.append(f"- **{name}**: {pct:.1f}% line coverage")
print("\n".join(lines))
PY
)"

printf '%s\n' "$BODY"

if [[ -n "${GITHUB_STEP_SUMMARY:-}" ]]; then
  {
    echo "## Code coverage (xccov)"
    echo ""
    printf '%s\n' "$BODY"
  } >>"$GITHUB_STEP_SUMMARY"
fi
