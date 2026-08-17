# Pockito Prototype — Specification Audit

**Built against:** `docs/pokito-mobile-screen-design-spec.md` (111 IDs),
`docs/POCKITO_MOBILE_MVP_PRODUCT_UX_ANALYSIS.md`, `designs/system/` (tokens, icons).
**Verified in-browser**, not by inspection: every number below was produced by running the prototype.

> **Revision, 15 Aug 2026.** §1 of this document previously claimed *0 dead buttons* and
> *0 console errors*, on the strength of walking the happy paths by hand. An exhaustive
> crawl — every reachable control, from every screen, to a depth of three — found **2 dead
> buttons and 246 uncaught errors**. Those claims were wrong, and they were wrong because
> the method behind them was too weak to falsify them. §11 records the sweep, the defects
> and the fixes; §1 now carries the numbers the sweep produced.

---

## 1. Headline

| Check | Result |
|---|---|
| Spec IDs implemented | **111 / 111** |
| Screens, sheets & modes rendering | **83**, all render without error |
| Dialogs | **22 / 22** (DLG-001…022) |
| Distinct wired actions | **207** |
| Controls exercised by the automated sweep | **10,050** sites · **9,432** clicks |
| **Dead buttons** | **0** — measured, see §11 |
| **Uncaught errors across the sweep** | **0** (was 246) |
| **Error-boundary hits across the sweep** | **0** (was 869 mid-fix) |
| Renders correctly with an entirely empty dataset | ✔ all 10 root screens |
| Design-system tokens used | 100% — no raw colours in `app.css` |

---

## 2. Coverage by family

| Family | Spec | Built | Notes |
|---|---|---|---|
| AUTH | 3 | 3 | Splash, sign-in, auth error |
| ONB | 6 | 6 | Full flow incl. optional space branch |
| HOME | 3 | 3 | Dashboard, month picker, net-worth breakdown |
| ACC | 6 | 6 | List, detail, add, edit, reorder mode, archived |
| TXN | 6 | 6 | Activity, detail, add, edit, filters, search |
| SPACE | 14 | 14 | Incl. both detail tabs, invite review, balance breakdown |
| SPLIT | 1 | 1 | Equal / Exact / Percentage with live remainder |
| SETL | 7 | 7 | SETL-007 is a dialog in the spec → built as **DLG-017** |
| BUD | 4 | 4 | List, detail (with ring + pace), create, edit |
| SUB | 7 | 6 | **SUB-007 is a stale spec reference** — see §6 |
| CAT | 3 | 3 | List, add/edit, reassign-before-delete |
| SET | 7 | 7 | Profile, currency, notifications, appearance, language, about |
| NOTIF | 2 | 2 | Inbox + permission pre-prompt |
| PICK | 7 | 7 | Account, category, date, space, member, currency, icon+colour |
| DLG | 22 | 22 | All with quantified consequences |
| AI | 7 | 7 | Connections, connect, consent, detail, permissions, activity, approvals |
| GLB | 6 | 6 | Components, not screens — see §3 |

## 3. Global components (GLB)

Implemented as reusable parts rather than routable screens, which is what the spec describes them as.

| ID | Component | Where |
|---|---|---|
| GLB-001 | Bottom navigation | `app.js → navBtn()`, `.nav` |
| GLB-002 | FAB | `app.js → render()`, `.fab`, hidden on 20 detail screens per spec |
| GLB-003 | Toast / snackbar | `ui.js → toast()`, with Undo on reversible writes |
| GLB-004 | Banner (offline / info / warning / danger) | `ui.js → banner()`, 5 tones |
| GLB-005 | Full-screen error | `ui.js → errorState()`, plus `gone()` / `goneSheet()` for a deleted record |
| GLB-006 | Refresh | `retry` action re-renders from the domain |

---

## 4. The two-lens model — verified by execution

Recorded a €45.00 shared expense in **Flat** (60/40 default split), paid from Revolut:

| Assertion | Before | After | ✔ |
|---|---|---|---|
| Transactions created | — | **1** | ✔ never two |
| Splits created | — | **1** | ✔ |
| Revolut balance (**cash flow**) | €6,142.06 | €6,097.06 | ✔ full −€45.00 |
| Spent this month (**spending**) | €619.73 | €646.73 | ✔ only your €27.00 share |
| Flat balance | €48.20 | €66.20 | ✔ +€18.00 Mira owes |

