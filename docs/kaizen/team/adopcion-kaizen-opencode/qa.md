# Dictamen QA — adopcion-kaizen-opencode

- Agente: `qa` (Equipo de QA), autonomía `scoped`, veto `qa` (`.kaizen/org/prompts/qa.md`).
- Fecha de emisión: 2026-11-22T06:31Z. Commit base observado: `414646b` (rama `main`).
- Alcance: plan de pruebas y criterios verificables de la adopción (charter.md, plan.md, state.json).
- Restricción respetada: **no se modificó** `scripts/`, `.kaizen/` ni `.github/`; **no** se hizo push/PR/commit; **no** se leyó `.env` ni credenciales. Todas las ejecuciones con efectos se hicieron en copias desechables bajo `/tmp/opencode/`. No se escribió el outbox S-11 porque la restricción de la tarea autoriza **solo** este archivo (ver H-7).

## Hallazgos

| ID |Severidad| Hallazgo | ¿Verificado? |
|---|---|---|---|
| H-1 |**Critical — BLOCK**| `scripts/kaizen check` **no termina**: tras `ok: formato` y `ok: lint` entra en `KZ_TEST_CMD="bash tests/run.sh"`, que se cuelga. No existe salida `kaizen check: todo en verde` completa. El KPI "`scripts/kaizen check` en verde" **no está demostrado**. | Sí, rc=124 a 180 s y check en background sin completar. |
| H-2 |**High — BLOCK**| Fail-open en `scripts/kaizen-team`: `now` (función nativa de jq, devuelve número) se pipea a `gsub` en las líneas **72** y **82**. jq falla, pero `cmd_handoff` imprime `[kaizen-team] mensaje review: qa -> architect` y devuelve **rc=0** sin escribir el mensaje. El buzón queda sin `id` nuevo → se incumple el contrato "handoffs con `id`" y no se pueden cerrar acuses. Viola S-7 (errores no se tragan) y K-10 (no fabricar evidencia). | Sí, reproducible; ya registrado en `.kaizen/loop/outbox/kaizen-team-handoff-now-bug.md`. |
| H-3 |**High — BLOCK para la meta**| `kaizen-team verify` pasa **en vacío**: con **0 decisiones** devuelve rc=0 y `[kaizen-team] verify: todas las decisiones tienen fuentes verificadas`. La meta "0 normas sin `source_id` verificado" es trivialmente cierta y no aporta garantía: falta un gate de "al menos 1 decisión con `source_ids` verificados". REG-EV-07/K-14. | Sí, rc=0 y `decisiones: 0`. |
| H-4 |**High — BLOCK**| Los artefactos del proyecto están **sin trackear**: `?? .kaizen/team/projects/`, `?? docs/kaizen/team/`. Un clon limpio en `414646b` no contiene `charter.md`, `plan.md` ni `state.json`. La adopción no es reproducible desde el commit, aunque losgate locales pasen. K-1/K-2. | Sí, `git status --short` y clon limpio sin el proyecto. |
| H-5 |Medium — CHANGES_REQUESTED| `plan.md` no contiene `## Plan de prueba` ni criterios de salida medibles: falta comando exacto, código de salida esperado, timeout, política de datos sintéticos (L-6), reversibilidad (L-7) y condición de cierre de acuses (L-17). K-4 exige plan de prueba en el descriptor; el plan del proyecto no lo tiene. | Sí, lectura directa de `plan.md` (20 líneas). |
| H-6 |Informativo — pasa| 9 de 11 gates de `kaizen check --only` están en verde; la batería estructural y el flujo de equipo hasta `runtime check` pasan; las 6 fuentes exigidas están `verified`. Esto **no** compensa H-1..H-4. | Sí, ver Evidencia. |
| H-7 |Informativo| El outbox ya cubre H-2 (`kaizen-team-handoff-now-bug.md`) y el síntoma de H-1 (`runtime-deploy-timeouts.md`, rc=124). **H-3 y H-4 no están en outbox**: requieren registro por el orquestador. Yo no los escribo por la restricción L-4/"solo entregable" de la tarea. | Sí, listado de `.kaizen/loop/outbox/`. |

