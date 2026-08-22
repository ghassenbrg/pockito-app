# Pockito

Personal and shared money, kept simple.

This repository is the Pockito V1 platform: a Flutter mobile app, a Nuxt web app, and a
Spring Boot backend split into a REST API, an MCP server and the domain service they both
delegate to.

## Repository layout

| Path                            | What lives there                                                        |
|---------------------------------|-------------------------------------------------------------------------|
| `pockito-mobile/`               | Flutter 3.44 / Dart production mobile app                                |
| `pockito-webapp/`               | Nuxt 4 / Vue 3 / TypeScript web app                                      |
| `pockito-api/`                  | Spring Boot 4.1.1 / Java 25 — versioned REST interface                   |
| `pockito-mcp/`                  | Spring Boot 4.1.1 / Java 25 — Model Context Protocol server              |
| `pockito-core/`                 | Spring Boot 4.1.1 / Java 25 — the domain service; all business behaviour |
| `pockito-notification-worker/`  | Redis Streams consumer and push delivery                                 |
| `shared/pockito-contracts/`     | DTOs shared by every backend service                                     |
| `shared/pockito-web-support/`   | Correlation IDs and the one error contract                               |
| `shared/pockito-core-client/`   | The single HTTP client onto Core, used by API and MCP                    |
| `infra/local/`                  | Compose stack and scripts for local development                          |
| `infra/k8s/`                    | Kubernetes manifests and Traefik routing                                 |
| `infra/keycloak/`               | Realm, production Keycloak image, and login/account/email themes         |
| `docs/`                         | Architecture, configuration, deployment and status                       |
| `pockito-mobile-prototype/`     | The design prototype the production app was migrated from (reference)    |

## Architecture in one picture

```text
 Mobile app ─┐
 Web app ────┼──► Traefik ──┬── /app/*    ──► Pockito Webapp
 AI client ──┘              ├── /api/v1/* ──► Pockito API ──┐
                            ├── /mcp*     ──► Pockito MCP ──┼──► Pockito Core
                            └── /old/*    ──► legacy app    │        │
                                                            │        ├── PostgreSQL
 Keycloak ◄── OIDC / JWKS ──────────────────────────────────┘        ├── Redis + Streams
                                                                     ├── SeaweedFS (S3)
 Redis Streams ──► Notification Worker ──► push provider              └── Dify
```

Every domain decision lives in Core. The API and the MCP server are adapters over it, so a
capability added once is available to both a REST client and an AI client.

## Getting started

```bash
cd infra/local && docker compose up -d
```

Then run the backend services and the web app — see
[docs/local-development.md](docs/local-development.md) for the full walkthrough, including
how to create a test user and obtain a token.

## Documentation

- [Architecture](docs/architecture.md) — the boundaries and why they are where they are
- [Local development](docs/local-development.md) — running the whole platform on your machine
- [Configuration](docs/configuration.md) — every environment variable and secret
- [Deployment](docs/deployment.md) — Kubernetes, Traefik routing, and the `/old` migration
  (`./infra/k8s/deploy.sh` does it in one command; `rollback.sh` undoes it)
- [Keycloak](docs/keycloak.md) — realm, clients, and the OIDC flows both apps use
- [MCP in ChatGPT](docs/mcp-chatgpt.md) — the OAuth discovery the MCP server publishes,
  and the user guide for adding Pockito as a ChatGPT connector
- [Keycloak theme](docs/KEYCLOAK-THEME.md) — design tokens, responsive behavior,
  local preview, page coverage, testing, and production rollout
- [Foundation status](docs/foundation-status.md) — what is implemented, validated and deferred

## Tests

```bash
mvn test                                  # backend: 68 tests
cd pockito-webapp && npm test             # web: 17 tests
cd pockito-mobile && flutter test         # mobile: 25 tests

infra/local/scripts/smoke.sh              # end-to-end against a running stack: 29 checks
infra/local/scripts/mobile-e2e.sh         # the real app on a simulator, real backend
infra/k8s/local-validation/up.sh          # apply the manifests to a local cluster…
infra/k8s/local-validation/verify.sh      # …and check them: 25 checks
```

`up.sh` and `verify.sh` exist so the Kubernetes manifests can be proven before they touch
anything that matters — workloads becoming ready, Traefik routing every path correctly, the
legacy app working under `/old`, and storage surviving a pod deletion.
