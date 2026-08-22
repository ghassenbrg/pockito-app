# Deployment

Target: the existing single-node Kubernetes cluster on the `ghassen.io` VM, alongside the
legacy stack in the `ghassen-io` namespace. Pockito V1 runs in its own `pockito` namespace
so the old application keeps running untouched while the new one comes up.

> **Status.** These manifests have been applied and verified in a local Kubernetes cluster
> — all nine workloads ready, Traefik routing every path correctly, `/old` serving the real
> legacy app, and storage surviving a pod deletion — but **not** on the `ghassen.io` VM,
> because this workstation has no write path to it. Reproduce the verification with
> `infra/k8s/local-validation/up.sh` and `verify.sh`. See
> [foundation-status.md](foundation-status.md) for what remains unverified.

## What gets deployed

| Manifest                          | Resource                                                  |
|-----------------------------------|-----------------------------------------------------------|
| `00-namespace.yaml`               | `pockito` namespace                                       |
| `01-secrets.example.yaml`         | Template — copy to `01-secrets.yaml` and fill in          |
| `10-postgres.yaml`                | StatefulSet + PVC (10 Gi)                                 |
| `11-redis.yaml`                   | StatefulSet + PVC (2 Gi), AOF enabled                     |
| `12-seaweedfs.yaml`               | StatefulSet + PVC (20 Gi), S3 gateway                     |
| `20-config.yaml`                  | ConfigMap: every non-secret endpoint                      |
| `30-…` to `34-…`                  | Core, API, MCP, notification worker, webapp               |
| `40-pockito-old-compat.yaml`      | The proxy that makes the legacy app work under `/old`     |
| `50-ingressroute.yaml`            | Traefik routing, middlewares and the HTTPS redirect       |

## One command

`infra/k8s/deploy.sh` does everything below, in order, with a preflight and a confirmation
prompt before it re-points the hostname:

```bash
cp infra/k8s/01-secrets.example.yaml infra/k8s/01-secrets.yaml   # fill in every REPLACE_ME
./infra/k8s/deploy.sh
```

It is safe to re-run, never modifies the legacy application, and `./infra/k8s/rollback.sh`
hands the hostname straight back. The rest of this page is what it does, for when you want
to do it a step at a time.

## Build and push the images

From the repository root, so the shared modules are in the build context:

```bash
for svc in pockito-core pockito-api pockito-mcp pockito-notification-worker; do
  docker build -f $svc/Dockerfile -t ghassenbrg/$svc:1.0.0 .
  docker push ghassenbrg/$svc:1.0.0
done
```

The web app needs its base path baked in at build time:

```bash
cd pockito-webapp
NUXT_APP_BASE_URL=/app/ \
NUXT_PUBLIC_API_BASE_URL=https://pockito.ghassen.io/api/v1 \
NUXT_PUBLIC_KEYCLOAK_ISSUER=https://auth.ghassen.io/realms/pockito \
NUXT_PUBLIC_KEYCLOAK_CLIENT_ID=pockito-webapp \
npm run build
```

## Apply

```bash
cp infra/k8s/01-secrets.example.yaml infra/k8s/01-secrets.yaml
# fill in every REPLACE_ME with `openssl rand -base64 32`

kubectl apply -f infra/k8s/00-namespace.yaml
kubectl apply -f infra/k8s/01-secrets.yaml
kubectl apply -f infra/k8s/10-postgres.yaml -f infra/k8s/11-redis.yaml -f infra/k8s/12-seaweedfs.yaml
kubectl -n pockito rollout status statefulset/pockito-postgres
kubectl -n pockito rollout status statefulset/pockito-seaweedfs

kubectl apply -f infra/k8s/20-config.yaml
kubectl apply -f infra/k8s/30-pockito-core.yaml
kubectl -n pockito rollout status deployment/pockito-core   # Flyway runs here

kubectl apply -f infra/k8s/31-pockito-api.yaml \
              -f infra/k8s/32-pockito-mcp.yaml \
              -f infra/k8s/33-pockito-notification-worker.yaml \
              -f infra/k8s/34-pockito-webapp.yaml \
              -f infra/k8s/40-pockito-old-compat.yaml
kubectl apply -f infra/k8s/50-ingressroute.yaml
```

Order matters in one place: Core has to reach a running PostgreSQL, because it migrates the
schema at start-up. Its startup probe allows 200 seconds for that.

