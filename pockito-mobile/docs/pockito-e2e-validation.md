# Pockito prototype end-to-end validation

Validated: 16 August 2026  
Prototype: `pockito-mobile`  
Data mode: local `MockPockitoRepository` only

## Result

The mandatory clean-user journey passes from sign-in and onboarding through accounts, multi-currency transactions, budgets, a three-member Household Space, shared expenses, settlements, a new cycle, historical analysis, receipt review, subscriptions, filters, and the final dashboard/account reconciliation.

The automated journey starts only at `/auth`. Every later destination is reached through visible application navigation, buttons, sheets, menus, or back navigation. No feature route is injected during the scenario.

No open P0, P1, or P2 findings remain after the final re-test.

## Acceptance coverage

| Requirement | Result | Evidence |
|---|---|---|
| New user and onboarding | Pass | Name, generated/avatar state, Japanese selection, appearance preference, JPY reporting currency, first account, and natural Home landing |
| Accounts | Pass | Rakuten JPY, Cash JPY, BGL EUR, BIAT TND, and Revolut Savings EUR; create, open, edit, archive/restore surface, native balance, converted equivalent, and shared transaction history |
| Multi-currency and FX | Pass | Automatic/manual modes, provider and last-updated disclosure, unavailable-rate state, captured rates, approximate equivalents, cross-currency transfers, and foreign-wallet shared expenses |
| Personal budgets | Pass | All-expense and scoped category/account configuration, 80%/100% alerts, healthy/near/exceeded treatment, edit/delete, matching activity, and monthly history |
| Shared Spaces | Pass | Household identity, icon, colour, JPY currency, ¥300,000 budget, accepted/declined invitations, current members, and invitation history |
| Split rules | Pass | Equal, percentage, shares, and exact editors; invalid totals disable confirmation; the Space default pre-fills expenses and per-expense override remains available |
| Primary add flow | Pass | The central action opens a launcher offering Expense, Income, Transfer and Scan; each opens the add form with that kind already selected, and Scan opens the receipt scanner directly |
| Personal ledger | Pass | Salary and Lunch update Rakuten, Activity, dashboard totals, categories, and the applicable personal budget |
| Transfers | Pass | JPY→JPY and JPY→EUR update both account histories while remaining excluded from spending and income |
| Out-of-Pockito payments | Pass | Kana and Fran can pay without a Pockito account; Space totals/splits change and all wallet balances remain untouched |
| Shared expenses | Pass | Owner, Kana, and Fran activity; default and custom splits; tracked and outside payments; explicit foreign-wallet conversion; edit/delete recalculation |
| Balances and contributions | Pass | The Space shows paid amount, responsibility, net member balance, and a simplified “who pays whom” plan |
| Settlements and cycles | Pass | Partial and complete settlement, optional wallet movement, zero balance, preserved expenses, clean next cycle, and immutable previous-cycle analytics |
| Histories and filters | Pass | Date period/custom range, type, category, wallet, Space, payer/member, and settled state where logically applicable |
| Receipt scan | Pass | Capture, processing, low-confidence review, editable result, explicit confirmation, failure, retry, and manual-entry recovery; scan never auto-commits |
| Subscriptions | Pass | Create/edit, pause/resume, archive, next due, skip/pay, payment account/history, monthly total, annualized total, and foreign-currency debit behavior |
| Financial overview | Pass | Net worth, native accounts and reporting equivalents, income/spending, budgets, top categories, shared balances, subscriptions, recent activity, and Kito insight |
| State catalogue | Pass | Empty, loading, error, offline, disabled, validation, success, pending, declined, near/exceeded, settled/unsettled, OCR failure, unavailable/manual FX, and no-wallet states |
| Navigation | Pass | Home, Accounts, central Add, Spaces and More; 45 routed surfaces render at 320×568; phone shell, 900 px rail breakpoint, extended rail, nested back navigation, sheets, dialogs, and error route audited |
| Brand system | Pass | Kito identity, semantic pose library, light/dark use, reduced motion, launch/app icons, and promotional assets are documented in `kito-mascot-guide.md` |

## Known acceptance dataset and accounting oracle

All stored amounts use integer minor units. JPY has zero decimals, EUR has two, and TND has three. Currency conversions round once to the destination currency's minor unit using half-away-from-zero behavior from Dart's `round()`.

### Accounts after the complete run

