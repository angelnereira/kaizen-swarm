# Deliberación y decisión de alto rendimiento

Un equipo de alto rendimiento no "decide entre todos": reparte roles de pensamiento, exige evidencia, permite disidencia y deja un memorial. Esto extiende `.kaizen/org/CONSENSUS.md`.

## Roles de pensamiento (por decisión)

| Rol | Quién | Función |
| --- | --- | --- |
| **Dueño de la decisión** | `gerente` / dueño del ámbito | Encuadra la pregunta, fija plazo, cierra o escala |
| **Analista** | `analista-negocios`, `capacidades-negocio`, `data-expert` | Aporta datos, supuestos y opciones |
| **Retador** | `architect`, `qa`, `security`, `cumplimiento-panama` | Busca fallos, contraejemplos y riesgos; su voz es obligatoria |
| **Escriva** | `knowledge-curator`, `verificador-evidencias` | Escribe el memorial y conserva `source_ids` |
| **Facilitador** | `facilitador-equipo` | Ordena turnos, evita debate circular, marca acuerdos |
| **Humano** | El Presidente | Aprueba decisiones sensibles (L-3/L-4) |

La regla del retador: si nadie objetó, la decisión no está lista. El retador no bloquea por capricho: bloquea con evidencia o marcando `unknown`.

## Secuencia

1. **Encuadre**: pregunta, métrica de éxito, restricciones, fecha.
2. **Evidencia**: `source_ids` verificados (`kaizen-team verify`); sin fuente, la opción queda `pending`.
3. **Opciones**: mínimo dos, con coste, riesgo y reversibilidad.
4. **Deliberación**: dos turnos; cada turno aporta dato nuevo. El retador presenta contraejemplo.
5. **Decisión**: mayoría cualificada sin veto; sensible → humano (A).
6. **Memorial** (`kaizen-voice memo`): decisión, disidentes, evidencia, incertidumbre, dueño y revisión.
7. **Verificación** (L-9): ¿mejoró la métrica? Si no, `regression-suspect` + revert propuesto.

## Participación pública (issues, PRs, canales)

- Todo comentario público debe: citar evidencia, separar hecho de hipótesis, proponer siguiente paso y no filtrar secretos ni detalles explotables (S-1/S-13).
- Formato: `Observación → Evidencia → Impacto → Propuesta → Pregunta concreta`.
- Sin comentarios vacíos ("LGTM", "de acuerdo"). Si no tienes evidencia, pregunta.
- El disenso se escribe en el hilo con el contraejemplo, nunca se guarda para "después".

Ver `scripts/kaizen-voice` y `.kaizen/org/knowledge/business/VOZ-Y-DOCUMENTACION.md`.
