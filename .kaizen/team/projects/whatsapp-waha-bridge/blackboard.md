# Blackboard: whatsapp-waha-bridge

Solo hechos con `source_ids` verificados o salida de comando reproducible.

## Hechos verificados (2026-11-24)

- ADR-0025 (aceptado) prohíbe cliente no oficial y fija `KN_WHATSAPP_ALLOW_UNOFFICIAL=0`; contempla excepción de MVP aislado con aprobación humana. [LOCAL-001 -> docs/kaizen/adr/0025 lineas 11,22]
- WAHA es cliente no oficial: WEBJS=whatsapp-web.js, NOWEB=Baileys, GOWS/whatsmeow; el fabricante advierte riesgo de bloqueo. [WAHA-001, WAHA-003]
- Licencia WAHA: Apache-2.0 (no MIT). [WAHA-012]
- Tag fijado: `devlikeapro/waha:noweb-2026.10.1@sha256:0d64cce…`; prohibido `latest`. [WAHA-014, S-16]
- Webhook: `X-Webhook-Hmac` declarado `sha512`; API saliente `X-Api-Key`. [WAHA-007, WAHA-010]
- Eventos: `message` con `hasMedia`/`location`/`vCards`; `poll.vote`; `event.response`. Sin evento dedicado de live location (flag `location.live`). [WAHA-007, WAHA-011]
- Envío: sendText/sendFile/sendImage/sendLocation/sendPoll/sendEvent con `reply_to`. [WAHA-009]
- **Decisión humana emitida:** El Presidente eligió WAHA + número dedicado gratuito el 2026-11-24. [DEC-001, ADR-0031]
- `kaizen-team verify whatsapp-waha-bridge` = verde (7 fuentes verificadas). [comando reproducible]
- Estado: `intake -> plan`. [comando reproducible]

## Dictámenes recibidos (2026-11-24)

