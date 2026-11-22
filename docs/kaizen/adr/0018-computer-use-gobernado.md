# ADR-0018: Computer Use gobernado sobre X11

Estado: aceptado (herramienta implementada y **desactivada** por defecto)
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
Cuando la configuración disponible no alcanza, un agente puede necesitar operar la computadora como lo haría el usuario: ver pantalla, mover ratón y escribir. El entorno real es Linux con `DISPLAY=:0` sobre Wayland/Xwayland, `xdotool` e `import` disponibles, sin `uvx`, `scrot` ni `wmctrl`.

## Decisión
1. `scripts/kaizen-desktop` implementa `capture`, `click`, `type`, `key`, `windows` y `check` sobre X11, con gate `KO_DESKTOP_ENABLED=1` (por defecto 0), allowlist de teclas, caracteres seguros para `type` y registro en `desktop.log` sin secretos.
2. Proceso `computer_use`: `authorize` (A: humano, V: seguridad) → `observe` → `act` (V: seguridad) → `verify` (A: humano) → `learn`.
3. Agente `computer-operator` en estado `paused` hasta aprobación explícita; equipo `desktop-ops` lo convoca solo cuando corresponda.
4. Bucle obligatorio: capturar → analizar → una acción → recapturar. Sin secuencias largas no supervisadas.
5. La plantilla de MCP `computer-control` queda **documentada pero no aplicada** a `opencode.json`: no hay `uvx` y el control total del escritorio exige aprobación adicional (S-15).

## Alternativas consideradas
- Instalar `computer-control-mcp` vía `uvx`: descartado; `uvx` no disponible y añade dependencias externas.
- Habilitar el control para todos los agentes: descartado; mínimo privilegio (S-6).

## Consecuencias
- Positivas: capacidad visual disponible de forma auditada y reversible.
- Negativas: consumo de contexto por captura y dependencia de Xwayland; se mitiga con recorte, una acción por ciclo y gate humano.

## Límites
Sin credenciales en pantalla, sin evasión de controles, sin datos personales en capturas versionadas. Wayland puro puede bloquear estas herramientas: verificar antes de cada acción.

## Cómo se verificará
- `kaizen-desktop status/check` en el entorno real; `kaizen-gov check` incluye el proceso con humano como A.
- Activación solo con `KO_DESKTOP_ENABLED=1` y aprobación registrada.
