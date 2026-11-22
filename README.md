# kaizen-swarm

Hogar operativo de una **organización de 45 agentes** (17 roles técnicos + gerencia, analista oficial de negocios, marketing, finanzas panameñas, **cumplimiento normativo**, **capacidades tecnológicas/financieras/mercadeo**, operaciones y conocimiento) que trabajan por issue con aislamiento en git worktrees, buzón trazable, proactividad con evidencia y consenso registrado. Los agentes de conocimiento **investigan en internet** normativa y estándares (ISO/NIST/AICPA/PCI) con fuentes oficiales y fecha de corte, y producen guías de implementación detalladas. Cada agente es un archivo **copiable, editable y guardable**, así que puedes especializar uno nuevo sin destruir el original. Además es una **plantilla instalable**: `scripts/bootstrap <repo>` lleva la organización a cualquier proyecto sin sobrescribir lo que ya exista.

## Instalación en un paso (para un agente CLI)

**Repositorio:** https://github.com/angelnereira/kaizen-swarm

Abre tu agente CLI en el directorio donde quieres trabajar y pégale **solo** el enlace con una de estas instrucciones:

### OpenCode

```text
Instala la comunidad de este repositorio: https://github.com/angelnereira/kaizen-swarm

1) Clónalo en /tmp/kaizen-swarm (git clone --depth 1).
2) Ejecuta: /tmp/kaizen-swarm/scripts/kaizen-installer all <directorio-destino>
   (instala el framework en el repo destino, los 47 agentes en .opencode/agents y en ~/.config/opencode/agents).
3) Verifica con: /tmp/kaizen-swarm/scripts/kaizen-start status y bash tests/run.sh.
4) Reporta qué archivos creó, qué omitió por existir y qué decisiones humanas quedan pendientes.
No escribas secretos, no modifiques opencode.json sin permiso y no hagas git push.
```

Equivalente si ya tienes el repo clonado: `./scripts/kaizen-installer all .` y luego `./scripts/kaizen-start status`.

### Claude Code

```text
Lee e instala siguiendo las instrucciones de https://github.com/angelnereira/kaizen-swarm

Clona el repo, ejecuta scripts/kaizen-installer all <directorio-destino>, luego scripts/kaizen-start status.
El script es la fuente de verdad: no improvises archivos. Instala los agentes en ~/.config/opencode/agents
sin sobrescribir opencode.json. No pulses credenciales ni hagas push. Reporta el resultado real de los comandos.
```

### Codex CLI

```text
Install the agent community from https://github.com/angelnereira/kaizen-swarm

Run: git clone --depth 1 <url> /tmp/kaizen-swarm && /tmp/kaizen-swarm/scripts/kaizen-installer all <target>
Then verify with /tmp/kaizen-swarm/scripts/kaizen-start status and bash /tmp/kaizen-swarm/tests/run.sh.
Do not add secrets, do not edit opencode.json without approval, do not push. Report created/skipped files.
```

### Humano (sin agente)

```bash
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm /tmp/kaizen-swarm
cd /tmp/kaizen-swarm
./scripts/kaizen-installer all /ruta/a/tu/proyecto
kaizen-start status          # o: ./scripts/kaizen-start status
kaizen-start start           # activa runtime + buzón con un solo comando
```

`all` es idempotente: fusiona sin sobrescribir (`scripts/bootstrap`) y genera los 47 agentes desde las definiciones. No toca tu `opencode.json` ni tus credenciales.

## Capas

| Capa | Reglas | CLI |
| --- | --- | --- |
| Gobernanza | `.kaizen/RULES.md` (K-1..K-14) | `scripts/kaizen` |
| Seguridad | `.kaizen/security/SECURITY-RULES.md` (S-1..S-16) | `scripts/kaizen-security` |
| Loop autónomo | `.kaizen/loop/LOOP.md` (L-1..L-17) | `scripts/kaizen-loop` |
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
scripts/kaizen-org list                          # inventario de 45 puestos
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

Gobernanza semántica: `.kaizen/gov/governance.json` define 9 procesos con RACI + veto + humano, responsabilidades, obligaciones y derechos por agente. Consulta con `scripts/kaizen-gov raci <proceso>|who|can|obligations|report` (ADR-0008, `docs/kaizen/org/GOBIERNO.md`).

