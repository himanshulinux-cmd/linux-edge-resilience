#!/bin/sh
set -eu
OUT=${1:-results}
if [ ! -r "$OUT/last_run" ]; then echo 'ERROR: no last_run file' >&2; exit 2; fi
PREFIX=$(cat "$OUT/last_run")
if [ ! -r "${PREFIX}_payload.sha256" ]; then echo 'ERROR: checksum file missing (possibly nonpersistent location)' >&2; exit 3; fi
if sha256sum -c "${PREFIX}_payload.sha256"; then
  echo "PASS: file content matches pre-reboot checksum"
else
  echo "FAIL: file changed/missing after reboot" >&2; exit 1
fi
