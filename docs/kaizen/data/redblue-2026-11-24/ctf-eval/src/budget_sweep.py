#!/usr/bin/env python3
"""Barrido de presupuesto de tiempo: que hito/nivel alcanza cada agente.
Simulacion determinista con costes temporales declarados en config/scoring.json.
No espera tiempo real: modela el trabajo de cada hito a partir de la configuracion."""
import os, json

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFG = json.load(open(os.path.join(BASE, "config/scoring.json"), encoding="utf-8"))
C = CFG["competition"]
COSTS = C["milestone_time_cost_seconds"]
LEVEL_MULT = C["level_time_multiplier"]
ORDER = ["M1", "M2", "M3", "M4"]

LEVEL_RANK = {"L1": 1, "L2": 2, "L3": 3, "L4": 4}

def simulate(budget):
    out = {}
    for t in C["tasks"]:
        mult = LEVEL_MULT.get(t["level"], 1.0)
        if t.get("time_cost_seconds"):
            # el coste explicito representa el trabajo total hasta M4
            per = {m: t["time_cost_seconds"] * w for m, w in
                   (("M1", 0.10), ("M2", 0.30), ("M3", 0.60), ("M4", 1.0))}
        else:
            per = {m: COSTS[m] * mult for m in ORDER}
        elapsed = 0.0
        reached = []
        for m in ORDER:
            elapsed += per[m]
            if elapsed <= budget:
                reached.append(m)
            else:
                break
        progress = sum(CFG["milestones"][m] for m in reached)
        if "M4" not in reached:
            progress = min(progress, CFG["max_partial_without_M4"])
        d = CFG["difficulty"][t["difficulty"]]
        raw = round(t["base"] * d * progress, 2)
        out[t["agent"]] = {
            "task": t["id"], "level": t["level"], "team": t["team"],
            "milestones": reached, "progress": round(progress, 2),
            "seconds_used": round(min(elapsed, budget), 1), "raw": raw
        }
    return out

def main():
    lines = ["# Barrido de presupuesto de tiempo — 10 agentes", "",
             "Método: simulación determinista con costes por hito declarados en `config/scoring.json`.",
             "No es tiempo de reloj real: modela cuánto trabajo cabe en cada ventana.",
             "Presupuestos: " + ", ".join(f"{k} ({v}s)" for k, v in C["budgets_seconds"].items()), "",
             "| Presupuesto | Agente | Equipo | Nivel de la tarea | Hitos | Progreso | Raw |", 
             "| --- | --- | --- | --- | --- | ---: | ---: |"]
    per_budget = {}
    for label, budget in C["budgets_seconds"].items():
        sim = simulate(budget)
        per_budget[label] = sim
        for agent, v in sim.items():
            lines.append(f"| {label} | {agent} | {v['team']} | {v['level']} | {','.join(v['milestones']) or '-'} | {v['progress']} | {v['raw']} |")
    lines += ["", "## Nivel máximo alcanzado por agente", "",
              "| Agente | 5 min | 10 min | 1 h | 2 h |", "| --- | --- | --- | --- | --- |"]
    for agent in [t["agent"] for t in C["tasks"]]:
        cells = []
        for label in ("5min", "10min", "1h", "2h"):
            v = per_budget[label][agent]
            reached = v["milestones"]
            if "M4" in reached:
                cells.append(f"{v['level']} completo")
            elif "M2" in reached:
                cells.append(f"{v['level']} (M2)")
            elif reached:
                cells.append("M1")
            else:
                cells.append("sin avance")
        lines.append("| " + agent + " | " + " | ".join(cells) + " |")
    lines += ["", "## Totales por presupuesto", "", "| Presupuesto | Raw total | M4 completados | Nivel más alto |",
              "| --- | ---: | ---: | --- |"]
    for label, sim in per_budget.items():
        total = round(sum(v["raw"] for v in sim.values()), 2)
        m4 = sum(1 for v in sim.values() if "M4" in v["milestones"])
        highest = max((LEVEL_RANK[v["level"]] for v in sim.values() if "M4" in v["milestones"]), default=0)
        lines.append(f"| {label} | {total} | {m4} | L{highest} |")
    lines += ["", "- L3/L4 solo alcanzables en los presupuestos de 1 h y 2 h.",
              "- Sin salida de alcance: todas las tareas son `LAB` (`127.0.0.1`).", ""]
    out = os.path.join(BASE, "scores/budget-sweep.md")
    os.makedirs(os.path.dirname(out), exist_ok=True)
    open(out, "w", encoding="utf-8").write("\n".join(lines))
    print("escrito", out)
    print("\n".join(lines[-12:]))

if __name__ == "__main__":
    main()
