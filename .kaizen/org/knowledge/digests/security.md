# Digest de conocimiento: security

- **CIAC-001 Hub general** — `contrib/ciac-knowledge/cache/01-hub.md` (sha256 7b84a245f7ba)
- **CIAC-002 Buenas practicas** — `contrib/ciac-knowledge/cache/best-practices/README.md` (sha256 79fc4c6b2ad0)
- **CIAC-003 Inteligencia de amenazas** — `contrib/ciac-knowledge/cache/threat-intelligence/README.md` (sha256 5146908b5c6f)
- **CIAC-004 Caceria de amenazas** — `contrib/ciac-knowledge/cache/threat-hunting/README.md` (sha256 d36ad04b47f5)
- **CIAC-005 Respuesta a incidentes** — `contrib/ciac-knowledge/cache/incident-response/README.md` (sha256 f17063a3a9bd)
- **CIAC-008 Evaluacion de madurez** — `contrib/ciac-knowledge/cache/maturity-assessment/README.md` (sha256 e0021b088323)
- **CIAC-009 Evaluacion de proveedores** — `contrib/ciac-knowledge/cache/vendor-assessment/README.md` (sha256 b5e8e2d54765)
- **CIAC-011 Datasets sinteticos** — `contrib/ciac-knowledge/cache/datasets/README.md` (sha256 4bc2511fc9ea)
- **CIAC-012 Deteccion como codigo** — `contrib/ciac-knowledge/cache/detection-as-code/README.md` (sha256 1170bff7d00b)

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
# Buenas prácticas

Guías de configuración segura pensadas para equipos de la región, desde la pyme con una sola persona de TI hasta el SOC de una entidad financiera.

| Carpeta | Alcance |
|---|---|
| [windows-hardening](windows-hardening/) | Estaciones y servidores Windows, Active Directory |
| [linux-hardening](linux-hardening/) | Servidores Linux (Debian/Ubuntu, RHEL y derivados) |
| [cloud-security](cloud-security/) | AWS, Azure, Google Cloud y Microsoft 365 / Google Workspace |
| [identity-security](identity-security/) | Identidades, MFA, cuentas privilegiadas y acceso |
| [nist-cisa](nist-cisa/) | Buenas prácticas de NIST y CISA para SOC, inteligencia, vulnerabilidades, cacería, respuesta a incidentes y comunicaciones |
| [ai-secure-development](ai-secure-development/) | Programar con IA, construir aplicaciones y agentes con LLM, y usar IA en operaciones de seguridad |

## Cómo está organizada cada guía

1. **Contexto:** por qué importa y qué amenazas mitiga (con técnicas ATT&CK).
2. **Prioridad:** 🔴 imprescindible · 🟡 recomendado · 🟢 deseable.
3. **Implementación:** pasos o comandos probados, con la versión.
4. **Verificación:** cómo comprobar que quedó aplicado.
5. **Impacto:** qué se puede romper y cómo revertir.
6. **Referencias:** CIS Benchmark, CIS Controls v8.1, NIST, OWASP, guía del fabricante.

Para empezar una guía nueva copia [`_plantilla.md`](_plantilla.md).

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
# Cacería de amenazas (Threat Hunting)

Búsqueda proactiva de actividad maliciosa que evadió los controles existentes, con el objetivo de **reducir el tiempo de permanencia del atacante** (*dwell time*) y mejorar continuamente la detección.

## Estructura

```
threat-hunting/
├── frameworks/          ← metodologías de referencia explicadas en español
│   ├── tahiti.md          TaHiTI: cacería dirigida por inteligencia
│   ├── magma.md           MaGMa: gestión de casos de uso de detección
│   └── peak.md            PEAK: hipótesis, línea base y modelos
├── hunts/               ← cacerías documentadas por la comunidad
│   └── _plantilla-hunt.md
└── backlog.md           ← ideas de cacería abiertas para que alguien las tome
```

## ¿Qué framework uso?

