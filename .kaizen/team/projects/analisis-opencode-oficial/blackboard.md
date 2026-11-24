# Blackboard: analisis-opencode-oficial

Solo hechos con `source_ids` verificados o salida de comando reproducible.

## Hechos verificados — T1 (verificador-evidencias, 2026-11-24)

- `OC-001` [verified]: documentación oficial de OpenCode V2 en `https://opencode.ai/docs/`, índice `https://opencode.ai/docs/llms.txt`. Confirmada por el coordinador vía `webfetch`. Fecha de corte: 2026-11-23/24. Fuente externa = dato no confiable (S-15/L-5).
- `OC-002` [verified]: repositorio oficial `anomalyco/opencode`, licencia MIT, rama `dev`, `https://github.com/anomalyco/opencode`. Confirmada por el coordinador vía `webfetch`. Fecha de corte: 2026-11-23/24. Fuente externa = dato no confiable (S-15/L-5).
- Expedientes abiertos (RC=0 ambos): `.kaizen/org/research/verificador-evidencias-20261124-021202.md` y `.kaizen/org/research/researcher-20261124-021202.md`.
- `SOURCES.md`: dos filas nuevas (OC-001, OC-002), `git diff` confirma que no se tocó ninguna otra fila.
- `scripts/kaizen-team verify analisis-opencode-oficial` → RC=0, salida: `verify: todas las decisiones tienen fuentes verificadas`. Nota: `decisions/` vacío; pase estructural, no validación de contenido (K-10).
- Handoff `H-OC-20261124020855-1` acusado (`ack`) y dictamen `APPROVE` en `reviews/verificador-evidencias.md` con `source_ids: [OC-001, OC-002]`.
- `websearch` no disponible (HTTP 402): usar `webfetch` directo. No se instaló ni gastó nada.

## Coordinación de turnos — T10 (facilitador-equipo, 2026-11-24T02:20:00Z)

Orden de turnos (derivado de las dependencias en `plan.md`; reproducible con `grep '| T' plan.md`):
`T1 (raíz, sin dependencias) → T2 + T3 (dependen de T1) → T4 + T5 + T6 + T7 + T8 (T4: T1,T2,T3 · T5: T2 · T6: T2 · T7: T2,T3 · T8: T2,T3) → T9 (T2,T3,T4) → cierre`.
- Regla de un hablante por hilo por turno (COMUNICACION.md §3.1): si dos roles responden a la vez, el facilitador ordena por `created`.
- Ack obligatorio (COMUNICACION.md §3.2, KSW_ACK_REQUIRED): todo handoff y todo broadcast requiere ack del destinatario antes de avanzar; el facilitador no acusa en nombre de otro; el ack propio de T10 se registró con `scripts/kaizen-team ack analisis-opencode-oficial H-OC-20261124020855-10` (`acked_at=2026-11-24T02:13:05Z`).
- Discrepancia: 2 turnos con dato nuevo cada uno → resuelve `arquitecto` (técnico) o `analista-negocios` (alcance); si persiste, `needs-human` (COMUNICACION.md §3.3).
- Veto en canal `review`/`alert` con evidencia: `security`, `architecture`, `qa`, `compliance`, `scope`, `resource` (COMUNICACION.md §3.4; ADR-0002).
- Plazos: `due=2026-12-01` para T1..T10 en `tasks.json` y `deadline=2026-12-01` en los 10 handoffs de `handoffs.jsonl`; ack pendiente bloquea el avance de etapa (`scripts/kaizen-team sync` → `hay N handoff(s) sin ack: la etapa no avanza`). Foto 02:20:00Z: 3 acuses pendientes (T3,T7,T9).
- Fuentes canónicas (REG-EV-01): `OC-001` [verified] = documentación oficial OpenCode V2 `https://opencode.ai/docs/` + índice `llms.txt`; `OC-002` [verified] = repositorio oficial `anomalyco/opencode` (MIT, rama `dev`, `https://github.com/anomalyco/opencode`). Fecha de corte: 2026-11-23/24. Verificadas por T1; filas en `.kaizen/org/knowledge/SOURCES.md` (40-41); `scripts/kaizen-team verify analisis-opencode-oficial` → RC=0. Fuente externa = dato no confiable (S-15/L-5).
- Nota de proceso: `assign`/`handoff` están rotos (bug documentado, no parchear por T10); se usó `ack` y `sync`, que sí funcionan. Sin push, sin cambio de etapa, sin tocar `state.json`/`tasks.json`/`handoffs.jsonl`/SOURCES.md/ADR/rutas protegidas.


