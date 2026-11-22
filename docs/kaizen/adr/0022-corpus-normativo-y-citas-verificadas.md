# ADR-0022: corpus normativo local, frescura y citas verificadas

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La comunidad necesita responder con normativa vigente citada con precisión. La documentación actual tiene registros dispersos (`SOURCES.md`) sin anclas por artículo, sin control de frescura y sin verificación automática de citas. La propuesta v1.3.0 pide un corpus con fuentes oficiales, niveles V/S/I/N y un verificador de citas.

## Decisión
1. `.kaizen/knowledge/sources.json` es el registro estructurado (id `PA-XXX-000`/`INT-STD-000`, dominio, emisor, URL, fecha, `freshness_days`, hash, nivel V/S/I/N). `SOURCES.md` sigue siendo la vista legible.
2. `scripts/kaizen-knowledge` implementa `add`, `ingest`, `verify --by <humano>`, `diff`, `index`, `stale`, `cite-check` y `check`.
3. Niveles: **V** (verificado por humano), **S** (fuente oficial localizada, texto no verificado), **I** (interpretación), **N** (vencido). Solo V sustenta decisiones.
4. `ingest` usa canales oficiales con User-Agent identificable, guarda el binario y su SHA-256, y **nunca supone contenido** si hay bloqueo: lo reporta al outbox S-11. No se eluden CAPTCHAs.
5. `stale` aplica SLO de frescura (7 días fiscal/banca, 30 general, 365 estándares) y degrada a N; `cite-check` falla si una cita no existe o no es V.
6. Equipo `normativa-corpus` con modelo `opencode/hy4-flash-free`, 10 miembros técnicos y de negocio.
7. Recursión controlada: `kr_MAX_DEPTH=3`, `KT_MAX_AGENTS=12`, `KT_MAX_PARALLEL=6`; ningún agente auto-edita su definición ni auto-publica norma verificada (ADR-0007/0021).

## Alternativas consideradas
- Scraping libre y memorístico: descartado; no auditable ni verificable (S-15).
- Verificación por el propio agente: descartado; `verify` exige `--by <humano>`.

## Consecuencias
- Positivas: citas trazables por artículo y fecha, frescura medible y bloqueo de fuentes no verificadas.
- Negativas: una fuente recién añadida arranca en I y no sirve hasta revisión humana; es una decisión deliberada.

## Límites
Los agentes no sustituyen a abogados, contadores ni profesionales licenciados. Todo dictamen crítico lleva firma humana. La red solo se usa a dominios oficiales; sin credenciales ni evasión de controles.

## Cómo se verificará
- `kaizen-knowledge check/index/stale/cite-check` y `bash tests/run.sh`.
- Prueba de abstención: una pregunta sin base en corpus debe devolver «sin fuente verificada».
