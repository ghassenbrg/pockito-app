# Pockito — component-level adoption analysis and roadmap

**Date:** 2026-08-17
**Companion to:** [`pockito-vs-lifeos-ux-comparison.md`](./pockito-vs-lifeos-ux-comparison.md)
**Scope:** component ideas — selectors, fields, data displays — drawn only from features
Pockito *already has*. LifeOS surfaces with no Pockito counterpart (receipt-scanner camera
chrome, Today/calendar, modules) are excluded by design.

## Decisions carried in from review

- **`PkWelcomeBanner` stays exactly as it is.** P0-2 and P1-4 of the companion document are
  superseded: the Home density problem is re-solved in §5 without touching the banner.
- Everything else in the companion document stands.

## What was checked before recommending

Several things that looked like gaps are not. Verified in code and **excluded**:

| Looked like a gap | Reality |
|---|---|
| Itemized splitting | `SplitMethod.itemized` is in the domain **and** the UI — `activity_screens.dart:3292` is a full itemized editor |
| Split preview before commit | Exists — `_previewing` / `split_preview_accept`, `activity_screens.dart:3469` |
| Receipt attachment affordance | `PkAttachmentStrip` (`pk_records.dart:136`) covers LifeOS's `AppReceiptThumbnail` |
| Inline warnings / offline / read-only banners | `PkInlineNotice`, `PkOfflineBanner`, `PkReadOnlyRibbon`, `PkDeniedNotice` — all better than LifeOS's `_InlineWarning` |
| Payer selection | `_PayersEditor` (`spaces_screens.dart:3661`) covers `_PayerPickerField` |
| Settlement history | `SettlementHistoryScreen` + `SettlementDetailScreen` exist |

---

## 1. The headline component finding: Pockito's form layer is bypassed

UI-005 built a complete field system. The screens largely did not adopt it.

Counted across `lib/ui/features`:

| Raw Material | Uses | Pockito equivalent | Uses |
|---|---|---|---|
| `TextField(` | **20** | `PkAmountField` | **3** |
| `DropdownButtonFormField` | **24** | `PkSelectField` | **4** |
| `showDatePicker` (direct) | 1 | `PkDateField` | **2** |

The clearest case is the app's most consequential money-entry screen. `SettleUpScreen`
(`spaces_screens.dart` ~3120) enters a settlement amount with a bare `TextField` styled
`displayLarge` and a `prefixText`, then picks the wallet with a raw
`DropdownButtonFormField`:

```dart
TextField(
  key: const ValueKey('settlement_amount'),
  controller: _amount,
  textAlign: TextAlign.center,
  style: Theme.of(context).textTheme.displayLarge,
  decoration: InputDecoration(prefixText: '${_symbol(space.currency)} ', …),
),
…
DropdownButtonFormField<String>(isExpanded: true, …)
```

**What is lost by not using `PkAmountField` here:** tabular figures, the clamped text
scaling that stops a 32 px amount blowing the layout at 2.0×, quick-amount chips, the
sign control, and the currency-aware decimal handling from `PockitoCurrencies`.
**What is lost by not using `PkSelectField`:** the composed `"$label, $value"` semantics
node, the guaranteed 48 px target, the leading icon-tile slot, and the shared error slot.

This is not a visual-polish item. It is the difference between a design system that exists
and a design system that is used.

### Related system escapes found in the same pass

| Escape | Location | Should be |
|---|---|---|
| `ListTile` inside `PkCard(padding: zero)` for search results | `global_search_screen.dart` | `PkLedgerRow` inside `PkGroupedSurface` |
| `PkIconTile(size: 40, iconSize: 19)` — off the 38/44 contract | `global_search_screen.dart` | `PkIconTile()` (dense) |
| `ListTile(dense: true)` for checklist steps | `pk_records.dart:724` | `PkLedgerRow.management` |
| Three private detail-row duplicates | `_ManagementRow` `spaces:2603`, `_DetailRow` `spaces:3003`, `_ExpenseDetailRow` `spaces:4640` | one `PkDetailRow` |

The three private detail rows are the hard evidence for the `PkDetailRow` gap the companion
document inferred from LifeOS's `AppFieldRow`.

---

## 2. Component ideas worth adopting, ranked

Each is scored on: does it improve usability, clarity, consistency, efficiency, hierarchy,
accessibility or perceived quality? Anything that only differed was dropped.

