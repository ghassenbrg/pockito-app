# Pockito mobile — prototype completion audit

**Date**: 16 August 2026
**Subject**: `pockito-mobile` (Flutter, local `MockPockitoRepository`)
**Compared against**: `pockito-core`, `pockito-ui`, `life-os` (specs `012-shared-spaces`,
`014-finance-shared`, `016-product-ux-audit`; `life-os-mobile` finance + spaces features)
**Question answered**: what is still missing before we freeze UI/UX and start backend work

> **Status — 16 August 2026: all findings addressed.** Every P0, P1 and P2 in this
> audit is complete, verified by `flutter analyze` (clean), 60 passing tests and a
> successful `flutter build apk --debug`. See
> [`prototype-completion-record.md`](prototype-completion-record.md) for where each
> finding landed.

---

## 0. What each reference actually contains

Reading the references first changed the shape of this audit, so it is worth stating what
is really in them.

| Project | What it holds | Verdict as a reference |
|---|---|---|
| `pockito-core` | Spring/JPA. 5 entities: `User`, `Wallet`, `Transaction`, `Category`, `Subscription`. Hierarchical categories, wallet savings goals, subscription intervals. **No spaces, splits or settlements.** | Authoritative for personal finance only |
| `pockito-ui` | Angular 17. Wallets, transactions, subscriptions, a **stub dashboard** (12-line component), a "budgets" nav item with nothing behind it. Full `en`/`fr`/`ja` i18n. 10 shared components. | Behind the prototype on features; **ahead on localization** |
| `life-os` `014-finance-shared` | 17 finance entities, 104 functional requirements, full OpenAPI. Tags, payment methods, multi-payer expenses, draft/void lifecycles, receipts + OCR, recurring templates, import/export, FX snapshots. | **The real feature bar** |
| `life-os` `012-shared-spaces` | Roles, permission matrix, invite lifecycle, activity log, member lifecycle. | **The real collaboration bar** |
| `life-os` `016-product-ux-audit` | 48 FRs of UX-audit remediation — states, navigation, large-result handling, accessibility. | **The real production-readiness bar** |

Two consequences:

1. **`pockito-ui` is not a migration source.** Its dashboard is empty and its feature set is a
   subset of the prototype's. The only thing worth taking from it is its localization discipline.
2. **The gap is against `life-os`, not against Pockito's own history.** Nearly every P0 below
   traces to a Life OS FR that the prototype has not yet met.

---

## 1. Feature gap analysis

### 1.1 Exists elsewhere, missing here

| Capability | Source | Note |
|---|---|---|
| Tags on transactions (M:N) | `014` FR-033, `life-os-mobile/tags_screen.dart` | No tag concept at all |
| Payment methods | `014` FR-023, `payment_methods_screen.dart` | No concept at all |
| Multi-payer shared expenses | `014` FR-040/041 | Prototype has a single `payerUserId` |
| Draft → Confirmed → Voided lifecycle | `014` FR-045/046/047 | Prototype writes are immediately live |
| Propose → Confirm → Cancel settlements | `014` FR-053 | Prototype settlements are instant |
| Receipt attachments as records + OCR status | `014` FR-060–064 | Scanner exists; nothing is stored |
| Roles + permission matrix | `012` FR-008/018a | `SpaceMember.role` exists but is a display label |
| Member lifecycle (role change, remove, leave) | `012` FR-016/017 | None implemented |
| Final-owner protection | `012` FR-009/010 | None |
| Activity/audit log with actor + grant/deny | `012` FR-020/022 | Space activity is a thin event list |
| Category hierarchy | `core` `parentCategory`, `014` FR-030 | Prototype categories are flat |
| Budget periods beyond monthly | `014` FR-080 | `frequency` is hardcoded `MONTHLY` |
| Recurring templates (general) | `014` FR-070–073 | Only Subscriptions exist |
| `ADJUSTMENT` transactions / reconciliation | `014` FR-020 | No way to correct a balance |
| Wallet savings goal | `core` `Wallet.goalAmount` | Missing |
| Import (CSV) / Export (CSV, JSON) | `014` FR-090–093 | Missing |
| Itemized split | `014` FR-043 | Prototype has equal/percentage/shares/exact |
| Split preview before save | `014` FR-044 | Editor computes but does not preview-then-commit |
| Optimistic-lock conflict UX | `014` FR-026 | Missing |
| Full localization | `pockito-ui` `en`/`fr`/`ja` | 4 files carry Japanese; the rest is hardcoded English |

