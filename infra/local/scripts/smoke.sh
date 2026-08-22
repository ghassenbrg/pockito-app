#!/usr/bin/env bash
# End-to-end smoke test of the Pockito foundation against the local stack.
#
# Drives the real Authorization Code + PKCE flow, then walks a brand-new user through
# first-login profile creation, onboarding, preferences and the avatar round-trip
# (API -> Core -> S3 -> SeaweedFS), asserting on every step.
set -uo pipefail

API="${API_URL:-http://localhost:8080}"
CORE="${CORE_URL:-http://localhost:8081}"
MCP="${MCP_URL:-http://localhost:8082}"
HERE="$(cd "$(dirname "$0")" && pwd)"

PASS=0
FAIL=0
ok()   { printf '  \033[32mPASS\033[0m %s\n' "$1"; PASS=$((PASS+1)); }
bad()  { printf '  \033[31mFAIL\033[0m %s\n    %s\n' "$1" "${2:-}"; FAIL=$((FAIL+1)); }
check(){ # check <description> <actual> <expected>
  if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected '$3', got '$2'"; fi
}

EMAIL="smoke-$(date +%s)@example.test"
PASSWORD='Passw0rd!'

echo "== Authentication =="
"$HERE/create-test-user.sh" "$EMAIL" "$PASSWORD" >/dev/null || { echo "could not create user"; exit 1; }
TOKENS=$("$HERE/get-token.sh" "$EMAIL" "$PASSWORD") || { echo "PKCE flow failed"; exit 1; }
TOKEN=$(printf '%s' "$TOKENS" | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')
REFRESH=$(printf '%s' "$TOKENS" | python3 -c 'import json,sys; print(json.load(sys.stdin)["refresh_token"])')
[ -n "$TOKEN" ] && ok "Authorization Code + PKCE returned an access token" || bad "PKCE flow"

AUD=$(printf '%s' "$TOKEN" | python3 -c '
import base64, json, sys
p = sys.stdin.read().split(".")[1]; p += "=" * (-len(p) % 4)
print(",".join(sorted(json.loads(base64.urlsafe_b64decode(p)).get("aud", []))))')
case "$AUD" in *pockito-api*) ok "token audience includes pockito-api" ;; *) bad "token audience" "$AUD" ;; esac

