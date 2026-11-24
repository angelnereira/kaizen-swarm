# Revisión de red pendiente de humano — 2026-11-24

Hallazgos del barrido pasivo. No se probó autenticación, no se accedió al router ni al Pixel. Todo dentro de activos confirmados como propios.

## 1. GravitalPay expuesto en todas las interfaces
- Evidencia: `01-baseline.txt:51-52` (`*:8080`, `*:8081`), `05-identificacion-servicios.txt:1-4` (título `GravitalPay`).
- Impacto: alcanzable desde cualquier dispositivo de la LAN `192.168.0.0/24`. Dominio de pagos: fuera de alcance del agente (L-3/L-4).
- Decisión del humano: ¿necesita acceso LAN? Si no, limitar a `127.0.0.1` o a una interfaz concreta y cerrar el puerto con firewall; si sí, documentar el motivo y exigir autenticación y TLS.
- No ejecutado por el agente. No se enviaron peticiones autenticadas ni se probaron credenciales.

## 2. UPnP del gateway con divulgación de versión
- Evidencia: `02-tcp-semilla.txt:6` (`192.168.0.1:80,5000`), `04-servicios.txt:19` (`MiniUPnPd/1.9`, `RedHatEnterpriseServer/6.10`).
- Impacto: fingerprinting del dispositivo; superficie UPnP visible en la LAN. Sin evidencia de explotación.
- Decisión del humano: entrar con las credenciales oficiales, revisar si UPnP es necesario, desactivarlo o actualizar firmware, y decidir si el equipo propone cambios con ventana y rollback.

## 3. Cobertura SAST incompleta
- El gate avisó: `KS_AUDIT_CMD`/`KS_SAST_CMD` vacíos. No se configuraron comandos falsos para silenciar el aviso (S-10).
- Herramientas disponibles verificadas: `gitleaks` sí; `semgrep`, `bandit`, `trivy`, `pip-audit` no instalados.
- Requiere ADR humano y verificación S-9 antes de instalar o fijar cualquier herramienta. Hasta entonces la cobertura se reporta como incompleta.

## 4. Publicación del frente
- Rama `Debura` publicada y sincronizada (`0 0`). PR pendiente: el agente no puede ejecutar `gh` (denegado por política).
- Comando para El Presidente: `gh pr create --base main --head Debura --title "Equipo rojo/azul: entrenamiento CTF con scoring verificable" --body-file docs/kaizen/pr-drafts/Debura.md`
- URL: https://github.com/angelnereira/kaizen-swarm/pull/new/Debura
