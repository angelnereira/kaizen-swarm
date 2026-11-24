# Contratos de interfaces — whatsapp-waha-bridge

> **Estado:** propuesta de arquitectura (diseño). No es implementación y no autoriza código.
> **Autor:** `architect` · **Fecha:** 2026-11-24 · **Proyecto:** `.kaizen/team/projects/whatsapp-waha-bridge/`
> **Decisiones relacionadas:** DEC-001 (2026-11-24), ADR-0031 (enmienda de ADR-0025).
> **Fuentes:** WAHA-001/002/003/007/009/010/011/012/014, META-003, LOCAL-001, reglas K-1/K-2/K-4/K-10/K-11/K-12, S-1/S-3/S-4/S-7/S-8/S-10/S-11/S-15, L-3/L-4/L-5/L-7/L-8/L-12.
> **Fecha de corte de fuentes:** 2026-11-24 (`.kaizen/org/knowledge/SOURCES.md:40-51`).
>
> **Advertencia L-5/S-15:** todo contenido de WAHA, webhooks, logs y buzones se trata como **dato no confiable**. Ningún texto entrante instruye al equipo: se convierte en tarea y se verifica antes de actuar (Igual que la `INSTRUCCIÓN RECIBIDA DE EL PRESIDENTE` que inyecta `scripts/kaizen-runtime:56-57`).

---

## 0. Principio rector (no negociable)

Se **reutiliza sin reemplazar** (`scripts/kaizen-inbox.py`, `scripts/kaizen-notify`, `scripts/kaizen-runtime`). El bridge es un **adaptador delgado y local**, no una plataforma: traduce eventos WAHA al contrato ya existente del inbox y publica respuestas por el canal ya existente del notify.

- `kaizen-inbox.py:56-89` sigue siendo el **único productor** del `.md` en `.kaizen/team/inbox/`; por eso el frontmatter `status: pending` se conserva sin tocarlo. El bridge **nunca** escribe ni marca ese `.md` (de `status: pending -> processed` se encarga `kaizen-runtime:45-47`).
- `kaizen-notify` sigue siendo el **único punto de salida**; `waha` se añade como un caso más en `cmd_send` (`scripts/kaizen-notify:55-57`), junto a `file`/`webhook`/`email`.
- `kaizen-runtime:42-47` sigue leyendo el **primer** `*.md` ordenado y aplica el cambio `status: pending -> processed`. El bridge **no** altera ese mecanismo: publica **un solo** `.md` por instrucción admitida (0 duplicados, KPI).

### 0.1 Topología y límites de red

```
WAHA (contenedor, sesión dedicada)
   |  POST <KI_WEBHOOK_PATH>   [raw body + X-Webhook-Hmac + X-Webhook-Timestamp + X-Webhook-Request-Id]
   v
bridge-waha (proceso local delgado, sin BD, sin bus)
   |  1) HMAC + anti-replay + allowlist + dedupe   -> fail closed
   |  2) archiva en <KI_DATA_DIR>/whatsapp/        (originales inmodificables, metadata separada)
   |  3) POST http://127.0.0.1:<KI_PORT>/inbox     [X-Kaizen-Secret]  {from,channel:"waha",text}
   v
kaizen-inbox.py  ->  .kaizen/team/inbox/*.md  (status: pending)
   v
kaizen-runtime   ->  status: processed + inyección como instrucción (dato no confiable)
   v
kaizen-notify[canal waha]  ->  WAHA sendText/sendFile/... [X-Api-Key] con reply_to al mismo chat
```

- El bridge escucha **solo en loopback / interfaz aislada**; nunca expone WAHA ni el bridge a redes públicas (WAHA-010, S-6). El contenedor debe poder alcanzar el puerto del bridge (ADR-0026, infra): **si no hay ruta loopback/host aislada, es `needs-human` de infra**, no se abre un puerto público.
- Secretos: solo **nombres** de variables de entorno (`KI_SHARED_SECRET_VAR`, `KN_WEBHOOK_SECRET_VAR`, y los nuevos `WAHA_WEBHOOK_SECRET_VAR`, `WAHA_API_KEY_VAR`). El bridge **no lee** `notify.env` directamente para valores, **no imprime** cabeceras ni cuerpos (S-1/S-2/S-8); `kaizen-inbox.py:91-93` ya lo hace así.

---

## 1. Contrato INGRESS — evento WAHA → instrucción del inbox

### 1.1 Endpoint y petición

| Elemento | Contrato |
| --- | --- |
| Ruta | `<KI_WEBHOOK_PATH>` (configurable, por defecto `/webhook/waha`), servida por el bridge en `127.0.0.1`. |
| Método | `POST`, `Content-Type: application/json`. |
| Cuerpo | El **raw body exacto** de WAHA. Se guarda tal cual para HMAC; se parsea **después** de verificar. |
| Cabeceras obligatorias | `X-Webhook-Hmac`, `X-Webhook-Timestamp`, `X-Webhook-Request-Id`. |
| Respuesta | `200 {"ok":true,"event_id":...}` si admitido; `401` si HMAC/allowlist fallan; `409` si duplicado/replay; `400` si payload inválido. Nunca devuelve secretos ni cuerpo del mensaje. |

### 1.2 Validación HMAC (fail closed)

