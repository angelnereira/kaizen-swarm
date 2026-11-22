# Meta-auditoría del equipo

Generado: 2026-11-22T20:01:31.366964+00:00 | Hallazgos: 19

| Nivel | Regla | Detalle |
| --- | --- | --- |
| ok | `check-gov` | kaizen-gov check: todo en verde (45 agentes, 12 procesos) |
| ok | `check-eval` | agentes=45 promedio=100.0 minimo=70 bajo_minimo=0 |
| ok | `check-swarm` | [kaizen-swarm] kaizen-swarm check: todo en verde |
| ok | `check-security` | kaizen-security: ok |
| ok | `permisos-push` | 0 agentes con deny de push |
| block | `s10-supresiones` | 32 supresiones sin issue |
| ok | `check-gov` | kaizen-gov check: todo en verde (45 agentes, 12 procesos) |
| ok | `check-eval` | agentes=45 promedio=100.0 minimo=70 bajo_minimo=0 |
| block | `check-swarm` | scripts/kaizen-swarm: line 233: `}' |
| block | `check-security` | scripts/kaizen-security: line 154: `}' |
| ok | `permisos-push` | 0 agentes con deny de push |
| ok | `s10-supresiones` | 0 supresiones sin issue |
| ok | `check-gov` | kaizen-gov check: todo en verde (45 agentes, 12 procesos) |
| ok | `check-eval` | agentes=45 promedio=100.0 minimo=70 bajo_minimo=0 |
| ok | `check-swarm` | [kaizen-swarm] kaizen-swarm check: todo en verde |
| ok | `check-security` | kaizen-security: ok |
| ok | `permisos-push` | 0 agentes con deny de push |
| ok | `s10-supresiones` | 0 supresiones sin issue |
| ok | `ejecucion` | 13 cambios aplicados |

## Cambios ejecutados

- supresiones S-10 corregidas en kaizen-meta
- supresiones S-10 corregidas en kaizen-notify
- supresiones S-10 corregidas en kaizen-loop
- supresiones S-10 corregidas en kaizen-learn
- supresiones S-10 corregidas en kaizen
- supresiones S-10 corregidas en kaizen-runtime
- supresiones S-10 corregidas en kaizen-start
- supresiones S-10 corregidas en kaizen-release
- gobernanza: OK
- catálogo: OK
- inventario: OK
- agentes globales: OK
- agentes locales: OK

## Límites
La meta-auditoría no modifica seguridad, dinero, datos personales ni decisiones regulatorias. Si dispara `stop-the-line`, requiere ADR humano antes de continuar (ADR-0028).
