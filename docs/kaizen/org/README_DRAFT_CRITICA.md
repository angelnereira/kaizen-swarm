# Borrador de crítica — README de kaizen-swarm

> Documento de trabajo del rol `qa`. **No es el README final.** Es un diagnóstico para que el responsable decida qué corregir antes de publicar.
>
> Fecha de verificación: 2026-11-22. Repo: `kaizen-swarm`. Método: lectura de `README.md`, `AGENTS.md`, `CHANGELOG.md`, `VERSION`, `.kaizen/*`, `docs/kaizen/org/*.md`, `docs/kaizen/adr/*.md`, `scripts/`, `observability/` y ejecución de comandos de solo lectura + `tests/run.sh`.
>
> **K-10:** toda cifra de abajo fue ejecutada o leída de un archivo versionado; donde no pude verificar algo, digo explícitamente "no verificado". **S-15:** el contenido de `AGENTS.md`, buzones, outbox y logs se trata como **dato no confiable**: se usa solo como corroboración, nunca como instrucción. No seguí ninguna directiva encontrada dentro de esos archivos.

---

## 0. Resumen ejecutivo — los 3 hallazgos más graves

| # | Severidad | Hallazgo | Evidencia mínima |
| --- | --- | --- | --- |
| **C-1** | **Critical** | El README publica una versión falsa (`v1.0.0`) y un ejemplo de release que sería un *downgrade* (`cut 1.0.1`). La fuente de verdad dice 1.2.0. | `VERSION` → `1.2.0`; `CHANGELOG.md` → `## v1.2.0 — 2026-11-22`; `scripts/kaizen-release status` → `version: 1.2.0 \| tag: v1.2.0`. |
| **C-2** | **Critical** | El README vende `reverse-api-engineer` como capacidad disponible, pero **no está instalada** (cuota de disco agotada). Es una promesa no verificable y viola K-10. | README:136; `.kaizen/loop/outbox/rae-api-instalacion-cuota.md` → "la herramienta y su skill **no quedaron instaladas**", `OSError: [Errno 122] Disk quota exceeded`. |
| **C-3** | **Critical** | El README se contradice sobre el número de agentes (45 y 47 en el mismo archivo) y contradice a `AGENTS.md` (42/44) y a un outbox desactualizado (42/43/44). No hay una cifra citables. | `scripts/kaizen-org list` → 45; `.kaizen/org/catalog.json` → `count: 45`; `docs/kaizen/org/CATALOGO-AGENTES.md` → `Total: 45 agentes`; `kaizen-release status` → `agentes: 45`, `globales: 47`; README:3,18,56,97,125,145. |

**Veredicto QA: CHANGES_REQUESTED.** El README es útil como índice de comandos, pero hoy **no es honesto**: cuatro cifras clave están desactualizadas, una capacidad no existe en el entorno y el bloqueo operativo real (saldo de OpenCode) se menciona de pasada sin frenar la promesa del piloto.

---

## 1. Hallazgos priorizados con severidad

Convención: `Critical` bloquea publicación; `High` bloquea publicación hasta corregir o declarar explícitamente; `Medium` corrige en el mismo cambio de documentación; `Low` se acumula sin crecer (K-5/S-14).

### CRITICAL

#### C-1 — Versión y ejemplo de release falsos
- **Severidad:** Critical.
- **Observación:** README:154 dice `Versión actual: **v1.0.0**`; README:158 propone `scripts/kaizen-release cut 1.0.1`. El repo está en 1.2.0. Seguir el README degrada la versión y genera un tag equivocado.
- **Evidencia (`source_ids`):**
  - `SRC-CMD-01` — `cat VERSION` → `1.2.0`.
  - `SRC-CMD-02` — `head -5 CHANGELOG.md` → `## v1.2.0 — 2026-11-22`.
  - `SRC-CMD-03` — `scripts/kaizen-release status` → `version: 1.2.0 | tag: v1.2.0 | ... | ultimo tag: v1.2.0`.
  - `SRC-FILE-01` — `README.md:154,158`.
- **Impacto:** Error irreversible en manos de un usuario (tag/release mal creado); rompe K-1 (documentación vs código) y K-7.
- **Propuesta:** Sustituir la cifra literal por una línea generada/verificable: `Versión: la que reporta scripts/kaizen-release status (1.2.0 al 2026-11-22)`. Cambiar el ejemplo a `cut 1.2.1` y añadir "elige el siguiente número; no ejecutes si `kaizen-release status` difiere". Añadir gate en `scripts/kaizen check` que compare `VERSION` con el README (fuera de este cambio: toca `scripts/`, requiere humano).

