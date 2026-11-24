decision_id: DEC-002
topic: Alcance remitentes, reafirmacion de riesgo y contingencia (decisiones del Presidente 2026-11-24)
source_ids: ["WAHA-001", "WAHA-003", "META-003", "PA-001", "PA-002"]
retrieved: 2026-11-24T04:03:50Z
status: verified
human_owner: El Presidente
---

# Decisión: Alcance remitentes, reafirmacion de riesgo y contingencia (decisiones del Presidente 2026-11-24)

## Evidencia
- Fuentes verificadas: 5
- Fuentes rechazadas: ninguna

## Opciones y decisión

| Decisión | Opción elegida por El Presidente (2026-11-24) | Alternativa descartada |
| --- | --- | --- |
| Alcance de remitentes | Propietario **+ terceros autorizados** (allowlist explícita; base legal y responsable ANTAI documentados antes de activar con terceros) | Solo propietario (recomendación de cumplimiento, no elegida); cualquier remitente (riesgo PA-001 inaceptable) |
| Riesgo ToS | Reafirmado: riesgo de ban sin SLA asumido sobre el número dedicado; registrado en ADR-0031 §Consecuencias | Diferir registro |
| Contingencia | Aprobada: migrar a Cloud API oficial (ADR-0025) si hay ban o Meta endurece política; revisión trimestral de META-003 | Sin contingencia |
| Secuencia | Preparar todo sin conectar número ni tocar flags; POC cuando el Presidente dé el número y autorice Docker | POC inmediata (sin número disponible) |

## Incertidumbre y escalado

- Cumplimiento debe re-dictaminar con el alcance «terceros autorizados»: su dictamen anterior (`CHANGES_REQUESTED`) se basaba en la recomendación de limitar al propietario. Hasta que reevalúe C3 (base legal/responsable ANTAI) con `source_ids`, el veto `compliance` seguirá vigente para activación con terceros (ADR-0002).
- QA sigue BLOQUEADO (H-0005): POC de HMAC/live location requiere número dedicado y daemon Docker. No se fabrica su aprobación.
- Revisión del KPI en L-9. Ninguna capacidad se declara soportada antes de la POC (K-10).
