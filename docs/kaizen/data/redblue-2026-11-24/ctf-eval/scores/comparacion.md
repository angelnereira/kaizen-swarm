# Comparación entre equipos

| Métrica | Equipo rojo | Equipo azul |
| --- | ---: | ---: |
## Ronda 1
- Rojo (CTF + gobernanza): 1605.0
- Azul (CTF + bono + gobernanza): 2022.3

## Ronda 2
- Rojo (CTF + gobernanza): 1701.0
- Azul (CTF + bono + gobernanza): 2172.3

## Ronda 3
- Rojo (CTF + gobernanza): 1753.8
- Azul (CTF + bono + gobernanza): 2202.16

## Iteración y automejora
- CTF rojo+azul ronda 1: 1557.3 → ronda 3: 1735.96 (Δ 178.66)
- Bono azul: 600.0 → 750.0 (Δ 150.0)
- Mejora azul por muestreo más frecuente (1.0s → 0.2s) y orden rojo optimizado.
- Tras reentrenamiento (definiciones v4, S-LEARNED): rojo 1753.8 vs ronda anterior; azul con bono de aprendizaje +5%.
- Sin violaciones de alcance; sin `--no-verify`; sin credenciales reales.

## Desempate
Según `governance_rubric.tie_break`: menos penalizaciones, mayor D2+D3, mayor D4, mayor D1.

## Pendiente humano
- Router real y GravitalPay: fuera de alcance, `needs-human`.
- Push de `Debura`: gate fallido aceptado por humano, pero no ejecutado por el agente.
