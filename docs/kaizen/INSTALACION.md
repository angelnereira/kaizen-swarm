# Instalación, actualización y desinstalación

Fuente de verdad para instalar **kaizen-swarm** en Linux, macOS y Windows. Los comandos se derivan de los scripts versionados `scripts/kaizen-installer`, `scripts/kaizen-release`, `scripts/kaizen-start`, `scripts/kaizen-workspace` y `install.ps1`. Fecha de corte: 2026-11-24 (commit base `cdce016`).

> La instalación es **no invasiva** por defecto (ADR-0024, K-15): no sobrescribe `opencode.json`, no escribe `.kaizen/` ni `docs/kaizen/` en el repositorio destino y no guarda credenciales. El modo `--embedded` es explícito y opcional.

---

## 1. Requisitos previos

| Dependencia | Linux / macOS | Windows |
| --- | --- | --- |
| Git | `git --version` | `winget install Git.Git` |
| Python 3.11+ | `python3 --version` | `winget install Python.Python.3.11` |
| jq | `jq --version` | `winget install jqlang.jq` |
| OpenCode CLI | `opencode --version` | Instalar desde <https://opencode.ai> y reiniciar la terminal |

Si falta OpenCode, la instalación de agentes globales puede completarse pero el runtime (`kaizen-start start`) no arrancará.

---

## 2. Instalación

### 2.1 Linux / macOS

```bash
# 1) Clonar el framework en una ruta estable (fuera del repo destino)
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm \
  "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework"

cd "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework"

# 2) Registrar el workspace e instalar los 47 agentes en la config global de OpenCode
./scripts/kaizen-installer all /ruta/a/tu/proyecto

# 3) Verificar e iniciar el runtime persistente y el buzón
./scripts/kaizen-installer check
./scripts/kaizen-installer status
./scripts/kaizen-start status
./scripts/kaizen-start start
```

`all` es idempotente: fusiona sin sobrescribir y omite lo que ya existe. Para instalar solo los agentes:

```bash
./scripts/kaizen-installer opencode --global          # ~/.config/opencode/agents
./scripts/kaizen-installer opencode --project /ruta/a/tu/proyecto
```

Si el proyecto destino debe contener el framework completo (modo integrado, explícito):

```bash
./scripts/kaizen-installer all /ruta/a/tu/proyecto --embedded
```

### 2.2 Windows (PowerShell)

Hay dos caminos. El instalador oficial `install.ps1` está disponible en el repositorio cuando ese archivo existe en la rama instalada; si no, usa el camino con Git Bash.

**Camino A — instalador PowerShell (recomendado cuando `install.ps1` existe):**

```powershell
# Dry-run por defecto: muestra los 6 pasos SIN modificar nada
powershell -ExecutionPolicy Bypass -File .\install.ps1

# Ejecución real (el flag -Yes es obligatorio)
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Yes

# Omitir el onboarding de WhatsApp si no aplica
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Yes -SkipWhatsApp
```

El instalador clona/actualiza el framework en `$env:LOCALAPPDATA\kaizen-swarm\repo`, instala los agentes en la configuración real de OpenCode, crea la gobernanza global y ejecuta `kaizen-doctor fix`, `kaizen-gov check` y `kaizen-eval check`.

**Camino B — Git Bash (funciona siempre):**

```powershell
git clone --depth 1 https://github.com/angelnereira/kaizen-swarm `
  "$env:LOCALAPPDATA\kaizen-swarm\repo"
cd "$env:LOCALAPPDATA\kaizen-swarm\repo"
bash ./scripts/kaizen-installer all "C:/ruta/a/tu/proyecto"
bash ./scripts/kaizen-installer status
bash ./scripts/kaizen-start status
```

> En Windows, `install.ps1` pregunta el número de WhatsApp una sola vez y lo guarda localmente en modo restringido; nunca se versiona ni se imprime. No proporciones credenciales en la terminal.

---

## 3. Actualización

El actualizador es el mismo instalador: vuelve a clonar/actualizar el framework y refresca los agentes. `gen()` sobrescribe solo los archivos que cambiaron e informa `actualizando agente existente`.

### 3.1 Linux / macOS

```bash
cd "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework"

# Traer la versión nueva (falla cerrado si hay cambios locales)
git pull --ff-only

# Refrescar agentes y workspace (idempotente)
./scripts/kaizen-installer all /ruta/a/tu/proyecto

