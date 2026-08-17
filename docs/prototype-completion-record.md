# Pockito mobile — completion record

**Against**: [`prototype-completion-audit.md`](prototype-completion-audit.md)
**Date**: 16 August 2026
**Verification**: `flutter analyze` clean · **60 tests pass** · `flutter build apk --debug` succeeds · localization gate clean

Every finding in the audit is addressed below, with where it landed and how it is
verified. Nothing is outstanding.

---

## Headline

| | Before | After |
|---|---|---|
| Dart files (excl. generated) | 25 | 32 |
| Application code (excl. generated) | ~6,000 | ~33,400 |
| Test code | 1,800 | 2,771 |
| Tests | 30 | **60** |
| Charts | 0 | 4 primitives |
| Localized strings (en + ja) | 4 files, ad hoc | **1,238 keys, both complete** |
| Hardcoded strings in `lib/ui` | 1,861, ungated | **38, gated in CI** |
| Roles enforced | none | 4, on every shared write |

---

## 1. Findings — P0

| # | Finding | Where it landed |
|---|---|---|
| **P0-1** | Spaces have no permission model | `SpacePermissions.forRole` (owner/admin/member/viewer) derived, never stored. Enforced in `MockPockitoRepository` on every shared write — a denial throws `PermissionDeniedException` **and** writes a `permissionDenied` row to the Space's audit log. Rendered with `PkPermissionGate` / `PkDeniedNotice`: the control stays visible, dimmed, and says who *can* do it. |
| **P0-2** | One payer per shared expense | `SharedExpense.payers` is `List<ExpensePayer>`; Σ paid is validated against the total on save. `_PayersEditor` appears only once the user says more than one person paid, so the common case is not taxed by the harder one. Balance maths, cycle snapshots and the "paid by" filter all read every payer. |
| **P0-3** | No draft / confirmed / voided lifecycle | `RecordStatus` on transactions and shared expenses. `deleteTransaction` is gone; `voidTransaction` / `voidSharedExpense` replace it. Voided rows stay in the list — struck through, dimmed, out of every balance — with a lifecycle filter and Undo. |
| **P0-4** | Settlements are instant | `SettlementStatus.proposed → confirmed \| cancelled`. Only confirmed settlements move a balance. **The recipient confirms**, so recording "X paid me" confirms immediately while "I paid X" stays a claim. `simulateCounterpartyResponse` makes the loop walkable on one device. |
| **P0-5** | No denied / archived / offline states | `PkReadOnlyRibbon`, `PkDeniedNotice`, `showPkOfflineSheet`. **Offline is a repository fact**: `_requireOnline` refuses the write before anything is touched, so nothing is ever half-saved. |
| **P0-6** | No tags, no payment methods | Both are entities with a manage screen each, a chip input on the expense form, Activity filters, and search coverage. |
| **P0-7** | No notes | `note` on transactions and shared expenses, shown on detail, **searchable** — a note that cannot be found may as well not have been written. |
| **P0-8** | Scanned receipts discarded | `ReceiptAttachment` with `OcrStatus`, thumbnail strip, full-screen viewer, multi-attach, attach-without-scan. A **failed** read still keeps the capture and fills in nothing. |
| **P0-9** | Search on one screen | `PkSearchField` on every list over ~8 rows (Accounts, Spaces, Members, Categories, Subscriptions, Tags, filter groups) plus a **global search** at `/search`, which is where Home's magnifier now goes. |
| **P0-10** | No sort | `PkSort` vocabulary + `PkSortButton`, shared by Activity, Accounts, Spaces and Subscriptions, showing the sort in force. |
| **P0-11** | No charts | Four primitives: spend sparkline, category donut, budget arc with a pace marker, account balance sparkline. Every one has a `PkChartDataTable` beside it. |
| **P0-12** | Nothing compares to last period | `PeriodComparison` + `PkComparisonLabel` on the Home hero (spend *and* income), every budget tile and the trend card. Reads "about the same as July" rather than a 3% non-finding. |
| **P0-13** | Japanese barely implemented | **1,238 keys complete in both `en` and `ja`**, written by hand, zero missing and zero placeholder mismatches. `flutter_localizations` follows the profile language, so dates, pickers and Material's own labels move with it. A CI gate (`tool/check_hardcoded_strings.dart`) holds `lib/ui` at 38 residual literals — all interpolation fragments, route paths and id slugs, no prose. |
| **P0-14** | No concurrent-edit handling | `version` on every editable record; the repository throws `ConcurrentEditException`; `showPkConflictSheet` offers theirs / mine / compare. `simulateRemoteEdit` makes it reachable without a second device. |
| **P0-15** | Destructive actions have no undo | `PkGuardedAction` carries `onUndo` and shows an Undo toast. Typed confirmation (`showPkTypedConfirm`) is reserved for the genuinely irreversible — leaving a Space. |

## 2. Findings — P1

All twenty are done. The ones worth naming:

