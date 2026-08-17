# Pockito prototype end-to-end acceptance audit

Validated on 16 August 2026 against the product/UX analysis, mobile screen specification, the previous Pockito prototype, and the shared-money rules documented in the repository.

## Result

PASS — the clean-state acceptance journey is executable through the Flutter UI, financial invariants pass, all routed surfaces render at compact phone width, and the release web build succeeds.

The permanent acceptance scenario lives in `integration_test/pockito_acceptance_test.dart`. The identical scenario is also registered in `test/pockito_acceptance_ui_test.dart` so it runs in CI without requiring a connected phone. Repository-level accounting oracles live in `test/mock_pockito_repository_test.dart`.

## Clean-state numerical oracle

The UI acceptance run begins with no accounts, Spaces, transactions, budgets, subscriptions, invitations, settlements, or cycles.

### Native account movements

| Event | Rakuten JPY | Cash JPY | Revolut EUR | BGL EUR |
|---|---:|---:|---:|---:|
| Opening balance | ¥500,000 | ¥10,000 | €0.00 | €2,450.00 |
| Salary | +¥350,000 | — | — | — |
| Lunch | -¥1,200 | — | — | — |
| Rakuten → Cash | -¥20,000 | +¥20,000 | — | — |
| Rakuten → Revolut at 0.0059 | -¥100,000 | — | +€590.00 | — |
| Scanned receipt | -¥2,480 | — | — | — |
| Household groceries, edited to ¥12,000 | -¥12,000 | — | — | — |
| ¥17,000 Space expense paid from BGL | — | — | — | -€100.30 |
| Partial + final settlements received | +¥16,133 | — | — | — |
| Netflix occurrence | -¥1,490 | — | — | — |
| **Final** | **¥728,963** | **¥30,000** | **€590.00** | **€2,349.70** |

BIAT remains TND 1,200.000. Transfers and settlements do not count as income or spending.

### Household Space

- Canonical currency: JPY.
- Default split: Ghassen 60%, Kana 40%, Fran 0%.
- Edited groceries: ¥12,000; responsibility ¥7,200 / ¥4,800 / ¥0.
- Foreign-wallet supplies: ¥17,000 canonical; this expense overrides the Space default with an equal split of ¥5,667 / ¥5,667 / ¥5,666; BGL wallet debit €100.30 at 1 JPY = 0.0059 EUR.
- Kana's ¥8,000 outside-Pockito expense is created and participates in balances/budget, then deleted during the recalculation check; no wallet moves at creation or deletion.
- Final current-cycle spend before settlement/reset: ¥29,000.
- Ghassen net before settlement: +¥16,133; Kana: -¥10,467; Fran: -¥5,666; sum = ¥0.
- Partial settlement: ¥3,000; remaining recommendations: Kana ¥7,467 and Fran ¥5,666.
- Final settlements: ¥7,467 and ¥5,666; every member = ¥0.
- Starting the next cycle resets current Space budget usage to ¥0 and keeps the ¥29,000 settled historical snapshot, its two expenses, contributions, category totals, and all three settlement records.

### Other totals

- Income: ¥350,000.
- Personal non-shared spending: ¥5,170 (Lunch ¥1,200 + scanned receipt ¥2,480 + Netflix ¥1,490).
- Source transfer total: ¥120,000; destinations preserve ¥20,000 and €590.00 separately.
- Netflix recurring total: ¥1,490/month; ¥17,880 annualized.
- Allocation rule: every responsibility sum equals its expense total.
- Space rule: every member-net sum equals zero.
- Rounding: conversion rounds to the destination currency's smallest unit; split allocation rounds deterministically and assigns any final remainder to the last calculated member so totals never drift.

## Resolved gap analysis

### P0 — Blocking

1. **Cross-currency transfer accounting**
   - Reproduction: transfer JPY from Rakuten to an EUR account.
   - Expected: subtract JPY source, add independently calculated EUR destination, preserve rate and both amounts.
   - Actual before fix: the same minor-unit integer was applied to both wallets.
   - Root cause: `MoneyTransaction` carried only one amount.
   - Change: added captured destination amount/currency, rate mode/date, fees, validation, live conversion, and native-balance accounting.

2. **Pairwise settlement incorrectly closed a whole Space**
   - Reproduction: settle one recommendation in a three-person Space.
   - Expected: only that debt decreases; the cycle closes only when every member is zero.
   - Actual before fix: any confirmed settlement acted as the cycle boundary.
   - Root cause: member balances used the latest settlement as a global cutoff.
   - Change: settlements and expenses now belong to an explicit cycle; all current-cycle settlements adjust balances; new-cycle action requires every balance to equal zero.

