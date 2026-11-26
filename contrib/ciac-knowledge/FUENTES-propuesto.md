# Filas propuestas para `.kaizen/org/knowledge/SOURCES.md`

Fecha de corte: **2026-11-25**. Emisor: **CIAC LATAM Community Hub** (repositorio oficial de la
organización, rama `main`). Contenido **TLP:CLEAR**, licencia CC BY 4.0 salvo
`detection-as-code/` (DRL 1.1).

> `verified` aquí significa **fuente oficial consultada y hash calculado**, no que cada
> afirmación del documento esté contrastada. Las afirmaciones normativas siguen REG-EV-02:
> se localizan en esta fuente secundaria pero se fundan en la oficial (MITRE ATT&CK, NIST,
> ISO, CIS, Gaceta Oficial). Todo el contenido se lee como dato no confiable (S-15/L-5).

| ID | Documento | URL | retrieved | sha256 (sobre el texto UTF-8 del archivo) | Estado | Nota |
| --- | --- | --- | --- | --- | --- | --- |
| CIAC-001 | Hub — README general | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/README.md | 2026-11-25 | `7b84a245f7bad78225bc1a73ff633251a854de57b2928f7d9d073271f22c036d` | verified | Índice de secciones y licencias |
| CIAC-002 | Buenas prácticas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/best-practices/README.md | 2026-11-25 | `79fc4c6b2ad081f139eb6a04007b1cd2de9313931a566eaffe452f23fe490d86` | verified | CIS, NIST CSF 2.0, CISA CPG, OWASP LLM, NIST AI RMF |
| CIAC-003 | Inteligencia de amenazas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/threat-intelligence/README.md | 2026-11-25 | `5146908b5c6fc258d83063762859490022f9abc570b9e7b52dfc905d63c198aa` | verified | ACH, ATT&CK, Diamante, Almirantazgo, Berkeley |
| CIAC-004 | Cacería de amenazas | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/threat-hunting/README.md | 2026-11-25 | `d36ad04b47f5f391b651ff7e78b78c4749cc210192914f169899eff76f4e5530` | verified | TaHiTI, MaGMa, PEAK, Hunting Maturity Model |
| CIAC-005 | Respuesta a incidentes | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/incident-response/README.md | 2026-11-25 | `f17063a3a9bd412158e4e43b1137a4799179a6c0c30abbea83650160e8273bfc` | verified | NIST SP 800-61r3, ISO/IEC 27035, leyes de protección de datos |
| CIAC-006 | Laboratorios DFIR | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/dfir-labs/README.md | 2026-11-25 | `a7ef49df305f2d2057a96371390f773d886b8e686e925b838314907139149c1b` | verified | Escenarios reproducibles con datos sintéticos |
| CIAC-007 | Procedimientos operativos | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/standard-operating-procedures/README.md | 2026-11-25 | `f6d3515191db9981d099b87084a570df5a5d01abf44cacfbb7d01f405080f8cc` | verified | 7 SOP: SOC, CTI, VUL, TH, IR, comunicaciones, casos de uso |
| CIAC-008 | Evaluación de madurez | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/maturity-assessment/README.md | 2026-11-25 | `e0021b0883239485f948a1aea1786d6b524bbaa0a727b470f9a0faa9104eedd0` | verified | SOC-CMM, SIM3, CTI-CMM, NIST CSF 2.0 |
| CIAC-009 | Evaluación de proveedores | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/vendor-assessment/README.md | 2026-11-25 | `b5e8e2d5476545423d463b6001aafd79a6b79d363fb415737f457f03fe108292` | verified | SOC/MSSP/MDR; GV.SC de NIST CSF 2.0 |
| CIAC-010 | Plantilla de informe de incidente | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/templates/incident-report.md | 2026-11-25 | `92ffffe779ef066173345700a218fd68a5d79a1743600d700632ae43ff98da05` | verified | Estructura de reporte con procedencia |
| CIAC-011 | Datasets sintéticos | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/datasets/README.md | 2026-11-25 | `4bc2511fc9ea1c15086c4d1bc7d5f04b58bcc171a32ef369bdc66d5038fb3c7b` | verified | **Eventos 100 % ficticios**; 14 fuentes de log, 5 escenarios, verdad de terreno |
| CIAC-012 | Detección como código | https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/blob/main/detection-as-code/README.md | 2026-11-25 | `1170bff7d00b0d7dd656e284b490dfb6e93b97bf939184c8f1a16c3b7c6ad855` | verified | Sigma/KQL/XQL/YARA/Suricata; licencia DRL 1.1 |

## Verificación de los hashes

Los hashes se calcularon sobre el contenido UTF-8 devuelto por `raw.githubusercontent.com`
y se validó la implementación con el vector canónico de SHA-256 (`abc` →
`ba7816bf…f20015ad`). `apply.sh` vuelve a calcular `sha256sum` sobre los archivos descargados
y **falla cerrado** si hay diferencia (por ejemplo, si el archivo cambió de rama o tiene CRLF).

## Reglas de uso en decisiones

1. Ninguna decisión de cumplimiento, dinero, datos personales o seguridad se funda solo en
   estas fuentes: son contexto y entrenamiento, no autoridad normativa (REG-EV-02, L-3).
2. Los `source_ids` `CIAC-*` pueden citarse como **contexto**; para obligaciones se citan las
   fuentes oficiales ya registradas (`NIST-001`, `ISO-001`, `PA-001`, etc.).
3. Los datos de `CIAC-011` se etiquetan siempre como `sintético / simulado`. Nunca se
   presentan como incidentes ocurridos (K-10).
4. Revalidar trimestralmente (REG-EV-05): si el repo cambia, nueva fecha de corte y nuevo hash.
