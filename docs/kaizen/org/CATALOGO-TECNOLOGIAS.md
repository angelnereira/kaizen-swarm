# Catálogo de skills y tecnologías — v1.0.0

Generado: 2026-11-22T05:16:35.716837+00:00Z | Fuente: REA morluto/rea (MIT) + kaizen-swarm

Herramientas REA: **19** | Familias: 5 | Proveedores: 4 | Skills del framework: 12

> Contenido externo = dato no confiable (S-15/L-5). La instalación de REA fue aprobada por El Presidente (ADR-0009). Las operaciones con efectos (`launches_process`, `may_write_filesystem`, etc.) requieren el proceso `reverse_engineering`.

## Familias de capacidades REA

| Familia | Herramientas | Proveedores | Efectos |
| --- | ---: | --- | --- |
| Artefactos y datos (`artifacts`) | 7 | native-macos, rea-artifact-graph, sqlite | launches_process, may_write_filesystem |
| Managed / .NET / Swift / ObjC (`managed`) | 6 | native-macos, rea-artifact-graph, rea-dotnet-static | launches_process, may_write_filesystem |
| Binarios nativos y funciones (`native`) | 2 | native-macos | launches_process, may_access_network, may_show_ui |
| Inspección general (`other`) | 1 | native-macos | launches_process |
| Runtime, debug e instrumentación (`runtime`) | 3 | native-macos, rea-artifact-graph | launches_process, may_access_network, may_show_ui |

### Operaciones por familia

**Artefactos y datos** (7): `extract_artifact`, `inspect_artifact`, `inspect_asset_catalog`, `inspect_keyed_archive`, `inspect_plist`, `inspect_signature`, `inspect_sqlite_database`

**Managed / .NET / Swift / ObjC** (6): `decode_interface_builder`, `demangle_swift`, `inspect_macho`, `inspect_managed_artifact`, `inspect_managed_members`, `inspect_managed_native_boundaries`

**Binarios nativos y funciones** (2): `capture_native_ui_scenario`, `inspect_native_dispatch_metadata`

**Inspección general** (1): `list_architectures`

**Runtime, debug e instrumentación** (3): `observe_native_calls`, `observe_native_ui`, `trace_dylib_resolution`

## Skills del framework

| Skill | Propósito | Ubicación | Dueño |
| --- | --- | --- | --- |
| `kaizen` | Gobernanza, ratchet, PDCA y evidencia | `scripts/kaizen` | todos |
| `kaizen-security` | Secretos, supresiones y SAST | `scripts/kaizen-security` | seguridad |
| `kaizen-swarm` | Comunidad por issue, worktrees y leases | `scripts/kaizen-swarm` | equipo |
| `kaizen-org` | Inventario de agentes, conocimiento y outsourcing | `scripts/kaizen-org` | equipo |
| `kaizen-team` | Escuadras, standups y decisiones | `scripts/kaizen-team` | equipo |
| `kaizen-eval` | Evaluación y ratchet de agentes | `scripts/kaizen-eval` | calidad |
| `kaizen-learn` | Aprendizaje a partir de errores | `scripts/kaizen-learn` | calidad |
| `kaizen-gov` | RACI, obligaciones y derechos | `scripts/kaizen-gov` | gobernanza |
| `kaizen-runtime` | Runtime proactivo y equipos | `scripts/kaizen-runtime` | operación |
| `kaizen-installer` | Instalación en repos y OpenCode | `scripts/kaizen-installer` | distribución |
| `kaizen-notify / kaizen-inbox` | WhatsApp/n8n y correo | `scripts/kaizen-notify` | comunicación |
| `reverse-engineer-anything` | Skill REA de investigación guiada | `~/.agents/skills/reverse-engineer-anything` | rea-specialist |

## Automejora del equipo

- kaizen-eval mide la definición
- kaizen-learn convierte errores en experiencia
- kaizen-org copy/save especializa agentes
- kaizen-release publica y propaga versiones

Las iteraciones producen lecciones (`kaizen-learn`), mejoran definiciones (`kaizen-org save`), suben la puntuación (`kaizen-eval`) y se publican como nueva versión (`kaizen-release`).
