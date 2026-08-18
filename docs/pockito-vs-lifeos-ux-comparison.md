# Pockito vs LifeOS — critical two-way UI/UX comparison

**Date:** 2026-08-17
**Pockito under review:** `pockito-mobile/` at the post-UI-016 baseline (166 tests passing)
**Benchmark:** `~/git/life-os/life-os-mobile/` (Flutter, 184 Dart files, `lib/design_system/`)

> **Note on the benchmark's name.** The brief names "FileOS". No product, directory, or
> string by that name exists on this machine. `life-os-mobile` is a Flutter finance app by
> the same author with `design_system/tokens`, and features for finance, spaces, AI, home,
> notifications, onboarding and search — a near-exact domain match. This document reads
> "FileOS" as **LifeOS** throughout. If a different product was meant, the findings about
> Pockito still stand on their own; the LifeOS columns would need re-running.

LifeOS is treated here as a reference product, not an authority. Several of its patterns
are actively worse than Pockito's and are called out as such.

---

## 1. Executive summary

**The headline is not "Pockito should be more like LifeOS."** On design-system maturity,
theming, accessibility and token discipline, Pockito is one to two generations ahead of
LifeOS, and most of what LifeOS does differently would be a regression if copied.
LifeOS's own Home screen is still a developer session-debug page — auth state, access
token, subject, "Send test notification"
(`lib/features/home/presentation/home_screen.dart`). It is not a finished product surface.

The five conclusions that matter:

1. **Pockito's real problem is vertical, not typographic.** Type sizes are already at or
   below LifeOS's. What is oversized is *space*: Home spends roughly **252 px on brand
   chrome and greeting artwork before any content**, then about **336 px on section
   headers and inter-section gaps** across six sections. At 390×844 the first data row on
   Home now sits *at* the navigation line. The fix is spatial compression, not smaller
   fonts.

2. **Pockito has a genuine, measurable contrast defect that the UI/UX audit missed.**
   `PkPalette.category` is used both as a chart *fill* palette and as icon *ink* via
   `PkIconTile`. Six of the twelve category colours fall below the 3:1 that a meaningful
   graphic requires against the light page — the worst is `kitoGold400 #F9B928` at
   **1.75:1**. LifeOS's `AppAccent` background/foreground *pair* is the structurally
   correct answer and Pockito should adopt the shape of it (not its colours).

3. **LifeOS has one clearly better token idea: composite padding recipes.**
   `AppSpacing.cardContent`, `cardHero`, `cardList`, `pageList` are padding *patterns* as
   tokens. Pockito has a clean scale but every screen still hand-assembles
   `EdgeInsetsDirectional.fromSTEB(context.gutter, PkSpacing.x3, context.gutter, PkSpacing.x4)`
   — Home does this six times with three different value sets. That is exactly how a
   rhythm drifts.

4. **LifeOS fails accessibility comprehensively, and copying its visual language would
   import those failures.** Its primary link colour `brandTeal #14B8A6` measures
   **2.49:1** on white; its active bottom-nav colour `brandTealNav #35B5A2` measures
   **2.53:1**. It has 7 `Semantics(` calls across 184 files, **zero** references to text
   scaling, fixed-height bars and 36 px pill buttons. Pockito has 28 `Semantics(` calls,
   41 tooltips, composed row announcements, a text-scale stacking rule, and eleven
   enforcement test suites.

5. **The biggest opportunity is beyond both apps: a density contract.** Neither product
   states, anywhere, how much real content a screen owes the reader in the first viewport.
   Pockito already has the machinery (`visibleRowCount` in `test/ui_audit/pk_density_test.dart`
   covers Accounts, Spaces, Activity, More, Notifications) — Home is the one screen exempted
   from it, and Home is the one screen that fails it.

---

## 2. LifeOS strengths — what it genuinely handles better

### 2.1 Composite spacing tokens (adopt the idea)

**LifeOS:** the spacing file ships padding *recipes*, not just a scale.

```dart
static const EdgeInsets cardContent = EdgeInsets.fromLTRB(18, 16, 18, 16);
static const EdgeInsets cardHero    = EdgeInsets.fromLTRB(20, 18, 18, 20);
static const EdgeInsets cardList    = EdgeInsets.symmetric(horizontal: 16);
static const EdgeInsets screenH     = EdgeInsets.symmetric(horizontal: 16);
static const EdgeInsets pageList    = EdgeInsets.fromLTRB(16, 8, 16, 140);
```

**Pockito:** `PkSpacing` is a strict 4 px grid with semantic aliases (`section`,
`headerToContent`, `heroToContent`, `stateGroup`) — better *vocabulary* — but screens
still compose their own insets. `home_screen.dart` contains six separate
`EdgeInsetsDirectional.fromSTEB(context.gutter, …)` blocks with top values of `x3`, `0`,
`0`, `x3`, `x3` and bottom values of `x4`, `x3`, `0`, `0`.

