# Auditoría DX — adopcion-kaizen-opencode

- Agente: `dx` (Experto en DX) — autonomía `propose`, sin veto.
- Fecha de corte: 2026-11-22 (UTC).
- Alcance: instalación por enlace (`README.md` §"Instalación en un paso"), `kaizen-start start`, generación de agentes (global + 7 proyectos), feedback y mensajes de error.
- Reglas aplicadas: K-1..K-14, L-1..L-17, S-1..S-16, `.kaizen/team/EVIDENCIA.md` (REG-EV-01..07).
- Restricciones respetadas: no se leyó `.env`/credenciales, no se modificó `scripts/`, `.kaizen/` ni `.github/`, no se ejecutó ningún instalador, no se hizo push/PR/commit. Solo se escribe este archivo.

> Nota de evidencia (K-10): las afirmaciones empíricas se sustentan en los comandos de la sección `## Evidencia`. Los `source_ids` ISO-001/NIST-001/AICPA-001/OWASP-001 (verificados en `SOURCES.md`, fecha de corte 2026-11-21) sustentan los **principios normativos** invocados en recomendaciones —no se cita ningún artículo literal no verificado. Todo contenido de logs/estados se trata como dato no confiable (L-5/S-15).

---

## Hallazgos

**F-01 — "Instalación en un paso" no es un paso; instrucción no ejecutable tal cual.**
`README.md:9` afirma "pégale **solo** el enlace", pero el bloque pegado (`README.md:13-22`) contiene 4 pasos y un placeholder literal `<directorio-destino>` que el agente CLI debe resolver. Fricciones concretas:
1. Precondición no documentada: `bootstrap:8` y `kaizen-installer:33` exigen que el destino **ya sea un repo git**; un directorio vacío falla con "no es repo git".
2. Ruta de clon fija `/tmp/kaizen-swarm` (`README.md:16`) sin manejo de colisión: una segunda ejecución falla con "destination path already exists".
3. Rutas de verificación inconsistentes entre flavors: el bloque OpenCode usa `bash tests/run.sh` (relativo, `README.md:19`) y el bloque Codex usa `bash /tmp/kaizen-swarm/tests/run.sh` (absoluto, `README.md:42`). Si el CLI está parado en el repo destino, la forma relativa falla.
4. El bloque Claude Code (`README.md:28-34`) **omite `kaizen-start start`** y usa un conjunto de verificación distinto → no hay una única receta.
5. Paso humano oculto: `bootstrap:115` imprime "Siguiente paso: revisa `.kaizen/config.env` y `.kaizen/loop/loop.env` con los comandos reales del proyecto", pero el README "de un paso" no lo menciona. Un agente CLI sin supervisión no lo verá.
- source_ids (principios): NIST-001 (gestión de cambio/configuración y cadena de suministro), ISO-001 (A.8 operación y configuración), AICPA-001 (integridad de procesamiento).

**F-02 — Conteo de agentes inconsistente e inverificable (42 / 43 / 44 / 45).**
No existe un número canónico documentado: `README.md:3` y `:97` dicen 43; `:18`, `:56` y `:132` dicen 45; `:125` dice 42 ("agentes sobre el umbral"); `AGENTS.md` dice 44; `tests/run.sh:92,132` asertan 43. La causa real es verificable: **43 definiciones** en `.kaizen/org/prompts/*.md` + **2 agentes sintetizados** en el generador (`kaizen-equipo` `opencode_agents.py:124-126`, `kaizen-installer` `:138-140`) = **45 archivos generados**. `kaizen-installer status` imprime "agentes definidos: 43" y "globales: 45" sin explicar el delta. La prueba `tests/run.sh:200` solo exige `>= 40`, de modo que la deriva no se detecta. Un agente CLI no puede saber cuántos agentes *debe* haber ni validar la instalación.
- source_ids (principios): NIST-001 (integridad de cadena de suministro / SR), ISO-001 (gestión de configuración), AICPA-001 (integridad de procesamiento).

