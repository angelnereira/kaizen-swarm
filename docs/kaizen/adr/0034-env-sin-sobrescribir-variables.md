# ADR-0034: archivos env no deben sobrescribir variables del entorno

Estado: aceptado el 2026-11-24 por El Presidente (Opción 1: corregir los fallos de `tests/run.sh`)
Fecha: 2026-11-24
Autoridad: autorización humana explícita para tocar `.kaizen/` bajo L-4
Fuentes: evidencia local reproducible (comandos abajo); sin fuente externa

## Contexto
`tests/run.sh` fallaba de dos formas y bloqueaba el hook `pre-push` (RC 124):
1. `KR_DRY_RUN=1 scripts/kaizen-runtime work equipo-central` lanzaba agentes reales con `timeout 900` y colgaba.
2. `KT_LEDGER=/tmp/... scripts/kaizen-tokens record|snapshot` escribía en el ledger real del repo y `snapshot` reventaba con `JSONDecodeError`.

Causa raíz común: los archivos `.kaizen/team/runtime.env` (línea 6, `KR_DRY_RUN=0`) y `.kaizen/finops/tokens.env` (líneas 2-3, `KT_LEDGER=...`, `KT_REPORT=...`) se sourcean con asignación plana **después** de que el entorno externo fijara esas variables, por lo que las sobrescriben. Los scripts ya tenían defaults con `:=`, que son correctos; el problema estaba en los `.env`.

Evidencia real:
- `grep -n KR_DRY_RUN .kaizen/team/runtime.env` → `KR_DRY_RUN=0`.
- `grep -n KT_LEDGER .kaizen/finops/tokens.env` → asignación plana.
- `bash -x tests/run.sh` → 199 `ok`, `FALLA ledger tokens`, y cuelgue en `KR_DRY_RUN=1 scripts/kaizen-runtime work equipo-central`.

## Decisión
Sustituir las asignaciones planas por expansiones con default que respetan el entorno:
- `.kaizen/team/runtime.env`: `KR_DRY_RUN="${KR_DRY_RUN:-0}"`
- `.kaizen/finops/tokens.env`: `KT_LEDGER="${KT_LEDGER:-.kaizen/finops/token-ledger.jsonl}"`, `KT_REPORT="${KT_REPORT:-docs/kaizen/org/TOKENS.md}"`

No se modifica `scripts/kaizen*`, `tests/run.sh` ni `.githooks/`. No se relaja ningún gate: los tests siguen ejecutándose y deben pasar.

## Consecuencias
- Positivas: los gates son deterministas y respetan variables de entorno; el pre-push podrá completarse; se elimina la condición que dejaba procesos `opencode run` colgados.
- Negativas: cambian archivos bajo `.kaizen/` (ruta protegida) — cubierto por la aprobación humana de esta ADR.

## Verificación
1. `bash -x tests/run.sh` → sin `FALLA ledger tokens` y sin cuelgue en `work continuo`.
2. `scripts/kaizen check` → RC 0 (incluye `tests`).
3. `git push -u origin kaizen/open-code-integration` → pasa el hook pre-push y empuja.
4. Si alguno de estos falla, se reporta con RC real; no se usa `--no-verify` (S-10).

## Alternativas descartadas
- `--no-verify` en el push: prohibido por S-10/K-10.
- Saltar `work continuo` del test: ocultaría un fallo real (L-10).
- Borrar el ledger corrupto: enmendaría datos sin causa; el fix de env evita que el test lo use.
