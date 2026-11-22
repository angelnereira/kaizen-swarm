# kaizen-swarm

Ejecuta una ronda de la comunidad Kaizen sobre un issue.

1. Lee `.kaizen/RULES.md`, `.kaizen/security/SECURITY-RULES.md`, `.kaizen/swarm/ROLES.md` y `.kaizen/swarm/PROTOCOL.md`.
2. Pregunta o deduce el número de issue y la ronda (1, 2 o 3); si no se indican, muestra `scripts/kaizen-swarm status` y termina.
3. Trabaja siempre en `wt-issue-<N>-<rol>`, nunca en la rama por defecto del repositorio.
4. Usa `KSW_DRY_RUN=1 scripts/kaizen-swarm run <N> --round <R>` para previsualizar y después ejecútalo sin la variable.
5. Ejecuta `scripts/kaizen check` y escribe tu dictamen en `reviews/<rol>.md`.
6. No hagas push ni abras PR: lo hace `scripts/kaizen-swarm finalize <N> --publish`.

Modo desatendido con `agy -p`: solo en contenedor desechable, con lista de denegación (`rm`, `curl`, `wget`, `env`, `printenv`, `git push`) y `KL_AUTONOMY=3` conforme a ADR-0001. Verifica antes la sintaxis de tu versión de `agy`: los reportes públicos describen aprobación automática de herramientas destructivas en modo impresión.
