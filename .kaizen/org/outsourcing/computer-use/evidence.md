source_ids: LOCAL-002
command: "KO_DESKTOP_ENABLED=1 kaizen-desktop check / key Escape / capture antes y despues"
result: "check OK (X11 DISPLAY=:0, 3072x1728, xdotool e import disponibles). Accion motor verificada: key Escape registrada en desktop.log. CAPTURA FALLIDA: X_GetImage devuelve BadMatch en este Xwayland; import/xwd no pueden capturar root ni ventana. Sin recaptura no hay verificacion visual."
state: "BLOQUEADO PARCIAL: teclado/funciona, vision de pantalla no disponible en este entorno"
