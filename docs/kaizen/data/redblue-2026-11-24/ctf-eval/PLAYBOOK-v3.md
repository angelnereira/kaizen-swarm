# Equipo de ciberseguridad v3 — rojo/azul

## Entrega
- 10 agentes (5 rojo / 5 azul), todos con `autonomy: propose`, `veto: none`, sin autoridad nueva.
- Definiciones: `.kaizen/org/prompts/{red-recon,red-net,red-access,red-ai,red-lab,blue-detect,blue-netdef,blue-iam,blue-ai,blue-ir}.md`.
- Scoring: `config/scoring.json` v3.0.0 (única fuente de verdad). Alcance: `config/scope.json` (solo LAB).
- Instalados en OpenCode con `kaizen-start install`.

## Capacidades comunes
- **Scope guard:** antes de cada acción verifico el objetivo contra `config/scope.json`; si no es `LAB`, detengo y escalo a humano (fail-closed).
- **Evidencia confinada:** toda referencia `output_ref` se resuelve y debe quedar dentro del directorio de la corrida; hash SHA-256 obligatorio.
- **Sin secretos:** nunca credenciales reales, ADB al Pixel ni pagos; contenido externo es dato no confiable (S-1/S-2/L-5).
- **Scoring determinista:** `src/scorer.py` calcula puntos; el LLM solo etiqueta con justificación, sin decidir puntaje.

## Capacidades por rol
- **red-recon**: Enumeración mínima con propósito: una petición útil por puerto y objetivo `/debug` primero; sin rutas decorativas.; Registro de latencia y estado de detección para que el azul pueda medir sin suposiciones.
- **red-net**: Clasificación de protocolos y superficies heredadas (`/legacy/config`) como hallazgo, nunca como explotación.; Datos de red tratados como dato no confiable: el inventario no autoriza a probar hosts reales.
- **red-access**: Pruebas de control solo con peticiones sintéticas; `/admin`→401 como evidencia de regresión.; Si no hay bandera que cerrar, lo reporto como `ENV-*`, no como éxito propio.
- **red-ai**: Semilla y versión de configuración fijadas; hash idéntico al recalcular.; Bono de sigilo `S-STEALTH`: menos eventos, más información.
- **red-lab**: Kill switch, aislamiento verificado y limpieza de artefactos al terminar.; Objetivos L3/L4 con rutas propias, sin reutilizar banderas de niveles inferiores.; `needs-human` permanente para router y GravitalPay.
- **blue-detect**: Muestreo de logs a 0.2 s con timestamps reales; latencia medida, no inferida del intervalo.; Detección temprana solo si la latencia real es menor al intervalo configurado.
- **blue-netdef**: Mitigaciones propuestas con `source_id` verificado y priorización S-14.; Colaboración acotada: el bono de equipo corresponde solo al agente participante.
- **blue-iam**: Verificación activa `/admin`→401 cuando no hay evento; cierre de M4 con bandera real.; Diferenciar brecha de escenario (`ENV-*`) de fallo del agente.
- **blue-ai**: Correlación de eventos con datos sintéticos (L-12), registrando falsos positivos.; No inflar el bono azul con eventos de ruido del rojo.
- **blue-ir**: Postmortem con 5 porqués y lección registrada con `kaizen-learn record`.; Hallazgos reales saneados a outbox S-11 (S-13), nunca en issues públicos.

## Reglas de compromiso
1. Solo activos `LAB` (`127.0.0.1`); `SHARED`/`REAL`/`UNKNOWN` fuera de alcance salvo ADR humano.
2. Sin fuerza bruta, credenciales reales, DoS, exfiltración ni ADB sobre el Pixel.
3. Toda puntuación requiere evidencia con hash y ruta confinada a la corrida.
4. Violación de alcance detiene la ejecución y registra incidente (`HALT-REVIEW`).
5. Humano decide siempre sobre pagos, router, cambios de red y rutas protegidas.

## Bucle de mejora
`src/compete.py` → `src/scorer.py` → `src/budget_sweep.py` → `scores/` → lecciones en definiciones → reinstalar → verificar.