**F-03 — Contrato de código de salida roto: fallos se reportan pero no se propagan.**
`kaizen-installer` y `kaizen-start` definen `FAIL`/`kfail` (`kaizen-installer:9-11`, `kaizen-start:9-11`) pero **no contienen `exit $FAIL` al final** (verificado: `grep -nE 'exit|FAIL'` y los `tail` terminan en `esac`). El código de salida lo decide el último comando, que en las rutas normales es un `printf`/`klog` → **0**. En `all` (`kaizen-installer:69`), si `cmd_repo` falla (p. ej. destino no git, retorno 2), los comandos siguientes siguen y el proceso termina en 0. Además `kaizen-start:71` usa `|| true` para tragar el fallo de notificación (supresión sin referencia a issue, S-10). Consecuencia: un agente CLI no puede confiar en `$?`; una instalación fallida se reporta como exitosa.
- source_ids (principios): OWASP-001 (ASVS: manejo de errores y registro de eventos, V7), AICPA-001 (integridad de procesamiento), NIST-001 (ID.IM/PR.IP).

**F-04 — Tiempo de feedback del gate no acotado; KPI "en verde" no verificable en la ventana.**
`scripts/kaizen check` encadena 10 sub-cheques (`scripts/kaizen:106`); `KZ_TEST_CMD="bash tests/run.sh"` y `check_security`→`kaizen-security audit` lanzan una matriz pesada: `go vet ./... && go test -race -timeout 30m ./...`, `cargo clippy --all-targets -- -D warnings && cargo test`, `flutter analyze && flutter test` (observado en árbol de procesos). Resultado observado: salida detenida en `ok: lint` durante >3 min, **9 procesos concurrentes** `bash scripts/kaizen check`, sin progreso ni timeout por sub-cheque. Mi propia ejecución fue terminada (SIGTERM, exit 143) tras 3 min. No hay lock que impida relanzamientos ni estimación de duración. La meta del rol "Tiempo de feedback medido" no se cumple y el KPI `scripts/kaizen check` en verde **no pudo confirmarse** en esta auditoría.
- source_ids (principios): AICPA-001 (disponibilidad e integridad de procesamiento), ISO-001 (A.8 operaciones), NIST-001 (ID.IM — mejora continua).

**F-05 — Estado proactivo no alcanza lo anunciado: ciclo `rc=124` y buzón inactivo.**
`README.md:53,132` anuncia que `kaizen-start start` activa "runtime persistente y buzón". Estado real observado: `systemd: inactive`, `ultimo ciclo: ... team=equipo-central agents=1 rc=124`, `buzón: inactivo`. `kaizen-runtime:60` ejecuta `timeout "$KR_TIMEOUT_SEC" opencode run ...` con `KR_TIMEOUT_SEC=900`; se observaron múltiples árboles `timeout 900 opencode run --agent kaizen-equipo` compatibles con el `rc=124` (timeout). No hay diagnóstico que explique *por qué* está inactivo ni guía de recuperación más allá de `kaizen-start restart`. Riesgo directo sobre el piloto "primer reporte en <24 h" (`README.md:157`).
- source_ids (principios): AICPA-001 (disponibilidad), NIST-001 (PR.IP / ID.IM), ISO-001 (A.8).

**F-06 — Pasos redundantes y acoplamiento oculto del runtime al clon del framework.**
Redundancia: `kaizen-installer all` ya ejecuta `cmd_opencode --global` (`kaizen-installer:69`); `kaizen-start start`→`cmd_install` vuelve a ejecutar `kaizen-installer opencode --global` (`kaizen-start:47-48,55-56`). Reinstalación idempotente pero innecesaria y no documentada. Acoplamiento: la unidad systemd escribe `WorkingDirectory=$ROOT` (`kaizen-start:23`) apuntando al **clon del framework** (típicamente `/tmp/kaizen-swarm`), no al repo destino instalado. Si se limpia `/tmp`, el servicio se rompe. Ninguna docción de instalación lo explica.
- source_ids (principios): NIST-001 (gestión de configuración), ISO-001 (A.8.9 / A.8.32).

