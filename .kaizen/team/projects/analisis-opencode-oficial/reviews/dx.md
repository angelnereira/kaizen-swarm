---
id: REV-DX-T5-20261124
correlation_id: analisis-opencode-oficial
channel: review
intent: finding
from: dx
to: [facilitador-equipo, architect, verificador-evidencias]
task: T5 — ergonomía y flujo de trabajo de kaizen-swarm con OpenCode V2
handoff: H-OC-20261124020855-5
status: APPROVE
source_ids: [OC-001]
fecha_corte: 2026-11-23/24
evidence_status: verified
expects_ack: true
deadline: 2026-12-01
created: 2026-11-23
refs:
  - https://opencode.ai/docs/cli/
  - https://opencode.ai/docs/cli/config/
  - https://opencode.ai/docs/cli/keybinds/
  - https://opencode.ai/docs/config/
  - https://opencode.ai/docs/skills/
  - https://opencode.ai/docs/commands/
  - https://opencode.ai/docs/plugins/
  - https://opencode.ai/docs/troubleshooting/
---

# Dictamen DX — T5: ergonomía y flujo con OpenCode V2

**Status: APPROVE (acotado).** Apruebo este mapa de propuestas como **insumo para el ADR de T4** y para los runbooks de K-8. Este APPROVE **no autoriza instalar plugins, skills ni paquetes; no autoriza gasto; no autoriza tocar `.opencode/`, `opencode.json` ni ninguna ruta protegida (L-4); y no sustituye la aprobación humana ni los dictámenes de `architect`/`security`.** Todas las adopciones quedan condicionadas a `kaizen-team verify` en verde y a ADR cuando afecten gobernanza o autonomía (L-3/L-4, ADR-0024).

**Condición de evidencia.** OC-001 figura como `verified` en `.kaizen/org/knowledge/SOURCES.md` con fecha de corte 2026-11-21; la fecha de corte declarada para esta tarea es 2026-11-23/24. Las páginas se consultaron el 2026-11-23/24. **No ejecuté ninguno de los comandos que aparecen en la documentación**: los transcribo como citas documentales, no como evidencia de ejecución (S-15/L-5, K-10). No instalé, no gasté, no modifiqué otros archivos ni estado, no hice push.

---

## Observación

kaizen-swarm ya tiene andamiaje propio para standups, decisiones, verificación, acuses y observabilidad local (`kaizen-team`, `kaizen-voice`, `kaizen-team verify`, Grafana). OpenCode V2 ofrece capacidades nativas que **solapan y pueden reducir el tiempo de feedback de ese flujo**, pero con una trampa importante: parte de la configuración vive en la máquina (`cli.json`) y parte en el proyecto (`opencode.json(c)`); confundirlas mezcla preferencias de TUI con gobernanza de servidor y puede saltarse las puertas humanas del equipo.

Además, la documentación consultada no muestra un comando slash `/reload` explícito: documenta **recarga automática** de comandos/configuración y un keybind `location.reload`. Lo reporto como incertidumbre, no como afirmación (K-10).

## Evidencia (citas documentales, OC-001, 2026-11-23/24)

