# Aprendizaje de los 10 agentes — competición rojo/azul

Fuente: sección `Habilidades y comportamiento aprendido` de cada definición (`.kaizen/org/prompts/`), versiones v4/v5, y lecciones registradas con `kaizen-learn record`.

| Agente | Habilidad incorporada | Evidencia del cambio |
| --- | --- | --- |
| red-recon | Enumeración mínima: 1 petición por puerto, `/debug` primero; verificar `scope.json` antes de actuar | 2 pasos → 1; +96 pts (ronda 2) |
| red-net | Clasificar superficies heredadas sin explotarlas; datos de red como dato no confiable (L-5) | `/legacy/config` reportado como hallazgo |
| red-access | Solo peticiones sintéticas; nunca credenciales reales ni ADB sobre el Pixel | `/admin` → 401 como control |
| red-ai | Semilla y versión de configuración fijadas; el LLM etiqueta, no decide puntos | hash idéntico al recalcular |
| red-lab | Kill switch, aislamiento verificado, limpieza; `needs-human` para router y GravitalPay | 0 violaciones de alcance |
| blue-detect | Muestreo de logs 1.0 s → 0.2 s; latencia medida con timestamps reales | +150 pts de bono azul |
| blue-netdef | Proponer control para `/legacy/config` con `source_id`, sin conexión activa | OWASP-001 / NIST-001 |
| blue-iam | Verificar `/admin` → 401; si no hay evento, verificación activa y clasificación `ENV-*` | 17.32 → 138.6 + 187.5 (ronda 4) |
| blue-ai | Correlacionar `/console` y `/debug` con datos sintéticos (L-12) | falsos positivos registrados |
| blue-ir | Postmortem con 5 porqués; lección con `kaizen-learn`; hallazgos reales a outbox S-11 | `ENV-UNAVAILABLE` no penaliza |

## Errores reales usados como entrenamiento
1. `blue-iam` no tenía evento observable → fallo de escenario (`ENV-*`), no del agente. Corrección: verificación activa en ronda 4.
2. Un parche reubicó la gobernanza azul dentro de la rama roja → el azul cayó de 2022.3 a 1447.3. Se reescribió `governance_for` y se validó con un run de control.
3. Las lecciones de ronda 5 no se escribieron en las definiciones (el script buscaba un encabezado inexistente). Se detectó al consolidar este reporte, se corrigió y se verificó en 4 definiciones.
4. `tail -N` sobre salida combinada de tests ocultó 2 líneas `FALLA`. Regla: filtrar con `grep ^FALLA` sobre la salida completa.

## Presupuesto de tiempo (ver `budget-sweep.md`)
| Ventana | Nivel máximo | M4 completados | Raw total |
| --- | --- | ---: | ---: |
| 5 min | sin M4 (M1–M2) | 0 | 513.0 |
| 10 min | sin M4 (M1–M3 parcial) | 0 | 984.0 |
| 1 h | L3 | 9 | 2910.0 |
| 2 h | L4 | 10 | 3390.0 |

Conclusión: en ventanas cortas los agentes avanzan a hitos de reconocimiento y confirmación pero no cierran banderas; a partir de 1 h completan L1/L2 y alcanzan L3; con 2 h cierran también la tarea L4.