| Account | Opening balance | Accepted activity | Final balance |
|---|---:|---|---:|
| Rakuten Bank · JPY | ¥500,000 | +¥350,000 salary −¥1,200 lunch −¥20,000 Cash transfer −¥100,000 Revolut transfer −¥2,480 scan −¥12,000 groceries +¥12,533 settlements received −¥1,490 Netflix | **¥725,363** |
| Cash · JPY | ¥10,000 | +¥20,000 transfer | **¥30,000** |
| BGL Luxembourg · EUR | €2,450.00 | −€100.30 for a ¥17,000 Household expense at manual 0.0059 EUR/JPY | **€2,349.70** |
| BIAT Tunisia · TND | DT 1,200.000 | No tracked activity | **DT 1,200.000** |
| Revolut Savings · EUR | €0.00 | +€590.00 from ¥100,000 at manual 0.0059 EUR/JPY | **€590.00** |

Kana and Fran's outside-Pockito payments never create account movements.

### Household closed cycle

| Metric | Ghassen | Kana | Fran | Total |
|---|---:|---:|---:|---:|
| Paid | ¥29,000 | ¥0 | ¥6,000 | **¥35,000** |
| Responsibility | ¥16,467 | ¥12,867 | ¥5,666 | **¥35,000** |
| Net before settlement | +¥12,533 | −¥12,867 | +¥334 | **¥0** |

Settlement sequence:

1. Kana → Ghassen ¥3,000 partial settlement.
2. Kana → Ghassen ¥9,533 remaining payment.
3. Kana → Fran ¥334 final payment.
4. Every current-cycle member balance equals ¥0.

The closed-cycle snapshot preserves:

- Spending: ¥35,000 of ¥300,000.
- Categories: Groceries ¥29,000; Shopping ¥6,000.
- Three expenses and three settlement records.
- Member paid/responsibility totals above.
- Read-only expense, settlement, category, contribution, and activity history.

The new Household cycle has zero usage and zero balances without mutating the snapshot.

### Cross-feature totals

- Income: **¥350,000**.
- Personal spending responsibility: **¥21,637**.
- Source-side transfers: **¥120,000**, excluded from spending and income.
- Personal monthly budget: **¥21,637 / ¥200,000**.
- Current Household budget after cycle rollover: **¥0 / ¥300,000**.
- Netflix recurring cost: **¥1,490/month; ¥17,880 annualized**.
- Every shared expense satisfies `sum(member responsibility) = expense amount`.
- Every Space satisfies `sum(member net balances) = 0` before and after settlement.

## Gap analysis and implemented resolutions

### P0 — Blocking

**Members & invites — add invitation**

- Reproduction: open Household → Members → Invite, enter a name/email, then send.
- Expected: the sheet closes safely and the invitation appears as Pending.
- Actual before fix: the sheet could rebuild with disposed text controllers during its closing transition and crash the journey.
- Root cause: controllers were owned by the caller and disposed as soon as the route future returned, before the exit animation had unmounted the form.
- Required change: move controller ownership into the sheet lifecycle and return immutable values.
- Resolution: implemented a state-owned, keyboard-aware, scroll-safe invite form; acceptance re-test passes.

### P1 — Major

**Household — balance breakdown**

- Reproduction: create three members and multiple settlement recommendations, then open Breakdown on a compact phone.
- Expected: paid, responsibility, net balances, and payment recommendations remain readable.
- Actual before fix: the fixed-height sheet overflowed after contribution details were added.
- Root cause: a non-scrollable `Column` was used for member-dependent content.
- Required change: make the sheet height-bounded and scrollable.
- Resolution: implemented an 82%-height scroll-safe sheet and added paid/responsibility details; acceptance re-test passes.

**Language selection — Japanese navigation**

- Reproduction: select Japanese in onboarding, then open Language settings or the primary shell.
- Expected: Japanese remains selected and the primary navigation demonstrates the chosen language.
- Actual before fix: onboarding stored `Japanese`, while settings used `日本語` as the value; navigation labels stayed English.
- Root cause: display labels and persisted language identifiers were conflated.
- Required change: canonical language identifiers plus localized display labels and navigation.
- Resolution: settings now preserve canonical values; primary navigation switches to ホーム, 口座, スペース, and 履歴 immediately.

### P2 — UX

**Authentication error, activity filters, receipt failure, and invite forms — compact layouts**

- Reproduction: open the affected states at 320×568 or with long account names/large text.
- Expected: all copy and controls remain reachable without clipping.
- Actual before fix: four independent fixed `Row`/`Column` compositions could overflow.
- Root cause: dynamic copy and state-dependent controls were not always given flex or scroll behavior.
- Required change: flex long headings and provide scroll-safe recovery/forms.
- Resolution: all affected surfaces were updated and the compact-route, long-name filter, and OCR-recovery regressions pass.

### P3 — Polish

No open P3 findings were retained. Kito sizing, compact insight spacing, theme contrast, app-icon crops, and campaign asset framing were refined during visual review.

## Final verification

