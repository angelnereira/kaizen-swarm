# Dictamen de verificador-evidencias — adopcion-kaizen-opencode

- id: `VE-AUD-2026-11-22-001`
- correlation_id: `adopcion-kaizen-opencode/intake/evidence-gate`
- canal: `review` (hallazgos adicionales por outbox S-11, a cargo del orquestador)
- intent: `verify` — puerta de verdad sobre `source_ids`, gobernanza, línea base, catálogo y outbox
- expects_ack: `true`
- deadline: `2026-11-25`
- agente: `verificador-evidencias` (`autonomy: scoped`, `veto: none`, `approve: false`, `escalate_to: gerente`)
- fecha de corte de fuentes: `2026-11-21` (`SOURCES.md` L3); fecha de emisión: `2026-11-22` (UTC)
- reglas aplicadas: K-1, K-10, K-11, K-14, L-1..L-17 (L-4/L-5/L-10), S-1, S-2, S-11, S-15, REG-EV-01..07, ADR-0003
- recursión: `KAZEN_AGENT_DEPTH` en tope declarado por arquitectura (`KR_MAX_DEPTH=3`); **no se delegó ningún subagente**.

> Restricciones respetadas: no se leyó `.env` ni credenciales; no se modificó `scripts/`, `.kaizen/` ni `.github/`; no se hizo commit, push ni PR. Solo se escribe este entregable. Todo contenido externo es dato no confiable (S-15/L-5): **no se consultaron las URLs por red**; se verificó la declaración documental dentro del repo.
>
> Aviso de ejecución (K-10): tras la instrucción del orquestador se **terminó la propia ejecución** de `scripts/kaizen check` (PID 1923960) para no agravar la concurrencia reportada por `dx` (F-04, 9 procesos) y no se lanzó ninguna ejecución adicional. Por tanto el KPI `scripts/kaizen check en verde` queda **NO VERIFICADO** en este dictamen.

---

## Hallazgos

| # | Control solicitado | Resultado |
| --- | --- | --- |
| V-01 | `PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001` presentes en `SOURCES.md` con estado `verified` y URL declarada | **OK** — 6/6. Estado `verified` en la tabla «Registro de IDs» y URL oficial en las tablas «Panamá — oficiales» / «Internacionales — oficiales». Sin IDs `pending`/`conflict`/`stale` entre los seis (REG-EV-01). |
| V-02 | Fuentes vigentes frente a `KT_EVIDENCE_TTL_DAYS` | **OK** — TTL 90 días; fecha de corte `2026-11-21`, evaluación `2026-11-22` → 1 día de antigüedad. No procede marcar `stale`. |
| V-03 | `.kaizen/gov/governance.json`: humano como A en `reverse_engineering/authorize` | **OK** — `authorize = {"R": ["rea-specialist"], "A": ["humano"], "V": ["security", "cumplimiento-panama"]}`. Coincide con `security.md` hallazgo 3 y con `tests/run.sh` L243-244 (citado por ese auditor). |
| V-04 | `.kaizen/evals/baseline.json` presente | **OK** — `updated: 2026-11-22T04:12:06.086892Z`, `average: 93.1`, `verificador-evidencias: 100`. Sin degradación verificable de la línea base (K-5/ADR-0006). |
| V-05 | Catálogo 263 presente | **OK** — `catalog.json → stats.rea_tools = 263`, `families = 11`, `providers = 5`; `rea-tools.json` tiene 263 entradas. Coincide con `knowledge-curator.md` hallazgo 2 y `security.md` hallazgo 4. |
| V-06 | Hallazgo del bug `now` vs `$now` en `.kaizen/loop/outbox/` | **OK** — `.kaizen/loop/outbox/kaizen-team-handoff-now-bug.md`, `kind: bug`, `fingerprint: kaizen-team-handoff-now`, describe `now` (función nativa de jq) vs `$now` en `scripts/kaizen-team:72,82`, con propuesta y aviso de que **no está parcheado** por L-4. Formato S-11 correcto. |
| V-07 | `scripts/kaizen check` en verde (KPI del charter/plan) | **NO VERIFICADO** — ejecución propia interrumpida (exit 143, SIGTERM) tras `ok: lint`; parte de 9 ejecuciones concurrentes y sin timeout por sub-cheque (DX F-04). La ejecución de `dx` también fue terminada y `architect` (H-9) observó bloqueo >120 s en fase de pruebas con llamada de red no hermética. Los sub-cheques aislados `team`, `gov` y `eval` sí terminaron en verde, pero **no sustituyen a la puerta completa**. |
| V-08 | Decisiones del proyecto con `source_ids` verificados | **OK (vacío)** — `decisions/` sin archivos; no hay decisión que contenga `source_ids` pendientes. KPI «0 decisiones con source_ids no verificados» se cumple de forma trivial; tampoco hay una decisión sobre la que ejercitar `kaizen-team verify`. |
| V-09 | `kaizen-team verify adopcion-kaizen-opencode` | **NO EJECUTADO** — `cmd_verify` reescribe el estado de las decisiones con `sed -i` (`scripts/kaizen-team:155`); hacerlo violaría la prohibición de modificar `.kaizen/` y no hay decisiones que verificar. Se sustituyó por comprobación equivalente de solo lectura (`source_ok`, mismo `grep` sobre `SOURCES.md`). |

