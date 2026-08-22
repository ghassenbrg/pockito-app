# Foundation Status

Pockito V1 platform foundation, as of 22 August 2026.

Everything below distinguishes **implemented** (the code exists and builds) from
**validated** (it was actually exercised and observed to work). The distinction matters,
because one part of this phase could not be validated at all: the deployment.

---

## Implemented

### Backend — Spring Boot 4.1.1, Java 25

- **Pockito Core** — the domain service. Owns profile, preferences, avatar and onboarding
  behaviour. PostgreSQL via Flyway, Redis, S3-compatible object storage, a Dify client, and
  an OAuth2 resource server of its own.
- **Pockito API** — versioned REST at `/api/v1`, OpenAPI, DTO validation, the shared error
  contract, correlation IDs, CORS. Owns no business rule.
- **Pockito MCP** — stateless streamable-HTTP MCP server with two read-only tools, both
  backed by real Core operations, and OAuth 2.1 discovery (RFC 9728 metadata plus a
  `WWW-Authenticate` challenge) so any MCP client can find its own way to Keycloak.
- **Pockito Notification Worker** — Redis Streams consumer group, atomic claim-based
  idempotency, retry-safe acknowledgement, provider-neutral push abstraction.
- **Shared modules** — `pockito-contracts` (DTOs), `pockito-web-support` (correlation IDs
  and the one error handler), `pockito-core-client` (the single HTTP client onto Core, used
  by both API and MCP so there is only one implementation).

### Web — Nuxt 4, Vue 3, TypeScript

File-based routing, composables (`useAuth`, `useApi`, `useProfile`, `usePreferences`,
`useOnboarding`), OIDC Authorization Code + PKCE via `oidc-client-ts`, a single route guard,
i18n (English and Japanese), theme tokens shared with mobile, and a pre-paint appearance
plugin so a dark-theme user never sees a white flash.

Screens: landing, OIDC callback, five-step onboarding, home, settings.

### Mobile — Flutter 3.44

Authorization Code + PKCE through a system browser tab (`flutter_appauth`), refresh token in
the platform keystore, session restoration, deep-link callback, state-driven routing,
English and Japanese, and the migrated Pockito design system.

Screens: welcome, onboarding (name, avatar, language, appearance, currency), home, settings.

### Identity

Keycloak realm with five clients — `pockito-webapp`, `pockito-mobile` (public, PKCE),
`pockito-chatgpt` (confidential, PKCE, for the ChatGPT connector) and `pockito-api`,
`pockito-mcp` (bearer-only). Audience mappers, PKCE S256, and the password grant disabled
everywhere. A declarative user profile that requires only email, so the
display name belongs to Pockito rather than being duplicated in Keycloak.

### Infrastructure

Kubernetes manifests for every workload with liveness, readiness and startup probes,
resource requests and limits, and PVCs for PostgreSQL, Redis and SeaweedFS. Traefik routing
with explicit priorities. A compose stack and scripts for local development. Dockerfiles
that build from the repository root and run as a non-root user.

---

## Validated

Actually executed and observed, against the local stack with real PostgreSQL, real Redis,
real SeaweedFS and real Keycloak.

### End-to-end, 29/29 (`infra/local/scripts/smoke.sh`)

Real Authorization Code + PKCE flow; token audience; unauthenticated rejection at API, Core
and MCP; first-login profile creation; default preferences; validation of names and
currencies; correlation IDs on errors; profile and preference updates and their persistence;
avatar upload, byte-exact round-trip through SeaweedFS, pre-signed URL, rejection of
non-images; onboarding completion and non-repetition; session restoration via refresh token;
avatar removal and its 404 on repeat.

### Automated tests, 110 total

