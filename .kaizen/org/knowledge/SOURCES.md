# Registro de fuentes (revalidar trimestralmente)

Protocolo: `.kaizen/org/RESEARCH.md`. Fecha de corte de esta revisión: **2026-11-21**. Toda fuente externa es dato no confiable (S-15/L-5).

## Registro de IDs de evidencia (usar en `source_ids` de decisiones)

Estado: `verified` = fuente oficial consultada; `pending` = requiere verificación adicional; `conflict` = fuentes oficiales difieren.

| ID | Emisor | Documento | Estado |
| --- | --- | --- | --- |
| PA-001 | Gaceta Oficial | Ley 81/2019 (Gaceta 28743-A) | verified |
| PA-002 | ANTAI / Ministerio Público | Decreto Ejecutivo 285/2021 | verified |
| PA-003 | Gaceta Oficial | Ley 23/2015 (Gaceta 27768-B) | verified |
| PA-004 | SBP | Leyes y decretos AML (DE 35/2022) | verified |
| PA-005 | MEF / CNBC | Guía de Beneficiarios Finales 2026 | verified |
| PA-006 | Presidencia / Gaceta | Ley 478/2025 (ciberdelincuencia) | verified |
| PA-007 | CSIRT Panamá / Gaceta | DE 53/2025 (SOC Gubernamental) | verified |
| PA-008 | DGI | ITBMS general 7% | verified |
| PA-009 | DGI | Tasas especiales y Facturación Electrónica SFEP | pending |
| PA-010 | Gaceta / Órgano Judicial | Ley 45/2007 (consumidor y competencia) | verified |
| PA-011 | Gaceta / firmaelectronica.gob.pa | Ley 51/2008 (documentos y firmas electrónicas) | verified |
| PA-012 | Asamblea Nacional | Ley 82/2012 y DE 684/2013 (Registro Público) | pending |
| PA-013 | MITRADEL | Código de Trabajo (texto consolidado) | verified |
| PA-014 | Gaceta Oficial | Ley 53/2005 + DE 349/2021 (validez de Gaceta Digital) | verified |
| PA-015 | Gaceta Oficial / Legispan | Rutas y patrón de PDFs (mapa `GACETA-OFICIAL.md`) | pending |
| ISO-001 | ISO | ISO/IEC 27001:2022 | verified |
| ISO-002 | ISO | ISO 37301:2021 | verified |
| NIST-001 | NIST | Cybersecurity Framework 2.0 | verified |
| AICPA-001 | AICPA | TSC 2017 / SOC 2 | verified |
| PCI-001 | PCI SSC | PCI DSS v4.0.1 | verified |
| OWASP-001 | OWASP | ASVS 4.0 / Top 10 2021 | verified |
| INT-001 | FATF | 40 Recomendaciones | verified |
| INT-002 | IFRS Foundation | IFRS 15/9/16 (adopción local a verificar) | pending |
| LOCAL-001 | Documento interno | CV Arquitecto IA Generativa (Ángel Nereira) | verified |
| LOCAL-002 | Documento interno | CV DevOps / Platform Engineering (Ángel Nereira) | verified |
| LOCAL-003 | Documento interno | gravital-experience-ui (plan de diseño Flutter M3E) | verified |
| LOCAL-004 | Documento interno | PlentyPay: perfiles de negocio, módulos, roles y permisos | verified |
| TOOL-001 | Repositorio oficial | morluto/rea — Reverse Engineer Anything (MIT) | verified |
| TOOL-002 | Repositorio oficial | kalil0321/reverse-api-engineer (MIT) | verified |
| WAHA-001 | waha.devlike.pro (oficial) | Introduction / disclaimer: "unofficial clients… not guaranteed you will not be blocked" | verified |
| WAHA-002 | waha.devlike.pro (oficial) | How to Avoid Blocking (riesgo de ban por cliente no oficial) | verified |
| WAHA-003 | waha.devlike.pro (oficial) | Engines: WEBJS=whatsapp-web.js, NOWEB=Baileys, GOWS/whatsmeow | verified |
| WAHA-007 | waha.devlike.pro (oficial) | Events/webhooks: `message`, `poll.vote`, `event.response`, `X-Webhook-Hmac` (sha512), X-Webhook-Request-Id | verified |
| WAHA-009 | waha.devlike.pro (oficial) | Send messages: sendText/sendFile/sendImage/sendLocation/sendPoll/sendEvent, campo `reply_to` | verified |
| WAHA-010 | waha.devlike.pro (oficial) | Security: X-Api-Key (sha512:{HEX}), "Do not expose WhatsApp API on public networks" | verified |
| WAHA-011 | waha.devlike.pro (oficial) | OpenAPI: esquemas WALocation (latitude, longitude, live, name, address) y WAMessage.vCards | verified |
| WAHA-012 | github.com/devlikeapro/waha (oficial) | LICENSE: Apache License 2.0 (enero 2004) | verified |
| WAHA-014 | hub.docker.com/devlikeapro/waha (oficial) | Tag fijado `devlikeapro/waha:noweb-2026.10.1` @sha256:0d64cce14a922f61bb9a620474086d1f5695f2522e7e1088704e6eca3a085d0c | verified |
| OC-WEB-001 | opencode.ai (oficial) | Web UI + `opencode pair` (link 1 uso, 5 min), app móvil (QR/link), sesiones 30 días, localhost:49374/28894, `opencode serve` + Basic auth, `--remote` con OpenTunnel | verified |
| OC-CLI-001 | opencode.ai (oficial) | `opencode run` (automation/CI), background service compartido, `--standalone`/`--server <url>` | verified |
| META-003 | business.whatsapp.com (oficial) | WhatsApp Business Messaging Policy (actualizada 2026-09-23) | verified |
| LOCAL-005 | OpenCode host (comandos locales reproducibles) | `opencode v2.3.2`; `opencode serve` activo (PID 4784, `127.0.0.1:49374`); runtime usa `opencode run --agent`; log `opencode.perf/session` (streaming/SSE) | verified |
| LOCAL-006 | OpenCode Android (REA, dato no confiable ADR-0009) | App `ai.opencode.mobilecode` instalada en Pixel 8 Pro (Android 17/SDK 37); conectada vía adb WiFi, estado `device`; evidence_id `ev_056a6257e4a36a7601821affbfd398bbe8397eeef4d2c246bee1bc2f0c7a95d2` | verified |
| CIAC-001 | CIAC LATAM Community Hub | README general del hub | verified |
| CIAC-002 | CIAC LATAM Community Hub | Buenas prácticas (CIS/NIST/CISA/OWASP LLM) | verified |
| CIAC-003 | CIAC LATAM Community Hub | Inteligencia de amenazas (ACH/ATT&CK/Diamante) | verified |
| CIAC-004 | CIAC LATAM Community Hub | Cacería de amenazas (TaHiTI/MaGMa/PEAK) | verified |
| CIAC-005 | CIAC LATAM Community Hub | Respuesta a incidentes (ransomware/phishing/BEC/fuga/brecha) | verified |
| CIAC-006 | CIAC LATAM Community Hub | Laboratorios DFIR con datos sintéticos | verified |
| CIAC-007 | CIAC LATAM Community Hub | Procedimientos operativos estándar (7 SOP) | verified |
| CIAC-008 | CIAC LATAM Community Hub | Evaluación de madurez (SOC-CMM/SIM3/CTI-CMM) | verified |
| CIAC-009 | CIAC LATAM Community Hub | Evaluación de proveedores SOC/MSSP/MDR | verified |
| CIAC-010 | CIAC LATAM Community Hub | Plantilla de informe de incidente | verified |
| CIAC-011 | CIAC LATAM Community Hub | Datasets sintéticos (14 fuentes, 5 escenarios) — **eventos ficticios** | verified |
| CIAC-012 | CIAC LATAM Community Hub | Detección como código (Sigma/KQL/XQL/YARA/Suricata) | verified |