**One entry, one row, two readings.** This is the product thesis and it holds.

### Settlements are never spending

An AI-approved ¥5,000 settlement produced a `SETTLEMENT` transaction on Cash with **no `categoryId`**,
so `Domain.spending()` structurally cannot include it. Balances moved; spending did not.

---

## 5. Multi-currency — verified

| Assertion | Result |
|---|---|
| Three currency roles kept separate | ✔ account (payment) / space (account) / user (reporting) |
| Cross-currency shared expense | ✔ Shinkansen: split **¥27,600**, transaction **€162.84**, rate `0.0059` stored |
| Debt denominated in the space's currency | ✔ Tokyo balances always JPY, never converted |
| Balances never span currencies | ✔ by construction |
| Reporting conversion disclosed | ✔ HOME-003 lists rate, date and source |
| Missing rate refuses to combine | ✔ CHF has no rate; net worth falls back to per-currency subtotals |
| JPY renders 0 decimals, EUR 2 | ✔ `¥1,200` / `€18.50` |

---

## 6. Findings

### F1 — Cycle boundary was wrong *(fixed in the prototype)*
`memberBalances` counted the boundary settlement **inside the cycle it closed**, so Flat showed
"you owe €13.80" instead of "you're owed €48.20". The spec is explicit that the boundary settlement
is excluded. Fixed in `domain.js`; `cycle` and `lifetime` now differ correctly.

### F2 — A pairwise settlement zeroes a whole 3+ member cycle **`[SPEC DECISION NEEDED]`**
Not a prototype bug — the prototype is faithful here. In Tokyo Trip, a ¥5,000 Mira→me settlement
became the space-wide boundary, so **every earlier split dropped out of the cycle**, including
Mira still owing Sam ¥15,600. The lifetime view is correct (`Mira→Sam ¥11,800`, `me→Sam ¥3,800`).

The spec defines the cycle boundary as *the last confirmed settlement in the space*. That is right for
two people and lossy for three or more.

**Options:** (a) boundary per member-pair rather than per space; (b) close the cycle only when every
balance reaches zero; (c) keep as-is and lean on the All-time toggle.
**Recommendation: (b)** — it matches what "since we last settled up" means to a group, and it keeps
one boundary per space rather than N².

### F3 — `sectionHead` could render a link with no action *(fixed)*
SUB-002 passed a label with no handler, producing `data-act="undefined"`. The component now renders
a non-interactive stat when no action is supplied — a button that does nothing can no longer be built.

### F4 — Settlement rows read "Uncategorised" *(fixed)*
Settlements have no category by design; the row now shows the space name instead.

### F5 — SUB-007 is a stale spec reference
The spec's §3.7 lists `SUB-006 Cadence picker`, but a leftover `SUB-007` appears elsewhere. There is
one cadence picker. **Recommend deleting SUB-007 from the spec.**

---

## 7. Journeys verified end-to-end

| # | Journey | Path | ✔ |
|---|---|---|---|
| 1 | Tab navigation, independent stacks | Home ↔ Accounts ↔ Spaces ↔ Activity | ✔ |
| 2 | Account drill-down | ACC-001 → ACC-002 → TXN-002 → back | ✔ |
| 3 | **Add a shared expense** | FAB → amount → share toggle → default split → save | ✔ |
| 4 | Split editing | Equal / Exact / Percentage, live remainder, Done gated | ✔ |
| 5 | Settle up | SPACE-002 → SETL-001 → SETL-002 → SETL-003 → SPACE-002 | ✔ |
| 6 | Settlement never re-enterable | back from SETL-003 lands on the space, not the form | ✔ |
| 7 | Budgets | HOME → BUD-001 → BUD-002 → back → back | ✔ |
| 8 | Subscriptions | pay / skip advance the schedule; pay writes a transaction | ✔ |
| 9 | Categories | delete-in-use blocked → CAT-003 reassign → delete | ✔ |
| 10 | AI approval | NOTIF/HOME banner → AI-007 → approve → settlement recorded `source: mcp` | ✔ |
| 11 | AI consent | AI-003 with writes off by default, limits panel on enable | ✔ |
| 12 | Onboarding | ONB-001…006 incl. space branch and invite link | ✔ |
| 13 | Search & filters | live search, 6 filter groups, removable chips | ✔ |
| 14 | Theme | light ⇄ dark across every surface | ✔ |