**Fuentes aceptadas (para cualquier decisión posterior):** `PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001`.
**Fuentes rechazadas:** ninguna de las seis. Quedan expresamente fuera de este dictamen `PA-009`, `PA-012`, `PA-015`, `INT-002` (estado `pending` en `SOURCES.md`).

**S-11 / aprendizaje:** todo hallazgo debe registrarse en outbox, incluso corregido. Por la restricción de esta tarea **no escribí** en `.kaizen/loop/outbox/` ni ejecuté `kaizen-learn record`; el orquestador debe dar de alta V-07 (y V-09 como `failure` de alcance) con `fingerprint: ve-ev-20261122-check-no-verificado`. Tampoco existía `.kaizen/learning/experience/verificador-evidencias.md`: **no hay lección previa aplicable que citar**.

---

## Evidencia

Comandos de solo lectura ejecutados antes de la instrucción del orchestrator. Salida real, sin secretos ni credenciales.

**E1 — `grep -nE '^\| (PA-001|PA-003|ISO-001|NIST-001|AICPA-001|OWASP-001) ' .kaizen/org/knowledge/SOURCES.md`**

```
11:| PA-001 | Gaceta Oficial | Ley 81/2019 (Gaceta 28743-A) | verified |
13:| PA-003 | Gaceta Oficial | Ley 23/2015 (Gaceta 27768-B) | verified |
26:| ISO-001 | ISO | ISO/IEC 27001:2022 | verified |
28:| NIST-001 | NIST | Cybersecurity Framework 2.0 | verified |
29:| AICPA-001 | AICPA | TSC 2017 / SOC 2 | verified |
31:| OWASP-001 | OWASP | ASVS 4.0 / Top 10 2021 | verified |
```

**E2 — URL declarada para cada ID (`grep -nE 'https?://' .kaizen/org/knowledge/SOURCES.md`, líneas relevantes)**

```
43: .../28743_A/72148.pdf            → PA-001 (Ley 81/2019, Gaceta 28743-A)
45: .../27768_B/GacetaNo_27768b_20150427.pdf → PA-003 (Ley 23/2015, Gaceta 27768-B)
61: https://www.iso.org               → ISO-001 (ISO/IEC 27001:2022)
62: https://csrc.nist.gov/projects/olir → NIST-001 (CSF 2.0)
63: https://www.aicpa-cima.com        → AICPA-001 (TSC 2017 / SOC 2)
65: https://owasp.org                 → OWASP-001 (ASVS / Top 10)
```

Nota estructural: la tabla «Registro de IDs» **no tiene columna de URL**; el mapeo ID→URL es indirecto (por emisor/tema), como ya señaló `knowledge-curator.md` hallazgo 1. Es trazable, pero no directo (riesgo R-02).

