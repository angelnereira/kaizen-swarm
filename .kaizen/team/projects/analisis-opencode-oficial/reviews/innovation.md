---
status: proposal
source_ids: [OC-001]
agent: innovation
task: T8
handoff: H-OC-20261124020855-8
correlation_id: analisis-opencode-oficial
cutoff: 2026-11-23/24
gate: verify-green
created: 2026-11-24T02:20:00Z
---

# Dictamen — innovation (T8): capacidades nuevas de OpenCode V2

> Alcance: solo documentación oficial `opencode.ai/docs` (OC-001, índice machine-readable `https://opencode.ai/docs/llms.txt`). No se ejecutó ningún comando de la documentación, no se instaló nada, no se gastó, no se hicieron cambios de estado ni push (S-15/L-5).
> Convención K-10: **[H]** = hecho documentado en la URL citada; **[I]** = hipótesis/valor estimado por este agente, no afirmación de la fuente.
> Nota de evidencia **[H]**: OC-001 aparece en `.kaizen/org/knowledge/SOURCES.md` (fila 40, `status: verified`) y `scripts/kaizen-team verify analisis-opencode-oficial` devuelve «todas las decisiones tienen fuentes verificadas» (ejecutado 2026-11-24). El handoff declara `source_ids: [OC-001, OC-002]`. Innovation no tiene autoridad de veto: emite `proposal` + `finding`.

## Observación

**[H]** La documentación V2 ofrece 11 capacidades relevantes para una comunidad de 45+ agentes; ninguna página examinada las etiqueta como `beta`, salvo dos RFDs de ACP en estado **Preview** (session compaction) y **draft** (end-turn token usage), y la guiña de escritorio `./gui-experimental` en plugins. **[H]** Varias capacidades traen advertencias explícitas: `request` de agente "preserves these values but does not yet send them"; snapshots son "best effort" y "a convenience, not a transaction or backup"; compaction es "lossy"; warming son "real provider requests" con coste; plugins pueden auto-actualizarse con `@latest`. **[I]** El valor para kaizen-swarm no está en adoptarlas todas, sino en las que ya tienen un hueco gobernado: recursión controlada, skills declarativos, handoffs/rollback y observabilidad de coste.

## Evidencia

Fuentes verificadas en esta iteración (fetched, fecha de corte 2026-11-23/24):

| # | Página oficial | Uso |
| --- | --- | --- |
| 1 | https://opencode.ai/docs/llms.txt | índice canónico V2 |
| 2 | https://opencode.ai/docs/agents/ | T8-1 |
| 3 | https://opencode.ai/docs/skills/ | T8-2 |
| 4 | https://opencode.ai/docs/commands/ | contexto (no priorizada) |
| 5 | https://opencode.ai/docs/snapshots/ | T8-3 |
| 6 | https://opencode.ai/docs/compaction/ | T8-4 |
| 7 | https://opencode.ai/docs/warming/ | descartada (coste) |
| 8 | https://opencode.ai/docs/cli/acp/ | T8-5 |
| 9 | https://opencode.ai/docs/console/harnesses/ | descartada (dinero) |
| 10 | https://opencode.ai/docs/cli/web/ | descartada (seguridad) |
| 11 | https://opencode.ai/docs/plugins/ | descartada (supply chain) |

### Priorización (máximo 5)

