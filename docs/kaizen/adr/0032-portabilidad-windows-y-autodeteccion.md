# ADR-0032: portabilidad Windows y autodetección de plataforma

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
El framework se ejecutó y diseñó en Linux, pero el usuario requiere que los agentes funcionen igual en una máquina Windows con PowerShell, sin asumir el sistema operativo.

## Decisión
1. `scripts/kaizen-platform` (Python) detecta `system`, `release`, WSL, presencia de `bash`, `powershell` y `python3`, y selecciona runtime: `bash` en Linux/WSL/macOS, `powershell` en Windows. Nunca asume Linux (K-10).
2. Los CLIs de lógica pura son Python y por ello multiplataforma: `kaizen-eval`, `kaizen-gov`, `kaizen-knowledge`, `kaizen-incentive`, `kaizen-meta`, `kaizen-community`, `kaizen-platform`, `kaizen-exporter.py`.
3. `scripts/kaizen-platform.ps1` es el entrypoint en Windows: localiza Python, fija `KAZEN_ROOT` y delega a esos CLIs. Reporta explícitamente que los scripts bash requieren Git Bash o WSL.
4. `docs/kaizen/org/PLATAFORMAS.md` documenta la matriz de comandos y la regla de verificación.
5. Equipo `portabilidad-windows` para validar detección, entrypoint PowerShell y paridad de comportamiento.

## Alternativas consideradas
- Reescribir todos los scripts bash en PowerShell: descartado; duplicaría lógica y rompería la fuente única.
- Asumir WSL en Windows: descartado; no siempre está instalado.

## Consecuencias
- Positivas: comportamiento consistente y detección honesta del entorno.
- Negativas: en Windows sin Git Bash/WSL, los comandos bash no están disponibles; se reporta, no se oculta.

## Cómo se verificará
- `kaizen-platform check|json` en Linux y Windows; `kaizen-platform.ps1 check` en PowerShell.
- `bash tests/run.sh` valida el detector y la matriz documentada.
