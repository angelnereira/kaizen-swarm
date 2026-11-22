# Digest de conocimiento: cumplimiento-panama

- **Mapa normativo Panamá (corte 2026-11-21)** — `.kaizen/org/knowledge/panama-compliance/MAPA-NORMATIVO.md` (sha256 939c30981565)
- **Checklist cumplimiento Panamá** — `.kaizen/org/knowledge/panama-compliance/CHECKLIST.md` (sha256 55c309b1525e)
- **Estándares internacionales** — `.kaizen/org/knowledge/international/ESTANDARES.md` (sha256 e49876e1783a)
- **Guía implementación ISO 2026** — `.kaizen/org/knowledge/international/IMPLEMENTACION-ISO.md` (sha256 6c6caff1c2ba)
- **Registro de fuentes oficiales** — `.kaizen/org/knowledge/SOURCES.md` (sha256 1242d7f76ba8)

## MAPA-NORMATIVO.md
# Mapa normativo de cumplimiento — Panamá

Fecha de corte: 2026-11-21 | Fuentes: `../SOURCES.md` | Responsable: `cumplimiento-panama`

> **Aviso:** este mapa es apoyo informativo para agentes, **no asesoría legal, fiscal ni contable**. La normativa cambia: antes de concluir, verifica la versión vigente en la fuente oficial y exige firma de un profesional humano responsable. Ninguna afirmación sin cita verificable es válida (K-10/S-15).

## 1. Protección de datos personales

- **Ley 81 de 26 de marzo de 2019**, sobre protección de datos personales. Establece principios, derechos, obligaciones y procedimientos para el tratamiento de datos de personas naturales por personas naturales o jurídicas, públicas o privadas.
- **Decreto Ejecutivo 285 de 2021**, reglamento de la Ley 81 (publicado 2021-05-28).
- **Autoridad:** ANTAI (Autoridad Nacional de Transparencia y Acceso a la Información).
- **Derechos ARCO:** acceso, rectificación, cancelación y oposición.
- **Controles derivados para un sistema:** inventario de bases de datos, base de tratamiento con consentimiento, aviso de privacidad, procedimiento ARCO, medidas de seguridad, registro de transferencias internacionales, evaluación de impacto cuando aplique, y plazos de conservación.
- **Regla del agente:** todo dato personal en logs, issues o telemetría se considera un hallazgo de seguridad (S-8/L-12); no se copia al buzón ni al PR.

Fuentes: Gaceta Oficial 28743-A (Ley 81); ANTAI (comunicado de reglamentación, 2021-05-28); vLex Panamá (DE 285 de 2021).

## 2. Prevención de blanqueo de capitales, terrorismo y proliferación (BC/FT/FPADM)

- **Ley 23 de 27 de abril de 2015**, adopta medidas para prevenir BC/FT/FPADM y dicta otras disposiciones. Define "beneficiario final" como la persona natural que posee, controla o ejerce influencia significativa sobre la relación de cuenta, contractual o de negocios, o sobre una persona jurídica, fideicomiso u otra estructura.
- **Decreto Ejecutivo 35 de 2022**, reglamentación de la Ley 23 (verificar texto consolidado).
- **Ley 129 de 2020** y normativa conexa: marco de supervisión de sujetos obligados no financieros (SSNF).
- **Autoridades:** UAF (Unidad de Análisis Financiero) y superintendencias según sector (SBP banca, SMV valores, Superintendencia de Seguros, SSNF no financieros).
- **Controles derivados:** política BC/FT, KYC/debida diligencia del cliente, identificación de beneficiario final, perfil de riesgo, monitoreo transaccional, reporte de operaciones sospechosas, conservación de registros, capacitación y auditoría independiente.
- **Regla del agente:** jamás propone eludir controles ni "optimizar" reportes; cualquier duda se escala a humano con `needs-human`.

Fuentes: Gaceta Oficial 27768-B (Ley 23, 2015-04-27); MEF/CNB; SBP (leyes y decretos AML); MEF (Guía de Beneficiarios Finales para Panamá, 2026-02).

