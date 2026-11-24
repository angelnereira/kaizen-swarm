# ADR-0031: enmienda de ADR-0025 — WAHA con número dedicado para Kaizen-Swarm

Estado: aceptado — **canal opcional en espera (no activo); ver DEC-004**
Fecha: 2026-11-24
Aprobado por: El Presidente (decisión explícita registrada por `kaizen-equipo` el 2026-11-24)
Enmienda a: ADR-0025 (puente WhatsApp solo con Cloud API oficial vía BSP)
Nota (2026-11-24, DEC-004 + DEC-006): El Presidente eligió **OpenCode vía app móvil Android como canal activo**; WhatsApp queda como canal opcional. Confirmó además **ADR-0032** para el caso "número personal, mensaje a uno mismo" (DEC-006): ese número prevalece **solo** para ese caso y vive fuera del repo (`owner.env`, `600`), nunca versionado. Para cualquier otro uso de WhatsApp con terceros se mantiene la línea base de este ADR (número dedicado + base legal/ANTAI). `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` sigue sin activarse.

## Contexto

El Presidente solicita WhatsApp como interfaz bidireccional de Kaizen Swarm (equipos de hasta 12 agentes, archivo local en rutas `/*/*`). El ADR-0025 fija `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` y descarta los clientes no oficiales por ToS y riesgo de bloqueo, pero contempla textualmente una excepción: *«Solo se permitiría un MVP aislado y con aprobación humana explícita, hoy deshabilitado»* (ADR-0025:22).

WAHA es un cliente **no oficial**: sus motores WEBJS/NOWEB son `whatsapp-web.js` y `Baileys` (WAHA-003), y el propio fabricante advierte que WhatsApp no permite bots/clientes no oficiales y que el bloqueo no está descartado (WAHA-001/002). No obstante, es software libre Apache-2.0 (WAHA-012), sin coste por mensaje, y expone REST + webhooks con HMAC-SHA512 (WAHA-007/010), suficiente para un MVP aislado.

El Presidente eligió explícitamente la opción «WAHA + número dedicado (gratuito)» el 2026-11-24, tras presentársele el contraste con Cloud API oficial y el riesgo de ToS/bloqueo.

## Decisión

1. Se habilita una **excepción acotada** al ADR-0025: WAHA queda autorizado **únicamente** como MVP aislado de Kaizen-Swarm, vinculado a un **número de WhatsApp dedicado**, distinto del número personal de El Presidente. El riesgo de bloqueo recae sobre ese número dedicado.
2. El número se vincula por QR. El escaneo es un acto **humano** con autorización explícita, sin credenciales en pantalla y sin activar computer-use (ADR-0018). `kaizen-equipo` **no** escanea ni posee credenciales.
3. La excepción **no** conmuta el valor global por defecto: `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` se mantiene como política por defecto del repositorio y `tests/run.sh` sigue verificándola. El cambio de flag para el MVP se hace **fuera del repositorio**, en configuración local del entorno aislado, y se documenta en el expediente de investigación. Cualquier cambio versionado del flag o del test exige un ADR nuevo y revisión humana.
4. Alcance técnico del MVP (aditivo, reversible, sin nueva plataforma):
   - `kaizen-inbox.py` se extiende con `X-Webhook-Hmac` (SHA-512, `hmac.compare_digest`), dedupe por ID y campos opcionales de media/ubicación, preservando `X-Kaizen-Secret`, `/inbox`, `/message` y el frontmatter `status: pending`.
   - `kaizen-notify` añade un canal `waha` junto a `file/webhook/email`, con correlación `chat_id` opcional; no se envían mensajes a terceros sin lista de destinatarios autorizada.
   - Servicio WAHA en compose **separado**, imagen fijada por tag **y** digest (`devlikeapro/waha:noweb-2026.10.1@sha256:0d64cce…`), sin `latest`, sin root, red privada, sin exposición pública, sesión y medios en volumen local excluido de Git.
   - Archivo local `whatsapp/{messages,context,index.jsonl}` bajo raíz configurable, con originales inmodificables, metadatos separados, SHA-256, y rutas `/*/*` resueltas y validadas dentro de la raíz (sin path traversal).
