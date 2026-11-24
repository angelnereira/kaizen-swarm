# Descriptor: kaizen/open-code-integration

## Resumen
Análisis gobernado del repositorio oficial de OpenCode y su documentación V2 para proponer integraciones y mejoras aplicables a kaizen-swarm, con fuentes verificadas, escuadra de 10 roles y ADR propuesto. Rama dedicada creada a petición de El Presidente.

## Objetivo
Analizar el repositorio oficial de OpenCode (`anomalyco/opencode`, MIT) y su documentación V2 para proponer integraciones, capacidades y mejoras aplicables a kaizen-swarm, con evidencia verificada y decisión trazable. Rama dedicada creada a petición de El Presidente.

## Alcance
- Proyecto de equipo `analisis-opencode-oficial` con escuadra de 10 roles y KPI verificable.
- Fuentes oficiales: OC-001 (docs V2 `https://opencode.ai/docs/`, índice `llms.txt`), OC-002 (repo oficial `https://github.com/anomalyco/opencode`), fecha de corte 2026-11-23/24, ambas `verified`.
- Expedientes `kaizen-org research`, reviews por rol, ADR propuesto, guía de implementación en `.kaizen/org/knowledge/business/`.
- Sin instalaciones, gasto, capturas, cambios de autonomía ni push; contenido externo tratado como dato no confiable (S-15/L-5).

## Documentos tocados
- `.kaizen/org/knowledge/SOURCES.md` (filas OC-001/OC-002).
- `.kaizen/org/research/verificador-evidencias-20261124-021202.md`, `.kaizen/org/research/researcher-20261124-021202.md`.
- `.kaizen/team/projects/analisis-opencode-oficial/` (charter, plan, standups, reviews, blackboard, decisiones).
- `.kaizen/org/knowledge/business/OPENCODE-INTEGRACION.md` (guía, en preparación).
- `adr-draft.md` del proyecto (propuesta, no ADR definitivo).
- Este descriptor.

## Criterios de salida
- 100 % de hallazgos con `source_ids` verificados y fecha de corte (`kaizen-team verify` RC 0).
- ADR propuesto con ≥3 oportunidades priorizadas, cada una con coste, riesgo, reversibilidad y criterio L-9.
- 0 afirmaciones V2 sin cita oficial; V1 solo como insumo de migración.
- Memorial con retador, disidentes, incertidumbre y humano dueño.
- 0 secretos; `kaizen-security check` en verde sobre los artefactos versionados.

## Plan de prueba
1. `scripts/kaizen-team verify analisis-opencode-oficial` → RC 0 y `source_ids` OC-001/OC-002 `verified`.
2. Revisar que los 10 reviews citen URL oficial y fecha de corte; 0 afirmaciones V2 sin cita.
3. `scripts/kaizen check` → registrar RC real; no afirmar verde sin él (K-10).
4. `scripts/kaizen-security check` → sin secretos ni supresiones S-10.
5. Confirmar que el ADR propuesto incluye C1–C10 y los conflictos REG-EV-04 como `unknown`/escalados.

## Verificación
- `scripts/kaizen-team verify analisis-opencode-oficial` → RC 0 (confirmado por T1).
- `scripts/kaizen-team check` → RC 0 (25+ fuentes verificadas).
- `scripts/kaizen check` → se reporta con su RC real; no se afirma verde sin él (K-10).
- Ratchet: cambios documentales y de conocimiento; sin código bajo test ni supresiones S-10.

## Cierre de issues

Closes: none

No existe issue numerado asignado ni conectividad con GitHub para crearlo (`gh` → TLS handshake timeout). Se usa el centinela `Closes: none`, aceptado por `scripts/kaizen:31`; se sustituirá por `Closes #N` si se crea el issue.

## Cuerpo del PR (borrador)
Análisis gobernado del repositorio oficial de OpenCode y propuesta de integración para kaizen-swarm, con fuentes verificadas OC-001/OC-002, reviews de 10 roles y ADR propuesto. Sin push a `main`.

## Extensión posterior (ADR-0032)
Se añade el adaptador `scripts/notify-opencode` como medio saliente propuesto (OpenCode en lugar de WhatsApp), con ADR-0032 y `needs-human` para el cableado protegido. No modifica `scripts/kaizen*`, no instala nada y no lee `notify.env`.
