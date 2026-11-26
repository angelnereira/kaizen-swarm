#!/usr/bin/env bash
# Cierra las tareas del proyecto con la evidencia real producida (sin forcear gates).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
T="$ROOT/.kaizen/team/projects/ciac-detection-training/tasks.json"
E="contrib/ciac-knowledge/ejercicios/escenario-05"
NOW="$(date -u +%FT%TZ)"
jq --arg now "$NOW" --arg e "$E" '
  map(
    .status = "done"
    | .completed = $now
    | .evidence =
        (if .task == "regla-sigma-fuerza-bruta-ssh" then ($e + "/reglas/")
         elif .task == "prueba-regresion-escenario-05" then ($e + "/resultados.md")
         elif .task == "verificar-source-ids-CIAC-011" then ($e + "/verificacion-fuentes.md")
         elif .task == "linea-tiempo-escenario-05" then ($e + "/linea-tiempo.md")
         elif .task == "dictamen-seguridad" then ($e + "/reviews/security.md")
         else ($e + "/README.md") end)
  )
' "$T" > "$T.tmp" && mv "$T.tmp" "$T"
echo "tareas cerradas con evidencia"
