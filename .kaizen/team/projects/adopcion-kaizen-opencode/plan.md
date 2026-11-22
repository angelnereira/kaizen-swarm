# Plan — adopcion-kaizen-opencode

## KPI verificable
0 normas sin `source_id` verificado y `scripts/kaizen check` en verde.

## Fuentes verificadas
PA-001 (Gaceta Ley 81), PA-003 (Gaceta Ley 23), ISO-001 (ISO 27001:2022),
NIST-001 (CSF 2.0), AICPA-001 (SOC 2), OWASP-001 (ASVS/Top 10).

## Tareas del escuadrón mínimo
1. `qa` — plan de pruebas y criterios reproducibles.
2. `architect` — límites, contratos y ADR de adopción.
3. `security` — rieles, secretos y supresiones.
4. `knowledge-curator` — índice de fuentes y digests.
5. `dx` — ergonomía de instalación y feedback.
6. `verificador-evidencias` — validación de `source_ids` y puerta `verify`.

## Puertas
Sin push, sin PR, sin commits en `dev`, sin lectura de `.env`.
No avanzar a `deliver`/`verify` mientras `scripts/kaizen check` esté en rojo.