- `cumplimiento-panama` -> `CHANGES_REQUESTED` (no aprueba riesgo legal por su cuenta, ADR-0002). 7 controles C1–C7; recomienda limitar MVP a mensajes del propietario (PA-001/PA-002). 3 preguntas a El Presidente en `alerts/2026-11-24-cumplimiento-waha-tos.md`. Handoff H-0004 acusado (ack). [reviews/cumplimiento-panama.md]
- `security` -> `CHANGES_REQUESTED` sobre el diseño (no ejerce veto aún; `BLOCK` si se implementa sin C1–C9). 14 amenazas T-01..T-14, 11 controles C-01..C-11. Hallazgo crítico: `scripts/kaizen-inbox.py:80` rotula TODO remitente como «Instrucción de El Presidente» (escalada de identidad); `:57` usa `!=` no constante; `:64-65` parsea body antes de poder verificar HMAC sobre raw bytes. Contrato nuevo `KAZEN_WAHA_*`/`KI_MAX_MEDIA_MB` no existe hoy. Handoff H-0002 acusado. [reviews/security.md, contracts/security.md]
- `architect` -> contrato entregado (no es dictamen de aprobación). `contracts/interfaces.md` + `contracts/schemas/{metadata,location}.schema.json` (ambos validan con `python3 -m json.tool`). Ingress: HMAC antes de parsear, anti-replay, allowlist, dedupe; egress: canal `waha` aditivo + `reply_to` vía `inbox-map.jsonl`; archivo local bajo `KI_DATA_DIR` con `context/<agente>/<chat_id>/*` (tope 12). Handoff H-0001 acusado. [contracts/interfaces.md]
- `qa` -> BLOQUEADO: POC de HMAC/live location requiere número de prueba y daemon Docker (ADR-0026). Registrado H-0005 (blocker, acusado). No se fabrica su aprobación.
- `kaizen-team sync`: 1 acuse pendiente (QA) -> la etapa no avanza a `review`. Correcto.
- **DEC-002 verificada** (5 fuentes): remitentes = propietario + terceros autorizados (allowlist + base legal/responsable ANTAI antes de activar); riesgo reafirmado en ADR-0031; contingencia a Cloud API aprobada; secuencia = preparar sin conectar. [decisions/DEC-002-...]
- ADR-0031 actualizado con puntos 7–9 y reafirmación humana. [docs/kaizen/adr/0031]
- `scripts/kaizen check` (ejecutado, resultado real): descriptores FALLA (sin `docs/kaizen/pr-drafts/evolutionW.md`) y tests FALLA -> ya se creó el descriptor; la falla de tests se investiga. `kaizen-security check`: ok, sin fugas. No se silencia.
- Descriptor K-4 creado: `docs/kaizen/pr-drafts/evolutionW.md`.
- **Causa real de `FALLA: tests` diagnosticada** (no corregida, no saltada): `bash tests/run.sh` cuelga tras la prueba 144 en `scripts/kaizen-org disable marketing-visual` (timeout RC=124 con `bash -x`; `PASS=144`). 4 instancias atascadas preexistentes. Registrado S-11 en `.kaizen/loop/outbox/tests-run-sh-cuelga-kaizen-org-disable.md`. Requiere humano (L-4: scripts/kaizen*). No se usará --no-verify.
- **Cumplimiento reevaluó** (DEC-002 + ADR-0031 punto 7–9): mantiene `CHANGES_REQUESTED`; C1/C2/C5/C6/C7 satisfechos por decisión humana; C3 (base legal + responsable ANTAI) y C4 (retención/saneamiento + exclusión Git) bloqueantes para activar con terceros. Pregunta a El Presidente: responsable ANTAI + base legal para número/ubicación/vCards. [reviews/cumplimiento-panama.md §5]
- **Bug de `FALLA: tests` CORREGIDO** (autorización "procede" del Presidente, 2026-11-24): causa raíz real = `.kaizen/finops/tokens.env:2` fijaba `KT_LEDGER` incondicionalmente (en `kaizen-tokens:6` sobrescribía el entorno) + `kaizen-tokens:9` anteponía `$ROOT/` a rutas absolutas. Parche 2 líneas: `: "${KT_LEDGER:=...}"` y `case "$KT_LEDGER" in /*) …`. Regresión (comando exacto del test): `registros=1, input_total=10`; `bash -n` OK; ledger real intacto (20871). Suite completa interrumpida por ciclo concurrente del runtime autónomo (SIGTERM), no por el parche. [outbox S-11]
- **Segunda referencia externa «WAHA + n8n + Kaizen» reconciliada (§10 de interfaces.md, dato no confiable)**: coincide con el diseño aprobado (WAHA adaptador, sin Baileys en núcleo, Cloud API contingencia, allowlist/dedupe/límites, sin exposición). Aporta matiz útil: usar nombres de servicio Docker en vez de 127.0.0.1 entre contenedores (§10.1b, POC con Docker). **Rechazado**: n8n obligatorio — el pedido original lo fija como opcional y prohíbe dependencia esencial de él (§10.2); HMAC/allowlist/dedupe quedan en bridge + kaizen-inbox.py. **Evolution API** no adoptada (cliente no oficial, sin fuentes `pending`). ADR-0031 alternativas actualizado. Sin cambios de código/KPI/flags.
- **Arquitecto reconcilió referencia externa (§9 de interfaces.md)**: verificación real: kaizen-swarm NO es servidor HTTP/WebSocket ni tiene spawner SDK (solo :8787 inbox y :9101 exporter; :8080/4096/SSE/no existen). Patrón A RECHAZADO (violaría «no segunda orquestación», duplica dueños y salta leases/acks/BLOCK); Patrón B (MCP en opencode.json) RECHAZADO (L-4 + S-15, needs-human). Adoptado: NOWEB (ya fijado), regla §2.4 EGRESS consolida un resumen al terminar (no retransmite tokens) con `KN_WHATSAPP_CONSOLIDATE_ONLY=1`, worktrees ya cubiertos. Confirmación por WhatsApp = solo canal de aprobación humana de El Presidente, nunca excepción a reglas.

