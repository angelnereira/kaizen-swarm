decision_id: DEC-001
topic: integracion-opencode-v2
source_ids: ["OC-001", "OC-002"]
retrieved: 2026-11-24
status: verified
approval: human_approved_2026-11-24
human_owner: architect
---

## Aprobación humana (2026-11-24)
El Presidente indicó «avanza», aprobando la secuencia O1 → O5 → O2 → O3, el veto a O4 y ADR-0032. Los conflictos REG-EV-04 C1/C2 quedan aceptados como `unknown` y escalados; no se promedian ni se decide por el agente. La verificación L-9 del KPI sigue pendiente y es puerta separada.

# Decisión: integración con OpenCode V2

## Evidencia
- Fuentes verificadas: OC-001 (documentación oficial V2 `https://opencode.ai/docs/`, índice `llms.txt`) y OC-002 (repositorio oficial `https://github.com/anomalyco/opencode`, MIT), `verified` en `SOURCES.md:40-41`, fecha de corte 2026-11-23/24. `kaizen-team verify` → RC 0.
- 10 reviews de la escuadra en `reviews/`: verificador APPROVE, deep-researcher APPROVE (25 URLs oficiales, v2.4.1 documentada), researcher CHANGES_REQUESTED (conflictos doc/repo), architect CHANGES_REQUESTED con veto `architecture` a plugins como gate, security CHANGES_REQUESTED con C1–C10, dx APPROVE acotado, dev2-api APPROVE de diseño, innovation proposal, knowledge-curator CHANGES_REQUESTED, facilitador coordinación.
- Versión instalada en este entorno: `opencode --version` → **v2.3.2** (cumple el mínimo ≥2.2.3 exigido por seguridad; la documentación del repo describe v2.4.1, sin que esto autorice actualizar).
- Reload: recarga automática de configuración/comandos **verificada** en docs oficiales; `/reload` y `location.reload` quedan `unknown` (skill interna no es fuente oficial). No se recomienda `/reload`.
- Sin secretos, sin instalaciones, sin gasto, sin ejecución de comandos procedentes de documentación externa (S-15/L-5).

## Opciones y decisión propuesta
- **O1 — Gobernanza declarativa V2** (`opencode.jsonc` con `policies` deny-by-default, `permissions` de apoyo y baseline por subagente). Coste bajo, riesgo medio (default `*/*/allow`, precedencia invertida, fail-open de `integration.use` en 2.2.3), reversibilidad muy alta. Criterio L-9: 100 % de `git push` y ediciones L-4 denegados en prueba sintética; 0 warnings descartados. **Recomendada como F0/F1.**
- **O2 — MCP local para herramientas Kaizen** (`mcp.servers`, `disabled: true`, `{env:NAME}`, `mcp.use deny`). Coste medio, riesgo medio-alto (prompt injection vía *server instructions*, `sessionID` no es autenticación, timeout 12 h), reversibilidad alta. Criterio: 0 secretos en config, 100 % de llamadas auditadas. Diferir a F2 tras C1–C10.
- **O3 — Cliente tipado `@opencode/client` + `Service.ensure`** con pin `2.` y streams con resync. Coste medio-alto, API HTTP experimental (178 operaciones, rutas `/api/experimental/*`), streams sin replay, reversibilidad media. Criterio: p95/tasa de error antes→después, 0 llamadas V1. Diferir a F3.
- **O5 — Recursión controlada y skills declarativas** (`subagent`/`steps`, `autoinvoke:false`), coste 0, sin duplicar gobernanza (K-1). Complementaria, F1.
- **O4 — Plugins/hooks como mecanismo de gates: VETADA (`architecture`)**. La API de plugins es un breaking change V1→V2, se autocargan desde `.opencode/plugins/`, la documentación publica `@latest` (S-9) y el hook `prompt` no garantiza exactamente-una-vez. Los plugins solo observarían; la verdad del gate sigue en `scripts/kaizen check` y `policies`. Security e innovación coinciden.

