# ADR-0023: autonomía de push, ramas remotas y corrección proactiva

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La regla original impedía a los agentes hacer push o abrir PR: «el orquestador lo hace». Eso los obligaba a esperar intervención humana para publicar correcciones, lo que contradice el objetivo de una comunidad proactiva y autónoma. El Presidente pidió explícitamente eliminar esa limitación.

## Decisión
1. Los agentes **pueden** hacer commit, push a ramas `kaizen/*` y abrir PRs por iniciativa propia, dentro de su issue/proyecto y con descriptor/evidencia.
2. Pueden corregir errores detectados y volver a verificar sin esperar una orden humana, registrando cada cambio con `source_ids` o comando reproducible (K-10).
3. Se mantiene la prohibición absoluta de **push directo a `main`** y de fusión sin gates: la protección de rama y CI siguen decidiendo.
4. Se mantienen los límites que no dependen de este repositorio: secretos (S-1/S-2), seguridad y autenticación, pagos/gasto, decisiones regulatorias o legales finales y modificar las propias reglas sin ADR (L-3/L-4).
5. El orquestador (`kaizen-swarm finalize --publish`, `kaizen-start`) sigue existiendo como vía auditada, pero ya no es el único canal.

## Alternativas consideradas
- Mantener el orquestador como único publicador: descartado por el responsable; reducía la proactividad.
- Quitar también la protección de `main`: descartado; sería un riesgo innecesario y no fue solicitado.

## Consecuencias
- Positivas: correcciones y mejoras fluyen sin esperar; menor tiempo entre detección y arreglo.
- Negativas: más escrituras remotas; se mitiga con ramas `kaizen/*`, descriptors, evidencia, CI y trazabilidad en el outbox.

## Cómo se verificará
- `bash tests/run.sh` y que los prompts/agentes generados ya no contengan la prohibición de push.
- Un ciclo de `kaizen-runtime work` debe permitir corregir y publicar en rama `kaizen/*`, nunca en `main`.