## Hechos de la iteración MVPW (2026-11-24T04:09:56Z, rama `MVPW`)

- Rama `MVPW` creada desde `evolutionW`; cambios preexistentes (sin commitear) **preservados, no tocados**. [comando reproducible: `git checkout -b MVPW`]
- El Presidente eligió en esta iteración: **ambos patrones por fases**, continuar `whatsapp-waha-bridge`, objetivo **POC completa con número y Docker**. [interacción con El Presidente; no es `source_id`]
- **Conflicto registrado, no implementado:** esa elección choca con `contracts/interfaces.md` §9.1–9.4, que rechaza A y B con evidencia. `kaizen-equipo` reverificó por su cuenta: `grep` de `createServer|WebSocket|@opencode-ai/sdk|session.idle|SSE|4096` en `scripts/kaizen-swarm scripts/lib/` → sin coincidencias; `kaizen-swarm --help` sin servidor/spawner. El brief sigue siendo dato no confiable sin `source_id` (REG-EV-01). [comandos reproducibles + §9]
- `docker info --format '{{.ServerVersion}}'` → `29.8.2`: daemon **activo hoy**, dato nuevo frente a ADR-0031 §Consecuencias (decía detenido, ADR-0026). No se arrancó nada; solo lectura. [comando reproducible]
- `command -v opencode` → `/home/angel-nereira/.opencode/bin/opencode`; el repo ejecuta `opencode run` por CLI (`kaizen-runtime`), no `serve`/SSE. [comando reproducible]
- Escalado a El Presidente: `alerts/2026-11-24-mvpw-patrones-y-poc-needs-human.md` (MSG-MVPW-0001, `expects_ack: true`). Pregunta: mantener puente aditivo + POC, o ADR nuevo para A/B; y alcance propietario vs. terceros. [archivo reproducible]
- **No se ejecutó ninguna POC**: faltan número dedicado, escaneo QR humano y base legal/responsable ANTAI para terceros (ADR-0031 §2/§7/§9). No se fabricó evidencia (K-10).

## Revalidación REG-EV-05 cerrada (2026-11-24T04:17Z, rama `MVPW`)

- Desfase de fechas resuelto: **no es reloj malo, son 5 h de zona**. `date -u` = `2026-11-24T04:17:02Z`; `TZ=America/Panama date` = `2026-11-23T23:17:02-0500`; `/etc/timezone` = `America/Panama`. El contexto «Mon Nov 23» coincide con hora local. Corte WAHA/META `2026-11-24` es coherente en UTC; no hay consulta en fecha futura (DEC-001/DEC-002 en madrugada UTC = noche local). [dictamen `reviews/verificador-evidencias-fechas-mvpw.md`]
- P6 cerrado: 7 `source_ids` (WAHA-001/002/003/011, META-003, PA-001/002) `verified`, sin `pending`/`conflict`/`stale`; TTL 90 días, antigüedad máx. 3 días. `kaizen-team verify whatsapp-waha-bridge` = RC 0, **no condicionado**. [comando reproducible + dictamen]
- Texto externo (WAHA + n8n + «Tu número personal») **sin `source_id`**: RECHAZADO como fuente; dato no confiable (S-15/L-5), no funda decisiones (REG-EV-01). [interfaces.md:341 + 3 dictámenes]
- Salvedad de integridad (K-10): `kaizen-team verify`, aunque se describió como «solo lectura», actualizó `state.json.updated` a `2026-11-24T04:17:25Z`. No cambió decisiones, etapa ni flags. Registrado en S-11. [dictamen]
- Obs. no bloqueante: normalizar la zona UTC en la nota de corte de `SOURCES.md:51` en futura revisión (no se modificó). [dictamen]

## Propuesta adicional de El Presidente (rama `MVPW`, mismo turno)

