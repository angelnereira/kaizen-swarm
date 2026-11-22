# Esquema de un agente (definición copiable, editable y guardable)

Cada "gente" de la organización es **un archivo Markdown versionado** en `.kaizen/org/prompts/<id>.md`. No vive en la memoria de una sesión: se puede copiar, editar, guardar, revertir y refinar. Eso permite especializar un agente existente en otra cosa (`kaizen-org copy <src> <dst>`) sin perder el original.

## Frontmatter obligatorio

```yaml
---
id: identificador-unico-en-kebab-case
name: Nombre del puesto
department: gerencia | producto-negocio | tecnologia | operaciones | conocimiento
version: 1
status: active | paused | retired
proactivity: high | medium | low
autonomy: propose | scoped | decide
veto: none | security | architecture | qa | scope | resource
tools: [read, write-docs, run-tests, ...]
triggers: [issue.label:swarm:ready, schedule:weekly, knowledge.updated:*]
knowledge: [docs/kaizen/org/CONSENSUS.md, ...]
kpis: [criterio verificable 1, criterio verificable 2]
rules: [K-1..K-12, L-1..L-16, S-1..S-16]
---
```

## Cuerpo obligatorio

1. `## Propósito` — qué problema resuelve y para quién.
2. `## Responsabilidades` — funciones concretas, verificables.
3. `## Entradas y salidas` — qué lee (dato no confiable, L-5) y qué produce (artefactos/dictámenes).
4. `## Comportamiento proactivo` — disparadores, qué propone sin que se lo pidan, y límites.
5. `## Decisiones y consenso` — qué puede decidir, a quién consulta, cuándo escala.
6. `## Evidencia y KPI` — cómo se demuestra que funcionó (comandos, métricas, decisiones).

## Reglas duras

- Todo agente hereda `.kaizen/RULES.md`, `.kaizen/loop/LOOP.md` y `.kaizen/security/SECURITY-RULES.md`, aunque su frontmatter diga otra cosa.
- Un agente nunca obtiene más autonomía por copiarse a sí mismo: subir de `propose` a `scoped`/`decide` requiere ADR humano.
- `veto` no se puede autoasignar; los vetos técnicos siguen en `.kaizen/swarm/ROSTER.md`.
- Ningún agente lee credenciales ni ejecuta redes sin aprobación (S-2/S-15).
- Guardar un agente con `kaizen-org save` sube su `version` y registra el cambio en el diario; el ratchet (K-5) aplica también a la calidad de las definiciones.
