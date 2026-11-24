---
id: REV-SEC-T7-20261123
correlation_id: analisis-opencode-oficial
channel: review
intent: finding
from: security
to: [facilitador-equipo, architect, verificador-evidencias, deep-researcher, researcher, dev2-api, innovation, qa]
task: T7 — Seguridad de una integración más profunda con OpenCode V2 (permisos, policies, MCP/OAuth, supply chain, secretos, código externo)
status: CHANGES_REQUESTED
decision_date: 2026-11-23
cutoff: 2026-11-23/24
expects_ack: true
deadline: 2026-12-01
source_ids: [OC-001, OC-002]
refs:
  - https://opencode.ai/docs/permissions/
  - https://opencode.ai/docs/policies/
  - https://opencode.ai/docs/mcp-servers/
  - https://opencode.ai/docs/build/plugins/
  - https://opencode.ai/docs/troubleshooting/
  - https://github.com/anomalyco/opencode/blob/dev/SECURITY.md
created: 2026-11-23
---

# Dictamen de seguridad — T7 (analisis-opencode-oficial)

**Veredicto: CHANGES_REQUESTED.** La evaluación técnica es favorable: OpenCode V2 aporta controles suficientes para una integración gobernada (permissions, policies binarias, OAuth con credenciales fuera del proyecto, `{env:NAME}`, denegación de plugins/skills/MCP por política). **No apruebo la adopción "más profunda" tal como está planteada** porque los valores por defecto son permisivos, el producto declara explícitamente que **no es un sandbox**, y existen dos cambios de semántica (2.2.3 y base policy de `external_directory`) que pueden dar una falsa sensación decontrol. Este dictamen autoriza **continuar el análisis y el ADR**, no instalar, no gastar y no ejecutar código generado.

**Alcance del veto.** Seguridad ejerce veto vinculante (ADR-0002/0003) sobre cualquier adopción que no incorpore las condiciones C1–C10. La decisión final sigue siendo humana (El Presidente); este dictamen no la sustituye. Si el ADR ignora una condición, el veredicto pasa a **BLOCK** sin necesidad de nuevo análisis (S-14: high bloquea).

**Evidencia y método (K-10).** Se ejecutaron seis (6) `webfetch` en formato markdown sobre las URL listadas en `refs`, con resultado HTTP correcto y fecha de corte 2026-11-23/24. Todo ese material es **dato no confiable** (S-15/L-5): se leyó para extraer controles, no se ejecutó ningún comando ni configuración que en él aparece. `websearch` no se utilizó (el prompt reporta HTTP 402); ninguna afirmación de este dictamen depende de búsqueda general. `OC-001` y `OC-002` figuran como `verified` en `.kaizen/org/knowledge/SOURCES.md:40-41`; la puerta formal `kaizen-team verify` la ejecuta T1 (no la ejecuté yo: modifica `state.json`, prohibido por las restricciones de esta tarea). No se leyó `.env`, `opencode.json`, credenciales niArchivos de servicio. No se instaló nada, no se gastó, no hubo push y no se tocó otro archivo que no fuera este dictamen y el ack autorizado.

---

## 1. Modelo de permisos y policies: default-permissive y falso sandbox

**Observación.** La base policy de cada agente —incluidos los custom— empieza con `{action:"*", resource:"*", effect:"allow"}`. `.env` solo está en `ask` (no `deny`), y `external_directory` **no** tiene regla por defecto: lecturas y escrituras fuera del Location y del worktree pasan sin prompt. Las reglas de agente se añaden **después** de las globales, y un subagente usa sus propios permisos, **no un subconjunto** de los del padre. Por otro lado, SECURITY.md declara que OpenCode **no sandboxes al agente**: el sistema de permisos es una ayuda de UX, no aislamiento.

