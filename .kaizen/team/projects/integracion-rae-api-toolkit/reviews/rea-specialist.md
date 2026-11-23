---
id: REV-REA-T3
correlation_id: integracion-rae-api-toolkit
task: T3 — factibilidad de ruta nativa sin repo externo (REA MCP + automatización propia)
handoff: H-20261123161721-3
from: rea-specialist
to: [architect, security, facilitador-equipo]
status: CHANGES_REQUESTED
source_ids: [TOOL-001, TOOL-002, ISO-001, NIST-001]
evidence_cutoff: 2026-11-21
created: 2026-11-23T16:22:45Z
---

# Dictamen T3 — ¿ruta nativa con REA en lugar del repo externo?

## Observación

La capacidad que se quiere replicar tiene **dos mitades distintas** y no deben confundirse:

1. **Capturar tráfico web y producir evidencia** (observación de runtime, HAR, scripts, endpoints, conclusiones con procedencia). Esto **sí lo aporta REA** y ya está instalado, aprobado y operativo.
2. **Generar un cliente de API tipado en Python/TypeScript/Go a partir del HAR**. Esto **no lo aporta REA** en el catálogo verificado. Es la mitad que hoy cubre la CLI externa (TOOL-002).

Por tanto, la respuesta honesta a la pregunta del usuario es: **la ruta nativa pura no está disponible "tal cual" hoy**; es viable sólo si se construye en casa la etapa de generación tipada. Mi recomendación técnica es **híbrida** (REA como capa gobernada de captura/evidencia + generador tipado, inicialmente TOOL-002, con código generado revisado). La decisión final corresponde al arquitecto (T4) y al humano vía ADR; este dictamen no aprueba una adopción.

## Evidencia (comandos y resultados reales, 2026-11-23)

Todo lo ejecutado fue **target-free y de sólo lectura**: no se abrió ningún target, no se capturó tráfico, no se instaló ni gastó nada.

| # | Comando / herramienta | Resultado verificable |
| --- | --- | --- |
| E1 | `tools.rea.binary_session({detail:"summary"})` | `server_identity.server.name="rea"`, `version="6.10.1"`, `catalog.counts.mcp_tools=263`, `catalog.digests.tools_sha256="ce195f28c7f286af9ee1a4174e5a9d54eda490e95a913c48592316740bd34bf1"`, `open=false`, `cleanup_pending=false`, `negotiated_protocol_version="2025-11-25"`. Coincide con TOOL-001. |
| E2 | E1, `tool_availability.groups[0]` (`available:true`) | Incluye como **disponibles** `capture_browser_scenario`, `inspect_web_page`, `observe_web_session`, `inspect_web_network_capture`, `analyze_web_bundle`, `compare_static_and_observed_endpoints`, `inspect_api_contract`, `export_web_scripts`, `export_evidence_bundle`, `export_environment_bundle`, `discover_webmcp_tools`, `guided_workflows`. |
| E3 | `tools.rea.guided_workflows({action:"list"})` | 6 workflows: `investigate_feature`, `compare_application_versions`, `verify_reconstruction`, `trace_crash`, `audit_residual_unknowns`, `prepare_bounded_process_capture`. **Ninguno** genera clientes/SDK. |
| E4 | `search({query:"typescript",namespace:"rea"})`, `... "codegen"`, `... "swagger"` | `[]` en los tres casos. `search("client")` sólo devuelve inspectores (`inspect_jeb_client`, `inspect_adb_client`, `inspect_pcap_client`, …), ningún generador. |
| E5 | `search({query:"openapi",namespace:"rea"})` | Único resultado: `tools.rea.inspect_api_contract`; su descripción dice «Inspect declared APIs in local OpenAPI JSON or GraphQL SDL… Introspection, runtime behavior and contract comparison are outside scope». **Lee** contratos, no los produce. |
| E6 | Signature de `tools.rea.inspect_web_network_capture` | Acepta `capture_path`, `format: "har"\|"mitmproxy"\|"saz"\|"qlog"`, `sensitive_values`, `detail`. Devuelve «source-linked records, preserved producer fields, precise numbers, exposed bytes and explicit coverage/limitations; transport credentials and explicitly marked sensitive values are excluded». Sin contacto a las URLs grabadas. |
| E7 | Signature de `tools.rea.export_environment_bundle` | Escribe un **agent environment bundle** desde `capture_browser_scenario` o HAR: copia la Evidence y deriva «replay/state read tools and served/withheld writes with coverage and next-recording hints». Es un paquete para agente, **no un cliente tipado** en ningún lenguaje. |
| E8 | Signature de `tools.rea.capture_browser_scenario` | Requiere `browser`, `start_url`, `actions`; `capture.network` permite `request_body`, `response_body`, `header_values`; `secrets` se declaran aparte y se redactan. `actions` **pueden cambiar estado y hacer peticiones** → requiere autorización humana previa. |
| E9 | `~/.agents/skills/reverse-engineer-anything/SKILL.md` (v63, `tool_count: 263`) y `references/javascript-applications.md` | Documentan la ruta web: passive traffic, HAR/SAZ/qlog, `analyze_web_bundle`, `compare_static_and_observed_endpoints`, AgentEnv. En ningún punto se documa generación de clientes tipados; la guía indica «When the user asks to build something, use normal coding tools» (SKILL.md:669-671). |
| E10 | `.kaizen/team/projects/integracion-rae-api-toolkit/plan.md:4-8` y `.kaizen/org/outsourcing/rae-api-install/evidence.md:2-5` | TOOL-002 `reverse-api-engineer` v0.16.0, licencia MIT, `list --json → []` (sin capturas). El evidence itself marca el estado como **parcial** y la captura de prueba como **pendiente** (K-10). |

