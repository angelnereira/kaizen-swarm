# ADR-0034: orquestación dinámica de roles, rangos y aprobaciones

Estado: aceptado
Fecha: 2026-11-23T03:34:42.396355+00:00
Aprobado por: Angel Nereira (solicitud de reparto proactivo, jerarquico y orquestado)

## Contexto
El usuario requirió que los agentes se repartan dinámica, flexible, recursiva e ingeniosamente los roles, responsabilidades, pasos y procedimientos; que exista jerarquía y rangos por proyecto/tarea; que se defina quién subordina a quién, quién aprueba y quién verifica; y un agente dedicado a planificar quién ejecuta.

## Decisión
1. Cinco agentes nuevos: `orquestador-equipo` (reparte y reporta), `planificador-trabajo` (pasos, dependencias, salida y rollback), `raci-dinamico` (rangos R0-R5 y matriz R/A/C/I/V/H), `supervisor-ejecucion` (verifica ack, deadline y cierre; puede V), `aprobador-trabajo` (prepara paquete; NUNCA aprueba).
2. `scripts/kaizen-orquesta hierarchy|plan|raci|asignar|estado|check` implementa el reparto de forma determinista: elige especialista por palabras clave, construye un plan de 7 pasos y una RACI por tarea, con `correlation_id`, `expects_ack`, `deadline` y `source_ids`. Dry-run por defecto.
3. Jerarquía **por tarea**, no permanente: R0 humano (A/H), R1 orquestador, R2 planificación/RACI, R3 ejecutores, R4 supervisión/evidencia (V), R5 preparación de aprobación. El humano siempre aprueba en sensible (ADR-0001/0002).
4. Recursión acotada por `KAZEN_AGENT_DEPTH`; al llegar a cero se consolida y reporta. Sin auto-lanzamiento ni bucle.
5. Integración: `kaizen-community` enruta comentarios de planificación/orquestación al orquestador y soporta `react <id> plan`.

## Alternativas consideradas
- Jerarquía fija global: descartada; no se adapta al proyecto ni a la tarea.
- Que un agente apruebe su propio trabajo: descartado; viola L-3/L-4 y ADR-0008.

## Consecuencias
- Positivas: separación plan / exec / verificación / aprobación, trazabilidad por correlation_id, bloqueo con evidencia.
- Negativas: 5 definiciones más (61 agentes); mitigado con gobernanza generada y eval 100.

## Límites
Ningún agente aprueba gasto, seguridad, pagos ni cambios regulatorios. `estado` no inventa progreso: si no hay archivo, lo reporta.

## Cómo se verificará
- `kaizen-orquesta check|plan|raci|asignar` y `kaizen-eval check` en verde.
- `bash tests/run.sh` sin fallos; `kaizen-gov check` en verde.
