# Connecting Pockito MCP to ChatGPT

How a Pockito user adds the MCP server as a ChatGPT connector, and what has to exist on our
side first.

The connector works in production as of 22 August 2026. Part 1 records what was built and
what has to be true of the deployed environment; Part 2 is the guide to hand to users.

Getting there took five separate failures, and every one of them reached the user as the same
sentence: *"There was a problem connecting Pockito."* ChatGPT's error text never once named a
cause. If you are here to debug rather than to read, skip to
[When it does not work](#when-it-does-not-work) — it is organised around getting a real error
out of a server, because guessing from the symptom does not work on this page.

## How it works

ChatGPT is given nothing but a URL. Everything else it discovers:

1. It calls `POST /mcp` with no token and gets `401` plus
   `WWW-Authenticate: Bearer resource_metadata="…"`.
2. It fetches that metadata document, which names Keycloak as the authorization server and
   states the resource identifier tokens must be minted for.
3. It reads Keycloak's own OpenID discovery document and runs Authorization Code with PKCE
   `S256` against the realm.
4. It calls `/mcp` again with the resulting bearer token, which `AudienceValidator` accepts
   because it carries `pockito-mcp` in `aud`.
5. Before the handshake it probes with `server/discover`, a method from a newer MCP revision
   than the one we implement. We answer in the single way that tells it to fall back to the
   `initialize` handshake we do speak — see [The protocol-era probe](#the-protocol-era-probe).

Every link has been exercised end to end against the deployed stack, ending in `tools/list`
over a real ChatGPT connector:

```
initialize            protocolVersion 2025-11-25, clientInfo openai-mcp
notifications/initialized
tools/list
```

## Part 1 — What was built

### The discovery document

Spring Security 7 publishes RFC 9728 metadata on its own, but its defaults are unusable
here in the way that matters most: it names **no authorization server at all**, so a client
that reads it still cannot find Keycloak, and it derives `resource` from the incoming
request — behind Traefik an internal `http://…:8082` URL, never the identifier the token is
minted for.

So the framework's endpoint is configured rather than replaced, in
[`SecurityConfig`](../pockito-mcp/src/main/java/io/ghassen/pockito/mcp/config/SecurityConfig.java):

```json
{
  "resource": "https://pockito.ghassen.io/mcp",
  "authorization_servers": ["https://auth.ghassen.io/realms/pockito"],
  "scopes_supported": ["openid", "profile", "email"],
  "bearer_methods_supported": ["header"],
  "resource_name": "Pockito",
  "tls_client_certificate_bound_access_tokens": false
}
```

It is served at both `/.well-known/oauth-protected-resource` and
`/.well-known/oauth-protected-resource/mcp`, identically — RFC 9728 appends the resource's
path, and clients disagree about which to try first. Both are `permitAll`; requiring a token
to learn how to obtain a token cannot work.

`resource` comes from `POCKITO_PUBLIC_BASE_URL`
([`McpDiscoveryProperties`](../pockito-mcp/src/main/java/io/ghassen/pockito/mcp/config/McpDiscoveryProperties.java))
rather than from the request, because it must equal the URL the user types into ChatGPT
exactly — a trailing slash apart is a failed connector.

### The challenge

The `authenticationEntryPoint` now sets `WWW-Authenticate` before writing the existing JSON
body. Without it a `401` tells a client nothing and discovery never starts. The JSON body is
kept, because it is what makes a `curl` against `/mcp` legible.

### The Keycloak client

`pockito-chatgpt` in [`realm-pockito.json`](../infra/keycloak/realm-pockito.json):
confidential, Authorization Code with PKCE `S256`, direct access grants off.

Two details are load-bearing.

**The audience mapper.** `AudienceValidator` rejects any token whose `aud` misses both
`pockito-api` and `pockito-mcp`. ChatGPT sends RFC 8707 `resource=` on the authorization and
token requests, but Keycloak does not turn that into an audience by itself, so the hardcoded
`oidc-audience-mapper` is what makes the token acceptable. Without it the user logs in
successfully and then every tool call returns `401` — the most confusing failure available.
Verified: a real PKCE exchange as this client yields `aud: ["pockito-mcp", "account"]`.

**Both redirect URIs.** ChatGPT uses the stable
`https://chatgpt.com/connector_platform_oauth_redirect` when the authorization server returns
`iss` on the authorization response, and a per-connector
`https://chatgpt.com/connector/oauth/{callback_id}` when it does not. The realm reports
`authorization_response_iss_parameter_supported: true`, so the stable one is what gets used —
but both are registered, because that flag is a realm setting someone could change.

It is confidential rather than public because ChatGPT is server-side and can hold a secret,
so there is no reason to weaken it. Dynamic client registration was not enabled: opening
anonymous registration on a realm holding real users, to save one manual step, is a bad trade.

### Routing

Traefik matched `PathPrefix(/mcp)` and nothing else, so `/.well-known/oauth-protected-resource`
fell through to the catch-all and reached the Nuxt app. A rule at priority 135 now sends it
to the MCP service. The priority is set explicitly, as everything in that file is.

**The manifests in this repo are not what runs.** Production is deployed from a separate
repository, `ghassen-io-infra`, whose `pockito/` directory is the source of truth for the
`pockito` namespace and owns `pockito.ghassen.io` outright. `infra/k8s/` here is a parallel
copy with different file numbering (`50-ingressroute.yaml` against
`pockito/60-ingressroute.yaml`). A routing change made only in this repo never ships, which
is exactly how the priority-135 rule sat written-and-unapplied while the connector failed.

Keycloak lives in that repo's other tree, `k8s/`, and needed a change of its own. RFC 8414
builds an authorization server's metadata URL by inserting `.well-known/…` *between* the
issuer's host and its path, so a client probes
`auth.ghassen.io/.well-known/oauth-authorization-server/realms/pockito`. Keycloak serves only
the appended form and returns 404 for that one. A `kc-wellknown-rewrite` middleware maps one
onto the other. Without it a client reads no metadata at all and reports that the server
advertises no PKCE support — an error that names the wrong subsystem entirely.

### The protocol-era probe

MCP revision `2026-07-28` added `server/discover`, which a client sends before anything else
to learn a server's supported versions. Spring AI has no handler for it, and its stateless
transport answers an unhandled method with `500` and a plain body. That is the one response
the specification gives a client no way to act on: the documented fallback — on `400`, if the
body is not a recognised modern JSON-RPC error, fall back to `initialize` — is keyed on 400,
so a 500 strands the client and the connection fails with nothing in ChatGPT's message to
suggest why.

[`LegacyEraProbeFilter`](../pockito-mcp/src/main/java/io/ghassen/pockito/mcp/config/LegacyEraProbeFilter.java)
answers the probe with `400` and a body that is deliberately *not* a JSON-RPC error, which is
what makes the client stop treating us as a draft-era server. Two things about it are
load-bearing and easy to undo by accident:

- It matches **only** `server/discover`. It is not a general "unknown method → 400" rule; a
  method that reaches an unhandled state later is a real fault and should still surface as a
  500 rather than be relabelled a bad request.
- It is registered **after** `AuthorizationFilter`, so an unauthenticated probe still gets the
  401 and `WWW-Authenticate` that start OAuth discovery. Registering it earlier would fix the
  handshake by breaking the connector setup that precedes it.

**This filter is temporary.** Delete it when the MCP Java SDK implements `2026-07-28` and
returns `404` with JSON-RPC `-32601` for unknown methods, as the revision requires. Do not
"fix" it by implementing `server/discover` for real: answering claims we speak that revision,
and the client would then send per-request `_meta`, `MCP-Protocol-Version` headers and
multi-round-trip results the SDK underneath cannot handle.

### The deployed realm

The realm file is **never re-imported into production** — that destroys the users. Everything
below is applied to the live realm on its own, and the file
([`realm-pockito.json`](../infra/keycloak/realm-pockito.json), duplicated byte-for-byte at
`ghassen-io-infra/keycloak/realm-pockito.json` — edit both) only governs fresh and local
realms.

**The client.** Add it on its own:

```bash
kcadm.sh create clients -r pockito -f - <<'JSON'
{ "clientId": "pockito-chatgpt", "name": "ChatGPT Connector",
  "protocol": "openid-connect", "publicClient": false,
  "standardFlowEnabled": true, "implicitFlowEnabled": false,
  "directAccessGrantsEnabled": false, "serviceAccountsEnabled": false,
  "redirectUris": ["https://chatgpt.com/connector_platform_oauth_redirect",
                   "https://chatgpt.com/connector/oauth/*"],
  "attributes": { "pkce.code.challenge.method": "S256" },
  "protocolMappers": [
    { "name": "pockito-mcp-audience", "protocol": "openid-connect",
      "protocolMapper": "oidc-audience-mapper",
      "config": { "included.client.audience": "pockito-mcp",
                  "id.token.claim": "false", "access.token.claim": "true" } } ] }
JSON
```

Then read the generated secret from the client's Credentials tab. It is entered once into
ChatGPT's connector settings and never seen by users — treat it as a secret, and note that
it does **not** belong in `pockito-config` or any cluster manifest, because our services
never use it.

**`offline_access`.** ChatGPT requests the `offline_access` scope, because a connector needs a
refresh token to stay connected. Keycloak issues an offline token only when both the user
holds the `offline_access` realm role and the client is permitted the scope; if either is
missing the token exchange fails with `not_allowed` and `"Offline tokens not allowed for the
user or client"`. Check both:

- Realm roles → `default-roles-pockito` → *Associated roles* contains `offline_access`.
- Clients → `pockito-chatgpt` → *Client scopes* lists `offline_access` as **Optional**.

Adding the role to the composite takes effect for existing users immediately, since composites
resolve at token time.

**A trap in this realm's roles.** `realm-pockito.json` used to set `"defaultRoles": ["USER"]`,
the field Keycloak dropped in version 13. Keycloak 25 ignores it silently and builds
`default-roles-pockito` from its own stock defaults, so the intended grant never happened:
**no user in the deployed realm holds `USER`.** The file now uses the modern `defaultRole`
plus an explicit composite, which fixes fresh imports. The deployed realm is still missing it.
Before relying on `USER` anywhere, add it to the composite by hand.

### Verifying a deployment

```bash
curl -s https://pockito.ghassen.io/.well-known/oauth-protected-resource | python3 -m json.tool
```

```bash
curl -si -X POST https://pockito.ghassen.io/mcp -d '{}' | grep -i www-authenticate
```

```bash
curl -s https://auth.ghassen.io/realms/pockito/.well-known/openid-configuration \
  | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["authorization_endpoint"]); print(d["code_challenge_methods_supported"])'
```

```bash
curl -s -o /dev/null -w '%{http_code}\n' https://auth.ghassen.io/.well-known/oauth-authorization-server/realms/pockito
```

The first must show `resource: https://pockito.ghassen.io/mcp` and Keycloak under
`authorization_servers` — a redirect or HTML here means the priority-135 rule is not applied.
The second must show the challenge header. The third must give an authorization endpoint and a
list containing `S256`. The fourth must be `200`, not `404`; that is the RFC 8414 rewrite. If
any is wrong, the connector fails at a point where ChatGPT's error message will not say why.

## Part 2 — Adding the connector (for users)

This is the part to publish in Pockito's help pages, once Part 1 is deployed.

> **You need a ChatGPT plan with Developer Mode.** Custom MCP connectors run through
> Developer Mode, which OpenAI makes available on Pro, Business/Team, Enterprise and Edu —
> not on Free, and not reliably on Plus. On Business and Enterprise, a workspace admin has to
> allow custom connectors before the option appears at all.

**1. Turn on Developer Mode.**
In ChatGPT on the web, open **Settings → Connectors → Advanced** and enable **Developer
mode**. On some plans this sits under **Settings → Security and login** instead. This is the
switch that lets you add a connector that OpenAI has not published itself.

**2. Add a custom connector.**
Still under **Settings → Connectors**, choose **Create** / **Add custom connector**.

**3. Fill in the connector.**

| Field | Value |
|-------|-------|
| Name | `Pockito` |
| Description | `My Pockito profile and preferences` |
| MCP server URL | `https://pockito.ghassen.io/mcp` |
| Authentication | **OAuth** |

The URL must be exactly that, with no trailing slash — it is also the identifier the token is
issued for, and a near-miss fails authentication rather than routing.

**4. Fill in OAuth advanced settings.**
ChatGPT discovers the endpoints, but it cannot discover a client identity, so that part is
typed in. Open **OAuth advanced settings** and set:

| Section | Field | Value |
|---------|-------|-------|
| Client registration | Registration method | **User-Defined OAuth Client** |
| | OAuth Client ID | `pockito-chatgpt` |
| | OAuth Client Secret | from the client's Credentials tab in Keycloak |
| | Token endpoint auth method | `client_secret_basic` |
| Scopes | Default scopes | `openid, profile, email` |
| | Base scopes | `openid` |
| OAuth endpoints | Auth URL | `https://auth.ghassen.io/realms/pockito/protocol/openid-connect/auth` |
| | Token URL | `https://auth.ghassen.io/realms/pockito/protocol/openid-connect/token` |
| | Registration URL | *leave empty* |
| | Authorization server base | `https://auth.ghassen.io/realms/pockito` |
| | Resource | `https://pockito.ghassen.io/mcp` |
| OpenID support | — | optional; nothing here depends on it |

Three of these are worth understanding rather than copying.

**Token endpoint auth method must not be `none`,** which is the field's default.
`pockito-chatgpt` is confidential, and Keycloak does not list `none` among its supported
methods. Leaving it produces the most misleading failure available: the login page never
checks client authentication, so you sign in perfectly and only the invisible code-to-token
step is rejected.

**Registration URL must stay empty.** ChatGPT offers Dynamic Client Registration whenever that
field is populated, and Keycloak's default `Trusted Hosts` policy rejects anonymous
registration with `Host not trusted`. We do not enable DCR — see Part 1 — so the field being
blank is what keeps ChatGPT on the manual client.

**Resource must match byte for byte** the `resource` value in our discovery document. It is
the identifier tokens are minted for; a trailing slash is a failed connector.

There is no field here for the token's audience. ChatGPT sends RFC 8707 `resource=`, Keycloak
ignores it, and `pockito-mcp` reaches the token only through the `oidc-audience-mapper`. If
every tool call returns 401, nothing on this page will fix it.

**5. Sign in to Pockito.**
Saving the connector opens the Pockito login page at `auth.ghassen.io`. Sign in with the
same account you use in the Pockito app. If you do not have one yet, create it in the app
first; the connector cannot register you.

**6. Approve the connection.**
Keycloak shows what ChatGPT is asking for. Approve it, and you land back in ChatGPT with the
connector listed.

**7. Enable it in a chat.**
Open a new conversation, and turn Pockito on in the connector or tools menu. Connectors are
per-conversation — a connector that is set up but not switched on will be ignored, which
looks identical to one that is broken.

**8. Check it works.**
Ask: *"Using Pockito, what's my display name and default currency?"* ChatGPT should call
`get_my_profile` and `get_my_preferences` and answer from real data. If it answers without
calling a tool, or says it has no access, the connector is not enabled in this conversation.

### What you can ask for today

Two tools, both read-only:

| Tool | Answers questions like |
|------|------------------------|
| `get_my_profile` | *What name is on my Pockito account? Have I finished onboarding?* |
| `get_my_preferences` | *What's my default currency? What language is my Pockito set to?* |

There are no finance tools yet — no wallets, transactions or budgets — because there is no
finance domain behind them, and a tool that returns invented numbers is worse than a missing
one. ChatGPT cannot tell the difference; you would. Nothing here can change your data.

The connector also will not appear in **deep research**. Deep research requires a server to
expose tools named `search` and `fetch`, and Pockito exposes neither. Use it in ordinary
chat.

## When it does not work

Everything below produced the identical message in ChatGPT — *"There was a problem connecting
Pockito."* Do not try to read a cause out of that sentence; there isn't one in it. Find out
which hop failed first, then consult the table.

### Find the failing hop

Three places, in order. Each one tells you whether to stop or keep going.

**1. Keycloak's auth events.** The admin console's Events page crashes on Keycloak 25
(`Cannot destructure property 'rowData' of 'undefined'`), so read them from the pod log
instead. `KC_LOG_LEVEL=info,org.keycloak.events:debug` is set on the deployment for exactly
this reason — keep it until Keycloak is upgraded.

```bash
kubectl -n ghassen-io logs -f deploy/keycloak | grep "type="
```

| What you see | Where the failure is |
|--------------|----------------------|
| No `LOGIN` at all | Discovery: ChatGPT never reached the login page |
| `LOGIN`, then nothing | ChatGPT never redeemed the code — it failed on the redirect back |
| `LOGIN`, then `CODE_TO_TOKEN_ERROR` | Keycloak refused the token; the `error=` and `reason=` fields name the cause exactly |
| `LOGIN`, then `CODE_TO_TOKEN` | OAuth is fine. Go to step 2. |

**2. The MCP server's log.**

```bash
kubectl -n pockito logs -f deploy/pockito-mcp
```

A 401 here means the token was issued but rejected — an audience problem, not an OAuth one.
Silence means ChatGPT never called us.

**3. The protocol exchange,** if the first two are clean and it still fails. Set
`logging.level.io.modelcontextprotocol: DEBUG` in `application-k8s.yml` to see the JSON-RPC
messages themselves. A healthy connect reads `initialize` → `notifications/initialized` →
`tools/list`. Turn it back off afterwards: it logs full message bodies, tool arguments
included.

### What each failure was

| Symptom | Cause | Fix |
|---------|-------|-----|
| No option to add a custom connector | Plan without Developer Mode, or an admin has disabled it | Check the plan; on Business/Enterprise ask the workspace admin |
| `must advertise PKCE support with code_challenge_methods_supported containing S256` | ChatGPT read no authorization-server metadata at all — either `/.well-known/oauth-protected-resource` is not routed to the MCP service, or the RFC 8414 path-insert URL 404s | Verification commands 1 and 4 above. The message names PKCE but the fault is never PKCE |
| `Dynamic client registration failed … Policy 'Trusted Hosts' rejected` | ChatGPT chose DCR because a Registration URL was present | Clear the Registration URL and pick User-Defined OAuth Client. Do not enable anonymous DCR on a realm holding real users |
| Login succeeds, then a generic failure; Keycloak logs `CODE_TO_TOKEN_ERROR` with `invalid_client_credentials` | Token endpoint auth method is `none`, or the secret is stale | Set `client_secret_basic` and regenerate the secret. Regenerating is safe: no Pockito service uses it |
| Login succeeds; Keycloak logs `not_allowed`, `"Offline tokens not allowed for the user or client"` | ChatGPT asked for `offline_access` and Keycloak will not issue an offline token | Add `offline_access` to `default-roles-pockito` and confirm it is an Optional client scope on `pockito-chatgpt` |
| Login succeeds, `CODE_TO_TOKEN` is clean, `pockito-mcp` logs `Missing handler for request type: server/discover` | The client speaks a newer MCP revision than the SDK, and an unhandled method returns 500 — a status its fallback rules cannot act on | `LegacyEraProbeFilter` should be answering that probe with 400. If it is not, check it is still registered after `AuthorizationFilter` |
| Login succeeds, tools all fail with 401 | Token has no `pockito-mcp` audience | The `oidc-audience-mapper` is missing on `pockito-chatgpt` in the deployed realm |
| Redirect rejected by Keycloak | ChatGPT is using a callback URI the client does not list | Copy the exact redirect URI from the connector page into the client |
| Tools listed but never called | Connector not enabled in this conversation | Turn it on in the conversation's tools menu |
| Worked yesterday, `401` today | Refresh token expired or the session was revoked | Reconnect the connector to sign in again |

Each failed call carries a correlation id in the response and in `pockito-mcp`'s logs; it is
the fastest way to tell a rejected token from a Core error.

### Noise that is not a problem

`Missing handler for notification type: notifications/initialized` is expected. A stateless
server has no session state to advance when the client announces it is ready, so the SDK
registers no handler; notifications are answered `202 Accepted` either way.

## Notes for whoever maintains this

OpenAI moves the connector UI and the auth requirements more often than we ship. Two
directions worth watching: Client ID Metadata Documents, which would replace the
manually created client with a metadata URL ChatGPT publishes, and native RFC 8707 `resource`
handling in Keycloak, which would replace the hardcoded audience mapper with the real
mechanism. Neither is needed now, and both would simplify this page.

Everything in Part 1 is generic OAuth 2.1 discovery, not ChatGPT-specific. Claude, VS Code
and any other MCP client that speaks the authorization spec connect to the same endpoint
with no further work. The `server/discover` probe is likewise not a ChatGPT quirk — any client
on a current SDK will send it, so `LegacyEraProbeFilter` is what keeps every one of them
working, not just this connector.

### Things left undone

- **Two debug settings are deliberately on.** `logging.level.io.modelcontextprotocol: DEBUG`
  in `application-k8s.yml` should come off once the connector is trusted. Keycloak's
  `KC_LOG_LEVEL` event logging should stay until Keycloak is upgraded, because the admin
  console cannot show events on 25.0.0.
- **Upgrades that would remove code from this page.** `mcp-core` 2.0.0 → 2.0.1; Keycloak off
  25.0.0; and eventually an SDK implementing `2026-07-28`, which retires
  `LegacyEraProbeFilter` entirely.
- **`USER` is granted to nobody** in the deployed realm — see [The deployed
  realm](#the-deployed-realm). Nothing is known to depend on it, but nothing has been checked
  either.
- **A recreated Keycloak user orphans its Pockito profile.** Profiles are keyed on the `sub`
  claim (`UserProfile.keycloak_subject`, unique and non-updatable), so deleting and recreating
  a user in Keycloak silently mints a fresh, empty profile and strands the old one. Repointing
  it is a database update, not something the application can do.

See also: [mcp.md](mcp.md) for the server itself, [keycloak.md](keycloak.md) for the realm.
