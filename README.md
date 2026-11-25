# kaizen-swarm

**Una organización de agentes para OpenCode que convierte instrucciones en trabajo verificable: por issue, con gobernanza, evidencia y mejora medible.**




## Windows sin fricción y doctor

`install.ps1 -Yes` instala los agentes en la **configuración real** de OpenCode (nunca en un directorio temporal), crea la gobernanza global en `~/.local/share/kaizen-swarm/framework` y deja **una sola pregunta**: tu número de WhatsApp. No modifica tus repositorios.

Si algo salió mal, ejecuta desde el repo:

```powershell
python scripts/kaizen-doctor check
python scripts/kaizen-doctor fix
```

El doctor detecta dependencias (`git`, `jq`, `opencode`), cuenta los agentes reales y elimina referencias huérfanas a `/tmp` en `opencode.json` **con backup**. Si `opencode` no está en PATH, instálalo desde https://opencode.ai y vuelve a correr el instalador (ADR-0038).

## Custodia de secretos (broker humano)

**El chat nunca es un canal seguro para secretos.** No pegues tokens ni contraseñas en la conversación: el texto queda en historial, logs y contexto del modelo. `kaizen-vault` invierte el flujo: el usuario deposita el valor fuera de banda (`set`, sin eco), el agente solo `request`, y un **humano aprueba en su terminal** (`approve`) emitiendo un grant HMAC con TTL. El secreto se entrega por **FD 3** al comando aprobado, nunca al chat ni a logs.

- Cifrado AES-256-GCM con nonce de 96 bits y AAD vinculante; Argon2id fijado; passphrase nunca persistida.
- Auditoría append-only con hash-chain, HMAC y anti-rollback (`audit-verify`).
- `redact` reemplaza valores conocidos por `[REDACTED]`; `custodian` muestra metadata sin valores.
- 10 agentes dedicados (`custodia-secretos`): custodio, cripto, políticas, auditor, ciclo de vida, fuga, cumplimiento, inyector, QA y aprobación humana.
- **Estado PILOT**, no adopción plena: queda verificar Windows (G5) y firmar un humano antes de usar secretos reales (ADR-0037). `rekey` local NO sustituye rotar en el proveedor (S-12).

```bash
scripts/kaizen-vault init            # humano, passphrase sin eco
scripts/kaizen-vault enroll <agente> # token opaco, modo 600
scripts/kaizen-vault allow <agente> <scopes> <comandos> <ttl_min>
scripts/kaizen-vault set <scope> <nombre>
scripts/kaizen-vault request <token_file> <scope> <purpose> <nota>  # agente: solo solicita
scripts/kaizen-vault requests && scripts/kaizen-vault approve <id> "<comando>"  # humano, fuera de banda
scripts/kaizen-vault exec <id> <token_file>   # broker entrega por FD 3
scripts/kaizen-vault audit-verify && scripts/kaizen-vault custodian
```

## Instalación definitiva

Repositorio: **https://github.com/angelnereira/kaizen-swarm**. La instalación es no invasiva: los agentes viven en `~/.config/opencode/agents` y el estado en `~/.local/share/kaizen-swarm`; el repo destino no se toca salvo `--embedded` explícito.

### Opción A — pasar el link a tu herramienta de IA (recomendado)

Copia y pega este prompt en **OpenCode, Claude Code, Codex o tu agente preferido**:

> Instala kaizen-swarm desde https://github.com/angelnereira/kaizen-swarm. Clona el repo, ejecuta `scripts/kaizen-installer opencode --global` (o `python scripts/kaizen-installer opencode --global` en Windows), verifica con `scripts/kaizen-platform check`, `scripts/kaizen-gov check` y `scripts/kaizen-eval check`. No modifiques el proyecto destino, no escribas secretos y reporta la salida real de cada comando.

### Opción B — terminal (Linux / WSL / macOS)

```bash
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm
cd kaizen-swarm
scripts/kaizen-installer opencode --global
scripts/kaizen-platform check
scripts/kaizen-gov check
bash tests/run.sh
```

Para instalar en un proyecto concreto: `scripts/kaizen-installer repo <ruta-del-proyecto>` (o `scripts/kaizen-runtime install`).

### Opción C — Windows (PowerShell)

```powershell
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm "$env:LOCALAPPDATA\kaizen-swarm"
cd "$env:LOCALAPPDATA\kaizen-swarm"
.\install.ps1 -Yes
.\scripts\kaizen-platform.ps1 check
```

