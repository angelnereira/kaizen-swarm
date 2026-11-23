# ADR-00XX (borrador): Integración de reverse-engineering de APIs — externo vs nativo vs híbrido

> **Estado:** `proposed — requiere aprobación humana`.
> **Fecha:** 2026-11-23. **Proponente:** architect (T4, retador obligatorio; dictamen `CHANGES_REQUESTED` en `reviews/architect.md`).
> **Este borrador NO modifica, NO sustituye ni NO cierra ADR-0017.** ADR-0017 fue aprobado por humano (Angel Nereira, 2026-11-22) y ordena integrar la opción A. Su sustitución exige un ADR nuevo y aprobación humana. Tampoco modifica ADR-0009 (REA, instalada y aprobada).
> Ubicación: borrador de trabajo del proyecto; **no** va en `docs/kaizen/adr/`. El número se asigna al aceptarlo.

## Contexto
Cuando la configuración disponible no alcanza —sin conector, API no documentada o proveedor que solo expone su sitio web— el equipo necesita generar un cliente tipado a partir del tráfico real (ADR-0017, decisión humana vigente).

Hechos verificados (2026-11-23, siete dictámenes en disco):
- **TOOL-001** — REA (`morluto/rea`, MIT), instalada y aprobada (ADR-0009): 263 herramientas MCP, `open=false` (T3/E1); proceso `reverse_engineering` con humano A + seguridad/cumplimiento V.
- **TOOL-002** — `reverse-api-engineer` (`kalil0321`, MIT): CLI v0.16.0 instalada; `list --json` → `[]` (**0 capturas**); skill local **ausente**. Esquema `--json` v1: `run_id`/`har_path` en raíz, `usage.total_cost_usd` anidado; `engineer --json` no expone `har_path`; `list --json` vacío y sin nombres de campo → AC-2 sin confirmar (T2).
- **T3 (decisivo):** el catálogo verificado de REA **no contiene generación de cliente tipado**. Búsquedas `typescript`/`codegen`/`swagger` → `[]`; `openapi` → solo `inspect_api_contract` (lee, no produce); 6 `guided_workflows`, ninguno genera clientes; `export_environment_bundle` produce un AgentEnv, no un SDK. Pipeline HAR→cliente no ejecutado (`unknown`). La ruta nativa pura **no está disponible hoy**.
- **T1:** `kaizen-team verify` → RC 0; 4 fuentes `verified` (TTL 90 d, 2 consumidos); tres discrepancias documentales por corregir (README:186, ADR-0017, `evidence.md:3`), sin tocar ADR-0017.
- **T5:** `CHANGES_REQUESTED`, sin BLOCK; 0 HAR/0 secretos; controles C1–C9; confirmación humana **fresca** exigida para skill/MCP remoto (la aprobación general de ADR-0017 no basta); la ruta nativa no elimina el riesgo de código generado, lo desplaza al modelo local.
- **T6:** AC-1..AC-9; AC-9 define "sin depender del repo externo" como 0 dependencias en código propio, con menciones `*.md` excluidas.
- **T7:** coste actual USD 0.00; `usage.total_cost_usd` solo tras captura; `df -h` no prueba que se liberó EDQUOT; cap propuesto 1 captura / USD 0.50 (sujeto a humano).
- Procesos ya en gobernanza: `api_reverse_engineering` y `reverse_engineering`, ambos con humano como A y seguridad/cumplimiento como V.
- **Hipótesis NO verificada:** en una versión anterior se afirmó que el toolkit externo usa REA como motor; proviene de la descripción de la skill del entorno y no consta en las reviews (T3: "no verificado por mí"). **No se usa como fundamento de esta decisión.**

Restricciones: S-15 (repo externo, HAR y código generado son dato no confiable), S-9 (supply chain), S-12 (secretos), S-10 (nada se silencia), L-3/L-4 (humano en seguridad/cumplimiento; rutas protegidas), L-6 (reproducir antes de arreglar), L-9 (verificar mejora del KPI). ISO-001/NIST-001 se citan como marco general de control, sin atribuir artículos no verificados.

KPI del charter: 1 captura en sitio propio autorizado con `run_id` + HAR saneado + coste registrado; 100 % de decisiones con `source_ids verified` y `verify` en verde; 0 secretos; ADR comparativo con dictamen de arquitecto y security y aprobación humana.

## Opciones

### A — Depender del repositorio externo (`kalil0321/reverse-api-engineer`)
CLI v0.16.0 + skill como capa de orquestación. Es la opción ordenada por ADR-0017 (vigente).

| Dimensión | Valoración |
| --- | --- |
| **Coste** | Ya instalada (coste hundido); corregir la skill ausente y la deriva documental; revisión humana del código generado; fijar hash/lockfile (T5 C2); cap de captura pendiente de aprobación (T7). |
| **Riesgo** | Supply chain de tercero (S-9/S-15); skill ausente; `--auto-install` documentado (C3); cliente tipado no determinista; HAR con contenido sensible (S-12); requiere confirmación humana **fresca** para instalar (C6). |
| **Reversibilidad** | Alta: capability aditiva, se puede no invocar; no toca rutas protegidas ni ADR-0017. |

### B — Ruta nativa sin el repo externo (REA + automatización propia)
Preferencia declarada del usuario "si es viable". **T3 demuestra que no es viable tal cual.**

