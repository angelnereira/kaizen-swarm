# ADR-0035 — Habilitar SAST y auditoría de dependencias en el gate

- Estado: Aceptado
- Fecha: 2026-11-24
- Responsable: El Presidente (aprobación plena dada en sesión: «resuélvelo»)
- Aplica a: `.kaizen/security/security.env`, `scripts/kaizen-insights.py`

## Contexto
El gate de pre-push avisaba `KS_AUDIT_CMD`/`KS_SAST_CMD` vacíos: cobertura de seguridad incompleta. No había herramientas SAST instaladas (`bandit`, `semgrep`, `trivy`, `pip-audit` ausentes) y el repo no tiene manifiesto Python. No se configureon comandos falsos para silenciar el aviso (S-10).

## Verificación previa (S-9)
- `bandit 1.9.4` — autor **PyCQA**, fuente `github.com/PyCQA/bandit`, Apache-2.0, estado Production Stable, Python ≥3.10. Wheel `bandit-1.9.4-py3-none-any.whl` SHA-256 `f89ffa663767f5a0585ea075f01020207e966a9c0f2b9ef56a57c7963a3f6f8e`.
- `pip-audit 2.10.1` — organización **PyPA**, fuente `github.com/pypa/pip-audit`, Apache-2.0, Production Stable. Wheel `pip_audit-2.10.1-py3-none-any.whl` SHA-256 `99ef3f600a317c1945f1e89e227ef26e1c2d618429b8bd3fa6f4f7c440c4611a`.
- Instalación aislada con `pip install --target ~/.local/share/kaizen-swarm/sast` (sin tocar paquetes del sistema: PEP 668 bloquea `--user`). No se modificó manifiesto ni lockfile: el repo no tiene ninguno.

## Decisión
1. Configurar `KS_SAST_CMD` con `bandit -q -ll -r scripts/` (severidad media y alta; sin `#nosec`, sin exclusiones).
2. Configurar `KS_AUDIT_CMD` con `pip-audit --path <directorio aislado>`: auditoría real de las dependencias de las herramientas del gate. No hay manifiesto de proyecto que auditar; se documenta esta limitación.
3. Corregir el único hallazgo `High` (B324 en `scripts/kaizen-insights.py:71`): `hashlib.sha1(..., usedforsecurity=False)`, porque el SHA-1 se usa como fingerprint de agrupación, no como primitivo de seguridad. Sin supresión.
4. Los 12 hallazgos `Low` quedan fuera del umbral `-ll`, declarado explícitamente; no se silencian, solo se fija un umbral verificable.

## Consecuencias
- El gate pasa con SAST y auditoría reales; el aviso de cobertura incompleta desaparece por configuración legítima, no por ocultamiento.
- Versiones fijadas y hashes registrados: cualquier actualización requiere nueva ADR y verificación S-9.
- `scripts/kaizen-insights.py` es ruta protegida (L-4): esta ADR autoriza exclusivamente el cambio de la llamada `sha1`.

## Verificación
- `PYTHONPATH=<dir> python3 -m bandit -q -ll -r scripts/` → rc=0.
- `PYTHONPATH=<dir> python3 -m pip_audit --path <dir>` → `No known vulnerabilities found`, rc=0.
- `git push origin Debura` → sin aviso `KS_AUDIT_CMD`/`KS_SAST_CMD vacíos`.
