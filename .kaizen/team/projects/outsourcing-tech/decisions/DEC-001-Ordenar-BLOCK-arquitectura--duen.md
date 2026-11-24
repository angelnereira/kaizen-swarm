decision_id: DEC-001
topic: Ordenar BLOCK arquitectura: dueno, fuentes y escalado ADR
correlation_id: OT-BLOCK-ARCH-001
source_ids: [ISO-001, NIST-001, OWASP-001, TOOL-001]
retrieved: 2026-11-22
cutoff: 2026-11-21
status: verified
decision_scope: proceso (resource) — NO aprueba fondo técnico
decision_owner: facilitador-equipo
technical_owner: architect
human_owner: El Presidente
---

# Memorial DEC-001 — Ordenar el BLOCK de arquitectura

Esta decisión ordena el **proceso**. No aprueba ni rechaza el fondo técnico del BLOCK
(aislamiento, profundidad constante, buzón no atómico, check no hermético): eso es
competencia del `architect` y, por tocar rutas protegidas (L-4) y exigir ADR-0011..0015,
del humano (El Presidente).

## Participación (`.kaizen/team/DECISIONES.md`)

| Rol | Agente | Estado |
| --- | --- | --- |
| Dueño de la decisión (proceso) | `facilitador-equipo` |_encuadra, fija plazo, escala_ |
| Analista | `verificador-evidencias` | fuentes verificadas en verde |
| Retador (obligatorio) | `architect` + `security` | BLOCK vigente, 1 turno registrado |
| Escriba | `verificador-evidencias` | memorial + `source_ids` |
| Facilitador | `facilitador-equipo` | ordena turnos, marca acuerdo de proceso |
| Humano | El Presidente | **requerido**: ADR y rutas protegidas (L-3/L-4) |

## Evidencia (Observación → Evidencia → Impacto)

**Observación.** El dictamen `architect` (veto `architecture`) sobre la adopción de
kaizen-opencode es `BLOCK`; el orquestador no integra con BLOCK abierto.

**Evidencia.** `.kaizen/loop/outbox/arquitectura-block-adopcion.md` registra los
hallazgos H-1 (escritura en `.kaizen/team/projects/`, ruta protegida), H-2 (profundidad
fija sin contrato por agente), H-3/H-4 (4 equipos sin worktree/`ownership.json`, miembro
duplicado, `last.json` last-writer-wins y carrera en el buzón: `find | head -1` + `sed -i`
sin claim atómico), H-9 (`kaizen check` colgado >120 s en `tests/run.sh`, sin resultado
verde ni rojo) y H-8/H-10/H-11 (deriva de recuentos, tres `|| true` sin issue — S-10,
handoffs `open` sin ack, `state.json` en `intake`). Verificado en verde por el propio
dictamen: 263 herramientas REA, 43 agentes, 10 procesos, `KR_MAX_DEPTH=3`,
`KR_MAX_TEAMS_PARALLEL=4`.

Fuentes de contraste (todas `verified` en `.kaizen/org/knowledge/SOURCES.md`, fecha de
corte **2026-11-21**):

| source_id | Documento | Ancla consultada | Estado |
| --- | --- | --- | --- |
| ISO-001 | ISO/IEC 27001:2022 | A.5 (gobierno de la seguridad) y A.8 (segregación / seguridad de redes) — soporta el requisito de aislamiento | verified |
| NIST-001 | NIST Cybersecurity Framework 2.0 | Función GOVERN (GV) y PROTECT (PR) — soporta contrato de profundidad y propiedad de rutas | verified |
| OWASP-001 | OWASP ASVS 4.0 / Top 10 2021 | V1 (arquitectura y diseño) — soporta compuerta por capacidad antes de exponer herramientas | verified |
| TOOL-001 | morluto/rea — Reverse Engineer Anything (MIT) | repositorio oficial — soporta la verificación del inventario de 263 herramientas | verified |

Comandos reproducibles ejecutados en este turno (sin secretos):

```
git branch --show-current
  → kaizen/facilitador-outsourcing-tech-block-arquitectura
bash scripts/kaizen-team standup outsourcing-tech
bash scripts/kaizen-team assign outsourcing-tech "<tarea>" architect|verificador-evidencias|knowledge-curator
  → jq: error: number (1795372782....) cannot be matched, as it is not a string
  → handoffs.jsonl: 0 bytes  (S-11, fingerprint kaizen-team-handoff-now)
bash scripts/kaizen-team decide ... --sources ISO-001,NIST-001,OWASP-001,TOOL-001
bash scripts/kaizen-team verify outsourcing-tech
```

**Impacto.** Sin orden de proceso: 3 tareas sin dueño, 0 acuses cerrados y un veto
`architecture` que bloquea `deliver`/`verify` del KPI de outsourcing-tech
(100 % contratos con deliverable + acceptance + evidence.md; 0 integraciones sin
verificación).

## Opciones consideradas

1. **Ejecutar el fondo técnico desde esta sesión** — RECHAZADA: excede mi autoridad
   (`resource`), toca rutas protegidas (L-4) y requiere ADR-0011..0015 con humano.
2. **Ordenar proceso + asignar dueños + verificar fuentes + escalar ADR a humano**
   — SELECCIONADA: reversible, dentro de `resource`, deja el veto intacto para que
   `architect` lo resuelva en su dominio.

## Decisión de proceso (acuerdo)

- Las 3 tareas del outbox quedan asignadas con lease y plazo; **0 tareas sin dueño**
  al cierre del standup.
- El BLOCK permanece **abierto**; no se fuerza `advance` de etapa sobre `review`.
- Se emiten handoffs con `correlation_id`, `expects_ack` y `deadline`; el ack del
  destinatario es condición para cerrar cada handoff (COMUNICACION.md §3.2).
- Esta decisión queda `proposed` hasta `kaizen-team verify` en verde; la aprobación
  del fondo (ADR-0011..0015) se escala a El Presidente.

## Incertidumbre y escalado

- La corrección de `scripts/kaizen-team` (bug `now` vs `$now`) y de `cmd_init`
  (idempotente por directorio, no crea `state.json` si el orquestador ya creó la
  carpeta) es ruta protegida (L-4): **no se parchea aquí**; se reporta por S-11.
- H-9 no se afirma verde ni rojo: `kaizen check` sin resultado hermético es
  «no verificado» (L-10/K-10). Se mantiene como BLOCK hasta ejecución aislada.
- Regla de 2 turnos: va el turno 1 (este memorial + handoff a `architect`). Sin
  acuerdo en 2 turnos, escala a `architect` (técnico) y, si persiste, a humano.

## Pregunta concreta a El Presidente

¿Autoriza abrir los ADR-0011..0015 (aislamiento/propiedad, contrato de profundidad,
compuerta REA, buzón determinista, check hermético) y el parche de `scripts/kaizen-team`
en rama `kaizen/*`? Opción recomendada: **sí**, con plazo 2026-11-24T18:00Z y rollback
documentado; riesgo de no hacerlo: el KPI de outsourcing-tech permanece bloqueado en
`review` y ninguna integración de especialista puede verificarse.
