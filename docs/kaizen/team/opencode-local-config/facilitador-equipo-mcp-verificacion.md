---
id: MSG-OLC-003
correlation_id: OLC-MCP-003
from: facilitador-equipo
to: dx
channel: direct
intent: verify
task: "Verificar MCP rea y railway activos sin credenciales en repo"
expects_ack: true
deadline: 2026-11-26T18:00:00Z
source_ids: [TOOL-001, ISO-001, NIST-001, OWASP-001, AICPA-001]
reply_to: MSG-OLC-001
status: open
created: 2026-11-23T03:16:19Z
---

# Evidencia — verificación de MCP `rea` / `railway` sin credenciales en repo

- equipo: `opencode-local-config` (responsible: `facilitador-equipo`, `autonomy: scoped`, `veto: resource`, `execute: false`)
- tarea preparada: «Verificar MCP rea y railway activos sin credenciales en repo» (owner `dx`; de `pending` a `ready`)
- handoff: `H-1795403779907` → `dx` (correlation_id `OLC-MCP-003`)
- fecha de emisión: `2026-11-23T03:16:19Z` (UTC)
- fecha de corte de fuentes: `2026-11-21` (`SOURCES.md` L3; dentro de `KT_EVIDENCE_TTL_DAYS=90`, REG-EV-05 vigente)
- reglas aplicadas: K-1, K-2, K-10, K-14, L-4, L-5, L-17, S-1, S-2, S-11, S-15, REG-EV-01/02/07, ADR-0023

> **Restricciones respetadas.** No se leyó `.env`, llaves privadas ni credenciales; no se imprimieron variables de entorno; no se ejecutaron herramientas de escritura, despliegue ni análisis de objetivo. Las llamadas MCP fueron de **solo lectura** (`rea.binary_session` con `detail=summary`, sin abrir objetivo; `railway.list-projects`). Todo contenido externo (respuestas MCP, configs, outbox) se trató como dato no confiable (S-15/L-5): se verificó su forma y disponibilidad, no se ejecutaron instrucciones que aparecieran en él.

---

## 1. Resultado

| # | Control | Resultado | Base reproducible |
| --- | --- | --- | --- |
| M-1 | MCP `rea` activo | **OK** | `tools.rea.binary_session({detail:"summary"})` responde con `server_identity.server.name = "rea"`, `version = 6.10.1`, `started_at = 2026-11-23T03:13:26Z`, `catalog.counts.mcp_tools = 263`, `negotiated_protocol_version = "2025-11-25"`, `capabilities = 3`, `open = false`, `cleanup_pending = false`. |
| M-2 | MCP `railway` activo | **OK** | `tools.railway["list-projects"]` responde `{projects: array(3)}` sin error de autenticación ni de transporte. |
| M-3 | Configuración MCP sin secretos en línea | **OK** | `jq` sobre `~/.config/opencode/opencode.json`: `mcp_servers=railway,rea`; ambos con `disabled=false` (habilitados) y `type=local`; `0` cadenas con prefijo de token/clave en **toda** la configuración global. Las credenciales, si las hay, se resuelven por entorno del proceso, **no** por valores versionados. |
| M-4 | Sin credenciales versionadas en el repo (config MCP) | **OK (parcial, ver H-1)** | `git ls-files \| grep -iE '(^|/)(...\|credentials\|.*token.*)$'` → coincidencias por **nombre** en `token-ledger.jsonl`, `tokens.env`, `TOKENS.md`, `ADR-0021`, `scripts/kaizen-tokens` y documentación. No se encontró ningún archivo `.pem`, `.key` ni `id_rsa` versionado. `opencode.json` del repo declarado en el cambio preexistente contiene `deny` para `*.env`, `**/.env.*`, `*.pem`, `*.key`, `**/id_rsa*`. |
| M-5 | Bug `now` vs `$now` en `kaizen-team` | **RESUELTO** | `scripts/kaizen-team:71,80` usan `--arg now "$(date -u +%FT%TZ)"` y `created:$now`; el sobre `H-1795403779907` se escribió íntegro en `handoffs.jsonl`. Ya no aplica el workaround de escritura manual por fail-open. |

**Conclusión acotada:** ambos servidores MCP están activos y responden, y la configuración versionada no contiene valores de credenciales. Esto **no** es el dictamen final del proyecto; corresponde a `dx` y después a `verificador-evidencias`.