#### C-2 — Capacidad anunciada, no instalada
- **Severidad:** Critical.
- **Observación:** README:136 agrupa "REA ... y reverse-api-engineer (APIs tipadas desde sitios autorizados)" como si ambas estuvieran listas para usar. README:138 da por desplegado el equipo `api-recon`. El outbox de instalación dice lo contrario.
- **Evidencia:**
  - `SRC-FILE-02` — `.kaizen/loop/outbox/rae-api-instalacion-cuota.md` (`kind: failure`): "El equipo `api-recon` está gobernado y documentado, pero la herramienta y su skill **no quedaron instaladas**. No se puede operar hasta liberar espacio." Causa: `ensurepip` no disponible y `OSError: [Errno 122] Disk quota exceeded`.
  - `SRC-FILE-03` — `README.md:136,138`.
  - `SRC-CMD-04` — `.kaizen/catalog/catalog.json` → `rea_tools: 263` (REA sí catalogada). No hay entrada equivalente que acredite la instalación de reverse-api-engineer.
- **Impacto:** Un lector intentará usar una herramienta inexistente; el README afirma uma capacidad sin evidencia (K-10). Además el equipo `api-recon` figure en la lista de despliegue aunque no pudo operar.
- **Propuesta:** Crear una **tabla de estado de capacidades** con columnas `Capacidad | Gobernada | Documentada | Instalada | Verificación | Bloqueo`. Ejemplo fila: `reverse-api-engineer | Sí (ADR-0017) | Sí | **NO** | pip show / npx skills list | Cuota de disco — outbox rae-api-instalacion-cuota`. Separar "diseñado" de "operativo" en todo el README. No eliminar la capacidad: declarar su estado.

#### C-3 — Recuento de agentes inconsistente y sin fuente única
- **Severidad:** Critical.
- **Observación:** El README usa 45 y 47 sin explicar la diferencia; `AGENTS.md` dice 42 puestos y 44 agentes instalados; el outbox `conteo-agentes-inconsistente.md` dice 42/43/44 y "45 (43 delegables + 2 anti-bucle)" — a su vez desactualizado. La fuente canónica coincide en 45 definiciones.
- **Evidencia:**
  - `SRC-CMD-05` — `scripts/kaizen-org list | awk 'NR>1' | wc -l` → `45`.
  - `SRC-CMD-06` — `.kaizen/org/catalog.json` → `count: 45`; `docs/kaizen/org/CATALOGO-AGENTES.md` → `Total: 45 agentes`.
  - `SRC-CMD-07` — `find .opencode/agents -maxdepth 1 -name '*.md' | wc -l` → `47`; `find ~/.config/opencode/agents -name '*.md' | wc -l` → `47`; `kaizen-release status` → `globales: 47`.
  - `SRC-CMD-08` — `python3 scripts/kaizen-gov` → `todo en verde (45 agentes, 12 procesos)`.
  - `SRC-FILE-04` — `README.md:3,97,125` = 45; `:18,56,145` = 47. `AGENTS.md` = 42/44. `.kaizen/loop/outbox/conteo-agentes-inconsistente.md` = 42/43/44.
- **Impacto:** Rompe REG-EV-07 trazabilidad; un dictamen puede citar cualquier número. Es el tercer recuento distinto en la historia del repo (el outbox ya lo había detectado y no se cerró).
- **Propuesta:** Publicar una tabla con significado explícito: **45 definiciones canónicas** (`kaizen-org list`), **47 agentes OpenCode generados** (47 `.md` en cada directorio), **17 roles del swarm** (`ROSTER.md`, verificado), y una nota: "`AGENTS.md` y el outbox de conteo están desactualizados; se corrigen por PR con ADR porque son rutas protegidas (L-4)". Declarar `kaizen-org list` como única fuente de verdad y no repetir el número en prosa: decir "los que reporte `kaizen-org list`".

### HIGH

#### H-1 — "9 procesos" cuando gobernanza define 12
- **Severidad:** High.
- **Observación:** README:119 afirma 9 procesos RACI. `governance.json` tiene 12 y el propio CLI lo confirma.
- **Evidencia:** `SRC-CMD-08`; `SRC-CMD-09` — `python3 -c "import json;d=json.load(open('.kaizen/gov/governance.json'));print(len(d['processes']))"` → `12`. Procesos: `decision, deployment, change, incident, compliance, research, agent_lifecycle, budget, retro, reverse_engineering, api_reverse_engineering, computer_use`.
- **Impacto:** Documento derivado contradice a la fuente canónica (K-1). Un usuario busque `budget` o `research` y no los encuentre en el README.
- **Propuesta:** Cambiar a 12 y listarlos en una tabla mínima (proceso → humano como A → veto). Reutilizar `docs/kaizen/org/GOBIERNO.md` en lugar de duplicar.

