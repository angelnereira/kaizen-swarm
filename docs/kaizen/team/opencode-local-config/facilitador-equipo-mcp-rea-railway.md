# Verificación de MCP rea y railway sin credenciales en el repo

- `correlation_id`: `OLC-MCP-003`
- Agente: `facilitador-equipo` (autoridad `resource`: ordena el proceso, no resuelve seguridad)
- Fecha de la evidencia: 2026-11-23T03:13:53Z
- `source_ids` verificados (`.kaizen/org/knowledge/SOURCES.md`, fecha de corte 2026-11-21):
  `TOOL-001`, `ISO-001`, `NIST-001`, `OWASP-001`, `AICPA-001`
- Referencias internas: ADR-0024 (instalación no invasiva, comunidad en la máquina), ADR-0009
  (resultados de REA = dato no confiable), `.kaizen/security/SECURITY-RULES.md` S-1/S-2/S-15.
- No se leyó ni imprimió ninguna credencial, `.env`, clave privada ni variable de entorno.
  La identidad devuelta por `railway.whoami` (correo/nombre/usuario) se descartó y **no** se
  versiona (L-12, REG-EV-06).

## Observación

Los servidores MCP `rea` y `railway` están declarados y habilitados en la configuración
**global** de la máquina, responden a llamadas de solo lectura, y **no** existe bloqueo `mcp`
ni credencial alguna en la configuración del repo. El KPI «MCP rea activo» queda verificado;
se añade `railway` como segundo servidor activo y se cierra la brecha de evidencia que solo
documentaba `rea`.

## Evidencia (comandos ejecutados, salida real, sin secretos)

1. Configuración del repo — solo claves estructurales, sin `mcp`:

   ```
   $ jq -r 'keys[]' opencode.json
   $schema
   instructions
   permissions

   $ jq -r 'if has("mcp") then "MCP_PRESENT" else "MCP_ABSENT" end' opencode.json
   MCP_ABSENT

   $ jq '[paths(scalars) as $p | ($p|map(tostring)|join(".")) | select(test("token|api.?key|secret|pass|auth|credential";"i"))] | length' opencode.json
   0
   ```

2. Configuración global — estado de los servidores (valores sensibles redactados por clave;
   no apareció ninguna clave `token`/`apiKey`/`secret`/`password`/`auth`):

   ```
   $ jq '<redacción por clave sensible> .mcp | ...' ~/.config/opencode/opencode.json
   {
     "servers": {
       "railway": { "type": "local", "command": ["…/railway-mcp"], "disabled": false },
       "rea":     { "type": "local", "command": ["…/node", "…/rea", "mcp"],
                    "disabled": false, "environment": { "JAVA_HOME": "…" } }
     }
   }
   ```

3. Liveness post-reinicio — llamadas de solo lectura, sin efectos y sin PII registrada:

   ```
   tools.rea.binary_session({})      → fulfilled, keys=[result], 18548 bytes, sin error
   tools.railway.whoami({})          → fulfilled (autenticado), 241 bytes, sin error;
                                       identidad omitida de la evidencia (L-12)
   ```

   La misma comprobación se ejecutó antes y después del reinicio del servidor, con idéntico
   resultado. Los servicios están activos y `railway` además autenticado.

   Revalidación independiente tras el segundo reinicio (sin PII; nombres de proyectos omitidos):

   ```
   tools.railway["list-projects"]({})            → fulfilled, 3 proyectos, sin error
   tools.rea.binary_session({detail:"summary"})  → fulfilled, sin error;
       server_identity.package = rea-agents@6.10.1
       catalog.counts.mcp_tools = 263
       catalog.digests.tools_sha256 = ce195f28c7f286af9ee1a4174e5a9d54eda490e95a913c48592316740bd34bf1
       client = opencode 2.3.2, protocolo 2025-11-25
   $ jq '.mcp.servers | map_values({disabled})' ~/.config/opencode/opencode.json
       railway.disabled = false ; rea.disabled = false
   ```

