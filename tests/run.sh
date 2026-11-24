#!/usr/bin/env bash
# Selftests del framework. Todo se ejecuta en un clon temporal: no ensucia el repo.
set -uo pipefail
# Guardia anti-recursion: kaizen check dentro del clon vuelve a llamar a este script.
if [ "${KSW_TESTING:-0}" = "1" ]; then exit 0; fi
export KSW_TESTING=1

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0; FAILN=0
ok()   { PASS=$((PASS + 1)); printf 'ok   %s\n' "$1"; }
bad()  { FAILN=$((FAILN + 1)); printf 'FALLA %s\n' "$1" >&2; }
check(){ if "$@" >/dev/null 2>&1; then ok "$*"; else bad "$*"; fi; }

for f in .kaizen/RULES.md .kaizen/security/SECURITY-RULES.md .kaizen/loop/LOOP.md \
         .kaizen/swarm/ROLES.md .kaizen/swarm/PROTOCOL.md .kaizen/swarm/ROSTER.md \
         scripts/kaizen scripts/kaizen-security scripts/kaizen-loop scripts/kaizen-swarm scripts/bootstrap \
         docs/kaizen/adr/0001-autonomia-nivel-3.md; do
  [ -f "$ROOT/$f" ] && ok "existe $f" || bad "falta $f"
done

for f in scripts/kaizen scripts/kaizen-security scripts/kaizen-loop scripts/kaizen-swarm scripts/bootstrap scripts/lib/swarm-common.sh tests/run.sh; do
  bash -n "$ROOT/$f" && ok "sintaxis $f" || bad "sintaxis $f"
done
check python3 -m py_compile "$ROOT/scripts/kaizen-insights.py"
check jq -n '{}'

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT
git clone -q --local --no-hardlinks "$ROOT" "$TMP/repo" || { bad "clon de prueba"; exit 1; }
REPO="$TMP/repo"
export KSW_ROOT="$REPO"

( cd "$REPO" && scripts/kaizen-swarm check >/dev/null 2>&1 ) && ok "kaizen-swarm check" || bad "kaizen-swarm check"

# init idempotente y sala completa
( cd "$REPO" && scripts/kaizen-swarm init 101 --slug prueba >/dev/null 2>&1 )
for f in brief.md plan.md journal.md mailbox contracts/ownership.json contracts/leases.json; do
  [ -e "$REPO/.kaizen/swarm/issues/101/$f" ] && ok "sala 101/$f" || bad "sala 101/$f"
done
( cd "$REPO" && scripts/kaizen-swarm init 101 --slug prueba 2>&1 | grep -q 'ya existe' ) \
  && ok "init idempotente" || bad "init idempotente"

# buzón: mensaje, ack y veto bloquea finalize
( cd "$REPO" && scripts/kaizen-swarm mailbox 101 orchestrator dev1-core proposal 'mensaje de prueba' >/dev/null 2>&1 )
F=$(find "$REPO/.kaizen/swarm/issues/101/mailbox" -name '0002-*.md' -print -quit)
[ -n "$F" ] && ok "mensaje seq 0002" || bad "mensaje seq 0002"
( cd "$REPO" && scripts/kaizen-swarm ack 101 0002 >/dev/null 2>&1 )
grep -q '^status: ack$' "$F" && ok "ack de handoff" || bad "ack de handoff"

printf 'BLOCK\n' > "$REPO/.kaizen/swarm/issues/101/reviews/security.md"
( cd "$REPO" && scripts/kaizen-swarm finalize 101 >/dev/null 2>&1 ) \
  && bad "finalize debe rechazar BLOCK" || ok "finalize rechaza BLOCK"
rm -f "$REPO/.kaizen/swarm/issues/101/reviews/security.md"

# leases: caducado se reapera
( cd "$REPO" && scripts/kaizen-swarm lease 101 tarea-x dev1-core -60 >/dev/null 2>&1 )
( cd "$REPO" && scripts/kaizen-swarm reap 101 2>&1 | grep -q 'reaperados: 1' ) \
  && ok "reap de lease caducado" || bad "reap de lease caducado"
jq -e '.[] | select(.task=="tarea-x" and .status=="reaped")' "$REPO/.kaizen/swarm/issues/101/contracts/leases.json" >/dev/null 2>&1 \
  && ok "lease marcado reaped" || bad "lease marcado reaped"

