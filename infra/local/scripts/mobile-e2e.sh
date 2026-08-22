#!/usr/bin/env bash
# Runs the mobile integration test against the running backend, on a booted simulator.
#
# Mints a brand-new Keycloak subject for every run, because the first test asserts
# first-login behaviour — reusing a subject that has already onboarded would fail for the
# wrong reason. The token comes from the same Authorization Code + PKCE flow the app uses.
#
# Usage: mobile-e2e.sh [device-udid]
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
MOBILE="$HERE/../../../pockito-mobile"
API="${API_URL:-http://localhost:8080/api/v1}"

DEVICE="${1:-$(xcrun simctl list devices booted -j \
  | python3 -c 'import json,sys
d=json.load(sys.stdin)["devices"]
print(next(x["udid"] for v in d.values() for x in v if x.get("state")=="Booted"))' 2>/dev/null)}"
[ -n "$DEVICE" ] || { echo "No booted simulator. Boot one with: xcrun simctl boot 'iPhone 17 Pro'" >&2; exit 1; }

EMAIL="mobile-e2e-$(date +%s)@example.test"
"$HERE/create-test-user.sh" "$EMAIL" 'Passw0rd!' >/dev/null

TOKEN=$("$HERE/get-token.sh" "$EMAIL" 'Passw0rd!' \
          pockito-mobile 'app.pockito.pockito://oauth2redirect' \
        | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')
[ -n "$TOKEN" ] || { echo "Could not obtain a token" >&2; exit 1; }

echo "Running the mobile flow as $EMAIL on $DEVICE against $API"
cd "$MOBILE"
exec flutter test integration_test/onboarding_flow_test.dart \
  -d "$DEVICE" \
  --dart-define=POCKITO_TEST_ACCESS_TOKEN="$TOKEN" \
  --dart-define=POCKITO_API_BASE_URL="$API"