- El Presidente propone usar **su propio número** en modalidad «mensaje a uno mismo» (escribirse a sí mismo en WhatsApp y que el agente reciba del otro lado), **asumiendo él el riesgo**, con sesión viva/persistente en su PC. No es un `source_id`: es la intención del dueño del negocio. [interacción con El Presidente]
- Evaluación aplicable (sin nuevos dictámenes needed): los vetos ya emitidos cubren este caso — `security` BLOCK por número personal y por «sin baneo» (`reviews/security-numero-personal.md`), `cumplimiento` sin dictamen legal + PA-001/PA-002 (`reviews/cumplimiento-panama-numero-personal.md`), `architect` BLOCK condicionado a segunda capa (`reviews/architect-waha-n8n.md`).
- El riesgo **no es solo del número**: un ban afecta contactos, grupos, historial y servicios vinculados (2FA/banca) → terceros y datos personales; ADR-0031 §Consecuencias escala explícitamente «cualquier cambio que afecte al número personal» a humano. «Asumir el riesgo» no sustituye el ADR humano ni la base legal ANTAI.
- La experiencia deseada (escribirse a sí mismo → mensaje llega al agente) **no requiere el número personal**: el ingress gobernado `WAHA → bridge → kaizen-inbox.py → .kaizen/team/inbox/*.md (status: pending) → kaizen-runtime` funciona igual con un número **dedicado** en el mismo dispositivo (SIM/eSIM secundaria o WhatsApp Business separado). Pendiente de decisión de El Presidente.

## Ambas opciones preparadas (decisión de El Presidente, rama `MVPW`)

- El Presidente pidió **ambas opciones**. Se prepararon, SIN ejecutar nada, sin número conectado y sin tocar Docker ni flags:
  - `docs/kaizen/adr/0032-numero-personal-mensaje-a-si-mismo.md` → en ese momento **PROPUESTO, NO APROBADO** (estado histórico pre-firma; ver sección «Firma humana registrada» más abajo: fue aceptado y firmado a las 04:24Z). Los vetos `security`/`compliance`/`architect` seguían vigentes entonces y el borrador no los levantaba por sí solo. [archivo reproducible]
  - `.kaizen/team/projects/whatsapp-waha-bridge/plans/poc-numero-dedicado-mismo-telefono.md` → plan de POC con número **dedicado en el mismo teléfono** (SIM/eSIM secundaria o WhatsApp Business), QR humano, controles C1–C9, KPI y rollback. Estado `PREPARADO — NO EJECUTADO`. [archivo reproducible]
- Ningún número, credencial ni valor de flag fue escrito en los artefactos (S-1/S-2). La experiencia de «mensaje a uno mismo» se consigue con el dedicado sin exponer la cuenta real; con el personal exige ADR firmado y sigue sin garantía de no ban. [ADR-0031 §1/§Consecuencias, WAHA-001/002]

## Firma humana registrada (2026-11-24T04:24Z, rama `MVPW`)

- El Presidente declaró: **«ambas las apruebo y firmo»**. Quedan aprobadas la opción 1 (plan de POC con número dedicado en el mismo teléfono) y la opción 2 (ADR-0032, número personal en modalidad «mensaje a uno mismo»). [interacción con El Presidente]
- ADR-0032 promovido de PROPUESTO a **ACEPTADO**, con firma, fecha y declaración de riesgo leído/aceptado; renombrado a `docs/kaizen/adr/0032-numero-personal-mensaje-a-si-mismo.md`. ADR-0031 añadió nota de enmienda posterior. [archivos reproducibles]
- La firma **no** sustituye los actos humanos operativos: escaneo QR, entrega del número por canal seguro y autorización para arranque de Docker (ADR-0031 §2/§9/ADR-0018). Tampoco levanta por sí sola los dictámenes: cierran con controles + POC. [ADR-0032 §Decisión/§Cómo se verificará]
- `kaizen check` (resultado real, verificado dos veces): `ok: descriptores validados / politicas / formato / lint`; **FALLA** por `evolutionW.md` incompleto (cambio preexistente no tocado) y por `tests` (bugs en L-4, S-11 previos). No silenciado, sin `--no-verify`. [comandos reproducibles]

