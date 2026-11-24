# Iteración facilitador-equipo (instancia A) — 2026-11-23T03:30Z

## Tarea
`OLC-MCP-003` — «Verificar MCP rea y railway activos sin credenciales en repo». Autoridad
`resource`: ordenar el proceso, no dictaminar seguridad ni arquitectura. La etapa del
proyecto permanece en `execute`; la tarea 3 queda `ready`, no cerrada.

## Decisión
- Evidencia: `docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-rea-railway.md`,
  `source_ids` `TOOL-001`, `ISO-001`, `NIST-001`, `OWASP-001`, `AICPA-001` (fecha de corte
  2026-11-21). Formato Observación → Evidencia → Impacto → Propuesta → Pregunta.
- Handoff `H-1795403633267078428` → `verificador-evidencias`, sobre completo y **acusado**
  (`kaizen-team ack`, 2026-11-23T03:15:19Z). Escritura directa por el bug fail-open
  documentado de `kaizen-team handoff` (`now` vs `$now`, fingerprint
  `kaizen-team-handoff-now`, ruta L-4).
- No se auto-avanzó de etapa ni se cerró la tarea: el dictamen final pertenece a
  `verificador-evidencias` (tarea 5).

## Evidencia (comandos y resultados reales)
```
jq -r 'if has("mcp") then "MCP_PRESENT" else "MCP_ABSENT" end' opencode.json → MCP_ABSENT
jq '<claves sensibles redactadas>' ~/.config/opencode/opencode.json
   → rea.disabled=false, railway.disabled=false, sin claves token/apiKey/secret
tools.rea.binary_session({})  → fulfilled, keys=[result], antes y después del reinicio
tools.railway.whoami({})      → fulfilled (autenticado); PII descartada, no versionada
5 patrones de secreto en git grep → 0 archivos c/u; *.pem/*.key/id_rsa versionados → 0
git ls-files | grep -icE '(^|/)[^/]*\.env(\.[^/]*)?$' → 16 (sin leer; abierto en security)
bash scripts/kaizen-team verify opencode-local-config → rc=0
bash scripts/kaizen-team sync opencode-local-config   → acuses pendientes=0
```
`scripts/kaizen check` **rc=1 FALLO** (resultado final real, no solo timeout): en la ejecución
que incluía el pre-push hook fallaron dos validaciones ya corregidas después en el descriptor
(`## Cierre de issues` y `Closes: none`, ambas presentes en HEAD actual) y, de forma
persistente, `FALLA: tests` (`$KZ_TEST_CMD` terminado). Otro agente documentó el detalle en
`.kaizen/loop/outbox/kaizen-check-tests-ledger-tokens.md` (`229 pasadas, 3 fallidas`; una es
`FALLA ledger tokens`, coherente con `token-ledger-corrupt-concurrent-write`). No se afirma
«check verde» ni se usó `--no-verify`. `kaizen-meta drift` → `[block] drift-git
local≠origin/main`; `kaizen-meta close` → `AttributeError` (mismo bug de desempaquetado
que `drift`).

## Hallazgos reportados por S-11 (outbox local, no versionado por diseño)
- `kaizen-meta-drift-crash` — `drift` y `close` confunden `rc` con salida; `close` sigue roto
  tras el parche concurrente a `drift`.
- `session-branch-drift-restart` — tras el reinicio la sesión aterrizó en la rama de otro
  agente; se restauró la propia antes de escribir.
- `facilitador-duplicate-work-OLC-MCP-003` — dos instancias de `facilitador-equipo`
  ejecutaron la misma tarea; dos evidencias y dos handoffs acusados se conservan.
- `token-ledger-corrupt-concurrent-write` — 3 líneas JSON inválidas en el ledger de tokens
  por append concurrente; `kaizen-tokens` falla; no se saneó (competencia de finops).

## Aprendizaje
Afirmar «0 credenciales en el repo» era demasiado amplio: un sufijo `.env` amplio revela
16 archivos versionados. El hallazgo verificable es «0 secretos embebidos en la config MCP y
0 patrones de secreto en archivos examinados», con el inventario `.env` derivado a security.
Además, en un workspace concurrente, verificar la rama activa y el `correlation_id` antes de
escribir evita duplicar una tarea y escribir en el estado de otro agente.

## Estado de cierre
Sin cierre formal: `kaizen-meta close` no ejecutable y `HEAD ≠ origin/main`. Push a
`kaizen/facilitador-opencode-local-config-verificacion` **falló** (`rc=1`, `error: failed to
push some refs`) porque el hook de pre-push ejecuta `kaizen check`, que está en rojo por
`FALLA: tests`; no se eludió el hook (K-10). Sin upstream configurado. Se reporta a El
Presidente con estado ámbar y la corrección del resultado real del gate.
