decision_id: DEC-001
topic: Adoptar WAHA con numero dedicado (enmienda ADR-0025 via ADR-0031)
source_ids: ["WAHA-001", "WAHA-003", "WAHA-007", "WAHA-010", "WAHA-012", "WAHA-014", "META-003"]
retrieved: 2026-11-24T03:44:21Z
status: verified
human_owner: El Presidente
---

# Decisión: Adoptar WAHA con numero dedicado (enmienda ADR-0025 via ADR-0031)

## Evidencia
- Fuentes verificadas: 7
- Fuentes rechazadas: ninguna

## Opciones y decisión

| Opción | Coste | Riesgo | Veredicto |
| --- | --- | --- | --- |
| A) WAHA + número dedicado | Gratuito (Apache-2.0, sin coste/mensaje) | ToS/ban del número dedicado; sin SLA | **ELEGIDA** por El Presidente el 2026-11-24 |
| B) Cloud API oficial + número dedicado | Capa gratuita ~1000 msgs/mes; verificación Meta | Trámite no inmediato | Descartada ahora; estado objetivo de producción |
| C) Solo preparar, sin activar | Cero | Sin canal operativo | Descartada: se quiere canal gratuito |

**Decisión:** adoptar A mediante ADR-0031 (enmienda aceptada). Retador obligatorio: `security` y `architect` deben emitir dictamen con evidencia antes de `execute`; `cumplimiento-panama` tiene veto `compliance` (ADR-0002) y no ha emitido dictamen: cualquier acción regulatoria/legal se escala a humano. Disidentes registrados: ninguno en ronda de decisión; la disidencia técnica de ADR-0025 queda preservada en ADR-0031 §Alternativas.

## Incertidumbre y escalado

- **Pendiente de POC (no afirmar soporte):** vector de cálculo del HMAC-SHA512 (docs enlazan a herramienta SHA-256, inconsistencia documental) y payload/frecuencia de *live location* (sin ejemplo oficial; WAHA-011 solo expone el flag `location.live`). Registrado en `SOURCES.md`.
- La afirmación de ADR-0025:8 («prohibición de chatbots desde 2026-01-15») no confirmada con fuente primaria: no se usa como justificación operativa.
- **Escalado humano requerido:** (1) proporcionar el número dedicado y autorizar el escaneo QR (ADR-0018, sin credenciales en pantalla); (2) arrancar el daemon Docker (ADR-0026, hoy detenido). Ninguno lo ejecuta el equipo por su cuenta.
- Revisión del KPI en L-9; si no mejora, `regression-suspect` + revert propuesto.
