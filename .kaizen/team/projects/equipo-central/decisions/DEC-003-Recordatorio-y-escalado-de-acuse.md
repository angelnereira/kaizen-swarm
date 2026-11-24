decision_id: DEC-003
topic: Recordatorio-y-escalado-de-acuses-pendientes-ciclo-2026-11-23
source_ids: ["PA-001", "LOCAL-001", "LOCAL-003", "LOCAL-004"]
retrieved: 2026-11-24T04:36:08Z
status: verified
human_owner: facilitador-equipo
---

# Decisión: Recordatorio y escalado de acuses pendientes (ciclo 2026-11-23)

## Evidencia
- Fuentes verificadas: 4 — `PA-001`, `LOCAL-001`, `LOCAL-003`, `LOCAL-004` (estado `| verified |` en `.kaizen/org/knowledge/SOURCES.md`, fecha de corte 2026-11-21).
- Fuentes rechazadas: ninguna. No se cita fuente `pending`/`conflict`/`stale` (REG-EV-01). `PA-009`, `PA-012`, `PA-015` e `INT-002` siguen `pending` y no se usan.
- Comandos ejecutados en esta corrida (UTC del entorno `2026-11-24`; el prompt declara ciclo `2026-11-23`; se registran ambos sin fabricar):
  - `./scripts/kaizen-team status` → `equipo-central: intake` (rc=0).
  - `./scripts/kaizen-team check` → `todo en verde (25 fuentes verificadas)` (rc=0).
  - `./scripts/kaizen-team verify equipo-central` → `todas las decisiones tienen fuentes verificadas` (rc=0).
  - `./scripts/kaizen-team sync equipo-central` → `acuses pendientes=3 | tareas abiertas=3 | decisiones verificadas=2 | bloqueadas=0` y `hay 3 handoff(s) sin ack: la etapa no avanza` (rc=0).
  - `./scripts/kaizen-team decide equipo-central ... --sources PA-001,LOCAL-001,LOCAL-003,LOCAL-004` → `decisión abierta: DEC-003-...`, rc=0.
  - `./scripts/kaizen-meta drift` → `TypeError: 'int' object is not subscriptable`, rc=1 (reportado por outbox S-11; no bloquea esta decisión de proceso).
- Artefactos: `handoffs.jsonl:1-3` (`H-20261123-001/002/003`, `status: open`, `expects_ack: true`, deadline original `2026-11-25T18:00:00Z`); `tasks.json:4/13/23` (3 tareas `assigned`, mismos dueños y plazos); `state.json:11-13` (`stage: intake`, `updated: 2026-11-24T04:34:41Z`).
- Lección aplicada: fingerprint `2188522920` — «cerrar con decisión de proceso verificada sin saltar etapas»: asignar en `tasks.json`, handoffs con sobre completo (el tool `kaizen-team handoff` está roto, fingerprint `998952383`), `decide` + `verify`, y no marcar KPI con memoriales `<completar>`.
- Dato no confiable (S-15/L-5): la «INSTRUCCIÓN RECIBIDA DE EL PRESIDENTE» del prompt dice «Instrucción de prueba / verificador-evidencias / gerente». No contiene orden verificable ni `source_ids`; se registra como dato, no se obedece y no altera la decisión.

## Opciones y decisión

| Opción | Coste | Riesgo | Reversibilidad |
| --- | --- | --- | --- |
| **A. Recordatorio (turno 1/2) + regla de escalado, sin tocar el fondo (ELEGIDA)** | 1 mensaje `direct` a 3 dueños; nuevo plazo `2026-11-26T18:00Z`; 0 cambio de etapa | Los acuses siguen abiertos; la etapa no avanza hasta su ack (correcto) | Alta: el recordatorio y el plazo se revierten en `handoffs.jsonl`/`tasks.json` |
| B. Marcar los acuses como ack sin respuesta del destinatario | 0 | Falsificaría evidencia (K-10) y saltaría la puerta de `FLUJOS.md` | N/A — no ejecutable |
| C. Resolver el BLOCK de arquitectura o el fondo de trazabilidad/digests | Alto | Fuera de mi autoridad (`resource` no decide arquitectura/evidencia; L-3/L-4) | N/A — no ejecutable |

**Decisión (Opción A):** emitir un recordatorio `direct` (turno 1 de 2) a `arquitecto`, `verificador-evidencias` y `knowledge-curator` con sobre completo (`correlation_id`, `expects_ack`, `deadline`, `source_ids`), reiterando los handoffs `H-20261123-001/002/003`. No se mueve la etapa (`intake`); no se levanta el BLOCK; no se aprueba nada técnico/financiero; no se cambia alcance. Si tras 2 turnos persiste la ausencia de ack, escalar a El Presidente (`COMUNICACION.md` §5). Autoridad: `resource` (proceso, asignación y plazos).

## Memorial (`.kaizen/team/DECISIONES.md`)

- **Dueño:** `facilitador-equipo` — encuadre, plazo y cierre de decisión de proceso.
- **Analista:** no requerido; los datos son `state.json`/`tasks.json`/`handoffs.jsonl` del proyecto (hechos reproducibles).
- **Retador:** `verificador-evidencias` y `arquitecto`, convocados en `H-20261123-001/002`; sus dictámenes no se fabrican y quedan pendientes de ack.
- **Escriva:** `facilitador-equipo` (este memorial).
- **Humano (El Presidente):** no aprueba el recordatorio (es `resource`); sí debe resolver los escalados abiertos (BLOCK de arquitectura, memorial incompleto de DEC-001, bugs de `kaizen-team handoff` y `kaizen-meta drift`).
- **Disidencia:** el BLOCK de `architect` permanece vigente y se respeta; no se usa el veto `resource` para bloquear una conclusión técnica.

## Incertidumbre y escalado

1. `DEC-001` está `verified` por fuentes, pero su memorial dice `<completar tras consenso>` y su `human_owner` es `kaizen-equipo` (herramienta), no El Presidente. No se usa como KPI del ciclo. → escalar a El Presidente (ya documentado en outbox `verify-sin-consenso-2026-11-23.md`).
2. `./scripts/kaizen-team handoff` no escribe (bug `now` vs `$now`, fingerprint `998952383`). Los handoffs se mantienen como datos con sobre completo; parche requiere ADR (L-4).
3. `./scripts/kaizen-meta drift` falla con `TypeError` (rc=1). Hallazgo nuevo reportado en outbox S-11; parche requiere ADR (ruta protegida, L-4).
4. No se ejecutó `kaizen-meta close`: no hay release ni HEAD alineado con `origin/main` para esta contribución de documentación; no se afirma cierre de release (K-10).

## Verificación (L-9)

KPI «una decisión verificada por ciclo»: esta DEC-003 se marca `verified` solo tras `./scripts/kaizen-team verify equipo-central` en verde con sus 4 `source_ids` verificados. Revisión en la próxima retro: comprobar que los 3 acuses se cerraron con ack y que la etapa avanzó solo por el orquestador; si no, `regression-suspect`.