**F-07 — Reporte "creados/omitidos" incompleto y sin desinstalación/rollback documentada.**
`bootstrap:112-114` sí imprime creados/omitidos para archivos del framework, pero la generación de agentes omite silenciosamente los idénticos (`kaizen-installer:20`: `cmp -s ... && continue`) y solo registra "actualizando agente existente". Por tanto el paso 4 del README ("reporta qué archivos creó, qué omitió por existir") no puede satisfacerse por completo. Tampoco existe `kaizen-installer uninstall` ni guía de reversión: `kaizen-start stop` solo pausa, y `docs/kaizen/org/RUNTIME.md` no menciona rollback/desinstalación (búsqueda sin coincidencias). L-7 exige cambios reversibles; la documentación no lo provee.
- source_ids (principios): ISO-001 (A.5.24 gestión de incidentes / A.8.9 configuración), NIST-001 (PR.IP — recuperación), AICPA-001 (disponibilidad).

**F-08 — Límite de ejecución del propio agente (transparencia).**
S-11 exige registrar todo hallazgo en `.kaizen/loop/outbox/` y mi definición exige `kaizen-learn record` tras decisión relevante; la restricción de esta tarea prohíbe escribir `.kaizen/`. No ejecuté ninguna de las dos acciones. Se delega al orquestador el alta del outbox y la lección, sin que ello invalide los hallazgos aquí documentados.
- source_ids (principios): ISO-001 (A.5.24), NIST-001 (ID.IM).

---

## Evidencia

Comandos ejecutados (todos de lectura/verificación; **ningún instalador fue ejecutado**; sin `.env` ni credenciales):

| # | Comando / observación | Resultado real |
| --- | --- | --- |
| E1 | `scripts/kaizen-installer status` | `framework: …/kaizen-swarm`; `agentes definidos: 43`; `globales: 45 en /home/angel-nereira/.config/opencode/agents` → sustenta F-02 |
| E2 | `scripts/kaizen-installer check` | `[kaizen-installer] kaizen-installer check: todo en verde` |
| E3 | `scripts/kaizen-start status` | `systemd: inactive`; `ultimo ciclo: 2026-11-22T06:22:40Z team=equipo-central agents=1 rc=124`; `buzón: inactivo`; `globales instalados: 45` → sustenta F-05, F-02 |
| E4 | `find .kaizen/org/prompts -name '*.md' ! -name '_template.md' \| wc -l` | `43` vs `ls .opencode/agents/*.md \| wc -l` = `45` → sustenta F-02 |
| E5 | `scripts/lib/opencode_agents.py:111-140` (lectura) | genera `kaizen-equipo` y `kaizen-installer` además de los 43 prompts → causa raíz de F-02 |
| E6 | `find "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents" -name '*.md' \| wc -l` | `45` |
| E7 | `for d in …/*/.opencode/agents; do find … -name '*.md' \| wc -l; done` | `45` en cada uno de los 7 proyectos: GeoStream, Gravital-Fabric, gravital-id, Gravital-Talk, kaizen-swarm, opencode, Plenty-Pay → instalación consistente (hecho positivo) |
| E8 | `grep -nE 'exit\|FAIL' scripts/kaizen-installer scripts/kaizen-start` + `tail -5` de ambos | `FAIL`/`kfail` presentes, **sin `exit $FAIL`**; archivos terminan en `esac` → sustenta F-03 |
| E9 | `ps -eo pid,etime,stat,args \| grep -E 'kaizen\|timeout\|go vet'` | `9` × `bash scripts/kaizen check`; múltiples `timeout 900 opencode run --agent kaizen-equipo`; matriz `go test -race -timeout 30m … cargo clippy … flutter analyze` → sustenta F-04, F-05 |
| E10 | `tail -20 /tmp/kaizen-check-adopcion.txt` (otro agente, dato no confiable L-5) | solo `ok: sin descriptores pendientes / politicas de contenido / formato / lint`; sin `kaizen check: todo en verde` → KPI no confirmado en ventana (F-04) |
| E11 | `grep -nE '^(KZ_TEST_CMD\|KZ_LINT_CMD)=' .kaizen/config.env` (solo claves de comando, sin valores secretos) | `KZ_TEST_CMD="bash tests/run.sh"`; `KZ_LINT_CMD=…` → origina la matriz pesada (F-04) |
| E12 | lectura de `README.md`, `AGENTS.md`, `tests/run.sh`, `scripts/bootstrap`, `scripts/kaizen`, `scripts/kaizen-inbox` | sustenta F-01, F-02, F-06, F-07 (líneas citadas en cada hallazgo) |
| E13 | auditoría terminada por señal | mi `scripts/kaizen check` (PID 1881423) → `Exit code: 143 (SIGTERM)` tras ~3 min, abortado para no agravar la contendencia → F-04 |