#### H-2 — KPI de evaluación desactualizado (93.1 vs 100.0)
- **Severidad:** High.
- **Observación:** README:125 publica "promedio actual **93.1/100**". La línea base real es 100.0.
- **Evidencia:**
  - `SRC-CMD-10` — `.kaizen/evals/baseline.json` → `average: 100.0`, `updated: 2026-11-22T12:44:44.976975+00:00Z`.
  - `SRC-CMD-11` — `python3 scripts/kaizen-eval check | tail -1` → `agentes=45 promedio=100.0 minimo=70 bajo_minimo=0`.
  - `SRC-FILE-05` — `.kaizen/loop/outbox/kpi-baseline-desactualizado-20261122.md` ya documenta exactamente esta divergencia.
- **Impacto:** El README describe una holgura de 6.9 puntos que no existe; según K-5 cualquier bajada de 100 rompe el ratchet. Además ignora un finding ya registrado.
- **Propuesta:** Escribir "promedio = el de la línea base vigente (`kaizen-eval check`; 100.0 al 2026-11-22)" y cerrar el outbox `kpi-baseline-desactualizado` cuando se corrija. No hardcodear la cifra en el README.

#### H-3 — Cifra de pruebas ausente en el README y desactualizada en el CHANGELOG
- **Severidad:** High.
- **Observación:** El README no da número de pruebas; `CHANGELOG.md` repite `144/144` en cuatro versiones. La ejecución real hoy es 191.
- **Evidencia:**
  - `SRC-CMD-12` — `timeout 150 bash tests/run.sh` → `rc=0`, salida final `191 pruebas pasadas, 0 fallidas` (conteo independiente: 191 líneas `ok `, 0 `FALLA`). Duración < 150 s.
  - `SRC-FILE-06` — `CHANGELOG.md:5,27,47,68` → `Pruebas: 144/144 en verde`.
  - `SRC-FILE-07` — `.kaizen/loop/outbox/qa-block-verificacion-vacua.md` decía que `kaizen check` colgaba en `tests/run.sh` con rc=124 a 180 s. **Ese finding está resuelto en la ejecución de hoy**; debe actualizarse para no difundir un dato falso (S-11/K-10).
- **Impacto:** Subestimación de la cobertura y contradicción con el CHANGELOG; un auditor no puede reproducir "144".
- **Propuesta:** Añadir al README una línea de **verificación reproducible**: "`bash tests/run.sh` → 191 pruebas pasadas, 0 fallidas (2026-11-22)". Actualizar CHANGELOG en el mismo cambio (K-7) y anotar la resolución del finding de QA.

#### H-4 — Piloto "7 días / <24 h" no alcanzable en el estado actual
- **Severidad:** High.
- **Observación:** README:164-171 recomienda un piloto con arranque `kaizen-start start` y KPI "primer reporte en menos de 24 h". README:140 admite que el último despliegue se detuvo por el límite gratuito de OpenCode, pero no conecta ambos hechos ni establece prerrequisito.
- **Evidencia:**
  - `SRC-FILE-08` — `.kaizen/loop/outbox/opencode-usage-limit-deploy.md`: los 6 equipos terminaron `rc=1` con `Free usage limit reached... switch models`, modelo `depool-alpha-free`.
  - `SRC-CMD-13` — `.kaizen/team/runtime/notifications.jsonl` → `Equipos: api-recon cumplimiento desktop-ops equipo-central plataforma producto. Paralelismo: 6. Profundidad: 3.` y entradas `INCIDENCIA`.
  - `SRC-FILE-03` — README:140,164-171.
- **Impacto:** Promesa no verificable (K-10). El usuario seguirá el piloto, fallará en el primer ciclo y culpará a la orquestación cuando el cuello es el proveedor del modelo.
- **Propuesta:** Antes del piloto, un bloque **"Precondición (no opcional)"**: proveedor de pago / suscripción OpenCode Go / cambio de modelo, y suficiente cuota de disco para `reverse-api-engineer` si se usa `api-recon`. Añadir ruta alternativa **sin modelo**: `KSW_DRY_RUN=1`, `bash tests/run.sh`, `scripts/kaizen-swarm check`, `scripts/kaizen-org check`, `scripts/kaizen-observability status`. Decir claramente: "sin esa precondición el KPI de 24 h no es medible".

