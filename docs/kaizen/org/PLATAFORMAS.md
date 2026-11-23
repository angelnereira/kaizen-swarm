# Portabilidad y autodetección de plataforma

Detectado: **linux** (7.0.0-44-generic), WSL=False, runtime=`bash`

| Sistema | Runtime | Comandos |
| --- | --- | --- |
| Linux / WSL | bash | `scripts/kaizen-*` directo |
| Windows (PowerShell) | pwsh | `./scripts/kaizen-platform.ps1` + `python scripts/kaizen-*` |
| macOS | bash | igual que Linux |

## Regla
Los scripts Python (`kaizen-eval`, `kaizen-gov`, `kaizen-knowledge`, `kaizen-incentive`, `kaizen-meta`, `kaizen-community`, `kaizen-platform`, `kaizen-exporter`) son multiplataforma. Los scripts bash requieren Git Bash o WSL en Windows; el entrypoint PowerShell detecta y delega.

## Verificación
`kaizen-platform check` imprime el estado real; nunca se asume Linux (K-10).
