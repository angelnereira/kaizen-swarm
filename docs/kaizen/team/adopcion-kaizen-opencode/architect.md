# Dictamen de arquitectura — adopcion-kaizen-opencode

- Agente: `architect` (veto `architecture`; `approve: false`, `recommend: true`, `execute: true`).
- Fecha: 2026-11-22. Fecha de corte de fuentes: 2026-11-21 (`SOURCES.md`).
- Alcance: límites, contratos y ADR de la adopción — catálogo REA (263 herramientas), gobernanza (43 agentes / 10 procesos), recursión (`KR_MAX_DEPTH=3`) y paralelismo (`KR_MAX_TEAMS_PARALLEL=4`).
- Recursión: `KAZEN_AGENT_DEPTH=3` = `KR_MAX_DEPTH=3` (tope alcanzado). **No se delegó ningún subagente**; el dictamen se consolida con evidencia verificada directamente (control de recursión, `scripts/kaizen-runtime:60`).
- Restricciones respetadas: no se leyó `.env` ni credenciales; no se modificó `scripts/`, `.kaizen/` ni `.github/`; no se hizo push, PR ni commit. Solo se escribe este archivo.

## Hallazgos

**H-1 (CRÍTICO) — El contrato de despacho del runtime contradice L-3/L-4.**
`scripts/kaizen-runtime:48` instruye a cada agente: *"escribe tu finding/handoff en `.kaizen/team/projects/`"*. `L-4` prohíbe modificar `.kaizen/` y `L-3` exige humano para rutas protegidas en cualquier nivel de autonomía. La arquitectura genera estructuralmente una violación de su propia regla: el orquestador ordena a los agentes escribir en una ruta que su propio contrato declara protegida. No existe ADR que autorice la excepción ni canal `needs-human` en el despacho.

**H-2 (CRÍTICO) — La "recursión controlada" es una constante, no un contrato verificable.**
`scripts/kaizen-runtime:60` lanza **todo** agente con `KAZEN_AGENT_DEPTH="$KR_MAX_DEPTH"` (3). No hay incremento (`profundidad_actual + 1`), ni propagación en el mensaje de despacho (`:48`), ni manejo del tope distinto de `flock` por equipo (`:31-32`). Resultado: todos los agentes arrancan *ya* en el techo; la delegación queda prohibida en la práctica, o se ignora la variable y queda sin control. La única prueba asociada (`tests/run.sh:168`) hace `grep 'KR_MAX_DEPTH=3'` en `runtime.env`: verifica un valor de configuración, **no el comportamiento**. Falta el contrato de profundidad (semántica, propagación, tope, auditoría) y su prueba.

**H-3 (ALTO) — El paralelismo de equipos bypasses el aislamiento del swarm.**
`teams.json` define 4 equipos (tope = 4) que `kaizen-runtime deploy` ejecuta en el **mismo árbol de trabajo** (`:101-115`), sin worktree por equipo, sin `contracts/ownership.json`, sin leases por tarea y sin `.kaizen/swarm/issues/<N>/`. K-12, `LOOP.md` L-15, `PROTOCOL.md:51` y la puerta `change` de `governance.json` (`descriptor K-4, ownership.json, kaizen check y sin BLOCK abierto`) exigen exactamente esos controles. En este repositorio **no existe ningún `ownership.json`**. Además:
- `verificador-evidencias` pertenece simultáneamente a `equipo-central` y `cumplimiento` → misma identidad escribiendo rutas compartidas en paralelo.
- `$S/last.json` (`:64`) se sobrescribe por cada equipo → *last-writer-wins*; el estado global no es confiable.

**H-4 (ALTO) — Carrera en el buzón de entrada con 4 equipos en paralelo.**
`scripts/kaizen-runtime:37-42`: cada ciclo hace `find … | sort | head -1` (selecciona el **mismo** primer mensaje) y luego `sed -i 's/^status: pending$/status: processed/'` sobre ese archivo compartido. No hay *claim* atómico ni verificación de propietario. Con `KR_MAX_TEAMS_PARALLEL=4`, cuatro ciclos pueden leer y marcar simultáneamente la misma instrucción; el "anti-recursividad" es best-effort, no una garantía.