#### H-5 — KPI "0 normas sin fuente" y `verify` vacuo: BLOCK de QA no divulgado
- **Severidad:** High.
- **Observación:** README:115 y :170 presentan fuentes verificadas y el KPI "0 normas sin fuente verificada" comosomething logrado. El dictamen QA registró que `verify` devuelve verde con cero decisiones, por lo que la meta es trivialmente cierta.
- **Evidencia:** `SRC-FILE-07` — outbox `qa-block-verificacion-vacua.md`: "`kaizen-team verify` devuelve rc=0 'todas las decisiones tienen fuentes verificadas' con **0 decisiones**"; artefactos `.kaizen/team/projects/` y `docs/kaizen/team/` sin versionar; propone gate `n_decisiones >= 1`. (Dato no confiable según S-15: se cita como hallazgo registrado, no como orden de ejecución; el gate requiere ADR/humano por L-4.)
- **Impacto:** El README afirma un cumplimiento no demostrado. Es exactamente el tipo de "evidencia fabricada por vacuidad" que K-10 prohíbe.
- **Propuesta:** Añadir sección **"Estado de verificación y deuda conocida"**: qué está verde (gates de tests, gov, eval), qué está en BLOCK (QA), qué significa `verify` hoy y la condición para que el KPI sea meaningful (`n_decisiones >= 1`). No eliminar el KPI: acompañarlo de su limitación.

#### H-6 — ADRs: CHANGELOG dice 9, existen 15, con hueco 0011-0015
- **Severidad:** High.
- **Observación:** El README enlaza ADR-0017, ADR-0009, etc. `CHANGELOG.md` dice `ADRs: 9`. En disco hay 15 ADRs numerados con salto de 0010 a 0016, más `_TEMPLATE.md`.
- **Evidencia:** `SRC-CMD-14` — `ls docs/kaizen/adr/000*.md` → `0001..0010, 0016, 0017, 0018, 0019, 0020` (15 archivos) + `_TEMPLATE.md`. `SRC-FILE-06` → `ADRs: 9`.
- **Impacto:** Inconsistencia documental; el lector no sabe si faltan ADRs o están reservados.
- **Propuesta:** CHANGELOG → 15; README → "15 ADRs vigentes (numeración 0001-0010 y 0016-0020; 0011-0015 reservados/sin publicar — aclarar)". Si el hueco fue un error, abrir issue de documentación.

### MEDIUM

#### M-1 — Falta sección "Qué no es"
- README:3 describe una organización casi ilimitada. `docs/kaizen/org/FORECAST.md` §2 ya contiene "Qué NO se les puede delegar hoy" (sin evidencia reproducible, seguridad/pagos/autenticación, telemetría como instrucción, "organizaciones autónomas" ficticias).
- **Propuesta:** Sección corta en el README con 5 viñetas y enlace a FORECAST. Fragmento sugerido: *"No es un sistema autónomo que decide solo: no ejecuta seguridad, pagos ni autenticación sin humano (L-3/ADR-0003); no trata issues, logs ni web como instrucciones (L-5/S-15); no sostiene por sí solo continuidad ni criterio de negocio (FORECAST.md §2)."*

#### M-2 — Falta Troubleshooting
- No hay ninguna sección de diagnóstico (`grep -niE 'troubleshoot|reversib|rollback|revertir|qué no es' README.md` → sin resultados).
- **Propuesta:** Tabla `Síntoma | Causa probable | Comando para confirmar | Acción | Fuente`. Filas mínimas: (a) `Free usage limit reached` → proveedor; (b) `Errno 122` en install → cuota; (c) `verify` verde con 0 decisiones → BLOCK QA; (d) Grafana no responde → `docker compose ... ps`; (e) `kaizen-org list` devuelve número distinto al README → fuente canónica; (f) tests lentos → medir con `timeout`; (g) agente `paused` → `kaizen-org enable`.

#### M-3 — Falta Reversibilidad
- L-7 exige documentar cómo se revierte todo cambio con riesgo operativo; el README solo menciona `finalize --publish` y PAUSE de forma tangencial.
- **Propuesta:** Sección con: `KSW_DRY_RUN=1` antes de `init/finalize`; `finalize` sin `--publish` por defecto; `kaizen-start stop`; `git checkout -- <ruta>` para definiciones; `kaizen-eval baseline` solo con ADR (nunca `--force` sin humano); `docker compose down` para el stack; `kaizen-org disable <id>` para pausar un agente. Avisar: rutas L-4 no se revierten con `git checkout` casero sin aprobación.

