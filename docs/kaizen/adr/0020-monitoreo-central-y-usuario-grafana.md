# ADR-0020: monitoreo central de proyectos y acceso Grafana para agentes

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
Los proyectos con Kaizen instalado trabajan en el mismo equipo local. Sin un punto central no se puede ver cómo se comportan otros repos ni dar feedback oportuno. Además Grafana necesita un usuario por defecto para que personas y agentes puedan entrar y depurar.

## Decisión
1. Usuario/admin por defecto en `observability.env`: `kaizen-admin` / `kaizen-local`; usuario de agente `kaizen-agent` / `kaizen-agent-local`. Se pueden sobrescribir por entorno; **no son credenciales de producción** y no se usan para nada fuera de localhost.
2. `scripts/grafana-bootstrap check|apply` crea el usuario agente y un service account vía API de Grafana; el token **nunca se versiona**.
3. El exporter amplía series con `kaizen_sibling_*` (etapa, tareas, hallazgos, calidad) leyendo los repos hermanos con `.kaizen` bajo el directorio padre (`KO_MONITOR_SIBLINGS=1`).
4. `scripts/kaizen-feedback snapshot|learn|all` convierte esa telemetría en `docs/kaizen/org/FEEDBACK.md` y en fallos conocidos/lecciones (`kaizen-learn`), sin inventar datos si el exporter no responde.
5. Las decisiones derivadas siguen `DECISIONES.md` y exigen `source_ids`; ADR-0019 aplica a la voz pública.

## Alternativas consideradas
- Un Prometheus por proyecto: descartado; fragmenta la visión y multiplica puertos.
- Credenciales compartidas de admin para agentes: descartado; mínimo privilegio con usuario Viewer.

## Consecuencias
- Positivas: feedback cruzado entre proyectos, detección temprana de hallazgos y acceso de depuración para el equipo.
- Negativas: el exporter lee más archivos; se mitiga con `KO_MONITOR_SIBLINGS` y namespace `kaizen_sibling_*`.

## Límites
Solo lectura, solo localhost por defecto (S-6). Sin secretos en el repo: las credenciales por defecto son locales y sobreescribibles. El feedback no sustituye la verificación ni autoriza cambios en otros repos sin humano (L-4).

## Cómo se verificará
- `kaizen-observability check`, `grafana-bootstrap check` y series `kaizen_sibling_*` presentes.
- `bash tests/run.sh` cubre feedback y usuario por defecto.
