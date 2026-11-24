---
status: CHANGES_REQUESTED
role: finops
correlation_id: integracion-rae-api-toolkit
handoff: H-20261123161721-7
task: T7 — coste tokens vs ruta nativa, cuota de disco y métricas
source_ids: [TOOL-001, TOOL-002]
source_cutoff: 2026-11-21
created: 2026-11-23T16:30:00Z
expects_ack: true
channel: review
refs:
  - .kaizen/org/knowledge/SOURCES.md
  - .kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md
  - .kaizen/loop/outbox/rae-api-instalacion-cuota.md
  - docs/kaizen/adr/0009-integracion-rea-gobernada.md
  - docs/kaizen/adr/0017-integracion-reverse-api-engineer.md
  - .kaizen/evals/report.md
  - scripts/kaizen-eval
---

# Dictamen FinOps — T7 (externo vs nativo)

**Veredicto: CHANGES_REQUESTED.** No bloqueo la ruta; condiciono el cierre a que exista un cap presupuestario aprobado y a que el coste se registre tras la captura autorizada. No hay veto FinOps (autoridad: `recommend`), y no ejecuté ninguna acción con gasto.

## Observación

La comparación de coste no puede cerrarse con una cifra hoy: la ruta externa (TOOL-002) expone el coste real **solo después** de una captura (`usage.total_cost_usd`), y no hay ninguna captura ejecutada ni ninguna métrica registrada. La ruta nativa (TOOL-001) ya está pagada en infraestructura local y no añade un segundo pipeline de inferencia.

## Evidencia (comandos y archivos reales, sin secretos)

- `SOURCES.md:38-39` → `TOOL-001` (morluto/rea, MIT) y `TOOL-002` (kalil0321/reverse-api-engineer, MIT), ambos `verified`, fecha de corte 2026-11-21 (REG-EV-01 en verde).
- `plan.md:4-7` → CLI v0.16.0 instalada en `~/.local/lib/python3.14/site-packages`; `reverse-api-engineer list --json` → `[]` (**cero runs**); skill no local; ADR-0017 desactualizado.
- `.kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md:33,49` → esquema `--json` con `usage` (tokens y `total_cost_usd`); regla: registrarlo con `kaizen-eval metrics add` cuando aplique.
- `.kaizen/loop/outbox/rae-api-instalacion-cuota.md:6,9` → `OSError: [Errno 122] Disk quota exceeded` (EDQUOT = cuota de usuario, no partición); `df -h ~` mostraba 34 GB libres en el momento del fallo.
- `df -h` (ejecutado hoy, solo lectura) → `/dev/nvme0n1p2` 468 G, usado 304 G, disponible 140 G, 69 %. **Esto no demuestra que la cuota de usuario se haya liberado**: `df` informa del filesystem, no de EDQUOT.
- `python3 scripts/kaizen-eval status` → `métricas: 0`, `baseline: SI`, rc=0. `.kaizen/evals/report.md:33` → «Decisiones registradas: 0». El registro de coste aún no existe.
- `python3 scripts/kaizen-eval --help` → imprime `uso: kaizen-eval check|baseline|ratchet|metrics add|report|status|all`, rc=2: **`--help` no es subcomando**; usar `status` o `metrics add`.
- `docs/kaizen/adr/0009-integracion-rea-gobernada.md:3,14` → REA aprobado e instalado por humano (A: Angel Nereira, 2026-11-21); coste de infraestructura ya absorbido.
- `docs/kaizen/adr/0017-integracion-reverse-api-engineer.md:3,15` → «instalación pendiente por cuota» y `cost_cap` sin fijar; el contrato de outsourcing registra `cost_cap: por aprobar (requiere liberar cuota)`.
- No había `reviews/` en el proyecto al emitir: T2 y T3 aún no han dejado dictamen en disco. Mi evaluación usa el contexto verificado y los archivos citados; no invento su contenido.

## Desglose de costes

| Concepto | Ruta externa (TOOL-002, CLI v0.16.0) | Ruta nativa (TOOL-001, REA MCP) | Medición |
| --- | --- | --- | --- |
| Instalación / cuota | 0 USD de licencia (MIT). Coste real = tiempo de reintento ya perdido por `Errno 122`; requiere liberar cuota de usuario antes de cualquier `pip`/`npx`. Skill no presente en local. | 0 USD marginal: ADR-0009 aprobado, instalado, 263 herramientas disponibles. | `df -h` + outbox (no confirma cuota liberada). No reinstalar en esta tarea. |
| Tokens por captura | **Incremental y desconocido hasta medir**: el SDK configurado en `~/.reverse-api/config.json` (claude/opencode/codex/…) genera el cliente y consume tokens por captura. `usage.total_cost_usd` es la única cifra autorizada. | Sin cargo por ToolCall de REA; solo la inferencia del agente ya presupuestada en la sesión. Lee tráfico/HAR con herramientas locales. | Tras captura autorizada: `reverse-api-engineer show <run_id> --json` → `usage.total_cost_usd` → `kaizen-eval metrics add`. Hoy: `$0` porque no hay runs (`list --json` → `[]`). |
| Mantenimiento de dependencias | Paquete Python en `~/.local` (3.14) + SDK del modelo + proveedor de captura (`chrome-mcp`/Playwright/`agent-browser`). Exige fijar versión, lockfile y revisión humana de manifiestos (S-9); `cryptography` no degradar. | Dependencia única ya gobernada y con evidencia por herramienta; sin nuevo manifiesto que revisar. | `reverse-api-engineer --version` (ya verificado: 0.16.0). Sin gasto. |

