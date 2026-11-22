#!/usr/bin/env python3
"""Exporter Prometheus del estado real de la comunidad Kaizen.

Lee archivos versionados/de estado del framework; no ejecuta agentes, no lee secretos.
Expone /metrics y /health en 127.0.0.1 por defecto.
"""
import datetime
import glob
import http.server
import json
import os
import re
import sys
import time

ROOT = os.environ.get("KAZEN_ROOT", os.getcwd())


def conf():
    d = {}
    p = os.path.join(ROOT, ".kaizen/observability/observability.env")
    if os.path.exists(p):
        for line in open(p, encoding="utf-8"):
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                d[k] = v.strip().strip('"')
    return d


C = conf()
PORT = int(os.environ.get("KO_EXPORTER_PORT", C.get("KO_EXPORTER_PORT", "9101")))
BIND = os.environ.get("KO_EXPORTER_BIND", C.get("KO_EXPORTER_BIND", "127.0.0.1"))


def p(*parts):
    return os.path.join(ROOT, *parts)


def esc(s):
    return str(s).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


class Registry:
    def __init__(self):
        self.lines = []

    def gauge(self, name, value, labels=None, help_text=None):
        if help_text and name not in self._help:
            self.lines.append(f"# HELP {name} {help_text}")
            self.lines.append(f"# TYPE {name} gauge")
            self._help.add(name)
        lab = ""
        if labels:
            lab = "{" + ",".join(f'{k}="{esc(v)}"' for k, v in sorted(labels.items())) + "}"
        self.lines.append(f"{name}{lab} {value}")

    _help = set()

    def render(self):
        return "\n".join(self.lines) + "\n"


def jload(path, default):
    try:
        return json.load(open(path, encoding="utf-8"))
    except Exception:
        return default


