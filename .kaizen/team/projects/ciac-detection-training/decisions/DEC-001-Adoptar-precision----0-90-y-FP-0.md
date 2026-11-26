decision_id: DEC-001
topic: Adoptar precision >= 0.90 y FP=0 como gate de aceptacion de detecciones
source_ids: ["CIAC-011", "CIAC-012"]
retrieved: 2026-11-26T03:52:30Z
status: verified
human_owner: facilitador-equipo
---

# Decisión: Adoptar precision >= 0.90 y FP=0 como gate de aceptacion de detecciones

## Evidencia
- Fuentes verificadas: 2
- Fuentes rechazadas: ninguna

## Opciones y decisión
- **Opción A (recomendada, adoptada)**: exigir precisión ≥ 0.90 y FP = 0 contra `verdad-terreno.csv` antes de pasar una regla de `experimental` a `test`. Coste bajo, reversible (solo cambia el gate de aceptación).
- **Opción B (descartada)**: exigir precisión ≥ 0.95. Sin evidencia que la justifique en un corpus sintético de 1 535 eventos.
- **Decisión**: adoptar la Opción A. Sin veto abierto; `security` y `qa` conservan su derecho de `BLOCK` con evidencia (ADR-0002). Dueño: `facilitador-equipo`.

## Incertidumbre y escalado
- La precisión del 100 % observada en 4 reglas es sobre **datos sintéticos**; no garantiza FP = 0 en producción. Las reglas permanecen `experimental`.
- `CIAC-011` es 100 % ficticio (K-10): ningún hallazgo se reporta como incidente real.
- Si tras la fusión la métrica no mejora: `regression-suspect` + revert propuesto (L-9). Si un veto persiste 2 turnos: escalado a El Presidente.
- Revisión: próxima retrospectiva (K-9), conowner `facilitador-equipo` y fecha 2026-12-03.
