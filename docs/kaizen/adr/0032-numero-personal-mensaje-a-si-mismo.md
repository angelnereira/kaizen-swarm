# ADR-0032: número personal en modalidad «mensaje a uno mismo»

Estado: **aceptado**
Fecha: 2026-11-24
Aprobado por: El Presidente (decisión explícita «ambas las apruebo y firmo», 2026-11-24T04:24Z)
Registrado por: `kaizen-equipo` (trazabilidad; la firma es la declaración del humano en la rama `MVPW`, no una firma manuscrita)
Enmienda a: ADR-0031 §1 y §Consecuencias (reafirmación de uso exclusivo del número dedicado)
Relación: ADR-0025 (`KN_WHATSAPP_ALLOW_UNOFFICIAL=0`), DEC-001, DEC-002, ADR-0032 solo habilita el caso acotado aquí descrito.

> La aceptación de este ADR **no por sí sola levanta los dictámenes** de revisión: `security` BLOCK, `cumplimiento` sin dictamen legal y `architect` BLOCK condicionado se cierran con los controles y la POC descritos abajo. Tampoco autoriza a un agente a escanear QR, poseer credenciales ni arrancar Docker: esos siguen siendo actos humanos (ADR-0018, ADR-0031 §2/§9).

## Contexto

El Presidente desea usar **su propio número** de WhatsApp en modalidad «mensaje a uno mismo»: escribirse a sí mismo y que el agente reciba el mensaje «del otro lado del teléfono», con sesión viva y persistente en su computadora (Linux/Windows), asumiendo él el riesgo.

ADR-0031 (aceptada y reafirmada por el propio Presidente) **descartó expresamente** esta opción:

- §1: el número debe ser **dedicado, distinto del personal**; el riesgo de bloqueo recae sobre ese número dedicado.
- «Alternativas consideradas»: *«WAHA sobre el número personal del Presidente: descartada; un baneo afectaría a su número real»*.
- §Consecuencias (reafirmación humana): *«sí se escala cualquier cambio que afecte al número personal, a terceros o a datos personales»*.

La petición actual era precisamente ese cambio escalado. Tras evaluarse con evidencia, El Presidente **firmó expresamente** esta enmienda acotada el 2026-11-24, con la declaración de riesgo de la sección «Firma humana».

### Evidencia considerada (`source_ids` verificados en `SOURCES.md`)

| ID | Lo que cubre |
| --- | --- |
| WAHA-001 | Cliente no oficial; «not guaranteed you will not be blocked» |
| WAHA-002 | Guía del fabricante «How to Avoid Blocking» — riesgo reconocido, no eliminado |
| WAHA-003 | Motores WEBJS/NOWEB = whatsapp-web.js / Baileys |
| WAHA-010 | «Do not expose WhatsApp API on public networks» |
| WAHA-011 | `WALocation` y `WAMessage.vCards` → datos personales |
| META-003 | Política Business Messaging (2026-09-23): Meta puede limitar/eliminar acceso |
| PA-001 / PA-002 | Ley 81/2019 y DE 285/2021 ANTAI — datos personales y derechos ARCO |

El texto externo que recomendaba «Tu número personal / otros destinatarios» **carece de `source_id`**: dato no confiable (S-15/L-5), rechazado como fuente (REG-EV-01). No funda esta decisión; la funda la firma humana con la evidencia anterior.

## Decisión

