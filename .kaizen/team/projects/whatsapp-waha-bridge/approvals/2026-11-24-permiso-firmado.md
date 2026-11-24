id: AP-001
tipo: aprobacion_humana_explicita
fecha: 2026-11-24
firmado_por: El Presidente (dueño del repositorio y del proyecto)
declaracion: "procede te doy permiso explícito firmo el permiso"
correlation_id: whatsapp-waha-bridge
source_ids: [ADR-0031, DEC-001, DEC-002]
status: registrado
---
# AP-001 — Permiso explícito firmado

## Alcance autorizado
- Reparar el bug de `scripts/kaizen-tokens` / `.kaizen/finops/tokens.env` (ruta protegida L-4) — **ejecutado y verificado** (2026-11-24).
- Avanzar con toda la preparación de la Fase 1 que no requiera datos personales reales ni acciones físicas del propietario.
- Ejecutar POCs con **datos sintéticos** y fuentes documentadas (sin secretos reales, sin número real).

## NO autorizado por esta firma (requiere datos/acciones concretas aún no entregados)
- Número de WhatsApp dedicado: no fue proporcionado; no se inventa ni se versiona (S-1/S-2, OWNER.md §4).
- Escaneo del QR: acto físico humano (ADR-0018), sin credenciales en pantalla.
- Arranque del daemon Docker: el daemon sigue detenido; el ciclo concurrente del runtime está activo y no se interrumpe.
- Responsable ante ANTAI y base legal para terceros (C3/C4): dato humano no proporcionado; no se fabrica evidencia (K-10).
- Activación de `KN_WHATSAPP_ALLOW_UNOFFICIAL` en el repo: sigue en `0` (ADR-0031 §3).

## Evidencia de la firma
Declaración literal del dueño del repositorio en la sesión `evolutionW`, 2026-11-24. Se registra aquí con `correlation_id` y `source_ids` para trazabilidad (TEAM.md/COMUNICACION.md). No es un dictamen legal ni una dispensa de gates: ADR-0002/0003/0023 siguen vigentes.