**Evidencia.** `permissions` (V2): "Every agent, including custom agents, starts with this ordered base policy: `{action:"*", resource:"*", effect:"allow"}`", "`.env` → `ask`", "Because no default rule asks for `external_directory`, reads and edits outside the Location and worktree proceed without a prompt", "A custom subagent uses its own permissions, not a subset of its parent's permissions", "the last matching rule wins", "`shell` runs with the host user's filesystem, process, and network authority… prefer a narrow shell allowlist". SECURITY.md §Threat Model: "OpenCode does **not** sandbox the agent… it is not designed to provide security isolation. If you need true isolation, run OpenCode inside a Docker container or VM" (OC-001/OC-002).

**Impacto.** Confiar en `permissions` como control de seguridad dejaría la integración expuesta a: escritura fuera del worktree sin prompt, subagentes más privilegiados que su padre, y ejecución con la autoridad completa del usuario del host. Es un riesgo **high** si se adoptan flujos de autonomía 3 sin endurecimiento (L-3/L-4, ADR-0023).

**Propuesta.** (1) Definir un perfil `security-baseline` en config con `policies` —no solo `permissions`— para las líneas rojas: `tool.use shell:* deny` con allowlist estrecho (`git status *`, `git diff *`), `tool.use read:*/.ssh/* deny`, `tool.use external_directory:* deny`, `tool.use edit:*.env deny`, `tool.use webfetch:* deny` salvo dominios permitidos, `execute deny` para el rol `security`. (2) Añadir regla explícita `external_directory` `ask`/`deny` con excepciones nominales; nunca `*` abierto. (3) Revisar `agents.<id>.permissions` de **cada** subagente y fijar el mismo baseline: herencia no garantizada. (4) Revisar y borrar periódicamente los "Allow always": se guardan como reglas `allow` duraderas del proyecto (aunque nunca pueden vencer un `deny`). (5) Usar V2 correcto: `permissions`/`shell`/`subagent` (no V1 `permission`/`bash`/`task`). (6) Documentar en el ADR que, si se requiere aislamiento real, se ejecuta en contenedor/VM sin root (S-16) y que el permiso no sustituye al diseño.

**Pregunta.** ¿Incluirá el ADR (T4) el perfil `policies` como **control obligatorio** y reconocerá explícitamente que `permissions` no es sandbox, en lugar de presentarlo como mitigación de seguridad?

---

## 2. Policies: pináculo, precedencia inversa y el cambio 2.2.3

**Observación.** Las policies son binarias, nunca preguntan y **solo pueden apretar**: `allow` no otorga acceso, solo levanta un `deny` anterior. Precedencia inversa a la configuración normal (la config más amplia se evalúa después y gana): managed preferences > sistema > Console > global > proyecto > `.opencode/`. Console y managed prevalecen sobre el repo. Los statements inválidos se **descartan con un warning en el log**. Además, antes de 2.2.3 `integration.use` con prefijos `mcp:`/`skill:`/`plugin:` cubría extensiones; desde 2.2.3 un `integration.use: *` **ya no bloquea** MCP/skills/plugins y en cambio bloquea providers; los clientes <2.2.3 ignoran las acciones nuevas.

**Evidencia.** `policies` doc: "Policies are separate from permissions… only ever tighten", "When several statements match, the last one wins", "Managed configuration and the connected Console always outrank user and project files", "Statements that fail validation are dropped with a warning in the server log", "A repository cannot re-enable a provider you deny globally", "Clients older than 2.2.3 ignore `integration.connect`, `integration.use`…, `mcp.use`, `skill.use`, and `plugin.use`". Sección "Upgrading from `integration.use`": un deny amplio de `integration.use` "no longer blocks MCP servers, skills, or plugins. Instead it blocks every provider".

**Impacto.** Un equipo puede creer que prohibió plugins/MCP con una regla que, tras actualizar, hace otra cosa (fail-open por cambio de semántica). Un typo en un `deny` puede quedar ignorado sin que nadie lo vea si no se revisa el log: equivaldría a una supresión silenciosa (S-10).

