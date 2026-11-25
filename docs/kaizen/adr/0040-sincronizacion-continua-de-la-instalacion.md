# ADR-0040: sincronización continua de la instalación local

Estado: propuesto
Fecha: 2026-11-25
Aprobado por: El Presidente (autorización explícita para superar C1-C5 y trata de rutas protegidas)

## Contexto

Cada mejora fusionada en `main` exigía hasta ahora recordar `kaizen-installer opencode --global` y verificar a mano que los agentes y la configuración local seguían alineados. Eso produce deriva: agentes desactualizados, gobernanza local distinta del repo y workspaces con versiones inconsistentes. Además, el canal remoto tenía cinco fallos de seguridad (C1-C5, outbox `chat-remoto-c1-c5`) que bloqueaban su activación.

## Decisión

1. **`scripts/kaizen-sync`** es la única puerta de sincronía: `status`, `check`, `run [--apply]` e `install-hook [--apply]`. `run` sin `--apply` es dry-run; `--apply` o `KZ_DRY_RUN=0` ejecuta.
2. **`run --apply`** hace, en orden: verificar que el checkout no esté detrás de `origin/main`; reinstalar agentes con `kaizen-installer opencode --global`; copiar gobernanza y prompts a `~/.local/share/kaizen-swarm/framework`; alinear el `version` de los workspaces que apuntan a este framework; verificar con `check`; y escribir una línea de auditoría en `~/.local/share/kaizen-swarm/sync.jsonl`.
3. **`install-hook --apply`** instala un `post-merge` en `.git/hooks/` que ejecuta `kaizen-sync run --apply` tras cada fusión. Si había hook previo, se conserva como `.kaizen.bak`. Es opt-in: nadie lo instala sin ejecutar el comando.
4. **C1-C5 quedan cerradas en código**: HMAC-SHA256 con marca de tiempo, nonce e idempotencia en `kaizen-inbox.py` (C1); redacción fail-closed con doble pasada y re-escaneo (C2); `trust: untrusted` y sin rótulo «Instrucción de El Presidente» (C3); egress opt-in, saneado y `curl -f` en `kaizen-notify` (C4); modo BSP oficial obligatorio, HMAC configurado y teléfonos nunca impresos en `kaizen-whatsapp` (C5).
5. **Fail closed**: sin HMAC configurado el buzón responde 503; sin redactor disponible el webhook no envía; sin modo BSP `kaizen-whatsapp check` falla. Ningún fallo se silencia (S-10/K-11).

## Alternativas consideradas

- Confiar en `kaizen-installer` manual tras cada merge: descartado; depende de memoria humana y no detecta deriva.
- Sincronizar en CI remoto: descartado por ahora; la cuenta de Actions está bloqueada por facturación y la instalación es local por diseño (ADR-0024).
- Hook automático sin opt-in: descartado; modificar `.git/hooks` de un repo ajeno sería invasivo.

## Consecuencias

- Positivas: un solo comando (o un hook opt-in) mantiene agentes, gobernanza, workspaces y auditoría alineados con `main`. Cada cambio se refleja de forma consistente.
- Negativas: `run --apply` reescribe archivos locales en la config global y el framework global; siempre queda registro en `sync.jsonl`. El hook solo actúa tras fusiones en el checkout donde se instaló.

## Límites

El agente no lee credenciales ni las imprime (S-2): el HMAC se referencia por nombre de variable. No se activa ningún envío remoto automático: `KN_CHANNELS` por defecto es `file`. No se modifica `opencode.json`. No se fusiona en `main` sin gates verdes (ADR-0023).

## Cómo se verificará

- `scripts/kaizen-sync status|check|run --apply|install-hook --apply` con resultados auditables.
- `bash tests/run.sh` con pruebas de C1-C5 y del flujo (auditoría, hook, check en verde).
- `scripts/kaizen check` en verde; gitleaks sin fugas.
