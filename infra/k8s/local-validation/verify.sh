#!/usr/bin/env bash
# Checks the things a deployment has to get right, against the local cluster: every
# workload ready, Traefik routing each path to the correct backend, the legacy app genuinely
# working under /old, and object storage surviving a pod deletion.
set -uo pipefail

PASS=0; FAIL=0
ok(){ printf '  \033[32mPASS\033[0m %s\n' "$1"; PASS=$((PASS+1)); }
bad(){ printf '  \033[31mFAIL\033[0m %s\n        %s\n' "$1" "${2:-}"; FAIL=$((FAIL+1)); }
check(){ [ "$2" = "$3" ] && ok "$1" || bad "$1" "expected '$3', got '$2'"; }

R(){ curl -sk --resolve 'pockito.ghassen.io:8443:127.0.0.1' \
         --resolve 'files.pockito.ghassen.io:8443:127.0.0.1' "$@"; }
code(){ R -o /tmp/vr.txt -w '%{http_code}' --max-time 30 "$@"; }

echo "== Workloads =="
for w in pockito-core pockito-api pockito-mcp pockito-notification-worker pockito-webapp pockito-old-compat; do
  ready=$(kubectl -n pockito get deploy "$w" -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
  check "$w is ready" "${ready:-0}" "1"
done
for w in pockito-postgres pockito-redis pockito-seaweedfs; do
  ready=$(kubectl -n pockito get statefulset "$w" -o jsonpath='{.status.readyReplicas}' 2>/dev/null)
  check "$w is ready" "${ready:-0}" "1"
done
bound=$(kubectl -n pockito get pvc -o jsonpath='{.items[*].status.phase}' | tr ' ' '\n' | grep -c Bound)
check "all three PVCs are bound" "$bound" "3"

echo
echo "== Traefik routing =="
check "/ redirects into /app/" "$(code https://pockito.ghassen.io:8443/)" "302"
check "/app/ serves the webapp" "$(code https://pockito.ghassen.io:8443/app/)" "200"
grep -q '<!DOCTYPE html>' /tmp/vr.txt && ok "/app/ returns HTML" || bad "/app/ HTML"
check "/api/v1 requires a token" "$(code https://pockito.ghassen.io:8443/api/v1/bootstrap)" "401"
grep -q 'auth.unauthenticated' /tmp/vr.txt && ok "/api/v1 uses the shared error shape" || bad "/api/v1 error shape"
check "/mcp requires a token" "$(code -XPOST https://pockito.ghassen.io:8443/mcp)" "401"
check "/old redirects to /old/" "$(code https://pockito.ghassen.io:8443/old)" "301"
check "HTTP redirects to HTTPS" "$(curl -s -o /dev/null -w '%{http_code}' --max-time 20 -H 'Host: pockito.ghassen.io' http://localhost:8090/app/)" "301"
# The object storage host reaches SeaweedFS, which rejects the unsigned request itself.
# 403 is the proof that matters: 404 would mean Traefik never routed it anywhere.
check "files host reaches object storage" "$(code https://files.pockito.ghassen.io:8443/pockito/nothing.jpg)" "403"
check "files host refuses writes" "$(code -XPUT https://files.pockito.ghassen.io:8443/pockito/nothing.jpg)" "404"

echo
echo "== The legacy app under /old =="
R --max-time 30 https://pockito.ghassen.io:8443/old/ -o /tmp/old.html >/dev/null
check "index loads" "$(grep -c '<app-root>' /tmp/old.html)" "1"
check "base href is rewritten" "$(grep -oE '<base href="[^"]*">' /tmp/old.html | head -1)" '<base href="/old/">'
missing=0
for a in $(grep -oE '(src|href)="[^"]*\.(js|css)"' /tmp/old.html | sed 's/.*="//;s/"//' | grep -v '^http' | sort -u); do
  ct=$(R -o /dev/null -w '%{content_type}' --max-time 30 "https://pockito.ghassen.io:8443/old/$a")
  case "$ct" in *javascript*|*css*) ;; *) missing=$((missing+1)); esac
done
check "every asset serves its real file (not the SPA fallback)" "$missing" "0"
check "translations resolve under the prefix" \
  "$(code https://pockito.ghassen.io:8443/old/assets/i18n/en.json)" "200"
check "SPA deep routes fall back to index" "$(code https://pockito.ghassen.io:8443/old/wallets)" "200"

echo
echo "== Object storage survives pod deletion =="
kubectl -n pockito exec pockito-seaweedfs-0 -- sh -c \
  'echo persistence-probe > /data/.probe' >/dev/null 2>&1
before=$(kubectl -n pockito exec pockito-seaweedfs-0 -- cat /data/.probe 2>/dev/null)
uid_before=$(kubectl -n pockito get pod pockito-seaweedfs-0 -o jsonpath='{.metadata.uid}')
kubectl -n pockito delete pod pockito-seaweedfs-0 --wait=true >/dev/null 2>&1
kubectl -n pockito rollout status statefulset/pockito-seaweedfs --timeout=300s >/dev/null 2>&1
uid_after=$(kubectl -n pockito get pod pockito-seaweedfs-0 -o jsonpath='{.metadata.uid}')
after=$(kubectl -n pockito exec pockito-seaweedfs-0 -- cat /data/.probe 2>/dev/null)
[ "$uid_before" != "$uid_after" ] && ok "the pod was genuinely replaced" || bad "pod not replaced"
check "data written before the deletion is still there" "$after" "$before"

echo
printf 'passed %d, failed %d\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