### A-1 · Icon catalog with stable ids, groups and search keywords — **adopt**

**LifeOS:** `financeIconCatalog` (1 482 lines) defines `FinanceIconDefinition(id, icon,
group, keywords)` across 18 groups, with namespaced persisted ids and an explicit rule:

> Never rename an existing id: add a new one instead so previously saved categories keep
> rendering.

`showIconPicker` (`shared/widgets/icon_picker.dart`) is a domain-agnostic, searchable,
sectioned full-screen picker; the caller owns the catalog and supplies
`sectionsForQuery`.

**Pockito:** `PkIcons.named` is a 21-entry `switch` with `_ => Icons.category_outlined`
(`pk_icons.dart`, 27 lines). Every category, account, space and budget outside those 21
names renders as the *same* generic glyph — and the user has no picker at all.

**Stronger:** LifeOS, clearly. This is its single best data-model idea.
**Weakness in LifeOS's version:** the catalog is hand-written Dart with no test asserting
id uniqueness, and `keywords` are English-only, so a Japanese user searching the picker
gets nothing.
**Adopt as:** `PkIconCatalog` — `PkIconDef(id, icon, group, keywords)` with namespaced ids
(`food.restaurant`), groups as an enum with ARB labels, keywords localised per locale, and
a test asserting unique ids and that every persisted fixture id resolves. Plus
`showPkIconPicker` built on `PkSheetScaffold` + `PkSearchField` (both already exist).
**Verdict: adapt LifeOS's model, build on Pockito's sheet and search primitives.**
**Affects:** categories, accounts, spaces, budgets, subscriptions. **Effort: M.**

### A-2 · Currency selector inside the amount field — **adopt**

**LifeOS:** `AppCurrencyChip` — flag emoji + ISO code + chevron, sitting on the right of
the amount card, tappable to change currency at the point of entry.

**Pockito:** `PkAmountField(controller, currency, …)` takes the currency as a fixed
argument. The caller decides it upstream; the reader cannot change it while entering.
Pockito is explicitly multi-currency — `PkFxDisclosure`, `equivalentMinor`,
`PockitoCurrencies.of(code).decimals` — so this is a real friction point in a place the
product cares about.

**Stronger:** LifeOS on the interaction; Pockito on everything around it.
**Weakness in LifeOS's version:** flag emoji render inconsistently across platforms and are
a poor proxy for currency (the euro, the dollar); the chip is 34 px tall.
**Adopt as:** optional `currencies` + `onCurrencyChanged` on `PkAmountField`, rendered as a
suffix control inside the existing 48 px field — **code only, no flag**, opening the
existing currency sheet. When the chosen currency differs from the space or reporting
currency, show `PkFxDisclosure` inline underneath.
**Verdict: combine.** **Affects:** `PkAmountField`, add/edit money event, settle up,
budget editor. **Effort: S.**

### A-3 · Balance-impact statement before commit — **adopt (highest product value)**

**LifeOS:** `_BalanceImpactCard` states the consequence in plain language before saving:
"*{other} will owe {payer}* +¥1,200 · Your balance goes from ¥3,400 to ¥4,600."

**Pockito:** the split *preview* shows how the amount divides. It does not say what the
save does to the balance between two people. `PkBalanceLabel.announce` already produces
exactly the right sentence form ("You're owed X" / "You owe X") — the vocabulary exists,
it is just not used as a before/after.

**Stronger:** LifeOS on the idea; its execution is poor (`const TextStyle()` placeholders,
hardcoded `Colors.orange`, no semantics).
**Why it matters:** shared money is Pockito's differentiator, and the moment a shared
expense is saved is the moment a relationship number changes. Stating that before the tap
is the single highest-trust interaction in the product.
**Adopt as:** `PkBalanceImpact(previousMinor, deltaMinor, currency, counterpartyName)` —
built on `PkInlineNotice`'s shape with `PkStatusTone.shared`, amounts through
`PkAmountText`, direction in words via `PkBalanceLabel.announce`, and one composed
semantics node so a screen reader hears the whole consequence in one utterance.
**Verdict: replace both** — LifeOS's idea, Pockito's vocabulary and accessibility.
**Affects:** add/edit shared expense, settle up, settlement review. **Effort: S–M.**

### A-4 · Segmented split-allocation bar with legend — **adopt**

