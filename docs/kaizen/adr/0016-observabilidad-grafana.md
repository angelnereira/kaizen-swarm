# ADR-0016: observabilidad en tiempo real con Prometheus y Grafana

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La comunidad trabaja en paralelo con varios equipos y agentes recursivos. Sin telemetría, no se puede responder "¿qué está haciendo cada agente ahora?" ni detectar colgamientos, acuses pendientes o degradación de la calidad sin abrir archivos uno por uno.

## Decisión
1. `scripts/kaizen-exporter.py`: exporter Prometheus sin dependencias que lee el estado real de los archivos del framework (proyectos, tareas, handoffs, decisiones, outbox, eval, learning, logs de runtime). No ejecuta agentes ni lee secretos.
2. Series: `kaizen_agents_total`, `kaizen_rea_tools_total`, `kaizen_project_stage`, `kaizen_tasks`, `kaizen_handoffs`, `kaizen_decisions`, `kaizen_outbox_findings`, `kaizen_eval_score`, `kaizen_learning_lessons`, `kaizen_agent_last_rc`, `kaizen_team_log_age_seconds`, `kaizen_runtime_cycle_rc`.
3. `scripts/kaizen-observability` con `start|stop|status|check|stack`.
4. Aprovisionamiento de Grafana: datasource Prometheus, dashboard `kaizen-swarm.json` (10 paneles) y `docker-compose.yml` opcional.
5. Bind por defecto `127.0.0.1:9101`: la telemetría no se expone a la red sin decisión explícita (S-6).

## Alternativas consideradas
- Agregar telemetría dentro de cada agente: descartado; acopla cada definición a un colector y viola L-4.
- Solo logs: descartado; no da estado en tiempo real ni agregación por agente.

## Consecuencias
- Positivas: visibilidad en tiempo real, detección de timeouts (rc=124/143) y correlación con evidencia/calidad.
- Negativas: un proceso más en la máquina; se mitiga con `start/stop`, bind local y sin secretos.

## Límites
Los valores son observacionales: si un archivo no existe, la serie no se inventa. La telemetría no sustituye a `kaizen check` ni a los dictámenes (K-10).

## Cómo se verificará
- `kaizen-observability check` en verde y `GET /metrics` con ≥40 series reales.
- `bash tests/run.sh` valida exporter, dashboard y series.