### 1.2 Present but partial

- **Roles** — modelled (`OWNER`/`MEMBER`), rendered as a label, never enforced.
- **Soft delete** — `MoneyTransaction.deleted` and `SharedExpense.deleted` exist in the model but
  the UI deletes permanently and nothing surfaces deleted records.
- **Offline** — a banner exists; every write still succeeds while "offline".
- **Notifications** — a list with read state and one swipe-to-dismiss + undo, but no grouping,
  no filters, and preferences that do not map to the real event catalogue.
- **FX** — modes, provider and captured rates exist; no rate history, no report-header
  disclosure, no manual-override audit.
- **Search** — exactly one search field in the product (Activity).

### 1.3 Over-simplified

- **Settlement as a single instant act.** Real three-person settlement is a negotiation:
  someone proposes, someone confirms, someone may cancel. The prototype's model collapses this.
- **One payer per expense.** The most common real dispute ("we both put money in") is
  unrepresentable.
- **Budgets as monthly-only, category-or-all.** No forecast, no rollover, no comparison.
- **Space activity as a feed of nice sentences** rather than an audit record.

### 1.4 Worth bringing over

Space detail IA of Overview / Money / People / Activity / Settings (`016` FR-010); invite review
that explains role, permissions and consequences (`016` FR-008); guided first-run checklist
(`016` FR-005/009); connections/related-items on detail screens (`016` FR-029).

### 1.5 Duplicate or unnecessary — do **not** migrate

- **Subscriptions vs recurring templates.** Life OS models one concept; Pockito has Subscriptions
  and would gain a second. Keep **one** engine — recurring templates — and let Subscriptions be a
  filtered *view* over it. Two parallel entities will diverge.
- **Life OS module/connections framework.** Pockito is a single-purpose finance app. Importing the
  module registry buys complexity with no payoff.
- **Per-space categories.** Life OS explicitly walked this back (categories are the owner's global
  catalogue). The prototype already matches the corrected model — keep it.
- **Per-expense `SETTLED` status.** Life OS deprecated it in its own spec. Do not reintroduce.
- **Prototype scaffolding in production IA.** "State catalogue", "Replay onboarding" and
  "Invitation review" sit in the More hub as first-class rows. Move them behind a debug flag.

### 1.6 Where mobile should beat the older implementations

- **Dashboard.** `pockito-ui`'s is an empty stub; there is nothing to copy and no incumbent to
  respect. This is the single biggest opportunity in the product.
- **Cycles.** Pockito's Space cycle concept is *better* than Life OS's open-ended balance. Keep it,
  and derive shared budget periods from the cycle rather than adding a second period system.
- **Kito.** Life OS has no mascot. The warmth is a genuine differentiator — the gap is that Kito
  currently appears only at empty/error moments and never during success or progress.

---

## 2. Findings — P0

*Must fix before the prototype is considered complete.*

---

### P0-1 · Spaces have no permission model

- **Current** `SpaceMember.role` holds `'OWNER'`/`'MEMBER'` and is rendered as the text "Owner" or
  "Member" in two places. Nothing is gated.
- **Problem** Every member can do everything: edit anyone's expense, settle, change settings,
  archive the space.
- **Why it matters** Shared money without permissions is not shippable. It is also the one thing
  the backend cannot retrofit — permission states change what every shared screen renders.
- **Reference** `012` FR-008, FR-018, FR-018a (fixed owner/admin/member/viewer matrix)
- **Solution** Add `viewer` and `admin` roles. Introduce a `SpacePermissions` value object derived
  from role, and gate: edit/delete others' expenses, settle, manage budgets, invite, remove,
  change roles, archive. Render disabled affordances with a reason, not hidden ones.
