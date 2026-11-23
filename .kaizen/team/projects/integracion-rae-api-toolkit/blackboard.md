# Blackboard: integracion-rae-api-toolkit

Solo hechos con `source_ids` verificados o salida de comando reproducible.

## T1 — verificación de evidencias (verificador-evidencias, 2026-11-23)

Hechos reproducibles (comandos ejecutados por este agente, RC=0 salvo indicado):

- `reverse-api-engineer --version` → `reverse-api-engineer, version 0.16.0`. [cmd reproducible 2026-11-23]
- `python3 -m pip show reverse-api-engineer` → `Version: 0.16.0`, `License: MIT`, `Location: ~/.local/lib/python3.14/site-packages`. [TOOL-002; cmd reproducible 2026-11-23]
- `reverse-api-engineer list --json` → `[]` (sin capturas ejecutadas). [cmd reproducible 2026-11-23]
- `command -v reverse-api-engineer` → `~/.local/bin/reverse-api-engineer`. [cmd reproducible 2026-11-23]
- Skill `reverse-api-engineer` AUSENTE en `~/.agents/skills` y `~/.config/opencode/skills` (`test -d` → NOT_FOUND; `ls ~/.agents/skills` → solo `reverse-engineer-anything`, `use-railway`). [cmd reproducible 2026-11-23]
- `scripts/kaizen-team verify integracion-rae-api-toolkit` → `[kaizen-team] verify: todas las decisiones tienen fuentes verificadas` (RC=0). [cmd reproducible 2026-11-23]

Fuentes (SOURCES.md, fecha de corte 2026-11-21; `KT_EVIDENCE_TTL_DAYS=90` en `.kaizen/team/team.env`; 2 días consumidos → ninguna `stale`):

- TOOL-001 `verified` — REA (MIT). ACEPTADA.
- TOOL-002 `verified` — reverse-api-engineer (MIT). ACEPTADA.
- ISO-001 `verified` — ISO/IEC 27001:2022. ACEPTADA.
- NIST-001 `verified` — NIST CSF 2.0. ACEPTADA.
- Fuentes rechazadas: ninguna. Sin `pending`/`conflict`/`stale`. REG-EV-01 satisfecho; REG-EV-04 no aplica (sin contradicción entre fuentes oficiales).

Estado documental (hecho, no corregido por este agente — detalle en `reviews/verificador-evidencias.md`):

- `README.md:186` ("NO instalado") y `ADR-0017:3,5,15,27` ("instalación pendiente por cuota / Errno 122") contradicen la CLI instalada (v0.16.0). [cmd reproducible 2026-11-23]
- `.kaizen/org/outsourcing/rae-api-install/evidence.md:3` afirma "skill copiado": mitad CLI CIERTA (`~/.local/bin`), mitad skill FALSA (NOT_FOUND). [cmd reproducible 2026-11-23]
- `DEC-001` marcado `status: verified` con contenido aún plantilla (`<completar tras consenso>`): `verify` valida fuentes, no contenido; decisión no cerrada hasta memorial de T4. [lectura de `decisions/DEC-001-toolkit-externo-vs-nativo.md`]

Dictamen: `CHANGES_REQUESTED` (fuentes aceptadas; se requieren correcciones documentales; sin BLOCK de evidencia).

## Registro de coordinacion — 2026-11-23 (facilitador-equipo)

- `correlation_id: integracion-rae-api-toolkit` | `channel: broadcast` | `intent: finding` | `expects_ack: true` | `deadline: 2026-11-30` | `source_ids: [TOOL-001, TOOL-002]` (ambos `verified` en `SOURCES.md`). Sin secretos.

### Hecho verificable (comando reproducible)
`scripts/kaizen-team sync integracion-rae-api-toolkit` →
`proyecto=integracion-rae-api-toolkit etapa=execute | acuses pendientes=6 | tareas abiertas=8 | decisiones verificadas=1 | bloqueadas=0`
`[kaizen-team] hay 6 handoff(s) sin ack: la etapa no avanza`
(antes del ack propio de H-8 el mismo comando reporto 8 acuses pendientes; la variacion a 6 se debe a los acuses de H-6 por `qa` a las 16:19:47Z y de H-8 por `facilitador-equipo` a las 16:20:07Z, segun `handoffs.jsonl`).

