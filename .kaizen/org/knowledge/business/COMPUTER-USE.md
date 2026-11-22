# Computer Use en esta máquina (capacidad gobernada)

Fuente: instrucciones provistas por El Presidente (2026-11-22) + verificación local real. Contenido externo = dato no confiable (S-15/L-5).

## 1. Entorno detectado (verificado)

| Dato | Valor real |
| --- | --- |
| Sistema | Linux 7.0.0-44-generic |
| `DISPLAY` | `:0` (Xwayland activo) |
| `WAYLAND_DISPLAY` | `wayland-0`, `XDG_SESSION_TYPE=wayland` |
| Geometría X11 | 3072×1728 (`xdotool getdisplaygeometry`) |
| `xdotool` | disponible (`/usr/bin/xdotool`) |
| `import` (ImageMagick) | disponible (`/usr/bin/import`) |
| `scrot`, `wmctrl`, `uvx` | **no disponibles** |
| Ventana activa | no reportada (`_NET_ACTIVE_WINDOW` falla): entorno sin gestor / sin foco |

**Conclusión:** el servo listo `computer-control-mcp` no se puede ejecutar con `uvx` aquí. La vía viable es un tool local con `xdotool` + `import` sobre Xwayland, con gate explícito. En Wayland puro, PyAutoGUI/xdotool suelen bloquearse por seguridad: verificar antes de cada acción.

## 2. Implementación local

`scripts/kaizen-desktop` expone: `check`, `capture <archivo>`, `click <x> <y>`, `type <texto>`, `key <tecla>`, `windows`, `status`.

- Requiere `KO_DESKTOP_ENABLED=1` (por defecto 0).
- `type` solo acepta caracteres seguros; `key` tiene allowlist (Return, Escape, Tab, space, ctrl/alt/shift+…).
- Cada acción se registra en `.kaizen/team/runtime/desktop.log` sin secretos.
- Antes de clic/escritura, **capturar y verificar visualmente** (bucle: capturar → analizar → actuar → recapturar).

## 3. Reglas duras

1. El proceso `computer_use` exige **humano como A** y veto de `security` (ADR-0018).
2. Sin credenciales: no escribir en campos de password/tokens; no capturar pantallas con datos sensibles.
3. Sin evasión de controles; el agente se detiene y escala si la UI pide autorización.
4. Consumo de contexto: cada captura consume tokens; usar modelo multimodal y recortar región cuando sea posible.
5. Acciones reversibles y verificadas: después de cada acción se recaptura para confirmar.

## 4. Opción MCP (solo si se instala `uvx`/servidor)

Plantilla NO aplicada a `opencode.json` global (requiere aprobación explícita adicional):

```json
{
  "mcp": {
    "servers": {
      "computer-control": {
        "type": "local",
        "command": ["uvx", "computer-control-mcp@latest"],
        "codemode": false
      }
    }
  }
}
```

Si se habilita, dar permiso solo al agente `computer-operator` (no a todos) y mantener `codemode:false` para que las herramientas de clic/teclado estén disponibles directamente.

## 5. Estado

Capacidad **documentada y gobernada**; tool local implementado pero **desactivado** (`KO_DESKTOP_ENABLED=0`). Para activarla, el humano aprueba el proceso `computer_use`, fija la variable y reinicia el agente `computer-operator` (hoy `paused`).
