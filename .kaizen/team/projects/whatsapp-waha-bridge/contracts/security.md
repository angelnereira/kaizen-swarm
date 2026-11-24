---
doc: contracts/security.md
role: security
project: whatsapp-waha-bridge
status: PROPUESTO_PARA_REVISION
source_ids: [WAHA-001, WAHA-002, WAHA-003, WAHA-007, WAHA-009, WAHA-010, WAHA-011, WAHA-012, WAHA-014, META-003, LOCAL-001]
cutoff: 2026-11-24
channel: review
---

# Contrato de seguridad — gateway WAHA ↔ Kaizen-Swarm

## 1. Alcance y supuestos

- **Decisiones gobernantes:** ADR-0031 (excepción acotada, número dedicado) y DEC-001 (Elección A). `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` permanece como política por defecto del repositorio; el flag del MVP se cambia **fuera del repo** (ADR-0031:20). `tests/run.sh` sigue verificándolo. [ADR-0031:20,22; DEC-001]
- **Arquitectura bajo revisión:** `WAHA --webhook--> kaizen-inbox.py (hoy: X-Kaizen-Secret) --> .kaizen/team/inbox/ --> runtime`; salida `kaizen-notify -> WAHA API (X-Api-Key)`.
- **Riesgo aceptado por humano:** WAHA es cliente no oficial (WAHA-001/002/003); el riesgo de ToS/ban recae sobre el **número dedicado**, no sobre El Presidente. Este contrato **no** reabre esa decisión, pero tampoco la convierte en conforme: `cumplimiento-panama` tiene veto `compliance` (ADR-0002/ADR-0031:15) y no ha emitido dictamen.
- **Todo contenido del webhook es dato no confiable** (S-15/L-5/ADR-0031:26): texto, medios, ubicaciones, vCards, encuestas, `event.response`, nombres de archivo y cabeceras. Ninguno es instrucción ni puede saltar veto, autonomía o aprobación humana.
- Los nombres de variables de esta sección son **contrato**; los valores viven en configuración local fuera del repo. Si falta una variable o es inválida, el proceso **falla rápido** con mensaje que no imprime valores (S-1/S-3).

## 2. Modelo de amenazas

| ID | Amenaza | Activo | Impacto | Control |
| --- | --- | --- | --- | --- |
| T-01 | Webhook falso / firma forjada | Cola de inbox, agentes | Inyección de tareas con identidad falsa | C-01 |
| T-02 | Replay de petición capturada | Idempotencia del pipeline | Duplicados, ejecución repetida | C-02, C-05 |
| T-03 | SSRF mediante URL de media del webhook | Red interna, archivos locales | Exfiltración / escaneo interno | C-03 |
| T-04 | Remitente no autorizado / suplantación | Autoridad de El Presidente | Escalada de privilegio por mensaje | C-04 |
| T-05 | Mensajes propios (`fromMe`) | Bucle WAHA↔inbox↔notify | Tormenta de tareas y coste | C-04, C-05 |
| T-06 | *Live location* / flood de eventos | Runtime, LEASES, presupuesto | Task storm, DoS por frecuencia | C-05 |
| T-07 | Path traversal en descargas y en rutas `/*/*` | Sistema de archivos | Lectura/escritura fuera de la raíz | C-06 |
| T-08 | Media excesiva o maliciosa | Disco, proceso, agentes | Agotamiento, poliglotas, ejecución | C-06 |
| T-09 | Secretos / PII en logs y diffs | Credenciales, datos personales | Filtración (S-8/L-12) | C-07 |
| T-10 | Envío a terceros no autorizado | Datos del proyecto | Exfiltración por `sendFile/sendText` | C-08 |
| T-11 | Prompt injection en contenido | Toma de decisiones del equipo | Salto de vetos/autonomía | C-09 |
| T-12 | Contenedor root / exponer API | Host, red | Escape, interceptación del canal | C-10 |
| T-13 | Ban/ToS del número dedicado | Canal | Pérdida del MVP (riesgo humano aceptado) | ADR-0031, META-003 |
| T-14 | Veto de cumplimiento no emitido | Legal/regulatorio | Acción regulatoria | Escalado a humano (ADR-0002) |

## 3. Controles verificables

### C-01 — Autenticación de ingress: HMAC-SHA512 sobre raw body