**LifeOS:** `_SplitAllocationBar` is a 12 px pill split into per-member segments sized by
`flex`, each colour-keyed to a `_SplitLegendDot` overlaid on that member's avatar in
`_SplitMemberRow` — so the bar and the row list are legible together. Segments carry a
`hasPattern` flag, i.e. a non-colour cue.

**Pockito:** `PkShareRule` — a 64 px wide, 2 px tall single-value bar, used **once**
(`spaces_screens.dart:4531`), no legend, no per-member segments, no label.

**Stronger:** LifeOS, and by a wide margin on the one feature Pockito is built around.
**Weakness in LifeOS's version:** 12 px is thin for a touch target if segments are ever
tappable, and the legend dot is 14 px.
**Adopt as:** `PkSplitBar(segments)` where a segment is `(memberId, minor, PkAccent,
pattern)`; 10–12 px tall, `PkRadius.full`, hairline dividers, minimum visible segment width
so a 2% share is still findable; legend dots resolved from the same `PkAccent` used by the
member's avatar; `Semantics` announcing each member's share as a percentage and an amount;
and `PkChartDataTable` as the tabular equivalent, matching what Pockito already does for
every other chart.
**Verdict: combine.** **Affects:** split editor, shared-expense detail, space detail.
**Effort: M.**

### A-5 · Record lifecycle timeline — **adopt**

**LifeOS:** `AppTimeline` — a compact vertical rail with completed/pending markers, used on
detail screens for audit and lifecycle state.

**Pockito:** `PkRecordStatusBanner` / `PkRecordStatusBadge` say *what state a record is in*
but not *how it got there*. `SpaceActivityLogScreen` shows a whole space's history; there
is no per-record equivalent.

**Stronger:** LifeOS for this specific job.
**Adopt as:** `PkRecordTimeline(entries)` where an entry is `(title, detail, timestamp,
PkStatusTone, done)`; markers use `PkStatusBadge` colours so lifecycle and status share one
grammar; each entry composes into one semantics node.
**Verdict: adapt.** **Affects:** transaction detail, shared-expense detail, settlement
detail, invite review. **Effort: S.**

### A-6 · Cross-language search synonyms — **adopt the idea, not the file**

**LifeOS:** `search_registry.dart` maps destinations to search terms in **four** languages
— `'budget'`, `'予算'`, `'ميزانية'`, `'ميزانية'` all reach Money. So a Japanese reader
finds a screen by typing a Japanese word even when the UI label differs.

**Pockito:** `viewModel.search(query)` matches entity names only. Typing "budget" or "予算"
finds a budget *named* that; it cannot find the Budgets screen, Categories, Preferences or
any destination.

**Stronger:** LifeOS on reach.
**Weakness in LifeOS's version:** the terms are hardcoded const lists in a Dart file that
localisers never see, so they rot the moment a label changes.
**Adopt as:** a `searchTerms` key per destination **in the ARB files** (`app_en.arb`,
`app_ja.arb`) — comma-separated synonyms that localisers own — merged into the existing
`PkSearchHit` pipeline as a `destination` kind. `GlobalSearchScreen` already groups by
kind, so destinations slot in as one more group.
**Verdict: replace both** — LifeOS's reach, delivered through Pockito's localisation
pipeline instead of a Dart constant. **Effort: S–M.**

### A-7 · Long-text entry in a dedicated sheet — **adopt selectively**

**LifeOS:** `_TextEntrySheet` — notes are entered in a focused sheet with `autofocus`,
`minLines: 2`, and bottom padding tracking `viewInsetsOf(context).bottom`, rather than as a
multiline field inside a scrolling form.

**Pockito:** notes are inline `TextField`s in long editors. `PkPinnedActions` already
handles the keyboard for the submit button, but a multiline field mid-form still fights the
scroll position.

**Stronger:** LifeOS for notes specifically; inline is right for short single-line fields.
**Adopt as:** `PkNoteField` — renders as a `PkSelectField`-shaped row showing the current
note (or a placeholder), opening `PkSheetScaffold` with the editor. One line in the form,
full room to write.
**Verdict: adapt, narrowly.** **Affects:** add/edit money event, shared expense, settle up,
budget editor. **Effort: S.**

### A-8 · Scope as a visible field — **adopt cautiously**

**LifeOS:** `FinanceScopePicker` makes personal-vs-space an explicit control in the form.

