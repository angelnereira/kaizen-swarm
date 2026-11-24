decision_id: DEC-006
topic: Resolucion conflicto: ADR-0032 numero personal prevalece; DEC-004 OpenCode canal activo se mantiene
source_ids: ["LOCAL-005", "LOCAL-006", "WAHA-001", "META-003"]
retrieved: 2026-11-24T05:05:46Z
status: verified
human_owner: El Presidente
---

# Decisión: Resolucion conflicto: ADR-0032 numero personal prevalece; DEC-004 OpenCode canal activo se mantiene

## Evidencia
- Fuentes verificadas: 4
- Fuentes rechazadas: ninguna

## Opciones y decisión

El Presidente resolvió el conflicto de la alerta `2026-11-24-conflicto-decisiones-ciclo-concurrente.md` confirmando **ADR-0032 (número personal, modalidad "mensaje a uno mismo")** — decisión humana explícita con valor entregado el 2026-11-24.

| Decisión | Resolución |
| --- | --- |
| Número para WhatsApp (si se elige ese canal) | **ADR-0032 prevalece**: número **personal** del Presidente en modalidad "mensaje a uno mismo". Queda registrado **fuera del repo** en `${XDG_CONFIG_HOME:-$HOME/.config}/kaizen-swarm/owner.env`, variable `KAZEN_OWNER_PHONE`, permisos `600`. **El valor no se versiona ni se imprime en artefactos.** |
| Canal activo | **DEC-004 se mantiene**: OpenCode (app Android + `opencode serve`) es el medio activo preferido. WhatsApp/WAHA sigue siendo **canal opcional**, ahora con número personal confirmado. |
| Conflicto ADR-0031 vs ADR-0032 | Resuelto a favor de ADR-0032 para el caso "mensaje a uno mismo". ADR-0031 queda como línea base (número dedicado) para cualquier otro uso de WhatsApp con terceros. |

**No se activates nada**: sin escaneo QR, sin arranque de Docker, sin cambio de `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` (sigue en `0`).

## Incertidumbre y escalado

- El número personal es dato privado (OWNER.md §4): solo en `owner.env` fuera del repo; **nunca** en este proyecto, diario, ADR, commit, PR ni logs. Verificado: ningún artefacto versionado contiene el valor.
- La confirmación del número **no** levanta los dictámenes: `security` BLOCK y `cumplimiento` sin dictamen legal siguen vigentes para activar WAHA (ADR-0032 §Nota). QR y Docker son actos humanos (ADR-0018/0031 §2/§9).
- Si en el futuro se activa WhatsApp con terceros, vuelve a exigirse número dedicado + base legal/ANTAI (C3/C4). El número personal es **solo** para "mensaje a uno mismo".
