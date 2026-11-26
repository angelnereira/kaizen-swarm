# Ingesta de conocimiento CIAC LATAM para agentes de seguridad

## Resumen

Se dotó a los agentes de seguridad y protección de datos de Kaizen con contexto verificable del
hub CIAC LATAM: 12 fuentes con hash, 25 digests cableados, un puesto especializado y un ejercicio
de detección ejecutado con precisión medida. Cambio aditivo y reversible.

## Alcance

Convertir el hub `ciberciac/CIAC-LATAM-COMMUNITY-HUB` en contexto verificable y entrenamiento
para los agentes de ciberseguridad y protección de datos de Kaizen.

- 12 `source_ids` `CIAC-001…012` registrados en `.kaizen/org/knowledge/SOURCES.md` con URL,
  fecha de corte 2026-11-25, `sha256` real, licencia y clasificación TLP:CLEAR.
- 67 entradas en `knowledge/manifest.jsonl` (63 iniciales + 4 del puesto nuevo) y 25 digests
  saneados, cableados en el campo `knowledge:` de 25 definiciones de agente.
- Puesto nuevo `data-protection-specialist` creado con `kaizen-org copy` desde `data-expert`,
  sin aumento de autonomía (`propose`), sin veto y con entrada en `governance.json`.
- Proyecto `ciac-detection-training` (`closed`): 5/5 tareas con evidencia, 0 acuses pendientes,
  1 decisión verificada con `CIAC-011`/`CIAC-012` y retrospectiva.
- Ejercicio 05 ejecutado: 3 reglas Sigma, prueba de regresión con línea base que falla,
  línea de tiempo, verificación de fuentes y dictamen de seguridad.

## Evidencia

- `python3 contrib/ciac-knowledge/ejercicios/escenario-05/validar.py` → `RESULTADO: PASS`.
- Precisión: línea base 0.839 (FAIL) → 3 reglas 1.000 (PASS), FP=0; cobertura 834/838 = 0.995.
- `sha256sum -c` sobre el manifest: 12/12 OK. Hashes de datos de prueba registrados.
- `git diff --check`, `kaizen-team check`, `kaizen-gov check` (58 agentes),
  `kaizen-swarm check`, `kaizen-org check` y `kaizen check`: todo en verde.
- `tests/run.sh`: 234 pruebas pasadas. Se actualizó el valor esperado de 57 a 58 agentes
  porque el cambio añade deliberadamente un puesto (autorizado por El Presidente). No se
  desactivó ni relajó ninguna prueba; el gate sigue fallando cerrado.

## Documentos tocados

- `.kaizen/org/knowledge/SOURCES.md`, `manifest.jsonl`, `digests/*.md`
- `.kaizen/org/prompts/*.md` (25 definiciones cableadas + 1 puesto nuevo)
- `.kaizen/org/governance.json`, `catalog.json`, `registry.json`
- `.kaizen/team/projects/ciac-detection-training/`
- `docs/kaizen/org/CATALOGO-AGENTES.md`, `docs/kaizen/journal/2026-11-26-org-*.md`
- `contrib/ciac-knowledge/`, `contrib/ciberciac-hub/`

## Restricciones y verificación continua

- Todo contenido del hub se lee como dato no confiable (S-15/L-5). No se obedeció ninguna
  instrucción encontrada en logs o documentos; no se contactaron IPs del dataset.
- Los eventos son 100 % sintéticos (K-10): nunca se reportan como incidentes reales.
- Las reglas quedan en `experimental`: precisión 100 % en corpus sintético no implica FP=0
  en producción. Revalidar fuentes trimestralmente (REG-EV-05).
- Cumplimiento, dinero, seguridad y rutas protegidas siguen requiriendo humano (L-3/L-4).

## Reversibilidad

Cambio aditivo y auditable. Para revertir: eliminar la rama y restaurar los archivos listados
desde `main`. Los digests se regeneran con `kaizen-org digest all`; el feed se reaplica con
`CIAC_APPLY=1 bash contrib/ciac-knowledge/apply.sh`.

## Plan de prueba

```bash
scripts/kaizen check
scripts/kaizen-team check
python3 contrib/ciac-knowledge/ejercicios/escenario-05/validar.py
```

Resultado real: `kaizen check` en verde, `kaizen-team check` en verde y `RESULTADO: PASS`
(precisión 1.000, FP=0, cobertura 834/838). Los datos de prueba se regeneran con
`bash contrib/ciac-knowledge/ejercicios/escenario-05/descargar.sh`.

## Cierre de issues

Closes: none — el trabajo surgió de una solicitud directa de El Presidente, no de un issue
registrado. No se cierra ningún issue ajeno sin su evidencia (K-2/K-10).