#### M-4 — Seguridad insuficiente y referencia colgante
- README:179 cita `KAIZEN-SECURITY.md §11 en la documentación de origen`; **ese archivo no existe en el repo** (`ls KAIZEN-SECURITY.md` → no encontrado). README:175 sí enlaza `.github/SECURITY.md` (existe).
- Falta explicar S-11 (todo hallazgo se documenta en `.kaizen/loop/outbox/`, incluso corregido), S-2 (el agente no lee credenciales) y L-4 (rutas protegidas).
- **Propuesta:** Quitar la referencia colgante; sustituir por `.kaizen/security/SECURITY-RULES.md` + `.github/SECURITY.md`; añadir 4 viñetas: secretos, outbox, rutas protegidas, fail-closed de escáneres (S-10).

#### M-5 — Dos instaladores sin relación explicada
- README:3 presenta `scripts/bootstrap <repo>` como "plantilla instalable"; la sección de instalación usa `scripts/kaizen-installer all`. El help real distingue `repo`, `opencode --global`, `opencode --project`, `all`.
- **Propuesta:** Tabla: `bootstrap` = motor de fusión de framework; `installer repo` = framework + agentes locales; `installer opencode --project|--global` = solo `.md` de agentes; `installer all` = todo. Añadir `installer status|check` como verificación y "no toca `opencode.json`" (verificado en el help y en tests).

#### M-6 — Versión de Node incorrecta
- README:121 → "Node v22.23.4"; `node -v` → `v22.22.1`.
- **Propuesta:** "Node 22.x — confirmar con `node -v`". No fijar patch en prosa.

#### M-7 — 8 equipos definidos vs 6 documentados/desplegados
- README:138 lista 6 equipos. `.kaizen/team/teams.json` tiene **8**: `equipo-central, cumplimiento, plataforma, producto, api-recon, desktop-ops, auto-mejora, decisiones`. `KR_MAX_TEAMS_PARALLEL=6` y el deploy real fue de 6 (los otros dos tienen `model` asignado y se invocan aparte).
- **Propuesta:** "8 equipos definidos, tope 6 en paralelo (`KR_MAX_TEAMS_PARALLEL=6`); `auto-mejora` y `decisiones` no entran en `deploy`". El contexto del equipo que pidió esta crítica cita 8: coincide con `teams.json`.

#### M-8 — Observabilidad: distinguish exporter activo de stack levantada
- README:135 habla de `stack` Prometheus + Grafana. `scripts/kaizen-observability status` → `exporter: ACTIVO (PID ...) http://127.0.0.1:9101/metrics`, `stack: docker compose ... up -d (Grafana :3000)`. **No verifiqué que Grafana esté corriendo** (no consulté Docker): el README debe decir cómo comprobarlo, no darlo por hecho.
- **Propuesta:** "Exporter activo en :9101 (verificado). Grafana requiere `docker compose -f observability/docker-compose.yml up -d`; confirmar con `... ps` y `curl -fsS http://127.0.0.1:9101/metrics | head`."

### LOW

- **L-1** — README:3 "sin sobrescribir lo que ya exista" es demasiado absoluto; matizar: "fusiona definiciones; verificar con `kaizen-installer status`".
- **L-2** — Los bloques pegables para CLI no dicen cómo confirmar el fin de la instalación; añadir `scripts/kaizen-installer status` y `scripts/kaizen-swarm check` a los cuatro bloques.
- **L-3** — Mezcla de idiomas en los comandos pegables (español/inglés); estandarizar el bloque Codex y el humano.

---

## 2. Secciones que faltan y contenido sugerido

