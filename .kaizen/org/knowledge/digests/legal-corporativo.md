# Digest de conocimiento: legal-corporativo

- **CIAC-005 Respuesta a incidentes** — `contrib/ciac-knowledge/cache/incident-response/README.md` (sha256 f17063a3a9bd)
- **CIAC-009 Evaluacion de proveedores** — `contrib/ciac-knowledge/cache/vendor-assessment/README.md` (sha256 b5e8e2d54765)

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
