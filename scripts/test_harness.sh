#!/bin/sh
set -eu
REPO=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
TEMP=$(mktemp -d)
trap 'rm -rf "$TEMP"' EXIT HUP INT TERM
cd "$TEMP"
sh "$REPO/scripts/edge_probe.sh" smoke results
sh "$REPO/scripts/verify_persistence.sh" results
grep -q '^label=smoke$' results/*_baseline.txt
printf '\n' >> "$(find results -name '*_payload.txt' | head -1)"
if sh "$REPO/scripts/verify_persistence.sh" results >/dev/null 2>&1; then
  echo 'FAIL: corruption was not detected'; exit 1
else
  echo 'PASS: simulated corruption detected'
fi
printf 'PASS: harness smoke tests complete\n'
