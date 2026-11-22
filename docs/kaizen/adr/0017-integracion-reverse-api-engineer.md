# ADR-0017: integración de reverse-api-engineer como extensión de capacidades

Estado: aceptado (documentado y gobernado; instalación pendiente por cuota)
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
Cuando la configuración disponible de un agente no alcanza —no hay conector, la API no está documentada o el proveedor solo expone su sitio web— el equipo necesita extender sus capacidades generando un cliente tipado a partir del tráfico real. `reverse-api-engineer` (https://github.com/kalil0321/reverse-api-engineer, MIT) hace exactamente eso.

## Decisión
1. Documentar la herramienta en `.kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md` con fuente oficial, CLI, esquema JSON, exit codes y restricciones (TOOL-002).
2. Crear el agente `reverse-api-specialist` y el equipo `api-recon` (junto a `security`, `qa`, `verificador-evidencias` y `facilitador-equipo`).
3. Añadir el proceso `api_reverse_engineering`: `authorize` (A: humano, V: seguridad/cumplimiento) → `capture` → `generate` → `verify` (A: humano) → `integrate` → `learn`.
4. Reglas duras: solo sitios autorizados, sin evasión de anti-bot, sin credenciales en HAR, revisión de seguridad antes de ejecutar código generado, `run_id`+HAR+coste como evidencia.
5. No instalar nada sin aprobación (S-15). La aprobación general del humano cubre MCP/skills, pero la instalación de esta herramienta **falló por cuota de disco** (`Errno 122`); queda registrada en outbox y pendiente de reintento.

## Alternativas consideradas
- Copiar endpoints a mano desde DevTools: descartado; no reproducible ni verificable.
- Llamar a la API sin cliente tipado: descartado; Rompe REG-EV-01 y aumenta errores.

## Consecuencias
- Positivas: el equipo puede superar limitaciones de configuración con clientes generados y auditables.
- Negativas: dependencia de una herramienta externa y de cuota de disco; se mitiga con gobernanza, evidencia y reintento controlado.

## Cómo se verificará
- `kaizen-gov check` incluye el nuevo proceso con humano como A.
- Tras liberar cuota: `pip install --user reverse-api-engineer`, `npx skills add kalil0321/reverse-api-engineer` y una captura de prueba sobre sitio propio con `run_id` y HAR.
