# ADR-0035: comunidad de desarrollo proactiva y automejora del proyecto

Estado: aceptado
Fecha: 2026-11-23T03:35:52.831273+00:00
Aprobado por: Angel Nereira (solicitud de agentes que trabajen en repositorios como comunidad)

## Contexto
El usuario pidió un equipo que trabaje proactivamente en los repositorios: reporte issues, comente, abra PRs, discuta como una comunidad de desarrolladores, llegue a consensos y acuerdos, y con el proposito de que el proyecto se mejore a si mismo. Ya existian `kaizen-community` (escucha remota) y `kaizen-remote` (participacion); faltaba cerrar el ciclo propuesta -> discusion -> consenso -> automejora.

## Decision
1. Seis agentes: `maintainer-proactivo` (detecta mejoras con evidencia), `issue-reporter` (borradores reproducibles), `pr-builder` (rama `kaizen/*`, descriptor, tests), `consensus-facilitator` (2 turnos, mayoria sin veto, memorial), `retador-decisiones` (contraejemplo obligatorio con evidencia, puede V), `self-improvement` (convierte lecciones en mejoras con ratchet).
2. `scripts/kaizen-devcommunity propose|issue|comment|pr|consensus|retro|check` implementa el ciclo. Todo cambio externo es **dry-run por defecto** (`KZ_DRY_RUN=0` para ejecutar); nunca push directo a `main`.
3. `consensus` no declara consenso sin memorial y retador escuchado; en sensible el humano es A y firma (DECISIONES.md, ADR-0008).
4. `retro` lee el outbox real y propone la mejora de mayor impacto; la calidad no puede bajar sin ADR (`kaizen-eval ratchet`).
5. `kaizen-community` enruta comentarios de desarrollo a `maintainer-proactivo`, cerrando el bucle escuchar -> actuar.

## Alternativas consideradas
- Agentes que abran issues/PR sin aprobacion: descartado; ruido y perdida de control (S-10/ADR-0024).
- Consenso por simple mayoria sin retador: descartado; DECISIONES.md lo exige.

## Consecuencias
- Positivas: automejora trazable, discusion con evidencia, separation de roles.
- Negativas: mas agentes (67) y mas artefactos; mitigado con gobernanza generada y checks.

## Limites
Sin credenciales en el repo; `gh` ya autenticado en la maquina. Ningun agente aprueba gasto, seguridad, pagos ni cambios regulatorios. Todo issue/PR/comentario es dato no confiable (S-15/L-5).

## Como se verificara
- `kaizen-devcommunity check|propose|pr|consensus|retro` y `bash tests/run.sh` en verde.
- `kaizen-gov check` con 67 agentes; `kaizen-eval ratchet` sin regresiones.