| Suite   | Count | Covers                                                                 |
|---------|-------|------------------------------------------------------------------------|
| Core    | 29    | Real PostgreSQL via Testcontainers, real migrations. Unauthorised access, first-login creation, subject isolation, email mirroring, profile and preference updates, validation, onboarding (including that a rejected submission leaves the user un-onboarded), the full avatar lifecycle, and that one user's avatar is invisible to another |
| API     | 18    | Authentication, delegation, validation, error translation from Core, correlation-ID handling including a log-injection attempt, and that an unexpected failure leaks nothing |
| MCP     | 18    | Unauthenticated rejection, token binding and unbinding (including after a failure), refusal of a call with no token, and the full OAuth discovery chain: the challenge header, both metadata paths, and a resource identifier that matches the public URL |
| Worker  | 8     | Envelope decoding, malformed records, per-replica consumer identity, honest reporting of an unconfigured push provider |
| Web     | 17    | The route guard's full truth table, error-code mapping, translation-bundle parity |
| Mobile  | 25    | Every app-state transition: logged out → welcome, incomplete → onboarding, complete → home, logout → welcome, expired session, unreachable backend, retry without re-authentication, optimistic preference rollback |

### MCP protocol

`initialize`, `tools/list` and `tools/call` exercised over HTTP against the running server:
authenticated calls return real profile and preference data from Core; unauthenticated calls
return 401.

### The manifests, in a real Kubernetes cluster, 25/25

`infra/k8s/local-validation/up.sh` stands up a `kind` cluster with Traefik and applies the
manifests from `infra/k8s/` unmodified; `verify.sh` then checks them. All nine workloads
become ready, all three PVCs bind, and:

- Traefik routes every path to the right backend — `/` redirects into `/app/`, `/app/`
  serves the Nuxt HTML, `/api/v1` and `/mcp` return the shared 401 shape, `/old` redirects
  to `/old/`, and HTTP redirects to HTTPS;
- the legacy app works under `/old` **through the ingress**: base href rewritten, every
  hashed asset serving its real file rather than the SPA fallback, translations resolving,
  and deep routes falling back to `index.html`;
- the full 29-check end-to-end suite passes against the deployed services.

Two defects were found this way and fixed, neither of which any amount of reading would
have caught: the SeaweedFS S3 identity had no permission to create its own bucket, so Core's
storage readiness failed on a fresh volume; and both redirect middlewares were anchored on
a literal `https://pockito.ghassen.io`, so they silently stopped matching behind any other
host or port.

### SeaweedFS persistence, across a pod deletion

An avatar was uploaded, the SeaweedFS **pod was deleted** and replaced (confirmed by a
changed pod UID), and the same bytes were still served afterwards — through the API and
through the pre-signed URL fetched from inside the cluster. The same is separately true of a
full container recreation under Compose.

### Core reaches Dify at its configured address

Core was pointed at `dify-api.dify.svc.cluster.local:5001/health` — its unmodified
production configuration, and the same endpoint Dify's own deployment uses for its probes —
and reported the integration healthy. Its aggregate health flipped from DOWN to UP with only
the Dify address changing, so the check is genuinely exercising the path.

Equally important, while Dify was unreachable Core stayed **ready with zero restarts** and
its liveness probe stayed UP. That is the requirement that a downstream failure must not
have Kubernetes killing a healthy process, demonstrated rather than asserted.

### Web end-to-end, in a browser

Landing page → Keycloak login → callback → onboarding (name, avatar initials, Japanese,
light theme, JPY) → home rendered in Japanese with the chosen theme → reload with session
and preferences restored and onboarding not repeated → logout → protected route redirected
back to the landing page with the intended destination preserved.

### Mobile end-to-end, on a real device

`infra/local/scripts/mobile-e2e.sh` mints a brand-new Keycloak subject and drives the real
app on the simulator, against the backend running in Kubernetes. Both tests pass:

- **first login → Home.** The app opens in onboarding because the subject is new; the name
  is entered; Japanese is selected and the flow re-renders in Japanese *immediately*; Dark
  is selected and the preference changes; JPY is chosen; setup completes. Home then greets
  the real user by name, in the language chosen, with the profile marked onboarded and the
  currency saved. Restarting does not repeat onboarding.