1. La ruta WAHA exige **dos** factores acumulativos: `X-Kaizen-Secret` (mecanismo actual, se conserva, ADR-0031:22) **y** `X-Webhook-Hmac`. Falta cualquiera → `401`, sin cuerpo derivado.
2. El HMAC se calcula como `HMAC-SHA512(KAZEN_WAHA_HMAC_SECRET, raw_body_bytes)` **antes** de `json.loads` y sobre los bytes exactos recibidos. Está prohibido recomputar sobre el JSON re-serializado: cualquier diferencia de espaciado/clave cambiaría el digest.
3. Comparación **constante en tiempo** con `hmac.compare_digest`. Longitud/formatos del header se validan antes de comparar; cabecera ausente, malformada o de longitud incorrecta → `401`.
4. El formato exacto del header (`sha512=<hex>` vs `sha512:<hex>`) y el vector de cálculo quedan **pendientes de POC**: la documentación enlaza una herramienta SHA-256 (SOURCES.md:51, DEC-001 §Incertidumbre). El parser debe ser **paramétrico y explícito**, no adivinar ni aceptar variantes por tolerancia.
5. **Separación de claves:** `KAZEN_WAHA_HMAC_SECRET` (ingress) ≠ `KAZEN_WAHA_API_KEY` (egress, `X-Api-Key` WAHA-010) ≠ `KAZEN_INBOX_SECRET` (`X-Kaizen-Secret`). Arranque falla si faltan o si dos igualan. Rotación de una no invalida las otras.
6. **Brecha actual a corregir en implementación:** `scripts/kaizen-inbox.py:57` compara `X-Kaizen-Secret` con `!=` (no constante) y `:64-65` lee y parsea el cuerpo antes de cualquier verificación HMAC. El diseño debe capturar `raw_body` y verificar primero.
7. Verificación: (a) body alterado → `401`; (b) body re-serializado → `401`; (c) header ausente/malformado → `401`; (d) inspección de código confirma `compare_digest`; (e) test de arranque con claves iguales → error sin imprimir valores.

### C-02 — Anti-replay

1. `X-Webhook-Request-Id` (WAHA-007) es el **nonce**. Caché TTL (p. ej. 300 s) con comprobación e inserción **atómicas**; el segundo uso del mismo nonce se descarta.
2. El duplicado responde `200 {ok:true, duplicate:true}` y **no** crea tarea ni archivo: un `4xx/5xx` provocaría reintentos de WAHA y amplificaría la carga. La deduplicación es idempotente a nivel de archivo (nombre derivado del ID + `open(..., 'x')` o rename atómico).
3. Si la POC confirma un header de timestamp de WAHA, exigir desfase ≤ 60 s; **si no existe**, la ventana de aceptación se ancla a la hora de llegada del servidor + caché de nonce. Existencia del header de timestamp: **unknown** (POC, QA).
4. La caché tiene límite de memoria y expiración (LRU/TTL); sin crecimiento ilimitado.

### C-03 — SSRF: nunca confiar en URL de media del webhook

1. Regla por defecto: **no descargar** URL arbitraria presente en el payload. Preferir resolver el medio por `messageId` mediante la API de WAHA (WAHA-009), no por una URL suministrada por el remitente.
2. Si se descarga: solo se acepta URL cuyo `host` (y `port`, y `scheme`) coincida exactamente con `KAZEN_WAHA_BASE_URL` configurado. Rechazar `userinfo`, IPs literales no configuradas y cualquier redirección (desactivar `follow_redirects`; si se permite, revalidar **cada salto** contra el mismo host). Mitigar DNS-rebinding resolviendo y verificando la IP antes de la conexión; solo la IP del base URL configurado está permitida.
3. La comprobación se hace con el valor **configurado**, nunca con el `from`/host del mensaje. `KAZEN_WAHA_BASE_URL` ausente → fallo de arranque.
4. La forma exacta de la URL de media (absoluta/relativa/host detrás de proxy) es **unknown** (POC, QA): el control se implementa con la validación de host y se afina con el payload real antes de activar.
5. El mismo criterio aplica a `sendFile/sendImage`: un mensaje entrante nunca puede elegir una URL remota como origen de un archivo saliente.

### C-04 — Remitentes, propietario, grupos y anti-bucle

