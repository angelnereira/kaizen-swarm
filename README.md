# kaizen-swarm

Hogar operativo de una comunidad de **17 agentes especializados** que trabajan por issue con aislamiento en git worktrees, buzón trazable y arbitraje de conflictos. Además es una **plantilla instalable**: `scripts/bootstrap <repo>` lleva la comunidad a cualquier proyecto sin sobrescribir lo que ya exista.

## Capas

| Capa | Reglas | CLI |
| --- | --- | --- |
| Gobernanza | `.kaizen/RULES.md` (K-1..K-12) | `scripts/kaizen` |
| Seguridad | `.kaizen/security/SECURITY-RULES.md` (S-1..S-16) | `scripts/kaizen-security` |
| Loop autónomo | `.kaizen/loop/LOOP.md` (L-1..L-15) | `scripts/kaizen-loop` |
| Comunidad | `.kaizen/swarm/ROLES.md`, `PROTOCOL.md` | `scripts/kaizen-swarm` |

Arranca en **nivel 3** (ADR-0001) con PAUSA retirada. Los workflows programados están condicionados a `vars.KAIZEN_LOOP_ENABLED == '1'`: el responsable añade `KAIZEN_TOKEN` y la clave del modelo antes de activarlos. Ningún agente recibe secretos (S-2).

## Flujo por issue

```
init N → R1 análisis/contratos → R2 implementación (worktrees) → R3 revisión → finalize N
```

- Cada rol escribe solo las rutas declaradas en `contracts/ownership.json`.
- Los mensajes van numerados en `mailbox/` con `seq/from/to/type/status`; un `handoff` necesita `ack`.
- `architect` y `security` (y `qa` por tests) pueden `BLOCK`; `finalize` no integra con BLOCK abierto.
- Los leases caducan: `reap` reporta y reasigna, de modo que un agente caído no detiene el issue.
- Buzón híbrido: `mailbox/` ignorado por git; `export.md` saneado se copia al descriptor del PR.

## Uso rápido

```bash
scripts/kaizen-swarm check                      # valida la instalación
KSW_DRY_RUN=1 scripts/kaizen-swarm init 42 --slug mi-cambio
scripts/kaizen-swarm init 42 --slug mi-cambio
scripts/kaizen-swarm run 42 --round 1
scripts/kaizen-swarm status 42
scripts/kaizen-swarm finalize 42 --publish      # push + PR (lo hace el orquestador)
```

Instalación en otro repo:

```bash
scripts/bootstrap /ruta/al/otro/repo
```

Verificación completa: `bash tests/run.sh` y `scripts/kaizen check`.

## Decisiones humanas pendientes

Secret scanning y push protection, Dependabot/CodeQL, reporte privado de vulnerabilidades, protección de rama con los checks Kaizen, CODEOWNERS sobre los rieles, permisos de workflows, token de granularidad fina, 2FA y límite de gasto del proveedor. Ver `.github/SECURITY.md`.

## Límites honestos

Los escáneres tienen falsos negativos; los hooks locales se pueden saltar. La barrera real es CI obligatorio + protección de rama + CODEOWNERS. El agente no es auditor y no tiene tokens. Ver KAIZEN-SECURITY.md §11 en la documentación de origen.