| # | Fuente (URL) | Fragmento documentado | Uso en este dictamen |
| --- | --- | --- | --- |
| E1 | `https://opencode.ai/docs/cli/config/` | "OpenCode stores CLI settings in one global file: `~/.config/opencode/cli.json` … There is no project-local CLI settings file. Add the published JSON Schema for validation and autocomplete: `{"$schema": "https://opencode.ai/v2/cli.json"}`. … Valid edits reload while the TUI is running. Unknown settings are ignored." | P1, P2 |
| E2 | `https://opencode.ai/docs/config/` | "Put project settings in either `opencode.json(c)` or `.opencode/opencode.json(c)` … OpenCode searches from the current directory to the filesystem root … every discovered `.opencode` config overrides every direct config." Incluye `skills`, `commands`, `permissions`, `policies`, `mcp`, `instructions`, `watcher`, `worktree`, `experimental.subagent_depth`. | P1, P3, P7 |
| E3 | `https://opencode.ai/docs/commands/` | "Create `.opencode/commands/review.md` to turn a prompt into `/review` … OpenCode reloads command files and configuration changes automatically … Saving this file updates `/review` without restarting OpenCode." Campos: `description`, `agent`, `model`, `subagent`, `$ARGUMENTS`, `$1`. Advertencia: "Shell blocks run … outside the agent's tool permission flow. Only use commands from sources you trust." | P2, P3 |
| E4 | `https://opencode.ai/docs/skills/` | "Put a `SKILL.md` file in `.opencode/skills/<skill-id>` … OpenCode advertises this skill when it is relevant. The agent can then load its instructions with the `skill` tool … The list includes only the ID, name, and description, not the full Markdown body." `metadata.opencode/autoinvoke: false`; permiso `{"action": "skill", "resource": "*", "effect": "allow"}`. | P3 |
| E5 | `https://opencode.ai/docs/cli/keybinds/` | "Customize bindings in `cli.json` … `leader` defaults to `ctrl+x`. `<leader>` in another binding refers to that key … Unknown command IDs are ignored." IDs: `location.reload` (none, "Reload configuration"), `service.restart` (none), `prompt.skills` (none), `plugins.list` (none), `command.palette.show` (`ctrl+p`), `session.quick_switch.1`…`9` (`<leader>1`…), `opencode.status` (`<leader>s`). | P2, P4 |
| E6 | `https://opencode.ai/docs/cli/config/` (Plugins, Alerts, Sessions) | "`plugins`: Declares ordered enablement directives and external plugins", ejemplo `-opencode.notifications` y `{"package": "./plugins/status", "options": {...}}`. `attention.sounds` admite `permission`, `question`, `error`, `done`, `subagent_done`. `session.permissions`: `prompt` o `autoaccept`. `debug.turn_tokens`: boolean o `verbose`. `diffs.source`: `branch`/`committed`/`working`/`turn`. | P5, P7 |
| E7 | `https://opencode.ai/docs/plugins/` | "TUI-only plugins are configured separately and remain active when connected to a remote server … `{"plugins": ["opencode-acme-cli"]}`" en `cli.json`. "Plugin entries are processed in order. Prefix an ID or wildcard with `-` to disable it". "Changes under watched config directories reload automatically … Changes to unwatched local dependencies may still require restarting OpenCode." Comandos `opencode plugin add/list/check/update/remove`. | P5 |
| E8 | `https://opencode.ai/docs/troubleshooting/` | "Show the current server information: `opencode service status` … Verify that its API is healthy: `opencode api get /api/info` … Installed builds write logs to `~/.local/share/opencode/log/opencode.log` … Each line includes a process `run` ID and a `role` field … `grep 'role=server'` … Remove API keys, authorization headers, prompts, file contents, and other sensitive data before sharing logs." | P6 |
| E9 | `https://opencode.ai/docs/cli/` | "Use `opencode run` to submit a prompt without opening the interactive interface. It is designed for scripts, CI jobs … `opencode debug paths` … The optional selector accepts `db`, `home`, `data`, `config`, `cache`, `state`, `tmp`, `bin`, `log`, or `repos` … This command does not start a server or open the database." | P6 |
| E10 | `https://opencode.ai/docs/config/` (Experimental) | "`subagent_depth` sets how deeply subagents can start their own subagents. Defaults to `1`, so a subagent cannot start another subagent." Advertencia: "Experimental settings may change, break, or be removed in any release without notice." | P7 |

## Impacto

El KPI de esta especialidad es **tiempo de feedback medido** con **0 afirmaciones sin `source_ids`**. Las brechas que cierran estas propuestas son: (a) editar reglas o comandos obligaba a reiniciar la TUI, (b) los flujos del equipo (standup/verify/decide) se repiten como prompts largos en lugar de comandos con nombre, (c) el estado de un subagente se descubre por polling en vez de por señal, (d) no hay un procedimiento documentado para diagnosticar el servicio compartido con correlación `run`/`role`. **No presento números de antes/después: no ejecuté mediciones en esta iteración (K-10).** Cada propuesta indica cómo medir su mejora (criterio L-9).

