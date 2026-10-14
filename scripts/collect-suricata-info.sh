#!/usr/bin/env bash
set -u
echo "=== Suricata lab information ==="
if ! command -v suricata >/dev/null 2>&1; then
  echo "Suricata command not found. Run this inside the environment where Suricata is installed."
  exit 1
fi
echo "--- Version ---"
suricata -V
echo "--- Build information (if supported) ---"
suricata --build-info 2>&1 || true
echo "--- Common log paths ---"
for f in /var/log/suricata/fast.log /var/log/suricata/eve.json; do
  if [ -r "$f" ]; then ls -lh "$f"
  elif [ -e "$f" ]; then echo "$f exists but is not readable"
  else echo "$f not found; path or logging may differ"
  fi
done
echo "Read-only information check complete."