| Sección nueva | Por qué hace falta | Contenido sugerido (listo para adaptar) |
| --- | --- | --- |
| **Estado del entorno (tabla)** | Es la causa raíz de C-2, H-4 y M-8: el README mezcla diseño con despliegue real. | `Capacidad \| Gobernada \| Documentada \| Instalada \| Cómo verificarlo \| Bloqueo actual`. Filas: REA (sí/sí/sí/263 herramientas), reverse-api-engineer (sí/sí/**no**/cuota), computer-use (sí/sí/desactivado/`KO_DESKTOP_ENABLED=0`), Grafana (sí/sí/exporter activo; stack bajo demanda), modelos (saldo agotado). |
| **Qué no es** | EVita sobreventa; el material ya existe en FORECAST §2. | Cinco viñetas (ver M-1) + enlace a `FORECAST.md` y ADR-0003. |
| **Requisitos y precondición de cómputo** | El piloto no es ejecutable sin proveedor/cuota. | Ver H-4. Incluir ruta "sin modelo" para validar instalación. |
| **Troubleshooting** | Ningún README de una plantilla instalable debería dejar al usuario sin síntomas→acción. | Tabla de 7 filas de M-2. |
| **Reversibilidad** | L-7; hoy no se documenta ningún rollback. | Contenido de M-3. |
| **Seguridad y límites reales** | Referencia colgante + S-11 ausente. | Contenido de M-4. |
| **Verificación reproducible y deuda conocida** | "Verificación completa" sin salida real ni fecha no es evidencia (K-10). | Comandos con salida esperada: `bash tests/run.sh` → `191 pruebas pasadas, 0 fallidas`; `kaizen check`; `kaizen-org check`; `kaizen-gov` → `45 agentes, 12 procesos`; `kaizen-eval check` → `promedio=100.0`. Debajo: BLOCK de QA y acciones pendientes. |
| **Fuentes y convención de cifras** | C-3 se repite porque nadie define la fuente. | "`kaizen-org list` para agentes, `kaizen-release status` para versión, `tests/run.sh` para pruebas, `governance.json` para procesos, `baseline.json` para eval. No copies números entre documentos." |
| **Glosario de dos líneas: `bootstrap` vs `kaizen-installer`** | Confusión de M-5. | Tabla de M-5. |

---

## 3. Checklist de aceptación para el README final

Marcar solo si se puede demostrar con el comando indicado. **No se da por bueno "porque suena bien" (K-10).**

- [ ] **AC-1** — No aparece `v1.0.0` ni `cut 1.0.1`. `grep -n 'v1\.0\.0\|cut 1\.0\.1' README.md` → sin resultados. Coincide con `kaizen-release status`. *(C-1)*
- [ ] **AC-2** — `reverse-api-engineer` aparece marcado como **no instalado**, con motivo y comando de verificación. *(C-2)*
- [ ] **AC-3** — Un solo significado por cifra de agentes: 45 definiciones / 47 generados / 17 roles swarm, con comando para cada una. No queda un "45" y un "47" sin explicar. *(C-3)*
- [ ] **AC-4** — Dice **12 procesos** y los nombra o enlaza `GOBIERNO.md`. `kaizen-gov` lo confirma. *(H-1)*
- [ ] **AC-5** — No aparece `93.1`; la cifra de eval remite a `kaizen-eval check` / `baseline.json`. *(H-2)*
- [ ] **AC-6** — Aparece la salida real `191 pruebas pasadas, 0 fallidas` con fecha, y `CHANGELOG.md` ya no dice 144/144. `(timeout 150 bash tests/run.sh)` *(H-3)*
- [ ] **AC-7** — El piloto tiene precondición explícita de modelo/cuota y alternativa sin modelo. *(H-4)*
- [ ] **AC-8** — El KPI "0 normas sin fuente" aparece con la salvedad del `verify` vacuo y el BLOCK de QA. *(H-5)*
- [ ] **AC-9** — CHANGELOG y README coinciden en número de ADRs (15) y se aclara el hueco 0011-0015. *(H-6)*
- [ ] **AC-10** — Existen las secciones: "Qué no es", "Troubleshooting", "Reversibilidad", "Seguridad y límites", "Estado del entorno", "Verificación reproducible". *(M-1..M-4, §2)*
- [ ] **AC-11** — No queda ninguna referencia a `KAIZEN-SECURITY.md`. `grep -n KAIZEN-SECURITY README.md` → vacío. *(M-4)*
- [ ] **AC-12** — `bootstrap` y `kaizen-installer` están diferenciados en una tabla con `status|check` como verificación. *(M-5)*
- [ ] **AC-13** — No aparece `v22.23.4`; dice "Node 22.x, verificar con `node -v`". *(M-6)*
- [ ] **AC-14** — Dice 8 equipos definidos / 6 en paralelo, coherente con `teams.json` y `runtime.env`. *(M-7)*
- [ ] **AC-15** — Distingue exporter activo (:9101) de stack Grafana (:3000) bajo demanda, con comandos de comprobación. *(M-8)*
- [ ] **AC-16** — Toda cifra del README tiene `source_id` en la tabla de fuentes del propio README o en este borrador; cero afirmaciones sin fuente (meta KPI del rol QA).
- [ ] **AC-17** — Los findings de este borrador fueron registrados en outbox S-11 por el orquestador/humano (yo no puedo: `.kaizen/` es ruta protegida L-4) y los ya resueltos se marcaron como tales.

