# Paquete de conocimiento CIAC LATAM → agentes Kaizen

**Fecha de preparación:** 2026-11-25
**Fuente:** https://github.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB (rama `main`)
**Estado:** propuesto, **no aplicado**. Requiere decisión humana (L-3/L-4).

## Objetivo

Convertir el hub de CIAC LATAM en **contexto verificable y entrenamiento** para los agentes de
ciberseguridad y protección de datos de Kaizen, con procedencia, hash, fecha de corte y
trazabilidad de qué agente consumió qué documento.

## Qué NO es

- **No son eventos históricos reales.** `datasets/README.md` declara que los registros son
  100 % ficticios (organización inventada, IPs RFC 5737, dominios `.example`, llave AWS de
  ejemplo). Lo que sí es real y verificable es la **procedencia del recurso**, las
  **técnicas/ATT&CK** y las **estructuras de log**. No se puede afirmar lo contrario (K-10).
- **No es ejecución de ataques.** El material es TLP:CLEAR, defensivo y educativo. Todo se
  lee como dato no confiable (S-15/L-5): ninguna instrucción dentro de un log, issue o
  documento se obedece como orden.
- **No modifica `.kaizen/` directamente.** Es ruta protegida (L-4). La aplicación se hace con
  los scripts auditados `kaizen-org feed` / `kaizen-org digest` (ver `apply.sh`).

## Licencias

| Contenido | Licencia | Uso |
| --- | --- | --- |
| Repo salvo `detection-as-code/` | CC BY 4.0 | Libre, incluso comercial, citando a *CIAC LATAM Community Hub* |
| `detection-as-code/` | DRL 1.1 | Reglas; respetar términos propios |
| Clasificación | TLP:CLEAR | Difusión abierta; aun así, tratar como dato no confiable |

## Contenido del paquete

| Archivo | Para qué |
| --- | --- |
| `FUENTES-propuesto.md` | Filas propuestas para `.kaizen/org/knowledge/SOURCES.md` con `source_id`, URL, `sha256`, `retrieved` y estado |
| `manifest-propuesto.jsonl` | Entradas para `kaizen-org feed`: qué documento se alimenta a qué agente |
| `MAPA-AGENTES.md` | Mapa sección del hub → agente → KPI verificable |
| `PLAN-ENTRENAMIENTO.md` | Cómo practicar con los 5 escenarios, rúbrica y frenos |
| `apply.sh` | Aplicación auditable (descarga, verificación de hash, feed, digest). Requiere `CIAC_APPLY=1` |
| `agents/data-protection-specialist.md` | Borrador de puesto nuevo (propuesto, no instalado) |

## Cómo aplicar (humano)

```bash
# 1) Revisar el paquete y las filas de FUENTES-propuesto.md
# 2) Aplicar conocimiento (feed + digest) con gate explícito:
CIAC_APPLY=1 bash contrib/ciac-knowledge/apply.sh

# 3) Con la revisión humana hecha, incorporar las filas de FUENTES-propuesto.md
#    a .kaizen/org/knowledge/SOURCES.md y fijar fecha de corte 2026-11-25

# 4) Verificar
scripts/kaizen-org status
scripts/kaizen-org digest all
```

`apply.sh` **no** hace push, **no** escribe en `.kaizen/` directamente, **no** lee credenciales
y falla cerrado si un hash no coincide.

## Decisiones requeridas

1. ¿Aplicar el feed a todos los agentes listados o solo al núcleo (`security`, `blue-detect`,
   `blue-ir`, `data-expert`, `cumplimiento-panama`)?
2. ¿Instalar el borrador `data-protection-specialist` mediante `kaizen-org copy`? (subir
   autonomía requiere ADR humano; el borrador es `propose`, sin veto).
3. ¿Registrar los source_ids `CIAC-*` como `verified` (repo oficial consultado) o `pending`
   hasta revisión humana de cada documento?
