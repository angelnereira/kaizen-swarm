# Descriptor — kaizen/facilitador-opencode-local-config-verificacion

> **Nota de nombre (K-4):** el nombre canónico derivado de la rama sería `kaizen-facilitador-opencode-local-config-verificacion.md`, que **ya existe** y describe otro cambio lógico. Para no sobrescribirlo se crea este descriptor con el nombre solicitado para la integración RAE-API. Al abrir el PR, humano/facilitador debe confirmar el emparejamiento rama↔descriptor. **No se cambió de rama, no se hizo commit ni push.**

## Resumen

Integrar reverse-api-engineer de forma gobernada con REA: corregir la deriva documental verificada, proponer el ADR comparativo, runbook y sandbox, con criterios AC-1..AC-9 reproducibles y captura saneada pendiente de autorización.

## Componente afectado

Proyecto `.kaizen/team/projects/integracion-rae-api-toolkit/` (etapa `execute`), documentación pública (`README.md`) y evidencia de contrato de outsourcing (`rae-api-install/evidence.md`).

## Tipo de cambio

- [x] documentation
- [ ] bug
- [ ] enhancement
- [ ] tech-debt
- [ ] refactor

## Rama, autoridad y fuentes

- **Rama actual:** `kaizen/facilitador-opencode-local-config-verificacion` (sin cambio de rama; sin commit ni push en este turno).
- **Autoridad:** aprobación directa de El Presidente (2026-11-23) para corregir la deriva documental. ADR-0023 autoriza push en ramas `kaizen/*`, **no ejecutado**. La captura sigue exigiendo humano como A y seguridad/cumplimiento como V (proceso `api_reverse_engineering`, plan.md:25).
- **Fuentes (`source_ids`):** TOOL-001 (REA, MIT) y TOOL-002 (reverse-api-engineer, MIT v0.16.0), ambas `verified` en `.kaizen/org/knowledge/SOURCES.md:38-39`; la fila TOOL-002 incluye el sha256 del wheel (`079cd958…`) y fecha de corte 2026-11-23. ISO-001/NIST-001: `verified`, corte 2026-11-21. Ninguna `pending`/`conflict`/`stale` (REG-EV-01).

## Alcance

1. **Integración gobernada:** CLI v0.16.0 ya instalada y verificada; skill local ausente en la auditoría (instalación posterior autorizada y en curso); 0 capturas. Sin instalar nada en este turno.
2. **ADR-0031:** comparativo externo vs nativo/híbrido; creado por el arquitecto en `docs/kaizen/adr/0031-integracion-hibrida-reverse-api-engineer.md` **durante este turno** (cambio concurrente, no editado aquí). Estado `proposed`: dirección aprobada por humano el 2026-11-23, pendiente de verificación L-9. No sustituye a ADR-0017 (vigente) ni a ADR-0009 (REA, aprobada).
3. **Runbook y sandbox:** `runbooks/rae-api-runbook.md` y `sandbox/` (sitio propio para la captura autorizada), con HAR saneado y coste registrado como evidencia.
4. **Documentación:** corregir README:186 y `evidence.md:3-4` al estado real verificado (gobernado / instalado / verificable), sin afirmar capturas hechas (K-10/K-7).

**Fuera de alcance:** capturas o tráfico, instalación de la skill o dependencias, modificación de `SOURCES.md`, ADR-0017, ADR-0031, `tests/run.sh`, handoffs de otros proyectos, `scripts/kaizen*`, cambios de autonomía y push.

## Cambios

| Archivo | Cambio | Autoría |
| --- | --- | --- |
| `README.md:186` | Línea «NO instalado por cuota» → estado separado: gobernado / CLI instalada y verificada / 0 capturas / skill ausente en auditoría con instalación en curso / ADR-0031 en propuesta. | Este turno |
| `.kaizen/org/outsourcing/rae-api-install/evidence.md:3-4` | `result`: eliminada la afirmación falsa «skill copiado»; declara skill ausente en auditoría e instalación autorizada 2026-11-23 en curso. `state`: «CLI instalada y verificada; skill no local en fecha de auditoría; captura/har pendiente; acceptance pendiente». Nota de honestidad (línea 5) conservada. | Este turno |
| `docs/kaizen/pr-drafts/kaizen-integracion-rae-api-toolkit.md` | Este descriptor (K-4). | Este turno |

### Cambios preexistentes en el árbol de trabajo (NO editados en este turno)

Pertenecen a otros procesos/roles y **deben revisarse antes de incluirlos en un PR** (K-3, un cambio lógico por commit):