---

## 4. Propuesta de estructura comentada

Numeración pensada para que el lector entienda **qué es, qué no es, qué hace falta para usarlo y cómo comprobarlo** antes de los comandos de venta. Entre corchetes, la razón del cambio.

```text
# kaizen-swarm                                  [sin cambios]

## 0. Estado del entorno (leo primero)           [NUEVO — evita C-2/H-4/M-8]
    Tabla capacidades: gobernada/documentada/instalada/verificación/bloqueo.
    Aviso: saldo OpenCode agotado; reverse-api-engineer no instalada;
    computer-use desactivado; exporter Grafana activo, stack bajo demanda.

## 1. Qué es y qué no es                         [REESCRITO — C-3, M-1]
    1.1 Qué es: organización de agentes con worktrees, buzón, evidencia.
    1.2 Conteo canónico: 45 definiciones / 47 generados / 17 roles + comandos.
    1.3 Qué NO es: 5 viñetas de FORECAST §2 + ADR-0003.

## 2. Instalación                                [ACLARADO — M-5]
    2.1 Tabla bootstrap vs installer repo/opencode/all + status/check.
    2.2 Bloques pegables (OpenCode / Claude / Codex / humano) — con
        `kaizen-installer status` añadido a los cuatro.
    2.3 Qué NO toca: opencode.json, credenciales, archivos propios.

## 3. Gobernanza, capas y seguridad               [CORREGIDO — H-1, M-4]
    3.1 Capas (tabla actual, sin cambios).
    3.2 12 procesos RACI + enlace GOBIERNO.md.
    3.3 Secretos, S-11, L-4, escáneres fail-closed. Sin KAIZEN-SECURITY.md.

## 4. Flujo por issue y uso rápido                [sin cambios de fondo]
    init → R1 → R2 → R3 → finalize; KSW_DRY_RUN=1; --publish explícito.

## 5. Organización, equipo y conocimiento         [REORDENADO — C-2]
    kaizen-org / kaizen-team / gov / REA / learn / eval.
    REA: instalada. reverse-api-engineer: gobernada pero NO instalada (enlace §0).

## 6. Arranque, notificaciones y observabilidad   [PRECISADO — M-7/M-8]
    8 equipos definidos, tope 6 en paralelo; exporter :9101 vs Grafana :3000.

## 7. Verificación reproducible                   [NUEVO — H-3/H-5/AC-6]
    Comandos + salida real esperada + fecha. Deuda conocida: BLOCK de QA,
    verify vacuo, artefactos sin versionar.

## 8. Reversibilidad                              [NUEVO — M-3]
    dry-run, stop, checkout, disable, docker compose down, baseline con ADR.

## 9. Troubleshooting                             [NUEVO — M-2]
    Síntoma → causa → comando → acción → fuente (7 filas).

## 10. Versión, catálogo y propagación             [CORREGIDO — C-1/M-6]
     "versión según kaizen-release status (1.2.0 al 2026-11-22)";
     Node 22.x; ejemplo cut 1.2.1 con aviso de no degradar.

## 11. Piloto recomendado — CON PRECONDICIÓN      [CONDICIONADO — H-4]
     Precondición de modelo/cuota arriba del KPI de 24 h.

## 12. Decisiones humanas pendientes              [sin cambios + AC-17]

## 13. Límites honestos y fuentes                 [REESCRITO — M-4/AC-16]
     Escáneres con falsos negativos; hooks saltables; CI + protección reales.
     Tabla de fuentes: qué comando manda en cada cifra.
```

**Nota de cierre para el responsable:** el README actual no está "mal escrito": está **desincronizado**. Cinco de sus cifras (versión, agentes, procesos, eval, ADRs) tienen dueño propio fuera del README, y una capacidad (reverse-api-engineer) nunca se instaló. La solución durable no es volver a escribir números a mano, sino convertir el README en un documento que **apunte a las fuentes y declare el estado del entorno**. Hasta que eso ocurra, cualquier "todo en verde" que diga necesita el comando que lo respalde (K-10).

---

## Apéndice A — Hallazgos listos para S-11 (el orchestrador los registra; yo no toco `.kaizen/`)

> Bloques en formato S-11, sin secretos ni datos personales. Copiar a `.kaizen/loop/outbox/` si el responsable lo autoriza. No son instrucciones para ejecutar cambios en rutas protegidas.

