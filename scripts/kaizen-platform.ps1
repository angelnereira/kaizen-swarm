# kaizen-platform.ps1 — entrypoint multiplataforma para PowerShell en Windows.
# Uso: .\scripts\kaizen-platform.ps1 check | report | eval | gov | knowledge | incentive | meta | community | exporter
param(
  [Parameter(Position=0)] [string]$Command = "check",
  [Parameter(Position=1)] [string[]]$Args = @()
)

$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$env:KAZEN_ROOT = $Root

$Python = Get-Command python -ErrorAction SilentlyContinue
if (-not $Python) { $Python = Get-Command py -ErrorAction SilentlyContinue }
if (-not $Python) { Write-Error "Python no encontrado; instala Python 3.11+"; exit 1 }
$Py = $Python.Source

function Invoke-Py([string]$Script, [string[]]$Params) {
  & $Py (Join-Path $Root "scripts/$Script") @Params
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

switch ($Command.ToLower()) {
  "check"  { Invoke-Py "kaizen-platform" @("check") }
  "report" { Invoke-Py "kaizen-platform" @("report") }
  "json"   { Invoke-Py "kaizen-platform" @("json") }
  "eval"   { Invoke-Py "kaizen-eval" $Args }
  "gov"    { Invoke-Py "kaizen-gov" $Args }
  "knowledge" { Invoke-Py "kaizen-knowledge" $Args }
  "incentive" { Invoke-Py "kaizen-incentive" $Args }
  "meta"   { Invoke-Py "kaizen-meta" $Args }
  "community" { Invoke-Py "kaizen-community" $Args }
  "exporter" { Invoke-Py "kaizen-exporter.py" $Args }
  default {
    Write-Host "kaizen-platform <check|report|json|eval|gov|knowledge|incentive|meta|community|exporter>"
    Write-Host "Los scripts bash (kaizen-swarm, kaizen-team, kaizen-runtime) requieren Git Bash o WSL en Windows."
  }
}
