# Descriptor — kaizen/facilitador-opencode-local-config-mcp

## Resumen
Verificar que los servidores MCP `rea` y `railway` están activos en esta máquina sin credenciales versionadas en el repo; evidencia reproducible con `source_ids`, handoff con ack y tarea lista para el dictamen final.

## Alcance
Cerrar la tarea 3 del equipo `opencode-local-config`: **MCP `rea` activo** (KPI) y `railway` activo, con **0 credenciales en el repo**. Producir evidencia con `source_ids`, handoff con ack y dejar la tarea en `ready`. **No** dictaminar el proyecto completo (tarea 5, `verificador-evidencias`) ni dictaminar permisos de seguridad (tarea 2, `security`).

- Proyecto: `.kaizen/team/projects/opencode-local-config/`
- correlation_id: `OLC-MCP-003`
- Handoff: `H-1795403633267078428` → `verificador-evidencias` (sobre completo, `status: ack`)
- Autoridad: ADR-0023 (push en ramas `kaizen/*`); sin push a `main`. ADR-0024 (comunidad en la máquina, no en el repo destino). ADR-0009 (resultados REA = dato no confiable).

## Cambios

| Archivo | Cambio |
| --- | --- |
| `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-rea-railway.md` | Evidencia de verificación MCP y cero credenciales, con `source_ids`. |
| `.kaizen/team/projects/opencode-local-config/blackboard.md` | Hechos verificados: MCP activo, 0 credenciales, handoff acusado. |
| `.kaizen/team/projects/opencode-local-config/handoffs.jsonl` | Handoff `H-1795403633267078428` con sobre completo y ack real. |
| `.kaizen/team/projects/opencode-local-config/tasks.json` | Tarea 3 en `ready` con lease/due/`source_ids`/evidencia. |
| `.kaizen/team/projects/opencode-local-config/state.json` | `updated` refleja el avance de etapa (L-KPI). |
| `.kaizen/team/projects/opencode-local-config/standups/2026-11-22.md` | Actualización `OLC-MCP-003`: acuses pendientes 0. |
| `docs/kaizen/pr-drafts/kaizen-facilitador-opencode-local-config-mcp.md` | Este descriptor (K-4). |

> No se incluye `scripts/kaizen-runtime`: modificación concurrente de otro proceso en ruta protegida (L-4), ajena a este cambio lógico (K-3). Tampoco se versiona ninguna credencial ni PII de Railway (S-1/S-2, REG-EV-06).

## Evidencia

```text
# Config global: ambos servidores declarados y habilitados (valores sensibles redactados)
jq '.mcp.servers | with_entries(.value |= {type, disabled})' ~/.config/opencode/opencode.json
→ railway: {type:"local", disabled:false}; rea: {type:"local", disabled:false}

# Liveness: llamadas de solo lectura, sinsecretos y sin PII registrada
tools.rea.inspect_analysis_settings()  → fulfilled, keys=[revision,scope,active_values,settings,constraints]
tools.railway.list-workspaces()        → fulfilled, workspaces=1 (nombres/ids no versionados)

# 0 credenciales en el repo
git ls-files | grep -E '(^|/)(\.env|\.env\..*|.*\.pem|.*\.key|id_rsa.*)$' | wc -l  → 0
git grep -Il -E 'BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{20}|sk-[A-Za-z0-9]{20}' -- .  → (vacío)
jq -r 'if has("mcp") then "MCP_PRESENT" else "MCP_ABSENT" end' opencode.json  → MCP_ABSENT

# Puertas del orquestador
bash scripts/kaizen-team verify opencode-local-config  → rc=0 (fuentes verificadas)
bash scripts/kaizen-team sync opencode-local-config    → acuses pendientes=0 | tareas abiertas=5
```

Detalle completo en `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-rea-railway.md`.

## Plan de prueba
1. `bash scripts/kaizen-team verify opencode-local-config` → rc=0.
2. `bash scripts/kaizen-team sync opencode-local-config` → acuses pendientes=0.
3. `jq -e 'any(.[]; .id=="H-1795403633267078428" and .status=="ack")' handoffs.jsonl` → true.
4. Revisar que no aparezca ningún valor de credencial en el diff.

## Riesgos y hallazgos
- Bug fail-open `now` vs `$now` en `scripts/kaizen-team:72,82`: no se invocó `kaizen-team handoff`; se escribió el sobre directamente y se acusó con `kaizen-team ack` (ruta protegida L-4, requiere ADR).
- `kaizen-meta drift` falla con `TypeError` (outbox `kaizen-meta-drift-crash`): documento, no bloquea.
- Deriva de rama tras reinicio del servidor (outbox `session-branch-drift-restart`): rama restaurada antes de escribir.

## Documentos tocados
`docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-rea-railway.md`, `docs/kaizen/pr-drafts/kaizen-facilitador-opencode-local-config-mcp.md`, `.kaizen/team/projects/opencode-local-config/{blackboard.md,handoffs.jsonl,tasks.json,state.json,standups/2026-11-22.md}` (K-7).