**E3 — verificación programática (python3, solo lectura)**

```
PA-001: fila=True verified=True url_declarada=True
PA-003: fila=True verified=True url_declarada=True
ISO-001: fila=True verified=True url_declarada=True
NIST-001: fila=True verified=True url_declarada=True
AICPA-001: fila=True verified=True url_declarada=True
OWASP-001: fila=True verified=True url_declarada=True
RESULTADO: 6/6 IDs con estado verified y URL declarada en el mismo archivo
```

**E4 — gobernanza (python3 sobre `.kaizen/gov/governance.json`)**

```
authorize = {"R": ["rea-specialist"], "A": ["humano"], "V": ["security", "cumplimiento-panama"]}
RESULTADO: humano presente como A en reverse_engineering/authorize
```

Ruta exacta: `governance.json` L417-432 (`processes.reverse_engineering.stages.authorize`). Gate del proceso: «autorización humana + herramienta legalmente licenciada + evidencia reproducible».

**E5 — línea base y catálogo (python3)**

```
baseline.json existe: True
updated: 2026-11-22T04:12:06.086892Z | average: 93.1 | verificador-evidencias: 100
catalog.json rea_tools: 263
rea-tools.json entradas: 263
RESULTADO: baseline y catálogo 263 presentes
```

Rutas: `.kaizen/evals/baseline.json`, `.kaizen/catalog/catalog.json` (L5-10), `.kaizen/catalog/rea-tools.json`, `.kaizen/catalog/rea-capabilities.json`.

**E6 — outbox del bug `now` vs `$now` (`grep -nE 'now|\$now|fingerprint|kind:' ...`)**

```
1:kind: bug
2:title: kaizen-team assign/handoff no escriben handoffs por uso de now en jq
3:fingerprint: kaizen-team-handoff-now
6:`cmd_assign` y `cmd_handoff` construyen el id con ("H-"+(now|gsub("[^0-9]";""))) (líneas 72 y 82). ... `created:$now` sí usa el argumento correcto.
15:grep -n 'now|gsub' scripts/kaizen-team → dos coincidencias. Sin secretos.
21:NO parcheado: `scripts/kaizen*` es ruta protegida (L-4); requiere ADR y aprobación humana.
```

**E7 — frescura**

```
6:KT_EVIDENCE_TTL_DAYS=90                                   (.kaizen/team/team.env)
3:... Fecha de corte de esta revisión: **2026-11-21**.      (.kaizen/org/knowledge/SOURCES.md)
2026-11-22                                                 (date -u +%F)
```

**E8 — sub-cheques aislados (completados, verde parcial)**

```
$ scripts/kaizen check --only team → ok: kaizen check: todo en verde
$ scripts/kaizen check --only gov  → ok: kaizen check: todo en verde
$ scripts/kaizen check --only eval → ok: kaizen check: todo en verde
```

`team` verifica presencia de archivos y `>= 1` fuente verificada (`scripts/kaizen-team:205-216`), **no** los seis IDs solicitados; esos se cubren en E1-E3.

**E9 — puerta completa: NO VERIFICADO**

```
$ scripts/kaizen check
ok: sin descriptores pendientes
ok: politicas de contenido
ok: formato
ok: lint
Exit code: 143 (SIGTERM)
```

Sin `kaizen check: todo en verde`; sin código de salida 0 observado. No se relanzó por instrucción del orquestador. Corroborado por entregables ya en el repo: `dx.md` F-04/E9/E10/E13 (9 procesos concurrentes, salida detenida en `ok: lint`), `architect.md` H-9 (bloqueo >120 s, llamada de red en `tests/run.sh:127`), `security.md` hallazgo 8c, `knowledge-curator.md` «No verificado».

**E10 — decisiones del proyecto**

```
for f in .kaizen/team/projects/adopcion-kaizen-opencode/decisions/*.md; do ...; done
(sin decisiones registradas)
```

