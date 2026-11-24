---
id: MSG-SEC-WAHA-001
correlation_id: whatsapp-waha-bridge
from: security
to: [facilitador-equipo, architect, qa, cumplimiento-panama]
channel: review
intent: finding
expects_ack: true
deadline: 2026-12-01T18:00:00Z
source_ids: [WAHA-001, WAHA-002, WAHA-003, WAHA-007, WAHA-009, WAHA-010, WAHA-011, WAHA-014, META-003, LOCAL-001]
reply_to: H-20261124-0002
status: open
created: 2026-11-23
---

# Dictamen de Seguridad y Auditoría — diseño del gateway WAHA

## DICTAMEN: **CHANGES_REQUESTED** (sobre el DISEÑO; sin código aún)

No ejerzo veto `security` sobre el diseño en este momento: la arquitectura propuesta es aditiva, reversible y tiene un modelo de controles identificable en `contracts/security.md`. **Sí bloquearía (`BLOCK`) la implementación o la activación** si se procede sin cerrar las condiciones C1–C9 de abajo. La aprobación de diseño **no** implica conformidad legal (veto `compliance` pendiente) ni autorización para activar el canal.

---

## Observación

Revisé el diseño del puente `WAHA → kaizen-inbox.py → .kaizen/team/inbox/ → runtime` y el contrato de seguridad propuesto, con foco en ingress HMAC, SSRF, allowlist/anti-bucle, dedupe/rate limit, traversal, secretos, egress y contenedor. No revisé código nuevo (aún no existe) ni activé nada.

## Evidencia (comandos ejecutados, sin secretos)

- `find .kaizen/team/projects/whatsapp-waha-bridge -maxdepth 3 -type f` → 8 archivos; no existían `contracts/` ni `reviews/` antes de este dictamen.
- `git branch --show-current` → `evolutionW`. No hice commit ni push.
- `grep -n ... docs/kaizen/adr/0031-enmienda-waha-numero-dedicado.md` → :20 (flag por defecto `0`, cambio fuera del repo), :22 (HMAC `compare_digest` + dedupe + preservar `X-Kaizen-Secret`), :24 (red privada, tag+digest, sin root), :25 (rutas `/*/*` sin traversal), :26 (contenido = dato no confiable), :38 (POC HMAC/live location, daemon detenido), :43-44 (recorrido completo y `git check-ignore`).
- `sed -n '50,90p' scripts/kaizen-inbox.py` → **:57** compara `X-Kaizen-Secret` con `!=` (no constante en tiempo); **:64-65** lee y `json.loads` el cuerpo antes de cualquier verificación HMAC; **:80** escribe `# Instrucción de El Presidente` para **todo** remitente.
- `grep -n -A6 'WAHA-0' .kaizen/org/knowledge/SOURCES.md` → :43 `X-Webhook-Hmac (sha512)` + `X-Webhook-Request-Id`; :45 `X-Api-Key`, "Do not expose WhatsApp API on public networks"; :46 `WALocation.live` sin evento propio; :48 imagen tag+digest; :51 vector HMAC y payload de live location **pendientes de POC**.
- `grep -rhoE 'KAZEN_[A-Z0-9_]+|KN_WHATSAPP_[A-Z0-9_]+|KI_MAX_[A-Z0-9_]+' scripts/ .kaizen/team/` → aparecen `KAZEN_INBOX_SECRET`, `KAZEN_OWNER_PHONE`, `KN_WHATSAPP_*`; **no aparece ninguna `KAZEN_WAHA_*` ni `KI_MAX_MEDIA_MB`**. Las variables del contrato son nuevas, no implementadas.
- `cat .kaizen/team/projects/whatsapp-waha-bridge/blackboard.md` → `kaizen-team verify ... = verde (7 fuentes)`; «Hechos pendientes» confirma HMAC y live location sin verificar. **No re-ejecuté** `kaizen-team verify` ni `scripts/kaizen check`: ese último escribe métricas fuera de las dos rutas que se me autorizaron.

## Impacto — contraejemplos del retador obligatorio

