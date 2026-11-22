# Propuesta de README fiel a la implementación (borrador de coherencia)

> Documento de trabajo del `knowledge-curator`. No modifica `README.md` ni rutas protegidas
> (`scripts/`, `.kaizen/`, `.github/`). Toda afirmación lleva `source_id` verificado en
> [§ 12 Fuentes](#12-fuentes-y-verificación). Estado: propuesta para decisión humana.
> Fecha de verificación: 2026-11-22 [SRC-01].

---

## 1. Qué es

`kaizen-swarm` es una **plantilla instalable de organización de agentes de IA** para repositorios
de software. No es un producto SaaS ni un framework de ejecución de modelos: es un conjunto de
**reglas versionadas, definiciones de agentes en Markdown, scripts orquestadores y documentación**
que se copian a un proyecto destino para que un equipo de agentes trabaje por issue, con
aislamiento en git worktrees, buzón trazable, proactividad con evidencia y consenso registrado
[SRC-14][SRC-15][SRC-16].

La unidad básica es el **puesto**, no la sesión: cada agente es un archivo
`.kaizen/org/prompts/<id>.md` con frontmatter (autonomía, veto, KPI, canales, triggers) y cuerpo
obligatorio; se puede copiar, editar, guardar y revertir como cualquier otro archivo del repo
[SRC-15]. La instalación es idempotente y **fusiona sin sobrescribir** lo que ya exista
[SRC-17].

Cifras verificadas en este repositorio (2026-11-22) [SRC-02][SRC-03][SRC-04][SRC-05][SRC-06][SRC-07][SRC-08][SRC-20]:

| Hecho | Valor real | Cómo se verifica |
| --- | --- | --- |
| Versión | **v1.2.0** | `cat VERSION`; `.kaizen/catalog/catalog.json → version` |
| Definiciones de agente | **45** (44 activos + `computer-operator` pausado) | `kaizen-org list` → 45 filas; `grep '^status:' prompts/*.md` |
| Agentes generados en OpenCode | **47** (45 + `kaizen-equipo` + `kaizen-installer`) | `ls .opencode/agents/*.md \| wc -l`; `kaizen-runtime status` → "globales instalados: 47" |
| Procesos gobernados (RACI) | **12** | `.kaizen/gov/governance.json → processes` |
| Equipos proactivos | **8** | `.kaizen/team/teams.json`; `kaizen-runtime status` |
| Herramientas REA | **263** en **11 familias**, 5 proveedores, 12 skills de framework | `.kaizen/catalog/catalog.json → stats` |
| Pruebas | **191 pasadas, 0 fallidas** | `bash tests/run.sh` |
| Evaluación de agentes | **100.0/100** (45 agentes, umbral 70, 0 bajo mínimo) | `scripts/kaizen-eval check` |
| ADRs | **15** (numeración 0001–0010 y 0016–0020; 0011–0015 reservados, sin redactar) | `ls docs/kaizen/adr/*.md` |

## 2. Qué no es

- **No es un modelo ni un proveedor de IA.** El runtime invoca un CLI (`KR_AGENT_CMD="opencode"`
  por defecto) y el modelo se configura fuera del repo [SRC-09][SRC-19].
- **No ejecuta pushes, PRs ni despliegues por su cuenta.** Los agentes proponen; el orquestador
  (`kaizen-swarm finalize`, `kaizen-team`, `kaizen-release`) y la protección de rama deciden
  [SRC-14][SRC-16].
- **No es un auditor, ni da asesoría legal.** Cumplimiento reporta con `source_ids` y escala a
  humano; `security`/`architecture`/`qa`/`compliance`/`scope`/`resource` tienen veto [SRC-15][SRC-16].
- **No guarda credenciales ni telemetría externa.** Sin secretos en el repo (S-1/S-2); la
  observabilidad es 100 % local [SRC-14][SRC-18][SRC-19].
- **No instala MCPs ni skills de terceros sin aprobación humana** (S-15). REA es la excepción
  documentada: instalado tras aprobación explícita [SRC-13][SRC-14].
- **No promete autonomía ilimitada.** Nivel 3 (ADR-0001) permite auto-merge de bajo riesgo con
  prueba de regresión; nunca sin humano en seguridad, dinero, datos, cumplimiento ni rutas
  protegidas [SRC-14][SRC-16][SRC-20].

## 3. Beneficios concretos

1. **Cero secretos por diseño.** Reglas S-1..S-16 y outbox S-11: todo hallazgo —incluso corregido—
   se documenta; el agente no lee credenciales [SRC-14].
2. **Trazabilidad de decisiones.** Ninguna decisión es válida sin `source_ids` verificados contra
   `.kaizen/org/knowledge/SOURCES.md` y `kaizen-team verify` en verde (REG-EV-01) [SRC-16].
3. **Aislamiento real de trabajo.** Cada rol trabaja en su worktree `wt-issue-<N>-<rol>`, declara
   propiedad en `contracts/ownership.json`, y `finalize` rechaza BLOCK abierto, ack pendiente,
   lease caducado o propiedad violada [SRC-14].
4. **Resiliencia.** Los leases caducan y `kaizen-swarm reap` reasigna; un agente caído no detiene
   el issue [SRC-14][SRC-16].
5. **Proactividad con frenos.** Los `triggers` generan propuestas en `decisions/inbox/`; el
   gerente asigna y se sigue consenso (2 turnos, umbral 0.66, sin veto) [SRC-15][SRC-16].
6. **Auto-mejora medible.** `kaizen-eval` puntúa 10 dimensiones (ratchet K-5), `kaizen-learn`
   convierte fallos en lecciones y `kaizen-org copy/save` especializa agentes sin destruir el
   original. Promedio actual 100.0/100 [SRC-07][SRC-15][SRC-20].
7. **Instalación portable.** Un solo enlace instruye a un agente CLI para clonar, ejecutar
   `kaizen-installer all <destino>` y verificar; no toca `opencode.json` del proyecto [SRC-17].
8. **Supervisión local.** Exporter Prometheus `:9101/metrics` y dashboard Grafana sin salida a red
   [SRC-18].

## 4. Arquitectura de capas

| Capa | Regla canónica | CLI / artefacto | Fuente |
| --- | --- | --- | --- |
| Gobernanza | `.kaizen/RULES.md` (K-1..K-14) | `scripts/kaizen` | SRC-14 |
| Seguridad | `.kaizen/security/SECURITY-RULES.md` (S-1..S-16) | `scripts/kaizen-security` | SRC-14 |
| Loop autónomo | `.kaizen/loop/LOOP.md` (L-1..L-17), nivel 3 sin PAUSA | `scripts/kaizen-loop` | SRC-14 |
| Comunidad swarm | `.kaizen/swarm/ROLES.md`, `PROTOCOL.md`, `ROSTER.md` (17 roles) | `scripts/kaizen-swarm` | SRC-14 |
| Organización | `.kaizen/org/ORGANIZATION.md`, `AGENT_SCHEMA.md`, `CONSENSUS.md`, `RESEARCH.md`, `OUTSOURCING.md` | `scripts/kaizen-org` | SRC-15 |
| Equipo proactivo | `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md`, `DECISIONES.md`, `OWNER.md` | `scripts/kaizen-team` | SRC-16 |
| Gobernanza semántica | `.kaizen/gov/governance.json` (12 procesos RACI + veto + humano) | `scripts/kaizen-gov` | SRC-04 |
| Calidad y aprendizaje | `.kaizen/evals/`, `.kaizen/learning/` | `kaizen-eval`, `kaizen-learn`, `kaizen-voice` | SRC-07 |
| Runtime y comunicación | `.kaizen/team/runtime.env`, `teams.json` | `kaizen-runtime`, `kaizen-start`, `kaizen-notify`, `kaizen-inbox` | SRC-09, SRC-19 |
| Distribución | `scripts/bootstrap`, `kaizen-installer`, `kaizen-release` | instalación idempotente y propagación | SRC-17 |
| Observabilidad | `observability/`, `.kaizen/observability/` | `kaizen-observability`, `grafana-bootstrap`, `kaizen-feedback` | SRC-18 |

**Precedencia:** documentación y ADR mandan sobre código (K-1); las reglas K/L/S heredan siempre,
aunque el frontmatter de un agente diga otra cosa [SRC-14][SRC-15].

## 5. Instalación y configuración paso a paso

### 5.1 Instalación por enlace para agentes CLI

Repositorio: `https://github.com/angelnereira/kaizen-swarm`. La fuente de verdad es el script:
no hay que improvisar archivos [SRC-17].

**OpenCode** — pegar en el CLI del directorio destino:

```text
Instala la comunidad de este repositorio: https://github.com/angelnereira/kaizen-swarm
1) git clone --depth 1 https://github.com/angelnereira/kaizen-swarm /tmp/kaizen-swarm
2) /tmp/kaizen-swarm/scripts/kaizen-installer all <directorio-destino>
   (bootstrap del framework + 47 agentes en .opencode/agents y en ~/.config/opencode/agents)
3) /tmp/kaizen-swarm/scripts/kaizen-start status && bash /tmp/kaizen-swarm/tests/run.sh
4) Reporta creados/omitidos y qué decisiones humanas quedan pendientes.
No escribas secretos, no modifiques opencode.json sin permiso y no hagas git push.
```

**Claude Code:** mismo contenido adaptado — «Lee e instala siguiendo las instrucciones de <enlace>;
clona, ejecuta `scripts/kaizen-installer all <destino>`, verifica con `kaizen-start status` y
`bash tests/run.sh`; no pulses credenciales ni hagas push; reporta el resultado real» [SRC-17].

**Codex CLI:** equivalente en inglés con `git clone --depth 1 <url> /tmp/kaizen-swarm &&
/tmp/kaizen-swarm/scripts/kaizen-installer all <target>` y verificación con `tests/run.sh` [SRC-17].

**Humano (sin agente):**

```bash
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm /tmp/kaizen-swarm
/tmp/kaizen-swarm/scripts/kaizen-installer all /ruta/a/tu/proyecto   # repo + local + global
/tmp/kaizen-swarm/scripts/kaizen-installer status                    # definidos / globales / checks
bash /tmp/kaizen-swarm/tests/run.sh                                  # 191 pruebas
```

`all` encadena `repo <dir>` (exige repo git; llama a `bootstrap`), `opencode --project <dir>` y
`opencode --global`. La generación usa `scripts/lib/opencode_agents.py`, omite archivos idénticos y
**nunca modifica `opencode.json`**: conserva permisos y MCP del usuario [SRC-17].

### 5.2 Arranque del runtime

```bash
./scripts/kaizen-start start      # instala agentes, systemd --user (o nohup), runtime y buzón
kaizen-start status               # agentes, runtime, buzón, modelo y RC del último ciclo
KR_DRY_RUN=1 scripts/kaizen-runtime once equipo-central   # prueba sin consumir modelo
./scripts/kaizen-start stop       # pausa total; también respeta .kaizen/loop/PAUSE
```

Parámetros en `.kaizen/team/runtime.env`: `KR_AGENT_CMD=opencode`, `KR_INTERVAL_SEC=900`,
`KR_MAX_RUNS_PER_DAY=24`, `KR_TIMEOUT_SEC=900`, `KR_MAX_DEPTH=3` (recursión controlada mediante
`KAZEN_AGENT_DEPTH`), `KR_MAX_TEAMS_PARALLEL=6`, `KR_DECISIONS_MODEL=opencode/hy4-flash-free`
[SRC-09][SRC-19].

### 5.3 Observabilidad y notificaciones (opcional)

```bash
scripts/kaizen-observability start      # exporter 127.0.0.1:9101/metrics
scripts/kaizen-observability stack      # Prometheus :9090 + Grafana :3000 (Docker)
scripts/grafana-bootstrap apply         # usuario kaizen-agent + service account (token nunca versionado)
scripts/kaizen-feedback snapshot        # docs/kaizen/org/FEEDBACK.md
```

Notificaciones: `KAZEN_WEBHOOK_URL` / `KAZEN_WEBHOOK_SECRET` → n8n → WhatsApp/Telegram; correo
SMTP y transporte `file` como respaldo. Instrucciones entrantes: `kaizen-inbox` escucha solo en
`127.0.0.1:8787` con cabecera `X-Kaizen-Secret` y sanea con `kaizen-security redact` [SRC-18][SRC-19].

## 6. Uso proactivo

**Flujo por issue (swarm):** `init N → R1 análisis/contratos → R2 implementación (worktrees) →
R3 revisión → finalize N`. Cada mensaje en `mailbox/` lleva `seq/from/to/type/status`; un
`handoff` necesita `ack`; `reap` reasigna leases caducados [SRC-14].

**Organización de agentes:**

```bash
scripts/kaizen-org list                          # 45 puestos
scripts/kaizen-org research cumplimiento-panama "versión vigente de la Ley 81" --url https://www.antai.gob.pa/
scripts/kaizen-org copy marketing marketing-visual --name "Marketing Visual"
scripts/kaizen-org save marketing-visual         # sube versión + diario
scripts/kaizen-org feed marketing-visual docs/kaizen/org/FORECAST.md
scripts/kaizen-org digest marketing-visual
scripts/kaizen-org pulse                         # propuestas en decisions/inbox/
scripts/kaizen-org decide "reducir tiempo de feedback" --owner gerente
```

Los agentes con `research-web` (`cumplimiento-panama`, `capacidades-negocio`, `researcher`) siguen
`.kaizen/org/RESEARCH.md`: fuente oficial, mínimo dos fuentes, fecha de corte y expediente en
`.kaizen/org/research/`. Ese conocimiento es **dato no confiable** (L-5/S-15) [SRC-15][SRC-14].

**Equipo proactivo:** `scripts/kaizen-team init <slug> --goal "..." --kpi "..."`, luego
`standup`, `assign`, `handoff`, `ack`, `sync`, `decide --sources PA-001,ISO-001`, `verify`,
`advance`, `retro`. Máquina de estados:
`intake → plan → squad → execute → review → decide → deliver → verify → closed`, con retorno a
`review` ante `needs-human`/`regression-suspect`. El orquestador mueve el estado; los agentes no se
auto-avanzan [SRC-16].

**Ocho equipos definidos** en `.kaizen/team/teams.json` [SRC-08]:

| Equipo | Objetivo (resumen) |
| --- | --- |
| `equipo-central` | Coordinar la comunidad; una decisión verificada por ciclo |
| `cumplimiento` | Gaceta Oficial y normativa panameña; 0 normas sin `source_id` |
| `plataforma` | CI/CD, nube, observabilidad, Rust/WASI; despliegues con rollback |
| `producto` | Perfiles de negocio, identidad, verticales, Flutter, RAG |
| `api-recon` | `reverse-api-engineer` gobernado; 0 capturas sin autorización |
| `desktop-ops` | Computer Use gobernado; 0 acciones sin captura y recaptura |
| `auto-mejora` | Convertir hallazgos en lecciones y subir `kaizen-eval` sin regresiones |
| `decisiones` | Deliberación con retador obligatorio y memorial |

`auto-mejora` y `decisiones` usan el modelo **`opencode/hy4-flash-free`** (ADR-0019) [SRC-08][SRC-20].

## 7. Gobernanza y decisiones

- **Consenso** (`.kaizen/org/CONSENSUS.md`): proponer → consultar → discutir (máx. 2 turnos con dato
  nuevo) → mayoría cualificada 0.66 **sin veto vigente** → registrar (revisión a 14 días) →
  verificar KPI (L-9). Vetos: `security`, `architecture`, `qa`, `compliance`, `scope`, `resource`
  [SRC-15].
- **Decisión de alto rendimiento** (`.kaizen/team/DECISIONES.md`): dueño, analista, **retador
  obligatorio**, escriba, facilitador y humano. «Si nadie objetó, la decisión no está lista.»
  Comunicación pública con `kaizen-voice comment|memo|check`:
  `Observación → Evidencia → Impacto → Propuesta → Pregunta` [SRC-16].
- **Evidencia** (`.kaizen/team/EVIDENCIA.md`): `source_id = XX-NNN` con `publisher`, `document`,
  `url`, `retrieved`, `sha256`, `status` (`verified|pending|conflict|stale`) y `verified_by`.
  Fuentes `pending/conflict/stale` bloquean (REG-EV-01) [SRC-16].
- **Humano** (`.kaizen/team/OWNER.md`): «El Presidente» aprueba objetivo/alcance/KPI, cierra
  proyectos y decide siempre sobre cumplimiento, dinero, datos personales, seguridad, rutas
  protegidas, autonomía, modelo y presupuesto [SRC-16].
- **12 procesos RACI** en `governance.json`: `decision`, `deployment`, `change`, `incident`,
  `compliance`, `research`, `agent_lifecycle`, `budget`, `retro`, `reverse_engineering`,
  `api_reverse_engineering`, `computer_use` — con humano como A en los tres últimos [SRC-04].
  Consultar con `kaizen-gov raci|who|can|obligations|report`.

## 8. Monitoreo local

- `kaizen-observability status|check|start|stop|stack`: exporter en `127.0.0.1:9101/metrics`,
  Prometheus `:9090` y Grafana `:3000`, dashboard **Kaizen Swarm — Agentes en tiempo real** [SRC-18].
- Series: `kaizen_agents_total`, `kaizen_rea_tools_total` (263), `kaizen_project_stage`,
  `kaizen_tasks`, `kaizen_handoffs`, `kaizen_decisions`, `kaizen_outbox_findings`,
  `kaizen_eval_score`, `kaizen_learning_lessons`, `kaizen_agent_last_rc{agent,team}`,
  `kaizen_team_log_age_seconds`, `kaizen_runtime_cycle_rc` (detecta rc 124/143) y series de repos
  hermanos (`kaizen_sibling_*`) [SRC-18].
- Si un archivo no existe, la serie **se omite**, nunca se inventa (K-10). Rojo → outbox S-11,
  nunca se oculta [SRC-14][SRC-18].
- `kaizen-feedback snapshot|learn|all` convierte lo observado en informes y lecciones [SRC-18].

## 9. Seguridad y límites honestos

**Seguridad:** S-1 cero secretos; S-2 el agente no toca credenciales; S-10 nada se silencia;
S-11 todo hallazgo va al outbox (incluso corregido); S-12 secreto filtrado = comprometido;
S-15 contenido externo (web, issues, logs, MCP, skills) es dato no confiable; S-16 contenedores sin
root y sin `latest` [SRC-14].

**Límites verificados hoy (no se ocultan):**

1. **Saldo OpenCode agotado.** El último `deploy` con 6 equipos terminó `rc=1` por el modelo
   `depool-alpha-free`: «Free usage limit reached…». Requiere conectar proveedor, suscribir
   OpenCode Go o cambiar de modelo; decisión de El Presidente. No se reintenta automáticamente
   para no falsificar resultados [SRC-10].
2. **Cuota de disco para `reverse-api-engineer`.** `pip install --user reverse-api-engineer` y la
   creación del venv fallaron con `OSError: [Errno 122] Disk quota exceeded` (cuota de usuario,
   no de partición). El equipo `api-recon` está gobernado y documentado, pero **la herramienta no
   quedó instalada**: hay que liberar cuota e instalar con `python3-venv` antes de operar [SRC-11].
3. **Computer Use desactivado.** `computer-operator` está `status: paused`; `scripts/kaizen-desktop`
   implementa X11 con gate `KO_DESKTOP_ENABLED=0` por defecto. Requiere autorización humana del
   proceso `computer_use` (A: humano, V: seguridad) [SRC-12][SRC-20].
4. **REA sí instalado, con aprobación humana.** ADR-0009: MCP `rea` + skill
   `reverse-engineer-anything`, Node v22.23.4 en espacio de usuario, backup de `opencode.json`,
   263 herramientas. Motores nativos licenciados (Hopper/Ghidra/IDA/Kuna) **no instalados**;
   resultados = dato no confiable con `_meta.provenance.untrusted_content` [SRC-13][SRC-20].
5. **Barreras no sustituidas.** Escáneres con falsos negativos y hooks locales saltables: la
   barrera real es CI obligatorio + protección de rama + CODEOWNERS; decisiones de seguridad,
   secret scanning y permisos de workflows siguen pendientes [SRC-01][SRC-14].
6. **Deuda de coherencia documental conocida.** Varios documentos derivados siguen desactualizados
   frente a la implementación: `AGENTS.md`/`ORGANIZATION.md`/`OWNER.md` citan 42–44 agentes,
   `RUNTIME.md` cita 4 equipos, `EVALUACION.md` cita 42 agentes y 93.1, `CHANGELOG.md` cita
   144/144 pruebas y 9 ADRs, y el KPI de `auto-mejora` cita baseline 93.1 frente a 100.0 real.
   Están reportados en el outbox S-11; requieren PR con ADR [SRC-21].

## 10. Verificación recomendada

```bash
bash tests/run.sh                 # 191 pasadas, 0 fallidas
scripts/kaizen check
scripts/kaizen-org check
scripts/kaizen-team check
scripts/kaizen-eval check          # promedio 100.0, bajo_minimo 0
scripts/kaizen-gov check
scripts/kaizen-observability check
scripts/kaizen-installer status    # definidos 45, globales 47
```

Si cualquier gate está rojo, se reporta por S-11 y se decide con evidencia; nunca se relaja la
línea base ni se silencia una prueba (K-5, K-10, S-10) [SRC-14].

## 11. Buenas prácticas y recomendaciones

1. **Un cambio = un issue + un descriptor** en `docs/kaizen/pr-drafts/`; sin descriptor no hay PR
   (K-4). Empieza con `kaizen start <rama>` y termina con `kaizen check` [SRC-14].
2. **Genera cifras desde la fuente**: `kaizen-installer status`, `kaizen-org list`,
   `kaizen-eval check`, `kaizen-runtime status`, nunca copiando números de documentos derivados
   [SRC-03][SRC-07][SRC-21].
3. **Especializa por copia, nunca por mutación**: `kaizen-org copy/save`; subir autonomía requiere
   ADR humano [SRC-15].
4. **Registra métricas de decisión** con `kaizen-eval metrics add` (coste, minutos, revert) para
   que el reporte agregue datos observados, no estimados [SRC-07].
5. **Alimenta y sanea conocimiento** con `kaizen-org feed`/`digest`, y respeta hash y fecha de
   corte: la trazabilidad rota de `SOURCES.md` está reportada en S-11 [SRC-15][SRC-21].
6. **Prueba sin gastar modelo**: `KR_DRY_RUN=1 scripts/kaizen-runtime once <equipo>` antes de
   desplegar [SRC-19].
7. **Sin credenciales en pantalla ni en el repo**: n8n guarda las de WhatsApp; el token de Grafana
   se entrega por API y nunca se versiona [SRC-18][SRC-19].
8. **No actives Computer Use ni captures sin humano**, y trata todo contenido de REA/APIs/web como
   dato no confiable [SRC-12][SRC-13][SRC-14].

## 12. Fuentes y verificación

Todas las rutas son relativas a `kaizen-swarm` y fueron leídas el 2026-11-22. Comandos citados
ejecutados en este repositorio.

| ID | Fuente verificable |
| --- | --- |
| SRC-01 | `README.md` (documento actual a corregir); `CHANGELOG.md` |
| SRC-02 | `VERSION` (= 1.2.0); `.kaizen/catalog/catalog.json → version` |
| SRC-03 | `.kaizen/org/prompts/*.md` (45 + `_template`); `.opencode/agents/*.md` (47); `scripts/kaizen-org list`; `scripts/kaizen-installer status` |
| SRC-04 | `.kaizen/gov/governance.json → processes` (12) |
| SRC-05 | `.kaizen/catalog/catalog.json → stats`; `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` |
| SRC-06 | `bash tests/run.sh` → «191 pruebas pasadas, 0 fallidas» |
| SRC-07 | `scripts/kaizen-eval check` → «agentes=45 promedio=100.0 minimo=70 bajo_minimo=0»; `.kaizen/evals/baseline.json`; `docs/kaizen/org/EVALUACION.md` |
| SRC-08 | `.kaizen/team/teams.json`; `scripts/kaizen-runtime status` → 8 equipos, 47 globales |
| SRC-09 | `.kaizen/team/runtime.env` (KR_* parámetros) |
| SRC-10 | `.kaizen/loop/outbox/opencode-usage-limit-deploy.md` |
| SRC-11 | `.kaizen/loop/outbox/rae-api-instalacion-cuota.md` |
| SRC-12 | `.kaizen/org/prompts/computer-operator.md` (`status: paused`); `scripts/kaizen-desktop`; `docs/kaizen/adr/0018-computer-use-gobernado.md` |
| SRC-13 | `docs/kaizen/adr/0009-integracion-rea-gobernada.md`; `.kaizen/org/knowledge/business/REA-INTEGRACION.md` |
| SRC-14 | `.kaizen/RULES.md`; `.kaizen/security/SECURITY-RULES.md`; `.kaizen/loop/LOOP.md`; `.kaizen/swarm/ROLES.md`, `PROTOCOL.md`, `ROSTER.md` |
| SRC-15 | `.kaizen/org/ORGANIZATION.md`, `AGENT_SCHEMA.md`, `CONSENSUS.md`, `RESEARCH.md`, `OUTSOURCING.md`; `.kaizen/org/knowledge/**` |
| SRC-16 | `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md`, `DECISIONES.md`, `OWNER.md` |
| SRC-17 | `scripts/kaizen-installer`, `scripts/bootstrap`, `scripts/lib/opencode_agents.py`, `scripts/kaizen-release` |
| SRC-18 | `scripts/kaizen-observability`, `scripts/grafana-bootstrap`, `scripts/kaizen-exporter.py`, `scripts/kaizen-feedback`; `observability/**`; `docs/kaizen/org/OBSERVABILIDAD.md`, `MONITOREO-PROYECTOS.md`; ADR-0016/0020 |
| SRC-19 | `docs/kaizen/org/RUNTIME.md`; `scripts/kaizen-start`, `kaizen-runtime`, `kaizen-notify`, `kaizen-inbox`; ADR-0005 |
| SRC-20 | `docs/kaizen/adr/*.md` (15 ADRs); ADR-0001, 0002, 0003, 0006, 0007, 0019 |
| SRC-21 | `.kaizen/loop/outbox/conteo-agentes-inconsistente.md`, `kpi-baseline-desactualizado-20261122.md`, `dx-block-instalacion.md`, `conocimiento-trazabilidad-*.md` |

---

### Correcciones principales frente al `README.md` actual

1. **Versión:** 1.0.0 → **1.2.0** (`VERSION` y catálogo).
2. **Agentes:** unifica 42/43/44/45/47 → **45 definiciones (44 activos + 1 pausado), 47 generados**.
3. **Procesos:** 9 → **12** (`governance.json`).
4. **Equipos:** 6 → **8** (añade `auto-mejora` y `decisiones`; ambos con `opencode/hy4-flash-free`).
5. **Evaluación:** 93.1/100 y «45 sobre umbral» → **100.0/100, umbral 70, 0 bajo mínimo**.
6. **Pruebas:** sin cifra fiable en el README → **191/191 verdes** (el CHANGELOG dice 144/144).
7. **REA vs. reverse-api-engineer:** REA sí instalado con aprobación humana; **reverse-api-engineer
   NO instalado** por cuota de disco (el README lo daba por operativo).
8. **Saldo OpenCode:** concretar agotamiento del plan gratuito `depool-alpha-free` con 6 equipos en
   `rc=1`, no solo «límite gratuito».
9. **State REAL del bundle:** `/tmp/kaizen-swarm/scripts/kaizen-installer all <destino>` (no asumir
   repo ya clonado); verificación con `kaizen-installer status` y `tests/run.sh`.
10. **Coherencia interna:** el propio README mezclaba «47 agentes» con «45 puestos» y «44 agentes»
    en secciones distintas; se unifica y se documenta la deuda de otros archivos derivados [SRC-21].
