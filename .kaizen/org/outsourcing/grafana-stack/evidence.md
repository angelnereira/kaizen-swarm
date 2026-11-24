source_ids: INT-STD-000
command: "curl http://127.0.0.1:9101/metrics; docker compose -f observability/docker-compose.yml up -d; docker ps"
result: "Exporter local SI (133 series, 35 de proyectos hermanos). Docker compose configurado con imagenes fijadas, usuarios y volumenes, pero el daemon Docker Desktop no esta corriendo: 'Cannot connect to the Docker daemon'. Prometheus :9090 y Grafana :3000 NO levantados."
state: "BLOQUEADO: requiere iniciar Docker Desktop en la máquina local"