**H-5 (MEDIO) — `KR_MAX_TEAMS_PARALLEL` no es un semáforo.**
`scripts/kaizen-runtime:107-111`: al alcanzar el tope ejecuta `wait`, que espera a **todos** los trabajos en segundo plano, no a una ventana deslizante. Hoy (4 equipos, tope 4) no se observa el defecto, pero el contrato "máximo N equipos concurrentes" no es generalizable: con más equipos se degradan a lotes secuenciales.

**H-6 (ALTO) — 263 herramientas REA sin compuerta de autorización por capacidad.**
`catalog.json` registra `rea_tools: 263` en 11 familias; `rea-tools.json` es una lista de 263 entradas. `rea-capabilities.json` declara operaciones con efectos `launches_process`, `may_access_network` y `may_write_filesystem` (p. ej. proveedor `native-macos`), y `analysis_provider_binding` es `null`. ADR-0009 exige el proceso `reverse_engineering` (A: humano; V: seguridad/cumplimiento) para **toda** conclusión REA, y trata su salida como dato no confiable (`_meta.provenance.untrusted_content`). No existe un contrato que vincule `capacidad → efecto → etapa authorize → identidad autorizada → auditoría` a nivel de herramienta; la disponibilidad de `tools.rea.*` no distingue una lectura inofensiva de una operación con `launches_process`. Alineación de control: ISO-001 (acceso y gestión de configuración), NIST-001 (`GV.RR`, `PR.AA`), AICPA-001 (`CC6`, `CC8`), OWASP-001 (A01/A05).

**H-7 (ALTO) — "Instalado" no es verificable y la verificación se contradice.**
ADR-0009:3 declara el estado *"aceptado e instalado"*, pero su propio criterio (`:30`) exige comprobar que **no** está instalada (*"sin entrada MCP rea en `opencode.json`"*). En disco `opencode.json` no tiene sección `mcp` (solo `$schema`, `instructions`, `permission`), y `tests/run.sh:259` da por buena la instalación con `grep -q '263 herramientas MCP'` sobre un documento — es decir, verifica una **cadena de texto**, no el runtime. S-2 impide leer la configuración global de OpenCode, por lo que **no puedo verificar** la instalación real de los 44 agentes ni del MCP. Falta un ADR/contrato que defina "instalado" y un procedimiento de verificación sin leer credenciales.

**H-8 (MEDIO) — Deriva documental (K-1) en los hechos fundacionales de la adopción.**
Conteo de agentes verificado: 43 (44 archivos en `.kaizen/org/prompts/` menos `_template.md`), coincidente con `governance.json` (43) y `CATALOGO-AGENTES.md` (43). Conviven además: 42 (`AGENTS.md:16`, `ORGANIZATION.md:16`, `OWNER.md:3`, ADR-0004/0006), 44 (`AGENTS.md:21`, ADR-0005:11, `RUNTIME.md:9`) y 45 (`README.md:18,132`, `roster.md:3`). Procesos: ADR-0008:11 afirma 9; `governance.json` tiene 10 (incluye `reverse_engineering`). ADR-0003:31 afirma catálogo de 32 agentes. Estas cifras son hechos internos sin `source_id` único y degradan el KPI "0 normas sin `source_id` verificado" por ambigüedad de la fuente de verdad. El conocedor de conocimiento ya reportó la inconsistencia de agentes; se añade la de procesos y la de ADR-0003.

