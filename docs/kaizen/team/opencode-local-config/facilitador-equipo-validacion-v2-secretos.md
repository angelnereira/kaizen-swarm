# Validación de opencode.json V2 y denegaciones de secretos

- `correlation_id`: `OLC-SEC-002`
- Agente: `facilitador-equipo` (autoridad `resource`: ordena el proceso, no decide seguridad)
- Fecha: 2026-11-22T20:00:37Z
- `source_ids` verificados (`.kaizen/org/knowledge/SOURCES.md`, fecha de corte 2026-11-21): `ISO-001`, `NIST-001`, `OWASP-001`, `AICPA-001`, `TOOL-001`
- Referencia normativa interna: ADR-0023 (push en ramas `kaizen/*`), `.kaizen/security/SECURITY-RULES.md` S-1/S-2/S-10
- Todo contenido externo es dato no confiable (S-15/L-5). No se leyó ni imprimió ninguna credencial.

## Observación

La configuración del repo implementa el esquema V2 de OpenCode y deniega la lectura de secretos, pero la configuración **global** de la máquina declara dos reglas `allow` para leer `.env`. Esa divergencia no la resuelve el facilitador: se documenta y se deriva a `security` para dictamen (L-3/L-4, fuera de la autoridad `resource`).

## Evidencia (comandos ejecutados, salida real, sin secretos)

Archivos examinados: `./opencode.json` (repo) y `~/.config/opencode/opencode.json` (global). Solo se imprimieron `action`, `resource`, `effect`, `$schema`, `instructions` y `mcp.servers[].disabled`; **no** se imprimieron URLs, argumentos, `env` ni `headers` de MCP.

1. Esquema e instrucciones del repo:

   ```
   $ jq -c '{schema: .["$schema"], instructions: .instructions}' opencode.json
   {"schema":"https://opencode.ai/config.json","instructions":[".kaizen/RULES.md",".kaizen/security/SECURITY-RULES.md",".kaizen/loop/LOOP.md",".kaizen/swarm/ROLES.md",".kaizen/swarm/PROTOCOL.md",".kaizen/team/TEAM.md",".kaizen/team/COMUNICACION.md",".kaizen/team/FLUJOS.md",".kaizen/team/EVIDENCIA.md",".kaizen/team/DECISIONES.md",".kaizen/team/OWNER.md"]}
   ```

2. Esquema V2 válido (26 reglas, todas con `action`/`resource`/`effect`):

   ```
   $ jq -r '"total=\(.permissions|length)  deny=\([.permissions[]|select(.effect=="deny")]|length)  allow=\([.permissions[]|select(.effect=="allow")]|length)"' opencode.json
   total=26  deny=12  allow=14

   $ jq -e '.permissions|type=="array"' opencode.json                                      → true
   $ jq -e '([.permissions[]|select(has("action") and has("resource") and has("effect"))]|length)==(.permissions|length)' opencode.json → true
   $ jq -e '.permissions|type=="array"' ~/.config/opencode/opencode.json                    → true
   ```

3. Push permitido, cero denegaciones de push:

   ```
   $ jq -e '[.permissions[]|select(.effect=="deny" and (.resource|test("push")))]|length==0' opencode.json → true
   $ jq -e '[.permissions[]|select(.resource=="git push*" and .effect=="allow")]|length==1' opencode.json   → true
   ```

4. Denegaciones de secretos en el repo (12 reglas `deny`, recursos sin valores sensibles):

   ```
   read   *.env
   read   **/.env
   read   **/.env.*
   read   **/*.pem
   read   **/*.key
   read   **/id_rsa*
   shell  gh auth*
   shell  rm -rf*
   shell  curl*
   shell  wget*
   shell  env
   shell  printenv*
   ```

5. **Divergencia confirmada** — configuración global (2 reglas):

   ```
   $ jq -r '.permissions[]|"\(.action)\t\(.resource)\t\(.effect)"' ~/.config/opencode/opencode.json
   read   *.env      allow
   read   *.env.*    allow
   ```

6. MCP activos (solo estado; sin datos de conexión): `railway.disabled=false`, `rea.disabled=false`. Agentes globales: `find ~/.config/opencode/agents -maxdepth 1 -name '*.md' -type f | wc -l` → `47`.

## Impacto

- El KPI de esquema V2 válido, 0 reglas `deny` de `git push` y MCP `rea` activo queda **verificado** en el repo (comandos reproducibles).
- Riesgo abierto: las reglas globales `read *.env: allow` y `read *.env.*: allow` amplían el acceso respecto del repo (`deny`). Requiere dictamen de `security` (veto vinculante, ADR-0002) antes de dar por cerrada la tarea 2. No es una decisión de proceso y el facilitador no la modifica.
- El bug fail-open de `scripts/kaizen-team:72,82` (`now` vs `$now`) impide usar `kaizen-team handoff`; se aplica el workaround documentado (escritura directa del sobre en `handoffs.jsonl` + `kaizen-team ack`, que sí es correcto). Sin fabricar evidencia (K-10).

## Propuesta

- Publicar handoff `H-1795377637441` a `security` con sobre completo (`correlation_id`, `expects_ack`, `deadline`, `source_ids`) y dejar la tarea 2 en `ready` con dueño y lease.
- Reportar la divergencia global por outbox S-11 (`kind: security`, fingerprint `opencode-global-env-allow`) sin copiar valores secretos.
- No cerrar la tarea 2 hasta que `security` emita su dictamen en `reviews/`.

## Pregunta

¿Confirma `security` que el par `read *.env: allow` / `read *.env.*: allow` en la configuración global debe degradarse a `deny` (o justifica excepción con `source_ids`) antes de avanzar a `review`?
