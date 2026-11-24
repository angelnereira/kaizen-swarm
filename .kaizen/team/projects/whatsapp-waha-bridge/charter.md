# Charter: whatsapp-waha-bridge

## Objetivo (actualizado 2026-11-24, DEC-004)
Canal de entrada para Kaizen Swarm usando **OpenCode como medio activo** (app móvil Android + `opencode serve`), con WhatsApp (WAHA) como **canal opcional en espera**. Equipos de hasta 12 agentes, archivo local persistente y contexto /*/*, reutilizando runtime y agentes sin reemplazarlos ni crear segunda arquitectura.

> Nota: el nombre del proyecto conserva el slug original `whatsapp-waha-bridge` por trazabilidad; el alcance real ahora es multi-canal OpenCode-first (DEC-004).

## KPI verificable
Fase 1: mensaje de remitente autorizado con HMAC X-Webhook-Hmac valido llega a .kaizen/team/inbox/ y kaizen-notify responde al mismo chat; 0 duplicados; sesion WAHA persiste tras reinicio; KN_WHATSAPP_ALLOW_UNOFFICIAL permanece 0 sin decision humana de enmienda ADR-0025

## Restricciones
- Decisiones con fuentes verificadas: .kaizen/team/EVIDENCIA.md
- Vetos: security, architecture, qa, compliance, scope, resource
- Proactividad con frenos: .kaizen/team/FLUJOS.md