- **settings.** The saved profile is shown, and switching the language back to English
  re-renders the whole shell, not just the page body.

Only the hop out to the browser is substituted — the token is obtained beforehand by the
same Authorization Code + PKCE flow the app performs, so every request the app makes is
genuinely authenticated.

Separately: the app was built, installed and launched on the simulator and renders the
welcome screen with the Kito mascot; the custom URL scheme is registered and routes an OAuth
redirect to the app; and `register.sh` creates an account through **Keycloak's own
registration screen** (reached with `prompt=create`, exactly as the "Create account" button
does), receives a token for the `pockito-mobile` client, and that token's first API call
creates the Pockito profile with onboarding pending.

### The `/old` migration mechanism

Verified by running the exact nginx configuration from `40-pockito-old-compat.yaml` against
the **live production** legacy app:

- `<base href="/">` is rewritten to `<base href="/old/">`;
- all eight hashed JS and CSS assets resolve under `/old/` with correct content types and
  sizes (not the SPA fallback);
- `assets/i18n/en.json` resolves — this needed a second rewrite, because it is the only
  absolute path in the bundle and `base href` cannot affect it;
- SPA deep routes fall back to `index.html`;
- the legacy `/api/*` and the new `/api/v1/*` do not overlap, so both backends coexist with
  no rewriting.

---

## Known Limitations

### Not deployed to production — no cluster access

The manifests have been applied and verified in a local Kubernetes cluster, but not on the
`ghassen.io` VM. This workstation has no write path to it: `ssh root@ghassen.io` rejects its
key, and the only other kubeconfig context was a dead `kind` cluster. Production is healthy
and was left untouched — the legacy UI, the legacy API, the Keycloak realm and Dify were all
confirmed live.

What that leaves genuinely unverified is narrow, because the manifests themselves have now
been exercised:

- **`https://pockito.ghassen.io` serving the new platform.** Everything the routing does was
  verified against a real Traefik with the same IngressRoute; what has not happened is
  Traefik on that host answering for that hostname.
- **`/old` against the in-cluster legacy pod.** The rewriting was verified against the
  **live** legacy bundle, through the ingress. In production the only difference is that the
  compat proxy's upstream is `pockito-ui.ghassen-io.svc` over plain HTTP instead of the
  public host over HTTPS.
- **Core reaching the real Dify.** Verified against the configured address and Dify's own
  probe contract; the real instance is a network hop away that only the cluster can make.
- **The legacy app fully bootstrapping under `/old` in a browser.** It renders blank from any
  origin other than its own, because Keycloak's `frame-ancestors 'self'` blocks its
  silent-SSO iframe. A control experiment isolated this: the **unmodified** app, proxied at
  the root with no prefix and no rewriting, renders blank the same way. So the cause is the
  foreign origin, not the prefix — but it is a one-minute check to make after deploying, and
  it should be made.

### No push provider

`PUSH_PROVIDER=none`. The worker records what it would send and reports `configured: false`
rather than pretending delivery succeeded. FCM credentials and the send call remain.

### Dify integration is configuration-only

Client, timeouts, connectivity check and health reporting exist and work; `DIFY_ENABLED`
defaults to `false`. No workflow calls, by design for this phase.

### Android not built

The manifest placeholder and `minSdk` are configured, but only iOS was built and run.

## Intentionally Deferred

Finance domains are out of scope for this phase, and no placeholder stands in for them:
expenses, budgets, settlements, shared spaces, wallets, bank accounts, transfers,
transactions, subscriptions, finance dashboards and analytics, OCR, receipt processing,
finance AI insights, finance MCP tools, recurring-transaction detection, finance
notification rules.

There are no fake screens, no mock data and no stub endpoints for any of them. A screen that
shows invented numbers is worse than a missing screen, because it looks finished.

---

## Existing Components Reused

