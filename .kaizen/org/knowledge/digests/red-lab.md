# Digest de conocimiento: red-lab

- **CIAC-011 Datasets sinteticos** — `contrib/ciac-knowledge/cache/datasets/README.md` (sha256 4bc2511fc9ea)

## README.md
# Datasets sintéticos para práctica

Registros **100 % ficticios** de una semana de operación de una empresa inventada, con ataques reales simulados escondidos entre el tráfico normal. Sirven para practicar cacería de amenazas, ingeniería de detección, respuesta a incidentes y análisis de registros sin tocar datos reales.

> ⚠️ **Todo es ficticio.** La organización *Andina Logística S.A.* no existe. Las IPs externas son de rangos de documentación (RFC 5737), los dominios terminan en `.example`, la cuenta y la llave de AWS son los valores de ejemplo de la documentación de AWS y los hashes son aleatorios. No uses estos valores como indicadores reales.

## El entorno

| | |
|---|---|
| **Organización** | Andina Logística S.A. · dominio `empresa-andina.example` · dominio de Windows `ANDINA` |
| **Período** | Lunes 2 al viernes 6 de marzo de 2026, en UTC (Colombia = UTC−5) |
| **Personas** | 30 usuarios (`nombre.apellido`) y 2 administradores (`adm.carlos`, `adm.julia`) |
| **Equipos** | Estaciones `WS-001` a `WS-030` (<ip>–39) · `SRV-DC01` (<ip>) · `SRV-FS01` (<ip>) · `SRV-SQL01` (<ip>) · `SRV-WEB01` (<ip>, DMZ) · `lnx-web02` (<ip>, DMZ) |
| **Servicios expuestos** | Tienda en línea `tienda.empresa-andina.example` (IP pública <ip>) detrás de un WAF |
| **Nube** | AWS (cuenta 111122223333, región principal sa-east-1) · Microsoft Entra ID y Microsoft 365 |

## Fuentes

| Fuente | Carpeta | Eventos | Basada en |
|---|---|---|---|
| Sysmon | [`fuentes/sysmon`](fuentes/sysmon/) | ~4 800 | Sysmon para Windows (eventos 1, 3, 10, 11, 13, 22) |
| Seguridad de Windows | [`fuentes/windows-security`](fuentes/windows-security/) | ~2 400 | Registros Security y System (4624, 4625, 4672, 4688, 4698, 4720, 7045, 1102) |
| EDR | [`fuentes/edr-alertas`](fuentes/edr-alertas/) | ~30 | Alertas genéricas de un EDR |
| Firewall | [`fuentes/firewall`](fuentes/firewall/) | ~5 700 | Registro de tráfico de un firewall de nueva generación |
| Proxy web | [`fuentes/proxy`](fuentes/proxy/) | ~2 400 | Registro de un proxy de navegación |
| DNS | [`fuentes/dns`](fuentes/dns/) | ~2 600 | Consultas al DNS interno |
| WAF | [`fuentes/waf`](fuentes/waf/) | ~2 000 | Formato de registro de AWS WAF |
| Servidor web | [`fuentes/servidor-web`](fuentes/servidor-web/) | ~1 400 | Registro de accesos de la tienda |
| Correo | [`fuentes/correo`](fuentes/correo/) | ~430 | Pasarela de seguridad de correo |
| AWS CloudTrail | [`fuentes/aws-cloudtrail`](fuentes/aws-cloudtrail/) | ~710 | Formato CloudTrail (incluye archivo con estructura nativa `Records`) |
| Entra ID · inicios de sesión | [`fuentes/azure-entra-signin`](fuentes/azure-entra-signin/) | ~1 100 | Esquema de *sign-in logs* de Microsoft Entra |
| Entra ID · auditoría | [`fuentes/azure-entra-audit`](fuentes/azure-entra-audit/) | ~90 | Esquema de *audit logs* de Microsoft Entra |
| Microsoft 365 · auditoría | [`fuentes/m365-audit`](fuentes/m365-audit/) | ~210 | Registro de auditoría unificado (Exchange y SharePoint) |
| Linux · autenticación | [`fuentes/linux-auth`](fuentes/linux-auth/) | ~880 | `auth.log` (sshd, sudo, cron) |

Cada fuente viene en **dos formatos**:
- **CSV** (`.csv`): para Excel, hojas de cálculo y herramientas de análisis. Los campos anidados se aplanan con punto (`httpRequest.clientIp`) y las listas se guardan como JSON.
- **JSON Lines** (`.jsonl`): un objeto JSON por línea, el formato que ingieren directamente Splunk, Elastic, Microsoft Sentinel / Azure Data Explorer y la mayoría de los SIEM.
