# ADR-0030: resolución de la recurrencia detectada por meta-auditoría

Estado: aceptado | Reanuda el loop tras stop-the-line
Fecha: 2026-11-23T03:16:21.170668+00:00
Aprobado por: Angel Nereira ("procede" y "hazlo por mi" en sesión)

## Contexto
La meta-auditoría disparó `stop-the-line` por clases repetidas: verificacion (5), otros (12), infra (4) y la clase nueva `cifras` (afirmaciones de cifras/evidencia no reproducibles, p. ej. H-3 del manifest de SOURCES.md). Este ADR y el baseline se perdieron en un reinicio del servidor y se recrean con fecha actual.

## Decisión
1. Aceptar las clases como deuda conocida y visible en outbox (S-11), no borrar hallazgos.
2. Reanudar el loop con `kaizen-loop resume` para permitir verificar las correcciones pedidas por El Presidente.
3. `cifras` entra en vigilancia reforzada: toda cifra citada debe acompañarse del comando real y su salida; una nueva repetición posterior a esta fecha vuelve a disparar stop-the-line.
4. Se corrige el fallo fail-open de `kaizen-meta drift` (TypeError por orden incorrecto de `sh`), que impedía reportar deriva Git.

## Alternativas consideradas
- Mantener PAUSE: descartado; bloquea la verificación exigida.
- Borrar hallazgos para bajar contadores: descartado; viola S-10/S-11.

## Consecuencias
- Positivas: operación reanudada con deuda visible y limite claro.
- Negativas: contadores altos; se compensa con baseline fechado.

## Cómo se verificará
- `kaizen-loop status` -> pausa: no.
- `kaizen-meta drift` sin traceback.
- Relanzamiento de equipos con cierre verificado por evidencia.
