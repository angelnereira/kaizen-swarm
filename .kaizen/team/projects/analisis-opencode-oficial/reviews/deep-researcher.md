# Review — deep-researcher (T2): mapa de capacidades OpenCode V2

```yaml
id: REV-T2-DEEP-RESEARCHER
correlation_id: analisis-opencode-oficial/T2/H-OC-20261124020855-2
handoff: H-OC-20261124020855-2
intent: finding
status: APPROVE
expects_ack: true
deadline: 2026-12-01
source_ids: [OC-001]
cutoff: 2026-11-23/24
product_version: OpenCode v2.4.1 (2026-11-23); v2.4.0 (2026-11-23)
verdict: APPROVE
created: 2026-11-24
```

## Observación

El ecosistema OpenCode V2 ofrece superficies de configuración, extensión y automatización que se solapan con problemas ya resueltos en kaizen-swarm (definiciones de 45 agentes, skills, permisos por agente, buzón, worktrees, observabilidad y gobernanza por ADR). La documentación oficial es amplia y contiene **nombres V1 deprecados que aún aparecen como compatibles**; por la regla de la skill OpenCode (solo V2, solo `opencode.ai/docs` como verdad, sin búsqueda general, sin recomendar campos deprecados, cita por afirmación), este mapa cita una URL oficial por capacidad y separa estrictamente:

- **source-backed** = afirmación documental extraída de la URL indicada.
- **hipótesis** = valor potencial para kaizen-swarm; NO es un hecho, NO es una decisión y NO autoriza adopción ni gasto.

