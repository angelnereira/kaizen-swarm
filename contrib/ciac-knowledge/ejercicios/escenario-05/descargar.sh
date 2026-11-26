#!/usr/bin/env bash
# Descarga los tres archivos necesarios para la prueba de regresión (solo lectura).
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HERE/datos"
B="https://raw.githubusercontent.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/main/datasets"
curl -fsSL --max-time 60 "$B/fuentes/linux-auth/linux-auth.jsonl" -o "$HERE/datos/linux-auth.jsonl"
curl -fsSL --max-time 60 "$B/fuentes/firewall/firewall.jsonl" -o "$HERE/datos/firewall.jsonl"
curl -fsSL --max-time 60 "$B/soluciones/verdad-terreno.csv" -o "$HERE/datos/verdad-terreno.csv"
sha256sum "$HERE/datos/"*