**Coste actual acumulado medible: USD 0.00** (0 capturas, 0 métricas). Coste future por captura: **no cuantificable sin ejecutar**; cualquier cifra ahora sería fabricada (K-10).

## Cómo medir sin gastar hoy

1. `python3 scripts/kaizen-eval status` → cuenta de métricas (hoy: 0). Solo lectura.
2. `reverse-api-engineer list --json` → `[]` confirma que no hay `run_id` que facturar (ya ejecutado según `plan.md:5`).
3. `df -h` → espacio del filesystem; **no** sustituye a una comprobación de cuota de usuario. No usar para declarar resuelto el `Errno 122`.
4. Preparar (NO ejecutar) el registro para el momento de la captura autorizada:
   `python3 scripts/kaizen-eval metrics add --agent reverse-api-specialist --decision DEC-001 --cost <usage.total_cost_usd> --minutes <n> --reverted 0`
5. Sin capturas, sin `npx`, sin `pip`, sin `playwright install`, sin credenciales leídas. Cumplido en esta tarea.

## Impacto

- Si se integra la CLI sin cap ni registro: aparece un gasto por captura no atribuible a un `run_id` ni a una decisión, rompiendo el KPI del charter («coste registrado») y REG-EV-07.
- Si se elige solo la ruta nativa: se evita el gasto incremental, pero se pierde el HAR saneado y el cliente tipado reproducible que exige el KPI; T3/T4 deben confirmar si la automatización propia lo cubre.
- El desfase documental (ADR-0017 «pendiente» vs CLI instalada) ya indujo a un fallo de instalación por cuota; propagarlo a la decisión final daría un dictamen sin fuente real (K-1/K-10).

## Propuesta — control de coste (sujeto a humano: dinero es sensible, L-3)

1. **Presupuesto**: USD 0.00 autorizados para esta evaluación. Cualquier captura requiere el proceso `api_reverse_engineering` (A: humano, V: seguridad/cumplimiento) y un cap explícito. **Cap propuesto** (cifra propuesta, no norma verificada): 1 captura de prueba, tope USD 0.50 por `usage.total_cost_usd`. El Presidente lo aprueba o lo corrige; no se auto-aplica.
2. **Límite**: si no hay `run_id` + HAR saneado + `usage` en el JSON, la captura **no cuenta** como evidencia de coste y se repite solo con autorización. Nunca `--auto-install` ni instalación de dependencias durante la captura.
3. **Alerta**: si `usage.total_cost_usd` excede el cap aprobado, si `status != ok`, si reaparece `Errno 122`, o si `kaizen-eval status` sigue en 0 tras la captura → outbox S-11 (`kind: failure`) con fingerprint y escalado al gerente. No silenciar (S-10/S-11).
4. **Regla de paridad**: para cada captura de la ruta externa, registrar el tiempo invertido en la ruta nativa en el mismo `metrics add`, para comparar coste total y no solo tokens.

## Pregunta concreta

¿Aprueba El Presidente el cap propuesto (1 captura, USD 0.50 tope) y confirma que la cuota de usuario quedó liberada tras el `Errno 122`? Sin esa respuesta, `DEC-001` queda con `cost_cap: por aprobar` y no puede cerrarse como `verified`.

## Documentos tocados

- **Escrito por mí**: solo `.kaizen/team/projects/integracion-rae-api-toolkit/reviews/finops.md` (este dictamen). No toqué ADR, gobernanza, `scripts/kaizen*`, `.kaizen/` núcleo ni `docs/kaizen/adr/`. Sin push.
- **Deben actualizar otros dueños (K-7), no yo**:
  - `docs/kaizen/adr/0017-integracion-reverse-api-engineer.md`: replacing «instalación pendiente» por «CLI instalada v0.16.0; skill y captura pendientes» y fijar `cost_cap` aprobado (arquitecto + humano).
  - `.kaizen/org/outsourcing/rea-api-install/contract.md` / `evidence.md`: `cost_cap: por aprobar` → cap aprobado; el `evidence.md` referenciado no existe en disco (discrepancia para T1).
  - `.kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md`: añadir el cap y la regla de alerta junto a la línea 49.
  - `.kaizen/evals/metrics.jsonl`: se alimenta con `metrics add` **después** de la captura autorizada (hoy 0 registros).