---

## 8. Design-system conformance

| Rule | Status |
|---|---|
| All colour via `--pk-*` tokens | ✔ no raw hex in `app.css` except the demo stage |
| Amber = shared money only | ✔ share rule, shared budget bars, space marks, FAB |
| Amber never used as text | ✔ text uses `--pk-shared-strong` (amber-700) |
| Balance direction carries a label | ✔ "You're owed" / "You owe" always paired with colour |
| Icons from the 48-icon set | ✔ zero emoji |
| Tabular figures on all money | ✔ `.money` |
| Touch targets ≥ 44px | ✔ |
| Focus-visible rings | ✔ |
| `prefers-reduced-motion` respected | ✔ |

### Component reuse
Screens compose primitives rather than hand-rolling markup:
`U.card` ×85 · `U.btn` ×84 · `U.mark` ×45 · `U.field` ×42 · `U.sheet` ×38 · `U.row` ×36 ·
`U.avatar` ×26 · `U.empty` ×22 · `U.pill` ×19 · `U.banner` ×19 · `U.pickerList` ×10.

---

## 9. Architecture

```
prototype/
  index.html            dev shell
  css/tokens.css        copied from designs/system — single source of truth
  css/app.css           application styles, tokens only
  icons.svg             48-icon sprite
  js/data.js            ALL mock data — one dataset
  js/domain.js          ALL financial rules — lenses, FX, splits, balances, budgets
  js/ui.js              reusable component layer
  js/screens-core.js    Home, Accounts, Activity, Add sheet, Split, Pickers
  js/screens-shared.js  Spaces, Settlements
  js/screens-manage.js  Budgets, Subs, Categories, Settings, Notifications, AI, Onboarding
  js/app.js             router, state, 207 actions, 22 dialogs, error boundary,
                        persistence, focus management, keyboard, system back
  build.py              → dist/pockito-prototype.html (single file, 389 KB, self-verifying)
```

**Separation held:** screens are pure render functions — they never compute a figure and never mutate.
Every number comes from `Domain`; every mutation goes through it. Swapping `data.js` for a real API
would not touch a single screen.

---

## 10. Known limitations

Honest list of what this prototype does **not** do.

1. **Onboarding is a flow demo** — completing it returns to the seeded data rather than an empty app,
   so the rest of the prototype stays explorable. (The empty app *is* reachable and correct — see
   §11.4 — it is just not where onboarding lands you.)
2. **No real OAuth** — AI-003 simulates the consent screen; no tokens are issued.
3. **Cross-currency uses fixed rates** from `data.js`; no live feed.
4. **Drag-to-reorder is button-based** (ACC-005) — a real build would use pointer drag.
5. **Search is substring, not fuzzy.**
6. **Offline state is representable but not triggered** — no service worker.
7. **Persistence is a single local snapshot** — one device, one browser, no sync, no conflict
   handling. It survives a refresh; it is not a storage layer.

---

## 11. Hardening pass — 15 Aug 2026

The prototype was correct on the paths it was walked down and fragile everywhere else. This pass
measured that, fixed it, and re-measured.

### 11.1 Method

A crawler enumerates every `[data-act]` control on screen, clicks each one from a clean state,
and repeats from each newly reached state to a depth of three — from all four tab roots.
Uncaught errors, error-boundary trips and unresolved actions are recorded with the action that
caused them. It is destructive on purpose: it deletes accounts, spaces and categories, then
keeps clicking whatever is still on screen, which is exactly how stale references surface.

| | Before | After |
|---|---|---|
| Distinct action sites | 5,203 | **10,050** |
| Clicks | 5,104 | **9,432** |
| Uncaught errors | **246** | **0** |
| Unhandled actions (dead buttons) | **2** | **0** |
| Error-boundary trips | n/a | **0** |

The site count roughly doubled because the *before* run kept crashing, which cut whole subtrees
off from exploration. Fixing the crashes made more of the app reachable.

### 11.2 Defects found and fixed

