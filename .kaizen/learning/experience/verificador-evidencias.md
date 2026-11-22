# Experiencia acumulada: verificador-evidencias

Generado: 2026-11-22T12:44:44Z | Lecciones: 12

## Lecciones con mayor recurrencia
- Arquitectura emite BLOCK: aislamiento, profundidad constante, buzón no atómico y check no hermético (x1, failure): Convertir este hallazgo en control verificable y registrar lección.
- Cuatro fallos en el kaizen check inicial del proyecto de adopción (x1, failure): Consolidar los dictámenes de los seis especialistas y abrir decisión con fuentes ISO-001, NIST-001, AICPA-001 y OWASP-001. No avanzar mientras `scripts/kaizen
- DX emite BLOCK: instalación no ejecutable tal cual, exit codes rotos y buzón inactivo (x1, failure): R-01..R-08 en el entregable. Corregir exit codes, timeout/lock del check, activar el buzón, unificar el recuento y documentar rollback. Todo en rutas protegida
- Digests desactualizados frente al hash actual de SOURCES.md (x1, bug): Volver a ejecutar `kaizen-org feed` + `digest` para esos agentes y verificar con `verificador-evidencias`. No se hizo: ruta protegida (L-4), requiere ADR.
- Dos equipos del deploy paralelo agotaron el timeout (rc=124) (x1, failure): Revisar logs y relanzar esos equipos con timeout mayor o alcance más acotado. No se silencia (S-11).
- Los 6 equipos fallaron por agotamiento del limite gratuito de OpenCode (x1, failure): Decisión humana: conectar un proveedor de pago, suscribir OpenCode Go o cambiar de modelo. No se reintenta automáticamente para no gastar ni falsificar result
- No se pudo instalar reverse-api-engineer por cuota de disco agotada (x1, failure): Liberar cuota (por ejemplo `~/.npm` ocupa 921 MB), repetir `pip install --user reverse-api-engineer` o instalar en un venv con `python3-venv`, y ejecutar `npx s
- QA emite BLOCK: KPI no verificable, verify vacuo y artefactos no trackeados (x1, failure): Definir "check en verde" con timeout y fail-closed; añadir gate `n_decisiones >= 1` en `verify`; persistir y trackear artefactos en CI; política de datos sint
- Recuento de agentes inconsistente entre documentos (42/43/44) (x1, bug): Generar el recuento desde `registry.json` en un solo lugar y actualizar documentos derivados vía PR con ADR. Requiere decisión humana (rutas protegidas).
- Security emite BLOCK en adopcion-kaizen-opencode por evidencia no verificable y dos hallazgos medios (x1, security): Corregir el truncamiento y la redacción del ADR vía PR con ADR (rutas protegidas L-4); que `verificador-evidencias` y `qa` aporten la evidencia que seguridad 
- Verificador emite BLOCK: kaizen check en verde queda NO VERIFICADO (exit 143) (x1, failure): Obtener una ejecución aislada y hermética de `kaizen check` (sin checks concurrentes) antes de cualquier verificación. Requiere ADR (check hermético, ADR-00
- kaizen-team assign/handoff no escriben handoffs por uso de now en jq (x1, bug): Sustituir `now` por `$now` en ambas expresiones. NO parcheado: `scripts/kaizen*` es ruta protegida (L-4); requiere ADR y aprobación humana. Mientras tanto, los

## Cómo usarla
Antes de proponer, revisa estas lecciones. Si aplican, cita el fingerprint y evita repetir el error.