**Stronger:** LifeOS, on this one axis. A named recipe cannot drift; six hand-assembled
insets already have.
**Weakness in LifeOS's version:** the raw scale underneath is 14 steps including off-grid
6/10/14/18/22, and `pageList`'s fixed `140` bottom is a permanent empty band whether or not
a nav bar is present. Pockito computes it from the actual Scaffold inset
(`PkPage`, `pk_components.dart:75`) — that part is better.
**Principle to keep:** a padding pattern used more than twice is a token.
**Verdict: combine.** Keep Pockito's 4 px grid and computed bottom clearance; add
Pockito-named sliver-padding recipes.

### 2.2 The accent as a background/foreground *pair*

**LifeOS:** `AppAccent(background, foreground)` with 14 canonical buckets — `tileMintBg
#D9F2EC` / `tileMintFg #0E8F77`. The foreground is always a darkened, readable variant of
the family; the background is always a soft wash. One value can't be used in the wrong role.

**Pockito:** `PkIconTile` takes a single `Color` and derives the background as
`color.withValues(alpha: .12)` (`pk_components.dart:334`). The foreground is whatever was
passed — and callers pass `PkPalette.categoryAt(index)`, a **fill** palette.

**Stronger:** LifeOS, decisively, and this is Pockito's most concrete defect (see §5.1).
**Weakness in LifeOS's version:** 14 hand-maintained pairs with no test asserting the
contrast relationship, and bucket names that encode *content* ("dining is mint") rather
than role — so a new category has no home.
**Verdict: replace both.** See §7.1.

### 2.3 A compact, honest greeting

**LifeOS:** `_GreetingHeader` is a 40 px avatar, one line of 26/w800
`t.homeGreetingNamed(greeting, firstName)`, a time-of-day icon, and a 13 px date. About
**70 px** total.

**Pockito:** `PkWelcomeBanner` (`pk_brand.dart:157`) is a full-bleed raster
(`welcome-header.png`, aspect 1743:855) that renders **~176 px tall at 390 px wide** and
carries the same three strings — greeting, name, date — in a text column constrained to
44% of the width. It sits below a separate 76 px brand header.

**Stronger:** LifeOS, on information-per-pixel by a factor of about 2.5.
**Weakness in LifeOS's version:** it is charmless — a stock sun icon does not build a
brand, and LifeOS has no mascot to lose.
**Weakness in Pockito's version, beyond size:** the artwork is a single light-toned asset
in both themes, so the code has to pin the overlay ink to `kitoNavy900` regardless of
theme — meaning **dark mode shows a bright pale-blue slab across the top of a navy page**.
And `_textWidth = .44` ellipsizes long names while pale-blue field sits empty beside them.
**Principle to keep:** Pockito greets the reader by name every visit. That is a product
decision and it is the right one.
**Verdict: replace both.** See §7.2 — keep the greeting and Kito, lose the banner.

### 2.4 Locale and RTL coverage

**LifeOS:** `app_en.arb`, `app_ja.arb`, `app_fr.arb`, `app_ar.arb`. Arabic means the
layout has been through RTL.
**Pockito:** `app_en.arb`, `app_ja.arb`.
**Stronger:** LifeOS on coverage. Pockito's *code* is RTL-ready — it uses
`EdgeInsetsDirectional` and `AlignmentDirectional` consistently — but nothing proves it,
because no RTL locale exists to test against.
**Verdict: adapt.** Adding a pseudo-RTL locale to the golden matrix is cheap insurance.
Not a P0.

### 2.5 An ambient motion token

`AppMotion.breathing = Duration(seconds: 3)` names the slow ambient loop used by scanner
viewfinders and AI shimmer states. `PkMotion` has fast/standard/slow but nothing for
"this pulses while the assistant thinks". Small, real, worth adding.

### 2.6 Honourable mention: `AppFieldRow`

A labelled detail row with a fixed 78 px label column, an icon tile, a flexible value and a
chevron — one component covering Merchant/Category/Paid-with across three screens. Pockito
has `PkSelectField` and `PkDateField` for *entry* but no single canonical **read-only
label:value row**. Minor gap; worth a `PkDetailRow`.

---

## 3. Pockito strengths — preserve these

