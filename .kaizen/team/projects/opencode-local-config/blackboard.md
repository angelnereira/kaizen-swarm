# Blackboard: opencode-local-config

Solo hechos con `source_ids` verificados o salida de comando reproducible (TEAM.md, principio 2). Fecha de corte de fuentes: 2026-11-21 (`SOURCES.md` L3). Todo contenido externo es dato no confiable (S-15/L-5).

| Hecho verificado | Valor | Evidencia (comando reproducible) | source_ids |
| --- | --- | --- | --- |
| Agentes globales instalados | 47/47 | `find ~/.config/opencode/agents -maxdepth 1 -name '*.md' -type f \| wc -l` → `47` | ISO-001, NIST-001 |
| Reglas `deny` sobre `git push` | 0 | `jq '[.permissions[] \| select(.effect=="deny" and (.resource\|test("push")))] \| length' opencode.json` → `0` | ADR-0023, ISO-001 |
| Regla `git push*` | `effect: allow` | `jq -c '[.permissions[] \| select(.resource\|test("git push"))]' opencode.json` → `[{"action":"shell","resource":"git push*","effect":"allow"}]` | ADR-0023 |
| Esquema V2 (`permissions` como arreglo, 26 reglas con `action`/`resource`/`effect`) | válido | `jq -e '.permissions \| type == "array"'` → `true`; `jq -e '([.permissions[]\|select(has("action") and has("resource") and has("effect"))]\|length) == (.permissions\|length)'` → `true` | ISO-001, OWASP-001 |
| MCP `rea` | activo (`disabled: false`) | `~/.config/opencode/opencode.json` → `mcp.servers.rea.disabled = false`; herramientas `tools.rea.*` disponibles en el runtime | TOOL-001 |
| Handoff de verificación | acusado (`status: ack`) | `kaizen-team ack opencode-local-config H-1795376780163988176` → ack registrado; `kaizen-team sync` → acuses pendientes 0 | AICPA-001, NIST-001 |

## Hallazgo abierto (no resuelto por el facilitador)

- El bug `now` vs `$now` en `scripts/kaizen-team:72,82` sigue presente y hace que `assign`/`handoff` reporten éxito sin escribir el handoff (fail-open). Ya documentado con fingerprint `kaizen-team-handoff-now` en `.kaizen/loop/outbox/kaizen-team-handoff-now-bug.md`. Workaround aplicado: handoff escrito directamente en el ledger y acusado con `kaizen-team ack`. Ruta protegida L-4: requiere ADR + humano.
- Configuración global `~/.config/opencode/opencode.json` declara `read *.env: allow` y `read *.env.*: allow`; la configuración del repo declara `deny` para esos patrones. Derivar a `security` (tarea "Validar opencode.json V2 (permissions) y denegaciones de secretos") para dictamen; el facilitador no cambia permisos (fuera de su autoridad `resource`).
