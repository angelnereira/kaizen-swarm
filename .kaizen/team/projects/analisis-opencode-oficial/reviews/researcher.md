---
id: REV-RESEARCH-OC-T3
correlation_id: analisis-opencode-oficial
channel: review
intent: finding
from: researcher
to: [facilitador-equipo, verificador-evidencias, architect, security, all]
task: T3 analisis del repositorio oficial anomalyco/opencode
handoff: H-OC-20261124020855-3
status: CHANGES_REQUESTED
expects_ack: true
deadline: 2026-12-01
source_ids: [OC-001, OC-002]
fecha_corte: 2026-11-23/24
created: 2026-11-24T02:26:22Z
---

# Dictamen researcher — T3

**Status: CHANGES_REQUESTED** · `source_ids: [OC-001, OC-002]` · fecha de corte 2026-11-23/24 · rama `kaizen/open-code-integration`.

> Mapeo canónico según `SOURCES.md:40-41`: **OC-001 = documentación oficial** (`opencode.ai/docs/`, índice `llms.txt`); **OC-002 = repositorio oficial** (`anomalyco/opencode`). Se encontró un review contemporáneo que rotula el repo como `OC-001`; corregir en consolidación (ver Impacto).

## Observación

### 1. Estructura del repositorio (OC-002)

La página raíz confirma: rama `dev`, **23.247 commits** (el `plan.md` registraba 23.246: deriva temporal, no disputa de fuente), 228,8 k stars, 31,1 k forks, 881 watchers, 2,7 k issues y 1,3 k PR; licencia MIT. Carpetas raíz: `.github`, `.husky`, `.opencode`, `.vscode`, `.zed`, `nix`, `packages`, `patches`, `salesforce`, `script`, `sdks/vscode`, `services`, `specs/v2`; archivos raíz: `AGENTS.md`, `CHANGELOG.md`, `CONTRIBUTING.md`, `LICENSE`, `SECURITY.md`, `bun.lock`, `bunfig.toml`, `flake.lock`, `flake.nix`, `install`, `package.json`, `strobe.json`, `tsconfig.json`, `turbo.json` y 22 `README.<idioma>.md`. (OC-002, `https://github.com/anomalyco/opencode`)

- `packages/` (~36 workspaces): `ai`, `app`, `cli`, `cli-rs`, `client`, `codemode`, `core`, `data`, `desktop`, `gui-plugins`, `http-recorder`, `httpapi-codegen`, `identity`, `latex`, `merman`, `nav-menus`, `patchmark`, `plugin`, `plugin-browser`, `plugins`, `process-daemon`, `protocol`, `schema`, `script`, `sdk`, `server`, `session-ui`, `simulation`, `stories`, `theme`, `tui`, `ui`, `util`, más `effect-drizzle-sqlite/examples/...`. (OC-002, `/tree/dev/packages`)
- `services/`: `data`, `files`, `legacy`, `site` (sitio opencode.ai **y la documentación V2**) y `update`, desplegados con Cloudflare/Wrangler y workflows de Actions. Nota menor: el `services/README.md` nombra el servicio `updates` pero el directorio es `update`. (OC-002, `/tree/dev/services`)
- `specs/v2/`, `sdks/vscode/`, `script/` y `patches/` existen y están verificados en la página raíz (OC-002). `script/` contiene lint/typecheck/pack/ast-grep/sdk-docs según los scripts de `package.json`; `patches/` sostiene ~21 `patchedDependencies` (p. ej. `@modelcontextprotocol/client@2.4.0`, `solid-js@1.9.17`, `vite@8.2.4`, `electron-updater@6.8.9`). (OC-002, `/blob/dev/package.json`)
- Monorepo Bun: `version: 2.4.1`, `private: true`, `packageManager: bun@1.4.4`, workspaces `packages/*`, `packages/plugins/*`, `services/*`, `packages/data/*`; guardrail `test: echo 'do not run tests from root' && exit 1`; lint con `oxlint` + `ast-grep` + comprobación de docs del SDK. (OC-002, `/blob/dev/package.json`)

### 2. Motor de extensiones (OC-002 + OC-001)