**Propuesta.** (1) Fijar versión mínima **≥ 2.2.3** (y ≥ 2.2.6 si se usa `websearch.use`) como requisito de cualquier integración; verificar con `opencode --version`. (2) Migrar toda regla V1/2.2.2 a `mcp.use`/`skill.use`/`plugin.use` explícitos; prohibir `integration.use: *` como sustituto de control de extensiones. (3) Tras cada edición de policies, revisar el log `role=server` buscando el warning de statements descartados; si aparece, la edición **falla** y se corrige (S-10: nada se silencia). (4) Poner las líneas rojas en managed/system/Console, no solo en el repo del proyecto, para que un repo no pueda revertirlas. (5) Añadir al runbook una comprobación de que el deny sigue activo tras actualizaciones de cliente (prueba de regresión L-6/L-9).

**Pregunta.** ¿Confirmarán T1 y T4 la versión instalada/objetivo y que ninguna policy actual depende de la semántica antigua de `integration.use` antes de citar el control como mitigación?

---

## 3. MCP y OAuth: credenciales fuera del proyecto, OAuth primero

**Observación.** Los servidores remotos usan OAuth por defecto con PKCE y guardan credenciales **fuera de la configuración del proyecto**. Cuando un servidor solo acepta API key se usa `oauth: false` con headers; la forma correcta de referenciar secretos es `{env:NOMBRE}` (las expansiones `$NOMBRE` **no** funcionan dentro de strings JSON). Los clientes pre-registrados permiten `client_id`/`client_secret` vía `{env:...}`. Los servidores locales admiten `command` —frecuentemente `npx -y ...`— y `environment`. El ID de sesión se envía a servidores remotos en `_meta["ai.opencode/sessionID"]` y la propia doc advierte que no debe usarse para autenticación/autorización y que el servidor remoto puede registrarlo. `execution` timeout por defecto: **12 horas**.

**Evidencia.** `mcp-servers` doc: "Remote servers use OAuth by default… Credentials are stored outside project configuration", "Use `{env:NAME}` for environment substitution. Shell expressions such as `$NAME` are not expanded in JSON strings", "Store secrets in environment variables rather than in the file", "Use `oauth: false` only when the server exclusively uses an API key or another header credential", "`client_secret`: Secret for a confidential client…", "Do not use it [sessionID] by itself for authentication or authorization… Remote servers receive the raw ID and may log or retain it", "execution 12 hours", y el ejemplo `["npx", "-y", "example-mcp-server"]`. SECURITY.md §Out of Scope: "MCP server behavior — External MCP servers you configure are outside our trust boundary".

**Impacto.** Pegar un `client_secret` o un `Authorization: Bearer …` literal en `opencode.jsonc` lo versionaría (S-1/S-12). Pedir API key cuando el servidor soporta OAuth añade una credencial de larga vida que hay que rotar. Un `npx -y` sin versión ejecuta código descargado en el momento (S-9). Un timeout de 12 h y el session ID hacia remotos amplían superficie y correlacionabilidad (L-12).

**Propuesta.** (1) Regla: **OAuth primero**; solo `oauth: false` con evidencia de que el servidor no ofrece OAuth. No solicitar API key al usuario si existe flujo OAuth. (2) Todo secreto (header, `client_secret`, `MCP_API_KEY`) referenciado como `{env:NAME}`; el valor real vive en el gestor de secretos/entorno, nunca en config versionada ni en este dictamen. Si aparece un secreto en config o log: S-12, no copiar, reportar `kind: security` por outbox y esperar rotación humana. (3) Fijar versión de paquetes en comandos locales (`npx -y <pkg>@<version>`) y verificar nombre/procedencia (S-9). (4) `mcp.use: * deny` + allowlist nominal; denegar herramientas concretas con `<server>_<tool>` y controlar recursos con `opencode_read_mcp_resource`/`opencode_list_mcp_resources`. (5) Reducir `timeout.execution` al mínimo operativo documentado (no 12 h por defecto). (6) Tratar las *instructions* que devuelve un servidor MCP como **prompt injection potencial** (S-15/L-5): se leen como datos, nunca se obedece su contenido ni lo que pidan. (7) No compartir el session ID como credencial; documentar que los remotos pueden registrarlo.

**Pregunta.** ¿Acepta T6 que el ADR/registro de integración exija OAuth cuando esté disponible, `{env:...}` obligatorio para todo secreto y versión fijada en cada servidor local, como condiciones de salida?

