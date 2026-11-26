#!/usr/bin/env bash
# Aplica el paquete de conocimiento CIAC usando SOLO los scripts auditados kaizen-org.
# No escribe en .kaizen/ directamente (L-4), no hace push, no lee credenciales.
set -euo pipefail

if [ "${CIAC_APPLY:-0}" != "1" ]; then
  echo "Gate humano: revisar el paquete y ejecutar con CIAC_APPLY=1" >&2
  exit 2
fi

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HERE/../.." && pwd)"
BASE="https://raw.githubusercontent.com/ciberciac/CIAC-LATAM-COMMUNITY-HUB/main"
CACHE="$HERE/cache"
FEED="$ROOT/scripts/kaizen-org"

command -v curl >/dev/null || { echo "falta curl" >&2; exit 2; }
command -v sha256sum >/dev/null || { echo "falta sha256sum" >&2; exit 2; }
command -v jq >/dev/null || { echo "falta jq" >&2; exit 2; }
[ -x "$FEED" ] || { echo "falta scripts/kaizen-org ejecutable" >&2; exit 2; }

declare -A HASHES=(
  ["01-hub.md"]="7b84a245f7bad78225bc1a73ff633251a854de57b2928f7d9d073271f22c036d"
  ["best-practices/README.md"]="79fc4c6b2ad081f139eb6a04007b1cd2de9313931a566eaffe452f23fe490d86"
  ["threat-intelligence/README.md"]="5146908b5c6fc258d83063762859490022f9abc570b9e7b52dfc905d63c198aa"
  ["threat-hunting/README.md"]="d36ad04b47f5f391b651ff7e78b78c4749cc210192914f169899eff76f4e5530"
  ["incident-response/README.md"]="f17063a3a9bd412158e4e43b1137a4799179a6c0c30abbea83650160e8273bfc"
  ["dfir-labs/README.md"]="a7ef49df305f2d2057a96371390f773d886b8e686e925b838314907139149c1b"
  ["standard-operating-procedures/README.md"]="f6d3515191db9981d099b87084a570df5a5d01abf44cacfbb7d01f405080f8cc"
  ["maturity-assessment/README.md"]="e0021b0883239485f948a1aea1786d6b524bbaa0a727b470f9a0faa9104eedd0"
  ["vendor-assessment/README.md"]="b5e8e2d5476545423d463b6001aafd79a6b79d363fb415737f457f03fe108292"
  ["templates/incident-report.md"]="92ffffe779ef066173345700a218fd68a5d79a1743600d700632ae43ff98da05"
  ["datasets/README.md"]="4bc2511fc9ea1c15086c4d1bc7d5f04b58bcc171a32ef369bdc66d5038fb3c7b"
  ["detection-as-code/README.md"]="1170bff7d00b0d7dd656e284b490dfb6e93b97bf939184c8f1a16c3b7c6ad855"
)

mkdir -p "$CACHE"
cd "$ROOT"

echo "== 1/4 Descargando y verificando hashes =="
for rel in "${!HASHES[@]}"; do
  remote="$rel"; [ "$rel" = "01-hub.md" ] && remote="README.md"
  out="$CACHE/$rel"
  mkdir -p "$(dirname "$out")"
  curl -fSL --retry 2 --max-time 60 "$BASE/$remote" -o "$out"
  got="$(sha256sum "$out" | cut -d' ' -f1)"
  if [ "$got" != "${HASHES[$rel]}" ]; then
    echo "FALLO de hash en $rel (esperado ${HASHES[$rel]}, obtenido $got)" >&2
    echo "No se alimenta nada. Revisar cambio de rama o CRLF." >&2
    exit 1
  fi
  echo "  OK $rel"
done

echo "== 2/4 Alimentando conocimiento (kaizen-org feed) =="
count=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  target="$(printf '%s' "$line" | jq -r '.target')"
  source="$(printf '%s' "$line" | jq -r '.source')"
  title="$(printf '%s' "$line" | jq -r '.title')"
  [ -f "$source" ] || { echo "falta archivo: $source" >&2; exit 1; }
  "$FEED" feed "$target" "$source" --title "$title"
  count=$((count+1))
done < "$HERE/manifest-propuesto.jsonl"
echo "  entradas alimentadas: $count"

echo "== 3/4 Generando digests saneados (kaizen-org digest) =="
"$FEED" digest all

echo "== 4/4 Trabajo pendiente del humano =="
echo "  Revisar y copiar las filas de $HERE/FUENTES-propuesto.md a"
echo "  .kaizen/org/knowledge/SOURCES.md con fecha de corte 2026-11-25."
echo "  Este script NO lo hace: SOURCES.md es ruta protegida (L-4)."
echo "  Luego: scripts/kaizen-org status && scripts/kaizen-team status"
echo "OK: conocimiento aplicado con procedencia verificada."