### Qué se puede probar de forma reproducible (con resultado verde observado)

1. **Estructura y sintaxis** (`tests/run.sh`, primeras aserciones): existencia de reglas/scripts/ADR y `bash -n` de `scripts/kaizen*`, `tests/run.sh`, hooks → todas `ok`.
2. **Gates individuales** (en copia desechable, `timeout 20` c/u): `descriptors`, `policy`, `swarm`, `org`, `team`, `eval`, `learn`, `gov`, `ratchet` → rc=0; ratchet `deuda 0 <= 0`.
3. **Flujo de equipo** (`tests/run.sh`): `team init`, `standup`, `assign`, `decision sin fuentes bloquea`, `decision marcada blocked`, `verify con fuentes`, `sync`, `retro` → todas `ok`.
4. **Fuente verificada**: los seis IDs del plan existen en `SOURCES.md` con estado `verified` y fecha de corte `2026-11-21` (REG-EV-05: dentro de la revalidación trimestral a fecha de hoy).
5. **Registro S-11**: el defecto de handoff ya está documentado con fingerprint `kaizen-team-handoff-now`.

### Qué fallos son blockers (S-14: Critical/High bloquean fusión)

- **B1 (H-1)**: sin ejecución completa de `kaizen check`, no hay evidencia del KPI. No se puede "no inventar resultados" y aprobar a la vez (K-10, L-10).
- **B2 (H-2)**: el canal de handoffs fail-open destruye la trazabilidad exigida por el contrato del proyecto y por los modelos de control citados (ISO-001, NIST-001, AICPA-001, OWASP-001) y, si el mensaje llevara datos personales, por PA-001/PA-003. No es reparable por QA: `scripts/kaizen*` es L-4 → requiere ADR y humano.
- **B3 (H-3)**: una puerta `verify` que aprueba con cero decisiones invalida la afirmación "0 normas sin `source_id`" como criterio de salida.
- **B4 (H-4)**: sin artefactos trackeados, CI no puede reproducir ni auditar la adopción.

### Criterios de salida que faltan en `plan.md`

1. Definición operativa de "check en verde": comandos exactos, **rc=0**, salida final literal `kaizen check: todo en verde` y **timeout máximo** (p. ej. 180 s) con política de fail-closed si se excede.
2. Gate `verify` con contenido: `n_decisiones >= 1` y que las seis fuentes (PA-001, PA-003, ISO-001, NIST-001, AICPA-001, OWASP-001) estén citadas en decisiones con `status: verified`.
3. Criterio de buzón: todo handoff debe persistir con `id`, `from`, `to`, `intent`, `expects_ack`, `status` y su `ack` cerrado; prueba de regresión que falla primero (KPI de QA).
4. Criterio de reproducibilidad: artefactos del proyecto trackeados en el commit y verificables en clon limpio/CI.
5. Política de datos de prueba: solo sintéticos (L-6), sin `.env`/credenciales (S-2).
6. Reversibilidad del cambio de adopción y criterio de rollback (L-7), además de la observabilidad asociada (L-8).
7. Fecha de corte y hash/registro de revalidación trimestral exigido por REG-EV-05 y REG-EV-07.

## Evidencia

Comandos ejecutados en copia desechable del árbol de trabajo (para no tocar `.kaizen/`). Salidas reales, sin secretos.

