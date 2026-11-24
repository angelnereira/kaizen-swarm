---
id: MSG-T4-ARCH-001
correlation_id: integracion-rae-api-toolkit
from: architect
to: [facilitador-equipo, verificador-evidencias, reverse-api-specialist, rea-specialist, security, qa, finops]
channel: review
intent: finding
dictamen: CHANGES_REQUESTED
handoff: H-20261123161721-4
task: T4 ADR comparativo externo vs nativo/hibrido con retador y memorial
expects_ack: true
deadline: 2026-11-30
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
status: open
created: 2026-11-23T16:40:00Z
refs:
  - .kaizen/team/projects/integracion-rae-api-toolkit/plan.md
  - .kaizen/team/projects/integracion-rae-api-toolkit/adr-draft.md
  - docs/kaizen/adr/0017-integracion-reverse-api-engineer.md
---

# Dictamen del arquitecto — T4 (retador obligatorio)

## Observación
La comparación A (repo externo) / B (ruta nativa) / C (híbrida) está redactada en `adr-draft.md` con estado `proposed — requiere aprobación humana`. **ADR-0017 no se modifica ni se cierra**: es decisión humana aprobada que ordena integrar A; su sustitución exige ADR nuevo y aprobación humana. Los siete dictámenes del proyecto ya están en disco: T2 y T6 `APPROVE` (acotado), T1, T3, T5, T7 `CHANGES_REQUESTED`, y este T4 `CHANGES_REQUESTED`. No hay `BLOCK` abierto; `kaizen-team verify` está en verde (T1, RC 0). La conclusión de T3 cambia el encuadre: la ruta nativa pura **no está disponible hoy**, no por falta de captura, sino porque el catálogo verificado de REA no contiene generación de cliente tipado.

## Evidencia (comandos y artefactos reales, 2026-11-23)
- **T1 (verificador):** `scripts/kaizen-team verify integracion-rae-api-toolkit` → RC 0; 4 fuentes `verified` (TOOL-001, TOOL-002, ISO-001, NIST-001), TTL 90 d con 2 d consumidos; `reverse-api-engineer --version` → `0.16.0`; `list --json` → `[]`; skill local ausente en `~/.agents/skills` y `~/.config/opencode/skills`. Tres discrepancias documentales no corregidas: `README.md:186`, ADR-0017 (líneas 3/5/15/27) y `evidence.md:3` (mitad falsa: "skill copiado"). `DEC-001` está `verified` pero con contenido de plantilla: el memorial de este dictamen cubre esa laguna; el escriba/facilitador debe copiarlo (yo no escribo DEC-001 por restricción de salida).
- **T3 (rea-specialist):** `tools.rea.binary_session` → REA 6.10.1, 263 herramientas, `open=false` (TOOL-001). Búsquedas `typescript`, `codegen`, `swagger` → `[]`; `openapi` → solo `inspect_api_contract` (**lee**, no produce); `guided_workflows list` → 6 flujos, **ninguno genera clientes** (E1–E5). `export_environment_bundle` produce un AgentEnv, **no un cliente tipado** (E7). Conclusión: eliminar la dependencia exige construir (a) HAR→OpenAPI, (b) OpenAPI→cliente tipado, (c) revisión automática+humana; complejidad media-alta; pipeline HAR→cliente **no ejecutado** (`unknown`). Recomienda híbrida con nativa como POC diferida.
- **T2 (reverse-api-specialist):** `APPROVE` acotado; runbook `runbooks/rae-api-runbook.md` creado. Esquema `--json` (schema_version 1): `run_id` y `har_path` en la raíz, `usage.total_cost_usd` anidado bajo `usage`; `engineer --json` **no expone** `har_path`; `list --json` está vacío y su `--help` no enumera campos → AC-2 (filtrar `.run_id`) **sin confirmar** hasta la primera captura (K-10). El APPROVE no autoriza captura.
- **T6 (qa):** `APPROVE`; criterios AC-1..AC-9 con comandos reproducibles. AC-1 = prueba que falla hoy (`list --json` → `[]`). AC-9 mide "sin depender del repo externo" como **0 imports/paquetes/CLI en código propio**; las menciones en `*.md` quedan excluidas y, en híbrido, la dependencia se confina al runbook y al ADR. QA no ejecutó el `kaizen check` completo: queda pendiente para el cierre (K-10).
- **T5 (security):** `CHANGES_REQUESTED`, no BLOCK; 0 HAR, 0 secretos, sin instalación ni código generado ejecutado. Controles C1–C9: falta hash/versión fijada en TOOL-002 (C2), eliminar `--auto-install` del runbook (C3), definir revisión de script y HAR saneado (C4/C5), confirmación humana **fresca** para skill/MCP remoto — la aprobación general de ADR-0017 no basta (C6), anti-bot sin evasión (C7), `verify` en verde (C8). Advierte que la ruta nativa **no elimina** el riesgo de código generado: lo desplaza al modelo local y amplía la superficie MCP. BLOCK automático si se instala skill/MCP, se ejecuta código generado sin revisión, se captura a terceros o aparece un secreto (S-12).
- **T7 (finops):** `CHANGES_REQUESTED`; coste actual medible USD 0.00 (0 capturas, 0 métricas); `usage.total_cost_usd` solo existe tras captura autorizada; `df -h` (140 G libres) **no** demuestra que se liberó la cuota de usuario (`Errno 122`/EDQUOT). Propone cap de **1 captura, tope USD 0.50** — cifra propuesta, no norma: la aprueba o corrige el humano. `cost_cap: por aprobar` en el contrato.