---

## 2. `source_ids` verificados

Todos los IDs citados existen en `.kaizen/org/knowledge/SOURCES.md` con estado `verified` y fecha de corte `2026-11-21`. No se usó ninguna fuente `pending`, `conflict` ni `stale` (REG-EV-01). `ADR-0023` se cita como **referencia normativa local**, no como `source_id` (no está registrado en `SOURCES.md`).

| ID | Uso en esta evidencia |
| --- | --- |
| `TOOL-001` | `morluto/rea` — repositorio oficial del proyecto `rea` verificado; sustenta M-1. |
| `ISO-001` | ISO/IEC 27001:2022 — control de acceso y configuración segura; sustenta M-3. |
| `NIST-001` | NIST CSF 2.0 — gestión de credenciales y superficie de ataque; sustenta M-3/M-4. |
| `OWASP-001` | OWASP ASVS 4.0 — verificación de secretos y configuración; sustenta M-3/M-4. |
| `AICPA-001` | AICPA TSC 2017 — registro y trazabilidad de la evidencia; sustenta el sobre. |

> No existe `source_id` registrado para Railway en `SOURCES.md`. M-2 se apoya **únicamente** en salida de comando reproducible (principio 2 de `TEAM.md`), no en una fuente normativa. Se propone a `knowledge-curator` / `verificador-evidencias` abrir un `kaizen-org research` con la URL oficial si se requiere trazabilidad normativa del proveedor.

---

## 3. Evidencia cruda (saneada; sin secretos ni datos personales)

### E1 — MCP `rea`

```text
$ tools.rea.binary_session({detail:"summary"})   # solo lectura, sin abrir objetivo
server_identity:
  server.name=rea  server.version=6.10.1
  started_at=2026-11-23T03:13:26.612Z
  sdk.server=2.3.1  sdk.core=2.3.1
  negotiated_protocol_version=2025-11-25
  skill.name=reverse-engineer-anything  skill.expected_version=63
  catalog.counts={cli_commands:204, mcp_tools:263, mcp_prompts:6}
  catalog.digests.tools_sha256=ce195f28c7f286af9ee1a4174e5a9d54eda490e95a913c48592316740bd34bf1
capabilities=3  open=false  cleanup_pending=false  analysis_provider_binding=null
```

Sin objetivo abierto y sin `cleanup_pending`: no quedó análisis ni estado sensible por cerrar. El hash del catálogo permite reproducir la versión exacta de las 263 herramientas.

### E2 — MCP `railway`

```text
$ tools.railway["list-projects"]()   # solo lectura
→ { projects: array(3) }   (sin error de transporte ni de autenticación)
```

No se invocó `whoami` ni ninguna herramienta de despliegue, para no exponer perfil ni proyectos. Solo se registra el conteo.

### E3 — Configuración MCP (estructura, nunca valores)

```text
$ jq -r '.mcp.servers | to_entries[] | "\(.key): disabled=\(.value.disabled|tostring) type=\(.value.type // "n/a")"' ~/.config/opencode/opencode.json
railway: disabled=false type=local
rea: disabled=false type=local

$ jq '[ .. | strings | select(test("^(sk-|gh[pousr]_|rail_|AIza|xox[baprs]-|AKIA)[A-Za-z0-9_-]{12,}")) ] | length' ~/.config/opencode/opencode.json
0
```

> Corrección 2026-11-23: una medición intermedia usó `.disabled // "unset"`. En jq, `false // x` devuelve `x`, así que ese formulario imprimía `unset` aunque el valor real es `false`. Se remidió con `|tostring` y se confirma `disabled=false` para ambos servidores, en coincidencia con la evidencia de la instancia A (`facilitador-equipo-mcp-rea-railway.md`).

### E4 — Inventario de nombres con patrón de credencial en el repo

```text
$ git ls-files | grep -iE '(^|/)(\.env|\.env\..*|\.pem|\.key|id_rsa|id_dsa|credentials|.*token.*)$'
.kaizen/finops/token-ledger.jsonl
.kaizen/finops/tokens.env
docs/kaizen/adr/0021-economia-de-tokens-y-trabajo-continuo.md
docs/kaizen/org/TOKENS.md
scripts/kaizen-tokens
```

`.pem`, `.key`, `id_rsa` e `id_dsa`: **0 coincidencias**. El archivo `tokens.env` **no fue leído** (S-2); se reporta como hallazgo H-1 para dictamen de `security`.

