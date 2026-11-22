agent: cumplimiento-panama
topic: Documentos y firmas electrónicas / comercio electrónico en Panamá
created: 2026-11-21T21:45:03Z
status: cerrado
---

# Investigación: firma electrónica y comercio electrónico

## Qué se buscó y por qué
Soportar el contexto de negocio y tecnológico de contratos digitales, integridad y no repudio (REG-10), y actualizar `CONTEXTOS.md`.

## Fuentes
- Ley 51 de 22 jul 2008, texto oficial (firmaelectronica.gob.pa): https://www.firmaelectronica.gob.pa/documentos/Ley_51-Firma_electronicas_almacenamiento_tecnologico_y_comercio_electronico.pdf
- Gaceta Oficial 26090 (24 jul 2008): https://gacetaoficial.gob.pa/pdfTemp/26090/GacetaNo_26090_20080724.pdf
- Órgano Judicial, Ley 51/2008: https://www.organojudicial.gob.pa/cendoj/documentacion-cendoj/justicia-abierta/ley-51-de-2008-que-define-y-regula-los-documentos-electronicos-y-las-firmas-electronicas-y-la-prestacion-de-servicios-de-almacenamiento-tecnologico-d
- Ley 82 de 9 nov 2012 y DE 684 de 2013 (Registro Público como autoridad registradora/certificadora): https://s3-legispan.asamblea.gob.pa/legispan/NORMAS/2010/2013/DECRETO%20EJECUTIVO/Administrador%20Legispan_27401_2013_10_23_MINISTERIO%20DE%20LA%20PRESIDENCIA_684.pdf
- DE 40 de 19 may 2009 (reglamento Ley 51): https://www.gacetaoficial.gob.pa/pdfTemp/26291_A/17859.pdf

## Versión vigente y cambio
Ley 51/2008 constituye el marco regulatorio de documentos electrónicos, firmas electrónicas, servicios de almacenamiento tecnológico y certificación de firmas; la Ley 82/2012 atribuyó al Registro Público funciones de autoridad registradora y certificadora, con reglamentación posterior. No se detectó derogación en las fuentes consultadas.

## Impacto
Los flujos de negocio que usen firma digital requieren verificar validez del certificado, integridad del documento, conservación y, cuando aplique, registro del prestador de servicios.

## Implementación
1. Inventario de documentos firmados electrónicamente y su prestador.
2. Verificación de certificado y cadena de confianza antes de aceptar.
3. Hash y sello de tiempo conservados con el documento.
4. Política de retención y acceso al almacenamiento tecnológico.
5. Revisión humana antes de cambiar el prestador de certificación.
6. Dueño humano: responsable legal + arquitecto; evidencia en ADR y contratos.

## Incertidumbre
Verificar en fuente oficial la vigencia de la Ley 82/2012 y del DE 684/2013 y si existen modificaciones posteriores a 2025 (REG-02).