---

## Propuestas

### P1 — Separar `cli.json` (máquina/TUI) de `opencode.json(c)` (proyecto/servidor)

**Observación.** Hoy el equipo versiona reglas y flujos en el repo; OpenCode V2 separa nítidamente preferencias de terminal de configuración de servidor/proyecto. Mezclarlas trasladaría preferencias de TUI al código y, peor, permitiría que un archivo de proyecto altere permisos o políticas.

**Evidencia.** E1 y E2: `cli.json` es **único y global** (o `$XDG_CONFIG_HOME/opencode/cli.json`), "no hay archivo local de proyecto", con `$schema: https://opencode.ai/v2/cli.json`; `opencode.json(c)` admite ubicaciones de sistema, globales y de proyecto con precedencia creciente (farthest→closest, y `.opencode` sobre directo).

**Impacto.** Sin esta separación, un cambio de tema o keybind ensucia el diff del proyecto, y un cambio de permisos podría quedar fuera del ADR y del `verify`.

**Propuesta.** Política de configuración para el equipo:
- `~/.config/opencode/cli.json` → tema, keybinds, tabs, diffs, alertas, plugins **de TUI**, debug de tokens. Con `$schema` (E1). Instalación en la máquina, coherente con ADR-0024.
- `opencode.json(c)` → modelo, agentes, comandos, skills, permisos, políticas, MCP, worktrees, instrucciones. Con `$schema: https://opencode.ai/config.json` (E2).
- **No usar `OPENCODE_CLI_CONFIG_CONTENT`** (documentado: "Inline settings remain authoritative while the variable is set"): haría invisible una preferencia para el resto del equipo.

**Beneficio medible.** 0 preferencias de TUI en diffs versionados; 100 % de cambios de servidor/proyecto pasan por ADR+`verify`. Medible con `git diff --name-only` sobre un ciclo de standup.

**Riesgo.** Escribir en `.opencode/` o `opencode.json` del repo viola L-4 → **requiere humano/ADR**; no lo ejecuto. Precedencia no intuitiva: "every discovered `.opencode` config overrides every direct config" (E2) → un archivo olvidado puede anular otro.

**Pregunta.** ¿Confirma el arquitecto (T4) que la política de config entra en el ADR como restricción, de modo que `security` (T7) la refleje en permisos?

---

### P2 — Recarga en caliente: menos reinicios, mismo feedback

**Observación.** La documentación describe tres mecanismos distintos de recarga; el equipo debe saber cuál aplica a cada cambio para no reiniciar de más ni dar por aplicado un cambio que no lo está.

**Evidencia.** E1: "Valid edits reload while the TUI is running". E3: "OpenCode reloads command files and configuration changes automatically … Saving this file updates `/review` without restarting OpenCode". E5: keybind `location.reload` = "Reload configuration", sin atajo por defecto. E7: "Changes under watched config directories reload automatically … Changes to unwatched local dependencies may still require restarting OpenCode", con `opencode service restart` como último recurso.

**Impacto.** Un reinicio innecesario corta sesiones, pierde posición en el transcript e interrumpe handoffs con `expects_ack`.

**Propuesta.** (a) Asignar `location.reload` a un atajo (ver P4). (b) Documentar en el runbook de DX: comandos y `cli.json` → recarga automática; plugins en directorios observados → recarga automática; dependencias locales no observadas → requieren reinicio **con humano**. (c) Medir: contar reinicios de TUI por sesión antes/después, objetivo 0 para cambios de comandos/config.

**Beneficio medible.** Conteo de reinicios por sesión y tiempo desde guardar archivo hasta ver el efecto (L-9). Cero gasto, totalmente reversible (quitar el keybind).