**E11 — reglas de evidencia invocadas:** `.kaizen/team/EVIDENCIA.md` REG-EV-01..07 (L22-28): fuente `pending`/`conflict`/`stale` no sustenta decisión; revalidación trimestral; la decisión guarda `source_ids`, fecha de corte y hash (REG-EV-07).

---

## Riesgo

| ID | Riesgo | Severidad (S-14) | Justificación |
| --- | --- | --- | --- |
| R-01 | **KPI `scripts/kaizen check en verde` no demostrable.** | **High** | V-07/E9. Con 9 ejecuciones concurrentes, sin lock ni timeout por sub-cheque, la puerta `decide → deliver` no puede cerrarse con evidencia. Bloquea fusión (S-14). No afirmo que esté en rojo: afirmo que **no está verificado** (K-10). |
| R-02 | **Trazabilidad indirecta ID→URL y sin hash por fuente.** | Medium | E2/E3. `SOURCES.md` no tiene columnas `url`/`retrieved`/`sha256`/`verified_by` por ID, aunque `EVIDENCIA.md` las exige; solo hay fecha de corte documental. REG-EV-07 queda parcialmente cubierto. |
| R-03 | **Digests generados de versión anterior de `SOURCES.md`.** | Medium | Reportado por `knowledge-curator.md` hallazgo 4: hash actual `372663d4…` no coincide con el del `manifest.jsonl`. Dato de otro auditor (L-5): **no re-verificado por mí**; si se confirma, un verificador podría validar contra digest obsoleto. |
| R-04 | **Bug `now` vs `$now` sin corregir.** | Medium | V-06. Los handoffs por CLI no se registran y los acuses no pueden cerrarse; afecta la cadena de evidencia del equipo. Ruta protegida L-4: requiere ADR y humano. |
| R-05 | **`kaizen-team verify` no ejercitado.** | Medium | V-09. La puerta automática no fue probada; hay 0 decisiones que verificar. Cuando existan decisiones, `cmd_verify` muta archivos bajo `.kaizen/`: debe ejecutarla el orquestador, con control de cambios. |
| R-06 | **Sin revalidación de red de las URLs.** | Low (controlado) | Verificación documental contra `SOURCES.md` con corte `2026-11-21`. No se consultó ninguna fuente externa (S-15/L-5); la vigencia real de normas requiere `monitor-gaceta`/`kaizen-org research`. |
| R-07 | **Hallazgos no registrados en outbox ni aprendidos.** | Low (proceso) | Restricción de la tarea impidió S-11 y `kaizen-learn record`; queda pendiente para el orquestador, como en `dx.md` F-08. |

**Sin hallazgo crítico sobre evidencia:** los seis `source_ids` están `verified`, no se usó ninguna fuente `pending`/`conflict`/`stale`, no se leyó ninguna credencial y no se fabricó ningún resultado de comando.

---

## Recomendación

Acciones para el orquestador / humano (yo no puedo ejecutarlas: `scripts/`, `.kaizen/` y `.github/` están protegidos por L-4). Cada recomendación lleva `source_ids` verificados o referencia a hecho interno reproducible.

