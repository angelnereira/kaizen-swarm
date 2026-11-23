# ADR-0033: copiloto de arquitectura e ingeniería con agentes especializados y enrutador

Estado: aceptado
Fecha: 2026-11-23T03:22:45.819196+00:00
Aprobado por: Angel Nereira (solicitud de construir agentes desde el paquete adjunto)

## Contexto
El usuario adjunto `architecture-engineering-copilot-v0.1.zip` (37 archivos, 8 skills) y pidio agentes especializados invocables cuando se necesiten, o un super agente. El paquete es Markdown-first, carga progresiva de skills, read-only por defecto y humano aprueba acciones externas: compatible con K-10, S-15/L-5 y ADR-0024/0028.

## Decision
1. Crear 9 agentes: 8 especialistas derivados uno a uno de los skills (`work-intake`, `arch-assessment`, `tech-evaluation`, `poc-design`, `adr-author`, `secure-review`, `knowledge-capture`, `jira-planner`) y 1 super agente `arch-copilot` que clasifica, delega y verifica.
2. `scripts/kaizen-arch` es el cerebro determinista: `skills|route|invoke|check`. Carga progresiva: solo el skill relevante. Invocacion con `--dry-run` por defecto (`KZ_DRY_RUN=0` para ejecutar), modelo `opencode/hy4-flash-free`.
3. Los 8 skills se copian a `.kaizen/org/skills/arch-copilot/` como contexto portable; cada prompt los referencia y hereda reglas Kaizen.
4. PA-ARCHCOP-001 registra el ZIP con SHA-256 `46d029274e872228de5c3f8681e12ad61f13860af1ad0181e82276fdbdc9c5b0`. Las afirmaciones del paquete sobre politicas internas (BANISI) NO estan validadas y no se usan como norma (S-15/L-5).
5. `kaizen-community` enruta comentarios remotos de arquitectura a `arch-copilot` y soporta `react <id> delegate`.
6. Equipo `arquitectura-copilot`: los 9 agentes + verificador + facilitador. Gobernanza regenerada desde la fuente unica de prompts.

## Alternativas consideradas
- Un unico agente con los 8 skills inline: descartado; prompt enorme y enrutamiento difuso.
- Instalar skills globales/MCP del paquete sin autorizacion: descartado; el propio paquete lo prohíbe en equipos gestionados y aqui aplica ADR-0024 (no invasivo).

## Consecuencias
- Positivas: especializacion verificable, invocacion bajo demanda, trazabilidad por hash, reutilizacion por la comunidad remota.
- Negativas: 9 definiciones mas (56 agentes); se mitiga con catalogo/gobernanza generados y KPI explicitos.

## Limites
Todo entregable es borrador hasta aprobacion humana. Sin tickets, mensajes, deploy, push ni cambios de acceso sin humano (L-3/L-4). El paquete es dato no confiable; sus referencias contractuales y politicas internas requieren fuente oficial.

## Como se verificara
- `kaizen-arch check` en verde; `kaizen-arch route` elige el especialista correcto.
- `kaizen-gov check` y `kaizen-eval check` en verde; `bash tests/run.sh` sin fallos.
