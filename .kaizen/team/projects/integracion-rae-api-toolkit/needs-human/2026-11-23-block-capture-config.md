---
id: NH-2026-11-23-001
proyecto: integracion-rae-api-toolkit
etapa: deliver
intent: blocker
status: resolved
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
created: 2026-11-23
---

# Bloqueo: credenciales/configuración de modelo para la captura de prueba

## Observación
El Presidente autorizó la integración del toolkit externo y el sandbox local está listo. La CLI y el skill están instalados. El preflight sin navegador devolvió RC 1: falta `~/.reverse-api/config.json` (sdk/modelo) y apareció una referencia a variable `api_key` detectada solo por categoría, sin imprimir valor.

## Evidencia
- `reverse-api-engineer --version` → 0.16.0; `list --json` → `[]`; skill presente en `~/.agents/skills/reverse-api-engineer`.
- `agent ... --dry-run` → RC 1 (detector por conteos/categorías; sin valores copiados).
- `test -f ~/.reverse-api/config.json` → RC 1.
- Seguridad: `APPROVE` con visto bueno para una captura en `127.0.0.1:8765` y guardrails.
- Outbox S-11: `.kaizen/loop/outbox/rae-api-preflight-sin-config.md`.

## Impacto
El KPI (1 captura con `run_id` + HAR saneado + coste registrado) no puede completarse ni verificarse. La decisión ADR-0031 queda en `proposed`; no se avanza a `verify` y no se fabrica evidencia (K-10/L-9).

## Decisión requerida (El Presidente)
1. Configurar localmente `~/.reverse-api/config.json` con el sdk/modelo que usted autorice, **sin compartir credenciales en este chat, logs ni repo** (S-1/S-2). O
2. Autorizar alternativamente que se documente el KPI como `needs-human` y se cierre la integración sin captura, dejando el POC nativo diferido.

## Propuesta
Opción 1, con cap de 1 captura y coste real a registrar; proveedor recomendado por el especialista: `auto` (Playwright MCP) con `--headless`, que conserva `har_path`. Una vez configurado, se re-ejecuta preflight y solo con RC 0 se captura.

## Plazo
Antes de pretender cerrar `DEC-001`/ADR-0031; sin esto el proyecto se mantiene en `deliver` con bloqueo abierto.

## Resolución 2026-11-23
El Presidente ordenó resolverlo. Se creó `~/.reverse-api/config.json` con `sdk: opencode` (sin credenciales), `agent_provider: auto`, `output_language: python`. Preflight `--dry-run --json` → RC 0, `status: ok`, `provider: auto`. Bloqueo de configuración cerrado; la captura se ejecuta bajo el visto bueno de seguridad ya emitido.
