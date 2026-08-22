# Configuration

Nothing environment-specific is compiled in. Backend services read environment variables
(from the ConfigMap and Secrets in Kubernetes, or the `local` profile on a workstation), the
web app reads `NUXT_PUBLIC_*`, and the mobile app reads `--dart-define` values.

## Environments

| Profile / mode | Where it applies                          | Source                               |
|----------------|-------------------------------------------|--------------------------------------|
| `local`        | A workstation against `infra/local`       | `application-local.yml`              |
| `test`         | Automated tests                            | `application-test.yml`               |
| `k8s`          | The deployed cluster                       | `infra/k8s/20-config.yaml` + Secrets |

## Backend

### Identity

| Variable                      | Purpose                                                        |
|-------------------------------|----------------------------------------------------------------|
| `KEYCLOAK_ISSUER_URI`         | Token issuer; must match the `iss` claim exactly                |
| `KEYCLOAK_JWKS_URI`           | Signing keys. Configured, not discovered — see below            |
| `POCKITO_EXPECTED_AUDIENCES`  | Comma-separated. Empty accepts any audience in the realm        |
| `POCKITO_PUBLIC_BASE_URL`     | MCP only. Public origin advertised in OAuth discovery           |

`POCKITO_PUBLIC_BASE_URL` is the origin AI clients reach the MCP server on from outside the
cluster, not the address it binds to. It cannot be derived from the request: behind Traefik
the request arrives as plain HTTP on port 8082, and the value has to equal the URL a user
types into their AI client exactly, because it is the resource identifier their access token
is minted for. Getting it wrong produces a successful login followed by a rejected tool call.
See [mcp-chatgpt.md](mcp-chatgpt.md).

The JWKS URI is set explicitly because both of Spring Security's discovery helpers contact
Keycloak while the decoder bean is being built. That would make every service fail to start
whenever Keycloak is briefly unavailable. Configured this way, the first token triggers the
key fetch and the keys are cached from then on.

### Datastores

| Variable                       | Example                                                     |
|--------------------------------|-------------------------------------------------------------|
| `POSTGRES_URL`                 | `jdbc:postgresql://pockito-postgres:5432/pockito`           |
| `POSTGRES_USER`                | `pockito`                                                   |
| `POSTGRES_PASSWORD`            | *secret*                                                    |
| `REDIS_HOST` / `REDIS_PORT`    | `pockito-redis` / `6379`                                    |
| `REDIS_PASSWORD`               | *secret*                                                    |
| `POCKITO_NOTIFICATION_STREAM`  | `pockito.notifications` — must match in Core and the worker |

### Object storage

Provider-neutral by design: moving to Ceph RGW, AWS S3 or R2 changes these values and
nothing else.

| Variable                    | Example                                        |
|-----------------------------|------------------------------------------------|
| `S3_ENDPOINT`               | `http://pockito-seaweedfs-s3:8333`             |
| `S3_PUBLIC_ENDPOINT`        | `https://files.pockito.ghassen.io`             |
| `S3_BUCKET`                 | `pockito`                                      |
| `S3_ACCESS_KEY`             | *secret*                                       |
| `S3_SECRET_KEY`             | *secret*                                       |
| `S3_REGION`                 | `us-east-1` (SeaweedFS ignores it; the SDK requires one) |
| `S3_OBJECT_CACHE_CONTROL`   | `private, max-age=31536000, immutable`         |
| `S3_PRESIGNED_URL_VALIDITY` | `1h`                                           |

`S3_ENDPOINT` is how the service reaches storage; `S3_PUBLIC_ENDPOINT` is how a browser or
phone reaches the same storage to redeem a pre-signed URL. They differ in Kubernetes
because the first is a cluster-internal service name. The split is not cosmetic: a SigV4
signature covers the `Host` header, so a URL has to be signed for the host that will
actually be requested, and it cannot be rewritten afterwards. Leave `S3_PUBLIC_ENDPOINT`
unset where both sides share a network — it then falls back to `S3_ENDPOINT`.

### Client caching

Two settings decide whether a client re-downloads a stored object on every page load.

`S3_OBJECT_CACHE_CONTROL` is written onto each object at upload and returned on every read.
Without it storage sends no freshness directive at all, and a browser falls back to guessing
one from `Last-Modified` — which for a just-uploaded file means revalidating every time. The
long lifetime is safe because keys are never reused: an upload always writes a new key and
deletes the old object, so the bytes at a given key never change.

