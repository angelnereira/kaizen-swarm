# ADR-0033: Integración de OpenCode V2 en kaizen-swarm

> **Estado: aceptado el 2026-11-24 por El Presidente** (instrucción «avanza»). Aprueba la secuencia O1 → O5 → O2 → O3 y el veto a O4. No modifica ADR-0017 ni ADR-0031. Las condiciones C1–C10 de `security` siguen siendo puertas obligatorias para cada fase; los conflictos REG-EV-04 C1/C2 permanecen `unknown` y escalados.

| Campo | Valor |
| --- | --- |
| id | ADR-0033 |
| proyecto | `analisis-opencode-oficial`, T4, handoff `H-OC-20261124020855-4` (ack rc=0) |
| correlation_id | `analisis-opencode-oficial` |
| source_ids | `[OC-001, OC-002]` — `verified` en `SOURCES.md:40-41`; `verify` RC=0 (T1), con salvedad estructural |
| fecha de corte | 2026-11-23/24 |
| verdades | **OC-001** = docs oficiales V2 `https://opencode.ai/docs/` (índice `llms.txt`); **OC-002** = repo oficial `https://github.com/anomalyco/opencode` (MIT) |
| versión | objetivo **v2.4.1** (2026-11-23, T2); mínimo **≥ 2.2.3** (≥ 2.2.6 si `websearch.use`, T7/C2) — `opencode --version` pendiente de F0 |
| retador | `architect`: **BLOCK** sobre O4; `security`: CHANGES_REQUESTED (C1–C10); T3: ausente |
| entradas | T1 APPROVE · T2 APPROVE · T3 **PENDING** · T5 APPROVE · T6 APPROVE · T7 CHANGES_REQUESTED · T8 proposal |

## Contexto

kaizen-swarm ya tiene gobernanza versionada (`.kaizen/RULES.md`, gates `scripts/kaizen check`, outbox S-11, acuses, leases, 45 definiciones de agente) y hoy interactúa con OpenCode sobre todo por shell y por Code Mode (`tools.opencode.*`). OpenCode V2 ofrece config declarativa con `permissions`/`policies`, MCP, `@opencode/client`, `@opencode/sdk` y plugins. La superposición es real, pero dos hechos limitan la adopción: (1) `permissions` **no es un sandbox** —la política base es `{*: *: allow}`, `.env` está en `ask`, `external_directory` no tiene regla y los subagentes no heredan un subconjunto— y (2) la API de plugins es un breaking change V1→V2. Por eso la verdad de los gates permanece en código versionado (OC-001, `/docs/config/`, `/docs/permissions/`, `/docs/policies/`; OC-002, SECURITY.md vía T7, corte 2026-11-23/24).

## Criterio de decisión

Preferir opciones que: (a) mantengan los gates en código versionado, (b) sean reversibles sin migración destructiva (L-7), (c) no introduzcan secretos (S-1/S-2) ni dependencias sin verificar (S-9), (d) no desplacen al humano en sensible (L-3/L-4), y (e) produzcan métrica comparable antes/después (L-9).

---

## Oportunidades priorizadas

### O1 — Gobernanza declarativa con `policies` de autoridad alta (PRIORIDAD 1)

**Qué**: `opencode.jsonc` con `$schema`, `policies` deny-by-default y `permissions` de apoyo: denegar `shell` amplio con allowlist estrecho (`git status *`, `git diff *`), `read:*.ssh/*`, `external_directory:*`, `edit:*.env`, `webfetch:*` salvo dominios permitidos y `execute` para el rol `security`; regla explícita `external_directory` `ask`/`deny`; mismos permisos replicados en `agents.<id>.permissions` de **cada** subagente (herencia no garantizada); `instructions` hacia `.kaizen/RULES.md`/`AGENTS.md`. Sin `experimental.*`. Usar `mcp.use`/`skill.use`/`plugin.use` **nunca** `integration.use: *` como control de extensiones. (OC-001, `/docs/config/`, `/docs/permissions/`, `/docs/policies/`, corte 2026-11-23/24)

