# Kito mascot and brand guide

## Official identity

**Name:** Kito  
**Role:** Pockito’s helpful money companion  
**Source of truth:** `assets/mascot/kito/source/kito-source-board.png`  
**Production master:** `assets/mascot/kito/source/kito-master.png`

Kito is cheerful, helpful, smart, curious, and gently playful. Kito encourages progress without judging spending choices, dramatizing financial problems, or competing with the user’s data.

Kito is a companion—not a chatbot persona, a game character, or a replacement for clear product language.

## Recognizable visual characteristics

- Soft 3D character with a rounded, compact silhouette.
- Deep cobalt upper body flowing into bright cyan at the lower body.
- Warm cream rectangular face opening.
- Large glossy navy eyes, minimal navy brows, and a small expressive mouth.
- Curved cobalt stem with one turquoise leaf.
- Tiny rounded arms and feet.
- Cream wallet with one warm-gold button when the scenario calls for a finance prop.
- Premium soft studio light and restrained material texture.

Do not change Kito into a flat vector robot, an animal, a human, or a generic blue blob. New artwork must preserve the face geometry, body proportions, palette, leaf, and silhouette.

## Core palette

| Role | Token | Hex |
|---|---|---:|
| Primary cobalt | `kitoBlue600` | `#1F55D5` |
| Deep cobalt | `kitoBlue700` | `#173FAD` |
| Bright blue | `kitoBlue500` | `#286CF2` |
| Aqua | `kitoAqua500` | `#17B6C8` |
| Leaf | `kitoLeaf` | `#45CED3` |
| Warm cream | `kitoCream50` | `#FFFBF4` |
| Gold accent | `kitoGold400` | `#F9B928` |
| Ink/navy | `kitoNavy900` | `#071625` |

The mascot palette informs the design system, but screens should not use every color at once. Cobalt is the primary action color, aqua supports positive movement and secondary emphasis, gold highlights shared money and meaningful milestones, cream warms selected surfaces, and navy keeps financial content trustworthy.

## Personality and expression rules

| Product moment | Expression or pose | Asset |
|---|---|---|
| Neutral/helpful | Happy default | `full-body/kito-default.png` |
| Welcome/encouragement | Open wave | `onboarding/kito-welcome.png` |
| Home insight/thinking/curiosity | Chart review | `tips/kito-thinking-insight.png` |
| Surprise/low confidence | Subtle “oh” receipt review | `expressions/kito-surprised.png` |
| Near-limit/overspending | Calm concern with gauge | `expressions/kito-concerned.png` |
| Error/confusion | Supportive puzzle inspection | `errors/kito-confused.png` |
| No notifications/rest | Peaceful sleeping pose | `notifications/kito-sleeping.png` |
| Empty transaction list | Optimistic empty-wallet pose | `empty-states/kito-first-transaction.png` |
| Scan/review | Receipt and magnifier | `poses/kito-receipt-review.png` |
| Shared Spaces | Kito and two companions | `illustrations/kito-shared-space.png` |
| CTA guidance | Pointing pose | `poses/kito-pointing.png` |
| Achievement/settlement/goal | Light celebration | `celebrations/kito-celebrating.png` |

These are intentionally reusable. “Happy,” “excited,” and “celebrating” can use the celebration asset at different scales; “thinking” and “curious” share the insight asset; “confused” and recoverable “error” share the puzzle asset. Do not generate a near-duplicate merely to change an eyebrow by a few pixels.

`PkEmptyState` resolves the pose from the state's icon, so a new empty or error
state gets the right Kito without each screen choosing one. The mapping lives in
`PkEmptyState._resolvedMascot` and is covered by `test/kito_brand_test.dart`; add
to it rather than passing a one-off `mascot:`. Two rules it encodes are easy to
get wrong: a recoverable error is never drawn with the optimistic empty-wallet
pose, and a finished settlement is never drawn like an unfinished one.

`kito-avatar.png` is a badge crop built for 32–56 px. It is not a substitute for
a full pose at illustration size — use `runtime/kito-default.png` instead.

The surface tone must agree with the pose. A budget that is over its limit gets
the concerned pose *and* the danger surface: a warning rendered in calm brand
blue stops being credible.

## When Kito should appear

- First-run welcome and meaningful onboarding transitions.
- One concise contextual insight on Home.
- AI-generated insight and approval identity.
- Purposeful empty, recoverable error, and quiet/resting states.
- Shared Space onboarding or empty state.
- Major success moments: first account, budget creation, settlement, or cycle completion.
- Receipt scan, low-confidence extraction, and review education.
- Optional tips that reduce confusion in a complex financial flow.

## When Kito should not appear

- Beside every transaction, account, category, or form field.
- For ordinary inline validation such as a missing required value.
- As decoration behind financial totals or tap targets.
- On every card in a list.
- In places where the character reduces chart or number legibility.
- During urgent security, irreversible deletion, or legal/compliance warnings.
- More than once as a prominent illustration in the same viewport.

