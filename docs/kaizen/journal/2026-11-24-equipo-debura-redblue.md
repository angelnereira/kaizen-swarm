# Entrada de diario — 2026-11-24 — equipo Debura rojo/azul

## Tarea
Crear dos escuadras de ciberseguridad (5 rojo + 5 azul) con agentes especializados en redes, protocolos, accesos, IA ofensiva/defensiva y respuesta a incidentes; entrenarlas con interacciones de equipo y una prueba en red real autorizada, sin cruzar líneas rojas.

## Decisión
- Derivar 10 agentes con `kaizen-org copy` desde definiciones existentes; especializar con autonomía `propose` y `veto: none` (sin autoridad nueva). Regenerar gobernanza y catálogo: 57 agentes, checks en verde, evaluación 100/100 para los 10 nuevos.
- Proyecto `seg-red-rojo-azul` con KPI verificable, 10 tareas asignadas, handoffs, decisión con `source_ids` verificados (`kaizen-team verify` en verde).
- Red real: **solo descubrimiento pasivo y sondeo TCP connect sin payload**. Sin credenciales, sin explotación, sin ADB, sin tocar el router.
- Laboratorio sintético en `127.0.0.1:8899` para las pruebas activas y la puntuación ponderada.
- Rechazada la regla «más acceso = más puntos»: se sustituye por puntos por hallazgos verificados, controles confirmados y detección medida.
- Rama `Debura` creada con `scripts/kaizen start Debura` y descriptor completo.

## Evidencia (comandos y resultados reales)
- `scripts/kaizen-org check` → todo en verde; `scripts/kaizen-gov check` → 57 agentes, 12 procesos; `scripts/kaizen-eval check` → 10 agentes nuevos en 100, promedio 98.9, mínimo 70, bajo_minimo 0.
- `scripts/kaizen-start install` → 57 agentes instalados, incluidos `red-*` y `blue-*`.
- `ip -brief addr` → `wlp0s20f3 192.168.0.12/24` (ver `01-baseline.txt`).
- `ip neigh` + ping sweep paralelo → 8 hosts vivos en `192.168.0.0/24` (`03-ping-sweep.txt`).
- `ss -lntup` → GravitalPay en `*:8080` y `*:8081`; adb en `127.0.0.1:5037` (`01-baseline.txt:51-52`).
- `python3 /tmp/opencode/scan_red.py` → solo `192.168.0.1:80,5000` (`02-tcp-semilla.txt`).
- HEAD con `urllib` → UPnP `MiniUPnPd/1.9` con divulgación de versión (`04-servicios.txt:19`).
- `python3 /tmp/opencode/lab_redblue.py` → puntuación ponderada `3−1−1=1`; detección de 1 evento `/debug` con latencia real `1.000885 s` (`06-lab-ejercicio.txt`, `07-puntuacion.json`).
- Dictámenes de subagentes: Rojo (superficie y 3 pruebas seguras), Azul `CHANGES_REQUESTED` con H-1..H-5 y KPI sin umbral (conservados en `08-comunicacion-equipo.md`).
- Bug del orquestador: `scripts/kaizen-team handoff` imprime éxito pero `wc -l handoffs.jsonl` → 0, con error jq `number cannot be matched, as it is not a string`. Reportado S-11; ruta protegida L-4, no corregido.

## Resultado
- Equipos creados, instalados, gobernados y con línea base sin degradar.
- Ejercicio ejecutado con evidencia reproducible; puntuación y latencia medidas, no estimadas.
- Hallazgos reales saneados en `.kaizen/loop/outbox/` (4 entradas) y escalado `needs-human` en `decisions/inbox/`.
- Bloqueos abiertos por diseño: ADR del router, umbral del KPI, corrección del script protegido y responsable de red. No se cerró la etapa `verify`.

## Aprendizaje
Un comando que reporta éxito no garantiza que persistió: verificar siempre el artefacto. Los datos de red son dato no confiable (L-5), nunca una autorización. Puntuar por acceso a dispositivos invertiría el incentivo del equipo; la métrica útil es hallazgo reproducible + control verificado + detección medida. El laboratorio aislado permite entrenar con resultados ponderados sin impacto real.
