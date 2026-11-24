## Resumen
Documentar comandos verificables de instalación, actualización y desinstalación para Linux, macOS y Windows.

## Componente afectado
Documentación de usuario (`docs/kaizen/`), README raíz.

## Tipo de cambio
- [x] documentation

## Documentos relacionados
- ADR-0024 (instalación no invasiva)
- ADR-0023 (autonomía de push, sin merges sin gates)
- K-7 (documentación viva)

## Plan de prueba
- `scripts/kaizen check --only descriptors`
- `scripts/kaizen check --only policy`
- `scripts/kaizen check --only ratchet`
- `bash tests/run.sh`
- Revisión manual de que cada bloque de comandos existe en `scripts/kaizen-installer`, `scripts/kaizen-release` y `install.ps1`.

## Impacto en calidad (ratchet)
- Cobertura: igual (documentación aditiva)
- Advertencias: igual
- Deuda (TODO/FIXME): igual

## Criterios de salida que avanza
- `docs/kaizen/INSTALACION.md` existe y cubre instalación, actualización y desinstalación en Linux/macOS y Windows.
- README enlaza la guía.
- `scripts/kaizen check` en verde en la rama.

## Aprendizaje (opcional)
No existe comando `uninstall` ni `update` dedicados: la actualización se hace reejecutando el instalador idempotente; la desinstalación se documenta como procedimiento manual con copia de seguridad y rutas explícitas.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila (no aplica; solo Markdown)
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
