# Observabilidad: qué hace cada agente, en tiempo real

```bash
scripts/kaizen-observability start     # exporter en http://127.0.0.1:9101/metrics
scripts/kaizen-observability status
scripts/kaizen-observability stack     # opcional: Prometheus + Grafana (Docker)
scripts/kaizen-observability stop
```

El exporter lee el estado real de los archivos del framework; no ejecuta agentes, no lee secretos y escucha solo en `127.0.0.1` (S-6).

## Series principales

| Métrica | Significado |
| --- | --- |
| `kaizen_agents_total` | Agentes definidos |
| `kaizen_rea_tools_total` | Herramientas REA del catálogo (263) |
| `kaizen_project_stage{project,stage}` | Etapa de cada proyecto |
| `kaizen_tasks{project,owner,status}` | Tareas por agente |
| `kaizen_handoffs{project,status}` | Acuses pendientes / cerrados |
| `kaizen_decisions{project,status}` | Decisiones por estado |
| `kaizen_outbox_findings{kind}` | Hallazgos S-11 por tipo |
| `kaizen_eval_score{agent}` | Calidad de cada definición |
| `kaizen_learning_lessons{agent}` | Experiencia acumulada |
| `kaizen_agent_last_rc{agent,team}` | Resultado del último ciclo por agente |
| `kaizen_team_log_age_seconds{team}` | Antigüedad del último log del equipo |
| `kaizen_runtime_cycle_rc{team}` | RC del último ciclo (detecta 124/143) |

## Dashboard

Grafana se aprovisiona automáticamente desde `observability/grafana/`: datasource `prometheus` (uid `prometheus`), dashboard **Kaizen Swarm — Agentes en tiempo real** con 10 paneles. Acceso por defecto `http://localhost:3000` (admin/admin). El compose incluye `extra_hosts: host.docker.internal:host-gateway` para que Prometheus alcance al exporter del host.

## Reglas

- Si un archivo no existe, la serie no se inventa: se omite (K-10).
- Los valores son observacionales; no sustituyen a `kaizen check` ni a los dictámenes.
- No exponer el puerto 9101 a la red sin decisión explícita.
- Los hallazgos que muestren rojo (rc≠0, acuses abiertos) se reportan por outbox S-11, no se silencian.

Ver ADR-0016.
