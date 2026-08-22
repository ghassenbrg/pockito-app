# Pockito V1 — Production Foundation, Monorepo & Environment Bootstrap

## Mission

Use the **attached architecture diagram as the source of truth** for the new Pockito platform.

The goal of this phase is to build a **clean, working, production-quality foundation** for Pockito before migrating any finance-specific business features.

At the end of this task, the complete platform foundation must work end-to-end:

```text
Mobile App ─┐
Web App ────┼──► Traefik
AI / MCP ───┘
                 │
                 ├──► Pockito Webapp
                 ├──► Pockito API
                 └──► Pockito MCP
                          │
                          ▼
                     Pockito Core
                    /      |      \
                   ▼       ▼       ▼
             PostgreSQL  Redis  SeaweedFS
                          │
                         Dify

Authentication / IAM
        ↓
     Keycloak
```

This phase is about making the **platform skeleton genuinely usable**, not just creating placeholder repositories.

After completion, the remaining major work should be:

> migrating finance business logic and finance screens incrementally.

Everything else — authentication, onboarding, user profile, preferences, storage, routing, infrastructure, service communication, configuration, mobile/web shells, API/MCP foundations, deployment, etc. — should already be working.

---

# 1. Architecture Is the Source of Truth

The attached architecture diagram is authoritative.

Do not redesign the architecture based on the old Pockito projects.

Existing projects may be used as references and sources of reusable implementation, but when something conflicts with the new architecture:

**the new architecture wins.**

The target architecture is:

```text
CLIENTS

Mobile App
Web App
AI Agent / MCP Clients
        │
        ▼
     Traefik
        │
        ├── /app/* ──► Pockito Webapp
        ├── /api/* ──► Pockito API
        └── /mcp/* ──► Pockito MCP


BACKEND INTERFACES

Pockito API ──────┐
                  ├──► Pockito Core
Pockito MCP ──────┘


POCKITO CORE

Pockito Core
├── PostgreSQL
├── Redis
├── SeaweedFS through S3-compatible API
├── Dify
└── Keycloak Admin API / IAM when actually required


IDENTITY

Keycloak
├── OIDC
├── registration
├── login
├── users
├── token issuer
├── JWKS
├── roles/scopes
└── IAM


ASYNC / NOTIFICATIONS

Pockito Core
      │
      ▼
Redis Streams
      │
      ▼
Notification Worker
      │
      ▼
Push provider such as FCM
```

Do not introduce Kafka in this phase.

Redis Streams is sufficient for the current asynchronous/notification requirements.

---

# 2. First Inspect Everything

Before modifying code or infrastructure, inspect:

```text
CURRENT MONOREPO
<current repository>

MOBILE PROTOTYPE
/Users/ghassenbrg/git/pockito-mobile-prototype

OLD POCKITO CORE
/Users/ghassenbrg/git/pockito-core

OLD POCKITO WEB
/Users/ghassenbrg/git/pockito-ui

LIFE OS
/Users/ghassenbrg/git/life-os

INFRASTRUCTURE
/Users/ghassenbrg/git/ghassen-io-infra
```

Do not immediately start rewriting.

First determine:

* what currently exists
* what is deployed
* what can be reused
* what should be adapted
* what should be discarded
* current Traefik routing
* current Kubernetes resources
* current Keycloak configuration
* current PostgreSQL
* current Redis
* existing Dify deployment
* existing secrets/configuration mechanism
* existing Pockito DNS/routes
* how the current old Pockito is deployed

Then create a concise implementation plan and execute it.

---

# 3. Monorepo Structure

Prepare the new Pockito monorepo with clean boundaries.

The target should conceptually contain:

```text
pockito/
├── pockito-mobile/
├── pockito-webapp/
├── pockito-api/
├── pockito-mcp/
├── pockito-core/
├── pockito-notification-worker/
│
├── packages/ or shared/
│   └── only where shared code genuinely makes sense
│
├── infra/
│   └── only for Pockito-specific deployment configuration
│
├── docs/
│
└── README.md
```

Adapt naming/layout to existing monorepo conventions where necessary.

Do **not** create nested `.git` repositories unless that is intentionally how the existing monorepo is structured.

These are application/service boundaries inside the monorepo.

---

# 4. Technology Stack

## Mobile

Use:

```text
Flutter
Dart
```

Start from the useful foundation already present in:

```text
/Users/ghassenbrg/git/pockito-mobile-prototype
```

Do **not** simply rename the prototype and keep all prototype code.

Create the new production mobile application cleanly and selectively migrate what is useful.

---

## Web

Use:

```text
Nuxt
Vue 3
TypeScript
```

