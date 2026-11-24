# Descriptor — kaizen/facilitador-opencode-local-config-verificacion

## Resumen
Verificar el KPI local de opencode: 47/47 agentes globales y 0 reglas deny de git push (git push* en allow); evidencia con source_ids, handoff acusado y tarea lista para QA.

## Alcance

Verificar el KPI del equipo `opencode-local-config` para el trabajo asignado: **47 agentes globales instalados** y **0 reglas `deny` de `git push`** (con `git push*` en `allow`). Reportar esquema V2 y MCP `rea` como contexto. Producir evidencia con `source_ids`, handoff con ack y dejar la tarea lista para `qa`. **No** dictaminar el proyecto completo (eso es de `verificador-evidencias`).

- Proyecto: `.kaizen/team/projects/opencode-local-config/`
- correlation_id: `OLC-VER-001`
- Handoff: `H-1795376780163988176` → `qa` (status `ack`)
- Autoridad: ADR-0023 (push en ramas `kaizen/*`); sin push a `main`.

## Cambios

| Archivo | Cambio |
| --- | --- |
| `opencode.json` | Migración a esquema V2 (`permissions[]`), instrucciones de equipo añadidas, `git push*`/merge/rebase/comentarios `gh` en `allow`, secretos en `deny`. (Cambio preexistente en el árbol de trabajo, verificado y trackeado en esta rama). |
| `.kaizen/team/teams.json` | Registro del equipo `opencode-local-config` con su KPI. (Cambio preexistente, trackeado aquí). |
| `.kaizen/team/projects/opencode-local-config/state.json` | Inicialización del proyecto (`execute`), necesaria para que `kaizen-team status/sync` operen. |
| `.kaizen/team/projects/opencode-local-config/handoffs.jsonl` | Handoff con sobre completo y ack real. |
| `.kaizen/team/projects/opencode-local-config/tasks.json` | Tarea 1 en `ready` con evidencia, lease, `source_ids` y handoff. |
| `.kaizen/team/projects/opencode-local-config/blackboard.md` | Hechos verificados con `source_ids` / comandos reproducibles. |
| `.kaizen/team/projects/opencode-local-config/standups/2026-11-22.md` | Standup del día, 0 tareas sin dueño, 0 acuses pendientes. |
| `docs/kaizen/team/opencode-local-config/facilitador-equipo-verificacion.md` | Evidencia: resultados, comandos, `source_ids`, handoff, hallazgos. |
| `.kaizen/loop/outbox/kaizen-team-handoff-now-bug.md` | Reincidencia del bug `now` vs `$now` (mismo fingerprint, sin duplicar). |
| `docs/kaizen/pr-drafts/kaizen-facilitador-opencode-local-config-verificacion.md` | Este descriptor (K-4). |

> No se incluye `.kaizen/finops/token-ledger.jsonl`: cambio autónomo de contabilidad de tokens, ajeno a este cambio lógico (K-3).

## Evidencia

```text
find ~/.config/opencode/agents -maxdepth 1 -name '*.md' -type f | wc -l
→ 47

jq -c '[.permissions[] | select(.resource | test("git push"))]' opencode.json
→ [{"action":"shell","resource":"git push*","effect":"allow"}]

jq '[.permissions[] | select(.effect == "deny" and (.resource | test("push")))] | length' opencode.json
→ 0

jq -e '.permissions | type == "array"' opencode.json
→ true
jq -e '([.permissions[] | select(has("action") and has("resource") and has("effect"))] | length) == (.permissions | length)' opencode.json
→ true
jq '.permissions | length' opencode.json
→ 26

scripts/kaizen-team ack opencode-local-config H-1795376780163988176
→ [kaizen-team] ack registrado: H-1795376780163988176
scripts/kaizen-team sync opencode-local-config
→ acuses pendientes=0 | tareas abiertas=5
```

Detalle completo en `docs/kaizen/team/opencode-local-config/facilitador-equipo-verificacion.md`.

## Plan de prueba

