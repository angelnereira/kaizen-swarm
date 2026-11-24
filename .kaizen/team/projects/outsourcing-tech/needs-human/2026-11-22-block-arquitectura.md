---
id: NH-OT-2026-11-22-001
correlation_id: OT-BLOCK-ARCH-001
from: facilitador-equipo
to: El Presidente
channel: alert
intent: decision
expects_ack: true
deadline: 2026-11-24T18:00:00Z
source_ids: [ISO-001, NIST-001, OWASP-001, TOOL-001]
status: open
created: 2026-11-22T18:39:42Z
---

# Escalado a El Presidente — BLOCK de arquitectura (outsourcing-tech)

## Reporte mínimo (`.kaizen/team/OWNER.md`)

**ESTADO:** ROJO — `outsourcing-tech`, etapa `execute` con veto `architecture` abierto.

**LOGRO:** 3/3 tareas del outbox pasaron de `owner: "?"` a dueño con lease y plazo
(0 tareas sin dueño); DEC-001 de **proceso** verificada con 4 fuentes `verified`
(`kaizen-team verify` rc=0; `kaizen-team check` rc=0, 25 fuentes). El fondo técnico
no fue aprobado por este agente.

**RIESGO:**
1. Veto `architecture` abierto: aislamiento, profundidad constante, buzón no atómico
   y `kaizen check` no hermético (outbox `arquitectura-block-adopcion.md`, H-1..H-11).
   El arquitecto confirmó en su ack que los ADR-0011..0015 **no existen en disco**
   (la numeración salta de 0010 a 0017) y que `kaizen check` sigue «no verificado».
2. KPI del equipo en rojo: solo 1/5 contratos tiene `evidence.md` y status `accepted`
   (rea-mcp); computer-use, grafana-stack, rae-api-install y whatsapp-bsp están `open`.
3. Dos bugs en `scripts/kaizen-team` (ruta protegida L-4): `assign`/`handoff` no
   registran acuses (`now` vs `$now`) e `init` no inicializa si el directorio ya
   existe. Workaround aplicado en datos del proyecto; no se parcheó el script.

**DECISIÓN REQUERIDA:** Autorizar (a) abrir ADR-0011..0015 en rama `kaizen/*` con
dueño `architect` y revisión de `security`, y (b) el parche de los dos bugs de
`scripts/kaizen-team` con rollback documentado. Opción recomendada: **sí**, plazo
2026-11-24T18:00Z. Riesgo de no autorizar: el KPI de outsourcing-tech permanece
bloqueado en `review` y ninguna integración de especialista puede verificarse.
Esta es una decisión sensible (rutas protegidas, gobernanza): no la toma el equipo.

**SIGUIENTE:** Sin intervención, el facilitador mantiene los 4 handoffs abiertos con
ack documentado, conserva el veto intacto, no fuerza `advance` y reporta el KPI real.
Con autorización, el arquitecto convierte cada hallazgo en ADR y `security` valida
la compuerta por capacidad antes de cualquier integración.

## Evidencia reproducible

```
git branch --show-current  → kaizen/facilitador-outsourcing-tech-block-arquitectura
bash scripts/kaizen-team verify outsourcing-tech  → rc=0
bash scripts/kaizen-team check                    → rc=0, 25 fuentes verificadas
bash scripts/kaizen-team sync outsourcing-tech    → acuses pendientes=4, tareas abiertas=3
sha256sum .kaizen/org/knowledge/SOURCES.md        → 11e960129d7e6f6f…
grep -m1 '^status:' .kaizen/org/outsourcing/*/contract.md → 1 accepted / 4 open
find .kaizen/org/outsourcing -name evidence.md    → solo rea-mcp/evidence.md
```

## Regla de 2 turnos

Turno 1 registrado (DEC-001 + handoff al arquitecto + ack del arquitecto). Si tras
dos turnos no hay acuerdo técnico, resuelve `architect` (técnico) o `product`
(alcance); si persiste, queda en este escalado `needs-human`. No se cierra nada
falsamente (K-2/K-10).