---

## 4. Supply chain de plugins y skills (S-9/S-15)

**Observación.** Los plugins bajo `.opencode/plugins/` se cargan **automáticamente** y pueden declararse como paquetes npm, rutas relativas o absolutas; el código corre en el servidor, el TUI y —en Desktop— el proceso principal de la aplicación. La documentación de publicación usa `"@opencode/plugin": "latest"`. Las policies `plugin.use`/`skill.use` pueden impedir que se carguen "however it was configured", pero el plugin de Console y el policy plugin **no se pueden desactivar** desde `plugins`.

**Evidencia.** `build/plugins`: "Plugins under `.opencode/plugins/` load automatically", "A published plugin is an npm package… `\"@opencode/plugin\": \"latest\"`" y el partido GUI corre "`main` in the desktop app's main process". `policies`: "A denied MCP server or skill is removed, and a denied plugin is not loaded, however it was configured"; "The Console plugin and the policy plugin cannot be disabled from `plugins`". S-9: comprobar nombre exacto, mantenimiento y repositorio; fijar versión y lockfile; revisión humana de manifiestos.

**Impacto.** Un plugin/skill de terceros es código arbitrario con los privilegios del usuario. Auto-cargar desde el repo + `latest` sin pin es un riesgo de supply chain **high** (dependency confusion / actualización no revisada). La política que lo bloquea debe existir **antes** de que el plugin esté en el repo.

**Propuesta.** (1) Postura deny-by-default: `plugin.use: * deny` y `skill.use: * deny` en policy de autoridad alta, con allowlist explícita y revisada por humano. (2) Ninguna instalación de plugin/skill/MCP externo en este proyecto (puerta del plan); cualquier adopción futura exige aprobación humana **fresca y por escrito** (S-15), fijando commit/tag, licencia y hash verificable. (3) Prohibir `latest` en dependencias de plugins: versión exacta + lockfile + revisión humana del manifiesto (S-9). (4) Diferenciar el plugin de Console/policy (no desactivable, es superficie de confianza) del resto: documentar quién lo gestiona. (5) Registrar cada extensión permitida en `SOURCES.md` con `source_id`, versión y hash.

**Pregunta.** ¿Registrará el arquitecto la postura deny-by-default de plugins/skills como restricción explícita del ADR y confirmará que ninguna recomendación de T8/T9 propone instalar extensiones sin aprobación humana?

---

## 5. Secretos en logs, diagnóstico y archivos de servicio (S-1/S-8/S-12/S-13)

**Observación.** Los logs se escriben en `~/.local/share/opencode/log/opencode.log` e incluyen `run` y `role=server` (sesiones, providers, plugins, permisos, herramientas). Las herramientas de diagnóstico son explícitamente sensibles: los heap snapshots "pueden contener prompts, contenido de archivos y credenciales"; los perfiles CPU/memoria y las instantáneas de Desktop también. SECURITY.md define server mode como opt-in y pide `OPENCODE_SERVER_PASSWORD`; sin él corre sin autenticar (con aviso). La doc de troubleshooting pide eliminar API keys, authorization headers, prompts y contenido de archivos antes de compartir logs.

**Evidencia.** `troubleshooting`: "The snapshot can contain prompts, file contents, and credentials. Do not share it publicly", "Remove API keys, authorization headers, prompts, file contents, and other sensitive data before sharing logs", privacidad del session ID ya citada, `service.json`/`opencode.db` con `OPENCODE_DB`, y que `opencode api` puede iniciar el servicio. SECURITY.md §Server Mode: "set `OPENCODE_SERVER_PASSWORD` to require HTTP Basic Auth. Without this, the server runs unauthenticated (with a warning)".

**Impacto.** Pegar un fragmento de log o un heap snapshot en un issue público filtraría credenciales y datos de usuario (S-1/S-8/S-12/S-13, L-12, REG-EV-06). Inspeccionar/editar la base de datos o los archivos de servicio sin backup puede destruir estado; **este agente no debe leerlos** (S-2).