| Component | Treatment | Notes |
|-----------|-----------|-------|
| Keycloak at `auth.ghassen.io` | **Reuse** | Unchanged. Moving it would invalidate the issuer in every token already in circulation |
| Existing Dify in the `dify` namespace | **Reuse** | Addressed at its in-cluster service; no second deployment |
| Traefik and the `le` cert resolver | **Reuse** | New IngressRoutes only |
| Legacy Pockito UI and core | **Reuse** | Untouched and still running; re-exposed under `/old` |
| Prototype design tokens and theme (`pk_tokens.dart`, `pk_theme.dart`) | **Reuse** | Migrated verbatim — they carry measured contrast decisions |
| Kito mascot, brand assets, app icon | **Reuse** | Runtime set only |
| Prototype `PkPage`, `PkScreenHeader`, `PkSkeleton`, `KitoImage`, `KitoReveal` | **Adapt** | Domain-neutral widgets only |
| Prototype i18n structure (ARB, en/ja) | **Adapt** | Structure kept, strings rewritten for the new screens |
| Old core's Keycloak realm-role converter | **Adapt** | Extended to map OAuth scopes as well |
| Old core's package structure | **Ignore** | Superseded by the API/MCP/Core split |

## Components Rewritten

- **Backend, entirely.** The old core is a Spring Boot 3.5 / Java 21 modular monolith that
  serves REST directly. The new one is three services on Spring Boot 4.1.1 / Java 25 with a
  domain service that neither adapter may bypass.
- **Web, entirely.** Angular 17 SPA → Nuxt 4 with file-based routing and composables.
- **Mobile.** New Flutter project. The design system was migrated; the prototype's mock
  repositories, local data, and every finance screen were not.
- **Schema.** One migration creating `user_profile`, not an import of the old finance schema.
- **Object storage.** MinIO (in life-os) → SeaweedFS, behind a provider-neutral port.

## Infrastructure Changes

**Additive only.** Nothing existing was modified, moved or deleted.

- New `pockito` namespace, alongside the untouched `ghassen-io`.
- New StatefulSets: PostgreSQL, Redis, SeaweedFS — Pockito's own, not shared with the legacy
  stack.
- New Deployments: Core, API, MCP, notification worker, webapp, and the `/old` compat proxy.
- New Traefik IngressRoute and middlewares for `pockito.ghassen.io`, with explicit
  priorities. Applying it takes over the hostname; deleting it hands the hostname straight
  back to the existing route.
- Keycloak: four clients and a user-profile change to add. The realm is not re-imported —
  that would destroy existing users.

Two problems in the existing infrastructure were found and are worth acting on:

1. **`ghassen-io-infra/k8s/01-secrets.yaml` has live credentials in plaintext in Git**,
   including a GitHub PAT and a Docker Hub PAT. Rotate them and purge them from history.
   Pockito reuses none of them.
2. The legacy stack runs with `LOGGING_LEVEL_ROOT: DEBUG`, Spring Security at `TRACE`, and
   `SPRING_PROFILES_ACTIVE: dev` in production.

---

## Next Recommended Migration

**Deploy this first.** The code is finished and tested and the manifests have been applied
and verified in a real cluster, so deploying is now a matter of access rather than unknowns.
Grant a machine cluster access and run `./infra/k8s/deploy.sh`, then close the four items
above — especially opening `/old` in a browser.

**Then migrate Expenses**, as the first finance domain. It is the smallest domain that
exercises every part of the foundation end to end — a Core operation with real rules, a REST
endpoint, an MCP tool, a notification event, and screens on both clients — so it will prove
the seams before a harder domain like Settlements depends on them.

The shape to follow:

```text
1. Core:    Expense entity + Flyway migration + ExpenseService (all the rules)
2. API:     POST/GET /api/v1/expenses, delegating only
3. MCP:     add_expense / list_expenses, calling the same Core operations
4. Events:  Core publishes expense.created to the existing Redis Stream
5. Clients: screens on mobile and web, against the existing API client
```

Nothing in step 1 to 5 should require touching authentication, storage, routing, deployment,
the profile model or the service boundaries. If it does, that is the signal that something
in this foundation was drawn in the wrong place.