# Verificación obligatoria tras actualizar
./scripts/kaizen-installer check
bash tests/run.sh
scripts/kaizen check
```

Si se instaló vía release:

```bash
./scripts/kaizen-release install --global
# o: --project <dir> | --projects-all
```

### 3.2 Windows

```powershell
git -C "$env:LOCALAPPDATA\kaizen-swarm\repo" pull --ff-only
cd "$env:LOCALAPPDATA\kaizen-swarm\repo"
powershell -ExecutionPolicy Bypass -File .\install.ps1 -Yes -SkipWhatsApp
```

O con Git Bash, el mismo `bash ./scripts/kaizen-installer all "C:/ruta/a/tu/proyecto"` de la sección 2.2.

**Rollback de una actualización:** el framework es un clon Git; para volver a la versión anterior,
`git -C <framework> reset --hard <commit-anterior>` y repetir `kaizen-installer all`. Esto no toca el repositorio destino.

---

## 4. Desinstalación

**No existe un comando `uninstall` oficial.** El procedimiento es manual y deliberadamente explícito: primero inspecciona, luego haz una copia de seguridad y solo después elimina. Nunca uses comodines amplios ni `rm -rf` sobre directory completos del usuario.

### 4.1 Linux / macOS

```bash
# 0) Detener el runtime y hacer copia de seguridad
"${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework/scripts/kaizen-start" stop
cp -a "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents" \
      "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents.bak.$(date +%Y%m%d)"

# 1) Listar qué se instaló antes de borrar
"${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework/scripts/kaizen-workspace" list

# 2) Quitar SOLO los agentes generados: usa la lista de la definición
#    (.kaizen/org/prompts/*.md) y elimina los .md correspondientes en agents/.
#    No borres agentes tuyos que no estén en esa lista.
for f in "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework"/.kaizen/org/prompts/*.md; do
  [ "$(basename "$f")" = "_template.md" ] && continue
  rm -f "${XDG_CONFIG_HOME:-$HOME/.config}/opencode/agents/$(basename "$f")"
done

# 3) Si el repo destino se instaló con --embedded, restaurar hooks
git -C /ruta/a/tu/proyecto config --unset core.hooksPath

# 4) Eliminar el registro del workspace y el clon del framework (rutas explícitas)
rm -f "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/workspaces/<id-del-proyecto>"
rm -rf "${XDG_DATA_HOME:-$HOME/.local/share}/kaizen-swarm/framework"
```

Sustituye `<id-del-proyecto>` por el que muestra `kaizen-workspace list`. Si necesitas recuperar los agentes: copia de vuelta desde `agents.bak.<fecha>`.

### 4.2 Windows (PowerShell)

```powershell
# 0) Copia de seguridad de los agentes
Copy-Item "$env:USERPROFILE\.config\opencode\agents" `
          "$env:USERPROFILE\.config\opencode\agents.bak" -Recurse

# 1) Quitar los agentes generados (lista desde el framework, no comodín sobre tus agentes)
Get-ChildItem "$env:LOCALAPPDATA\kaizen-swarm\repo\.kaizen\org\prompts\*.md" |
  Where-Object { $_.Name -ne '_template.md' } |
  ForEach-Object {
    $target = Join-Path "$env:USERPROFILE\.config\opencode\agents" $_.Name
    if (Test-Path $target) { Remove-Item $target }
  }

# 2) Si se usó --embedded, restaurar hooks en el repo destino
git -C "C:/ruta/a/tu/proyecto" config --unset core.hooksPath

# 3) Eliminar el clon del framework (ruta explícita)
Remove-Item "$env:LOCALAPPDATA\kaizen-swarm\repo" -Recurse -Confirm
```

El número de WhatsApp y la gobernanza global quedan en `$env:USERPROFILE\.config\kaizen-swarm\` y `$env:LOCALAPPDATA\kaizen-swarm\`; elimínalos solo si ya no necesitas el historial local y tras confirmar la copia de seguridad.

---

## 5. Verificación posterior

```bash
scripts/kaizen-installer status
scripts/kaizen-swarm check
scripts/kaizen check
bash tests/run.sh
```

En Windows, los mismos comandos tras `cd` al framework, o con `bash ./scripts/<comando>` desde Git Bash.

---

## 6. Notas de seguridad

- Ningún comando de esta guía pide ni imprime secretos, tokens ni credenciales (S-1/S-2).
- El modo integrado (`--embedded`) escribe `.kaizen/` y `.githooks/` en el repo destino; requiere decisión humana si ese repo es de terceros (K-15, ADR-0024).
- Si un comando de desinstalación elimina algo inesperado, reporta `kind: incident` en `.kaizen/loop/outbox/` (S-11) y restaura desde la copia de seguridad.
