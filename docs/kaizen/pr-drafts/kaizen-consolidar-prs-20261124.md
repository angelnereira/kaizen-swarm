## Resumen
Consolidar en una sola rama los PRs #3, #4 y #5 y publicar la guía de instalación, actualización y desinstalación para Linux y Windows.

## Componente afectado
Rama `main` (contenido agregado de cuatro ramas `kaizen/*` y `Debura`), documentación de usuario.

## Tipo de cambio
- [x] enhancement
- [x] documentation

## Documentos relacionados
- ADR-0023 (autonomía de push; nunca fusión sin gates)
- ADR-0024 (instalación no invasiva)
- ADR-0031, ADR-0032, ADR-0033, ADR-0034 (PR #3/#4)
- EVIDENCIA.md REG-EV-01 (fuentes verificadas)
- `.kaizen/team/projects/consolidar-prs-main/evidence-triage.md`

## Plan de prueba
- `scripts/kaizen check` (descriptores, política, formato, lint, tests, ratchet, seguridad, gobernanza)
- `bash tests/run.sh`
- `git grep -n -E '^(<<<<<<<|=======|>>>>>>>)' --exclude-dir=.git .` (sin marcadores de conflicto)
- `git merge-base --is-ancestor origin/kaizen/open-code-integration HEAD` y equivalente para #4 y #5
- Revisión de `.kaizen/org/knowledge/SOURCES.md`: ninguna fuente descartada; mapeo `OC-001/002` ↔ `OC-WEB-001/OC-CLI-001` queda pendiente de humano.

## Impacto en calidad (ratchet)
- Cobertura: igual o superior (se conservan las pruebas de los tres PRs)
- Advertencias: igual
- Deuda (TODO/FIXME): igual

## Criterios de salida que avanza
- Los HEADs de #3, #4 y #5 son ancestros de esta rama; #1 queda excluido por veto de seguridad.
- `scripts/kaizen check` en verde.
- `docs/kaizen/INSTALACION.md` presente y enlazada desde README.
- 0 marcadores de conflicto y 0 secretos detectados por el hook local.

## Decisiones y incidencias
- PR #1 excluido: secreto detectado por GitGuardian en `docker-compose.yml:42` (S-11 `gg-generic-password-docker-compose-ab9fd0e`) y suite en rojo (S-11 `pr1-tests-summary-mid-script`). Veto `security` vigente.
- Gates remotos en rojo por bloqueo de facturación de GitHub Actions (S-11 `gh-actions-billing-lock`): no son fallos de código; requiere re-run humano.
- Conflicto de `SOURCES.md` resuelto de forma aditiva: se conservan `TOOL-002`, `TOOL-002b`, `OC-001`, `OC-002`, `OC-WEB-001` y `OC-CLI-001`.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [x] Pasa tests
- [x] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
