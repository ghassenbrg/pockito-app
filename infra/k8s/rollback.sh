#!/usr/bin/env bash
# Hands pockito.ghassen.io back to the legacy application.
#
# Only the routing is removed. The new workloads keep running in the `pockito` namespace
# with their data intact, so this is reversible in both directions: re-running deploy.sh
# puts the new platform back.
set -euo pipefail
K8S="$(cd "$(dirname "$0")" && pwd)"

kubectl delete -f "$K8S/50-ingressroute.yaml" --ignore-not-found
echo "Routing removed. The IngressRoute in ghassen-io-infra/k8s/80-ingressroutes.yaml now"
echo "serves pockito.ghassen.io again."
sleep 5
curl -s -o /dev/null -w 'https://pockito.ghassen.io/  HTTP %{http_code}\n' --max-time 30 https://pockito.ghassen.io/
