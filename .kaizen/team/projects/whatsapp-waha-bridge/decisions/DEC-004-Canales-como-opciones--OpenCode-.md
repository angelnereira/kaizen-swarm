decision_id: DEC-004
topic: Canales como opciones: OpenCode mobile (Android) como canal activo, WhatsApp opcional
source_ids: ["LOCAL-005", "LOCAL-006", "WAHA-001"]
retrieved: 2026-11-24T04:47:43Z
status: verified
human_owner: El Presidente
---

# Decisión: Canales como opciones: OpenCode mobile (Android) como canal activo, WhatsApp opcional

## Evidencia
- Fuentes verificadas: 3
- Fuentes rechazadas: ninguna

## Opciones y decisión

El Presidente aclaró el alcance del cambio (2026-11-24): *«Ambos son Canales como opción, solo que OpenCode vía app mobile de Android en vez de WhatsApp»*.

| Canal | Rol | Gobernanza |
| --- | --- | --- |
| **OpenCode mobile (Android)** | **Canal activo preferido**. `ai.opencode.mobilecode` en Pixel 8 Pro → `opencode serve` (API v2/SSE) → agente `kaizen-equipo` → `kaizen-team` | Ya existe (LOCAL-005/006). No requiere número, QR, WAHA, HMAC, Docker ni ANTAI. |
| WhatsApp / WAHA | **Canal opcional**, no activado. Queda a disposición si el Presidente lo elige después | ADR-0025 + ADR-0031 + DEC-001/002 siguen **vigentes pero en espera**; no se reescriben ni se activan. |

**Decisión:** no hay cambio de arquitectura ni de núcleo. No se construye adaptador, bus ni MCP nuevo. Se usa la sesión de OpenCode (la app Android ya conectada) como medio para hablar con el equipo, y kaizen-equipo sigue convirtiendo cada instrucción en proyecto/tarea con KPI y `source_ids`.

## Incertidumbre y escalado

- Esta decisión **no** habilita WAHA, no conecta número y no cambia `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` (ADR-0031 §3).
- El KPI del proyecto se reescribe para medir el canal OpenCode: instrucción desde la app → tarea con KPI + ack → respuesta en la misma sesión. WhatsApp pasa a condición `pending` dentro del mismo proyecto.
- Lo ya verificado para WAHA (HMAC-SHA512, contratos, esquemas `metadata`/`location`) se conserva como **preparación reutilizable**, no se descarta.
- Sin push ni PR por iniciativa propia. Cualquier activación de WhatsApp requiere de nuevo los datos humanos (número, ANTAI, Docker).