| Area | Pockito | LifeOS | Why Pockito wins |
|---|---|---|---|
| **Theming** | `PkSemanticColors` ThemeExtension with full light *and* dark constants; every component reads `context.pk.*` | Colours are `const` on `AppColors` and **baked into every `TextStyle`**; `AppPaletteExtension` exists but only light is ever registered | LifeOS cannot support dark mode without rewriting all 45 text styles |
| **Semantic finance vocabulary** | `shared / sharedStrong / sharedSurface / sharedBorder / owed / owing / success / danger / warning / ai` | `statusOrange / statusDanger / statusGreen` plus 24 per-feature colour constants (`quickAddExpenseCardBg`, …) | Pockito's names describe *money meaning*; LifeOS's describe hue |
| **Error semantics** | `error: rose600` | `error: AppColors.statusOrange` (`app_theme.dart`) | LifeOS collapses error and warning into one amber. A failed payment and a nearly-full budget look identical |
| **Type scale** | 13 semantic roles (`moneyHero`, `moneyRow`, `rowTitle`, `supporting`, `micro`) resolved through a ThemeExtension, with Material names remapped onto the same scale | ~45 named styles including per-screen ones (`assistantInsightBody`, `notificationTimestamp`) at fractional sizes 9.5 / 11.5 / 12.5 / 13.5 | Pockito's scale can be reasoned about; LifeOS's has a style per usage site |
| **Rule enforcement** | 24 test files, incl. 11 audit suites: source gates banning raw sizes, literals and `VisualDensity.compact`; contrast, tap-target, density, golden and responsive suites | 30 test files, no design-system gates. The doc comment says "free-floating `TextStyle(fontSize: …)` calls inside screens are not allowed" — there are **103 raw `fontSize:` in `lib/features`** | A rule that is not tested is a comment |
| **Accessibility** | 28 `Semantics(`, 41 tooltips, composed one-node row announcements, `CustomSemanticsAction` for swipe-only actions, `PkChartDataTable` giving every chart a tabular equivalent, text-scale stacking at ≥1.5×, reduced-motion honoured in `PkSkeleton` | 7 `Semantics(`, **0** text-scaling references, fixed 72 px nav / 42 px tabs / 36 px pill buttons | Not close |
| **Row grammar** | One `PkLedgerRow` with four declared density contracts (56/64/72/80) composing every finance and management row | `AppListRow` (12 px padding, no contract) plus `AppNotificationCard`, `AppFieldRow`, `AppMemberRow` as separate shapes | Pockito's rows are a system; LifeOS's are a set |
| **Elevation discipline** | 4 shadow tokens; **one** variant lifts (`PkCardVariant.raised`), the rest use a hairline border | 15 shadow tokens, 6 of them coloured glows; `AppCard` default paints shadow **and** border; `AppTabsPill` stacks a shadow on the track and another on the thumb | LifeOS's every-surface-floats look is exactly what Pockito's audit removed |
| **Button hierarchy** | Themed Material buttons, 48 default / 52 reserved for final actions, one primary appearance | Three gradient CTA moods (`brandCta` mint→sky, `teal`, `purple`) each with its own glow, plus outlined pill, soft pill, destructive, CTA stripe | Three equally-loud gradient CTAs is not a hierarchy |
| **Bottom navigation** | Data-driven from one `PkNavDestination` list shared with the wide-screen rail; selection marked three ways (filled icon, tinted pill, heavier label) | `assert(destinations.length == 4)`, hand-rolled `Stack`/`Positioned` with a magic `_fabInsideBar = 0.90`, selection by colour alone at 2.53:1 | Pockito's survives a fifth destination and a colour-blind reader |
| **Responsive** | Named breakpoints, `PkTwoPane` master-detail from 840, rail at 900, `PkPageWidth` measures (560 form / 640 reading / 1120 dashboard) | No breakpoints in the design system | LifeOS is phone-only |
| **Privacy** | `PkPrivacy` + `PkAmountText` mask that preserves layout width and announces "Balance hidden" | none | A finance-specific feature LifeOS lacks entirely |

**Also preserve, explicitly:** Kito (`kito_components.dart` — `KitoMessage`, `KitoInsightCard`,
`KitoCelebration`, pose-mapped empty states), the cobalt→aqua brand gradient, gold reserved
for shared money, and the aqua `ai` ink. LifeOS's AI identity is purple sparkles on lavender
— generic, and adopting it would cost Pockito its one distinctive AI signal.

---

## 4. Weaknesses in LifeOS — do not copy

1. **No dark mode, structurally.** Text colours are compiled into `AppTypography`. Not a
   missing feature; a missing capability.
2. **Link and nav colours below 2.6:1.** `brandTeal #14B8A6` = **2.49:1**;
   `brandTealNav #35B5A2` = **2.53:1**. Every "View all" and every active tab label fails
   WCAG AA by a wide margin.
3. **`error` mapped to amber.** Warning and error are indistinguishable.
4. **A type style per usage site.** `assistantInsightBody` at 12.5, `notificationTimestamp`
   at 11.5, `assistantInput` at 13.5. Fractional sizes round unpredictably across densities.
5. **Zero text-scale handling.** At 200% the 72 px nav, 42 px tabs and 36 px pills clip.
6. **Sub-44 px touch targets** throughout: `AppOutlinedPillButton` height 36,
   `AppSoftPillButton` ≈30, `AppCircleIconButton.flat` 40, `AppTagChip.inline` ≈18.
7. **A card per notification.** `AppNotificationCard` is a standalone shadowed card per row
   — the fragmentation pattern Pockito's audit removed in favour of `PkGroupedSurface`.
