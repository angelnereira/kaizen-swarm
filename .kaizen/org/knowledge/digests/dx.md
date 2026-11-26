# Digest de conocimiento: dx

- **CIAC-002 Buenas practicas** — `contrib/ciac-knowledge/cache/best-practices/README.md` (sha256 79fc4c6b2ad0)
- **CIAC-012 Deteccion como codigo** — `contrib/ciac-knowledge/cache/detection-as-code/README.md` (sha256 1170bff7d00b)

## README.md
# Buenas prácticas

Guías de configuración segura pensadas para equipos de la región, desde la pyme con una sola persona de TI hasta el SOC de una entidad financiera.

| Carpeta | Alcance |
|---|---|
| [windows-hardening](windows-hardening/) | Estaciones y servidores Windows, Active Directory |
| [linux-hardening](linux-hardening/) | Servidores Linux (Debian/Ubuntu, RHEL y derivados) |
| [cloud-security](cloud-security/) | AWS, Azure, Google Cloud y Microsoft 365 / Google Workspace |
| [identity-security](identity-security/) | Identidades, MFA, cuentas privilegiadas y acceso |
| [nist-cisa](nist-cisa/) | Buenas prácticas de NIST y CISA para SOC, inteligencia, vulnerabilidades, cacería, respuesta a incidentes y comunicaciones |
| [ai-secure-development](ai-secure-development/) | Programar con IA, construir aplicaciones y agentes con LLM, y usar IA en operaciones de seguridad |

## Cómo está organizada cada guía

1. **Contexto:** por qué importa y qué amenazas mitiga (con técnicas ATT&CK).
2. **Prioridad:** 🔴 imprescindible · 🟡 recomendado · 🟢 deseable.
3. **Implementación:** pasos o comandos probados, con la versión.
4. **Verificación:** cómo comprobar que quedó aplicado.
5. **Impacto:** qué se puede romper y cómo revertir.
6. **Referencias:** CIS Benchmark, CIS Controls v8.1, NIST, OWASP, guía del fabricante.

Para empezar una guía nueva copia [`_plantilla.md`](_plantilla.md).

## README.md
# Detection as Code

Detecciones versionadas, revisadas y probadas como código. Licencia: [DRL 1.1](LICENSE.md).

| Carpeta | Formato | Plataforma |
|---|---|---|
| [sigma](sigma/) | Sigma (YAML) | Independiente: se convierte a cualquier SIEM con pySigma |
| [kql](kql/) | Kusto Query Language | Microsoft Sentinel, Defender XDR |
| [xql](xql/) | XQL | Cortex XDR / XSIAM |
| [yara](yara/) | YARA | Archivos y memoria |
| [suricata](suricata/) | Reglas Suricata | IDS/IPS de red |

## Ciclo de vida

```
experimental  →  test  →  stable
   (nueva)      (probada en   (usada por 2+ organizaciones
                 laboratorio)   sin falsos positivos relevantes)
```

## Requisitos de toda detección
- Técnica **MITRE ATT&CK** asociada.
- **Autor/a, fecha** y **referencias**.
- **Falsos positivos** conocidos.
- **Origen de datos** necesario (qué log o telemetría).
- Probada: indica plataforma y versión.

## Prioridad: Sigma primero
Si la lógica se puede expresar en Sigma, escríbela en Sigma y, si quieres, agrega la versión KQL o XQL. Así una misma detección sirve a toda la comunidad, sin importar su SIEM.

```bash
pip install sigma-cli
sigma plugin install microsoft365defender   # o splunk, elasticsearch, ...
sigma convert -t microsoft365defender sigma/windows/<regla>.yml
```

Los PR que tocan `sigma/` o `yara/` se validan automáticamente.