## Runtime size and layout guidance

| Use | Typical CSS/Flutter size | Source |
|---|---:|---|
| Assistant avatar/badge | 32–56 px | `runtime/kito-avatar.png` |
| Inline message | 56–88 px | Runtime pose |
| Empty state | 120–168 px | Runtime pose |
| Onboarding hero | 160–240 px | `runtime/kito-welcome.png` |
| Celebration | 160–220 px | `runtime/kito-celebrating.png` |
| App icon source | 1254 px | `assets/brand/source/app-icon-master.png` |
| In-app brand mark | 30–88 px | `assets/brand/app-icon.png` via `PkWordmark` / `PkMark` |

- Use `BoxFit.contain`; never stretch Kito non-uniformly.
- Preserve the full leaf and intended hand gesture.
- Maintain at least 8% breathing room around the character silhouette.
- Runtime assets are capped at 768 px on the longest edge; the avatar is capped at 384 px.
- High-resolution masters stay outside the Flutter runtime asset bundle.
- Prefer transparent art. Campaign compositions may use an intentional background.

## Background handling

- On light surfaces, use transparent Kito art over white, warm cream, or pale Kito-blue surfaces.
- On dark surfaces, use transparent art over navy surfaces with enough edge contrast around the cobalt body.
- Never place Kito over a busy photo or chart.
- Never fake transparency with white, black, or a rendered checkerboard.
- App artwork must be verified for a real alpha channel before packaging.

## Light and dark modes

Kito’s original colors stay stable across themes. The surrounding surface changes:

- Light: `kitoCanvas`, white, `kitoBlue50`, or `kitoCream50`.
- Dark: `kitoNavy900`, `kitoNavy800`, or `kitoNavy700`.
- Do not recolor Kito for dark mode.
- Do not add a white sticker outline. Use a restrained halo or surface card only when edge contrast needs help.
- All copy remains outside the raster asset so contrast and localization can be controlled by Flutter.

## Accessibility

Kito is **decorative by default**. `KitoImage` excludes itself from semantics
unless a `semanticLabel` is passed, because the heading and body copy next to
the artwork already say what the state is — announcing the picture as well makes
a screen reader read every empty state twice. Pass a label only where the
artwork carries information no text repeats; the About screen is currently the
only such place.

## Interaction and motion principles

- Motion should explain arrival, feedback, or completion—not demand attention.
- Standard entrance: 250–350 ms fade plus no more than 6% vertical travel.
- Celebration may use one subtle bounce; never loop it.
- Thinking/blinking may be used only if a future animated asset is added and must stop after a few seconds.
- Motion must become instant when `MediaQuery.disableAnimations` is enabled.
- Kito must never block a primary button or delay a financial action.

## Tone of voice

Kito’s copy is short, observant, and non-judgmental:

- “You’re still comfortably inside this month’s plan.”
- “This receipt needs one quick check.”
- “Everyone is settled. Nice and tidy.”
- “Nothing here yet—your first transaction will appear here.”

Avoid:

- Baby talk, excessive emoji, or repeated exclamation marks.
- Shame: “You spent too much.”
- False certainty: “Your finances are perfect.”
- Human claims: “I checked your bank.”
- Vague AI language: “Magic found this.”

## Asset naming conventions

- Prefix every file with `kito-`.
- Use lowercase kebab-case.
- Name by meaning, not generation order: `kito-receipt-review.png`, not `kito-v7.png`.
- Use `-master` only for high-resolution canonical sources.
- Platform icons use platform-standard filenames after export.
- Runtime copies live in `assets/mascot/kito/runtime/` and are the only mascot directory declared in `pubspec.yaml`.

## App icon pipeline

Every packaged icon is generated from the master by
`tool/generate_app_icons.py`. Run it after any change to the master and commit
the results:

```bash
python3 tool/generate_app_icons.py
```

The brand master is drawn edge to edge with no baked corners, which is what iOS
and modern Android want: each platform applies its own mask, and an icon that
bakes in its own rounding stacks two shapes and shows slivers at the corners.
The generator derives each platform's shape from that single file:

| Target | Shape | Alpha | Kito coverage |
|---|---|---|---|
| iOS, all sizes | Full bleed square | Opaque (App Store requirement) | Master composition |
| Android legacy `ic_launcher` | Rounded square | Transparent corners | Master composition |
| Android `ic_launcher_round` | Circle | Transparent corners | Master composition |
| Android adaptive foreground | Square 108dp canvas | Transparent | 66dp safe zone |
| Web `Icon-192/512` | Rounded square | Transparent corners | Master composition |
| Web `Icon-maskable-*` | Full bleed square | Opaque | 70% of the canvas |
| In-app `PkMark` | Full bleed square | Opaque, `PkMark` clips | Master composition |