| Capacidad | Qué es (fuente) | Madurez declarada **[H]** | Valor hipotético **[I]** | Coste aprox. **[I]/[H]** | Riesgo dependencia S-9 | Humano |
| --- | --- | --- | --- | --- | --- | --- |
| 1. Agents + permisos | Perfiles Markdown/JSONC con `mode: primary|subagent|all`, reglas `allow/ask/deny` por acción (incl. `subagent`, `skill`, `shell`), `steps`, `hidden`, `disabled` — `/agents/` | Sin etiqueta beta; V1 frontmatter **deprecated**; **`request` no se envía aún en V2** (warning textual) | Implementar `KAZEN_AGENT_DEPTH` y `KR_MAX_DEPTH` como regla nativa `subagent` por ID; `steps` como tope por iteración L-1; `hidden` para agentes de mantenimiento | 0 USD; coste de conversión de definiciones | **Bajo**: nativo, sin paquetes nuevos. Riesgo: cambiar autonomía copiando definición no la aumenta (L-16) | No para proponer; **sí** para cambio de autonomía/gobernanza (ADR, L-3/L-4) |
| 2. Skills + catálogos | `SKILL.md` con `description`, `metadata.opencode/autoinvoke: false`, descubrimiento en `~/.config/opencode/skills`, `.opencode/skills`, catálogos HTTP con `index.json` versionado — `/skills/` | Sin etiqueta beta; "V2 **currently does not enforce**" el patrón de ID 1–64 chars; IDs por ruta, no por `name` | Alinear las skills de la comunidad al formato nativo; `autoinvoke:false` + permiso `skill: ask` para skills experimentales → proactividad con frenos (L-16/S-15) | 0 USD; variables de configuración ya existentes | **Bajo-medio**: catálogo HTTP es contenido externo no confiable (S-15); skills sin `description` no se anuncian | No para proponer; **sí** para instalar skills/catálogos de terceros (S-15) |
| 3. ACP (`opencode acp`) | Agente Agent Client Protocol v1 sobre JSON-RPC stdin/stdout; capacidades `loadSession`, `mcpCapabilities.http`, `session/list|load|resume|fork`, `usage_update` con `cost.amount` USD, child sessions con `_meta.depth` — `/cli/acp/` | Protocolo v1 declarado; **RFDs en Preview/draft**: session compaction "in Preview", end-turn token usage "draft"; `mcpCapabilities.sse: false`, "doesn't support MCP over ACP" | `depth` de child sessions ←→ `KAZEN_AGENT_DEPTH`; `usage_update.cost` ←→ `kaizen-tokens`; `session/fork` para ramas de decisión sin tocar git | 0 API nueva; mismo proveedor + sobrecarga de protocolo **[H]** sin cifras | **Medio**: protocolo con RFDs no estables y sin SSE; acoplamiento a cliente externo | **Sí** para integrar cliente externo (gobernanza/herramientas, ADR) |
| 4. Compaction | Resume la conversación al acercarse al límite; `keep.tokens` (15k), `background: true`, `agents.compaction.model`, native (OpenAI Responses) vs summary — `/compaction/` | Estable con matices **[H]**: "compaction is **lossy**"; native "support varies by deployment and model"; checkpoint cifrado no portable entre modelos | Sesiones largas del swarm con 45 perfiles; summary estructurado (Objective/Next Move) ≈ handoffs/journal; `agents.compaction.model` para modelo económico | **[H]** requests reales: "a summary that is never used ... still costs tokens"; monto depende del modelo, **no se inventa cifra** | **Medio**: pérdida de detalle afecta K-10; native liga a proveedor/modelo | **Sí** si cambia modelo de resumen con coste (finops) |
| 5. Snapshots | `/undo`/`/redo`: rollback de conversación + archivos en BD Git interna; cobertura por paso del modelo, `snapshots: false` — `/snapshots/` | **[H]** "enabled by default", captura "best effort", "convenience, not a transaction or backup"; ignora ignorados y >2 MiB; no revierte efectos de shell | Complemento de L-7 (reversibilidad) y L-9 (rollback) para iteraciones del loop; **no sustituye** git ni el runbook | 0 USD; almacenamiento local de objetos Git **[H]** "treat the OpenCode data directory as sensitive local data" | **Bajo-medio**: sobreescribe cambios actuales del path restaurado; datos sensibles en caché local | No para uso; **sí** si se decide política de retención de datos (L-12) |

**Criterio de verificación L-9 propuesto (por capacidad):** (1) 0 violaciones de profundidad en logs tras aplicar permisos `subagent`; (2) % de skills con `description` y permiso explícito (meta: 100%); (3) % de eventos de child session con `depth` y `usage.cost` presentes; (4) nº de sesiones abiertas por "context too long"; (5) tiempo medio de rollback en iteraciones L-7.

