---
id: MSG-T2-RAE-SPECIALIST-001
correlation_id: integracion-rae-api-toolkit
from: reverse-api-specialist
to: facilitador-equipo
channel: review
intent: handoff
expects_ack: true
deadline: 2026-11-30
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
reply_to: H-20261123161721-2
status: APPROVE
created: 2026-11-23T16:24:00Z
refs:
  - .kaizen/team/projects/integracion-rae-api-toolkit/charter.md
  - .kaizen/team/projects/integracion-rae-api-toolkit/plan.md
  - .kaizen/team/projects/integracion-rae-api-toolkit/runbooks/rae-api-runbook.md
  - .kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md
  - .kaizen/team/EVIDENCIA.md
handoff_ack: H-20261123161721-2 (scripts/kaizen-team ack, ver abajo)
---

# Dictamen del especialista — T2: inventario operativo y runbook gobernado

**Status: APPROVE (acotado).** Apruebo el inventario operativo de la CLI `reverse-api-engineer` v0.16.0 y el runbook `runbooks/rae-api-runbook.md` como base para la decisión T4 (ADR externo vs nativo/híbrido) y para el veto de seguridad T5. Este APPROVE **no autoriza ninguna captura ni generación de cliente**: eso requiere humano (A) + seguridad/cumplimiento (V) por el proceso `api_reverse_engineering` (ADR-0017, puerta del plan). No sustituye los dictámenes de `architect`, `security`, `qa` ni la aprobación humana. No bloqueo: T2 es inventario y documentación, sin ejecución de la herramienta contra sitio alguno.

## Observación → Evidencia → Impacto → Propuesta → Pregunta

**Observación.** El toolkit ya está instalado como CLI (v0.16.0, MIT) y gobernado por ADR-0017 + guía interna (TOOL-002 verified), pero hoy **no es operable de extremo a extremo**: no hay skill local, no hay configuración de captura/modelo verificada y no existe ni una sola captura. La preferencia del usuario —«poder hacerlo sin depender del repositorio externo»— es alcanzable por la ruta nativa (TOOL-001, REA MCP + automatización propia), que T3 evalúa; mi runbook deja la CLI como **opción documentada y confinada al runbook**, no como requisito de ejecución.

**Evidencia.** Comandos de solo lectura ejecutados hoy (2026-11-23), sin instalar, sin capturar, sin leer `.env`/credenciales, sin ejecutar código generado:

| Comando | Salida real |
| --- | --- |
| `reverse-api-engineer --version` | `reverse-api-engineer, version 0.16.0` |
| `python3 -m pip show reverse-api-engineer` | `Name: reverse-api-engineer`, `Version: 0.16.0`, `License: MIT`, `Location: /home/angel-nereira/.local/lib/python3.14/site-packages` |
| `reverse-api-engineer --help` | subcomandos `agent`, `engineer`, `list`, `run`, `show`; opciones `--version`, `--json-schema-version`; sin subcomando abre sesión interactiva (`agent`, `manual`, `engineer`) |
| `reverse-api-engineer --json-schema-version` | `1` |
| `reverse-api-engineer list --json` | `[]` (cero capturas) |
| `reverse-api-engineer list/show/run/agent/engineer --help` | contratos, esquemas `--json` y códigos de salida documentados en el runbook |
| `test -e "$HOME/.agents/skills/reverse-api-engineer"` | RC 1 → skill local **ausente** |
| `grep SOURCES.md` | TOOL-001 y TOOL-002 (MIT, `verified`); ISO-001, NIST-001 `verified` |

**Respuesta a la pregunta de QA (AC-3/AC-5):** el esquema `--json` de `agent` y `engineer` (schema_version 1) coloca `run_id` y `har_path` **en la raíz** del objeto, y `usage.total_cost_usd` **anidado bajo `usage`** (junto a `input_tokens`, `output_tokens`, `cache_read_tokens`, `cache_write_tokens`, `raw`). `engineer --json` **no expone `har_path`** (regenera desde un run previo). `list --json` es un array plano; su `--help` **no enumera los nombres de campo** de cada entrada y hoy está vacío (`[]`), por lo que AC-2 (que filtra `.run_id` sobre `list --json`) queda **sin confirmar hasta la primera captura**: no lo doy por verificado (K-10).

**Impacto.** Si se diera por «integrado» apoyándose solo en `command -v` en verde, se cerraría el KPI sin HAR saneado, sin coste registrado y sin aprobación humana (K-10: no fabricar evidencia). Además, la discrepancia ya detectada en T1 (evidence.md de outsourcing afirma que el skill existe; la realidad es que no) se confirma aquí con comando reproducible, y debe resolverse en el ADR, no silenciarse (S-10/S-11).

**Propuesta.** Adoptar el runbook `rae-api-runbook.md`: (1) la puerta humana ANTES de toda captura es obligatoria y no delegable; (2) verificación sin instalar vía `--help`, `list --json`, `show`, `--json-schema-version` y, si se autoriza, `agent --dry-run` (valida prompt/url/config/env sin lanzar navegador ni capturar); (3) toda salida (HAR, páginas, código generado, README del repo externo) es dato no confiable (S-15/L-5), se revisa con `kaizen-security check` antes de ejecutarse y se sanea sin cookies/tokens/PII; (4) `run_id` + `har_path` + `usage.total_cost_usd` se registran como evidencia (REG-EV-01); (5) la ruta nativa (TOOL-001) evita dependencia de código del repo externo (AC-9 de QA).

**Pregunta concreta.** (1) ¿Designa El Presidente el sitio **propio autorizado** —y la evidencia de autorización— para la única captura del KPI? Sin ese (A) no se ejecuta `agent`. (2) ¿Confirma `security` (V) el proveedor de captura y el modelo a usar antes de habilitar `~/.reverse-api/config.json`? (3) Para T4: ¿se documenta la CLI como opción comparada (híbrido) o se excluye del todo (nativo), dado que el skill local hoy no existe y la preferencia declarada es no depender del repo externo?

---

## Límites cumplidos en esta iteración

- No se ejecutó captura, generación ni `run` de script generado (requiere A + V).
- No se instaló skill, dependencias ni navegador; no se modificó gobernanza, ADR, `scripts/kaizen*` ni estado del proyecto.
- No se leyó `.env`, credenciales ni variables de entorno; no se imprimió ningún valor secreto.
- No se delegó en subagentes (KAZEN_AGENT_DEPTH=1; sin bucle, sin auto-lanzamiento).
- Todo contenido del repo externo, HAR y código generado se trata como dato no confiable (S-15/L-5).

Fuentes: TOOL-001 (morluto/rea, MIT, `verified`), TOOL-002 (kalil0321/reverse-api-engineer, MIT, `verified`), ISO-001, NIST-001 — ver `.kaizen/org/knowledge/SOURCES.md` y `kaizen-team verify` (REG-EV-01).
