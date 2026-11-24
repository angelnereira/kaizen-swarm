# evolutionW — OpenCode como canal de Kaizen Swarm (WhatsApp opcional)

## Resumen
OpenCode (app móvil Android + `opencode serve`) pasa a ser el canal activo para hablar con Kaizen Swarm; WhatsApp/WAHA queda como canal opcional no activado. Entrega de **gobernanza y contratos**: ADR, 5 decisiones verificadas, contratos de ingress/egress, esquemas y corrección de un bug de tests. Sin adaptador ni segunda arquitectura.

## Cierre de issues
No aplica: no hay issue numerado asociado en esta entrega (trabajo de gobernanza/diseño). El proyecto de equipo es `.kaizen/team/projects/whatsapp-waha-bridge/`. Los hallazgos se registraron en `.kaizen/loop/outbox/` (S-11).

Closes: none

## Plan de prueba
1. `kaizen-team check` + `kaizen-team verify whatsapp-waha-bridge` → verdes.
2. Regresión aislada del bug de `kaizen-tokens` (`KT_LEDGER` absoluto) → `input_total=10`.
3. POC HMAC-SHA512 con vector oficial → prefijo/sufijo coinciden.
4. Recorrido del canal OpenCode verificado en la sesión `ses_df46fa86effekZ3R42lECIWYEb`.
5. `tests/run.sh` completo: bloqueado por bug preexistente de concurrencia (S-11), prueba específica en verde.

Estado: en preparación (sin código implementado, sin número conectado, sin flag activado)
Rama: `evolutionW`
Proyecto de equipo: `.kaizen/team/projects/whatsapp-waha-bridge/`
Canal activo (DEC-004): app OpenCode Android (`ai.opencode.mobilecode`) → `opencode serve` → `kaizen-equipo`. WhatsApp/WAHA queda como canal opcional en espera (ADR-0031 vigente pero inactivo).

## Objetivo
Integrar WhatsApp como puerta de entrada/salida bidireccional de Kaizen Swarm (hasta 12 agentes), con archivo local persistente y contexto navegable en rutas `/*/*`, reutilizando `kaizen-inbox`, `kaizen-notify` y el runtime sin reemplazarlos. Principio: menos es más.

## Gobernanza (previa a cualquier código)
- ADR-0025 prohíbe cliente no oficial. El Presidente aprobó enmienda acotada: **ADR-0031** (WAHA + número dedicado, riesgo aislado en ese número, flag por defecto `0` intacto).
- Decisiones del Presidente 2026-11-24 (DEC-002): remitentes = propietario **+ terceros autorizados** con base legal y responsable ANTAI documentados antes de activar; reafirmación del riesgo y aprobación de contingencia a Cloud API oficial con revisión trimestral; preparar todo y esperar el número antes de cualquier POC con número real.
- Fuentes verificadas: WAHA-001/002/003/007/009/010/011/012/014, META-003, PA-001/PA-002 en `.kaizen/org/knowledge/SOURCES.md`.

## Alcance de esta entrega (diseño y gobernanza, Fase 0)
- [x] Rama `evolutionW` creada.
- [x] Proyecto de equipo, KPI, charter, standup, blackboard, diario.
- [x] DEC-001/DEC-002 con `source_ids` verificados (`kaizen-team verify` en verde).
- [x] ADR-0031 de enmienda, Aceptado por El Presidente.
- [x] Contratos de diseño: `contracts/interfaces.md`, `contracts/security.md`, esquemas `metadata.schema.json` y `location.schema.json`.
- [x] Dictámenes: `security` = CHANGES_REQUESTED, `cumplimiento-panama` = CHANGES_REQUESTED, `architect` = contrato entregado.
- [x] Registro S-11: bug de `kaizen-team assign` (jq `now` vs `$now`).
- [x] Reevaluación de cumplimiento con alcance «terceros autorizados» (CHANGES_REQUESTED, C3/C4 bloqueantes).
- [x] AP-001: permiso explícito firmado por El Presidente (2026-11-24), con alcance y exclusiones.
- [x] Bug de `kaizen-tokens` corregido y verificado (regresión aislada).
- [x] POC de HMAC-SHA512 **verificada** (vector oficial reproducido, datos sintéticos).
- [ ] POC de *live location* (PENDIENTE: requiere número dedicado + Docker).
- [ ] Implementación Fase 1 (ingress/egress) — NO incluida en esta entrega.