The adaptive foreground and the maskable icon need real transparency or a safe
zone, which the opaque edge-to-edge master cannot provide, so those two
composite `full-body/kito-default.png` over Pockito cobalt. That pose is the
only transparent asset that also carries the cream wallet with its warm-gold
button, so every packaged icon shows the same finance prop. It is cropped to the
bust the master frames — head, leaf and wallet, without the feet — because an
icon has to read at 48 px.

Do not try to shrink the master into the safe zone instead: it has no margin, so
any invented surround leaves a visible frame, replicating its edge smears the
character outwards, and drawing it over a second copy of itself ghosts. All
three were tried.

`test/kito_brand_test.dart` asserts the corner alpha, the opacity and the square
foreground, so a regenerated-but-wrong icon set fails the suite.

## Promotional asset set

| Format | Asset | Intended use |
|---|---|---|
| Wide 16:9 | `flyers/kito-pockito-hero-wide.png` | Announcement, landing hero, banner |
| Landscape 4:3 | `flyers/kito-ai-insights.png` | AI/insight feature story |
| Square | `social/kito-shared-square.png` | Shared Spaces social post |
| Vertical 9:16 | `social/kito-budget-story.png` | Budget feature story/reel cover |

These images deliberately contain no baked-in copy. Product or marketing teams can localize text without regenerating Kito.

## Generation provenance and prompt system

The library was generated with the built-in image-generation tool, using the supplied `designs/kito-mascot.png` as the sole original identity reference. The clean master was then used as a secondary consistency anchor.

Every character prompt used this invariant set:

> Preserve Kito’s cream face geometry, glossy navy eyes, rounded body proportions, cobalt-to-cyan palette, curved cobalt stem, turquoise leaf, cream wallet motif, soft 3D materials, premium studio lighting, and recognizable silhouette. No text, watermark, extra character details, childish exaggeration, or style change.

Scenario prompts changed only the expression, pose, and one meaningful prop. Transparent production assets used a separate background-extraction pass with this invariant:

> Remove only the background and floor plate. Preserve the complete character, intended props, composition, colors, textures, and antialiased edges. Output genuine alpha—never a rendered checkerboard.

Campaign prompts used `ads-marketing` compositions with Kito unchanged, restrained glassy financial motifs, and no baked-in text or numbers.

## Review checklist

Before approving any new Kito asset:

1. Is the face and silhouette immediately recognizable?
2. Are proportions and materials consistent with the master?
3. Does the expression match a real product state?
4. Is there only one meaningful story or prop?
5. Is the background genuinely transparent where required?
6. Does it remain clear at the intended runtime size?
7. Does it work on both light and dark surfaces?
8. Is it useful enough to justify another asset?
9. Is all copy kept in Flutter rather than baked into the image?
10. Does Kito help the user rather than compete with financial information?

## Brand assets outside the mascot library

`assets/brand/` holds the artwork that is Pockito rather than Kito:

| Asset | Use |
|---|---|
| `source/app-icon-master.png` | 1254 px icon master; not bundled at runtime |
| `app-icon.png` | 512 px runtime copy, used by `PkMark` |
| `pockito-logo-horizontal-light.svg` | Lockup for light surfaces (ink type) |
| `pockito-logo-horizontal-dark.svg` | Lockup for dark surfaces (white type) |
| `welcome-header.png` | 1200 px Home greeting banner |

Both runtime files are regenerated by `tool/generate_app_icons.py`, so the
in-app brand mark and the installed launcher icon are the same artwork by
construction.

### The horizontal lockup

`PkWordmark` renders the official `pockito-logo-horizontal-*.svg` artwork
through `flutter_svg`, and picks the variant from the active theme.

**The file names describe the surface, not the ink.** `-dark` sets "Pockito" in
white (`#FFFFFF`) and belongs on dark backgrounds; `-light` sets it in
`#0F172A` and belongs on light ones. `PkBrandAssets.logoFor(brightness)` is the
only place that mapping lives, so no screen can pair the wrong one.

The lockup is a graphic, not body copy: it does not grow with the reader's text
size, and it scales down rather than overflowing a narrow row.

### The welcome banner

`PkWelcomeBanner` overlays the greeting, the profile name and the date on
`welcome-header.png`. Nothing is baked into the image.

- The illustration leaves a clear pale-blue field between the coin at the far
  left and Kito on the right. Text sits at 15%–59% of the width, which clears
  the coin, the small decorative ring and the leaves.
- Overlay ink is fixed to `kitoNavy900`, not the theme's text colour: the
  artwork is light in both themes, so theme-derived text would turn near-white
  on pale blue in dark mode.
- The natural aspect is a floor, not a fixed height. A long name or a large text
  scale grows the banner and the artwork covers, keeping Kito anchored right.
- The banner already contains Kito, so the greeting adds no second mascot.