- **Affected** `SpaceDetailScreen`, `SpaceMembersScreen`, `SpaceSettingsScreen`,
  `SharedExpenseDetailScreen`, `SettleUpScreen`, `AddMoneyEventScreen`
- **Complexity** Large

### P0-2 · A shared expense can only have one payer

- **Current** `SharedExpense.payerUserId` is a single id.
- **Problem** "We split the bill and both paid part of it" cannot be recorded.
- **Why it matters** This is one of the most common real shared-expense shapes; it is also a
  model change, so it must land before backend contracts freeze.
- **Reference** `014` FR-040, FR-041 (`shared_expense_payer` is a collection; Σ paid = total)
- **Solution** Replace `payerUserId` with `List<ExpensePayer>{userId, amountMinor, accountId?}`.
  Validate Σ = total with the same live-validation treatment the split editor already uses.
- **Affected** `AddMoneyEventScreen`, `SharedExpenseDetailScreen`, member-balance maths, split editor
- **Complexity** Medium

### P0-3 · No draft / confirmed / voided lifecycle

- **Current** Everything saves live; delete is permanent. `deleted` exists on the model but is unused.
- **Problem** No way to stage an expense, no audit trail after a correction, no reversal that keeps
  history.
- **Why it matters** Deleting money records without a trace is disqualifying for a finance app, and
  the "Show, then save" pattern is what makes OCR and recurring safe.
- **Reference** `014` FR-025, FR-045, FR-046, FR-047 (hard delete is FORBIDDEN)
- **Solution** Add `status` to transactions and shared expenses. Delete becomes void. Voided rows
  stay visible, struck through, excluded from balances. Add a "Deleted / voided" filter.
- **Affected** All money lists, `TransactionDetailScreen`, `SharedExpenseDetailScreen`, Activity filters
- **Complexity** Medium

### P0-4 · Settlements are instant, with no proposal step

- **Current** Confirm settlement writes immediately and moves balances.
- **Problem** With three or more members, one person unilaterally declares another has paid.
- **Why it matters** This is the flow most likely to cause a real dispute between real users.
- **Reference** `014` FR-053, FR-055
- **Solution** `PROPOSED → CONFIRMED | CANCELLED`. Only confirmed settlements move balances. The
  recipient confirms. Surface pending proposals on Home and in the Space.
- **Affected** `SettleUpScreen`, `SettlementDetailScreen`, `SettlementHistoryScreen`, Home, Notifications
- **Complexity** Medium

### P0-5 · Permission-denied, archived-read-only and offline-write states do not exist

- **Current** One offline *banner*. Archived spaces still accept writes. No denied state anywhere.
- **Problem** The prototype only demonstrates the happy path for a user who is allowed to do
  everything and is online.
- **Why it matters** These states are where a finance app either reassures or terrifies. They are
  also explicitly mandated by both Life OS specs.
- **Reference** `012` FR-030, `014` FR-093, `016` FR-014, FR-015, FR-032
- **Solution** Three shared treatments: a read-only ribbon (archived / viewer), a blocked-action
  sheet with action-specific recovery copy (offline), and an inline denied state with the reason and
  who can help. Block offline writes *before* submission.
- **Affected** Every write surface; new shared components
- **Complexity** Medium

### P0-6 · No tags and no payment methods

- **Current** Neither concept exists.
- **Problem** Users cannot answer "how much did I spend on the Berlin trip" or "how much went on
  the Amex" — the two most common cross-cutting questions after category.
- **Reference** `014` FR-023, FR-033; `life-os-mobile` `tags_screen.dart`, `payment_methods_screen.dart`
- **Solution** Add both as light entities with a manage screen each in More, a chip input on the
  expense form, and filters in Activity.
- **Affected** `AddMoneyEventScreen`, Activity filters, More, two new manage screens
- **Complexity** Medium

### P0-7 · Transactions have no notes field