## Keycloak

The realm needs the new clients before anything can authenticate. Keycloak itself stays
exactly where it is — moving it would change the issuer claim in every token already in
circulation. Its authentication UI is packaged in the deterministic image built from
`infra/keycloak/Dockerfile`; deploy that image to the existing `auth.ghassen.io` service and
set `loginTheme=pockito`, `accountTheme=pockito`, and `emailTheme=pockito` on
the existing realm. Never delete and re-import production users.
Build it reproducibly with `infra/keycloak/build-image.sh`; release automation
can set `PUSH=1` and an immutable `KEYCLOAK_TAG`.
See [keycloak.md](keycloak.md) and [KEYCLOAK-THEME.md](KEYCLOAK-THEME.md).

## Routing

Old and new share the hostname, so priorities are set explicitly rather than left to
Traefik's rule-length heuristic:

| Path        | Priority | Goes to                                             |
|-------------|----------|-----------------------------------------------------|
| `/api/v1/*` | 140      | Pockito API (new)                                   |
| `/mcp*`     | 130      | Pockito MCP (new)                                   |
| `/old`      | 125      | redirect to `/old/`                                 |
| `/old/*`    | 120      | legacy Angular app, via the compat proxy            |
| `/api/*`    | 110      | legacy Pockito core — everything that is not `/api/v1` |
| `/app/*`    | 100      | Pockito webapp (new)                                |
| `/`         | 90       | redirect into `/app/`                               |

The API split works without any rewriting because the two never overlap: the legacy
controllers are `/api/{users,wallets,transactions,categories,subscriptions}` and the new API
is `/api/v1` only.

## Making `/old` genuinely work

Serving an SPA under a prefix is where this kind of migration usually half-fails: the first
HTML request returns 200 and everything inside it 404s. The legacy image ships
`<base href="/">` compiled into `index.html`, so `40-pockito-old-compat.yaml` runs a small
nginx that rewrites two things on the way through:

1. **`<base href="/">` → `<base href="/old/">`.** Every hashed asset in the image is
   referenced relatively, so this single line moves all of them under the prefix.
2. **`"/assets/` → `"/old/assets/` in JavaScript.** The i18n loader prefix is the only
   absolute path the bundle contains, and `base href` has no effect on an absolute path.
   Without this the app loads but has no translations.

Both rewrites were verified against the live production bundle before being written down:
every hashed asset and `assets/i18n/en.json` resolve correctly under the prefix, and SPA
deep routes fall back to `index.html`.

If the legacy app is ever rebuilt, re-check that `"/assets/` is still the only absolute
reference:

```bash
curl -s https://pockito.ghassen.io/main-*.js | grep -o '"/[a-z]*/' | sort -u
```

## Verifying a deployment

```bash
kubectl -n pockito get pods,svc,pvc
kubectl -n pockito get deployment -o wide

# Health, from inside the cluster
kubectl -n pockito exec deploy/pockito-api -- \
  wget -qO- http://pockito-core:8081/actuator/health/readiness

# Routing, from outside
curl -sI https://pockito.ghassen.io/          # 302 to /app/
curl -s  https://pockito.ghassen.io/api/v1/bootstrap   # 401 without a token
curl -sI https://pockito.ghassen.io/old/      # 200, legacy app
```

`infra/k8s/local-validation/verify.sh` performs most of these automatically and can be
pointed at any cluster by changing the `--resolve` target inside it.

Then the checks a status code cannot make for you:

- Open `/old/` in a browser and confirm the app renders, navigates and loads translations —
  not just that the first request is a 200.
- Sign in on `/app/`, complete onboarding, upload an avatar, reload, and confirm the session
  and preferences survive.
- Delete the SeaweedFS pod and confirm the avatar is still there afterwards:

```bash
kubectl -n pockito delete pod pockito-seaweedfs-0
kubectl -n pockito rollout status statefulset/pockito-seaweedfs
# re-fetch the avatar; it must still be served
```

## Rolling back

The legacy application is untouched by all of this — it keeps running in `ghassen-io` on its
own Deployment and Service. To revert routing entirely:

```bash
kubectl delete -f infra/k8s/50-ingressroute.yaml
```

The pre-existing IngressRoute in `ghassen-io-infra/k8s/80-ingressroutes.yaml` then serves
`pockito.ghassen.io` exactly as it does today.
