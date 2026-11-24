## Resumen
Ordenar por proceso (sin tocar el fondo) el BLOCK de arquitectura en outsourcing-tech: 3/3 tareas con dueño, decisión verificada, handoffs con ack y escalado ADR a El Presidente.

## Componente afectado
Coordinación de equipo — `.kaizen/team/projects/outsourcing-tech/` (datos del orquestador, sin código ni rutas protegidas).

## Tipo de cambio
- [x] documentation
- [x] refactor (solo consolidación de datos del proyecto; no se parchean scripts)

## Documentos relacionados
- `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md`, `DECISIONES.md`
- `.kaizen/loop/outbox/arquitectura-block-adopcion.md` (BLOCK de arquitectura, H-1..H-11)
- `.kaizen/team/OWNER.md` (reporte a El Presidente)
- ADR-0011..0015 **pendientes** (no existen; requieren humano, L-4)
- `.kaizen/loop/outbox/kaizen-team-init-precreated-dir.md` y reincidencia de `kaizen-team-handoff-now`

## Plan de prueba
- `bash scripts/kaizen-team verify outsourcing-tech` → rc=0, todas las decisiones con fuentes verificadas.
- `bash scripts/kaizen-team check` → rc=0, 25 fuentes verificadas.
- `bash scripts/kaizen-team sync outsourcing-tech` → acuses pendientes=1, tareas abiertas=3, decisiones verificadas=1.
- `jq -r '.[] | select(.owner=="?") | .task' .kaizen/team/projects/outsourcing-tech/tasks.json` → vacío (0 tareas sin dueño).
- `jq -r '[.id,.status]|@tsv' .kaizen/team/projects/outsourcing-tech/handoffs.jsonl` → 3 `ack`, 1 `open` (broadcast, documentado).
- `sha256sum .kaizen/org/knowledge/SOURCES.md` → `11e960129d7e6f6f…` (coherente con el finding de trazabilidad).
- `bash scripts/kaizen check` → **NO VERIFICADO**: se colgó >120 s en `tests/run.sh` (H-9, check no hermético); no se afirma verde ni rojo.

## Impacto en calidad (ratchet)
- Cobertura: igual (no hay código nuevo).
- Advertencias: igual.
- Deuda (TODO/FIXME): igual.
- Sin supresiones S-10; ningún `--no-verify` ni CI desactivado.

## Criterios de salida que avanza
- 0 tareas sin dueño al cierre del standup (KPI facilitador). ✔
- DEC-001 con `source_ids` verificados y `verify` en verde (REG-EV-01). ✔
- Handoff con ack real de los tres destinatarios convocados. ✔
- Veto `architecture` intacto; sin avance forzado de etapa. ✔
- Escalado `needs-human` con opción recomendada y plazo. ✔

## Aprendizaje (opcional)
`init` confunde directorio con estado y `assign` pierde handoffs por `now` vs `$now` en jq; en nivel 3 no se parchea (L-4): se documenta (S-11), se aplica workaround en datos y se escala. Centralizar los acuses evitó reproducir el hallazgo "buzón no atómico" que originó el BLOCK. Lección: `.kaizen/learning/lessons/facilitador-equipo/2026-11-22-002-blocker.md`.

## Cierre de issues
Closes: none — origen: hallazgo del outbox `arquitectura-block-adopcion.md`, sin issue numerado; no se fabrica un número (K-10).

## Checklist
- [x] Compila (no aplica: sin código)
- [ ] Pasa tests — `scripts/kaizen check` sin resultado hermético (H-9); no se afirma verde
- [x] Documentación actualizada (standup, blackboard, DEC-001, acks, diario, outbox)
- [x] Línea base no empeora