1. Calcular `HMAC-SHA512(secret, raw_body_bytes)` con el secreto leído de la variable cuyo **nombre** declara `WAHA_WEBHOOK_SECRET_VAR` (S-1/S-3: si falta o está vacía, el bridge **falla rápido** al arrancar sin imprimir el valor).
2. Normalizar `X-Webhook-Hmac`: aceptar `sha512=<hex>`, `sha512:<hex>` y `<hex>` (WAHA-007 declara `sha512`; **el vector exacto de cálculo está pendiente de POC**, ver §7). Normalizar a minúsculas y quitar espacios.
3. Comparar en **tiempo constante** (`hmac.compare_digest`) contra el hex calculado. Si no coincide o la cabecera es malformada → `401`, **sin escritura** en inbox ni en archivo, y se emite un evento de error al `kaizen-notify` canal `file` (S-7/S-8, sin secretos).
4. **POC pendiente:** si la POC demuestra otro vector (p. ej. canonicalización JSON en lugar de raw body), se actualiza **este contrato** antes de habilitar el canal. Mientras tanto `KN_WHATSAPP_MODE` permanece en modo preparación y `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` sin decisión humana (ADR-0025/0031).

> Nota de evidencia: WAHA-007 (`Events/webhooks`, fecha de corte 2026-11-24) confirma la cabecera y el algoritmo declarado; `SOURCES.md:51` registra explícitamente la inconsistencia documental con una herramienta SHA-256. **No afirmar soporte verificado** hasta POC.

### 1.3 Anti-replay y dedupe

| Control | Regla |
| --- | --- |
| Timestamp | `X-Webhook-Timestamp` (ISO-8601 o epoch, según POC) debe estar dentro de `WAHA_REPLAY_SKEW_SEC` (por defecto 300 s) respecto al reloj local (UTC). Fuera de ventana → `409`. **Cabecera a confirmar en POC** (WAHA-007 confirma `X-Webhook-Request-Id`; `X-Webhook-Timestamp` es requerimiento de este contrato, no fuente verificada aún). |
| Request-Id | `X-Webhook-Request-Id` se registra en `index.jsonl`; si ya existe dentro de `WAHA_DEDUPE_TTL_SEC` (por defecto 86400 s) → `409`, sin nueva tarea. |
| Dedupe primario | `event_id`: `message.id` para `message`; `payload.id` (o equivalente confirmado en POC) para `poll.vote` y `event.response`. Un `event_id` admitido **produce como máximo un** `.md` en el inbox (KPI: 0 duplicados). |
| Estado de dedupe | Archivo `<KI_DATA_DIR>/whatsapp/state/dedupe.json` (JSON append/upsert, **no una BD**). Entrada: `{event_id, request_id, received, disposition}`. |
| **Agrupación de *live location*** | Si `location.live == true`, el evento **no crea tarea nueva**: se hace *upsert* de `location.json` y se incrementa `updated` en `metadata.json` de la **misma** carpeta `<message-id>` (clave de sesión `live_session_id = sha256(chat_id + "|" + message.id del primer evento de la sesión)`). Se registra cada actualización en `index.jsonl` como `{"op":"location_update",...}`. Se emite **una sola** instrucción al inicio de sesión y, como máximo, **una** al cierre si la POC confirma un evento de fin; mientras tanto el cierre se deduce por inactividad > `WAHA_LIVE_TTL_SEC` (por defecto 300 s) y se marca `poc-pending`. Esto evita tormenta de tareas por actualizaciones de ubicación. |

### 1.4 Allowlist de remitente (fail closed)

- `WAHA_ALLOWED_CHATS` (lista de `chatId` autorizados, nombres de variable únicamente). Solo se admiten eventos cuyo `chatId` esté en la lista.
- El remitente se deriva de `message.from` y se normaliza con la misma idea de `safe_name()` (`kaizen-inbox.py:22-23`: `[^A-Za-z0-9_-]`, máx. 40). Resultado: `from = "waha_" + safe_name(sender)` para que el inbox no mezcle identidades (default del inbox sería `whatsapp`; aquí se fija explícitamente).
- Si no hay allowlist configurada → el bridge **no admite ningún mensaje** (denegar por defecto, S-6).

### 1.5 Mapeo exacto de campos

El bridge envía a `POST /inbox` **solo** `{from, channel, text}` — el contrato que `kaizen-inbox.py:69-88` ya entiende. Los campos aditivos viajan en el archivo local (§3) y **no** se intentan meter en el frontmatter, para no romper el `sed` de `kaizen-runtime:46`.

| Evento WAHA (fuente) | Campo de entrada | `text` enviado al inbox (sanitizado por `kaizen-inbox.py:26-38`) | Campos aditivos (archivo local) |
| --- | --- | --- | --- |
| `message` [WAHA-007/011] | `message.body` | El cuerpo del mensaje. Si `hasMedia=true`, se añade una línea `MEDIA: <tipo> (<filename>)` y un extracto acotado de `extracted.md`. | `event_id`, `chat_id`, `timestamp`, `media[]`, `tipo`, `mime`, `sha256` |
| `message` con `location` [WAHA-011] | `message.location.{latitude,longitude,name,address,live}` | `UBICACIÓN: <lat>,<lon> — <name> — <address>` (acotado). | `location` → `location.json` (§3.3) |
| `message` con `vCards` [WAHA-011] | `message.vCards[]` | `VCARD: <nombre> <teléfono>` por cada tarjeta, acotado. | `vCards[]` |
| `poll.vote` [WAHA-007] | `payload` (voto/opción) | `POLL: <opción votada>` | `poll` (objeto crudo saneado) |
| `event.response` [WAHA-007] | `payload` (respuesta a evento) | `EVENTO: <texto de respuesta>` | `event` (objeto crudo saneado) |
| cualquier otro `event` | `payload` | `EVENTO WAHA: <tipo>` — **solo si** está en allowlist de tipos; si no, `409` y finding, nunca texto arbitrario. | `event_type` |

