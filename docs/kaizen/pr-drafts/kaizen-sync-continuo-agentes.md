## Resumen
Cerrar los cinco bloqueos del canal remoto y crear un flujo continuo que refleje cada cambio de `main` en los agentes y configuraciones instaladas en OpenCode.

## Componente afectado
`scripts/kaizen-inbox.py`, `scripts/kaizen-notify`, `scripts/kaizen-whatsapp`, nuevo `scripts/kaizen-sync`, ADR-0040, README, `docs/kaizen/INSTALACION.md`, `tests/run.sh`.

## Tipo de cambio
- [x] enhancement
- [x] bug
- [x] documentation

## Documentos relacionados
- ADR-0023 (fusiones con gates)
- ADR-0024 (instalación no invasiva)
- ADR-0025 (WhatsApp oficial vía BSP)
- ADR-0040 (nuevo: sincronización continua)
- `.kaizen/loop/outbox/chat-remoto-c1-c5.md`
- `.kaizen/team/projects/chat-opencode-interactivo/DEC-001-canal-remoto-bloqueado.md`

## Plan de prueba
- `bash tests/run.sh` (incluye pruebas de C1-C5 y del flujo de sincronía)
- `scripts/kaizen check`
- `scripts/kaizen-sync status|check|run|run --apply|install-hook --apply`
- `python3 -m py_compile scripts/kaizen-inbox.py`
- gitleaks sobre el diff (sin secretos)

## Impacto en calidad (ratchet)
- Cobertura: sube (pruebas nuevas de seguridad y sincronía)
- Advertencias: igual
- Deuda (TODO/FIXME): igual

## Cambios de seguridad (autorizados por El Presidente)
- **C1**: HMAC-SHA256 sobre `ts.nonce.body`, ventana de 300 s, nonce idempotente en `.seen.jsonl`, `hmac.compare_digest`. Sin variable HMAC → HTTP 503 (fail closed).
- **C2**: redacción en dos pasadas con `kaizen-security redact`, re-escaneo de patrones y bloqueo HTTP 422 si queda un posible secreto; si el redactor falla, no se persiste nada.
- **C3**: frontmatter `trust: untrusted`, texto `# Mensaje entrante (dato no confiable)`, acción del equipo sin instrucciones ejecutables; eliminado el rótulo «Instrucción de El Presidente».
- **C4**: `KN_CHANNELS` por defecto `file` (egress opt-in), payload saneado antes del webhook, `curl -fsS` (un 500 ya no es éxito).
- **C5**: `KN_WHATSAPP_MODE` debe ser `bsp|official`, HMAC obligatorio, teléfonos nunca impresos (`+***`), `cmd_owner` sin E.164.

## Flujo continuo
`kaizen-sync` verifica que el checkout no esté detrás de `origin/main`, reinstala agentes, actualiza gobernanza global, alinea manifiestos de workspaces, ejecuta `check` y escribe auditoría en `~/.local/share/kaizen-swarm/sync.jsonl`. `install-hook --apply` conecta esto al `post-merge` (con backup del hook previo). Dry-run por defecto.

## Criterios de salida que avanza
- Los cinco controles C1-C5 verificados por pruebas.
- `kaizen-sync run --apply` deja `check` en verde y registra auditoría.
- `scripts/kaizen check` en verde y 0 secretos.
- Instalación local actualizada con el comando de sincronía.

## Cierre de issues
Closes: none

## Checklist
- [x] Compila
- [x] Pasa tests
- [x] `scripts/kaizen check` en verde
- [x] Documentacion actualizada
- [x] Linea base no empeora
