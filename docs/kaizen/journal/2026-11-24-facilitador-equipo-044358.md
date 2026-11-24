# Diario — facilitador-equipo — 2026-11-24T04:43:58Z

## Tarea
Coordinar `equipo-central` y dejar lista la tarea pendiente «`scripts/kaizen check` en rojo por agente concurrente `marketing-visual` sin gobernanza», cerrando el KPI «una decisión verificada por ciclo».

## Decisión
Opción A (autoridad `resource`): asignar a `gerente` las 3 tareas sin dueño con plazo `2026-11-26T18:00:00Z`; handoffs con sobre completo; ack de recepción registrado; DEC-004 de proceso abierta, verificada y con memorial completo; escalar el ADR de catálogo/gobernanza a El Presidente. No se tocó el fondo (gobernanza/catálogo), no se movió la etapa (`intake`), no se levantó el BLOCK de `architect`, no se hicieron push ni PR.

## Evidencia (comandos y resultados reales)
- `scripts/kaizen check` → rc=1 (`FALLA: swarm`, `FALLA: organizacion`).
- `scripts/kaizen-org check` → rc=1, `catálogo desc.sincronizado (80 vs 81)`; `scripts/kaizen-gov check` → rc=0, verde; `scripts/kaizen-swarm check` → rc=1.
- `scripts/kaizen-team status|sync` → `intake`, decisiones verificadas=4/0 bloqueadas y 6 acuses pendientes.
- `scripts/kaizen-team decide … --sources PA-001,LOCAL-001,LOCAL-003,LOCAL-004` → DEC-004; `scripts/kaizen-team verify equipo-central` → rc=0, `status: verified`.
- `scripts/kaizen-team ack equipo-central H-20261124-004` → ack de recepción.
- `scripts/kaizen-meta drift` → rc=1, `TypeError` (fallo conocido `387791946`, ya reportado en outbox). `scripts/kaizen-meta close` → rc=1, `AttributeError: 'int' object has no attribute 'strip'` (misma causa raíz, extension agregada al outbox; además `close` queda `block` sin HEAD en `origin/main` ni release).
- `scripts/kaizen-team standup equipo-central` → rc=0 engañoso: no creó el archivo por falta de `standups/`; nuevo outbox `20261124-standup-sin-directorio`.
- Fuentes verificadas: PA-001, LOCAL-001, LOCAL-003, LOCAL-004. Guard ejecutado: `kaizen-learn known guard facilitador-equipo …` → 1 fallo recordado (`245293479`).

## Resultado
0 tareas sin dueño; handoff con ack (`H-20261124-004`); DEC-004 verificada con memorial completo (KPI cumplido); etapa `intake` sin saltos de puerta; tarea lista para `gerente` con ADR escalado. `kaizen check` sigue en rojo **a propósito**: el arreglo requiere ADR humano y no se falsea la puerta (S-10/K-10).

## Aprendizaje
Un escalado del outbox puede estar parcialmente desactualizado: verificar cada sub-check por separado antes de redactar la evidencia (`gov` pasó a verde; solo `org` sigue rojo). Aplicar fingerprints `2188522920`, `245293479`, `998952383` y `387791946`: no usar `assign`/`handoff` del tool, escribir sobres completos y confirmar con `jq` tras cada escritura. El ack se registra solo para el sobre que yo recibo; los acuses de otros roles no se fabrican (K-10). `cite-check` de DEC-004 → `citas válidas: 0`, rc=0: no se citan articulos normativos, solo `source_ids` como anclaje del ledger; la decision se apoya en comandos reproducibles. Además: no confiar en el rc de `kaizen-team standup` sin comprobar que el archivo existe.