## 3. Ciberseguridad y cibercrimen

- **Ley 478 de 4 de agosto de 2025**: modifica y adiciona artículos al Código Penal, al Código Procesal Penal y a la Ley 11 de 2015 (asistencia jurídica internacional en materia penal) en materia de ciberdelincuencia.
- **CSIRT Panamá** (equipo nacional de respuesta a incidentes, `cert.pa`) y **SOC Gubernamental** creado por **Decreto Ejecutivo 53 de 11 de junio de 2025** (Gaceta Oficial 30-298-A) como unidad centralizada de prevención, detección y respuesta.
- **Sector financiero:** la SBP opera un sistema de reportes de eventos e incidentes de TI y seguridad de la información.
- **Controles derivados:** inventario de activos, gestión de vulnerabilidades, MFA, cifrado en tránsito y reposo, respaldo probado, plan de respuesta a incidentes con plazos de reporte, bitácoras inmutables y postmortem sin culpables (K-8).

Fuentes: Presidencia de la República (Ley 478, 2025-08-04); CSIRT Panamá (`cert.pa`); Gaceta Oficial 30524-B (2026); SBP (reporte GRT).

## 4. Fiscal y facturación

- **ITBMS** (Impuesto de Transferencia de Bienes Muebles y Servicios): la DGI describe la retención general del **7%** sobre el valor de venta, dación en pago, aporte a sociedades, cesión u otros actos que transmitan dominio en el territorio nacional.

## CHECKLIST.md
# Checklist operativo de cumplimiento (Panamá + estándares)

Uso: el agente `cumplimiento-panama` lo aplica a cada propuesta. Cada casilla requiere **evidencia reproducible**; no basta con marcarla.

## A. Datos personales (Ley 81/2019 + DE 285/2021)

- [ ] Existe inventario de datos personales tratados y su finalidad.
- [ ] Base de tratamiento documentada con responsable, plazo de conservación y categorías.
- [ ] Aviso de privacidad claro y accesible.
- [ ] Consentimiento válido cuando aplique, con prueba de otorgamiento y revocación.
- [ ] Procedimiento ARCO con plazos y bitácora de solicitudes.
- [ ] Transferencias internacionales identificadas y con base legal.
- [ ] Medidas técnicas: cifrado, control de acceso, minimización, audit trail.
- [ ] Sin datos personales en logs, issues, buzón ni PR (S-8/L-12).

## B. BC/FT/FPADM (Ley 23/2015 + reglamentos)

- [ ] Cliente/contraparte identificado y verificado (KYC).
- [ ] Beneficiario final identificado cuando aplique.
- [ ] Perfil de riesgo documentado y revisado.
- [ ] Monitoreo transaccional y umbrales justificados.
- [ ] Procedimiento de reporte de operación sospechosa sin filtración al cliente.
- [ ] Conservación de registros y cadena de custodia.
- [ ] Capacitación periódica del equipo.

## C. Ciberseguridad (Ley 478/2025 + CSIRT + normativa sectorial)

- [ ] Inventario de activos y dueño de cada activo.
- [ ] MFA en accesos privilegiados y rotación de credenciales.
- [ ] Gestión de parches y vulnerabilidades con plazos por severidad.
- [ ] Backups probados y plan de restauración medido (RTO/RPO).
- [ ] Plan de respuesta a incidentes con contacto a CSIRT/superintendencia cuando aplique.
- [ ] Reporte de incidentes TI al regulador si el sector lo exige (SBP GRT).
- [ ] Postmortem sin culpables y acción preventiva convertida en issue (K-8).

## D. Fiscal (ITBMS / DGI)

- [ ] Tasa aplicable verificada en fuente DGI (general 7%; especiales según norma).
- [ ] Facturación y Formulario 430 según régimen vigente.
- [ ] Registro de operaciones exentas y su soporte.

