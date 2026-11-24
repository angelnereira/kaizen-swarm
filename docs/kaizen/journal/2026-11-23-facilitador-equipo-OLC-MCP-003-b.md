# Iteración facilitador-equipo (instancia B, post-reinicio) — 2026-11-23T03:35Z

## Tarea
`OLC-MCP-003` — «Verificar MCP rea y railway activos sin credenciales en repo». Autoridad `resource`: ordenar el proceso, no dictaminar seguridad ni cambiar el KPI. La etapa del proyecto permanece en `execute` y la tarea 3 queda `ready`, no cerrada.

## Decisión
- Preparar la tarea 3 para `dx` con evidencia reproducible, `source_ids` verificados y handoff acusado; conservar el handoff y la evidencia de la instancia A y dejar que `verificador-evidencias` (tarea 5) elija la fuente canónica.
- No auto-avanzar de etapa, no cerrar la tarea, no leer credenciales, no tocar permisos ni rutas protegidas (L-3/L-4).

## Evidencia (comandos y resultados reales)
```
tools.rea.binary_session({detail:"summary"}) → server.name=rea, version=6.10.1,
  catalog.counts.mcp_tools=263, protocolo=2025-11-25, open=false, cleanup_pending=false
tools.railway["list-projects"]()            → { projects: array(3) }  (sin whoami, sin PII)
jq '.mcp.servers | to_entries[] | "\(.key): disabled=\(.value.disabled|tostring) type=\(.value.type)"'
  → railway: disabled=false type=local ; rea: disabled=false type=local
jq '[..|strings|select(test("^(sk-|gh[pousr]_|rail_|AIza|xox[baprs]-|AKIA)[A-Za-z0-9_-]{12,}"))]|length' ~/.config/opencode/opencode.json
  → 0
find ~/.config/opencode/agents -maxdepth 1 -name '*.md' -type f | wc -l → 49 (KPI dice 47)
scripts/kaizen-team ack opencode-local-config H-1795403779907 → ack registrado 03:16:57Z
bash scripts/kaizen-team verify opencode-local-config → rc=0
bash scripts/kaizen-team sync opencode-local-config → acuses pendientes=0, tareas abiertas=5
scripts/kaizen-knowledge cite-check <evidencia> → rc=0 (citas válidas: 0)
timeout 240 scripts/kaizen check → rc=124; descriptores/políticas/formato/lint en verde, fase tests sin salida
```
Corrección propia: medición intermedia `disabled=unset` era artefacto de `false // "unset"` en jq; remédida con `|tostring` → `disabled=false`.

## Resultado
Evidencia `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-verificacion.md`; tarea 3 `ready` con owner `dx`, lease y deadline `2026-11-26T18:00Z`; handoff `H-1795403779907` acusado. Fuente canónica pendiente de `verificador-evidencias`.

## Hallazgos (S-11, outbox local no versionado por diseño)
`repo-tokens-env-tracked` (tokens.env versionado, contenido no leído por S-2), `opencode-kpi-agent-count-drift` (49 vs 47), `facilitador-duplicate-work-OLC-MCP-003` (colisión con la instancia A), actualización de `kaizen-check-tests-ledger-tokens` (rc=124 por timeout en tests).

## Aprendizaje
El operador `//` de jq trata `false` como falsy: usar `|tostring` para reportar booleanos de configuración. En un workspace con instancias concurrentes, verificar `correlation_id` y rama activa **antes** de escribir; conservar ambas evidencias y dejar la selección canónica al verificador evita destruir trabajo ajeno. `kaizen check` agotó el timeout en la fase de tests: reportar rc=124 sin afirmar verde (K-10).

## Estado de cierre
Sin cierre formal: `HEAD ≠ origin/main` y rama `kaizen/*` sin upstream. Push de la rama permitido por ADR-0023; sin push a `main`. Reporte a El Presidente con estado ámbar por el timeout del gate global.
