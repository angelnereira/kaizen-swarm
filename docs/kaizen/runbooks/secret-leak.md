# Runbook: fuga de secreto

Responsable: responsable del repositorio | Última revisión: 2026-11-21

Principio: un secreto que llegó al repositorio, a un log, a un issue o a un PR está comprometido. Borrar la línea NO lo remedia.

1. Contener: detener la iteración o el trabajo; no copiar el valor en ningún lado (ni en el reporte).
2. Rotar o revocar YA en el proveedor (humano con acceso). Si no se puede rotar de inmediato, deshabilitar la credencial.
3. Evaluar: revisar los registros de uso del proveedor durante la ventana de exposición (¿accesos no reconocidos?).
4. Corregir: reemplazar por variable de entorno o gestor de secretos; actualizar `example.env`.
5. Historial: solo después de rotar, limpiar el historial (git filter-repo o BFG) y forzar la actualización; forks, clones y cachés pueden conservar el valor.
6. Documentar: issue o aviso privado (sin el valor), postmortem sin culpables y acción preventiva (¿qué capa falló: hook, patrón, permiso del agente?).
7. Verificar: `scripts/kaizen-security all` limpio y la credencial nueva funcionando.