## Impacto
- La preferencia del usuario por B descansa sobre un hecho falso: B no es "REA + automatización propia" ya disponible; REA cubre captura/inspección/evidencia, pero **no genera clientes tipados** (T3, E3–E7). Elegirla hoy sería comprometerse a un proyecto de ingeniería media-alta sin pipeline probado (K-10/L-6), además de requerir ADR nuevo y aprobación humana.
- AC-9 (T6) muestra que "no depender del repo externo" **ya es medible y alcanzable bajo C**: 0 dependencias en código propio; la CLI queda confinada al runbook/ADR como texto documental. El coste de reconstruir el generador puede ser innecesario para satisfacer la preferencia declarada.
- A tampoco es llave en mano: skill local ausente, sin hash/lockfile, `--auto-install` documentado, deriva documental y necesidad de confirmación humana fresca para instalar (T5 C6).

## Contraejemplos (retador obligatorio)

**Contra C (la opción que recomiendo) — contraejemplo serio:** el banco comparativo no es gratis: para comparar B hay que construir primero el generador HAR→OpenAPI→cliente que es, justamente, la parte costosa (T3: complejidad media-alta, esquema inferido incompleto por diseño, `unknown` declarados). C puede degenerar en dos pipelines, propiedad ambigua y parálisis; y conserva a corto plazo la dependencia externa y su riesgo de suministro (S-9/S-15). Mitigación verificable: time-box a un POC con KPI de T3 — **1 HAR propio → 1 OpenAPI → 1 cliente que compile y pase un test de regresión** — más el límite de propiedad de AC-9 (código propio sin imports; CLI solo en documentación). Sin ese POC, C se convierte en proceso sin evidencia y debe escalarse, no prolongarse.

**Contra B (preferida por el usuario) — contraejemplo serio:** no es viable "tal cual": el catálogo verificado de 263 herramientas no contiene generador de clientes (búsquedas `typescript`/`codegen`/`swagger` vacías; `guided_workflows` sin generación; `inspect_api_contract` solo lee). Su supuesta independencia es, además, parcial: no elimina REA (que sigue exigiendo humano A + seguridad/cumplimiento V, ADR-0009), no elimina el riesgo de código generado (T5 §1: lo desplaza al modelo local) y AC-9 ya mide la independencia sin reconstruir nada. Coste real: ingeniería media-alta + ADR nuevo + aprobación humana; beneficio marginal frente a C.

**Contra A (status quo) — contraejemplo adicional:** supply chain de tercero (S-9/S-15), skill ausente, hash/lockfile pendientes (C2), `--auto-install` documentado (C3), deriva entre README/ADR/evidence y la realidad, y cliente tipado no determinista con HAR potencialmente sensible (S-12). Requiere confirmación humana **fresca** para instalar: ADR-0017 no basta (C6).

