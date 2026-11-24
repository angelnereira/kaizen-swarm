# ADR-0032: canal saliente de reportes usando el propio OpenCode

Estado: aceptado el 2026-11-24 por El Presidente («avanza»); verificación L-9 del KPI pendiente
Fecha: 2026-11-24
Aprobado por: Angel Nereira — instrucción directa: «el medio en vez de whatsapp sea el propio opencode»
Fuentes: OC-001 (documentación oficial V2), OC-002 (repositorio oficial `anomalyco/opencode`), fecha de corte 2026-11-23/24
`source_ids`: [OC-001, OC-002]

## Contexto
Hoy `kaizen-notify` envía reportes por `file`, `webhook` (n8n → WhatsApp) y `email`; ADR-0025 fija que, si se usa WhatsApp, debe ser Cloud API oficial vía BSP, con opt-in, ventana de 24 h y plantillas. El Presidente ordenó que el medio sea **el propio OpenCode**, no WhatsApp, para aprovechar que la comunidad ya opera dentro de OpenCode en escritorio y Android (ver evidencia de logs en `OPENCODE-INTEGRACION.md`: 113 eventos `stream_delta_batch` y sesiones activas de agentes Kaizen).

La API V2 expone rutas estables adecuadas para notificaciones (`OC-001`):
- `POST /api/session` → crea la sesión dedicada de reportes.
- `POST /api/session/{sessionID}/synthetic` con `text`, `description`, `metadata`, `resume:false` y un `id` «que empiece por `msg_`»; el mismo `id` devuelve el mensaje original en lugar de duplicarlo. `resume:false` deja el item en el inbox **sin iniciar al agente**, por lo que no hay gasto de inferencia.
- `GET /api/session/{sessionID}/inbox` → verificación de entrega.

La app Android mostró un timeout de 25 s en `POST /api/experimental/session/{id}/wait`: las rutas experimentales quedan explícitamente fuera de este diseño.

## Decisión
1. El canal primario de salida pasa a ser **OpenCode**, mediante un adaptador delgado e independiente: `scripts/notify-opencode` (ruta NO protegida; no se modifica `scripts/kaizen*`). Contrato: `send --title T --body B [--level ...]`, `event <equipo> <rc> [detalle]`, `status`, `session`.
2. El adaptador usa **solo rutas estables**: crea/reutiliza una sesión dedicada y publica mensajes `synthetic` con `resume:false` e `id` determinista `msg_kzn<sha256(title|body|level)>`. El ID se reenvía en reintentos: idempotencia garantizada por la API.
3. `file` se conserva como pista de auditoría local (`notifications.jsonl`, con `channel:"opencode"`, `session` y `message_id`). `webhook`/WhatsApp y `email` quedan como **fallback** y solo bajo ADR-0025: nada de clientes no oficiales (ADR-0025:11,22).
4. Sin secretos en el payload ni en `metadata` (S-1/S-8/S-12). El ID de sesión es dato operativo no sensible y vive en `.kaizen/team/runtime/opencode-notify-session`.
5. No se usan rutas `/api/experimental/*`, no se instala nada, no se modifica `~/.config/opencode/opencode.json` ni `.opencode/`, y no se activan plugins/hooks como mecanismo de entrega (veto `architecture` en `DEC-001`).

## Consecuencias
- Positivas: canal nativo, local y auditable; sin coste por mensaje de BSP, sin ventana de 24 h ni plantillas; idempotencia real; el reporte queda visible en la app de OpenCode (escritorio/Android) junto al trabajo de los agentes.
- Negativas: depende del servicio local de OpenCode; si no está disponible, el adaptador falla cerrado y se mantiene `file`. En Android requiere notificaciones habilitadas — los logs mostraron `session_activity_failed NotificationsDisabled` (ya escalado al humano).

## Límites y trabajo pendiente (L-4)
Sustituir el medio **dentro del runtime** exige añadir el caso `opencode` a `cmd_send` en `scripts/kaizen-notify:55-57` y/o cambiar el dispatch en `scripts/kaizen-runtime` — ambos son `scripts/kaizen*`, ruta protegida (L-4). Este ADR **no los modifica**. Se abre `needs-human/2026-11-24-wiring-canal-opencode.md` con la propuesta concreta; el humano debe aprobar la edición o autorizar invocar `notify-opencode` desde su propio orquestador. Hasta entonces el adaptador es funcional de forma autónoma y ya fue probado.

## Cómo se verificó (L-9)
```
scripts/notify-opencode session            → ses_df41f93beffe2GJlHzqDoa0Y8B
scripts/notify-opencode send --title ...   → [notify-opencode] reporte publicado ... id msg_kzn...
opencode api get /api/session/<sid>/inbox  → 1 item synthetic con el texto y metadata.channel="opencode"
segundo send idéntico                       → sigue 1 item (mismo id, idempotencia)
scripts/notify-opencode event ... 0 ...     → item "Equipo ...: OK"
```
Sin coste de inferencia (`resume:false`), sin secretos, sin push a `main`. ADR-0025 permanece vigente para cualquier uso residual de WhatsApp; este ADR solo cambia el medio primario.

## Alternativas consideradas
- Mantener WhatsApp/BSP: descartada por instrucción del Presidente; queda como fallback.
- Plugin/hook de OpenCode como egress: vetado por `architecture` en `DEC-001` (breaking changes V1→V2, autocarga, `@latest`).
- Webhook n8n genérico: conservado como fallback, no como primario.

## Cableado completado (2026-11-24, permiso humano habilitado)
Se aplicó la Opción 1: `scripts/kaizen-notify` incorpora `send_opencode()` y antepone el canal `opencode` cuando `KN_OPENCODE_ENABLED=1` (por defecto), sin leer ni modificar `notify.env`. `file` conserva la auditoría; `webhook`/`email` siguen como fallback. Prueba real: `kaizen-notify send --title "Cableado OpenCode activo"` → item en el inbox de `ses_df41f93beffe2GJlHzqDoa0Y8B`. El ADR sigue `proposed` hasta la verificación L-9 del KPI; el cableado ya está operativo.