**Pockito:** scope arrives as a route query (`/add?space=…`) and is largely fixed
thereafter. Someone who starts a personal expense and realises it should be shared has to
back out.

**Stronger:** LifeOS on flexibility.
**Risk:** this is *not* the global space switcher rejected in the companion document §11.7.
It is a per-record field, and that distinction must hold — a scope field in a form is fine;
a scope pill in the app header is not.
**Adopt as:** a `PkSelectField` labelled "Personal / {space}" in the editor, changing scope
re-runs the split section. **Verdict: adapt.** **Effort: M** (state, not visuals).

---

## 3. Explicitly not adopted

Beyond the thirteen items in the companion document §11, these component-level patterns
were considered and rejected:

| Pattern | Why not |
|---|---|
| `AppCurrencyChip`'s flag emoji | Inconsistent glyphs across platforms; a flag is a country, not a currency |
| `AppNotificationCard` | Card-per-row; `PkGroupedSurface` is correct |
| `_SplitAllocationBar`'s 12 px tappable segments | Below the 48 px floor if made interactive — keep the bar passive, put interaction in the rows |
| `AppSuggestionChip` (140 px shadowed card) | Pockito's `PkQuickActions` `ActionChip` row is lighter and already themed |
| `_PrimaryFooter` / `AppPrimaryCta` gradient stripes | Three competing CTA gradients; `PkPinnedActions` + `PkSubmitButton` is the answer |
| `AppStatusChip`, `AppTagChip`, `AppAiPill`, `AppCornerBadge`, `AppStatusDot` | Five shapes for what `PkStatusBadge` + `PkStatusTone` does in one |
| `AppFieldRow`'s fixed 78 px label column | Breaks at 2.0× text and in Japanese; `PkDetailRow` should use a flexible label with a minimum |

---

## 4. Consolidated backlog additions

New items, to be read alongside the companion document's P0-1, P0-3, P1-5…P2-15.

| ID | Item | Type | Priority | Effort |
|---|---|---|---|---|
| **C-1** | Migrate 20 `TextField` / 24 `DropdownButtonFormField` to `PkAmountField` / `PkSelectField` / `PkDateField`; add a source gate banning raw form fields in `lib/ui/features` | Pockito improvement | **P0** | L |
| **C-2** | `PkDetailRow`; collapse `_ManagementRow`, `_DetailRow`, `_ExpenseDetailRow` | LifeOS-inspired | **P1** | S |
| **C-3** | `PkIconCatalog` + `showPkIconPicker` replacing `PkIcons.named` | LifeOS-inspired | **P1** | M |
| **C-4** | `PkBalanceImpact` before-and-after consequence statement | Beyond both | **P1** | S–M |
| **C-5** | `PkSplitBar` + legend, replacing `PkShareRule` | Best-of-both | **P1** | M |
| **C-6** | Currency control inside `PkAmountField` + inline `PkFxDisclosure` | Best-of-both | **P1** | S |
| **C-7** | Destination + synonym search via ARB `searchTerms` | Beyond both | **P2** | S–M |
| **C-8** | `PkRecordTimeline` | LifeOS-inspired | **P2** | S |
| **C-9** | `PkNoteField` (sheet-based long text) | LifeOS-inspired | **P2** | S |
| **C-10** | Scope as a field in the editor | LifeOS-inspired | **P2** | M |
| **C-11** | `GlobalSearchScreen` onto `PkLedgerRow` + `PkGroupedSurface`; fix off-contract `PkIconTile(40/19)` | Pockito improvement | **P2** | S |

---

## 5. Home density, re-solved with the banner kept

`PkWelcomeBanner` stays. The ~176 px it occupies is now a fixed cost, so the reclaim has to
come from the three things around it. Measured baseline at 390×844, nav line at **758**:

| Element | Top | Bottom |
|---|---|---|
| Brand header | 0 | 76 |
| `PkWelcomeBanner` | 76 | 251.6 |
| Action-required block | 251.6 | ~470 |
| `PkHeroPanel` | 481.6 | 680.6 |
| `PkQuickActions` | 692.6 | 732.6 |
| First section header | 752.6 | 812.6 |

**Three changes, none touching the banner:**

1. **Make `_HomeBrandHeader` a floating sliver.** `SliverAppBar(floating: true, snap: true)`
   carrying the wordmark and the three `PkIconAction`s. It is present on arrival, scrolls
   away, and returns on any upward scroll. **−76 px of permanent height**, nothing removed.