8. **Shadow on everything, including borders.** Card = border + shadow. Tabs = shadow on
   track + shadow on thumb. Suggestion chips = shadow. The page reads as a stack of
   floating posters.
9. **Coloured glow CTAs in three hues.** Purple "Settle now", teal "Accept invite", mint→sky
   "Done". Nothing tells the reader which is primary.
10. **Radius derived from size.** `AppIconTile._defaultRadiusForSize` maps 34→10, 40→12,
    52→14. Radius should come from *role*, not from a size lookup, or the same component at
    two sizes reads as two components.
11. **Eleven radius steps and fourteen spacing steps.** More scale than any product needs;
    a scale that wide is a scale that isn't consulted.
12. **`pageList` bottom = 140, always.** A fixed empty band regardless of context.
13. **Home is a debug screen.** Auth status, access-token expiry, subject ID, "Send test
    notification", "Log out". Whatever LifeOS teaches, it is not dashboard composition.

---

## 5. Weaknesses in Pockito — what actually reduces quality today

### 5.1 P0 — Category colours used as icon ink fail contrast

`PkPalette.category` (`pk_tokens.dart:385`) is a 12-colour list consumed two ways: as
donut/chart fills (correct — large areas), and as the `color` argument to `PkIconTile`
in `PkAccountTile`, `PkSpaceTile` and `PkTransactionTile`, where it becomes a 20 px glyph
on a 12%-alpha wash of itself — i.e. effectively the raw colour on near-white.

Measured against the light page, as a non-text graphic requiring **3:1**:

| Colour | Role in list | Contrast | Result |
|---|---|---|---|
| `#F9B928` `kitoGold400` | category glyph | **1.75:1** | fail |
| `#F59E0B` | category glyph | **2.16:1** | fail |
| `#17B6C8` `kitoAqua500` | category glyph | **2.45:1** | fail |
| `#14B8A6` | category glyph | **2.49:1** | fail |
| `#10B981` | category glyph | **2.54:1** | fail |
| `#0EA5E9` | category glyph | **2.77:1** | fail |
| `#1F55D5` `kitoBlue600` | category glyph | 6.33:1 | pass |
| `#F43F5E` / `#8B5CF6` / `#EC4899` / `#64748B` / `#A855F7` | category glyph | 3.53–4.76:1 | pass |

**Six of twelve fail.** The audit corrected *ink* colours (`kitoGold600`, `rose600`,
`kitoAqua700`) but left the fill palette wired directly into the icon component, so the
correction never reached the icons. `test/ui_audit/pk_accessibility_test.dart` did not
catch it because `meetsGuideline(textContrastGuideline)` checks text, not icon glyphs.

### 5.2 P0 — Home shows no data in the first viewport

Measured at 390×844, default text scale, current `main`:

| Element | Top | Bottom |
|---|---|---|
| Brand header | 0 | 76 |
| `PkWelcomeBanner` | 76 | 251.6 |
| Action-required block | 251.6 | ~470 |
| `PkHeroPanel` | 481.6 | 680.6 |
| `PkQuickActions` | 692.6 | 732.6 |
| First section header ("Accounts") | 752.6 | 812.6 |
| **Navigation bar top** | **758.0** | |

The reader's first screen is: a wordmark, a picture, a notice block, a number, and a row of
chips. **Zero rows of their actual money.** Every other root screen is gated on a density
floor (Accounts ≥5 rows, Spaces ≥3, Activity ≥5, More ≥7, Notifications ≥6). Home is not,
and it is the screen that fails.

### 5.3 P1 — Section chrome is the second-largest consumer of Home

Six sections × (`PkSpacing.section` 20 + an 18/24 title + `headerToContent` 12) ≈ **336 px**
of pure chrome, before a single row is drawn. Each section also carries its own "See all",
which makes Home read as a table of contents for the app rather than as a view of the money.

### 5.4 P1 — The welcome banner is dark-mode-hostile and width-wasteful

A fixed light raster with ink pinned to `kitoNavy900` (`pk_brand.dart`, `_ink`). In dark
mode this is a bright pale-blue band on a navy page — the single loudest element in the
theme, carrying the least information. `_textWidth = .44` truncates long names against
empty artwork.

### 5.5 P2 — Chevrons are oversized

`PkLedgerRow` draws `Icons.chevron_right_rounded` at `PkSize.iconLarge` (24). A passive
affordance repeated on every row of every list. LifeOS uses 18. 20 is the right answer.

### 5.6 P2 — Container count on Home

Nine rounded surfaces on one screen: banner, action block, hero, quick-action chips,
three `PkGroupedSurface`, two chart `PkCard`, plus `KitoInsightCard`. The audit fixed
*card-per-object*; *card-per-section* is the remaining half of the same problem.

### 5.7 P2 — `PkSetupChecklist` uses raw `ListTile(dense: true)`

`pk_records.dart:724` builds its steps from Material `ListTile` with `dense: true` rather
than `PkLedgerRow.management`. `dense` shrinks the target below the 48 the rest of the app
guarantees, and it is the one place a screen escapes the row system.

