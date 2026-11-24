# ADR-0027: resolución autónoma de conflictos y push efectivo

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira (autorización explícita en esta sesión)

## Contexto
Aunque ADR-0023 autorizó el push de agentes en ramas `kaizen/*`, los agentes seguían fallando con errores de permisos. La causa real no era la regla escrita sino la **denegación en el perfil generado de OpenCode**: `{"action":"shell","resource":"git push*","effect":"deny"}`. Además no existía un mecanismo para resolver conflictos de fusión sin intervención humana.

## Decisión
1. Eliminar la regla `deny` de `git push*` en `scripts/lib/opencode_agents.py` y añadir `allow` explícito para `git push*`, `git merge*`, `git rebase*`, `git checkout --ours/--theirs` y `gh issue/pr comment*`.
2. `scripts/kaizen-conflict` con `status`, `resolve --strategy ours|theirs --file F|--all`, `commit-push` y `abort`. Solo opera en ramas `kaizen/*`, `feature/*` o `fix/*`; **nunca en `main`**.
3. Cada resolución y push queda auditado en `.kaizen/team/runtime/conflicts.jsonl` con timestamp, rama y archivo.
4. La resolución es autónoma pero **verificable**: se exige que no queden archivos `diff-filter=U` antes de commitear, y el descriptor del issue debe registrar la estrategia elegida y su justificación (K-4/K-10).
5. El agente `kaizen-installer` ya no dice «no ejecutes git push»; indica que puede hacerlo en ramas `kaizen/*` (nunca `main`).

## Alternativas consideradas
- Seguir bloqueando push «por seguridad》: descartado; el usuario autorizó explícitamente y la denegación contradice ADR-0023.
- Resolver conflictos siempre con `theirs`: descartado; se exige declarar estrategia y evidencia.

## Consecuencias
- Positivas: los agentes pueden corregir, fusionar y publicar sin esperar; conflicto resuelto con traza.
- Negativas: riesgo de resolver mal un conflicto; se mitiga con estrategia explícita, auditoría y prohibición de `main`.

## Límites
Ninguna resolución autoriza push directo a `main`, cambios en secretos, seguridad, pagos ni decisiones regulatorias sin humano (L-3/L-4). Si el push remoto falla, se reporta en outbox; no se inventa éxito (K-10).

## Cómo se verificará
- `grep git push` en los 47 agentes generados debe mostrar `effect: allow`, nunca `deny`.
- `bash tests/run.sh` valida permisos y comandos de `kaizen-conflict`.