**H-9 (ALTO) — El KPI `scripts/kaizen check en verde` no es confirmable de forma reproducible.**
Ejecuté `bash scripts/kaizen check`: pasó *descriptores*, *políticas*, *formato* y *lint*, y **quedó bloqueado más de 120 s en `tests/run.sh`**, que es la fase de pruebas. Causa arquitectural: `tests/run.sh:127` realiza una llamada de red a `https://www.antai.gob.pa/` (`kaizen-org research … --url …`). La puerta `deliver` de `FLUJOS.md` y el plan del proyecto exigen `kaizen check` en verde para avanzar; un test no hermético hace que la puerta sea no determinista en CI/offline. **No afirmo que esté en rojo ni en verde: no se pudo completar.** No fabrico evidencia (K-10).

**H-10 (MEDIO) — Supresiones S-10 sin referencia de issue en el runtime.**
`scripts/kaizen-runtime:71`, `:75` y `:114` usan `|| true` (con redirección a `/dev/null`) sin el formato `<supresión> -- #NNN motivo` que exige S-10. Todo hallazgo debe ir al outbox S-11, pero mi restricción explícita me prohíbe escribir en `.kaizen/`; **no se registró en el outbox** y debe hacerlo el orquestador.

**H-11 (MEDIO) — Ejecución fuera de la máquina de estados y handoffs sin ack.**
`state.json` sigue en `intake` (sin `advance`), `tasks.json` está vacío (`[]`) y los seis `handoffs` de `handoffs.jsonl` están `status: open` con `expects_ack: true`, sin acuse. `COMUNICACION.md:39` indica que sin ack el estado no avanza (`KSW_ACK_REQUIRED`). Los dictámenes se están produciendo sin lease, sin ack y sin transición registrada: la auditabilidad del proyecto es incompleta.

## Evidencia

### Fuentes verificadas (estado `verified` en `.kaizen/org/knowledge/SOURCES.md`, fecha de corte 2026-11-21)
| `source_id` | Emisor | Documento | Línea |
| --- | --- | --- | --- |
| `ISO-001` | ISO | ISO/IEC 27001:2022 | 26 |
| `NIST-001` | NIST | Cybersecurity Framework 2.0 | 28 |
| `AICPA-001` | AICPA | TSC 2017 / SOC 2 | 29 |
| `OWASP-001` | OWASP | ASVS 4.0 / Top 10 2021 | 31 |

`EVIDENCIA.md` REG-EV-01 (fuente no verificada bloquea) y REG-EV-07 (decisión = `source_ids` + fecha de corte + hash). Las cuatro fuentes citadas están `verified`; ninguna de mis recomendaciones se apoya en fuente `pending`/`conflict` (PA-009, PA-012, PA-015 e INT-002 quedan excluidas).

### Comandos ejecutados (salida real, sin secretos)
```
$ python3 -c "json.load(open('.kaizen/gov/governance.json'))"
  processes = 10 ; agents = 43
$ ls .kaizen/org/prompts/*.md | grep -v _template | wc -l
  43
$ python3 -c "len(json.load(open('.kaizen/catalog/rea-tools.json')))"
  263
$ python3 -c "json.load(open('.kaizen/catalog/catalog.json'))['stats']"
  {"rea_tools": 263, "providers": 5, "families": 11, "framework_skills": 12}
$ grep -nE '^(KR_MAX_DEPTH|KR_MAX_TEAMS_PARALLEL)=' .kaizen/team/runtime.env
  9:KR_MAX_DEPTH=3
  11:KR_MAX_TEAMS_PARALLEL=4
$ grep -n 'KAZEN_AGENT_DEPTH=' scripts/kaizen-runtime
  60:      KAZEN_AGENT_DEPTH="$KR_MAX_DEPTH" timeout ... 
$ cat .kaizen/team/teams.json
  4 equipos: equipo-central, cumplimiento, plataforma, producto
$ find . -name ownership.json -not -path './.git/*'
  (sin salida)
$ python3 -c "json.load(open('opencode.json')).keys()"
  ['$schema', 'instructions', 'permission']   # sin sección "mcp"
$ bash scripts/kaizen check
  ok: sin descriptores pendientes
  ok: politicas de contenido
  ok: formato
  ok: lint
  ... sin terminar en 120 s (fase tests/run.sh) → EXIT no observado
$ grep -n -- '--url' tests/run.sh
  127: ... kaizen-org research cumplimiento-panama ... --url https://www.antai.gob.pa/
```

