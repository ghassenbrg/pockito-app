#!/usr/bin/env bash
# Creates a verified test user in the local Keycloak realm.
# Local development only — production users register through Keycloak's own screens.
set -euo pipefail

EMAIL="${1:?email required}"
PASSWORD="${2:?password required}"
KC="${KEYCLOAK_URL:-http://localhost:8180}"
REALM="${KEYCLOAK_REALM:-pockito}"
ADMIN_USER="${KEYCLOAK_ADMIN:-admin}"
ADMIN_PASSWORD="${KEYCLOAK_ADMIN_PASSWORD:-admin}"

TOKEN=$(curl -sS -X POST "$KC/realms/master/protocol/openid-connect/token" \
  -d grant_type=password -d client_id=admin-cli \
  -d "username=$ADMIN_USER" -d "password=$ADMIN_PASSWORD" \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')

STATUS=$(curl -sS -o /dev/null -w '%{http_code}' -X POST "$KC/admin/realms/$REALM/users" \
  -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' \
  -d "$(python3 - "$EMAIL" "$PASSWORD" <<'PY'
import json, sys
email, password = sys.argv[1], sys.argv[2]
print(json.dumps({
    "username": email,
    "email": email,
    "emailVerified": True,
    "enabled": True,
    "credentials": [{"type": "password", "value": password, "temporary": False}],
}))
PY
)")

case "$STATUS" in
  201) echo "Created $EMAIL" ;;
  409) echo "$EMAIL already exists" ;;
  *)   echo "Unexpected status $STATUS creating $EMAIL" >&2; exit 1 ;;
esac