- **Plugins**: el repo expone `packages/plugin`, `packages/plugins`, `packages/gui-plugins` y `packages/plugin-browser` (OC-002, `/tree/dev/packages`). Los docs describen configuración por `opencode.jsonc` con paquetes npm/versionados/scoped/rutas locales/`file://`, capas de precedencia, descubrimiento en `.opencode/plugins/`, desactivación con `-` y comodines, CLI `opencode plugin add|list|check|update|remove`, auto-actualización de `name@latest`/rangos/ramas Git cada 24 h con rollback a la versión previa si falla la carga, y dos plugins integrados que ignoran eliminaciones (`opencode.config.policy`, `opencode.provider.opencode`) para no poder desactivar políticas. (OC-001, `/docs/plugins/`)
- **Agents**: perfiles Markdown/JSONC con `mode: primary|subagent|all`, permisos `allow|ask|deny`, `steps`, `hidden`, `disabled`, `subagent` por ID y subagentes siempre en background; aviso de que `request` se preserva pero **aún no se envía** en V2. (OC-001, `/docs/agents/`)
- **Skills**: `SKILL.md` con `description`, descubrimiento global/proyecto y compatibilidad `.claude`/`.agents`, catálogos HTTP con `index.json` versionado, IDs derivados de ruta (case-sensitive), precedencia y carga mediante la herramienta `skill`, con permiso `skill` por ID. (OC-001, `/docs/skills/`); el repo refleja el soporte en `specs/v2/tools.md` y en notas de release de v2.3.0/v2.4.1 (OC-002, `/releases`).
- **MCP**: `mcp.servers` con servidores `local`/`remote`, OAuth PKCE con CIMD/DCR, timeouts `startup`/`catalog`/`execution`, `pool`, `codemode` por defecto `true`, eventos y permisos por `<servidor>_<herramienta>`; el `sessionID` viaja en `_meta` como correlación opaca, **no como autenticación**. (OC-001, `/docs/mcp-servers/`); el repo incluye `packages/process-daemon` (`@opencode/pty`) y parchea `@modelcontextprotocol/client@2.4.0` (OC-002, `/blob/dev/package.json`).

### 3. Contrato V2 (OC-002)

`specs/v2/README.md` define autoridad por preocupación, no por archivo: **Protocol** (`packages/protocol/src` + `HttpApi` del Server) para operaciones HTTP y errores de transporte; **Schema** (`packages/schema/src`) para formas de dominio públicas y payloads de eventos duraderos; **Core** (`packages/core/src`) para comportamiento runtime y persistencia; **AGENTS.md** raíz para guardrail de regresión de colaboradores. Contratos corrientes: `Session` (admisión de prompt, ejecución, instrucciones, compactación, recuperación) y `Tools` (construcción, registro, ejecución y leyes de resultado). Registros de decisión: *Event stream* y *Provider policy* (aceptados e implementados; este último con sentencias administradas por Console con autoridad final) y *Claude Agent provider* (**Draft**). Histórico: *Catalog/config/plugin lifecycle*. Regla explícita: los clientes generados siguen el `HttpApi` público ensamblado; los issues de GitHub poseen el trabajo activo y el historial Git preserva planes retirados. (OC-002, `/blob/dev/specs/v2/README.md`)

### 4. Gobernanza (OC-002)

- **MIT**: `LICENSE` = MIT License, `Copyright (c) 2025 opencode`; `package.json` declara `"license": "MIT"`. (OC-002, `/blob/dev/LICENSE`, `/blob/dev/package.json`)
- **CONTRIBUTING.md**: cambios más aceptables = bugfixes, LSP/formatters, rendimiento LLM, fixes de entorno, comportamiento estándar faltante y documentación; UI y features de producto requieren *design review*; proveedores nuevos se añaden primero a `models.dev`; PR pequeños, basados en `dev`, con títulos `type(scope): summary` (`feat|fix|docs|chore|refactor|test`), `Fixes/Closes #N` cuando aplica; se rechazan descripciones largas generadas por IA y se marcan issues con "AI-generated walls of text" con 2 h para corregir; los clientes generados nunca se editan a mano (`bun run generate` en `packages/client`). (OC-002, `/blob/dev/CONTRIBUTING.md`)
- **SECURITY.md**: **no acepta reportes de seguridad generados por IA** (baneo automático); modelo de amenaza = agente local con shell, archivos y web; **sin sandbox**: el sistema de permisos es una característica de UX, **no aislamiento de seguridad**, y recomienda Docker/VM; modo servidor opcional con `OPENCODE_SERVER_PASSWORD` para Basic Auth (sin él queda sin autenticar con advertencia); fuera de alcance: acceso a servidor habilitado, escapes de sandbox, manejo de datos del proveedor LLM, comportamiento de MCP servers externos y configs maliciosas; reporte vía GitHub Security Advisory y escalado a `security@anoma.ly` tras 6 días hábiles. (OC-002, `/blob/dev/SECURITY.md`)

