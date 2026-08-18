# Pockito mobile UI/UX programme — completion record

**Date:** 17 August 2026
**Date of last revision:** 18 August 2026
**Programme:** [`docs/pockito-mobile-ui-ux-audit.md`](pockito-mobile-ui-ux-audit.md), tasks UI-001 → UI-016;
[`docs/pockito-component-adoption-roadmap.md`](pockito-component-adoption-roadmap.md), tasks UI-017 → UI-023;
UI-024 from a screenshot review of the dark theme; UI-025 closing the roadmap's exit gates
**Companion:** [`docs/prototype-completion-audit.md`](prototype-completion-audit.md) — landed before this
programme began; none of its work was recreated or overwritten.

> **Status: complete.** `flutter analyze` clean, `dart format` clean, 215 tests
> passing including the golden baselines, and both debug and release APKs build.

This document records where each task landed, what the acceptance criteria are
checked *by*, and the two places the audit's own numbers had to be reconciled.

---

## 1. How the criteria are enforced

Section 9 is not a checklist somebody re-reads. Every criterion that can be
measured is measured, on every surface, by a suite that walks one manifest.

| Suite | Enforces |
|---|---|
| `test/support/pk_surface_manifest.dart` | The catalogue itself: 60 surfaces, their kinds, their declared states, their density floors |
| `pk_manifest_test.dart` | Every router path is in the manifest — a route with no coverage fails the build |
| `pk_tokens_test.dart` | §5.1–5.8 values, tabular figures, §5.6/9.5 contrast maths |
| `pk_responsive_test.dart` | §9.6 — 9 viewports × 60 surfaces, plus 320×568 @2.0× and RTL, zero overflow |
| `pk_density_test.dart` | §9.3 viewport capacities, and D-02's one-hero rule |
| `pk_targets_test.dart` | §9.4 — every control ≥48×48, no overlapping targets |
| `pk_accessibility_test.dart` | §9.5 — Flutter's WCAG matchers on all 60 surfaces in both themes, plus row semantics, 1.3×/2.0×, Japanese, RTL, reduced motion |
| `pk_ledger_test.dart` | §9.8 — 500-item stress, memoised grouping, sticky headers |
| `pk_kito_test.dart` | §4.5 / D-08 — Kito's size and frequency budget |
| `pk_adaptive_test.dart` | §7.24 / 9.6 — rail at 900, two-pane, no stretched columns |
| `pk_onboarding_test.dart` | §7.22 — 35% art bound, reachable CTA at 320×568 @2.0× |
| `pk_polish_test.dart` | §9.2 — radius/shadow consistency, privacy mode, motion, haptics |
| `pk_system_usage_test.dart` | UI-002/UI-005 source gates: no raw sizes, one sheet presenter, en/ja parity, no user-facing literals |
| `pk_golden_test.dart` | UI-016 — 60 route baselines (light + dark) and 9 component baselines |

Running `flutter test` runs all of it.

---

## 2. Where each task landed

**UI-001 · Stabilise and baseline.** The companion audit's work was already
green, so nothing needed repairing. Added the surface manifest, the shared
harness (`pk_test_harness.dart`) and the overflow collector that every later
suite uses.

**UI-002 · Semantic tokens.** `PkTypography` (13 named roles) as a theme
extension; the Material names now resolve onto the same scale, so a screen that
reaches for `titleLarge` still lands inside the system. Routine tiers came down
one step (display 40→32, screen title 28→24, section 20→18, row 17→15).
`PkSpacing.section` 24→20 with named aliases. Radii remapped so the legacy
names carry the audit's values — cards are 16, heroes 20, sheets 24.
`PkSize.touch` 44→48 plus row, control, avatar and button contracts.
`PkBreakpoints` and the form/reading/dashboard measures.

**UI-003 · Surfaces and rows.** `PkCard` variants, `PkGroupedSurface`,
`PkLedgerRow` (four densities; stacks the amount under the title above 1.5×
text), `PkStatusBadge`, `PkGroupLabel`, `PkInlineNotice`, `PkPinnedActions`,
`PkTwoPane`, `PkContentColumn`. Every list row in the app composes
`PkLedgerRow` now, verified by `pk_polish_test.dart`.

**UI-004 · Headers, navigation, actions, targets.** Root header 24 / app bar 18.
`PkIconAction` chrome 42→36 inside a 48 target. `VisualDensity.compact` removed
everywhere — it shrinks the *target*, which is exactly the conflation D-04 rules
out; tight padding replaces it, and the source gate now bans it.

**UI-005 · Sheets and pickers.** `showPkSheet` is the only presenter, with
`PkSheetSize.compact`/`standard`; the drag handle is gone because
`PkSheetScaffold` already draws a header with Close. Activity's 88%
pseudo-screen filter became a standard sheet with header reset and pinned Apply.
Added `PkSelectField` so rich entities stop being dropdown strings.

