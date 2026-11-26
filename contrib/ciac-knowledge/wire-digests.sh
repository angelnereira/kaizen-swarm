#!/usr/bin/env bash
# Añade la ruta del digest CIAC al campo knowledge: de las definiciones que recibieron feed.
# Cambio acotado, auditable y reversible; no aumenta autonomía ni vetos.
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
FEED="$ROOT/scripts/kaizen-org"
DIG="$ROOT/.kaizen/org/knowledge/digests"
P="$ROOT/.kaizen/org/prompts"
n=0
for f in "$DIG"/*.md; do
  [ -f "$f" ] || continue
  id="$(basename "$f" .md)"
  grep -q 'CIAC-0' "$f" || continue
  prompt="$P/$id.md"
  [ -f "$prompt" ] || { echo "OMITIDO (sin definicion): $id"; continue; }
  rel=".kaizen/org/knowledge/digests/$id.md"
  if grep -qF "$rel" "$prompt"; then echo "YA CABLEADO: $id"; continue; fi
  grep -q '^knowledge:' "$prompt" || { echo "FALLO (sin campo knowledge): $id"; exit 1; }
  sed -i "s|^knowledge: \[|knowledge: [$rel, |" "$prompt"
  if ! grep -qF "$rel" "$prompt"; then echo "FALLO al escribir: $id"; exit 1; fi
  "$FEED" save "$id" --no-bump >/dev/null
  echo "CABLEADO: $id"
  n=$((n+1))
done
echo "TOTAL cableados: $n"