- `flutter analyze`: pass, no issues.
- `flutter test`: pass, **42 tests**.
- Mandatory clean-user UI journey: pass from a fresh `MockPockitoRepository.empty()`.
- Route audit: pass across all declared prototype surfaces at 320×568, including `/more`, `/activity` and the pre-selected `/add?type=…` entries.
- Responsive visual review: pass at 390×844 and 1200×900.
- Theme review: light and dark pass; reduced-motion component behavior is tested.
- Web release build: pass; clean release runtime with no application console errors.
- Android debug APK: pass.
- iOS Simulator app: pass.
- Runtime mascot audit: 13 transparent semantic assets plus an opaque icon; all platform 1024/512/192 masters are correctly opaque.
- Placeholder audit: no `Coming Soon`, TODO, FIXME, “not implemented”, or under-construction strings in product code.
- Icon audit: every packaged icon runs full bleed or carries transparent corners, the iOS set is opaque, and the Android adaptive foreground is square and inside the 66dp safe zone.

## Re-test conclusion

The scenario was restarted from clean local state after the fixes. The final pass confirmed the exact wallet balances, budget totals, member responsibility, settlement remainder, zero-sum Space balance, subscription payment, activity filters, top-category dashboard data, clean new cycle, and immutable previous cycle listed above.

The prototype is suitable as the UI/UX reference for the future production application. Real authentication, banking, OCR, exchange-rate, notification, AI, and backend services remain deliberately outside this local prototype phase.

## Navigation revision — August 2026

The phone shell was rebuilt as a floating bar with a central add action, and the
information architecture moved to Home · Accounts · Add · Spaces · More.

**What changed and why**

- `/settings` was a hub reachable only from an unlabelled avatar on Home. It is
  now the **More** destination at `/more`; `/settings` redirects there so every
  existing link and deep link still resolves.
- **Activity** left the bar to make room for More. It is the first entry in the
  More hub, it is still one tap from Home's "See all", and it is now a pushed
  route with a real back control instead of a tab switch that discarded the
  caller's scroll position.
- The four shell branches are Home, Accounts, Spaces and More. No screen was
  duplicated and no surface became unreachable.

**Acceptance journey impact**

The journey now opens money events through the launcher
(`openAdd(tester, 'income' | 'transfer' | 'scan' | 'expense')`) instead of
opening the form and then switching type, reaches Activity through More, and
pops one fewer page when leaving the hub. Every financial assertion, balance,
responsibility split, settlement remainder and cycle snapshot is unchanged, and
the run still starts from `MockPockitoRepository.empty()` at `/auth`.

## Deep-link entry and naming — August 2026

Two follow-ups were closed after the navigation revision.

**No routed surface is a dead end.** `AppBar` only draws a back button when the
navigator can pop, so any screen opened directly by URL showed no way out.
`PkAppBar` now supplies one that falls back to the primary destination owning
the screen — `/accounts`, `/spaces`, `/home` or `/more` — and all 54 app bars use
it. A regression test walks eleven surfaces by link and asserts each returns to
the right destination.

**The product name is Pockito everywhere.** Files, classes, the Kotlin package,
the Android `applicationId` and the iOS `PRODUCT_BUNDLE_IDENTIFIER` were renamed
from `Pokito`/`app.pokito.pockito` to `Pockito`/`app.pockito.pockito`, and the
freezed models were regenerated rather than text-patched. No `pokito` spelling
remains in the project outside build output.

## Home header and brand refresh — August 2026

The supplied `designs/app-icon.png` and `designs/welcome-header.png` replaced the
generated icon master and the plain greeting header.

- **App icon.** Every iOS, Android legacy, Android adaptive, web and maskable
  icon, plus the in-app brand mark, is regenerated from the new master by
  `tool/generate_app_icons.py`. The master is edge to edge, so `CORNER_CROP` is
  now zero and each platform applies its own mask.
- **Home top area.** The greeting header became a brand row — the Pockito
  lockup with Search, Assistant and Notifications — above the welcome banner.
  Greeting, name and date are overlaid on the artwork and are fully dynamic:
  the greeting follows the time of day and the reader's language, the name comes
  from the profile, and the date is formatted for the locale.
- The old avatar shortcut to the settings hub is gone; More is a bottom-nav
  destination, so the acceptance journey now reaches it through the bar.

## Navigation overlay and scroll clearance

The floating bar overlays page content rather than reserving a strip, so a list
reads as continuing underneath it instead of stopping at a hard edge.

`Scaffold(extendBody: true)` makes Flutter report the bar's full height —
including its safe-area inset — as the body's bottom padding. `PkPage` adds
`PkSize.navClearance` to that value, so every page reserves exactly enough
trailing space for its last row to be scrolled clear of the bar, and a pushed
page with no bar reserves only the gesture inset. No screen carries a permanent
empty band, and the rule applies everywhere `PkPage` is used.
