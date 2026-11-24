kind: needs-human
agent: facilitador-equipo
created: 2026-11-24T05:25:00Z
correlation_id: seg-red-rojo-azul
---

# Escalado: router, umbral de KPI y bug del orquestador

## Disparador
Ejercicio rojo/azul autorizado sobre activos propios. Propiedad del router confirmada por El Presidente; alcance «amplio» solicitado.

## Evidencia
- Router `192.168.0.1`: `:80`, UPnP `:5000` con divulgación de versión (`04-servicios.txt:19`). No se intentaron credenciales ni login.
- GravitalPay en `*:8080/8081` con CSP permisiva (`01-baseline.txt:51-52`, `04-servicios.txt:26,41`).
- KPI sin umbral → dictamen azul `CHANGES_REQUESTED`.
- `scripts/kaizen-team handoff` no persiste mensajes (jq `gsub` sobre `now` numérico); ruta protegida L-4. Outbox: `kaizen-team-handoff-jq-numero-gsub.md`.

## Decisiones requeridas de El Presidente
1. **ADR de cambio de router**: ventana, alcance exacto, responsable y rollback. Sin ADR no se administra el dispositivo.
2. **Umbral del KPI de detección**: objetivo, ventana y tasa de falsos positivos para cerrar `verify`.
3. **ADR para corregir `scripts/kaizen-team`** (ruta protegida): `(now|tostring|gsub(...))` y fallo cerrado si no persiste.
4. **Responsable de red** para revisar UPnP y el enlazado global de 8080/8081.

## Opciones y KPI
- Opción recomendada: mantener todo el ejercicio en laboratorio sintético; cambios en red real solo con ADR y humano presente. KPI: 100% de hallazgos con evidencia y outbox; 0 accesos a dispositivos reales; 0 secretos.
- Opción rechazada: puntuar por número de dispositivos accesados o control obtenido. Incentiva intrusión y viola L-3/S-1/S-2.

## Quinto escalado: push bloqueado por gate
`git push -u origin Debura` falló: el hook de pre-push ejecuta `kaizen check`, que está en rojo por tests (`FALLA ledger tokens`, `FALLA work continuo` y dos fallas más truncadas en la salida). Causa raíz de `ledger tokens`: el test clona desde `HEAD`, donde `scripts/kaizen-tokens` sigue con el bug de ruta absoluta para `KT_LEDGER`; el fix existe sin confirmar en el árbol de trabajo, pero `scripts/kaizen*` es ruta protegida (L-4). No se usó `--no-verify` ni se rodeó el hook (S-10/K-10). Se requiere ADR humano para corregir el script protegido o aceptar la excepción y ejecutar el push.

## Siguiente paso
El gerente registra el escalado y asigna. El agente no ejecuta cambios de red ni modifica rutas protegidas (ADR-0002/0003, ADR-0023).
