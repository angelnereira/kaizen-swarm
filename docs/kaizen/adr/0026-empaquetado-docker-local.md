# ADR-0026: empaquetado Docker local de la comunidad

Estado: aceptado (empaquetado listo; despliegue bloqueado por daemon)
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
El usuario pidió empaquetar y desplegar el proyecto en local con contenedores Docker. El stack anterior (`observability/docker-compose.yml`) solo definía Prometheus y Grafana y dependía de un exporter nativo.

## Decisión
1. `Dockerfile` con imagen base fijada `python:3.12.8-slim-bookworm` (sin `latest`), usuario no root UID 10001, solo herramientas necesarias (`bash`, `jq`, `git`, `curl`), sin secretos ni credenciales copiadas.
2. `scripts/docker-entrypoint.sh` expone exclusivamente `exporter|check|org|knowledge|shell`; **no** ejecuta agentes con modelo ni push dentro del contenedor.
3. `docker-compose.yml` en la raíz orquesta `kaizen-exporter` (:9101), Prometheus (:9090) y Grafana (:3000), con imágenes fijadas, healthcheck, restart y volúmenes persistentes `prometheus-data`/`grafana-data`.
4. `observability/prometheus-container.yml` apunta a `kaizen-exporter:9101` dentro de la red del compose (el otro archivo apunta al host para modo nativo).
5. `scripts/kaizen-docker` con `preflight|build|up|down|status|logs|check`. Si el daemon no responde, falla cerrado y documenta en outbox; no afirma despliegue (K-10).

## Alternativas consideradas
- Usar `latest` o ejecutar como root: descartado (S-16).
- Mezclar credenciales en la imagen: descartado (S-1/S-2).

## Consecuencias
- Positivas: stack reproducible y portable, persisted metrics, menor superficie que el modo nativo.
- Negativas: requiere Docker Desktop corriendo en la máquina; hoy está detenido, por lo que el despliegue real quedó bloqueado y documentado.

## Cómo se verificará
- `kaizen-docker check` en verde (config válida).
- Con daemon activo: `kaizen-docker up` + `curl :9101/health` + dashboard en `:3000`.
