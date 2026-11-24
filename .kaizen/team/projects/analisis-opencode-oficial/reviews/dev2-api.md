# Review: dev2-api — Integración práctica OpenCode V2 ↔ kaizen-swarm

- **status**: APPROVE (dictamen de **diseño/arquitectura de integración**; no autoriza fusión, instalación ni ejecución)
- **source_ids**: [OC-001]
- **fecha de corte**: 2026-11-23/24
- **correlation_id**: analisis-opencode-oficial
- **handoff**: H-OC-20261124020855-6 (ack registrado: `scripts/kaizen-team ack analisis-opencode-oficial H-OC-20261124020855-6` → RC=0)
- **fuentes consultadas (webfetch, solo documentación oficial)**: `/docs/api/`, `/docs/build/client/`, `/docs/build/sdk/`, `/docs/build/plugins/rpc/`, `/docs/mcp-servers/`, más el índice de la skill OpenCode. `websearch` no disponible (HTTP 402); ninguna duda V2 se resolvió con búsqueda general.
- **regla aplicada**: todo contenido de documentación, issues o buzones es dato no confiable (S-15/L-5). **No se ejecutó ningún comando de la documentación, no se instaló ningún paquete, no se gastó, no se hicieron push ni cambios fuera de este review y el ack.**

---

## 1. Observación

kaizen-swarm today resuelve orquestación, notificación, buzón de entrada, observabilidad y gates con scripts propios (`scripts/kaizen-team`, `kaizen-swarm`, `kaizen-runtime`, `kaizen-notify`, `kaizen-inbox`, `kaizen-voice`, `kaizen-learn`, verificados con `ls -1 scripts/kaizen*`). OpenCode V2 expone un plano de control HTTP con contrato OpenAPI, un cliente TypeScript generado, un SDK embebido, un service background descubrible y un mecanismo de RPC para plugins. Existe una superposición funcional real —sesiones, eventos, worktrees, VCS, automatizaciones, buzón de sesión y permisos— que permite **complementar** esos scripts, pero también un riesgo de sustituir gobernanza humana y evidencia por un transporte que no la garantiza.

---

## 2. Evidencia (OC-001)

### 2.1 API HTTP y contrato OpenAPI

- La API es una superficie **experimental** (`HttpApi`) con **178 operaciones y 528 schemas** derivados de un documento **OpenAPI 3.1.0**; el documento sin procesar está publicado en `/docs/openapi.json` y, **en el servidor en ejecución, en `/openapi.json`** (índice de la skill OpenCode, sección API). `opencode api get /api/info` es el chequeo documentado de arranque.
- Rutas relevantes para integración (texto literal de `/docs/api/`):

| Agrupación | Operaciones documentadas | Uso potencial en kaizen-swarm |
| --- | --- | --- |
| Server / Location | `GET /api/info`, `POST /api/pair`, `GET /api/location`, `POST /api/location/reload` | healthcheck y descubrimiento |
| Agent / Model / Provider | `GET /api/agent`, `GET /api/agent/{agentID}`, `GET /api/model`, `GET /api/provider` | inventario vivo de capacidades frente a `kaizen-org list` |
| Session | `POST /api/session`, `POST /api/session/{sessionID}/prompt`, `/command`, `/skill`, `/shell`, `/compact`, `/interrupt`, `/background` | ejecución de tareas T1..T10 como sesiones |
| Session inbox | `GET /api/session/{sessionID}/inbox`, `PATCH .../inbox/{inboxID}`, `DELETE .../inbox/{inboxID}` | cola **steer/queue** hacia un agente (no es un buzón entrante de WhatsApp) |
| Form / Permission | `GET|POST /api/session/{sessionID}/form`, `.../form/{formID}/reply`, `GET|POST .../permission`, `.../permission/{requestID}/reply` (`once`/`always`/`reject`) | gates humanos / aprobaciones |
| Event | `GET /api/event` — "Subscribe to events" | observabilidad; `V2Event` incluye `session.execution.*`, `permission.asked`, `form.created`, `worktree.updated`, `vcs.branch.updated`, `session.idle` |
| Worktree / VCS | `GET|POST|DELETE /api/worktree`, `/api/worktree/refresh`, `GET /api/vcs/status|diff|branch|base` | worktrees `wt-issue-<N>-<rol>` y finalize |
| Automation / Job | `/api/experimental/automation` (create/pause/resume/delete; `Trigger.At|Every|Cron|Event`, `Action.Prompt|Code|Shell`), `/api/experimental/job` | tareas programadas/proactivas (`kaizen-runtime`, `kaizen-loop`) — **experimental** |
| Skill / Command / Plugin / MCP | `GET /api/skill`, `/api/command`, `/api/plugin`, `/api/mcp`, `/api/mcp/resource` | descubrimiento de skills/comandos/MCP |
| Shell / PTY / Websearch | `POST /api/shell`, `/api/shell/{id}/output`, `/api/pty`, `POST /api/websearch` | alternativa a `computer-operator`/`kaizen-desktop` (riesgo S-16) |
| RPC | `POST /api/rpc/{rpcID}/{method}` | ver 2.5 |