5. Contenido de WhatsApp, medios, ubicaciones, contactos, encuestas y eventos: **dato no confiable** (S-15/L-5). Ninguno ejecuta instrucciones incrustadas ni puede saltar vetos, autonomía o aprobación humana.
6. La trazabilidad queda documentada: el KPI del proyecto, los `source_ids` y los resultados de la POC se registran antes de declarar soportada cualquier capacidad (K-10: recibir el webhook ≠ recorrido completo probado).
7. **Alcance de remitentes (decisión del Presidente, 2026-11-24):** se aceptan mensajes del propietario **y de terceros autorizados** mediante allowlist explícita. Antes de activar el canal con terceros deben estar documentados la base legal y el responsable ante ANTAI para los datos personales (número, ubicación, vCards), conforme a PA-001/PA-002 y L-12. El incumplimiento de esta condición mantiene el veto `compliance` (ADR-0002) y bloquea la activación con terceros; el MVP puede operar primero solo con el propietario.
8. **Reafirmación y contingencia (decisión del Presidente, 2026-11-24):** el Presidente reafirma expresamente el riesgo de ban sin SLA y el uso exclusivo del número dedicado (queda registrado en este ADR, §Consecuencias) y aprueba el plan de contingencia: migrar a Cloud API oficial (ADR-0025) si el número es bloqueado o si Meta endurece la política, con revisión trimestral de META-003 (REG-EV-05).
9. **Secuencia de activación:** el equipo prepara contratos, descriptor y plan de prueba sin conectar número ni cambiar flags. QA ejecuta la POC de HMAC-SHA512 y *live location* cuando el Presidente proporcione el número dedicado y autorice el arranque del daemon Docker (ADR-0026). Hasta entonces el diseño permanece `CHANGES_REQUESTED` y ninguna capacidad se declara soportada.

## Alternativas consideradas

- **Mantener ADR-0025 y usar solo Cloud API oficial**: conforme, sin riesgo de ToS; descartada por el Presidente por no ser la vía gratuita/inmediata elegida. Sigue siendo el estado objetivo de producción si el MVP se abandona.
- **WAHA sobre el número personal del Presidente**: descartada; un baneo afectaría a su número real.
- **Enmendar ADR-0025 globalmente** (cambiar el flag por defecto en el repo): descartada; se prefiere excepción acotada y configuración fuera del repo.
- **Evolution API** como alternativa a WAHA (referencia externa, 2026-11-24): no adoptada. Es igualmente cliente no oficial (mismo conflicto ADR-0025/ToS), el usuario eligió WAHA (DEC-001), y carece de fuentes verificadas (`pending`, REG-EV-01). Requiere expediente `kaizen-org research` + decisión humana si se evalúa.
- **n8n como capa obligatoria** (referencia externa, 2026-11-24): rechazada. El pedido original fija n8n como **adaptador opcional** y prohíbe que lo esencial dependa de él. HMAC/allowlist/dedupe viven en el bridge y `kaizen-inbox.py`, no en n8n. n8n puede insertarse como automatización adicional sin ser dependencia del KPI.

## Consecuencias

- Positivas: canal gratuito e inmediato; número dedicado aísla el riesgo; reutiliza `kaizen-inbox`/`kaizen-notify`/runtime; evidencia oficial registrada en `SOURCES.md`.
- Negativas: ToS de WhatsApp no permite clientes no oficiales; posible ban del número dedicado; sin SLA; requiere verificación por POC del HMAC y de *live location*; el daemon Docker hoy está detenido (ADR-0026), por lo que el despliegue real queda condicionado a su arranque.
- **Reafirmación humana (2026-11-24):** El Presidente confirmó haber leído y aceptado el riesgo de bloqueo del número dedicado, la ausencia de SLA y la responsabilidad de usar exclusivamente el número dedicado (no el personal). Consecuencia: no se escala este riesgo específico en futuras decisiones; sí se escala cualquier cambio que afecte al número personal, a terceros o a datos personales.

## Cómo se verificará

- `kaizen-team verify whatsapp-waha-bridge` en verde con `source_ids` WAHA-*.
- Mensaje de remitente autorizado con HMAC válido → archivo en `.kaizen/team/inbox/` → respuesta al mismo `chat_id` → media/original persistido → 0 duplicados. Prueba de recorrido completo, no solo recepción de webhook.
- `git check-ignore` confirma que sesión, medios, inbox y `waha-data/` no son versionables.
- `tests/run.sh` sigue en verde (flag por defecto `0` intacto).
- Revisión trimestral (REG-EV-05) y cierre del MVP si Meta endurece la política (META-003).

## Enmienda posterior (2026-11-24)

**ADR-0032 (aceptada)** crea una excepción acotada adicional: autoriza el **número personal** de El Presidente únicamente en modalidad «mensaje a uno mismo», con firma humana y declaración de riesgo aceptado. Esto no conmuta la política por defecto (`KN_WHATSAPP_ALLOW_UNOFFICIAL=0` sigue en 0), no habilita terceros con el número personal y no autoriza a agentes a escanear QR, poseer credenciales ni arrancar Docker. La opción de número dedicado en el mismo teléfono sigue vigente y aprobada (plan `plans/poc-numero-dedicado-mismo-telefono.md`).
