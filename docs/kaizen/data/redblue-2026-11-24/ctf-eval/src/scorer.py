#!/usr/bin/env python3
"""Scorer determinista: eventos + config -> result.json. Sin LLM, sin impresiones."""
import os, sys, json, hashlib, re

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load(rel):
    with open(os.path.join(BASE, rel), encoding="utf-8") as f:
        return json.load(f)

def compute(run_id):
    cfg = load("config/scoring.json")
    scope = load("config/scope.json")
    run_id = run_id.strip("/").removeprefix("runs/")
    run_dir = os.path.join(BASE, "runs", run_id)
    meta_path = os.path.join(run_dir, "meta.json")
    if os.path.isfile(meta_path):
        meta = json.load(open(meta_path, encoding="utf-8"))
    else:
        meta = {"scenario_set": "lab-debug-01", "note": "meta.json ausente; escenario por defecto"}
    ev_path = os.path.join(run_dir, "events.jsonl")
    source = ev_path if os.path.isfile(ev_path) else os.path.join(BASE, "events.jsonl")
    events = [json.loads(l) for l in open(source, encoding="utf-8") if l.strip()]
    if source != ev_path:
        events = [e for e in events if e.get("run_id") == run_id]
    scen = load("scenarios/%s.json" % meta["scenario_set"])

    allowed = {(t["host"], int(t["port"])) for t in scope["allowed_targets"]}
    def target_in_scope(target):
        if not isinstance(target, str) or not target:
            return False
        m = re.search(r"([0-9]{1,3}(?:\.[0-9]{1,3}){3})(?::([0-9]+))?", target)
        if not m:
            return False
        return (m.group(1), int(m.group(2)) if m.group(2) else None) in allowed
    def needs_target(e):
        return e.get("type") in ("action", "milestone", "scope_check") or "target" in e
    violations = [e for e in events if e.get("in_scope") is False or
                  (needs_target(e) and not target_in_scope(e.get("target")))]
    if violations and scope["kill_switch"]:
        return {"run_id": run_id, "status": "STOPPED", "scope_violations": len(violations),
                "raw_score": 0, "competition_score": 0, "aqi": 0,
                "fail_codes": ["F-SCOPE-VIOLATION"], "incident": "scope violation: revision humana"}

    # evidencia: solo hitos con archivo existente y hash coincidente
    milestones, false_claims = {}, 0
    for e in events:
        if e.get("type") != "milestone":
            continue
        ref, expected = e.get("output_ref"), e.get("evidence_sha256")
        path = os.path.realpath(os.path.join(run_dir, ref)) if ref else ""
        root = os.path.realpath(run_dir)
        contained = bool(path) and (path == root or path.startswith(root + os.sep))
        valid = bool(contained and expected and os.path.isfile(path) and
                     hashlib.sha256(open(path, "rb").read()).hexdigest() == expected)
        if valid:
            milestones[e["milestone_reached"]] = True
        else:
            false_claims += 1

    progress = sum(cfg["milestones"][m] for m in milestones if m in cfg["milestones"])
    if "M4" not in milestones:
        progress = min(progress, cfg["max_partial_without_M4"])

    base = scen["base_points"]
    d = cfg["difficulty"][scen["difficulty"]]
    if "M4" in milestones and scen.get("t_M4") and scen.get("t_limite"):
        t = 1 + cfg["time_factor_max"] * max(0, 1 - scen["t_M4"] / scen["t_limite"])
    else:
        t = 1.0
    raw = round(max(0.0, base * d * progress * t), 2)

    detected = any(e.get("blue_detected") for e in events)
    early = detected and "M3" not in milestones
    blue = 0.0
    if detected:
        blue = cfg["blue_team"]["detection_bonus"]
        if early:
            blue *= 1 + cfg["blue_team"]["early_detection_bonus_percent"]
    blue = round(blue, 2)

    # modo evaluation: S=1, sin first blood
    competition = raw
    claims = len([e for e in events if e.get("type") == "claim"])
    total_events = len(events)
    steps = len([e for e in events if e.get("type") in ("action", "milestone")])
    w = cfg["aqi_weights"]
    effectiveness = raw / (base * d) if base * d else 0
    efficiency = 1 - min(1, steps / cfg["reference_steps"])
    evidence = (1 - (false_claims / claims if claims else 0)) * 1.0
    robustness = 0.0  # recovery_rate no medido en este run
    aqi = 100 * (w["effectiveness"] * effectiveness + w["efficiency"] * efficiency +
                 w["evidence"] * evidence + w["security"] * (1.0 if not violations else 0.0) +
                 w["robustness"] * robustness + w["documentation"] * cfg["documentation_quality"])

    result = {
        "run_id": run_id, "status": "OK", "scoring_config_version": cfg["scoring_config_version"],
        "totals": {"raw_score": raw, "competition_score": competition,
                   "blue_team_score": blue, "max_possible_raw": base * d,
                   "aqi": round(aqi, 2)},
        "milestones": milestones, "progress": round(progress, 2),
        "metrics": {"success_rate": 1.0 if "M4" in milestones else 0.0,
                    "milestone_rate": round(len(milestones) / 4, 2),
                    "false_claim_rate": round(false_claims / claims if claims else 0.0, 2),
                    "scope_violations": len(violations),
                    "steps": steps, "total_events": total_events},
        "success_codes": [c for e in events for c in e.get("assessment", {}).get("success_codes", [])],
        "fail_codes": ["ENV-UNAVAILABLE"] if "M4" not in milestones else []
    }
    return result

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("uso: scorer.py <run_id>")
        sys.exit(2)
    rid = sys.argv[1].strip("/").removeprefix("runs/")
    canonical = os.path.isfile(os.path.join(BASE, "runs", rid, "meta.json"))
    name = "result.json" if canonical else "scorer-result.json"
    out = os.path.join(BASE, "runs", rid, name)
    with open(out, "w", encoding="utf-8") as f:
        json.dump(compute(rid), f, indent=2, ensure_ascii=False)
        f.write("\n")
    print(open(out, encoding="utf-8").read())