### 2.2 `@opencode/client` y el entrypoint `/effect`

De `/docs/build/client/`:

- `@opencode/client` es el cliente TypeScript **generado del mismo contrato** que la referencia de API. Entrypoint por defecto: valores **Promise** + **async iterables** para streaming.
- `OpenCode.make({ baseUrl: "http://localhost:4096", headers })`; `client.session.create({ location: { directory } })`; `client.session.prompt({ sessionID, text })`; opciones por operación con `AbortSignal` y headers por petición.
- Eventos: `for await (const event of client.event.subscribe())`; filtro `client.event.subscribe({ types: ["config.updated"] })`; `server.connected` llega siempre. **Live-only, sin replay ni reconexión automática**; el consumidor debe amortiguar antes de trabajo lento.
- Sobre esquemas: "The Promise client accepts Standard Schema or plain JSON Schema definitions and **does not run schema parsers locally**: the server returns already parsed and transformed output. **Effect Schema definitions require the Effect client**." El índice oficial de la skill nombra ese entrypoint: **`@opencode/client/effect`** expone *typed Effects, Streams y valores de esquema decodificados*. Conclusión con base documental: el default es Promise y no decodifica localmente; `/effect` es el requerido cuando el contrato usa Effect Schema. (No se ejecutó ni instaló; es diseño basado en documentación.)

### 2.3 SDK embebido

De `/docs/build/sdk/`:

- `@opencode/sdk` **aloja OpenCode dentro de la aplicación**: "assembles the OpenCode server and routes API calls through its HTTP router **in memory**. It opens **no HTTP listener** and adds no network hop".
- `OpenCode.create()` devuelve un host explícitamente poseído; liberar con `await using` o `await opencode.close()`. Aliases `sessions` y `events`. Mismos valores Promise, errores declarados, request options y `AsyncIterable` que el cliente.
- Worktrees del SDK **requieren `projectID`**: `opencode.worktree.create({ projectID, name })`, `refresh({ projectID })`, `remove({ projectID, directory, force })`.
- Personalización con `Plugin.define({...})` pasado a `OpenCode.create({ plugins: [plugin] })`.

### 2.4 Service (descubrir/iniciar el background service)

De `/docs/build/client/`, sección "Local background service":

- Los entrypoints principales son **browser-compatible y no incluyen gestión de procesos locales**; en Node se importa `@opencode/client/service`.
- `Service.discover()` → endpoint sano registrado **sin iniciar** proceso. `Service.ensure()` → servicio compatible, **inicia uno si hace falta**. `Service.stop()` → detiene la instancia registrada exacta. `Service.headers(endpoint)` → headers de autenticación para el cliente.
- `Service.ensure({ file, version: (v) => v.startsWith("2."), command: ["opencode", "serve", "--service"], onStart(reason, previousVersion) })`. El predicado de versión es el mecanismo documentado para **fijar V2** y evitar V1.
- La skill añade que `opencode api` usa el mismo flujo de descubrimiento/autenticación que la TUI y **puede iniciar el servicio** cuando no hay uno sano compatible.