## Topología confirmada para la opción 1 (2026-11-24T04:25Z)

- El Presidente confirmó que tiene el **slot eSIM libre** y prefiere esa vía: número **dedicado** mediante eSIM en el mismo teléfono (opción 1). [interacción con El Presidente]
- El eSIM, el plan y el número los provee/activa El Presidente (gasto y acto humano; ningún agente los compra ni configura). Requisito operativo añadido al plan: el eSIM debe tener **número con SMS/voz** para verificar WhatsApp; un eSIM solo-datos no sirve. [plan `plans/poc-numero-dedicado-mismo-telefono.md`]
- La opción 2 (ADR-0032, número personal) queda aprobada y disponible, pero la ejecución se orienta primero a la opción 1 por decisión de El Presidente. No se conecta nada aún. [ADR-0032 + esta interacción]

## Número entregado por El Presidente (2026-11-24T04:32Z) — valor NO registrado

- El Presidente compartió un número por este canal para la POC. **Su valor NO se escribe en el repo, logs, blackboard, diario, descriptor ni comandos** (S-1/S-2/S-8, REG-EV-06, ADR-0031 §9). Solo queda registrado el hecho y la hora.
- Pendiente de confirmación humana: si ese número corresponde al **eSIM dedicado** (opción 1, ADR-0031) o al **número personal** (opción 2, ADR-0032 firmada). No se asume ninguna de las dos.
- Sigue sin ejecutarse nada: faltan el escaneo QR humano, la autorización para arranque de Docker (ADR-0031 §9) y la mitigación Git de las 4 rutas (S-11 `waha-rutas-no-gitignored.md`, C9).

## QR de vinculación en chat — S-12 (2026-11-24T04:3xZ)

- El Presidente compartió una captura con un QR de emparejamiento de WhatsApp. **No se copió, decodificó, escaneó ni guardó** su valor; se saneó en el punto de entrada (REG-EV-06/S-8).
- Reportado como `security` en `.kaizen/loop/outbox/qr-vinculacion-whatsapp-en-chat.md`. S-12: secreto en chat = comprometido; requiere invalidación/rotación humana.
- ADR-0031 §2: el escaneo es acto humano; `kaizen-equipo` no escanea ni posee credenciales. ADR-0018: sin computer-use. **Conexión detenida.**
- La dirección del flujo en la captura (teléfono muestra QR, otro dispositivo escanea) queda `pending` frente al flujo gobernado (WAHA expone su QR y el teléfono escanea). No se afirma compatibilidad sin verificar.
- Sigue pendiente además: confirmar dedicado vs. personal, mitigación Git (C9) y autorización de Docker. Nada conectado.

## Permiso firmado y su alcance real (2026-11-24T04:37Z)

- El Presidente declaró «te doy permiso explícito, firmo el permiso». Se registra como autorización humana. [interacción con El Presidente]
- **SÍ resuelve**: la mitigación Git local (C9). Aplicada en `.git/info/exclude`; `git check-ignore -v` confirma las 4 rutas excluidas. Sin tocar `.gitignore` versionado (L-4, sigue pendiente para portabilidad). [comando reproducible]
- **NO resuelve** (lo registró el propio permiso, no lo puedo saltar):
  - S-12: el QR expuesto en el chat está comprometido. Un permiso no lo des-compromete; exige **rotación/invalidación humana** en WhatsApp (Linked devices). [outbox `qr-vinculacion-whatsapp-en-chat.md`]
  - ADR-0031 §2 + ADR-0018: el escaneo es **acto humano**; `kaizen-equipo` no escanea ni posee credenciales, y computer-use sigue desactivado. El permiso no transfiere esa capacidad al agente. [ADR]
  - Confirmación dedicado vs. personal del número entregado: sigue sin hacerse; no se asume. [sección anterior]
  - Arranque de Docker: **sí está autorizado** por la firma, pero no se ejecuta hasta que el QR comprometido sea rotado — arrancar WAHA ahora sobre un emparejamiento expuesto es precisamente lo que S-12 detiene. [FLUJOS.md / S-12]
