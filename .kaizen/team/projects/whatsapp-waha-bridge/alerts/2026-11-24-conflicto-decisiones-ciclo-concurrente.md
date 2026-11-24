id: MSG-0002
correlation_id: whatsapp-waha-bridge
from: kaizen-equipo
to: [facilitador-equipo, El Presidente]
channel: alert
intent: finding
expects_ack: true
deadline: 2026-12-01
source_ids: [LOCAL-005, LOCAL-006, WAHA-001, ADR-0031, ADR-0032]
status: resolved
created: 2026-11-24T04:55:00Z
resolved_at: 2026-11-24T05:05:00Z
resolution: DEC-006 — El Presidente confirmó ADR-0032 (numero personal, mensaje a uno mismo); DEC-004 se mantiene (OpenCode canal activo, WhatsApp opcional). Valor guardado fuera del repo en owner.env (600), nunca versionado.
---
# Conflicto de decisiones por ciclo concurrente del runtime

## Observación
Mientras `kaizen-equipo` ejecutaba la sesión `ses_df46fa86effekZ3R42lECIWYEb` (canal OpenCode), el runtime autónomo lanzó otro ciclo (`opencode run --agent`, PIDs 1802323/1802324/1851491) que escribió en el MISMO proyecto `whatsapp-waha-bridge`.

## Evidencia (rutas reales)
- `decisions/DEC-003-Aprobar-ADR-0032--numero-persona.md` — aprueba ADR-0032: **número PERSONAL** del Presidente en modalidad "mensaje a uno mismo", con firma declarada `"ambas las apruebo y firmo"` a las 04:24Z (firma que no apareció en esta sesión).
- `decisions/DEC-005-Cambiar-medio-a-OpenCode-Mobile-.md` — re-scope a OpenCode Mobile, con `source_ids` OC-WEB-001/OC-CLI-001 (añadidas a `SOURCES.md` por ese ciclo; `verify` las marca verdes).
- `docs/kaizen/adr/0032-numero-personal-mensaje-a-si-mismo.md` — Estado: aceptado; enmienda ADR-0031 §1 (número dedicado) → número personal.
- Mis decisiones en la misma sala: DEC-001/002 (número **dedicado**, WhatsApp opcional) y **DEC-004** (OpenCode mobile canal activo; WhatsApp opcional, número dedicado, flag=0).

## Impacto
Conflicto sustantivo no resuelto: **ADR-0031/DEC-004 dicen número dedicado; ADR-0032/DEC-003 dicen número personal**. No lo resolveré por mi cuenta: es una decisión sensible (datos personales/ban, ADR-0002/0003, L-3). `kaizen-team verify` está en verde para ambas, así que el orquestador no lo detecta como BLOCK: **requiere revisión humana explícita**.

## Propuesta
El Presidente debe confirmar cuál prevalece: (A) OpenCode mobile como canal activo + WhatsApp opcional con número **dedicado** (DEC-004), o (B) WhatsApp con número **personal** "mensaje a uno mismo" (ADR-0032/DEC-003). Hasta entonces: no conectar número, no escanear QR, no activar WAHA, no cambiar flags.

## Pregunta concreta
¿Confirma ADR-0032 (número personal) o mantiene DEC-004 (número dedicado, WhatsApp solo opcional)? Ack requerido.
