# Connecting Pockito MCP to ChatGPT

How a Pockito user adds the MCP server as a ChatGPT connector, and what has to exist on our
side first.

The server side is implemented and verified. Part 1 records what was built and the one
step that can only be done against the deployed environment; Part 2 is the guide to hand to
users.

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

Every link was exercised against the local stack, including a real PKCE login as the ChatGPT
client, ending in successful `tools/call` responses for both tools.

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
to the MCP service ([`50-ingressroute.yaml`](../infra/k8s/50-ingressroute.yaml)). The
priority is set explicitly, as everything in that file is.

### Step that remains: the deployed realm

`pockito-chatgpt` exists in the realm file and has been verified against the local Keycloak.
It still has to be created on the **deployed** realm at `auth.ghassen.io`, which cannot be
done from here. Do not delete and re-import the realm — that destroys the users. Add the
client on its own:

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

The first must show `resource: https://pockito.ghassen.io/mcp` and Keycloak under
`authorization_servers`; the second the challenge header; the third an authorization
endpoint and a list containing `S256`. If any is wrong, the connector fails at a point where
ChatGPT's error message will not say why.

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

**4. Sign in to Pockito.**
Saving the connector opens the Pockito login page at `auth.ghassen.io`. Sign in with the
same account you use in the Pockito app. If you do not have one yet, create it in the app
first; the connector cannot register you.

**5. Approve the connection.**
Keycloak shows what ChatGPT is asking for. Approve it, and you land back in ChatGPT with the
connector listed.

**6. Enable it in a chat.**
Open a new conversation, and turn Pockito on in the connector or tools menu. Connectors are
per-conversation — a connector that is set up but not switched on will be ignored, which
looks identical to one that is broken.

**7. Check it works.**
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

| Symptom | Cause | Fix |
|---------|-------|-----|
| No option to add a custom connector | Plan without Developer Mode, or an admin has disabled it | Check the plan; on Business/Enterprise ask the workspace admin |
| "Could not connect" straight away | Wrong URL, or `/.well-known` not routed to the MCP service | Re-check the URL; run the first verification command above |
| Login succeeds, tools all fail | Token has no `pockito-mcp` audience | The `oidc-audience-mapper` is missing on `pockito-chatgpt` in the deployed realm |
| Redirect rejected by Keycloak | ChatGPT is using a callback URI the client does not list | Copy the exact redirect URI from the connector page into the client |
| Tools listed but never called | Connector not enabled in this conversation | Turn it on in the conversation's tools menu |
| Worked yesterday, `401` today | Refresh token expired or the session was revoked | Reconnect the connector to sign in again |

Server-side, each failed call carries a correlation id in the response and in
`pockito-mcp`'s logs; it is the fastest way to tell a rejected token from a Core error.

## Notes for whoever maintains this

OpenAI moves the connector UI and the auth requirements more often than we ship. Two
directions worth watching: Client ID Metadata Documents, which would replace the
manually created client with a metadata URL ChatGPT publishes, and native RFC 8707 `resource`
handling in Keycloak, which would replace the hardcoded audience mapper with the real
mechanism. Neither is needed now, and both would simplify this page.

Everything in Part 1 is generic OAuth 2.1 discovery, not ChatGPT-specific. Claude, VS Code
and any other MCP client that speaks the authorization spec connect to the same endpoint
with no further work.

See also: [mcp.md](mcp.md) for the server itself, [keycloak.md](keycloak.md) for the realm.