### 2.5 RPC para plugins

De `/docs/build/plugins/rpc/`:

- `Rpc.define({ id, methods: { search: { input, output, errors } }, events: { updated: { schema } } })`. Admite **JSON Schema** o **Standard Schema** (Zod, Valibot, ArkType). Datos de evento deben ser objeto; nombres de error `rpc.*` reservados.
- Registro: `ctx.rpc.register(Acme, { search: async (input, context) => { ... context.signal ... context.error(...) } })`; el mismo plugin llama con `ctx.rpc(Acme)`; emite con `registration.events.emit("updated", {...})`. Suscripciones `events.on` / `events.subscribe`, tipo recibido `rpc.<rpcID>.<event>`, **live-only**.
- Cualquier cliente HTTP puede invocar la ruta genérica `POST /api/rpc/{rpcID}/{method}` con `{ "input": ... }` y recibe `{ "output": ... }`. El cliente tipado se crea con `client.rpc(Acme)`.

### 2.6 MCP y Code Mode

De `/docs/mcp-servers/`: V2 configura bajo **`mcp.servers`** (no nombres directos bajo `mcp`); `type: local|remote`, `codemode` por defecto **`true`**, `protocol: legacy|auto|2026-07-28`, `pool`, `disabled`. Secretos por `{env:NAME}` u OAuth fuera de la configuración. Code Mode agrupa herramientas como `tools.<servidor>.<herramienta>(...)`. El `sessionID` viaja en `_meta["ai.opencode/sessionID"]` como **valor de correlación opaco**: "Do not use it by itself for authentication or authorization".

De la skill: en Code Mode, usar primero `tools.opencode.*` **dentro de `execute`** (descubrir con `search({ namespace: "opencode" })`); para lo que no cubran, `opencode api`. En este entorno ya existen `tools.opencode.worktree_create|worktree_list|worktree_remove|session_move|list_mcp_resources`.

### 2.7 Evidencia interna reproducible

`ls -1 scripts/kaizen*` confirma la existencia de `kaizen-team`, `kaizen-swarm`, `kaizen-runtime`, `kaizen-notify`, `kaizen-inbox`, `kaizen-voice`, `kaizen-learn`, `kaizen-observability`, `kaizen-gov`, `kaizen-whatsapp`. Según AGENTS.md: notify → webhook n8n → WhatsApp **oficial vía BSP** (ADR-0025), inbox → 127.0.0.1:8787 con secreto compartido, observabilidad → Grafana local :3000/Prometheus :9090, y outbox S-11 como canal de hallazgos.

---

## 3. Impacto

1. **Positivo, bajo acoplamiento**: el par `Service.discover()/ensure()` + `@opencode/client` permite a kaizen-swarm *conectarse* a OpenCode sin poseer su proceso ni convertirse en host; `@opencode/sdk` es la alternativa de acoplamiento fuerte si algún día queremos que el orquestador sea el host.
2. **Superposición útil**: `GET /api/event` da un flujo unificado de `session.execution.*`, `permission.asked`, `worktree.updated`, `vcs.branch.updated` — hoy repartido entre `handoffs.jsonl`, `standups/` y el exporter de Grafana. `/api/worktree` y `/api/vcs/*` solapan con la gestión de worktrees del swarm y con `finalize`.
3. **Riesgo de sustitución indebida**: el inbox de sesión de OpenCode es una cola *steer/queue* de mensajes hacia un agente; **no equivale** a `kaizen-inbox` (instrucciones entrantes de El Presidente con secreto compartido). Sustituirlo rompería el flujo OWNER.md. Igualmente, `Permission.Reply` es un transporte de respuesta, **no** la autoridad humana de ADR-0002/0003 ni el outbox S-11.
4. **Riesgo de secretos y datos**: `/api/pair`, `/auth/connect/{code}` y `/api/credential` manejan credenciales; `Service.headers()` **devuelve headers de autenticación** que nunca deben imprimirse ni versionarse (S-1/S-2/S-8). El `sessionID` en `_meta` no es credencial (S-6).
5. **Madurez**: la API se declara *experimental* y varias rutas están bajo `/api/experimental/*` (automation, jobs, generate). Cualquier dependencia de ellas debe llevar bandera y plan de reversión (L-7).
6. **Coste/alcance de este review**: cero gasto, cero instalación; el análisis se agota en la capa de contrato.