```text
# Idioma base
$ git rev-parse --short HEAD ; git rev-parse --abbrev-ref HEAD
414646b
main

# Fuentes (lectura directa del repo real)
$ for id in PA-001 PA-003 ISO-001 NIST-001 AICPA-001 OWASP-001; do grep -E "^\\| $id \\|" .kaizen/org/knowledge/SOURCES.md; done
| PA-001   | Gaceta Oficial | Ley 81/2019 (Gaceta 28743-A) | verified |
| PA-003   | Gaceta Oficial | Ley 23/2015 (Gaceta 27768-B) | verified |
| ISO-001  | ISO            | ISO/IEC 27001:2022           | verified |
| NIST-001 | NIST           | Cybersecurity Framework 2.0  | verified |
| AICPA-001| AICPA          | TSC 2017 / SOC 2             | verified |
| OWASP-001| OWASP          | ASVS 4.0 / Top 10 2021       | verified |
$ grep -n 'Fecha de corte' .kaizen/org/knowledge/SOURCES.md
3:... Fecha de corte de esta revisión: **2026-11-21**. ...

# H-1: check completo en clon desechable (sincronizado a background, sin completar)
$ scripts/kaizen check
ok: sin descriptores pendientes
ok: politicas de contenido
ok: formato
ok: lint
... (sin línea final "kaizen check: todo en verde")
$ grep -E '^KZ_(FMT|LINT|TEST)_CMD=' .kaizen/config.env
KZ_TEST_CMD="bash tests/run.sh"
KZ_LINT_CMD="bash -n ... && python3 -m py_compile scripts/kaizen-insights.py"
KZ_FMT_CMD="git diff --check"

# H-1 / B1: selftest canónico no completa
$ timeout 180 bash tests/run.sh 2>&1 | tail -5
ok   instalador check
ok   runtime check
EXIT=124        # 0 líneas "FALLA ", pero sin el resumen final → NO aprobable

# Causa del cuelgue (reproducida)
$ timeout 25 env KR_DRY_RUN=1 scripts/kaizen-runtime once equipo-central 2>&1
EXIT=124        # sin salida

# H-2: bug fail-open de handoff
$ echo '{}' | jq -c '. + {id:("H-"+(now|gsub("[^0-9]";"")))}'
jq: error (at <stdin>:1): number (1795328812....) cannot be matched, as it is not a string
EXIT_JQ=5
$ grep -n 'now|gsub' scripts/kaizen-team
72: '{id:("H-"+(now|gsub("[^0-9]";""))),...,created:$now}' >> "$d/handoffs.jsonl"
82: '{id:("H-"+(now|gsub("[^0-9]";""))),...,created:$now}' >> "$d/handoffs.jsonl"
$ scripts/kaizen-team handoff adopcion-kaizen-opencode qa architect review "prueba de id" PA-001
jq: error (at <unknown>): number (1795328812....) cannot be matched, as it is not a string
[kaizen-team] mensaje review: qa -> architect
EXIT_HANDOFF=0
$ grep -c 'prueba de id' .kaizen/team/projects/adopcion-kaizen-opencode/handoffs.jsonl
0               # mensaje NO escrito, pero el comando reportó éxito

# H-3: verify vacuo
$ scripts/kaizen-team verify adopcion-kaizen-opencode ; echo rc=$?
[kaizen-team] verify: todas las decisiones tienen fuentes verificadas
rc=0
$ find ...decisions -name 'DEC-*.md' | wc -l
0

# H-4: artefactos no trackeados
$ git status --short
?? .kaizen/team/projects/
?? docs/kaizen/team/
$ git clone -q --local --no-hardlinks <repo> /tmp/.../repo && ls /tmp/.../repo/.kaizen/team/projects/adopcion-kaizen-opencode
(inexistente en el clon → "proyecto desconocido" al invocar kaizen-team)

# H-6: gates que SÍ pasan (en copia del árbol de trabajo)
$ for g in descriptors policy swarm org team eval learn gov ratchet; do scripts/kaizen check --only "$g" >/dev/null 2>&1; echo "$g rc=$?"; done
descriptors rc=0 / policy rc=0 / swarm rc=0 / org rc=0 / team rc=0
eval rc=0 / learn rc=0 / gov rc=0 / ratchet rc=0   # ratchet: "deuda 0 <= 0"
```