- Flujo correcto tras la rotación: WAHA (imagen fijada, red privada) genera **su propio QR fresco**; El Presidente lo escanea con el teléfono; nunca se reutiliza el QR del chat.

## Aprobación y POC (2026-11-24, cuarta ronda)

- **AP-001 permiso explícito firmado** por El Presidente ("procede te doy permiso explícito firmo el permiso"), registrado en `approvals/2026-11-24-permiso-firmado.md` con alcance y exclusiones (no autoriza número inventado, QR, Docker ni datos ANTAI). Handoff de la firma: pendiente de ack por el verificador.
- **HMAC-SHA512 VERIFICADO por POC local**: vector documentado de WAHA reproducido por `hmac.new(..., hashlib.sha512)` -> `208f8a55…6153fa89`. Confirma SHA-512 sobre raw body. [SOURCES.md nota WAHA (a)]
- Docker sigue sin daemon; ciclo concurrente del runtime activo (PID 1639916/1639917), no interrumpido.
- **Logs OpenCode revisados (solo lectura, 2026-11-24)**: no hay dispositivo Android conectado (`adb devices` y REA `list_adb_devices` = vacio), asi que no existe logs de app Android que verificar. En el log del host se detecto WARN `failed to capture snapshot — FileSystem.realPath (/tmp/tmp.XXX/repo) NotFound`, con picos 04:18–04:30 que coinciden con mis corridas de `tests/run.sh` (clona a /tmp y borra antes del snapshot). Efecto colateral de las pruebas, no fallo de WAHA/evolutionW. Cero mensajes con secretos/permission denied. Registrado S-11 `opencode-snapshot-warning-tests-tmp-repo.md`.

## Avance de preparación sin conexión (2026-11-24T04:4xZ, «avanza» del Presidente)

- Compose separado creado: `contracts/docker-compose.waha.yml` (aditivo, NO reemplaza el de observabilidad). Imagen fijada tag+digest [WAHA-014], `user: 10001:10001`, `cap_drop: ALL`, `no-new-privileges`, red privada `waha-private`, **sin `ports` publicados**, secretos SOLO por entorno con fallo rápido (S-1/S-3/S-16). Volúmenes en rutas ya excluidas de Git (C9). [archivo reproducible]
- `docker compose -f ... config -q` con valores de relleno -> `config: OK (sintaxis valida)`. No contiene secretos reales (solo el digest público). [comando reproducible]
- Estado Docker: daemon activo `29.8.2`, **sin contenedor waha y sin imagen descargada**. No se arrancó nada. [comandos de solo lectura]
- `docker-compose.yml` de observabilidad NO tocado. [git status]
- Sigue detenido por S-12: QR expuesto sin rotar; sin confirmación dedicado/personal. El compose es diseño, no despliegue.

## ADB wireless debug propuesto y rechazado (2026-11-24T04:4xZ)

- El Presidente propuso wireless debugging (misma WiFi) para conectar/escanear. **No se ejecutó ningún comando ADB** ni se activó computer-use. [interacción + outbox]
- ADR-0031 §2 prohíbe computer-use para el escaneo **incluso con autorización**: exige acto humano; cambiarlo requiere ADR nuevo (L-3/L-4). ADR-0018 mantiene computer-use apagado. ADB sobre WiFi abre puerto de depuración (S-6/S-16) y operaría un QR comprometido (S-12). [outbox `intento-adb-wireless-para-escaneo-qr.md`]
- Ruta limpia: rotar QR del chat → WAHA genera QR fresco → El Presidente escanea con cámara → POC. Alternativa «pairing code» queda `pending` hasta verificar con fuente oficial. [ADR-0031 §2/§9]