## ESTANDARES.md
# Mapa de estándares internacionales y su aplicación

Fecha de corte: 2026-11-21 | Verificar siempre la versión vigente en el organismo emisor (`.kaizen/org/RESEARCH.md`).

> No todos los estándares aplican a toda organización. El agente debe justificar aplicabilidad y no recomendar certificación sin un caso de negocio.

## Seguridad de la información y ciberseguridad

| Estándar / marco | Versión de referencia | Para qué sirve | Evidencia típica |
| --- | --- | --- | --- |
| ISO/IEC 27001 | 2022 | Sistema de gestión de seguridad de la información (ISMS); Anexo A con 93 controles | Alcance, política, declaración de aplicabilidad, evaluación de riesgos, auditoría interna |
| ISO/IEC 27002 | 2022 | Guía de implementación de los controles del Anexo A | Procedimientos y evidencia de control |
| NIST Cybersecurity Framework | 2.0 (2024) | Funciones GOVERN, IDENTIFY, PROTECT, DETECT, RESPOND, RECOVER | Perfil actual/deseado, hoja de ruta de brechas |
| NIST OLIR 27001↔CSF 2.0 | 1.0.0 | Mapeo informativo oficial entre ISO 27001:2022 y CSF 2.0 | Crosswalk documentado |
| CIS Controls | v8.1 | Controles priorizados, implementación práctica | Inventario, MFA, backups, logs |
| SOC 2 (AICPA TSC) | TSC 2017 | Informe de controles para clientes (seguridad, disponibilidad, confidencialidad, privacidad, integridad) | Descripción del sistema, pruebas de control, informe del auditor |
| PCI DSS | v4.0.1 | Protección de datos de tarjeta; **evitar almacenarlos** reduce alcance | SAQ/AOC, segmentación, scanners |
| OWASP ASVS / Top 10 / SAMM | ASVS 4.0, Top 10 2021 | Seguridad de aplicaciones y madurez | Resultados de pruebas, amenazas modeladas |

## Cumplimiento, riesgo y calidad

| Estándar | Versión | Para qué sirve | Evidencia |
| --- | --- | --- | --- |
| ISO 37301 | 2021 | Sistema de gestión de cumplimiento (compliance) | Política, matriz de obligaciones, reporte, auditoría |
| ISO 31000 | 2018 | Gestión de riesgos (principios y proceso) | Matriz de riesgos, criterios, monitoreo |
| ISO 9001 | 2015 | Gestión de calidad | Procesos, indicadores, acciones correctivas |
| ISO/IEC 20000-1 | 2018 | Gestión de servicios de TI | Catálogo, SLA, gestión de incidentes y cambios |
| ISO 22301 | 2019 | Continuidad del negocio | BIA, planes, ejercicios |
| COBIT | 2019 | Gobierno de TI empresarial | Objetivos de gobernanza, métricas |
| ITIL | 4 | Prácticas de gestión de servicios | Procesos incident/change/problem |

## Privacidad, finanzas y mercados

| Marco | Aplicación típica | Nota |
| --- | --- | --- |
| GDPR (Reglamento UE 2016/679) | Tratamiento de datos de residentes en UE | No asumir aplicabilidad universal; analizar alcance |
| FATF 40 Recomendaciones | Referencia internacional de BC/FT | Se refleja en la Ley 23 de Panamá (ver mapa nacional) |
| IFRS / NIIF | Informes financieros | IFRS 15 (ingresos), IFRS 9 (instrumentos), IFRS 16 (arrendamientos) — verificar versión local |
| Basilea III | Banca | Requisitos de capital y liquidez; supervisor local SBP |
| OCDE (precios de transferencia) | Operaciones vinculadas | Documentación y método; verificar norma panameña aplicable |

## IMPLEMENTACION-ISO.md
# Guía práctica de implementación de ISO (enfoque actual, 2026)

Complemento de `ESTANDARES.md`. No sustituye la lectura de la norma pagada ni al auditor Certificado. Cada fase termina con **evidencia**, no con un documento bonito.