- **Coste**: bajo — config versionada + prueba sintética; sin instalación.
- **Riesgo**: medio — default permisivo y precedencia invertida pueden dar **falso sentido de seguridad**; desde 2.2.3 `integration.use: *` cambió de semántica (fail-open); statements inválidos se descartan con warning en log. Mitigación: versión ≥ 2.2.3, líneas rojas en managed/system/Console cuando aplique, revisión del log `role=server` tras cada edición y dictamen de `security`.
- **Reversibilidad**: **muy alta** — borrar/ajustar config; sin estado persistente.
- **Criterio L-9**: 100% de `git push` a `main` y de `edit` en `KL_PROTECTED_GLOBS` denegados en prueba sintética antes/después; 0 statements descartados sin justificar (S-10); 0 secretos en config; `verify` en verde.

### O2 — Servidor MCP local para herramientas Kaizen (PRIORIDAD 2)

**Qué**: exponer `scripts/kaizen-team|kaizen-swarm|kaizen-org|kaizen-voice` como MCP local (stdio) bajo `mcp.servers` V2, `codemode: true`, `disabled: true` hasta aprobación, `mcp.use: * deny` + allowlist nominal, permisos `<server>_<tool>`, secretos **solo** `{env:NAME}` y `timeout.execution` reducido al mínimo operativo (no 12 h). (OC-001, `/docs/mcp-servers/`, corte 2026-11-23/24)

- **Coste**: medio — implementar y testear servidor MCP + config + permisos.
- **Riesgo**: medio-alto — superficie de ataque; *server instructions* se inyectan al system prompt (prompt injection → dato no confiable, L-5/S-15); `sessionID` no autentica; paquetes locales sin versión (`npx -y pkg`) ejecutan código descargado (S-9); MCP externo está **fuera** del modelo de amenaza del upstream (T7 §6). Mitigación: denegar todas las tools del servidor a agentes que no lo necesitan (así se omiten sus instructions), OAuth primero si aplica, versión fijada, auditoría de llamadas, `disabled: true` hasta T7 sin BLOCK.
- **Reversibilidad**: **alta** — quitar entrada o `disabled: true`; sin migración de datos.
- **Criterio L-9**: `grep` de secretos en config → 0; 100% de invocaciones en log auditable; disminución medible de round-trips shell frente a línea base; `kaizen-team verify` sigue en verde.

### O3 — Cliente tipado `@opencode/client` para orquestación (PRIORIDAD 3)

**Qué**: sustituir invocaciones shell ad-hoc por `@opencode/client` (`OpenCode.make`, `Service.ensure({ version: (v) => v.startsWith("2.") })`, `AbortSignal.timeout`, RPC tipado, streams `AsyncIterable`), conservando Code Mode `tools.opencode.*` para descubrimiento. Usar `/api/experimental/generate/text`, nunca la ruta genérica deprecada. Si el contrato usa Effect Schema, emplear `@opencode/client/effect` (el cliente Promise no decodifica localmente). (OC-001, `/docs/build/client/`, `/docs/api/`, T6 §2, corte 2026-11-23/24)

- **Coste**: medio-alto — dependencia npm fijada + lockfile (S-9, revisión humana), capa de abstracción y contract tests.
- **Riesgo**: medio — API HTTP marcada **experimental** (178 operaciones, 528 schemas) y es breaking change V1→V2; streams sin replay/reconexión → resync explícito; acoplamiento a versión del servidor. Mitigación: predicate `2.`, contract tests, pin + lockfile, no construir gobernanza crítica sobre rutas experimentales.
- **Reversibilidad**: **media** — capa de abstracción permite volver a `opencode api`/shell; sin tocar datos.
- **Criterio L-9**: latencia p95 y tasa de error antes/después; 0 llamadas a V1; predicate falla explícitamente ante V1; cobertura de contract tests no menor que la línea base (K-5).

### O5 — Recursión controlada y skills declarativas (PRIORIDAD 4, coste 0)

**Qué**: expresar `KAZEN_AGENT_DEPTH`/`KR_MAX_DEPTH` como permisos `subagent` por ID y `steps` por agente; skills con `metadata.opencode/autoinvoke: false` y permiso `skill: ask`; IDs `kebab-case` únicos. Mapear las 45 definiciones como plantillas `.opencode/agents/<id>.md` **sin duplicar gobernanza** (K-1: la fuente de verdad sigue en `.kaizen/org/prompts/`). (OC-001, `/docs/agents/`, `/docs/skills/`, T2 §2/§3, T8 piloto 1, corte 2026-11-23/24)