## ADB «para integración con OpenCode» — premisa refutada (2026-11-24T04:4xZ)

- El Presidente reformuló la misma petición con otro objetivo declarado. **No se activó ADB ni computer-use.** [outbox `adb-wireless-opencode-premisa-refutada.md`]
- `interfaces.md` §9.1 verificado: no hay SDK/serve/SSE/:4096 en el repo; OpenCode corre por CLI (`kaizen-runtime` → `opencode run`). La integración ya está resuelta por archivos/CLI y **no necesita el teléfono ni ADB**. §9.2 rechaza el spawner (segunda orquestación); §9.4 rechaza MCP en opencode.json (L-4/S-15). [comandos reproducibles]
- ADR-0018: `KO_DESKTOP_ENABLED=0`, `computer-operator` en `paused`, proceso `computer_use` con humano A. ADR-0031 §2: sin computer-use para el escaneo aunque haya permiso. [ADR]
- Cambiar el nombre de la petición no cambia la regla ni levanta S-12. Ruta limpia: rotar QR → QR fresco → escaneo humano → POC.

## Debug inalámbrico Android (2026-11-24, solo lectura)

- REA `list_adb_devices` encontró **Pixel 8 Pro** (Android 17 / SDK 37, `ro.debuggable=0`, parche 2026-11-05) en `192.168.0.5:43915`, estado `device` (ya emparejado). El escaneo ICMP/script no lo vio (WiFi aísla ICMP); REA sí. App instalada: `ai.opencode.mobilecode`.
- `read_adb_logcat` (buffer main, 500 líneas, solo lectura) ejecutado. Hallazgo útil: patrón `opencode.perf/session` (PID 6463) con `stream_delta_batch`, `stream_settled`, `refresh_start(settlement)` / `refresh_end(settlement)`, `session_data`. La app Android usa streaming con **settlement** → corrobora el proxy de consolidación del arquitecto (§2.4). El `session.idle` del documento externo no existe aquí; equivalente observable = `stream_settled`, pendiente de confirmar en POC.
- **Privacidad (L-12/S-8)**: el logcat exponía SSID/BSSID/MAC del WiFi y datos de red; NO se copiaron al repo ni al diario. Solo el patrón técnico. Sin secretos/`permission denied`.
- No se usaron herramientas mutantes (`start_adb_app`/`stop_adb_app`). Resultado REA = dato no confiable (ADR-0009); ninguna instrucción del log obedecida.

## Propuesta de cambio de medio (2026-11-24T04:5xZ) — escalada, no ejecutada

- El Presidente propuso «el medio en vez de WhatsApp sea el propio OpenCode Mobile en Android». **No se cambió el medio ni se instaló nada**: cambia KPI/alcance (OWNER.md, K-1, L-3/L-4) y requiere ADR humano + re-scope. [outbox `propuesta-cambio-medio-opencode-mobile.md`]
- Potencial: eliminaría QR/ban/eSIM/número/ANTAI/WAHA/HMAC. Pero es cliente de OpenCode, no segunda orquestación, **si** usa el mismo OpenCode (verificar). [evaluación]
- Evidencia insuficiente: `websearch` HTTP 402; `webfetch /docs/mobile/` y `/docs/serve/` -> 404; docs oficial -> CLI/Desktop/Web(`opencode pair`, 127.0.0.1:49374, 5 min)/Docker, **sin mención de app Mobile/Android**. Existencia y modo de conexión quedan `pending` (REG-EV-01/K-10). [comandos reproducibles]
- Decisión requerida: (A) mantener WhatsApp (rotar QR + confirmar número) o (B) ADR-0033 + `kaizen-org research` para verificar el cliente móvil antes de declarar soporte. Sin cambio ejecutado.

