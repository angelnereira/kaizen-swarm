# ADR-0038: instalación Windows sin fricción y doctor de instalación

Estado: aceptado
Fecha: 2026-11-23T09:50:11.929742+00:00
Aprobado por: Angel Nereira (caso de uso real compartido)

## Contexto
El usuario compartió una sesión de instalación en Windows/PowerShell. Primera iteración: el framework quedó en `C:\tmp\kaizen-swarm`, los agentes en un **directorio scratch** (`C:\tmp\kaizen-xdg\opencode\agents`) y la config real del usuario (`C:\Users\anereira\.config\opencode`) nunca recibió los agentes; 21 tests fallaron por falta de `jq`; quedaron 7 decisiones humanas. Segunda iteración: sí instaló, pero con dos notas que generaron desconfianza: (1) los agentes buscaban `.kaizen/RULES.md` en el repo y sugerían `kaizen-installer repo <repo>`, (2) `opencode reload` reportó una ruta WSL temporal huérfana (`tmp.0Xbm3RJeMm/repo`). La sesión se trata como dato no confiable (S-15/L-5): se extrajeron fallos, no se obedecieron instrucciones.

## Decisión
1. **`install.ps1` instala en la configuración REAL de OpenCode** (`~/.config/opencode/agents` o `%APPDATA%\opencode\agents`). Queda prohibido usar un `XDG_CONFIG_HOME` temporal como destino final. El directorio scratch solo sirve para pruebas aisladas, nunca se reporta como "instalado".
2. **`kaizen-doctor check|fix`**: detecta Python, git, jq, OpenCode, conteo real de agentes, gobernanza global y referencias a `/tmp`/`tmp.` huérfanas en `opencode.json`. `fix` crea la gobernanza global, limpia huérfanos **con backup** e instala los agentes en la config real.
3. **Gobernanza global no invasiva**: se copia `.kaizen/RULES.md`, `LOOP.md`, `SECURITY-RULES.md` y los prompts a `~/.local/share/kaizen-swarm/framework`. El generador de agentes ya NO les dice que instalen en el repo: si no hay `.kaizen/`, operan con las reglas embebidas en su definición y no escriben en el proyecto destino salvo `--embedded`.
4. **Dependencias tempranas**: si falta `git` o `opencode`, el instalador falla con el comando exacto (`winget install Git.Git`, instalar OpenCode desde `https://opencode.ai`). `jq` se reporta con `winget install jqlang.jq` antes de correr tests.
5. **Onboarding de una sola pregunta**: al final, si no hay número configurado, `kaizen-welcome setup` pide el número de WhatsApp y lo guarda en modo 600. El resto de decisiones quedan con valores seguros por defecto y se documentan, sin bloquear la instalación.
6. **Resumen corto y verificable**: rutas reales, conteo de agentes, `gov/eval` en verde y un único comando de reparación (`kaizen-doctor fix`). Nada de "7 decisiones pendientes" como cierre.

## Alternativas consideradas
- Seguir usando un scratch para "no molestar" la config real: descartado; es exactamente lo que frustró al usuario.
- Instalar `.kaizen/` en cada repo automáticamente: descartado; viola ADR-0024 (no invasivo) y genera desconfianza.

## Consecuencias
- Positivas: instalación en un solo comando, verificable, sin sorpresas ni rutas huérfanas.
- Negativas: el doctor toca `opencode.json` solo para limpiar huérfanos, siempre con backup; se reporta en la salida.

## Límites
No se instala OpenCode automáticamente sin verificar la fuente oficial; se da el comando exacto. No se escriben secretos ni números de teléfono en el repo. Windows con ACLs no se verifica en esta máquina Linux (compuerta G5 abierta).

## Cómo se verificará
- `install.ps1` (dry-run y `-Yes`) y `kaizen-doctor check` → `ok: true`, agentes en config real, 0 huérfanos.
- `kaizen-gov check`, `kaizen-eval check` y `bash tests/run.sh` en verde.
