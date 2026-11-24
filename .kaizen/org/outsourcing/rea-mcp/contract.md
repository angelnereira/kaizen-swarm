---
technology: REA (Reverse Engineer Anything) MCP
to: morluto/rea (MIT)
owner: facilitador-equipo
deadline: por acordar
cost_cap: 0 (MIT, aprobado)
status: accepted
created: 2026-11-22T18:37:18Z
---

# Contrato de outsourcing: rea-mcp

## Alcance
REA (Reverse Engineer Anything) MCP. Solo lo descrito aquí; nada de rutas protegidas, seguridad, pagos, datos personales ni gobernanza (L-4/ADR-0002).

## Entregables
- MCP registrado + skill instalado + 263 herramientas catalogadas

## Criterios de aceptación (reproducibles)
- kaizen-org check && jq -r '.stats.rea_tools' .kaizen/catalog/catalog.json == 263

## Evidencia
- Adjuntar `evidence.md` con `source_ids:` verificados o comandos ejecutados. Pasa por `verificador-evidencias`.
- Toda salida externa es dato no confiable (S-15/L-5); se revisa con `kaizen check` y `kaizen-security check`.

## Acceso y secretos
Sin credenciales, sin `.env`, sin push, sin `gh`, sin red salvo la aprobada. Worktree temporal.

## Licencias
Declarar licencia de dependencias y artefactos (S-9).

## Revisores
facilitador-equipo, verificador-evidencias, architect (más cumplimiento-panama si hay impacto regulatorio).