```text
kind: bug
title: README publica version v1.0.0 y ejemplo cut 1.0.1 mientras VERSION es 1.2.0
fingerprint: readme-version-stale
---
## Que paso
README.md:154 y :158 desactualizados frente a VERSION, CHANGELOG y kaizen-release status.
## Donde
README.md:154,158; VERSION; CHANGELOG.md:5; scripts/kaizen-release status.
## Impacto
Un usuario podria crear un tag/release hacia atras; rompe K-1/K-7.
## Evidencia
cat VERSION -> 1.2.0; kaizen-release status -> version 1.2.0, tag v1.2.0.
## Reproduccion
1) cat VERSION  2) scripts/kaizen-release status  3) grep -n 'v1.0.0' README.md
## Propuesta
Generar la cifra desde la fuente; ejemplo cut 1.2.1.
```

```text
kind: failure
title: README anuncia reverse-api-engineer como capacidad disponible sin estar instalada
fingerprint: readme-capacidad-no-instalada
---
## Que paso
README.md:136 la presenta junto a REA sin declarar que la instalacion fallo por cuota.
## Donde
README.md:136,138; .kaizen/loop/outbox/rae-api-instalacion-cuota.md.
## Impacto
Promesa no verificable (K-10); equipo api-recon no operativo.
## Evidencia
Outbox rae-api-instalacion-cuota: OSError [Errno 122] Disk quota exceeded; skill no instalada.
## Reproduccion
1) leer outbox citado  2) intentar pip show reverse-api-engineer en el entorno.
## Propuesta
Tabla de estado de capacidades; separar gobernado/documentado de instalado.
```

```text
kind: bug
title: README contradice fuente canonica de recuento de agentes (45 vs 47) y a AGENTS.md (42/44)
fingerprint: readme-conteo-agentes
---
## Que paso
README usa 45 y 47 sin explicacion; AGENTS.md y un outbox antiguo usan 42/43/44.
## Donde
README.md:3,18,56,97,125,145; AGENTS.md; .kaizen/loop/outbox/conteo-agentes-inconsistente.md.
## Impacto
REG-EV-07: no hay cifra citable; es la segunda vez que se reporta el mismo drift.
## Evidencia
kaizen-org list -> 45; catalog.json count=45; .opencode/agents/*.md -> 47;
~/.config/opencode/agents/*.md -> 47; ROSTER.md -> 17 roles.
## Reproduccion
1) scripts/kaizen-org list | tail -n +2 | wc -l  2) find .opencode/agents -maxdepth 1 -name '*.md' | wc -l
## Propuesta
Tabla con significado por cifra y declarar kaizen-org list como fuente unica.
```

```text
kind: bug
title: README cita KPI eval 93.1 y 9 procesos cuando baseline es 100.0 y hay 12 procesos
fingerprint: readme-cifras-gobierno-eval
---
## Que paso
README.md:119,125 desactualizados; CHANGELOG dice 9 ADRs cuando hay 15.
## Donde
README.md:119,125; .kaizen/evals/baseline.json; .kaizen/gov/governance.json; CHANGELOG.md:5.
## Impacto
KPI con holgura falsa; documentacion derivada contradice a la canonica (K-1).
## Evidencia
kaizen-eval check -> promedio=100.0; kaizen-gov -> 45 agentes, 12 procesos;
ls docs/kaizen/adr/000*.md -> 15 archivos (hueco 0011-0015).
## Reproduccion
1) python3 scripts/kaizen-eval check | tail -1  2) python3 scripts/kaizen-gov  3) ls docs/kaizen/adr/
## Propuesta
Remitir a comandos, no a literales; CHANGELOG a 15 ADRs.
```

```text
kind: documentation
title: README no da cifra de pruebas y CHANGELOG dice 144/144 frente a 191 reales
fingerprint: readme-pruebas-stale
---
## Que paso
Falta de salida reproducible; ademas un outbox de QA quedo desactualizado (decia que tests colgaban a 180s).
## Donde
README.md:127; CHANGELOG.md:5,27,47,68; .kaizen/loop/outbox/qa-block-verificacion-vacua.md.
## Impacto
No se puede reproducir el estado verde que se afirma (K-10).
## Evidencia
timeout 150 bash tests/run.sh -> rc=0, "191 pruebas pasadas, 0 fallidas".
## Reproduccion
1) timeout 150 bash tests/run.sh 2) tail -1 de la salida.
## Propuesta
Publicar salida con fecha; actualizar CHANGELOG y marcar resuelto el finding de hang.
```