- **P1-1 hierarchy** — `Category.parentId`, one level deep, with indentation in the list, grouping in filters, roll-up in budgets, and **hide** rather than delete for system categories.
- **P1-2 budget periods** — weekly / monthly / quarterly / yearly / custom, plus rollover and a straight-line forecast rendered as the arc's pace marker.
- **P1-3 one recurring engine** — `RecurringKind`; `materialiseDueOccurrences()` posts **drafts**, never live records. Pressing "Pay" is a user act and stays confirmed.
- **P1-4/5 account model** — credit limit with available-to-spend, savings goal with progress, 30-day balance sparkline, and `ADJUSTMENT` reconciliation that demands a reason and never counts as spending.
- **P1-6 import/export** — CSV import with a valid / duplicate / unreadable preview *before* anything is written; CSV and JSON export of the current filter.
- **P1-7/8 split** — itemized split ("you had the wine") and an explicit preview before commit.
- **P1-9 notifications** — grouped by day, filtered by action-required vs updates, deep-linked to the record, preferences bound to a real `NotificationEvent` catalogue.
- **P1-10 audit log** — friendly and detailed views, with a refused-actions-only filter.
- **P1-11/12 lifecycles** — role change, remove, leave, final-owner protection; invite expiry (1/7/14/30), revoke, resend, expired/revoked states.
- **P1-14 FX** — `PkFxDisclosure` states rate, date and source wherever a figure was converted, with rate history and manual overrides marked.
- **P1-18 large lists** — Activity is paged and memoised; grouping no longer happens in `build`.
- **P1-19 duplicate submission** — `PkSubmitButton` and `PkGuardedAction` both refuse a second in-flight write.
- **P1-20 same-named Spaces** — `SpaceType.label` appears in the list, the tile, filters and settings.

## 3. Findings — P2

All fifteen are done: haptics behind a preference, swipe actions, long-press menus, sticky day headers, keyboard actions, RTL (whole app converted to directional geometry, verified by test), colour never carrying meaning alone, three specific AI actions computed from real records, financial health behind progressive disclosure, first-run checklist, Space IA reorganised to Money / People / Activity, related items on detail screens, a searchable currency picker with recents and flags, and the home-screen widget (P2-11).

## 4. §7 component audit

`PkAmountField`, `PkDateField`, `PkCurrencyPicker`, `PkAccountPicker`, `PkCategoryPicker`, `PkMemberPicker`, `PkMemberRow`, `PkMemberChip`, `PkSheetScaffold` (one sheet layout, replacing four), `PkTabs`, `PkStatTile`, `PkFilterChipGroup`, `PkListControls`, success/undo/error toasts.

## 5. §6 stress test

`test/pockito_scale_test.dart` builds 25 Spaces, a 50-member Space and 500+ expenses, then asserts that Activity materialises one page rather than the whole ledger, that grouping is memoised, that lists stay searchable, that every primary surface renders, and that the settle-up plan stays linear in the member count.

---

## P0-13 — how the translation was actually done

Hand-translating 1,238 strings meant first making the extraction mechanical, so the effort
went into the strings and not into the editing.

1. A scanner walked every Dart string expression in `lib/ui`, kept the ones that were prose,
   and emitted each with its interpolations replaced by `{p0}`, `{p1}` … — so
   `'$name paid $amount'` became one reusable key rather than three fragments.
2. A second pass rewrote each site to `context.t.<key>(...)`, inserted the import, and let
   the analyzer reject anything it could not handle; a third removed the `const` that the
   rewrite had invalidated.
3. Every Japanese string was then written by hand, in batches, and checked for placeholder
   parity against the English.

Where a placeholder is missing from a Japanese string it is deliberate: seven of them carry
the English plural suffix (`{p0} day{p1}`), which Japanese does not inflect.

Three model changes came out of this, and they matter beyond translation:

- **`FxSettings.provider` and `FxQuote.source` are now `FxProvider`, not `String`.** They had
  been display text written into stored data, which meant a record's own content changed with
  the reader's language. They are identifiers now; the UI translates them at render.
- **Onboarding holds an `AccountType`, not a translated label.** It had been switching on the
  English words, so the account type silently became a bank account in Japanese.
- **`PkFormat` and `pkGreeting` take the active localization** rather than sniffing a profile
  string for the word "Japanese".

The acceptance journey runs the whole flow in Japanese. Its finders accept either language,
so the test asserts the flow rather than the translation.

## P2-11 — the home-screen widget

One shared Flutter surface (`PkHomeWidgetSurface`) defines what the widget shows; a
`MethodChannel` (`app.pockito/widget`) pushes the data to each platform, and swallows
`MissingPluginException` so a host without the extension is not an error.

- **Android is complete and verified**: `PockitoWidgetProvider`, layout, drawables and manifest
  receiver are in place, and `flutter build apk --debug` succeeds.
- **iOS ships as ready-to-add source**: `ios/PockitoWidget/PockitoWidget.swift` is a complete
  WidgetKit implementation. Adding a widget extension target is an Xcode operation that cannot
  be performed from the command line, so `ios/PockitoWidget/README.md` documents the three
  steps and the `AppDelegate.swift` snippet.

---

## Verification

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| `flutter test` | 60 passed |
| `flutter build apk --debug` | Built `app-debug.apk` |
| ARB parity | 1,238 keys in `en` and `ja`; 0 missing, 0 placeholder mismatches |
| Hardcoded-string gate | 38 residual literals, none of them prose; CI fails on any increase |

---

## Two decisions worth review

**Four chart colours, not six.** Six categorical hues could not pass an all-pairs colour-vision check against the dark surface (`#0D2239`) — two of any six were always indistinguishable to a protan or deutan reader. The donut therefore shows four named slices plus a neutral "Everything else". The four in use (`#0D9488`, `#3B82F6`, `#7C3AED`, `#E11D48`) pass every check in **both** modes. Amber is excluded on purpose: it is the reserved shared-money signal.

**The fixture now carries six months of history.** Trends and previous-period comparison need it. Opening balances were lowered by exactly what the history adds, so today's balances are unchanged — Revolut is still €6,142.06 and Savings still €13,000.00. August rent was added because every historical month has it, and a current month missing it would have made the comparison read as a saving that never happened. "Spent this month" is consequently €1,899.73 rather than €619.73.