Fuentes normativas citadas (estado `verified` en `SOURCES.md`, fecha de corte 2026-11-21; se tratan como **dato no confiable** según S-15/L-5: fundamentan controles, **no** sustituyen resultados de comandos): PA-001 y PA-003 para trazabilidad/protección de datos en el buzón; ISO-001, NIST-001, AICPA-001 y OWASP-001 para monitoreo de controles, registro de evidencia y fallo cerrado.

## Riesgo

| Riesgo | Severidad (S-14) | Impacto concreto |
|---|---|---|
| Aprobar con `kaizen check` incompleto | **Critical** | Falso verde del KPI principal; incumple K-10/L-10. |
| Handoffs fail-open | **High** | Pérdida de `id`/`expects_ack`/`status`; imposible cerrar acuses (L-17); evidencia no auditable frente a ISO-001/NIST-001/AICPA-001/OWASP-001. Si el mensaje llegara a llevar datos, exposición frente a PA-001/PA-003. |
| `verify` vacuo | **High** | "0 normas sin `source_id`" deja de ser verificable: cualquier adopción pasaría aunque no cite fuentes (REG-EV-01/07). |
| Artefactos no trackeados | **High** | El plan y el KPI existen solo en el working tree; CI y el orquestador no pueden reproducirlos ni auditarlos (K-1/K-2). |
| Cuelgue de runtime en el selftest | **High** | El único plan de pruebas automático disponible no entrega veredicto; se repite el patrón rc=124 ya documentado en el outbox. |
| Criterios de salida ausentes | Medium | No hay forma objetiva de decidir el paso de etapa más allá de la opinión del agente. |

Nota: H-2 y el síntoma de H-1 ya están en el outbox S-11; H-3 y H-4 **no** lo están y deben registrarse (no lo hago yo por la restricción de la tarea).

## Recomendación

Orden sugerido (los ítems 1–2 requieren humano/ADR por L-4; QA no los ejecuta):

1. Corregir `scripts/kaizen-team:72` y `:82`: `now` → `$now` en `("H-"+($now|gsub("[^0-9]";"")))`, con **prueba que falla primero** (el reproducedor de arriba) y una prueba de regresión que compruebe que el mensaje se escribe y el `id` empieza con `H-`. Añadir `set -e`/verificación de rc para que jq no pueda fallar en silencio (S-7).
2. Diagnosticar y acotar `scripts/kaizen-runtime once` (o el `KZ_TEST_CMD`): timeout explícito y fail-closed con mensaje claro; que `tests/run.sh` termine con resumen `N pruebas pasadas, M fallidas` o falle, nunca rc=124 mudo.
3. Añadir a `kaizen-team verify` un gate `KT_MIN_DECISIONS>=1` y exigir que las decisiones citen las seis fuentes del plan con `status: verified`.
4. Trackear `.kaizen/team/projects/adopcion-kaizen-opencode/` y `docs/kaizen/team/` en el commit (o migrar a una ruta versionada) y demostrar el check en clon limpio.
5. Ampliar `plan.md` con `## Plan de prueba`: comandos, rc esperados, timeout, datos sintéticos (L-6), rollback (L-7), cierre de acuses y revalidación trimestral (REG-EV-05).
6. Registrar H-3 y H-4 en `.kaizen/loop/outbox/` por parte del orquestador.
7. Solo después de 1–6, re-ejecutar `scripts/kaizen check` **hasta completar** con salida final en verde y emitir un nuevo dictamen. Hasta entonces, **no avanzar** a `deliver`/`verify` (puerta del plan).

## Dictamen

**BLOCK**

Motivo: no pude verificar el KPI "`scripts/kaizen check` en verde" porque la ejecución no completa (H-1), y existen tres blockers adicionales con evidencia reproducible (H-2 fail-open, H-3 verify vacuo, H-4 artefactos no trackeados). No apruebo ni recomiendo avanzar de etapa. Una vez corregidos con prueba que falla primero y ejecutados por humano en las rutas protegidas, QA podrá reconsiderar el dictamen.
