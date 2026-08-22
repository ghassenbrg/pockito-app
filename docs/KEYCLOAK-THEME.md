# Pockito Keycloak theme

Pockito Authentication is a complete customer-facing theme for the Nuxt web
app, Flutter OAuth flow, normal browsers, Custom Tabs, and
`ASWebAuthenticationSession`. It is built and tested against **Keycloak
26.4.7**, the exact patch pinned by the local and production image.

The theme changes presentation only. Keycloak still owns validation, CSRF,
credentials, required actions, passkeys, sessions, email actions, and all
OAuth/OIDC redirects.

## Project integration

```text
infra/keycloak/
├── Dockerfile                         deterministic production image
├── realm-pockito.json                 selects all three Pockito themes
├── smoke-theme.sh                     live asset/shell smoke
└── themes/pockito/
    ├── login/
    │   ├── theme.properties           inherits keycloak.v2
    │   ├── template.ftl               shared responsive product shell
    │   ├── footer.ftl                 product/help/legal footer
    │   ├── messages/                  Pockito English/Japanese strings
    │   └── resources/                 tokens, components, logo, Kito
    ├── account/
    │   ├── theme.properties           inherits keycloak.v3 Account Console
    │   └── resources/                 Account Console skin and current logo
    └── email/
        ├── theme.properties           inherits Keycloak email messages/bodies
        ├── html/template.ftl          responsive transactional wrapper
        ├── messages/                  English/Japanese security footer
        └── resources/                 email-safe current logo PNG
```

`infra/local/compose.yml` builds this image and adds a read-only source mount
for live local editing. Production receives the same directory from
`infra/keycloak/Dockerfile`; it never depends on a manual server copy.

The realm sets:

```json
{
  "loginTheme": "pockito",
  "accountTheme": "pockito",
  "emailTheme": "pockito"
}
```

Existing deployed realms are not re-imported. Apply those settings with
`kcadm.sh` after deploying the image.

## Branding decision

The existing wallet-style Pockito logo is intentionally preserved. The task's
later product decision superseded the proposed blue/cyan `P` reconstruction;
no replacement logo system is introduced by this theme.

The current files remain the sources used by authentication:

- `login/resources/img/pockito-logo-light.svg` on light form surfaces;
- `login/resources/img/pockito-logo-dark.svg` on the navy brand panel;
- `login/resources/img/favicon.svg` and `favicon.ico` for browser chrome;
- `account/resources/img/pockito-logo.svg`, using the current dark-background
  lockup in the Account Console masthead;
- `email/resources/img/pockito-logo.png`, an email-safe transparent export of
  the current light-background lockup.

Kito comes from the existing official
`pockito-mobile/assets/mascot/kito/runtime/kito-welcome.png`. The theme ships one
optimized copy; an unused derivative was removed.

## Login-theme architecture

The parent is `keycloak.v2`. All Keycloak 26 page templates, fields, provider
buttons, ARIA attributes, localization keys, secure hidden fields, and scripts
continue to come from the matching Keycloak release.

Only two parent templates are overridden:

1. `template.ftl` is copied from **Keycloak 26.4.7** because the supplied design
   requires structural content that CSS cannot add safely: the desktop brand
   panel, responsive Kito block, and mobile trust block.
2. `footer.ftl` supplies the configurable product/help/legal footer once for
   every page.

No individual login, registration, reset, OTP, WebAuthn, consent, broker,
device, info, or error page is copied. New Keycloak 26 flows therefore inherit
the Pockito shell instead of dropping to stock styling.

When Keycloak changes patch versions, compare the upstream `template.ftl`
before deployment; see the upgrade checklist below.

## Design system

`login/resources/css/pockito.css` centralizes semantic tokens and components.
Its values follow:

- `pockito-webapp/app/assets/css/main.css`;
- `pockito-mobile/lib/ui/core/design_system/pk_tokens.dart`;
- `pockito-mobile/lib/ui/core/design_system/pk_theme.dart`.

| Role | Light | Dark |
|---|---:|---:|
| Page | `#f7f9fd` | `#071625` |
| Surface | `#ffffff` | `#0d2239` |
| Field | `#f0f5fa` | `#091b2e` |
| Primary text | `#071625` | `#f8fafc` |
| Secondary text | `#324b65` | `#94a3b8` |
| Border | `#dde7f0` | `#1e3954` |
| Primary action | `#286cf2` | `#7eb5ff` |
| Danger | `#d01640` | `#fb7185` |
| Success | `#047857` | `#34d399` |