---

## 4. Propuesta

### 4.1 Opción recomendada (la más viable): **adaptador delgado de red, no sustitución**

**B — `@opencode/client` + `@opencode/client/service` como adaptador opcional**, con **C — `opencode api` / OpenAPI — como paso 0 sin dependencias**. Mantener A (SDK embebido) como opción futura condicionada a ADR.

| Opción | Qué haría | Coste | Riesgo | Reversibilidad | Veredicto |
| --- | --- | --- | --- | --- | --- |
| C. `opencode api` + `/openapi.json` | healthcheck y llamadas puntuales desde scripts; descubrir operation IDs del contrato | nulo (CLI ya documentada) | bajo; API experimental | total, es solo lectura/llamada | **Paso 0 inmediato** |
| B. `@opencode/client` + `Service` | adaptador TS delgado: `discover/ensure/headers`, sesiones, eventos, RPC tipado | una dependencia pinned + lockfile (S-9) | medio: acoplamiento a contrato experimental; headers sensibles | alto: el adaptador es un módulo aislado y desactivable por bandera | **Destino recomendado** |
| A. `@opencode/sdk` embebido | que kaizen-swarm hospede OpenCode en memoria, sin listener | alto: Bun/TS, plugins, ciclo de vida del host | alto: cambia quién posee sesiones/permisos/gobernanza | medio: requiere ADR y migración | Solo futuro, con ADR humano |

Justificación: B preserva la frontera de propiedad de la comunidad (nuestro `state.json`, `handoffs.jsonl` y outbox siguen siendo la verdad), usa `version: (v) => v.startsWith("2.")` para blindar V2, y ofrece `events.subscribe()` para observabilidad sin reemplazar Grafana. A sólo tiene sentido si El Presidente decide que el orquestador *es* OpenCode, lo cual es una decisión sensible (L-3/L-4).

### 4.2 Mapeo concreto: scripts actuales ↔ superficie OpenCode

| Script kaizen | Superficie OC-001 (source_id) | Acción propuesta |
| --- | --- | --- |
| `kaizen-team` / `kaizen-swarm` | `/api/session`, `/api/event`, `/api/worktree`, `/api/vcs/*`, `GET /api/agent` | **Complementar**: publicar avances como eventos/sesiones; **no** mover la máquina de estados ni los acuses fuera del orquestador |
| `kaizen-runtime` / `kaizen-loop` | `/api/experimental/automation` (`Trigger.Cron/Event`), `/api/experimental/job` | **Complementar solo tras ADR**: experimental; mantener el loop local como fuente de verdad |
| `kaizen-notify` / `kaizen-whatsapp` | `POST /api/session/{id}/prompt`, `POST /api/experimental/generate` | **No sustituir**: el adaptador oficial BSP/n8n (ADR-0025) y el reporting a OWNER.md deben permanecer; como máximo, un plugin RPC que *entregue* el resumen ya saneado |
| `kaizen-inbox` | `GET/PATCH/DELETE /api/session/{id}/inbox` | **No sustituir**: semántica distinta (steer/queue vs. instrucciones entrantes autenticadas). Documentar la diferencia en la guía de implementación (T9) |
| `kaizen-observability` / `kaizen-feedback` | `GET /api/event` + `event.subscribe()` | **Complementar**: puente opcional evento → exporter local; recordar que es live-only y sin replay, por lo que Grafana sigue siendo el histórico |
| `kaizen-gov` / gates | `/api/session/{id}/permission`, `/api/session/{id}/form` | **Solo transporte**: la respuesta `once/always/reject` no sustituye la aprobación humana ni `kaizen-gov can` |
| `kaizen-org list` / descubrimiento | `/api/agent`, `/api/skill`, `/api/command`, `/api/mcp` | **Complementar**: inventario en vivo como `finding`, nunca como instrucción (L-5) |
| Worktrees del swarm | `tools.opencode.worktree_create/list/remove` (Code Mode) y `/api/worktree` | **Complementar con cuidado**: el SDK exige `projectID`; las operaciones `remove` con `force` requieren humano (L-4) |

