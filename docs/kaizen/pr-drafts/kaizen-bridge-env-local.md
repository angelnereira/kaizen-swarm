## Resumen
Leer la configuración sensible del canal remoto desde un archivo local fuera del repo y exportar el HMAC al proceso del buzón.

## Componente afectado
`scripts/kaizen-inbox`, `scripts/kaizen-notify`, `scripts/kaizen-whatsapp`, `tests/run.sh`.

## Tipo de cambio
- [x] enhancement
- [x] bug

## Documentos relacionados
- ADR-0025 (WhatsApp oficial vía BSP)
- outbox `chat-remoto-c1-c5`

## Plan de prueba
- `bash tests/run.sh`
- `scripts/kaizen check`
- `scripts/kaizen-whatsapp diagnose` (solo presencia, sin valores)

## Impacto en calidad (ratchet)
- Cobertura: sube (1 prueba)
- Advertencias: igual
- Deuda: igual

## Motivo
El diagnóstico mostró que los nombres de las variables están declarados pero los valores no existen en el entorno. Los scripts ahora leen `~/.config/kaizen-swarm/bridge.env` (modo 600, fuera del repo) y el buzón exporta explícitamente el HMAC al proceso Python. Ningún valor se imprime ni se versiona (S-1/S-2).

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
