# ADR-0021: economía de tokens, trabajo continuo y capacidad en árbol

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La comunidad ya deliberaba y aprendía, pero no medía el coste real de sus corridas, podía detenerse al terminar una tarea y no tenía un techo explícito de agentes simultáneos. Sin esos controles, la proactividad puede convertirse en ruido o en un cuello de botella de la máquina.

## Decisión
1. `scripts/kaizen-tokens`: ledger local de `input`, `output`, `cost_usd` y `saved_estimate` por agente/tarea; `snapshot`, `report` y `check`. El ahorro es **estimado** contra una línea base configurable, nunca afirmado como medición real (K-10).
2. El exporter publica `kaizen_tokens_*` y el dashboard incorpora 3 paneles de coste y ahorro.
3. `kaizen-runtime` captura `usage` de `opencode run --format json` cuando `KT_TOKEN_CAPTURE=1` y lo registra; si no hay datos, no inventa.
4. `kaizen-runtime work <equipo>` toma tareas pendientes del proyecto (o las propone desde el outbox), las asigna a los miembros y, al terminar una, pasa a la siguiente hasta `KT_MAX_TASKS_PER_AGENT`. Un agente no se detiene solo porque acabó una tarea.
5. Capacidad en árbol: los agentes pueden delegar con `KAZEN_AGENT_DEPTH` (recursión controlada, ADR-0005) y el techo `KT_MAX_AGENTS=12` con `KT_MAX_PARALLEL=6` evita reventar la máquina; `deploy` reduce paralelismo si se excede.
6. Equipo `finops-tokens` con modelo `opencode/hy4-flash-free` para operar esta capa.

## Alternativas consideradas
- Medir solo coste monetario: descartado; el volumen de tokens y el ahorro estimado permiten optimizar prompts y modelo.
- Dejar que cada agente decida cuándo parar: descartado; sin cola de trabajo la proactividad se agota en una tarea.

## Consecuencias
- Positivas: coste visible, trabajo continuo verificable y capacidad gobernada.
- Negativas: más datos y un comando más; se mitiga con ledger local y comandos simples.

## Límites
El coste es el que reporta el modelo; si no lo reporta se guarda 0 y se dice. El ahorro es estimado. Ningún mecanismo autoriza gasto nuevo sin humano (S-1/L-3) ni modifica autonomía por eficiencia.

## Cómo se verificará
- `bash tests/run.sh` cubre ledger, métricas, `work` en dry-run y techo de agentes.
- `kaizen-tokens snapshot|report` con datos reales; paneles visibles en Grafana local.
