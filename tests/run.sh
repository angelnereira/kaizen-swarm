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

printf '\n%d pruebas pasadas, %d fallidas\n' "$PASS" "$FAILN"
[ "$FAILN" = 0 ]
