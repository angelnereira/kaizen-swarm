# Puente WhatsApp oficial (resumen operativo)

Fuente: documentación provisoria provista por El Presidente (2026-11-22), marcada como contenido externo no confiable (S-15/L-5). Verificar siempre contra `developers.facebook.com` y la consola de Meta antes de operar.

## Qué usamos

| Vía | Estado en este repo |
| --- | --- |
| Cloud API oficial vía BSP (Twilio, 360dialog, WATI, MessageBird) o Embedded Signup | **Única permitida** (`KN_WHATSAPP_MODE=bsp-cloud-webhook`) |
| API On-Premises | Descontinuada por Meta en octubre 2025 |
| Baileys / whatsapp-web.js (no oficial) | **Prohibida** (`KN_WHATSAPP_ALLOW_UNOFFICIAL=0`) |

## Requisitos (decisión humana, nunca en el repo)

1. Meta Business Verification.
2. WhatsApp Business Account (WABA) en Meta Business Manager.
3. Número de teléfono **dedicado**, con perfil de empresa.
4. App de Meta vinculada y access token vigente.
5. Webhook público HTTPS con validación de firma HMAC y procesamiento **idempotente** (Meta reintenta eventos).

Credenciales y firma HMAC viven en n8n/Vault/entorno. Nunca en `.kaizen/`, `example.env` ni logs.

## Ventana 24 h y plantillas

- Dentro de las 24 h desde la última interacción: mensaje libre (texto, imagen, botones, listas).
- Fuera de la ventana: **solo plantillas aprobadas** (HSM) de categoría Marketing, Utilidad o Autenticación.
- `kaizen-whatsapp template --id ... --category UTILITY --body "..."` crea la plantilla en estado `draft` hasta aprobación de Meta.
- `kaizen-whatsapp window --phone N` indica si applies mensaje libre o plantilla.
- Botones: máximo 3 quick replies; listas: hasta 10 ítems agrupados.

## Opt-in y políticas

- `KN_WHATSAPP_OPTIN_REQUIRED=1`: `kaizen-whatsapp optin add|check` guarda cuándo y cómo dio consentimiento el usuario.
- Opt-out claro y respetado.
- Prohibido spam, contenido inapropiado y mensajes no autorizados: riesgo de suspensión permanente.
- IA permitida solo para tareas estructuradas (servicio, estado de pedido/tarea, reservas, notificaciones transaccionales, autenticación). Fuera de dominio → humano o «fuera de alcance» (Meta lo prohíbe desde 2026-01-15).

## Costes (referencia, verificar por país y BSP)

Facturación por mensaje **entregado**, no por conversación. Referencia EE. UU.: Marketing ≈ US$25/1000; Utilidad/Autenticación/Servicio ≈ US$3.40/1000; 1000 mensajes de servicio gratuitos al mes por número. El BSP añade su tarifa. Registrar costes reales con `kaizen-tokens`/finops; **no afirmar cifras locales sin verificar**.

## Mapa con nuestra arquitectura

```text
Meta Cloud API ──► n8n (HMAC + idempotencia) ──► kaizen-inbox ──► kaizen-equipo (router)
                                                        │              ├─► especialistas
                                                        │              └─► humano (needs-human)
kaizen-notify ──► plantilla/ventana ──► n8n/BSP ──► WhatsApp
Grafana/local ──► observabilidad       workspaces externos ──► contexto por proyecto
```

## Operación

```bash
scripts/kaizen-whatsapp check
scripts/kaizen-whatsapp templates
scripts/kaizen-whatsapp optin add --phone <N> --source "checkbox-registro"
scripts/kaizen-whatsapp window --phone <N>
scripts/kaizen-remote issue-comment <N> --body "..." --dry-run   # no WhatsApp, pero mismo principio auditado
```

Ver ADR-0025 y `.kaizen/team/notify.env`.
