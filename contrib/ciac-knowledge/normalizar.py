#!/usr/bin/env python3
"""Normaliza espacios finales y lineas en blanco al final de archivos generados."""
import subprocess
import sys
from pathlib import Path

names = subprocess.check_output(
    ["git", "diff", "--cached", "--name-only", "--", "*.md"], text=True
).splitlines()
changed = 0
for name in names:
    p = Path(name)
    if not p.is_file():
        continue
    lines = [line.rstrip() for line in p.read_text(encoding="utf-8").splitlines()]
    while lines and lines[-1] == "":
        lines.pop()
    new = "\n".join(lines) + "\n"
    if new != p.read_text(encoding="utf-8"):
        p.write_text(new, encoding="utf-8")
        changed += 1
print(f"normalizados: {changed}")
sys.exit(0)
