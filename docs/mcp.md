# Pockito MCP

The Model Context Protocol server, at `/mcp` on `pockito.ghassen.io`.

Like the REST API, it is an adapter: every tool delegates to Pockito Core, and no business
rule is implemented here.

## Transport

Stateless streamable HTTP (`spring.ai.mcp.server.protocol: stateless`). Each call is a
self-contained authenticated request, which suits a server behind Traefik with bearer tokens
and no session to keep.

## Authentication

Every request to `/mcp` needs a valid Keycloak access token. An AI client without one is
rejected at the edge of the service and never reaches a tool.

The token is then relayed to Core, which verifies it again on its own terms. It is carried
from the HTTP request into the tool through the MCP transport context rather than a
thread-local set in a filter — so it stays correct even if the protocol layer hands the call
to a different thread, and one client's token can never leak into another's request.

## Tools

| Tool                  | Returns                                                        |
|-----------------------|----------------------------------------------------------------|
| `get_my_profile`      | Display name, email, avatar URL, onboarding state               |
| `get_my_preferences`  | Language, appearance, default currency                          |

Both are annotated read-only and idempotent, so a client can call them without prompting the
user for confirmation.

There are deliberately no finance tools. There is no finance domain behind them yet, and a
tool that returns invented data is worse than a missing one — an AI client cannot tell the
difference.

## Trying it

```bash
TOKEN=$(infra/local/scripts/get-token.sh kito@example.test 'Passw0rd!' \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])')

curl -s -X POST http://localhost:8082/mcp \
  -H "Authorization: Bearer $TOKEN" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call",
       "params":{"name":"get_my_profile","arguments":{}}}'
```

## Discovery

A client that has only been given the URL finds its own way in. An unauthenticated call
returns `401` with a `WWW-Authenticate` header naming an RFC 9728 metadata document, served
at `/.well-known/oauth-protected-resource` and `/.well-known/oauth-protected-resource/mcp`;
that document names the Keycloak realm, and everything after it is ordinary OpenID Connect.

Spring Security publishes that document, but its defaults name no authorization server and
derive the resource identifier from the request, so both are set explicitly in
`SecurityConfig` — the identifier from `POCKITO_PUBLIC_BASE_URL`, because behind Traefik the
request does not know the URL the user actually typed.

This is generic OAuth 2.1, not specific to any one client. ChatGPT, Claude and any other MCP
client that speaks the authorization spec use the same path in.

## Using it from ChatGPT

Adding Pockito as a ChatGPT connector — the step-by-step guide for users, the `pockito-chatgpt`
Keycloak client behind it, and the one step still outstanding on the deployed realm — is in
[mcp-chatgpt.md](mcp-chatgpt.md).

## Adding a tool later

1. Add the operation to Core, if it does not exist.
2. Add an `@McpTool` method to `ProfileTools` (or a sibling class) that calls it through
   `CoreClient`, wrapped in `withCallerToken`.
3. Nothing else. Registration is automatic, and authentication and identity relay already
   apply.

The same Core operation should back the REST endpoint, so a capability behaves identically
whether a person or an agent invokes it.