### Descartadas (finding, con razón documentada)

| Capacidad | Hecho de la fuente | Motivo de descarte |
| --- | --- | --- |
| Warming `/warming/` | "disabled by default"; hasta **7 peticiones** en ventana de 30 min; "real provider requests ... incur costs" | Gasto continuo sin KPI demostrado; requiere humano (L-3) |
| Console harnesses `/console/harnesses/` | API key de Console (la doc muestra solo un prefijo de ejemplo; ningún valor real aquí), "usage is billed to your workspace"; modelos free-tier devuelven HTTP 403 fuera de OpenCode | Dinero + credenciales: humano siempre (ADR-0002/0003, S-1/S-2) |
| Web `/cli/web/` | `opencode pair --remote` "expose your OpenCode server to the internet"; requiere `--yes` sin terminal | Superficie de exposición; humano y security (S-16) |
| Plugins `/plugins/` | `name@latest` se auto-actualiza; solo dos plugins integrales ignoran eliminación (policy) | Supply chain (S-9): fijar versiones exactas y aprobación humana antes de instalar |
| Commands `/commands/` | bloques `!` ejecutan shell "outside the agent's tool permission flow" | Útil pero solapado con T5 (dx); se traslada como insumo, no se prioriza aquí |

## Impacto

**[I]** Las cinco priorizadas son **aditivas y reversibles**: no exigen cambiar gobernanza ni autonomía para evaluarlas. **[I]** El mayor impacto esperado es reducir la distancia entre el contrato de la comunidad (recursión controlada, acuses, evidencia, coste local) y los primitivos nativos V2, sin introducir dependencias de paquetes. **[H]** El riesgo transversal es la dependencia de protocolos/capacidades declaradas como preview, lossy o no enviadas aún; por eso ninguna se propone como ADR de adopción total, sino como piloto acotado con métrica L-9. **[H]** Puerta de evidencia cerrada en verde: OC-001 `verified` y `kaizen-team verify` OK (REG-EV-01).

## Propuesta

1. **Piloto 1 (coste 0, humano no): Agents + Skills.** Mapear `KAZEN_AGENT_DEPTH`/`KR_MAX_DEPTH` a reglas `subagent` por ID y `steps`; marcar skills experimentales con `autoinvoke:false` y permiso `ask`. Medir: 0 violaciones de profundidad, 100% de skills con descripción. Revertir: `git checkout` de los archivos de config.
2. **Piloto 2 (humano para coste): Compaction + ACP.** ACP solo en modo local (sin cliente externo) para observar `depth` y `usage.cost`; compaction con `background:false` si hay riesgo de pérdida. Medir: sesiones por "context too long" y cobertura de `usage`. Revertir: no iniciar `opencode acp` / `compaction.auto:false`.
3. **Piloto 3 (opcional): Snapshots** como herramienta de loop, nunca como sustituto de git; revisar política de datos locales antes de habilitarlo en sesiones con secretos (L-12).
4. **No adoptar en este ciclo:** warming, Console harnesses, web remoto, plugins con `@latest` (ver tabla de descartes).
5. **Puerta de decisión:** OC-001 ya está `verified` y `kaizen-team verify` en verde; el retador (arquitecto/security) y El Presidente intervienen si se toca autonomía, dinero o exposición. Este agente solo propone (autonomía `propose`, sin veto).

**Top 3 más prometedoras (para el resumen al gerente):** Agents+permisos → https://opencode.ai/docs/agents/ · Skills+catálogos → https://opencode.ai/docs/skills/ · ACP → https://opencode.ai/docs/cli/acp/

## Pregunta

¿Autoriza El Presidente a que el arquitecto convierta los pilotos 1 y 2 en un ADR propuesto (sin ejecución, sin gasto y sin instalar nada), con OC-001 ya verificada y supeditado a que security revise el uso de `usage_update.cost` y los catálogos HTTP como dato no confiable (S-15)? Plazo sugerido: 2026-12-01, según deadline del handoff.
