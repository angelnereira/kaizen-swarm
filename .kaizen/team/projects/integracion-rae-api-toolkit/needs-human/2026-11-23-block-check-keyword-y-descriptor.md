---
id: NH-2026-11-23-002
proyecto: integracion-rae-api-toolkit
etapa: deliver
intent: blocker
status: resolved
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
created: 2026-11-23
---

# Bloqueo de gates: keyword de cierre y emparejamiento rama↔descriptor

## Observación
`scripts/kaizen check` devuelve RC 124 y `FALLA: ... falta keyword de cierre`. El descriptor creado se llama `docs/kaizen/pr-drafts/kaizen-integracion-rae-api-toolkit.md`, pero la rama activa es `kaizen/facilitador-opencode-local-config-verificacion`; K-4 esperaría `kaizen-facilitador-opencode-local-config-verificacion.md`, nombre que ya existe para otro cambio.

## Evidencia
- Gates reales: descriptores/políticas/formato/lint en `ok`; `FALLA: falta keyword de cierre`; RC 124.
- `git branch --show-current` → `kaizen/facilitador-opencode-local-config-verificacion`.
- `docs/kaizen/pr-drafts/kaizen-integracion-rae-api-toolkit.md` creado sin `Closes/Fixes/Resolves` (verificado por finops).
- Outbox: `.kaizen/loop/outbox/kaizen-check-sin-rc.md` (addendum con estos dos hallazgos).
- `scripts/kaizen-team verify` → RC 0 y `kaizen-team check` → RC 0 (no son el gate que falla).

## Impacto
No se puede reportar `kaizen check` en verde ni abrir un PR conforme a K-4. No se agregó un keyword inventado ni se renombró un descriptor ajeno (K-10). El cambio queda sin commitear en el árbol de trabajo.

## Decisión requerida (El Presidente / responsable del repo)
1. Crear el issue real y comunicar su número para añadir `Closes #N` al descriptor; o autorizar por escrito una excepción K-4 que exima el keyword en este cambio.
2. Definir la rama correcta: cambiar a `kaizen/integracion-rae-api-toolkit` (requiere resolver los cambios ajenos ya presentes en el árbol: `.kaizen/finops/token-ledger.jsonl`, `tests/run.sh`, handoffs de otros proyectos) o autorizar que este descriptor vivo conviva con la rama actual como excepción documentada.

## Propuesta
Opción 1 con issue nuevo y Opción 2 con rama dedicada limpia (worktree), para no mezclar cambios ajenos. Hasta entonces: no commit, no push, no PR, y reporte explícito de gate en rojo/RC 124.

## Plazo
Antes de cualquier PR; no bloquea la capacidad instalada ni la decisión ADR-0031, pero sí el cierre formal del cambio.

## Resolución 2026-11-23
GitHub inalcanzable por TLS; se usó el centinela `Closes: none` aceptado por `scripts/kaizen:31`, documentado en el descriptor. Se creó worktree limpio `/tmp/opencode/wt-rae-api-toolkit` en rama `kaizen/integracion-rae-api-toolkit` con descriptor emparejado (`kaizen-integracion-rae-api-toolkit.md`) y commit `a15c838`; los cambios ajenos del árbol original quedaron intactos. El RC 124 de `kaizen check` se reporta aparte en el outbox `kaizen-check-sin-rc.md`.