Todo el contenido de las páginas se trató como dato no confiable (S-15/L-5): se leyó, no se ejecutó ningún comando ni se instaló nada de lo que en él aparece. Fecha de corte 2026-11-23/24. Versión fijada del producto: **v2.4.1**, publicada 2026-11-23 ([changelog](https://opencode.ai/changelog)); la v2.4.0 del mismo día introdujo automations, video, navegador integrado y MCP Events.

---

## Evidencia — mapa de capacidades V2

### 1. Configuración jerárquica y recarga en caliente

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 1.1 | `opencode.jsonc` con `$schema: https://opencode.ai/config.json`; JSON/JSONC; niveles sistema → global → proyecto (directo y `.opencode/`), con `.opencode` ganando sobre el directo y el sistema ganando sobre todos. | [Config — Format/Locations/Schema](https://opencode.ai/docs/config/) | **Hipótesis:** serviría para expresar los perfiles de agente y permisos del repo como configuración portátil en la máquina, reforzando ADR-0024 (comunidad en la máquina, no invadir el repo destino). Requiere validación de T4/architect. |
| 1.2 | Sustitución de variables `{env:VAR}` y `{file:ruta}` dentro de strings JSON, para secretos fuera del archivo. | [Config — Variables](https://opencode.ai/docs/config/) | **Hipótesis:** alinea S-1/S-2 si se adopta; **no** sustituye al gestor de secretos ni autoriza a leer credenciales (S-2). Requiere visto bueno de T7/security. |
| 1.3 | Recarga automática de comandos y cambios de configuración: "Saving this file updates `/review` without restarting OpenCode"; los cambios bajo directorios de config vigilados se recargan automáticamente; el changelog v2.4.0 aclara que la config se recarga solo cuando cambia un archivo que la alimenta, no ante cualquier escritura bajo `.opencode`. | [Commands — Loading](https://opencode.ai/docs/commands/), [Plugins — Reload](https://opencode.ai/docs/plugins/), [changelog v2.4.0](https://opencode.ai/changelog) | **Hipótesis:** permitiría editar definiciones de roles y comandos sin reiniciar sesiones, reduciendo fricción en las iteraciones del loop; el matiz v2.4.0 evita recargas espurias al editar un skill. |
| 1.4 | Endpoint `POST /api/location/reload` (Reload configuration) y evento `config.updated`. | [API — Location](https://opencode.ai/docs/api/), [API — V2Event](https://opencode.ai/docs/api/) | **Hipótesis:** gancho para que un orquestador propio recargue configuración de forma controlada y auditable; T6 debe evaluarlo, sin ejecutar comandos de la doc. |
| 1.5 | `experimental.subagent_depth` (por defecto 1: un subagente no lanza otro); `experimental.location_idle_timeout` (por defecto 60 min); `experimental.todo` (herramienta `todowrite`, por defecto false). Experimental = puede cambiar o desaparecer sin aviso. | [Config — Experimental](https://opencode.ai/docs/config/) | **Hipótesis:** `subagent_depth` traduce directamente la recursión controlada `KAZEN_AGENT_DEPTH`/`KR_MAX_DEPTH`; **pero** es experimental y no debe gobernar una regla K sin ADR humano. `location_idle_timeout` es candidato a estudio de coste, no a activación. |

### 2. Agents y subagents

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 2.1 | Un agente = system prompt + modelo + permisos + metadatos. Definible en `.opencode/agents/<nombre>.md` (frontmatter + cuerpo = `system`) o bajo `agents` en JSONC. Rutas anidadas forman el ID (`team/reviewer`). | [Agents](https://opencode.ai/docs/agents/) | **Hipótesis:** mapeo 1:1 con `.kaizen/org/prompts/<id>.md` (45 puestos). El archivo Markdown permitiría conservar la definición como plantilla; requiere decidir fuente de verdad para no duplicar gobernanza (K-1). |
| 2.2 | Modos `primary`, `subagent`, `all`. Los subagentes corren en sesiones hijas con contexto fresco, **siempre en background**, y el padre recibe un `<subagent>` message al quedar idle y tras cada ronda posterior. Permiso `subagent` controla qué IDs puede lanzar el padre. | [Agents — Modes](https://opencode.ai/docs/agents/), [Tools — Subagent](https://opencode.ai/docs/tools/) | **Hipótesis:** coincide con el patrón de delegación usado en esta investigación; permitiría endurecer el permission `subagent` para impedir bucles (nunca lanzarse a uno mismo ni a kaizen-installer). T7 debe verificar. |
| 2.3 | Built-ins visibles: `build` (primary), `plan` (primary), `general` (subagent), `explore` (subagent); ocultos de mantenimiento `compaction`, `title`, `summary`. **V2 no tiene agente `scout` integrado.** Los built-ins se pueden sobrescribir por ID. | [Agents — Built-ins](https://opencode.ai/docs/agents/) | **Hipótesis:** `kaizen-scout` es una herramienta propia del framework, **no** un built-in de OpenCode; no debe asumirse su existencia fuera de este repo. `explore` cubre parte del rol de exploración. |
| 2.4 | Opciones por agente: `description`, `mode`, `model` (`provider/model#variant`), `system`, `permissions`, `steps` (tope de pasos, quita herramientas al final), `hidden` (visibilidad, **no** seguridad), `disabled`, `color`, `request` (headers/body: la doc advierte que V2 preserva estos valores pero aún no los envía en las peticiones al modelo). | [Agents — Options](https://opencode.ai/docs/agents/) | **Hipótesis:** `steps` y `permissions` son los candidatos más concretos para acotar autonomía por rol; `request` **no** debe usarse hoy para controlar temperatura por agente (la doc lo desaconseja implícitamente). |
| 2.5 | Reglas de fusión: escalares tardíos reemplazan; mapas de request se fusionan por clave; reglas de permisos se **añaden**; globales se aplican antes de las del agente. | [Agents — Merging](https://opencode.ai/docs/agents/) | **Hipótesis:** requiere cuidado con el orden de capas para que un permiso global no sea reforzado accidentalmente por una excepción posterior; T7 debe modelar el orden. |

### 3. Skills

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 3.1 | `SKILL.md` en `.opencode/skills/<id>/` con `name`/`description`; scripts y referencias junto al skill; rutas relativas al directorio que contiene `SKILL.md`. Descubrimiento en `~/.config/opencode/skills`, `.claude/skills`, `.agents/skills`, `.opencode/skills`; el ID lo da la ruta (no el frontmatter `name`). | [Skills — Create/Discovery/IDs](https://opencode.ai/docs/skills/) | **Hipótesis:** los skills de la comunidad son portátiles entre OpenCode, Claude Code y `.agents/`; T9 podría usarlos como canal de difusión sin escribir en el repo destino (ADR-0024). |
| 3.2 | Catálogos HTTP: array `skills` con URL base + `index.json`; rutas same-origin y seguras; subir `version` para refrescar caché. Consolidación de Console workspace. | [Skills — Sources/Catalogs](https://opencode.ai/docs/skills/) | **Hipótesis:** posible distribución centralizada de guías; **riesgo** de supply chain y de contenido externo no confiable (S-15/L-5) → evaluación obligatoria de T7 antes de cualquier uso. |
| 3.3 | Carga bajo demanda con la herramienta `skill` y el ID exacto; solo se anuncian ID/nombre/descripción por step, el cuerpo se inyecta al cargar; `metadata.opencode/autoinvoke: false` o `disable-model-invocation: true` ocultan el skill del modelo sin dejar de registrarlo. Permiso `skill` con efecto `allow`/`ask`/`deny`. | [Skills — Loading/Permissions](https://opencode.ai/docs/skills/) | **Hipótesis:** la carga diferida reduce consumo de contexto frente a incluir 45 definiciones en cada prompt; requiere medir antes/después (L-9) y no es evidencia de ahorro. |
| 3.4 | Precedencia por ID: el registro posterior gana; Lua/Console/apt: built-in → `.claude` → `.agents` → global → proyecto → entradas explícitas `skills`. | [Skills — Precedence](https://opencode.ai/docs/skills/) | **Hipótesis:** evita duplicados accidentales de skills con el mismo nombre entre capas; exige convención de IDs `kebab-case` único. |

### 4. Comandos (slash commands)

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 4.1 | `.opencode/commands/*.md` → `/nombre`; rutas anidadas → `/team/review`; frontmatter `description`, `agent`, `model`, `subagent`; `$ARGUMENTS` y `$1`, `$2`, ...; bloques `!`\`comando\`` inyectan salida de shell **fuera del flujo de permisos de herramientas** (la doc advierte: solo usar comandos de fuentes confiables). | [Commands](https://opencode.ai/docs/commands/) | **Hipótesis:** formalizar `/standup`, `/retro`, `/check` como comandos versionados; **pero** los bloques shell son un riesgo S-4/S-10: jamás insertar argumentos no confiables en ellos. Requiere T7. |
| 4.2 | `subagent: true` ejecuta en sesión hija en background; `false` fuerza la sesión actual; omitido = hijo solo si el agente es `subagent`. `subtask` es alias deprecado; si ambos están, gana `subagent`. | [Commands — Background/Fields](https://opencode.ai/docs/commands/) | **Hipótesis:** permite mover tareas del loop a background sin cambiar el agente principal; se debe usar `subagent`, nunca `subtask`. |
| 4.3 | Prioridad: proyecto > global, más cercano > ancestro; un comando propio puede reemplazar a uno built-in; recarga automática al guardar. | [Commands — Loading](https://opencode.ai/docs/commands/) | **Hipótesis:** un comando `kaizen` propio podría sombrear a otro sin tocar rutas protegidas; revisar K-4/K-7 antes.de adoptar. |

### 5. Plugins: hooks, tools y transforms

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 5.1 | Un plugin es un paquete con partes opcionales **Server** (`.`), **TUI** (`./tui`), **GUI** (`./gui-experimental`) y **RPC** (`./rpc`); una dependencia `@opencode/plugin`; carga desde `.opencode/plugins/` o array `plugins` en config. | [Building plugins](https://opencode.ai/docs/build/plugins/) | **Hipótesis:** un plugin propio podría concentrar la lógica de gobernanza Kaizen sin editar el repo destino; **pero** instalar plugins de terceros requiere aprobación humana (S-15) y revisión S-9. |
| 5.2 | Control de plugins: prefijar ID/wildcard con `-` para desactivar, `*` para todos, `.*` para prefijo; un ID posterior reactiva. Dos built-ins ignoran eliminación: `opencode.config.policy` y `opencode.provider.opencode` (no se puede apagar el enforcement de políticas desde un repo). | [Plugins — Control](https://opencode.ai/docs/plugins/) | **Hipótesis:** es un análogo técnico de las rutas protegidas L-4; útil como defensa en profundidad, no como sustituto de la gobernanza humana. |
| 5.3 | Versionado/actualización: `name@latest`, rangos (`^1.2.0`, `1.x`), ramas Git, `semver:`; chequeo al arranque y cada 24 h; si la versión nueva falla al cargar se mantiene la anterior. Nombre suelto o hash = fijado. | [Plugins — Manage/Reload](https://opencode.ai/docs/plugins/), [changelog v2.4.0](https://opencode.ai/changelog) | **Hipótesis:** el auto-update es un riesgo de supply chain (S-9); **hipótesis contraria**: fijar versiones exactas y usar `plugin check` manual. T7 debe decidir, con humano. |
| 5.4 | **Transforms**: ediciones sincrónicas y repetibles del estado del dominio (agent, model, provider, command, integration, mcp, reference, skill, tool, vcs, worktree, websearch) vía `ctx.<dominio>.transform(editor => ...)`; `reload()` reaplica transforms tras cambiar entradas externas; `registration.dispose()` revierte; cada petición captura un snapshot estable de herramientas. | [Server plugins — Transforms](https://opencode.ai/docs/build/plugins/server/) | **Hipótesis:** permite inyectar las reglas K/S como transforms auditables en lugar de parchear prompts; encaja con ADR-0024 si el plugin vive en la máquina. Requiere ADR y humano antes de activar. |
| 5.5 | **Tools**: `ctx.tool.transform` con `editor.namespace()`, `add/update/remove`, `options.codemode`, entrada JSON Schema, `context.progress`, `context.signal` para cancelación; freeform `text`/`regex`/`lark`. `list()`/`get()` solo fuera de un callback. | [Server plugins — Tools](https://opencode.ai/docs/build/plugins/server/) | **Hipótesis:** exponer utilidades Kaizen propias (p. ej. validación de descriptor) como herramienta tipada; T6/T7 deben revisar permisos declarados por la herramienta. |
| 5.6 | **Hooks**: `ctx.session.hook("fork"|"prompt"|"context"|"compaction"|"generate"|"title", cb)`. El hook `prompt` puede reescribir texto, añadir archivos y cambiar `delivery` de `steer` a `queue` **antes** de la admisión durable; los hooks `context`/`compaction`/`generate`/`title` modifican system, mensajes, herramientas u opciones solo de la llamada saliente. Múltiples plugins se ejecutan en orden de registro; los hooks `prompt` deben ser retry-safe (no son límite de exactamente-una-vez). | [Server plugins — Hooks](https://opencode.ai/docs/build/plugins/server/) | **Hipótesis:** un hook `prompt` podría aplicar saneado de secretos y recordatorio de reglas K antes de cada turno; **riesgo**: altera la entrada persistida del usuario → exige humano y trazabilidad (K-10/L-12). |
| 5.7 | `ctx.permission.assert(...)` evalúa reglas de sesión (incluidas aprobaciones guardadas) y puede pedir aprobación; `deny` o rechazo con feedback produce un `Tool.Error` que el modelo ve; `ctx.session.update({ permissions })` reemplaza reglas de sesión y los hijos las heredan al crearse. | [Server plugins — Permissions](https://opencode.ai/docs/build/plugins/server/) | **Hipótesis:** traduce el veto vinculante de security/architect y los acuses `expects_ack` a un mecanismo técnico; no sustituye al humano en sensible (L-3). |
| 5.8 | Almacenamiento durables JSON por plugin (`ctx.storage.get/set/remove/scan`); eventos `ctx.event.subscribe({ types })` (los plugins dentro del servidor **no** reciben `server.connected`); RPC tipado con `./rpc`. | [Server plugins — Storage/Events](https://opencode.ai/docs/build/plugins/server/), [Client — Plugin RPC](https://opencode.ai/docs/build/client/) | **Hipótesis:** posibilitaría un buzón local con correlación y eventos `config.updated`/`permission.asked` para observabilidad; **no** debe duplicar el buzón S-11 sin decisión arquitectónica. |

### 6. MCP y OAuth

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 6.1 | Servidores `local` (stdio) y `remote` (Streamable HTTP) bajo `mcp.servers.<nombre>`; V2 **no** pone nombres directamente bajo `mcp`; `disabled` (no `enabled`) mantiene configurado sin conectar; `{env:NAME}` para secretos (no se expande `$NAME` en strings JSON). | [MCP servers — Config/Local/Remote](https://opencode.ai/docs/mcp-servers/) | **Hipótesis:** el MCP `opencode_console` que ya usa este entorno muestra el patrón; la comunidad podría declarar sus MCP en config de máquina, no en el repo ajeno. |
| 6.2 | OAuth por defecto en remotos con PKCE, descubrimiento y refresco; credenciales **fuera** de la configuración del proyecto. Pre-registro con campos snake_case V2 (`client_id`, `client_secret`, `scope`, `callback_port`, `redirect_uri`, `auth_server_metadata_url`); CIMD y DCR como métodos alternos. | [MCP servers — OAuth](https://opencode.ai/docs/mcp-servers/) | **Hipótesis:** útil si se conecta un MCP de Gaceta Oficial; **riesgo**: tokens y OAuth en ámbito sensible → humano y T7 obligatorios. |
| 6.3 | Code Mode **por defecto**: herramientas agrupadas bajo `tools.<servidor>.<tool>`; `codemode: false` las expone directamente. Permisos por `<server>_<tool>`, por `opencode_list_mcp_resources`/`opencode_read_mcp_resource`. | [MCP servers — Names/Permissions/Resources](https://opencode.ai/docs/mcp-servers/), [Tools — Extensions](https://opencode.ai/docs/tools/) | **Hipótesis:** el catálogo Code Mode reduce el consumo de contexto al no listar cada herramienta; debe medirse (L-9), no asumirse. |
| 6.4 | Protocolo: `legacy` (default, hasta 2025-11-25), `auto` (prueba `server/discover` para revisión 2026-07-28 y cae a legacy), `2026-07-28` (exige la revisión nueva). `pool: true` comparte conexión entre directorios solo en la revisión nueva. Timeouts `startup`/`catalog`/`execution`. | [MCP servers — Protocol version/Shared connections/Timeouts](https://opencode.ai/docs/mcp-servers/) | **Hipótesis:** `pool` podría abaratar el monitoreo multi-proyecto local; **advertencia** de la doc: `auto` sobre servidor local legacy añade proceso efímero y puede esperar hasta el timeout de startup. |
| 6.5 | El ID de sesión se envía como metadata `_meta["ai.opencode/sessionID"]`; la doc advierte: identifica la sesión invocadora, **no** usar por sí solo para autenticación/autorización; servidores remotos reciben el ID crudo. | [MCP servers — Context](https://opencode.ai/docs/mcp-servers/) | **Hipótesis:** patrón de correlation-id para mensajes del equipo; **no** debe reemplazar al `correlation_id` firmado de `.kaizen/team/COMUNICACION.md`. T7 debe dictaminar. |

### 7. Permisos y policies

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 7.1 | Reglas ordenadas `{action, resource, effect}` con `allow`/`ask`/`deny`; **la última regla que coincide gana**; wildcards `*` y `?`; sin coincidencia → `ask`. Cualquier `deny` en una operación multi-recurso la niega. | [Permissions — Rules/Matching](https://opencode.ai/docs/permissions/) | **Hipótesis:** puede expresar "deny git push" y "ask .env" de forma declarativa, complementando L-3/L-4; requiere T7 y validación. |
| 7.2 | Acciones V2: `read`, `edit`, `glob`, `grep`, `shell`, `subagent`, `skill`, `question`, `webfetch`, `websearch`, `generate_image`, `external_directory`, `<server>_<tool>`, `opencode_*_mcp_resource`, `execute`. `doom_loop` y `lsp` **no** son acciones V2. `shell` se apoya en un scanner (bash/zsh/sh/PowerShell); la doc advierte que `eval` u sintaxis mal formada puede no analizarse y prefiere allowlists estrechas. | [Permissions — Actions/Scanner](https://opencode.ai/docs/permissions/) | **Hipótesis:** `external_directory` y `shell` son los controles que mejor traducen "no rutas protegidas" y "no push a main"; **no** sustituyen a la verificación humana. |
| 7.3 | Política base de todo agente: `{*: *: allow}` más `ask` para `*.env` y `*.env.*`, `allow` para `*.env.example`. Agentes ships añaden: `plan` niega ediciones salvo `~/.opencode/plan`; `general` niega preguntas y subagentes; `explore` niega todo salvo shell/lecturas/glob/grep/web; `title` y `summary` niegan todo. | [Permissions — Defaults](https://opencode.ai/docs/permissions/) | **Hipótesis:** el default `allow` amplio confirma que la seguridad no puede darse por sentada; refuerza la necesidad de T7 con evidencia. |
| 7.4 | Aprobaciones del cliente: `once`, `always` (guarda patrón **project-scoped**, nunca anula un `deny`), `reject`. Non-interactive clients deben decidir cómo responder. | [Permissions — Approvals](https://opencode.ai/docs/permissions/) | **Hipótesis:** `always` puede acumular reglas laxas con el tiempo → hipótesis de control: revisar periódicamente `/api/permission/saved`. |
| 7.5 | **Policies** separadas de permissions: binarias, nunca preguntan, solo **restringen**. Acciones: `provider.use`, `tool.use`, `integration.connect`, `integration.use`, `mcp.use`, `skill.use`, `plugin.use`, `websearch.use`. Última coincidencia gana; precedencia invertida (la configuración más amplia gana: managed > sistema > Console > global > directo > `.opencode`). Un `allow` en `tool.use` **nunca** concede acceso, solo levanta un `deny` previo. | [Policies](https://opencode.ai/docs/policies/), [Config — Policies](https://opencode.ai/docs/config/) | **Hipótesis:** es el mecanismo más cercano a "deny-by-default con allowlist por agente" para la comunidad; permite que un repo no re-habilite lo que la máquina prohibió (ADR-0024). T7/architect deben decidir con humano. |
| 7.6 | Console compila sus policies Providers/Tools a statements `policies`; cambios se aplican en el siguiente fetch (~1 min); cliente sin conexión conserva los últimos statements. La doc advierte: las policies **no** sandboxed código de plugin. | [Policies — Console](https://opencode.ai/docs/policies/) | **Hipótesis:** útil para gobernanza central, pero depende de un servicio externo (S-15); no sustituye a ADR-0023/0024 ni al humano. |

### 8. API HTTP (OpenAPI 3.1.0)

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 8.1 | Superficie HTTP **experimental**: 178 operaciones y 528 schemas derivados de un documento OpenAPI 3.1.0. | [API](https://opencode.ai/docs/api/), [openapi.json](https://opencode.ai/docs/openapi.json) | **Hipótesis:** base para un conector propio (T6) sin depender de la TUI; **riesgo**: many rutas marcadas `experimental`, pueden cambiar → fijar versión y no construir gobernanza crítica sobre ellas. |
| 8.2 | Rutas de interés para este proyecto: `/api/location/reload`, `/api/agent`, `/api/command`, `/api/skill`, `/api/session/{id}/prompt`, `/api/session/{id}/command`, `/api/session/{id}/revert/{stage,commit}`, `/api/session/{id}/compact`, `/api/session/{id}/context`, `/api/permission/*`, `/api/worktree`, `/api/vcs/*`, `/api/event`, `/api/mcp`, `/api/plugin/*`, `/api/experimental/automation`, `/api/experimental/job`. | [API — Server/Session/Permission/Worktree/VCS/Event](https://opencode.ai/docs/api/) | **Hipótesis:** `/api/event` podría alimentar la observabilidad local (Grafana/Prometheus) con eventos `session.*`, `permission.asked`, `config.updated` en lugar de parsear logs; T6 debe validar。 |
| 8.3 | Esquemas para correlación: `Session.Event.Durable` enumera `session.inbox.*`, `session.execution.*`, `session.tool.*`, `session.compaction.*`, `session.revert.*`; `V2Event` incluye `permission.asked/replied`, `config.updated`, `plugin.updated`, `worktree.updated`, `filesystem.changed`. | [API — Schemas](https://opencode.ai/docs/api/) | **Hipótesis:** nombres estables para un adaptador de eventos del buzón; requiere verificar que un evento no se convierta en instrucción (L-5). |
| 8.4 | Rutas `POST /api/experimental/generate` aparecen marcadas como **deprecated path**; preferir `/api/experimental/generate/text`. | [API — Generate](https://opencode.ai/docs/api/) | **Hipótesis:** T6 debe usar solo la ruta `text`; no recomendar la genérica. |

### 9. Cliente `@opencode/client`

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 9.1 | Cliente TypeScript de la API HTTP; tipos generados del mismo contrato que la API reference. `OpenCode.make({ baseUrl, headers })`, recursos agrupados (`client.session.*`, `client.event.*`, `client.rpc`). | [Build — Client](https://opencode.ai/docs/build/client/) | **Hipótesis:** candidato para el conector T6; tipado generado reduce desviación entre doc e implementación. |
| 9.2 | Eventos: iterables asíncronos; **live-only, sin replay ni reconexión automática**; el último suscriptor cierra la conexión; `server.connected` siempre llega incluso con filtro `types`. Los consumidores deben hacer buffer antes de trabajo lento. | [Build — Client — Stream events](https://opencode.ai/docs/build/client/) | **Hipótesis:** obligaría a diseñar resync explícito en el adaptador de eventos; **no** asumir durabilidad. |
| 9.3 | RPC tipado: importar contrato de `opencode-acme-plugin/rpc`, `client.rpc(Acme)`, `acme.events.on/subscribe`. El servidor debe configurar e implementar el RPC; importar la definición **no** lo registra. Cualquier HTTP client puede llamar `POST /api/rpc/{rpcID}/{method}`. | [Build — Client — Plugin RPC](https://opencode.ai/docs/build/client/) | **Hipótesis:** permitiría exponer acciones Kaizen (standup, verify) como métodos tipados; requiere plugin servidor y humano. |
| 9.4 | Servicio local Node: `@opencode/client/service` con `Service.discover()`, `Service.ensure()`, `Service.stop()`, `Service.headers()`; `version` acepta exacta o predicado (`v => v.startsWith("2.")`). | [Build — Client — Local background service](https://opencode.ai/docs/build/client/) | **Hipótesis:** facilitaría un arranque controlado del servicio para CI local; **no** debe implicar gasto ni exponer credenciales. |
| 9.5 | Nota de compatibilidad: las rutas de utilidades de sesión en Code Mode pasaron a `tools.opencode.session.rename` / `.move` ([changelog v2.4.0](https://opencode.ai/changelog)); los nombres directos de herramienta y las acciones de permiso no cambiaron. | [changelog v2.4.0](https://opencode.ai/changelog) | **Hipótesis:** cualquier script propio debe usar la nueva ruta; no citar la antigua. |

### 10. SDK `@opencode/sdk`

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 10.1 | Hospeda OpenCode **dentro** de la aplicación: ensambla servidor y rutas en memoria, **sin listener HTTP ni salto de red**. `OpenCode.create()` devuelve un host explícito; liberar con `await using` o `close()`. Misma API Promise, streams `AsyncIterable` y aliases `sessions`/`events`. | [Build — SDK](https://opencode.ai/docs/build/sdk/) | **Hipótesis:** Permitiría pruebas deterministas del framework sin levantar un servidor ni gastar red; ideal para tests de regresión L-6. |
| 10.2 | Worktrees desde el SDK: `opencode.worktree.create/refresh/remove({ projectID, ... })`; create/refresh cargan config y plugins del checkout canónico guardado. | [Build — SDK — Worktrees](https://opencode.ai/docs/build/sdk/) | **Hipótesis:** se alinea con los worktrees `wt-issue-<N>-<rol>` del swarm; T6/T4 deben evaluar si sustituye o complementa `scripts/kaizen-swarm`. |
| 10.3 | Personalización: registrar plugins en `OpenCode.create({ plugins: [plugin] })`; `ctx.agent.transform` sobre `build`; `opencode.plugin(plugin)` después de arrancar. Variante Cloudflare Durable Objects documentada aparte. | [Build — SDK — Customize](https://opencode.ai/docs/build/sdk/), [Cloudflare](https://opencode.ai/docs/build/sdk/cloudflare/) | **Hipótesis:** un "runtime Kaizen" embebido podría aplicar transforms de gobernanza en memoria; requiere ADR, humano y revisión de seguridad. |

### 11. Características nuevas / emergentes (V2.4.x)

| # | Capacidad (source-backed) | URL oficial | Hipótesis de valor para kaizen-swarm (NO hecho) |
|---|---|---|---|
| 11.1 | **Warming**: keep-alive de caché de prompt, desactivado por defecto; `auto` = 90 % de `cache.ttl` (o 4 min), ventana por defecto 30 min; no aplica a subagentes; no muta historial ni despacha tools; fallos se loguean sin romper sesión; **consume requests reales, tokens, coste y rate limits**. | [Warming](https://opencode.ai/docs/warming/), [Config — Warming](https://opencode.ai/docs/config/) | **Hipótesis:** **no** activar por defecto: el coste es real y el proyecto prohíbe gastar; solo study con humano y métrica L-9. |
| 11.2 | **Snapshots**: `/undo` y `/redo` revierten conversación **y archivos** juntos; captura best-effort antes/después de cada step; cubre archivos tracked y untracked ≤2 MiB del directorio activo dentro de un worktree Git; **no** revierte efectos de shell, DB, commits ni archivos ignorados; requiere Git; almacenamiento en DB Git interna (tratar como dato sensible); activados por defecto, `snapshots: false` los desactiva. | [Snapshots](https://opencode.ai/docs/snapshots/) | **Hipótesis:** complemento de L-7 (cambios reversibles), **pero** no es backup ni transacción; no debe confundirse con el rollback de `scripts/kaizen-swarm`. |
| 11.3 | **Compaction**: resumen automático al acercarse al límite; `keep.tokens` por defecto 15000; `buffer` 15 % (mínimo 16k) del contexto; resumen local por defecto o `settings.compaction.type: native` por provider/model; resumen en background (`compaction.background`, por defecto true) con coste incluso si no se usa; `agents.compaction.model` permite otro modelo; idempotencia pasando `id`. | [Compaction](https://opencode.ai/docs/compaction/), [Config — Compaction](https://opencode.ai/docs/config/) | **Hipótesis:** relevante para sesiones largas de investigación; el resumen ya estructurado (Objetivo / Next Move) encaja con el formato de reporte a El Presidente; medir coste antes de activar native. |
| 11.4 | **ACP**: `opencode acp` expone OpenCode como agente del Agent Client Protocol v1 sobre JSON-RPC por stdin/stdout; servidor privado, sin puerto de red; capabilities: loadSession, MCP http, imágenes, fork/list/resume; `additionalDirectories` con grants heredados por hijos; eventos de child sessions con `_meta["opencode/child-session"]` (id, parentID, depth, title); reporta compaction y usage (tokens/coste) a clients que lo anuncian. | [CLI — ACP](https://opencode.ai/docs/cli/acp/) | **Hipótesis:** permitiría a Zed u otros clientes ACP consumir los agentes del equipo; los `depth` y `child-session` proveen trazabilidad para la recursión controlada. |
| 11.5 | **Harnesses de Console**: Claude Code, Codex, Hermes, Pi y Raycast pueden apuntar al gateway de Console con API key; reciben modelos, **policies verificadas antes de cada tool call**, MCP servers, skills e instructions del workspace; `--keep-provider` conserva la suscripción propia; Console MCP en `https://opencode.ai/console/mcp` con OAuth DCR. Modelos gratuitos solo dentro de OpenCode (403 en otros harnesses). | [Console — Harnesses](https://opencode.ai/docs/console/harnesses/) | **Hipótesis:** this_session corre bajo Codex/harness; el patrón sugiere que las reglas podrían viajar con el workspace; **pero** gasto y datos externos → humano (L-3/L-4) y sin credenciales en chat. |
| 11.6 | **Automations** (nuevo en v2.4.0): prompts, Code Mode scripts o shell commands en timer, intervalo, cron o evento push de MCP; `/automation`; acción shell pide aprobación **una vez al crear** y registra exit code/output por ejecución; `automations: false` las desactiva. | [changelog v2.4.0](https://opencode.ai/changelog) | **Hipótesis:** candidato para standups/retros y para monitor-gaceta; **riesgo**: ejecución no supervisada de shell → requiere humano, allowlist estrecha y registro S-11. |
| 11.7 | **MCP Events / browser integrado / generate_video** (v2.4.0): seguimiento de MCP Events beta con heartbeats y reconexiones; navegador persistente en Desktop; generación de video en background; extensión Effects. Config se recarga solo ante archivos que la alimentan (v2.4.0). | [changelog v2.4.0](https://opencode.ai/changelog) | **Hipótesis:** el browser integrado podría servir a `reverse-api-specialist` solo con humano y sin credenciales en pantalla (ADR-0017/0018); video y browser quedan fuera del alcance actual. |

---

## Campos y nombres deprecados — NO recomendar (source-backed)

| No usar | Usar en V2 | URL oficial |
|---|---|---|
| `experimental.policies` | `policies` (toplevel) | [Config — Deprecated policies](https://opencode.ai/docs/config/), [Policies](https://opencode.ai/docs/policies/) |
| `permission`, `bash`, `task` (V1) | `permissions`, `shell`, `subagent` | [Permissions — warning](https://opencode.ai/docs/permissions/) |
| `subtask` en comandos | `subagent` | [Commands — Fields](https://opencode.ai/docs/commands/) |
| frontmatter V1 de agentes | campos V2 (`mode`, `system`, `permissions`, ...) | [Agents — Formats](https://opencode.ai/docs/agents/) |
| `temperature`, `top_p`, `prompt`, `permission`, `tools`, `disable`, `maxSteps` a nivel superior en agents | configuración en provider/model/variant (la doc advierte que `request` aún no se envía al modelo) | [Agents — Options/Request](https://opencode.ai/docs/agents/) |
| `integration.use` con prefijos `mcp:`, `skill:`, `plugin:` (pre-2.2.3) | `mcp.use`, `skill.use`, `plugin.use` (requiere cliente ≥2.2.3) | [Policies — Upgrading](https://opencode.ai/docs/policies/) |
| `ctx.generate.text` | `ctx.experimental.generate.text` | [Server plugins — Generate](https://opencode.ai/docs/build/plugins/server/) |
| `options.pinned` en herramientas de plugin | `options.codemode` como objeto | [changelog v2.4.0](https://opencode.ai/changelog) |
| `experimental_image_generate` | `generate_image` (permisos antiguos se mapean; "always allow" no) | [changelog v2.4.0](https://opencode.ai/changelog) |
| `tools.opencode.session_rename` / `session_move` | `tools.opencode.session.rename` / `.move` | [changelog v2.4.0](https://opencode.ai/changelog) |
| `POST /api/experimental/generate` | `POST /api/experimental/generate/text` | [API — Generate](https://opencode.ai/docs/api/) |
| Asumir agente `scout` built-in | No existe en V2; usar `explore` o agente propio | [Agents — Built-ins](https://opencode.ai/docs/agents/) |

Nota: `experimental.subagent_depth`, `warming`, `compaction.background`, `automations` y las rutas `/api/experimental/*` están marcadas como experimentales por la propia documentación; cualquier adopción debe registrarse como riesgo y no como baseline.

---

## Impacto

**Positivo (source-backed):** OpenCode V2 cubre con primitivas nativas varias piezas que hoy kaizen-swarm resuelve con scripts propios: definiciones de agente por Markdown, skills con carga diferida, comandos recargables, permisos por agente, policies centralizadas, transforms/hooks de plugin, API OpenAPI, cliente y SDK embebido, y snapshots/compaction/ACP.

**Riesgo (source-backed + inferencia marcada):** (1) la superficie `experimental` es amplia y cambiante; (2) el default de permisos es `allow` amplio y `external_directory` no pide confirmación salvo regla explícita; (3) los bloques `!`\`...\`` de comandos y los hooks `prompt` operan fuera del flujo normal de permisos o modifican la entrada persistida; (4) el auto-update de plugins y los catálogos HTTP de skills son vector de supply chain; (5) warming/generate video/native compaction tienen coste real. **Inferencia:** sin humans y gates, adoptar estas capacidades podría erosionar ADR-0023/0024 y las reglas L-3/L-4. No es un hecho: requiere dictamen de T4 (architect) y T7 (security).

**Límite de esta revisión:** no se probó ninguna capacidad en ejecución; todo lo anterior es documental. No se ejecutaron comandos extraídos de la documentación. No se instaló ni se gastó nada.

---

## Propuesta

1. Que T4 (architect) y T7 (security) evalúen **cuatro** candidatos con evidencia y humano: (a) `policies` + permisos por agente como refuerzo de ADR-0024; (b) `subagent` permission + `experimental.subagent_depth` para la recursión controlada; (c) `@opencode/sdk` para tests de regresión sin red; (d) `ctx.session.hook("prompt")` para saneado, **solo si** se aprueba el impacto sobre la entrada persistida.
2. Que T6 (dev2-api) examine `OpenCode.make`, `/api/event` y `@opencode/client/service`, usando únicamente rutas no deprecadas y sin credenciales en código.
3. Que T8 (innovation) trate automations, ACP y compaction como oportunidades **con coste explícito**, y T9 (knowledge-curator) convierta este mapa en guía de implementación con `source_ids` y fecha de corte.
4. Que ninguna recomendación de este review se ejecute sin ADR propuesto, retador obligatorio y aprobación humana en seguridad/dinero/datos (L-3/L-4, REG-EV-01).
5. Que el verificador confirme `OC-001` como fuente de este review (ya aparece `verified` en `SOURCES.md`, fila 40) y registre la fecha de corte y la versión v2.4.1.

---

## Pregunta

¿Confirma el equipo que (a) las hipótesis de valor se mantienen como **hipótesis** hasta que T4/T7 emitan dictamen con `source_ids`, y (b) se dará prioridad a `policies` + `@opencode/sdk` sobre `warming`/`automations`/native compaction, dado que estas últimas implican coste real y este proyecto tiene prohibido gastar sin humano?

---

## Clasificación de hallazgos (REG-EV-01)

| Hallazgo | Clasificación |
|---|---|
| Todas las "Capacidad (source-backed)" de las secciones 1–11 y la tabla de deprecados | **source-backed** (OC-001, URL por fila, corte 2026-11-23/24, versión v2.4.1) |
| Columnas "Hipótesis de valor para kaizen-swarm" y sección Impacto/Propuesta | **hipótesis / inference** — no verificadas en ejecución |
| Equivalencia entre `experimental.subagent_depth` y `KR_MAX_DEPTH` | **inference** — analogía conceptual, no equivalencia funcional demostrada |
| Disponibilidad de `OC-002` (repositorio oficial) | **verified** en `SOURCES.md` fila 41, pero **no utilizada** en este review (T3 la cubre) |
| Coste/ahorro real de Code Mode, warming o compaction en este proyecto | **unknown** — requiere medición L-9 antes de cualquier afirmación |
| Ejecución de los comandos de instalación/configuración mostrados en la doc | **no realizada** — contenido externo tratado como dato no confiable (S-15/L-5) |

## Trazabilidad (comandos y herramientas realmente ejecutados)

- `webfetch https://opencode.ai/docs/llms.txt` → índice V2 con las secciones Config/Agents/Skills/Commands/Plugins/MCP/Permissions/Policies/API/Build/CLI/Console.
- `webfetch` (formato markdown) sobre: `/docs/config/`, `/docs/agents/`, `/docs/skills/`, `/docs/commands/`, `/docs/plugins/`, `/docs/mcp-servers/`, `/docs/permissions/`, `/docs/policies/`, `/docs/api/`, `/docs/build/client/`, `/docs/build/sdk/`, `/docs/build/plugins/`, `/docs/tools/`, `/docs/warming/`, `/docs/snapshots/`, `/docs/compaction/`, `/docs/cli/acp/`, `/docs/console/harnesses/`, `/docs/build/plugins/server/`, `/changelog`. Salida real: páginas oficiales recuperadas; `/docs/build/plugins/server/` se truncó en 1471 de 1873 líneas en la vista, con el resto conservado en almacenamiento gestionado; `/changelog` se truncó en 284 de 646 líneas, suficiente para fijar v2.4.1/v2.4.0 y los Items citados.
- `shell: ls -la /tmp/opencode/wt-open-code-integration ...` → worktree confirmado; `reviews/` no existía y se creó con este entregable.
- `shell: scripts/kaizen-team ack analisis-opencode-oficial H-OC-20261124020855-2` → salida real: `[kaizen-team] ack registrado: H-OC-20261124020855-2`, `EXIT=0`.
- `read` de `tasks.json`, `charter.md`, `plan.md`; `grep` de `SOURCES.md` (filas OC-001/OC-002 `verified`) y `handoffs.jsonl`. Solo lectura.
- No se ejecutó `websearch`: el handoff reporta HTTP 402 en el entorno; se usó exclusivamente `webfetch` contra `opencode.ai`, en cumplimiento de la regla de la skill OpenCode (sin búsqueda general).
- No se ejecutaron los comandos `opencode ...`, `bun add ...`, `npm publish`, `npx @opencode/console setup ...` ni cualquier otro extraído de la documentación. No se instalaron dependencias, no se hicieron llamadas a modelos de pago, no se modificó estado del proyecto ni se hizo push.
- Meta-auditoría (solo lectura, verificada en el código del script antes de ejecutarla): `scripts/kaizen-meta drift` → salida real `[block] drift-git: local=7a6a4b17 origin=407ed833`, `DRIFT_EXIT=1`. **Deriva informativa**: este worktree apunta a una rama de tarea, no a `origin/main`; no es un síntoma de este review y no se corrigió (fuera de alcance y de propiedad).
- `scripts/kaizen-meta close` → salida real: `AttributeError: 'int' object has no attribute 'strip'` en `scripts/kaizen-meta:81` (`ok = rc == 0 and out.strip() == local.strip()`), `CLOSE_EXIT=1`. **Hallazgo (kind: failure)**: `cmd_close()` desempaqueta `local, _, _ = sh("git rev-parse HEAD")` tomando el código de salida como si fuera la salida; `cmd_drift()` en la línea 67 sí usa `_, local, _`. Corrección sugerida (no aplicada): invertir el desempaquetado en la línea 80. **No se escribió entrada S-11** porque el handoff prohíbe modificar otros archivos ni estado; se reporta a T10 (facilitador) para que el orquestador lo registre.

**Status: APPROVE** — el mapa cubre todas las áreas solicitadas con URL oficial por afirmación, usa solo V2, evita campos deprecados (los lista como excluidos) y marca cada hipótesis como no verificada. Queda pendiente la validación humana/ADR de T4 y T7 para cualquier adopción.