Reglas del `text`:

- Se conserva el `sanitize()` del inbox (`kaizen-security redact` + corte a 4000 caracteres, `kaizen-inbox.py:26-38`). El bridge **no** relaja ese límite y **no** envía secretos.
- `channel` es siempre la constante `"waha"` (`safe_name` lo deja intacto).
- El bridge **no** escribe `received`, `from` ni `status` en el `.md`: los produce `kaizen-inbox.py:81-84`. La respuesta `{ok:true,file:"..."}` del inbox se guarda en `metadata.referencias` y en `referencias/inbox-map.jsonl` para correlacionar la salida (§2.2).

### 1.6 Secuencia operativa (orden estricto)

1. Verificar HMAC (§1.2) sobre raw body.
2. Verificar timestamp + Request-Id (§1.3).
3. Parsear JSON; validar esquema mínimo; aplicar allowlist (§1.4).
4. Calcular `event_id` y dedupe; si duplicado/live-update, seguir la rama correspondiente (§1.3) **sin** postear al inbox.
5. Archivar en `<KI_DATA_DIR>/whatsapp/` (§3): crear carpeta `<message-id>`, escribir `original/` inmodificable, `message.md`, `location.json`/`extracted.md` si aplica, `metadata.json`, `summary.md`, y append en `index.jsonl`.
6. Postear a `127.0.0.1:<KI_PORT>/inbox` con `X-Kaizen-Secret` y `{from,channel:"waha",text}`.
7. Registrar `inbox_file` devuelto en `metadata.referencias` y en `inbox-map.jsonl`.
8. Si cualquier paso falla: **no** se marca `status: processed`, se escribe `estado: failed` en `metadata.json`, se notifica por canal `file` y se reporta por outbox S-11 (K-10/S-11). Nunca se "aprueba" un fallo (S-10).

---

## 2. Contrato EGRESS — `kaizen-notify` canal `waha`

### 2.1 Adición aditiva al notify (sin romper file/webhook/email)

- `KN_CHANNELS` acepta ahora `waha` como token más en `cmd_send` (`scripts/kaizen-notify:55-57`). Los canales existentes conservan su comportamiento y orden: `file`, `webhook`, `email`, `waha`.
- Nueva función `send_waha()` con la misma semántica que `send_webhook()`: si no hay URL base/API key configuradas (nombres `KN_WHATSAPP_API_URL_VAR`, `WAHA_API_KEY_VAR`), hace `klog` y `return 0` (omite). Si `curl` falla → `kfail` → `FAIL=1` (idéntico a `send_webhook:26`). **No se silencia** (S-7/S-10).
- `cmd_event(team, rc, detail)` y `cmd_send(...)` siguen siendo la única API pública; no se crea un segundo comando de salida.
- `status` de `kaizen-notify:75` incluye `waha: configurado|omitido` sin imprimir secretos.

### 2.2 Correlación con el mismo chat y `reply_to`

| Elemento | Contrato |
| --- | --- |
| `chatId` | Se resuelve desde `inbox-map.jsonl` / `context/<agente>/<chat_id>/last_inbound.json` usando el `chat_id` de la tarea. Si no hay correlación, se envía sin `reply_to` y se registra el finding; **nunca** se inventa un id. |
| `reply_to` | El `message.id` (event_id) del último inbound admitido en ese chat, pasado como campo `reply_to` del endpoint WAHA (WAHA-009). `kaizen-notify` acepta `--reply-to` opcional en `cmd_send`; `cmd_event` lo hereda del contexto. |
| Plantillas / ventana | Salida solo dentro de la política vigente: `KN_WHATSAPP_WINDOW_HOURS`, `KN_WHATSAPP_TEMPLATES_DIR`, `KN_WHATSAPP_OPTIN_REQUIRED` (nombres ya presentes en `notify.env`). Fuera de ventana o sin plantilla aprobada → no enviar y escalar; ADR-0025/0031. |

### 2.3 Endpoints y restricción de archivos salientes

- `sendText` → `{chatId, text, reply_to}`; `sendFile`/`sendImage` → `{chatId, file, reply_to}`; `sendLocation` → `{chatId, location{latitude,longitude,name,address}, reply_to}`; `sendPoll` → `{chatId, poll, reply_to}`; `sendEvent` → `{chatId, event, reply_to}` (WAHA-009). Todas con `X-Api-Key` saliente (WAHA-010), **nunca en URL** (S-6).
- Archivos salientes **solo** desde raíces autorizadas declaradas en `KN_WHATSAPP_SEND_DIRS` (por defecto vacío = ninguno). Algoritmo: `realpath(candidato)` debe empezar por `realpath(raiz_autorizada) + "/"`; si no, rechazar. Se prohíbe `..`, symlinks que salgan de la raíz, rutas absolutas arbitrarias del repo y cualquier archivo bajo `.kaizen/`, `~/.ssh`, `~/.aws` o credenciales (S-2/S-4).
- Límite de tamaño `KN_WHATSAPP_MAX_ATTACH_BYTES` (por defecto 10 MiB) y MIME allowlist `KN_WHATSAPP_SEND_MIMES`. Si se exceden → rechazo con log sin datos del archivo.
- Ningún archivo de `original/` se envía de vuelta sin revisión humana: los originales son evidencia, no contenido de salida.

---

## 3. Esquema de archivo local (bajo `KI_DATA_DIR`)

### 3.1 Raíz y árbol