The component layer covers fields, password visibility, check/radio/select
controls, buttons, links, provider buttons, separators, notices, validation,
disabled/read-only states, authenticator lists, QR codes, OTP fields, recovery
codes, consent lists, clipboard content, terms, and long dynamic text.

Provider buttons use an auto-fitting grid. One, two, or many providers work;
the layout does not assume Google and Apple. The current realm has no external
identity providers, so provider/broker styling is structurally covered but was
not claimed as a live realm test.

## Responsive behavior

- **840 px and wider:** two-pane authentication product with Kito/brand content
  and a constrained form card.
- **600–839 px:** centered tablet card without a compressed decorative panel.
- **Below 600 px:** mobile-first single column, current logo, compact language
  selector, 48 px controls, safe-area padding, and a post-form Kito/trust block.
- **Short landscape:** form-only presentation; Kito is hidden and the document
  scrolls rather than shrinking controls.
- **Below 360 px:** emergency 12 px gutter and wrapping provider/footer layout.

No fixed form height is used. Long translations, errors, profile attributes,
recovery codes, password-manager UI, keyboard resizing, and browser chrome can
increase document height without horizontal overflow.

Verified login widths/heights with no horizontal overflow:

```text
1920x1080  1440x900  1280x800  1024x768  768x1024
430x932    390x844   375x812   360x800   844x390
320x568 stress check
```

## Localization, RTL, accessibility, and appearance

Keycloak owns standard copy. Pockito-specific shell/footer/email strings are in
English and Japanese message bundles. Japanese login, registration, validation,
and password recovery were exercised live at 390x844. Logical CSS properties
and Keycloak's `dir` attribute preserve RTL structure.

The theme preserves semantic labels, field relationships, native autocomplete,
logical tab order, screen-reader error text, and Keycloak's password visibility
control. It adds 2 px visible focus outlines, 48 px touch targets, forced-color
fallbacks, reduced-motion handling, and wrapping for long messages.

`darkMode=true` uses Keycloak 26's supported `prefers-color-scheme` integration.
The login page was exercised live in dark mode at 1440x900. Cross-origin app
storage and unsigned query-string theme hints are intentionally not used.

## Mobile OAuth context and security

Flutter continues to use `flutter_appauth`, Chrome Custom Tabs on Android, and
`ASWebAuthenticationSession` on iOS. The theme does not move authentication
into JavaScript and does not change callback URIs, PKCE, OAuth state, nonce,
CSRF, password handling, or token validation.

Inherited autocomplete values preserve email keyboards, password managers,
current/new-password behavior, and `one-time-code` autofill. The document—not a
fixed-height wrapper—scrolls when the mobile keyboard reduces visual height.

## Account Console

The customer-facing Account Console inherits `keycloak.v3`; no React bundle or
page template is forked. `pockito-account.css` skins the masthead, current logo,
navigation, content surfaces, forms, buttons, notices, and mobile layout.

Live checks used a temporary local user at 1440x900 and 390x844, including
Personal Info fields and nested mobile scrolling. The temporary users and OTP
credential created for verification were deleted afterwards. The Admin Console
is deliberately unchanged.

## Email theme

All Keycloak HTML email bodies inherit one responsive Pockito wrapper. It adds
the current logo, restrained card layout, and localized security footer while
the upstream templates continue to provide verify-email, reset-password,
execute-actions, identity-link, workflow, organization, and security-event
content. Upstream plain-text fallbacks remain intact.

The HTML template and resources are present in the production image and served
by Keycloak. A live multipart `execute-actions-email` delivery was captured
through a temporary local SMTP sink: the upstream plain-text fallback, branded
HTML wrapper, current logo URL, action link, expiry copy, and security footer
were all present. The temporary SMTP configuration and user were removed after
the check. Repeat one delivery smoke against the production SMTP provider in
staging.

## Local development

From the repository root:

```bash
docker compose -f infra/local/compose.yml up -d --build keycloak
infra/keycloak/smoke-theme.sh
```

Local Compose disables only theme/template/static caches so edits appear after
refresh. Production does not disable caches.

On an existing local database, enable all surfaces without deleting users:

```bash
docker exec pockito-local-keycloak-1 /opt/keycloak/bin/kcadm.sh \
  config credentials --server http://localhost:8180 \
  --realm master --user admin --password admin

docker exec pockito-local-keycloak-1 /opt/keycloak/bin/kcadm.sh \
  update realms/pockito \
  -s loginTheme=pockito -s accountTheme=pockito -s emailTheme=pockito
```

Useful entry points:

```text
http://localhost:8180/realms/pockito/account
http://localhost:8180/realms/pockito/protocol/openid-connect/auth
```