`S3_PRESIGNED_URL_VALIDITY` is the real ceiling. An HTTP cache is keyed on the whole URL
including the query string, so a URL signed afresh per response is a cache key the client
has never seen and it re-downloads every time. Pockito therefore reuses one signed URL per
object for **half** the validity, which is how long a client can actually hold the bytes.
Raising it means fewer re-downloads and a longer life for a URL that leaks; lowering it, the
reverse. That trade is why it is configuration.

### Service discovery

| Variable            | Example                                                    |
|---------------------|------------------------------------------------------------|
| `POCKITO_CORE_URL`  | `http://pockito-core.pockito.svc.cluster.local:8081`       |

Always a Kubernetes service name, never a pod IP. Timeouts are bounded (2 s connect, 10 s
read) so a hung Core cannot pin API request threads.

### Dify

| Variable        | Example                                             |
|-----------------|-----------------------------------------------------|
| `DIFY_ENABLED`  | `false` until a workflow actually needs it           |
| `DIFY_BASE_URL` | `http://dify-api.dify.svc.cluster.local:5001`        |
| `DIFY_API_KEY`  | *secret*                                             |

The in-cluster service, not `dify.ghassen.io`, so AI traffic never leaves the cluster.

### Notification worker

| Variable                 | Purpose                                                    |
|--------------------------|------------------------------------------------------------|
| `POD_NAME`               | Names this replica's stream consumer, from the downward API |
| `PUSH_PROVIDER`          | `none` until FCM is configured                              |
| `PUSH_CREDENTIALS_PATH`  | Mounted service-account file                                |

## Web app

Everything here is public: it ships to the browser and is visible in the page source. No
secret belongs in this list.

| Variable                          | Local                                        | Deployed                                  |
|-----------------------------------|----------------------------------------------|-------------------------------------------|
| `NUXT_PUBLIC_API_BASE_URL`        | `http://localhost:8080/api/v1`               | `https://pockito.ghassen.io/api/v1`       |
| `NUXT_PUBLIC_KEYCLOAK_ISSUER`     | `http://localhost:8180/realms/pockito`       | `https://auth.ghassen.io/realms/pockito`  |
| `NUXT_PUBLIC_KEYCLOAK_CLIENT_ID`  | `pockito-webapp`                             | `pockito-webapp`                          |
| `NUXT_APP_BASE_URL`               | `/`                                          | `/app/`                                   |

`NUXT_APP_BASE_URL` must match the Traefik path prefix. Get it wrong and the HTML loads
while every asset and route 404s.

## Mobile app

Supplied with `--dart-define`, so a build is pinned to an environment.

| Define                          | Default (local)                             |
|---------------------------------|---------------------------------------------|
| `POCKITO_API_BASE_URL`          | `http://localhost:8080/api/v1`              |
| `POCKITO_KEYCLOAK_ISSUER`       | `http://localhost:8180/realms/pockito`      |
| `POCKITO_KEYCLOAK_CLIENT_ID`    | `pockito-mobile`                            |
| `POCKITO_REDIRECT_URI`          | `app.pockito.pockito://oauth2redirect`      |

The redirect URI has to agree in three places, or authentication completes in the browser
and has nowhere to hand the code back:

1. this define,
2. `manifestPlaceholders["appAuthRedirectScheme"]` in `android/app/build.gradle.kts` and
   `CFBundleURLSchemes` in `ios/Runner/Info.plist`,
3. the `pockito-mobile` client's redirect URIs in Keycloak.

## Secrets

Real secrets never enter the repository. `infra/k8s/01-secrets.example.yaml` is a template;
the real `01-secrets.yaml` is gitignored.

Protected values: database and Redis passwords, S3 access keys, Keycloak admin credentials,
Dify API keys, push provider credentials.

Nothing sensitive is logged. Health details name endpoints and bucket names but never
credentials, and `show-details: when-authorized` keeps even those away from anonymous
probes. `server.error.include-message: never` stops exception text reaching clients.

> **Note on the existing infrastructure repository.** `ghassen-io-infra/k8s/01-secrets.yaml`
> currently has live credentials committed in plaintext, including a GitHub PAT and a Docker
> Hub PAT. Those should be rotated and removed from history. Pockito deliberately reuses
> none of them.