`KI_DATA_DIR` es obligatoria y validada al arrancar (S-3: si falta, fallo rápido con mensaje claro y **sin valores**). Ejemplo de valor: `<raiz>/whatsapp`. **No** se usa BD ni índice vectorial nuevo.

```
<KI_DATA_DIR>/
  messages/
    AAAA/
      MM/
        DD/
          <message-id>/
            metadata.json        # campos §3.2 (siempre)
            message.md           # texto saneado (nunca el raw secreto)
            original/            # bytes exactos descargados de WAHA — INMODIFICABLES
              <filename>         # solo basename; sha256 en metadata
            extracted.md         # texto extraído de media (opcional)
            summary.md           # resumen para el equipo (acotado)
            location.json        # solo si location presente (§3.3)
  context/
    <agente>/                    # hasta KT_MAX_AGENTS=12 (kaizen-runtime:170)
      <chat_id>/
        *.ref                    # punteros a <message-id>; NO copias de originales
        last_inbound.json        # chat_id + último event_id/message.id (para reply_to)
        notas.md                 # trabajo del agente, dato no confiable
  index.jsonl                    # append-only: received|classified|dispatched|location_update|failed
  state/
    dedupe.json                  # §1.3
  referencias/
    inbox-map.jsonl              # event_id -> inbox_file devuelto por kaizen-inbox.py
```

> Los patrones `context/*/*` (agente/chat) se resuelven y validan dentro de la raíz (§3.4). El máximo de 12 agentes se hereda de `KT_MAX_AGENTS` (`kaizen-runtime:170`), no se redefine aquí.

### 3.2 `metadata.json` (campos obligatorios y aditivos)

Esquema normativo: `contracts/schemas/metadata.schema.json`.

| Campo | Tipo | Regla |
| --- | --- | --- |
| `id` | string | `<message-id>`; coincide con el nombre de carpeta. |
| `received` | date-time UTC | Momento de admisión, no de reenvío. |
| `updated` | date-time UTC | Igual a `received` al crear; se actualiza en `location_update`. |
| `sender` | string | Id original de `message.from`, antes de `safe_name`; **nunca** un secreto. |
| `channel` | const `"waha"` | Fijo; distingue origen de `file`/`webhook`/`email`. |
| `tipo` | enum | `text\|image\|video\|audio\|document\|location\|poll\|vcard\|event\|unknown`. |
| `mime` | string\|null | Tipo MIME detectado del original. |
| `filename` | string\|null | Solo basename; **nunca** ruta absoluta. |
| `sha256` | string(64 hex)\|null | Hash de `original/`; `null` si no hay media. |
| `estado` | enum | `archived\|dispatched\|processed\|failed\|duplicate-suppressed\|poc-pending`. |
| `resumen` | string | Texto acotado para el equipo (redactado). |
| `referencias` | string[] | `inbox_file`, `extracted.md`, `location.json`, ids relacionados. |

Aditivos (opcionales, todos saneados): `event_id`, `chat_id`, `event_type`, `timestamp`, `reply_to`, `media[]`, `vCards[]`, `poll`, `event`, `live`, `hmac` (`verified`\|`poc-pending` — **nunca** el secreto ni el digest), `dedupe_key`, `errors[]`.

### 3.3 `location.json`

Esquema normativo: `contracts/schemas/location.schema.json`.

| Campo | Tipo | Origen / regla |
| --- | --- | --- |
| `lat` | number | `location.latitude` [WAHA-011]. |
| `lon` | number | `location.longitude` [WAHA-011]. |
| `precision` | number\|null | Metros estimados; `null` hasta POC (WAHA no expone precisión). |
| `live` | boolean | `location.live` [WAHA-011]; activa la regla de agrupación §1.3. |
| `timestamp` | date-time UTC | Momento del evento (o del muestreo, si POC lo distingue). |
| `name` | string\|null | `location.name` [WAHA-011]. |
| `address` | string\|null | `location.address` [WAHA-011]. |

### 3.4 Reglas duras del archivo

1. **Originales inmodificables:** `original/` se escribe una sola vez, se calcula `sha256` y no se editan ni borran por el bridge. Borrado/retención = decisión humana con runbook, no del bridge.
2. **Metadatos separados:** nunca se incrustan campos en el `.md` del inbox ni se reescribe el frontmatter; `message.md` es texto saneado, `metadata.json` es la verdad estructurada.
3. **Sin BD/vectorial nuevo:** `index.jsonl`, `dedupe.json` e `inbox-map.jsonl` son archivos append/upsert. No se añade SQLite, Chroma/pgvector ni servicio de búsqueda.
4. **Path traversal:** toda ruta derivada de datos entrantes (incluidos `context/*/*`, `filename`, `chat_id`, `agente`) se valida con `realpath` y debe quedar **dentro** de `realpath(KI_DATA_DIR)`; se rechazan `..`, `.` ocultos, symlinks que salgan, caracteres de control y absolutos. `filename` se reduce a `basename` con la misma política de `safe_name` del inbox. Un path inválido → `400`/finding, nunca escritura.
5. **Sin secretos en archivos ni logs:** el bridge no persiste cabeceras HMAC, `X-Api-Key`, tokens ni datos personales más allá del `sender` mínimo necesario para correlacionar (S-1/S-8/L-12). Salida saneada con `kaizen-security redact`, igual que `kaizen-inbox.py:28-37`.
6. **Reversibilidad (L-7):** el archivo es aditivo; deshabilitar `waha` no exige migración ni borrado. `index.jsonl` permite reconstruir la cronología.

---

## 4. Límites explícitos — qué NO se construye

