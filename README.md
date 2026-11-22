# kaizen-swarm

Hogar operativo de una **organización de 42 agentes** (17 roles técnicos + gerencia, analista oficial de negocios, marketing, finanzas panameñas, **cumplimiento normativo**, **capacidades tecnológicas/financieras/mercadeo**, operaciones y conocimiento) que trabajan por issue con aislamiento en git worktrees, buzón trazable, proactividad con evidencia y consenso registrado. Los agentes de conocimiento **investigan en internet** normativa y estándares (ISO/NIST/AICPA/PCI) con fuentes oficiales y fecha de corte, y producen guías de implementación detalladas. Cada agente es un archivo **copiable, editable y guardable**, así que puedes especializar uno nuevo sin destruir el original. Además es una **plantilla instalable**: `scripts/bootstrap <repo>` lleva la organización a cualquier proyecto sin sobrescribir lo que ya exista.

## Capas

| Capa | Reglas | CLI |
| --- | --- | --- |
| Gobernanza | `.kaizen/RULES.md` (K-1..K-12) | `scripts/kaizen` |
| Seguridad | `.kaizen/security/SECURITY-RULES.md` (S-1..S-16) | `scripts/kaizen-security` |
| Loop autónomo | `.kaizen/loop/LOOP.md` (L-1..L-15) | `scripts/kaizen-loop` |
| Comunidad | `.kaizen/swarm/ROLES.md`, `PROTOCOL.md` | `scripts/kaizen-swarm` |
| Organización | `.kaizen/org/ORGANIZATION.md`, `AGENT_SCHEMA.md`, `CONSENSUS.md` | `scripts/kaizen-org` |
| Equipo proactivo | `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md` | `scripts/kaizen-team` |

Arranca en **nivel 3** (ADR-0001) con PAUSA retirada. Los workflows programados están condicionados a `vars.KAIZEN_LOOP_ENABLED == '1'`: el responsable añade `KAIZEN_TOKEN` y la clave del modelo antes de activarlos. Ningún agente recibe secretos (S-2).

## Flujo por issue

```
init N → R1 análisis/contratos → R2 implementación (worktrees) → R3 revisión → finalize N
```

- Cada rol escribe solo las rutas declaradas en `contracts/ownership.json`.
- Los mensajes van numerados en `mailbox/` con `seq/from/to/type/status`; un `handoff` necesita `ack`.
- `architect` y `security` (y `qa` por tests) pueden `BLOCK`; `finalize` no integra con BLOCK abierto.
- Los leases caducan: `reap` reporta y reasigna, de modo que un agente caído no detiene el issue.
- Buzón híbrido: `mailbox/` ignorado por git; `export.md` saneado se copia al descriptor del PR.

## Uso rápido

```bash
scripts/kaizen-swarm check                      # valida la instalación
KSW_DRY_RUN=1 scripts/kaizen-swarm init 42 --slug mi-cambio
scripts/kaizen-swarm init 42 --slug mi-cambio
scripts/kaizen-swarm run 42 --round 1
scripts/kaizen-swarm status 42
scripts/kaizen-swarm finalize 42 --publish      # push + PR (lo hace el orquestador)
```

Organización de agentes:

```bash
scripts/kaizen-org list                          # inventario de 42 puestos
scripts/kaizen-org research cumplimiento-panama "versión vigente de la Ley 81" --url https://www.antai.gob.pa/
scripts/kaizen-org copy marketing marketing-visual --name "Marketing Visual"
scripts/kaizen-org save marketing-visual         # sube versión + diario
scripts/kaizen-org feed marketing-visual docs/kaizen/org/FORECAST.md
scripts/kaizen-org digest marketing-visual
scripts/kaizen-org pulse                         # propuestas proactivas
scripts/kaizen-org decide "reducir tiempo de feedback" --owner gerente
```

Instalación en otro repo:

```bash
scripts/bootstrap /ruta/al/otro/repo
```

Especialistas y outsourcing: 10 agentes por tecnología (GCP, RAG, .NET bancario, plataforma, Rust/WASI, fiscal DGI/HKA, Flutter M3E, perfiles de negocio, identidad y verticales) según `CAPACIDADES-REFERENCIA.md`. Si una tecnología queda fuera del equipo, `scripts/kaizen-org outsource <slug> --tech … --deliverable … --acceptance …` abre un contrato; `outsource-accept` solo cierra con `evidence.md` verificable (`.kaizen/org/OUTSOURCING.md`, ADR-0004).

Equipo proactivo: `scripts/kaizen-team init <slug> --goal "..." --kpi "..."`, luego `standup`, `assign`, `handoff`, `ack`, `sync`, `decide --sources PA-001,ISO-001`, `verify`, `advance`, `retro`. Los proyectos avanzan por estados con puertas y ninguna decisión se da por tomada sin fuentes verificadas en `SOURCES.md` (Gaceta Oficial incluida).

Bases de conocimiento especializado: `.kaizen/org/knowledge/` (mapa normativo panameño, contextos de negocio/tecnología, reglas REG-01..15, rutas de Gaceta Oficial, checklist, estándares internacionales, guía de implementación ISO, capacidades de negocio y `SOURCES.md`). El protocolo de investigación es `.kaizen/org/RESEARCH.md`.

Verificación completa: `bash tests/run.sh`, `scripts/kaizen check` y `scripts/kaizen-org check`. El alcance realista de los modelos actuales y la previsión de evolución están en `docs/kaizen/org/FORECAST.md`. Los vetos de cumplimiento se regularon en `docs/kaizen/adr/0002-veto-de-cumplimiento-e-investigacion-normativa.md`.

## Arranque en un comando y WhatsApp

```bash
./scripts/kaizen-start start      # instala 44 agentes, runtime persistente y buzón
kaizen-start status               # estado
kaizen-start stop                 # pausa total
```

Los reportes llegan a El Presidente (`.kaizen/team/OWNER.md`) por webhook n8n → WhatsApp, correo o archivo; las instrucciones de WhatsApp vuelven por `kaizen-inbox` y `kaizen-equipo` las convierte en trabajo verificable. Sin credenciales en el repo: `docs/kaizen/org/RUNTIME.md`.

## Primer objetivo (piloto recomendado, 7 días)

**Auditoría exprés de cumplimiento fiscal y de datos en PlentyPay.**

- Equipo: `cumplimiento` + `plataforma`, coordinado por `kaizen-equipo`.
- Entregable: mapa de obligaciones DGI/Ley 81 con `source_ids` verificados, checklist accionable, 3 hallazgos con evidencia y un ADR de decisión.
- KPI: **0 normas sin fuente verificada** y primer reporte en menos de 24 h.
- Arranque: `kaizen-start start` y, desde WhatsApp, «Audita DGI y datos personales de PlentyPay y envíame el resumen con fuentes».

## Decisiones humanas pendientes

Secret scanning y push protection, Dependabot/CodeQL, reporte privado de vulnerabilidades, protección de rama con los checks Kaizen, CODEOWNERS sobre los rieles, permisos de workflows, token de granularidad fina, 2FA y límite de gasto del proveedor. Ver `.github/SECURITY.md`.

## Límites honestos

Los escáneres tienen falsos negativos; los hooks locales se pueden saltar. La barrera real es CI obligatorio + protección de rama + CODEOWNERS. El agente no es auditor y no tiene tokens. Ver KAIZEN-SECURITY.md §11 en la documentación de origen.
