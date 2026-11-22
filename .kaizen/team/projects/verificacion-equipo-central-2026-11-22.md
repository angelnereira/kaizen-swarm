---
id: VERIF-EQ-CENTRAL-2026-11-22
correlation_id: EQ-CENTRAL-KPI-2026-11-22
channel: review
intent: review
expects_ack: false
deadline: 2026-11-29T18:00:00Z
source_ids:
  - PA-009
  - PA-012
  - PA-015
  - INT-002
status: completed
created: 2026-11-22T06:18:41Z
---

# Dictamen — verificación del KPI del equipo `equipo-central` (2026-11-22)

**Dictamen: CHANGES_REQUESTED** — el paso `kaizen-team verify` del disparador sale código 1 (Hallazgo H-1); el disparador documentado del equipo no se ejecuta como está escrito. La puerta decide→deliver está abierta (0 decisiones con fuentes pending/conflict/stale, Hallazgo H-5).

## Hallazgos (comandos reales, salidas reales)

- **H-1 (salida 1):** `./scripts/kaizen-team verify` → `./scripts/kaizen-team: line 137: $1: unbound variable`. El script espera `<slug>` (uso: `verify <slug>`; `proj_ok` rechaza slugs desconocidos) y sale al invocarlo sin argumentos con `set -u`.
- **H-2 (salida 0, neutro):** `./scripts/kaizen-team status` → `proyectos:` (0 proyectos). `verify` es váctico por definición: no hay `state.json` en `.kaizen/team/projects/`.
- **H-3 (contexto):** `ls .kaizen/team/projects/` → `finding-platform-engineer-rollback-20261122.md`, `finding-bpa-capacidades-v1-20261122.md`; sin dirs de proyecto ni `decisions/*.jsonl`.
- **H-4 (contexto):** `ls .kaizen/org/decisions/inbox/` → `ai-20261122-060818.md`, `ai-rag-engineer-20261122-060819.md`, `analista-negocios-20261122-060819.md` — propuestas proactivas sin `source_ids` ("sin evidencia no hay decisión", K-10).
- **H-5:** `docs/kaizen/journal/` → vacío.

## Fuentes aceptadas (verificadas, per REG-EV-01..07)

PA-001, PA-002, PA-003, PA-004, PA-005, PA-006, PA-007, PA-008, PA-010, PA-011, PA-013, PA-014, ISO-001, ISO-002, NIST-001, AICPA-001, PCI-001, OWASP-001, INT-001, LOCAL-001, LOCAL-002, LOCAL-003, LOCAL-004 — **23 verificadas** (según la salida de `kaizen-team check`: exit 0, `todo en verde (23 fuentes verificadas)`).

## Fuentes rechazadas (pending / conflict / stale)

- **Pendientes (no sostienen decisión, bloquean por REG-EV-01):** PA-009 (DGI, Tasas especiales y Facturación Electrónica SFEP), PA-012 (Asamblea Nacional, Ley 82/2012 y DE 684/2013 Registro Público), PA-015 (Gaceta/Legispan, rutas y patrón de PDFs), INT-002 (IFRS Foundation, IFRS 15/9/16).
- **Conflict:** ninguna.
- **Stale:** ninguna — la tabla de `SOURCES.md` no incluye estatus `stale` ni `retrieved` por fuente (KT_EVIDENCE_TTL_DAYS=90 en `.kaizen/team/team.env`).

## Cantidad de decisiones con fuente pending/conflict/stale

**0.** No hay decisiones con `source_ids`: el equipo tiene 0 proyectos (`status` vacío); 0 archivos `DEC-*` en `docs`/`.kaizen`; las 3 propuestas de `.kaizen/org/decisions/inbox/` no tienen `source_ids` y "sin evidencia no hay decisión" (K-10). Etapa decide → deliver sin bloqueos.

## Cambio requerido

Hacer que el disparador `kaizen-team verify` se ejecute sin slug: default `${1:-}` como hace `cmd_status`, y verificar todos los proyectos o salir 0 si no hay; y definir el slug del proyecto de equipo-central si el KPI "una decisión verificada por ciclo" debe tener evidencia de decisión verificada.