## Cambios versionados en esta rama
- `.kaizen/org/knowledge/SOURCES.md` (fuentes WAHA/META).
- `.kaizen/org/research/verificador-evidencias-20261124-034331.md` (expediente).
- `.kaizen/team/projects/whatsapp-waha-bridge/` (proyecto, decisiones, contratos, revisiones, alertas).
- `.kaizen/loop/outbox/kaizen-team-assign-jq-now-bug.md` (S-11).
- `docs/kaizen/adr/0031-enmienda-waha-numero-dedicado.md`.
- `docs/kaizen/journal/2026-11-24-equipo-waha-034500.md`.
- `docs/kaizen/pr-drafts/evolutionW.md` (este descriptor).

NO se han modificado: `scripts/kaizen*`, ADR-0025, `tests/run.sh`, `.gitignore`, secretos ni rutas protegidas L-4.

## Verificación
- **Canal OpenCode (DEC-004) — recorrido verificado en esta sesión**: instrucción del Presidente desde la sesión OpenCode (`OPENCODE_SESSION_ID=ses_df46fa86effekZ3R42lECIWYEb`, `opencode serve` PID 4784 activo) → `kaizen-equipo` → DEC-001..004 con `source_ids` verificados → 4 tareas con handoffs → respuesta en la misma sesión. 0 tareas duplicadas; 1 handoff (H-0003/QA) queda abierto honestamente (POC WAHA, canal en espera).
- **Conflicto detectado (no resuelto por el agente)**: el ciclo concurrente del runtime creó ADR-0032 + DEC-003 (número **personal**) y DEC-005 (fuentes OC-*), que chocan con DEC-004/ADR-0031 (número **dedicado**, WhatsApp opcional). Registrado en `alerts/2026-11-24-conflicto-decisiones-ciclo-concurrente.md`. Requiere decisión humana; no se borró ni invalidó nada.
- **DEC-006 (conflicto resuelto)**: El Presidente confirmó ADR-0032 (número personal, "mensaje a uno mismo"); DEC-004 se mantiene (OpenCode canal activo, WhatsApp opcional). Número guardado **fuera del repo** en `owner.env` (variable `KAZEN_OWNER_PHONE`, permisos `600`), **nunca versionado ni impreso en artefactos**. Sin activación (flag `=0`, sin QR, sin Docker).
- `scripts/kaizen-team check`: verde (39 fuentes verificadas).
- `scripts/kaizen-security check`: verde (sin fugas).
- `python3 -m json.tool` en ambos esquemas: OK.
- `scripts/kaizen check`: bug del ledger **CORREGIDO** (autorización del Presidente 2026-11-24 "procede"). Causa raíz real: `.kaizen/finops/tokens.env:2` fijaba `KT_LEDGER` incondicionalmente (sobrescribía el entorno) y `scripts/kaizen-tokens:9` anteponía `$ROOT/` a rutas absolutas. Parche en 2 líneas (asignación condicional + `case` para absolutas). Regresión aislada idéntica al test: `registros=1, input_total=10`, `bash -n` OK, ledger real intacto (20871 líneas). `tests/run.sh` completo no pudo cerrarse porque un ciclo concurrente del runtime autónomo interrumpió la corrida con SIGTERM (del entorno, no del parche); la prueba específica sí pasó. Registrado en S-11.

## Efectos en el repositorio / rollback
Cambios aditivos y documentales. Rollback: revertir commits en esta rama. Nunca push a `main` ni fusión sin gates (ADR-0023). Sin PR por iniciativa propia sin evidencia verde.

## Documentación tocada (K-7)
ADR-0031, SOURCES.md, diario, contratos del proyecto, alerta de cumplimiento, este descriptor.