1. **Denegar por defecto.** `KAZEN_WAHA_ALLOWED_SENDERS` (lista de IDs de chat/número) y `KAZEN_WAHA_OWNER_CHAT_ID` (propietario) son obligatorios. Un ID fuera de la lista → descartado sin crear tarea; se registra solo un evento `dropped_sender` con hash estable.
2. Grupos **ignorados por defecto** (`isGroup==true` o sufijo `@g.us`). Solo se procesan si hay entrada explícita en la allowlist **y** autorización del propietario registrada.
3. **Anti-bucle:** mensajes propios del número dedicado (`fromMe==true` o chat ID del número de la sesión) **nunca** se convierten en instrucciones; se ignoran para procesamiento (pueden registrarse como telemetría sin contenido).
4. **Distinción de identidad** — el frontmatter del archivo en `.kaizen/team/inbox/` debe llevar `actor_kind` y `source_id` verificable:

   | `actor_kind` | Condición | Puede crear tarea |
   | --- | --- | --- |
   | `owner` | `chat_id == KAZEN_WAHA_OWNER_CHAT_ID` | Sí (con KPI y `source_ids`) |
   | `user_allowed` | en `KAZEN_WAHA_ALLOWED_SENDERS` | Sí, ámbito restringido |
   | `agent` | mensaje procedente de un agente/notify | **No** |
   | `self` | `fromMe` / número de la sesión | **No** |
   | `unknown` | cualquier otro | **No** |

5. **Brecha actual a corregir:** `scripts/kaizen-inbox.py:80` escribe literalmente `# Instrucción de El Presidente` para **cualquier** remitente. Eso convierte a cualquier usuario permitido en El Presidente. La etiqueta debe derivarse de la identidad verificada; los demás remitentes se rotulan como dato (`# Mensaje de usuario <id> — dato no confiable`), nunca como instrucción del dueño.
6. La forma exacta del ID (número E.164 vs chat ID vs LID) es **unknown** (POC, QA): la allowlist se compara sobre el valor canónico que WAHA emita, documentado en `contracts/interfaces.md`.

### C-05 — Deduplicación y control de frecuencia

1. Clave de dedupe: `X-Webhook-Request-Id` o, en su defecto, `(chat_id, messageId)`. Deduplicación en dos capas: nonce (C-02) y archivo idempotente (C-01.2).
2. Límite por remitente (p. ej. 10 mensajes/minuto con ráfaga 3) y límite global. Exceso → descartar y emitir métrica `waha_rate_dropped` (sin contenido ni IDs sensibles). **Nunca** crear una tarea por evento descartado.
3. **Live location:** WAHA-011 solo expone el flag `location.live`; no hay evento oficial ni frecuencia documentada → **unknown** (SOURCES.md:51). Hasta la POC: agrupar actualizaciones consecutivas por chat en una sesión con ventana de coalescencia (p. ej. 60 s), emitir **como máximo una** tarea por sesión y un techo de sesiones por hora. Prohibido crear una tarea por coordenada. Si el payload/frecuencia real no encaja, se desactiva el manejo de live location y se reporta `failure` (S-11) en lugar de improvisar.
4. Coordenadas y nombres de lugar son datos personales (L-12): no van a logs; se almacenan solo si el caso de uso lo exige, con metadata separada y política de retención documentada.

### C-06 — Tamaño, MIME y path traversal

1. `KI_MAX_MEDIA_MB` obligatorio. Aplicar a `Content-Length` **y** contar bytes al leer en streaming; exceder el límite aborta la descarga y cierra la conexión. Prohibida la lectura sin límite (`rfile.read()` de tamaño arbitrario).
2. Validación en tres capas: **extensión** (allowlist), **MIME declarado** y **contenido** (magic bytes). Rechazar dobles extensiones, ejecutables, SVG con scripts y poliglotas: aislar en cuarentena, nunca ejecutar ni pasar al modelo como instrucción. Si se añade una librería de detección, revisar nombre/versión/lockfile (S-9) y someter a revisión humana.
3. Nombres de archivo: sanitizar con allowlist `[A-Za-z0-9._-]`, sin caracteres de control, sin `..`, sin componente inicial `.`; preferir nombre de almacenamiento UUID y conservar el original solo como **metadato**.
4. **Path traversal** tanto en descargas como en la navegación de rutas `/*/*`: resolver con `realpath`, exigir `commonpath([ROOT_RESUELTA, destino]) == ROOT_RESUELTA`. Rechazar rutas absolutas, `..`, `%2e%2e`, symlinks que salgan de la raíz y rutas construidas con datos del mensaje. La raíz sale de configuración, nunca de la petición (ADR-0031:25).
5. Verificación: tests con `../`, `%2e%2e%2f`, symlink hacia `/etc`, ruta absoluta, Unicode/overlong, y archivo > `KI_MAX_MEDIA_MB`.