### 5. Cadencia de releases y señales de estabilidad (OC-002 + OC-001)

Cadencia observada en `/releases`: **v2.4.1 (23 Nov 15:57)**, **v2.4.0 (23 Nov 09:22)**, v2.3.2 (18 Nov 01:35), v2.3.1 (18 Nov 00:17), v1.19.6 (17 Nov 07:21, con insignia **"Latest"** en GitHub), process-daemon v0.6.0 (16 Nov 23:36) y v2.3.0 (13 Nov 08:55): **6 lanzamientos en 11 días**, varios el mismo día. Los releases son inmutables, con attestations y assets con sha256. (OC-002, `/releases`)

Señales positivas: guardrails de lint/typecheck por paquete, regla de cliente generado, specs con tabla de autoridad y registros de decisión, política de seguridad explícita y comunidad grande. Señales de cautela: las notas de v2.4.0/v2.4.1 acumulan cambios rupturistas (renombrado de `experimental_image_generate`→`generate_image`, auto-actualización de plugins, token de Copilot, negociación de protocolo MCP, tema TUI, rutas `tools.opencode.session_rename|session_move`→`tools.opencode.session.rename|.move`,OpenTUI ≥ 0.9.4, carga de plugins en background, ruta de escritura de almacenamiento con flag de reversión `experimental.part_rows: false`); la rama v2 usa tecnología de vanguardia (`effect@4.1.0`, TypeScript 6/7 beta, OpenTUI 0.9.9); `trustedDependencies` y ~21 parches exigen revisión de supply chain; y GitHub marca **v1.19.6** como "Latest" mientras v2.4.1 es la más reciente por fecha: la semántica del canal de release debe confirmarse antes de adoptar. (OC-002, `/releases`, `/blob/dev/package.json`; OC-001, `/docs/`, `/docs/agents/`)

### 6. Conflictos doc/repo (REG-EV-04) — escalado, sin promediar

**C1 — `conflict` (MCP, default de protocolo).** El repo (v2.4.0, upgrade notes) afirma: *"MCP servers are tried on the newest protocol first. A server without a `protocol` setting is probed before falling back to the legacy handshake. Set `protocol: "legacy"` on a server that misbehaves."* (OC-002, `/releases/tag/v2.4.0`). La documentación oficial afirma: *"OpenCode opens every server with the classic MCP `initialize` handshake by default"* y la tabla indica **`legacy` — Default**, con `auto` como opción explícita que prueba `server/discover` (salvo `pool: true`, donde un `protocol` no definido pasa a `auto`). (OC-001, `/docs/mcp-servers/#protocol-version`). **Dos fuentes oficiales difieren sobre el comportamiento por defecto**: no se promedia; se marca `conflict` y se escala a humano/verificador.

**C2 — `conflict` (agentes integrados).** El README del repo dice: *"OpenCode includes two built-in agents ... **build** ... **plan** - Read-only agent ... Denies file edits by default ... Also included is a **general** subagent ... `@general`"* (OC-002, `README.md`). La doc oficial enumera **cuatro** agentes visibles — `build`, `plan`, `general` y **`explore`** — y matiza que `plan` *"may write OpenCode plan files when asked"* (OC-001, `/docs/agents/#built-ins`). Divergencia en el conjunto y en la capacidad de escritura de `plan`; se marca `conflict` y se escala. Esto refuerza el hallazgo de T2 de que `scout` no es un built-in V2.

**C3 — deriva menor (no `conflict` normativo).** README etiqueta el Desktop como **BETA** mientras la doc `/docs/` lo presenta sin esa etiqueta; `services/README.md` nombra `updates` frente al directorio `update`; el plan registraba 23.246 commits frente a 23.247 observados. Se registran como deriva de baja severidad, no como disputa de fuente.

## Evidencia

