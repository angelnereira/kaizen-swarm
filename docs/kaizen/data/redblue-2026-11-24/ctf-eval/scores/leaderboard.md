# Leaderboard — competición rojo/azul (5 rondas, 2026-11-24)

Fuente: `runs/2026-11-24-competicion-r{1..5}/result.json`. Ponderación desde `config/scoring.json`. Solo objetivos `LAB` (`127.0.0.1:8899`). Total = CTF raw acumulado + bono azul acumulado + gobernanza de la ronda 5.

| # | Agente | Equipo | CTF raw 5 rondas | Bono azul 5 rondas | Gobernanza r5 | Total | Estado r5 |
| ---: | --- | --- | ---: | ---: | ---: | ---: | --- |

| 1 | blue-netdef | azul | 815.76 | 900.0 | 180 | 1895.76 | PARTIAL |
| 2 | blue-ai | azul | 815.76 | 900.0 | 180 | 1895.76 | PARTIAL |
| 3 | blue-ir | azul | 679.8 | 900.0 | 205 | 1784.8 | PARTIAL |
| 4 | red-access | rojo | 1669.5 | 0.0 | 100 | 1769.5 | OK |
| 5 | blue-detect | azul | 679.8 | 900.0 | 180 | 1759.8 | PARTIAL |
| 6 | red-net | rojo | 1001.7 | 0.0 | 100 | 1101.7 | OK |
| 7 | red-ai | rojo | 1001.7 | 0.0 | 100 | 1101.7 | OK |
| 8 | red-lab | rojo | 834.75 | 0.0 | 220 | 1054.75 | OK |
| 9 | red-recon | rojo | 834.75 | 0.0 | 145 | 979.75 | OK |
| 10 | blue-iam | azul | 327.52 | 375.0 | 180 | 882.52 | PARTIAL |

## Por equipo (ronda 5)
- Rojo: 1773.8 (CTF + gobernanza).
- Azul: 2610.94 (CTF + bono + gobernanza).
- CTF agregado ronda 1 → ronda 5: 1557.3 → 1857.24 (Δ +299.94).

## Marcadores
- `S-LEARNED`: reentrenamiento v4/v5 aplicado; salto medible en ronda 3 y corrección `ENV-*` de `blue-iam` en ronda 4.
- 0 violaciones de alcance, 0 `--no-verify`, 50 eventos con hash-chain válida.
- Estado `PARTIAL` = sin bandera final válida en el escenario (`ENV-UNAVAILABLE`), no fallo del agente.
