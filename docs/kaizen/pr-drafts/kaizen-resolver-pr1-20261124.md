## Resumen
Resolver los conflictos del PR #1, eliminar el literal de contraseña detectado por GitGuardian y publicar su contenido en `main`.

## Componente afectado
PR #1 (`kaizen/equipo-arquitectura-copilot`): copiloto de arquitectura, orquestación, custodia de secretos, bridge de WhatsApp e instalador de Windows.

## Tipo de cambio
- [x] enhancement
- [x] documentation
- [x] bug (arnés de pruebas y secreto versionado)

## Documentos relacionados
- ADR-0023 (autonomía de push, sin fusiones sin gates)
- ADR-0037 (custodia de secretos, broker humano)
- S-1/S-3/S-6/S-12 (cero secretos, sin hardcoding, mínimo privilegio, secreto detectado)
- `.kaizen/loop/outbox/gg-generic-password-docker-compose-ab9fd0e.md`
- `.kaizen/team/projects/consolidar-prs-main/evidence-triage.md`

## Plan de prueba
- `scripts/kaizen check` (descriptores, política, formato, lint, tests, ratchet, seguridad, gobernanza)
- `bash tests/run.sh`
- `git grep -n 'GF_SECURITY_ADMIN_PASSWORD' docker-compose.yml | sed 's/:.*//'` (sin imprimir valores)
- `grep -rlE '^(<<<<<<<|=======|>>>>>>>)' --exclude-dir=.git .` (sin marcadores)
- `scripts/kaizen-security check` (gitleaks: 0 fugas)

## Impacto en calidad (ratchet)
- Cobertura: sube (se conservan las 234 pruebas de `main` y se agregan 30 del PR #1; conteos ahora dinámicos)
- Advertencias: igual (dos avisos S-3 justificados abajo)
- Deuda (TODO/FIXME): igual

## Resolución de conflictos
- `token-ledger.jsonl`: unión de ambos lados; se descartaron líneas con JSON inválido y duplicados (15.324 líneas válidas).
- `governance.json`: unión de `agents` y `processes` (90 agentes, 12 procesos), conservando `updated` de `main`.
- `catalog.json` y `CATALOGO-AGENTES.md`: regenerados con `scripts/kaizen-org catalog` desde los 90 prompts reales; no se editaron a mano.
- `handoffs.jsonl`: se conservó la versión completa de `main`; la del PR era un fragmento del mismo objeto.
- `tests/run.sh`: base de `main` + pruebas nuevas del PR #1; conteos 57/80 sustituidos por conteo dinámico de prompts; resumen y `[ "$FAILN" = 0 ]` al final (antes estaban en la mitad y enmascaraban fallos). La aserción de ADR-0037 buscaba el literal `chat NO es canal`, inexistente en el ADR; se sustituyó por `chat nunca es un canal seguro|NO al chat`, que verifica la misma política con la redacción real del documento (no se relaja: sigue fallando si el ADR no prohíbe el chat).
- `docker-compose.yml:42`: se eliminó el literal detectado y se exige `KAZEN_GRAFANA_ADMIN_PASSWORD` con `${VAR:?...}` (fallo rápido, S-3). El valor sigue comprometido en el historial: requiere rotación humana.

## Justificación de avisos S-3
- `scripts/kaizen-whatsapp-bridge:165,172`: direcciones `127.0.0.1` con puerto efímero (`0`) y HMAC de prueba calculado desde `KAZEN_WEBHOOK_SECRET` (variable de entorno). No son hosts, puertos ni credenciales de producción; son el arnés de prueba del bridge local.

## Criterios de salida que avanza
- `scripts/kaizen check` en verde.
- 0 marcadores de conflicto, 0 secretos versionados, 0 supresiones S-10.
- Los 90 prompts tienen catálogo y gobernanza consistentes.
- Se documenta que la rotación de la credencial y la reescritura de historial siguen siendo humanas (S-12).

## Cierre de issues
Closes #1

## Checklist
- [x] Compila
- [ ] Pasa tests
- [ ] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