auth=(-H "Authorization: Bearer $TOKEN")
status() { curl -s -o /dev/null -w '%{http_code}' --max-time 10 "$@"; }
body()   { curl -s --max-time 10 "$@"; }
# Reads one or more dotted paths out of a JSON body on stdin, joined by "/".
jget()   { python3 -c '
import json, sys
d = json.load(sys.stdin)
out = []
for path in sys.argv[1:]:
    v = d
    for part in path.split("."):
        v = v[part]
    out.append(str(v))
print("/".join(out))' "$@"; }

echo
echo "== Authorization =="
check "unauthenticated API bootstrap is rejected" "$(status "$API/api/v1/bootstrap")" "401"
check "unauthenticated Core internal call is rejected" "$(status "$CORE/internal/v1/bootstrap")" "401"
check "unauthenticated MCP call is rejected" "$(status -X POST "$MCP/mcp")" "401"
check "garbage token is rejected" "$(status -H 'Authorization: Bearer not-a-token' "$API/api/v1/bootstrap")" "401"

echo
echo "== First login =="
BOOT=$(body "${auth[@]}" "$API/api/v1/bootstrap")
check "bootstrap succeeds" "$(status "${auth[@]}" "$API/api/v1/bootstrap")" "200"
check "new user needs onboarding" \
  "$(printf '%s' "$BOOT" | python3 -c 'import json,sys; print(json.load(sys.stdin)["onboardingRequired"])')" "True"
check "profile is linked to the Keycloak subject" \
  "$(printf '%s' "$BOOT" | python3 -c 'import json,sys; print(bool(json.load(sys.stdin)["profile"]["subject"]))')" "True"
check "default currency is EUR" \
  "$(printf '%s' "$BOOT" | python3 -c 'import json,sys; print(json.load(sys.stdin)["preferences"]["defaultCurrency"])')" "EUR"

echo
echo "== Validation =="
check "blank display name is rejected" \
  "$(status "${auth[@]}" -X PUT -H 'Content-Type: application/json' -d '{"displayName":"  "}' "$API/api/v1/me")" "400"
check "unsupported currency is rejected" \
  "$(status "${auth[@]}" -X PUT -H 'Content-Type: application/json' \
     -d '{"language":"EN","theme":"DARK","defaultCurrency":"XXX"}' "$API/api/v1/me/preferences")" "400"
check "malformed currency is rejected" \
  "$(status "${auth[@]}" -X PUT -H 'Content-Type: application/json' \
     -d '{"language":"EN","theme":"DARK","defaultCurrency":"eur1"}' "$API/api/v1/me/preferences")" "400"
ERR=$(body "${auth[@]}" -X PUT -H 'Content-Type: application/json' -d '{"displayName":""}' "$API/api/v1/me")
check "errors carry a correlation id" \
  "$(printf '%s' "$ERR" | python3 -c 'import json,sys; print(bool(json.load(sys.stdin).get("correlationId")))')" "True"

echo
echo "== Profile and preferences =="
check "display name updates" \
  "$(body "${auth[@]}" -X PUT -H 'Content-Type: application/json' -d '{"displayName":"Kito Tester"}' "$API/api/v1/me" \
     | python3 -c 'import json,sys; print(json.load(sys.stdin)["displayName"])')" "Kito Tester"
check "preferences update" \
  "$(body "${auth[@]}" -X PUT -H 'Content-Type: application/json' \
     -d '{"language":"JA","theme":"DARK","defaultCurrency":"JPY"}' "$API/api/v1/me/preferences" \
     | jget language theme defaultCurrency)" "JA/DARK/JPY"
check "preferences persist across requests" \
  "$(body "${auth[@]}" "$API/api/v1/me/preferences" \
     | python3 -c 'import json,sys; print(json.load(sys.stdin)["language"])')" "JA"

echo
echo "== Avatar =="
PNG=$(mktemp -t avatar).png
python3 - "$PNG" <<'PY'
import base64, sys
# 1x1 transparent PNG
open(sys.argv[1], "wb").write(base64.b64decode(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg=="))
PY
AV=$(body "${auth[@]}" -X POST -F "file=@$PNG;type=image/png" "$API/api/v1/me/avatar")
check "avatar upload succeeds" \
  "$(printf '%s' "$AV" | python3 -c 'import json,sys; print(bool(json.load(sys.stdin).get("objectKey")))')" "True"
check "avatar upload returns a pre-signed URL" \
  "$(printf '%s' "$AV" | python3 -c 'import json,sys; print(bool(json.load(sys.stdin).get("url")))')" "True"
check "avatar bytes round-trip through storage" \
  "$(curl -s --max-time 10 "${auth[@]}" "$API/api/v1/me/avatar" | wc -c | tr -d ' ')" \
  "$(wc -c < "$PNG" | tr -d ' ')"
check "profile exposes the avatar URL" \
  "$(body "${auth[@]}" "$API/api/v1/me" | python3 -c 'import json,sys; print(bool(json.load(sys.stdin).get("avatarUrl")))')" "True"

TXT=$(mktemp -t notimage).txt
echo "not an image" > "$TXT"
check "non-image upload is rejected" \
  "$(status "${auth[@]}" -X POST -F "file=@$TXT;type=text/plain" "$API/api/v1/me/avatar")" "400"

echo
echo "== Onboarding =="
DONE=$(body "${auth[@]}" -X POST -H 'Content-Type: application/json' \
  -d '{"displayName":"Kito Onboarded","preferences":{"language":"EN","theme":"LIGHT","defaultCurrency":"USD"}}' \
  "$API/api/v1/onboarding/complete")
check "onboarding completes" \
  "$(printf '%s' "$DONE" | python3 -c 'import json,sys; print(json.load(sys.stdin)["onboardingRequired"])')" "False"
check "onboarding applied the display name" \
  "$(printf '%s' "$DONE" | python3 -c 'import json,sys; print(json.load(sys.stdin)["profile"]["displayName"])')" "Kito Onboarded"
check "onboarding does not repeat on the next bootstrap" \
  "$(body "${auth[@]}" "$API/api/v1/bootstrap" | python3 -c 'import json,sys; print(json.load(sys.stdin)["onboardingRequired"])')" "False"

echo
echo "== Session restoration =="
NEW=$(curl -s --max-time 10 -X POST "${KEYCLOAK_URL:-http://localhost:8180}/realms/pockito/protocol/openid-connect/token" \
  -d grant_type=refresh_token -d client_id=pockito-webapp -d "refresh_token=$REFRESH" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin).get("access_token",""))')
[ -n "$NEW" ] && ok "refresh token yields a new access token" || bad "refresh token exchange"
check "refreshed token still reaches the same profile" \
  "$(curl -s --max-time 10 -H "Authorization: Bearer $NEW" "$API/api/v1/me" \
     | python3 -c 'import json,sys; print(json.load(sys.stdin)["displayName"])')" "Kito Onboarded"

echo
echo "== Avatar removal =="
check "avatar delete returns 204" "$(status "${auth[@]}" -X DELETE "$API/api/v1/me/avatar")" "204"
check "second delete reports not found" "$(status "${auth[@]}" -X DELETE "$API/api/v1/me/avatar")" "404"

rm -f "$PNG" "$TXT"
echo
printf 'passed %d, failed %d\n' "$PASS" "$FAIL"
[ "$FAIL" -eq 0 ]