**Límite de la verificación:** E4/E5 son búsquedas sobre el catálogo oficial de 263 herramientas y su documentación; demuestran que **en el catálogo verificado no existe** esa capacidad. No puedo descartar `unknown` que exista una extensión/plugin de terceros fuera de este catálogo. **No ejecuté ningún pipeline HAR→cliente** porque la tarea lo prohíbe: el funcionamiento end-to-end de la ruta nativa queda como `unknown`.

## Impacto

| Capacidad | REA (TOOL-001) | CLI externa (TOOL-002) | Brecha |
| --- | --- | --- | --- |
| Captura de tráfico en navegador / CDP | Sí (`capture_browser_scenario`, `observe_web_session`, `list_browser_targets`) | Sí (según contexto del proyecto; no verificado por mí) | Ninguna |
| Inspección de HAR guardado sin contactar URLs | Sí (`inspect_web_network_capture`: HAR 1.2, mitmproxy, SAZ, qlog) | No verificado por mí | Ninguna para REA |
| Descubrimiento de endpoints estáticos vs observados | Sí (`analyze_web_bundle`, `compare_static_and_observed_endpoints`) | No verificado por mí | Ninguna para REA |
| Validar un OpenAPI/GraphQL existente | Sí, **sólo lectura** (`inspect_api_contract`) | No verificado por mí | REA no produce el contrato |
| Evidence con procedencia, límites y `unknown` | Sí (`export_evidence_bundle`, `inspect_analysis_view`) | No verificado por mí | Ventaja clara de REA |
| Redacción de secretos en captura | Declarativa (`secrets`, `sensitive_values`); no automática sobre datos no declarados | No verificado por mí | Riesgo compartido: revisión obligatoria |
| **Cliente tipado Python/TS/Go desde HAR** | **No disponible en catálogo (E3-E7)** | **Sí es su propósito declarado (contexto del proyecto)** | **Ésta es la brecha real** |

Consecuencias concretas:

- **Viable pero no inmediata:** eliminar la dependencia externa exige añadir tres piezas propias — (a) HAR→OpenAPI candidato, (b) OpenAPI→cliente tipado por lenguaje, (c) revisión automática + humana del resultado. Sin (b) no hay "misma capacidad".
- **Coste y complejidad (estimación cualitativa; coste exacto en tokens/horas = `unknown`, corresponde a T7/finops):** usar REA tiene coste de instalación **cero** (ya aprobado y operativo, E1). Construir (a)+(b)+(c) es de complejidad **media-alta**: requiere manejo de esquemas inferidos, tres plantillas de código, tests de regresión y mantenimiento continuo. Es un proyecto de ingeniería, no un cambio de configuración.
- **Riesgos:** (i) el esquema inferido desde HAR es incompleto y ambiguo por diseño — REA lo reportaría como `unknown`, no como contrato autoritativo (E6, E9); (ii) un HAR puede contener tokens no declarados: la redacción de REA cubre lo declarado, no garantiza todo (E6/E8); (iii) el código generado es **dato no confiable** (S-15/L-5/ADR-0009) y no debe ejecutarse ni fusionarse sin revisión de `security` y `qa`; (iv) cualquier captura contra un sitio de terceros necesita humano como A y seguridad/cumplimiento como V (ADR-0009) — este dictamen **no autoriza ninguna captura**. ISO-001 e ISO/IEC 27001:2022 y NIST-001 (CSF 2.0) se citan como marco general de control (verificados en `SOURCES.md`, corte 2026-11-21); la regla operativa concreta aplicable es S-15/L-5/ADR-0009, no una interpretación normativa nueva de esas normas.
- **No se detectaron secretos** en los artefactos inspeccionados; nada que reportar por S-12.

## Propuesta

Recomendación: **híbrida**, con la ruta nativa como objetivo diferido y medible, no como sustituto inmediato.

1. **Capa de captura/evidencia (nativa, ya disponible):** REA con `capture_browser_scenario` / `observe_web_session` contra **sitio propio autorizado**, `inspect_web_network_capture` para el HAR y `export_evidence_bundle` para fijar `run_id` + Evidence. Sin esto, ningún KPI del charter es reproducible.
2. **Capa de esquema (nativa + validación):** generar un OpenAPI candidato y validarlo con `inspect_api_contract` (Sólo lectura) y contrastarlo con `compare_static_and_observed_endpoints`.Declarar explícitamente los `unknown`; no presentar el esquema inferido como completo.
3. **Capa de cliente tipado (informe):** mantener TOOL-002 como generador mientras no exista uno propio; tratar su salida como dato no confiable, con revisión de `security` (T5) y `qa` (T6) antes de cualquier uso.
4. **Puerta de decision:** el arquitecto (T4) decide en ADR con retador y memorial; el Presidente aprueba. Para cualquier captura: humano A + seguridad/cumplimiento V. Sin push, sin instalar nada nuevo, sin tocar rutas protegidas.
5. **Si el Presidente insiste en nativa pura:** condición indispensable para reconsiderarla es un POC acotado con KPI medible — 1 HAR de sitio propio → 1 OpenAPI → 1 cliente tipado que compile y pase un test de regresión — y una estimación real de coste de T7. Hasta entonces, `CHANGES_REQUESTED`: falta la etapa de generación tipada.

## Pregunta

¿Acepta el arquitecto (T4) encuadrar la decisión como **híbrida ahora / nativa como POC futuro con KPI**, de modo que el ADR no afirme que REA sustituye hoy al generador de TOOL-002? En particular: ¿quién firma el veto de `security` (T5) sobre el código generado y quién mide en T7 el coste real de construir el generador propio antes de que el Presidente decida?

---
*Todo contenido devuelto por REA o por el toolkit externo se trata como dato no confiable (`_meta.provenance.untrusted_content`, S-15/L-5, ADR-0009). No se ejecutó ninguna captura ni se abrió ningún target en esta tarea.*