| Comando | Esperado | Política |
| --- | --- | --- |
| `find …/agents -name '*.md' \| wc -l` | `47` | Solo lectura; sin credenciales. |
| `jq` sobre `opencode.json` (4 consultas) | `allow`, `0`, `true`, `true` | Solo lectura; falla cerrado si difiere. |
| `grep -nE '^\| (ID) \|' SOURCES.md` | 5 IDs `verified` + ADR-0023 aceptado | REG-EV-01/07; sin fuentes `pending`. |
| `scripts/kaizen-team ack` + `sync` | ack registrado, acuses 0 | Sin invocar `handoff` (bug fail-open documentado). |
| `scripts/kaizen-knowledge cite-check <evidencia>` | rc=0 | Ejecutado: `citas válidas: 0` (el doc no usa anclas `PA-XXX-art`). |
| `scripts/kaizen check` | `todo en verde`, rc=0 | Ver § Estado real del gate. Timeout 120 s, fail-closed. |

Datos de prueba: ninguno; solo archivos de configuración sin secretos (L-6). Reversibilidad: los cambios son aditivos y están en rama `kaizen/*`; revert = eliminar la rama / revertir el commit (L-7).

## Estado real del gate `kaizen check`

Ejecutado en esta rama con `timeout 120`:

```text
ok: descriptores validados
FALLA: falta el descriptor docs/kaizen/pr-drafts/kaizen-facilitador-opencode-local-config-verificacion.md
ok: politicas de contenido
ok: formato
ok: lint
rc=124   # timeout en fase de pruebas (bash tests/run.sh), patrón ya documentado en el outbox
```

El descriptor se creó en este mismo commit para corregir la `FALLA`. El `rc=124` en la fase de pruebas es un fallo conocido y **no se silencia** (S-10): se reporta como `failure` y se escala. No se afirma «todo en verde» sin ejecución completa (K-10/L-10).

## Documentos tocados

- `docs/kaizen/team/opencode-local-config/facilitador-equipo-verificacion.md` (evidencia)
- Este descriptor (K-7)
- Blackboard y standup del proyecto (documentación viva del equipo)

## Impacto en calidad (ratchet)
- Cobertura: igual (no hay código nuevo).
- Advertencias: igual.
- Deuda (TODO/FIXME): igual.
- Sin supresiones S-10; ningún `--no-verify` ni CI desactivado.

## Criterios de salida que avanza
- 47/47 agentes globales verificados con comando reproducible. ✔
- 0 reglas `deny` de `git push`, `git push*` en `allow` (repo y global). ✔
- Esquema V2 válido (arreglo de 26 reglas con `action`/`resource`/`effect`). ✔
- Handoff `H-1795376780163988176` con ack real; `sync` → acuses pendientes 0. ✔
- 5/5 tareas con dueño; tarea 1 en `ready` con evidencia y `source_ids`. ✔

## Hallazgos / escalado

- H-1: bug `now` vs `$now` en `scripts/kaizen-team:72,82` (recurrente, ya en outbox, L-4 → ADR + humano).
- H-2: config global permite `read *.env` (derivar a `security`, tarea 2; facilitador no cambia permisos).
- H-4: `kaizen check` no completa (rc=124) — reportado, no silenciado.

## Cierre de issues
Closes: none — verificación de configuración local sin issue numerado; no se fabrica un número (K-10). Origen: tarea del proyecto `opencode-local-config`.

## Checklist
- [x] Compila (no aplica: sin código).
- [ ] Pasa tests — `scripts/kaizen check` sin resultado hermético (rc=124 en fase de pruebas); no se afirma verde.
- [x] Documentación actualizada (evidencia, blackboard, standup, outbox, descriptor).
- [x] Línea base no empeora.

## Cuerpo del PR

Verificación de configuración local: 47/47 agentes globales, 0 reglas `deny` de `git push` (`git push*` = `allow`), esquema V2 válido (26 reglas) y MCP `rea` activo. Evidencia reproducible con `source_ids` ISO-001, NIST-001, OWASP-001, AICPA-001, TOOL-001 y ADR-0023. Handoff a `qa` acusado, 0 acuses pendientes, tarea en `ready`. Sin push a `main`. `kaizen check` reporta hallazgos conocidos (descriptor incluido en este PR; timeout rc=124 en fase de pruebas reportado, no silenciado).
