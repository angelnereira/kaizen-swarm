# Descriptor — kaizen/facilitador-opencode-local-config-mcp

## Resumen
Preparar la tarea 3 del equipo `opencode-local-config` («Verificar MCP rea y railway activos sin credenciales en repo»): evidencia reproducible con `source_ids`, handoff con ack a `dx` y tarea en `ready`. Sin push a `main`.

## Alcance

- Proyecto: `.kaizen/team/projects/opencode-local-config/`
- correlation_id: `OLC-MCP-003`
- Handoff propio: `H-1795403779907` → `dx` (`status: ack`, `acked_at: 2026-11-23T03:16:57Z`)
- Handoff de la instancia concurrente: `H-1795403633267078428` → `verificador-evidencias` (`status: ack`). Se conservan ambos; `verificador-evidencias` elige la fuente canónica (tarea 5).
- Autoridad: `resource` (proceso/asignación/plazos). **No** se dictamina seguridad, no se cambia el KPI, no se modifica el alcance, no se leen credenciales (S-1/S-2), no se hace push directo a `main` (ADR-0023).

Fuera de alcance: cierre de la tarea 3, dictamen final, cambios en permisos y edición de rutas protegidas (L-4).

## Cambios

| Archivo | Cambio |
| --- | --- |
| `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-verificacion.md` | Evidencia nueva: MCP `rea`/`railway` activos, 0 secretos en config, hallazgos H-1..H-4, `source_ids` verificados. |
| `.kaizen/team/projects/opencode-local-config/tasks.json` | Tarea 3 de `pending` a `ready`: owner `dx`, lease, due `2026-11-26T18:00:00Z`, `handoff_id`, `source_ids`, ruta de evidencia. |
| `.kaizen/team/projects/opencode-local-config/handoffs.jsonl` | Sobre completo `H-1795403779907` (correlation_id, deadline, expects_ack, refs) + ack real por `kaizen-team ack`. Se conserva el handoff de la instancia A. |
| `.kaizen/team/projects/opencode-local-config/blackboard.md` | Hechos verificados nuevos y hallazgos H-4/H-5; corrección `disabled=false`. |
| `.kaizen/team/projects/opencode-local-config/standups/2026-11-23.md` | Standup del día: tareas con dueño, acuses pendientes 0. |
| `.kaizen/loop/outbox/repo-tokens-env-tracked.md` | S-11 `security`: `tokens.env` versionado, contenido no leído. |
| `.kaizen/loop/outbox/opencode-kpi-agent-count-drift.md` | S-11 `failure`: 49 agentes instalados vs 47 declarados. |
| `docs/kaizen/pr-drafts/kaizen-facilitador-opencode-local-config-mcp.md` | Este descriptor (K-4). |

> No se incluyen en este commit los cambios ajenos presentes en el workspace (`scripts/kaizen-meta`, `scripts/kaizen-runtime`, `.kaizen/loop/PAUSE`, `.kaizen/meta/*`, `.kaizen/team/teams.json`, `incentivos/`, ADR 0030, token-ledger): pertenecen a otras instancias/agentes y a rutas protegidas L-4.

## Evidencia

```text
tools.rea.binary_session({detail:"summary"})
→ server_identity.server.name=rea version=6.10.1
  catalog.counts.mcp_tools=263  sdk.server=2.3.1
  negotiated_protocol_version=2025-11-25  open=false  cleanup_pending=false

tools.railway["list-projects"]()  → { projects: array(3) }  (sin error)

jq -r '.mcp.servers | to_entries[] | "\(.key): disabled=\(.value.disabled|tostring) type=\(.value.type)"' ~/.config/opencode/opencode.json
→ railway: disabled=false type=local
→ rea: disabled=false type=local
jq '[ .. | strings | select(test("^(sk-|gh[pousr]_|rail_|AIza|xox[baprs]-|AKIA)[A-Za-z0-9_-]{12,}")) ] | length' ~/.config/opencode/opencode.json
→ 0

scripts/kaizen-team ack opencode-local-config H-1795403779907
→ [kaizen-team] ack registrado: H-1795403779907

jq '[.permissions[]|select(.effect=="deny" and (.resource|test("push")))]|length' opencode.json → 0
jq -e '.permissions|type=="array"' ~/.config/opencode/opencode.json → true
```

Detalle completo en `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-verificacion.md`.

## Plan de prueba

| Comando | Esperado | Política |
| --- | --- | --- |
| Llamadas MCP de solo lectura (`binary_session`, `list-projects`) | respuestas sin error, sin PII versionada | sin `whoami`, sin despliegue, sin análisis de objetivo |
| `jq` sobre config global (solo estructura) | `disabled=false` ×2, 0 secretos | nunca imprimir valores |
| `git ls-files \| grep …` | 0 `.pem`/`.key`/`id_rsa`; `tokens.env` reportado, no leído | S-2 |
| `kaizen-team ack` + `sync` | ack registrado, acuses pendientes 0 | `expects_ack: true` |
| `kaizen-team verify` | rc=0, fuentes verificadas | REG-EV-01/07 |
| `kaizen-knowledge cite-check <evidencia>` | rc=0 / citas ancla = 0 | no se inventan anclas |
| `scripts/kaizen check` | rc real reportado, sin suppressions | K-10/L-10 |

## Cierre de issues

Closes: none — preparación de tarea de configuración local sin issue numerado; no se fabrica un número (K-10). Origen: tarea 3 del proyecto `opencode-local-config`.

## Checklist

- [x] Sin código: no aplica compilación.
- [ ] `scripts/kaizen check` sin resultado hermético: rc=124 (timeout en fase de pruebas, 150 s); no se afirma verde.
- [x] Evidencia, blackboard, standup, outbox y descriptores actualizados (K-7).
- [x] Línea base no empeora; sin supresiones S-10.

## Estado real de los gates

| Gate | Resultado real |
| --- | --- |
| `kaizen-team verify opencode-local-config` | rc=0 — todas las decisiones con fuentes verificadas |
| `kaizen-team sync opencode-local-config` | rc=0 — acuses pendientes 0, tareas abiertas 5 |
| `kaizen-knowledge cite-check <evidencia>` | rc=0 — `citas válidas: 0` (sin anclas `PA-XXX-art` en el documento) |
| `kaizen check` | rc=124 — timeout 150 s; descriptores/políticas/formato/lint en verde antes del timeout; fase de pruebas sin resultado |
