decision_id: DEC-001
topic: toolkit-externo-vs-nativo
source_ids: ["TOOL-001", "TOOL-002", "ISO-001", "NIST-001"]
retrieved: 2026-11-23T16:18:32Z
status: verified
approval: human_approved_2026-11-23
human_owner: architect
---

## Aprobación humana (2026-11-23)
El Presidente ordenó: "implementalo la idea es aprovechar en nuestro proyecto ese otro proyecto: https://github.com/kalil0321/reverse-api-engineer.git". Se adopta la **opción C con la CLI externa como generador vigente** y la ruta nativa como POC diferido. Queda registrada en `blackboard.md` como confirmación fresca (C6/S-15). ADR-0017 no se modifica; se abre ADR-0031 en `proposed`. El cap de USD 0.50 sigue siendo propuesta de FinOps: esta aprobación autoriza la integración, no un gasto ilimitado; cualquier captura se limita a 1 ejecución sobre sitio propio y se reporta su `usage.total_cost_usd` real.

# Decisión: toolkit-externo-vs-nativo

## Evidencia
- Fuentes verificadas: 4/4 (TOOL-001, TOOL-002, ISO-001, NIST-001), fecha de corte 2026-11-21, TTL 90 d, 2 d consumidos. Ninguna `pending`, `conflict` ni `stale`; REG-EV-01 satisfecho.
- `scripts/kaizen-team verify integracion-rae-api-toolkit` → RC 0, ejecutado por T1 y reconfirmado por T2.
- Hecho medible: `reverse-api-engineer --version` → 0.16.0 (MIT, `~/.local/bin`); `list --json` → `[]` (0 capturas); skill local `~/.agents/skills/reverse-api-engineer` ausente.
- REA (TOOL-001) instalada y aprobada (ADR-0009), 263 herramientas MCP verificadas en catálogo; **no contiene generador de cliente tipado** (búsquedas `typescript`/`codegen`/`swagger` → `[]`; `inspect_api_contract` solo lee).
- Coste real hoy: USD 0.00, 0 métricas en `kaizen-eval`; `usage.total_cost_usd` solo existe tras captura.
- Siete dictámenes en `reviews/`: T1 CHANGES_REQUESTED, T2 APPROVE acotado, T3 CHANGES_REQUESTED, T4 CHANGES_REQUESTED, T5 CHANGES_REQUESTED (sin BLOCK), T6 APPROVE, T7 CHANGES_REQUESTED. Ningún veto abierto.
- Detalle de memorial y contraejemplos: `reviews/architect.md`; borrador de ADR en `adr-draft.md` (proposed, no va a `docs/kaizen/adr/`).

## Opciones y decisión
- **A — dependencia externa** (ADR-0017 vigente): CLI v0.16.0 + skill. Coste hundido, reversibilidad alta; riesgos de supply chain, skill ausente, `--auto-install` y confirmación humana fresca requerida.
- **B — ruta nativa sin el repo externo** (preferencia del usuario): **no viable hoy**. Falta el generador HAR→OpenAPI→cliente tipado en el catálogo verificado; construirlo es complejidad media-alta y su coste exacto es `unknown`. No elimina el gate humano ni el riesgo de código generado.
- **C — híbrida acotada (recomendación del arquitecto y de esta coordinación)**: conservar A como capability vigente sin tocar ADR-0017; REA como capa de captura/evidencia;generator inicial TOOL-002 bajo revisión; POC time-boxeado de B (1 HAR → 1 OpenAPI → 1 cliente que compile y pase regresión) antes de cualquier ADR nuevo.

**Decisión registrada:** adoptar la dirección **C** como propuesta, con estatus `pending_human`. No es definitiva: el humano debe aprobar el ADR nuevo y la captura. ADR-0017 permanece intacto. AC-9 mide "sin depender del repo externo" como 0 imports/paquetes/llamadas CLI en código propio (menciones en `*.md` excluidas), no como mera disponibilidad de la herramienta.

## Condiciones duras antes de ejecutar
1. Humano (A) + seguridad/cumplimiento (V) para cualquier captura, instalación de skill/MCP remoto o ejecución de código generado; la aprobación general de ADR-0017 **no basta** (T5 C6).
2. Sitio propio autorizado designado por el humano; sin evasión de anti-bot (T5 C7).
3. Cap de coste aprobado: 1 captura, tope USD 0.50 (cifra propuesta por FinOps, no norma); registrar `usage.total_cost_usd` con `kaizen-eval metrics add`.
4. Prohibido `--auto-install`; fijar versión/hash de TOOL-002; revisar el script generado y el HAR saneado (0 secretos) con `kaizen-security redact` (T5 C2–C5).
5. AC-2 y AC-9 permanecen `sin confirmar` hasta la primera captura (T2/T6); no marcarlas en verde por anticipado.
6. Corregir la deriva documental por sus dueños: README:186 y `evidence.md:3` (FinOps/outsourcing) y ADR-0017 mediante ADR nuevo (arquitecto). No corregido aquí (K-7/K-1).

## Bloqueo actual (2026-11-23)
La integración quedó implementada en lo gobernable (CLI + skill instalados y con procedencia fijada, hash en `SOURCES.md`, runbook sin `--auto-install`, ADR-0031 propuesto, seguridad APPROVE, sandbox local, worktree limpio y commit `2da9a88`). La configuración local se resolvió sin credenciales (`sdk: opencode`, `agent_provider: auto`) y el preflight pasó con RC 0. **La captura del KPI se intentó una vez y falló**: RC 1, `run_id: 25244c9ac6c5`, `har_path: null`, `script_path: null`, `error: "Agent analysis produced no result."`; el log solo contiene el prompt, sin respuesta del modelo. No se ejecutó una segunda captura porque el cap autorizado era de una sola ejecución. Registrado en `.kaizen/loop/outbox/rae-api-capture-sin-resultado.md` y escalado en `needs-human/2026-11-23-block-modelo-analisis.md`. El proyecto permanece en `deliver`; no se avanza a `verify` ni se fabrica evidencia (K-10/L-9). Requiere decisión humana: modelo disponible con nuevo permiso de captura, o KPI cerrado como `needs-human`.

## Incertidumbre y escalado
- `unknown`: viabilidad end-to-end del generador nativo (POC no ejecutado), AC-2, coste real por captura, liberación real de EDQUOT (`df -h` no la prueba), sitio autorizado y confirmación humana fresca.
- Disidencia registrada: el retador objetó su propia recomendación C (riesgo de dos pipelines y dependencia remanente), B (capacidad ausente y gobernanza irreversible) y A (supply chain y aprobación fresca). Ver `reviews/architect.md`.
- Escalado a El Presidente: aprobar/rechazar C, designar sitio propio, autorizar cap y confirmar instalación de skill; sin esos datos el estado es **"sin evidencia para decidir"** y no se elige B por preferencia (K-10/L-6).
- Verificación L-9: comparar antes (0 capturas / skill ausente / generador nativo inexistente / deriva documental) contra después (1 captura verificada + POC medido o escalado + ADR humano). Si el KPI no mejora, `regression-suspect` y revert propuesto.
