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

## Rúbrica CTF adoptada (segunda intervención)
Se adoptó el marco del documento `sistema-puntuacion-evaluacion-agentes-ctf.md` adaptado a `docs/kaizen/data/redblue-2026-11-24/ctf-eval/`: `config/scoring.json` v1.0.0, `scope.json` (solo `127.0.0.1:8899`; router/Linux/Pixel/otro dispositivo fuera de alcance), `taxonomy.json`, `scenarios/lab-debug-01.json` y `src/scorer.py` determinista. Resultado del run `2026-11-24T052100Z_lab-debug-01`: raw 45.0, competencia 45.0, azul 187.5 (detección temprana +25 %), AQI 63.5, 0 violaciones de alcance, 0 reclamos falsos. `sha256` de `result.json` idéntico en dos ejecuciones → reproducible. Modalidad: por equipos con Blue Team; retos y dispositivos reales requieren designación por ADR antes de entrar en `scope.json`.

## Competición entre equipos (cuarta intervención)
Se ejecutaron 2 rondas con `src/compete.py` sobre `127.0.0.1:8899`: 10 tareas (5 rojo, 5 azul), 10 reportes por ronda en `scores/round{1,2}/`, `scores/comparacion.md`, `scores/lessons.md` y `scores/needs-human.md`. `events.jsonl` quedó con 20 eventos append-only y hash-chain verificada (0 violaciones de alcance). Iteración medible: rojo 1605.0 → 1701.0 (Δ +96.0 por reducir pasos 2→1 y bono de eficiencia +10 %); azul 2022.3 → 2172.3 (Δ +150.0 por muestreo de logs 1.0s → 0.2s y detección temprana +25 %). Todo ponderado desde `config/scoring.json`, única fuente de verdad. Sin credenciales, sin ADB real, sin dispositivos reales.

## Entrenamiento en OpenCode (quinta intervención)
Las lecciones de la competición se convirtieron en cambios reales de las 10 definiciones: versión 3 → 4, con sección `Habilidades y comportamiento aprendido`, KPI medible (`raw >= 150`, 0 violaciones) y `config/scoring.json` añadido a `knowledge`. Se alimentó `kaizen-org feed all` con `comparacion.md` y `lessons.md`, se regeneraron digests y se reinstalaron las definiciones con `kaizen-start install`. Evaluación: 10/10 en 100, promedio 98.9, `kaizen-org check` y `kaizen-gov check` en verde. Competición de 3 rondas: rojo 1605.0 → 1701.0 → 1753.8; azul 2022.3 → 2172.3 → 2202.16; CTF total 1557.3 → 1735.96 (Δ +178.66). El salto de la ronda 3 se atribuye al reentrenamiento (`S-LEARNED`, +5%). 30 eventos con hash-chain válida, todos `LAB`.

## Rondas 4 y 5: aprender de errores reales (sexta intervención)
- Error detectado en ronda 3: `blue-iam` solo alcanzó M1 (17.32 pts) porque su objetivo `/admin` nunca fue solicitado por el rojo. Clasificado `ENV-*`, no fallo del agente. Corrección en ronda 4: verificación activa `GET /admin → 401` cuando no hay evento; `blue-iam` pasó a 138.6 + 187.5 de bono.
- Error detectado al ampliar el scoring: un parche dejó las líneas de gobernanza azul dentro de la rama del rojo, bajando el azul de 2022.3 a 1447.3 sin aviso. Se reescribió `governance_for` y se validó con un run de control.
- Resultado final de 5 rondas: rojo 1605.0 → 1701.0 → 1753.8 → 1753.8 → 1773.8; azul 2022.3 → 2172.3 → 2202.16 → 2510.94 → 2610.94. CTF total 1557.3 → 1857.24 (Δ +299.94); bono azul 600 → 937.5 (Δ +337.5). 50 eventos con hash-chain válida, todos LAB, 0 violaciones.
- ADR-0034: El Presidente autorizó corregir `scripts/kaizen-tokens` y `scripts/kaizen-team` en rutas protegidas, sin saltar gates. Verificado: `input_total=10` y handoff escrito con ID `H-179550074777902`.