2. **Progressive disclosure (companion §7.4).** Two sections stay full — "Who owes whom"
   and "Budgets". Accounts, Upcoming, Spending trend and Where it went collapse into one
   `PkGroupedSurface` of four `PkLedgerRow.management` rows, each carrying its own trailing
   summary value. Four header blocks (~224 px) become four 56 px rows (224 px) that each
   *carry a number* — same height, four times the information, and four redundant "See all"
   buttons disappear. **−~112 px of chrome above the fold** (the four headers were the part
   competing for the first viewport).
3. **Move `PkQuickActions` below the first data section.** They are a shortcut, not an
   answer; the hero already gives the answer. **−52 px above the fold.**

**Projected:** first data row moves from y≈812 to **y≈570** — comfortably above the 758 nav
line, with the "Who owes whom" group showing two or three real rows. The D-02 two-hero
overlap resolves because the hero and the banner no longer share the viewport with a
section header wedged between them.

**Gate:** extend `pk_density_test.dart` with the Home case from companion §7.3 — ≥2 data
rows above the navigation at 390×844, default scale.

---

## Status — all phases landed, 18 August 2026

Every phase below is implemented, with one substitution and one item blocked on artwork.

| Phase | State | Notes |
|---|---|---|
| **UI-017** Accents | ✅ | `PkAccent` splits fill from per-brightness ink; `PkIconTile` refuses a bare `Color`. Six of twelve category colours were failing 3:1 as glyph ink. |
| **UI-018** Fields | ✅ | 0 `DropdownButtonFormField`, 0 `showDatePicker`, 0 raw `TextField`/`TextFormField` outside three marked inline numeric cells. `PkTextField` was added to close the plain-text case the original plan had not named. Source gate in place. |
| **UI-019** Rows | ✅ | `PkDetailRow` replaced four private copies; 40 `ListTile`s migrated to `PkLedgerRow.management`; gate bans the rest outside `PopupMenuItem`. |
| **UI-020** Home | ✅ | All three §5 changes landed, including the floating brand header and progressive disclosure. See the substitution below. |
| **UI-021** Shared money | ✅ | `PkSplitBar`, `PkBalanceImpact`, split-editor goldens at 1.0× and 2.0×. |
| **UI-022** Icons and search | ✅ | ~60-entry catalogue with namespaced ids and a legacy map; ARB-owned search synonyms. |
| **UI-023** Polish | ✅ | `PkRecordTimeline`, provenance badges, scope as a field, RTL goldens, container ceiling, `PkMotion.ambient` in `KitoThinking`. |
| **UI-024** Dark theme | ✅ | Not in this plan — a defect family found by reviewing dark-mode screenshots. See the completion record. |

**One substitution in UI-020 §5.** The plan collapsed *Spending trend* and *Where it went*
into rows, but neither chart had a destination, so collapsing them would have deleted them
from the product. A `/home/insights` screen was added to hold both charts, both comparison
labels and both accessible data tables in full; the two rows lead there. The acceptance
journey now follows the row rather than reading the chart on Home.