- `.kaizen/team/projects/integracion-rae-api-toolkit/**` (dictámenes T1–T7, `adr-draft.md`, `decisions/`, `runbooks/`, `sandbox/`, `state.json`, `tasks.json`, `handoffs.jsonl`).
- `docs/kaizen/adr/0031-integracion-hibrida-reverse-api-engineer.md`: creado por `architect` mientras se ejecutaba este turno; estado `proposed`. **No editado aquí.**
- `.kaizen/org/knowledge/SOURCES.md` (fila TOOL-002 completada por T1/C2).
- `.kaizen/finops/token-ledger.jsonl`, `.kaizen/team/projects/opencode-local-config/{handoffs.jsonl,state.json}`, `.kaizen/team/projects/outsourcing-tech/handoffs.jsonl`, `tests/run.sh`.

## Evidencia (comandos ejecutados en este turno, 2026-11-23)

```text
git branch --show-current
→ kaizen/facilitador-opencode-local-config-verificacion

command -v reverse-api-engineer
→ /home/angel-nereira/.local/bin/reverse-api-engineer        (rc 0)

reverse-api-engineer --version
→ reverse-api-engineer, version 0.16.0                        (rc 0)

test -d ~/.agents/skills/reverse-api-engineer
→ SKILL AUSENTE

reverse-api-engineer list --json
→ []                                                           (rc 0; 0 capturas)
```

Evidencia de apoyo: `reviews/verificador-evidencias.md` (comandos 1–8, `verify` rc 0), `reviews/qa.md:47-115` (AC-1..AC-9), `reviews/architect.md`, `reviews/security.md`, `reviews/finops.md`, `adr-draft.md`, `.kaizen/loop/outbox/rae-api-instalacion-cuota.md` (`Errno 122` = EDQUOT, cuota de usuario; `df -h` no la prueba resuelta).

## Plan de prueba

| Comando | Esperado | Estado |
| --- | --- | --- |
| `reverse-api-engineer --version` / `command -v` | 0.16.0 / `~/.local/bin` | Ejecutado, rc 0 |
| `test -d ~/.agents/skills/reverse-api-engineer` | Hoy RC 1; reevaluar antes de invocar la skill | Ejecutado: ausente |
| `reverse-api-engineer list --json` | `[]` hoy; 1 entrada con `run_id` tras captura (AC-2) | Ejecutado: `[]` |
| `scripts/kaizen-team verify integracion-rae-api-toolkit` | RC 0, fuentes `verified` | Verificado por T1; reejecutar al cierre |
| `jq -e … usage.total_cost_usd` sobre metadata de captura | numérico ≥ 0 (AC-5) | Pendiente de captura autorizada |
| `grep -rIloE …` sobre HAR/artefactos (AC-4) | 0 secretos, sin imprimir valores | Pendiente de captura autorizada |
| `scripts/kaizen check` | RC 0 | **Ejecutado**: FALLA por keyword de cierre ausente + rc=124 en fase de pruebas; reportado, no silenciado (S-10) |

Datos de prueba: ninguno real; solo comandos de solo lectura. Reversibilidad: cambios aditivos y documentales en rama `kaizen/*`; revert = revertir el commit (L-7).

## Criterios de salida (AC-1..AC-9, según `reviews/qa.md`)

- **AC-1** — Prueba que falla hoy (L-6): `list --json` → `[]` y skill ausente (RC 1). Rojo histórico documentado.
- **AC-2** — Regresión verde: tras la captura, exactamente 1 entrada con el `run_id` de prueba. **Sin confirmar** hasta la captura; la ruta nativa equivaldrá a AC-3+AC-4+AC-9 (excepción documentada, no silenciada).
- **AC-3** — Captura de prueba con `run_id` no vacío que enlaza metadata ↔ `list --json` ↔ HAR. **Pendiente.**
- **AC-4** — HAR parseable, no vacío y saneado; `grep -l`/`-q` sin imprimir secretos; si aparece uno: S-12, detener y reportar sin copiarlo. **Pendiente.**
- **AC-5** — `usage.total_cost_usd` numérico ≥ 0 en metadata y registrado con `kaizen-eval metrics add`. Hoy USD 0.00; **pendiente de autorización de gasto**.
- **AC-6** — 100 % de decisiones con `source_ids verified`: `kaizen-team verify` RC 0. Fuente: T1 en verde.
- **AC-7** — `scripts/kaizen check` y `--only team` en RC 0; sin `--no-verify` ni supresiones. **Ejecutado hoy: FALLA** (descriptor sin keyword de cierre) y rc=124 en pruebas; en rojo y reportado (S-10). No se agregó un keyword de cierre falso (K-10).
- **AC-8** — ADR comparativo con `reviews/architect.md` APPROVE, `reviews/security.md` sin BLOCK abierto y aprobación humana registrada. ADR-0031 `proposed` (dirección aprobada, L-9 pendiente); **pendiente**.
- **AC-9** — «Sin depender del repo externo» = 0 imports/paquetes/llamadas CLI en código propio (menciones `*.md` excluidas). `command -v` en verde es disponibilidad, no dependencia.
- **KPI del charter adicional:** `verify` en verde **y** 1 captura saneada sobre sitio propio autorizado con `run_id` + HAR + coste; ningún BLOCK/ack pendiente/lease caducado (condición de cierre de `qa.md:115`).

