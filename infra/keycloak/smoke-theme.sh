#!/usr/bin/env bash
# Verifies that a running local Keycloak serves the active Pockito theme and
# its production assets. This does not create users or mutate the realm.
set -euo pipefail

KEYCLOAK_URL="${KEYCLOAK_URL:-http://localhost:8180}"
CLIENT_ID="${KEYCLOAK_CLIENT_ID:-pockito-webapp}"
REDIRECT_URI="${KEYCLOAK_REDIRECT_URI:-http://localhost:3000/auth/callback}"
PAGE=$(mktemp)
trap 'rm -f "$PAGE"' EXIT

encoded_redirect=$(python3 -c 'import sys,urllib.parse; print(urllib.parse.quote(sys.argv[1], safe=""))' "$REDIRECT_URI")
auth_url="$KEYCLOAK_URL/realms/pockito/protocol/openid-connect/auth?client_id=$CLIENT_ID&redirect_uri=$encoded_redirect&response_type=code&scope=openid&state=theme-smoke&nonce=theme-smoke&code_challenge=AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA&code_challenge_method=S256"

curl -fsS "$auth_url" > "$PAGE"
grep -q '<title>Sign in to Pockito</title>' "$PAGE"

css_path=$(sed -n 's/.*href="\([^"]*\/pockito\.css\)".*/\1/p' "$PAGE" | head -1)
if [ -z "$css_path" ]; then
  echo "Pockito stylesheet was not linked by the active realm theme" >&2
  exit 1
fi

curl -fsS "$KEYCLOAK_URL$css_path" | grep -q -- 'Reference-matched login composition'
resource_base=${css_path%/css/pockito.css}

grep -q 'class="pk-brand-panel"' "$PAGE"
grep -q 'class="pk-mobile-brand"' "$PAGE"
grep -q 'class="pk-auth-footer"' "$PAGE"

for asset in \
  pockito-logo-light.svg \
  pockito-logo-dark.svg \
  kito-welcome.png \
  favicon.ico; do
  curl -fsS -o /dev/null "$KEYCLOAK_URL$resource_base/img/$asset"
done

for asset in \
  auth/pockito-logo.svg \
  auth/kito-login.png \
  auth/login-hero.png \
  auth/login-hero@2x.png \
  auth/login-hero.webp \
  auth/login-hero@2x.webp; do
  curl -fsS -o /dev/null "$KEYCLOAK_URL$resource_base/img/$asset"
done

# Account and email assets use the same version hash but their own theme type.
account_base=${resource_base/\/login\//\/account\/}
email_base=${resource_base/\/login\//\/email\/}
curl -fsS "$KEYCLOAK_URL$account_base/css/pockito-account.css" | grep -q -- '--pk-primary'
curl -fsS -o /dev/null "$KEYCLOAK_URL$account_base/img/pockito-logo.svg"
curl -fsS -o /dev/null "$KEYCLOAK_URL$email_base/img/pockito-logo.png"

echo "Pockito login, account, and email theme assets are active and reachable."
