#!/usr/bin/env bash
# Stands up a local Kubernetes cluster and applies the real manifests from infra/k8s, so
# they can be validated before they are applied anywhere that matters: workloads becoming
# ready, probes passing, PVCs surviving pod deletion, and Traefik routing every path to the
# right backend.
#
# Requires: kind, a container engine, and the compose stack in infra/local for Keycloak.
set -euo pipefail

export KIND_EXPERIMENTAL_PROVIDER="${KIND_EXPERIMENTAL_PROVIDER:-podman}"
ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"
K8S="$ROOT/infra/k8s"
CLUSTER=pockito

cd "$ROOT"

if ! kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; then
  kind create cluster --config "$K8S/kind-cluster.yaml"
fi
kubectl config use-context "kind-$CLUSTER"

echo "==> Traefik"
V=v3.6.2
BASE="https://raw.githubusercontent.com/traefik/traefik/$V/docs/content/reference/dynamic-configuration"
kubectl apply -f "$BASE/kubernetes-crd-definition-v1.yml"
kubectl apply -f "$BASE/kubernetes-crd-rbac.yml"
kubectl apply -f "$(dirname "$0")/traefik.yaml"
kubectl -n traefik rollout status deployment/traefik --timeout=180s

echo "==> images"
mvn -B -q package -DskipTests
tmp=$(mktemp -d)
for svc in pockito-core pockito-api pockito-mcp pockito-notification-worker; do
  ctx="$tmp/$svc"; mkdir -p "$ctx"
  cp "$svc/target/$svc-1.0.0-SNAPSHOT.jar" "$ctx/app.jar"
  printf 'FROM eclipse-temurin:25-jre-alpine\nWORKDIR /app\nCOPY app.jar app.jar\nENTRYPOINT ["java","-jar","/app/app.jar"]\n' > "$ctx/Dockerfile"
  docker build -q -t "ghassenbrg/$svc:1.0.0" "$ctx" >/dev/null
done
docker build -q --build-arg NUXT_APP_BASE_URL=/app/ \
  --build-arg NUXT_PUBLIC_API_BASE_URL=http://pockito.ghassen.io:8090/api/v1 \
  --build-arg NUXT_PUBLIC_KEYCLOAK_ISSUER=http://localhost:8180/realms/pockito \
  -t ghassenbrg/pockito-webapp:1.0.0 pockito-webapp >/dev/null

for img in pockito-core pockito-api pockito-mcp pockito-notification-worker pockito-webapp; do
  docker save -o "$tmp/$img.tar" "ghassenbrg/$img:1.0.0"
  kind load image-archive --name "$CLUSTER" "$tmp/$img.tar"
  # Podman tags local builds under localhost/; the manifests name docker.io.
  docker exec "$CLUSTER-control-plane" ctr -n k8s.io images tag \
    "localhost/ghassenbrg/$img:1.0.0" "docker.io/ghassenbrg/$img:1.0.0" 2>/dev/null || true
done
rm -rf "$tmp"

echo "==> manifests"
kubectl apply -f "$K8S/00-namespace.yaml"
python3 - "$K8S/01-secrets.example.yaml" <<'PY' | kubectl apply -f -
import secrets, sys, pathlib
tpl = pathlib.Path(sys.argv[1]).read_text()
for _ in range(tpl.count('REPLACE_ME')):
    tpl = tpl.replace('REPLACE_ME', secrets.token_urlsafe(24), 1)
print(tpl)
PY
kubectl apply -f "$K8S/10-postgres.yaml" -f "$K8S/11-redis.yaml" -f "$K8S/12-seaweedfs.yaml"
for s in pockito-postgres pockito-redis pockito-seaweedfs; do
  kubectl -n pockito rollout status "statefulset/$s" --timeout=300s
done

kubectl apply -f "$K8S/20-config.yaml"
kubectl apply -f "$(dirname "$0")/overlay.yaml"
kubectl apply -f "$(dirname "$0")/dify-stub.yaml"
kubectl apply -f "$K8S/30-pockito-core.yaml" -f "$K8S/31-pockito-api.yaml" \
              -f "$K8S/32-pockito-mcp.yaml" -f "$K8S/33-pockito-notification-worker.yaml" \
              -f "$K8S/34-pockito-webapp.yaml" -f "$K8S/40-pockito-old-compat.yaml"
kubectl apply -f "$(dirname "$0")/old-target.yaml"
kubectl apply -f "$(dirname "$0")/old-compat-upstream.yaml"
kubectl apply -f "$K8S/50-ingressroute.yaml"

for d in pockito-core pockito-api pockito-mcp pockito-notification-worker pockito-webapp pockito-old-compat; do
  kubectl -n pockito rollout status "deployment/$d" --timeout=300s
done

echo
echo "Cluster is up. Verify with:  infra/k8s/local-validation/verify.sh"
