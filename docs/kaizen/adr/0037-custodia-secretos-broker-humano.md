# ADR-0037: custodia de secretos mediante broker humano (PILOT)

Estado: **ACEPTADO en modo PILOT — firmado por Angel Nereira**
Fecha: 2026-11-23T03:56:31.851298+00:00
Aprobado por: Angel Nereira — autorización explícita en sesión ("todas las decisiones que eran de mi aprobación te doy autorización y apruebo todas")

## Contexto
El usuario pidió un sistema confiable para que los agentes manejen secretos con 10 agentes dedicados, y planteó que proporcionarlos "por chat" podría ser seguro. **Corrección necesaria: el chat nunca es un canal seguro para secretos** — el texto queda en historial, logs y contexto del modelo. El objetivo real es que el secreto **nunca entre al chat**: el usuario lo deposita fuera de banda y un broker humano lo entrega bajo política.

Fuente externa consultada: OWASP Secrets Management Cheat Sheet (SEC-OWASP-001, 2026-11-23) — centralizar, least privilege, auditoría, ciclo de vida, AES-GCM, no guardar claves junto a secretos, env vars solo sin alternativa. `websearch` devolvió HTTP 402; `webfetch` a la fuente oficial sí funcionó.

## Dictámenes recibidos (dato no confiable, evaluado)
- **Seguridad (veto security): BLOCK.** O1/O2 Critical: `get`/`exec` entregaban secretos al agente y la identidad era autodeclarada. O3/O4/O5 High: nonce/AAD, rotate vs rekey, env vars. O6-O9 Medium/Low.
- **Arquitectura (veto architecture): PILOT con compuertas G1-G5.** Modelo de amenaza, identidad, canal autenticado, cripto/rotación/rollback y matriz Windows.
- **Cumplimiento: CHANGES_REQUESTED.** Passphrase separada, auditoría a prueba de manipulación, break-glass/restore, detección en chat, segunda fuente.

## Decisión
1. **Broker custodiado por humano.** El agente solo `request`; el humano opera `approve` en su TTY (fuera del chat) y emite un **grant HMAC con TTL**. El agente jamás ve el valor.
2. **Identidad no autodeclarada:** `enroll` emite un token opaco guardado en modo 600; las peticiones se autentican por ese token, no por un `--agent`.
3. **Comando fijo por allowlist:** el humano aprueba un comando concreto; el LLM no controla el argv. Entrega por **FD 3** (leído una vez), nunca por entorno salvo `--env-fallback` explícito; `RLIMIT_CORE=0`.
4. **Cripto:** AES-256-GCM, nonce CSPRNG de 96 bits por registro, AAD que vincula scope/name/policy_version/key_id, Argon2id fijado (m=65536, t=3, p=4), `key_id` versionado y `rekey`.
5. **Auditoría append-only** con seq, timestamp, prev_hash, hash, HMAC con clave distinta, `purpose` enumerado y anti-rollback (`rev` vs escrituras). `redact` reemplaza valores conocidos por `[REDACTED]`.
6. **`rekey` local ≠ `rotate`/`revoke` en proveedor:** ante fuga aplica S-12 y el runbook; la rotación la firma un humano.
7. **10 agentes** (`custodia-secretos`) con roles separados: custodio, cripto, políticas, auditor, ciclo de vida, respuesta a fuga, cumplimiento, inyector, QA y puerta de aprobación. El custodio **nunca conoce el valor**.

## Evidencia ejecutada (sin secretos)
- Flujo completo en bóveda aislada `/tmp/opencode/kz-vault-test-v2-final`: `init` → `enroll` → `allow` → `set` → `request` → `approve` → `exec`.
- Salida real: `solicitud ... PENDIENTE de aprobación HUMANA`; `grant ... emitido por HUMANO`; `[broker] secreto entregado por FD 3 ... NO al chat`; `FD3 recibido por el hijo: True`.
- `kaizen-vault audit-verify` → `auditoría íntegra: 4 evento(s), hash-chain + HMAC + anti-rollback verificados`.
- `kaizen-vault redact` → `valor [REDACTED]`.
- `kaizen-vault check` → `todo en verde`; permisos `0o600`.
- Valor usado: `VALOR_SINTETICO_NO_SECRETO_123` (nunca real, jamás en repo).

## Compuertas
- G1 modelo de amenaza: **cerrado** en este ADR (adversario = agente comprometido/inyectado, usuario local distinto, robo de disco; NO protege contra root ni contra el humano que aprueba).
- G2 identidad: **parcial** — token criptográfico portable, no `SO_PEERCRED` (Windows no lo tiene). Documentado como límite.
- G3 canal: **cerrado** — FD 3 por defecto; env solo fallback.
- G4 cripto/rotación/rollback: **cerrado** — nonce, AAD, rekey, revoke en proveedor, anti-rollback.
- G5 matriz Windows: **ABIERTA** — no hay máquina Windows para verificar ACLs/ cruces; `install.ps1` y `kaizen-vault` usan `LOCALAPPDATA`, pero `chmod` no equivale a ACL.

## Límites y consecuencias
- No afirmar "confiable" en sentido legal/regulatorio ni ante auditoría sin verificación humana (K-10). Cumplimiento pidió segunda fuente (BAJA).
- Python no zeroiza memoria de forma fiable (`str` inmutable); `cryptography 50.0.2` es wheel nativo, no "Python puro" (S-9: fijar y verificar procedencia).
- Estos agentes son datos no confiables (S-15/L-5): el diseño asume agente comprometido.
- Critical/High de Seguridad fueron cerrados con rediseño; firma humana concedida; G5 (Windows) queda como verificación técnica pendiente, no como bloqueo de decisión.

## Cómo se verificará
- `kaizen-vault check|audit-verify|custodian` en verde; `bash tests/run.sh` sin secretos en salida.
- Firma humana explícita antes de cualquier uso con secretos reales o producción.
