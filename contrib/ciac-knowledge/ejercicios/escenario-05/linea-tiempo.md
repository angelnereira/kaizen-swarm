# Línea de tiempo — Escenario 05 (fuerza bruta SSH + minería)

Fuente: `datasets/soluciones/verdad-terreno.csv` (CIAC-011, **datos sintéticos**). Horas en UTC, 2026-03-02.

| Hora UTC | Fuente | Hallazgo | ATT&CK |
| --- | --- | --- | --- |
| 08:40:00 | linux-auth / firewall | Primer `Failed password` desde 192.0.2.50; regla `Internet-a-DMZ-ssh-temporal` permite SSH entrante | T1110.001 |
| 08:40:00 – 08:52:38 | linux-auth | 380 intentos fallidos, uno cada 2 s, contra `admin` y `root` | T1110.001 |
| 08:52:45 | linux-auth | Acceso exitoso con contraseña de la cuenta `deploy` | T1078.003 |
| 08:54:45 | linux-auth | Descarga del minero de criptomonedas | T1105 |
| 08:55:15 | linux-auth | Permisos de ejecución al binario | T1222.002 |
| 08:55:45 | linux-auth | Persistencia con `cron` | T1053.003 |
| 08:57:45 – 17:57:45 | firewall | 359 conexiones cada 5 min desde `lnx-web02` (DMZ) a `203.0.113.90:3333`, duración 300 s | T1496 |

## Punto de corte

La primera detección disponible es el `Failed password` a las **08:40:00 UTC**. Habría cortado la
cadena **12 min 45 s antes** del acceso exitoso y **17 min 45 s antes** de la primera conexión
al pool de minería. La regla de firewall `SSH INTERNET→DMZ:22` detecta el mismo minuto.
La detección de minería, en cambio, solo aparece a las 08:57:45.

## Nota de alcance

Ninguno de estos eventos ocurrió realmente: son registros ficticios generados con semilla fija.
La línea de tiempo sirve para entrenar correlación y medir detecciones, no para reportar un
incidente (K-10).