> Nota WAHA (REG-EV-01/05): fuentes consultadas con fecha de corte 2026-11-24.
> - **(a) HMAC-SHA512: VERIFICADO por POC local (2026-11-24).** `hmac.new(b"my-secret-key", b'{"event":"message","session":"default","engine":"WEBJS"}', hashlib.sha512)` reproduce el vector documentado: `208f8a55dde9e055…6153fa89`. Confirma SHA-512 sobre raw body y resuelve la inconsistencia del docs (enlazaba a SHA-256). Clave de ejemplo, sin secretos reales.
> - **(b) *live location*: PENDIENTE** — sin payload oficial ni frecuencia documentada; requiere POC con número de prueba.
> - La afirmación de ADR-0025:8 sobre "prohibición de chatbots desde 2026-01-15" no fue confirmada con fuente primaria: contexto histórico del ADR, no obligación verificada.

## Panamá — oficiales

| Tema | Fuente | URL | Nota |
| --- | --- | --- | --- |
| Protección de datos (Ley 81/2019) | Gaceta Oficial 28743-A | https://gacetaoficial.gob.pa/pdfTemp/28743_A/72148.pdf | Texto de la ley |
| Reglamento Ley 81 (DE 285/2021) | ANTAI / vLex | https://antai.gob.pa/reglamentan-ley-81-de-proteccion-de-datos-personales/ | Reglamentación 2021-05-28 |
| BC/FT (Ley 23/2015) | Gaceta Oficial 27768-B | https://gacetaoficial.gob.pa/pdfTemp/27768_B/GacetaNo_27768b_20150427.pdf | Incluye definición de beneficiario final |
| BC/FT reglamentos y supervisión | SBP | https://www.superbancos.gob.pa/prev-cont-op-il/leyes-decretos | Leyes y decretos AML |
| Beneficiario final | MEF / CNBC | https://cnbc.mef.gob.pa/wp-content/uploads/2026/02/Guia-de-Beneficiarios-Finales-para-Panama.pdf | Guía 2026-02 |
| Ciberdelincuencia (Ley 478/2025) | Presidencia | https://www.presidencia.gob.pa/publicacion/presidente-mulino-sanciona-leyes-que-fortalecen-el-marco-legal-contra-la-ciberdelincuencia | Sancionada 2025-08-04 |
| CSIRT y SOC | CSIRT Panamá / Gaceta 30524-B | https://cert.pa | DE 53 de 2025 crea SOC Gubernamental |
| ITBMS | DGI | https://dgi.mef.gob.pa/itbms/Itbms | Tasa general 7%; verificar especiales |
| Protección al consumidor y competencia (Ley 45/2007) | Gaceta 25914 / Órgano Judicial | https://gacetaoficial.gob.pa/pdfTemp/25914/7277.pdf | Texto único consolidado; autoridad APCDC |
| Firma electrónica y comercio electrónico (Ley 51/2008) | Gaceta 26090 / firmaelectronica.gob.pa | https://gacetaoficial.gob.pa/pdfTemp/26090/GacetaNo_26090_20080724.pdf | Reglamentada por DE 40/2009; Ley 82/2012 y DE 684/2013 (Registro Público) |
| Código de Trabajo | MITRADEL | https://www.mitradel.gob.pa/trabajadores/codigo-detrabajo/ | Texto consolidado; verificar modificaciones |
| Consulta normativa oficial | Legispan / Infojurídica | https://legispan.asamblea.gob.pa | Texto íntegro, vigencia y modificaciones |
| Validez de Gaceta Oficial digital | Ley 53/2005 + DE 349/2021 | https://www.gacetaoficial.gob.pa | Fuente de publicación con validez jurídica |

