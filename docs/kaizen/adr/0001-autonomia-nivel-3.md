# ADR-0001: autonomía nivel 3 para la comunidad

Estado: aceptado
Fecha: 2026-11-21
Aprobado por: Angel Nereira (responsable del repositorio, decisión registrada en la sesión de instalación)

## Contexto
`.kaizen/loop/loop.env` y la documentación Kaizen fijan por defecto `KL_AUTONOMY=1` con PAUSA activa: el agente solo propone y una persona fusiona. El objetivo declarado para este repositorio es una comunidad **proactiva y autónoma**, con roles dedicados que colaboran sin esperar a que se lance cada tarea.

## Decisión
Fijar `KL_AUTONOMY=3` desde la instalación y retirar `.kaizen/loop/PAUSE`. La comunidad puede auto-fusionar:

- cambios de bajo riesgo (docs, pruebas, comentarios, ≤ 150 líneas) tras gates verdes;
- correcciones de bug con prueba de regresión verificada y despliegue canario con reversión automática.

## Alternativas consideradas
1. Nivel 1 + PAUSA (recomendación por defecto del framework): descartada por el responsable; demasiado pasiva para el objetivo.
2. Nivel 2: descartada; no cubre bugfix verificados.

## Consecuencias
- Positivas: el ciclo detecta→corrige→verifica se cierra sin intervención por tarea; los roles trabajan de forma proactiva sobre issues `swarm:ready`.
- Negativas: mayor superficie de auto-merge. Se compensa con rutas protegidas (L-4), CODEOWNERS, protección de rama, presupuesto diario, disyuntor y veto vinculante de Seguridad/Arquitecto/QA.

## Restricciones que NO se relajan
Nunca sin humano: rutas protegidas, seguridad y autenticación, pagos, migraciones destructivas, borrado de datos, publicación a producción sin pipeline con gate humano, y modificar el propio loop o sus reglas. El orquestador —no el agente— hace push y abre PRs.

## Cómo se verificará
- `scripts/kaizen-swarm check` confirma la existencia de este ADR.
- `scripts/kaizen-loop status` muestra autonomía 3 y pausa no activa en el repo local.
- El workflow `kaizen-loop.yml` queda condicionado a `vars.KAIZEN_LOOP_ENABLED == '1'`; el responsable añade el token y las claves del modelo antes de activarlo. Sin esa variable no hay ejecuciones programadas ni ruido de CI.
- Roster canónico: 17 roles (el documento de diseño decía 16 por error de conteo).
