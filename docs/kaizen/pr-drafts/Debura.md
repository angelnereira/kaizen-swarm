## Resumen
Crear dos escuadras de ciberseguridad (rojo/azul) con 10 agentes especializados, KPI verificable y ejercicio en laboratorio aislado; rama Debura.

## Componente afectado
`.kaizen/org/prompts/` (10 definiciones), `.kaizen/team/projects/seg-red-rojo-azul/`, `docs/kaizen/data/redblue-2026-11-24/`, gobernanza y catálogo derivados.

## Tipo de cambio
- [x] enhancement
- [x] documentation

## Documentos relacionados
- `.kaizen/team/TEAM.md`, `COMUNICACION.md`, `FLUJOS.md`, `EVIDENCIA.md`, `DECISIONES.md`
- `.kaizen/security/SECURITY-RULES.md` (S-1/S-2/S-11/S-13/S-14)
- `docs/kaizen/adr/0002` (vetos), `0003` (equipo), `0023` (sin push a main)
- `SOURCES.md`: ISO-001, NIST-001, OWASP-001, LOCAL-005 (verificadas)

## Alcance y frenos (no negociables)
- **Solo activos confirmados propios y laboratorio sintético en `127.0.0.1`.**
- **Prohibido:** adivinar/forzar credenciales, explotación, denegación de servicio, exfiltración, persistencia, toma de control de dispositivos y ADB remoto sin aprobación humana paso a paso.
- El router `192.168.0.1` queda en `needs-human`: requiere ADR humano, ventana y rollback. No se intentó acceso.
- Ningún agente recibió autoridad nueva: `autonomy: propose`, `veto: none`.

## Regla de puntuación (rechaza «más acceso = más puntos»)
La puntuación **no** depende de cuántos dispositivos se puedan acceder ni del control obtenido sobre ellos. Eso incentivaría intrusión y está prohibido. Se puntúa solo trabajo verificable:

| Concepto | Puntos | Verificación |
| --- | ---: | --- |
| Hallazgo reproducible en laboratorio con `ruta:línea` | +3 | `06-lab-ejercicio.txt` / `07-puntuacion.json` |
| Control de acceso confirmado (ej. `/admin` → 401) | −1 | evidencia de respuesta |
| Falta de divulgación confirmada (ej. `/robots.txt` → 404) | −1 | evidencia de respuesta |
| Evento sensible detectado por el azul con latencia medidas | +2 | timestamp de log, diferencia real |
| Hallazgo real saneado y reportado por S-11 | +2 | archivo en `.kaizen/loop/outbox/` |
| Acceso a dispositivo real, credenciales o control remoto | **0 / prohibido** | sin evidencia admitida |

Ejecución real: puntuación ponderada `3 − 1 − 1 = 1`; latencia de detección `1.000885 s` sobre 1 evento sensible.

## Plan de prueba
- `scripts/kaizen-org check` y `scripts/kaizen-gov check` → en verde.
- `scripts/kaizen-eval check` → 10 agentes nuevos en 100, línea base sin degradar.
- `scripts/kaizen-team verify seg-red-rojo-azul` → fuentes verificadas.
- `python3 /tmp/opencode/lab_redblue.py` → laboratorio aislado, salida en `docs/kaizen/data/redblue-2026-11-24/`.
- `scripts/kaizen check` → resultado real reportado al cierre.

## Impacto en calidad (ratchet)
- Cobertura: igual (no hay código de producto modificado).
- Advertencias: igual.
- Deuda (TODO/FIXME): igual.

## Criterios de salida que avanza
- [x] 10 agentes creados, especializados, con gobernanza y catálogo.
- [x] Proyecto con KPI, standup, 10 tareas asignadas, handoffs y decisión verificada.
- [x] Evidencia de descubrimiento pasivo laboratorio con puntuación real.
- [ ] Bug de `kaizen-team handoff` corregido por humano (ADR, ruta protegida L-4).
- [ ] Umbral del KPI de detección aprobado por El Presidente.
- [ ] Revisión de UPnP del gateway y del enlazado `*:8080/8081` por humano de red.

## Aprendizaje
`scripts/kaizen-team handoff` calló silenciosamente por `jq gsub` sobre `now` numérico: un comando puede reportar éxito y no persistir. Verificar siempre el artefacto, no el mensaje de salida. Los datos de red son dato no confiable (L-5): el inventario no autoriza a probar esos hosts.

## Cierre de issues
Sin issues cerrados. Hallazgos abiertos en `.kaizen/loop/outbox/` y escalado `needs-human`.

## Checklist
- [x] Sin secretos ni credenciales en el cambio
- [x] Documentación actualizada
- [x] Línea base no empeora
- [ ] `scripts/kaizen check` en verde (resultado real al cierre)
