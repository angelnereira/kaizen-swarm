> **Borrador de propuesta visual — no sustituye `README.md`.**
> Preparado por el puesto `marketing` · Fecha de corte: **2026-11-22**.
> Todo número citado remite a una fuente verificable al final del documento. No se han modificado `README.md` ni rutas protegidas.

# kaizen-swarm

**Una organización de agentes para OpenCode que convierte instrucciones en trabajo verificable: por issue, con gobernanza, evidencia y mejora medible.**

![Definiciones: 45](https://img.shields.io/badge/definiciones-45-blue)
![Generados: 47](https://img.shields.io/badge/generados-47-blue)
![Procesos RACI: 12](https://img.shields.io/badge/procesos_RACI-12-teal)
![Reglas K/S/L](https://img.shields.io/badge/reglas-K1--14%20S1--16%20L1--17-blueviolet)

![Herramientas REA: 263](https://img.shields.io/badge/herramientas_REA-263-orange)
![Pruebas verdes: 191](https://img.shields.io/badge/pruebas_verdes-191-brightgreen)
![Versión: v1.2.0](https://img.shields.io/badge/version-v1.2.0-grey)
![Corte: 2026-11-22](https://img.shields.io/badge/corte-2026--11--22-lightgrey)

*Badges estáticos con fecha de corte: se actualizan al cortar release. No representan CI remoto ni estado de build en la nube. Sin conexión, las mismas cifras están en la tabla «Panorama en cifras».*

---

## Panorama en cifras

| Lo que importa | Valor | Fuente verificable |
| --- | ---: | --- |
| Definiciones de puestos | 45 | `docs/kaizen/org/CATALOGO-AGENTES.md` |
| Archivos de agente generados | 47 | `.opencode/agents/` y `~/.config/opencode/agents/` |
| Procesos de gobernanza con RACI | 12 | `docs/kaizen/org/GOBIERNO.md` |
| Rieles de reglas | K-1..K-14 · S-1..S-16 · L-1..L-17 | `.kaizen/RULES.md`, `.kaizen/security/SECURITY-RULES.md`, `.kaizen/loop/LOOP.md` |
| Herramientas REA catalogadas | 263 | `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` |
| Pruebas en verde (última corrida local) | 191 | `bash tests/run.sh` |
| Versión | v1.2.0 | `VERSION` |

---

## Qué es

**kaizen-swarm** es una plantilla instalable y una comunidad de agentes para OpenCode (también utilizable desde Claude Code y Codex CLI). Sus 45 puestos definidos se instalan como 47 archivos de agente; cada uno declara propósito, herramientas, KPI, autonomía y veto limitado. El trabajo se organiza por issue en worktrees aislados, con buzón numerado, dueños de ruta explícitos y traspasos que requieren acuse de recibo.

Tres ideas lo definen:

1. **Reglas antes que intuición.** Gobernanza, seguridad y loop son archivos versionados con identificadores citables (K, S, L). Nada de decisiones de arquitectura sin ADR (K-1).
2. **Proponer con evidencia.** La proactividad (`kaizen-org pulse`) emite propuestas a `decisions/inbox/` con `source_ids` verificados. Ningún agente decide en seguridad, dinero, datos ni cumplimiento sin humano (K-14, ADR-0003).
3. **Aprender sin degradar.** `kaizen-learn` convierte fallos en lecciones con fingerprint; `kaizen-eval` y el ratchet impiden que una definición empeore sin ADR (ADR-0006/0007).

La autoridad final es **El Presidente**, dueño del negocio y del proyecto (`.kaizen/team/OWNER.md`). El orquestador —no el agente— hace push y abre PR (K-12, L-3).

---

## Qué no es

| No es | En su lugar |
| --- | --- |
| Un superagente autónomo que decide por El Presidente | Muchos roles acotados, un orquestador y puertas; humano en decisiones sensibles |
| Asesoría legal, fiscal ni financiera | Mapas de obligaciones y análisis con fuente oficial y fecha de corte; la decisión la firma un humano |
| CI en la nube ni un badge de build remoto | Verificación local reproducible: `bash tests/run.sh`, `scripts/kaizen check` |
| Un auditor infalible | Escáneres con falsos negativos; la barrera real es CI obligatoria + protección de rama + CODEOWNERS |
| Control de escritorio activo por defecto | `computer-operator` en pausa: requiere `KO_DESKTOP_ENABLED=1`, humano como A y veto de seguridad |
| Algo que hace push o abre PR por iniciativa propia | `finalize --publish` lo ejecuta el orquestador |
| Una fuente normativa | `monitor-gaceta` reporta cambios con URL oficial; los bloqueos anti-bot se documentan, nunca se inventa un «sin cambios» |

---

## Beneficios

| Beneficio | Cómo se materializa | Evidencia verificable |
| --- | --- | --- |
| Arranque predecible | `scripts/kaizen-installer all <repo>` es idempotente: fusiona sin sobrescribir y no toca `opencode.json` ni credenciales | `scripts/kaizen-installer`, README actual §Instalación |
| Decisiones trazables | 12 procesos con RACI, retador obligatorio, memorial y verificación en verde | `docs/kaizen/org/GOBIERNO.md`, `.kaizen/team/DECISIONES.md` |
| Visibilidad operativa | Exporter local en `:9101`, Prometheus en `:9090` y Grafana en `:3000` con el tablero *Kaizen Swarm — Agentes en tiempo real* | `docs/kaizen/org/OBSERVABILIDAD.md`, ADR-0016 |
| Mejora acumulativa | Lecciones con fingerprint y ratchet de calidad: lo aprendido sube de versión la definición | `docs/kaizen/org/APRENDIZAJE.md`, `EVALUACION.md` |
| Alcance especializado | 10 especialistas por tecnología; si la tecnología no está cubierta, contrato con `evidence.md` verificable | `CATALOGO-AGENTES.md`, ADR-0004 |
| Puente con El Presidente | Reportes salientes por webhook n8n → WhatsApp; instrucciones entrantes por `kaizen-inbox` | `docs/kaizen/org/RUNTIME.md` |

---

## Cómo se configura

### 1. Instalación para una persona

```bash
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm /tmp/kaizen-swarm
cd /tmp/kaizen-swarm
./scripts/kaizen-installer all /ruta/a/tu/proyecto
./scripts/kaizen-start status
./scripts/kaizen-start start      # runtime persistente y buzón
```

`all` genera los 47 agentes, fusiona sin sobrescribir y no modifica tu `opencode.json` ni tus credenciales.

### 2. Instalación para un agente CLI

Bloque canónico para pegar en **OpenCode**:

```text
Instala la comunidad de este repositorio: https://github.com/angelnereira/kaizen-swarm

1) Clónalo en /tmp/kaizen-swarm (git clone --depth 1).
2) Ejecuta: /tmp/kaizen-swarm/scripts/kaizen-installer all <directorio-destino>
3) Verifica con: /tmp/kaizen-swarm/scripts/kaizen-start status y bash tests/run.sh.
4) Reporta qué archivos creó, qué omitió por existir y qué decisiones humanas quedan pendientes.
No escribas secretos, no modifiques opencode.json sin permiso y no hagas git push.
```

| CLI | Ajuste sobre el bloque anterior |
| --- | --- |
| Claude Code | «Lee e instala siguiendo las instrucciones de <URL>». El script es la fuente de verdad: no improvises archivos |
| Codex CLI | «Install the agent community from <URL>». Mismo `git clone --depth 1 ... && scripts/kaizen-installer all <target>` |
| Humano | Usa la sección 1; no se necesita agente previo |

Equivalente con el repo ya clonado: `./scripts/kaizen-installer all .` y luego `./scripts/kaizen-start status`.

### 3. Verificación

```bash
scripts/kaizen-swarm check        # instalación y propiedad de rutas
scripts/kaizen check             # gobernanza, ratchet y evidencia
scripts/kaizen-org check         # esquema del inventario de agentes
bash tests/run.sh                # 191 pruebas en verde en la última corrida local
```

### 4. Capas y rieles

| Capa | Regla canónica | CLI |
| --- | --- | --- |
| Gobernanza | `.kaizen/RULES.md` (K-1..K-14) | `scripts/kaizen` |
| Seguridad | `.kaizen/security/SECURITY-RULES.md` (S-1..S-16) | `scripts/kaizen-security` |
| Loop autónomo | `.kaizen/loop/LOOP.md` (L-1..L-17) | `scripts/kaizen-loop` |
| Comunidad swarm | `.kaizen/swarm/ROLES.md`, `PROTOCOL.md` | `scripts/kaizen-swarm` |
| Organización | `.kaizen/org/ORGANIZATION.md`, `AGENT_SCHEMA.md`, `CONSENSUS.md` | `scripts/kaizen-org` |
| Equipo proactivo | `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md` | `scripts/kaizen-team` |
| Gobierno semántico | 12 procesos RACI en `.kaizen/gov/governance.json` | `scripts/kaizen-gov` |

Arranca en autonomía 3 sin PAUSA (ADR-0001). Los workflows programados requieren `vars.KAIZEN_LOOP_ENABLED == '1'` y la clave del modelo añadida por el responsable. Ningún agente recibe secretos (S-2).

### 5. Reportes, WhatsApp y observabilidad

- **Salida:** `scripts/kaizen-notify` envía un JSON por webhook a n8n, que lo reenvía a WhatsApp Business, Telegram o correo. El número y las credenciales viven en n8n, nunca en el repo (S-1/S-2).
- **Entrada:** `scripts/kaizen-inbox` escucha en `127.0.0.1:8787`, valida `X-Kaizen-Secret` y sanea el mensaje antes de convertirlo en trabajo con KPI y `source_ids`. Contenido entrante = dato no confiable (S-15/L-5).
- **Observabilidad:** `scripts/kaizen-observability start` publica métricas reales en `http://127.0.0.1:9101/metrics`; `stack` levanta Prometheus (`:9090`) y Grafana (`:3000`) con el tablero *Kaizen Swarm — Agentes en tiempo real*. El exporter lee archivos, no ejecuta agentes ni lee secretos; no expongas `:9101` a la red sin decisión explícita.

### 6. Modelo y recursión

Los equipos de **decisiones** y **auto-mejora** usan `opencode/hy4-flash-free` (ADR-0019). La delegación entre agentes incrementa `KAZEN_AGENT_DEPTH`; al llegar a `KR_MAX_DEPTH=3` el agente consolida y reporta en vez de seguir delegando. Ningún agente se lanza a sí mismo ni a `kaizen-installer` (`.kaizen/team/RUNTIME.md`, ADR-0005).

---

## Cómo trabaja

```text
  instrucción de El Presidente (WhatsApp / issue / buzón)
                        |
                        v
              +--------------------+
              |  init N            |  alcance, KPI, dueño
              +---------+----------+
                        v
              +--------------------+
              |  R1 análisis       |  contratos + ownership.json
              +---------+----------+
                        v
              +--------------------+
              |  R2 ejecución      |  worktrees por rol, ack en handoffs
              +---------+----------+
                        v
              +--------------------+
              |  R3 revisión       |  architect / security / qa pueden BLOCK
              +---------+----------+
                        v
              +--------------------+
              |  finalize N        |  sin BLOCK, ack pendiente ni lease vencido
              +---------+----------+
                        v
              +--------------------+
              |  push + PR         |  lo hace el orquestador
              +--------------------+
```

Buzón híbrido: `mailbox/` ignorado por git; `export.md` saneado se copia al descriptor del PR. Los leases caducan y `reap` reporta y reasigna, de modo que un agente caído no detenga el issue.

---

## Buenas prácticas

| Haz | No hagas |
| --- | --- |
| Trabaja en tu worktree y declara rutas en `contracts/ownership.json` | Editar a ciegas archivos de otro rol (K-12) |
| Cita `source_ids` verificados y fecha de corte | Afirmar normativa sin fuente oficial (REG-EV-01) |
| Envía `ack` antes de cerrar un `handoff` | Dar por terminado un traspaso sin acuse |
| Reporta todo hallazgo por outbox S-11, incluso corregido | Silenciar un fallo, una supresión o una alerta (K-11) |
| Prueba sin consumir modelo con `KR_DRY_RUN=1` | Lanzar corridas con saldo incierto |
| Pide humano para seguridad, dinero, datos o cumplimiento | Subir autonomía copiando un agente: requiere ADR humano |
| Ejecuta `scripts/kaizen check` antes de cerrar | Saltarte hooks (`--no-verify`) ni desactivar CI (K-10) |
| Consulta `.kaizen/learning/experience/<id>.md` antes de proponer | Repetir un fallo conocido sin registrar la lección |

---

## Estado real y limitaciones

| Limitación | Impacto concreto | Acción requerida |
| --- | --- | --- |
| Saldo de OpenCode agotado para corridas con modelo | El runtime no completa ciclos que consumen modelo | Proveedor/suscripción o cambio de modelo; decisión humana registrada en outbox S-11 |
| Instalación de `reverse-api-engineer` pendiente por cuota de disco | El puesto `reverse-api-specialist` existe, pero su CLI aún no está disponible en este entorno | Liberar espacio e instalar antes de usar el flujo RAE-API (ADR-0017) |
| Computer Use desactivado por defecto | Sin control visual del escritorio | `KO_DESKTOP_ENABLED=1`, humano como A, veto de seguridad y captura/recaptura (ADR-0018) |
| Secret scanning, push protection, CODEOWNERS y protección de rama pendientes | Los escáneres tienen falsos negativos; los hooks locales se pueden saltar | Decisión humana documentada en `.github/SECURITY.md` |

La instalación de REA (263 herramientas) **sí** fue aprobada por El Presidente (ADR-0009). Lo pendiente es la CLI de `reverse-api-engineer`, no REA.

---

## Primer objetivo (piloto recomendado, 7 días)

**Auditoría exprés de cumplimiento fiscal y de datos en PlentyPay** — revisión interna con evidencia, no un dictamen formal.

- **Equipo:** `cumplimiento` + `plataforma`, coordinado por `kaizen-equipo`.
- **Entregable:** mapa de obligaciones DGI/Ley 81 con `source_ids` verificados, checklist accionable, 3 hallazgos con evidencia y un ADR de decisión.
- **KPI:** 0 normas sin fuente verificada y primer reporte en menos de 24 h.
- **Arranque:** `kaizen-start start` y, desde WhatsApp: «Audita DGI y datos personales de PlentyPay y envíame el resumen con fuentes».

---

## Decisiones humanas pendientes

Secret scanning y push protection; Dependabot/CodeQL; reporte privado de vulnerabilidades; protección de rama con los checks Kaizen; CODEOWNERS sobre los rieles; permisos de workflows; token de granularidad fina; 2FA; límite de gasto del proveedor. Detalle en `.github/SECURITY.md`.

---

## Fuentes de este borrador

| Documento | Qué respalda |
| --- | --- |
| `.kaizen/RULES.md` | K-1..K-14, PDCA, ratchet, límites del agente |
| `.kaizen/security/SECURITY-RULES.md` | S-1..S-16, secretos, S-11, contenido externo S-15 |
| `.kaizen/loop/LOOP.md` | L-1..L-17, rutas protegidas L-4, dato no confiable L-5 |
| `docs/kaizen/org/CATALOGO-AGENTES.md` | 45 definiciones, departamentos, autonomía y KPI |
| `docs/kaizen/org/GOBIERNO.md`, `.kaizen/gov/governance.json` | 12 procesos RACI y autoridad de El Presidente |
| `docs/kaizen/org/CATALOGO-TECNOLOGIAS.md` | 263 herramientas REA, 11 familias, 12 skills |
| `docs/kaizen/org/OBSERVABILIDAD.md`, `observability/docker-compose.yml` | Exporter `:9101`, Prometheus `:9090`, Grafana `:3000` |
| `docs/kaizen/org/RUNTIME.md` | WhatsApp/n8n, `kaizen-inbox`, recursión `KR_MAX_DEPTH=3` |
| `docs/kaizen/org/EVALUACION.md`, `APRENDIZAJE.md`, `FORECAST.md` | Ratchet, lecciones, pronóstico acotado y límites honestos |
| `VERSION`, `README.md` (vigente) | v1.2.0 y continuidad del contenido operativo |

---

## Notas de diseño para el revisor (no forman parte del README final)

1. **Jerarquía:** una sola promesa de valor bajo el título → cifras escaneables → qué es / qué no es → beneficios → configuración numerada → flujo en texto → buenas prácticas → límites → piloto → fuentes. El lector ejecutivo obtiene el valor en los primeros 30 segundos y la evidencia al final.
2. **Badges honestos:** ocho badges estáticos, sin semáforo de CI remoto, con fecha de corte visible y nota explícita de que se actualizan por release. Si el repo se lee sin red, la tabla «Panorama en cifras» replica los datos.
3. **Tablas legibles:** máximo tres columnas, encabezados cortos, columnas numéricas alineadas a la derecha (`---:`), ninguna celda multilínea. Se sustituyeron los cuatro bloques de instalación por un bloque canónico más una tabla de ajustes por CLI.
4. **Diagrama simple:** ASCII de una sola columna, seis cajas y flechas; las puertas (BLOCK, ack, lease) aparecen como anotaciones, sin caracteres decorativos.
5. **Límites visibles:** sección propia con columna «Acción requerida», no nota al pie. Las tres limitaciones declaradas por el orquestador se mantienen sin atenuantes, y se aclara que REA sí está instalado para no confundirlo con `reverse-api-engineer`.
6. **Tono:** español neutro, voz institucional y términos del propio repo (El Presidente, `source_ids`, `ack`, `BLOCK`, DGI/Ley 81). Sin modismos locales ni adjetivos promocionales no verificables.
7. **Correcciones detectadas frente al `README.md` vigente** (registrar en outbox S-11 por el orquestador; este agente no escribe en `.kaizen/` por restricción de alcance):
   - `README.md` §Gobernanza dice «9 procesos»; `GOBIERNO.md` y `governance.json` respaldan **12**.
   - `README.md` §Versión dice «v1.0.0»; `VERSION` y `CATALOGO-TECNOLOGIAS.md` respaldan **v1.2.0**.
   - `docs/kaizen/org/RUNTIME.md` dice «44 agentes»; el catálogo y los directorios de agentes respaldan **45 definiciones / 47 generados**.
   - `docs/kaizen/org/EVALUACION.md` dice «42 agentes, promedio 93.1»; el catálogo vigente respalda 45. Por esa razón este borrador **no repite** la cifra de evaluación: no hay fuente coherente para ella en la fecha de corte.