| Framework | Origen | Enfoque | Ideal para |
|---|---|---|---|
| [TaHiTI](frameworks/tahiti.md) | FI-ISAC Países Bajos (sector financiero), 2018 | Cacería estructurada disparada y enriquecida por inteligencia de amenazas | Equipos con función CTI y sectores regulados (banca, energía, gobierno) |
| [MaGMa](frameworks/magma.md) | FI-ISAC Países Bajos, 2017 | Gestión de casos de uso de monitoreo: de los riesgos del negocio a las reglas | Saber **qué ya se detecta** para no cazar lo que el SIEM ya cubre, y medir cobertura |
| [PEAK](frameworks/peak.md) | Splunk SURGe, 2023 | Tres tipos de cacería: por hipótesis, por línea base y asistida por modelos | Equipos que quieren combinar hipótesis con análisis de datos y anomalías |

Se complementan: **MaGMa** dice dónde están las brechas de detección, **TaHiTI** organiza la cacería a partir de la inteligencia, y **PEAK** amplía las técnicas de análisis. Todos usan **MITRE ATT&CK** como lenguaje común.

## Tipos de cacería

| Tipo | Punto de partida | Ejemplo |
|---|---|---|
| **Estructurada (por hipótesis)** | Inteligencia, una técnica ATT&CK o un hallazgo previo | "Un actor que ataca banca en la región usa tareas programadas para persistir en estaciones de trabajo" |
| **No estructurada (por datos)** | Exploración de datos y anomalías | Procesos que se ejecutan una sola vez en todo el parque |
| **Situacional** | Un evento externo | Vulnerabilidad explotada masivamente en un equipo de borde que usamos |

## Pirámide del dolor
Prioriza cacerías en la parte alta (herramientas y TTP). Buscar hashes o IPs es rápido pero el atacante los cambia en minutos; un comportamiento es mucho más difícil de cambiar.

## Modelo de madurez de cacería (*Hunting Maturity Model*)


## README.md
# Respuesta a incidentes

Playbooks para los incidentes más frecuentes en la región, estructurados según el ciclo de **NIST SP 800-61r3** (alineado con NIST CSF 2.0) e **ISO/IEC 27035**.

| Playbook | Cuándo usarlo |
|---|---|
| [ransomware](ransomware/) | Cifrado de archivos, notas de rescate o amenaza de publicación de datos |
| [phishing](phishing/) | Correo malicioso reportado o detectado, con o sin clic |
| [business-email-compromise](business-email-compromise/) | Cuenta de correo comprometida o fraude de pagos por suplantación |
| [data-leak](data-leak/) | Exposición no intencionada de datos: recurso público, credenciales en código, datos publicados por terceros |
| [data-breach](data-breach/) | Acceso no autorizado confirmado a datos, con o sin exfiltración demostrada; incluye notificaciones legales |

## Fases de cada playbook

| Fase | Pregunta clave |
|---|---|
| 0. Preparación | ¿Qué debe existir **antes** del incidente? |
| 1. Detección y análisis | ¿Qué pasó, desde cuándo y qué alcance tiene? |
| 2. Contención | ¿Cómo detengo la propagación sin destruir evidencia? |
| 3. Erradicación | ¿Cómo elimino al atacante y su persistencia? |
| 4. Recuperación | ¿Cómo vuelvo a operar de forma segura? |
| 5. Lecciones aprendidas | ¿Qué cambio para que no se repita? |

## Notificaciones en LATAM
Cada país tiene obligaciones distintas (autoridad de protección de datos, reguladores sectoriales como el financiero, CSIRT nacional). Todo playbook incluye un paso para **verificar con el área legal** qué notificaciones aplican y en qué plazo. Directorio de equipos de respuesta: https://www.first.org/members/teams/

Para documentar el incidente usa [`templates/incident-report.md`](../templates/incident-report.md).

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

## README.md
# Evaluación de proveedores de SOC y MSSP

Herramientas para **seleccionar, contratar y supervisar** proveedores de servicios de seguridad gestionados: SOC tercerizado, MSSP, MDR (detección y respuesta gestionadas) o servicios de respuesta a incidentes. Pensado para organizaciones de Latinoamérica de cualquier tamaño, desde la que contrata su primer SOC hasta la entidad regulada que debe justificar la elección ante su supervisor.

## Contenido

