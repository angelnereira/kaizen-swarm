## Resumen
Chat interactivo con OpenCode en una ruta de proyecto dedicada (contexto, archivos e historial), con entrada saneada y guardrails contra instrucciones incrustadas.

## Componente afectado
Nuevo comando `scripts/chat-opencode`, ADR-0039, README, `docs/kaizen/INSTALACION.md`, `tests/run.sh`.

## Tipo de cambio
- [x] enhancement
- [x] documentation

## Documentos relacionados
- ADR-0024 (instalación no invasiva)
- ADR-0025 (WhatsApp oficial vía BSP)
- ADR-0032 (canal saliente con `resume:false`: explica el chat vacío)
- ADR-0037 (custodia de secretos; el chat nunca es canal de secretos)
- ADR-0039 (nuevo: chat como ruta-proyecto)
- `.kaizen/team/projects/chat-opencode-interactivo/{architect-chat-design,security-chat-review,ai-chat-guardrails}.md`

## Plan de prueba
- `bash tests/run.sh` (incluye 15 pruebas nuevas del chat)
- `scripts/kaizen check`
- `XDG_DATA_HOME=<tmp> scripts/chat-opencode init <slug> --agent qa`
- `scripts/chat-opencode path|message|context|ask|check <slug>`
- Revisión de que `ask` en dry-run emite `<chat_message>` y las reglas duras.

## Impacto en calidad (ratchet)
- Cobertura: sube (15 pruebas nuevas)
- Advertencias: igual
- Deuda (TODO/FIXME): igual

## Restricciones de gobernanza respetadas
- El comando se llama **`scripts/chat-opencode`**, no `scripts/kaizen-chat`: la ruta `scripts/kaizen*` está protegida (L-4) y el precedente es `notify-opencode` (ADR-0032). No se tocaron `kaizen-inbox.py`, `kaizen-runtime` ni `kaizen-workspace`.
- Todo mensaje se sanea con `kaizen-security redact` y se persiste como dato no confiable (S-15/L-5).
- El prompt delimita el mensaje con `<chat_message>` y prohíbe ejecutar comandos, pagos, push y decisiones sensibles sin humano (L-3/L-4).
- `ask` hace dry-run por defecto; `KZ_DRY_RUN=0` ejecuta `opencode run --agent` con el cwd en la ruta de la sesión.
- No se escriben números, tokens ni credenciales en la ruta, en el repo ni en la transcripción (S-1/S-2, ADR-0025).

## Criterios de salida que avanza
- La ruta `${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/chat/<slug>/` existe con `context/`, `files/`, `inbox/`, `transcript.md` y `state.json`.
- La sesión queda registrada como workspace externo no invasivo.
- `scripts/chat-opencode check <slug>` en verde y sin secretos.
- `scripts/kaizen check` en verde.

## Pendiente de humano
- Emparejamiento/opt-in del número de WhatsApp y cualquier credencial del canal remoto (nunca en el chat ni en el repo).
- Decidir si se habilita `resume:true` sobre la ruta estable de sesión de ADR-0032 para conversación persistente (el `ask` actual es one-shot, igual que el runtime).
- Firma de `security` sobre el contrato de permisos `external_directory` si se expone el agente fuera de la máquina.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [x] Pasa tests
- [x] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