**Riesgo.** `opencode service restart` detiene el servicio compartido; ejecutarlo durante un handoff activo rompe acuses. **No encontré un slash command `/reload` en las ocho páginas consultadas**: solo `location.reload` y la recarga automática. Lo marco como **no verificado** y pido confirmación con OC-001 antes de escribir `/reload` en un runbook (K-10).

**Pregunta.** ¿Puede `verificador-evidencias` confirmar con OC-001 si existe un slash `/reload` en otra página oficial no consultada, o documentamos solo `location.reload`?

---

### P3 — Comandos y skills propios para standup, decide y verify

**Observación.** `kaizen-team standup|decide|verify` y `kaizen-voice` hoy se invocan como prompts repetidos. OpenCode V2 permite darles nombre (`/team/standup`) y cargar reglas bajo demanda (`skill`), con ahorro de contexto.

**Evidencia.** E3: comandos Markdown/JSON en `.opencode/commands/`, `/review` desde `.opencode/commands/review.md`, `$ARGUMENTS`/`$1`, campos `agent`, `model`, `subagent`. E4: skills en `.opencode/skills/<id>/SKILL.md`, advertencia al modelo solo con ID/nombre/descripción y carga del cuerpo con la herramienta `skill`.

**Impacto.** Estandarizar la forma reduce variación de formato y facilita el KPI de "0 afirmaciones sin `source_ids`": el comando ya exige el campo en la plantilla.

**Propuesta.** Definir (en la máquina, `~/.config/opencode/commands/` y `~/.config/opencode/skills/`, para no tocar L-4):
- Comandos `/team/standup`, `/team/verify`, `/team/decide` con `description` y `subagent: false` — las decisiones requieren humano y no deben ir a background.
- Skills `kaizen-loop`, `kaizen-evidence`, `kaizen-voice` con `description` explícita; `metadata.opencode/autoinvoke: false` solo si se quiere carga manual por ID.
- Plantilla de `/team/verify` con recordatorio de `source_ids` y fecha de corte; **sin bloques `!`** (ver riesgo).
- Medir consumo con `debug.turn_tokens: true` en `cli.json` (E6).

**Fragmento documentado (comando):**
```md
<!-- ~/.config/opencode/commands/team/verify.md -->
---
description: Verificar decisiones del equipo contra SOURCES.md
agent: general
model: anthropic/claude-sonnet-5-5#high
subagent: false
---
Verifica $ARGUMENTS: cita source_ids, fecha de corte y resultado de kaizen-team verify.
```
Es un **ejemplo derivado de la sintaxis documentada** (E3), no un comando que haya ejecutado.

**Beneficio medible.** Menos tokens de system por turno (skills cargan cuerpo solo cuando se usan, E4), formato consistente en 100 % de standups y `verify`, y token por turno observable con `debug.turn_tokens`.

**Riesgo.** E3 advierte: los bloques `!` "run … outside the agent's tool permission flow" y "Do not place untrusted arguments inside shell blocks" → **prohibido** poner argumentos del buzón en bloques shell (S-4/S-15). Los skills de catálogo HTTP son contenido externo (S-15) → no registrar URLs sin aprobación. IDs duplicados: "the source registered later supplies the skill" (E4) → override silencioso. `debug.turn_tokens: "verbose"` incluye tool call inputs (E6) → usar `true` para no exponer secretos en logs (S-8).

**Pregunta.** ¿Autoriza el equipo publicar comandos/skills en `~/.config/opencode/` (ADR-0024) o deben versionarse en `.opencode/` con ADR humano previo (L-4)?

---

### P4 — Keybinds para el flujo del equipo (sin colisiones)

**Observación.** El equipo cambia entre worktrees de roles, recarga config y abre skills; hacerlo con el menú `Ctrl+P` cada vez adds fricción medible.

**Evidencia.** E5: sintaxis de `keybinds` en `cli.json`, `<leader>` por defecto `ctrl+x`, `leader.timeout`, y IDs `location.reload`, `prompt.skills`, `plugins.list`, `session.quick_switch.1..9`, `opencode.status`. E5 también: "Unknown command IDs are ignored". E6: `input.delete.to.line.end` = `ctrl+k`.