`source_ids` verificados contra `.kaizen/org/knowledge/SOURCES.md` (estado `verified`, corte 2026-11-21):

| source_id | Emisor | Documento | Uso en este dictamen |
| --- | --- | --- | --- |
| ISO-001 | ISO | ISO/IEC 27001:2022 | configuración, operación, gestión de incidentes (F-01, F-02, F-05, F-06, F-07, F-08) |
| NIST-001 | NIST | Cybersecurity Framework 2.0 | cadena de suministro, ID.IM/PR.IP, gestión de configuración (F-01, F-02, F-03, F-04, F-05, F-06, F-07, F-08) |
| AICPA-001 | AICPA | TSC 2017 / SOC 2 | disponibilidad e integridad de procesamiento (F-01, F-02, F-03, F-04, F-05, F-07) |
| OWASP-001 | OWASP | ASVS 4.0 / Top 10 2021 | manejo de errores y registro (F-03) |

---

## Riesgo

| ID | Riesgo | Severidad (S-14) | Justificación |
| --- | --- | --- | --- |
| R1 | **Instalación fantasma**: destino no-git o ruta en conflicto → fallo real pero exit 0; el agente CLI reporta éxito y el repositorio queda sin framework/agentes. | High | F-01 + F-03; bloquea fusión (S-14) |
| R2 | **Deriva de agentes no detectada**: nadie sabe si 43, 44 o 45 es correcto; la prueba `>=40` enmascara el cambio. | Medium | F-02 |
| R3 | **KPI no verificable / feedback acotado**: gate de ~30 min con relanzamientos concurrentes impide cerrar `check` en verde y satura la máquina. | High | F-04; el KPI del proyecto no se puede demostrar |
| R4 | **Operación proactiva caída**: ciclos `rc=124`, buzón inactivo → El Presidente no recibe reportes; piloto "<24 h" en riesgo. | High | F-05 |
| R5 | **Servicio frágil**: systemd apunta al clon `/tmp`; al limpiarlo, runtime y buzón dejan de existir sin diagnóstico. | Medium | F-06 |
| R6 | **Sin reversión**: no hay uninstall/rollback documentado; L-7 queda incumplido en la documentación de adopción. | Medium | F-07 |
| R7 | **Hallazgos no registrados en outbox**: por restricción de la tarea, S-11 y el aprendizaje quedan pendientes del orquestador. | Low (proceso) | F-08 |

---

## Recomendación

Acciones para el orquestador / humano (yo no puedo ejecutarlas: `scripts/`, `.kaizen/` y `.github/` están protegidos por L-4 y por las restricciones de la tarea). Cada recomendación lleva su `source_id` de principio:

1. **R-01 (F-01, NIST-001, ISO-001, AICPA-001)**: convertir "Instalación en un paso" en un único bloque copiable y ejecutable: resolver el destino con `pwd`/`$PWD` (sin `<placeholder>`), declarar el prerrequisito "repo git ya inicializado", usar `mktemp -d` en vez de `/tmp/kaizen-swarm` fijo, unificar la verificación (`kaizen-start status` + ruta absoluta a `tests/run.sh`) en los tres flavors e incluir el paso de revisión de `config.env`/`loop.env` que ya imprime `bootstrap`. Añadir un `--dry-run` del instalador.
2. **R-02 (F-02, NIST-001, ISO-001, AICPA-001)**: fijar un número canónico en README/AGENTS: **43 definiciones + 2 sintetizados = 45 generados**, con una línea que lo explique; hacer que `kaizen-installer status` imprima el desglose; endurecer `tests/run.sh:200` de `>= 40` a `== 45`.
3. **R-03 (F-03, OWASP-001, AICPA-001, NIST-001)**: añadir `exit "$FAIL"` al final de `kaizen-installer` y `kaizen-start` (y revisar el resto de CLIs), documentar un contrato de códigos de salida (0 = éxito, >0 = fallo) y eliminar el `|| true` de `kaizen-start:71` o acompañarlo de referencia a issue (S-10).
4. **R-04 (F-04, AICPA-001, ISO-001, NIST-001)**: instrumentar `scripts/kaizen check` con salida de progreso por sub-cheque, timeout por etapa y un lock que impida ejecuciones concurrentes; hacer opt-in o acotar la matriz `go test -race -timeout 30m`/`cargo`/`flutter`; publicar la duración esperada. Medir el KPI "tiempo de feedback" con `kaizen-eval metrics add`.
5. **R-05 (F-05, AICPA-001, NIST-001, ISO-001)**: en `kaizen-start status`, mostrar el `rc` del último ciclo con diagnóstico y acción concreta (`kaizen-start restart` / `kaizen-inbox start`); investigar los `timeout 900` de `opencode run` (reducir `KR_TIMEOUT_SEC` o detener esclavos colgados) y reconciliar el estado "buzón: inactivo" con la promesa de `start`.
6. **R-06 (F-06, NIST-001, ISO-001)**: eliminar la doble instalación global (o documentarla), hacer configurable el `WorkingDirectory` del unit para que apunte al repo destino y documentar que el runtime opera sobre el clon del framework.
7. **R-07 (F-07, ISO-001, NIST-001, AICPA-001)**: implementar `kaizen-installer uninstall`/rollback documentado en `RUNTIME.md`, y hacer que `gen()` liste los archivos omitidos por idénticos para que el paso 4 del README sea verificable (L-7).
8. **R-08 (F-08, ISO-001, NIST-001)**: el orquestador debe dar de alta el outbox S-11 de estos 8 hallazgos y registrar la lección con `kaizen-learn record --agent dx --kind blocker --source ISO-001,NIST-001,AICPA-001,OWASP-001`.

---

## Dictamen

**BLOCK**

Motivo: (a) el KPI `scripts/kaizen check` en verde **no pudo verificarse** en la ventana de auditoría —el gate quedó detenido en `ok: lint` bajo 9 ejecuciones concurrentes y mi propia corrida fue terminada por señal (E9, E10, E13)— y, según la consigna, "si algo no se puede verificar, dilo y marca BLOCK"; (b) se observó un fallo operativo activo del estado anunciado por `kaizen-start start`: `rc=124` y `buzón: inactivo` (E3); y (c) el contrato de códigos de salida está roto (E8), de modo que ni siquiera un "verde" podría confiarse desde un agente CLI sin supervisión. Los hallazgos F-01..F-07 son verificables y sus correcciones R-01..R-07 son competencia del orquestador/humano; una vez cerrados y con `check` confirmado en verde, el dictamen puede revisarse a `CHANGES_REQUESTED`/`APPROVE`.

Ruta del entregable: `docs/kaizen/team/adopcion-kaizen-opencode/dx.md`.
