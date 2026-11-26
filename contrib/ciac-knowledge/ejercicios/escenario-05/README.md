# Ejercicio 05 — fuerza bruta SSH + minería (CIAC-011)

**Proyecto Kaizen:** `ciac-detection-training` (etapa `closed`)
**KPI:** precisión ≥ 0.90 y FP=0; 100 % de hallazgos con `evento_id`, fuente, ATT&CK y comando reproducible.
**Datos:** 100 % sintéticos. Ningún evento se reporta como ocurrido (K-10).

## Reproducir

```bash
bash descargar.sh          # descarga 3 archivos a datos/ e imprime sha256
python3 validar.py         # imprime métricas y sale 0 solo si PASS
cat resultados.md          # salida real de la corrida de validación
```

## Resultado real

| Regla / línea base | Coincidencias | TP | FP | Precisión | Gate |
| --- | --- | --- | --- | --- | --- |
| `baseline_todos_los_fallos_sshd` | 453 | 380 | 73 | 0.839 | **FAIL** (esperado) |
| `auth_linux_ssh_failed_password` | 380 | 380 | 0 | 1.000 | PASS |
| `firewall_ssh_internet_dmz_temporal` | 95 | 95 | 0 | 1.000 | PASS |
| `firewall_pool_mineria_3333` | 359 | 359 | 0 | 1.000 | PASS |

Cobertura combinada: **834/838 = 0.995** del escenario 05. `RESULTADO: PASS`.

La línea base falla antes de las reglas nuevas: eso satisface L-6 (prueba que falla primero).

## Artefactos

| Archivo | Responsable |
| --- | --- |
| `reglas/*.yml` | blue-detect |
| `resultados.md` + `validar.py` | qa |
| `verificacion-fuentes.md` | verificador-evidencias |
| `linea-tiempo.md` | blue-ir |
| `reviews/security.md` | security (APPROVE condicionado) |

## Condiciones

Las reglas quedan en `experimental`: precisión 100 % sobre corpus sintético **no** garantiza
cero falsos positivos en producción. No contactar las IPs del dataset; no aplicar en producción
sin validación en telemetría real.
