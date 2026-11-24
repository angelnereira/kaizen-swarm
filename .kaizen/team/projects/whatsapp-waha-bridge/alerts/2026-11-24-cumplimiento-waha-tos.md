id: MSG-0001
correlation_id: whatsapp-waha-bridge
from: cumplimiento-panama
to: [facilitador-equipo, El Presidente]
channel: alert
intent: finding
expects_ack: true
deadline: 2026-12-01
source_ids: [WAHA-001, WAHA-002, WAHA-003, META-003, PA-001, PA-002, LOCAL-001, LOCAL-002]
reply_to: H-20261124-0004
status: open
created: 2026-11-24T03:52:00Z
---
# Alerta de cumplimiento — WAHA con número dedicado

## Observación
Dictamen `CHANGES_REQUESTED` sobre el diseño. WAHA es cliente no oficial: el fabricante admite que WhatsApp no lo permite y no garantiza no ser bloqueado (WAHA-001/003); guía de evasión de ban (WAHA-002); Meta se reserva limitar/eliminar acceso y exige opt-in + escalamiento humano (META-003, corte 2026-09-23). ADR-0025 (aceptado) fue enmendado por ADR-0031 con aprobación humana.

## Evidencia
- `reviews/cumplimiento-panama.md` con 7 controles verificables C1–C7 y HECHO vs HIPÓTESIS.
- PA-001 (Ley 81/2019) + PA-002 (DE 285/2021) aplican a datos personales (número, ubicación, vCards) que entrarían al sistema.

## Impacto
Sin C1–C7, cumplimiento emitirá `BLOCK` y `finalize` no integrará. No se emite dictamen legal (ADR-0002): todo queda sujeto a verificación humana/ANTAI.

## Propuesta
Controles C1–C7 en el diseño; **recomendación fuerte**: limitar el MVP a mensajes del propio propietario para eliminar el riesgo PA-001 con datos de terceros.

## Pregunta concreta (ack requerido)
1. ¿Dónde se registra la reafirmación del riesgo de ban sin SLA y el uso exclusivo del número dedicado? (Sugerencia: ADR-0031 §Consecuencias, ya presente — confirmar.)
2. ¿Base legal y responsable ante ANTAI para datos de terceros? (Recomendado: solo mensajes del propietario en el MVP.)
3. ¿Aprueba el plan de contingencia a Cloud API oficial con revisión trimestral de META-003?