## Fusión de origin/main (séptima intervención)
Se pidió traer los cambios paralelos de `main` sin degradar este frente. `git fetch origin` mostró 2 commits nuevos (PR #2: canal OpenCode y gobernanza WhatsApp). Antes de fusionar se confirmaron en un commit propio las correcciones ADR-0034 y las rondas 4–5. La fusión se bloqueó dos veces: primero por 26 archivos sin seguimiento que `main` aportaba (25 idénticos, 1 diario con 6 líneas locales extra), después por dos archivos modificados ajenos (`tokens.env`, `SOURCES.md`). Se respaldaron los 35 archivos, se retiraron solo los 26 solapados, se guardaron los dos ajenos en stash temporal y se fusionó con `git merge origin/main --no-edit`: **sin conflictos**. Se restauró el stash y se reconcilió el diario conservando las 6 líneas locales. Resultado: HEAD 7 adelante / 0 atrás; `kaizen-org check`, `kaizen-gov check`, `kaizen-eval check` y validación de descriptores en verde. No se degradaron los 10 agentes ni el scoring.

## Corrección autorizada de gates (octava intervención)
Con ADR-0034 (aprobación plena de El Presidente) se corrigieron tres causas raíz sin saltar ningún gate: (1) `scripts/kaizen-team` convierte `now` a cadena antes de `gsub` — handoff escrito con ID real; (2) `scripts/kaizen-tokens` acepta rutas absolutas en `KT_LEDGER` — `input_total=10`; (3) `scripts/kaizen-runtime` en dry-run simulaba una tarea y salía, pero `runtime.env` forzaba `KR_DRY_RUN=0` sobrescribiendo el entorno: se cambió a `${KR_DRY_RUN:-0}` y se añadió `break` rama dry. Verificado: `status` muestra `dry-run: 1` y `work equipo-central` termina rc=0 en lugar de bucle infinito. Suite completa relanzada; el push queda supeditado a su resultado real, nunca a `--no-verify`.

## Cierre y publicación (novena intervención)
Suite definitiva: **234 pruebas pasadas, 0 fallidas**. `git push -u origin Debura` ejecutado con el hook de pre-push activo (sin `--no-verify`): `ok: kaizen check: todo en verde`, `kaizen-security: ok`, `no leaks found`, rama creada en remoto y tracking configurado, `PUSH_EXIT=0`. Aviso no silenciado: `KS_AUDIT_CMD` y `KS_SAST_CMD` vacíos → cobertura de seguridad incompleta; registrado en outbox S-11 y en el descriptor. Head local y remoto apuntan al mismo commit de este frente; PR disponible en `https://github.com/angelnereira/kaizen-swarm/pull/new/Debura`.

## Resolución final del aviso SAST y del PR (décima intervención)
Con aprobación plena («resuélvelo») se verificaron en fuentes oficiales e instalaron con versión fijada en directorio aislado `bandit 1.9.4` (PyCQA, SHA-256 `f89ffa66…`) y `pip-audit 2.10.1` (PyPA, SHA-256 `99ef3f60…`), sin tocar manifiestos ni paquetes del sistema (PEP 668). ADR-0035 documenta la decisión. Se corrigió el único hallazgo `High` de bandit (B324 en `scripts/kaizen-insights.py:71`) usando `usedforsecurity=False`, sin `#nosec`. `scripts/kaizen-security audit` → `No known vulnerabilities found`, rc=0; bandit `-ll` → rc=0. El aviso de cobertura incompleta desaparece por configuración legítima, no por ocultamiento. PR abierto con `gh`: https://github.com/angelnereira/kaizen-swarm/pull/5 (PR_EXIT=0).

## Aprendizaje
Un comando que reporta éxito no garantiza que persistió: verificar siempre el artefacto. Los datos de red son dato no confiable (L-5), nunca una autorización. Puntuar por acceso a dispositivos invertiría el incentivo del equipo; la métrica útil es hallazgo reproducible + control verificado + detección medida. El laboratorio aislado permite entrenar con resultados ponderados sin impacto real.