### 5.8 P2 — No read-only detail row primitive

Detail screens compose label/value pairs ad hoc. LifeOS's `AppFieldRow` is the missing shape.

### 5.9 Scale audit — the specific questions asked

| Question | Verdict |
|---|---|
| Fonts too large? | **No.** `screenTitle` 24 vs LifeOS 26–28; `sectionTitle` 18 vs 16; `rowTitle` 15 vs 14–15; `moneyHero` 32 vs 32. Pockito is at or below the benchmark. |
| Cards too tall? | **Partly.** Rows are right (56/64/72/80 are earned and content-driven). The *banner* and *section chrome* are the problem. |
| Excessive padding? | **At section level, yes** (§5.3). Inside cards and rows, no — 16/12 is correct. |
| Oversized icons? | **Only chevrons** (24 → 20). Tiles at 38/44 with 20/22 glyphs are right. |
| Too much whitespace? | Yes, vertically between sections; no, within them. |
| Too many containers? | Yes on Home (§5.6). Elsewhere `PkGroupedSurface` already fixed it. |
| Too many rounded cards? | Radius scale is disciplined (5 steps, card 16). The *count* is the issue, not the radius. |
| Weak information density? | **On Home only** — and severely (§5.2). |
| Poor primary/secondary hierarchy? | **On Home only** — two heroes (banner + `PkHeroPanel`) share the first viewport, which is what D-02 forbids. |

**And the opposite check on LifeOS:** is it too dense? In places, yes — 11 px timestamps,
12.5 px body copy, 9.5 px "AI" pills, 30 px tap targets, and a 2.49:1 link colour are
aesthetics purchased with usability. Pockito must not chase that floor. The target is
LifeOS's *vertical* efficiency at Pockito's *legibility* standard.

---

## 6. Best-of-both opportunities

| # | Opportunity | From LifeOS | From Pockito | Result |
|---|---|---|---|---|
| B-1 | **`PkAccent` pair** | the bg/fg pair concept | semantic tokens, dark mode, test gates | A `(surface, ink, fill)` triple per category, ink guaranteed ≥3:1 in both themes, asserted by test |
| B-2 | **Sliver padding recipes** | `cardContent` / `pageList` as tokens | 4 px grid, computed bottom clearance, directional insets | `PkSliverInsets.section/hero/block` — no screen assembles its own again |
| B-3 | **Greeting** | one compact row | Kito, the name, the date, warmth | A 72–80 px greeting header that *is* the brand header (§7.2) |
| B-4 | **Ambient motion** | `breathing` 3 s | reduced-motion honoured everywhere | `PkMotion.ambient`, gated on `disableAnimations` |
| B-5 | **Detail row** | `AppFieldRow`'s fixed label column | `PkLedgerRow` semantics + density contracts | `PkDetailRow` as a fifth `PkRowDensity` consumer |
| B-6 | **Scope awareness** | the header space pill | Spaces as a first-class destination | *Contextual* scope chip on Home only — not a global switcher (§11.7) |

---

## 7. Better-than-both opportunities

### 7.1 An accent system that cannot be wrong

Neither app's approach survives scrutiny: LifeOS hand-maintains 14 pairs with no
verification; Pockito derives a wash from a fill and then uses the fill as ink.

**Proposal.** Define accents as a role triple, generated once per category index:

```dart
@immutable
class PkAccent {
  final Color fill;    // charts, progress, large areas — saturation allowed
  final Color ink;     // glyphs and labels — guaranteed >= 3:1 on surface & sunken
  final Color surface; // the tile wash — guaranteed to pass with `ink`
}
```

`PkIconTile` takes a `PkAccent`, never a `Color`. `PkPalette.categoryAt` returns a
`PkAccent`. Charts keep using `.fill`. A test iterates all twelve accents × light/dark ×
{surface, sunken} and asserts the floor — the same shape as the existing token suite.
This is better than LifeOS (verified, themed, no hand-maintenance) and better than Pockito
(the fill can no longer leak into an ink slot).

### 7.2 The greeting *is* the header

Both apps stack a chrome bar and then a greeting block. LifeOS spends ~48 + 70 px;
Pockito spends 76 + 176 px. Neither needs two rows.

**Proposal — one 76–84 px header:**

```
┌──────────────────────────────────────────────────────────┐
│  ◉Kito   Good morning, Amina          ⌕   ✧   🔔        │
│   40px   Sunday, August 16                                │
└──────────────────────────────────────────────────────────┘
```

- Kito's avatar mark (40 px) replaces the wordmark as the identity anchor — the mascot
  becomes *more* present, not less, because it is on every screen rather than only Home.
- Greeting + name on line one at `rowTitle`; date on line two at `supporting`.
- The three existing `PkIconAction`s keep their 48 px targets.
- The pose can vary with time of day (`KitoAsset.sleeping` late, `thinking`, `celebrating`
  on a settled day) — a warmth signal the raster banner cannot give, at 40 px instead of 176.
