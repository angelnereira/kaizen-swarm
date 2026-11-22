# Funciones de aptitud arquitectónica

- Ningún script supera 400 líneas.
- `scripts/kaizen-swarm` no importa de los CLIs directamente: delega en `scripts/lib/swarm-common.sh`.
- Un rol nunca escribe fuera de las rutas de `contracts/ownership.json` (fail-closed en `finalize`).
- Ningún mensaje del buzón contiene un valor sensible: todo pasa por `kaizen-security redact`.
- Ninguna rama del swarm se auto-fusiona si toca `KL_PROTECTED_GLOBS`.
- Tiempo de arranque de `scripts/kaizen-swarm check` < 2 s; duración de `tests/run.sh` < 30 s.
