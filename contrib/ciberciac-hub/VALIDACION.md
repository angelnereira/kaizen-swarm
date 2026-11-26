# Validación de las nuevas reglas Sigma

**Fecha:** 2026-11-25
**Dataset:** `CIAC-LATAM-COMMUNITY-HUB/datasets` (rama `main`, CC BY 4.0)
**Verdad de terreno:** `datasets/soluciones/verdad-terreno.csv` (1 535 eventos maliciosos)

## Observación

El hub tiene una sola regla Sigma (`proc_creation_win_vssadmin_borrado_shadow.yml`, T1490)
para 1 535 eventos maliciosos repartidos en cinco escenarios. Hay una brecha de cobertura
evidente en T1003.001, T1053.005 y T1567.002 del escenario 01.

## Evidencia

Las cuatro reglas propuestas se evaluaron con la misma lógica que expresa Sigma, aplicada
sobre `datasets/fuentes/sysmon/sysmon.jsonl` (4 773 eventos) y contrastada por `evento_id`
contra la verdad de terreno.

| Regla | Técnica | Coincidencias | TP | FP | FN (sysmon, técnica) | Precisión | Cobertura |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `proc_creation_win_comsvcs_lsass_dump` | T1003.001 | 1 | 1 | 0 | 1 | 100 % | 50 % (1 de 2) |
| `proc_access_win_lsass_suspicious_access` | T1003.001 | 1 | 1 | 0 | 1 | 100 % | 50 % (1 de 2) |
| `proc_creation_win_rclone_exfiltration` | T1567.002 | 1 | 1 | 0 | 0 | 100 % | 100 % |
| `proc_creation_win_schtasks_suspicious_persistence` | T1053.005 | 1 | 1 | 0 | 0 | 100 % | 100 % |

Las dos reglas de T1003.001 son complementarias: juntas cubren el 100 % de los dos eventos
Sysmon de esa técnica (volcado con `comsvcs.dll` y acceso al proceso `lsass.exe`).

### Eventos coincidentes (todos maliciosos según verdad de terreno)

| `evento_id` | Hora UTC | Regla | Línea de comando / acceso |
| --- | --- | --- | --- |
| `535112f1-…-afb41fda8468` | 2026-03-04 19:17:00 | comsvcs | `rundll32.exe …comsvcs.dll, MiniDump 712 …\dbg.dmp full` |
| `c999385b-…-60b7e0e72011` | 2026-03-04 19:17:01 | lsass access | `EventID 10`, `TargetImage=…\lsass.exe`, `GrantedAccess=0x1fffff` |
| `9f463c53-…-8e1b7c4f9a05` | 2026-03-04 20:23:00 | rclone | `rclone.exe copy …\f.7z remoto:respaldo --config …\rc.conf` |
| `2e7d6bad-…-1f5c8d3e6b72` | 2026-03-04 18:12:42 | schtasks | `schtasks /create /tn "\Microsoft\Windows\UpdateHelper" /tr …\AppData\…\svchost-update.exe /sc onlogon /rl highest /f` |

## Impacto

Cuatro técnicas del escenario 01 pasan de **cero a una detección cada una**, con cero falsos
positivos en el corpus sintético. El valor está en la correlación temprana: la persistencia
por tarea programada ocurre a las 18:12 y el volcado de credenciales a las 19:17, casi una
hora antes del borrado de instantáneas que dispara la alerta crítica a las 07:10 del día
siguiente.

## Limitaciones (no ocultar)

- La validación se hizo con lógica equivalente sobre JSONL, **no con `sigma-cli`**: el shell
  está denegado en el entorno donde se preparó esta contribución. Antes de fusionar hay que
  ejecutar `sigma check` / `sigma convert` en CI.
- El dataset es sintético: precisión del 100 % aquí **no garantiza** ausencia de falsos
  positivos en producción. Las reglas quedan en `experimental` y documentan sus FP conocidos.
- `GrantedAccess=0x1010` se incluye por ser el valor canónico de lectura de LSASS, aunque en
  este corpus solo aparece `0x1fffff`. Revisar en el entorno real.

## Reproducción

```bash
# 1) Validación sintáctica (pendiente de ejecutar en CI con shell disponible)
sigma check detection-as-code/sigma/windows/

# 2) Comprobación de coincidencias contra el dataset sintético
python - <<'PY'
import json
evs=[json.loads(l) for l in open("datasets/fuentes/sysmon/sysmon.jsonl") if l.strip()]
truth={r.split(",")[0] for r in open("datasets/soluciones/verdad-terreno.csv").read().splitlines()[1:] if r.strip()}
preds={
 "comsvcs": lambda e: e.get("Image","").lower().endswith("\\rundll32.exe")
      and "comsvcs.dll" in e.get("CommandLine","").lower()
      and "minidump" in e.get("CommandLine","").lower(),
 "rclone": lambda e: e.get("Image","").lower().endswith("\\rclone.exe")
      and any(x in e.get("CommandLine","").lower() for x in (" copy "," sync ")),
}
for name,p in preds.items():
    hits=[e for e in evs if p(e)]
    tp=sum(e["evento_id"] in truth for e in hits)
    print(name, "coincidencias:",len(hits), "TP:",tp, "FP:",len(hits)-tp)
PY
```
