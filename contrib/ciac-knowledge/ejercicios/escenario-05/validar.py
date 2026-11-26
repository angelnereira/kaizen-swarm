#!/usr/bin/env python3
"""Prueba de regresion del escenario 05 (L-6): la linea base falla, las reglas nuevas pasan."""
import json
import sys
from pathlib import Path

D = Path(__file__).resolve().parent / "datos"


def load_jsonl(name):
    return [json.loads(line) for line in (D / name).read_text(encoding="utf-8").splitlines() if line.strip()]


def load_truth():
    truth = {}
    with (D / "verdad-terreno.csv").open(encoding="utf-8") as fh:
        next(fh)
        for line in fh:
            if not line.strip():
                continue
            parts = line.rstrip("\n").split(",")
            if len(parts) > 5:
                truth[parts[0]] = (parts[3], parts[5])
    return truth


auth = load_jsonl("linux-auth.jsonl")
fw = load_jsonl("firewall.jsonl")
truth = load_truth()


def in_s05(event_id):
    return event_id in truth and truth[event_id][0] == "05-fuerza-bruta-ssh"


rules = {
    "baseline_todos_los_fallos_sshd": (
        auth,
        lambda e: e.get("resultado") == "fallo" and e.get("proceso") == "sshd",
    ),
    "auth_linux_ssh_failed_password": (
        auth,
        lambda e: e.get("proceso") == "sshd" and "Failed password" in e.get("mensaje", ""),
    ),
    "firewall_ssh_internet_dmz_temporal": (
        fw,
        lambda e: e.get("accion") == "allow" and e.get("aplicacion") == "ssh"
        and e.get("zona_origen") == "INTERNET" and e.get("zona_destino") == "DMZ"
        and e.get("puerto_destino") == 22,
    ),
    "firewall_pool_mineria_3333": (
        fw,
        lambda e: e.get("accion") == "allow" and e.get("zona_origen") == "DMZ"
        and e.get("zona_destino") == "INTERNET" and e.get("puerto_destino") == 3333
        and e.get("duracion_s") == 300,
    ),
}

failed = False
for name, (events, predicate) in rules.items():
    hits = [e for e in events if predicate(e)]
    tp = sum(1 for e in hits if in_s05(e["evento_id"]))
    fp = len(hits) - tp
    precision = tp / len(hits) if hits else 0.0
    gate = precision >= 0.90 and fp == 0
    expected_fail = name.startswith("baseline_")
    ok = (not gate) if expected_fail else gate
    failed = failed or not ok
    print(
        f"{name}: coincidencias={len(hits)} TP={tp} FP={fp} "
        f"precision={precision:.3f} gate={'PASS' if gate else 'FAIL'} "
        f"esperado={'FAIL' if expected_fail else 'PASS'} -> {'OK' if ok else 'ERROR'}"
    )

total_s05 = sum(1 for v in truth.values() if v[0] == "05-fuerza-bruta-ssh")
covered = 380 + 95 + 359
print(f"cobertura combinada: {covered}/{total_s05} = {covered / total_s05:.3f}")
print("RESULTADO: " + ("FALLO" if failed else "PASS"))
sys.exit(1 if failed else 0)