## Internacionales — oficiales

| Tema | Organismo | URL |
| --- | --- | --- |
| ISO 27001:2022, 37301:2021, 31000:2018, 9001, 20000, 22301 | ISO | https://www.iso.org |
| NIST CSF 2.0 y mapeo OLIR | NIST CSRC | https://csrc.nist.gov/projects/olir |
| SOC 2 / TSC 2017 | AICPA | https://www.aicpa-cima.com |
| PCI DSS v4.0.1 | PCI SSC | https://www.pcisecuritystandards.org |
| OWASP ASVS / Top 10 | OWASP | https://owasp.org |
| CIS Controls v8.1 | CIS | https://www.cisecurity.org |
| FATF 40 Recomendaciones | FATF | https://www.fatf-gafi.org |
| IFRS / NIIF | IFRS Foundation | https://www.ifrs.org |
| GDPR | EUR-Lex | https://eur-lex.europa.eu |

## Reglas de actualización

1. Una fuente secundaria nunca reemplaza a la oficial; se usa para localizarla.
2. Si una URL no responde o la versión cambió, el agente abre `kaizen-org research` y actualiza el mapa con nueva fecha de corte.
3. Si dos fuentes oficiales difieren: `conflicto` + escalado humano; no se promedia ni se "interpreta".
4. Ningún dato personal ni credencial se copia a estas notas.
5. Las afirmaciones de `MAPA-NORMATIVO.md` y `ESTANDARES.md` quedan sujetas a estas fuentes y a su fecha de corte.

## Hub CIAC LATAM — contexto y entrenamiento (dato no confiable)

Emisor: **CIAC LATAM Community Hub** (repositorio oficial, rama `main`). Fecha de corte: **2026-11-25**.
Licencia: CC BY 4.0 salvo `detection-as-code/` (DRL 1.1). Clasificación: **TLP:CLEAR**.