### Handoffs abiertos (requieren ack de su propio dueno; el facilitador no acusa por otro)
| ID | Dueno | Tarea | deadline |
| --- | --- | --- | --- |
| H-20261123161721-1 | verificador-evidencias | T1 conciliar estado real vs documentado y validar source_ids | 2026-11-30 |
| H-20261123161721-2 | reverse-api-specialist | T2 inventario operativo del toolkit y runbook gobernado (sin capturar) | 2026-11-30 |
| H-20261123161721-3 | rea-specialist | T3 factibilidad ruta nativa sin repo externo (REA MCP + automatizacion propia) | 2026-11-30 |
| H-20261123161721-4 | architect | T4 ADR comparativo externo vs nativo/hibrido con retador y memorial | 2026-11-30 |
| H-20261123161721-5 | security | T5 veto seguridad: S-15/S-12, codigo generado, HAR y skills | 2026-11-30 |
| H-20261123161721-7 | finops | T7 coste tokens vs ruta nativa, cuota disco y metricas | 2026-11-30 |
Cerrados/acusados: H-6 (qa, 16:19:47Z) y H-8 (facilitador-equipo, 16:20:07Z). Cero tareas sin dueno al cierre del standup; 6 acuses pendientes documentados (uno por especialista).

### Reglas de turno aplicadas (`.kaizen/team/COMUNICACION.md`, `.kaizen/team/FLUJOS.md`)
- Un hablante por hilo por turno; si dos roles responden a la vez, el facilitador ordena por `created`.
- Ack obligatorio en todo `handoff` y todo `broadcast`; sin ack la etapa no avanza (KSW_ACK_REQUIRED). La etapa sigue en `execute` y no sera cambiada por el facilitador: lo mueve el orquestador segun puertas.
- Dos turnos de discrepancia con dato nuevo; a los dos turnos resuelve `arquitecto` (tecnico) o `analista-negocios` (alcance); si persiste, `needs-human`.
- Ninguna decision sin `source_ids` verificados (`kaizen-team verify` en verde, REG-EV-01). Cumplimiento, dinero, datos personales y seguridad requieren humano (L-3/L-4).
- Orden de turnos recomendado: T1+T6 (raices) → T2+T3 y T5 → T7 → T4 (ADR con retador y memorial). Cada especialista acusa su propio handoff.

### Escalacion del bug del orquestador (`needs-human`)
- Hallazgo: `scripts/kaizen-team assign` y `handoff` no escriben en `handoffs.jsonl` por uso de `now` (nativo de jq, numero) donde corresponde `$now` (string); `gsub` falla y la redireccion queda vacia (falso verde: `sync` reporto 0 acuses pendientes al crear el proyecto). `scripts/kaizen-team ack` **si funciona** y fue usado para H-8.
- Evidencia: `.kaizen/loop/outbox/kaizen-team-handoff-now-bug.md` (fingerprint `kaizen-team-handoff-now`, reincidencia 2026-11-23 para este proyecto); `scripts/kaizen-team:72,82`.
- Impacto: los handoffs se escribieron directamente en el archivo de datos del proyecto con sobre completo; sin el fix, `sync` puede dar falso verde y la etapa no avanza.
- Decision requerida: fix definitivo (sustituir `now` por `$now`) en `scripts/kaizen-team` — ruta protegida (L-4), requiere ADR y aprobacion humana. NO parcheado por este agente. Plazo: antes de la siguiente asignacion; dueno: humano responsable del repo.