- **Coste**: 0 USD; coste de conversión y validación.
- **Riesgo**: bajo-medio — copiar una definición **no aumenta autonomía** (L-16); `experimental.subagent_depth` es inestable y no debe gobernar una regla K sin ADR humano; catálogos HTTP de skills son contenido externo no confiable (S-15).
- **Reversibilidad**: **muy alta** — `git checkout` de config; sin datos.
- **Criterio L-9**: 0 violaciones de profundidad en logs; 100% de skills con `description` y permiso explícito; 0 definiciones duplicadas entre `.kaizen/` y `.opencode/`.

### O4 — Plugin/hook propio como gate de gobernanza — **RECHAZADA (veto `architecture`)**

**Qué se proponía**: plugin `@opencode/plugin` con hooks que ejecutaran `kaizen check`, el outbox S-11 y los acuses automáticamente.

- **Coste**: alto — plugin TypeScript, pin de `@opencode/plugin`, publicación/tests.
- **Riesgo**: **HIGH (S-14)** — API de plugins breaking change V1→V2; plugins se autocargan desde `.opencode/plugins/`; la doc publica `"@opencode/plugin": "latest"` (supply chain S-9); el hook `prompt` puede reescribir texto persistido y no es exactamente-una-vez (T2 §5.6); `plugin.use: * deny` es condición C6 de seguridad. Un upgrade podría desactivar el hook sin error visible y dejar pasar un cambio sin gate → viola K-11/S-10 y los vetos.
- **Reversibilidad**: media, pero una aprobación indebida **no es reversible**.
- **Criterio L-9**: no aplica como gate. Único uso admitido: **observador/notificador**, nunca autoridad; la verdad sigue en `scripts/kaizen check` y `policies`. Si se adopta así: pin exacto, lockfile, test de contrato y dictamen fresco de `security`.
- **Voto**: **BLOCK** del retador; `innovation` también la descarta por supply chain. Requiere respuesta en buzón; a 2 turnos resuelve `architect`; si persiste, `needs-human`.

---

## Condiciones de seguridad incorporadas (T7, C1–C10)

| # | Condición (obligatoria antes de adopción operativa) | Cómo se satisface en este ADR |
| --- | --- | --- |
| C1 | Fuentes verificadas y `verify` en verde | ✅ OC-001/OC-002 `verified`; F0 confirma alcance estructural de `verify`. |
| C2 | Versión ≥ 2.2.3 (≥ 2.2.6 si `websearch.use`) | F0: `opencode --version` + registro; objetivo v2.4.1. |
| C3 | Perfil `policies` con deny de shell amplio, `.ssh`, `external_directory`, `*.env`, `execute` + allowlist estrecho | O1. |
| C4 | `external_directory` explícito y subagentes revisados (herencia no garantizada) | O1 + O5. |
| C5 | OAuth primero; secretos solo `{env:NAME}`; versión fijada en `npx` | O2. |
| C6 | `mcp.use`/`skill.use`/`plugin.use` deny-by-default; sin `integration.use: *` | O1 + O2 + O4 rechazada. |
| C7 | Sin instalación de plugins/skills/MCP; aprobación humana fresca | Restricción global; F1–F3 no instalan. |
| C8 | Logs/snapshots/profiles nunca versionados sin redacción | Restricción global; ningún artefacto generado. |
| C9 | Código generado solo tras revisión + `kaizen-security check`, entorno aislado | Runbook pendiente en F4; ninguno ejecutado aquí. |
| C10 | Sin push, gasto ni rutas protegidas; acuse registrado | ✅ Ack rc=0; este borrador no modifica nada de lo anterior. |

**Declaración requerida por T7**: `permissions` **no sustituye** al diseño ni es sandbox; el upstream declara que OpenCode no sandboxes al agente y que MCP/config quedan fuera de su modelo de amenaza. Cualquier hallazgo vulnerable se gestiona en canal privado interno; **ningún agente abre reportes de seguridad automatizados** contra anomalyco/opencode (S-13).

---

## Plan por fases