- **Current** `merchant` only.
- **Problem** No place to record *why* — the context that makes a ledger reviewable months later.
- **Reference** `core` `Transaction.note` (1000), `014` `description` (2000)
- **Solution** Add an optional multiline `note`, shown on the detail screen and searchable.
- **Affected** `AddMoneyEventScreen`, `TransactionDetailScreen`, Activity search
- **Complexity** Small

### P0-8 · Scanned receipts are never kept

- **Current** The scanner extracts values into the form and discards the capture.
- **Problem** The expense has no receipt afterwards. Re-checking a charge is impossible.
- **Why it matters** "Show me the receipt" is the primary reason to scan at all.
- **Reference** `014` FR-060–064 (`receipt_attachment` with an OCR status lifecycle)
- **Solution** Persist an attachment on the transaction/shared expense with `ocrStatus`. Show a
  thumbnail on the detail screen with a full-screen viewer; allow attach-without-scan and multiple
  attachments; never auto-apply OCR values.
- **Affected** Scanner sheet, `TransactionDetailScreen`, `SharedExpenseDetailScreen`, `AddMoneyEventScreen`
- **Complexity** Medium

### P0-9 · Search exists on exactly one screen

- **Current** One field, on Activity.
- **Problem** Accounts, Spaces, Categories, Subscriptions, Members, Settlements and Cycles have no
  search. With 10 accounts, 10 spaces or 500 expenses these become unusable.
- **Reference** `014` FR-024, `016` FR-025, FR-031
- **Solution** Search on every list over ~8 rows. Add global search reachable from the Home search
  action — it currently routes to Activity as a stand-in.
- **Affected** Accounts, Spaces, Categories, Subscriptions, Members, Settlements; new global search
- **Complexity** Medium

### P0-10 · No sort controls anywhere

- **Current** Every list has one hardcoded order.
- **Problem** "Largest expense this month", "oldest unsettled", "account with least money" are
  unanswerable.
- **Solution** A shared sort control (date, amount, name, balance) beside each filter entry point,
  with the active sort shown.
- **Affected** Activity, Accounts, Spaces, Subscriptions, Budgets, Settlements
- **Complexity** Small

### P0-11 · The app contains no charts

- **Current** Zero visualisations. Two `pie_chart` *icons*. The only `CustomPaint` is the scanner frame.
- **Problem** A finance dashboard made entirely of numbers and lists.
- **Why it matters** This is the clearest single signal that this is a prototype rather than a
  finance product.
- **Reference** `014` FR-081
- **Solution** Four small, shared, token-driven primitives: spend-trend sparkline (6 months),
  category donut, budget arc, account balance sparkline. Accessible labels, no colour-only meaning,
  reduced-motion respected.
- **Affected** Home, `BudgetDetailScreen`, `AccountDetailScreen`, `SpaceCycleDetailScreen`
- **Complexity** Medium

### P0-12 · Nothing compares to the previous period

- **Current** "Spent €619.73" with no reference point.
- **Problem** A number without a baseline carries no judgement. Users cannot tell a good month from
  a bad one.
- **Reference** `014` FR-081
- **Solution** Delta vs the previous period on the hero and on each budget and category row, with
  direction and a plain-language reading ("about the same as July").
- **Affected** Home hero, `_CategorySpendRow`, `PkBudgetTile`, `BudgetDetailScreen`
- **Complexity** Small–Medium

### P0-13 · Japanese is advertised but barely implemented

- **Current** Localized strings live in 4 files: navigation labels, the greeting, two settings rows,
  onboarding. Everything else is hardcoded English.
- **Problem** Selecting 日本語 produces a Japanese tab bar over an English app.
- **Why it matters** It is a promise the product visibly breaks, and retrofitting i18n across ~9,000
  lines of screens after backend work is far more expensive than doing it now.
- **Reference** `pockito-ui` ships complete `en`/`fr`/`ja` bundles
- **Solution** Extract every user-facing string to ARB, adopt `flutter_localizations`, and add a
  release gate that fails on hardcoded literals in `lib/ui`.
- **Affected** Every screen
- **Complexity** Large

