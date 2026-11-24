# ADR-0034 — Autorización humana para corregir gates de kaizen en rutas protegidas

- Estado: Aceptado
- Fecha: 2026-11-24
- Responsable: El Presidente (dueño del repositorio)
- Aplica a: `scripts/kaizen-tokens`, `scripts/kaizen-team`, `scripts/kaizen-runtime`

## Contexto
El proyecto `seg-red-rojo-azul` (rama `Debura`) quedó bloqueado en el hook de pre-push porque `scripts/kaizen check` corre `tests/run.sh`, que reportó 4 fallos. Dos causas están identificadas y son preexistentes en `HEAD`:

1. `scripts/kaizen-tokens` trata `KT_LEDGER` como ruta relativa incluso cuando se pasa una ruta absoluta; el test usa `/tmp/kz-test-ledger.jsonl` sobre un clon y falla.
2. `scripts/kaizen-team` construye IDs de handoff con `("H-"+(now|gsub("[^0-9]";"")))`; `now` es numérico y `gsub` exige cadena, así que los handoffs no se escriben y el archivo queda vacío.
3. `scripts/kaizen-runtime work` en modo `dry-run` no marca la tarea como cerrada, por lo que reintenta la misma pendiente en un bucle infinito (test `work continuo` termina por timeout).

Ambos archivos están en `scripts/kaizen*`, ruta protegida por L-4. El agente se negó a modificarlos y a usar `--no-verify` (K-10/S-10) sin autorización.

## Decisión
El Presidente otorga **aprobación explícita y plena** para:
- corregir las dos causas raíz anteriores en las rutas protegidas;
- ejecutar la suite completa de pruebas;
- publicar la rama `Debura` en `origin` una vez que los gates estén en verde.

No se autoriza saltar, desactivar ni falsear ningún gate. La corrección es la única vía permitida.

## Consecuencias
- Se corrige el manejo de rutas absolutas en `KT_LEDGER` (cambio ya presente en el árbol de trabajo, ahora confirmado bajo esta ADR).
- Se convierte `now` a cadena antes de `gsub` en `cmd_assign` y `cmd_handoff`, y se verifica que el archivo `handoffs.jsonl` reciba las líneas.
- Si quedaran fallos, se corrige la causa o se escala de nuevo; nunca se oculta el resultado.
- La autonomía de los agentes no cambia: sigue siendo la declarada (`propose`, sin veto nuevo). Esta ADR autoriza dos correcciones puntuales, no una ampliación de permisos.

## Verificación
- `scripts/kaizen-tokens snapshot` con `KT_LEDGER=/tmp/...` → `input_total=10`.
- `scripts/kaizen-team handoff <slug> a b finding prueba NIST-001` → `wc -l handoffs.jsonl` > 0.
- `bash tests/run.sh` → 0 fallos.
- `git push -u origin Debura` → aceptado por el hook de pre-push.