### Actualizacion en vivo (acuses concurrentes durante el standup)
El registro superior es el snapshot verificado a las 16:20:07Z. Mientras se escribia, otros especialistas acusaron sus propios handoffs: H-4 (architect, 16:22:35Z), H-7 (finops, 16:23:01Z) y H-5 (security, 16:23:03Z). Ultima verificacion reproducible: `scripts/kaizen-team sync integracion-rae-api-toolkit` → `etapa=execute | acuses pendientes=4` (lectura inmediatamente posterior de `handoffs.jsonl` ya mostraba 3 abiertos: **H-1 verificador-evidencias, H-2 reverse-api-specialist, H-3 rea-specialist**). La discrepancia 4 vs 3 se debe a la carrera de acuses entre ambos comandos, no a un cambio de etapa. El facilitador no acusa en nombre de otro: H-1, H-2 y H-3 siguen abiertos y deben ser acusados por sus duenos. Etapa=`execute` sin cambios (la mueve el orquestador segun puertas).



## Aprobación humana fresca — 2026-11-23 (C6)
El Presidente autorizó explícitamente: "implementalo la idea es aprovechar en nuestro proyecto ese otro proyecto: https://github.com/kalil0321/reverse-api-engineer.git". Esto cubre C6 (S-15): confirmación humana fresca para usar/instalar el skill y la CLI externa. La aprobación general de ADR-0017 ya no es la única base. Alcance declarado por esta coordinación: integración gobernada (opción C, generador externo + REA como capa de captura), sin captura contra terceros, cap de coste propuesto USD 0.50 pendiente de confirmación explícita, ADR nuevo 0031 en `proposed`, ADR-0017 intacto. Fuente: mensaje directo del usuario en esta sesión (hecho reproducible en el hilo), `source_ids` de la decisión: TOOL-001, TOOL-002, ISO-001, NIST-001.

## Aplicación de condiciones T5 — 2026-11-23 (hechos verificados)
- C6: aprobación humana fresca de El Presidente registrada arriba.
- C3: `--auto-install` eliminado de bloques ejecutables en `runbooks/rae-api-runbook.md`; verificado con grep (solo comentarios/advertencias).
- C2: `SOURCES.md:39` actualizada por verificador-evidencias con `reverse-api-engineer v0.16.0`, wheel `reverse_api_engineer-0.16.0-py3-none-any.whl` y sha256 `079cd9585c6a6766a91f0e681fd5b530e08dc5ec12e3aa72e52bf2b263f50ca0`; `status: verified`, `kaizen-team verify` RC=0. Fuente: API oficial PyPI (HTTP 200, dos consultas independientes).
- Sandbox propio: `sandbox/server.py` bind `127.0.0.1:8765`, datos sintéticos, sin PII; servidor NO arrancado hasta la captura autorizada (TOOL-001/TOOL-002, ADR-0009).

## Bloqueo de captura — 2026-11-23 (hecho verificado)
`reverse-api-engineer agent ... --dry-run` sobre el sandbox local devolvió RC 1; `~/.reverse-api/config.json` ausente. Detector por categoría encontró 1 referencia `api_key`; no se imprimió ni copió valor (S-2/S-12). Skill instalado por clone+sparse-checkout tras fallar `npx skills add` (RC 124). Seguridad: APPROVE con visto bueno para 1 captura en 127.0.0.1:8765. Outbox: `.kaizen/loop/outbox/rae-api-preflight-sin-config.md`; escalado: `needs-human/2026-11-23-block-capture-config.md`. Sin captura ejecutada, sin gasto, sin secretos en artefactos.

## Procedencia del skill fijada — 2026-11-23 (S-9)
Repo oficial `kalil0321/reverse-api-engineer`, commit `a1c79a9b0eec6b63b34381370e7d8a8ab56ab3f8`. sha256 de la instalación: SKILL.md `27caaff1…63f55`, sessions.md `4e699c33…c1634`, setup.md `1b7f46c0…e7af2`, troubleshooting.md `3bd7625b…30184`; `sha256sum -c` → 4 OK. Registrado en `runbooks/rae-api-runbook.md`. No hubo descarga adicional ni captura.

