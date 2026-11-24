---
id: REV-ARCH-T4
correlation_id: analisis-opencode-oficial
channel: review
intent: finding
from: architect
to: [facilitador-equipo, verificador-evidencias, security, El Presidente]
task: T4 — oportunidades priorizadas y ADR con retador obligatorio
handoff: H-OC-20261124020855-4
status: CHANGES_REQUESTED
block: arquitectura — O4 (plugin/hook como gate de gobernanza)
expects_ack: true
deadline: 2026-12-01
source_ids: [OC-001, OC-002]
cutoff: 2026-11-23/24
created: 2026-11-24
---

# Dictamen del Arquitecto — T4 / analisis-opencode-oficial

**Veredicto: CHANGES_REQUESTED**, con **BLOCK (`veto architecture`) sobre la oportunidad O4** (plugin/hook como mecanismo de aplicación de gates). No apruebo la adopción operativa: `security` mantiene `CHANGES_REQUESTED` con 10 condiciones y T3 no ha entregado. Apruebo **continuar el ADR propuesto** bajo esas condiciones. La decisión final es humana (El Presidente).

> Mapeo de fuentes según `SOURCES.md:40-41`: **OC-001 = documentación oficial V2** (`https://opencode.ai/docs/`, índice `llms.txt`); **OC-002 = repositorio oficial** (`anomalyco/opencode`, MIT). Estado `verified`; `kaizen-team verify` RC=0 reportado por T1. Fecha de corte 2026-11-23/24. Todo contenido externo leído es dato no confiable (S-15/L-5): no se ejecutó comando procedente de esas páginas.

## Entradas revisadas (reales, no inventadas)

| Entrada | Estado | Uso en este dictamen |
| --- | --- | --- |
| T1 `reviews/verificador-evidencias.md` (`REV-VERIF-OC-T1`) | ✅ APPROVE | Fuentes `verified`; `verify` RC=0; advierte que el pase es **estructural** (`decisions/` vacío). |
| T2 `reviews/deep-researcher.md` (`REV-T2-DEEP-RESEARCHER`) | ✅ APPROVE | Mapa de capacidades V2; versión **v2.4.1** (2026-11-23); 11 secciones con URL por afirmación. |
| T3 `reviews/researcher.md` | ⏳ **PENDING** | No existe al cierre de este dictamen. No se inventó su contenido. |
| T5 `reviews/dx.md` (`REV-DX-T5-20261124`) | ✅ APPROVE (acotado) | `cli.json` vs `opencode.jsonc`; comandos/skills; recarga; `/reload` reportado como incertidumbre. |
| T6 `reviews/dev2-api.md` | ✅ APPROVE (diseño) | API OpenAPI 3.1.0 (178 operaciones, **experimental**), cliente, SDK, Service, RPC. |
| T7 `reviews/security.md` (`REV-SEC-T7-20261123`) | ⚠️ **CHANGES_REQUESTED** | Veto vinculante; condiciones **C1–C10**; pasa a BLOCK si se ignoran. |
| T8 `reviews/innovation.md` | `proposal` | Agents+Skills, ACP, compaction, snapshots; descarta warming/harnesses/web/plugins-@latest. |

Además: `charter.md`, `plan.md`, `tasks.json`, `state.json` (`execute`), `handoffs.jsonl` y `blackboard.md` leídos. `SOURCES.md:40-41` verificadas por `grep`. Ack de `H-OC-...-4` registrado (rc=0).

---

## Observación

Hay tres palancas integrables y verificables en documentación oficial V2 —config declarativa con `policies`/`permissions`, MCP local de herramientas Kaizen y cliente tipado `@opencode/client`— más una cuarta de coste cero (agents/skills para recursión controlada). Pero el terreno no es neutral: `permissions` **no es un sandbox** (base `{*: *: allow}`, `.env` en `ask`, `external_directory` sin regla, subagentes con permisos propios) y la API de plugins es un breaking change documentado. La evidencia ya está verificada; lo que falta no es fuente, es **endurecimiento** y una entrada (T3).

