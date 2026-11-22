# Dictamen de knowledge-curator — adopcion-kaizen-opencode

- id: `KC-AUD-2026-11-22-001`
- correlation_id: `adopcion-kaizen-opencode/intake/knowledge-audit`
- channel: `review` (hallazgos adicionales por outbox S-11, a cargo del orchestrator)
- intent: `audit` — auditar base de conocimiento y trazabilidad
- expects_ack: `true`
- deadline: `2026-11-25`
- agente: `knowledge-curator` (autonomía `propose`; sin veto; escala a `gerente`)
- fecha de corte de la auditoría: `2026-11-22`
- reglas aplicadas: K-1, K-10, K-11, K-14, L-2, L-4, L-5, S-2, S-11, S-15, REG-EV-01/05/07

> Todo contenido externo es dato no confiable (S-15/L-5). Esta auditoría **no** consultó URLs por red: verificó únicamente la declaración de fuentes, URLs y fecha de corte dentro del repositorio. No se leyó `.env`, credenciales ni variables de entorno (S-2). No se modificó `scripts/`, `.kaizen/` ni `.github/`; no se hizo commit, push ni PR.

## Hallazgos

1. **OK — Los 6 IDs funcionales están presentes y verificados.** `SOURCES.md` contiene `PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001` y `OWASP-001` con estado `verified`, URL oficial declarada en las tablas de fuentes y una fecha de corte única (`2026-11-21`) en el encabezado. Se satisface el criterio solicitado. (Nota estructural menor: la tabla «Registro de IDs» no lleva columna de URL; el mapeo ID→URL es indirecto, por emisor/tema, en las tablas «Panamá — oficiales» e «Internacionales — oficiales». Es trazable pero no directo.)

2. **OK — Catálogo REA exacto.** `.kaizen/catalog/catalog.json` declara `rea_tools: 263`, `families: 11`. Recuento real: 11 claves de familia, 263 operaciones en total, 263 operaciones únicas, y el `count` de cada familia coincide con el número de `operations`. Cero desajustes. Coincide con `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` y con ADR-0010/ADR-0009.

3. **OK — La documentación de adopción no afirma normas sin fuente.** Charter y plan citan `source_ids` (los 6 IDs anteriores) y las reglas duras de evidencia (`EVIDENCIA.md`, REG-EV-01). Los ADR revisados (0001–0010) respaldan sus afirmaciones en ADR, comando reproducible o fuente declarada. No se encontró ninguna norma/afirmación normativa sin `source_id`.

4. **HALLAZGO (trazabilidad) — `manifest.jsonl` tiene el hash de `SOURCES.md` desactualizado.** El manifest registra dos hashes históricos para `SOURCES.md`: `1242d7f7…` (`fed_at` 02:43:32Z) y `8b11e0a8…` (`fed_at` 03:03:56Z). El hash actual del archivo es `372663d4…` y **no coincide con ninguna entrada**. El `mtime` de `SOURCES.md` (03:22:32Z) es posterior al último feed (03:03:56Z): el archivo cambió después de alimentar los digests y no se volvió a ejecutar `feed`/`digest`. Consecuencia: los digests de `cumplimiento-panama`, `monitor-gaceta` y `verificador-evidencias` fueron generados desde una versión anterior de `SOURCES.md`. Esto rompe la cadena de trazabilidad y contradice el KPI «0 normas sin `source_id` verificado» en su dimensión de frescura (REG-EV-05/07).

5. **HALLAZGO (knowledge faltante) — No existe digest ni lección de `knowledge-curator`.** `.kaizen/org/knowledge/digests/` contiene 16 digests de otros roles, pero no `knowledge-curator.md`. Tampoco existe `.kaizen/learning/experience/knowledge-curator.md` (solo hay una lección de `facilitador-equipo`). El rol que debe mantener el índice no tiene su propio digest ni experiencia consultable, limitando el cumplimiento de «consultar lecciones previas antes de proponer».