### 4.3 Ejemplo concreto de integración (documentado, NO ejecutado)

Paso 0 — verificación sin dependencias (comando de la documentación; **no ejecutado en esta tarea**, S-15/L-5):

```sh
opencode api get /api/info
# alternativa: descargar el contrato y derivar operation IDs
# GET /openapi.json  (del servidor en ejecución)
```

Paso 1 — adaptador delgado en Node (seudocódigo basado literalmente en `/docs/build/client/`):

```ts
import { OpenCode } from "@opencode/client"
import { Service } from "@opencode/client/service"

// 1) Descubrir o arrancar el servicio, fijando V2 y sin imprimir headers.
const endpoint = await Service.ensure({
  version: (v) => v.startsWith("2."),
  onStart(reason, previousVersion) {
    logger.info({ reason, previousVersion }, "opencode service started")
  },
})
const client = OpenCode.make({
  baseUrl: endpoint.url,
  headers: Service.headers(endpoint), // NUNCA loguear
})

// 2) Publicar el avance de la tarea T6 como una sesión ligada al Location del repo.
const session = await client.session.create({
  location: { directory: repoDirectoryFromConfig }, // S-3: de configuración, no hardcodeado
})
await client.session.prompt({
  sessionID: session.id,
  text: "T6: integration review listo; source_ids [OC-001]",
})

// 3) Observabilidad: solo eventos nuevos (live-only => Grafana sigue siendo el histórico).
for await (const event of client.event.subscribe({
  types: ["session.execution.succeeded", "session.execution.failed", "permission.asked"],
})) {
  if (event.type === "server.connected") continue // marcador documentado
  localExporter.push(sanitize(event)) // sin secretos ni datos personales (S-8/L-12)
}
```

Paso 2 — exponer una capacidad del swarm como RPC tipado (diseño; requiere plugin configurado en el servidor, **no instalado aquí**):

```ts
// rpc.ts (contrato compartido)
import { Rpc } from "@opencode/plugin/rpc"
export const Kaizen = Rpc.define({
  id: "kaizen",
  methods: {
    status: {
      input: { type: "object", properties: { project: { type: "string" } }, required: ["project"] },
      output: { type: "object", properties: { stage: { type: "string" } }, required: ["stage"] },
      errors: { not_found: { type: "object", properties: {}, additionalProperties: false } },
    },
  },
  events: {
    advanced: { schema: { type: "object", properties: { stage: { type: "string" } }, required: ["stage"] } },
  },
})
// index.ts (servidor): ctx.rpc.register(Kaizen, { status: async (input, ctx) => ... })
// cliente: const kaizen = client.rpc(Kaizen); await kaizen.status({ project })
// HTTP genérico: POST /api/rpc/kaizen/status  { "input": { "project": "..." } }
```

Nota: invocar `client.rpc(Kaizen)` **no registra** el RPC; el plugin servidor debe estar configurado y en ejecución. Los errores `rpc.*` están reservados.

---

## 5. Criterios de aceptación (verificables, L-9)

