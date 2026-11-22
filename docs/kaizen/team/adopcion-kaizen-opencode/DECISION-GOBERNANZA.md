# Decisión de gobernanza — adopcion-kaizen-opencode

Estado: **BLOQUEADA, pendiente de aprobación humana** | Fecha: 2026-11-22
Autoridad final: **El Presidente** (`.kaizen/team/OWNER.md`)

## Matriz de dictámenes (escuadra mínima, 6 especialistas)

| Rol | Dictamen | Motivo central |
| --- | --- | --- |
| `architect` | **BLOCK** (veto `architecture`) | Sin ownership/aislamiento para 4 equipos; buzón no atómico; `check` no hermético (H-1..H-11) |
| `security` | **BLOCK** | Evidencia no verificable bajo S-2/S-15; efectos REA truncados en el catálogo; ADR-0009 obsoleto |
| `dx` | **BLOCK** | Exit codes fail-open, buzón inactivo, `rc=124`, instalación no literal (F-01..F-08) |
| `verificador-evidencias` | **BLOCK** | `kaizen check` en verde NO VERIFICADO (exit 143 / SIGTERM) |
| `qa` | **BLOCK** | `verify` vacuo con 0 decisiones, artefactos no trackeados; **corrección**: `check` sí pasa en verde sobre el commit `414646b` (EXIT=0); los colgamientos fueron sobre el working tree divergente |
| `knowledge-curator` | **CHANGES_REQUESTED** | Hash de `SOURCES.md` desincronizado de digests; recuento 42/43/44/45 |

**Resultado: 5 BLOCK + 1 CHANGES_REQUESTED. No se otorga APPROVE.**

## Hechos verificados en verde (no basta para aprobar)

- 263 herramientas REA en 11 familias (`catalog.json`), 43 agentes, 10 procesos de gobernanza.
- Fuentes `PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001` presentes como `verified` en `SOURCES.md` (corte 2026-11-21).
- `humano` como A en `reverse_engineering/authorize`; aprobación REA registrada (ADR-0009).
- Estructura, sintaxis y 9 sub-cheques individuales en verde.

## Puerta que no se puede pasar

El KPI del proyecto es «0 normas sin `source_id` verificado **y `scripts/kaizen check` en verde**». **Corrección tardía confirmada por QA y arquitectura:** en un clon limpio del commit `414646b`, `scripts/kaizen check` terminó con `EXIT=0` y `kaizen check: todo en verde` (incluye `ok: tests`). Los colgamientos (rc 124/143) ocurrieron sobre el árbol de trabajo divergente y con nueve checks concurrentes. La segunda mitad del KPI **sí está verificada sobre el estado commiteado**; el hallazgo se reformula como divergencia commit/working-tree (H-4), que sigue bloqueando. Además, `verify` es vacuo con 0 decisiones, por lo que el KPI «0 normas sin fuente» es trivialmente cierto y no demuestra nada.

Conforme a L-3/L-4 y ADR-0003, el proyecto **permanece en `intake`**: sin `decide`, sin `deliver`, sin `verify`, sin commit de los artefactos y sin publicar nueva versión.

## ADRs propuestos (requieren humano)

| ADR | Tema | Origen |
| --- | --- | --- |
| 0011 | Propiedad y aislamiento de equipos (`ownership.json` + worktrees) | architect H-3/H-4 |
| 0012 | Contrato de profundidad por agente (no constante global) | architect H-2 |
| 0013 | Compuerta por capacidad REA (efectos `may_write_filesystem`) | architect H-6, security |
| 0014 | Buzón determinista con claim atómico y ack verificable | architect H-4, QA |
| 0015 | `check` hermético: timeout, lock, sin red, fail-closed | architect H-9, QA, verificador |

Adicionales inmediatos: corregir `now` → `$now` en `kaizen-team:72,82` (bug confirmado), añadir `exit $FAIL` a `kaizen-installer`/`kaizen-start`, regenerar digests tras el cambio de `SOURCES.md`, unificar el recuento de agentes, quitar los tres `|| true` sin issue (S-10) y versionar los artefactos del proyecto.

Todas estas rutas están protegidas (L-4): **no fueron parcheadas por la comunidad**. Requieren ADR y decisión de El Presidente.

## Evidencia

- 10 hallazgos en `.kaizen/loop/outbox/` (S-11), con fingerprints para deduplicación.
- 6 entregables en `docs/kaizen/team/adopcion-kaizen-opencode/<rol>.md`.
- Salida real de `kaizen check` en `check-inicial.md` (cuando el proceso en background termine y reporte su código real).

## Siguiente paso humano

1. Leer los 6 dictámenes y los 10 hallazgos del outbox.
2. Aprobar o rechazar los ADR-0011..0015.
3. Solo entonces autorizar los parches en rutas protegidas y repetir `qa` + `verificador-evidencias`.
4. Con APPROVE unánime y `check` hermético en verde, abrir decisión con `source_ids` y avanzar a `deliver`.