Requirements:

* Nuxt
* Vue.js 3
* TypeScript
* current stable compatible versions
* Nuxt-native architecture
* file-based routing
* composables
* centralized API client
* centralized authentication integration
* centralized localization
* centralized appearance/theme
* clean typed models

Do not build a generic Vue SPA inside Nuxt.

Do not put Pockito business logic in Nuxt.

The webapp is a frontend client:

```text
Browser
   ↓
Traefik
   ↓
Pockito Webapp
Nuxt + Vue
   ↓
Pockito API
   ↓
Pockito Core
```

The web application must never directly access:

```text
PostgreSQL
Redis
SeaweedFS
Pockito Core
```

All domain/application operations go through `Pockito API`.

---

## Backend

Use:

```text
Spring Boot 4.1.1
Java 25
```

for the new Java backend services.

Use modern Spring conventions.

For other libraries, tools and dependencies:

* use current stable releases
* use LTS versions where the technology has an LTS concept
* avoid deprecated dependencies
* verify compatibility before selecting versions
* do not silently downgrade Java or Spring Boot

If an explicitly required version causes a real incompatibility, document it clearly rather than silently changing the requested stack.

---

# 5. Backend Boundaries

Keep:

```text
Pockito API
Pockito MCP
Pockito Core
```

as distinct architectural components.

## Pockito API

Responsible for:

* REST interface
* request/response DTOs
* HTTP-level validation
* authentication context
* API versioning
* OpenAPI
* mapping requests to Core operations

It should **not own business logic**.

---

## Pockito MCP

Responsible for:

* MCP protocol
* MCP tools/resources
* AI/MCP client authentication
* mapping MCP calls to Core operations

It should **not duplicate Core business logic**.

---

## Pockito Core

This is the central domain/application service.

All real Pockito business behavior belongs here.

Conceptually:

```text
REST call
   ↓
Pockito API
   ↓
Pockito Core


MCP call
   ↓
Pockito MCP
   ↓
Pockito Core
```

When finance functionality is added later:

```text
API: createExpense()
            │
            ▼
      Pockito Core


MCP: add_expense
            │
            ▼
      Pockito Core
```

Both must reuse the same Core operation.

Never create two implementations of the same business rule.

---

# 6. Mobile Prototype Migration

Use:

```text
/Users/ghassenbrg/git/pockito-mobile-prototype
```

as the main UI/UX/design reference.

Take only the global foundation needed now.

Reuse/adapt:

* Pockito branding
* Kito mascot/assets
* app icon/assets
* design tokens
* typography
* colors
* spacing
* buttons
* inputs
* cards
* loading states
* error states
* common dialogs/sheets
* navigation shell
* theme infrastructure
* localization infrastructure
* avatar component
* profile UI
* onboarding patterns
* general app shell

Do not migrate finance screens yet.

Do not migrate:

* expenses
* budgets
* settlements
* spaces business flows
* transactions
* wallets
* subscriptions
* financial analytics
* finance dashboards
* OCR workflows
* finance AI features

Remove prototype-only shortcuts and mock logic.

The result must be a real production application foundation.

---

# 7. Old Repositories as References

Inspect:

```text
/Users/ghassenbrg/git/pockito-core
/Users/ghassenbrg/git/pockito-ui
/Users/ghassenbrg/git/life-os
```

They contain things that are already implemented and working.

Reuse or adapt useful pieces where appropriate, for example:

* Keycloak configuration
* data models
* infrastructure patterns
* translations
* profile logic
* storage utilities
* user mapping
* configuration
* migrations
* security
* deployment manifests
* error handling
* reusable frontend components

But classify anything migrated as:

```text
REUSE
ADAPT
REWRITE
IGNORE
```

Do not blindly carry technical debt into the new architecture.

---

# 8. Infrastructure Repository

The current infrastructure lives here:

```text
/Users/ghassenbrg/git/ghassen-io-infra
```

Inspect it before changing anything.

Reuse the existing VM/Kubernetes environment.

Do not create duplicate infrastructure when a suitable component already exists.

The attached architecture indicates a:

```text
VM
└── Kubernetes default cluster
```

The new Pockito services should run there.

---

# 9. Existing Dify

Dify already exists in the VM.

Do not deploy another Dify.

Find the existing configuration/service in:

```text
/Users/ghassenbrg/git/ghassen-io-infra
```

Determine:

* Kubernetes service name
* namespace
* internal endpoint
* authentication requirements
* secrets/config
* current health

Then configure:

```text
Pockito Core
      │
      ▼
     Dify
```

For this phase, the integration may remain foundation-only.

We need:

* client configuration
* connectivity
* health verification
* clean abstraction

Do not implement finance AI workflows yet.

---

# 10. Preserve Old Pockito

The old application must remain available.

Rename old Pockito infrastructure/resources logically to:

```text
pockito-old
```

where safe and appropriate.

The legacy Pockito must be accessible at:

```text
https://pockito.ghassen.io/old
```

The **new Pockito becomes the default**:

```text
https://pockito.ghassen.io/*
```

Target routing should conceptually become:

```text
pockito.ghassen.io/old/*
      ↓
old Pockito


pockito.ghassen.io/app/*
      ↓
new Pockito webapp


pockito.ghassen.io/api/*
      ↓
new Pockito API


pockito.ghassen.io/mcp/*
      ↓
new Pockito MCP
```

The root:

```text
https://pockito.ghassen.io/
```

should lead users into the new Pockito application.

Do not destroy or overwrite the old application before validating `/old`.

Be careful with frontend base paths, static assets, redirects and API URLs so that the old app genuinely works under `/old`, not only its first HTML request.

---

# 11. Traefik

Traefik is the external entry point.

Configure routing according to the architecture.

Conceptually:

```text
/app/* → pockito-webapp

/api/* → pockito-api

/mcp/* → pockito-mcp

/old/* → pockito-old
```

For Keycloak, preserve the existing working architecture.

Do not arbitrarily move Keycloak under `/auth/*` if that would change its issuer URL or break existing OIDC clients.

If an `/auth/*` route is already suitable and clean, it may be used.

Authentication correctness is more important than forcing a particular path.

---

# 12. Keycloak Is the Identity Provider

Keycloak owns:

* registration
* login
* passwords
* credential management
* OAuth/OIDC
* users
* token issuing
* access tokens
* refresh tokens
* roles
* scopes
* MFA/passkeys if introduced later
* email verification if configured

Pockito must **not create its own username/password authentication implementation**.

Do not create:

```text
POST /api/login
POST /api/register
```

that directly accept and authenticate user passwords through Pockito Core.

---

# 13. Mobile Authentication

The Pockito mobile app should have a polished **native Pockito entry experience**.

Example:

```text
Welcome to Pockito

[ Log in ]
[ Create account ]
```

But pressing those buttons should initiate Keycloak authentication.

Use:

```text
OAuth 2 / OpenID Connect
Authorization Code
PKCE
```

Conceptually:

```text
Pockito Mobile
      │
      │ Login / Register
      ▼
System/browser-backed authentication session
      │
      ▼
Keycloak
      │
      │ successful authentication
      ▼
redirect / deep link back to Pockito
      │
      ▼
authenticated mobile app
```

Do not embed a custom username/password form that sends credentials through Pockito API.

Implement:

* login
* create account
* OAuth callback
* deep linking
* secure token storage
* refresh handling
* session restoration
* logout
* expired session handling
* unauthenticated routing
* authenticated routing

---

# 14. Web Authentication

The Nuxt webapp also authenticates with Keycloak using OIDC.

Expected flow:

```text
Browser
   ↓
Nuxt Pockito
   ↓
Keycloak
   ↓
authenticated
   ↓
Nuxt Pockito
   ↓
Pockito API
```

Implement:

* login
* registration entry
* logout
* auth callback
* protected pages
* session restoration
* token handling
* refresh strategy
* unauthorized handling
* expired-session handling
* return-to-original-page behavior where appropriate

Do not make Nuxt responsible for storing or validating passwords.

---

# 15. Keycloak Token Validation

API and MCP should validate Keycloak-issued tokens appropriately using issuer/JWKS configuration.

Conceptually:

```text
Keycloak
   │
   │ signed JWT
   ▼
Client
   │
   ▼
API / MCP
   │
   │ validate issuer/signature/audience/scopes
   ▼
Pockito Core
```

Do not design the system so every authenticated API request requires a synchronous call to Keycloak.

Pass the authenticated identity/security context into Core.

---

# 16. Core → Keycloak

`Pockito Core → Keycloak Admin API / IAM` should exist **only for operations that genuinely require Keycloak administration**.

Examples:

* update identity attributes when required
* query Keycloak identity
* administrative user lifecycle
* role management
* account disable/delete flows

Do not use the Keycloak Admin API simply to validate each normal request.

---

# 17. Identity vs Pockito Profile

Keep identity and application profile separate.

Conceptually:

```text
Keycloak
├── user identity
├── email
├── credentials
├── authentication
└── subject ID

              │
              │ subject
              ▼

Pockito PostgreSQL
├── Pockito profile
├── display name
├── avatar
├── language
├── theme
├── default currency
├── onboarding state
└── application preferences
```

