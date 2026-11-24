# Economía de tokens del equipo

Generado: 2026-11-23T16:15:06Z | Fuente: `.kaizen/finops/token-ledger.jsonl`

## Datos observados

```
registros=20867
input_total=64100 output_total=9020
coste_total_usd=0.0100 ahorro_estimado=50
facilitador-equipo: tareas=20866 in=64000 out=9000 cost=0.0000 ahorro=0 eficiencia=0%
qa: tareas=1 in=100 out=20 cost=0.0100 ahorro=50 eficiencia=97%

```

## Optimización

- Usar `opencode/hy4-flash-free` para tareas de coordinación y revisión.
- Limitar comprehensión del prompt a brief + contrato + rol.
- Agrupar preguntas del buzón en un solo ciclo (batch) antes de delegar.
- Recortar capturas de pantalla a la región relevante (Computer Use).
- Si un agente repite fallo, consultar `kaizen-learn guard` antes de reintentar.

## Ahorro estimado
El ahorro es una **estimación** contra una línea base configurable (input/output por tarea). No se afirma ahorro real sin medición previa (K-10).