1. **No** nueva plataforma ni marco de mensajería: no se sustituye `kaizen-inbox.py`, `kaizen-notify` ni `kaizen-runtime`.
2. **No** bus de mensajes, colas, pub/sub ni broker (Redis, RabbitMQ, NATS…).
3. **No** base de datos nueva (ni SQLite) ni sistema vectorial/embedding/RAG (no `pgvector`, Chroma, FAISS…).
4. **No** microservicio por archivo ni por agente: un solo proceso local delgado (`bridge-waha`) y un canal adicional en `kaizen-notify`.
5. **No** cliente no oficial alternativo (Baileys/whatsapp-web.js) ni reemplazo de WAHA; tampoco migración a Cloud API oficial sin ADR humano (WAHA-001/003, ADR-0025/0031).
6. **No** exponer WAHA ni el bridge a red pública, ni desactivar verificación TLS, ni `latest` en imágenes (WAHA-010/014, S-5/S-16).
7. **No** activar `KN_WHATSAPP_ALLOW_UNOFFICIAL` ni el daemon Docker sin humano (ADR-0018/0026, §7).
8. **No** suprimir pruebas, escáneres ni advertencias; ningún `|| true`/`skip` sin issue en la misma línea (S-10).

---

## 5. Decisiones de diseño, alternativas y rollback

| # | Decisión | Alternativa descartada | Justificación (evidencia) | Rollback |
| --- | --- | --- | --- | --- |
| D1 | Adaptador delgado `bridge-waha` delante del inbox | Modificar `kaizen-inbox.py` para parsear WAHA | `kaizen-inbox.py` es rutina reutilizada y su frontmatter `status: pending` es consumido por `kaizen-runtime:45-47` (K-1, L-4) | `KI_WEBHOOK_PATH` sin ruta / `KN_WHATSAPP_MODE=preparacion`; el inbox queda intacto |
| D2 | Campos aditivos en `metadata.json`/`index.jsonl`, no en el frontmatter | Ampliar el frontmatter del `.md` | `kaizen-runtime:43,46` usa `sed` rígido; añadir claves rompe la extracción | Los archivos son aditivos: ignorarlos no afecta al runtime |
| D3 | Destino `127.0.0.1:<KI_PORT>/inbox` con `X-Kaizen-Secret` | Escribir directamente en `.kaizen/team/inbox/` | Pierde `sanitize()` y el frontmatter canónico (`kaizen-inbox.py:69-88`, S-4/S-8) | El bridge deja de postear; inbox sigue funcional para otros canales |
| D4 | `waha` como caso nuevo en `cmd_send` | Script `send_waha` separado | Un único punto de salida y semántica de fallo igual a `webhook` (`kaizen-notify:19-27,55-57`) | Quitar `waha` de `KN_CHANNELS`; file/webhook/email inalterados |
| D5 | Dedupe por archivo (`dedupe.json` + `index.jsonl`) | Tabla en BD / caché externa | Prohíbe BD nueva (§4); suficiente para 12 agentes | Borrar/ignorar `dedupe.json` y reconstruir desde `index.jsonl` |
| D6 | *Live location* = upsert en sitio, una sola tarea | Una tarea por actualización | Evita tormenta de tareas (KPI: 0 duplicados); `location.live` es el único flag oficial [WAHA-011] | Umbral `WAHA_LIVE_TTL_SEC` ajustable;marcar `poc-pending` si el payload real difiere |
| D7 | Fail-closed en HMAC/allowlist/timestamp | Aceptar y luego filtrar | S-6 (denegar por defecto), WAHA-010, KPI de remitente autorizado | Modo preparación; ningún mensaje se admite hasta POC + humano |

---

## 6. Criterios de aceptación verificables (alineados al KPI)

1. Con HMAC válido y `chatId` allowlisted: exactamente **un** `.md` con `status: pending` en `.kaizen/team/inbox/` y `metadata.estado=dispatched`. Comando reproducible: inspeccionar `index.jsonl` y el `.md` (sin secretos).
2. Reenviar el mismo `event_id`/`X-Webhook-Request-Id`: respuesta `409`, **cero** `.md` nuevos (`0 duplicados`).
3. HMAC inválido o `chatId` no allowlisted: `401`, cero escrituras, evento de error en `notifications.jsonl` sin secretos.
4. `kaizen-notify` con `KN_CHANNELS=...,waha`: `sendText` con `reply_to` igual al `message.id` del último inbound del mismo `chat_id`; `file`/`webhook`/`email` siguen funcionando.
5. Reinicio del bridge: `dedupe.json`, `index.jsonl` y `inbox-map.jsonl` persisten; la sesión WAHA persiste (sesión dedicada, verificado por POC).
6. Intento de path traversal en `filename`/`context` → rechazo y finding; ningún archivo fuera de `KI_DATA_DIR`.
7. `KN_WHATSAPP_ALLOW_UNOFFICIAL` sigue `0` y `KN_WHATSAPP_MODE` no se activa sin decisión humana (ADR-0025/0031).

---

## 7. Incertidumbre, POC pendiente y escalado (no afirmar como soporte)