Use the Keycloak subject/user identifier as the stable identity link.

Do not store password hashes or authentication credentials in Pockito PostgreSQL.

---

# 18. First Login / Onboarding

After authentication, determine whether the user has completed Pockito onboarding.

Conceptually:

```text
Authentication complete
        ↓
GET /api/v1/bootstrap
        ↓
Pockito profile exists?
        ↓
onboarding completed?
   /                 \
 no                   yes
 ↓                     ↓
Onboarding             Home
```

The onboarding must be a real working flow.

---

# 19. Onboarding Requirements

Implement global onboarding only.

At minimum:

## Profile

* display name
* relevant basic profile information

## Avatar

Allow:

* upload
* replace
* remove
* initials/default fallback

## Default Currency

Allow user to choose their global/default currency.

## Language

At minimum prepare:

```text
English
Japanese
```

Keep architecture ready for additional languages.

## Appearance

Support:

```text
System
Light
Dark
```

## Other Global Preferences

Take any genuinely global preferences already established in the prototype where useful.

Do not add finance-domain configuration yet.

---

# 20. Avatar Storage

Avatar binary files should be stored in object storage.

Do not store image blobs directly in PostgreSQL.

Flow:

```text
Mobile / Web
      ↓
Pockito API
      ↓
Pockito Core
      ↓
ObjectStorageService
      ↓
S3 API
      ↓
SeaweedFS
```

PostgreSQL stores metadata/reference information.

---

# 21. SeaweedFS

Use SeaweedFS as the new object-storage implementation.

SeaweedFS runs inside Kubernetes.

Use its **S3-compatible API**.

Core should not depend on SeaweedFS-specific functionality.

Create a generic abstraction such as:

```text
ObjectStorageService

putObject(...)
getObject(...)
deleteObject(...)
createPresignedUrl(...)
```

Configuration should be provider-neutral:

```text
S3_ENDPOINT
S3_BUCKET
S3_ACCESS_KEY
S3_SECRET_KEY
S3_REGION
```

Current implementation:

```text
Pockito Core
      ↓
ObjectStorageService
      ↓
S3 API
      ↓
SeaweedFS
```

This should make future migration possible to:

```text
Ceph RGW
AWS S3
Cloudflare R2
other S3-compatible providers
```

without changing domain logic.

---

# 22. SeaweedFS Persistence

This is currently a single-node Kubernetes environment.

Ensure SeaweedFS persistence survives pod recreation.

Conceptually:

```text
SeaweedFS
    │
    ▼
   PVC
    │
    ▼
VM / on-prem persistent disk
```

Do not rely on container filesystem storage.

---

# 23. PostgreSQL

PostgreSQL is the source of truth for persistent Pockito application data.

For this phase, support at least:

* Pockito user/profile
* Keycloak subject link
* preferences
* onboarding state
* avatar metadata
* timestamps
* application configuration requiring persistence

Use proper schema migration tooling from day one.

Do not import the entire old finance schema.

Finance schema will be migrated incrementally later.

---

# 24. Redis

Redis is used for appropriate ephemeral/asynchronous functionality.

Primary intended responsibilities:

```text
cache
short-lived state
Redis Streams
notification/event jobs
```

Do not use Redis as the source of truth for user profiles or finance data.

Do not unnecessarily duplicate Keycloak session management.

If Redis contains session-related application state, clearly document exactly what it contains and why.

---

# 25. Notifications Foundation

Prepare the architecture for notifications now.

Do not use Kafka.

Target:

```text
Pockito Core
      │
      │ event/job
      ▼
Redis Streams
      │
      ▼
Pockito Notification Worker
      │
      ▼
Push provider
      │
      ▼
Mobile device
```

Separate:

```text
notification persistence
```

from:

```text
push delivery
```

Notification state/history belongs in PostgreSQL when implemented.

Redis Streams is for asynchronous delivery/events.

The complete finance notification rules can be added later, but the infrastructure/service boundary should be ready.

---

# 26. Notification Worker

Create:

```text
pockito-notification-worker
```

as a clean service boundary.

For this foundation phase it should at least:

* start correctly
* connect to Redis
* consume the intended stream
* implement health/readiness
* use idempotent/retry-safe processing design
* have configuration ready for the push provider

Do not invent lots of finance notification events yet.

---

# 27. Mobile Application Scope

The new mobile app should contain only the production foundation.

Required flow:

```text
Splash / Bootstrap
        ↓
Authentication state
   /             \
logged out       logged in
   ↓                 ↓
Welcome         Bootstrap profile
                  /           \
          incomplete         complete
              ↓                 ↓
          Onboarding           Home
```