**Impacto.** Atajos mal elegidos rompen edición de prompt o se ignoran silenciosamente; bien elegidos acortan el ciclo standup→verify→decide.

**Propuesta.** Fragmento documentado para `~/.config/opencode/cli.json` (derivado de E5; **no aplicado**):
```json
{
  "$schema": "https://opencode.ai/v2/cli.json",
  "keybinds": {
    "leader": "ctrl+x",
    "location.reload": "<leader>r",
    "prompt.skills": "<leader>k",
    "plugins.list": "<leader>p"
  },
  "leader": { "timeout": 2000 }
}
```
Mantener `command.palette.show` en su valor por defecto `ctrl+p` y `session.quick_switch.1..9` en `<leader>1..9` para saltar entre roles/worktrees.

**Beneficio medible.** Número de pulsaciones para recargar config y abrir skills (de several en el menú a 2 con leader); tiempo de feedback por cambio de regla. Reversible borrando el bloque `keybinds`.

**Riesgo.** `ctrl+k` ya es `input.delete.to.line.end` (E6) → **no remapear la paleta a `ctrl+k`**; `session.tab.select.1` y `session.quick_switch.1` comparten `<leader>1` (E5) → documentar precedencia; un `leader.timeout` bajo provoca disparos accidentales; IDs inexistentes se ignoran sin error → validar contra la tabla de E5.

**Pregunta.** ¿Confirma `facilitador-equipo` que `<leader>1..9` se usa hoy para cambiar entre los roles del swarm y conviene reservarlo, o lo usa para pestañas?

---

### P5 — Plugins de TUI: notificación de subagente y control de ruido

**Observación.** El equipo descubre que un subagente terminó mirando el panel de Grafana o el buzón. OpenCode V2 puede emitir una señal local de finalización (`subagent_done`) y cargar plugins solo en la TUI.

**Evidencia.** E6: `attention.notifications`, `attention.sound`, y `attention.sounds` con eventos `done`, `subagent_done`, `error`, `permission`, `question`; `plugins` en `cli.json` con directiva `-` para desactivar. E7: "TUI-only plugins are configured separately and remain active when connected to a remote server"; comandos `opencode plugin add/list/check/update/remove`; "Exact npm versions and full Git commit hashes stay pinned".

**Impacto.** Menor latencia entre "el subagente terminó" y "el humano/equipo reacciona", sin sondear buzones; y menos ruido si se desactivan notificaciones irrelevantes.

**Propuesta.** (a) Regla de inventario: plugins de servidor → `opencode.json(c)`; plugins de TUI → `cli.json` (E7). (b) Activar `attention.notifications` y el evento `subagent_done` (E6) como mejora de feedback, previa revisión de que el texto notificado no contenga secretos. (c) Antes de cualquier adopción, inventariar con los comandos documentados `opencode plugin list --builtin` y fijar versiones exactas (`@1.2.0`) con revisión humana S-9. (d) Usar `"-"` para desactivar ruido, nunca eliminar policies.

**Beneficio medible.** Latencia de detección de finalización de subagente (antes: polling; después: evento) con criterio L-9; 100 % de plugins con versión fijada; 0 notificaciones con secretos. **No ejecutar `plugin add` ni `plugin update` en esta iteración.**

**Riesgo.** Supply chain (S-9): `plugin add` instala paquetes y `plugin update` cambia código sin gate humano → prohibido sin humano. E7: `opencode.config.policy` y `opencode.provider.opencode` ignoran eliminaciones (no se pueden desactivar). Notificaciones pueden filtrar contenido de prompts (S-8); no pegarlas en issues ni en el buzón sin `kaizen-security redact`.

**Pregunta.** ¿Debe `security` (T7) emitir el dictamen de supply chain de plugins antes de que el equipo active cualquier notificación o plugin de TUI?

---

### P6 — Diagnóstico del servicio compartido con trazabilidad `run`/`role`