### P0-14 · No concurrent-edit handling

- **Current** Last write wins, silently.
- **Problem** Two members editing the same expense destroy each other's work with no signal.
- **Reference** `014` FR-026 (version column, HTTP 409, merge/refresh UX)
- **Solution** Carry a `version` on editable records now, and design the conflict sheet — "Kana
  changed this while you were editing" with *theirs / mine / merge*. The UI must exist before the
  backend can return 409.
- **Affected** `AddMoneyEventScreen`, `SpaceSettingsScreen`, `BudgetEditorScreen`, settlements
- **Complexity** Medium

### P0-15 · Destructive actions have no undo

- **Current** Undo exists only for dismissing a notification. Deleting an expense, account, budget,
  space or member is immediate and final.
- **Reference** `016` FR-034
- **Solution** Undo snackbar for anything reversible; typed confirmation only for the genuinely
  irreversible; consistent destructive copy that states the consequence.
- **Affected** Every delete path
- **Complexity** Small–Medium

---

## 3. Findings — P1

*Strongly recommended — expected from a mature finance application.*

| # | Finding | Current → Recommended | Reference | Affected | Complexity |
|---|---|---|---|---|---|
| P1-1 | **Flat categories** | No parent/child → hierarchy with roll-up totals; system categories hideable not deletable | `core` `parentCategory`, `014` FR-030/032 | Categories, filters, reports | Medium |
| P1-2 | **Monthly-only budgets** | `frequency` hardcoded `MONTHLY` → weekly/quarterly/yearly/custom, plus rollover and end-of-period forecast | `014` FR-080 | Budgets, editor, Home | Medium |
| P1-3 | **Subscriptions ≠ recurring** | Two parallel concepts → one recurring engine; Subscriptions become a view. Pause/resume/end; occurrences materialise as **drafts**, never auto-posted | `014` FR-070–073 | Subscriptions, Activity, Home | Medium |
| P1-4 | **Thin account model** | Opening balance only → current vs available balance, credit limit for cards, savings goal with progress, balance trend | `core` `goalAmount`, `014` `current_balance_minor` | Accounts, detail | Medium |
| P1-5 | **No reconciliation** | No way to correct a balance → `ADJUSTMENT` transaction type with a reason | `014` FR-020 | Account detail, add flow | Small |
| P1-6 | **No import/export** | Nothing → CSV import with a preview showing valid/invalid/skipped rows; CSV+JSON export of the current filter | `014` FR-090–093 | More, Activity | Large |
| P1-7 | **No itemized split** | 4 methods → add itemized ("you had the wine") | `014` FR-043 | Split editor | Medium |
| P1-8 | **No split preview** | Computed inline → explicit preview of per-payer and per-participant amounts before commit | `014` FR-044 | Split editor, add flow | Small |
| P1-9 | **Notifications are a flat list** | Read state only → group by day and type, filter action-required vs updates, deep-link to the object, preferences mapped to the real event catalogue | `012` FR-028, `016` FR-020/021 | Notifications, settings | Medium |
| P1-10 | **Space activity is not an audit log** | Friendly sentences → actor, timestamp, item, event type, and permission grant/deny; friendly view by default with a detailed filter | `012` FR-020/022, `016` FR-030 | Space activity | Medium |
| P1-11 | **No member lifecycle** | Invite + simulate accept only → change role, remove member, leave space, with final-owner protection and its error state | `012` FR-009/010/016/017 | Members, settings | Medium |
| P1-12 | **Invites lack a lifecycle** | Send + simulate → expiry choice (1/7/14/30 days, default 7), revoke, resend, expired/revoked states | `012` FR-012a/015 | Members, invite review | Small–Medium |
| P1-13 | **No global quick actions** | Add is bottom-nav only → contextual quick actions per surface (add expense here, scan, settle up, invite) | `016` FR-006 | All primary screens | Small |
| P1-14 | **FX not disclosed in reports** | Rates captured, never explained → rate value + snapshot date + source in any converted view header; rate history; manual override captured | `014` FR-083/084/085 | Home, account detail, reports | Medium |
| P1-15 | **Inconsistent loading/error states** | Skeletons on Home only; other screens flash or show nothing | `016` FR-032 | All list screens | Medium |
| P1-16 | **Amount input is a plain text field** | `TextFormField` with `displayLarge` → dedicated amount field: currency-aware live formatting, correct keypad, quick amounts, sign affordance | — | Add flow, budgets, settlements | Medium |
| P1-17 | **Filters are fire-and-forget** | Sheet + count badge → individually removable active-filter chips, reset-all, persistence across sessions, saved views | `016` FR-031 | Activity, all filtered lists | Medium |
| P1-18 | **No large-list strategy** | Every list builds eagerly; Activity groups all transactions on every build | `016` FR-031 (500 items, 50 members, 25 spaces) | Activity, Spaces, Members | Medium |
| P1-19 | **No duplicate-submission guard** | Double-tapping Save can create two records | `016` FR-044 | Every save/confirm/settle | Small |
| P1-20 | **Same-named spaces are indistinguishable** | `SpaceType` is rendered only inside Space settings — not in the list, tiles or invite surfaces where two "Household" spaces must be told apart | `012` FR-001a | Spaces list, `PkSpaceTile`, invite review | Small |