Required screens:

```text
Welcome

Authentication entry
├── Login
└── Create Account

Onboarding
├── Profile
├── Avatar
├── Language
├── Appearance
├── Default Currency
└── Completion

Home
└── minimal production-ready shell

Settings
├── Profile
├── Avatar
├── Language
├── Appearance
├── Currency
└── Logout
```

Do not fill Home with fake finance functionality.

---

# 28. Mobile Home

The authenticated Home screen should be polished and clearly Pockito.

Use:

* Pockito branding
* Kito
* real current user
* user avatar
* greeting
* correct design system
* global navigation shell if required

But keep domain content intentionally minimal.

The absence of finance screens in this phase is intentional.

---

# 29. Nuxt Web Application Scope

The new webapp must be a real working Nuxt application.

Implement:

```text
Unauthenticated
├── Landing / Welcome
├── Login
└── Create Account

Authenticated
├── Application Shell
├── Home
├── Profile
├── Avatar
├── Preferences
│   ├── Language
│   ├── Appearance
│   └── Default Currency
└── Logout
```

Handle first-login onboarding similarly to mobile.

Do not migrate the old Pockito finance UI yet.

---

# 30. Nuxt Architecture

Use clean Nuxt conventions.

Conceptually:

```text
pockito-webapp/
├── app/
├── assets/
├── components/
├── composables/
├── layouts/
├── middleware/
├── pages/
├── plugins/
├── public/
├── types/
├── utils/
├── i18n/
└── nuxt.config.ts
```

Follow the actual current Nuxt conventions where they differ.

Prefer reusable composables such as:

```text
useAuth()
useApi()
useProfile()
usePreferences()
useOnboarding()
```

Do not scatter raw API calls through Vue components.

---

# 31. Web/Mobile Behavior Consistency

Both applications should use the same Pockito backend concepts.

For example:

```text
GET /api/v1/bootstrap
```

should provide enough information for either client to initialize:

```text
authenticated user
profile
onboarding status
preferences
feature/global configuration as needed
```

Do not build completely independent onboarding/profile models for mobile and web.

---

# 32. API Foundation

Create a clean versioned API.

Exact design may evolve, but likely foundation endpoints include:

```text
GET    /api/v1/bootstrap

GET    /api/v1/me
PUT    /api/v1/me

GET    /api/v1/me/preferences
PUT    /api/v1/me/preferences

POST   /api/v1/me/avatar
DELETE /api/v1/me/avatar

POST   /api/v1/onboarding/complete
```

Requirements:

* authentication
* authorization
* DTO validation
* consistent errors
* versioning
* OpenAPI
* typed models
* appropriate HTTP status codes
* correlation IDs

Do not create placeholder finance endpoints.

---

# 33. MCP Foundation

Create and deploy the new MCP service now.

It should:

* start successfully
* authenticate correctly
* communicate with Pockito Core
* expose health/readiness
* have proper configuration
* be reachable through `/mcp/*`
* be ready for future finance tools

Do not create fake finance tools just to make the MCP look populated.

If meaningful, initial capabilities may include things such as:

```text
get_my_profile
get_my_preferences
```

but only implement tools backed by actual functionality.

---

# 34. Service Communication

Inside Kubernetes, use internal Kubernetes service discovery.

Do not call services using pod IPs.

Conceptually:

```text
pockito-api
      ↓
pockito-core service


pockito-mcp
      ↓
pockito-core service


pockito-core
      ↓
postgres service

pockito-core
      ↓
redis service

pockito-core
      ↓
seaweedfs-s3 service

pockito-core
      ↓
existing Dify service
```

Use timeouts and proper failure handling.

---

# 35. Kubernetes

Prepare all required Pockito workloads for the existing Kubernetes environment.

Use appropriate resources:

* Deployment
* StatefulSet where needed
* Service
* ConfigMap
* Secret
* PVC
* IngressRoute / Traefik resources
* liveness probes
* readiness probes
* startup probes where useful
* resource requests/limits where appropriate

At minimum account for:

```text
pockito-webapp
pockito-api
pockito-mcp
pockito-core
pockito-notification-worker

Keycloak
PostgreSQL
Redis
SeaweedFS
Traefik

existing Dify
```

Do not duplicate resources already managed correctly by `ghassen-io-infra`.

---

# 36. Configuration

Centralize configuration.

Support appropriate environments such as:

```text
local
dev
k8s
production
```

Do not scatter endpoints or credentials through source code.

Prepare documented configuration for:

```text
Keycloak issuer
Keycloak client IDs
Keycloak admin configuration if required
PostgreSQL
Redis
SeaweedFS S3
Dify
frontend API URL
frontend auth configuration
mobile redirect URIs
web redirect URIs
push notifications
```

---

# 37. Secrets

Never commit actual credentials.

Use the existing infrastructure's secret-management pattern.

Protect:

* database credentials
* Redis secrets
* S3 access keys
* Keycloak client secrets
* Keycloak admin credentials
* Dify API keys
* push provider credentials
* signing/private material

Ensure sensitive values never appear in normal application logs.

---

# 38. Global Localization

Localization must be part of the foundation.

Do not hard-code user-facing strings everywhere.

At minimum support infrastructure for:

```text
English
Japanese
```

Mobile and web should both support language selection.

Persist the user's preference.

The server-side preference should allow the same user preference to be restored across devices.

---

# 39. Appearance

Implement centralized appearance configuration.

At minimum:

```text
System
Light
Dark
```

Mobile and web should use their respective design systems cleanly.

Persist the preference.

Avoid screen-specific hard-coded appearance behavior.

---

# 40. User Preference Strategy

For responsive UX, clients may cache local preferences such as:

```text
language
theme
basic profile/bootstrap state
```

but PostgreSQL remains the authoritative persistent Pockito profile source.

On startup:

```text
local cached preference
      ↓
fast initial rendering

then

/api/v1/bootstrap
      ↓
server state reconciliation
```

Avoid obvious light/dark or avatar flashing where practical.

---

# 41. Health Checks

Every Pockito service should expose appropriate health information.

Distinguish:

```text
liveness
```

from:

```text
readiness
```

A temporary downstream failure should not necessarily cause Kubernetes to continuously kill a healthy application process.

Verify connectivity where appropriate to:

* PostgreSQL
* Redis
* SeaweedFS
* Core
* required auth configuration

---

# 42. Observability

Prepare a reasonable production foundation:

* structured logs
* correlation/request IDs
* useful error logs
* HTTP request logging where appropriate
* Spring Actuator
* health endpoints
* startup diagnostics
* service identification

Never log:

* passwords
* refresh tokens
* authorization headers
* private keys
* secrets

Do not over-engineer a new observability platform in this phase if the infrastructure does not already provide one.

---

# 43. Error Handling

Mobile and web should gracefully handle:

```text
offline
network timeout
401
403
expired session
API unavailable
Keycloak unavailable
profile load failure
avatar upload failure
invalid input
unexpected backend failure
```

Do not surface raw backend exceptions to end users.

The APIs should expose a consistent error format.

---

# 44. Database Migrations

Use proper version-controlled migrations.

The new database should start with the minimal new foundation schema.

Do not dump/import all old Pockito tables.

Migration of finance domains comes later and should be explicit.

---

# 45. Data Ownership

Keep ownership clear.

## Keycloak

```text
identity
credentials
authentication
roles/scopes
```

## PostgreSQL

```text
Pockito profile
preferences
onboarding status
business data later
notification history later
```

## Redis

```text
cache
temporary state
streams/jobs
```

## SeaweedFS

```text
avatars
receipts later
attachments later
exports later
```

## Dify

```text
AI workflows/orchestration
```

---

# 46. What NOT to Implement Now

Finance functionality is explicitly out of scope.

Do not implement or migrate:

```text
Expenses
Budgets
Settlements
Shared spaces business logic
Wallets
Bank accounts
Transfers
Transactions
Subscriptions
Finance dashboards
Finance analytics
OCR finance workflows
Receipt processing business logic
Finance AI insights
Finance MCP tools
Recurring transaction detection
Finance notification rules
```

Do not populate the application with fake/mock implementations of these features.

---

# 47. Production Quality

This is no longer a throwaway prototype.

Do not leave:

* fake login
* mock users
* hard-coded tokens
* hard-coded localhost URLs
* placeholder secrets
* prototype authentication
* duplicated business logic
* dead prototype screens
* fake uploads
* TODO security
* TODO database migrations
* arbitrary sleeps
* fragile startup scripts
* credentials in Git
* broken deep links
* unhandled auth expiry

If something cannot be completed, document the exact blocker.

---

# 48. Tests

Add meaningful automated tests.

## Backend

Cover at minimum:

```text
unauthorized profile access
authenticated profile retrieval
profile update
preferences update
first-login profile creation
onboarding completion
avatar metadata/storage flow
Keycloak subject mapping
validation
```

## Mobile

Test critical app-state transitions where practical:

```text
logged out → welcome

authenticated + onboarding incomplete
→ onboarding

authenticated + onboarding complete
→ home

logout
→ welcome
```

## Web

