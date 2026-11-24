decision_id: DEC-004
topic: Asignar-y-escalar-check-rojo-marketing-visual
source_ids: ["PA-001", "LOCAL-001", "LOCAL-003", "LOCAL-004"]
retrieved: 2026-11-24T04:42:56Z
status: verified
human_owner: gerente
---
# Decisión: Asignar y escalar `kaizen check` en rojo por `marketing-visual` sin gobernanza

## Observación → Evidencia → Impacto → Propuesta → Pregunta

- **Observación:** la puerta global `scripts/kaizen check` sigue en rojo; `kaizen-gov check` ya está en verde, pero el catálogo de agentes quedó desincronizado tras la aparición concurrente de `.kaizen/org/prompts/marketing-visual.md`.
- **Evidencia:** salida de comando reproducible (abajo) + 4 `source_ids` `verified`. Ninguna fuente `pending`/`conflict`/`stale` (REG-EV-01).
- **Impacto:** la puerta global bloquea; no se silencia ni se salta (S-10/K-10). El arreglo toca gobernanza/catálogo (L-4) y requiere ADR humano: fuera de mi autoridad (`resource`).
- **Propuesta:** asignar a `gerente`, abrir handoffs con sobre completo, cerrar esta decisión de proceso verificada y escalar el ADR a El Presidente. Sin tocar el fondo ni mover la etapa.
- **Pregunta concreta a El Presidente:** ¿autoriza el ADR para regenerar el catálogo de `marketing-visual` (`kaizen-org catalog`) antes del `2026-11-26T18:00:00Z`?

## Evidencia (comandos ejecutados, UTC 2026-11-24)

| Comando | Salida real | rc |
| --- | --- | ---: |
| `scripts/kaizen check` | `ok: descriptores / politicas / formato / lint / tests`; `FALLA: swarm`; `FALLA: organizacion`; `ok: deuda 0 <= 0`; `kaizen check: FALLO` | 1 |
| `scripts/kaizen-org check` | `FALLA: catálogo desc.sincronizado (80 vs 81)` | 1 |
| `scripts/kaizen-gov check` | `kaizen-gov check: todo en verde (81 agentes, 12 procesos)` | 0 |
| `scripts/kaizen-swarm check` | `FALLA: kaizen-org check en rojo` | 1 |
| `scripts/kaizen-team status equipo-central` | `equipo-central: intake` | 0 |
| `scripts/kaizen-team sync equipo-central` | `acuses pendientes=3 \| tareas abiertas=6 \| decisiones verificadas=3` | 0 |
| `scripts/kaizen-meta drift` | `TypeError: 'int' object is not subscriptable` (fallo conocido `387791946`; no bloquea esta decisión de proceso) | 1 |

- Artefactos: `.kaizen/org/catalog.json` → `.count = 80`; el registro reconstruido tiene `81` entradas; `marketing-visual` **no aparece** en `docs/kaizen/org/CATALOGO-AGENTES.md`; `.kaizen/org/prompts/marketing-visual.md` está sin versionar y con `status: paused` y nota «Especializacion pendiente de refinement y aprobacion (K-5/ADR)».
- El outbox `20261123-check-rojo-marketing-visual.md` (fingerprint `20261123-check-rojo-marketing-visual`) puede estar desactualizado en el punto «gobernanza»: hoy `kaizen-gov check` está en verde. Se reporta la evolución sin borrar el hallazgo original.
- **Anclaje de fuentes:** `PA-001` (Gaceta Oficial, Ley 81/2019), `LOCAL-001`, `LOCAL-003`, `LOCAL-004` — todas `| verified |` en `.kaizen/org/knowledge/SOURCES.md` (fecha de corte 2026-11-21). Son el anclaje exigido por REG-EV-07; el hallazgo técnico se apoya en comandos reproducibles, no en interpretar esos documentos. `PA-009`, `PA-012`, `PA-015`, `INT-002` siguen `pending` y no se usan.
- Lección aplicada: fingerprint `2188522920` — no usar `kaizen-team assign` (duplica y salta a `execute`) ni `kaizen-team handoff` (escribe `source_ids` como cadena y omite `correlation_id`/`deadline`, fingerprint `998952383`). Asignación y handoffs escritos con sobre completo; ack de recepción registrado con `kaizen-team ack`.

