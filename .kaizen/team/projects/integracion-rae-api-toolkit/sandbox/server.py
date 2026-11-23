#!/usr/bin/env python3
"""Servidor HTTP local de prueba para el KPI de integracion-rae-api-toolkit.

- Sólo escucha en 127.0.0.1 (nunca 0.0.0.0): no se expone fuera de localhost.
- Sirve archivos estáticos desde ./public y un endpoint JSON con datos SINTÉTICOS.
- Sin credenciales, sin datos personales, sin dependencias externas (Python stdlib).
- No se inicia automáticamente: lo arranca explícitamente un humano o un agente autorizado.
"""

from __future__ import annotations

import json
import os
import sys
from http.server import SimpleHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

# Decisión de seguridad: enlace fijo a loopback. No es configurable a propósito.
HOST = "127.0.0.1"
DEFAULT_PORT = 8765
MIN_PORT = 1024
MAX_PORT = 65535

BASE_DIR = Path(__file__).resolve().parent
STATIC_DIR = BASE_DIR / "public"

# Catálogo inventado para pruebas. Ningún campo identifica a una persona real.
CATALOG = [
    {"id": 1, "sku": "SKU-0001", "name": "Cuaderno A5", "price_cents": 350, "currency": "USD", "active": True},
    {"id": 2, "sku": "SKU-0002", "name": "Lapiz HB", "price_cents": 75, "currency": "USD", "active": True},
    {"id": 3, "sku": "SKU-0003", "name": "Borrador blanco", "price_cents": 50, "currency": "USD", "active": False},
]


class SandboxHandler(SimpleHTTPRequestHandler):
    """Estático + API JSON falsa, con logging sin query strings ni cabeceras."""

    server_version = "KaizenSandbox/1.0"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(STATIC_DIR), **kwargs)

    def do_GET(self) -> None:
        path = self.path.split("?", 1)[0]
        if path.startswith("/api/"):
            self._handle_api(path)
            return
        super().do_GET()

    def _handle_api(self, path: str) -> None:
        if path == "/api/health":
            self._send_json({"status": "ok", "service": "kaizen-sandbox"})
            return
        if path == "/api/catalog":
            self._send_json({"items": CATALOG, "total": len(CATALOG)})
            return
        if path.startswith("/api/catalog/"):
            raw_id = path[len("/api/catalog/") :]
            if not raw_id.isdigit():
                self._send_json({"error": "invalid_id"}, status=400)
                return
            item = next((row for row in CATALOG if row["id"] == int(raw_id)), None)
            if item is None:
                self._send_json({"error": "not_found"}, status=404)
                return
            self._send_json(item)
            return
        self._send_json({"error": "not_found"}, status=404)

    def _send_json(self, payload: object, status: int = 200) -> None:
        body = json.dumps(payload, ensure_ascii=False, separators=(",", ":")).encode("utf-8")
        self.send_response(status)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.end_headers()
        self.wfile.write(body)

    def log_request(self, code="-", size="-") -> None:
        # S-8: se registra sólo método, ruta sin query y código; nunca cabeceras ni cuerpos.
        path = self.path.split("?", 1)[0]
        sys.stderr.write(f"{self.command} {path} {code}\n")

    def log_message(self, fmt: str, *args: object) -> None:
        # Evita que el handler base vuelva a imprimir la request line completa.
        return


def parse_port() -> int:
    """Puerto desde SANDBOX_PORT; falla rápido sin imprimir el valor recibido."""
    raw = os.environ.get("SANDBOX_PORT", str(DEFAULT_PORT))
    try:
        port = int(raw, 10)
    except ValueError:
        raise SystemExit("Configuracion invalida: SANDBOX_PORT debe ser un entero entre 1024 y 65535")
    if not MIN_PORT <= port <= MAX_PORT:
        raise SystemExit("Configuracion invalida: SANDBOX_PORT debe estar entre 1024 y 65535")
    return port


def main() -> None:
    port = parse_port()
    if not STATIC_DIR.is_dir():
        raise SystemExit("Falta el directorio public/ junto a server.py")
    httpd = ThreadingHTTPServer((HOST, port), SandboxHandler)
    sys.stderr.write(f"Sandbox local escuchando en http://{HOST}:{port}/ (Ctrl+C para detener)\n")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.server_close()


if __name__ == "__main__":
    main()
