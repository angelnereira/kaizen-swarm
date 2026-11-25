## Resumen
El entorno explícito prevalece sobre bridge.env/notify.env para el modo BSP y el HMAC del buzón.

## Componente afectado
`scripts/kaizen-whatsapp`.

## Tipo de cambio
- [x] bug

## Plan de prueba
- `bash tests/run.sh` (292 pruebas)
- `scripts/kaizen check`

## Impacto en calidad (ratchet)
- Cobertura: igual; Advertencias: igual; Deuda: igual.

## Motivo
Un bridge.env vacío sobrescribía el HMAC inyectado por la prueba y hacía fallar `kaizen-whatsapp check`. Se capturan los valores explícitos antes de leer archivos locales y se restauran después. Sin secretos impresos.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
