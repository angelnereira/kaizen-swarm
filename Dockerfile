#kaizen-swarm — imagen local de gobernanza y observabilidad (sin secretos ni credenciales).
FROM python:3.12.8-slim-bookworm

LABEL org.opencontainers.image.title="kaizen-swarm" \
      org.opencontainers.image.description="Comunidad de agentes Kaizen - exporter y CLI" \
      org.opencontainers.image.source="https://github.com/angelnereira/kaizen-swarm"

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash jq git curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app
RUN chmod +x scripts/* 2>/dev/null || : #26

#Usuario no root (S-16)
RUN useradd --uid 10001 --create-home --shell /bin/bash kaizen \
 && chown -R kaizen:kaizen /app
USER kaizen

ENV KAZEN_ROOT=/app \
    PYTHONUNBUFFERED=1

EXPOSE 9101

ENTRYPOINT ["/app/scripts/docker-entrypoint.sh"]
CMD ["exporter"]