**UI-006 · Activity as the canonical ledger.** Continuous list with inset
separators instead of a rounded card per day; sticky headers brought into the
28–32 band; skeletons rebuilt to match real row geometry.

**UI-007 · Quick Add.** New `QuickAddScreen` — a compact sheet for a personal
expense or income, five taps to save, with "More options" handing its state to
the full editor. The receipt scanner and split editor became full-screen routes,
as §4.6 and §6.12 require. The acceptance journey now exercises both paths.

**UI-008 · Home.** Welcome artwork is first-use only; action-required sits above
the hero; hero restructured from 259 px to ~160; Kito's insight moved below the
finance content.

**UI-009 · Accounts and Spaces.** Grouped rows, compact summaries, one add entry
point each, member and invite rows on the canonical foundation.

**UI-010 · Management.** Budgets grouped Personal/Shared; subscriptions grouped
Overdue / Due soon / Later; categories, tags and payment methods on 56 px rows.

**UI-011 · AI, notifications, More, settings.** Compact AI trust note, grouped
connection rows, write permission given warning treatment; notifications grouped
Today/Earlier; More rebuilt as grouped 56 px rows. Prototype surfaces are now
compiled out of a release build by `kPkDebugSurfaces`.

**UI-012 · Kito.** `KitoSize` names the five moments §4.5 defines and
`KitoImage.sized` decodes near its rendered size. `KitoMessage` no longer stacks
a 96 px image above its own text below 340 px — the width where the copy could
least afford it.

**UI-013 · Onboarding.** Illustration bounded to 35% of usable height, headline
on the semantic scale, one pinned CTA, and progress that announces "Step 1 of 7"
instead of being seven coloured bars.

**UI-014 · Responsive.** `PkTwoPane` gives Accounts and Spaces a detail pane at
≥840; Home reflows into two columns; every list screen keeps a reading measure.

**UI-015 · Accessibility and localization.** See §3 — this task found the most.

**UI-016 · Visual regression and polish.** 69 golden baselines, privacy mode
implemented (it did not exist), and the consistency rules asserted directly so a
failure names the rule rather than the pixels.

### The adoption programme, UI-017 → UI-023

The comparison against LifeOS found that the design system was ahead of the
benchmark on every structural axis and was being *bypassed by the screens*.
These seven tasks closed that gap and added the gates that keep it closed.

**UI-017 · Accent and contrast.** `PkAccent` splits a category's *fill* from its
*ink*, per brightness, and `PkIconTile` will no longer accept a bare `Color` —
the defect is unrepresentable rather than merely fixed. Six of twelve category
colours were failing 3:1 as glyph ink; `_SpaceHero` was drawing a saturated fill
as ink on white at 1.75:1.

**UI-018 · Field migration.** 24 `DropdownButtonFormField` and 20 raw
`TextField` moved onto `PkAmountField` / `PkSelectField` / `PkSelectFormField` /
`PkDateField` / `PkNoteField`, with a currency control inside the amount field.
Settle Up went first: the most consequential number in the product was a bare
`TextField` styled `displayLarge`.

**UI-019 · Row and detail consolidation.** `PkDetailRow` replaced four private
copies. `pkStatusInk` became the single source of status colour.

**UI-020 · Home composition.** The hero reached its 148–168 px budget for the
first time (199 → 165) without touching `PkWelcomeBanner`, which is a fixed
product decision.

**UI-021 · Shared money.** `PkSplitBar` with a legend, `PkBalanceImpact`'s
before-and-after statement.

**UI-022 · Icons and search reach.** A 27-line icon switch became a ~60-entry
catalogue with namespaced ids, a legacy compatibility map so records saved
before it keep their mark, and search that reaches destinations through
translator-owned ARB synonyms.

**UI-023 · Polish and proof.** `PkRecordTimeline` on the shared-expense detail,
provenance badges on AI-written and receipt-backed rows, scope as a single
field, an RTL locale in the golden matrix, and a container ceiling on Home.

### UI-024 · The dark theme, from screenshots

A review of five dark-mode screenshots found a family of defects that every
prior audit had missed, because each one is invisible in light mode. See §3.

### UI-025 · Closing the roadmap's open items

A re-read of the roadmap against the code found five phases that had shipped
their substance but not their exit gate. Closing them is what turned the
programme from "done" into "enforced".

**The two missing gates.** `PkTextField` was added — the plain-text case the
plan never named — and 24 raw `TextField`/`TextFormField` migrated onto it,
leaving three inline numeric cells that say in a marker why a table cell cannot
carry a floating label and a 48 px box. 40 `ListTile`s became
`PkLedgerRow.management`, including four destructive rows that were each
colouring their own title by hand and now ask for `destructive: true`. Both
rules are source gates; a `PopupMenuItem`'s child is exempt by shape, because
there `ListTile` *is* the Material convention.