## Opciones y decisión

| Opción | Coste | Riesgo | Reversibilidad |
| --- | --- | --- | --- |
| **A. Asignar a `gerente` + ADR humano + escalar a El Presidente (ELEGIDA)** | 3 tareas, 4 handoffs, 1 ADR | La puerta permanece roja hasta el ADR (correcto: no se falsea) | Alta: tareas, handoffs y esta decisión se revierten sin tocar gobernanza |
| B. Regenerar el catálogo yo mismo para poner `check` en verde | 1 comando | Fuera de autoridad: L-4, gobernanza y ADR humano; además concurrencia ajena | No ejecutable por este agente |
| C. Silenciar o saltar la puerta (`\|\| true`, supresión) | 0 | Prohibido por S-10/K-10/L-10 | No ejecutable |
| D. Declarar el check en verde sin el arreglo | 0 | Fabricar evidencia (K-10) | No ejecutable |

**Decisión (Opción A, autoridad `resource`):** asignar a `gerente` las 3 tareas sin dueño, con plazo `2026-11-26T18:00:00Z` — (1) objeto de este ciclo: `check` rojo por `marketing-visual`; (2) bug de `kaizen-team handoff`; (3) bug de `kaizen-meta drift` —, emitir 4 handoffs `direct` con sobre completo (`correlation_id`, `intent`, `expects_ack`, `deadline`, `source_ids`), dejar registrado el ack de recepción del escalado (`H-20261124-004`) y escalar a El Presidente los ADRs. No se mueve la etapa (`intake`), no se levanta el BLOCK de `architect`, no se aprueba nada técnico/financiero y no se cambia alcance.

## Memorial (`.kaizen/team/DECISIONES.md`)

- **Dueño:** `gerente` (`human_owner`) — cierra el ADR y reporta a El Presidente. Encuadre y plazo: `facilitador-equipo`.
- **Analista:** `facilitador-equipo` — datos de `state.json`, `tasks.json`, `handoffs.jsonl` y salida de comandos (hechos reproducibles).
- **Retador:** `verificador-evidencias` (`H-20261123-002`) y `arquitecto` (`H-20261123-001`, BLOCK vigente). Sus dictámenes no se fabrican: quedan pendientes de ack.
- **Escriva:** `facilitador-equipo` (este memorial).
- **Facilitador:** `facilitador-equipo` — ordena turnos y deja la tarea lista sin decidir el fondo.
- **Humano (El Presidente):** aprueba el ADR de gobernanza/catálogo (L-3/L-4). No aprueba la asignación, que es `resource`.
- **Disidencia:** el BLOCK de `architect` se respeta íntegramente; el veto `resource` no se usa para bloquear una conclusión técnica.

## Incertidumbre y escalado

1. `kaizen-gov check` pasó a verde respecto al outbox del 2026-11-23; el único resto rojo es `kaizen-org check` (`80 vs 81`). No se da por resuelto hasta `check` en verde.
2. Regenerar el catálogo y tocar `governance.json` son rutas protegidas (L-4): requieren ADR humano y coordinación con el dueño concurrente de `marketing-visual`.
3. `scripts/kaizen-team handoff` (`998952383`) y `scripts/kaizen-meta drift` (`387791946`) siguen rotos; parche requiere ADR (L-4). Interim: handoffs escritos directamente.
4. No se ejecutó `kaizen-meta close`: no hay release ni HEAD alineado con `origin/main` para este cambio de coordinación; no se afirma cierre de release (K-10).
5. No se hizo push ni PR: hay cambios concurrentes ajenos sin commitear en el worktree; se commitean solo los artefactos propios (ADR-0023).

## Verificación (L-9)

KPI «una decisión verificada por ciclo»: esta DEC-004 se marca `verified` solo tras `scripts/kaizen-team verify equipo-central` en verde con sus 4 `source_ids` verificados (estado escrito por el tool, no a mano). En la próxima retro se comprobará que `gerente` acusó recibo, que el ADR fue aprobado y que `scripts/kaizen check` volvió a verde; si no mejora o empeora, se abre `regression-suspect` con revert propuesto.
