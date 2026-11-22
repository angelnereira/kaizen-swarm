# Voz, criterio y documentación de los agentes

Los agentes no solo ejecutan: **redactan, comentan, analizan, juzgan y participan en público**. Esta habilidad es tan importante como el código: una conclusión sin redacción clara no es accionable.

## 1. Cuatro habilidades obligatorias

| Habilidad | Qué exige |
| --- | --- |
| **Redactar** | Escritos cortos, con encabezados, estado, evidencia y siguiente paso |
| **Comentar** | En issues/PRs: observación → evidencia → impacto → propuesta → pregunta |
| **Analizar** | Separar dato de inferencia; declarar supuestos y rangos de incertidumbre |
| **Juzgar** | Emitir `APPROVE / CHANGES_REQUESTED / BLOCK` con criterio y consecuencias |

## 2. Plantillas

### Comentario de issue

```markdown
## Observación
<qué vi, sin adjetivos>

## Evidencia
- `source_id` o comando reproducible

## Impacto
<qué cambia para el usuario / el negocio / el sistema>

## Propuesta
<acción concreta y dueño>

## Pregunta
<una pregunta verificable>
```

### Dictamen de revisión

```markdown
## Hallazgos
- [severidad] descripción — archivo:línea o source_id

## Evidencia
<comando ejecutado o fuente>

## Riesgo
<qué pasa si no se corrige>

## Recomendación
<cambio mínimo>

## Dictamen
APPROVE | CHANGES_REQUESTED | BLOCK
```

### Memorial de decisión

```markdown
## Decisión
<qué se decidió>

## Opciones y por qué se descartaron
## Evidencia (source_ids)
## Disidentes y contraejemplos
## Incertidumbre
## Dueño, fecha de revisión y KPI
```

## 3. Reglas de publicación

1. Sin secretos, credenciales ni datos personales (S-1/S-8).
2. Sin detalles explotables en issues públicos (S-13): el hallazgo de seguridad va por canal privado.
3. Sin afirmaciones sin evidencia: decir "no verificado" es válido y preferible (K-10).
4. Sin comentarios de relleno: si no aportas dato, formula una pregunta concreta.
5. Lenguaje ejecutivo: estado, evidencia, riesgo, decisión requerida, plazo (`.kaizen/team/OWNER.md`).

## 4. Criterio

Para juzgar, el agente comprueba: ¿la evidencia es reproducible? ¿la opción es reversible? ¿existe fuente oficial? ¿quién responde si falla? ¿se respetan L-3/L-4 y los vetos? Si alguna respuesta es "no", el dictamen es `CHANGES_REQUESTED` o `BLOCK`.

Ver `scripts/kaizen-voice comment|memo|check` y `.kaizen/team/DECISIONES.md`.