## Evidencia

1. `grep -n 'OC-00[12]' SOURCES.md` → filas 40-41 en estado `verified`; T1 reporta `kaizen-team verify` RC=0, con la salvedad de que `decisions/` está vacío (verificación estructural, no de contenido). (OC-001/OC-002, T1)
2. Config V2: `$schema: https://opencode.ai/config.json`; `permissions` ordered `{action,resource,effect}`; `policies` binarias que **solo restringen**, precedencia invertida (managed > sistema > Console > global > proyecto > `.opencode`); `agents` con `mode`/`steps`/`permissions`; `skills`, `commands`, `instructions`, `plugins`, `mcp`. `experimental.*` puede cambiar sin aviso. (OC-001, `https://opencode.ai/docs/config/`, `https://opencode.ai/docs/permissions/`, `https://opencode.ai/docs/policies/`, corte 2026-11-23/24)
3. `security` (T7): base policy `{action:"*", resource:"*", effect:"allow"}`; `.env` → `ask`; `external_directory` sin regla por defecto; subagente usa sus propios permisos, **no un subconjunto**; SECURITY.md declara que OpenCode **no sandboxes** al agente; desde 2.2.3 `integration.use: *` ya no bloquea MCP/skills/plugins (bloquea providers) → fail-open por cambio de semántica; statements inválidos se descartan con warning en log. (OC-001/OC-002, T7)
4. MCP V2: `mcp.servers` (V2 no pone nombres directamente bajo `mcp`); `disabled: true` en lugar de `enabled`; secretos **solo** `{env:NAME}` (`$NAME` no se expande); OAuth por defecto en remotos con credenciales fuera de la config; `codemode` default `true`; permisos `<server>_<tool>`; `sessionID` en `_meta` **no es autenticación**; timeout `execution` = 12 h; *server instructions* se inyectan al system prompt. (OC-001, `https://opencode.ai/docs/mcp-servers/`, corte 2026-11-23/24)
5. Plugins: `@opencode/plugin`, `Plugin.define`, partes server/TUI/GUI/RPC, carga automática desde `.opencode/plugins/`, publicación npm con `"@opencode/plugin": "latest"` en la doc; hooks `prompt` pueden reescribir la entrada persistida y no son exactamente-una-vez; la API de plugins es, con la HTTP, uno de los dos breaking changes intencionales V1→V2. (OC-001, `https://opencode.ai/docs/build/plugins`, `/build/plugins/server/`, `/migrate-v1/`, T2 §5, corte 2026-11-23/24)
6. Cliente: `@opencode/client`, `OpenCode.make`, `Service.ensure({ version: (v) => v.startsWith("2.") })`, `AbortSignal`, streams `AsyncIterable` **live-only sin replay**; Promise client **no** ejecuta parsers de esquema localmente (requiere `/effect` si el contrato usa Effect Schema). API HTTP marcada **experimental**; ruta `/api/experimental/generate` deprecada en favor de `/text`. (OC-001, `https://opencode.ai/docs/build/client`, `/api/`, T6 §2, corte 2026-11-23/24)
7. Versión objetivo **v2.4.1** (2026-11-23) según T2; `security` exige mínimo **≥ 2.2.3** (≥ 2.2.6 si se usa `websearch.use`). No ejecuté `opencode --version` en esta iteración: se registra como pendiente de F0 (K-10). (OC-001/OC-002, T2/T7)

## Impacto

