# Digest de conocimiento: auditor-riesgos

- **CIAC-008 Evaluacion de madurez** — `contrib/ciac-knowledge/cache/maturity-assessment/README.md` (sha256 e0021b088323)
- **CIAC-009 Evaluacion de proveedores** — `contrib/ciac-knowledge/cache/vendor-assessment/README.md` (sha256 b5e8e2d54765)
- **CIAC-010 Plantilla de informe** — `contrib/ciac-knowledge/cache/templates/incident-report.md` (sha256 92ffffe779ef)

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