Test critical route/auth behavior:

```text
protected route unauthenticated
→ authentication

authenticated incomplete user
→ onboarding

authenticated complete user
→ home
```

---

# 49. End-to-End Validation — New Mobile User

Actually execute this flow before declaring success:

```text
1. Install/open Pockito mobile app.

2. App starts unauthenticated.

3. User sees Pockito welcome screen.

4. Tap Create Account.

5. Keycloak registration opens.

6. Create account successfully.

7. Return to Pockito through correct callback/deep link.

8. Pockito obtains authenticated session.

9. Bootstrap endpoint identifies first login.

10. Native onboarding opens.

11. Enter display name.

12. Upload avatar.

13. Select language.

14. Select System/Light/Dark.

15. Select default currency.

16. Finish onboarding.

17. Reach minimal Pockito Home.

18. User avatar/profile displays correctly.

19. Close app completely.

20. Reopen app.

21. Session restores correctly.

22. Preferences/profile restore correctly.

23. Onboarding does not repeat.

24. Logout.

25. Login again.

26. Return to Home successfully.
```

---

# 50. End-to-End Validation — Web

Validate:

```text
1. Open https://pockito.ghassen.io/

2. New Nuxt Pockito app loads.

3. Login through Keycloak.

4. Authentication succeeds.

5. User bootstrap/profile loads.

6. Incomplete user sees onboarding.

7. Completed user sees Home.

8. Avatar loads.

9. Preferences load.

10. Language works.

11. Appearance works.

12. Logout works.

13. Protected routes cannot be accessed after logout.
```

---

# 51. End-to-End Validation — Avatar

Verify:

```text
Client
   ↓
Pockito API
   ↓
Pockito Core
   ↓
S3 abstraction
   ↓
SeaweedFS
   ↓
PVC
```

Then:

```text
retrieve avatar
↓
display in mobile/web
```

Restart/recreate SeaweedFS pod and verify persisted avatar data remains available.

---

# 52. End-to-End Validation — MCP

Verify:

```text
AI/MCP client
      ↓
https://pockito.ghassen.io/mcp/*
      ↓
Traefik
      ↓
Pockito MCP
      ↓
authenticated identity
      ↓
Pockito Core
```

Confirm authorization is enforced.

---

# 53. End-to-End Validation — Old Pockito

Before completion verify:

```text
https://pockito.ghassen.io/old
```

still opens and functions.

Test:

* HTML
* JS
* CSS
* assets
* frontend routing
* relevant backend/API routing
* authentication if applicable

Do not consider `/old` working merely because the first page responds with HTTP 200.

---

# 54. Infra Validation

Validate:

```text
Traefik
Keycloak
Pockito Webapp
Pockito API
Pockito MCP
Pockito Core
Notification Worker
PostgreSQL
Redis
SeaweedFS
Dify connectivity
```

Check:

* pods
* services
* routes
* DNS/service discovery
* health
* readiness
* logs
* PVCs
* restart behavior

---

# 55. Documentation

Create/update documentation for:

```text
architecture
repository layout
technology stack
local development
Kubernetes deployment
Traefik routing
Keycloak configuration
mobile OAuth/OIDC
web OAuth/OIDC
redirect URIs
API
MCP
PostgreSQL
Redis
Redis Streams
SeaweedFS
Dify
environment variables
secrets
old/new Pockito routing
future migration process
```

Create:

```text
docs/foundation-status.md
```

with:

```text
# Foundation Status

## Implemented

## Validated

## Known Limitations

## Intentionally Deferred

## Existing Components Reused

## Components Rewritten

## Infrastructure Changes

## Next Recommended Migration
```

---

# 56. Future Migration Preparation

The architecture must make it easy to add domains incrementally.

Later we should be able to migrate:

```text
Profile foundation        ✅ now

Expenses                  later
Spaces                    later
Budgets                   later
Settlements               later
Wallets                   later
Transactions              later
Subscriptions             later
OCR                       later
Finance AI                later
```

Each new domain should plug into:

```text
Mobile/Web
     ↓
API
     ↓
Core


AI Agent
     ↓
MCP
     ↓
Core
```

without changing authentication or infrastructure fundamentals.

---

# 57. Execution Strategy

Work in controlled phases.

## Phase 1 — Audit

Inspect all repositories and current infrastructure.

## Phase 2 — Plan

Create the exact target structure and migration plan.

## Phase 3 — Preserve Legacy

Move/reroute old Pockito safely to `/old`.

## Phase 4 — Bootstrap Services

Create:

```text
pockito-mobile
pockito-webapp
pockito-api
pockito-mcp
pockito-core
pockito-notification-worker
```