- Theme-native: no pinned ink, no light raster on a dark page.

**Net: ~170 px returned to Home**, roughly two data rows, with the brand *strengthened*.

### 7.3 A stated density contract, enforced

Neither product declares what a screen owes the first viewport.

**Proposal.** Add to the token layer, and to `pk_density_test.dart`:

> Every root screen shows at least **two rows of the reader's own data** above the
> navigation at 390×844 and default text scale. Chrome, greeting, hero and shortcuts
> together may not exceed **60%** of the visible page.

Home currently sits at ~100% chrome. §7.2 plus §7.4 brings it to roughly 55%.

### 7.4 Progressive disclosure instead of six sections

Both apps list every domain on the dashboard with a "See all" beside each. That is
navigation wearing a dashboard's clothes.

**Proposal.** Home shows **two** sections in full — "Who owes whom" and "Budgets", the two
that are genuinely actionable — then one `PkGroupedSurface` of four `PkLedgerRow.management`
entries (Accounts, Upcoming, Spending trend, Where it went) each with its own trailing
summary value. Four section-header blocks (≈224 px) collapse into four 56 px rows (224 px)
that each *carry a number* instead of announcing a heading. Same height, four times the
information, and the "See all" repetition disappears.

### 7.5 Status as one grammar, extended to progress

Pockito's `PkStatusTone` + `PkStatusBadge` is already the best status primitive in either
codebase. It should also drive `PkProgressBar` and `PkBudgetArc` colour, so budget health
and badge tone can never disagree — today `PkBudgetTile` computes `barColor` inline from
`BudgetHealth` while the badge computes its own from `PkStatusTone`.

---

## 8. Component comparison

| Component | LifeOS | Pockito | Action for Pockito |
|---|---|---|---|
| Card | `AppCard` + `AppGradientCard` (+`.smartInsight`) — border **and** shadow by default | `PkCard` with 4 variants; only `raised` lifts | **Keep.** |
| Grouped list | none (card per row) | `PkGroupedSurface` | **Keep** — a genuine advantage |
| List row | `AppListRow`, 12 px padding, no height contract | `PkLedgerRow` + `PkRowDensity` (56/64/72/80) | **Keep;** reduce chevron to 20 |
| Detail row | `AppFieldRow` (label column + tile + value) | — | **Add `PkDetailRow`** |
| Icon tile | `AppIconTile(accent)` + `.circle` + `AppBadgedIconTile` | `PkIconTile(color)` + `.feature` | **Redesign** to take `PkAccent`; consider a badged variant for AI/receipt provenance |
| Status | `AppStatusChip`, `AppTagChip`, `AppAiPill`, `AppStatusDot`, `AppCornerBadge` (5 shapes) | `PkStatusBadge` + `PkStatusTone` (1 shape, 7 tones) | **Keep** — consolidate is already done |
| Section header | `AppSectionHeader` + `AppCenteredTitle` | `PkSectionHeader` + `PkGroupLabel` | **Keep;** use `PkGroupLabel` more on Home (§7.4) |
| Empty state | `AppEmptyState` — grey circle + icon, admittedly unused | `PkEmptyState` + `.section`, pose-mapped Kito, scrolls at 2.0× | **Keep** — not close |
| Skeleton | none | `PkSkeleton`, reduced-motion aware | **Keep** |
| Progress | `AppProgressBar` (6 px, gradient option) | `PkProgressBar` (8 px, animated, semantic label+value) | **Keep;** bind colour to `PkStatusTone` (§7.5) |
| Tabs | `AppTabsPill` (animated thumb) + `AppSegmentedTabs` | `PkTabs` sliver header | **Keep;** borrow the animated thumb only if `PkTabs` isn't already animating |
| Chips / filters | `AppFilterPill`, `AppSuggestionChip`, `AppTagChip` | `PkListControls`, `PkActiveFilters`, `PkFilterChipData`, `PkSearchField`, `PkSortButton` | **Keep** — Pockito's filter model is far more complete |
| Buttons | 6 shapes, 3 gradient moods, 36–56 px | Themed Material, 48 / 52-final, `PkSubmitButton` | **Keep** |
| Sheet | `AppBottomSheet` + handle | `PkSheetScaffold`, `PkSheetSize`, `showPkSheet`, own Material, `onReset` | **Keep** |
| Bottom nav | 4-destination assert, hand-rolled Stack | `PkBottomNav` + shared `PkNavDestination` + rail | **Keep** |
| Top bar | `AppTopBar` with space pill + 4 actions | `_HomeBrandHeader` + `PkScreenHeader` + `PkAppBar` | **Redesign** per §7.2 |
| AI surface | `AppSmartInsightCard`, `AppAiHintCard`, `AppAiPill`, `AppAssistantHeroIllustration` — purple sparkles | `KitoInsightCard`, `ai` semantic ink, `PkStatusTone.ai` | **Keep Pockito's.** Kito *is* the assistant; a sparkle icon would dilute it |
| Charts | `finance_visuals.dart` | `PkSparkline`, `PkCategoryDonut`, `PkBudgetArc`, `PkComparisonLabel`, `PkChartDataTable` | **Keep** — the data-table equivalent is an accessibility feature LifeOS has no answer to |
| Receipt scan | `AppScanCamera` (1023 lines, full viewfinder chrome) | route stub `/add?scan=1` | **Note only** — a feature gap, not a design gap |