---

## 4. Findings — P2

*Polish and differentiation.*

| # | Finding | Recommendation | Complexity |
|---|---|---|---|
| P2-1 | **No haptics anywhere** | Selection tick on nav/segment/chip, success on save, warning on destructive confirm | Small |
| P2-2 | **No swipe actions** | Swipe a transaction row for edit/duplicate/delete; a subscription for pay/skip | Small |
| P2-3 | **No long-press context menus** | Long-press an account, space or expense for its actions without opening it | Small |
| P2-4 | **Activity day headers scroll away** | Sticky `SliverPersistentHeader` per day group | Small |
| P2-5 | **Motion is route-level only** | Add list-item stagger on first paint, shared-element transition from row to detail, and a success animation on settle | Medium |
| P2-6 | **Keyboard handling is default** | Done/next accessories, next-field focus order, scroll-to-focused-field in long forms | Small |
| P2-7 | **RTL not ready** | Several `fromLTRB` / `Alignment.centerRight` usages; switch to directional equivalents and test with `Directionality.rtl` | Small–Medium |
| P2-8 | **Balance meaning is colour-carried** | `PkBalanceLabel` pairs colour with text — extend that discipline to charts and progress bars once they exist | Small |
| P2-9 | **AI is a console, not an assistant** | Today: connections, approvals, activity. Add three *specific* actions where a traditional UI is slower — explain this month, compare two months, flag unusual expenses. Do not add NL search until search itself exists | Medium |
| P2-10 | **Dashboard is missing financial health** | Add cash flow (in vs out vs net), savings rate, disposable remaining, upcoming obligations total, unusual-spend flag — behind progressive disclosure so Home stays calm | Medium |
| P2-11 | **No home-screen widget** | Life OS ships `FinanceWidget`. A balance + this-month widget is high-visibility, low-cost | Medium |
| P2-12 | **Onboarding has no setup checklist** | Land new users on a progress checklist: profile, first account, first expense, first space, notifications | `016` FR-005/009 · Small |
| P2-13 | **Space detail IA is technical** | Reorganise to Overview / Money / People / Activity / Settings | `016` FR-010 · Medium |
| P2-14 | **Detail screens are terminal** | Add related items: receipts, the space, the recurring template, the settlement, the budget | `016` FR-029 · Small |
| P2-15 | **Currency selector is a plain dropdown** | `pockito-core` defines ~150 currencies; add search, recents, and flags (`pockito-ui` ships a flag set) | Small |

---

## 5. Dashboard analysis

The Home screen currently answers: net worth, spent, income, one Kito insight, account balances,
shared totals, budgets, subscriptions, top 3 categories, recent 5 transactions.

**It cannot answer:**