### C-07 — Permisos locales, `.gitignore` y logs

1. Directorios de sesión/medios/inbox: `0700`; archivos: `0600` (o `umask 077`). Sin lectura para «otros». Sin secretos en capas de imagen ni en argumentos de build (S-16).
2. Deben quedar **fuera de Git** (ADR-0031:44): `waha-data/`, `whatsapp/session/`, `whatsapp/media/`, `.kaizen/team/inbox/` y cualquier volumen de sesión. Verificar con `git check-ignore -v <rutas>`. **Nota L-4:** `.gitignore` es ruta protegida; este agente **no la edita** — la inclusión de entradas queda como condición para El Presidente/responsable.
3. Logs sin secretos ni PII (S-8/L-12): redactar `X-Webhook-Hmac`, `X-Api-Key`, `X-Kaizen-Secret`, números de teléfono, chat IDs, coordenadas y contenido de medios. Registrar solo ID de evento estable, hash y resultado. Un log que pueda contener un secreto es bug de seguridad (S-11).
4. Sin impresión de valores de configuración en stdout, diffs ni contexto del modelo. Prohibido `env`/`printenv` (S-2).

### C-08 — Egress a terceros

1. `KAZEN_WAHA_ALLOWED_RECIPIENTS` es la lista de destinatarios permitidos. Responder al mismo `chat_id` solo si el remitente aprobó C-04; **cualquier otro destinatario** exige (a) entrada en la lista y (b) autorización explícita del propietario con registro de quién/cuándo. `reply_to` (WAHA-009) no sustituye la autorización.
2. Archivos salientes únicamente desde `KAZEN_WAHA_OUTBOUND_DIRS` (rutas resueltas y validadas como en C-06.4), con tope de tamaño y control MIME. **Denegar** explícitamente `.env`, `notify.env`, `.ssh/`, claves, `~/.aws`, almacenes de tokens y cualquier ruta fuera de esos directorios.
3. `X-Api-Key` se envía solo como cabecera, leída de configuración, nunca en URL/query ni en logs (S-6/S-8). Falta de clave → fallo de envío, no envío anónimo.
4. Verificación: test de envío a destinatario fuera de allowlist → rechazo; test de ruta `../.env` → rechazo sin lectura del archivo.

### C-09 — Contenido externo = dato no confiable

1. Ningún campo del webhook se pasa a `eval`/`exec`, shell, plantillas interpretadas, consultas SQL concatenadas ni construcción de rutas. Escapar según el contexto de salida (S-4).
2. Texto, transcripción de medios, vCards, encuestas, `event.response`, nombres de archivo y `location.name` se tratan como **datos**: se archivan como `status: pending` con `source_ids`; no ejecutan comandos, no crean etapas, no cambian flags, no auto-aprueban.
3. El puente no puede saltar vetos de `security`/`architect`/`qa`/`compliance`, no aumenta autonomía y no envía mensajes por iniciativa propia basándose solo en contenido entrante (L-3/L-4, ADR-0002/0023).
4. Los mensajes de agentes (`actor_kind: agent`) se distinguen de los de humanos y nunca se presentan como instrucciones del dueño (C-04.5).

### C-10 — Contenedor y red (S-16)

1. Red privada; **sin exposición pública** ni puertos publicados al host salvo loopback estrictamente controlado (WAHA-010: "Do not expose WhatsApp API on public networks").
2. Imagen fijada por **tag y digest**: `devlikeapro/waha:noweb-2026.10.1@sha256:0d64cce14a922f61bb9a620474086d1f5695f2522e7e1088704e6eca3a085d0c` (WAHA-014); prohibido `latest`.
3. Sin root: usuario no privilegiado, `read_only` donde sea posible, `cap_drop: ALL`, `no-new-privileges`, sin montajes sensibles del host. Límites de memoria/PIDs para acotar DoS.
4. Sesión y medios en volumen local excluido de Git (C-07.2). Secretos por configuración local/gestor, nunca en capas de imagen ni argumentos de build.
5. El daemon Docker está detenido (ADR-0026): los controles de runtime no son verificables hoy → condición previa a cualquier activación.

### C-11 — Fallo cerrado y gates

