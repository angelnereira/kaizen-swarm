# Dictamen de seguridad — Escenario 05

Agente: `security`. Fecha: 2026-11-26. Canal: `review`.

**Voto: APPROVE** (con condiciones)

## Observación

Tres reglas Sigma nuevas para el escenario 05, con precisión 100 % y FP=0 sobre el corpus
sintético, y una línea base que falla el gate (0.839) como prueba de regresión (L-6).

## Evidencia

- `resultados.md`: salida real de `python3 validar.py` → `RESULTADO: PASS`.
- Coincidencias: 380 + 95 + 359 = 834 de 838 eventos maliciosos (cobertura 0.995).
- Hash de los datos de prueba verificado por `verificador-evidencias`.
- `kaizen check`, `kaizen-team check`, `kaizen-gov check`, `kaizen-swarm check` y
  `kaizen-org check`: todos en verde.

## Impacto

El equipo tiene una medición reproducible de detección temprana: 08:40:00 UTC frente a
08:57:45 UTC del primer beacon de minería.

## Condiciones (bloqueantes para producción)

1. Las reglas permanecen en `experimental`. **No** aplicar en producción sin validación en
   telemetría real: el 100 % de precisión es sobre datos sintéticos.
2. `puerto_destino: 3333` y `duracion_s: 300` son indicadores débiles fuera del laboratorio;
   documentados como falsos positivos conocidos en cada regla.
3. Prohibido contactar `192.0.2.50` o `203.0.113.90`: son rangos de documentación y el ejercicio
   es solo lectura (S-15/L-4).
4. Ningún hallazgo se reporta como incidente real (K-10).

## Disidencia

Sin objeciones abiertas. `qa` conserva veto funcional si la prueba de regresión deja de fallar
en la línea base en una corrida futura.
