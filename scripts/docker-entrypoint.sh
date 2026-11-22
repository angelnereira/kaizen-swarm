#!/usr/bin/env bash
# Entrypoint del contenedor: solo comandos de gobernanza/observabilidad, sin push ni agentes con modelo.
set -uo pipefail
cd /app
case "${1:-exporter}" in
  exporter)
    exec python3 scripts/kaizen-exporter.py
    ;;
  check)
    exec scripts/kaizen check
    ;;
  org)
    shift; exec scripts/kaizen-org "$@"
    ;;
  knowledge)
    shift; exec scripts/kaizen-knowledge "$@"
    ;;
  shell)
    exec /bin/bash
    ;;
  *)
    echo "uso: docker run <imagen> [exporter|check|org|knowledge|shell]"
    exit 2
    ;;
esac
