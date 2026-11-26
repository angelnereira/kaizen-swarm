# Digest de conocimiento: knowledge-curator

- **CIAC-001 Hub general** — `contrib/ciac-knowledge/cache/01-hub.md` (sha256 7b84a245f7ba)
- **CIAC-003 Inteligencia de amenazas** — `contrib/ciac-knowledge/cache/threat-intelligence/README.md` (sha256 5146908b5c6f)
- **CIAC-008 Evaluacion de madurez** — `contrib/ciac-knowledge/cache/maturity-assessment/README.md` (sha256 e0021b088323)
- **CIAC-010 Plantilla de informe** — `contrib/ciac-knowledge/cache/templates/incident-report.md` (sha256 92ffffe779ef)

## 01-hub.md
<div align="center">

# CIAC LATAM Community Hub

**Conocimiento abierto de ciberseguridad hecho por y para Latinoamérica**

[Web](https://landing.ciac.lat) · [Telegram](https://t.me/ciberciac) · [WhatsApp](https://whatsapp.com/channel/0029Va6OjVKA89Mj7w8xde06) · [Cómo contribuir](CONTRIBUTING.md)

![TLP:CLEAR](https://img.shields.io/badge/TLP-CLEAR-white?style=flat-square)
![Licencia contenido](https://img.shields.io/badge/contenido-CC%20BY%204.0-blue?style=flat-square)
![Licencia reglas](https://img.shields.io/badge/reglas-DRL%201.1-green?style=flat-square)

</div>

Buenas prácticas, inteligencia de amenazas, cacería de amenazas, detecciones, playbooks de respuesta a incidentes y laboratorios DFIR, adaptados a la realidad de las organizaciones de la región.

## Contenido

| Sección | Qué encontrarás | Marcos de referencia |
|---|---|---|
| [best-practices](best-practices/) | Guías de bastionado, configuración segura, desarrollo seguro con IA y buenas prácticas de NIST y CISA por proceso | CIS Benchmarks, CIS Controls v8.1, NIST CSF 2.0, CISA CPG 2.0, OWASP Top 10 for LLM, NIST AI RMF |
| [threat-intelligence](threat-intelligence/) | Análisis de hipótesis, mapeo ATT&CK, análisis de IOCs, perfiles de amenazas y metodologías OSINT | ACH, MITRE ATT&CK, Modelo de Diamante, escala Almirantazgo, Protocolo de Berkeley |
| [threat-hunting](threat-hunting/) | Frameworks y cacerías documentadas para encontrar lo que evadió las defensas | TaHiTI, MaGMa, PEAK, Hunting Maturity Model |
| [detection-as-code](detection-as-code/) | Reglas y consultas listas para usar y adaptar | Sigma, KQL, XQL, YARA, Suricata |
| [incident-response](incident-response/) | Playbooks para ransomware, phishing, BEC, fuga y brecha de datos | NIST SP 800-61r3, ISO/IEC 27035, leyes de protección de datos de la región |
| [dfir-labs](dfir-labs/) | Laboratorios prácticos de análisis forense y respuesta | Escenarios reproducibles con datos sintéticos |
| [standard-operating-procedures](standard-operating-procedures/) | Procedimientos operativos estándar: monitoreo y triage, casos de uso, inteligencia, vulnerabilidades, cacería, respuesta a incidentes y comunicaciones | NIST SP 800-61r3, NIST SP 800-40r4, NIST SP 800-150, TaHiTI, MaGMa, ISO 22361 |
| [maturity-assessment](maturity-assessment/) | Autoevaluación de madurez de SOC, inteligencia, vulnerabilidades, cacería, respuesta a incidentes y comunicaciones | SOC-CMM, SIM3, CTI-CMM, Hunting Maturity Model, NIST CSF 2.0 |
| [vendor-assessment](vendor-assessment/) | Selección, contratación y supervisión de proveedores de SOC, MSSP y MDR | SOC-CMM, SIM3, ISO/IEC 27001, SOC 2, MITRE ATT&CK Evaluations, NIST CSF 2.0 GV.SC |
| [templates](templates/) | Plantillas de informes y evaluaciones | ISO/IEC 27005, NIST SP 800-30 |

## ¿Por qué un hub para LATAM?

La mayoría del material de referencia está en inglés y pensado para organizaciones con presupuestos y equipos grandes. Este repositorio busca:

- Contenido **en español**, con terminología consistente.
- Ejemplos basados en **amenazas que sí se ven en la región**: troyanos bancarios, phishing que suplanta entidades locales, ransomware contra gobierno, salud y manufactura, fraude BEC en comercio exterior.
- Recomendaciones **aplicables por equipos pequeños**, indicando qué es imprescindible y qué es deseable.
- Referencias a **marcos internacionales**, para que todo sea comparable y auditable.


## README.md
# Inteligencia de amenazas

| Carpeta | Contenido |
|---|---|
| [ACH](ACH/) | Análisis de Hipótesis en Competencia: método y matrices de casos reales |
| [MITRE-ATTACK](MITRE-ATTACK/) | Mapeos de campañas y amenazas regionales a ATT&CK, capas de Navigator |
| [IOC-analysis](IOC-analysis/) | Análisis y enriquecimiento de indicadores de compromiso |
| [threat-profiles](threat-profiles/) | Perfiles de actores y familias de malware relevantes para LATAM |
| [OSINT](OSINT/) | Metodologías de inteligencia de fuentes abiertas: ciclo, Protocolo de Berkeley, OPSEC, ética y casos aplicados |

## Principios de análisis

- **Separar hechos de valoraciones.** Los hechos llevan la calificación de su fuente; las valoraciones, lenguaje estimativo.
- **Calificar fuentes** con la escala Almirantazgo (confiabilidad A–F, credibilidad 1–6, p. ej. `B2`).
- **Lenguaje estimativo calibrado:**

| Término | Probabilidad aproximada |
|---|---|
| Casi seguro | 95–99 % |
| Muy probable | 80–95 % |
| Probable | 55–80 % |
| Tan probable como no | 45–55 % |
| Improbable | 20–45 % |
| Muy improbable | 5–20 % |

- **Atribución prudente:** nunca atribuir a un actor o país sin evidencia y nivel de confianza explícitos.

## README.md
# Evaluación de madurez

Herramientas para medir y mejorar la madurez de las capacidades de ciberseguridad, basadas en modelos internacionales y adaptadas a la realidad de las organizaciones latinoamericanas: equipos pequeños, presupuestos limitados y regulación en evolución.

## Dominios

| Dominio | Modelo de referencia principal | Evaluación |
|---|---|---|
| [SOC](soc/) | **SOC-CMM** (Security Operations Center Capability Maturity Model) | 13 criterios |
| [Inteligencia de amenazas](cti/) | **CTI-CMM** (Cyber Threat Intelligence Capability Maturity Model) | 12 criterios |
| [Gestión de vulnerabilidades](vulnerability-management/) | **CIS Control 7**, **NIST SP 800-40r4**, **SSVC** | 11 criterios |
| [Cacería de amenazas](threat-hunting/) | **Hunting Maturity Model**, **TaHiTI**, **PEAK** | 10 criterios |
| [Respuesta a incidentes](incident-response/) | **SIM3** de la Open CSIRT Foundation, **NIST SP 800-61r3** | 13 criterios |
| [Comunicaciones](communications/) | **SIM3** (P-2, H-6), **NIST CSF 2.0** (RS.CO), **ISO 22361** | 12 criterios |

## Cómo usarlo

1. **Lee la [escala y el método](escala-y-metodo.md).** Todos los dominios usan la misma escala de 0 a 4 para poder compararlos.
2. **Copia la [hoja de autoevaluación](plantillas/autoevaluacion.csv)** (se abre en Excel o Google Sheets) y califica cada criterio con evidencia.
3. **Define el nivel objetivo** según el perfil de tu organización (ver abajo). No todo tiene que llegar a 4.
4. **Calcula los resultados** con [`scripts/calcular_madurez.py`](scripts/calcular_madurez.py) o en la hoja de cálculo.
5. **Prioriza las brechas** y arma la [hoja de ruta](plantillas/hoja-de-ruta.md).
6. **Comunica** con el [informe de madurez](plantillas/informe-madurez.md).
7. **Repite** cada 12 meses, o tras un cambio importante o un incidente grave.

## Niveles objetivo sugeridos por perfil

| Perfil | Ejemplo | Objetivo general | Prioridad |
|---|---|---|---|
| **Pequeña** | Pyme, ONG, municipio pequeño; TI de 1 a 3 personas, sin SOC propio | **1–2** | Los criterios marcados 🔴 en cada dominio |
| **Mediana** | Empresa con área de seguridad, SOC tercerizado o propio pequeño | **2–3** | Todos los criterios 🔴 en nivel 3 |
| **Regulada o crítica** | Banca, seguros, energía, telecomunicaciones, salud, gobierno central | **3–4** | Todos los criterios en 3; los regulatorios en 4 |

> Una organización pequeña con un SOC tercerizado también puede usar esta evaluación: califica lo que **exiges y verificas** de tu proveedor. Para seleccionar o supervisar proveedores usa [`vendor-assessment`](../vendor-assessment/).

## Por qué estos modelos

- **SOC-CMM** y **SIM3** son los modelos más usados en el mundo para SOC y equipos de respuesta. SIM3 es la base de la certificación de Trusted Introducer y del enfoque de madurez de ENISA para CSIRT nacionales.
- **CTI-CMM** es un modelo comunitario y neutral respecto a proveedores, inspirado en el C2M2, que mide la inteligencia por el valor que entrega a otras áreas.
- Gestión de vulnerabilidades, cacería y comunicaciones no tienen un modelo único dominante; aquí se combinan las referencias más reconocidas.

## incident-report.md
# Informe de incidente de seguridad

| | |
|---|---|
| **ID del incidente** | INC-AAAA-NNN |
| **Clasificación** | TLP:CLEAR · TLP:GREEN · TLP:AMBER · TLP:RED |
| **Estado** | Abierto · Contenido · Cerrado |
| **Severidad** | Crítica · Alta · Media · Baja |
| **Tipo** | Ransomware · Phishing · BEC · Malware · Acceso no autorizado · Fuga de datos · Otro |
| **Fecha de detección** | AAAA-MM-DD HH:MM (UTC) |
| **Fecha de cierre** | AAAA-MM-DD |
| **Elaborado por** | Nombre · rol |
| **Versión** | 1.0 |

## 1. Resumen ejecutivo
Qué pasó, impacto en el negocio, estado actual y decisiones requeridas. Máximo un párrafo, sin jerga técnica.

## 2. Alcance e impacto

| Dimensión | Detalle |
|---|---|
| Sistemas afectados | |
| Usuarios / cuentas afectadas | |
| Datos comprometidos | Tipo y volumen (personales, financieros, propiedad intelectual) |
| Impacto operativo | Servicios interrumpidos y duración |
| Impacto económico estimado | |

## 3. Línea de tiempo (UTC)

| Fecha y hora | Evento | Fuente de la evidencia |
|---|---|---|
| | Acceso inicial | |
| | Detección | |
| | Contención | |
| | Erradicación | |
| | Recuperación | |

## 4. Análisis técnico
### 4.1 Vector de acceso inicial
### 4.2 Actividad del atacante (ATT&CK)
