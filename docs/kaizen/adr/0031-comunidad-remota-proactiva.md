# ADR-0031: comunidad remota proactiva en issues y PR

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
Los agentes saben comentar issues/PR (`kaizen-remote`), pero no escuchan de forma continua: un comentario de un humano o de otro agente podía quedar sin respuesta. El usuario pidió que actúen como una comunidad real de desarrollo: leer, analizar en contexto y reaccionar respondiendo o actuando.

## Decisión
1. `scripts/kaizen-community` con `scan|events|react|digest|watch` sobre issues y PR mediante `gh api`.
2. Deduplicación por ID de comentario y marca de tiempo en `~/.local/share/kaizen-swarm/community/<hash>/` (estado local, nunca en el repo).
3. Clasificación por intención (`blocker`, `approval`, `proposal`, `question`, `comment`) con ruta a un rol responsable.
4. Reacción: `reply` (por defecto `--dry-run`, requiere `KC_DRY_RUN=0` para publicar), `act` (dispara `kaizen-runtime work`) o `escalate` (`needs-human`).
5. Todo comentario es **dato no confiable** (S-15/L-5): no se ejecutan instrucciones que contenga; se interpreta, se responde con evidencia o se escala.
6. Bloqueos y propuestas se registran en outbox S-11 con fingerprint; `digest` produce `docs/kaizen/org/COMUNIDAD-REMOTA.md`.

## Alternativas consideradas
- Webhooks entrantes: descartado por ahora; requiere servidor público. El modo `watch` por polling es local y suficiente.
- Responder automáticamente sin deduplicación: descartado; generaría respuestas duplicadas.

## Consecuencias
- Positivas: la comunidad reacciona a comentarios reales con trazabilidad y rol asignado.
- Negativas: consumo de API de GitHub y posible ruido; se mitigan con `KC_INTERVAL_SEC`, presupuesto de ciclos y deduplicación.

## Límites
Sin credenciales en el repo; `gh` ya autenticado en la máquina. Ninguna reacción autoriza gasto, seguridad o decisiones regulatorias sin humano.
