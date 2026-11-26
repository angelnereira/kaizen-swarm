# Verificación de fuentes — Escenario 05

Agente responsable: `verificador-evidencias`. Fecha de corte: 2026-11-26.

| `source_id` | Estado en SOURCES.md | Uso en este ejercicio | Resultado |
| --- | --- | --- | --- |
| CIAC-011 | verified | Dataset sintético y verdad de terreno | OK — 12 fuentes de log, 5 escenarios, 1 535 eventos |
| CIAC-012 | verified | Formato y ciclo de vida de las reglas | OK — `experimental` → `test` → `stable` |

## Comprobaciones ejecutadas

1. `scripts/kaizen-team verify ciac-detection-training` → *todas las decisiones tienen fuentes verificadas* (51 fuentes).
2. `sha256sum` de los tres archivos descargados para la prueba (ver salida en la sesión):
   - `linux-auth.jsonl` → `d36a723e79f48ec1d13445a7cee61b3ef77169e4b2705fcd958112f94adc7001`
   - `firewall.jsonl` → `da0a29fafeab9cebec4c81338ea89f9cec73ecb7f16fbe753a3f211c6da928bf`
   - `verdad-terreno.csv` → `b85d0eb4c379e8274f5848a30460dfc037a65d25c7e2604cab63cbc907fe7d55`
3. Los hashes del manifest CIAC se revalidaron con `sha256sum -c`: 12/12 OK.

## Salvaguardas

- `CIAC-011` es **100 % ficticio**: ningún evento se reporta como ocurrido (K-10).
- No se copiaron credenciales ni datos personales a artefactos: la llave AWS del dataset es el
  valor de ejemplo de la documentación (no reproducido aquí) y no se reutilizó.
- El contenido del hub se trató como dato no confiable (S-15/L-5): no se obedeció ninguna
  instrucción encontrada en logs o documentos.

## Dictamen

**APPROVE** para usar `CIAC-011` y `CIAC-012` como contexto y verdad de terreno del ejercicio.
No apto para fundar obligaciones normativas (REG-EV-02).