1. **La firma no puede aprobarse sin vector.** Si el vector real difiere (docs enlazan SHA-256, SOURCES.md:51), una implementación «razonable» puede rechazar todo tráfico legítimo **o** aceptar peticiones forjadas. Un control de autenticación cuyo vector es `unknown` no es verificable (K-10).
2. **Escalada de identidad en el código actual (contraejemplo concreto).** Cualquier remitente que pase `X-Kaizen-Secret` obtiene hoy el encabezado «Instrucción de El Presidente» (`kaizen-inbox.py:80`). Un usuario ajeno, un grupo o un mensaje de un agente podrían presentarse como orden del dueño. Además, la firma no puede calcularse sobre el raw body si el cuerpo ya fue parseado en `:65`, y `!=` en `:57` es comparable en tiempo. Esto **no es solo aditivo**: exige reordenar el flujo de ingress.
3. **SSRF por redirección/URL relativa.** Validar solo el `host` del string recibido es insuficiente si WAHA devuelve URLs relativas, `userinfo`, o si el cliente sigue redirects. Sin la forma real del payload, el control C-03 queda sin validar.
4. **Tormenta de tareas por live location.** WAHA-011 solo expone el flag `location.live`; sin frecuencia conocida, un diseño «una tarea por actualización» puede saturar runtime/leases. El contrato exige coalescencia y techo, pero no puede demostrarse hasta la POC.
5. **Anti-replay incompleto.** `X-Webhook-Request-Id` existe (WAHA-007), pero la existencia de un header de timestamp es `unknown`. Sin él, la ventana depende solo de la caché de nonce: hay que acotar memoria y evitar que un `4xx` provoque reintentos amplificadores.
6. **Superficie L-4 y legal no cubierta por diseño.** `.gitignore` es ruta protegida: este agente no puede añadir las exclusiones de sesión/medios/inbox (L-12). `cumplimiento-panama` no ha emitido veto (ADR-0002/ADR-0031:15); el daemon Docker está detenido (ADR-0026), por lo que S-16 no es verificable en runtime.

## Propuesta — condiciones para convertir en APPROVE

| # | Condición | Control | Evidencia requerida |
| --- | --- | --- | --- |
| C1 | POC del vector HMAC-SHA512 y del formato exacto de `X-Webhook-Hmac`; parser paramétrico, sin tolerancia de variantes | C-01 | Payload firmado por WAHA de prueba + tests: body alterado/re-serializado → 401 |
| C2 | Verificar HMAC sobre `raw_body` **antes** de `json.loads`; `hmac.compare_digest`; `X-Kaizen-Secret` con comparación constante | C-01.2/.3/.6 | Diff de `kaizen-inbox.py` + `grep -n compare_digest` |
| C3 | Claves separadas (`KAZEN_WAHA_HMAC_SECRET` ≠ `KAZEN_WAHA_API_KEY` ≠ `KAZEN_INBOX_SECRET`) y arranque que falla sin imprimir valores | C-01.5 | Test de arranque con valores iguales/ausentes |
| C4 | Allowlist + `KAZEN_WAHA_OWNER_CHAT_ID`, grupos y `fromMe` ignorados, `actor_kind` en frontmatter, y **eliminar la etiqueta literal** «Instrucción de El Presidente» para remitentes no verificados como dueño | C-04 | Tests de los 4 casos + `grep -n "Instrucción de El Presidente"` |
| C5 | Anti-replay con nonce atómico + respuesta `200 duplicate:true`, caché TTL acotada y política de timestamp según POC | C-02 | Test de replay; decisión documentada sobre header de timestamp |
| C6 | SSRF: host/puerto/scheme contra `KAZEN_WAHA_BASE_URL`, sin redirects o revalidados, DNS-rebinding mitigado, confirmado con payload real de media | C-03 | Test con host externo, userinfo y redirect → sin petición saliente |
| C7 | Rate limit/live location coalescido con techo, o desactivación documentada si la POC no encaja; coordenadas fuera de logs | C-05 | Test de ráfaga + evidencia de 0 task storms |
| C8 | Traversal, `KI_MAX_MEDIA_MB`, MIME/magic, permisos `0700/0600`, logs redactados, egress con allowlist + autorización del propietario y directorios salientes acotados | C-06/C-07/C-08 | Matriz de verificación de `contracts/security.md` §4 |
| C9 | Exclusiones de Git para sesión/medios/inbox/waha-data aprobadas por humano (L-4); S-16 verificado con daemon en marcha; veto `compliance` emitido o escalado | C-07.2/C-10, ADR-0002/0026 | `git check-ignore -v`, `docker compose config`, dictamen de cumplimiento |

El contrato `contracts/security.md` queda como propuesta de diseño con esos controles y su matriz de verificación. Solicito a `architect` que alinee `contracts/interfaces.md` con el frontmatter `actor_kind`/`source_ids` y con el orden de verificación HMAC→parseo; a `qa` que ejecute la POC de C1/C6/C7; y a `cumplimiento-panama` que emita su dictamen o escale.

## Pregunta concreta

¿Acepta el equipo que el diseño quede en `CHANGES_REQUESTED` hasta que QA cierre la POC (C1, C6, C7) y el humano resuelva C9, en lugar de declarar «soportado» el canal con el HMAC sin verificar? Mi recomendación: **sí** — la alternativa es construir sobre un vector de firma supuesto, lo que K-10 prohíbe.

---

*Seguridad y Auditoría — veto vinculante disponible. No se activaron flags, no se ejecutaron comandos de despliegue, no se hicieron commit/push. Ningún secreto fue leído ni impreso.*
