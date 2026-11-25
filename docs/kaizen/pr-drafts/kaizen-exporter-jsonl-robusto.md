## Resumen
Hacer que el exporter de observabilidad lea handoffs.jsonl impresos en varias líneas, para que /metrics no se caiga.

## Componente afectado
`scripts/kaizen-exporter.py`, `tests/run.sh`.

## Tipo de cambio
- [x] bug

## Plan de prueba
- `bash tests/run.sh`
- `scripts/kaizen check`
- `GET /metrics` tras reiniciar el exporter

## Impacto en calidad (ratchet)
- Cobertura: sube (1 prueba); Advertencias: igual; Deuda: igual.

## Motivo
`collect()` hacía `json.loads` por línea y fallaba con `AttributeError: 'str' object has no attribute 'get'` cuando kaizen-team escribía objetos Pretty-printed. Sin /metrics no hay telemetría para evaluar agentes (K-6). Se usa `JSONDecoder.raw_decode` sobre el contenido completo y se filtran solo diccionarios.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
