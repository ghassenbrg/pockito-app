#!/usr/bin/env bash
# Obtains a Pockito access token by driving the real Authorization Code + PKCE flow
# against the local Keycloak, exactly as the webapp and the mobile app do.
#
# Direct access grants (password grant) are deliberately disabled on every Pockito client,
# so this script exercises the flow we actually ship rather than a test-only shortcut.
#
# Usage: get-token.sh <username> <password> [client-id] [redirect-uri]
set -euo pipefail

USERNAME="${1:?username required}"
PASSWORD="${2:?password required}"
CLIENT_ID="${3:-pockito-webapp}"
REDIRECT_URI="${4:-http://localhost:3000/auth/callback}"
KC="${KEYCLOAK_URL:-http://localhost:8180}"
REALM="${KEYCLOAK_REALM:-pockito}"

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }

VERIFIER=$(openssl rand -base64 60 | tr -d '\n' | tr '+/' '-_' | tr -d '=')
CHALLENGE=$(printf '%s' "$VERIFIER" | openssl dgst -binary -sha256 | b64url)
STATE=$(openssl rand -hex 12)
COOKIES=$(mktemp)
trap 'rm -f "$COOKIES"' EXIT

AUTH_URL="$KC/realms/$REALM/protocol/openid-connect/auth?client_id=$CLIENT_ID&response_type=code&scope=openid%20profile%20email&redirect_uri=$(printf '%s' "$REDIRECT_URI" | sed 's|:|%3A|g;s|/|%2F|g')&state=$STATE&code_challenge=$CHALLENGE&code_challenge_method=S256"

LOGIN_PAGE=$(curl -sS -c "$COOKIES" "$AUTH_URL")
FORM_ACTION=$(printf '%s' "$LOGIN_PAGE" \
  | grep -oE 'action="[^"]*login-actions/authenticate[^"]*"' \
  | head -1 | sed -e 's/^action="//' -e 's/"$//' -e 's/&amp;/\&/g')

if [ -z "$FORM_ACTION" ]; then
  echo "Could not find the Keycloak login form; is the client or redirect URI wrong?" >&2
  exit 1
fi

# --max-redirs 0 so the redirect to the app carries the code back to us instead of being followed.
LOCATION=$(curl -sS -b "$COOKIES" -c "$COOKIES" -o /dev/null -D - \
  --data-urlencode "username=$USERNAME" \
  --data-urlencode "password=$PASSWORD" \
  "$FORM_ACTION" | tr -d '\r' | awk 'tolower($1)=="location:"{print $2}')

CODE=$(printf '%s' "$LOCATION" | sed -n 's/.*[?&]code=\([^&]*\).*/\1/p')
if [ -z "$CODE" ]; then
  echo "Authentication did not return a code. Redirect was: ${LOCATION:-<none>}" >&2
  exit 1
fi

curl -sS -X POST "$KC/realms/$REALM/protocol/openid-connect/token" \
  -d grant_type=authorization_code \
  -d "client_id=$CLIENT_ID" \
  -d "code=$CODE" \
  --data-urlencode "redirect_uri=$REDIRECT_URI" \
  -d "code_verifier=$VERIFIER"