**Home, as §5 actually specified it.** The brand header floats and snaps
(−76 px of permanent height). Accounts, Upcoming, Spending trend and Where it
went are one grouped surface of four rows, each carrying its own summary value
— the same height as the four section headers they replace, four answers
instead of four headings, and four redundant "See all" buttons gone.

**One substitution, stated.** Collapsing the two charts into rows would have
deleted them: neither had a destination. `/home/insights` now holds both
charts, both comparison labels and both accessible data tables, and the two
rows lead there. The acceptance journey follows the row rather than reading the
chart on Home, which is a stronger assertion than the one it replaced.

**`PkMotion.ambient` earned its place.** It had been added as a token with no
call sites, which is worse than no token. `KitoThinking` is the assistant's
waiting state — a three-second breath, reduced-motion gated so the ticker never
starts rather than merely being invisible.

---

## 3. Defects found and fixed

These were not in either audit's findings list. They were found by measuring.

| Finding | Fix |
|---|---|
| Light-mode gold measured **2.6:1** on the page — below even the 3:1 §5.6 requires of meaningful colour | `kitoGold600` #D88A00 → #9A6100 (5.14:1) |
| Brand aqua as *ink* measured **2.45:1**; it is a fill colour | New `kitoAqua700` #0E7C88 and an `ai` semantic colour |
| Rose ink measured **4.46:1** — a hair under the 4.5 an 11 px badge needs | #E11D48 → #D01640 |
| The hero gradient's aqua end carried **3.77:1 against pure white**, so no supporting text on it could pass | End stop #138FAF → #12798F, and 13 `white70`/`white60` washes made full white |
| `VisualDensity.compact` was shrinking touch targets in 10 places | Replaced with tight padding; banned by a source gate |
| `PkSkeleton` kept a ticker running under reduced motion, and crashed at teardown | Controller now starts and stops with the setting |
| `SpaceRole.label`/`.summary` — English getters for logs — were rendering in the UI | All routed through `labelIn(context.t)` |
| Colour swatches were 40×40 tap targets with no accessible name | 40 px chrome inside a 48 target, labelled "Colour N" |
| Activity's swipe row exposed gesture actions with no label and no non-gesture path | Semantics label plus custom actions a screen reader can invoke |
| Five `IconButton`s had no tooltip | Labelled |
| ~45 user-facing English literals in `lib/ui` | Moved to ARB; a source gate now fails on new ones |
| Three test harnesses resized the render view without updating `MediaQuery`, so they measured a 390×844 view against an 800×600 `MediaQuery` | Harnesses aligned; this is what made a correctly-sized sheet appear to overflow |

### Found by the adoption programme (UI-017 → UI-023)

| Finding | Fix |
|---|---|
| Six of twelve category colours failed 3:1 **as glyph ink**. `meetsGuideline(textContrastGuideline)` checks text, not icons, so no prior gate could see it | `PkAccent` splits fill from per-brightness ink; `PkIconTile` cannot take a bare colour |
| `_SpaceHero` drew the saturated category fill as ink on a white button — **1.75:1** | `accent.inkOn(Brightness.light)` |
| The Home hero's month control was white 12 px on `white .14` over the gradient — **4.39:1** | A navy scrim at .22 plus a white .28 hairline (~7:1); the same fix on `_SpaceHero`'s segmented control |

### Found by the dark-theme screenshot review (UI-024)

Every one of these renders correctly in light mode. That is why they survived
fifteen tasks of auditing: the light half of a frozen colour is the half that
gets looked at.

| Finding | Fix |
|---|---|
| **Unread notifications were a near-white card with near-white text on it.** `PkPalette.indigo50` was painted as the row background — the light end of a ramp with no dark counterpart — while the text on it followed the theme | `pkStatusSurface(context, tone)` derives the wash from the tone's own ink over the *current* surface. Same fix on the currency notice, the FX notice, the blocked-invite card and the allocation warning |
| **The unread dot, every verified tick and three notice icons were dark blue on dark blue.** The other half of the same defect: `indigo600` read on `indigo50` only because the background was frozen too | Ink routed through `pkStatusInk`, `colorScheme.primary` or `context.pk.*`. A second source gate now fails on a light-only tier used as a mark |
| **Twenty stacked date headers and no transactions.** A pinned `SliverPersistentHeader` pins to the *viewport*, so one per day meant every day already scrolled past stayed stuck at the top | Each day wrapped in `SliverMainAxisGroup`, which scopes the pinning to the group. A test now asserts that rows, not date bars, fill a deeply-scrolled viewport |
| **"Approval requested" rendered as "Appro…" beside a badge with room to spare.** `Row` divides free space by flex factor, so a title and a badge both at `Flexible(flex: 1)` each took half the line whatever they needed | The badge is measured at its own width and capped; the title takes the remainder |
| **"Household · EUR · 2 members" clipped beside an amount with slack.** The same trap one level up — `Expanded` and `Flexible` are both flex 1 | The amount column sizes to its content, capped at 55%. `PkDetailRow` had the identical bug and got the identical fix |
| The dark shared-money wash read as olive rather than gold at hero size | `sharedSurface` #362A12 → #241C0D, `sharedBorder` #755313 → #6B4C12. Large areas take the low-chroma end; the amber ink and hairline carry the signal |
| `PkAvatar` put a pale disc in the middle of a dark row | Fill and initials both follow the theme |