## Verificación global — estado honesto (2026-11-23)
`scripts/kaizen-team check` → RC 0 (25 fuentes verificadas). `scripts/kaizen-team verify integracion-rae-api-toolkit` → RC 0. `scripts/kaizen check` → **RC desconocido**: proceso aún en ejecución tras 43:59 con salida parcial (`ok: descriptores validados`, `ok: politicas de contenido`, `ok: formato`, `ok: lint`). No se cuenta como pase (K-10). Outbox: `.kaizen/loop/outbox/kaizen-check-sin-rc.md`. El bloqueo de credenciales para la captura sigue abierto (NH-2026-11-23-001).

## Gates finales y escalados — 2026-11-23 (hechos verificados)
Documentación corregida por finops: README:186-190, `.kaizen/org/outsourcing/rae-api-install/evidence.md:3-5`, descriptor `docs/kaizen/pr-drafts/kaizen-integracion-rae-api-toolkit.md` (sin keyword inventado). `scripts/kaizen-team verify` RC 0; `kaizen-team check` RC 0. `scripts/kaizen check` → RC 124 con `FALLA: falta keyword de cierre` (no aprobado, no silenciado). Desajuste rama↔descriptor documentado. Escalados: `needs-human/2026-11-23-block-capture-config.md` y `needs-human/2026-11-23-block-check-keyword-y-descriptor.md`. Sin commit ni push.

## Resolución de bloqueos 1-3 por El Presidente — 2026-11-23
1. Config local creada sin credenciales: `~/.reverse-api/config.json` con `sdk: opencode`, `agent_provider: auto`, `output_language: python`, `output_dir: null`. Preflight `agent -p "validar configuracion sin captura" -u http://127.0.0.1:8765/ --dry-run --json` → **RC 0**, `status: ok`, `provider: auto`, sin errores; no se imprimió valor sensible. NH-2026-11-23-001 resuelto en cuanto a configuración (la captura sigue pendiente de ejecutarse).
2. GitHub inalcanzable (`gh issue list` → TLS handshake timeout). No se fabricó issue: se usó el centinela `Closes: none` que `scripts/kaizen:31` acepta, documentado en el descriptor. NH-2026-11-23-002 (parte keyword) resuelto.
3. Worktree limpio `/tmp/opencode/wt-rae-api-toolkit`, rama `kaizen/integracion-rae-api-toolkit`, commit `a15c838` con solo los cambios propios; el árbol original conserva únicamente los cambios ajenos preexistentes. Descriptor `kaizen-integracion-rae-api-toolkit.md` emparejado con la rama. NH-2026-11-23-002 (parte rama) resuelto.

## Intento de captura del KPI — 2026-11-23 (hecho verificado)
Preflight RC 0 con `sdk: opencode` / `agent_provider: auto`. Sandbox `127.0.0.1:8765` health/catalog 200. Única captura autorizada ejecutada: RC 1, `status: error`, `run_id: 25244c9ac6c5`, `har_path: null`, `script_path: null`, `error: "Agent analysis produced no result."`. Log del run: solo 1 evento `prompt`, sin respuesta del modelo. No se hizo segunda captura (cap = 1, guardrail de seguridad). Servidor detenido (SIGTERM). Outbox: `.kaizen/loop/outbox/rae-api-capture-sin-resultado.md`. KPI NO cumplido; sin coste registrado; sin evidencia fabricada (K-10).

## Gate final `kaizen check` — 2026-11-23 (RC real)
`scripts/kaizen check` → RC 1; `ok: descriptores validados`, `ok: politicas de contenido`, `ok: formato`, `ok: lint`, `FALLA: tests`, `ok: deuda 0 <= 0`. Unico gate rojo: tests. Reintento en worktree limpio colgado y terminado con SIGTERM (no cuenta como aprobacion). Procesos `tests/run.sh` colgados preexistentes en el entorno. No se silencia ni se afirma verde (K-10/S-10). Outbox: `.kaizen/loop/outbox/kaizen-check-sin-rc.md`.