4. Cero credenciales versionadas en el repo:

   ```
   $ for pat in 'ghp_[A-Za-z0-9]' 'sk-[A-Za-z0-9]{20}' 'AKIA[0-9A-Z]{16}' \
                 '-----BEGIN [A-Z ]*PRIVATE KEY-----' 'Bearer [A-Za-z0-9._-]{20}'; do
         git grep -Il -E "$pat" -- . ':(exclude)*.md' | wc -l
     done
   0   0   0   0   0        # archivos coincide por patrón

   $ git ls-files | grep -E '(^|/)(\.env|\.env\..*|.*\.pem|.*\.key|id_rsa.*)$' | wc -l
   0

   Nota de precisión: el patrón anterior solo cubre `.env`/`.pem`/`.key`/`id_rsa*` como
   nombre de archivo. Un barrido más amplio por sufijo `.env` muestra **16 archivos
   `*.env` versionados** (p. ej. `.kaizen/finops/tokens.env`, `.kaizen/team/notify.env`).
   **No se leyó ninguno** (S-1/S-2/S-12). Su existencia ya fue reportada por `security` en
   `.kaizen/loop/outbox/repo-tokens-env-tracked.md`. Por tanto el hallazgo verificable es
   «0 patrones de secreto en archivos versionados examinados y 0 claves en la config MCP»,
   **no** «0 credenciales en todo el repo»: el inventario de `.env` es competencia de
   `security` y sigue abierto.

   $ git ls-files | grep -icE '(^|/)[^/]*\.env(\.[^/]*)?$'
   16

   $ grep -nE '\.env|\.pem|\.key|id_rsa' .gitignore
   2:.env   3:.env.*   4:!example.env   5:*.pem   6:*.key   7:id_rsa*
   ```

5. Puertas del orquestador en verde:

   ```
   $ bash scripts/kaizen-team verify opencode-local-config
   [kaizen-team] verify: todas las decisiones tienen fuentes verificadas        (rc=0)

   $ bash scripts/kaizen-team sync opencode-local-config
   proyecto=opencode-local-config etapa=execute | acuses pendientes=0 | tareas abiertas=5 | decisiones verificadas=0 | bloqueadas=0
   ```

## Impacto

- KPI confirmado: `rea` activo, `railway` activo y autenticado, 0 secretos embebidos en la
  configuración MCP y 0 patrones de secreto en archivos versionados examinados. Queda abierto
  el inventario de 16 archivos `*.env` versionados (sin leer), competencia de `security`.
  `source_ids` verificados; `kaizen-team verify` en verde (REG-EV-01).
- No se abrió ni se modificó ningún archivo de credenciales. La configuración global guarda
  los binarios y `JAVA_HOME` en la máquina (ADR-0024); el repo solo declara permisos.
- Hallazgos reportados por S-11 sin silenciarlos: `kaizen-meta drift` falla con `TypeError`
  (`kaizen-meta-drift-crash`) y el reinicio movió la sesión a otra rama
  (`session-branch-drift-restart`). Ninguno bloquea esta verificación; el segundo se solventó
  restaurando la rama propia antes de escribir.
- Concurrencia detectada: una segunda instancia de `facilitador-equipo` ejecutó el mismo
  `OLC-MCP-003` y produjo `facilitador-equipo-mcp-verificacion.md` + handoff acusado
  `H-1795403779907` a `dx`. Se conservan ambos handoffs (el de esta evidencia,
  `H-1795403633267078428`, y el de la otra instancia) y se reporta el choque en
  `.kaizen/loop/outbox/facilitador-duplicate-work-OLC-MCP-003.md`. No se borró ni se sobrescribió
  la evidencia ajena; `verificador-evidencias` decide la fuente canónica en la tarea 5.

## Propuesta

- Dejar la tarea 3 en `ready` con dueño, lease, `deadline`, `source_ids` y esta evidencia.
- Publicar handoff a `verificador-evidencias` (`H-1795403633267078428`, `OLC-MCP-003`) con
  sobre completo y acusarlo, para que integre el dictamen final de configuración local.
- No cerrar la tarea 3: el dictamen final (tarea 5) sigue en manos de `verificador-evidencias`.

## Pregunta

¿Confirma `verificador-evidencias` que esta evidencia cierra el KPI de MCP sin fuentes
`pending`/`conflict` y puede incorporarse al dictamen final sin nuevo dictamen de `security`?