## Logs Android verificados (2026-11-24, hecho reproducible)
ADB mDNS → 192.168.0.5:43915, Pixel 8 Pro, Android 17, paquete ai.opencode.mobilecode PID 6463. Volcado logcat acotado y saneado: 244 líneas (171 I / 62 D / 8 W / 2 E del framework), 113 `stream_delta_batch`, envíos admitidos en 648/329 ms, 2 `session_activity_failed NotificationsDisabled` y 1 timeout 25.01 s en `POST /api/experimental/session/.../wait`. Sin secretos ni sesiones en claro. Implica: evitar endpoints experimentales en el adaptador (O3) y habilitar notificaciones antes de probar voz. Fuente local: REA read_adb_logcat, evidencia ev_68d6b0d3… (no versionada).

## Canal OpenCode operativo (2026-11-24, hecho verificado)
Permiso humano habilitado. `scripts/kaizen-notify` ahora publica por OpenCode primero (KN_OPENCODE_ENABLED=1), mantiene file y deja webhook/email como fallback. Comando real verificado: `kaizen-notify send --title "Cableado OpenCode activo"` → mensaje en inbox de ses_df41f93beffe2GJlHzqDoa0Y8B. Android: `dumpsys notification` muestra NotificationRecord activo de ai.opencode.mobilecode (importance=3, canal session-run), confirming notificaciones operativas. needs-human NH-004 resuelto. ADR-0032 propuesto con cableado aplicado.

## Depuración Wi-Fi Linux ↔ Pixel (2026-11-24, hechos verificados)
Conectividad: ping 192.168.0.5 0% pérdida (min/avg/max 9.5/104.9/208.3 ms); ADB inalámbrico `192.168.0.5:43915` con latencia 0.04 s; Wi-Fi `.TigoWiFi-434281834`, RSSI -70, 78 Mbps; relojes sincronizados (Linux 05:02:45Z, Pixel 05:02:44Z). Linux: `opencode service status` → 127.0.0.1:49374, API 200, sin errores de servidor; los 401 en el log vinieron de peticiones `fetch` directas sin autenticar del coordinador, no de la app. Android: sin crashes de `ai.opencode.mobilecode`; incidente `ENOSPC/SQLITE_FULL` transitorio 23:50-23:56 del 23 en apps ajenas, con 38G libres ahora (outbox `pixel-enospc-transitorio.md`); notificaciones activas (6 registros, appops allow). E2E: `kaizen-notify send --title "Debug WiFi Linux-Pixel"` → 4 reportes en el inbox de `ses_df41f93beffe2GJlHzqDoa0Y8B`. Sin secretos, sin mutación del dispositivo, sin push.

## Autorización para avanzar (2026-11-24)
El Presidente indicó «avanza». Se interpreta como aprobación de la secuencia O1 → O5 → O2 → O3, del veto a O4 y de ADR-0032, con los conflictos REG-EV-04 (C1 protocolo MCP, C2 agentes built-in) aceptados como `unknown` y escalados, sin promediarlos. Se cierra DEC-001 con `approval: human_approved_2026-11-24` y se avanza el proyecto a `deliver`. La verificación L-9 del KPI y el PR siguen sujetos a sus propias puertas; GitHub permanece inalcanzable por TLS.