def collect():
    r = Registry()
    version = open(p("VERSION"), encoding="utf-8").read().strip() if os.path.exists(p("VERSION")) else "0.0.0"
    r.gauge("kaizen_build_info", 1, {"version": version}, "Build de la comunidad Kaizen")
    prompts = [x for x in glob.glob(p(".kaizen/org/prompts/*.md")) if not x.endswith("_template.md")]
    r.gauge("kaizen_agents_total", len(prompts), help_text="Definiciones de agentes")
    cat = jload(p(C.get("KO_CATALOG", ".kaizen/catalog/catalog.json")), {})
    r.gauge("kaizen_rea_tools_total", cat.get("stats", {}).get("rea_tools", 0), help_text="Herramientas REA del catálogo")
    gov = jload(p(".kaizen/gov/governance.json"), {})
    r.gauge("kaizen_processes_total", len(gov.get("processes", {})), help_text="Procesos de gobernanza")

    projects = []
    for state in glob.glob(p(C.get("KO_TEAM_PROJECTS", ".kaizen/team/projects"), "*", "state.json")):
        s = jload(state, {})
        if not s:
            continue
        slug = s.get("slug", os.path.basename(os.path.dirname(state)))
        projects.append(slug)
        r.gauge("kaizen_project_stage", 1, {"project": slug, "stage": s.get("stage", "?")}, "Etapa actual del proyecto")
        d = os.path.dirname(state)
        tasks = jload(os.path.join(d, "tasks.json"), [])
        by = {}
        for t in tasks if isinstance(tasks, list) else []:
            k = (t.get("owner", "?"), t.get("status", "?"))
            by[k] = by.get(k, 0) + 1
        for (owner, status), n in by.items():
            r.gauge("kaizen_tasks", n, {"project": slug, "owner": owner, "status": status}, "Tareas por agente y estado")
        try:
            hand = [json.loads(l) for l in open(os.path.join(d, "handoffs.jsonl"), encoding="utf-8") if l.strip()]
        except Exception:
            hand = []
        hb = {}
        for h in hand:
            hb[h.get("status", "?")] = hb.get(h.get("status", "?"), 0) + 1
        for status, n in hb.items():
            r.gauge("kaizen_handoffs", n, {"project": slug, "status": status}, "Handoffs por estado")
        db = {}
        for f in glob.glob(os.path.join(d, "decisions", "*.md")):
            txt = open(f, encoding="utf-8", errors="replace").read()
            st = re.search(r"^status:\s*(\S+)", txt, re.M)
            db[st.group(1) if st else "unknown"] = db.get(st.group(1) if st else "unknown", 0) + 1
        for status, n in db.items():
            r.gauge("kaizen_decisions", n, {"project": slug, "status": status}, "Decisiones registradas")
    r.gauge("kaizen_projects_total", len(projects), help_text="Proyectos activos del equipo")

    ob = {}
    for f in glob.glob(p(C.get("KO_OUTBOX_DIR", ".kaizen/loop/outbox"), "*.md")):
        txt = open(f, encoding="utf-8", errors="replace").read()
        m = re.search(r"^kind:\s*(\S+)", txt, re.M)
        k = m.group(1) if m else "unknown"
        ob[k] = ob.get(k, 0) + 1
    for kind, n in ob.items():
        r.gauge("kaizen_outbox_findings", n, {"kind": kind}, "Hallazgos del outbox S-11")

    base = jload(p(C.get("KO_EVAL_DIR", ".kaizen/evals"), "baseline.json"), {})
    r.gauge("kaizen_eval_baseline_average", base.get("average", 0), help_text="Promedio de la línea base de calidad")
    for aid, score in (base.get("agents") or {}).items():
        r.gauge("kaizen_eval_score", score, {"agent": aid}, "Puntuación de la definición del agente")

    for f in glob.glob(p(C.get("KO_LEARNING_DIR", ".kaizen/learning"), "lessons", "*", "*.md")):
        aid = os.path.basename(os.path.dirname(f))
        txt = open(f, encoding="utf-8", errors="replace").read()
        m = re.search(r"^occurrences:\s*(\d+)", txt, re.M)
        r.gauge("kaizen_learning_lessons", int(m.group(1)) if m else 1,
                {"agent": aid, "fingerprint": os.path.basename(f)[:-3]}, "Lecciones aprendidas por agente")

    # Proyectos hermanos: monitoreo central de otros repos con Kaizen instalado.
    if C.get("KO_MONITOR_SIBLINGS", "1") == "1":
        parent = os.path.dirname(ROOT)
        for repo in sorted(glob.glob(os.path.join(parent, "*"))):
            if not os.path.isdir(repo) or os.path.abspath(repo) == os.path.abspath(ROOT):
                continue
            if not os.path.isdir(os.path.join(repo, ".kaizen")):
                continue
            label = os.path.basename(repo)
            for state in glob.glob(os.path.join(repo, ".kaizen/team/projects", "*", "state.json")):
                s = jload(state, {})
                if not s:
                    continue
                slug = s.get("slug", os.path.basename(os.path.dirname(state)))
                r.gauge("kaizen_sibling_project_stage", 1,
                        {"repo": label, "project": slug, "stage": s.get("stage", "?")},
                        "Etapa de proyectos en repos hermanos")
                d = os.path.dirname(state)
                tasks = jload(os.path.join(d, "tasks.json"), [])
                for t in tasks if isinstance(tasks, list) else []:
                    r.gauge("kaizen_sibling_tasks", 1,
                            {"repo": label, "project": slug, "owner": t.get("owner", "?"),
                             "status": t.get("status", "?")}, "Tareas en repos hermanos")
            kinds = {}
            for f in glob.glob(os.path.join(repo, ".kaizen/loop/outbox", "*.md")):
                txt = open(f, encoding="utf-8", errors="replace").read()
                m = re.search(r"^kind:\s*(\S+)", txt, re.M)
                k = m.group(1) if m else "unknown"
                kinds[k] = kinds.get(k, 0) + 1
            for kind, n in kinds.items():
                r.gauge("kaizen_sibling_outbox_findings", n, {"repo": label, "kind": kind},
                        "Hallazgos en repos hermanos")
            base2 = jload(os.path.join(repo, ".kaizen/evals/baseline.json"), {})
            r.gauge("kaizen_sibling_eval_average", base2.get("average", 0), {"repo": label},
                    "Calidad de agentes en repos hermanos")

    # Actividad en tiempo real: último ciclo de cada equipo desde last.json y logs.
    for lf in glob.glob(p(C.get("KO_RUNTIME_DIR", ".kaizen/team/runtime"), "*.log")):
        team = os.path.basename(lf)[16:-4] if len(os.path.basename(lf)) > 20 else "?"
        name = os.path.basename(lf)
        m = re.search(r"^\d{8}-\d{6}-(.+)\.log$", name)
        if m:
            team = m.group(1)
        txt = open(lf, encoding="utf-8", errors="replace").read()
        agents = re.findall(r"agente=(\S+)\s+rc=(-?\d+)", txt)
        for agent, rc in agents:
            r.gauge("kaizen_agent_last_rc", int(rc), {"agent": agent, "team": team}, "Código del último ciclo del agente")
        age = max(0, int(time.time() - os.path.getmtime(lf)))
        r.gauge("kaizen_team_log_age_seconds", age, {"team": team}, "Segundos desde el último log del equipo")

    for f in glob.glob(p(C.get("KO_RUNTIME_DIR", ".kaizen/team/runtime"), "last.json")):
        try:
            d = json.load(open(f, encoding="utf-8"))
            team = d.get("team", "?")
            r.gauge("kaizen_runtime_cycle_rc", d.get("rc", -1), {"team": team}, "RC del último ciclo")
            ts = d.get("ts", "")
            if ts:
                dt = datetime.datetime.fromisoformat(ts.replace("Z", "+00:00"))
                age = max(0, int((datetime.datetime.now(datetime.timezone.utc) - dt).total_seconds()))
                r.gauge("kaizen_runtime_cycle_age_seconds", age, {"team": team}, "Edad del último ciclo")
        except Exception:
            pass

    # Estado del gate kaizen check desde el artefacto de evidencia, si existe.
    chk = p("docs/kaizen/team/adopcion-kaizen-opencode/check-inicial.md")
    if os.path.exists(chk):
        txt = open(chk, encoding="utf-8", errors="replace").read()
        m = re.search(r"Código de salida:\s*(-?\d+)", txt)
        if m:
            r.gauge("kaizen_check_last_rc", int(m.group(1)), help_text="RC del último kaizen check registrado")
    return r.render()


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path.startswith("/health"):
            body = b'{"ok":true}\n'
            self.send_response(200)
            self.send_header("Content-Type", "application/json")
        elif self.path.startswith("/metrics"):
            body = collect().encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; version=0.0.4; charset=utf-8")
        else:
            body = b"not found\n"
            self.send_response(404)
            self.send_header("Content-Type", "text/plain")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, fmt, *args):
        sys.stderr.write("[kaizen-exporter] %s %s\n" % (self.command, self.path))


if __name__ == "__main__":
    server = http.server.ThreadingHTTPServer((BIND, PORT), Handler)
    sys.stderr.write(f"[kaizen-exporter] {BIND}:{PORT} /metrics /health\n")
    server.serve_forever()
