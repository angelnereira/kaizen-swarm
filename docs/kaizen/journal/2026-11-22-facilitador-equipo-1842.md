# Iteración facilitador-equipo — outsourcing-tech — 2026-11-22T18:42Z

## Tarea
"Arquitectura emite BLOCK: aislamiento, profundidad constante, buzón no atómico y
check no hermético" (outbox, sin dueño). Rol: facilitador-equipo para El Presidente.
Objetivo: ordenar el proceso, no resolver el fondo técnico.

## Decisión
- Autoridad usada: `resource` (proceso, asignación y plazos). No aprobé fondo técnico,
  no cambié etapa por decisión propia, no toqué rutas protegidas (L-4).
- DEC-001 de **proceso** con `source_ids` verificados ISO-001, NIST-001, OWASP-001,
  TOOL-001 (fecha de corte 2026-11-21). `kaizen-team verify` → rc=0.
- BLOCK de `architect` conservado ABIERTO: requiere ADR-0011..0015 y humano.
- Escalado a El Presidente en `needs-human/2026-11-22-block-arquitectura.md`,
  plazo 2026-11-24T18:00Z.

## Evidencia (comandos y resultados reales)
```
git checkout -b kaizen/facilitador-outsourcing-tech-block-arquitectura   → OK
bash scripts/kaizen-team status outsourcing-tech                         → FALLA: proyecto desconocido (rc=2)
bash scripts/kaizen-team init outsourcing-tech ...                       → "ya existe (idempotente)", no creó state.json
  workaround: cp tasks.json → rmdir → init → restaurar tasks.json
bash scripts/kaizen-team standup outsourcing-tech                        → standups/2026-11-22.md
bash scripts/kaizen-team assign outsourcing-tech <t> <agente> x3         → jq error "now...not a string"; handoffs.jsonl=0 bytes; tareas duplicadas
  workaround: consolidé 3 tareas con owner/due/lease y escribí handoffs con sobre completo
bash scripts/kaizen-team decide ... --sources ISO-001,NIST-001,OWASP-001,TOOL-001 → DEC-001
bash scripts/kaizen-team verify outsourcing-tech                         → rc=0 "todas las decisiones tienen fuentes verificadas"
bash scripts/kaizen-team check                                           → rc=0 "todo en verde (25 fuentes verificadas)"
sha256sum .kaizen/org/knowledge/SOURCES.md                               → 11e960129d7e6f6f…
grep -m1 '^status:' .kaizen/org/outsourcing/*/contract.md                → 1 accepted / 4 open; 1 evidence.md
subagent architect / verificador-evidencias / knowledge-curator (DEPTH=1) → 3 acks en acks/*.md
bash scripts/kaizen-team ack outsourcing-tech H-...431|432|433          → rc=0, status=ack
bash scripts/kaizen-team sync outsourcing-tech                           → acuses pendientes=1, tareas abiertas=3, decisiones verificadas=1
```

## Resultado
- 3/3 tareas con dueño (0 sin dueño al cierre del standup).
- 3 handoffs directos con ack real de los destinatarios; 1 broadcast a `all` queda
  abierto y documentado (requiere ack de la escuadra; no se cierra falsamente, K-10).
- `verify` y `kaizen-team check` en verde; veto `architecture` intacto.
- KPI real reportado: 1/5 contratos con `evidence.md` (20 %), rojo.
- Hallazgos S-11: `kaizen-team-init-precreated-dir` (nuevo) y reincidencia de
  `kaizen-team-handoff-now` (mismo fingerprint, sin duplicar).

## Aprendizaje
El orquestador de equipo no es atómico: `init` confunde directorio con estado y
`assign` pierde handoffs por `now` vs `$now`. En este nivel no se parchea (L-4): se
documenta, se aplica workaround en datos y se escala con ADR. Delegar los acuses a
los destinatarios reales y centralizar la escritura evita reproducir el hallazgo
"buzón no atómico" que precisamente originó el BLOCK. Lección registrada con
`kaizen-learn record` y fallo conocido con `kaizen-learn known add`.
