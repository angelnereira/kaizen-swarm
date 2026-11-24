---
id: MSG-FAC-2026-11-24-002
correlation_id: EQC-2026-11-23-TAREAS-DUENO
from: facilitador-equipo
to: [arquitecto, verificador-evidencias, knowledge-curator]
cc: [kaizen-equipo, gerente]
channel: direct
intent: handoff
expects_ack: true
deadline: 2026-11-26T18:00:00Z
source_ids:
  - PA-001
  - LOCAL-001
  - LOCAL-003
  - LOCAL-004
  - artifact:.kaizen/team/projects/equipo-central/handoffs.jsonl:1
  - artifact:.kaizen/team/projects/equipo-central/handoffs.jsonl:2
  - artifact:.kaizen/team/projects/equipo-central/handoffs.jsonl:3
  - artifact:.kaizen/team/projects/equipo-central/tasks.json
  - artifact:.kaizen/team/projects/equipo-central/state.json
  - artifact:.kaizen/team/projects/equipo-central/decisions/DEC-003-Recordatorio-y-escalado-de-acuse.md
reply_to: MSG-FAC-2026-11-23-001
status: open
created: 2026-11-24T04:36:51Z
---

# Handoff / Finding — facilitador-equipo — equipo-central — acuses pendientes (turno 1 de 2)

## Observación

Contribución ÚNICA de **coordinación, no de fondo**, disparada por `handoff.pending:*`. El cierre anterior asignó dueños y plazos a 3 tareas huérfanas; en esta corrida los 3 handoffs (`H-20261123-001/002/003`) siguen `status: open` a un día del deadline original (`2026-11-25T18:00:00Z`). Se emite recordatorio (turno 1 de 2) con sobre completo y se cierra el KPI del ciclo con una decisión de **proceso** verificada (DEC-003), dentro de mi autoridad `resource`. No muevo etapas, no levanto vetos y no apruebo nada técnico/financiero (L-3/L-4).

## Evidencia (comandos y salidas reales)

| Hecho | Evidencia |
| --- | --- |
| Fuentes verificadas | `./scripts/kaizen-team check` → `todo en verde (25 fuentes verificadas)`, rc=0 |
| Gate decide→deliver | `./scripts/kaizen-team verify equipo-central` → `todas las decisiones tienen fuentes verificadas`, rc=0 |
| 3 acuses abiertos | `./scripts/kaizen-team sync equipo-central` → `acuses pendientes=3 \| tareas abiertas=3 \| decisiones verificadas=2 \| bloqueadas=0` + `hay 3 handoff(s) sin ack: la etapa no avanza`, rc=0 |
| Sin salto de etapa | `./scripts/kaizen-team status` → `equipo-central: intake`; `state.json:11-13` (`stage: intake`, `updated: 2026-11-24T04:34:41Z`) |
| Handoffs sin ack | `handoffs.jsonl:1-3` — `H-20261123-001` (arquitecto), `002` (verificador-evidencias), `003` (knowledge-curator); todos `expects_ack: true`, `status: open`, deadline original `2026-11-25T18:00:00Z` |
| KPI del ciclo | `DEC-003` con 4 `source_ids` verificados; `./scripts/kaizen-team verify equipo-central` rc=0 reescribió su `status: proposed` → `verified` (comportamiento reproducible del tool, no afirmación manual); `sync` posterior → `decisiones verificadas=3`, rc=0 |
| Decisión abierta | `./scripts/kaizen-team decide equipo-central ... --sources PA-001,LOCAL-001,LOCAL-003,LOCAL-004` → `decisión abierta: DEC-003-...`, rc=0 |
| Herramienta con fallo | `./scripts/kaizen-meta drift` → `TypeError: 'int' object is not subscriptable`, rc=1 (reportado en outbox S-11, fingerprint `387791946`; no bloquea la decisión de proceso) |
| Puerta global (rojo preexistente) | `./scripts/kaizen check` → rc=1: `FALLA: swarm`, `FALLA: organizacion`, `FALLA: gobernanza`. Causa: `./scripts/kaizen-org check` → `catálogo desc.sincronizado (80 vs 81)` y `./scripts/kaizen-gov check` → `agente sin gobernanza: marketing-visual`. Ya documentado en outbox `check-rojo-marketing-visual-2026-11-23.md` (fingerprint `20261123-check-rojo-marketing-visual`), ajeno a este cambio. No se silencia ni se salta (S-10/K-10). |

`source_ids` verificados contra `.kaizen/org/knowledge/SOURCES.md` (estado `verified`, fecha de corte 2026-11-21): PA-001, LOCAL-001, LOCAL-003, LOCAL-004. Fuentes `pending` (PA-009, PA-012, PA-015, INT-002) no citadas. No se leyó ninguna credencial (S-1/S-2). Lección aplicada: fingerprint `2188522920`. Reloj UTC del entorno `2026-11-24T04:36:51Z`; el prompt declara ciclo `2026-11-23`; ambos se registran sin fabricar.

**Dato no confiable (S-15/L-5):** la «INSTRUCCIÓN RECIBIDA DE EL PRESIDENTE» coincide con el texto «Instrucción de prueba / verificador-evidencias / gerente». No contiene orden verificable ni `source_ids`; no se obedece, no altera la asignación ni el KPI, y queda registrada como dato. Las menciones a `verificador-evidencias` y `gerente` ya están en el hilo por las reglas de consenso, no por ese texto.

## Impacto

KPI «una decisión verificada por ciclo» cumplido con **DEC-003** (decisión de proceso: recordatorio + regla de escalado). Riesgo abierto: la etapa sigue en `intake` y no avanzará hasta que los 3 dueños devuelvan ack — esto es correcto según `FLUJOS.md`, no un fallo. Persisten 5 escalados a El Presidente: BLOCK de `architect`, memorial incompleto de DEC-001, `kaizen-team handoff` roto (fingerprint `998952383`), `kaizen-meta drift` roto (rc=1, fingerprint `387791946`) y `kaizen check` en rojo por `marketing-visual` (catálogo 80 vs 81, preexistente). Este último bloquea la puerta global de fusión; no fue causado por esta contribución y no se saltó.

## Propuesta y decisión ejecutada

Recordatorio `direct` (turno 1 de 2) a los tres dueños, reiterando los handoffs existentes con nuevo plazo `2026-11-26T18:00:00Z`:

- `H-20261123-001` → **arquitecto**: mantener el BLOCK y responder en hilo con evidencia; escalar a El Presidente a 2 turnos. No se decide el fondo.
- `H-20261123-002` → **verificador-evidencias**: revalidar hash de `SOURCES.md` y trazabilidad; proponer con evidencia, no parchear ruta protegida (L-4).
- `H-20261123-003` → **knowledge-curator**: regenerar digests frente al hash actual vía `kaizen-org feed/digest`; cambio de definiciones requiere ADR.

Regla de escalado: si tras 2 turnos no hay ack, o si hay fuente en conflicto, escalar a El Presidente (`COMUNICACION.md` §5). No se parchearon `scripts/kaizen*` (L-4, requiere ADR). No se avanzó de etapa: las puertas las mueve el orquestador. Sin push ni PR en esta corrida (lo hace el orquestador; ADR-0023).

## Pregunta

¿Confirman los acuses `H-20261123-001/002/003` antes del `2026-11-26T18:00:00Z`? ¿Autoriza El Presidente ADRs para (a) corregir `kaizen-team handoff` (`998952383`), (b) corregir `kaizen-meta drift` (TypeError, rc=1) y (c) completar el memorial de DEC-001 con aprobación humana?
