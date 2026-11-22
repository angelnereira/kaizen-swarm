# Monitoreo de proyectos hermanos y feedback

## Acceso a Grafana

```bash
scripts/kaizen-observability stack        # Prometheus :9090 + Grafana :3000
scripts/grafana-bootstrap apply           # crea usuario kaizen-agent y service account
```

Credenciales locales por defecto (sobrescribibles por entorno, **no usar fuera de localhost**):

| Uso | Usuario | Password |
| --- | --- | --- |
| Admin | `kaizen-admin` | `kaizen-local` |
| Agentes (Viewer) | `kaizen-agent` | `kaizen-agent-local` |

El token del service account se entrega por la API de Grafana y **nunca se escribe en el repo**. Dashboard: **Kaizen Swarm — Agentes en tiempo real**.

## Monitoreo central

El exporter (`:9101/metrics`) lee los repos hermanos con `.kaizen` bajo el directorio padre y publica:

- `kaizen_sibling_project_stage{repo,project,stage}`
- `kaizen_sibling_tasks{repo,project,owner,status}`
- `kaizen_sibling_outbox_findings{repo,kind}`
- `kaizen_sibling_eval_average{repo}`

Si un repo no tiene `.kaizen`, se ignora; si el exporter no responde, no se inventan datos.

## Feedback continuo

```bash
scripts/kaizen-feedback snapshot   # escribe docs/kaizen/org/FEEDBACK.md
scripts/kaizen-feedback learn      # convierte hallazgos en fallos conocidos/lecciones
scripts/kaizen-feedback all
```

Regla: rojo si un proyecto lleva mucho en `intake`, su calidad baja de 70 o tiene hallazgos abiertos. Cada hallazgo se convierte en lección con `kaizen-learn` y se decide con `source_ids` según `DECISIONES.md`. **No se modifica otro repo sin humano** (L-4).

Ver ADR-0020.