**Propuesta.** (1) Prohibido versionar o pegar logs, CPU profiles, heap snapshots ni `service.json`/`opencode.db`; si se comparten, primero `kaizen-security redact` y verificación con búsquedas que no impriman valores (`grep -l`/`grep -q`). (2) Ningún comando de diagnóstico (`debug heap-dump`, `SIGUSR1`, `SIGPROF`, `opencode api`) en este proyecto: no hay incidencia que lo justifique y puede iniciar servicios. (3) Si se habilita server mode en el futuro: `OPENCODE_SERVER_PASSWORD` obligatorio, CORS con orígenes exactos (`service set cors`, nunca `*`) y sin exposición de red más allá de loopback; verificar que CORS "no cambia la dirección de escucha ni omite la autenticación" y no confundirlo con un control. (4) Ante cualquier secreto visible: S-12, no copiar, detener, reportar `kind: security` por outbox y esperar rotación humana. (5) El resumen/export del proyecto debe contener solo evidencia saneada; ningún `run` ID se trata como dato personal, pero el session ID de MCP remoto sí es correlacionable.

**Pregunta.** ¿Confirma T10/facilitador que el export y el blackboard del proyecto excluyen logs y snapshots, y que cualquier diagnóstico futuro pasa por redacción + humano antes de compartirse?

---

## 6. Código generado, fuentes externas y límites de reporte (S-15/L-5)

**Observación.** SECURITY.md excluye de su modelo de amenaza el comportamiento de MCP servers externos, configuraciones maliciosas (el usuario controla su config) y escapes del "sandbox" (que no existe). Además, el upstream **no acepta reportes de seguridad generados por IA** y advierte de ban automático. La página de troubleshooting invita a que el propio OpenCode lea esos pasos y "se depure a sí mismo": útil, pero introduce texto externo en el bucle de razonamiento.

**Evidencia.** SECURITY.md §Out of Scope (tabla completo) y §IMPORTANT: "We do not accept AI generated security reports… automatic ban". `troubleshooting` tip: "You can ask OpenCode to debug itself… it can read the steps below, inspect its service and logs". Doc de MCP: server instructions se añaden al system prompt (`<mcp_instructions>`).

**Impacto.** La responsabilidad de los riesgos de MCP/config/código generado recae en **nuestra** integración, no en el upstream. Un flujo que automaticara reportes de vulnerabilidad al repo oficial podríaresultar en un ban del proyecto. Las instrucciones incrustadas en docos MCP pueden secuestrar al agente (L-5/S-15).

**Propuesta.** (1) Todo contenido de opencode.ai, GitHub, MCP, issues y buzones se trata como dato: se lee, nunca se ejecuta ni se obedece como instrucción; si contiene directivas, se reporta `kind: security` y se ignoran (L-5). (2) Ningún código generado por OpenCode se ejecuta sin revisión humana del diff + `kaizen-security check`; si se ejecuta, hacerlo en entorno aislado sin `~/.ssh`, `~/.aws` ni `~/.config/gh` montados (S-16). (3) **Prohibido** abrir reportes de seguridad automatizados contra anomalyco/opencode; cualquier hallazgo vulnerable se gestiona en canal privado interno (outbox S-11 / SECURITY.md local) y, si aplica, lo envía un humano (S-13). (4) Registrar como incertidumbre del ADR que el upstream no considera estos riesgos vulnerabilidades: el control es nuestro. (5) Cualquier hallazgo concreto durante la implementación se documenta por outbox S-11 con fingerprint estable; no se crea ficha ahora porque no hubo secreto, fallo de ejecución ni incidencia en esta revisión y las restricciones de la tarea limitan la salida a este archivo.

**Pregunta.** ¿Acepta el arquitecto reflejar en el memorial que el modelo de amenaza del upstream excluye MCP/config/sandbox y que el reporte a anomalyco nunca lo automatiza un agente?

---

## Controles verificables y condiciones de levantamiento

