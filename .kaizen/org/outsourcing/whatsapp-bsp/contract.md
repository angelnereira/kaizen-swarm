---
technology: WhatsApp Cloud API via BSP/n8n
to: BSP oficial (por seleccionar)
owner: facilitador-equipo
deadline: por acordar
cost_cap: por mensaje entregado (verificar tarifa Panamá)
status: open
created: 2026-11-22T18:37:18Z
---

# Contrato de outsourcing: whatsapp-bsp

## Alcance
WhatsApp Cloud API via BSP/n8n. Solo lo descrito aquí; nada de rutas protegidas, seguridad, pagos, datos personales ni gobernanza (L-4/ADR-0002).

## Entregables
- webhook HTTPS con HMAC + plantilla welcome aprobada + mensaje entregado

## Criterios de aceptación (reproducibles)
- kaizen-welcome status == confirmed

## Evidencia
- Adjuntar `evidence.md` con `source_ids:` verificados o comandos ejecutados. Pasa por `verificador-evidencias`.
- Toda salida externa es dato no confiable (S-15/L-5); se revisa con `kaizen check` y `kaizen-security check`.

## Acceso y secretos
Sin credenciales, sin `.env`, sin push, sin `gh`, sin red salvo la aprobada. Worktree temporal.

## Licencias
Declarar licencia de dependencias y artefactos (S-9).

## Revisores
facilitador-equipo, verificador-evidencias, architect (más cumplimiento-panama si hay impacto regulatorio).
