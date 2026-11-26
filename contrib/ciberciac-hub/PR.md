# PR (borrador) — Añadir 4 detecciones Sigma de alta fidelidad para el escenario 01

**Título:** `Añadir detecciones Sigma para LSASS, rclone y persistencia por tarea programada`

**Destino:** `ciberciac/CIAC-LATAM-COMMUNITY-HUB` → `main`
**Rama propuesta:** `kaizen/detecciones-escenario-01`
**Licencia:** las reglas se publican bajo DRL 1.1, igual que el resto de `detection-as-code`.

## Cuerpo

### Observación

El hub contiene 1 535 eventos maliciosos etiquetados en `verdad-terreno.csv`, pero una sola
regla Sigma (`proc_creation_win_vssadmin_borrado_shadow.yml`, T1490). Tres técnicas del
escenario 01 —volcado de LSASS, exfiltración con `rclone` y persistencia por tarea
programada— no tenían detección versionada.

### Evidencia

Cada regla nueva se probó contra `datasets/fuentes/sysmon/sysmon.jsonl` y se contrastó por
`evento_id` con la verdad de terreno:

| Regla | Técnica | Coincidencias | TP | FP |
| --- | --- | --- | --- | --- |
| `proc_creation_win_comsvcs_lsass_dump` | T1003.001 | 1 | 1 | 0 |
| `proc_access_win_lsass_suspicious_access` | T1003.001 | 1 | 1 | 0 |
| `proc_creation_win_rclone_exfiltration` | T1567.002 | 1 | 1 | 0 |
| `proc_creation_win_schtasks_suspicious_persistence` | T1053.005 | 1 | 1 | 0 |

Detalle reproducible en `VALIDACION.md` (adjunto a esta contribución).

### Impacto

- Cobertura del escenario 01: de 1 a 5 reglas Sigma para técnicas distintas.
- Detección más temprana: la persistencia se detecta a las 18:12 UTC y el robo de
  credenciales a las 19:17 UTC, frente a la alerta de impacto de las 07:10 UTC del día
  siguiente.
- Cero falsos positivos en el corpus sintético; falsos positivos conocidos documentados en
  cada regla y estado `experimental`.

### Propuesta

Fusionar cuatro archivos YAML en `detection-as-code/sigma/windows/`, sin tocar reglas
existentes ni rutas protegidas. Cambio aditivo y reversible (basta revertir los cuatro
archivos).

### Pregunta

¿Aceptan el enfoque de dos reglas complementarias para T1003.001 (herramienta + acceso al
proceso), o prefieren una sola regla correlacionada?¿Quieren que añada también las versiones
KQL/XQL en el mismo PR?

### Antes de fusionar

- Ejecutar `sigma check` en CI (no disponible en el entorno de preparación; ver
  `VALIDACION.md` → Limitaciones).
- Validar `GrantedAccess=0x1010` en telemetría real.
