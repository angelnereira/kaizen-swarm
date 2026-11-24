# Comparación entre equipos

| Métrica | Equipo rojo | Equipo azul |
| --- | ---: | ---: |
## Ronda 1
- Rojo (CTF + gobernanza): 2325.0
- Azul (CTF + bono + gobernanza): 3450.0

## Ronda 2
- Rojo (CTF + gobernanza): 2493.0
- Azul (CTF + bono + gobernanza): 3450.0

## Ronda 3
- Rojo (CTF + gobernanza): 2585.4
- Azul (CTF + bono + gobernanza): 3543.75

## Ronda 4
- Rojo (CTF + gobernanza): 2585.4
- Azul (CTF + bono + gobernanza): 3873.0

## Ronda 5
- Rojo (CTF + gobernanza): 2605.4
- Azul (CTF + bono + gobernanza): 3973.0

## Iteración y automejora
- CTF rojo+azul ronda 1: 3555.0 → ronda 5: 4050.9 (Δ 495.9)
- Bono azul: 750.0 → 937.5 (Δ 187.5)
- Mejora azul por muestreo más frecuente (1.0s → 0.2s) y orden rojo optimizado.
- Tras reentrenamiento (definiciones v4, S-LEARNED): rojo 2605.4 vs ronda anterior; azul con bono de aprendizaje +5%.
- Sin violaciones de alcance; sin `--no-verify`; sin credenciales reales.

## Desempate
Según `governance_rubric.tie_break`: menos penalizaciones, mayor D2+D3, mayor D4, mayor D1.

## Pendiente humano
- Router real y GravitalPay: fuera de alcance, `needs-human`.
- Push de `Debura`: gate fallido aceptado por humano, pero no ejecutado por el agente.
