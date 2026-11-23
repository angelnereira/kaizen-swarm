---
id: NH-2026-11-23-003
proyecto: integracion-rae-api-toolkit
etapa: deliver
intent: blocker
status: open
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
created: 2026-11-23
---

# Bloqueo: el SDK opencode no produjo análisis en la captura

## Observación
Configuración local resuelta (preflight RC 0), sandbox propio saludable y visto bueno de seguridad vigente. La única captura permitida devolvió RC 1 con `error: "Agent analysis produced no result."`, sin HAR ni cliente generado (`run_id: 25244c9ac6c5`).

## Evidencia
`reverse-api-engineer agent ... --json` → RC 1, `status: error`, `har_path: null`, `script_path: null`, `cost: null`. Log del run: 1 evento `prompt`, sin respuesta de modelo. Outbox: `.kaizen/loop/outbox/rae-api-capture-sin-resultado.md`. Config: `sdk: opencode`, `agent_provider: auto`, modelo por defecto `big-pickle` (`config.py:9`).

## Impacto
KPI incompleto (0 capturas válidas, 0 HAR saneado, 0 coste registrado). No se avanza a `verify`; no se reporta éxito (K-10/L-9).

## Decisión requerida
1. Autorizar un modelo disponible para el SDK `opencode` (o change de SDK) dentro del cap ya propuesto, sin compartir credenciales; o
2. Aceptar el KPI como `needs-human` y cerrar la integración con la capacidad instalada y gobernada, dejando la captura como deuda explícita.

## Propuesta
Opción 1 con un modelo confirmado disponible y UNA nueva captura solo si el humano levanta explícitamente el guardrail de "una sola captura" (el intento fallido no produjo HAR ni gasto, pero el cap era estricto). Si no hay modelo disponible sin gasto, Opción 2.

## Plazo
Antes de cerrar ADR-0031 y el cambio. Sin esto no hay verificación L-9.