## Estado real de los gates (2026-11-23, ejecutados en este turno)

```text
scripts/kaizen-team verify integracion-rae-api-toolkit
→ [kaizen-team] verify: todas las decisiones tienen fuentes verificadas
→ rc=0   (AC-6 en verde)

timeout 120 scripts/kaizen check
→ FALLA: docs/kaizen/pr-drafts/kaizen-integracion-rae-api-toolkit.md: falta keyword de cierre
→ ok: descriptores validados
→ ok: politicas de contenido
→ ok: formato
→ ok: lint
→ rc=124 (timeout en fase de pruebas, patron ya documentado en el outbox)

git status --short (antes vs despues de los gates)
→ SIN CAMBIOS ADICIONALES EN EL ARBOL
```

La FALLA del descriptor deriva de la omision deliberada del keyword de cierre: no hay issue y fabricarlo violaria K-10. No se silencia (S-10): queda registrada aqui y se escala al humano para que cree el issue o autorice la excepcion. El rc=124 es un fallo conocido y tampoco se silencia.

## Documentos tocados

- **Este turno:** `README.md`, `.kaizen/org/outsourcing/rae-api-install/evidence.md`, este descriptor (K-7).
- **Por otros roles en la rama (no editados por este turno):** runbook `rae-api-runbook.md`, `sandbox/`, dictámenes `reviews/`, `adr-draft.md`, `decisions/DEC-001`, `.kaizen/org/knowledge/SOURCES.md:39`, blackboard/standup del proyecto.

## Impacto en calidad (ratchet)

- Cobertura: igual (cambio documental; sin código nuevo).
- Advertencias de lint: igual.
- Deuda (TODO/FIXME): igual.
- Sin supresiones S-10, sin `--no-verify`, sin CI desactivada.

## Checklist

- [x] Compila (no aplica: sin código).
- [ ] Pasa tests — `scripts/kaizen check`: keyword de cierre **resuelto** con `Closes: none` (centinela aceptado por `scripts/kaizen:31`). Gates OK: descriptores, políticas de contenido, formato, lint y deuda. **Único gate rojo: `tests`** (RC 1 observado en árbol original; reintento en worktree limpio colgado y terminado con SIGTERM). Existen procesos `tests/run.sh` colgados preexistentes en el entorno. No se afirma verde ni se silencia (K-10/S-10); detalle en `.kaizen/loop/outbox/kaizen-check-sin-rc.md`.
- [x] Documentación actualizada (README, evidence, descriptor).
- [x] Línea base no empeora.
- [x] Sin push, sin commit, sin captura, sin instalación, sin credenciales leídas.

## Cierre de issues

Closes: none

No existe issue numerado asignado y GitHub no es alcanzable desde este entorno (`gh issue list` → TLS handshake timeout), por lo que no se fabricó un número remoto (K-10). Se usa el centinela `Closes: none`, que `scripts/kaizen:31` acepta explícitamente como cierre válido. Origen real: aprobación humana directa de El Presidente (2026-11-23) y tarea del proyecto `integracion-rae-api-toolkit`, con traza en `blackboard.md` y `needs-human/`. Si se crea un issue remoto más adelante, sustituir esta línea por `Closes #N`.

## Aprendizaje

La deriva documental puede sobrevivir a un `verify` en verde: `verify` valida `source_ids`, no la verdad de las frases. Corregir el estado real exige comandos reproducibles y separar «herramienta instalada» de «flujo ejecutado» (K-1/K-10). La captura sigue siendo el único cierre del KPI; este cambio solo la deja correctamente descrita.

## Cuerpo del PR (borrador)

Corrección de deriva documental de la integración RAE-API: CLI v0.16.0 instalada y verificada, 0 capturas, skill ausente en auditoría con instalación autorizada en curso, ADR-0031 en propuesta. Evidencia con TOOL-001/TOOL-002 `verified`. Descriptor K-4 con AC-1..AC-9; captura saneada y `verify` en verde como puertas pendientes. Sin push a `main`.