| Question | Status |
|---|---|
| How does this month compare with last? | Missing → **P0-12** |
| What is my cash flow / am I net positive? | Missing → P2-10 |
| What is my spending trend? | Missing → **P0-11** |
| Anything unusual this month? | Missing → P2-10 |
| How much can I still spend? | Partially — budget remaining exists, no disposable figure |
| Who owes whom? | Only a total; no per-member breakdown on Home |
| What is due soon, in total? | Individual subscriptions only, no total |
| Anything waiting on me? | Only AI approvals — not invites, settlements or drafts |

**Prioritisation problem.** The AI approval banner sits above net worth. An AI connection request is
rarer and less urgent than an unsettled balance or a pending invite. Home should lead with an
**action-required** block (`016` FR-004) covering invites, settlement proposals, draft expenses
awaiting confirmation and budget breaches — and only then show passive summaries.

**Redundancy.** "Shared" totals on Home duplicate the Spaces tab hero almost exactly. Replace the
Home block with *who owes whom* — the part the Spaces tab does not show at a glance.

---

## 6. Realistic data stress test

Walking the current implementation against the target volumes from `016` FR-031:

| Scenario | Expected outcome |
|---|---|
| 10+ accounts | Home's horizontal account strip becomes a long swipe with no overview; Accounts list has no search or sort |
| 10+ spaces | Spaces list is a flat unsearchable column; same-named spaces are indistinguishable (P1-20) |
| Space with 6 members | Balance breakdown sheet and split editor were designed around 2–3; the settle-up plan grows quadratically |
| 500 expenses | `ActivityScreen` regroups every transaction into a day map on **every build**; no pagination |
| Many categories/tags | Category filter is a flat unsearchable chip list |
| Long merchant names | Handled — `ellipsis` is applied consistently |
| Large JPY values | Handled — zero-decimal and tabular figures are correct |
| Multiple currencies | Handled per account; no portfolio-level FX disclosure (P1-14) |
| Empty new account | Handled |
| Over-budget month | Handled — exceeded state is well designed |
| Multiple unsettled members | Recommendations exist; no proposal/confirm loop (P0-4) |
| Month with no activity | Month picker allows navigating to an empty month; totals correctly read zero but there is no dedicated empty-period treatment explaining why |

Two of these are code-level risks rather than design gaps: Activity's per-build regrouping and the
settle-up plan's growth. Both should be fixed before the data set grows.

---

## 7. Component audit

The design system is in better shape than the feature set. `PkCard`, `PkHeroPanel`,
`PkBottomNav`, `PkEmptyState`, `PkAmountText`, `PkBalanceLabel`, `PkIconTile`, `PkProgressBar`
and the Kito components are consistent and token-driven, and the analyzer shows no scattered
hard-coded colours, radii or text styles in feature code.

**What still reads as prototype:**

| Component | Issue | Recommendation |
|---|---|---|
| Amount input | Plain `TextFormField` at `displayLarge` | `PkAmountField` — see P1-16 |
| Date picker | Raw Material `showDatePicker` | `PkDateField` with relative shortcuts (Today, Yesterday) |
| Currency selector | Plain `DropdownButtonFormField` | `PkCurrencyPicker` with search + recents |
| Account selector | Plain dropdown with `'Name · CUR'` strings | `PkAccountPicker` showing icon, colour and balance |
| Category selector | Plain dropdown | `PkCategoryPicker` with icon, colour, and hierarchy |
| Member selector | Ad-hoc rows per screen | `PkMemberPicker` + a shared `PkMemberChip` |
| Filter sheets | Three hand-rolled variants (Activity, Settle, Split) | One `PkFilterSheet` |
| Segmented controls | Material `SegmentedButton` with theme overrides | Acceptable; verify at 320 px with three long JA labels |
| Progress bars | `PkProgressBar` is good | Add label + accessible value; needed once budgets forecast |
| Toasts | Themed `SnackBar` | Add a success variant with an icon, and an undo variant |
| Tabs | `_TabsDelegate` is local to Spaces | Promote to `PkTabs` |
| Charts | Do not exist | See P0-11 |