| Archivo | Para qué |
|---|---|
| [cuestionario.md](cuestionario.md) | 48 preguntas en 10 secciones, con evidencia a solicitar, señales de alerta y referencias |
| [plantillas/evaluacion-proveedores-ciac.xlsx](plantillas/evaluacion-proveedores-ciac.xlsx) | **Plantilla Excel lista para usar**: datos del proceso, pesos, cuestionario con calificación de hasta tres proveedores, prueba de concepto y resumen automático con ranking, descalificaciones y gráficos |
| [plantillas/cuestionario.csv](plantillas/cuestionario.csv) | Versión para enviar al proveedor y calificar |
| [plantillas/matriz-comparativa.csv](plantillas/matriz-comparativa.csv) y [pesos.csv](plantillas/pesos.csv) | Comparación ponderada de varias ofertas |
| [plantillas/prueba-de-concepto.md](plantillas/prueba-de-concepto.md) | Plan para probar la detección antes de firmar |
| [plantillas/acuerdo-de-nivel-de-servicio.md](plantillas/acuerdo-de-nivel-de-servicio.md) | Estructura de SLA con tiempos por severidad |
| [plantillas/clausulas-contractuales.md](plantillas/clausulas-contractuales.md) | Lista de verificación de cláusulas clave |
| [plantillas/revision-periodica.md](plantillas/revision-periodica.md) | Revisión trimestral y anual del servicio |
| [scripts/comparar_proveedores.py](scripts/comparar_proveedores.py) | Calcula el ranking ponderado y marca descalificaciones |

## Proceso

```
1. Requisitos  →  2. Preselección  →  3. Cuestionario  →  4. Verificación  →  5. Prueba de   →  6. Decisión  →  7. Contrato  →  8. Supervisión
   internos         (3–5 ofertas)      con evidencias      de evidencias      concepto           ponderada        y SLA          periódica
```

1. **Requisitos internos.** Antes de hablar con proveedores, define qué necesitas: activos y fuentes a monitorear, horario, qué acciones puede tomar el proveedor, regulación aplicable, presupuesto. Usa la [evaluación de madurez](../maturity-assessment/) para saber qué capacidades tienes y cuáles necesitas comprar.
2. **Preselección.** Descarta a quien no cumpla los criterios ⛔ básicos (cobertura 24/7, protección de datos, regulación sectorial).
3. **Cuestionario.** Envía la misma versión a todos y exige evidencia, no solo respuestas.
4. **Verificación.** Revisa certificados, pide demostraciones de la consola y llama a las referencias.
5. **Prueba de concepto.** Para contratos relevantes, mide la detección y el escalamiento con técnicas emuladas.
6. **Decisión.** Ajusta los pesos a tu realidad y calcula el ranking con la matriz.
7. **Contrato y SLA.** Lleva al contrato lo que el proveedor prometió en el cuestionario.
8. **Supervisión.** El servicio se gestiona, no solo se compra: revisión trimestral y reevaluación anual.

## Escala

Igual que la [evaluación de madurez](../maturity-assessment/escala-y-metodo.md):

| Puntaje | Significado para un proveedor |
|---|---|

## README.md
# Datasets sintéticos para práctica

Registros **100 % ficticios** de una semana de operación de una empresa inventada, con ataques reales simulados escondidos entre el tráfico normal. Sirven para practicar cacería de amenazas, ingeniería de detección, respuesta a incidentes y análisis de registros sin tocar datos reales.

> ⚠️ **Todo es ficticio.** La organización *Andina Logística S.A.* no existe. Las IPs externas son de rangos de documentación (RFC 5737), los dominios terminan en `.example`, la cuenta y la llave de AWS son los valores de ejemplo de la documentación de AWS y los hashes son aleatorios. No uses estos valores como indicadores reales.

## El entorno

| | |
|---|---|
| **Organización** | Andina Logística S.A. · dominio `empresa-andina.example` · dominio de Windows `ANDINA` |
| **Período** | Lunes 2 al viernes 6 de marzo de 2026, en UTC (Colombia = UTC−5) |
| **Personas** | 30 usuarios (`nombre.apellido`) y 2 administradores (`adm.carlos`, `adm.julia`) |
| **Equipos** | Estaciones `WS-001` a `WS-030` (<ip>–39) · `SRV-DC01` (<ip>) · `SRV-FS01` (<ip>) · `SRV-SQL01` (<ip>) · `SRV-WEB01` (<ip>, DMZ) · `lnx-web02` (<ip>, DMZ) |
| **Servicios expuestos** | Tienda en línea `tienda.empresa-andina.example` (IP pública <ip>) detrás de un WAF |
| **Nube** | AWS (cuenta 111122223333, región principal sa-east-1) · Microsoft Entra ID y Microsoft 365 |

## Fuentes

