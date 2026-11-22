# ADR-0019: colaboración de alto rendimiento, voz pública y memoria de fallos

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La comunidad ya tiene roles, RACI y evidencia, pero faltaban tres cosas de un equipo real de alto rendimiento: (1) roles de pensamiento en la decisión (quién reta, quién escribe), (2) habilidad de redactar/comentar/juzgar en público con criterio, y (3) memoria explícita de fallos para no repetirlos.

## Decisión
1. `.kaizen/team/DECISIONES.md`: roles de pensamiento (dueño, analista, retador, escriba, facilitador, humano), regla del retador obligatorio, secuencia en 7 pasos y normas de participación pública.
2. `.kaizen/org/knowledge/business/VOZ-Y-DOCUMENTACION.md` y `scripts/kaizen-voice`: plantillas y validación para comentarios de issue, dictámenes de revisión y memoriales de decisión, con prohibición de secretos, datos explotables y afirmaciones sin evidencia.
3. `scripts/kaizen-learn known add|guard`: registro de fallos conocidos con síntoma, fix y regla de evitación; `guard` se ejecuta **antes de implementar** para recordar fallos que coinciden con palabras clave.
4. Las 45 definiciones incluyen `## Voz y participación` y `## Memoria de fallos`.
5. Proceso `decision` ampliado con etapas `challenge` (retador) y `memorial` + `verify` (humano).
6. Equipo `decisiones` con modelo `opencode/hy4-flash-free`, creado para deliberar sin coste.

## Alternativas consideradas
- Decisiones por mayoría simple: descartado; sin retador ni memorial se pierde el contraejemplo.
- Guardar fallos solo en el diario: descartado; no se consultan antes de implementar.

## Consecuencias
- Positivas: decisions con contraejemplo registrado, comentarios accionables, y prevención activa de fallos repetidos.
- Negativas: más pasos por decisión; se compensa con plantillas y validación automática (`kaizen-voice check`).

## Límites
El retador no bloquea sin evidencia; el humano sigue siendo A en decisiones sensibles (L-3/L-4). Los fallos conocidos no sustituyen a la verificación ni autorizan cambios de autonomía.

## Cómo se verificará
- `bash tests/run.sh` cubre `kaizen-voice`, `known add/guard`, roles de decisión y equipo con modelo fijado.
- `kaizen-gov check` valida las etapas `challenge`/`memorial`.