- **HMAC-SHA512 (POC, QA):** vector de cálculo no verificado localmente; WAHA-007 declara `sha512` pero `SOURCES.md:51` registra inconsistencia con documentación de SHA-256. `X-Webhook-Timestamp` no aparece en las fuentes verificadas: es requisito de este contrato, **pendiente de confirmar**. Hasta POC, §1.2 es diseño, no comportamiento probado.
- **Live location (POC, QA):** no hay payload ni frecuencia de ejemplo oficial; WAHA-011 solo expone el flag `location.live`. Las reglas §1.3 y §3.3 son provisionales y llevan `estado: poc-pending` hasta verificación con número de prueba.
- **Humano (El Presidente):** (1) número dedicado + autorización de escaneo QR (ADR-0018, sin credenciales en pantalla); (2) arranque del daemon Docker (ADR-0026, hoy detenido); (3) cualquier activación de `KN_WHATSAPP_ALLOW_UNOFFICIAL` requiere ADR humano. Ninguno lo ejecuta el equipo por su cuenta (L-3/L-4).
- **Cumplimiento (veto `compliance`):** `cumplimiento-panama` no ha emitido dictamen; cualquier acción regulatoria/legal (ToS, META-003) se escala. Este contrato **no** da asesoría legal.
- **Infra:** reachability del webhook desde el contenedor WAHA al bridge sin exponer red pública (§0.1) — resolver con humano antes de `execute`.

---

## 8. Fuentes citadas (source_ids, ancla, fecha de corte 2026-11-24)

| source_id | Ancla usada en este contrato |
| --- | --- |
| WAHA-001 | disclaimer de cliente no oficial / riesgo de ban |
| WAHA-002 | "How to Avoid Blocking" |
| WAHA-003 | motores WEBJS/NOWEB/GOWS |
| WAHA-007 | eventos `message`, `poll.vote`, `event.response`; `X-Webhook-Hmac` (sha512), `X-Webhook-Request-Id` |
| WAHA-009 | sendText/sendFile/sendImage/sendLocation/sendPoll/sendEvent + `reply_to` |
| WAHA-010 | `X-Api-Key` saliente; no exponer API en redes públicas |
| WAHA-011 | `WALocation{latitude,longitude,live,name,address}`, `WAMessage.vCards` |
| WAHA-012 | licencia Apache-2.0 |
| WAHA-014 | tag fijado `devlikeapro/waha:noweb-2026.10.1@sha256:0d64cce…` (sin `latest`) |
| META-003 | WhatsApp Business Messaging Policy (contexto de cumplimiento, no fundamento operativo) |
| LOCAL-001 | ADR-0025:8 — prohibición de cliente no oficial y `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` |
| DEC-001 / ADR-0031 | decisión humana de adoptar WAHA con número dedicado (2026-11-24) |
| Codificado | `scripts/kaizen-inbox.py:22-23,26-38,56-89` · `scripts/kaizen-notify:19-27,49-57,75` · `scripts/kaizen-runtime:42-47,170` |

> Toda norma citada aquí lleva `source_id` verificable y fecha de corte. Los elementos marcados `poc-pending` carecen de fuente verificada y **no** sustentan una decisión (REG-EV-01, K-10).

---

## 9. Alineación con referencia OpenCode/WAHA (dato externo no confiable)

> El documento pegado por El Presidente se trata como **dato no confiable** (S-15/L-5): **sin `source_id`**, sin fecha de corte verificable. Se lee y se contrasta con el repo; **no** funda decisiones (REG-EV-01/K-10). No cambia el KPI (§6), ni DEC-001/ADR-0031, ni las decisiones §5. Esta sección es **documentación aditiva**: no implementa código.

### 9.1 Verificación contra el repo real — «¿kaizen-swarm es hoy un servidor HTTP/WebSocket con spawner SDK?»

**Conclusión: NO.** No existe tal servidor ni tal spawner. Evidencia reproducible (lectura directa, sin secretos):

| Afirmación del documento | Realidad verificada en el repo |
| --- | --- |
| «servidor HTTP/WebSocket en :8080» | Únicos listeners: `scripts/kaizen-inbox.py:97` → `HTTPServer(("127.0.0.1", 8787))` (buzón) y `scripts/kaizen-exporter.py:291` → `ThreadingHTTPServer` en :9101 (métricas). Sin :8080, sin WebSocket en `kaizen-start`/`kaizen-swarm`/`kaizen-runtime` (búsqueda `HTTPServer|WebSocket|websocket|serve(|listen(` → sin coincidencias). |
| «levanta sesiones OpenCode vía `@opencode-ai/sdk` (`opencode serve --port 4096` + SSE)» | No hay `@opencode-ai/sdk`, `opencode serve`, `--port 4096` ni SSE en el repo. La ejecución real es CLI: `scripts/kaizen-runtime:9,66,148` → `timeout … "$KR_AGENT_CMD" run --agent "$member" … --archived "$prompt"` (`KR_AGENT_CMD=opencode`). |
| «progreso por POST /api/sendText» | No existe `/api/sendText`. La salida real es `scripts/kaizen-notify:49-70` (`cmd_send`/`cmd_event` con canales `file/webhook/email`), confirmado en el contrato §2. |
| «registrar MCP `waha-whatsapp` en opencode.json» | `opencode.json` contiene **solo** `$schema`, `instructions` (11) y `permissions` (26); no hay clave `mcp`, `waha`, `sdk` ni `serve` (búsqueda case-insensitive → sin coincidencias). |
| «worktree distinto por sesión» | Ya existe: `scripts/kaizen-swarm:102-108` crea `wt-issue-<N>-<rol>` y ejecuta `"$agent" run "$prompt"`; `.kaizen/swarm/PROTOCOL.md:50` y `.kaizen/swarm/ROLES.md:9` lo fijan como contrato. |
| «equipo de 12 agentes» | Ya existe: `scripts/kaizen-runtime:170` (`KT_MAX_AGENTS=12`), `:20-22,51-76` (miembros desde `teams.json`), `:35-36` (`flock` anti-recursividad), `:101-106` (round-robin), `:164-184` (despliegue paralelo). `scripts/kaizen-start:26,69-71` arranca `kaizen-runtime up` + buzón + notify. |