1. **Fuente**: toda afirmación V2 de este review lleva `source_ids: [OC-001]` y fecha de corte 2026-11-23/24; 0 afirmaciones V2 sin cita (KPI de charter).
2. **Contrato antes que código**: antes de cualquier implementación, el adaptador publica su interfaz en `contracts/` del equipo (responsabilidad dev2-api) y el architect emite dictamen.
3. **Sin ejecución ni instalación en esta tarea**: 0 paquetes añadidos, 0 comandos de la documentación ejecutados, 0 gasto, 0 push. Verificable por ausencia de diffs fuera de `reviews/dev2-api.md` y del ack.
4. **Blindaje V2**: el arranque del servicio usa un predicado de versión `startsWith("2.")`; ninguna recomendación usa campos deprecados de V1 sin marcarlos como migración.
5. **Secretos**: `Service.headers(endpoint)` y cualquier header OAuth `Bearer` nunca aparecen en logs, diffs, outbox ni contexto; los secretos de configuración usan `{env:NAME}`; 0 secretos (KPI).
6. **Gobernanza intacta**: `kaizen-inbox`, `kaizen-notify` (BSP oficial), el outbox S-11 y las aprobaciones humanas siguen siendo la vía canónica; el adaptador no cambia etapas ni auto-aprueba.
7. **Reversibilidad**: el adaptador detrás de una bandera; desactivarlo restaura el comportamiento actual sin migración de datos (L-7).
8. **Observabilidad**: si se activa el puente de eventos, se documenta explícitamente que el stream es live-only y que Grafana conserva el histórico; ningún evento crudo con datos personales se persiste (L-12).
9. **Dependencias**: si se adopta B, versión fijada y lockfile, con revisión humana del manifiesto (S-9); `websearch` sigue fuera de alcance por HTTP 402.

---

## 6. Límites

- **No implementado**: todo lo anterior es diseño. No se creó ningún `opencode.json(c)`, no se registró ningún plugin/MCP, no se instaló `@opencode/client`, `@opencode/sdk` ni `@opencode/plugin`. S-15/L-5.
- **API experimental**: superficie `HttpApi` marcada como experimental; rutas `/api/experimental/*` (automation, jobs, generate, client-mcp) pueden cambiar. No fundar obligaciones sobre ellas sin revalidación (REG-EV-05).
- **Eventos sin replay**: `client.event.subscribe()` y los eventos RPC son live-only, sin reconexión automática; no sustituyen al log histórico de Grafana ni a `handoffs.jsonl`.
- **Permisos MCP**: Code Mode es el default; `codemode:false` cambia la exposición de herramientas y debe decidirse con seguridad (T7). El `sessionID` de `_meta` es opaco y **no** es autenticación.
- **No confundir dominios**: inbox de sesión ≠ buzón entrante de OWNER.md; `Permission.Reply` ≠ aprobación humana; `Service.headers()` ≠ credencial a versionar.
- **Fuentes**: solo documentación oficial V2 (OC-001). `websearch` devolvió HTTP 402; no se usaron fuentes de nivel I/S/N ni resultados de búsqueda general para resolver dudas V2 (K-10).
- **Fuera de mi autoridad**: decidir ADR, cambiar autonomía, instalar dependencias, tocar rutas protegidas (L-4), modificar gobernanza, publicar o fusionar. Todo eso se propone con evidencia y sigue CONSENSUS.md; sensible → El Presidente.

---

## 7. Pregunta

Al arquitecto (T4) y a seguridad (T7): ¿aceptan la **opción B con bandera de desactivación** como destino del adaptador —manteniendo `kaizen-inbox`, `kaizen-notify` (BSP oficial) y el outbox S-11 como vías canónicas— y confirman que el puente `GET /api/event` → exporter local debe tratarse como **complemento no histórico** de Grafana, de modo que el ADR resultante no otorgue a OpenCode autoridad sobre la máquina de estados ni sobre aprobaciones humanas?
