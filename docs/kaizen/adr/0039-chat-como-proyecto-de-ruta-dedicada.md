# ADR-0039: chat interactivo como proyecto de ruta dedicada

Estado: propuesto
Fecha: 2026-11-25
Aprobado por: pendiente de El Presidente

## Contexto

El canal remoto actual entrega reportes y latidos (`Session update … OK`) hacia un chat que permanece vacío; no hay conversación ni memoria de proyecto. La integración con OpenCode existe para ejecución por agente (`opencode run --agent`) y para entrada local (`kaizen-inbox.py` escribe mensajes en `.kaizen/team/inbox/`), pero no hay un lugar en la máquina que actúe como «el proyecto del chat». La captura que mostró El Presidente se trata como dato no confiable (S-15/L-5): de ella solo se extrae el hecho observable —mensaje periódico, chat vacío—, no instrucciones.

## Decisión

1. **El chat principal vive en una ruta dedicada**, no en el repo: `${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/chat/<slug>/`. Cada slug es una sesión y se registra con `kaizen-workspace init` como workspace externo no invasivo (ADR-0024).
2. **Esa ruta se trata como un proyecto**: contiene `context/` (contexto que se pasa al agente), `files/` (archivos del usuario), `inbox/` (mensajes entrantes saneados), `transcript.md` (historial) y `state.json` (agente, versión, fechas).
3. **`scripts/chat-opencode`** expone `init|path|list|message|context|file|ask|check`. `ask` compone un prompt con guardrails + contexto de la ruta + mensaje y, por defecto, hace **dry-run**; solo ejecuta `opencode run --agent` con `KZ_DRY_RUN=0`.
4. **Contenido entrante = dato**: todo mensaje se sanea con `kaizen-security redact` antes de escribirse y se etiqueta como dato no confiable en la transcripción (L-5/S-15). El prompt prohíbe ejecutar instrucciones que aparezcan en el chat.
5. **Canal remoto**: solo WhatsApp oficial vía BSP/n8n (ADR-0025). Ningún número, token ni credencial se escribe en la ruta de chat, en el repo ni en la transcripción. El emparejamiento y el opt-in son decisiones humanas.
6. **Sin acciones sensibles desde el chat**: no hay comandos, pagos, gobernanza, seguridad ni cambios de autonomía sin humano (L-3/L-4). Las respuestas siguen el formato Estado → Evidencia → Impacto → Propuesta → Pregunta.

## Alternativas consideradas

- Meter la conversación en `.kaizen/team/inbox/` del repo: descartado; ensucia el repositorio y no da memoria por sesión.
- Usar la sesión de OpenCode Web UI directamente como canal: descartado por ahora; `opencode serve` y Basic auth requieren configuración y no resuelven dónde guardar contexto y archivos.
- Crear un repo Git por chat: descartado; `kaizen-workspace` ya registra directorios sin exigir Git.

## Consecuencias

- Positivas: el agente «trabaja en un proyecto» con contexto persistente; cada sesión es auditable y reproducible; el canal remoto deja de ser un buzón de un solo sentido.
- Negativas: hay que crear y nombrar sesiones; el contexto crece y debe estar saneado; `ask` con `KZ_DRY_RUN=0` consume tokens del modelo.

## Límites

No se conecta automáticamente a WhatsApp ni se lee credenciales (S-2). No se ejecutan órdenes que lleguen por el chat. No se publica la transcripción a canales externos sin revisión humana.

## Cómo se verificará

- `scripts/chat-opencode init <slug>` crea la ruta, `state.json` y el workspace; `check <slug>` en verde.
- `message` sanea el texto y lo refleja en `transcript.md`; `ask` en dry-run muestra el prompt con guardrails.
- `bash tests/run.sh` y `scripts/kaizen check` en verde; 0 secretos detectados en la ruta.