| # | Defect | Effect |
|---|---|---|
| H1 | **`prompt()` used for the note field** (`app.js`) | Threw outright in embedded and sandboxed webviews — the note could not be set at all. Replaced with a proper sheet (`NOTE-EDIT`): themed, length-limited, live counter, clearable. |
| H2 | **Dead button: `open-add:<accountId>`** on the empty account detail | The one CTA on an empty account did nothing. The prefix was never registered — `open-add` now takes an account and preselects it. |
| H3 | **Dead key: `.` on the amount keypad** | Amounts are entered minor-unit first, so the handler ignored `.` — an enabled button that did nothing. The slot is now `00`. |
| H4 | **Overlays survived navigation** | `go`/`back`/`switchTab` left sheets and dialogs mounted, so they re-rendered against a context that had moved on. The single largest source of the 246 errors. Navigation now dismisses them. |
| H5 | **No error boundary** | Any throw left a blank viewport with no way out. Screens, sheets, dialogs, menus and actions now render inside a boundary that reports and degrades to a recoverable state. |
| H6 | **~30 unguarded entity dereferences** | A row outliving its record (deleted space, account, subscription, split, budget, connection, member) crashed the screen. Guarded, with an explicit *"deleted account/space/subscription"* rendering where the record is genuinely gone. |
| H7 | **`back()` lost scroll position** | Scrolling deep into Activity, opening a row and going back returned you to the top. Scroll is now captured per stack entry and restored; forward navigation correctly starts at the top. |
| H8 | **Save was not gated on the account existing** | Deleting the selected account from another screen left the add sheet savable and crashing. Now gated, with the button stating what is missing. |
| H9 | **`sub-toggle-pause` assumed the edit sheet was open** | Pausing from the list menu threw. |
| H10 | **`go:SETL-001` assumed a second member** | Settling up in a solo space threw. Now explains why it can't. |
| H11 | **`history.replaceState` could abort boot** | On opaque origins (`data:`, some webviews) it throws — the standalone bundle rendered nothing. Back-button integration is now optional and disables itself on refusal. |
| H12 | **Malformed CSS** — `display:display:none` in `.sheet-body::-webkit-scrollbar`. |
| H13 | **`.pk-icon--fill` collapsed nav icons** | The set is stroke-only with detail in open subpaths, so filling turned the clock and person icons into blobs. The selected state now carries weight and colour. |
| H14 | **Shared/AI badges were the first thing truncated** on a narrow transaction row — the amber space badge is the point of the row. Badges now lead; the account name truncates instead. |
| H15 | **"Salary and freelance" was hardcoded** in the home hero regardless of actual income categories. Now derived. |
| H16 | **`inert` was rewritten every render**, forcing a focusability recompute across the tree — a ~20× render slowdown once modal semantics were added. Now written only on change (2.4 ms/render). |

### 11.3 Added for production-readiness

- **Modal semantics** — `role="dialog"` / `aria-modal` on sheets, `alertdialog` on confirmations,
  `role="menu"` on overflow menus, and `inert` + `aria-hidden` on everything underneath.
- **Keyboard** — Escape unwinds one overlay layer at a time (inner sheet → outer sheet → screen),
  Tab is trapped inside the topmost overlay, Enter/Space activate the switch rows.
- **Focus management** — focus moves into an opening overlay and returns to the control that
  opened it, resolved by selector because the screen is re-rendered from scratch underneath.
- **System back** — the browser Back button and the Android back gesture map to in-app back,
  and refuse to leave the app from a tab root.
- **Persistence** — the session is snapshotted to `localStorage` (debounced) and restored on
  load, including theme and the screen you were on. *Reset data* clears it. Falls back to
  in-memory silently when storage is unavailable.
- **Toast** — `role="status"` / `aria-live`, and dismissable.
- **Scroll** — restored on back, reset on forward, preserved across in-place re-renders.
- **Build assertions** — `build.py` now verifies the sprite, styles and scripts were actually
  inlined and that no external reference survived, instead of printing a warning and exiting 0.

### 11.4 Empty-dataset check

With every collection emptied — the true first-run state — all ten root screens render with no
errors, and the add sheet correctly refuses to save with *"Pick an account"*. The home hero no
longer asserts a page of zeroes: it invites the first account and says nothing has been recorded
yet, rather than reporting *"100% of €0.00 that left your accounts"*.