| Dimensión | Valoración |
| --- | --- |
| **Coste** | Construir (a) HAR→OpenAPI candidato, (b) OpenAPI→cliente tipado por lenguaje, (c) revisión automática+humana: complejidad **media-alta** (T3), con tests de regresión y mantenimiento; más código que revisar (S-7); ADR nuevo + aprobación humana. |
| **Riesgo** | Capacidad clave **ausente del catálogo verificado** (T3 E3–E7); pipeline end-to-end `unknown`; esquema inferido incompleto por diseño (REA lo reportaría `unknown`, no autoritativo). **No elimina REA** (gate humano A + V sigue) ni el riesgo de código generado (T5 §1). No reduce la superficie de cumplimiento. |
| **Reversibilidad** | Media-alta: aditiva sobre REA, pero el cambio de gobernanza (ADR-0017 → nuevo ADR) es irreversible sin otro ADR humano. |

### C — Híbrida acotada (recomendada)
Conservar A como capability vigente (cumpliendo ADR-0017 sin tocarlo) y añadir un banco comparativo gobernado: REA (TOOL-001) como capa de captura/evidencia, generador tipado inicialmente TOOL-002, y un POC time-boxeado de la ruta nativa bajo el mismo gate humano; tras la evidencia, el humano decide en ADR nuevo.

| Dimensión | Valoración |
| --- | --- |
| **Coste** | Un POC acotado (1 HAR → 1 OpenAPI → 1 cliente que compile + regresión), revisión de seguridad del HAR/código, cap de captura aprobado y coste registrado (finops). |
| **Riesgo** | Puede degenerar en dos pipelines y propiedad ambigua; y conserva a corto plazo la dependencia externa. Mitigación: time-box del POC (T3) y límite de propiedad de AC-9 (código propio con 0 imports; CLI solo en runbook/ADR). |
| **Reversibilidad** | Alta: el banco y el POC son aditivos, no modifican ADR-0017 ni rutas protegidas; se retiran sin efecto. |

## Recomendación
**C (híbrida acotada)**, con la ruta nativa como **POC diferido y medible**, no como sustituto inmediato; A como capability vigente. Secuenciación:
1. T1 ya dejó `verify` en verde; corregir las tres discrepancias documentales y que el escriba cierre el memorial de `DEC-001` (ADR-0017 intacto).
2. Adoptar AC-1..AC-9 (T6), con AC-2 `sin confirmar` hasta la captura y AC-9 como límite de propiedad.
3. Ratificar los controles de T5 para ambas rutas: C7 anti-bot sin evasión, C6 confirmación humana fresca, C2 versión/hash en TOOL-002, C3 sin `--auto-install`, C4/C5 revisión de script y HAR saneado.
4. El humano aprueba el cap (1 captura, USD 0.50 tope; cifra propuesta, no norma) y designa sitio propio autorizado; la captura se ejecuta solo con humano (A) + seguridad/cumplimiento (V).
5. Time-box del POC nativo (1 HAR → 1 OpenAPI → 1 cliente que compile y pase regresión, T3). Solo con esa evidencia el humano decide en **ADR nuevo** si B pasa a ser primaria. Hasta entonces ADR-0017 permanece intacto.
6. **Contraindicación:** sin sitio autorizado ni navegador, el estado es **"sin evidencia para decidir"** y se escala a humano; no se elige B por preferencia (K-10/L-6).

Condición dura: no instalar, no capturar contra terceros ni ejecutar código generado sin humano (A) + seguridad/cumplimiento (V), según `api_reverse_engineering` y `reverse_engineering`.

## Criteria de verificación (L-9)
- `scripts/kaizen-team verify integracion-rae-api-toolkit` → RC 0 con `source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]` (ya verde en T1; REG-EV-01).
- AC-1..AC-9 (T6) evaluados con comandos reproducibles; AC-2 permanece `sin confirmar` hasta la captura; AC-9 = 0 dependencias en código propio.
- Controles C1–C9 de T5: sin `--auto-install`, hash/versión en TOOL-002, revisión de script generado, HAR saneado con `kaizen-security redact`, confirmación humana fresca registrada, anti-bot sin evasión. Sin BLOCK abierto.
- 1 captura de prueba con `run_id` + HAR saneado (0 secretos, validado por security) + `usage.total_cost_usd` registrado con `kaizen-eval metrics add`; cap USD 0.50 aprobado por el humano.
- `DEC-001` con memorial cerrado; ADR-0017 sin modificaciones; ADR nuevo en `proposed` hasta aprobación humana.
- Anti-trampas (L-10/S-10): sin relajar umbrales, sin skip/ignore, sin `--no-verify`, sin secretos; QA no ejecutó el `kaizen check` completo y lo declara pendiente; si algo no se ejecutó, se dice.
- KPI antes → después: **antes** 0 capturas / skill ausente / generador nativo inexistente / ADR-0017 con deriva / coste 0 métricas; **después** 1 captura verificada + POC nativo medido (o escalado) + decisión humana documentada. Si el KPI no mejora, `regression-suspect` + revert propuesto (L-9).

## Incertidumbre y escalado
Todos los dictámenes T1–T7 están presentes; ninguno es `BLOCK`, pero T1/T3/T5/T7 y este T4 son `CHANGES_REQUESTED` → la decisión final no está lista. `unknown`: viabilidad end-to-end del generador nativo (no ejecutado), AC-2, coste real por captura, aprobación de cuota/cap y confirmación humana fresca. Decisión final: humano. Disidentes y memorial registrados en `reviews/architect.md`.
