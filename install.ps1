# install.ps1 — instalador oficial de kaizen-swarm para Windows/PowerShell.
# Instala en la configuracion REAL de OpenCode del usuario (nunca en un scratch).
# Dry-run por defecto: usa -Yes para ejecutar. Sin secretos en el repo.
param(
  [string]$RepoUrl = "https://github.com/angelnereira/kaizen-swarm",
  [string]$InstallDir = "$env:LOCALAPPDATA\kaizen-swarm\repo",
  [switch]$Yes,
  [switch]$SkipWhatsApp
)

$ErrorActionPreference = "Stop"
function Step($n, $msg) { Write-Host "[$n/6] $msg" }
$Py = (Get-Command python -ErrorAction SilentlyContinue).Source
if (-not $Py) { $Py = (Get-Command py -ErrorAction SilentlyContinue).Source }
if (-not $Py) { Write-Error "Python 3.11+ requerido. Instalalo con: winget install Python.Python.3.11"; exit 1 }

$Steps = @(
  "Verificar Python, git, jq y OpenCode (rutas reales)",
  "Clonar/actualizar el framework en $InstallDir",
  "Instalar agentes en la configuracion REAL de OpenCode (~/.config/opencode/agents)",
  "Crear gobernanza global (~/.local/share/kaizen-swarm/framework) sin tocar tus repos",
  "Diagnosticar y reparar rutas tmp huerfanas (kaizen-doctor fix)",
  "Verificar gov/eval y preguntar el numero de WhatsApp (un solo chat)"
)

if (-not $Yes) {
  Write-Host "== kaizen-swarm installer (Windows) — DRY-RUN =="
  $i = 1; foreach ($s in $Steps) { Step $i $s; $i++ }
  Write-Host "`nPara instalar de verdad: .\install.ps1 -Yes"
  Write-Host "Los agentes se instalan en tu config real; NO se crea un directorio XDG temporal."
  exit 0
}

Step 1 "Verificar dependencias"
$gitBin = (Get-Command git -ErrorAction SilentlyContinue).Source
$jqBin = (Get-Command jq -ErrorAction SilentlyContinue).Source
$ocBin = (Get-Command opencode -ErrorAction SilentlyContinue).Source
Write-Host "  python=$Py"
Write-Host "  git=$gitBin"
Write-Host "  jq=$jqBin (si falta, los tests fallan: winget install jqlang.jq)"
Write-Host "  opencode=$ocBin"
if (-not $gitBin) { Write-Error "git requerido: winget install Git.Git"; exit 1 }
if (-not $ocBin) { Write-Error "OpenCode no esta en PATH. Instalalo desde https://opencode.ai y vuelve a ejecutar este instalador."; exit 1 }

Step 2 "Clonar/actualizar framework"
if (-not (Test-Path "$InstallDir\.git")) {
  New-Item -ItemType Directory -Force -Path (Split-Path $InstallDir) | Out-Null
  & git clone --depth 1 $RepoUrl $InstallDir
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
} else {
  & git -C $InstallDir pull --ff-only
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Push-Location $InstallDir
try {
  Step 3 "Instalar agentes en config real"
  & $Py scripts/kaizen-installer opencode --global
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  Step 4-6 "Doctor, verificacion y onboarding"
  & $Py scripts/kaizen-doctor fix
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $Py scripts/kaizen-gov check
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  & $Py scripts/kaizen-eval check | Select-Object -Last 2
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

  if (-not $SkipWhatsApp) {
    $owner = "$env:USERPROFILE\.config\kaizen-swarm\owner.env"
    if (-not (Test-Path $owner)) {
      Write-Host "`nUnico dato que necesitamos: tu numero de WhatsApp con codigo de pais."
      Write-Host "Se guarda localmente en modo 600; nunca se versiona ni se imprime."
      & bash scripts/kaizen-welcome setup
    }
  }
} finally { Pop-Location }

Write-Host "`n== Instalacion verificada =="
Write-Host "  Agentes en la config real de OpenCode (no en un scratch)."
Write-Host "  Gobernanza global creada; tus repositorios NO fueron modificados."
Write-Host "  Si algo falla: python scripts/kaizen-doctor check ; python scripts/kaizen-doctor fix"