| Fuente | Carpeta | Eventos | Basada en |
|---|---|---|---|
| Sysmon | [`fuentes/sysmon`](fuentes/sysmon/) | ~4 800 | Sysmon para Windows (eventos 1, 3, 10, 11, 13, 22) |
| Seguridad de Windows | [`fuentes/windows-security`](fuentes/windows-security/) | ~2 400 | Registros Security y System (4624, 4625, 4672, 4688, 4698, 4720, 7045, 1102) |
| EDR | [`fuentes/edr-alertas`](fuentes/edr-alertas/) | ~30 | Alertas genéricas de un EDR |
| Firewall | [`fuentes/firewall`](fuentes/firewall/) | ~5 700 | Registro de tráfico de un firewall de nueva generación |
| Proxy web | [`fuentes/proxy`](fuentes/proxy/) | ~2 400 | Registro de un proxy de navegación |
| DNS | [`fuentes/dns`](fuentes/dns/) | ~2 600 | Consultas al DNS interno |
| WAF | [`fuentes/waf`](fuentes/waf/) | ~2 000 | Formato de registro de AWS WAF |
| Servidor web | [`fuentes/servidor-web`](fuentes/servidor-web/) | ~1 400 | Registro de accesos de la tienda |
| Correo | [`fuentes/correo`](fuentes/correo/) | ~430 | Pasarela de seguridad de correo |
| AWS CloudTrail | [`fuentes/aws-cloudtrail`](fuentes/aws-cloudtrail/) | ~710 | Formato CloudTrail (incluye archivo con estructura nativa `Records`) |
| Entra ID · inicios de sesión | [`fuentes/azure-entra-signin`](fuentes/azure-entra-signin/) | ~1 100 | Esquema de *sign-in logs* de Microsoft Entra |
| Entra ID · auditoría | [`fuentes/azure-entra-audit`](fuentes/azure-entra-audit/) | ~90 | Esquema de *audit logs* de Microsoft Entra |
| Microsoft 365 · auditoría | [`fuentes/m365-audit`](fuentes/m365-audit/) | ~210 | Registro de auditoría unificado (Exchange y SharePoint) |
| Linux · autenticación | [`fuentes/linux-auth`](fuentes/linux-auth/) | ~880 | `auth.log` (sshd, sudo, cron) |

Cada fuente viene en **dos formatos**:
- **CSV** (`.csv`): para Excel, hojas de cálculo y herramientas de análisis. Los campos anidados se aplanan con punto (`httpRequest.clientIp`) y las listas se guardan como JSON.
- **JSON Lines** (`.jsonl`): un objeto JSON por línea, el formato que ingieren directamente Splunk, Elastic, Microsoft Sentinel / Azure Data Explorer y la mayoría de los SIEM.


## README.md
# Detection as Code

Detecciones versionadas, revisadas y probadas como código. Licencia: [DRL 1.1](LICENSE.md).

| Carpeta | Formato | Plataforma |
|---|---|---|
| [sigma](sigma/) | Sigma (YAML) | Independiente: se convierte a cualquier SIEM con pySigma |
| [kql](kql/) | Kusto Query Language | Microsoft Sentinel, Defender XDR |
| [xql](xql/) | XQL | Cortex XDR / XSIAM |
| [yara](yara/) | YARA | Archivos y memoria |
| [suricata](suricata/) | Reglas Suricata | IDS/IPS de red |

## Ciclo de vida

```
experimental  →  test  →  stable
   (nueva)      (probada en   (usada por 2+ organizaciones
                 laboratorio)   sin falsos positivos relevantes)
```

## Requisitos de toda detección
- Técnica **MITRE ATT&CK** asociada.
- **Autor/a, fecha** y **referencias**.
- **Falsos positivos** conocidos.
- **Origen de datos** necesario (qué log o telemetría).
- Probada: indica plataforma y versión.

## Prioridad: Sigma primero
Si la lógica se puede expresar en Sigma, escríbela en Sigma y, si quieres, agrega la versión KQL o XQL. Así una misma detección sirve a toda la comunidad, sin importar su SIEM.

```bash
pip install sigma-cli
sigma plugin install microsoft365defender   # o splunk, elasticsearch, ...
sigma convert -t microsoft365defender sigma/windows/<regla>.yml
```

Los PR que tocan `sigma/` o `yara/` se validan automáticamente.