| Fase | Acción | Puerta de salida |
| --- | --- | --- |
| **F0 — Precondición** | Confirmar `opencode --version` ≥ 2.2.3 y registrar; cerrar T3 (`reviews/researcher.md`); documentar que `verify` es estructural; revisar que no existan policies con semántica pre-2.2.3. | Versión registrada + T3 entregado + `verify` verde + El Presidente aprueba el ADR. |
| **F1 — O1** | Crear `opencode.jsonc` con `$schema`, `policies` y `permissions`; replicar baseline en agentes; sin instalar nada. | Prueba sintética de denegación + 0 warnings descartados + T7 sin BLOCK. |
| **F2 — O2** | Servidor MCP local con `disabled: true`, deny-by-default, `{env:...}`, timeout acotado; activar solo tras T7 sin BLOCK. | Logs de auditoría + métrica de round-trips + C5/C6 cerradas. |
| **F3 — O3 + O5** | Cliente tipado con pin V2, contract tests, y mapeo de profundidad/skills con coste 0. | KPI L-9 mejorado; si no, `regression-suspect` + revert (L-9). |
| **F4 — Revisión** | Reevaluar plugins solo como observador; runbook C9; revalidar fuentes (REG-EV-05); cerrar memorial. | Sin BLOCK abierto ni ack pendiente. |

**Rollback**: F1 = borrar config; F2 = `disabled: true`/quitar entrada; F3 = revertir capa, dependencia y mapeos. Ninguna fase toca rutas protegidas (L-4), secretos (S-1/S-2), migraciones destructivas ni `main` (ADR-0023).

## Contraejemplos considerados

1. *«Los hooks del plugin bastan, no hace falta tocar config»* — **rechazado**: gobernanza sujeta a API con breaking changes y a `latest`; ver O4.
2. *«`permissions` ya bloquea todo, no necesitamos `policies`»* — **rechazado**: base `{*: *: allow}`, `.env` en `ask`, `external_directory` sin regla, subagentes no heredan subconjunto; T7 lo confirma con SECURITY.md.
3. *«MCP remoto con OAuth es más simple»* — **diferido**: el caso es local; stdio + `{env:...}` + `disabled: true` reduce superficie; OAuth se reserva para remotos con evidencia.
4. *«El SDK embebido es más rápido y evita el servicio»* — **diferido**: `@opencode/sdk` corre en memoria sin listener HTTP, pero acopla ciclo de vida y sus worktrees exigen `projectID`; útil para tests deterministas (T2 §10), no para gobernanza hoy.
5. *«Instalar plugins de la comunidad acelera F2»* — **rechazado**: S-9/S-15 exigen verificación y aprobación humana fresca; C7.
6. *«`experimental.subagent_depth` resuelve la recursión»* — **rechazado como control**: es experimental y no debe gobernar una regla K sin ADR humano; O5 usa permisos `subagent`/`steps`.
7. *«`integration.use: *` ya prohíbe extensiones»* — **rechazado**: desde 2.2.3 bloquea providers, no MCP/skills/plugins (fail-open documentado por T7).
8. *«Podemos decidir ya porque el plan nombra las fuentes»* — **subsanado**: T1 las verificó; aun así el pase de `verify` es estructural porque `decisions/` está vacío, y T3 falta.

## Memorial y disidencia

- **Decisión propuesta**: O1 > O2 > O3 > O5 condicionada a F0 y C1–C10; O4 vetada como gate.
- **Disidentes**: `architect` (retador, BLOCK sobre O4); `security` (CHANGES_REQUESTED, veto activo); `researcher` T3 ausente; `qa` sin dictamen; `innovation` descarta plugins.
- **Evidencia**: 6 páginas oficiales V2 consultadas (corte 2026-11-23/24) + reviews T1/T2/T5/T6/T7/T8; `SOURCES.md:40-41` `verified`; `verify` RC=0 (T1); ack rc=0; T2 fija v2.4.1; T7 formula C1–C10.
- **Incertidumbre**: T3 sin entregar; versión instalada no ejecutada aquí; `verify` estructural; semántica 2.2.3; API HTTP experimental; streams sin replay; `/reload` no documentado (T5); `request` de agente no se envía aún en V2 (T2 §2.4).
- **Dueño humano**: El Presidente — aprueba ADR, gobernanza/autonomía y activación de O2.
- **Revisión**: tras F3 con métrica L-9; revalidación trimestral de fuentes (REG-EV-05).

**Nota de alcance**: borrador no aprobado; no cambia autonomía, no instala dependencias, no ejecuta comandos de documentación, no modifica ADR-0017/ADR-0031 ni `docs/kaizen/adr/`.