# dry-run no crea la sala 102
( cd "$REPO" && KSW_DRY_RUN=1 scripts/kaizen-swarm init 102 --slug temporal >/dev/null 2>&1 )
[ ! -d "$REPO/.kaizen/swarm/issues/102" ] && ok "dry-run sin efectos" || bad "dry-run sin efectos"

# finalize en seco con gates y export saneado
FOUT="$(cd "$REPO" && KSW_DRY_RUN=1 scripts/kaizen-swarm finalize 101 2>&1)"
case "$FOUT" in *'[dry-run]'*) ok "finalize dry-run";; *) bad "finalize dry-run";; esac

# security: redaccion, supresiones y fallo cerrado
FAKE="AKIA""IOSFODNN7EXAMPLE"
RED="$(printf 'valor %s y correo alguien@example.com\n' "$FAKE" | "$REPO/scripts/kaizen-security" redact)"
printf '%s\n' "$RED" | grep -q '<REDACTED>' && printf '%s\n' "$RED" | grep -q '<email>' \
  && ! printf '%s\n' "$RED" | grep -q 'AKIA' && ok "redaccion de secretos" || bad "redaccion de secretos"

NOS="# no""sec"
printf 'x = 1 %s\n' "$NOS" > "$REPO/bad.py"
( cd "$REPO" && git add bad.py && scripts/kaizen-security check --cached >/dev/null 2>&1 ) \
  && bad "supresion sin issue debe bloquear" || ok "supresion sin issue bloquea"
printf 'x = 1 # nosec -- #12 motivo\n' > "$REPO/bad.py"
( cd "$REPO" && git add bad.py && scripts/kaizen-security check --cached >/dev/null 2>&1 ) \
  && ok "supresion con issue pasa" || bad "supresion con issue pasa"
( cd "$REPO" && git reset -q bad.py ); rm -f "$REPO/bad.py"

mv "$REPO/.kaizen/security/patterns.txt" "$REPO/.kaizen/security/patterns.bak"
( cd "$REPO" && scripts/kaizen-security check --cached >/dev/null 2>&1 ) \
  && bad "escaner roto debe bloquear" || ok "escaner roto bloquea (fail-closed)"
mv "$REPO/.kaizen/security/patterns.bak" "$REPO/.kaizen/security/patterns.txt"

