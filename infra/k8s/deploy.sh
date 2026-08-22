#!/usr/bin/env bash
# Deploys Pockito V1 to the ghassen.io cluster and cuts pockito.ghassen.io over to it.
#
# Run this from a machine that can reach the cluster (kubectl context set, images pushable).
# It is safe to re-run: every step is idempotent, and the legacy application is never
# modified — it keeps running in the `ghassen-io` namespace throughout, and `rollback.sh`
# hands the hostname straight back to it.
#
#   ./infra/k8s/deploy.sh                 # full deploy, prompts before the cutover
#   SKIP_BUILD=1 ./infra/k8s/deploy.sh    # manifests only, images already pushed
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
K8S="$ROOT/infra/k8s"
REGISTRY="${REGISTRY:-ghassenbrg}"
TAG="${TAG:-1.0.0}"
cd "$ROOT"

step(){ printf '\n\033[1m==> %s\033[0m\n' "$1"; }
fail(){ printf '\033[31mERROR:\033[0m %s\n' "$1" >&2; exit 1; }

step "Preflight"
kubectl cluster-info >/dev/null 2>&1 || fail "kubectl cannot reach a cluster"
CTX=$(kubectl config current-context)
echo "    context: $CTX"
kubectl get crd ingressroutes.traefik.io >/dev/null 2>&1 \
  || fail "Traefik CRDs are absent — is this the right cluster?"
[ -f "$K8S/01-secrets.yaml" ] \
  || fail "$K8S/01-secrets.yaml is missing. Copy 01-secrets.example.yaml and fill it in:
       cp $K8S/01-secrets.example.yaml $K8S/01-secrets.yaml
       # replace every REPLACE_ME, e.g. with: openssl rand -base64 32"
! grep -q REPLACE_ME "$K8S/01-secrets.yaml" || fail "01-secrets.yaml still contains REPLACE_ME"
echo "    legacy app: $(kubectl -n ghassen-io get deploy pockito-ui -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo '?') replica(s) ready — it will not be touched"

if [ -z "${SKIP_BUILD:-}" ]; then
  step "Build and push images"
  for svc in pockito-core pockito-api pockito-mcp pockito-notification-worker; do
    echo "    $svc"
    docker build -q -f "$svc/Dockerfile" -t "$REGISTRY/$svc:$TAG" . >/dev/null
    docker push -q "$REGISTRY/$svc:$TAG" >/dev/null
  done
  echo "    pockito-webapp"
  docker build -q \
    --build-arg NUXT_APP_BASE_URL=/app/ \
    --build-arg NUXT_PUBLIC_API_BASE_URL=https://pockito.ghassen.io/api/v1 \
    --build-arg NUXT_PUBLIC_KEYCLOAK_ISSUER=https://auth.ghassen.io/realms/pockito \
    --build-arg NUXT_PUBLIC_KEYCLOAK_CLIENT_ID=pockito-webapp \
    -t "$REGISTRY/pockito-webapp:$TAG" pockito-webapp >/dev/null
  docker push -q "$REGISTRY/pockito-webapp:$TAG" >/dev/null
fi

step "Namespace, secrets and datastores"
kubectl apply -f "$K8S/00-namespace.yaml"
kubectl apply -f "$K8S/01-secrets.yaml"
kubectl apply -f "$K8S/10-postgres.yaml" -f "$K8S/11-redis.yaml" -f "$K8S/12-seaweedfs.yaml"
for s in pockito-postgres pockito-redis pockito-seaweedfs; do
  kubectl -n pockito rollout status "statefulset/$s" --timeout=600s
done

step "Pockito Core"
# Core migrates the schema on start-up, so it has to be healthy before anything calls it.
kubectl apply -f "$K8S/20-config.yaml"
kubectl apply -f "$K8S/30-pockito-core.yaml"
kubectl -n pockito rollout status deployment/pockito-core --timeout=600s

step "API, MCP, worker, webapp and the /old proxy"
kubectl apply -f "$K8S/31-pockito-api.yaml" \
              -f "$K8S/32-pockito-mcp.yaml" \
              -f "$K8S/33-pockito-notification-worker.yaml" \
              -f "$K8S/34-pockito-webapp.yaml" \
              -f "$K8S/40-pockito-old-compat.yaml"
for d in pockito-api pockito-mcp pockito-notification-worker pockito-webapp pockito-old-compat; do
  kubectl -n pockito rollout status "deployment/$d" --timeout=600s
done

step "Everything is running. The next step changes what the public hostname serves."
cat <<'NOTE'
    Applying the IngressRoute re-points https://pockito.ghassen.io from the legacy
    application to the new platform. The legacy app keeps running and stays reachable at
    /old; nothing is deleted. To undo it: ./infra/k8s/rollback.sh
NOTE
if [ -t 0 ] && [ -z "${ASSUME_YES:-}" ]; then
  read -r -p "    Cut the hostname over now? [y/N] " reply
  case "$reply" in [yY]*) ;; *) echo "    Stopped before the cutover. Re-run with ASSUME_YES=1 when ready."; exit 0;; esac
fi

step "Traefik routing"
# The storage hostname is new, and Let's Encrypt cannot issue for a name that does not
# resolve. Warn rather than stop: everything except avatars works without it, and the
# route starts serving as soon as the record and the certificate catch up.
if ! getent hosts files.pockito.ghassen.io >/dev/null 2>&1 \
   && ! host files.pockito.ghassen.io >/dev/null 2>&1; then
  echo "    WARNING: files.pockito.ghassen.io does not resolve. Point it at the same"
  echo "             address as pockito.ghassen.io, or pre-signed avatar URLs will fail."
fi
kubectl apply -f "$K8S/50-ingressroute.yaml"
sleep 5

step "Verify"
probe(){ printf '    %-34s ' "$1"; curl -s -o /tmp/pd.txt -w 'HTTP %{http_code}\n' --max-time 30 "$2"; }
probe "/            → into /app/"      https://pockito.ghassen.io/
probe "/app/        → new webapp"      https://pockito.ghassen.io/app/
probe "/api/v1      → 401 expected"    https://pockito.ghassen.io/api/v1/bootstrap
probe "/mcp         → 401 expected"    https://pockito.ghassen.io/mcp
probe "/old/        → legacy app"      https://pockito.ghassen.io/old/
# 403 is the pass here: Traefik routed it and SeaweedFS rejected the unsigned request.
probe "files host  → 403 expected"     https://files.pockito.ghassen.io/pockito/nothing.jpg
printf '    %-34s %s\n' "/old/ base href" \
  "$(curl -s --max-time 30 https://pockito.ghassen.io/old/ | grep -oE '<base href="[^"]*">' | head -1)"

cat <<'NOTE'

    Deployed. Two checks a status code cannot make for you:

      1. Open https://pockito.ghassen.io/old/ in a browser. Confirm the legacy app renders
         and navigates — not just that it returns 200.
      2. Sign in at https://pockito.ghassen.io/app/, complete onboarding, upload an avatar,
         then reload and confirm the session and preferences survive.

    Keycloak still needs the four Pockito clients if they are not there yet — see
    docs/keycloak.md. Do not re-import the realm; it would destroy existing users.
NOTE
