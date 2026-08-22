# Pockito API

Base path `/api/v1`. Every endpoint requires a Keycloak access token as a bearer token.
OpenAPI is served at `/v3/api-docs`.

| Method   | Path                        | Purpose                                                |
|----------|-----------------------------|--------------------------------------------------------|
| `GET`    | `/api/v1/bootstrap`         | Everything a client needs to start: profile, preferences, onboarding state, supported languages and currencies |
| `GET`    | `/api/v1/me`                | The authenticated user's profile                        |
| `PUT`    | `/api/v1/me`                | Update the display name                                 |
| `GET`    | `/api/v1/me/preferences`    | Language, appearance, default currency                  |
| `PUT`    | `/api/v1/me/preferences`    | Update all three                                        |
| `POST`   | `/api/v1/me/avatar`         | Upload or replace the avatar (multipart, field `file`)  |
| `GET`    | `/api/v1/me/avatar`         | Download the avatar bytes                               |
| `DELETE` | `/api/v1/me/avatar`         | Remove the avatar                                       |
| `POST`   | `/api/v1/onboarding/complete` | Submit onboarding and mark it done                    |

`GET /api/v1/bootstrap` is the single initialisation call, used identically by the mobile
app and the web app. That is deliberate: two clients deriving onboarding state their own way
is how they end up disagreeing about it.

## Errors

Every failure uses one shape:

```json
{
  "status": 400,
  "code": "preferences.currency.unsupported",
  "message": "Currency ZZZ is not supported",
  "correlationId": "5b8a2f1c-…",
  "timestamp": "2026-08-21T18:04:11Z",
  "violations": [{ "field": "displayName", "message": "must not be blank" }]
}
```

Branch on `code`, never on `message` — `message` is diagnostic, is not localised, and both
clients translate from the code instead of rendering it.

| Code                                | Status | Meaning                                    |
|-------------------------------------|--------|--------------------------------------------|
| `auth.unauthenticated`              | 401    | No token, or it is invalid or expired       |
| `access.denied`                     | 403    | Authenticated but not allowed               |
| `validation.failed`                 | 400    | Request body failed validation; see `violations` |
| `request.malformed`                 | 400    | Body could not be parsed                    |
| `profile.display_name.blank`        | 400    | Display name is empty                       |
| `preferences.currency.unsupported`  | 400    | Currency is not in the supported list       |
| `avatar.empty`                      | 400    | Uploaded file has no content                |
| `avatar.unsupported_type`           | 400    | Not PNG, JPEG or WebP                       |
| `avatar.too_large`                  | 400/413| Over 2 MB                                   |
| `avatar.not_found`                  | 404    | No avatar to fetch or remove                |
| `core.unreachable`                  | 503    | Core is down or timed out — retry           |
| `internal.error`                    | 500    | Unexpected; logged in full, opaque to clients |

## Correlation

Send `X-Correlation-Id` and it is echoed back and used in the logs of every service that
handles the request. Send nothing and one is minted at the edge. Either way the response
carries it, and so does the `correlationId` in an error body — so a user-reported failure
can be found without asking them what time it happened.

Client-supplied ids are validated before use: they end up in log files, so anything with
unexpected characters or excessive length is replaced rather than trusted.

## Avatars

Upload is `multipart/form-data` with a `file` part; PNG, JPEG and WebP up to 2 MB. The bytes
go to object storage and only metadata to Postgres.

`avatarUrl` on the profile is a short-lived pre-signed URL, regenerated per response rather
than stored, so the object stays private and a leaked URL expires. `GET /api/v1/me/avatar`
exists for clients that cannot reach object storage directly.
