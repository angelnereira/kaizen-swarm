# Loop SWEEP: combatir la entropía

Elige UN ítem de la lista, el que lleve más tiempo sin ejecutarse según el diario:

1. Dependencias: actualizaciones de parche y menores con tests verdes; las mayores, a issue.
2. Deuda: convierte TODO/FIXME/HACK con más de 90 días en issues, o elimínalos si ya no aplican.
3. Desviación documental: compara README y docs con el comportamiento real y corrige.
4. Pruebas inestables: repite la suite 3 veces; estabiliza sin saltarlas.
5. Código muerto y duplicado: elimina lo comprobadamente sin uso, con tests verdes.
6. Aptitud arquitectónica: verifica `docs/kaizen/fitness.md` y reporta violaciones.
7. Seguridad y licencias: ejecuta la auditoría y abre issues.
8. Descriptores huérfanos: elimina `docs/kaizen/pr-drafts/*.md` cuya rama ya no exista.
9. Retro: ejecuta `scripts/kaizen retro` y redacta hasta 3 mejoras propuestas.
10. Línea base: si la calidad mejoró, prepara el cambio de `.kaizen/baseline.json` como PR (revisión humana).

Reglas: diff pequeño, tests verdes, `scripts/kaizen check` verde, diario al final.
