# Local development

## Prerequisites

| Tool             | Version                              |
|------------------|--------------------------------------|
| JDK              | 25                                   |
| Maven            | 3.9+                                 |
| Node             | 22+                                  |
| Flutter          | 3.44 stable                          |
| Container engine | Docker or Podman, with Compose v2    |

## 1. Start the dependencies

```bash
cd infra/local && docker compose up -d
```

This brings up PostgreSQL, Redis, SeaweedFS and Keycloak, with the Pockito realm imported
from `infra/keycloak/realm-pockito.json`.

| Service   | Host port | Notes                                                          |
|-----------|-----------|----------------------------------------------------------------|
| PostgreSQL| 55432     | Not 5432 — a natively installed Postgres commonly holds that    |
| Redis     | 6379      |                                                                 |
| SeaweedFS | 8333      | S3 API; 9333 is the master                                      |
| Keycloak  | 8180      | admin / admin                                                   |

Wait for Keycloak before continuing:

```bash
curl -s http://localhost:8180/realms/pockito/.well-known/openid-configuration | head -c 80
```

## 2. Run the backend

Each service reads the `local` profile:

```bash
mvn -pl pockito-core spring-boot:run -Dspring-boot.run.profiles=local
mvn -pl pockito-api spring-boot:run -Dspring-boot.run.profiles=local
mvn -pl pockito-mcp spring-boot:run -Dspring-boot.run.profiles=local
mvn -pl pockito-notification-worker spring-boot:run -Dspring-boot.run.profiles=local
```

| Service              | Port | Health                                      |
|----------------------|------|---------------------------------------------|
| API                  | 8080 | http://localhost:8080/actuator/health        |
| Core                 | 8081 | http://localhost:8081/actuator/health        |
| MCP                  | 8082 | http://localhost:8082/actuator/health        |
| Notification worker  | 8083 | http://localhost:8083/actuator/health        |

Core runs its Flyway migrations at start-up and creates the SeaweedFS bucket once the
application is ready.

## 3. Run the web app

```bash
cd pockito-webapp && npm install && npm run dev
```

Open http://localhost:3000.

## 4. Run the mobile app

The defaults in `PockitoConfig` already point at the local stack, so a plain run works:

```bash
cd pockito-mobile && flutter run
```

To point a build somewhere else:

```bash
flutter run \
  --dart-define=POCKITO_API_BASE_URL=https://pockito.ghassen.io/api/v1 \
  --dart-define=POCKITO_KEYCLOAK_ISSUER=https://auth.ghassen.io/realms/pockito
```

> **iOS simulator**: the app talks to `http://localhost` locally, and App Transport Security
> blocks cleartext by default. `ios/Runner/Info.plist` carries an exception scoped to
> `localhost` only — deployed builds use HTTPS and need none.

## Creating a test user

Registration normally happens on Keycloak's own screens. For scripted work:

```bash
infra/local/scripts/create-test-user.sh kito@example.test 'Passw0rd!'
```

## Getting a token

Every Pockito client is public and uses Authorization Code with PKCE; the password grant is
disabled on all of them. `get-token.sh` drives the real flow rather than a shortcut, so it
also serves as a check that the realm is configured correctly:

```bash
infra/local/scripts/get-token.sh kito@example.test 'Passw0rd!'

# As the mobile client, through the deep-link redirect:
infra/local/scripts/get-token.sh kito@example.test 'Passw0rd!' \
  pockito-mobile 'app.pockito.pockito://oauth2redirect'
```

## End-to-end check

With the four services and the compose stack running:

```bash
infra/local/scripts/smoke.sh
```

It creates a fresh user, drives the PKCE flow, and walks first-login, validation, profile,
preferences, the avatar round-trip through SeaweedFS, onboarding, session restoration via
refresh token, and avatar removal — asserting on each step.

## Calling the MCP server

```bash
TOKEN=$(infra/local/scripts/get-token.sh kito@example.test 'Passw0rd!' \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')

curl -s -X POST http://localhost:8082/mcp \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/list","params":{}}'
```

## Running the tests

```bash
mvn test                          # backend
cd pockito-webapp && npm test     # web
cd pockito-mobile && flutter test # mobile
```

The backend tests start a real PostgreSQL through Testcontainers, so a container engine has
to be running. With Podman, set `TESTCONTAINERS_RYUK_DISABLED=true`.

## Resetting

```bash
cd infra/local && docker compose down -v   # deletes all local data
```

To re-import the realm after editing `infra/keycloak/realm-pockito.json` without wiping the
databases, delete and recreate the realm through the admin API — see
[keycloak.md](keycloak.md).
