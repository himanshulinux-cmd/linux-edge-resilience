#!/bin/sh
# Portable Linux baseline and persistence probe. Run as a normal user.
set -eu
LABEL=${1:-debian}
OUT=${2:-results}
mkdir -p "$OUT"
STAMP=$(date -u +%Y%m%dT%H%M%SZ)
PREFIX="$OUT/${LABEL}_${STAMP}"
{
 echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
 echo "label=$LABEL"
 echo "hostname=$(hostname)"
 if [ -r /etc/os-release ]; then grep -E '^(PRETTY_NAME|VERSION_ID|ID)=' /etc/os-release; fi
 echo "kernel=$(uname -r)"
 echo "machine=$(uname -m)"
 if [ -r /proc/meminfo ]; then grep -E '^(MemTotal|MemAvailable):' /proc/meminfo; fi
 if [ -r /proc/uptime ]; then echo "uptime_seconds=$(cut -d' ' -f1 /proc/uptime)"; fi
 echo '[mount_root]'; (mount | grep ' on / ' || true)
 echo '[disk]'; df -k .
 echo '[boot_analysis]'; if command -v systemd-analyze >/dev/null 2>&1; then systemd-analyze || true; else echo 'not available (not a systemd system)'; fi
} > "${PREFIX}_baseline.txt"
printf '%s\n' 'CSC579 test payload: saved before reboot' > "${PREFIX}_payload.txt"
sha256sum "${PREFIX}_payload.txt" > "${PREFIX}_payload.sha256"
printf '%s\n' "${PREFIX}" > "$OUT/last_run"
echo "Baseline saved: ${PREFIX}_baseline.txt"
echo "Payload saved: ${PREFIX}_payload.txt"
echo "Checksum saved: ${PREFIX}_payload.sha256"
echo 'NEXT: reboot normally, then run scripts/verify_persistence.sh results'