**Observación.** Cuando un panel de Grafana muestra rojo (rc≠0), hoy no hay un procedimiento único para distinguir fallo de cliente, de servicio compartido o de un proyecto, ni para correlacionar con el log.

**Evidencia.** E8: `opencode service status` → información del servidor; `opencode api get /api/info` → health; logs en `~/.local/share/opencode/log/opencode.log` con `run` ID y `role=server`; advertencia de sanear antes de compartir. E9: `opencode debug paths log|db|config|...` imprime la ruta sin iniciar servidor.

**Impacto.** Sin correlación `run`/`role`, un incidente del swarm se diagnostica por prueba y error, aumentando MTTR y dificultando el postmortem sin culpables de K-8.

**Propuesta.** Runbook de diagnóstico (solo lectura primero): (1) `opencode service status`; (2) `opencode api get /api/info` (health y PID); (3) `opencode debug paths log`; (4) `grep 'role=server'` y filtrar por `run=<id>`; (5) escalar reinicio a humano. Registrar cada hallazgo por outbox S-11 y alimentar el postmortem. Integrar con el panel *Kaizen Swarm — Agentes en tiempo real* (rc≠0 → ejecutar pasos 1-4).

**Beneficio medible.** MTTR por incidente y 100 % de incidentes con `run`/`role` en el postmortem. Coste cero; reversible (no cambia configuración).

**Riesgo.** E8: `opencode api` **puede iniciar** el servicio si no hay uno sano → cambia estado; `opencode service set/unset cors` **detiene** el servicio; "Do not delete or edit service files or the database while troubleshooting". Los logs pueden contener prompts y credenciales → sanear con `kaizen-security redact` (S-8/S-12). Los heap snapshots "can contain prompts, file contents, and credentials. Do not share it publicly" (E8) → fuera de alcance sin humano. **No ejecuté ninguno de estos comandos.**

**Pregunta.** ¿Quién es el dueño del runbook (K-8) y con qué umbral de rc≠0 se dispara la revisión de logs en lugar de solo el reporte por outbox?

---

### P7 — Ajustes complementarios de bajo riesgo (insumo para T4)

| Ajuste (documentado en OC-001) | Fragmento / fuente | Beneficio medible | Riesgo |
| --- | --- | --- | --- |
| `diffs.source: "turn"` | E6 — "Last turn, the files the session changed in its latest turn" | Revisión de PRs pequeños (K-4) con menos ruido | "falls back to `branch` when `/diff` is not opened from a session" (E6) |
| `tabs.scope: "cwd"` | E1 — "Keeps separate tabs per working directory" | Aísla worktrees `wt-issue-<N>-<rol>` (K-12) | Más pestañas; consumo de memoria |
| `session.permissions: "prompt"` | E6 — `prompt` o `autoaccept` | Mantiene gate humano (L-3) | **`autoaccept` está prohibido** en este equipo: saltaría permisos sensibles |
| `experimental.subagent_depth: 1` | E10 — "Defaults to 1 … a subagent cannot start another subagent" | Alinea la recursión con `KAZEN_AGENT_DEPTH` | Experimental: "may change, break, or be removed … without notice" → no depender de él |
| `instructions: [".kaizen/RULES.md", ...]` | E2 — "loads them alongside discovered `AGENTS.md`" | Reglas canónicas presentes en cada sesión | Más contexto; `opencode.json` es L-4 → humano |
| `watcher.ignore: ["dist/**", "coverage/**"]` | E2 | Menos recargas espurias | Patrones mal calibrados pueden ignorar cambios reales |

---

## Insumo priorizado para el ADR de T4 (coste / riesgo / reversibilidad / L-9)

