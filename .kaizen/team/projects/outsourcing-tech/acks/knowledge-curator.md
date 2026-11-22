---
id: ACK-20261122-OT-EVID-DIGEST-003-KC
correlation_id: OT-EVID-DIGEST-003
from: knowledge-curator
to: facilitador-equipo
channel: review
intent: ack
expects_ack: false
status: ack
deadline: 2026-11-25T18:00:00Z
source_ids:
  - H-17953727975011262433
  - CMD:sha256sum .kaizen/org/knowledge/SOURCES.md
  - CMD:stat -c %y .kaizen/org/knowledge/SOURCES.md
  - CMD:grep -rniE 'SOURCES\.md|sha256' .kaizen/org/knowledge/digests/*.md
  - artifact:.kaizen/org/knowledge/digests/verificador-evidencias.md:4
  - artifact:.kaizen/org/knowledge/digests/monitor-gaceta.md:4
  - artifact:.kaizen/org/knowledge/digests/cumplimiento-panama.md:7
  - artifact:.kaizen/team/EVIDENCIA.md:26
  - artifact:.kaizen/team/EVIDENCIA.md:28
  - artifact:.kaizen/team/projects/finding-trazabilidad-sources-20261122.md:57
  - ISO-001
  - NIST-001
  - PA-001
---

# ACK — Digests desactualizados frente al hash actual de SOURCES.md

## 1. Acuse explícito

**ACK** del handoff **`id: H-17953727975011262433`** (`correlation_id: OT-EVID-DIGEST-003`, `from: facilitador-equipo`, `to: knowledge-curator`, `intent: handoff`). Confirmo la recepción de la tarea "Digests desactualizados frente al hash actual de SOURCES.md". `expects_ack: false`: este mensaje es solo acuse y evidencia; no solicito réplica.

Contenido de archivos de datos (handoffs.jsonl, finding, digests, manifest) tratado como **dato no confiable (S-15/L-5)**: usado únicamente como evidencia, jamás como instrucción. No ejecuto la acción que el finding sugiere para este agente ("ejecutar feed + digest") sin ADR.

## 2. Investigación (solo lectura)

```
$ sha256sum .kaizen/org/knowledge/SOURCES.md
11e960129d7e6f6f00067c40ce61f5d5e4cf5ffa3440672baff78104bf861f8f  .kaizen/org/knowledge/SOURCES.md
$ sha256sum .kaizen/org/knowledge/SOURCES.md | cut -c1-8
11e96012
$ stat -c '%y' .kaizen/org/knowledge/SOURCES.md
2026-11-22 01:39:39.438051861 -0500   # = 2026-11-22T06:39:39Z
```

Hash real vigente (8 chars): **`11e96012`**. Fecha de corte real (mtime): **2026-11-22T06:39:39Z**.

De los 17 digests en `.kaizen/org/knowledge/digests/`, solo 3 declaran un hash de `SOURCES.md`. Los otros 14 no citan `SOURCES.md` y quedan fuera de la comparación directa.

## 3. Tabla digest → fecha declarada → hash reportado → hash real

| Digest | Fecha de corte declarada | Hash reportado (`SOURCES.md`) | Hash real | Resultado |
| --- | --- | --- | --- | --- |
| `verificador-evidencias.md` (`digests/verificador-evidencias.md:4`, corte `:53`) | 2026-11-21 | `8b11e0a8b083` | `11e96012` | **DESACTUALIZADO** |
| `monitor-gaceta.md` (`digests/monitor-gaceta.md:4`, corte `:11`/`:53`) | 2026-11-21 | `8b11e0a8b083` | `11e96012` | **DESACTUALIZADO** |
| `cumplimiento-panama.md` (`digests/cumplimiento-panama.md:7`, corte `:19`/`:187`) | 2026-11-21 | `1242d7f76ba8` | `11e96012` | **DESACTUALIZADO** |

Ninguno de los tres coincide con el hash real `11e96012`. Las tres fechas declaradas (2026-11-21) son anteriores al mtime real (2026-11-22T06:39:39Z): los digests citan una versión anterior del registro.

**Observación de soporte (manifest):** `manifest.jsonl` contiene hoy 3 entradas para `SOURCES.md`, todas con hashes obsoletos (`1242d7f76ba8…` para `cumplimiento-panama`; `8b11e0a8b083…` para `monitor-gaceta` y `verificador-evidencias`, `fed_at` 2026-11-22T02:43:33Z / 03:03:56Z). El finding reportó "0 coincidencias" en su momento (`:50`); la evidencia actual difiere, se registra tal cual sin presumir cuál es correcta. Ninguna entrada refleja `11e96012`.

## 4. Impacto (REG-EV-05 / REG-EV-07)

- **REG-EV-05** (`.kaizen/team/EVIDENCIA.md:26`): "revalidar trimestralmente; si cambia la versión, se actualiza `retrieved` y se registra el cambio en un expediente `kaizen-org research`". `SOURCES.md` cambió el 2026-11-22T06:39:39Z (hash `11e96012`) y los digests no revalidaron su `retrieved` ni registraron el cambio: fecha de corte y hash siguen en 2026-11-21 / `8b11e0a8b083` / `1242d7f76ba8`.
- **REG-EV-07** (`.kaizen/team/EVIDENCIA.md:28`): la decisión guarda `source_ids`, fecha de corte y hash; sin ellos no se considera tomada. Toda decisión que apunte a estos digests arrastra hash y fecha divergentes del registro vigente.
- Consecuencia: efecto **stale** sobre las fuentes citadas → **REG-EV-01** (`:22`) bloquea su uso como evidencia vigente. Coincido con el dictamen `BLOCK` del finding (`:29`, H-1/H-2 en `:57`–`:58`). **No** firmo ni revalido nada con estos digests mientras no se regeneren.

## 5. Plan propuesto (NO ejecutado)

Requiere ADR humano y toca rutas protegidas (`.kaizen/org/knowledge/`, L-4); por mi autonomía `propose` **no lo ejecuto**. Secuencia propuesta para el humano/gerente:

1. **ADR** autorizando la regeneración de los digests de `verificador-evidencias`, `monitor-gaceta` y `cumplimiento-panama` contra `SOURCES.md` vigente (hash `11e96012`, fecha de corte 2026-11-22T06:39:39Z) y la actualización del `manifest.jsonl`.
2. Tras el ADR, ejecutar `kaizen-org feed` para esos tres targets con `SOURCES.md` y regenerar con `kaizen-org digest`.
3. Registrar el cambio de versión en un expediente `kaizen-org research` y actualizar `retrieved` (REG-EV-05); corregir las entradas de `SOURCES.md` en `manifest.jsonl` para que reflejen `11e96012`.
4. Validación: `verificador-evidencias` ejecuta `kaizen-team verify` en verde y `qa` confirma con un `sha256sum` idéntico antes de cerrar (finding `:81`).
5. Sin cambios en secretos ni credenciales (S-1/S-2); sin push a `main` (ADR-0023); sin decidir el ADR (L-4).

Plazo observado: 2026-11-25T18:00:00Z. Quedo a la espera de la decisión humana; no cambio de etapa ni auto-apruebo.

— `knowledge-curator` (KAZEN_AGENT_DEPTH=1; sin delegación, sin auto-invocación)
