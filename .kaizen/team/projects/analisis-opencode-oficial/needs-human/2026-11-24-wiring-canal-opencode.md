---
id: NH-2026-11-24-004
proyecto: analisis-opencode-oficial
etapa: decide
intent: proposal
status: resolved
source_ids: [OC-001, OC-002]
created: 2026-11-24
---

# Cableado del canal OpenCode en el runtime (requiere humano, L-4)

## Observación
ADR-0032 decide que el medio de salida sea el propio OpenCode. El adaptador `scripts/notify-opencode` ya está implementado y probado (sesión dedicada, mensaje `synthetic`, `resume:false`, idempotencia). Pero el runtime actual sigue despachando reportes desde `scripts/kaizen-notify:55-57` (`file`/`webhook`/`email`).

## Evidencia
- `notify-opencode send|event|status|session` verificados; `GET /api/session/{sid}/inbox` devuelve los items.
- ADR-0032 en `docs/kaizen/adr/0032-canal-saliente-opencode.md`.
- `scripts/kaizen-notify` y `scripts/kaizen-runtime` están bajo `scripts/kaizen*` = ruta protegida (L-4).

## Decisión requerida
Autorizar una de dos opciones:
1. Añadir el caso `opencode` en `cmd_send` (`scripts/kaizen-notify:55-57`) y hacer que el adaptador sea invocado por el notify, con `KN_CHANNELS=file,opencode` y `webhook`/`email` como fallback; o
2. Dejar `kaizen-notify` intacto y que el humano/aprobar un cambio en `scripts/kaizen-runtime` para invocar `notify-opencode event ...` en el ciclo de equipo.

## Propuesta
Opción 1: un único punto de salida, semántica de fallo igual a `webhook` (kfail + fallback a `file`), sin tocar la configuración de OpenCode ni credenciales. Requiere ADR complementario o aprobación explícita del humano porque L-4 prohíbe editar `scripts/kaizen*` por iniciativa del agente.

## Impacto si no se aprueba
El canal OpenCode existe y se puede usar de forma manual/autónoma (`notify-opencode`), pero los ciclos automáticos del runtime seguirán usando `file`/`webhook`/WhatsApp. No se ha tocado nada protegido.

## Plazo
Antes de dar por cerrada la migración de medio; no bloquea el ADR-0032 ni el análisis de OpenCode.

## Resolución 2026-11-24 — permiso habilitado
El Presidente confirmó "permiso habilitado". Se aplicó la Opción 1: `send_opencode()` añadida a `scripts/kaizen-notify`, con `KN_OPENCODE_ENABLED=1` por defecto y precedencia del canal `opencode` aunque `notify.env` no lo liste; `file` sigue como auditoría y `webhook`/`email` como fallback. Verificado: `kaizen-notify send --title "Cableado OpenCode activo"` → mensaje presente en `GET /api/session/{sid}/inbox`. Además, `adb shell dumpsys notification --noredact` muestra un `NotificationRecord` activo de `ai.opencode.mobilecode` (importance=3, canal session-run), confirmando que las notificaciones están operativas en el Pixel 8 Pro. Sin secretos ni cambios en `notify.env`.

## Nota: push bloqueado por pre-push (2026-11-24)
Los commits de trabajo (`875a01b`, `eae5590`) están listos en local. El push falla con RC 124 porque `.githooks/pre-push` corre `scripts/kaizen check` y el gate `tests` cuelga (condición preexistente documentada en `.kaizen/loop/outbox/kaizen-check-sin-rc.md`). `git ls-remote` confirma que el remoto sí responde. No se saltó el hook (S-10). Decisión requerida: arreglar `tests` o autorizar excepción del hook (L-4).