> El orquestador actual es **por archivos y CLI**, no por servidor: `.md` en el inbox → `status: pending/processed` (`kaizen-runtime:42-47`) → comandos `opencode run` → `last.json:78` → `notify event:88-89`. Cualquier servidor HTTP/SSE descrito en el documento ajeno sería **nuevo**.

### 9.2 Patrón A = segunda arquitectura de orquestación → RECHAZADO

El pedido original prohíbe explícitamente «una segunda arquitectura de orquestación» y «un nuevo sistema multiagente». Un spawner de sesiones OpenCode por SDK (Patrón A) **violaría** esa restricción:

1. **Duplicidad:** el enjambre de hasta 12 agentes ya se ejecuta con `kaizen-runtime` + `kaizen-swarm` + delegación con `KAZEN_AGENT_DEPTH` (`:66,148`). Añadir otro spawner crea dos dueños de la misma tarea.
2. **Salta las puertas:** un `POST /api/sendText` que lanza agentes elude leases/acks/BLOCK (`scripts/kaizen-swarm:136-141`), el `flock` anti-recursivo (`kaizen-runtime:35-36`) y el contrato `status: pending` del que depende el runtime (§0).
3. **Superficie nueva:** requiere nueva dependencia SDK (S-9), un servicio con SSE (S-16) y un segundo estado de sesiones; la evidencia del documento es un patrón, **no** un hecho verificado en este repo (K-10).
4. **Coste/riesgo sin beneficio:** el objetivo (recibir un mensaje y responder al mismo chat) ya se logra con el puente aditivo.

**Se mantiene el puente aditivo:** `WAHA → bridge → kaizen-inbox.py → .kaizen/team/inbox/*.md (status: pending) → kaizen-runtime → kaizen-notify[waha]`. Es la única forma de preservar la decisión `DEC-001` y los gates existentes sin reemplazarlos (K-1/K-12, §0).

### 9.3 Ideas compatibles que SÍ se incorporan

- **(a) Motor NOWEB — corrobora, no cambia.** Ya está fijado `devlikeapro/waha:noweb-2026.10.1@sha256:0d64cce…` [WAHA-014] y `NOWEB=Baileys` [WAHA-003]. El argumento de bajo RAM del documento refuerza la elección actual. GOWS no se adopta: cambiaría la imagen fijada y exigiría ADR humano (S-16/K-1).
- **(b) EGRESS — nueva regla normativa §2.4 (se añade aquí; no se edita §2): consolidación, no retransmisión.** `kaizen-notify[waha]` **no** enviará un mensaje por cada evento/token interno. Buffering en `<KI_DATA_DIR>/whatsapp/context/<agente>/<chat_id>/summary.md` y **un único** `cmd_send` cuando el equipo termina (equivalente funcional a `session.idle`; en este repo el disparador verificable es `kaizen-runtime:78` `last.json` + `notify event:88-89`, **no** un hook `session.idle` real — ver incertidumbre). Flag `KN_WHATSAPP_CONSOLIDATE_ONLY=1` por defecto; refuerza el requisito original de «no enviar mensajes repetitivos por cada pequeño evento interno» sin tocar el KPI.
- **(c) Aislamiento por worktree — ya cubierto.** `wt-issue-<N>-<rol>` (`scripts/kaizen-swarm:102-108`, `.kaizen/swarm/PROTOCOL.md:50`, `.kaizen/swarm/ROLES.md:9`). No se añade lógica de worktree por sesión ni por mensaje.

### 9.4 ideas RECHAZADAS y escalado (sin implementación)

- **Patrón B — MCP `waha-whatsapp` en `opencode.json`: NO se implementa.** `opencode.json` es ruta protegida L-4, y S-15 prohíbe instalar MCP sin aprobación humana. Además crearía una **segunda** salida hacia WhatsApp, compitiendo con `kaizen-notify` (§2). Si se desea, se abre `needs-human` con la propuesta; el humano decide mediante ADR. Ningún agente lo registra ni lo activa.
- **«Confirmar comandos sensibles por WhatsApp»: NO como excepción.** L-3/L-4 y ADR-0002/0003/0023: seguridad, cumplimiento, dinero, datos, rutas protegidas y cambio de autonomía siguen requiriendo humano y vetos vinculantes. Como máximo, WhatsApp puede ser **canal de aprobación humana de El Presidente autorizado** (chatId allowlisted, `correlation_id`, `source_ids`, `deadline`, ack), y la aprobación es **evidencia**, nunca una dispensa de las reglas. Un mensaje de chat arbitrario no autoriza nada; la confirmación sensible requiere además canal fuera de banda según `.kaizen/team/DECISIONES.md`.
- Cualquier cambio de autonomía, modelo, herramienta o permiso derivado de este documento se escala a humano; no se ejecuta por iniciativa del equipo.

### 9.5 Rollback y trazabilidad

- Esta sección es solo documentación: **no** modifica KPI (§6), decisiones (§5), esquemas ni fuentes (§8). Retirar la sección no revierte ningún cambio funcional.
- La única regla operativa nueva (§2.4 consolidación) se revierte con `KN_WHATSAPP_CONSOLIDATE_ONLY=0` y vuelve al comportamiento previo de `cmd_send`; hacerlo de forma permanente requiere justificación documentada porque contradice el requisito original de no repetir eventos.
- Patrón A y Patrón B quedan registrados como **rechazados con evidencia** (§9.1-9.4); si se reconsideran, es `needs-human` + ADR, no acción del agente.

