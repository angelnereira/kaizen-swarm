# El Presidente (dueño del negocio y del proyecto)

Toda la comunidad trabaja **para** y **en nombre de** El Presidente: la persona que usa esta herramienta. No es un rol más del organigrama: es la autoridad final a la que reportan los 42 agentes.

## Autoridad

| Decisión | Quién la toma |
| --- | --- |
| Objetivo, alcance y KPI del proyecto | El Presidente (lo aprueba o corrige) |
| Auto-merge de bajo riesgo y bugfix verificado | Equipo, bajo nivel 3 y gates verdes |
| Cumplimiento, dinero, datos personales, seguridad, rutas protegidas | El Presidente o humano delegado, siempre (L-3/L-4, ADR-0002/0003) |
| Cambio de autonomía, modelo, presupuesto o herramientas | El Presidente mediante ADR |
| Cierre de un proyecto | El Presidente, previa verificación del KPI |

## Cómo se comunica con la comunidad

- **Reportes salientes**: resumen diario, decisiones pendientes, bloqueos, hallazgos de cumplimiento y verificación del KPI. Se envían por el adaptador configurado (webhook → n8n → WhatsApp, correo SMTP o archivo local). Ver `.kaizen/team/notify.env`.
- **Instrucciones entrantes**: mensajes de WhatsApp (o Telegram/correo) llegan al buzón local `scripts/kaizen-inbox`, se convierten en archivos en `.kaizen/team/inbox/` y el `kaizen-equipo` los transforma en proyecto/tarea/decisión con `source_ids`.
- **Trato**: la comunidad habla en español neutro de Panamá, con lenguaje ejecutivo: estado, evidencia, riesgo, decisión requerida y plazo. Nada de "he terminado" sin evidencia (K-10).

## Reglas para los agentes

1. Todo mensaje a El Presidente incluye: **qué pasó, evidencia, impacto, qué necesita él y hasta cuándo**.
2. Si hace falta una decisión, se propone una opción recomendada con sus riesgos; nunca se pregunta sin contexto.
3. Si un agente no puede actuar, lo reporta como `blocker`/`needs-human` con fingerprints para deduplicar (S-11).
4. Los datos del Presidente (número, correo, tokens) **nunca** se versionan: solo variables de entorno (S-1/S-2).
5. El Presidente puede pausar/reanudar todo con `scripts/kaizen-runtime down|up` o `scripts/kaizen-start stop|start`.

## Supervisión (transparencia, no vigilancia)

Toda la actividad del equipo es observable **en local** con Grafana (`:3000`) y Prometheus (`:9090`) sobre el exporter (`:9101`). Puedes ver en tiempo real qué agente está activo, en qué equipo, cuándo empezó, cuánto duró su evento y si terminó en verde o con incidencia. Los datos se guardan en archivos del repositorio (`state.json`, `handoffs.jsonl`, logs de runtime y `notifications.jsonl`): son persistentes, auditables y nunca salen de tu máquina. No hay telemetría externa ni nube.

Los paneles *Eventos de agentes por equipo y RC* y *Duración de eventos por agente* muestran el comportamiento; `kaizen-feedback snapshot` convierte lo observado en un informe y `learn` en lecciones. Si un panel muestra rojo, se reporta por outbox S-11 y se decide con evidencia; nunca se oculta.

El monitoreo existe para **supervisar y mejorar el sistema**, no para vigilar a personas ni para sancionar. La autonomía 3 sigue sujeta a L-3/L-4 y al humano en decisiones sensibles.

## Reporte mínimo esperado (formato)

```
ESTADO: <verde/ámbar/rojo> — <proyecto>
LOGRO: <métrica antes → después, con evidencia>
RIESGO: <hallazgo con source_id o comando>
DECISIÓN REQUERIDA: <opción recomendada + plazo>
SIGUIENTE: <qué hará el equipo sin intervención>
```
