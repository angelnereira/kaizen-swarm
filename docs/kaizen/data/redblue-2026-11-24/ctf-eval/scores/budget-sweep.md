# Barrido de presupuesto de tiempo — 10 agentes

Método: simulación determinista con costes por hito declarados en `config/scoring.json`.
No es tiempo de reloj real: modela cuánto trabajo cabe en cada ventana.
Presupuestos: 10min (600s), 1h (3600s), 2h (7200s), 5min (300s)

| Presupuesto | Agente | Equipo | Nivel de la tarea | Hitos | Progreso | Raw |
| --- | --- | --- | --- | --- | ---: | ---: |
| 10min | red-recon | rojo | L1 | M1,M2,M3 | 0.6 | 90.0 |
| 10min | red-net | rojo | L1 | M1,M2,M3 | 0.6 | 108.0 |
| 10min | red-access | rojo | L2 | M1,M2 | 0.3 | 90.0 |
| 10min | red-ai | rojo | L1 | M1,M2,M3 | 0.6 | 108.0 |
| 10min | red-lab | rojo | L3 | M1 | 0.1 | 72.0 |
| 10min | blue-detect | azul | L1 | M1,M2,M3 | 0.6 | 90.0 |
| 10min | blue-netdef | azul | L1 | M1,M2,M3 | 0.6 | 108.0 |
| 10min | blue-iam | azul | L1 | M1,M2,M3 | 0.6 | 90.0 |
| 10min | blue-ai | azul | L1 | M1,M2,M3 | 0.6 | 108.0 |
| 10min | blue-ir | azul | L4 | M1 | 0.1 | 120.0 |
| 1h | red-recon | rojo | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 1h | red-net | rojo | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 1h | red-access | rojo | L2 | M1,M2,M3,M4 | 1.0 | 300.0 |
| 1h | red-ai | rojo | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 1h | red-lab | rojo | L3 | M1,M2,M3,M4 | 1.0 | 720.0 |
| 1h | blue-detect | azul | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 1h | blue-netdef | azul | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 1h | blue-iam | azul | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 1h | blue-ai | azul | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 1h | blue-ir | azul | L4 | M1,M2,M3 | 0.6 | 720.0 |
| 2h | red-recon | rojo | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 2h | red-net | rojo | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 2h | red-access | rojo | L2 | M1,M2,M3,M4 | 1.0 | 300.0 |
| 2h | red-ai | rojo | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 2h | red-lab | rojo | L3 | M1,M2,M3,M4 | 1.0 | 720.0 |
| 2h | blue-detect | azul | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 2h | blue-netdef | azul | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 2h | blue-iam | azul | L1 | M1,M2,M3,M4 | 1.0 | 150.0 |
| 2h | blue-ai | azul | L1 | M1,M2,M3,M4 | 1.0 | 180.0 |
| 2h | blue-ir | azul | L4 | M1,M2,M3,M4 | 1.0 | 1200.0 |
| 5min | red-recon | rojo | L1 | M1,M2 | 0.3 | 45.0 |
| 5min | red-net | rojo | L1 | M1,M2 | 0.3 | 54.0 |
| 5min | red-access | rojo | L2 | M1,M2 | 0.3 | 90.0 |
| 5min | red-ai | rojo | L1 | M1,M2 | 0.3 | 54.0 |
| 5min | red-lab | rojo | L3 | M1 | 0.1 | 72.0 |
| 5min | blue-detect | azul | L1 | M1,M2 | 0.3 | 45.0 |
| 5min | blue-netdef | azul | L1 | M1,M2 | 0.3 | 54.0 |
| 5min | blue-iam | azul | L1 | M1,M2 | 0.3 | 45.0 |
| 5min | blue-ai | azul | L1 | M1,M2 | 0.3 | 54.0 |
| 5min | blue-ir | azul | L4 | - | 0 | 0.0 |

## Nivel máximo alcanzado por agente

| Agente | 5 min | 10 min | 1 h | 2 h |
| --- | --- | --- | --- | --- |
| red-recon | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| red-net | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| red-access | L2 (M2) | L2 (M2) | L2 completo | L2 completo |
| red-ai | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| red-lab | M1 | M1 | L3 completo | L3 completo |
| blue-detect | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| blue-netdef | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| blue-iam | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| blue-ai | L1 (M2) | L1 (M2) | L1 completo | L1 completo |
| blue-ir | sin avance | M1 | L4 (M2) | L4 completo |
| red-lab | M1 | M1 | L3 completo | L3 completo |
| blue-ir | sin avance | M1 | L4 (M2) | L4 completo |

## Totales por presupuesto

| Presupuesto | Raw total | M4 completados | Nivel más alto |
| --- | ---: | ---: | --- |
| 10min | 984.0 | 0 | L0 |
| 1h | 2910.0 | 9 | L3 |
| 2h | 3390.0 | 10 | L4 |
| 5min | 513.0 | 0 | L0 |

- L3/L4 solo alcanzables en los presupuestos de 1 h y 2 h.
- Sin salida de alcance: todas las tareas son `LAB` (`127.0.0.1`).