---

## 9. Screen-level recommendations

**Home** — the only screen with structural problems. Apply §7.2 (merged greeting header),
§7.4 (two full sections + one summary group), drop the separate wordmark bar. Expected: first
data row moves from y≈812 to y≈560, and D-02's one-hero rule holds again.

**Accounts / Spaces** — no structural change. They pass density and already have two-pane.
Only the `PkAccent` migration touches them.

**Activity** — strongest screen in the app; leave it. It is the reference for what Home
should feel like.

**More / Settings** — `PkSetupChecklist` should stop using `ListTile(dense: true)` (§5.7).

**Notifications** — already grouped; explicitly do **not** move to LifeOS's card-per-row.

**Budget detail** — bind arc and badge to one `PkStatusTone` source (§7.5).

**Detail screens (transaction, account, space)** — adopt `PkDetailRow` for label/value pairs.

---

## 10. Design-system recommendations (centralise, don't fix per screen)

1. `PkAccent` triple replaces bare `Color` in `PkIconTile`; `PkPalette.categoryAt` returns it.
2. Contrast test extended from text to **icon glyphs and status ink**, all accents × both themes.
3. `PkSliverInsets` recipes; ban hand-assembled `EdgeInsetsDirectional.fromSTEB(context.gutter, …)`
   in feature code via the existing source-gate suite.
4. `PkSize.chevron = 20`, used by `PkLedgerRow`.
5. `PkMotion.ambient` (3 s), reduced-motion gated.
6. `PkDetailRow` added to the row family.
7. Density contract expressed as a token *and* a test, extended to Home.
8. `PkProgressBar` / `PkBudgetArc` take a `PkStatusTone`, not a `Color`.
9. Add a pseudo-RTL locale to the golden matrix.
10. New brand header component (`PkAppHeader`) replacing `_HomeBrandHeader` + `PkWelcomeBanner`.

---

## 11. Things NOT to copy from LifeOS

1. **Colour-baked text styles** — kills dark mode.
2. **`brandTeal` as link/accent ink** — 2.49:1.
3. **Purple-sparkle AI identity** — Pockito has Kito and an `ai` semantic ink; this would dilute both.
4. **Card-per-notification / card-per-row** — the exact fragmentation UI-003 removed.
5. **Coloured glow shadows and gradient CTAs in three hues** — destroys button hierarchy.
6. **Sub-44 px pills and chips** — Pockito's 48 px floor is a decision, not an accident.
7. **A global space switcher in the header** — Pockito's IA makes Spaces a destination; a
   global scope pill would create two competing mental models of "where am I". A
   *contextual* scope chip on Home is a different, acceptable idea.
8. **Fractional font sizes** (9.5 / 11.5 / 12.5 / 13.5).
9. **`error` mapped to amber.**
10. **Fixed 140 px list bottom padding.**
11. **Radius derived from component size.**
12. **A 14-step spacing scale with off-grid values.**
13. **`AppScreen`'s `Stack` + `Positioned.fill(bottom: bodyClipInset)`** — clipping the body
    above the nav instead of letting content scroll under it. Pockito's `extendBody` +
    computed clearance is better.

---

## 12. Prioritised implementation backlog

### P0 — Critical

**P0-1 · Category colours fail contrast as icon ink**
- *Problem:* 6 of 12 `PkPalette.category` entries measure 1.75–2.77:1 when rendered as a
  20 px glyph by `PkIconTile`; 3:1 is required. Affects every account, space, category and
  transaction row.
- *Evidence:* `pk_tokens.dart:385` + `pk_components.dart:334`; measurements in §5.1.
  LifeOS's `AppAccent` pair structurally prevents this.
- *Solution:* introduce `PkAccent(fill, ink, surface)`; `PkIconTile` accepts only
  `PkAccent`; extend the contrast suite to glyphs across both themes.
- *Affects:* `pk_tokens.dart`, `pk_components.dart`, `PkAccountTile`, `PkSpaceTile`,
  `PkTransactionTile`, `PkBudgetTile`, chart palette, `pk_accessibility_test.dart`.
- *Type:* **Best-of-both** (LifeOS's pair shape, Pockito's theming and enforcement).

**P0-2 · Home shows zero data above the fold** — *solution superseded*
- *Problem:* at 390×844 the first data row starts at y≈812 against a nav line at 758.
  Two heroes (banner + `PkHeroPanel`) share the first viewport, violating D-02.
