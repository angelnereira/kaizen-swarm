# ADR-0029: dirección ejecutiva e incentivos ponderados

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La administración pidió decisiones de diseño, arquitectura y requerimientos funcionales con criterio ejecutivo, normativo, legal y financiero, además de un mecanismo que indique a los agentes cuándo actúan bien para sostenerse proactivos sin recompensar resultados sin evidencia.

## Decisión
1. Equipo `direccion-ejecutiva`: gerente, director de producto, analista de negocios, cumplimiento, legal corporativo, auditor de riesgos, finanzas, fiscal, verificador y facilitador. Modelo `opencode/hy4-flash-free`.
2. Nuevos puestos `legal-corporativo` (veto `scope`) y `auditor-riesgos` (veto `security`), con deber de citar `source_id` y escalar a humano.
3. Las decisiones sensibles siguen `DECISIONES.md`: retador obligatorio, memorial y **humano como A**. Finanzas y cumplimiento deben intervenir en toda decisión con impacto monetario o regulatorio.
4. Equipo `incentivos` y `scripts/kaizen-incentive`: score 0-100 ponderado — Evidencia 25, Cierre 25, Proactividad 20, Mejora 15, Eficiencia de tokens 10, Seguridad 5. Refuerzo ≥70, ajuste 40-69, freno <40.
5. El incentivo **no es una recompensa por output**: exige evidencia y cierre verificados; un agente con resultados sin evidencia puntúa bajo aunque haya producido mucho (K-10).

## Alternativas consideradas
- Incentivo por número de tareas: descartado; incentiva ruido.
- Decisiones solo técnicas: descartado; la administración requiere criterio legal, financiero y de negocio.

## Consecuencias
- Positivas: criterio ejecutivo trazable y retroalimentación continua consistente.
- Negativas: más roles en el board y una métrica más; se mitigan con RACI y dashboard local.

## Límites
Los dictámenes legales/financieros siguen siendo borradores hasta firma humana. Ningún incentivo autoriza gasto, seguridad o decisiones regulatorias sin humano (L-3/L-4).

## Cómo se verificará
- `kaizen-incentive check|dashboard` y `kaizen-gov check` en verde.
- `bash tests/run.sh` valida ambos equipos y el ledger de incentivos.