## Phase 5 — Infrastructure

Wire:

```text
Traefik
PostgreSQL
Redis
SeaweedFS
Keycloak
Dify
```

## Phase 6 — Authentication

Complete mobile and web login/registration/session handling.

## Phase 7 — Profile

Implement profile/preferences/avatar.

## Phase 8 — Onboarding

Implement full first-login onboarding.

## Phase 9 — Application Shells

Create minimal production mobile and web Home.

## Phase 10 — MCP

Validate authenticated MCP access.

## Phase 11 — Tests

Run unit/integration/E2E coverage.

## Phase 12 — Deployment

Deploy everything into the existing VM Kubernetes environment.

## Phase 13 — End-to-End Validation

Actually exercise all required flows.

## Phase 14 — Documentation

Document the final state and next migration step.

---

# 58. Do Not Stop at Code Generation

This task is **not complete** when repositories/files merely exist.

Do not stop after:

```text
"Created Kubernetes manifests"
"Created Keycloak configuration"
"Created Nuxt app"
"Created Flutter app"
```

Actually:

```text
build
test
deploy
inspect
open
login
register
redirect
upload
restart
reload
logout
login again
verify
```

Fix errors found during validation.

---

# 59. Definition of Done

The task is complete when all applicable items below are true:

```text
✅ Attached architecture respected

✅ Existing infrastructure audited

✅ Old Pockito preserved

✅ Old Pockito available under /old

✅ New Pockito available at pockito.ghassen.io

✅ Flutter production mobile app created

✅ Nuxt + Vue 3 + TypeScript webapp created

✅ Spring Boot 4.1.1 backend foundation created

✅ Java 25 used

✅ Pockito API created

✅ Pockito MCP created

✅ Pockito Core created

✅ Notification Worker created

✅ API and MCP both use Core

✅ Keycloak authentication working

✅ Mobile Authorization Code + PKCE working

✅ Mobile registration working

✅ Mobile deep-link callback working

✅ Mobile session restoration working

✅ Web OIDC authentication working

✅ Web session restoration working

✅ User/profile model implemented

✅ Keycloak subject linked to Pockito user

✅ First-login detection working

✅ Mobile onboarding working

✅ Web onboarding working

✅ Avatar upload working

✅ Avatar stored through S3 abstraction

✅ SeaweedFS working

✅ SeaweedFS PVC persistence verified

✅ Language preference working

✅ Appearance preference working

✅ Default currency working

✅ Minimal mobile Home working

✅ Minimal Nuxt Home working

✅ PostgreSQL integrated

✅ Database migrations working

✅ Redis integrated

✅ Redis Streams foundation ready

✅ Dify existing deployment reused

✅ Pockito Core can reach Dify

✅ Traefik routing working

✅ Kubernetes services configured

✅ Health/readiness configured

✅ Secrets handled correctly

✅ No finance business logic unnecessarily migrated

✅ No fake finance screens introduced

✅ Core automated tests passing

✅ Critical mobile/web auth-state tests passing

✅ Mobile E2E flow validated

✅ Web E2E flow validated

✅ MCP authentication validated

✅ Old /old deployment validated

✅ Documentation completed
```

The only major intentionally missing functionality after this phase should be:

```text
❌ Finance business domains
❌ Finance feature screens
❌ Finance-specific MCP tools
❌ Finance-specific AI workflows
```

---

# Final Expected Result

At the end of this goal, we should have a **real Pockito V1 platform foundation**, not another prototype.

A new user should be able to:

```text
install/open Pockito
        ↓
register/login with Keycloak
        ↓
return to Pockito
        ↓
complete onboarding
        ↓
upload avatar
        ↓
select language/theme/currency
        ↓
reach Home
        ↓
close/reopen application
        ↓
remain correctly authenticated
```

A web user should be able to:

```text
open pockito.ghassen.io
        ↓
authenticate
        ↓
load profile/preferences
        ↓
complete onboarding if required
        ↓
reach Nuxt Home
```

An MCP client should be able to:

```text
connect
   ↓
authenticate
   ↓
reach Pockito MCP
   ↓
call Pockito Core-backed foundation functionality
```

The infrastructure should be:

```text
Traefik
Keycloak
Nuxt Webapp
Flutter Mobile Client
Pockito API
Pockito MCP
Pockito Core
Notification Worker
PostgreSQL
Redis + Redis Streams
SeaweedFS
Existing Dify
```

all correctly configured and ready.

From that point onward, finance functionality can be migrated **one domain at a time** without needing to redesign authentication, storage, routing, deployment, profiles, onboarding, frontend foundations or service boundaries.