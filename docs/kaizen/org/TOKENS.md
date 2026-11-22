# Economía de tokens del equipo

```bash
scripts/kaizen-tokens record --agent qa --task "revisión" --input 1200 --output 300 --cost 0.012 --saved 400 --model opencode/hy4-flash-free
scripts/kaizen-tokens snapshot
scripts/kaizen-tokens report
scripts/kaizen-tokens check
```

El ledger `.kaizen/finops/token-ledger.jsonl` es local y auditable. Cada línea guarda agente, tarea, modelo, tokens de entrada/salida, coste reportado y ahorro **estimado**.

## Ahorro estimado

No es una medición de "tokens que dejamos de gastar": es la diferencia entre el consumo observado y una línea base configurable (`KT_BASELINE_INPUT`, `KT_BASELINE_OUTPUT`) por tarea. Se presenta como estimación y nunca se usa para afirmar eficiencia sin datos previos (K-10).

## Optimización recomendada

1. Usar `opencode/hy4-flash-free` para coordinación, revisión y tareas de bajo riesgo.
2. Reducir el prompt a brief + contrato + rol, sin historial innecesario.
3. Agrupar preguntas del buzón en un ciclo (batch) antes de delegar.
4. Recortar capturas de pantalla a la región relevante (Computer Use).
5. Consultar `kaizen-learn guard` antes de reintentar un fallo conocido.
6. Si un agente repite tareas sin mejorar el KPI, escalar a humano en vez de seguir gastando.

## Trabajo continuo y capacidad

- `kaizen-runtime work <equipo>` coge la siguiente tarea pendiente al terminar una; si no hay, las propone desde el outbox con evidencia.
- `KT_MAX_TASKS_PER_AGENT=3` evita bucles infinitos sin supervisión.
- `KT_MAX_AGENTS=12` y `KT_MAX_PARALLEL=6` limitan el árbol de delegación; el runtime reduce paralelismo si se excede.
- Los paneles de Grafana muestran `kaizen_tokens_input_total`, `kaizen_tokens_output_total`, `kaizen_tokens_cost_usd` y `kaizen_tokens_saved_estimate`.

Ver ADR-0021.