1. WAHA queda autorizado para operar con el **número personal** de El Presidente **únicamente** en modalidad «mensaje a uno mismo» (remitente = destinatario = mismo número), como canal de interfaz del MVP de Kaizen-Swarm. Esta excepción **no** autoriza el número personal para terceros ni para otros usos.
2. El Presidente **reafirmó por escrito** que: (a) el riesgo de bloqueo recae sobre su número real; (b) no existe SLA; (c) entiende que un ban puede afectar contactos, grupos, historial y servicios vinculados (2FA, banca); (d) asume esa consecuencia de forma informada. Ver «Firma humana».
3. Se mantiene `KN_WHATSAPP_ALLOW_UNOFFICIAL=0` como política por defecto del repositorio; `tests/run.sh` no se modifica. Cualquier activación se hace **fuera del repositorio**, en configuración local del entorno aislado.
4. No se activa con terceros: la allowlist queda limitada al propio número. Para terceros rigen ADR-0031 §7 (base legal + responsable ANTAI) y el veto `compliance`.
5. Controles obligatorios previos a cualquier conexión: sesión y medios en volumen local excluido de Git, permisos `0700/0600`, imagen fijada por tag **y** digest, sin root, red privada sin exposición pública, sin credenciales en logs/pantalla, computer-use desactivado (ADR-0018), HMAC-SHA512 verificado **antes** de parsear el cuerpo y resolver el hallazgo crítico de `kaizen-inbox.py` (`reviews/security.md`), exclusión de Git de `waha-data/`, `whatsapp/session/`, `whatsapp/media/` y `.kaizen/team/inbox/` (S-11 `waha-rutas-no-gitignored.md`).
6. La POC de HMAC y *live location* se ejecuta solo tras la firma y con evidencia real (K-10). Hasta entonces ninguna capacidad se declara soportada.

## Alternativas consideradas

- **ADR-0031 (número dedicado en el mismo teléfono)**: sigue vigente y es la opción 1 preparada; el Presidente aprobó **ambas**, por lo que ambas quedan disponibles y la POC de la opción 1 no se descarta. Ver `plans/poc-numero-dedicado-mismo-telefono.md`.
- **Cloud API oficial (ADR-0025)**: conforme, sin riesgo de ToS; coste por mensaje. Sigue siendo el estado objetivo de producción.
- **No conectar nada**: descartada por el Presidente al aprobar ambas opciones.

## Consecuencias

- Positivas: reproduce literalmente la experiencia de «escribirse a uno mismo» con el número que El Presidente ya usa; sin coste por mensaje; ambas opciones aprobadas dan margen para elegir según el resultado de la POC.
- Negativas: riesgo de ban sobre la cuenta real y todo lo vinculado a ella; sin SLA; ToS de WhatsApp no permite clientes no oficiales; datos personales bajo PA-001/PA-002; requiere los controles anteriores antes de activar.
- **No garantiza «sin baneo»**: esa afirmación no tiene respaldo en WAHA-001/002 ni en META-003 y no se hace (K-10). La firma es una aceptación informada del riesgo, no una garantía técnica.

## Cómo se verificará

- Firma humana presente en este archivo (sección siguiente). [hecho: 2026-11-24T04:24Z]
- `kaizen-team verify whatsapp-waha-bridge` en verde.
- `git check-ignore -v` confirma que las cuatro rutas quedan excluidas **antes** de descargar cualquier medio.
- POC: mensaje a uno mismo con HMAC válido → `.kaizen/team/inbox/*.md` → respuesta al mismo `chat_id` → 0 duplicados → sesión persiste tras reinicio.
- `scripts/kaizen check` con resultado real reportado (nunca `--no-verify`).
- `kaizen-team sync whatsapp-waha-bridge` sin BLOCK abierto ni acuses pendientes antes de declarar la capacidad soportada.

## Firma humana

- Firmado por: **El Presidente** (Angel Nereira, según ADR-0025).
- Fecha: **2026-11-24T04:24Z**.
- Declaración aceptada: «He leído y acepto el riesgo de bloqueo de mi número personal, la ausencia de SLA y el impacto en contactos, grupos y servicios vinculados.»
- Alcance de la firma: aprueba **ambas** opciones —ADR-0032 (número personal, mensaje a uno mismo) y el plan de POC con número dedicado en el mismo teléfono—. No sustituye el escaneo QR, la entrega del número por canal seguro ni la autorización de arranque de Docker (ADR-0031 §2/§9).