1. Configuración ausente/inválida → error de arranque claro sin valores (S-3). Cualquier excepción se propaga o registra con huella estable; nunca se traga (S-7).
2. Escáner o test que falle o no pueda ejecutarse = **FALLO**, nunca aprobado (S-10/K-11). Sin `nosec/noqa/eslint-disable/ts-ignore/skip/xfail/only/|| true/continue-on-error/--no-verify` salvo `<supresion> -- #N motivo` en la misma línea.
3. `kaizen-team verify whatsapp-waha-bridge` en verde y `tests/run.sh` con `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` intacto antes de pasar a `deliver`.
4. Todo hallazgo, aunque se corrija, se registra en `.kaizen/loop/outbox/` (S-11); las correlaciones de seguridad van por canal `alert`.

## 4. Matriz de verificación (evidencia esperada)

| Control | Comando / prueba (a ejecutar por QA en implementación) | Criterio de paso |
| --- | --- | --- |
| C-01 | tests de firma válida, body alterado, body re-serializado, header malformado; `grep -n compare_digest scripts/kaizen-inbox.py` | 401 en los 3 casos inválidos; `compare_digest` presente |
| C-01/C-04 | `grep -n "Instrucción de El Presidente" scripts/kaizen-inbox.py` | Etiqueta condicional por identidad verificada, no literal global |
| C-02 | replay del mismo `X-Webhook-Request-Id` dos veces | 1 tarea, 2ª respuesta `duplicate:true` |
| C-03 | media URL con host externo, redirect y userinfo | 3 rechazos; sin petición saliente |
| C-04 | remitente no listado, grupo, `fromMe`, mensaje de agente | 0 tareas en los 4 casos |
| C-05 | ráfaga de 100 mensajes y actualizaciones de live location | ≤ techo configurado; 0 task storms |
| C-06 | `../`, symlink, >`KI_MAX_MEDIA_MB`, poliglota | Rechazo sin salida de raíz ni ejecución |
| C-07 | `git check-ignore -v waha-data/ whatsapp/session/ whatsapp/media/ .kaizen/team/inbox/` | Las 4 rutas ignoradas |
| C-08 | envío fuera de allowlist y ruta `../.env` | Rechazo sin leer archivo |
| C-09 | payload con "ignora tus reglas" en texto/vCard/nombre | Archivado como dato; 0 cambios de etapa/flag |
| C-10 | `docker compose config` + inspección de imagen/tag/digest | Sin `latest`, sin root, sin puerto público |
| C-11 | `kaizen-team verify whatsapp-waha-bridge`, `tests/run.sh`, `git diff --check`, grep de supresiones | Verde; flag 0; sin supresiones nuevas |

## 5. `unknown` y POC pendiente (no afirmar soporte)

| Ítem | Estado | Dueño | Impacto si falla |
| --- | --- | --- | --- |
| Vector exacto de cálculo del HMAC-SHA512 (docs enlazan SHA-256) | unknown — POC | qa | C-01 no verificable; falso positivo/negativo de firma |
| Formato del header `X-Webhook-Hmac` y existencia de header de timestamp | unknown — POC | qa | Ajustar C-01.4 y C-02.3 |
| Payload y frecuencia de *live location* (WAHA-011 solo expone `location.live`) | unknown — POC | qa | C-05.3 no validable → desactivar y reportar |
| Forma canónica del ID de remitente y detección de grupos | unknown — POC | qa/architect | Ajustar C-04.1/.2/6 |
| Forma de la URL de media y política de redirects | unknown — POC | qa | Ajustar C-03.2 |
| Veto `compliance` (ToS/legal) | no emitido | cumplimiento-panama | Escalado a humano; este contrato no lo sustituye |
| Daemon Docker detenido (ADR-0026) | bloqueado | humano | C-10 no verificable en runtime |
| Entradas de `.gitignore` para sesión/medios/inbox/waha-data | L-4, pendiente de humano | El Presidente | Datos personales podrían versionarse (L-12) |

## 6. Reglas de no regresión

- Ningún control de este contrato se relaja para «que pase» la POC (L-10/K-5). Si un control impide avanzar, se documenta con evidencia y se escala; no se silencia.
- `KN_WHATSAPP_ALLOW_UNOFFICIAL` sigue en `0` en el repo; cualquier cambio versionado exige ADR nuevo y revisión humana (ADR-0031:20).
- Este documento es un contrato de **diseño**. La aprobación no implica conformidad legal ni autorización para activar el canal; rigen ADR-0002/0018/0026 y el dictamen en `reviews/security.md`.
