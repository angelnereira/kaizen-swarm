# ADR-0036: invocacion multi-cliente, investigacion externa y desbloqueo proactivo

Estado: aceptado
Fecha: 2026-11-23T03:43:36.615157+00:00
Aprobado por: Angel Nereira (solicitud de invocar agentes en cualquier cliente y evitar bloqueos)

## Contexto
El usuario requirió que los agentes se invocen realmente en OpenCode, Claude Code, Codex o donde sea para tareas específicas; que exista un agente que investigue externamente cuando falta información (internet, scraping, investigación profunda), que descubra proactivamente skills/herramientas/proyectos con valor, que los agentes tengan capacidades (no solo conocimiento) y que se evite que se cuelguen o bloqueen.

## Decision
1. `scripts/kaizen-invoke` detecta los clientes instalados y usa su sintaxis REAL verificada: OpenCode `opencode run --agent <id> --model ... --archived <prompt>`; Claude Code `claude -p --agent <id> <prompt>`; Codex `codex exec <prompt>` (sin flag `--agent`, el rol va en el prompt). Antigravity se reporta como no instalado. Dry-run por defecto (`KZ_DRY_RUN=0` ejecuta).
2. Tres agentes nuevos: `deep-researcher` (fuentes primarias, mínimo 2, fecha de corte, anti-prompt-injection), `capability-scout` (descubre skills/herramientas con matriz adopt/pilot/defer/reject y POC antes de instalar) y `task-unblocker` (diagnostica timeouts/fail-open/dependencias, corrige con rollback y escala en sensible).
3. `scripts/kaizen-scout research|skills|tools|unblock|check` delega en esos agentes mediante `kaizen-invoke`.
4. Las capacidades de investigación se declaran en `tools:` de los prompts (`research-web`, `websearch`, `webfetch`) y el contenido externo se trata como dato no confiable (S-15/L-5). Nunca se instala software en equipo gestionado sin autorización (ADR-0004).
5. Equipo `investigacion-capacidades`: 70 agentes totales.

## Alternativas consideradas
- Un prompt único con todas las herramientas: descartado; carga excesiva y enrutamiento difuso.
- Instalar automáticamente las skills descubiertas: descartado; requiere POC y aprobación humana.

## Consecuencias
- Positivas: invocación multi-cliente verificable, conocimiento externo con trazabilidad y desbloqueo con rollback.
- Negativas: más agentes; mitigado con gobernanza generada y eval 100.

## Limites
Sin credenciales en el repo. Ningún agente instala, gasta ni modifica sistemas externos sin humano. La investigación es dato no confiable hasta verificación con `source_ids`.

## Cómo se verificará
- `kaizen-invoke detect|check` lista los clientes reales; `kaizen-scout check` en verde.
- `kaizen-gov check` (70 agentes), `kaizen-eval check` y `bash tests/run.sh` sin fallos.