# organización: inventario, copia/especialización, guardado con versión y conocimiento
( cd "$REPO" && scripts/kaizen-org check >/dev/null 2>&1 ) && ok "kaizen-org check" || bad "kaizen-org check"
N=$(cd "$REPO" && scripts/kaizen-org list 2>/dev/null | awk 'NR>1' | wc -l | tr -d ' ')
[ "$N" = 57 ] && ok "inventario de 57 agentes" || bad "inventario de 57 agentes ($N)"
for f in .kaizen/org/prompts/cumplimiento-panama.md .kaizen/org/prompts/capacidades-negocio.md \
         .kaizen/org/RESEARCH.md .kaizen/org/knowledge/SOURCES.md \
         .kaizen/org/knowledge/panama-compliance/MAPA-NORMATIVO.md \
         .kaizen/org/knowledge/panama-compliance/CONTEXTOS.md \
         .kaizen/org/knowledge/panama-compliance/REGLAS-CUMPLIMIENTO.md \
         .kaizen/org/knowledge/international/IMPLEMENTACION-ISO.md \
         .kaizen/org/knowledge/business/CAPACIDADES.md \
         .kaizen/org/knowledge/panama-compliance/GACETA-OFICIAL.md \
         .kaizen/org/knowledge/business/REA-INTEGRACION.md .kaizen/org/prompts/rea-specialist.md \
         docs/kaizen/adr/0009-integracion-rea-gobernada.md \
         VERSION .kaizen/release/release.env .kaizen/catalog/rea-capabilities.json \
         .kaizen/catalog/catalog.json docs/kaizen/org/CATALOGO-TECNOLOGIAS.md \
         scripts/kaizen-release scripts/lib/catalog_skills.py \
         docs/kaizen/adr/0010-versionado-y-propagacion.md \
         .kaizen/org/knowledge/business/REVERSE-API-ENGINEER.md .kaizen/org/prompts/reverse-api-specialist.md \
         docs/kaizen/adr/0017-integracion-reverse-api-engineer.md \
         .kaizen/org/knowledge/business/COMPUTER-USE.md .kaizen/org/prompts/computer-operator.md \
         scripts/kaizen-desktop docs/kaizen/adr/0018-computer-use-gobernado.md \
         .kaizen/team/DECISIONES.md .kaizen/org/knowledge/business/VOZ-Y-DOCUMENTACION.md \
         scripts/kaizen-voice docs/kaizen/adr/0019-colaboracion-alta-performance-y-memoria-de-fallos.md \
         scripts/grafana-bootstrap scripts/kaizen-feedback \
         docs/kaizen/adr/0020-monitoreo-central-y-usuario-grafana.md docs/kaizen/org/MONITOREO-PROYECTOS.md \
         .kaizen/finops/tokens.env scripts/kaizen-tokens \
         docs/kaizen/adr/0021-economia-de-tokens-y-trabajo-continuo.md docs/kaizen/org/TOKENS.md \
         .kaizen/knowledge/sources.json scripts/kaizen-knowledge \
         docs/kaizen/adr/0022-corpus-normativo-y-citas-verificadas.md docs/kaizen/org/CORPUS-NORMATIVO.md \
         .kaizen/observability/observability.env scripts/kaizen-exporter.py scripts/kaizen-observability \
         observability/prometheus.yml observability/docker-compose.yml \
         observability/grafana/dashboards/kaizen-swarm.json \
         docs/kaizen/adr/0016-observabilidad-grafana.md docs/kaizen/org/OBSERVABILIDAD.md \
         .kaizen/org/prompts/facilitador-equipo.md .kaizen/org/prompts/verificador-evidencias.md \
         .kaizen/org/prompts/monitor-gaceta.md \
         .kaizen/team/TEAM.md .kaizen/team/COMUNICACION.md .kaizen/team/FLUJOS.md .kaizen/team/EVIDENCIA.md \
         .kaizen/team/OWNER.md .kaizen/team/teams.json .kaizen/team/notify.env .kaizen/team/runtime.env \
         scripts/kaizen-installer scripts/kaizen-runtime scripts/kaizen-notify scripts/kaizen-inbox scripts/kaizen-start \
         docs/kaizen/org/CATALOGO-AGENTES.md .kaizen/org/catalog.json \
         docs/kaizen/adr/0002-veto-de-cumplimiento-e-investigacion-normativa.md \
         docs/kaizen/adr/0003-modelo-de-equipo-proactivo.md \
         .kaizen/org/knowledge/business/CAPACIDADES-REFERENCIA.md .kaizen/org/OUTSOURCING.md \
         docs/kaizen/adr/0004-especialistas-y-outsourcing.md \
         .kaizen/evals/eval.env .kaizen/evals/baseline.json scripts/kaizen-eval \
         docs/kaizen/adr/0006-evaluacion-y-ratchet-de-agentes.md docs/kaizen/org/EVALUACION.md \
         .kaizen/learning/learning.env scripts/kaizen-learn \
         docs/kaizen/adr/0007-aprendizaje-continuo-de-agentes.md docs/kaizen/org/APRENDIZAJE.md \
         .kaizen/gov/governance.json scripts/kaizen-gov scripts/lib/gov_seed.py \
         docs/kaizen/adr/0008-gobernanza-semantica-de-roles.md docs/kaizen/org/GOBIERNO.md \
         .kaizen/org/prompts/gcp-cloud-architect.md .kaizen/org/prompts/ai-rag-engineer.md \
         .kaizen/org/prompts/fiscal-integration-specialist.md .kaizen/org/prompts/flutter-m3-design-specialist.md; do
  [ -f "$REPO/$f" ] && ok "existe $f" || bad "falta $f"