- *Evidence:* measurements in §5.2; every other root screen has a density floor, Home is exempt.
- *Solution:* **§7.2's merged greeting header is withdrawn — `PkWelcomeBanner` stays as is
  by product decision.** The problem is re-solved without touching the banner in
  [`pockito-component-adoption-roadmap.md` §5](./pockito-component-adoption-roadmap.md):
  a floating sliver brand header (−76 px), progressive disclosure (−~112 px of header
  chrome), and quick actions moved below the first data section (−52 px). Projected first
  data row y≈570.
- *Affects:* `home_screen.dart`, `pk_density_test.dart`, Home goldens. **Not** `pk_brand.dart`.
- *Type:* **New solution beyond both.**

**P0-3 · Density contract is unstated and Home is unenforced**
- *Problem:* the density rule exists only as five per-screen assertions; the screen most
  likely to inflate is the one not covered.
- *Solution:* state the contract (≥2 data rows, ≤60% chrome, first viewport, default scale);
  add the Home case to `pk_density_test.dart`.
- *Affects:* `pk_density_test.dart`, `docs/ui-ux-completion-record.md`.
- *Type:* **New solution beyond both.**

### P1 — High value

**P1-4 · Welcome banner is dark-mode-hostile and truncates names** — *reduced to P2*
- *Evidence:* `pk_brand.dart` pins `_ink = kitoNavy900` because the raster is light in both
  themes; `_textWidth = .44`. §5.4.
- *Decision:* the banner **stays**. Removal is off the table.
- *Remaining, optional:* a dark-variant asset so the band is not the brightest element on a
  navy page, and a text width that follows the name instead of a fixed 44%. Both are
  contained changes inside `PkWelcomeBanner` that keep the artwork and composition.
- *Type:* **Pockito improvement.**

**P1-5 · Section chrome consumes ~336 px on Home**
- *Solution:* §7.4 — two full sections, four summary rows carrying values.
- *Type:* **New solution beyond both.**

**P1-6 · Sliver padding recipes**
- *Evidence:* six hand-assembled inset blocks in `home_screen.dart` with three different
  value sets; LifeOS's `AppSpacing.cardContent`/`pageList` show the fix.
- *Solution:* `PkSliverInsets`; extend the source gate to ban ad-hoc gutter insets.
- *Type:* **FileOS/LifeOS-inspired adaptation.**

**P1-7 · `PkDetailRow`**
- *Evidence:* LifeOS's `AppFieldRow` covers three screens with one component; Pockito
  composes label/value pairs per screen.
- *Type:* **FileOS/LifeOS-inspired adaptation.**

**P1-8 · Progress colour bound to `PkStatusTone`**
- *Evidence:* `PkBudgetTile` computes `barColor` from `BudgetHealth` inline while the badge
  resolves its own tone — two sources for one meaning.
- *Type:* **Pockito improvement.**

**P1-9 · `PkSetupChecklist` off the row system**
- *Evidence:* `pk_records.dart:724` uses `ListTile(dense: true)`; `dense` is banned
  elsewhere by the source gate.
- *Solution:* rebuild on `PkLedgerRow.management`.
- *Type:* **Pockito improvement.**

### P2 — Polish

**P2-10 · Chevron 24 → 20** (`PkSize.chevron`). Repeated on every row; LifeOS uses 18.
*Type: best-of-both.*

**P2-11 · `PkMotion.ambient` (3 s)** for assistant/thinking states, reduced-motion gated.
*Type: LifeOS-inspired adaptation.*

**P2-12 · Container count on Home** — after P0-2/P1-5, re-count and target ≤6 rounded
surfaces per viewport. *Type: Pockito improvement.*

**P2-13 · Pseudo-RTL locale in the golden matrix** — Pockito's code is directional
throughout but unproven. *Type: LifeOS-inspired adaptation.*

**P2-14 · Kito pose follows time of day** in the new header (sleeping late, thinking,
celebrating on a settled day). Warmth per pixel that no benchmark has.
*Type: new solution beyond both.*

**P2-15 · Badged icon tile** for provenance (AI-extracted, receipt-attached) — LifeOS's
`AppBadgedIconTile` shape, Pockito's `PkStatusTone.ai` colour. *Type: best-of-both.*

---

## Closing position

Pockito should not become LifeOS. On every axis that determines whether a finance app can
ship — theming, semantic colour, accessibility, responsive behaviour, component
consolidation, enforcement — Pockito is ahead, and LifeOS's most visible traits (glow CTAs,
card-per-row, sub-44 targets, a 2.49:1 accent) are liabilities.

What LifeOS teaches is **restraint with vertical space**. It fits a greeting into 70 px
where Pockito spends 252. Take that lesson, apply it with Pockito's legibility standard,
and spend the reclaimed height on the reader's own money — that is the whole programme
above, and it costs the brand nothing. Kito ends up on *every* screen instead of one.
