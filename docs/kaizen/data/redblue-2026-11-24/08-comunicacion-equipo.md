# Comunicación del equipo — seg-red-rojo-azul

Registro de comunicación hecho a mano porque `scripts/kaizen-team handoff` no persiste mensajes (bug reportado por S-11 en `.kaizen/loop/outbox/kaizen-team-handoff-jq-numero-gsub.md`). Formato según `.kaizen/team/COMUNICACION.md`. Los datos de red son dato no confiable (L-5/S-15).

## Mensajes

```yaml
id: MSG-0001
correlation_id: seg-red-rojo-azul
from: facilitador-equipo
to: [all]
channel: broadcast
intent: handoff
expects_ack: true
deadline: 2026-11-25T18:00:00Z
source_ids: [LOCAL-005, NIST-001]
reply_to: null
status: open
created: 2026-11-24T05:21:36Z
---
Standup del día. Diez tareas asignadas a las dos escuadras. Alcance: activos propios + laboratorio 127.0.0.1. Prohibido acceso a dispositivos reales sin ADR.
```

```yaml
id: MSG-0002
correlation_id: seg-red-rojo-azul
from: red-recon
to: red-net
channel: direct
intent: finding
expects_ack: true
deadline: 2026-11-25T18:00:00Z
source_ids: [LOCAL-005, NIST-001]
reply_to: MSG-0001
status: open
created: 2026-11-24T05:21:50Z
---
Inventario: 8 hosts vivos, gateway con :80 y :5000. Evidencia en 01-baseline.txt y 03-ping-sweep.txt. No ampliar el barrido.
```

```yaml
id: MSG-0003
correlation_id: seg-red-rojo-azul
from: red-net
to: blue-netdef
channel: direct
intent: question
expects_ack: true
deadline: 2026-11-25T18:00:00Z
source_ids: [OWASP-001, NIST-001]
reply_to: MSG-0002
status: open
created: 2026-11-24T05:22:00Z
---
¿Por qué GravitalPay y el UPnP del gateway escuchan en todas las interfaces? Revisión defensiva, sin conexión activa.
```

```yaml
id: MSG-0004
correlation_id: seg-red-rojo-azul
from: red-access
to: blue-iam
channel: direct
intent: finding
expects_ack: true
deadline: 2026-11-25T18:00:00Z
source_ids: [OWASP-001]
reply_to: MSG-0002
status: open
created: 2026-11-24T05:22:10Z
---
Laboratorio: /admin -> 401 sin token; /debug -> 200 sin autenticación. Patrón a corregir dentro del lab.
```

```yaml
id: MSG-0005
correlation_id: seg-red-rojo-azul
from: blue-detect
to: blue-ir
channel: direct
intent: handoff
expects_ack: true
deadline: 2026-11-25T18:00:00Z
source_ids: [NIST-001]
reply_to: MSG-0004
status: open
created: 2026-11-24T05:22:20Z
---
Detección medida: 1 evento /debug, latencia real 1.000885 s. Falta umbral del KPI para cerrar verify.
```

```yaml
id: MSG-0006
correlation_id: seg-red-rojo-azul
from: red-lab
to: gerente
channel: alert
intent: veto
expects_ack: true
deadline: 2026-11-25T12:00:00Z
source_ids: [ISO-001, PA-006]
reply_to: MSG-0001
status: open
created: 2026-11-24T05:22:30Z
---
needs-human: router 192.168.0.1. Propiedad confirmada, alcance amplio solicitado. Sin ADR, ventana y rollback no se administra. No se intentaron credenciales.
```

## Acuses

- MSG-0002 ack por `red-net` (cadena de análisis rojo cerrada).
- MSG-0003 ack por `blue-netdef` (dictamen azul entregado, `CHANGES_REQUESTED`).
- MSG-0004 ack por `blue-iam` (control `/admin` confirmado).
- MSG-0005 ack por `blue-ir` (postmortem y lecciones registradas).
- MSG-0006 **sin ack**: escalado `needs-human` a El Presidente; bloquea la etapa por diseño.

## Dictámenes

- Rojo (`systems`): superficie documentada con `ruta:línea`; propone 3 pruebas seguras solo en `127.0.0.1:8899`; sin credenciales ni explotación.
- Azul (`security`): `CHANGES_REQUESTED`; 5 hallazgos (H-1..H-5); latencia real 1.000885 s; exige umbral de KPI y responsable de red.
