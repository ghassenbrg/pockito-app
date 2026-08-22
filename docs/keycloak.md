# Keycloak

Keycloak owns identity. Pockito has no password field, no `POST /api/login`, and stores no
credential material of any kind.

The realm lives at `infra/keycloak/realm-pockito.json` and is imported automatically by the
local compose stack.

The realm selects the responsive `pockito` login theme. Its source, exact Keycloak image,
local preview workflow, inherited page coverage, responsive behavior, and rollout procedure
are documented in [KEYCLOAK-THEME.md](KEYCLOAK-THEME.md).

## The realm stays where it is

`https://auth.ghassen.io/realms/pockito`, unchanged. It is not being moved under
`pockito.ghassen.io/auth/*`: the issuer URL appears in the `iss` claim of every token
already in circulation and in every client's discovery document. Moving it would invalidate
all of them for no benefit. Authentication correctness beats a tidier path.

## Clients

| Client            | Type        | Flow                          | Redirect URIs                                                |
|-------------------|-------------|-------------------------------|--------------------------------------------------------------|
| `pockito-webapp`  | public      | Authorization Code + PKCE S256| `http://localhost:3000/*`, `https://pockito.ghassen.io/app/*` |
| `pockito-mobile`  | public      | Authorization Code + PKCE S256| `app.pockito.pockito://oauth2redirect`, `http://localhost:*/*`|
| `pockito-chatgpt` | confidential| Authorization Code + PKCE S256| `https://chatgpt.com/connector_platform_oauth_redirect`, `https://chatgpt.com/connector/oauth/*` |
| `pockito-api`     | bearer-only | none — validates tokens only  | —                                                            |
| `pockito-mcp`     | bearer-only | none — validates tokens only  | —                                                            |

The direct access grant (password grant) is **disabled on every client**. There is no way to
exchange a password for a token through Pockito, which is the point.

The two front-end clients are public and use PKCE, because neither a browser app nor a
mobile app can keep a client secret. The two back-end clients are bearer-only: they never
start a login, they only verify what arrives.

`pockito-chatgpt` is confidential: ChatGPT runs server-side and can hold a secret, so there
is no reason to weaken it to a public client. It exists because dynamic client registration
is deliberately not enabled — opening anonymous registration on a realm holding real users,
to save one manual step, is a bad trade. Its secret lives only in ChatGPT's connector
settings; no Pockito service ever uses it, so it belongs in no manifest of ours.

### Why the webapp is not `pockito-web`

`pockito-web` is the live legacy Angular application's client. The new Nuxt app gets its own
`pockito-webapp` so the two have independent redirect URIs and lifecycles — retiring the old
app later cannot disturb the new one.

## Audience

`pockito-webapp` and `pockito-mobile` each carry two audience mappers, adding `pockito-api`
and `pockito-mcp` to the access token's `aud`; `pockito-chatgpt` carries one, for
`pockito-mcp`. The resource servers check it.

ChatGPT sends RFC 8707 `resource=` throughout its OAuth flow, which is the mechanism that
*should* set the audience, but Keycloak does not honour it — hence the hardcoded mapper.
Removing it produces a login that appears to succeed followed by a `401` on every tool
call, which is the worst failure mode available. See [mcp-chatgpt.md](mcp-chatgpt.md).

Without an audience check, issuer and signature alone would accept a token minted for *any*
client in the realm — including one added later for something unrelated.

## User profile

The realm's declarative user profile makes `email` required and `firstName`/`lastName`
optional. Pockito's identity is email plus credentials; the display name is application
state, collected during onboarding and stored in Postgres.

This is not cosmetic. With Keycloak's defaults, first and last name are required, and a user
created without them is met by a `VERIFY_PROFILE` required action that blocks the login flow
before a token is ever issued.

## Registration

`registrationAllowed: true`, and both clients open it the standard way — `prompt=create` on
an ordinary Authorization Code request. The mobile app passes it as `promptValues`, the web
app as a `signinRedirect` argument. Neither renders a registration form of its own.

## Applying the realm

The local stack imports it on first start. To re-import after an edit without wiping the
databases:

```bash
KC=http://localhost:8180
T=$(curl -s -X POST "$KC/realms/master/protocol/openid-connect/token" \
     -d grant_type=password -d client_id=admin-cli -d username=admin -d password=admin \
     | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')

curl -s -X DELETE -H "Authorization: Bearer $T" "$KC/admin/realms/pockito"
curl -s -X POST -H "Authorization: Bearer $T" -H 'Content-Type: application/json' \
     --data @infra/keycloak/realm-pockito.json "$KC/admin/realms"
```

On the deployed realm, do **not** delete and re-import — that would destroy the existing
users. Add the new clients and the user-profile change through the admin console or
`kcadm.sh`:

```bash
kcadm.sh create clients -r pockito -f - <<'JSON'
{ "clientId": "pockito-webapp", "publicClient": true, "standardFlowEnabled": true,
  "directAccessGrantsEnabled": false,
  "redirectUris": ["https://pockito.ghassen.io/app/*"],
  "webOrigins": ["https://pockito.ghassen.io"],
  "attributes": { "pkce.code.challenge.method": "S256" } }
JSON
```

Then add the audience mappers, and repeat for `pockito-mobile`, `pockito-chatgpt`,
`pockito-api` and `pockito-mcp`. The JSON in `infra/keycloak/realm-pockito.json` is the reference for all four.

After deploying the Pockito Keycloak image, select its theme on the existing realm without
touching users or authentication flows:

```bash
kcadm.sh update realms/pockito \
  -s loginTheme=pockito -s accountTheme=pockito -s emailTheme=pockito
```

## Core → Keycloak Admin API

Core does not call the Admin API today, and it must never be used to validate an ordinary
request — that is what the JWKS-cached signature check is for. It is reserved for operations
that genuinely require administration: changing identity attributes, account disable and
delete, role management.