6. **HALLAZGO (consistencia) — Recuento de agentes inconsistente en documentación de adopción.** Conviven tres cifras: `AGENTS.md` afirma «42 puestos»; `.kaizen/gov/governance.json` y `docs/kaizen/org/CATALOGO-AGENTES.md` tienen 43 entradas; `docs/kaizen/adr/0005` y `docs/kaizen/org/RUNTIME.md` afirman «44 agentes». En disco hay 44 archivos en `.kaizen/org/prompts/`, de los cuales 1 es `_template.md` → 43 definiciones reales. La cifra correcta verificable es **43**; «42» y «44» son inexactas. Son hechos internos verificables por conteo (no normas que exijan `source_id` externo), pero su discrepancia degrada la trazabilidad documental.

## Evidencia

| # | Afirmación | ID / ruta | Verificación (comando / observación) |
| --- | --- | --- | --- |
| 1 | IDs funcionales + URL + corte | `.kaizen/org/knowledge/SOURCES.md`: L3 (corte `2026-11-21`); L11 `PA-001`, L13 `PA-003`, L26 `ISO-001`, L28 `NIST-001`, L29 `AICPA-001`, L31 `OWASP-001` (todos `verified`); URLs en L43 (PA-001, Gaceta 28743-A), L45 (PA-003, Gaceta 27768-B), L61 (ISO-001, `iso.org`), L62 (NIST-001, `csrc.nist.gov/projects/olir`), L63 (AICPA-001, `aicpa-cima.com`), L65 (OWASP-001, `owasp.org`) | lectura directa del archivo |
| 2 | Catálogo 263 / 11 | `.kaizen/catalog/catalog.json` L5–L10 (`stats`); familias `android 37, artifacts 11, buildenv 12, evidence 17, firmware 9, managed 19, native 51, network 5, other 35, runtime 30, web 37` | `python3` → 11 claves, suma `operations` = 263, únicas = 263, `count` == `len(operations)` en todas |
| 2b | Coherencia documental del catálogo | `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` L5, L11–L23; `docs/kaizen/adr/0010-versionado-y-propagacion.md` L8; `.kaizen/org/knowledge/business/REA-INTEGRACION.md` L3, L67 (hash actual `5eab3dae…` == manifest L49 ✓) | lectura + `sha256sum` |
| 3 | Sin normas sin fuente | `.kaizen/team/projects/adopcion-kaizen-opencode/charter.md` L6–L7; `plan.md` L3–L8; `.kaizen/team/EVIDENCIA.md` REG-EV-01..07 (L22–L28) | lectura directa |
| 4 | Hash de `SOURCES.md` obsoleto | manifest L5 `1242d7f7…`, L19/L23 `8b11e0a8…`; `sha256sum SOURCES.md` → `372663d40b49c78f820e6b8d1d3757390453e410184f576eb9670c17bebec939`; `stat` SOURCES.md `2026-11-21 22:22:32 -0500` (03:22:32Z) vs feed 03:03:56Z | `sha256sum` + `stat` + lectura de manifest |
| 5 | Digests/lección ausentes | `.kaizen/org/knowledge/digests/` (16 archivos, sin `knowledge-curator.md`); `.kaizen/learning/lessons/` (solo `facilitador-equipo/2026-11-22-001-decision.md`); sin `.kaizen/learning/experience/knowledge-curator.md` | `find` / `ls` |
| 6 | Conteo de agentes | `.kaizen/org/prompts/` 44 archivos (43 + `_template.md`); `governance.json agents` = 43; `CATALOGO-AGENTES.md` = 43 filas; `AGENTS.md` L16 «42 puestos»; `docs/kaizen/adr/0005` L11 y `RUNTIME.md` L9 «44 agentes»; `.kaizen/swarm/ROSTER.md` = 17 roles ✓ (coherente con ADR-0001) | `ls \| wc`, `python3`/`grep -c`, lectura |