| Prioridad | Oportunidad | Coste | Riesgo | Reversibilidad | Criterio L-9 |
| --- | --- | --- | --- | --- | --- |
| 1 | P3 — comandos y skills de equipo (`/team/standup`, `/team/verify`, `/team/decide`) | Cero gasto; config en la máquina | Medio si se versiona en `.opencode/` (L-4) o se usa `!` con entradas no confiables | Alta: borrar archivos de comando/skill | 100 % de standups con `source_ids`; menos tokens por turno (`debug.turn_tokens`) |
| 2 | P2+P4 — recarga en caliente y keybind `location.reload` | Cero gasto | Bajo: colisiones de atajos y reinicio indebido del servicio | Alta: quitar el bloque `keybinds` | 0 reinicios de TUI por cambio de config/comando |
| 3 | P6 — runbook de diagnóstico `service status` + logs `run`/`role` | Cero gasto | Medio: logs con secretos y `opencode api` puede iniciar servicio | Alta: documento, sin cambio de estado | MTTR menor; 100 % de incidentes con `run`/`role` |

No priorizo P5 (plugins) ni P1 (política de config) para el primer ADR: P5 depende del dictamen de `security` (T7) y P1 de la decisión de gobernanza del arquitecto (T4).

## Hallazgo reportado aquí (no creo outbox por restricción de la tarea)

No se encontró documentación de un slash command `/reload` en las ocho páginas consultadas. No es un fallo del sistema, es una **incertidumbre de evidencia**: no debe escribirse como comando oficial hasta confirmarse con OC-001 (K-10). Se solicita a `verificador-evidencias` su confirmación. No se crea archivo en `.kaizen/loop/outbox/` porque la tarea prohíbe modificar otros archivos; queda registrado en este dictamen `review`.

## Resultado de verificación (`scripts/kaizen check`, ejecutado 2026-11-23/24)

Salida real (RC=1):

```
ok: descriptores validados
FALLA: falta el descriptor docs/kaizen/pr-drafts/kaizen-open-code-integration.md
ok: politicas de contenido
ok: formato
ok: lint
FALLA: tests
ok: deuda 0 <= 0
kaizen check: FALLO
```

Dos fallos: (1) falta el descriptor de PR —responsabilidad de `dev5-glue`/finalize según K-4 y K-12, no de T5—; (2) `tests` en rojo —hallazgo S-11, se reporta aquí y en el resumen al equipo porque la restricción de esta tarea prohíbe crear archivos fuera de `reviews/dx.md` (no se abre outbox ni se silencia el fallo). **No corregí ni relajé nada**: no creé el descriptor, no salté tests ni usé `--no-verify` (K-10/L-10/S-10). El veredicto `APPROVE` de este dictamen cubre **solo el análisis de ergonomía**; no implica que el repo pase `kaizen check`.

## Dictamen

**APPROVE (acotado).** Las seis propuestas están respaldadas por OC-001 (`verified`), con fecha de corte 2026-11-23/24, y ninguna se ejecutó. Condiciones para convertirlas en cambio: (1) ADR del arquitecto (T4) y verificación en verde; (2) humano aprueba cualquier escritura en rutas L-4, instalación de plugins/skills o reinicio del servicio; (3) `security` (T7) dictamina supply chain antes de activar plugins; (4) medir con el criterio L-9 de la tabla y revertir si la métrica no mejora.

## Pregunta final concreta

¿Acepta `architect` (T4) las tres oportunidades priorizadas como insumo del ADR, con la condición de que la adopción de comandos/skills sea en `~/.config/opencode/` (ADR-0024) hasta que un humano autorice tocar `.opencode/`?

## Nota de consolidación del coordinador (2026-11-24)
El RC=1 reportado arriba es de una ejecución anterior a la creación del descriptor. El coordinador creó `docs/kaizen/pr-drafts/kaizen-open-code-integration.md` (con `## Resumen`, `## Plan de prueba`, `## Cierre de issues` y `Closes: none`) y `scripts/kaizen check --only descriptors` → RC 0. El gate `tests` sigue en rojo por procesos `tests/run.sh` colgados preexistentes, reportado en outbox; no se afirma verde (K-10). Sobre la recarga: la verificación posterior (REG-EV-04) confirmó recarga automática en docs oficiales, pero `/reload` y `location.reload` quedaron `unknown`; no se recomienda `/reload`. Las 3 propuestas de este review siguen vigentes como insumo del ADR.
