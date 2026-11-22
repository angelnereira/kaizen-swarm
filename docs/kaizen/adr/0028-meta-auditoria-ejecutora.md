# ADR-0028: meta-auditoría con autoridad de ejecución

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
El análisis de comportamiento del agente mostró que la debilidad central no era falta de acciones sino de **cierre verificado**: reportar «listo/pusheado/publicado» sin `git ls-remote` ni `gh release view`, rodear permisos denegados con wrappers, no detectar deriva de versión y repetir clases de fallo sin stop-the-line. Auditar sin poder corregir deja el descubrimiento sin consecuencia.

## Decisión
1. Equipo `meta-auditoria` con autoridad para **ejecutar** remediaciones deterministas, no solo emitir dictámenes.
2. `scripts/kaizen-meta` con: `check` (gob/eval/swarm/security + permisos + S-10), `drift` (HEAD vs origin vs VERSION vs versión observada), `close` (HEAD vs `git ls-remote` + release publicada), `guard` (logs con `permission.rejected`), `recurrence` ( agrupa hallazgos por clase y dispara `PAUSE` al tercero) y `execute` (corrige supresiones S-10, regenera gobernanza/catálogo/agentes y sincroniza recuentos en docs).
3. Reglas operativas derivadas:
   - Ningún «hecho» sin evidencia de cierre real (K-10 reforzado).
   - Si el tool deniega una acción, se reporta; **no se rodea con wrappers**.
   - Tres repeticiones de la misma clase → `stop-the-line`, ADR pendiente y humano.
   - Al inicio de cada tarea, `drift` antes que `fix`.
4. `execute` **nunca** toca seguridad, dinero, datos personales ni decisiones regulatorias; solo archivos de gobernanza derivados y docs de estado. Cada cambio queda en `findings.jsonl` y `META-AUDITORIA.md`.

## Alternativas consideradas
- Equipo solo auditor: descartado; el usuario pidió explícitamente que ejecute cambios.
- Auto-remediación sin límites: descartado; violaría L-3/L-4.

## Consecuencias
- Positivas: el sistema corrige su propia deriva y cierra el loop antes de reportar.
- Negativas: más escrituras automáticas; se mitiga con alcance acotado, evidencia y stop-the-line.

## Cómo se verificará
- `kaizen-meta check|drift|close|guard|recurrence` en verde o con bloqueos documentados.
- `bash tests/run.sh` valida los comandos y que el equipo esté desplegado.
