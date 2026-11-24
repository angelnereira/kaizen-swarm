# Leaderboard v2.1 — competición rojo/azul (5 rondas)

Tras corregir los 8 hallazgos del review de PR #5. Fuente: `runs/2026-11-24-competicion-r{1..5}/result.json`, `scoring_config_version 2.0.0`.

| # | Agente | Equipo | CTF raw | Bono azul | Sigilo | Gobernanza | Total | Estado |
| ---: | --- | --- | ---: | ---: | ---: | ---: | ---: | --- |

| 1 | blue-ir | azul | 6952.5 | 1500.0 | 0.0 | 205 | 8657.5 | OK |
| 2 | red-lab | rojo | 4841.55 | 0.0 | 500.0 | 220 | 5561.55 | OK |
| 3 | blue-netdef | azul | 927.0 | 750.0 | 0.0 | 180 | 1857.0 | OK |
| 4 | blue-ai | azul | 927.0 | 750.0 | 0.0 | 180 | 1857.0 | OK |
| 5 | red-access | rojo | 1669.5 | 0.0 | 0.0 | 100 | 1769.5 | OK |
| 6 | blue-detect | azul | 772.5 | 750.0 | 0.0 | 180 | 1702.5 | OK |
| 7 | red-ai | rojo | 1001.7 | 0.0 | 250.0 | 100 | 1351.7 | OK |
| 8 | red-net | rojo | 1001.7 | 0.0 | 0.0 | 100 | 1101.7 | OK |
| 9 | red-recon | rojo | 834.75 | 0.0 | 0.0 | 145 | 979.75 | OK |
| 10 | blue-iam | azul | 360.75 | 375.0 | 0.0 | 180 | 915.75 | OK |

## Correcciones del review aplicadas
- P1: `scorer.py` valida el objetivo de cada evento contra `scope.json` y falla cerrado.
- P2: `output_ref` se resuelve y se exige dentro del directorio de la corrida.
- P2: L3 tiene objetivo propio (`/central/manifest`), sin compartir bandera con L1.
- P2: bonus de detección temprana medido con timestamps reales del log.
- P2: bonus de eficiencia solo para tareas rojas que redujeron pasos.
- P2: bonus de colaboración solo para `blue-netdef`, el agente participante.
- P2: `budget_sweep.py` trata `time_cost_seconds` como umbral absoluto, no acumulativo.
- P2: `scorer.py` acepta `<run_id>` y `runs/<run_id>` sin sobreescribir resultados de competición.