### Found while closing the roadmap (UI-025)

All three were exposed by giving content its own screen: on Home the charts sat
far enough down that a lazily-built sliver never rendered them into the checked
tree.

| Finding | Fix |
|---|---|
| The category donut's legend rows are tappable and were **24 px tall** — the smallest tap target in the app, on the one control that navigates into a filtered ledger | A legend that only labels the ring may stay tight; one that navigates gets `PkSize.touch`. Above 1.2× the percentage and amount move under the name rather than overflowing |
| `PkSectionHeader`'s action was inflexible and pushed the header past the gutter at 2.0× | The title is what the section *is*; the way in may ellipsize |
| `PkWelcomeBanner` inks its greeting navy to sit on the artwork, with nothing guaranteeing the artwork is there. An image that has not decoded leaves navy text on a navy page | The artwork's own pale field is painted beneath the image, so the ink always has the surface it was designed for |
| An unlabelled, full-screen tappable node sat above every route — the app-level tap-to-dismiss-the-keyboard gesture, advertised to screen readers as a button the size of the display | `excludeFromSemantics: true`. It is a convenience for a pointer, not a control |

---

## 4. Reconciled numbers

Two places where the audit's own figures could not all hold at once. Both are
documented here rather than silently resolved, per DoD item 16.

**The hero height budget (§7.1) versus the previous-period comparison (P0-12).**
148–168 px cannot hold net worth, a month control, spend and income *and* a
delta for each at default text. The hero was restructured — label, amount and
month control share one row — which lands it at ~160 px with the comparison
intact. The per-metric explanatory note is dropped on short screens.
**Owner:** design. **Risk:** low. **Target:** review at the next design pass.

**Two columns from 600 px (§4.7) versus row legibility.** A 600–839 px window
splits into two ~280 px columns — narrower than the phone layout they replace,
and the ledger rows inside them begin truncating. Home therefore reflows at 840
(`medium`), not 600. §4.7 permits two columns from 600 rather than requiring
them. **Owner:** design. **Risk:** low. **Target:** revisit if a 600–839 px
form factor becomes a target device.

---

## 5. Scope notes

- **Golden coverage.** §9.7 asks for evidence of eleven states on every primary
  route — a ~660-image cross-product, most of it duplicate. What is captured is
  every surface in light and dark, the states each route *declares* in the
  manifest, and each shared component's own variants: 69 images that a person
  can actually review. Adding a state to a manifest entry adds its baseline.
- **Manual VoiceOver and TalkBack sign-off** (§9.9) needs a physical device and
  remains outstanding. Everything a machine can check about semantics — labels,
  targets, contrast, announcement order, reduced motion — is checked on all 60
  surfaces in both themes.
- **Integration tests** need an attached device; the same journey runs headlessly
  in `test/pockito_acceptance_ui_test.dart`, which is what CI executes.
- **`/home/insights` is a new screen, not a moved one.** The spending trend and
  the category breakdown left Home because their section headers were the part
  competing with the hero, not because the charts were unwanted. Both are on
  the new screen in full, with their comparison labels and their accessible
  data tables. Nothing was dropped.
- **P2-14, Kito's pose by time of day, is not achievable as specified.**
  `welcome-header.png` is a single composed raster with Kito baked into it, so
  changing the pose is an artwork request, not a code change. It is reported
  here rather than approximated with an overlay, which would have put a second
  Kito on top of the first. **Owner:** design. **Unblocked by:** a set of poses
  delivered as separate assets, or the banner recomposed as art plus a sprite.

---

## 6. Verification

```
dart format lib test integration_test   # clean
flutter analyze                         # No issues found
flutter test                            # 215 passed
flutter build apk --debug               # ok
flutter build apk --release             # ok, 69.6 MB
```

Pockito's identity is unchanged: blue/aqua/gold, Kito, the Spaces model, the AI
trust posture and the finance feature set are all as they were. Nothing in
PayPay's branding, palette, layout, modules, icons or screen structure was
reproduced; the benchmark informed density and hierarchy principles only.
