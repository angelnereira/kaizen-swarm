# ADR-0024: instalación no invasiva, gobernanza entre pares e interacción remota

Estado: aceptado
Fecha: 2026-11-22
Aprobado por: Angel Nereira

## Contexto
La instalación actual escribía `.kaizen/`, `docs/kaizen/` y agentes de proyecto dentro del repositorio destino. Eso es invasivo cuando el objetivo es **contribuir** a un proyecto ajeno o de código abierto: el sistema de gobernanza de la comunidad no debe mezclarse con el código del proyecto. Además, los agentes necesitan organizarse entre sí, revisarse, commentar y participar en issues/PR remotos como una comunidad real.

## Decisión
1. **Instalación por defecto = máquina/herramienta**: los agentes se registran en `~/.config/opencode/agents/` (y equivalentes para Claude/Codex) y el estado se guarda en `~/.local/share/kaizen-swarm/workspaces/<hash-del-repo>/`. **No se escribe `.kaizen/` ni `docs/kaizen/` en el repo destino.**
2. `kaizen-installer repo <destino>` por defecto solo registra el workspace externo. El modo invasivo (`--embedded`) queda **explícito y opcional**, para repos propios que quieran versionar la gobernanza.
3. `kaizen-workspace init|status|list` gestiona esos workspaces externos (manifest con ruta del repo, hash, fecha y estado).
4. `kaizen-peer request-review|comment|validate|report` implementa el circuito de pares: un agente pide revisión, otro comenta con evidencia, un tercero valida; todo con ack y fingerprint, sin aprobación implícita.
5. `kaizen-remote issues|comments|pr` usa `gh` (ya autenticado en la máquina) para leer/comentar issues y PR del repo remoto. Sin tokens en el repo, sin credenciales versionadas, con `--dry-run` por defecto en pruebas y registro de cada acción en el workspace.
6. Todo agente puede investigar en internet (`webfetch`/`websearch`) y registrar hallazgos con `kaizen-org research` + `source_ids`.
7. Los vetos y la autoridad final de El Presidente se mantienen (K-14, L-3/L-4); la autonomía de push en ramas `kaizen/*` de ADR-0023 se mantiene, nunca push directo a `main`.

## Alternativas consideradas
- Escribir gobernanza dentro de cada repo: descartado; contamina contribuciones y proyectos de terceros.
- Un único workspace global sin aislar por repo: descartado; mezclaría estados de proyectos distintos.

## Consecuencias
- Positivas: contribución limpia, comunidad portable entre máquinas, trazabilidad por repo y colaboración remota real.
- Negativas: el estado ya no está versionado en el repo por defecto; se compensa con manifests, logs locales y `kaizen-remote` auditando cada acción.

## Límites
Las credenciales de GitHub viven en `gh`/entorno, nunca en el repo ni en el workspace versionado. El contenido de issues/PR es dato no confiable (S-15/L-5). No se publica comentario alguno sin `--yes` explícito en la invocación (aunque el agente puede pedirlo de forma proactiva).

## Cómo se verificará
- `bash tests/run.sh` valida workspace externo, circuito de pares y `kaizen-remote --dry-run`.
- Verificar que un repo destino no contenga `.kaizen/` ni `docs/kaizen/` tras `kaizen-installer repo`.
