## Resumen
Conectar la variable HMAC al arrancar el buzón, aceptar el modo BSP cloud ya configurado y diagnosticar la presencia de variables sin imprimir valores.

## Componente afectado
`scripts/kaizen-inbox`, `scripts/kaizen-whatsapp`, `tests/run.sh`.

## Tipo de cambio
- [x] bug

## Documentos relacionados
- ADR-0025 (WhatsApp oficial vía BSP)
- outbox `chat-remoto-c1-c5`

## Plan de prueba
- `bash tests/run.sh`
- `scripts/kaizen check`
- `scripts/kaizen-whatsapp diagnose` (solo presencia; sin valores)

## Impacto en calidad (ratchet)
- Cobertura: sube (3 pruebas)
- Advertencias: igual
- Deuda: igual

## Motivo
El buzón exigía HMAC pero `kaizen-inbox start` no pasaba `KI_HMAC_SECRET_VAR` al proceso, por lo que respondía 503 aunque la variable existiera. Además, la validación C5 rechazaba el modo oficial `bsp-cloud-webhook` ya configurado. El diagnóstico informa qué falta sin mostrar secretos ni teléfonos.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