`install.ps1` sin `-Yes` solo muestra los comandos (dry-run). En Windows los CLIs Python son multiplataforma; los scripts bash requieren Git Bash o WSL y `kaizen-platform check` lo reporta honestamente (ADR-0032).

### Verificación y paridad

`kaizen-platform check|json` detecta Linux, WSL, Windows y macOS y selecciona runtime `bash` o `powershell`. `kaizen-invoke detect` confirma los clientes disponibles (OpenCode, Claude Code, Codex). El comportamiento es igual o similar: mismos CLIs Python, mismos prompts, mismos checks. Nunca se asume Linux (K-10).

![Definiciones: 80](https://img.shields.io/badge/definiciones-80-blue)
![Generados: 80](https://img.shields.io/badge/generados-80-blue)
![Procesos RACI: 12](https://img.shields.io/badge/procesos_RACI-12-teal)
![Herramientas REA: 263](https://img.shields.io/badge/herramientas_REA-263-orange)
![Pruebas: 191](https://img.shields.io/badge/pruebas-191-brightgreen)
![Versión: v1.3.0](https://img.shields.io/badge/version-v1.3.0-grey)
![Corte: 2026-11-23](https://img.shields.io/badge/corte-2026--11--23-lightgrey)

> Badges estáticos con fecha de corte: se actualizan al cortar release. No representan CI remoto. Las mismas cifras están en la tabla siguiente para leer sin red.

---

## Panorama en cifras

| Lo que importa | Valor | Fuente de verdad |
| --- | ---: | --- |
| Definiciones de puestos | 45 | `docs/kaizen/org/CATALOGO-AGENTES.md` |
| Archivos de agente generados | 47 | `.opencode/agents/` y `~/.config/opencode/agents/` |
| Procesos de gobernanza RACI | 12 | `docs/kaizen/org/GOBIERNO.md` |
| Equipos proactivos | 8 | `.kaizen/team/teams.json` |
| Rieles de reglas | K-1..K-14 · S-1..S-16 · L-1..L-17 | `.kaizen/RULES.md`, `.kaizen/security/SECURITY-RULES.md`, `.kaizen/loop/LOOP.md` |
| Herramientas REA catalogadas | 263 (11 familias) | `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` |
| Calidad media de definiciones | 100.0/100 | `scripts/kaizen-eval check` |
| Pruebas en verde (última corrida local) | 191/191 | `bash tests/run.sh` |
| Versión | v1.2.0 | `VERSION` |

---

## Qué es

**kaizen-swarm** es una plantilla instalable y una comunidad de agentes para OpenCode (también utilizable desde Claude Code y Codex CLI). Los 45 puestos se instalan como 47 archivos de agente; cada uno declara propósito, herramientas, KPI, autonomía y veto limitado. El trabajo se organiza por issue en worktrees aislados, con buzón numerado, dueños de ruta explícitos y handoffs que requieren acuse.

Tres ideas lo definen:

1. **Reglas antes que intuición.** Gobernanza, seguridad y loop son archivos versionados con identificadores citables (K, S, L). Nada de decisiones de arquitectura sin ADR (K-1).
2. **Proponer con evidencia.** La proactividad (`kaizen-org pulse`) emite propuestas con `source_ids` verificados. Ningún agente decide en seguridad, dinero, datos ni cumplimiento sin humano (K-14, ADR-0003).
3. **Aprender sin degradar.** `kaizen-learn` convierte fallos en lecciones con fingerprint; `kaizen-eval` y el ratchet impiden que una definición empeore sin ADR (ADR-0006/0007).

La autoridad final es **El Presidente**, dueño del negocio y del proyecto (`.kaizen/team/OWNER.md`). El orquestador —no el agente— hace push y abre PR (K-12, L-3).

## Qué no es

| No es | En su lugar |
| --- | --- |
| Un superagente que decide por El Presidente | Muchos roles acotados, orquestador y puertas; humano en decisiones sensibles |
| Asesoría legal, fiscal ni financiera | Mapas de obligaciones con fuente oficial y fecha de corte; firma un humano |
| CI en la nube ni badge de build remoto | Verificación local reproducible: `bash tests/run.sh`, `scripts/kaizen check` |
| Un auditor infalible | Escáneres con falsos negativos; la barrera es CI + protección de rama + CODEOWNERS |
| Control de escritorio activo por defecto | `computer-operator` en `paused` + `KO_DESKTOP_ENABLED=0`, humano como A |
| Algo que hace push o PR por iniciativa propia | `finalize --publish` lo ejecuta el orquestador |
| Una fuente normativa | `monitor-gaceta` reporta cambios con URL oficial; los bloqueos se documentan, nunca se inventa un «sin cambios» |

## Beneficios

| Beneficio | Cómo se materializa |
| --- | --- |
| Arranque predecible | `kaizen-installer all <repo>` es idempotente: fusiona sin sobrescribir y no toca `opencode.json` ni credenciales |
| Decisiones trazables | 12 procesos RACI, retador obligatorio, memorial y verificación (`DECISIONES.md`, ADR-0019) |
| Visibilidad operativa | Grafana 100 % local: `:9101` exporter, `:9090` Prometheus, `:3000` Grafana, 12 paneles |
| Mejora acumulativa | Lecciones con fingerprint y ratchet de calidad: lo aprendido sube de versión la definición |
| Alcance especializado | 10 especialistas por tecnología; si no hay especialista, contrato con `evidence.md` verificable |
| Puente con El Presidente | Reportes por webhook n8n → WhatsApp; instrucciones entrantes por `kaizen-inbox` |

---

## Cómo se configura

Guía completa de **instalación, actualización y desinstalación** en Linux, macOS y Windows: [`docs/kaizen/INSTALACION.md`](docs/kaizen/INSTALACION.md).

### Chat interactivo como proyecto

El chat principal puede vivir en una ruta dedicada de la máquina, con su contexto, archivos y transcripción:

```bash
scripts/chat-opencode init mesa-directiva --agent kaizen-equipo
scripts/chat-opencode path mesa-directiva          # ~/.local/share/kaizen-swarm/chat/mesa-directiva
scripts/chat-opencode message mesa-directiva "¿estado de los PRs?"
scripts/chat-opencode ask mesa-directiva "resume el estado"   # dry-run; KZ_DRY_RUN=0 ejecuta opencode
scripts/chat-opencode check mesa-directiva
```

Contrato y límites: [ADR-0039](docs/kaizen/adr/0039-chat-como-proyecto-de-ruta-dedicada.md). El contenido entrante es dato no confiable y nunca se ejecuta (S-15/L-5); los canales remotos usan solo WhatsApp oficial vía BSP (ADR-0025).

### Para una persona

```bash
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm /tmp/kaizen-swarm
cd /tmp/kaizen-swarm
./scripts/kaizen-installer all /ruta/a/tu/proyecto
./scripts/kaizen-start status
./scripts/kaizen-start start      # runtime persistente y buzón
```

`all` genera los 47 agentes, fusiona sin sobrescribir y no modifica tu `opencode.json` ni tus credenciales.

### Para un agente CLI (solo pasar el enlace)

```text
Instala la comunidad de este repositorio: https://github.com/angelnereira/kaizen-swarm

1) Clónalo en /tmp/kaizen-swarm (git clone --depth 1).
2) Ejecuta: /tmp/kaizen-swarm/scripts/kaizen-installer all <directorio-destino>
3) Verifica: /tmp/kaizen-swarm/scripts/kaizen-start status y bash tests/run.sh.
4) Reporta qué creó, qué omitió por existir y qué decisiones humanas quedan pendientes.
No escribas secretos, no modifiques opencode.json sin permiso y no hagas git push.
```

| CLI | Ajuste |
| --- | --- |
| Claude Code | «Lee e instala siguiendo las instrucciones de <URL>». El script es la fuente de verdad |
| Codex CLI | «Install the agent community from <URL>». Mismo clone + `kaizen-installer all <target>` |
| Humano | Usa el bloque anterior; no se necesita agente previo |

### Verificación

```bash
scripts/kaizen-swarm check     # instalación, propiedad y vetos
scripts/kaizen check           # gobernanza, seguridad, eval, aprendizaje y ratchet
bash tests/run.sh              # 191 pruebas
scripts/kaizen-observability check
```

---

## Flujo de trabajo

```text
intake → plan → squad → execute → review → decide → deliver → verify → closed
   ↑                                                              │
   └───────────── needs-human / regression-suspect ───────────────┘
```

- Cada rol escribe solo sus rutas (`contracts/ownership.json`); los leases caducan y se reasignan.
- Los mensajes llevan `seq`, `from`, `to`, `intent`, `expects_ack` y `source_ids`; sin ack no hay handoff cerrado.
- `architect`, `security`, `qa`, `compliance`, `scope` y `resource` pueden vetar con evidencia.
- `kaizen-swarm finalize` no integra con BLOCK abierto, acuses pendientes ni propiedad violada.

---

## WhatsApp oficial

El puente usa **solo Cloud API oficial vía BSP/n8n**: ventana de 24 h, plantillas aprobadas, opt-in explícito y webhooks idempotentes con firma HMAC. `kaizen-whatsapp templates|window|optin|check` aplica la política localmente; Baileys/whatsapp-web.js está prohibido (`KN_WHATSAPP_ALLOW_UNOFFICIAL=0`). Credenciales en n8n/Vault, nunca en el repo (ADR-0025).

## Instalación no invasiva y comunidad de pares

La comunidad se instala en la **máquina y sus herramientas** (agentes globales + `~/.local/share/kaizen-swarm/workspaces/`), no dentro del código del proyecto: `kaizen-installer repo <destino>` solo registra un workspace externo; `--embedded` es explícito y opcional. Los agentes se organizan con `kaizen-peer request-review|comment|validate`, investigan en internet y participan en issues/PR remotos con `kaizen-remote` auditado (`--dry-run` por defecto). Ninguna credencial se guarda en el repo (ADR-0024, K-15).

## Corpus normativo y citas verificadas

`scripts/kaizen-knowledge add|ingest|verify|diff|index|stale|cite-check` mantiene `.kaizen/knowledge/sources.json` con niveles **V/S/I/N**, frescura por dominio y anclas por artículo. Solo una fuente **V** (verificada por humano) sustenta decisiones; `cite-check` falla si una cita no existe o no está verificada. Equipo `normativa-corpus` con `opencode/hy4-flash-free` (ADR-0022, `docs/kaizen/org/CORPUS-NORMATIVO.md`).

## Economía de tokens y trabajo continuo

`scripts/kaizen-tokens record|snapshot|report` lleva un ledger local de entrada/salida, coste reportado y ahorro **estimado**; el exporter lo publica como `kaizen_tokens_*` en Grafana. `kaizen-runtime work <equipo>` asigna la siguiente tarea pendiente al terminar una (proactividad sin detenerse), con `KT_MAX_TASKS_PER_AGENT=3`, `KT_MAX_AGENTS=12` y `KT_MAX_PARALLEL=6` para no reventar la máquina. Equipo `finops-tokens` con `opencode/hy4-flash-free` (ADR-0021, `docs/kaizen/org/TOKENS.md`).

## Supervisión local (Grafana)

Grafana es la **capa de monitoreo**, 100 % en tu máquina: Prometheus `:9090`, Grafana `:3000`, exporter `:9101`. Muestra en tiempo real qué agente trabaja, en qué equipo, cuánto dura su evento y si terminó en verde. La **fuente** es persistente (archivos del repo) y el histórico se conserva en volúmenes locales de Prometheus y Grafana. No hay telemetría externa.

```bash
scripts/kaizen-observability stack       # Prometheus + Grafana (Docker)
scripts/grafana-bootstrap apply          # usuario kaizen-agent (Viewer)
scripts/kaizen-feedback all              # informe + lecciones
```

Credenciales locales por defecto (sobrescribibles; **no usar fuera de localhost** y cambiarlas si el equipo comparte red): admin `kaizen-admin` / `kaizen-local`, agente `kaizen-agent` / `kaizen-agent-local`. El token del service account nunca se versiona. Ver `docs/kaizen/org/MONITOREO-PROYECTOS.md` y ADR-0020.

---

## Seguridad y límites

- Los agentes no leen `.env`, claves ni variables de entorno (S-2). No hay secretos en el repo.
- Nada se silencia: todo hallazgo va al outbox S-11 con fingerprint; un escáner que falla bloquea.
- REA está **instalado** con aprobación humana (ADR-0009); sus resultados se tratan como datos no confiables.
- `reverse-api-engineer` está **documentado y gobernado, pero NO instalado** por cuota de disco (`Errno 122`). No lo consideres operativo hasta liberar espacio.
- `computer-operator` está en pausa: requiere `KO_DESKTOP_ENABLED=1`, humano como A y veto de seguridad (ADR-0018).
- Los 6 equipos desplegados con `depool-alpha-free` se detuvieron por saldo insuficiente. El 2026-11-22 la auto-mejora sí corrió con `opencode/hy4-flash-free` y terminó en verde (rc=0); la mejora determinista local se aplicó además como respaldo.

## Buenas prácticas

1. Instala en un repo con `kaizen-installer all`, nunca copiando archivos a mano.
2. Antes de delegar, lee `RULES.md`, `TEAM.md`, `DECISIONES.md` y la definición del agente.
3. Un issue, un KPI verificable, un descriptor; sin evidencia no se cierra.
4. Usa `kaizen-voice` para comentar en público: Observación → Evidencia → Impacto → Propuesta → Pregunta.
5. Ejecuta `kaizen-learn guard` antes de implementar para recordar fallos conocidos.
6. Vigila Grafana; si algo muestra rojo, repórtalo y decide con `source_ids`.
7. No relajes la línea base ni saltes hooks; los cambios de autonomía exigen ADR humano.

---

## Piloto recomendado

**Auditoría exprés de cumplimiento DGI/Ley 81 sobre un proyecto propio**, 7 días. Equipos `cumplimiento` + `plataforma`, KPI: **0 normas sin fuente verificada** y primer reporte en <24 h. Arranca con `kaizen-start start` y una instrucción por WhatsApp: *«Audita DGI y datos personales y envíame el resumen con fuentes»*.

---

## Documentación y fuentes

- Gobernanza: `.kaizen/RULES.md`, `.kaizen/security/SECURITY-RULES.md`, `.kaizen/loop/LOOP.md`
- Organización: `.kaizen/org/ORGANIZATION.md`, `AGENT_SCHEMA.md`, `CONSENSUS.md`, `OUTSOURCING.md`
- Equipo: `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md`, `DECISIONES.md`, `OWNER.md`
- Calidad: `docs/kaizen/org/EVALUACION.md`, `APRENDIZAJE.md`, `CATALOGO-TECNOLOGIAS.md`, `MONITOREO-PROYECTOS.md`
- Decisiones: `docs/kaizen/adr/` (15 ADRs: 0001–0010 y 0016–0020; los ADR-0011..0015 siguen **propuestos** por arquitectura y sin escribir, ver outbox)
- Normativa verificada: `.kaizen/org/knowledge/SOURCES.md` (PA-001, PA-003, ISO-001, NIST-001, AICPA-001, OWASP-001)
- Release: https://github.com/angelnereira/kaizen-swarm/releases/tag/v1.2.0

> Los borradores que originaron este README están en `docs/kaizen/org/README_DRAFT_*.md` (estética, coherencia y crítica) y sus hallazgos en `.kaizen/loop/outbox/`.




## Invocación multi-cliente, investigación y desbloqueo

`kaizen-invoke detect|invoke|all` usa la sintaxis real de OpenCode (`run --agent`), Claude Code (`-p --agent`) y Codex (`exec`), con dry-run por defecto. `deep-researcher`, `capability-scout` y `task-unblocker` investigan externamente con fuentes verificadas, descubren capacidades con valor y diagnostican tareas colgadas con rollback; `kaizen-scout research|skills|tools|unblock` los delega (ADR-0036).

## Comunidad de desarrollo y automejora

Seis agentes trabajan en el repositorio como comunidad: `maintainer-proactivo` detecta mejoras con evidencia, `issue-reporter` redacta borradores, `pr-builder` prepara PRs en ramas `kaizen/*`, `consensus-facilitator` modera 2 turnos con memorial, `retador-decisiones` exige contraejemplos y `self-improvement` convierte lecciones en mejoras con ratchet. `kaizen-devcommunity propose|issue|comment|pr|consensus|retro|check` es dry-run por defecto; ningún agente aprueba ni hace push a `main` (ADR-0035).

## Orquestación dinámica y jerarquía por tarea

Cinco agentes separan **planificar** (`planificador-trabajo`), **repartir** (`orquestador-equipo`), **definir rangos/RACI** (`raci-dinamico`), **verificar** (`supervisor-ejecucion`) y **preparar la aprobación** (`aprobador-trabajo`). `scripts/kaizen-orquesta hierarchy|plan|raci|asignar|estado|check` produce un plan de 7 pasos y una matriz R/A/C/I/V/H con rangos R0–R5: el humano (R0) siempre es A y firma; ningún agente aprueba. La jerarquía es por tarea, con `correlation_id`, ack y recursión acotada por `KAZEN_AGENT_DEPTH` (ADR-0034).

## Copiloto de arquitectura e ingeniería

Nueve agentes derivados del paquete v0.1: ocho especialistas (`work-intake`, `arch-assessment`, `tech-evaluation`, `poc-design`, `adr-author`, `secure-review`, `knowledge-capture`, `jira-planner`) y el súper agente `arch-copilot`, que clasifica y delega. `scripts/kaizen-arch skills|route|invoke|check` carga solo el skill relevante e invoca con `--dry-run` por defecto (`KZ_DRY_RUN=0` para ejecutar). Los comentarios remotos de arquitectura se enrutan al copiloto (ADR-0033). El ZIP se registra con SHA-256 como PA-ARCHCOP-001; sus políticas internas no están validadas y no se usan como norma.
