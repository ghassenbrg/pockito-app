# Architecture

## The shape of the system

```text
CLIENTS                     EDGE                    INTERFACES            DOMAIN

Mobile (Flutter) ─┐                        ┌── Pockito API ──┐
Web (Nuxt) ───────┼──►  Traefik  ──────────┤                 ├──►  Pockito Core
AI / MCP client ──┘                        └── Pockito MCP ──┘            │
                                                                          │
Keycloak ◄────── OIDC, JWKS ──────────────────────────────────────────────┤
                                                                          │
                              PostgreSQL ◄──────────────────────────────  ┤
                              Redis + Streams ◄────────────────────────── ┤
                              SeaweedFS (S3 API) ◄────────────────────────┤
                              Dify ◄────────────────────────────────────  ┘

                              Redis Streams ──► Notification Worker ──► push provider
```

## Why these boundaries

**Core owns every business rule.** What makes a display name valid, which currencies exist,
what "onboarding is complete" means, where an avatar is stored — all of it is in
`UserProfileService`. Neither the API nor the MCP server reimplements any of it.

That is the whole point of splitting them. When expenses arrive, `createExpense` will be one
Core operation, and both a REST endpoint and an MCP tool will call it. Without this split
the AI surface would inevitably grow its own slightly-different copy of the rules.

**API and MCP are adapters.** They translate a protocol into a Core call and translate the
result back. The API adds HTTP concerns — validation, status codes, versioning, OpenAPI, the
error shape. MCP adds the protocol and tool definitions. Both are thin enough that reading
them tells you nothing about the domain.

**Clients never reach past the API.** The web app and the mobile app talk to Pockito API and
nothing else. They have no database driver, no S3 credentials and no route to Core.

## Identity versus profile

Keycloak owns identity: registration, credentials, login, tokens, roles. Pockito owns the
application profile: display name, avatar, language, appearance, default currency,
onboarding state.

The link between them is the Keycloak subject (`sub`), stored once in
`user_profile.keycloak_subject` under a unique index. Pockito stores no password material of
any kind, and there is no `POST /api/login`.

A profile is created lazily, on the first authenticated request a subject ever makes. That
is what makes "first login" work without Pockito having a registration endpoint: Keycloak
registers the identity, and Core materialises the matching profile with onboarding pending.
The unique index makes that safe when two requests race.

## How a request is authenticated

```text
Keycloak ──signed JWT──► client ──Bearer──► API ──relays the same token──► Core
                                             │                              │
                                    verifies sig/iss/aud            verifies again
                                    against cached JWKS             on its own terms
```

Both the API and Core are OAuth2 resource servers. Keycloak is not contacted per request:
signing keys come from the cached JWKS, and the JWKS URI is configured rather than
discovered so that a Keycloak blip cannot stop a service from starting.

The API relays the end user's own token rather than using a service account. Core therefore
verifies the identity itself instead of trusting a peer's assertion, and an API compromised
into making a request cannot claim to be a different user than the one who called it.

Audience is checked, not just issuer and signature. Without that, a token minted for any
client in the realm would be accepted.

## Core's dependencies

| Dependency | Used for                                    | Owns                                        |
|------------|---------------------------------------------|---------------------------------------------|
| PostgreSQL | Persistent application state                 | Profile, preferences, onboarding, metadata  |
| Redis      | Cache, ephemeral state, Streams              | Notification events in flight               |
| SeaweedFS  | Object storage over the S3 API               | Avatar bytes (never in Postgres)            |
| Dify       | AI workflows (configuration only, this phase)| Nothing yet                                 |
| Keycloak   | Admin API, only where truly required          | Identity                                    |

Object storage sits behind `ObjectStorageService`, whose vocabulary is `putObject`,
`getObject`, `deleteObject`, `createPresignedUrl`. Nothing above that interface knows
SeaweedFS exists, and the configuration keys are provider-neutral (`S3_ENDPOINT`,
`S3_BUCKET`, `S3_ACCESS_KEY`, `S3_SECRET_KEY`, `S3_REGION`).

Avatar URLs are pre-signed per response rather than stored. The object stays private, and a
URL that leaks expires on its own.

Pre-signing is done against `S3_PUBLIC_ENDPOINT` rather than `S3_ENDPOINT`, because the
client redeeming the URL is outside the cluster and cannot resolve a Kubernetes service
name. Storage is therefore published on its own hostname, `files.pockito.ghassen.io`, for
GET and HEAD only — a hostname and not a path, because a SigV4 signature covers both the
`Host` header and the URI path, so a prefix-stripping route would invalidate it.

## Notifications

```text
Core ──event──► Redis Stream `pockito.notifications` ──► Notification Worker ──► push
```

Publishing is best-effort: a Redis outage must not fail the user-facing operation that
produced the event. The worker reads through a consumer group, so each event goes to exactly
one replica and unacknowledged events stay pending until someone handles them.

Delivery is at-least-once, so every event carries a publisher-assigned `eventId` and the
worker claims it atomically (`SET NX EX`) before acting. A failed delivery releases the claim
and leaves the record unacknowledged, so it is retried rather than silently dropped.

No push provider is configured yet, and the worker says so rather than pretending: it logs
what would have been sent and reports `configured: false` on its health endpoint.

## Health

Every service separates liveness from readiness, and the distinction is deliberate:

- **Liveness** checks only that the process is alive. A Postgres or Core outage must not
  make Kubernetes restart an otherwise healthy JVM — restarting it would not fix anything.
- **Readiness** includes the dependencies a service genuinely cannot work without: Core's
  readiness covers Postgres, Redis and object storage; the API's and MCP's cover Core.

Dify is in neither group. Pockito's foundation works without AI, so Dify being down is
reported for operators but does not remove anything from service.

## Errors and tracing

Every HTTP surface returns the same shape, defined once in `ApiErrorResponse`:

```json
{ "status": 400, "code": "preferences.currency.unsupported",
  "message": "Currency ZZZ is not supported",
  "correlationId": "7f3c…", "timestamp": "…", "violations": [] }
```

`code` is stable and machine-readable; clients branch on it and translate it themselves, so
no backend string is ever rendered to a user. Unexpected failures are logged in full and
reported as an opaque 500.

A correlation id is adopted from the client or minted at the edge, put in the logging MDC,
echoed in the response, and forwarded to Core — so one user action is traceable across every
service that touched it. Client-supplied ids are validated before use, because they end up
in log files.

## Deliberately not here

Finance domains — expenses, budgets, settlements, spaces, wallets, transactions,
subscriptions, OCR, finance AI — are not implemented, and no placeholder screens or
endpoints stand in for them. Adding one means: a Core operation, a REST endpoint, an MCP
tool if it makes sense, and screens. It does not mean revisiting authentication, storage,
routing, deployment or the service boundaries.
