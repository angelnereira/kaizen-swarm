---
description: Comunidad Kaizen swarm por issue (init | run | status | finalize | check)
argument-hint: init <issue> | run <issue> --round 1|2|3 | status [issue] | finalize <issue> | check
---
Lee `.kaizen/RULES.md`, `.kaizen/swarm/ROLES.md` y `.kaizen/swarm/PROTOCOL.md` y ejecuta la acción pedida en $ARGUMENTS usando `scripts/kaizen-swarm`. Respeta el principio de mínimo privilegio: sin `git push`, sin `gh pr`, sin `--no-verify`. Usa `KSW_DRY_RUN=1` para previsualizar acciones con efectos. Todo hallazgo se reporta en `.kaizen/loop/outbox/` (S-11). No inventes resultados.
