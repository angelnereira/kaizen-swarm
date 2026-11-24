# Leaderboard v2 — competición rojo/azul (5 rondas)

Fuente: `runs/2026-11-24-competicion-r{1..5}/result.json` con `scoring_config_version 2.0.0`.
Total = CTF raw + bono azul + sigilo rojo + gobernanza (ronda 5).

| # | Agente | Equipo | CTF raw | Bono azul | Sigilo | Gobernanza | Total | Estado |
| ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |

| 1 | blue-ir | azul | 7647.75 | 1800.0 | 0.0 | 205 | 9652.75 | OK |
| 2 | red-lab | rojo | 4841.55 | 0.0 | 500.0 | 220 | 5561.55 | OK |
| 3 | blue-netdef | azul | 1019.7 | 900.0 | 0.0 | 180 | 2099.7 | OK |
| 4 | blue-ai | azul | 1019.7 | 900.0 | 0.0 | 180 | 2099.7 | OK |
| 5 | blue-detect | azul | 849.75 | 900.0 | 0.0 | 180 | 1929.75 | OK |
| 6 | red-access | rojo | 1669.5 | 0.0 | 0.0 | 100 | 1769.5 | OK |
| 7 | red-ai | rojo | 1001.7 | 0.0 | 250.0 | 100 | 1351.7 | OK |
| 8 | red-net | rojo | 1001.7 | 0.0 | 0.0 | 100 | 1101.7 | OK |
| 9 | red-recon | rojo | 834.75 | 0.0 | 0.0 | 145 | 979.75 | OK |
| 10 | blue-iam | azul | 396.82 | 375.0 | 0.0 | 180 | 951.82 | OK |

## V2: mejoras aplicadas
- Bono de sigilo `S-STEALTH` (+50 por tarea roja no detectada con M4).
- `blue-iam` tiene bandera real: pasó de PARTIAL a OK (M4, 173.25 + 187.5).
- `expect=200` en tareas azules: M2 ya no se pierde por configuración.
- Escala nueva: no comparar cifras v1 con v2 directamente.