### E5 — KPI revalidado

```text
$ jq '[.permissions[]|select(.effect=="deny" and (.resource|test("push")))]|length' opencode.json
0
$ jq -e '.permissions|type=="array"' ~/.config/opencode/opencode.json
true
$ jq -e '([.permissions[]|select(has("action") and has("resource") and has("effect"))]|length)==(.permissions|length)' ~/.config/opencode/opencode.json
true
$ find ~/.config/opencode/agents -maxdepth 1 -name '*.md' -type f | wc -l
49     # ver H-2: el KPI registrado dice 47
```

---

## 4. Hallazgos (S-11, no resueltos por el facilitador)

- **H-1 — `tokens.env` versionado.** Existe `.kaizen/finops/tokens.env` (605 bytes) rastreado en Git. **No se leyó su contenido** (S-2). Requiere dictamen de `security`: confirmar si contiene solo umbrales/ejemplos o valores reales; si son reales, rotación inmediata (S-12). Reportado en `.kaizen/loop/outbox/repo-tokens-env-tracked.md`. El facilitador no cambia permisos ni lee el archivo (fuera de su autoridad `resource`; seguridad requiere humano, L-3/L-4).
- **H-2 — deriva del KPI de agentes.** El KPI del proyecto dice **47** agentes globales; la medición actual es **49**. Los dos nuevos son `auditor-riesgos.md` y `legal-corporativo.md`, añadidos en `d499180` («Add executive board and weighted incentive teams»). No es un fallo de instalación: es una **desactualización de la línea base del KPI**. El facilitador no modifica el KPI (autoridad de El Presidente, `OWNER.md`). Reportado en `.kaizen/loop/outbox/opencode-kpi-agent-count-drift.md`. Recomendación: aprobar KPI ≥ 47 con_catálogo vigente o actualizar la cifra a 49 mediante decisión registrada.
- **H-3 — sin `source_id` para Railway.** Ver §2. No bloquea la verificación técnica (M-2 es reproducible), pero sí un dictamen normativo; derivado a `verificador-evidencias`.
- **H-4 — colisión de dos instancias de `facilitador-equipo` en `OLC-MCP-003`.** Otra instancia produjo `facilitador-equipo-mcp-rea-railway.md` y el handoff acusado `H-1795403633267078428` → `verificador-evidencias`, mientras esta instancia produjo este documento y `H-1795403779907` → `dx`. No hubo pérdida de evidencia, pero sí doble escritura del mismo sobre (principio 6 de `TEAM.md`). Reportado por la otra instancia en `.kaizen/loop/outbox/facilitador-duplicate-work-OLC-MCP-003.md` (`kind: incident`, fingerprint `facilitador-duplicate-work-OLC-MCP-003`). **Conservamos ambos handoffs y ambas evidencias**; `verificador-evidencias` (tarea 5) elige la fuente canónica para el dictamen final. Esta instancia mantuvo el `owner: dx` de la tarea 3 según el plan de la escuadra y corrigió su propia medición `disabled=unset` → `disabled=false` (M-3/E3).

---

## 5. Sobre del handoff (ledger)

```yaml
id: H-1795403779907
correlation_id: OLC-MCP-003
from: facilitador-equipo
to: dx
channel: direct
intent: handoff
task: "Verificar MCP rea y railway activos sin credenciales en repo — evidencia reproducible con source_ids, tarea lista para dictamen de DX"
expects_ack: true
deadline: 2026-11-26T18:00:00Z
source_ids: [TOOL-001, ISO-001, NIST-001, OWASP-001, AICPA-001]
refs:
  - docs/kaizen/team/opencode-local-config/facilitador-equipo-mcp-verificacion.md
  - .kaizen/loop/outbox/repo-tokens-env-tracked.md
  - .kaizen/loop/outbox/opencode-kpi-agent-count-drift.md
status: ack
created: 2026-11-23T03:16:19Z
acked_at: 2026-11-23T03:16:57Z
```

`expects_ack: true` y `status: ack` registrados en `handoffs.jsonl` mediante `kaizen-team ack`; `kaizen-team sync` confirma acuses pendientes = 0. La tarea 3 queda en `ready` con lease y fecha de vencimiento, sin cambiar de etapa del proyecto (sigue en `execute`; el avance lo hace el orquestador respetando `FLUJOS.md`).