**Decisión registrada:** adoptar la secuencia **O1 → O5 → O2 → O3**, con O4 rechazada, condicionada a C1–C10 y a la resolución humana de los conflictos. Estatus `pending_human`; no se ha cambiado gobernanza, autonomía ni configuración operativa de OpenCode. ADR propuesto en `adr-draft.md` del proyecto (no escrito en `docs/kaizen/adr/`).

## Condiciones duras (C1–C10 de seguridad)
Fuentes con `verify` verde; versión ≥2.2.3 (confirmada v2.3.2); perfil `policies` con denies duros; `external_directory` explícita y subagentes revisados; OAuth + `{env:NAME}` + versiones fijadas (nunca `@latest`); `mcp.use`/`skill.use`/`plugin.use` deny-by-default; sin instalaciones; sin logs ni snapshots versionados; código generado solo tras revisión en entorno aislado; sin push, gasto ni rutas protegidas. Pasa a BLOCK automático si se instala sin aprobación fresca, aparece un secreto, se depende de cliente <2.2.3, se usa server mode sin password o se automatizan reportes al upstream.

## Conflictos REG-EV-04 (no promediados, escalados)
1. **C1 MCP:** el release v2.4.0 indica que sin `protocol` se prueba el más nuevo primero; la doc `/docs/mcp-servers/` describe default `legacy` con `auto` explícito. Marcar `unknown`, no elegir default hasta confirmación.
2. **C2 agentes:** el README lista 3 built-ins (build/plan/general); la doc lista 4 e incluye `explore`, con `plan` pudiendo escribir archivos de plan. Marcar `unknown`; usar `explore` solo tras verificación.
3. Deriva menor: 23.246 vs 23.247 commits, Desktop "BETA" en README vs doc sin etiqueta, GitHub marca v1.19.6 como "Latest" pese a v2.4.1 → verificar semántica de canal antes de fijar versión.

## Incertidumbre y escalado
- `unknown`: `/reload` y `location.reload`; default de protocolo MCP; lista exacta de agentes built-in; semántica del canal "Latest"; estabilidad de rutas `/api/experimental/*`; coste real de ACP/snapshots/compaction.
- Disidentes: retador vetó O4 y cuestionó la seguridad de O2/O3; security mantuvo `CHANGES_REQUESTED` hasta C1–C10; researcher pidió escalar C1/C2; knowledge-curator marcó la guía con esos mismos `unknown`.
- Decisión requerida de El Presidente: aprobar/rechazar la secuencia propuesta; autorizar F0 (verificar versión y deny-by-default) antes de cualquier cambio; confirmar que no se actualizará ni instalará nada sin aprobación; fijar plazo (propuesto 2026-12-01).

## Verificación L-9
Antes: 0 fuentes OC en el ledger, 0 reviews, 0 ADR, gobernanza OpenCode sin declarar. Después esperado: OC-001/OC-002 verificadas, 10 reviews, ADR propuesto con O1–O5 y C1–C10, guía en `.kaizen/org/knowledge/business/OPENCODE-INTEGRACION.md`, y 0 cambios operativos sin humano. Si el KPI no mejora o aparece un BLOCK, volver a `review` y abrir `needs-human` (L-9/FLUJOS).

## Evidencia Android añadida (2026-11-24)
Depuración inalámbrica autorizada sobre Pixel 8 Pro (`ai.opencode.mobilecode`, PID 6463). Logs saneados: 113 eventos `stream_delta_batch`, envíos `steer` admitidos en 648/329 ms, `session_activity_failed NotificationsDisabled` (2) y un timeout de 25.01 s en `POST /api/experimental/session/.../wait`. Refuerza el riesgo de O3 (rutas experimentales) y añade una dependencia operativa de notificaciones del sistema. No cambia la decisión propuesta; añade dos controles: no usar `/api/experimental/*` como contrato y verificar notificaciones antes de probar voz/inbox.

## Nota de alcance (2026-11-24)
El Presidente ordenó además que el medio saliente sea OpenCode en lugar de WhatsApp. Se implementó el adaptador verificable `scripts/notify-opencode` y se abrió ADR-0032; el cableado en `scripts/kaizen*` queda como `needs-human` por L-4. Esto complementa —no sustituye— la decisión O1→O5→O2→O3 de este memorial.