- **Positivo**: O1/O2/O3/O5 reducen fricción y aumentan verificabilidad sin instalar nada ni tocar rutas protegidas (L-4) ni secretos (S-1/S-2).
- **Negativo si se aplica O4 como gate**: un upgrade de la API de plugins podría desactivar silenciosamente el hook que "aprueba" un cambio, dejando pasar una modificación sin gate. Eso viola K-11/S-10 ("un escáner que falla bloquea, nunca aprueba"), el veto vinculante de `architect`/`security` y la condición C6/C7 de T7. Riesgo **high** (S-14): bloquea fusión.
- **Negativo si se ignora T7**: sus condiciones C1–C10 son explícitamente obligatorias; si el ADR las omite, el dictamen de seguridad pasa a BLOCK automáticamente. Por eso este dictamen sigue siendo `CHANGES_REQUESTED`.

## Propuesta

Emitir `adr-draft.md` en estado **`proposed — requiere aprobación humana`** con priorización **O1 > O2 > O3 > O5**, incorporando **C1–C10** de `security` como restricciones explícitas, y **vetar O4** como autoridad de gates (solo observador, con pin y test de contrato). Véase el ADR adjunto para coste, riesgo, reversibilidad, criterios L-9, fases y contraejemplos.

**Objeción principal del retador (BLOCK sobre O4):** la API de plugins es un breaking change documentado y los plugins se autocargan desde `.opencode/plugins/`; anclar la aplicación de gates a un hook introduce un único punto de fallo silencioso. Además, el hook `prompt` altera texto persistido y no es exactamente-una-vez (T2 §5.6), y `latest` es supply chain no revisada (S-9). La verdad del gate permanece en `scripts/kaizen check` (código versionado) y en `policies` de autoridad alta; el plugin, si existiera, solo **informa**. Exijo además: versión ≥ 2.2.3 verificada, `plugin.use`/`skill.use`/`mcp.use` deny-by-default, y T3 entregado antes de cualquier adopción.

## Pregunta

¿Confirma El Presidente que **F0** (verificar `opencode --version` ≥ 2.2.3, registrar el resultado, cerrar T3 y mantener `verify` en verde) es puerta obligatoria antes de **F1**, y que la postura deny-by-default de plugins/skills/MCP queda como restricción del ADR? Recomiendo sí: convierte este `CHANGES_REQUESTED` en revisable sin romper REG-EV-01 ni el veto de `security`.

---

## Memorial (DECISIONES.md)

| Campo | Contenido |
| --- | --- |
| **Decisión** | Proponer ADR con O1 > O2 > O3 > O5, condicionado a C1–C10 y a F0; **vetar O4 como gate**. |
| **Disidentes** | `architect` (yo, retador obligatorio): **BLOCK** sobre O4. `security` (T7): **CHANGES_REQUESTED**, veto activo hasta C1–C10. `researcher` (T3): **ausente**, voto no computado. `innovation` descarta plugins por supply chain. `qa` sin dictamen. |
| **Evidencia** | 6 páginas oficiales V2 consultadas (corte 2026-11-23/24) + 6 reviews leídas; `SOURCES.md:40-41` `verified`; ack `H-OC-...-4` rc=0; T2 fija v2.4.1; T7 formula C1–C10. |
| **Incertidumbre** | T3 sin entregar; `verify` es estructural (`decisions/` vacío); versión instalada no ejecutada aquí; semántica de `integration.use` cambió en 2.2.3; API HTTP experimental; streams sin replay; `experimental.subagent_depth` inestable; `/reload` no documentado (dx lo reporta como incertidumbre). |
| **Dueño humano** | **El Presidente** (OWNER.md): aprueba el ADR, gobernanza/autonomía (L-3/L-4, ADR-0002/0003), versión mínima y activación de O2. Yo **no** apruebo, instalo ni despliego. |
| **Revisión** | Tras F3 con métrica antes/después (L-9); revalidación trimestral de fuentes (REG-EV-05); si el KPI no mejora, `regression-suspect` + revert (L-9). |

**Regla de voz aplicada**: Observación → Evidencia → Impacto → Propuesta → Pregunta. Sin secretos, sin datos explotables, sin afirmaciones V2 sin cita oficial.