**Duplication worth consolidating:** four bottom-sheet layouts implement their own header +
drag-handle + action row; three screens hand-roll a member row; two hand-roll a stat tile.

---

## 8. Prototype completion checklist

Freeze UI/UX only when every box is ticked.

### Model and lifecycle
- [ ] Roles extended to owner / admin / member / viewer with a fixed permission matrix
- [ ] Permissions enforced on every shared write, with visible denied states
- [ ] Multi-payer shared expenses (Σ paid = total)
- [ ] Draft / confirmed / voided lifecycle on transactions and shared expenses
- [ ] Delete replaced by void everywhere money is involved
- [ ] Propose → confirm → cancel settlements
- [ ] `version` field on every editable record + conflict resolution sheet
- [ ] Tags and payment methods
- [ ] Transaction notes
- [ ] Receipt attachments with OCR status, viewer, and multi-attach

### States
- [ ] Empty, loading (skeleton), error, offline, permission-denied, archived read-only, partial-data
      and first-use states on **every** primary screen
- [ ] Offline writes blocked before submission with action-specific recovery copy
- [ ] Undo on every reversible destructive action
- [ ] Retry on every failed load
- [ ] Duplicate-submission guard on every save / confirm / settle
- [ ] Empty-period state for months with no activity

### Data and discovery
- [ ] Search on every list over ~8 rows, plus global search
- [ ] Sort control on every significant list
- [ ] Active-filter chips with individual removal, reset-all, and persistence
- [ ] Pagination or virtualisation on Activity, Spaces, Members
- [ ] Activity regrouping moved out of `build`
- [ ] Verified with 25 spaces, 50 members in one space, 500 expenses

### Dashboard
- [ ] Action-required block above passive summaries
- [ ] Previous-period comparison on hero, budgets and categories
- [ ] Spend-trend, category donut, budget arc and balance sparkline primitives
- [ ] "Who owes whom" replacing the duplicated shared totals block
- [ ] Cash flow and disposable-remaining, behind progressive disclosure

### Breadth
- [ ] Category hierarchy
- [ ] Budget periods beyond monthly, with rollover and forecast
- [ ] One recurring engine; Subscriptions as a view over it
- [ ] Account current vs available balance, credit limit, savings goal
- [ ] `ADJUSTMENT` / reconciliation
- [ ] Itemized split + split preview
- [ ] Member lifecycle: role change, remove, leave, final-owner protection
- [ ] Invite expiry, revoke, resend, and expired/revoked states
- [ ] CSV import with preview; CSV/JSON export
- [ ] FX disclosure in every converted view

### Quality
- [ ] All user-facing strings externalised; `en` + `ja` complete; lint gate against literals
- [ ] Haptics on selection, success and destructive confirmation
- [ ] Swipe actions and long-press menus on primary rows
- [ ] RTL verified with `Directionality.rtl`
- [ ] Accessibility: labels on every icon-only control, no colour-only meaning, 48×48 targets
- [ ] Light and dark verified on every screen
- [ ] Prototype scaffolding moved behind a debug flag
- [ ] Acceptance journey extended to cover permissions, void, and settlement proposal

---

## 9. Suggested sequencing

The P0 list is not evenly urgent. Three of them are **model changes that block backend contracts**
and should land first, because every later screen depends on their shape:

1. **Wave 1 — model** P0-1 permissions, P0-2 multi-payer, P0-3 lifecycle, P0-4 settlement
   proposal, P0-14 versioning. Nothing else should start until these settle.
2. **Wave 2 — trust** P0-5 states, P0-15 undo, P0-8 receipts, P0-7 notes.
3. **Wave 3 — comprehension** P0-11 charts, P0-12 comparison, dashboard reprioritisation.
4. **Wave 4 — scale** P0-9 search, P0-10 sort, P1-17 filters, P1-18 large lists.
5. **Wave 5 — reach** P0-6 tags and payment methods, P0-13 localization (start early, it is long).

P0-13 (localization) is Large and touches every file — begin extracting strings in parallel with
Wave 1 rather than leaving it to the end.
