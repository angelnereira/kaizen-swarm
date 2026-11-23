# install.ps1 — instalador definitivo de kaizen-swarm para Windows/PowerShell.
# Comportamiento equivalente al instalador de Linux/WSL. Sin secretos. Dry-run por defecto.
param(
  [string]$RepoUrl = "https://github.com/angelnereira/kaizen-swarm",
  [string]$InstallDir = "$env:LOCALAPPDATA\kaizen-swarm",
  [switch]$Yes
)

$ErrorActionPreference = "Stop"
Write-Host "== kaizen-swarm installer (Windows) =="

$Python = Get-Command python -ErrorAction SilentlyContinue
if (-not $Python) { $Python = Get-Command py -ErrorAction SilentlyContinue }
if (-not $Python) { Write-Error "Python 3.11+ requerido"; exit 1 }
$Py = $Python.Source
Write-Host "Python: $Py"

$Commands = @(
  "git clone --depth 1 $RepoUrl `"$InstallDir`"",
  "cd `"$InstallDir`"; python scripts/kaizen-installer opencode --global",
  "cd `"$InstallDir`"; python scripts/kaizen-platform check",
  "cd `"$InstallDir`"; python scripts/kaizen-gov check",
  "cd `"$InstallDir`"; python scripts/kaizen-eval check"
)

if (-not $Yes) {
  Write-Host "MODO DRY-RUN (usa -Yes para ejecutar):"
  $Commands | ForEach-Object { Write-Host "  $_" }
  Write-Host "Verificacion equivalente a Linux/WSL: kaizen-platform check reporta runtime=powershell."
  exit 0
}

if (-not (Test-Path "$InstallDir\.git")) {
  & git clone --depth 1 $RepoUrl $InstallDir
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
  & git -C $InstallDir pull --ff-only
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Push-Location $InstallDir
try {
  & $Py scripts/kaizen-installer opencode --global
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $Py scripts/kaizen-platform check
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $Py scripts/kaizen-gov check
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $Py scripts/kaizen-eval check
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} finally { Pop-Location }

Write-Host "Instalacion verificada. Los agentes viven en ~/.config/opencode/agents (no invaden el repo destino)."