3. **Editing a shared expense changed its cycle identity**
   - Reproduction: edit a current Household expense from ¥10,000 to ¥12,000.
   - Expected: same record/cycle, all wallet, budget, category, member, and activity values recalculate.
   - Actual before fix: the editor's default `current` string replaced the Space's real cycle ID, excluding the expense from current calculations.
   - Root cause: edit construction did not preserve `cycleId`.
   - Change: editor and repository both preserve the stored cycle; historical-cycle edits/deletes are rejected.

4. **Foreign-currency subscription debited the wrong unit**
   - Reproduction: record a JPY subscription from an EUR wallet.
   - Expected: preserve JPY subscription amount and debit a converted EUR amount.
   - Actual before fix: JPY minor units were applied directly to the EUR wallet.
   - Root cause: subscription payment assumed billing and wallet currencies matched.
   - Change: payments capture native wallet debit, billing source amount/currency, rate/mode/date, and show the approximate wallet debit before confirmation.

5. **Foreign-wallet split override converted the Space amount twice**
   - Reproduction: enter a ¥17,000 Household expense, choose an EUR wallet, then override its split.
   - Expected: member responsibilities sum to ¥17,000; the wallet conversion is unrelated to split allocation.
   - Actual before fix: the split editor interpreted 17,000 as EUR and converted it back to roughly ¥2.88 million.
   - Root cause: the split editor derived entry currency from the payment wallet even though the shared-expense form is canonical in the Space currency.
   - Change: split math always uses Space currency; the EUR wallet debit is calculated and captured separately.

### P1 — Major

1. **Onboarding was non-persistent** — profile/avatar, language, theme, reporting currency, and first account now save into the mock repository and land naturally on Home.
2. **Invitation states were decorative** — invitations are now entities with Pending, Accepted, Declined, and Revoked states; acceptance adds a real member.
3. **FX configuration was absent** — Settings now provides automatic provider/date disclosure and validated manual pairs. Transactions capture which mode was used.
4. **Split coverage was incomplete** — Equal, Percentage, Shares, and Exact are supported; invalid percentages/exact totals cannot save.
5. **Outside-Pockito and foreign-wallet shared expenses were ambiguous** — canonical Space amount and actual wallet debit are separate and inspectable; outside payment never moves a wallet.
6. **Cycle history was mutable/implicit** — settled cycle snapshots retain expenses, settlements, contribution/responsibility totals, categories, dates, and budget usage; closed records are read-only.
7. **Budget scope was too narrow** — personal budgets can cover all expenses or selected category/account combinations; Space budgets are explicit; current and previous monthly snapshots are visible.
8. **History filtering was too narrow** — Activity supports period/custom range, type, category, wallet, and Space; Space history adds member, category, and settled state.
9. **OCR only showed a happy path** — scan now includes processing, review-before-commit, low-confidence disclosure, failed scan, retry, and manual entry.
10. **Subscription lifecycle was incomplete** — create/edit, pause/resume, archive, record/skip payment, next due date, payment history, monthly total, and annualized total are implemented.

### P2 — UX

1. **Create-Space navigation lost the primary shell** — completion now returns to the Spaces list with a success message, from which the created Space opens normally.
2. **Settlement did not explain multi-member payments** — Space hero and breakdown now state who owes whom and show the minimum payer→receiver recommendations.
3. **Default-split sheet disposed fields during its exit animation** — controller lifetime now extends through route dismissal.
4. **Settlement result overflowed on compact phones** — result content is scrollable and the route sweep covers 320×568.
5. **Long currency selectors overflowed** — selectors use expanded responsive layout.
6. **Budget save action could sit behind lower navigation** — the primary save action is now a fixed safe-area action.

### P3 — Polish

1. Foreign account tiles/details now show subtle approximate reporting equivalents with rate mode.
2. FX, outside-Pockito, historical, near-limit/exceeded, and settled states use explicit semantic language instead of relying on colour alone.
3. The primary add action remains limited to Expense, Income, Transfer, and Scan to preserve speed.

## Verification evidence

- `flutter analyze`: no issues.
- `flutter test`: 17 tests passed, including the clean-state UI scenario, numerical oracles, route sweep, compact-size overflow checks, scan flow, and navigation checks.
- `flutter build web --release`: passed; Wasm dry run passed.
- Route sweep includes auth/onboarding, accounts, Space members/settings/settlements/cycles/history, activity, budgets, subscriptions, FX, settings, state catalogue, and error route.
- Live release-build browser audit confirmed native/approximate account totals, foreign-account disclosure, named Space debt, minimal multi-member settlement recommendations, full filter controls, and automatic/manual FX screens.
- Repository search found no required-flow `Coming Soon`, TODO, `Unimplemented`, or deliberately null primary action.