- `webfetch` (markdown/texto) sobre: `https://github.com/anomalyco/opencode`, `/tree/dev/packages`, `/tree/dev/services`, `/tree/dev/specs/v2`, `/blob/dev/CONTRIBUTING.md`, `/blob/dev/SECURITY.md`, `/releases`, `raw.githubusercontent.com/anomalyco/opencode/dev/{LICENSE,package.json,specs/v2/README.md}`, `https://opencode.ai/docs/llms.txt`, `/docs/`, `/docs/plugins/`, `/docs/skills/`, `/docs/mcp-servers/`, `/docs/agents/`. Salida real recuperada; nada se ejecutó ni instaló.
- `grep -n "OC-00" .kaizen/org/knowledge/SOURCES.md` → filas 40-41, `verified` (OC-001 docs, OC-002 repo). `state.json` en etapa `execute`.
- El verificador ya había abierto `.kaizen/org/research/researcher-20261124-021202.md` (02:12:02Z). Mi intento posterior creó un duplicado vacío (`...-022340.md`) que **fue eliminado**; queda un único expediente canónico del repo. No se modificó `SOURCES.md` ni el estado del proyecto.
- Restricciones cumplidas: sin instalación, sin gasto, sin comandos procedentes del repo, sin push, sin cambios de etapa, sin delegación (`KAZEN_AGENT_DEPTH=1`, `KR_MAX_DEPTH` no alcanzado). Contenido externo tratado como dato no confiable (S-15/L-5); no se ejecutaron los comandos `curl | bash`, `bun install`, `bun dev` ni `opencode plugin add` que aparecen en páginas/README.

## Impacto

- REG-EV-01 está satisfecho para OC-001/OC-002 (filas `verified`), pero **REG-EV-04 no**: C1 y C2 son conflictos entre dos superficies oficiales del mismo proyecto (la documentación V2 vive en `services/site` del propio repo, OC-002). Cualquier ADR que fije un default de MCP o asuma `explore` como built-in quedaría sin base verificable.
- Para T4 (architect): la ADR debe fijar versión exacta **v2.4.1** y tratar los defaults de MCP/agentes como `unknown` hasta resolución; no promediar. Para T7 (security): el ARC de permisos es UX, no aislamiento (S-6/S-16), y los ~21 parches/`trustedDependencies` requieren revisión de supply chain (S-9). Para T6 (dev2-api): las rutas `tools.opencode.session.rename|.move` de v2.4.0 son la forma vigente; el catálogo de Code Mode de este entorno aún presenta `session_move`, lo que es deriva de versión a confirmar en la prueba de integración. Para T9: corregir el mapeo OC-001/OC-002 en la consolidación.
- KPI del charter: 100 % de afirmaciones citadas (OC-001/OC-002 con URL), 0 secretos, 0 comandos ejecutados del repo. Los conflictos se reportan, no se ocultan (S-11 vía este dictamen y el resumen al orquestador; la restricción de "no modificar otros archivos" impide crear una entrada S-11 adicional aquí).

## Propuesta

1. **Registrar C1 y C2 como `conflict` con escalado a El Presidente** (facilitador + verificador), sin elegir un default. Revisar el commit de `services/site` frente a la nota de v2.4.0 y actualizar `retrieved`/expediente (`kaizen-org research`) cuando se resuelva (REG-EV-04/05). Coste: tiempo; riesgo: ninguno si se mantienen ambos como `unknown`; reversibilidad: total; L-9: `#conflictos_resueltos_o_escalados = 2`.
2. **Fijar versión y plugins**: ADR con `v2.4.1` exacto y specs de plugin sin `@latest`/rangos (`plugin check` manual). Coste 0; riesgo: perder parches automáticos; reversibilidad: solo config; L-9: `#plugins_sin_pin = 0`.
3. **Adoptar el patrón de autoridad de `specs/v2`** (Protocol → Schema → Core → guardrails) como plantilla de contratos de kaizen-swarm; 0 dependencias nuevas, reversible por documentación; L-9: `#ADR_con_dueño_por_preocupación ≥ 3`.
4. **Reutilizar skills + MCP con permisos `allow|ask|deny` y `autoinvoke:false`**, sin catálogos HTTP de terceros sin humano (S-15); coste 0; reversible; L-9: `#skills_con_descripción_y_permiso_explícito`.
5. **Aislamiento**: cualquier prueba con OpenCode sobre contenido no confiable ejecutarla en contenedor/VM; `protocol` declarado explícitamente en la config; revisión de `trustedDependencies`/`patches` en T7. Coste: infra local; reversible; L-9: `#perfiles_sin_aislamiento = 0`.
6. **Corregir el etiquetado de fuentes** en la consolidación: repo = OC-002, docs = OC-001 (`SOURCES.md:40-41`).

## Pregunta

¿Confirma el facilitador, con el verificador, que **C1 y C2 se registran como `conflict` y se escalan a El Presidente** (REG-EV-04, sin promediar), y que la ADR de T4 fijará `v2.4.1` con plugins pinned y tratará el default MCP y la existencia de `explore` como `unknown` hasta que la fuente oficial se reconcilie?

---

Ack del handoff `H-OC-20261124020855-3` registrado con `scripts/kaizen-team ack`. Sin push ni fusión.
