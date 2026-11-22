agent: cumplimiento-panama
topic: Vigencia y alcance de Ley 81/2019 y Decreto Ejecutivo 285/2021
created: 2026-11-21T21:45:01Z
status: cerrado
---

# Investigación: protección de datos personales en Panamá

## Qué se buscó y por qué
Verificar el marco aplicable a cualquier sistema que trate datos personales en contexto de negocio y tecnología, para convertirlo en reglas REG-01/02/06/07/08.

## Fuentes (oficiales y contraste)
- Gaceta Oficial 28743-A, Ley 81 de 26 de marzo de 2019: https://gacetaoficial.gob.pa/pdfTemp/28743_A/72148.pdf
- ANTAI, "Reglamentan Ley 81 de Protección de Datos Personales", 28 may 2021: https://antai.gob.pa/reglamentan-ley-81-de-proteccion-de-datos-personales/
- Ministerio Público, DE 285 de 28 may 2021: https://ministeriopublico.gob.pa/normativa_internac/decreto-ejecutivo-285-de-28-de-mayo-de-2021-que-reglamenta-la-ley-81-sobre-proteccion-de-datos-personales/
- Órgano Judicial (CENDOJ), texto del DE 285: https://www.organojudicial.gob.pa/cendoj/documentacion-cendoj/novedades-normativas/decreto-ejecutivo-285-de-28-de-mayo-de-2021-que-reglamenta-la-ley-81-de-26-de-marzo-2019-sobre-proteccion-de-datos-personales
- Contraste secundario (solo pista): guía de cumplimiento 2025 de recordinglaw.com.

## Versión vigente y cambio
Ley 81/2019 vigente, reglamentada por DE 285/2021 (28-05-2021). Autoridad: ANTAI. No se encontró evidencia de sustitución de la ley en las fuentes consultadas; la vigencia debe revalidarse trimestralmente.

## Impacto
Cualquier producto con datos de personas requiere inventario de tratamientos, consentimiento, aviso de privacidad, procedimiento ARCO, transferencias documentadas y medidas de seguridad. En logs/issues/buzón, un dato personal es hallazgo de seguridad (S-8/L-12).

## Implementación
1. Crear registro de tratamientos con responsable, finalidad y plazo de conservación.
2. Implementar procedimiento ARCO con bitácora y plazos (verificar plazos en texto oficial).
3. Añadir redacción automática en CI y prohibición de PII en telemetría.
4. Definir plan de respuesta a incidentes; **plazo exacto de notificación por violación de seguridad: verificar en texto del DE 285 antes de afirmarlo** (REG-02).
5. Dueño humano: responsable de cumplimiento; evidencia en `docs/kaizen/adr/`.

## Incertidumbre
No se pudo confirmar en fuente oficial consultada el plazo concreto de notificación de incidentes ni actualizaciones posteriores a 2025. Queda marcado como "vigencia no verificada" y escalado a humano (REG-15).