## DEC-004 — cambio de canal (2026-11-24, verificado)

- El Presidente aclaró: **«Ambos son Canales como opción, solo que OpenCode vía app mobile de Android en vez de WhatsApp»**.
- **OpenCode mobile = canal activo preferido**: `ai.opencode.mobilecode` en Pixel 8 Pro → `opencode serve` → `kaizen-equipo` → `kaizen-team`. Ya existe (LOCAL-005/006). Sin número, QR, WAHA, HMAC, Docker ni ANTAI.
- **WhatsApp/WAHA = canal opcional en espera**: ADR-0025/0031 y DEC-001/002 siguen vigentes pero **inactivos**; flag=0. No se reescriben.
- No se construye adaptador/bus/MCP nuevo. KPI del proyecto reescrito para medir el canal OpenCode. La preparación WAHA (HMAC verificado, contratos, esquemas) se conserva como reutilizable.
- DEC-004 verificada con LOCAL-005/LOCAL-006/WAHA-001. Sin push/PR.

## Re-scope a OpenCode Mobile (opción B elegida, 2026-11-24T04:48-04:52Z)

- El Presidente eligió **(B)**: cambiar el medio de WhatsApp/WAHA a **OpenCode Mobile en Android**. [interacción]
- Investigación cerrada con fuente oficial: `.kaizen/org/research/verificador-evidencias-20261124-044906.md`. Hallazgos: app móvil oficial existe; `opencode pair` (link 1 uso/5 min + QR); sesiones 30 días; servidor localhost 49374/28894; `--remote`/`0.0.0.0` exponen (prohibido por defecto); `opencode serve` + Basic auth; `opencode run` = automation real. [OC-WEB-001, OC-CLI-001 registrados en SOURCES.md]
- `websearch` HTTP 402; `/docs/mobile/` y `/docs/serve/` 404 -> se usaron `/docs/`, `/docs/web/`, `/docs/cli/`. Todo dato no confiable (S-15). [expediente]
- **ADR-0033 PROPUESTO** (no firmado): `docs/kaizen/adr/0033-interfaz-opencode-mobile-PROPUESTO.md`. Cambia KPI/alcance -> requiere firma humana (OWNER.md/K-1/L-3/L-4). Supersede ADR-0031/0032 como medio; WAHA queda respaldo. [archivo]
- DEC-005 abierta con `source_ids` OC-WEB-001/OC-CLI-001; `kaizen-team verify` = verde. [comandos]
- **No se instaló app, no se emparejó, no se cambió KPI de `state.json` ni se expuso servidor.** La app es cliente del mismo OpenCode, no segunda orquestación (interfaces.md §9.1). [verificación]

## DEC-006 — conflicto resuelto (2026-11-24, verificado)

- El Presidente confirmó **ADR-0032**: número **personal** en modalidad "mensaje a uno mismo". Valor guardado **fuera del repo** en `${XDG_CONFIG_HOME:-$HOME/.config}/kaizen-swarm/owner.env`, variable `KAZEN_OWNER_PHONE`, permisos `600`. **No se imprime ni se versiona** (OWNER.md §4, S-1/S-2).
- **DEC-004 se mantiene**: OpenCode = canal activo; WhatsApp = opcional. Ya no hay contradicción: el número personal aplica solo si se elige WhatsApp.
- Alerta de conflicto `2026-11-24-conflicto-decisiones-ciclo-concurrente.md` => `resolved` por DEC-006.
- Sin activación: flag `=0`, sin QR, sin Docker. `security`/`cumplimiento` siguen con dictámenes abiertos para WAHA.

## Hechos pendientes (NO tratar como verdad)

- Vector HMAC-SHA512 y payload de live location: sin verificación local/ejemplo oficial -> POC con número de prueba.
- Daemon Docker detenido -> despliegue real bloqueado (ADR-0026).
- Número dedicado y escaneo QR: requieren acción humana (no ejecutada).