Depuración profunda con REA: instalado con aprobación humana (MCP + skill `reverse-engineer-anything`, 263 herramientas, Node v22.23.4 en espacio de usuario). El agente `rea-specialist` analiza binarios, Electron/.NET, Android, firmware y runtime **solo con autorización** del proceso `reverse_engineering` (A: humano, V: seguridad/cumplimiento); todo resultado se trata como dato no confiable (`.kaizen/org/knowledge/business/REA-INTEGRACION.md`, ADR-0009).

Aprendizaje continuo: `scripts/kaizen-learn record|digest|apply|report` convierte fallos, blockers y decisiones en lecciones con fingerprint, las deduplica, genera experiencia por agente y, cuando se repiten, las promueve a la definición (sube versión). Cuanto más se usa, más aprende y se especializa (`.kaizen/org/learning` → `docs/kaizen/org/APRENDIZAJE.md`, ADR-0007).

Evaluación y ratchet de agentes: `scripts/kaizen-eval check|baseline|ratchet|report|metrics add` — 10 dimensiones, promedio actual **93.1/100**, 45 agentes sobre el umbral de 70. Coste por decisión, tiempo a verificación y tasa de revert se registran con `metrics add`; la línea base no puede bajar sin ADR (`docs/kaizen/org/EVALUACION.md`, ADR-0006).

Verificación completa: `bash tests/run.sh`, `scripts/kaizen check` y `scripts/kaizen-org check`. El alcance realista de los modelos actuales y la previsión de evolución están en `docs/kaizen/org/FORECAST.md`. Los vetos de cumplimiento se regularon en `docs/kaizen/adr/0002-veto-de-cumplimiento-e-investigacion-normativa.md`.

## Colaboración de alto rendimiento

`.kaizen/team/DECISIONES.md` define roles de pensamiento (dueño, analista, retador, escriba, facilitador, humano), la regla del retador obligatorio y memorial de decisión. `scripts/kaizen-voice comment|memo|check` redacta y valida comentarios públicos y dictámenes con evidencia. `scripts/kaizen-learn known add|guard` recuerda fallos conocidos antes de implementar. Equipo `decisiones` con modelo `opencode/hy4-flash-free` (ADR-0019).

## Capacidades ampliadas y equipo grande

- **Observabilidad**: `scripts/kaizen-observability start` expone métricas reales en `http://127.0.0.1:9101/metrics`; `stack` levanta Prometheus + Grafana con el dashboard *Kaizen Swarm — Agentes en tiempo real* (ADR-0016).
- **REA** (ingeniería inversa profunda, 263 herramientas) y **reverse-api-engineer** (APIs tipadas desde sitios autorizados): con gobernanza, humano como A y evidencia (ADR-0009/0017).
- **Computer Use**: `scripts/kaizen-desktop` (X11 + `xdotool`/`import`), desactivado por defecto; requiere aprobación humana del proceso `computer_use` (ADR-0018).
- **Despliegue grande**: 6 equipos en paralelo (`equipo-central`, `cumplimiento`, `plataforma`, `producto`, `api-recon`, `desktop-ops`) con `kaizen-runtime deploy`, `KR_MAX_TEAMS_PARALLEL=6` y recursión controlada `KR_MAX_DEPTH=3`.

Nota operativa real: el último despliegue fue detenido por el **límite gratuito de OpenCode** (`depool-alpha-free`); requiere proveedor/suscripción o cambio de modelo (registrado en outbox S-11).

## Arranque en un comando y WhatsApp

```bash
./scripts/kaizen-start start      # instala 47 agentes, runtime persistente y buzón
kaizen-start status               # estado
kaizen-start stop                 # pausa total
```

Los reportes llegan a El Presidente (`.kaizen/team/OWNER.md`) por webhook n8n → WhatsApp, correo o archivo; las instrucciones de WhatsApp vuelven por `kaizen-inbox` y `kaizen-equipo` las convierte en trabajo verificable. Sin credenciales en el repo: `docs/kaizen/org/RUNTIME.md`.

## Versión, catálogo y propagación

Versión actual: **v1.0.0**. Catálogo de capacidades: `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` (263 herramientas REA en familias + skills del framework).

```bash
scripts/kaizen-release status
scripts/kaizen-release cut 1.0.1              # regenera, commitea, taggea y publica GitHub Release
scripts/kaizen-release install --global --projects-all   # OpenCode global + proyectos con .kaizen
```

`install --project` solo reemplaza `.opencode/agents/*.md` generados: no toca `opencode.json` ni archivos propios del proyecto (ADR-0010).

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
