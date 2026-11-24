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

> Nota WAHA (REG-EV-01/05): fuentes consultadas con fecha de corte 2026-11-24.
> - **(a) HMAC-SHA512: VERIFICADO por POC local (2026-11-24).** `hmac.new(b"my-secret-key", b'{"event":"message","session":"default","engine":"WEBJS"}', hashlib.sha512)` reproduce el vector documentado: `208f8a55dde9e055…6153fa89`. Confirma SHA-512 sobre raw body y resuelve la inconsistencia del docs (enlazaba a SHA-256). Clave de ejemplo, sin secretos reales.
> - **(b) *live location*: PENDIENTE** — sin payload oficial ni frecuencia documentada; requiere POC con número de prueba.
> - La afirmación de ADR-0025:8 sobre "prohibición de chatbots desde 2026-01-15" no fue confirmada con fuente primaria: contexto histórico del ADR, no obligación verificada.
| TOOL-002b | Repositorio oficial / PyPI | kalil0321/reverse-api-engineer v0.16.0 (MIT); wheel reverse_api_engineer-0.16.0-py3-none-any.whl; sha256 079cd9585c6a6766a91f0e681fd5b530e08dc5ec12e3aa72e52bf2b263f50ca0 | verified |
| OC-001 | Documentación oficial | OpenCode V2 docs https://opencode.ai/docs/ (índice llms.txt) | verified |
| OC-002 | Repositorio oficial | anomalyco/opencode (MIT, https://github.com/anomalyco/opencode) | verified |

> Nota de consolidación (REG-EV-01): se conservan ambas series de identificadores. `TOOL-002b` es la versión con hash del PR #3 y convive con `TOOL-002`. `OC-001/OC-002` y `OC-WEB-001/OC-CLI-001` apuntan a la misma documentación oficial; el mapeo formal entre ambos requiere decisión humana y queda registrado como pendiente en el proyecto `consolidar-prs-main`. Ninguna fuente fue descartada.

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
