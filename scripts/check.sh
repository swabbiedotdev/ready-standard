#!/bin/sh
# Checks this repository against a Ready Room checkout:
#   1. the template package validates with 0 errors and 0 warnings;
#   2. the committed JSON Schema matches the one Ready Room generates.
# Usage: scripts/check.sh <ready-room-checkout>   (or set READY_ROOM)
set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
ready_room=${1:-${READY_ROOM:-}}
if [ -z "$ready_room" ] || [ ! -f "$ready_room/app/scripts/pip.ts" ]; then
  echo "usage: scripts/check.sh <ready-room-checkout>" >&2
  exit 2
fi
ready_room=$(cd "$ready_room" && pwd)
pip="$ready_room/app/scripts/pip.ts"
skill="$root/skills/ready-standard"

echo "Ready Room: $ready_room ($(git -C "$ready_room" rev-parse --short HEAD 2>/dev/null || echo unknown))"

echo "== Validating the template package"
out=$(node "$pip" validate "$skill/assets/template-package")
echo "$out"
echo "$out" | tail -1 | grep -qx '0 errors, 0 warnings' || {
  echo "Template package must report 0 errors, 0 warnings" >&2
  exit 1
}

echo "== Comparing the JSON Schema"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
(cd "$tmp" && node "$pip" schema "$tmp/ready.schema.json" >/dev/null)
if ! cmp -s "$tmp/ready.schema.json" "$skill/assets/ready.schema.json"; then
  echo "assets/ready.schema.json differs from Ready Room's schema." >&2
  echo "Regenerate it: node $pip schema $skill/assets/ready.schema.json" >&2
  echo "then review references/format.md and the templates for the change." >&2
  exit 1
fi
echo "Schema matches."
