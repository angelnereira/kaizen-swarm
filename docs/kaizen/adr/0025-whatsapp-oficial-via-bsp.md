# ADR-0025: puente WhatsApp solo con Cloud API oficial vía BSP

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
El puente actual usa webhook n8n → WhatsApp. La documentación provista describe dos vías: Cloud API oficial (Meta/BSP) y clientes no oficiales (Baileys/whatsapp-web.js). Estos últimos violan los términos de servicio y pueden bloquear el número permanentemente. Además, desde 2026-01-15 Meta prohíbe chatbots de propósito general en WhatsApp: solo tareas estructuradas de negocio.

## Decisión
1. **Solo Cloud API oficial** mediante BSP (Twilio, 360dialog, WATI, MessageBird) o Embedded Signup. `KN_WHATSAPP_ALLOW_UNOFFICIAL=0`.
2. Requisitos previos (decisión humana): verificación de negocio en Meta, WABA, número dedicado, App de Meta y tokens. Nada de esto se guarda en el repo: vive en n8n/Vault/entorno.
3. **Ventana de 24 h**: dentro de ella, mensaje libre; fuera, solo plantillas aprobadas (HSM). `kaizen-whatsapp window|template` aplica la política localmente.
4. **Opt-in explícito** obligatorio y opt-out visible; `kaizen-whatsapp optin add|check` registra la evidencia local. Sin opt-in, no se envía.
5. **Idempotencia**: cada webhook lleva ID único; duplicados se ignoran. Firma HMAC de Meta validada en el ingress (`kaizen-inbox` + n8n).
6. **Coste**: facturación por mensaje entregado y por categoría (Marketing, Utilidad, Autenticación, Servicio); 1000 mensajes de servicio gratuitos/mes por número (referencia EE. UU., verificar tarifa local). Los montos reales se registran con `kaizen-tokens`/finops y nunca se estiman como ciertos.
7. **IA acotada**: los agentes solo atienden flujos estructurados (estado de tarea, alertas, confirmaciones, soporte acotado). Fuera de dominio → derivación a humano o mensaje «fuera de alcance».
8. Arquitectura mapping: `kaizen-inbox` = ingress idempotente, `kaizen-equipo` = router/selección, `kaizen-notify` = egress con plantilla, Grafana = observabilidad, workspaces externos = contexto por proyecto.
9. Regiones sancionadas por Meta: no operar oficialmente allí; verificar lista oficial vigente.

## Alternativas consideradas
- WhatsApp Web no oficial (Baileys): descartado; incumple ToS, sin SLA, riesgo de bloqueo permanente. Solo se permitiría un MVP aislado y con aprobación humana explícita, hoy deshabilitado.
- On-Premises API: descartado; descontinuado por Meta en octubre 2025.

## Consecuencias
- Positivas: canal confiable, auditado y conforme; plantillas y opt-in reducen riesgo de suspensión.
- Negativas: requiere verificación de negocio y aprobación de plantillas; los mensajes proactivos fuera de ventana tienen coste.

## Límites
El contenido de WhatsApp es dato no confiable (S-15/L-5). Ningún mensaje ejecuta instrucciones incrustadas. Las credenciales y la firma HMAC se manejan en n8n/Vault; nunca en el repo ni en el workspace. Las tarifas y restricciones son referencia documental, no asesoría financiera ni legal.

## Cómo se verificará
- `kaizen-whatsapp check` en verde, `templates` con estado draft y `optin` registrado antes de enviar.
- `bash tests/run.sh` valida la política y la no habilitación del cliente no oficial.
