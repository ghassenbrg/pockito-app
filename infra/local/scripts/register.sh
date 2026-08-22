#!/usr/bin/env bash
# Creates a Pockito account the way the apps do: Keycloak's own registration screen,
# reached with prompt=create on an ordinary Authorization Code + PKCE request, ending in a
# token. Nothing here goes through Pockito — which is the point.
#
# Usage: register.sh <email> <password> [client-id] [redirect-uri]
set -euo pipefail

EMAIL="${1:?email required}"; PASSWORD="${2:?password required}"
CLIENT_ID="${3:-pockito-mobile}"
REDIRECT_URI="${4:-app.pockito.pockito://oauth2redirect}"
KC="${KEYCLOAK_URL:-http://localhost:8180}"
REALM="${KEYCLOAK_REALM:-pockito}"

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }
VERIFIER=$(openssl rand -base64 60 | tr -d '\n' | tr '+/' '-_' | tr -d '=')
CHALLENGE=$(printf '%s' "$VERIFIER" | openssl dgst -binary -sha256 | b64url)
COOKIES=$(mktemp); trap 'rm -f "$COOKIES"' EXIT

ENCODED=$(python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$REDIRECT_URI")
PAGE=$(curl -sS -c "$COOKIES" \
  "$KC/realms/$REALM/protocol/openid-connect/auth?client_id=$CLIENT_ID&response_type=code&scope=openid%20profile%20email&redirect_uri=$ENCODED&state=s&code_challenge=$CHALLENGE&code_challenge_method=S256&prompt=create")

ACTION=$(printf '%s' "$PAGE" | grep -oE 'action="[^"]*registration[^"]*"' | head -1 \
         | sed -e 's/^action="//' -e 's/"$//' -e 's/&amp;/\&/g')
[ -n "$ACTION" ] || { echo "Keycloak did not serve a registration form" >&2; exit 1; }

LOCATION=$(curl -sS -b "$COOKIES" -c "$COOKIES" -o /dev/null -D - \
  --data-urlencode "email=$EMAIL" \
  --data-urlencode "username=$EMAIL" \
  --data-urlencode "password=$PASSWORD" \
  --data-urlencode "password-confirm=$PASSWORD" \
  "$ACTION" | tr -d '\r' | awk 'tolower($1)=="location:"{print $2}')

CODE=$(printf '%s' "$LOCATION" | sed -n 's/.*[?&]code=\([^&]*\).*/\1/p')
[ -n "$CODE" ] || { echo "Registration did not return a code. Redirect: ${LOCATION:-<none>}" >&2; exit 1; }

curl -sS -X POST "$KC/realms/$REALM/protocol/openid-connect/token" \
  -d grant_type=authorization_code -d "client_id=$CLIENT_ID" -d "code=$CODE" \
  --data-urlencode "redirect_uri=$REDIRECT_URI" -d "code_verifier=$VERIFIER"