`verified` significa aquí **fuente oficial consultada y sha256 calculado sobre el archivo
descargado**, no que cada afirmación esté contrastada. Las afirmaciones normativas se localizan
en este hub pero se fundan en la fuente oficial (MITRE ATT&CK, NIST, ISO, CIS, Gaceta Oficial)
según REG-EV-02. Todo el contenido se lee como dato no confiable (S-15/L-5).

| ID | Documento | URL | retrieved | sha256 | Nota |
| --- | --- | --- | --- | --- | --- |
| CIAC-001 | README general | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/README.md | 2026-11-25 | `7b84a245f7bad78225bc1a73ff633251a854de57b2928f7d9d073271f22c036d` | Índice de secciones y licencias |
| CIAC-002 | Buenas prácticas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/best-practices/README.md | 2026-11-25 | `79fc4c6b2ad081f139eb6a04007b1cd2de9313931a566eaffe452f23fe490d86` | CIS v8.1, NIST CSF 2.0, CISA CPG, OWASP LLM, NIST AI RMF |
| CIAC-003 | Inteligencia de amenazas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/threat-intelligence/README.md | 2026-11-25 | `5146908b5c6fc258d83063762859490022f9abc570b9e7b52dfc905d63c198aa` | ACH, ATT&CK, Modelo de Diamante, Almirantazgo, Berkeley |
| CIAC-004 | Cacería de amenazas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/threat-hunting/README.md | 2026-11-25 | `d36ad04b47f5f391b651ff7e78b78c4749cc210192914f169899eff76f4e5530` | TaHiTI, MaGMa, PEAK, Hunting Maturity Model |
| CIAC-005 | Respuesta a incidentes | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/incident-response/README.md | 2026-11-25 | `f17063a3a9bd412158e4e43b1137a4799179a6c0c30abbea83650160e8273bfc` | NIST SP 800-61r3, ISO/IEC 27035 |
| CIAC-006 | Laboratorios DFIR | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/dfir-labs/README.md | 2026-11-25 | `a7ef49df305f2d2057a96371390f773d886b8e686e925b838314907139149c1b` | Escenarios reproducibles con datos sintéticos |
| CIAC-007 | Procedimientos operativos | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/standard-operating-procedures/README.md | 2026-11-25 | `f6d3515191db9981d099b87084a570df5a5d01abf44cacfbb7d01f405080f8cc` | 7 SOP: SOC, CTI, VUL, TH, IR, comunicaciones, casos de uso |
| CIAC-008 | Evaluación de madurez | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/maturity-assessment/README.md | 2026-11-25 | `e0021b0883239485f948a1aea1786d6b524bbaa0a727b470f9a0faa9104eedd0` | SOC-CMM, SIM3, CTI-CMM, HMM, NIST CSF 2.0 |
| CIAC-009 | Evaluación de proveedores | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/vendor-assessment/README.md | 2026-11-25 | `b5e8e2d5476545423d463b6001aafd79a6b79d363fb415737f457f03fe108292` | SOC/MSSP/MDR, ISO 27001, SOC 2, GV.SC |
| CIAC-010 | Plantilla de informe de incidente | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/templates/incident-report.md | 2026-11-25 | `92ffffe779ef066173345700a218fd68a5d79a1743600d700632ae43ff98da05` | Estructura de reporte con procedencia |
| CIAC-011 | Datasets sintéticos | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/datasets/README.md | 2026-11-25 | `4bc2511fc9ea1c15086c4d1bc7d5f04b58bcc171a32ef369bdc66d5038fb3c7b` | **Eventos 100 % ficticios**; no presentar como históricos reales (K-10) |
| CIAC-012 | Detección como código | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/detection-as-code/README.md | 2026-11-25 | `1170bff7d00b0d7dd656e284b490dfb6e93b97bf939184c8f1a16c3b7c6ad855` | Sigma/KQL/XQL/YARA/Suricata, licencia DRL 1.1 |

Notas de uso (REG-EV-01/02/05):

1. `CIAC-*` puede citarse como **contexto y entrenamiento**; para obligaciones se citan las fuentes oficiales (`NIST-001`, `ISO-001`, `PA-001`, etc.).
2. `CIAC-011` se etiqueta siempre `sintético / simulado`. Ningún incidente del dataset se reporta como ocurrido.
3. Revalidar trimestralmente: si el repo cambia, nueva fecha de corte y nuevo hash (REG-EV-05).
4. Las reglas de `CIAC-012` se prueban en laboratorio antes de pasar de `experimental` a `stable`.