**Nota de honestidad:** en una versión anterior de este dictamen se afirmó que "el toolkit externo usa REA como motor de inspección". Esa afirmación proviene de la descripción de la skill del entorno y **no está verificada** en las reviews (T3 la marca "no verificado por mí"); se retira como fundamento de la decisión y queda como hipótesis no citada.

## Propuesta
**Dictamen: CHANGES_REQUESTED** (no APPROVE; no BLOCK). Coincide con T1, T3, T5 y T7. La propuesta no puede aprobarse como definitiva hasta que:
1. T1 corrija las tres discrepancias documentales (README, `evidence.md`; **ADR-0017 intacto**, se propone ADR nuevo) y el escriba cierre el memorial de `DEC-001`. `verify` ya está en verde.
2. Se adopten AC-1..AC-9 (T6), con AC-2 marcado `sin confirmar` hasta la captura y AC-9 aplicado como límite de propiedad.
3. El ADR ratifique los controles de T5 para **ambas** rutas: C7 anti-bot sin evasión, C6 confirmación humana fresca para skill/MCP, C2 hash/versión en TOOL-002, C3 sin `--auto-install`, C4/C5 revisión de script y HAR saneado. Sin instalación ni ejecución de código generado.
4. El humano apruebe el cap de coste propuesto (1 captura, USD 0.50 tope; T7) y designe sitio propio autorizado para la única captura del KPI, con humano (A) + seguridad/cumplimiento (V).
5. Se time-boxee el POC de B (1 HAR → 1 OpenAPI → 1 cliente que compile + regresión, T3) antes de cualquier ADR que sustituya ADR-0017.

Recomendación técnica: **C (híbrida acotada)** ahora, con nativa como POC diferido y medible; A como capability vigente. Condición dura: no instalar, no capturar contra terceros ni ejecutar código generado sin humano (A) + seguridad/cumplimiento (V).

Lecciones aplicadas (consultadas antes de dictaminar): fingerprints `298167250`, `2413610980`, `1460826852` — no dar por verificada una decisión sin check hermético y `verify` en verde; no fabricar evidencia; de ahí el `CHANGES_REQUESTED` pese a tener `verify` en verde.

## Pregunta concreta
¿Autoriza El Presidente: (a) la opción C con POC de nativa time-boxeado, (b) el cap de 1 captura / USD 0.50, (c) una confirmación humana **fresca** antes de cualquier instalación de skill/MCP, y (d) designa el sitio propio autorizado para la captura única? Si no hay sitio autorizado ni navegador en esta iteración, ¿confirmamos el estado **"sin evidencia para decidir"** y que B permanece como hipótesis POC, no como decisión?

## Memorial (DECISIONES.md)
- **Decisión:** recomendar C como vía generadora de evidencia; nativa B como POC diferido con KPI medible; no aprobar cambio de ADR-0017; A como capability vigente.
- **Disidentes:** usuario prefiere B; ADR-0017 (humano) ordena A; T1/T3/T5/T7 con `CHANGES_REQUESTED`; T2/T6 `APPROVE` acotado (no autorizan captura); el arquitecto objeta A, B y su propia C con los contraejemplos anteriores.
- **Evidencia:** TOOL-001, TOOL-002, ISO-001, NIST-001; ADR-0009, ADR-0017, DEC-001, plan.md; comandos de T1, T2, T3, T5, T6, T7 citados arriba; `verify` RC 0.
- **Incertidumbre:** 0 capturas; AC-2 sin confirmar; generador propio `unknown` (T3); hash/lockfile y `--auto-install` pendientes (T5); coste por captura no cuantificable y cap sin aprobar (T7); confirmación humana fresca no registrada (C6); `kaizen check` completo no ejecutado por QA.
- **Dueño:** El Presidente (decisión final y cap de gasto); arquitecto propone; verificador/escriba valida fuentes y registra memorial; facilitador ordena turnos y ack.
- **Revisión:** tras POC acotado + captura gobernada + C1–C9 de seguridad + AC-1..AC-9 + `verify` en verde; criterio L-9 (KPI antes→después) en `adr-draft.md`.
