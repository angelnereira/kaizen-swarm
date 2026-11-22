# FINDING — Platform Engineer — Rollback documentado para despliegues a producción

id: FIND-PE-001
correlation_id: PE-PROY-001
from: platform-engineer
to: all
channel: finding
intent: finding
expects_ack: false
deadline: 2026-11-25T18:00:00Z
status: open
created: 2026-11-22T06:09:24Z
source_ids:
  - LOCAL-002
  - docs/kaizen/org/GOBIERNO.md#deployment-gate (verificado: gate `deployment` exige rollback documentado)
  - docs/kaizen/org/GOBIERNO.md#rollback-stage (verificado: rollback → R: platform-engineer, A: humano)
  - CMD:ls .github/workflows/ (verificado: sin workflows de despliegue/CD; CI = kaizen-gates, kaizen-loop, kaizen-report-failure, kaizen-security, kaizen-swarm)
  - CMD:scripts/kaizen-release check → "todo en verde (v1.0.0)"

## ¿Qué pasó
Como Ingeniero de Plataforma (objetivo: CI/CD, nube, observabilidad, despliegues reversibles; KPI: despliegues con rollback), audito la reversibilidad de los despliegues a producción. El gate `deployment` de `GOBIERNO.md` exige explícitamente "rollback documentado" y el etapa `rollback` tiene responsable platform-engineer. Ese artefacto no existe.

## Dónde (evidencia real)
- `docs/kaizen/org/GOBIERNO.md:30` — etapa `deployment` (7): "tests + gates + Kaizen check verdes; humano para producción; rollback documentado".
- `docs/kaizen/org/GOBIERNO.md:57` — etapa `rollback` — R: platform-engineer, A: humano.
- `docs/kaizen/runbooks/` — contiene solo `_TEMPLATE.md` y `secret-leak.md`; no hay runbook de rollback de despliegue (GCP/Azure según CAPACIDADES-REFERENCIA: ejecutores en GCP, Functions en Azure).
- `.github/workflows/` — solo `kaizen-gates.yml`, `kaizen-loop.yml`, `kaizen-report-failure.yml`, `kaizen-security.yml`, `kaizen-swarm.yml`; sin pipeline de despliegue ni job de revert/rollback.

## Impacto
- KPI de platform-engineer: despliegues con rollback — un despliegue a producción sin rollback documentado no cumple la condición de la etapa y no cierra el gate de reversibilidad.
- Sin runbook: al rollback, se ejecuta "persona → memoria" (ruteo impredecible, perdida de evidencia, ~15-30 min adicionales). Con runbook + checklist: reversión en <= 30 min verificada.

## Evidencia (comandos reales, sin secretos)
```
$ ls .github/workflows/
kaizen-gates.yml  kaizen-loop.yml  kaizen-report-failure.yml  kaizen-security.yml  kaizen-swarm.yml
$ ls docs/kaizen/runbooks/
_TEMPLATE.md  secret-leak.md
$ scripts/kaizen-release check
[kaizen-release] kaizen-release check: todo en verde (v1.0.0)
$ git log --oneline -3
414646b Release v1.0.0: publish catalog and versioned agent community
...
```

## Reproducción (nueva):
1. `ls docs/kaizen/runbooks/` → ausencia de `rollback-*.md`.
2. Buscar "rollback" en `.github/workflows/*.yml` → 0 coincidencias.

## Propuesta (opción recomendada, A: humano)
Crear `docs/kaizen/runbooks/rollback-produccion.md` — runbook ejecutable y reversible con rollback verificado (K-8/runbook en CONTRACT). Contenido sugerido:
- Índice: tipos de despliegue cubiertos (GCP Cloud Run/GKE según infra real; Azure Functions), versión desplegada vs versión anterior, estado de health check.
- Procedimiento por tipo: pasos concretos de revert (ej. `gcloud ...` rollback a versión N-1 / revision rollback), timing target (<= 30 min), verificación (health endpoint verde, monitoreo Dynatrace sincronizado).
- Checklist pre/pos rollback, aprobación humana, actualización del descriptor K-4.
- Advertencias: no rutas protegidas (L-4).
Actualizar `docs/kaizen/org/GOBIERNO.md:30` si aplica (no).

## Riesgo si no se actúa
- Recurrencia: cada despliegue a producción ignora la etapa de rollback del gate → viola KPI "despliegues con rollback" y K-2 (etiqueta blocked pendiente).
- Custo: causa raíz de incidentes se vuelve más difícil de verificar sin procedimiento anclado.
- Próxima aplicación: próxima etapa `deployment` de `docs/kaizen/org/GOBIERNO.md` que exige rollback documentado.

## Verificación (criterio de salida)
- `ls docs/kaizen/runbooks/` muestra `rollback-produccion.md`.
- `scripts/kaizen check --only descriptors` verde (runbook nuevo no des incurre en ratchet).
- `scripts/kaizen check` completo verde (K-4: descriptor + test + sin BLOCK).
- Documentos tocados listados en descriptor del PR/PR-draft asociado.