Use the web/mobile clients to generate complete authorization URLs. Do not
hand-edit action URLs after a flow begins; their tab/session values expire.

### Representative state tests

- Submit login or registration empty to exercise field validation.
- Use Register and Forgot Password from a fresh authorization flow.
- Add `CONFIGURE_TOTP` to a temporary user's `requiredActions` to inspect QR,
  manual-secret, device-name, and validation states.
- Complete TOTP setup, then start a fresh login to inspect normal OTP entry.
- Use a disallowed redirect URI to inspect the branded HTTP 400 error page.
- Use `/realms/pockito/account` with a local test user to inspect Account
  Console navigation and forms.
- Configure local SMTP before testing reset/verify/action email delivery.

Never delete/re-import a deployed realm to refresh the theme; doing so deletes
users.

## Production deployment

Build from the repository root:

```bash
infra/keycloak/build-image.sh

# Release/CI publication:
PUSH=1 KEYCLOAK_TAG=26.4.7-pockito.1 infra/keycloak/build-image.sh
```

Publish/deploy that immutable image through the existing Keycloak deployment,
then apply the three realm theme settings with `kcadm.sh`. Do not change the
issuer, hostname, database, OAuth clients, or realm import strategy as part of
the theme rollout.

Rollback is selecting the prior image and prior theme settings. No credential
or token data is migrated by this change.

## Evidence-based coverage matrix

`Inherited` means the page uses the shared Pockito shell/component layer from
the exact Keycloak parent. It does **not** mean the realm feature was enabled
and completed live.

| Surface / flow | Themed | Live tested | Responsive evidence |
|---|---|---|---|
| Username/password login | Yes | Yes, EN/JA/light/dark | Full viewport matrix |
| Registration/profile fields | Yes | Yes, JA + validation | 390x844 |
| Forgot password | Yes | Yes, JA | 390x844 |
| Reset/update/temporary password | Inherited | No email action link | Shared shell/components |
| Verify/resend email | Inherited | Feature disabled locally | Shared shell/components |
| Configure TOTP, QR/manual secret | Yes | Yes | 390x844, no overflow |
| OTP entry and validation surface | Yes | Yes | 390x844 |
| Recovery codes/reset OTP | Inherited | Not enabled live | Static component audit |
| WebAuthn/passkey auth/register | Inherited | Not enabled live | Static Keycloak 26 audit |
| Required actions | Yes | `CONFIGURE_TOTP` live | 390x844 |
| Declarative profile/update email | Inherited | Registration + Account profile | Mobile/desktop |
| Terms | Inherited | Not required by realm | Static shell audit |
| OAuth consent | Inherited | Clients do not require consent | Static shell audit |
| Identity providers/broker/linking | Inherited | No providers configured | Dynamic grid audit |
| Logout/session expired/restart | Inherited | Restart control observed | Static shell audit |
| Device authorization | Inherited | No device client configured | Static Keycloak 26 audit |
| Error/info/success pages | Yes | Invalid redirect HTTP 400 | 390x844 |
| Account Console | Yes, `keycloak.v3` | Personal Info live | 1440x900, 390x844 |
| HTML email wrapper | Yes | Multipart action email delivered locally | Responsive static audit |
| Plain-text emails | Upstream | Delivered in same multipart smoke | Not layout-dependent |

## Upgrade checklist

1. Pin one exact new Keycloak patch in the Dockerfile and Compose.
2. Extract the new `keycloak-themes-<version>.jar`.
3. Diff upstream `keycloak.v2/login/template.ftl` against this override and
   reapply only the Pockito shell insertions.
4. Confirm `keycloak.v3` Account Console still accepts child `styles`, `logo`,
   and favicon properties.
5. Rebuild the image and run `infra/keycloak/smoke-theme.sh` against it without
   the local theme mount.
6. Repeat login, registration, forgot-password, TOTP, OTP, error, Account
   Console, Japanese, dark mode, and the viewport matrix.
7. Configure SMTP and deliver one reset and verification email in staging.

## Troubleshooting

- **Stock login:** confirm `loginTheme=pockito` and that `pockito.css` returns
  HTTP 200.
- **Stock account screen:** confirm `accountTheme=pockito`; account and login
  themes are separate settings.
- **Unbranded email:** confirm `emailTheme=pockito`, SMTP, and the HTML part of
  the message.
- **Stale local CSS:** confirm the read-only source mount and local cache flags,
  then use a private window.
- **Stale production CSS:** deploy a new immutable image tag; do not disable
  production theme caches.
- **Partly stock new flow:** inspect its Keycloak 26 markup and add a semantic
  selector before considering another template override.