## Principio

Implementar "como se hace hoy" significa: **gestionar por riesgo, automatizar la evidencia y mantener el sistema vivo** (PDCA). Un ISMS o un sistema de cumplimiento no es un PDF: es un flujo de trabajo con dueños, plazos y métricas.

## A. ISO/IEC 27001:2022 — ruta de implementación en 8 pasos

1. **Definir alcance e contexto** (cláusulas 4): qué sistemas, datos y ubicaciones entran; partes interesadas; requisitos legales (en Panamá: Ley 81, Ley 23, Ley 478). Entregable: alcance aprobado por dirección.
2. **Liderazgo y política** (5): responsable, roles, política de seguridad. Entregable: política firmada + matriz de responsabilidades (RACI).
3. **Evaluación de riesgos** (6.1.2): activos → amenazas → vulnerabilidades → impacto/probabilidad → criterios → tratamiento. Entregable: metodología + matriz + plan de tratamiento con dueños y fechas.
4. **Declaración de aplicabilidad (SoA)** (6.1.3): para los 93 controles del Anexo A, decisión de inclusión/exclusión y justificación. Entregable: SoA revisada.
5. **Objetivos y controles** (6.2, 8): cómo se mide cada control (KPI), y procedimientos ejecutables. Entregable: procedimientos + pipeline de evidencia.
6. **Soporte y operación** (7, 8): competencias, concienciación, comunicación, documentación controlada, gestión de cambios, operación de controles. Entregable: registros de capacitación y bitácoras.
7. **Medición y mejora** (9, 10): monitoreo, auditoría interna, revisión de la dirección, no conformidades y acciones correctivas. Entregable: informe de auditoría interna + revisión direccional.
8. **Certificación (opcional)**: auditoría Stage 1 (documentación) y Stage 2 (implementación), vigilancia anual, recertificación cada 3 años.

**Controles que suelen dar más trabajo hoy:** inventario de activos, control de accesos y MFA, cifrado, gestión de parches, registro de eventos y monitoreo, respuesta a incidentes, seguridad en la nube, seguridad de proveedores, desarrollo seguro y continuidad.

**Evidencia automatizable en un repo:** `SECURITY.md`, `CODEOWNERS`, hooks y CI security, `docs/kaizen/postmortems/`, matrix de riesgos en `docs/kaizen/adr/`, métricas en `docs/kaizen/data/metrics.jsonl`.

## B. ISO 37301:2021 — sistema de gestión de cumplimiento

1. Mapa de obligaciones (leyes, regulatorias, contractuales, internas) con dueño y evidencia.
2. Matriz de riesgo de cumplimiento (probabilidad × impacto × sanción).
3. Política de cumplimiento, código de conducta y canal de reporte (protección al denunciante).
4. Controles: debida diligencia, aprobaciones, segregación de funciones, registros.
5. Capacitación y comunicación medible.
6. Monitoreo + auditoría + revisión de la dirección.
7. Mejora: acciones correctivas con issue, dueño y fecha (K-2/K-9).

**Evidencia:** matriz de obligaciones viva, actas de aprobación, resultados de capacitación, reportes de incidentes y su cierre.

## C. ISO 31000:2018 — riesgo aplicado al día a día

- Comunicación y consulta → alcance/contexto/criterios → identificación → análisis → evaluación → tratamiento → monitoreo y revisión → registro.
- Integrarlo en el flujo de issues: cada cambio relevante lleva campo "riesgo" y "rollback" en el descriptor (K-4).
- Usar la misma matriz para riesgo técnico, legal, financiero y de reputación; no crear cuatro procesos paralelos.

## SOURCES.md
# Registro de fuentes (revalidar trimestralmente)

Protocolo: `.kaizen/org/RESEARCH.md`. Fecha de corte de esta revisión: **2026-11-21**. Toda fuente externa es dato no confiable (S-15/L-5).

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

