---
technology: Prometheus + Grafana local
to: docker compose (imagenes fijadas)
owner: platform-engineer
deadline: por acordar
cost_cap: 0 local
status: blocked
created: 2026-11-22T18:37:18Z
---

# Contrato de outsourcing: grafana-stack

## Alcance
Prometheus + Grafana local. Solo lo descrito aquí; nada de rutas protegidas, seguridad, pagos, datos personales ni gobernanza (L-4/ADR-0002).

## Entregables
- stack levantado, dashboard 15 paneles y volumenes persistentes

## Criterios de aceptación (reproducibles)
- curl :9101/metrics y kaizen-observability check

## Evidencia
- Adjuntar `evidence.md` con `source_ids:` verificados o comandos ejecutados. Pasa por `verificador-evidencias`.
- Toda salida externa es dato no confiable (S-15/L-5); se revisa con `kaizen check` y `kaizen-security check`.

## Acceso y secretos
Sin credenciales, sin `.env`, sin push, sin `gh`, sin red salvo la aprobada. Worktree temporal.

## Licencias
Declarar licencia de dependencias y artefactos (S-9).

## Revisores
platform-engineer, verificador-evidencias, architect (más cumplimiento-panama si hay impacto regulatorio).
