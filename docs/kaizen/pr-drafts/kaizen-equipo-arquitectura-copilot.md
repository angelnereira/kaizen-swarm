## Resumen
Copiloto de arquitectura, orquestación dinámica, comunidad de desarrollo, custodia de secretos y bridge de WhatsApp

## Componente afectado
kaizen-swarm (comunidad de agentes)

## Tipo de cambio
- [x] enhancement
- [ ] bug
- [ ] tech-debt
- [ ] documentation
- [ ] refactor

## Documentos relacionados
- ADR-0033 / ADR-0034 / ADR-0035 / ADR-0036 / ADR-0037 / ADR-0038

## Plan de prueba
- `scripts/kaizen-gov check`
- `scripts/kaizen-eval check`
- `bash tests/run.sh`

## Impacto en calidad (ratchet)
- Cobertura: sube
- Advertencias: igual
- Deuda técnica: igual

## Criterios de salida que avanza
- 80 agentes en verde y cero secretos en artefactos versionados.

## Aprendizaje
La instalación y la custodia de secretos mejoran cuando la verificación es temprana y no invasiva.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [x] Pasa tests
- [x] `scripts/kaizen check` en verde
- [x] Documentación actualizada
- [x] Línea base no empeora