### Lecturas de archivos de texto (sin credenciales)
`RULES.md` K-1/K-10/K-12 · `LOOP.md` L-3/L-4/L-15 · `SECURITY-RULES.md` S-2/S-10/S-11/S-15 · `EVIDENCIA.md` REG-EV-01/07 · `TEAM.md`/`COMUNICACION.md`/`FLUJOS.md` · `PROTOCOL.md:51` · `governance.json#agents/architect` y `processes` · ADR-0003, 0008, 0009, 0010 · `scripts/kaizen-runtime:37-48,60,64,71,75,101-115` · `tests/run.sh:127,168,259` · `state.json`, `tasks.json`, `handoffs.jsonl`.

**No verificado y dicho explícitamente:** instalación real del MCP/skill REA y de los agentes en `~/.config/opencode/` (S-2); resultado final de `scripts/kaizen check` (bloqueado en la fase de pruebas); contenido de cualquier `.env` (no leído).

## Riesgo

| # | Riesgo | Severidad | Impacto en el KPI |
| --- | --- | --- | --- |
| H-1 | Violación L-3/L-4 inducida por el propio despacho | Crítico | Invalida la gobernanza de rutas protegidas; bloquea `finalize`. |
| H-2 | Recursión no modelada como contrato | Crítico | Ni delegación controlada ni límite efectivo; imposible auditar profundidad. |
| H-3/H-4 | Paralelismo sin propiedad ni *claim* atómico | Alto | Escrituras concurrentes, pérdida de instrucciones, estado global erróneo. |
| H-6/H-7 | 263 capacidades con efectos sin gate ni verificación | Alto | Superficie de acceso no gobernada; evidencia de "instalado" fabricable por texto. |
| H-9 | Puerta `check` no determinista (red) | Alto | `verify` puede pasar/fallar por causas ajenas al cambio. |
| H-5/H-8/H-10/H-11 | Semáforo incompleto, deriva doc, supresiones, handoffs sin ack | Medio | Deuda arquitectural y trazabilidad degradada. |

Consecuencia agregada: mientras H-1, H-2, H-3 y H-9 estén abiertos, **no puede afirmarse** "0 normas sin `source_id` verificado y `kaizen check` en verde" como hecho verificable. Ejercicio del veto `architecture` según `COMUNICACION.md:41` y mi autoridad (`veto: architecture`).

## Recomendación