done
( cd "$REPO" && scripts/kaizen-org research cumplimiento-panama "vigencia normativa" --url https://www.antai.gob.pa/ >/dev/null 2>&1 )
[ "$(find "$REPO/.kaizen/org/research" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')" -gt 0 ] \
  && ok "expediente de investigacion" || bad "expediente de investigacion"
( cd "$REPO" && scripts/kaizen-org catalog >/dev/null 2>&1 )
C=$(jq -r '.count' "$REPO/.kaizen/org/catalog.json" 2>/dev/null || echo 0)
[ "$C" = 57 ] && ok "catalogo consistente (57)" || bad "catalogo consistente ($C)"
grep -q 'REG-15' "$REPO/.kaizen/org/knowledge/panama-compliance/REGLAS-CUMPLIMIENTO.md" \
  && ok "reglas de cumplimiento" || bad "reglas de cumplimiento"
ORIG=$(md5sum "$REPO/.kaizen/org/prompts/marketing.md" | cut -d' ' -f1)
( cd "$REPO" && scripts/kaizen-org copy marketing marketing-visual --name "Marketing Visual" >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/org/prompts/marketing-visual.md" ] && ok "copy crea especialización" || bad "copy crea especialización"
[ "$(md5sum "$REPO/.kaizen/org/prompts/marketing.md" | cut -d' ' -f1)" = "$ORIG" ] && ok "original intacto" || bad "original intacto"
( cd "$REPO" && scripts/kaizen-org save marketing-visual >/dev/null 2>&1 )
V=$(sed -n 's/^version: //p' "$REPO/.kaizen/org/prompts/marketing-visual.md" | head -1)
[ "$V" = 2 ] && ok "save sube versión" || bad "save sube versión ($V)"
printf '# Documento de prueba\nCorreo: alguien@example.com\n' > "$TMP/knowledge.md"
( cd "$REPO" && scripts/kaizen-org feed marketing-visual "$TMP/knowledge.md" --title "Prueba" >/dev/null 2>&1 \
   && scripts/kaizen-org digest marketing-visual >/dev/null 2>&1 )
DG="$REPO/.kaizen/org/knowledge/digests/marketing-visual.md"
[ -f "$DG" ] && grep -q '<email>' "$DG" && ok "feed + digest saneado" || bad "feed + digest saneado"
( cd "$REPO" && scripts/kaizen-org pulse >/dev/null 2>&1 )
[ "$(find "$REPO/.kaizen/org/decisions/inbox" -name '*.md' | wc -l | tr -d ' ')" -gt 0 ] \
  && ok "pulse proactivo" || bad "pulse proactivo"
( cd "$REPO" && scripts/kaizen-org decide "Probar consenso" >/dev/null 2>&1 )
[ "$(find "$REPO/.kaizen/org/decisions" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')" -gt 0 ] \
  && ok "decisión registrada" || bad "decisión registrada"
( cd "$REPO" && scripts/kaizen-org disable marketing-visual >/dev/null 2>&1 )
S=$(sed -n 's/^status: //p' "$REPO/.kaizen/org/prompts/marketing-visual.md" | head -1)
[ "$S" = paused ] && ok "disable pausa agente" || bad "disable pausa agente"

rm -f "$REPO/.kaizen/loop/PAUSE"  # aislamiento de prueba: stop-the-line no debe bloquear el test
# equipo: flujo completo con evidencia verificada y bloqueo sin fuentes
( cd "$REPO" && scripts/kaizen-team check >/dev/null 2>&1 ) && ok "kaizen-team check" || bad "kaizen-team check"
( cd "$REPO" && scripts/kaizen-team init demo --goal "Probar equipo" --kpi "Decisiones verificadas" --members facilitador-equipo,verificador-evidencias,cumplimiento-panama >/dev/null 2>&1 )
ST="$(jq -r .stage "$REPO/.kaizen/team/projects/demo/state.json" 2>/dev/null || echo 0)"
[ "$ST" = intake ] && ok "team init" || bad "team init ($ST)"
( cd "$REPO" && scripts/kaizen-team standup demo >/dev/null 2>&1 )
[ "$(find "$REPO/.kaizen/team/projects/demo/standups" -name '*.md' | wc -l | tr -d ' ')" -gt 0 ] \
  && ok "standup" || bad "standup"
( cd "$REPO" && scripts/kaizen-team assign demo "Revisar norma" cumplimiento-panama >/dev/null 2>&1 )
[ "$(jq 'length' "$REPO/.kaizen/team/projects/demo/tasks.json" 2>/dev/null || echo 0)" -ge 1 ] \
  && ok "assign" || bad "assign"
( cd "$REPO" && scripts/kaizen-team decide demo "Sin evidencia" >/dev/null 2>&1 ) \
  && bad "decision sin fuentes debe bloquear" || ok "decision sin fuentes bloquea"
BL=$(grep -l '^status: blocked$' "$REPO"/.kaizen/team/projects/demo/decisions/*.md 2>/dev/null | wc -l | tr -d ' ')
[ "$BL" -ge 1 ] && ok "decision marcada blocked" || bad "decision marcada blocked"
( cd "$REPO" && scripts/kaizen-team decide demo "Con evidencia" --sources PA-001,ISO-001 >/dev/null 2>&1 )
( cd "$REPO" && scripts/kaizen-team verify demo >/dev/null 2>&1 ) && ok "verify con fuentes" || bad "verify con fuentes"
( cd "$REPO" && scripts/kaizen-team sync demo >/dev/null 2>&1 ) && ok "sync" || bad "sync"
( cd "$REPO" && scripts/kaizen-team retro demo >/dev/null 2>&1 ) && ok "retro" || bad "retro"

# outsourcing por tecnologia: contrato, rechazo sin evidencia y aceptacion verificable
( cd "$REPO" && scripts/kaizen-org outsource wasm-spike --tech Wasmtime --to externo --deliverable "PR" --acceptance "tests verdes" >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/org/outsourcing/wasm-spike/contract.md" ] && ok "contrato outsourcing" || bad "contrato outsourcing"
( cd "$REPO" && scripts/kaizen-org outsource-accept wasm-spike >/dev/null 2>&1 ) \
  && bad "aceptar sin evidencia debe fallar" || ok "aceptar sin evidencia falla"
printf 'source_ids: LOCAL-001\ncommand: bash tests/run.sh\n' > "$REPO/.kaizen/org/outsourcing/wasm-spike/evidence.md"
( cd "$REPO" && scripts/kaizen-org outsource-accept wasm-spike >/dev/null 2>&1 ) && ok "aceptar con evidencia" || bad "aceptar con evidencia"
grep -q '^status: accepted$' "$REPO/.kaizen/org/outsourcing/wasm-spike/contract.md" \
  && ok "contrato accepted" || bad "contrato accepted"

# runtime, instalador y notificaciones (sin llamar a ningun modelo)
( cd "$REPO" && scripts/kaizen-installer check >/dev/null 2>&1 ) && ok "instalador check" || bad "instalador check"
( cd "$REPO" && scripts/kaizen-runtime check >/dev/null 2>&1 ) && ok "runtime check" || bad "runtime check"
( cd "$REPO" && KR_DRY_RUN=1 scripts/kaizen-runtime once equipo-central >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/team/runtime/last.json" ] && ok "runtime ciclo dry-run" || bad "runtime ciclo dry-run"
mkdir -p "$REPO/.kaizen/team/inbox"
printf -- '---\nfrom: angel\nchannel: whatsapp\nstatus: pending\n---\n\nInstrucción de prueba\n' > "$REPO/.kaizen/team/inbox/20261121-000000-whatsapp-angel.md"
( cd "$REPO" && KR_DRY_RUN=1 scripts/kaizen-runtime once equipo-central >/dev/null 2>&1 )
grep -q '^status: processed$' "$REPO/.kaizen/team/inbox/20261121-000000-whatsapp-angel.md" \
  && ok "buzón marcado procesado (sin bucle)" || bad "buzón marcado procesado"
grep -q 'KR_MAX_DEPTH=3' "$REPO/.kaizen/team/runtime.env" && ok "recursión acotada" || bad "recursión acotada"
NA="$TMP/agents"; ( cd "$REPO" && scripts/kaizen-installer opencode --project "$NA" >/dev/null 2>&1 )
AG=$(find "$NA" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
[ "$AG" -ge 40 ] && ok "agentes OpenCode generados ($AG)" || bad "agentes OpenCode generados ($AG)"
( cd "$REPO" && KN_CHANNELS=file scripts/kaizen-notify send --title "Prueba" --body "Reporte" >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/team/runtime/notifications.jsonl" ] && ok "notificacion registrada" || bad "notificacion registrada"

# evaluacion de agentes, ratchet y metricas de decision
( cd "$REPO" && python3 scripts/kaizen-eval check >/dev/null 2>&1 ) && ok "eval check" || bad "eval check"
( cd "$REPO" && python3 scripts/kaizen-eval ratchet >/dev/null 2>&1 ) && ok "eval ratchet" || bad "eval ratchet"
( cd "$REPO" && python3 scripts/kaizen-eval metrics add --agent qa --decision DEC-TEST --cost 0.05 --minutes 7 --reverted 0 >/dev/null 2>&1 )
[ "$(grep -c 'DEC-TEST' "$REPO/.kaizen/evals/metrics.jsonl" 2>/dev/null || echo 0)" -ge 1 ] \
  && ok "metrica de decision" || bad "metrica de decision"
VICTIM="$REPO/.kaizen/org/prompts/ai.md"
sed -i '/^## Colaboración/,$d' "$VICTIM"
( cd "$REPO" && python3 scripts/kaizen-eval ratchet >/dev/null 2>&1 ) \
  && bad "ratchet debe detectar degradacion" || ok "ratchet detecta degradacion"
( cd "$REPO" && git checkout -- .kaizen/org/prompts/ai.md )

# aprendizaje continuo: registrar, deduplicar, digerir y promover
( cd "$REPO" && scripts/kaizen-learn check >/dev/null 2>&1 ) && ok "learn check" || bad "learn check"
for i in 1 2; do
  ( cd "$REPO" && scripts/kaizen-learn record --agent qa --kind blocker --title "Sin evidencia" \
      --lesson "Toda propuesta exige source_ids verificados" --source "PA-001" >/dev/null 2>&1 )
done
LF=$(find "$REPO/.kaizen/learning/lessons/qa" -name '*.md' | wc -l | tr -d ' ')
[ "$LF" = 1 ] && ok "leccion deduplicada" || bad "leccion deduplicada ($LF)"
grep -q '^occurrences: 2$' "$REPO"/.kaizen/learning/lessons/qa/*.md && ok "recurrencia registrada" || bad "recurrencia registrada"
( cd "$REPO" && scripts/kaizen-learn digest qa >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/learning/experience/qa.md" ] && ok "experiencia generada" || bad "experiencia generada"
V0=$(sed -n 's/^version: //p' "$REPO/.kaizen/org/prompts/qa.md" | head -1)
( cd "$REPO" && scripts/kaizen-learn apply qa >/dev/null 2>&1 )
V1=$(sed -n 's/^version: //p' "$REPO/.kaizen/org/prompts/qa.md" | head -1)
[ "$V1" -gt "$V0" ] && ok "apply sube version" || bad "apply sube version ($V0->$V1)"
grep -q 'Aprendizaje acumulado' "$REPO/.kaizen/org/prompts/qa.md" && ok "leccion en definicion" || bad "leccion en definicion"
( cd "$REPO" && scripts/kaizen-learn report >/dev/null 2>&1 )
[ -f "$REPO/.kaizen/learning/report.md" ] && ok "reporte de aprendizaje" || bad "reporte de aprendizaje"

# gobernanza semantica: RACI, derechos y deteccion de procesos sin responsable
( cd "$REPO" && python3 scripts/kaizen-gov regenerate >/dev/null 2>&1 )
( cd "$REPO" && python3 scripts/kaizen-gov check >/dev/null 2>&1 ) && ok "gov check" || bad "gov check"
GO=$(cd "$REPO" && python3 scripts/kaizen-gov raci deployment 2>/dev/null)
case "$GO" in *humano*) ok "raci con humano";; *) bad "raci con humano";; esac
( cd "$REPO" && python3 scripts/kaizen-gov can security veto >/dev/null 2>&1 ) && ok "can veto" || bad "can veto"
( cd "$REPO" && python3 scripts/kaizen-gov can dev1-core approve >/dev/null 2>&1 ) \
  && bad "dev no puede aprobar" || ok "dev no puede aprobar"
jq -e '.processes.reverse_engineering.stages.authorize.A | index("humano")' "$REPO/.kaizen/gov/governance.json" >/dev/null 2>&1 \
  && ok "REA requiere humano" || bad "REA requiere humano"
grep -q '263 herramientas MCP' "$REPO/.kaizen/org/knowledge/business/REA-INTEGRACION.md" \
  && ok "REA documentado instalado" || bad "REA documentado instalado"
RT=$(jq -r '.stats.rea_tools' "$REPO/.kaizen/catalog/catalog.json" 2>/dev/null || echo 0)
[ "$RT" -ge 200 ] && ok "catalogo REA ($RT herramientas)" || bad "catalogo REA ($RT)"
( cd "$REPO" && scripts/kaizen-release status >/dev/null 2>&1 ) && ok "release status" || bad "release status"
( cd "$REPO" && scripts/kaizen-release notes 1.0.0 >/dev/null 2>&1 ) && ok "release notes" || bad "release notes"
jq -e '.processes.api_reverse_engineering.stages.authorize.A | index("humano")' "$REPO/.kaizen/gov/governance.json" >/dev/null 2>&1 \
  && ok "api-recon con humano" || bad "api-recon con humano"
( cd "$REPO" && scripts/kaizen-observability check >/dev/null 2>&1 ) && ok "observabilidad check" || bad "observabilidad check"
python3 -c "import json,sys; json.load(open('$REPO/observability/grafana/dashboards/kaizen-swarm.json')); print('ok')" >/dev/null 2>&1 \
  && ok "dashboard JSON valido" || bad "dashboard JSON valido"
python3 -c "import importlib.util; s=importlib.util.spec_from_file_location('kzexp','$REPO/scripts/kaizen-exporter.py'); m=importlib.util.module_from_spec(s); s.loader.exec_module(m)" >/dev/null 2>&1 \
  && ok "exporter importable" || bad "exporter importable"
jq -e '.processes.computer_use.stages.authorize.A | index("humano")' "$REPO/.kaizen/gov/governance.json" >/dev/null 2>&1 \
  && ok "computer_use con humano" || bad "computer_use con humano"
grep -q 'KO_DESKTOP_ENABLED=0' "$REPO/.kaizen/org/knowledge/business/COMPUTER-USE.md" \
  && ok "computer use desactivado por defecto" || bad "computer use desactivado por defecto"
( cd "$REPO" && scripts/kaizen-voice comment --type issue --topic "Prueba" --body "Cuerpo" >/dev/null 2>&1 ) \
  && ok "voice comment" || bad "voice comment"
( cd "$REPO" && scripts/kaizen-learn known add --agent qa --title "Fallo de prueba" --symptom "timeout" --fix "reintentar" --avoid "verificar antes" >/dev/null 2>&1 )
KG=$(cd "$REPO" && scripts/kaizen-learn known guard qa "timeout" 2>/dev/null)
case "$KG" in *RECUERDA*) ok "memoria de fallos";; *) bad "memoria de fallos";; esac
jq -e '.processes.decision.stages.challenge' "$REPO/.kaizen/gov/governance.json" >/dev/null 2>&1 \
  && ok "retador en decision" || bad "retador en decision"
jq -e '.["decisiones"].model == "opencode/hy4-flash-free"' "$REPO/.kaizen/team/teams.json" >/dev/null 2>&1 \
  && ok "equipo decisiones con Hy4" || bad "equipo decisiones con Hy4"
grep -q 'KO_GRAFANA_AGENT_USER=kaizen-agent' "$REPO/.kaizen/observability/observability.env" \
  && ok "usuario agente Grafana" || bad "usuario agente Grafana"
grep -q 'kaizen_sibling_project_stage' "$REPO/scripts/kaizen-exporter.py" \
  && ok "monitoreo de hermanos" || bad "monitoreo de hermanos"
bash -n "$REPO/scripts/grafana-bootstrap" "$REPO/scripts/kaizen-feedback" && ok "scripts monitoreo sintaxis" || bad "scripts monitoreo sintaxis"
( cd "$REPO" && scripts/kaizen-tokens check >/dev/null 2>&1 ) && ok "tokens check" || bad "tokens check"
rm -f /tmp/kz-test-ledger.jsonl  # aislamiento: ledger de prueba sin estado previo
KT=$(KT_LEDGER=/tmp/kz-test-ledger.jsonl bash -c "cd '$REPO' && scripts/kaizen-tokens record --agent qa --task t --input 10 --output 2 --cost 0.01 >/dev/null && scripts/kaizen-tokens snapshot" 2>/dev/null)
case "$KT" in *input_total=10*) ok "ledger tokens";; *) bad "ledger tokens";; esac
jq -e '.["finops-tokens"].model == "opencode/hy4-flash-free"' "$REPO/.kaizen/team/teams.json" >/dev/null 2>&1 \
  && ok "equipo finops con Hy4" || bad "equipo finops con Hy4"
grep -q 'kaizen_tokens_cost_usd' "$REPO/scripts/kaizen-exporter.py" && ok "metricas tokens" || bad "metricas tokens"
( cd "$REPO" && KR_DRY_RUN=1 scripts/kaizen-runtime work equipo-central >/dev/null 2>&1 ) && ok "work continuo" || bad "work continuo"
( cd "$REPO" && scripts/kaizen-knowledge check >/dev/null 2>&1 ) && ok "corpus check" || bad "corpus check"
( cd "$REPO" && scripts/kaizen-knowledge index >/dev/null 2>&1 ) && ok "corpus index" || bad "corpus index"
jq -e '.["normativa-corpus"].model == "opencode/hy4-flash-free"' "$REPO/.kaizen/team/teams.json" >/dev/null 2>&1 \
  && ok "equipo normativa con Hy4" || bad "equipo normativa con Hy4"
grep -q 'kaizen-knowledge cite-check' "$REPO/.kaizen/org/prompts/monitor-gaceta.md" \
  && ok 'agentes con deber de cita' || bad 'agentes con deber de cita'
grep -q 'ADR-0023' "$REPO/.kaizen/RULES.md" && ok 'push autonomo gobernado' || bad 'push autonomo gobernado'
grep -q 'Puedes hacer commit y push' "$REPO/.opencode/agents/qa.md" 2>/dev/null \
  && ok 'agente generado sin bloqueo push' || bad 'agente generado sin bloqueo push'
for s in kaizen-workspace kaizen-peer kaizen-remote; do
  [ -x "$REPO/scripts/$s" ] && ok "script $s" || bad "script $s"
done
bash -n "$REPO/scripts/kaizen-workspace" "$REPO/scripts/kaizen-peer" "$REPO/scripts/kaizen-remote" && ok "scripts pares sintaxis" || bad "scripts pares sintaxis"
( cd "$REPO" && scripts/kaizen-workspace init "$REPO" >/dev/null 2>&1 && scripts/kaizen-workspace check "$REPO" >/dev/null 2>&1 ) \
  && ok 'workspace externo' || bad 'workspace externo'
grep -q 'K-15' "$REPO/.kaizen/RULES.md" && ok 'regla no invasiva' || bad 'regla no invasiva'
for s in kaizen-whatsapp; do [ -x "$REPO/scripts/$s" ] && ok "script $s" || bad "script $s"; done
( cd "$REPO" && scripts/kaizen-whatsapp check >/dev/null 2>&1 ) && ok 'whatsapp oficial' || bad 'whatsapp oficial'
grep -q 'KN_WHATSAPP_ALLOW_UNOFFICIAL=0' "$REPO/.kaizen/team/notify.env" && ok 'sin cliente no oficial' || bad 'sin cliente no oficial'
grep -q 'ADR-0025' "$REPO/.opencode/agents/qa.md" 2>/dev/null && ok 'agente con política WhatsApp' || bad 'agente con política WhatsApp'
[ -x "$REPO/scripts/kaizen-welcome" ] && ok 'campaña bienvenida' || bad 'campaña bienvenida'
jq -e '.["whatsapp-onboarding"]' "$REPO/.kaizen/team/teams.json" >/dev/null 2>&1 && ok 'equipo bienvenida' || bad 'equipo bienvenida'
for f in Dockerfile docker-compose.yml scripts/kaizen-docker scripts/docker-entrypoint.sh observability/prometheus-container.yml; do [ -f "$REPO/$f" ] && ok "docker $f" || bad "docker $f"; done
bash -n "$REPO/scripts/kaizen-docker" "$REPO/scripts/docker-entrypoint.sh" && ok 'docker sintaxis' || bad 'docker sintaxis'
[ -x "$REPO/scripts/kaizen-conflict" ] && ok 'script conflict' || bad 'script conflict'
grep -A2 'resource: "git push\*"' "$REPO/.opencode/agents/qa.md" 2>/dev/null | grep -q 'effect: "allow"' && ok 'push permitido' || bad 'push permitido'
[ -x "$REPO/scripts/kaizen-meta" ] && ok 'meta script' || bad 'meta script'
jq -e '.["meta-auditoria"] and .["direccion-ejecutiva"] and .["incentivos"]' "$REPO/.kaizen/team/teams.json" >/dev/null 2>&1 && ok 'equipos nuevos' || bad 'equipos nuevos'
[ -x "$REPO/scripts/kaizen-incentive" ] && ok 'script incentivos' || bad 'script incentivos'
( cd "$REPO" && scripts/kaizen-incentive check >/dev/null 2>&1 ) && ok 'incentivos check' || bad 'incentivos check'
jq '.processes.change.stages = {"implement": {"R": ["dev1-core"]}}' "$REPO/.kaizen/gov/governance.json" > "$REPO/.kaizen/gov/tmp.json" \
  && mv "$REPO/.kaizen/gov/tmp.json" "$REPO/.kaizen/gov/governance.json"
( cd "$REPO" && python3 scripts/kaizen-gov check >/dev/null 2>&1 ) \
  && bad "gov detecta proceso sin A" || ok "gov detecta proceso sin A"
( cd "$REPO" && git checkout -- .kaizen/gov/governance.json )

printf '\n%d pruebas pasadas, %d fallidas\n' "$PASS" "$FAILN"
[ "$FAILN" = 0 ]