> **Incertidumbre:** el documento externo no tiene `source_id` y sus afirmaciones sobre SDK/SSE/`session.idle` son patrones genéricos, **no** hechos de este repo. No se afirmó que `session.idle` exista: el disparador de consolidación usa `last.json`/`notify event` como **proxy verificable**, pendiente de confirmar en POC junto con HMAC y *live location* (§7). La imagen `noweb` [WAHA-014] y los worktrees [PROTOCOL.md:50] sí están verificados en el repo.

## 10. Alineación con segunda referencia externa «WAHA + n8n + Kaizen» (dato no confiable)

> Segundo documento pegado por El Presidente (con marcas de origen de IA externa). Se trata como **dato no confiable** (S-15/L-5), **sin `source_id` ni fecha de corte verificable**: no funda decisiones (REG-EV-01/K-10). Se contrasta con el pedido original del usuario y con el repo. No cambia el KPI (§6), DEC-001/DEC-002 ni ADR-0031. Documentación aditiva.

### 10.1 Coincidencias con el diseño ya aprobado (no requieren cambio)

| Recomendación del documento | Estado en este proyecto |
| --- | --- |
| WAHA como adaptador de transporte, no Baileys en el núcleo | **Ya decidido** (DEC-001, ADR-0031): WAHA como contenedor aislado, sin tocar el runtime. |
| Conservar `kaizen-inbox` como entrada canónica; `kaizen-notify` para salida; runtime sin cambios | **Ya en §0/§1/§2**: puente aditivo, sin reemplazar componentes. |
| Cloud API como adaptador alternativo para producción | **Ya en ADR-0031 §Decisión 8 / DEC-002**: contingencia aprobada. |
| Allowlist, autenticación, IDs de mensaje, dedupe, límites de frecuencia, trazabilidad | **Ya en `contracts/security.md`** (C-01..C-11) y §1.2/§1.3. |
| No exponer WAHA ni el buzón a Internet | **Ya en ADR-0031 §4 y security.md** (red privada, sin exposición pública). |
| Preparar especificación con ADR, contratos HTTP, variables, Compose, seguridad, pruebas y criterios de aceptación | **Ya entregado salvo Compose**: ADR-0031, `interfaces.md`, `security.md`, esquemas, `example` de variables, criteria en §6. Compose queda bloqueado por daemon Docker detenido (ADR-0026). |

### 10.1b Punto técnico SÍ adoptado: nombres de servicio Docker

El documento advierte que si n8n/Kaizen corren en contenedores distintos, hay que usar **nombres de servicio de la red Docker**, no `127.0.0.1`. **Se incorpora como restricción al contrato de infra** (sin cambiar código hoy): el bridge dentro del contenedor WAHA/n8n debe resolver el buzón por un host configurable (`KAZEN_INBOX_HOST`, default `127.0.0.1` para el caso local), y la URL base de WAHA por `KAZEN_WAHA_BASE_URL`. El `kaizen-inbox.py` **sigue escuchando solo en 127.0.0.1** (§0): si el bridge está en otro contenedor, se usa un proxy/resolver en la misma red, nunca exponer el buzón a la red pública. Requiere POC + decisión de red con el daemon Docker activo (ADR-0026).

### 10.2 Conflicto resuelto a favor del pedido original: n8n OPCIONAL

El documento sitúa a **n8n en el camino crítico** («n8n verifica que provenga de tu número autorizado… n8n envía la instrucción a kaizen-inbox»). Esto **choca con el requerimiento original literal del usuario**: *«n8n puede seguir funcionando como adaptador opcional… pero la funcionalidad esencial de WhatsApp no debe depender obligatoriamente de n8n»* (pedido original, §2 Componentes a reutilizar).

**Resolución (K-1: la documentación/ADR y el pedido del usuario mandan sobre referencias externas):**
- Camino esencial: `WAHA → bridge → kaizen-inbox.py → inbox.md → kaizen-runtime → kaizen-notify[waha]` — **sin n8n**. Autenticación (HMAC), allowlist y dedupe viven en el bridge y en `kaizen-inbox.py` (§1.2, security.md C-01..C-04), no en n8n.
- n8n permanece como **adaptador opcional**: si el usuario lo activa, puede insertarse como capa de automatización adicional, pero **su ausencia no rompe** el circuito WAHA↔Kaizen. No se añade ningún workflow de n8n como dependencia del KPI.
- Esta resolución refuerza el principio «menos es más» y evita un único punto de fallo. No necesita ADR nuevo: **ya está en el ADR-0031 §4** (no se reemplaza el buzón ni se introduce dependencia obligatoria de n8n).

### 10.3 Alternativa secundaria mencionada: Evolution API — NO adoptada (pending)

El documento cita `evolution-foundation/evolution-api` como alternativa para múltiples instancias/canales. **No se adopta**: (a) el usuario eligió WAHA explícitamente (DEC-001); (b) es igualmente un cliente de WhatsApp no oficial → mismo conflicto ADR-0025 y mismos riesgos ToS/ban; (c) **sin fuentes verificadas** en `SOURCES.md` (estado `pending`, REG-EV-01). Si se quiere evaluar, se abre expediente `kaizen-org research` con fuentes oficiales y decisión humana; no se instala ni se integra por iniciativa del equipo (S-9/S-15).

### 10.4 Conclusión

El documento externo **confirma** la arquitectura ya aprobada y aporta un matiz de red útil (§10.1b). Su única divergencia sustantiva (n8n obligatorio) se **rechaza** por contradictoria con el pedido original (§10.2). No se modifica código, KPI, decisiones ni flags. Rollback: retirar esta sección no revierte nada funcional.