1. **ADR-0011 — Límites de ejecución y propiedad.** Unificar los dos modelos (swarm por issue y runtime por equipo): todo equipo paralelo debe tener worktree propio, `contracts/ownership.json` con globs por rol, leases y ack antes de handoff. Quitar de `scripts/kaizen-runtime:48` la instrucción de escribir en `.kaizen/team/projects/`; sustituirla por la ruta de artefactos permitida (`docs/kaizen/team/...`) y un `needs-human` explícito si se requiere tocar L-4. *(H-1, H-3, H-11; ISO-001, NIST-001 `GV.RR`/`PR.AA`, AICPA-001 `CC6`/`CC8`, OWASP-001 A01/A05.)*
2. **ADR-0012 — Contrato de recursión controlada.** Definir `KAZEN_AGENT_DEPTH` como profundidad **actual** (0 en el orquestador), incremento `+1` por delegación y bloqueo en `>= KR_MAX_DEPTH` con consolidación y reporte. Propagarlo en el sobre del mensaje (`correlation_id` + `depth`) y sustituir el `grep` de `tests/run.sh:168` por una prueba que verifique la negativa a delegar en el tope. *(H-2; NIST-001 `GV.OV`, AICPA-001 `CC4`.)*
3. **ADR-0013 — Compuerta REA por capacidad.** Mapear cada una de las 263 herramientas al esquema `{efecto, riesgo, etapa reverse_engineering requerida}`; exigir un registro de autorización humano + veto de seguridad/cumplimiento para operaciones con `launches_process`, `may_write_filesystem` o `may_access_network`; fijar `analysis_provider_binding` al proveedor autorizado y registrar la evidencia con `_meta.provenance.untrusted_content`. Corregir ADR-0009: eliminar la condición "no instalada" o declarar formalmente la instalación con prueba verificable sin leer secretos. *(H-6, H-7; ISO-001, NIST-001 `GV.RM`/`PR.AA`, AICPA-001 `CC3`/`CC6`, OWASP-001 A01.)*
4. **ADR-0014 — Buzón y paralelismo deterministas.** *Claim* atómico del mensaje (rename/`flock` sobre el archivo, o índice con `owner`), semáforo real con `wait -n`/PIDs por ventana, `last.json` por equipo y agregado por el orquestador. *(H-4, H-5.)*
5. **ADR-0015 — Puerta `check` hermética.** Eliminar o simular la llamada de red de `tests/run.sh:127`; fijar timeout y modo offline; reportar `check` con salida y código reales antes de `deliver`. Mientras tanto, marcar `verify` como `needs-human`. *(H-9; AICPA-001 `CC7`, NIST-001 `DE.CM`.)*
6. **Correcciones de documentación (K-1).** Unificar el recuento a "43 definiciones + 1 plantilla" en `AGENTS.md`, `RUNTIME.md`, ADR-0005, `README.md`, `ORGANIZATION.md`, `OWNER.md` y `roster.md`; actualizar ADR-0008 (9 → 10 procesos) y ADR-0003 (32 → 43 agentes). *(H-8.)*
7. **S-10/S-11.** Sustituir los tres `|| true` de `scripts/kaizen-runtime` por manejo explícito con referencia de issue, y hacer que el orquestador registre en el outbox los hallazgos H-1…H-11 (yo no puedo escribir `.kaizen/`). *(H-10.)*
8. **No avanzar** de `intake` a `deliver`/`verify` hasta que `scripts/kaizen check` termine en verde y existan los acuses pendientes de `handoffs.jsonl`. *(H-9, H-11.)*

## Dictamen

**BLOCK**

Ejercicio del veto de arquitectura. Los cuatro hechos cuantitativos solicitados **sí están verificados** (263 herramientas REA, 43 agentes, 10 procesos, `KR_MAX_DEPTH=3` / `KR_MAX_TEAMS_PARALLEL=4`), y las cuatro fuentes exigidas (`ISO-001`, `NIST-001`, `AICPA-001`, `OWASP-001`) están `verified` en `SOURCES.md`. Sin embargo:

1. **No se pudo verificar** el KPI `scripts/kaizen check en verde`: la ejecución se detuvo en la fase de pruebas durante más de 120 s por una llamada de red no hermética (`tests/run.sh:127`). Afirmar verde sería fabricar evidencia (K-10).
2. **No se pudo verificar** la instalación real de REA/OpenCode sin leer configuración global (S-2), y la documentación que la afirma se contradice (ADR-0009:3 vs :30).
3. Existen acoplamientos peligrosos confirmados (H-1 despacho vs L-3/L-4, H-2 recursión como constante, H-3/H-4 paralelismo sin propiedad ni *claim* atómico) que requieren ADRs nuevos (H-1…H-5) antes de considerar cerrada la adopción.

Condiciones para levantar el BLOCK: (a) ADR-0011 a ADR-0015 aprobados por humano y reflejados en contratos/pruebas; (b) `scripts/kaizen check` completado en verde con salida real; (c) verificación independiente de REA por `security`/`verificador-evidencias` sin violar S-2; (d) acuses de los handoffs y registro S-11 de los hallazgos por el orquestador. Escalado a El Presidente y al facilitador con `correlation_id` del proyecto `adopcion-kaizen-opencode`.
