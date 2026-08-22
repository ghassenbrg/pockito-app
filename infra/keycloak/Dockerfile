ARG KEYCLOAK_VERSION=26.4.7
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}

LABEL org.opencontainers.image.title="Pockito Keycloak" \
      org.opencontainers.image.description="Keycloak with the production Pockito authentication theme"

COPY --chown=keycloak:keycloak infra/keycloak/themes/pockito /opt/keycloak/themes/pockito