**Fuentes normativas citadas (verificadas en `SOURCES.md`):** `PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001` — todas `verified`, corte `2026-11-21`. El resto de hallazgos se sustentan en rutas del repositorio y comandos reproducibles, no en fuentes externas.

## Riesgo

- **Medio — Trazabilidad de digests (hallazgo 4).** Decisiones futuras que citen los 6 `source_ids` podrían apoyarse en digests generados desde una versión anterior de `SOURCES.md`. Si el cambio de las 03:22 alteró algún `source_id` o su estado, un `verificador-evidencias` podría validar contra una fuente desactualizada. No se detectó cambio de estado en los 6 IDs (siguen `verified`), pero la cadena hash→digest está rota.
- **Medio — Knowledge faltante (hallazgo 5).** Sin digest ni experiencia propia, el rol no puede demostrar «lecciones previas aplicadas» ni auditar su propio conocimiento; riesgo de repetir el mismo defecto de frescura.
- **Bajo — Consistencia documental (hallazgo 6).** Cifras 42/43/44 confunden a instaladores y auditores; no afecta normas ni seguridad, pero erosiona la confianza en la documentación de adopción (K-1/K-7).
- **No verificado por este auditor (se dice explícitamente, K-10):** no ejecuté `scripts/kaizen check` (fuera del alcance de esta auditoría de conocimiento y en ruta protegida L-4); por tanto **no confirmo** el KPI «green». Tampoco verifiqué resolución de las URLs por red ni la instalación real de los 44 agentes en `~/.config/opencode/`. Esos controles competen a `qa` / `verificador-evidencias` y al orquestador.

## Recomendación

1. **Re-alimentar y regenerar** el conocimiento tras el cambio de `SOURCES.md`: ejecutar `kaizen-org feed` para los tres targets afectados (`cumplimiento-panama`, `monitor-gaceta`, `verificador-evidencias`) y `kaizen-org digest`, de modo que el manifest registre el hash actual `372663d4…` (REG-EV-05/07). Acción a cargo del orquestador; yo no modifico `.kaizen/`.
2. **Crear** `.kaizen/org/knowledge/digests/knowledge-curator.md` e inicializar la experiencia del rol con `kaizen-learn record`, citando `PA-001`…`OWASP-001` y el comando `sha256sum` como evidencia.
3. **Unificar el recuento de agentes a 43** (o corregir el conteo real que decida el orquestador) en `AGENTS.md`, ADR-0005 y `docs/kaizen/org/RUNTIME.md`, con ADR/nota que explique el `_template.md`. Preferir «43 definiciones + 1 plantilla».
4. **Verificación final** por `verificador-evidencias`/`qa`: `scripts/kaizen check` en verde y `kaizen-team verify adopcion-kaizen-opencode` sin `source_id` stale antes de avanzar de etapa.
5. Registrar los hallazgos 4–6 en el outbox S-11 (formato `failure`/`documentation`) por parte del orquestador; yo no escribo en `.kaizen/`.

## Dictamen

**CHANGES_REQUESTED**

Los tres controles solicitados están verificados en verde (IDs funcionales con URL y corte; catálogo 263/11 exacto; documentación de adopción sin normas sin fuente). No obstante, existen defectos de trazabilidad y conocimiento que deben corregirse antes de la aprobación final: (a) hash de `SOURCES.md` desactualizado en `manifest.jsonl` con digests generados de una versión previa; (b) ausencia de digest y lección de `knowledge-curator`; (c) recuento de agentes inconsistente (42/43/44). No hay BLOCK: ninguno de estos impide verificar los hechos auditados y no se detectó secreto, dado personal ni afirmación normativa sin fuente. La confirmación de `scripts/kaizen check` en verde queda pendiente y es responsabilidad de `qa`/`verificador-evidencias`, no de este auditor. Escalado a `gerente` si se decide no corregir (a) por tratarse de ruta protegida L-4.