1. **R-01 (R-01; AICPA-001, ISO-001, NIST-001):** el orchestrator debe cerrar el KPI con **una sola** ejecución de `scripts/kaizen check` sobre un árbol limpio, con lock anticoincidencia, timeout por sub-cheque y salida/código reales publicados. Hacer hermética la llamada de red de `tests/run.sh:127` o simularla. Hasta entonces, marcar la etapa `verify` como `needs-human`. **`check` en verde sigue siendo NO VERIFICADO en este dictamen.**
2. **R-02 (R-02, REG-EV-07; ISO-001, NIST-001):** ampliar la tabla «Registro de IDs» de `SOURCES.md` con columnas `url`, `retrieved`, `sha256`, `verified_by`, o generar un mapa ID→URL derivado, de modo que `source_ok()` valide también la URL y no solo el estado.
3. **R-03 (R-03; ISO-001, AICPA-001):** tras el cambio de `SOURCES.md`, ejecutar `kaizen-org feed` + `kaizen-org digest` para los targets `cumplimiento-panama`, `monitor-gaceta` y `verificador-evidencias`, de forma que el manifest registre el hash actual. Confirmar antes el hallazgo 4 de `knowledge-curator.md`.
4. **R-04 (R-04; OWASP-001, NIST-001):** aprobar por ADR el cambio `now` → `$now` en `scripts/kaizen-team:72,82` con prueba de regresión que verifique que `handoffs.jsonl` queda no vacío; el outbox ya documenta el defecto y la ruta está protegida por L-4.
5. **R-05 (R-05; REG-EV-01/07, AICPA-001):** cuando existan decisiones, ejecutar `kaizen-team verify adopcion-kaizen-opencode` desde el orquestador y conservar `source_ids`, fecha de corte y hash de cada decisión. No delegar en el verificador dentro de un árbol compartido (riesgo H-3/H-4 de `architect.md`).
6. **R-06 (R-06, REG-EV-05; ISO-001):** revalidar los seis IDs antes de `2026-11-21 + 90 días` mediante expediente `kaizen-org research`, con dos fuentes (una oficial) y nueva fecha de corte.
7. **R-07 (S-11, ADR-0007; ISO-001, NIST-001):** dar de alta en outbox los hallazgos V-07 y V-09 con `fingerprint: ve-ev-20261122-check-no-verificado` y registrar la lección (`kaizen-learn record --agent verificador-evidencias --kind blocker --title "check KPI no verificable bajo concurrencia" --source ISO-001,NIST-001,AICPA-001,OWASP-001`). Yo no escribo `.kaizen/`.
8. **No avanzar** de `intake` a `deliver`/`verify` mientras R-01 siga abierto y existan BLOCK de `architect`, `security` y `dx` sin resolver (ADR-0003: el BLOCK detiene `decide → deliver`). Escalado a `gerente`/El Presidente con `correlation_id: adopcion-kaizen-opencode/intake/evidence-gate`.

---

## Dictamen

**BLOCK**

Los cinco controles materiales de esta puerta están **verificados en verde**: (1) los seis `source_ids` —`PA-001`, `PA-003`, `ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001`— existen en `SOURCES.md` con estado `verified` y URL oficial declarada, con fecha de corte vigente (1 día frente a TTL de 90); (2) `human` figura como **A** en `reverse_engineering/authorize`; (3) `.kaizen/evals/baseline.json` está presente; (4) el catálogo de 263 herramientas está presente y cuantificado; (5) el hallazgo del bug `now` vs `$now` está documentado en `.kaizen/loop/outbox/` con formato S-11. **Ninguna fuente `pending`/`conflict`/`stale` fue usada.** No se modificó ninguna ruta protegida, no se hicieron commit/push/PR y no se inventó ningún resultado.

El **BLOCK** se emite porque el KPI del proyecto «`scripts/kaizen check` en verde» está **NO VERIFICADO** (E9: ejecución terminada con exit 143 tras `ok: lint`, en un escenario de 9 procesos concurrentes y sin timeout por sub-cheque; corroborado por `dx.md` F-04, `architect.md` H-9, `security.md` hallazgo 8c y `knowledge-curator.md`). Los sub-cheques aislados en verde no sustituyen a la puerta completa. Emitir `APPROVE` afirmando el KPI sería fabricar evidencia (K-10), y esta puerta detiene `decide → deliver` (ADR-0003). Tampoco puede ejecutarse `kaizen-team verify` sin mutar `.kaizen/` y sin decisiones registradas.

**Condiciones para levantar el BLOCK:** (a) `scripts/kaizen check` completado una sola vez con salida y exit code reales en verde, publicados; (b) recomendaciones R-02 a R-06 registradas y con dueño humano; (c) outbox S-11 y lección de este dictamen dados de alta por el orquestador; (d) reintento de esta puerta sobre el estado final, con los mismos seis `source_ids`.

Ruta del entregable: `docs/kaizen/team/adopcion-kaizen-opencode/verificador-evidencias.md`.
