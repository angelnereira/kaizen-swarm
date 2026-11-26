#!/usr/bin/env bash
# Calcula los hashes reales de los 12 documentos fuente y los imprime.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
C="$HERE/cache"
BASE="https://raw.githubusercontent.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/main"
mkdir -p "$C"
while IFS='|' read -r rel remote; do
  [ -z "$rel" ] && continue
  mkdir -p "$C/$(dirname "$rel")"
  curl -fsSL --max-time 60 "$BASE/$remote" -o "$C/$rel"
  printf '%s  %s\n' "$(sha256sum "$C/$rel" | cut -d' ' -f1)" "$rel"
done <<'EOF'
01-hub.md|README.md
best-practices/README.md|best-practices/README.md
threat-intelligence/README.md|threat-intelligence/README.md
threat-hunting/README.md|threat-hunting/README.md
incident-response/README.md|incident-response/README.md
dfir-labs/README.md|dfir-labs/README.md
standard-operating-procedures/README.md|standard-operating-procedures/README.md
maturity-assessment/README.md|maturity-assessment/README.md
vendor-assessment/README.md|vendor-assessment/README.md
templates/incident-report.md|templates/incident-report.md
datasets/README.md|datasets/README.md
detection-as-code/README.md|detection-as-code/README.md
EOF