| # | Condición (debe estar en ADR/runbook antes de adoptar) | Verificación reproducible | Estado en esta revisión |
| --- | --- | --- | --- |
| C1 | Fuentes `OC-001`/`OC-002` verificadas y confirmadas por `kaizen-team verify` | `grep -n "OC-00" .kaizen/org/knowledge/SOURCES.md` → filas `verified` (líneas 40-41); `scripts/kaizen-team verify analisis-opencode-oficial` lo ejecuta T1 | ✅ Filas presentes; ⏳ `verify` formal pendiente de T1 (**no ejecutado aquí**: modifica `state.json`) |
| C2 | Versión mínima ≥ 2.2.3 (≥ 2.2.6 si `websearch.use`) | `opencode --version` + registro en `SOURCES.md` | ⏳ Pendiente de T4/T1 |
| C3 | Perfil `policies` con deny de shell amplio, `.ssh`, `external_directory`, `*.env`, `execute`; allowlist estrecho | Inspección de `opencode.json(c)` + `policies` doc | ⏳ Pendiente de ADR |
| C4 | `external_directory` con regla `ask`/`deny` explícita y subagentes revisados | grep de `external_directory` y `agents.*.permissions` | ⏳ Pendiente de ADR |
| C5 | OAuth primero; secretos solo `{env:NAME}`; versión fijada en `npx` | Revisión de config: 0 literales `Bearer`/`client_secret`/API keys | ⏳ Pendiente de T6 |
| C6 | `mcp.use`/`skill.use`/`plugin.use` deny-by-default + allowlist; sin `integration.use: *` como control de extensiones | `policies` doc §"MCP servers, skills, and plugins" + diff de config | ⏳ Pendiente de ADR |
| C7 | Sin instalación de plugins/skills/MCP; aprobación humana fresca para cualquier adopción futura | `git status` + blackboard (no hay registro de instalación) | ✅ Sin instalación en esta revisión; ⏳ aprobación futura |
| C8 | Logs/snapshots/profiles nunca versionados ni compartidos sin redacción; sin diagnóstico aquí | `git status` + revisión del export | ✅ Sin artefactos generados |
| C9 | Código generado Solo tras revisión + `kaizen-security check`, en entorno aislado | Runbook pendiente; ningún código ejecutado en esta revisión | ⏳ Definición pendiente de T6 |
| C10 | Sin push, sin gasto, sin tocar rutas protegidas (L-4); ack de handoff registrado | `git status --short`; `kaizen-team ack … H-OC-20261124020855-7` | ✅ Ack emitido por seguridad al cierre de esta revisión |

**Para levantar CHANGES_REQUESTED:** C1–C10 deben estar cerradas con evidencia reproducible en `blackboard.md` y referenciadas en `reviews/architect.md` + ADR. Seguridad reemitirá el dictamen con `status: APPROVE` y `supersedes` apuntando a este id. Mientras tanto, el veto sigue activo para cualquier adopción operativa.

**Pasa a BLOCK automáticamente si:** (a) se instala plugin/skill/MCP o se ejecuta código generado sin revisión; (b) aparece un secreto en config, log, snapshot o mensaje; (c) se usa `integration.use: *` como control de extensiones o se depende de cliente <2.2.3; (d) se habilita server mode sin `OPENCODE_SERVER_PASSWORD`; (e) un agente abre un reporte de seguridad automatizado contra el upstream; (f) se ignora una política denegada o se silencia su warning de validación.

---

## Nota de alcance y K-10

Este dictamen **no** aprueba la instalación de OpenCode V2, la creación de MCPs/plugins, el gasto, la ejecución de código generado ni la publicación de definiciones de agente. Aprueba únicamente continuar el análisis Documental y la propuesta de ADR bajo las condiciones anteriores. No se fabricó evidencia: las seis fuentes se obtuvieron por `webfetch` real, `verify` no se ejecutó por modificar estado, y no se realizó ninguna instalación, captura, diagnóstico ni ejecución de código. No se hallaron secretos ni supresiones nuevas, por lo que no se abrió ficha de outbox (S-11/S-12) y no se publicaron detalles explotables (S-13).