**P2-14 (Kito's pose by time of day) is not achievable as written.** `welcome-header.png` is
a single composed raster with Kito baked into it, so a pose change is an artwork request,
not a code change. The banner is kept exactly as it is, per the product decision in §1.

Three defects were found while closing these phases that no audit had caught: a chart
legend whose tappable rows were 24 px, a section header whose action pushed past the gutter
at 2.0×, and a greeting inked navy over an image with no guaranteed backdrop beneath it.

---

## 6. Roadmap

Phases continue the existing `UI-0xx` numbering. Each phase has an exit gate that is a
**test**, not a review, matching how UI-001…UI-016 were run.

### UI-017 · Accent and contrast correction — *foundation, blocks everything visual*

- Companion **P0-1**: `PkAccent(fill, ink, surface)`; `PkIconTile` accepts only `PkAccent`;
  `PkPalette.categoryAt` returns one.
- Extend the contrast suite from text to **icon glyphs and status ink**, all accents ×
  light/dark × {surface, sunken}.
- **Exit gate:** `pk_accessibility_test.dart` asserts ≥3:1 for every accent ink; zero
  `PkIconTile(color:` remaining.
- **Why first:** six of twelve category colours currently fail. Every later phase touches
  icon tiles, so fixing the type afterwards means touching them twice.
- **Effort: M.** No visible redesign — the colours shift, nothing moves.

### UI-018 · Form-field migration — *the largest correctness win*

- **C-1**: migrate all raw `TextField` / `DropdownButtonFormField` / `showDatePicker`.
- **C-6**: currency control in `PkAmountField` (done here so screens migrate once).
- **C-9**: `PkNoteField` (same reason).
- Add source gates to `pk_system_usage_test.dart` banning raw form fields in
  `lib/ui/features`, in the same shape as the existing raw-size and literal gates.
- **Exit gate:** gates pass; `pk_targets_test.dart` and `pk_accessibility_test.dart` pass
  on every editor surface in the manifest; goldens regenerated for editors.
- **Order within the phase:** Settle Up first — it is the most sensitive and the worst
  offender — then add/edit money event, shared expense, budget editor, subscription editor,
  space and category editors.
- **Effort: L.** The biggest single phase; split by screen if it needs to land incrementally.

### UI-019 · Row and detail consolidation

- **C-2** `PkDetailRow`; delete the three private duplicates.
- **C-11** `GlobalSearchScreen` onto the row system; fix the off-contract icon tile.
- **P1-9** `PkSetupChecklist` off `ListTile(dense: true)`.
- **P2-10** `PkSize.chevron = 20`.
- **Exit gate:** no `ListTile` in `lib/ui/features` outside an explicit exemption;
  `pk_ledger_test.dart` covers `PkDetailRow`; goldens regenerated.
- **Effort: M.**

### UI-020 · Home composition

- §5 above: floating brand header, progressive disclosure, quick actions repositioned.
- **P1-5** section chrome reduction.
- **P0-3 / companion §7.3** density contract stated and gated, Home included.
- **Exit gate:** `pk_density_test.dart` asserts ≥2 Home data rows above the nav; chrome
  ≤60% of the visible page; `PkWelcomeBanner` still `findsOneWidget`; Home goldens
  regenerated.
- **Depends on:** UI-019 (the collapsed sections are `PkLedgerRow.management` rows).
- **Effort: M.**

### UI-021 · Shared-money components — *the differentiator*

- **C-4** `PkBalanceImpact`.
- **C-5** `PkSplitBar` + legend + `PkChartDataTable` equivalent; retire `PkShareRule`.
- **P1-8** progress and arc colour bound to `PkStatusTone`.
- **Exit gate:** new widget tests for both components incl. semantics announcements; split
  and settle flows carry an impact statement; `pk_golden_test.dart` extended with the split
  editor at 1.0× and 2.0×.
- **Depends on:** UI-017 (segments are `PkAccent`s).
- **Effort: M.**

### UI-022 · Icon catalog and search reach

- **C-3** `PkIconCatalog` + `showPkIconPicker`; migrate persisted icon names to namespaced
  ids with a compatibility map so existing fixtures keep rendering.
- **C-7** destination + synonym search through ARB `searchTerms`.
- **Exit gate:** test asserts unique ids, that every fixture icon name resolves through the
  compatibility map, and that a Japanese synonym reaches its destination in `ja`.
- **Effort: M.**

### UI-023 · Polish and proof

- **C-8** `PkRecordTimeline`; **C-10** scope as a field.
- **P2-11** `PkMotion.ambient`; **P2-12** container recount; **P2-13** pseudo-RTL locale in
  the golden matrix; **P2-14** Kito pose by time of day *inside the existing banner*;
  **P2-15** badged icon tile for AI/receipt provenance.
- **Exit gate:** full suite green, golden matrix regenerated including the RTL locale.
- **Effort: M.**

### Dependency order

```
UI-017 (accents) ─┬─> UI-018 (fields) ──> UI-019 (rows) ──> UI-020 (home)
                  └─> UI-021 (shared money)
                       UI-022 (icons/search) — independent, any time after UI-018
                       UI-023 (polish) — last
```

`UI-022` only needs the field system in place (the picker opens from a `PkSelectField`), so
it can run in parallel with `UI-019`–`UI-021` if there is capacity.

### Where to start

**UI-017 first, and it is a day or two of work.** It fixes a live accessibility defect,
touches no layout, and every later phase depends on the accent type existing. Ship it
alone, regenerate goldens, confirm the suite is green — then open UI-018, and inside it do
**Settle Up before anything else**: it is the screen where a raw `TextField` is handling the
most consequential number in the product.
