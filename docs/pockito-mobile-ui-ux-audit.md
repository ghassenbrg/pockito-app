# Pockito mobile UI/UX production-readiness audit

**Date:** 16 August 2026  
**Product audited:** `pockito-mobile` Flutter prototype, the checked-in interactive web prototype, and shared Pockito design-system assets  
**Benchmark:** the three supplied PayPay screenshots, used only to study mature finance-product principles  
**Companion audit:** [`docs/prototype-completion-audit.md`](prototype-completion-audit.md)  
**Status:** implementation specification; this document does not implement changes

---

## Executive decision

Pockito does not need a global scale-down. It needs a **calm-dense hierarchy**:

- keep meaningful balances prominent, but reduce routine hero amounts from 40 to 32 logical pixels;
- preserve 48×48 cross-platform touch targets while making the visible icon, chip, and button treatment smaller;
- replace repeated standalone cards with grouped financial lists and separators;
- reduce routine screen titles, section gaps, card radius, shadows, and repeated full-width actions;
- show Kito when Kito adds reassurance, explanation, progress, or delight—not as a permanent tax on every viewport;
- let transaction, account, settings, notification, and management screens carry more useful information per viewport;
- preserve Pockito’s blue/aqua/gold language, Kito, AI safety positioning, and shared-finance identity.

The current prototype’s body copy and transaction typography are mostly in the right range. Its prototype-like feeling comes mainly from **too many high-emphasis containers at once**: 28 px screen titles, 40 px amounts, 24 px card radii, generous shadows, 20–24 px repeated gaps, standalone cards per list item, large illustrations, and full-width buttons at the end of screens that already expose the same action elsewhere.

The target is not PayPay’s visual identity or layout. The target is Pockito’s own mature finance UI: friendly, trustworthy, information-rich, readable, and unmistakably Pockito.

---

# 1. Evidence

## 1.1 Sources inspected

The audit is based on:

1. All three supplied PayPay screenshots:
   - a feature-dense home surface;
   - a transaction-history surface;
   - a filtering/date-selection surface.
2. The complete existing completion audit at `docs/prototype-completion-audit.md`.
3. The Flutter routing map in `pockito-mobile/lib/ui/core/navigation/app_router.dart`.
4. All feature screen files under `pockito-mobile/lib/ui/features/`.
5. The design-system implementation under `pockito-mobile/lib/ui/core/design_system/` and `pockito-mobile/lib/ui/core/components/`.
6. The checked-in interactive prototype at `prototype/dist/pockito-prototype.html`, including Home, Accounts, Spaces, Activity, Add Expense, onboarding entry points, and AI consent entry points.
7. Pockito’s existing product/design specifications and validation documents.
8. Official platform and accessibility guidance:
   - [Apple HIG: Typography](https://developer.apple.com/design/human-interface-guidelines/typography)
   - [Apple HIG: Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility)
   - [Apple HIG: Layout](https://developer.apple.com/design/human-interface-guidelines/layout)
   - [Android accessibility: touch targets](https://developer.android.com/guide/topics/ui/accessibility/views/apps-views)
   - [Flutter `kMinInteractiveDimension`](https://api.flutter.dev/flutter/material/kMinInteractiveDimension-constant.html)
   - [WCAG 2.2](https://www.w3.org/TR/WCAG22/)
   - [WCAG 2.2 target-size explanation](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)

## 1.2 Audit limitation caused by concurrent work

At audit time, another agent was actively implementing the companion completion audit. The Flutter web target did not compile because model and UI migrations were temporarily out of sync: multi-payer expenses, permission components, settlement guards, itemized splits, and transaction deletion were partially migrated. This audit deliberately did **not** repair or modify that work.

Consequences:

- visual evidence comes from the checked-in interactive prototype and supplied screenshots;
- current Flutter architecture, sizing, route coverage, and component usage come from static inspection;
- the implementation agent must begin with a clean analyzer/test baseline after the companion work lands;
- exact screenshot baselines must be regenerated from the completed Flutter branch before visual changes begin.

This limitation does not invalidate the sizing or architecture findings: the relevant tokens and component contracts were inspectable, and the interactive prototype demonstrated the same visual language and information architecture.

## 1.3 Current product surface inventory

The current Flutter router exposes the following significant surfaces:

- Primary destinations: Home, Accounts, Spaces, More, plus the central add launcher.
- Money: Activity, transaction detail, add/edit/duplicate money event, receipt scanning, filters, split editor, net-worth breakdown.
- Accounts: list, detail, add/edit, archived list, reorder.
- Spaces: list, create, overview/detail, expense detail, members, settings, settle up, settlement success/history/detail, cycles/detail, archived list.
- Management: budgets/list/detail/editor, subscriptions/list/detail/editor, categories.
- AI: connections, connect, authorization, connection detail, activity, approvals.
- System: notifications, profile, currency, exchange rates, notification preferences, appearance, language, about, prototype state catalogue.
- Entry: splash, sign-in, auth error, onboarding, invite review.
- Shared states: loading skeletons, empty, error, offline, denied/read-only/conflict/submit treatments in active migration.

This is sufficient breadth for a production-readiness UI audit. The problem is not a lack of screens; it is the consistency and density with which the screens present their content.

## 1.4 Measured current design-system evidence

| Area | Current implementation | Audit reading |
|---|---:|---|
| Screen gutter | 16 | Good default |
| Section gap | 24 | Too frequent when every section uses it |
| Default card padding | 16 | Good; needs a 12 px dense variant |
| Hero padding | 20 | Acceptable when hero height is constrained |
| Default card radius | 24 | Too round for routine finance rows |
| Modal radius | 28 | Slightly large but acceptable for branded sheets |
| Card shadow | blur 20, y 8 | Too present for repeated list cards |
| Hero shadow | blur 30, y 14 | Too heavy for routine summary panels |
| Display amount | 40/44, weight 800 | One level too large for routine balances |
| Screen title | 28/34, weight 700 | One level too large for most root screens |
| Section title | 20/26, weight 700 | Slightly too large when repeated |
| Row title | 15–17 | Correct range; choose by row type |
| Supporting text | 13/18 | Correct |
| Default row token | 64 | Good |
| Default visible icon tile | 44 with 21 icon | Slightly large for dense ledgers; good for feature cards |
| Avatar | 40 | Good member default; too large for compact history rows |
| Filled button | 52 high | Too tall as a universal default; good for primary final actions |
| Outlined button | 48 high | Correct |
| Navigation | 58 container, 48 targets, 56 add | Good; add is visually dominant but acceptable |
| Kito inline message | 72–96 image | Too large for routine guidance |
| Page max width | 760 | Too wide for single-column forms; useful for two-column/adaptive layouts |
| Wide shell breakpoint | 900 | Reasonable |

## 1.5 Current viewport evidence

The checked-in interactive prototype shows:

- Home gives the greeting, approval banner, large net-worth card, and only the beginning of Accounts in the first phone viewport. Two high-emphasis blocks precede the first scannable list.
- Accounts is comparatively mature: one summary panel followed by compact rows. It demonstrates that Pockito can be dense without becoming cold.
- Activity is the strongest density reference in Pockito itself. Its rows align merchant/category on the left and amount on the right, group by date, and can display several events without clutter.
- Spaces uses large standalone cards for each space. The balance is clear, but the combination of card radius, internal whitespace, avatars, and repeated borders limits scan speed.
- Add Expense is effective when it uses a large amount, concise metadata rows, an integrated keypad, and a pinned action. The Flutter form has since grown substantially; it must preserve this progressive-disclosure quality.

## 1.6 PayPay benchmark observations

### B-01 — Dense home modules with clear local hierarchy

**Observation**  
PayPay fits navigation, a promotion, quick actions, a tabbed discovery module, balance rows, service shortcuts, and the beginning of additional content in one viewport.

**Why it works**  
It does not give every element equal size. Module titles, primary actions, values, metadata, and shortcuts occupy visibly different tiers. Small visible icons still have generous touch areas.

**Pockito comparison**  
Pockito gives several consecutive areas hero-like treatment: welcome artwork, AI approval, portfolio hero, card groups, and Kito messages. The hierarchy is warm but less selective.

**Pockito opportunity**  
Use fewer simultaneous heroes. Keep one dominant financial summary, convert urgent items to compact action-required rows, and make routine sections visually quieter. Do not copy PayPay’s module arrangement, brand colors, service grid, or promotional model.

### B-02 — Transaction history prioritizes merchant, amount, and state

**Observation**  
PayPay history aligns the merchant/event title left and amount right, places date and payment method beneath, and uses a compact status pill only when needed. Month grouping and filter controls remain obvious.

**Why it works**  
Users scan a financial ledger on two axes: “what happened?” and “how much?” Supporting details never interrupt that axis. Tabular right alignment makes amounts comparable.

**Pockito comparison**  
`PkTransactionTile` already follows the same general principle independently and correctly. However, daily rounded cards, large icon tiles, and inconsistent rich metadata can make Pockito rows feel more decorative than ledger-like.

**Pockito opportunity**  
Retain Pockito icons and colors, but standardize amount alignment, metadata order, row variants, group headers, and status placement. A simple event should be 64 px; a shared/status-rich event should be 72–80 px. The row’s interactive target may be the whole row.

### B-03 — Visual size and touch size are decoupled

**Observation**  
Many visible icons and chips are compact, while their surrounding controls remain comfortably tappable.

**Why it works**  
Production density comes from reducing visible chrome, not from shrinking hit areas.

**Pockito comparison**  
Pockito’s `PkIconAction` is visibly 42×42 even though platform guidance supports a smaller visible icon inside a 44/48 target. Chips and buttons often expose their full target as a large filled shape.

**Pockito opportunity**  
Adopt 48×48 as the cross-platform target floor, with 20–24 px glyphs, 32–40 px visible chips/buttons where appropriate, and transparent padding around compact controls.

### B-04 — Filters are visible, stateful, and reversible

**Observation**  
PayPay exposes the active history scope near the top and provides a dedicated filter surface with reset, period shortcuts, custom dates, and a clear apply action.

**Why it works**  
The user can see the current scope, change it, and recover to a default without remembering hidden state.

**Pockito comparison**  
Activity has search, a filter badge, type chips, and an extensive sheet. The current sheet is 88% of screen height and hand-built, while active filters are only partially visible.

**Pockito opportunity**  
Use `PkSheetScaffold`, `PkActiveFilters`, and a consistent apply/reset contract. Prefer content-height sheets for small filters and full-height sheets only for multi-section filters. Show removable active filters beneath search.

### B-05 — Rows expand only when information earns the space

**Observation**  
PayPay rows with method and status metadata are taller; simpler structures elsewhere remain compact.

**Why it works**  
Density is content-dependent, not a single universal row height.

**Pockito comparison**  
Pockito often uses the same padded card treatment for a setting, account, space, AI connection, and budget even though their information needs differ.

**Pockito opportunity**  
Create named row variants and prohibit ad hoc vertical padding. Use 56, 64, 72, and 80 px contracts based on content, never “whatever the children happen to require” at the default text scale.

### B-06 — Compact header and bottom-navigation proportions

**Observation**  
PayPay keeps app-level navigation predictable and reserves the central emphasis for its core action.

**Why it works**  
The frame stays stable while content changes, making the product feel controlled.

**Pockito comparison**  
Pockito’s new four-destination floating navigation and central add launcher are structurally sound. The older prototype’s Activity-as-tab and the current More-as-tab represent an IA transition that must remain consistent across deep links and headers.

**Pockito opportunity**  
Keep Home / Accounts / Spaces / More plus Add. Activity remains a first-class destination inside More and a direct Home/search target, not a fifth tab. Stabilize labels, selected states, safe-area behavior, and back behavior.

### B-07 — Restrained whitespace, not absent whitespace

**Observation**  
The benchmark uses whitespace to separate groups, but not between every row.

**Why it works**  
Group-level whitespace communicates information architecture; row-level separators communicate continuity.

**Pockito comparison**  
Pockito frequently uses 8 px gaps between individually rounded cards plus 20–24 px before actions and 24 px section cadence.

**Pockito opportunity**  
Use whitespace between groups and dividers within groups. This change alone will make Accounts, Spaces, Budgets, Subscriptions, AI Connections, and settings feel substantially more mature.

## 1.7 Platform evidence and implications

- Apple recommends 44×44 pt targets on iOS/iPadOS; Android and Flutter Material use 48×48 dp/logical pixels. Pockito should use **48×48 logical pixels** as its cross-platform implementation floor.
- Apple’s default body size is 17 pt and minimum custom type guidance reaches 11 pt, but the guidance emphasizes Dynamic Type and legibility rather than a single fixed scale. Pockito’s 15–16 px body text is acceptable; its issue is hierarchy inflation above body text.
- WCAG 2.2 requires at least 24×24 CSS px targets or sufficient spacing for Level AA web surfaces; Pockito’s native target should exceed that floor.
- Normal text must meet 4.5:1 contrast; large text and non-text controls require 3:1. Focus visibility must remain evident for keyboard/web use.
- Layouts must respond to device size, orientation, locale, and text scaling. A max-width container alone is not responsive design; wide Pockito surfaces need deliberate two-pane or rail behavior.

---

# 2. Findings

## 2.1 Severity model

- **P0:** blocks the UI from being called production-ready or creates broad accessibility/consistency risk.
- **P1:** materially improves maturity, scan speed, or comprehension and should ship in the same UI program.
- **P2:** polish or differentiation after the system is stable.

## 2.2 P0 findings

### UI-P0-01 — The hierarchy has too many simultaneous heroes

Root screens routinely combine a large title, subtitle, large hero, mascot/banner, and prominent call-to-action before the first list. A production finance UI must make one thing dominant per viewport.

### UI-P0-02 — Typography is inflated above the body scale

Body and supporting text are sound. `displayLarge` 40/44, `headlineLarge` 28/34, `headlineMedium` 22/28, and `titleLarge` 20/26 collectively shift routine content up one tier. This makes forms, section headers, amounts, and empty states compete.

### UI-P0-03 — Standalone cards are overused

Twenty-four-pixel radii, borders, shadows, and 8 px gaps around routine rows create visual fragmentation and reduce rows per viewport. Cards should identify conceptual groups, not every tap target.

### UI-P0-04 — Visible control size is conflated with hit-target size

Buttons, icon actions, chips, and list icons often expose the whole accessible target as visible chrome. This creates a large-looking interface even where the target size is correct.

### UI-P0-05 — Component variants are not explicit enough

Rows, hero panels, buttons, sheets, status pills, and mascot treatments lack a small named set of density variants. Individual screens therefore choose padding and composition ad hoc.

### UI-P0-06 — Responsive rules are partial

The app has `LayoutBuilder`, max-width constraints, a 900 px navigation-rail breakpoint, and some compact row fallbacks. It does not yet define a complete 320 px, phone, tablet, landscape, and large-text contract for every component.

### UI-P0-07 — Accessibility is not yet a release gate

The system includes some semantics, reduced-motion handling, tooltips, and minimum controls, but there is no documented matrix for TalkBack/VoiceOver, text scaling, contrast, focus order, switch access, or target inspection across all significant screens.

### UI-P0-08 — Activity is close, but not yet a canonical ledger

It has strong alignment and grouping. The remaining problems are oversized day-card containers, non-sticky headers, incomplete active-filter visibility, and insufficient row contracts for status/shared/transfer/voided variants.

### UI-P0-09 — Complex forms and quick entry share one presentation model

A personal quick expense and a multi-payer, multi-currency, receipt-backed shared expense do not have the same complexity. Treating both as one tall sheet either overwhelms the quick path or constrains the advanced path.

### UI-P0-10 — Current work must be stabilized before visual migration

The companion audit is changing models and components. Visual refactoring on a failing analyzer baseline would hide regressions and create merge churn.

## 2.3 P1 findings

### UI-P1-01 — Home prioritization is not selective enough

The greeting/welcome art, AI approval, portfolio hero, Kito insight, shared summary, budgets, subscriptions, categories, and recent activity all seek attention. Home needs a strict information-priority ladder.

### UI-P1-02 — Repeated actions consume unnecessary space

Several screens provide an app-bar add action, a bottom/full-width add button, and sometimes a central launcher for the same task. One primary entry plus a contextual alternative is enough.

### UI-P1-03 — Kito is too large in routine information contexts

Inline Kito messages use 72–96 px artwork. This is appropriate for onboarding, celebration, and exceptional trust moments, but too large for repeated helper copy or AI connection lists.

### UI-P1-04 — Screen headers are too large and inconsistent with app bars

`PkScreenHeader` uses 28 px while `PkAppBar` uses 20 px. Root and pushed screens therefore feel like different products.

### UI-P1-05 — Financial values need a semantic scale

Net worth, account balance, transaction amount, budget amount, split amount, and form input cannot all inherit a generic display/title style. Their emphasis and truncation rules differ.

### UI-P1-06 — Status communication needs one grammar

Pending, overdue, paid, archived, offline, denied, shared, AI-generated, verified, and budget health use a mix of pills, colors, banners, subtitles, and cards. Define severity, placement, labels, and icon rules.

### UI-P1-07 — Bottom sheets are over-tall by default

Receipt and filter sheets use fixed 86–88% heights. Smaller selection tasks should hug content; complex editors should become full-screen routes.

### UI-P1-08 — Wide layouts waste or overextend content

A 760 px single column is too wide for body copy and form fields. Tablets should use 560 px form columns or master-detail/two-column content rather than merely centering a broad phone layout.

### UI-P1-09 — Empty and error states can overconsume the viewport

Mascot, icon, headline, body, and button stacks are useful, but need compact variants when they appear inside a section rather than as the entire screen.

### UI-P1-10 — Visual trust needs less decorative depth

Large shadows, gradients, and rounding are friendly but can feel promotional. Finance trust benefits from crisp alignment, restrained elevation, stable surfaces, and predictable state transitions.

## 2.4 P2 findings

- Motion should communicate relationship and result, not animate every list item.
- Haptics should reinforce selection, success, and warnings, never compensate for weak visual state.
- Privacy mode should preserve layout when balances are hidden.
- Tabular figures should be mandatory for every monetary, percentage, date, and count column where comparison matters.
- Landscape phone should favor split panes or condensed heroes, not scaled-down portrait cards.
- Japanese strings need width and line-break tests; no component should be sized only around English.
- Kito can become more useful through subtle context-aware expressions, but only after density and state rules are stable.

---

# 3. Decisions

These are binding design decisions for the implementation program.

## D-01 — Adopt “calm-dense” as the product-density principle

Pockito will show more useful finance data per viewport while retaining 48 px touch targets, legible type, friendly language, and breathing room between conceptual groups.

## D-02 — Preserve one dominant element per viewport

A screen may have one hero, one full-screen state, or one large Kito illustration—not several. Compact action-required rows and secondary summaries do not count as heroes.

## D-03 — Group related rows; do not card every row

Use one surface with internal separators for accounts, transactions, settings, members, notifications, categories, subscriptions, AI connections, and simple spaces. Standalone cards remain for heterogeneous dashboards, warnings, approvals, insights, and objects that need strong individuality.

## D-04 — Use 48 px targets with smaller visible controls

Cross-platform interactive regions are at least 48×48. Visible icon containers may be 32–40, icons 20–24, and chips 32–36 high, provided transparent padding or parent-row interaction supplies the target.

## D-05 — Reduce routine type by one tier, not all type

Body and metadata stay close to current values. Routine screen titles, section titles, form amounts, and financial heroes move to the specification in section 5.

## D-06 — Separate quick add from advanced editing

Quick Add is a compact sheet optimized for amount, account, category, date, and note/receipt shortcuts. Advanced personal/shared/OCR/split editing is a full-screen, scroll-safe flow with a pinned final action.

## D-07 — Keep current primary navigation

Home, Accounts, Spaces, More, and central Add are the production mobile frame. Activity is reachable from Home search/recent activity and from More. Wide layouts use a navigation rail.

## D-08 — Use Kito according to an explicit budget

Kito’s size and frequency are limited by context. Routine list/detail screens do not reserve 96 px for the mascot. Kito is prioritized for onboarding, empty/error recovery, AI trust, scan review, shared-finance reassurance, and celebrations.

## D-09 — Make accessibility and responsiveness acceptance criteria, not cleanup

Every component and screen task includes target size, semantics, text scaling, contrast, narrow width, dark mode, and Japanese checks.

## D-10 — Do not duplicate the completion audit

The companion audit remains authoritative for new models/features: permissions, multi-payer, lifecycles, settlement proposals, tags, payment methods, notes, stored receipts, search/sort breadth, charts, period comparisons, localization, conflict handling, undo, import/export, and production states. This document specifies how those features must look and behave when present.

---

# 4. Recommendations

## 4.1 Information hierarchy

Use this priority order on finance screens:

1. Current context and trust state: account/space/month, offline/read-only/permission state.
2. Primary financial answer: balance, total, due, or amount.
3. Action required: approval, settlement, overdue item, conflict, budget breach.
4. Primary action: add, settle, confirm, retry, or save.
5. Scannable evidence: transactions, members, budgets, breakdowns.
6. Secondary education and Kito guidance.

If a lower-priority element appears above a higher-priority one, the screen must document why.

## 4.2 Density rules

- Aim for 5–7 simple ledger rows or 4–5 rich rows in a 390×844 viewport after header/filter chrome.
- Use 8–12 px between standalone cards; use 0 px plus dividers inside grouped lists.
- Use 20 px between major sections, 12 px between a section header and content, and 8 px between tightly related controls.
- Avoid more than two consecutive full-width 48+ px controls.
- Avoid full-width “Add” buttons at the bottom when the app bar or central launcher already provides the same action and discovery is adequate.

## 4.3 Financial scanning rules

- Left column answers “what”; right column answers “how much/status.”
- Amounts are right-aligned and use tabular figures.
- Metadata order is consistent: category/type → account/payment method → shared-space context → date/status.
- Show no more than two metadata lines in a list row.
- Currency is never inferred solely from color or locale.
- Positive/negative meaning uses sign and words/semantics, not color alone.
- Large values may reduce to the next monetary size but must never clip, marquee, or silently lose the currency.

## 4.4 Card and surface rules

Use a standalone card only when at least one applies:

- the content is heterogeneous dashboard information;
- the object needs an independent state or action boundary;
- it is dismissible, actionable, or elevated over surrounding content;
- it is a warning, insight, approval, or trust notice;
- it participates in horizontal scrolling.

Otherwise use a grouped surface, section, or plain list.

## 4.5 Kito rules

- Kito must never be the only carrier of state meaning.
- Routine inline helper: 48–64 px.
- Insight card: 56–64 px.
- Full-screen empty/error: 88–112 px.
- Celebration/success: 112–144 px.
- Onboarding hero: 140–180 px, never more than 35% of usable height.
- Scanner overlay: small contextual pose outside the receipt capture region.
- Do not show more than one Kito instance in a viewport.
- Hide or compact Kito before shrinking financial data on short screens.

## 4.6 Form strategy

- Quick actions open a compact sheet only when the task can be completed in one viewport with the keyboard open.
- Full-screen routes are used for multi-currency transfers, shared expenses, multi-payer, split configuration, receipt review, conflict resolution, and any form with more than six meaningful controls.
- The primary submit action remains reachable with the keyboard open and exposes loading/disabled/success states.
- Optional advanced sections use disclosure rows with summaries; collapsed sections still expose validation errors.

## 4.7 Responsive strategy

- 320–359 px: 12 px emergency gutter where necessary, compact icon tiles, stacked trailing values only when required.
- 360–599 px: standard 16 px gutter, one column.
- 600–839 px: content centered at 560 px for forms; dashboard may use two equal columns after the primary hero.
- 840–899 px: two-pane list/detail where useful, but retain bottom navigation until the shell breakpoint.
- 900+ px: navigation rail; list/detail or two-column dashboard; form column max 560 px.
- Short height (<700 px): compact hero and mascot variants; pinned actions must not cover fields.

## 4.8 Motion strategy

- 150 ms for selection/focus feedback.
- 200–250 ms for sheets, disclosure, and route relationship.
- 300–350 ms only for celebration or a data visualization entering.
- Respect `disableAnimations` and avoid staggered ledger animation after every filter/search update.
- Amount updates may cross-fade; do not count rapidly unless the change itself is the message.

---

# 5. Design-system specification

## 5.1 Typography tokens

Replace generic use of Material names with Pockito semantic aliases, even if the implementation maps them onto `TextTheme`.

| Semantic token | Size / line | Weight | Use |
|---|---:|---:|---|
| `pkMoneyHero` | 32 / 38 | 750–800 | Net worth, account/space primary balance |
| `pkMoneyInput` | 32 / 38 | 700 | Add/edit amount entry |
| `pkMoneySection` | 24 / 30 | 700 | Secondary summary totals |
| `pkMoneyRow` | 15 / 20 | 600–700 | Transaction/account trailing amount |
| `pkScreenTitle` | 24 / 30 | 700 | Root screen title |
| `pkAppBarTitle` | 18 / 24 | 600–700 | Pushed screen title |
| `pkSectionTitle` | 18 / 24 | 700 | Section heading |
| `pkRowTitle` | 15 / 20 | 600 | Merchant, account, member, setting |
| `pkBody` | 15 / 22 | 400 | Primary explanatory copy |
| `pkBodyStrong` | 15 / 22 | 600 | Emphasized body/action copy |
| `pkSupporting` | 13 / 18 | 400 | Account/category/date/context |
| `pkLabel` | 12 / 16 | 600 | Chips, field labels, group labels |
| `pkMicro` | 11 / 14 | 600 | Badges only; never essential prose |

Rules:

- Keep one system font family.
- Use tabular figures on every amount, percentage, date column, and comparable count.
- `pkMicro` is not permitted for destructive consequences, errors, balances, or required form guidance.
- At text scale ≥1.3, rows may grow; at ≥2.0, trailing amount may move beneath title rather than truncate.
- Screen titles wrap to two lines only when localization requires it; app-bar titles prefer ellipsis with the full title in semantics.

## 5.2 Spacing tokens

Keep the 4 px grid and define semantic aliases:

| Token | Value | Use |
|---|---:|---|
| `spaceHairline` | 2 | Optical alignment only |
| `space1` | 4 | Icon/text micro-gap |
| `space2` | 8 | Tight related controls |
| `space3` | 12 | Row internal gap; header-to-content |
| `space4` | 16 | Phone gutter; default card padding |
| `space5` | 20 | Major section gap |
| `space6` | 24 | Hero-to-content or modal grouping, used sparingly |
| `space8` | 32 | Full-screen state grouping |

`PkSpacing.section` changes from 24 to 20. Do not mechanically replace every 24; review whether each use is a major section, hero separation, or accidental whitespace.

## 5.3 Radius tokens

| Token | Value | Use |
|---|---:|---|
| `radiusSmall` | 8 | badges, tiny containers |
| `radiusControl` | 12 | buttons, fields, icon tiles |
| `radiusCard` | 16 | standard cards/grouped surfaces |
| `radiusHero` | 20 | brand/financial hero |
| `radiusSheet` | 24 | modal sheet top corners |
| `radiusFull` | 999 | chips, avatars, pills |

Routine cards must not use 24. Large 20+ radii are reserved for heroes and sheets.

## 5.4 Elevation and border tokens

- `surfaceFlat`: no shadow, 1 px subtle border only when needed against the page.
- `surfaceGrouped`: no shadow, subtle border, clipped dividers.
- `surfaceRaised`: one shadow at 8–12 blur, y 3–4, low alpha.
- `surfaceHero`: one restrained shadow at 16–20 blur, y 6–8.
- `surfaceModal`: platform/modal elevation.

Do not combine a strong border and strong shadow. Dark mode should rely primarily on tonal surfaces and borders, not black shadows.

## 5.5 Size tokens

| Element | Visible size | Target/layout size |
|---|---:|---:|
| Standard icon | 20 | 48 target |
| Emphasis/nav icon | 24 | 48 target |
| Dense icon tile | 36–40, icon 20 | row target 56–64 |
| Feature icon tile | 44, icon 22 | card target ≥64 |
| Compact avatar | 32 | row target ≥56 |
| Member avatar | 40 | row target ≥64 |
| Profile avatar | 64 | edit affordance 48 |
| Primary button | visible 48 high | 48 target |
| Emphasized final button | visible 52 high | 52 target |
| Compact secondary button | visible 36–40 | 48 target |
| Chip | visible 32–36 | 48 target or sufficient parent spacing |
| Text input | 48 min | 48 target |
| Simple settings row | 56 min | full row target |
| Standard finance row | 64 | full row target |
| Rich finance row | 72–80 | full row target |
| Sticky tabs | 44 visible | 48 target |
| Bottom navigation | 58 + safe area | each destination ≥48 |
| Central add | 52–56 | ≥56 |

Change `PkSize.touch` from 44 to 48 so custom controls meet the stricter cross-platform floor.

## 5.6 Color and contrast

- Keep Pockito blue/aqua/gold, but use gold primarily for shared-finance context and attention—not generic selection everywhere.
- Define semantic surfaces for success, warning, danger, shared, AI, offline, read-only, and neutral information.
- Every status uses text/icon plus color.
- Normal text contrast ≥4.5:1; large text ≥3:1; controls, focus, dividers that carry meaning, and chart marks ≥3:1.
- `textTertiary` must be verified on both page and sunken surfaces; do not assume palette intent proves contrast.
- Amount red/green treatments include sign and spoken semantics.

## 5.7 Number formatting

- Use locale-aware grouping and decimal digits.
- Keep sign attached to the number.
- Keep currency attached visually and semantically; it may be smaller but not separated to a distant column.
- Do not abbreviate primary balances. Compact dashboard comparison cards may abbreviate only with an accessible full-value label.
- JPY and other zero-decimal currencies must not show fake decimals.
- Align equivalent/converted values under the primary amount, never on the same visual tier.

## 5.8 Responsive and text-scale tokens

Add named breakpoints:

- `compactNarrow = 360`
- `compact = 600`
- `medium = 840`
- `navigationRail = 900`
- `expanded = 1180`

Add semantic constraints:

- `formMaxWidth = 560`
- `readingMaxWidth = 640`
- `dashboardMaxWidth = 1120` on expanded layouts
- `listPaneWidth = 360–420` in master-detail

Do not clamp app-wide text scaling. Navigation may switch layout at large scales; brand art may remain unscaled; meaningful text must scale.

## 5.9 Accessibility semantics

- A financial row is one coherent semantic button with title, amount, date/status, and context in that order.
- Decorative Kito images are excluded; meaningful Kito expressions still need accompanying text.
- Icon-only controls require tooltip/semantic label and state where applicable.
- Charts expose a summary and a navigable textual data table or equivalent list.
- Progress bars expose label, current value, maximum, and status.
- Hidden balances announce “Balance hidden,” not the masked characters.
- Focus order follows visual order, including sheets and pinned actions.
- Swipe/long-press actions always have a non-gesture alternative.

---

# 6. Component changes

## 6.1 `PkPage`

- Keep safe-area handling and scroll clearance.
- Replace a single 760 px content maximum with `readingMaxWidth`, `formMaxWidth`, and adaptive dashboard/list-detail layouts.
- Add a short-height density signal available to hero and mascot components.
- Keep pull-to-refresh only where refresh has a real production meaning.

## 6.2 `PkScreenHeader` and `PkAppBar`

- Root header: 24 px title, optional 13 px subtitle, 12 px bottom gap.
- Pushed app bar: 18 px title, 56 px height.
- Maximum two visible trailing actions; move additional actions to overflow.
- Root subtitle is omitted when it merely restates a count already visible below.
- Back target is 48×48; preserve predictable deep-link fallback behavior.

## 6.3 `PkCard`

Add variants:

- `standard`: radius 16, padding 16, flat/low elevation.
- `dense`: radius 16, padding 12.
- `group`: radius 16, zero outer row padding, internal separators, no shadow.
- `raised`: only for actionable dashboard/approval content.

Deprecate direct per-screen border/shadow construction except for documented hero/brand art.

## 6.4 `PkHeroPanel`

- Radius 20, padding 16–20.
- No fixed minimum height; target 128–168 on phones.
- `compact`, `standard`, and `expanded` layouts.
- Only one `pkMoneyHero` value.
- Supporting metrics use `pkMoneySection` or `pkMoneyRow`, not another display size.
- Shadow reduced to `surfaceHero`.

## 6.5 Financial rows

Create a shared row foundation with named variants:

- `PkLedgerRow.simple` — 64 px.
- `PkLedgerRow.rich` — 72 px.
- `PkLedgerRow.status` — up to 80 px.
- `PkManagementRow` — 56–64 px.

`PkTransactionTile`, `PkAccountTile`, `PkSpaceTile`, `PkBudgetTile`, subscription rows, settlement rows, notification rows, and AI connection rows should compose this foundation rather than duplicate alignment and padding logic.

## 6.6 `PkTransactionTile`

- Preserve left title/right amount scan axis.
- Dense tile icon 36–40 with 20 px glyph.
- One metadata line by default; second line only for shared share/status.
- Date appears in group header or row, not both.
- Add explicit variants for transfer, settlement, shared, pending, voided, and OCR-review.
- Shared/AI labels become compact inline badges that do not displace the merchant.

## 6.7 `PkAccountTile` and `PkSpaceTile`

- Default list rendering is grouped, not one card per object.
- 64–72 px rows.
- Account metadata: type · currency · optional default.
- Space metadata: type · currency · members; amount/status right.
- Avatars do not appear in the list unless they disambiguate spaces; a compact stacked treatment is capped at three.

## 6.8 `PkSectionHeader`

- Use 18/24 title.
- Bottom gap 8–12.
- Action target 48 but visually compact.
- Count and “See all” cannot both appear unless each answers a distinct question.

## 6.9 Buttons

- Default filled/outlined height 48; 52 only for the final action in onboarding, authorization, destructive confirmation, or long forms.
- Small visible action 36–40 inside a 48 target.
- Full-width primary button is limited to one per viewport.
- Destructive action uses danger color only at the commitment point.
- Loading keeps button dimensions stable and prevents duplicate submission.

## 6.10 Chips, tabs, filters, and search

- Chip visible height 32–36, 12 px label, 8–12 px horizontal padding.
- Use 48 target through parent padding/constraints.
- `PkTabs` visible height 44, target 48, scrollable when localization cannot fit.
- `PkSearchField` height 48; clear action target 48.
- `PkActiveFilters` supports individual removal, clear all, wrapping, and horizontal compact mode.
- `PkSortButton` displays the active sort in semantics and optionally in a small label.

## 6.11 Inputs and pickers

- `PkAmountField` uses `pkMoneyInput`, live locale formatting, currency affordance, sign/type semantics, and no giant 40 px text.
- `PkDateField`, account/category/currency/member/tag/payment-method pickers share label, error, and sheet behavior.
- Selectors show icon/color plus current value; do not use plain dropdown strings for rich entities.
- Picker sheets have search for more than eight choices.

## 6.12 Sheets and dialogs

`PkSheetScaffold` becomes mandatory for custom sheets:

- compact content sheet: content height, max 60% screen;
- standard sheet: max 80%;
- complex editor: full-screen route, not an 88% pseudo-screen;
- drag handle is omitted when a full header with Close already communicates modality;
- title, optional reset, scroll body, and pinned apply action follow one order;
- keyboard inset is always handled.

Dialogs are limited to short decisions. Forms, item selection, conflict merge, and detailed consequences use sheets/routes.

## 6.13 States

- `PkEmptyState.full`: one screen, Kito 88–112, one primary and optional text action.
- `PkEmptyState.section`: no more than 120 px tall, icon/Kito 48–64, compact copy.
- Loading skeleton geometry matches final row/card geometry.
- Error/offline/denied/read-only surfaces preserve the surrounding layout when possible.
- Success uses inline confirmation or short celebration; do not force a full success screen for reversible routine saves.

## 6.14 Kito components

- `KitoMessage` defaults to compact 56–64 art; `large` must be explicit.
- At widths under 340, do not automatically stack to a 96 px image above text; use compact inline or hide decorative art.
- `KitoInsightCard` uses one or two lines and a disclosure action; longer explanation opens detail.
- `KitoCelebration` respects short height and reduced motion.

## 6.15 Navigation

- Keep four destinations plus Add.
- Bottom-nav label 11–12, icon 22–24, target ≥48.
- At large text sizes, allow labels to wrap once or move to a vertical/rail layout; do not globally suppress scaling.
- Add launcher shows 3–5 contextual choices, each 56–64 px, with text and icon.
- Destination state is never communicated by color alone.

## 6.16 Charts

When the companion audit’s charts are implemented:

- sparklines are 40–56 px high and secondary to the amount;
- donut minimum 120 px with a textual category list;
- chart colors are semantic and distinguishable in grayscale;
- every chart has a concise insight sentence and accessible data alternative;
- animation is disabled under reduced motion.

---

# 7. Screen changes

## 7.1 Home

Target order:

1. Compact brand header.
2. Action-required stack only when items exist.
3. One portfolio hero with month control, net worth, spend/income, and comparison.
4. Contextual quick actions: Add expense, Scan, Transfer, Settle when relevant.
5. Accounts preview.
6. “Who owes whom” shared preview.
7. Budgets/upcoming obligations.
8. Trend/category insight.
9. Recent activity.

Changes:

- Do not show the large welcome artwork and the portfolio hero together on routine visits.
- Welcome artwork is first-use/returning-after-long-absence content and collapses after interaction.
- Convert AI approval and settlement/invite/draft items to one compact action-required component.
- Portfolio hero target height 148–168.
- Net worth 32/38; spend/income 20–24, not additional display values.
- Kito insight is below critical finance content and compact unless the insight is urgent.
- At 390×844, header, action-required row if present, full hero, and the start of Accounts must be visible above navigation.
- On 600+ widths, keep hero full width and use two columns beneath.

## 7.2 Accounts list

- Compact summary hero 120–144 px.
- Group account rows in one surface, 64–72 px each, with separators.
- Show at least five standard rows in a 390×844 viewport with the summary present.
- Remove the bottom full-width Add button if app-bar Add is added; otherwise keep one bottom action, not both.
- Expose search/sort from the companion audit without pushing the list below the fold.
- Multi-currency equivalent remains supporting text.

## 7.3 Account detail

- Hero 132–156 px: balance, current/available distinction, month in/out, optional sparkline.
- Recent activity uses canonical ledger rows.
- Add Money Event is a compact floating/contextual action, not a large repeated bottom button if already available.
- Related savings goal/credit limit/FX disclosure fits beneath the balance without adding another hero.

## 7.4 Spaces list

- Summary hero 120–144 px.
- Pending invite is a compact action-required row above the list.
- Group spaces into one surface where possible; 72 px row target.
- Always show type and currency so same-named spaces are distinguishable.
- Member avatars are optional and compact; balance meaning uses words plus sign/color.
- Create Space has one primary entry point.

## 7.5 Space detail

- Adopt the companion audit IA: Overview / Money / People / Activity / Settings.
- Keep at most two app-bar actions; move the rest to overflow or tabs.
- Hero 148–168: current/lifetime scope, balance answer, one primary settle action.
- Sticky tabs 44/48 and horizontally scrollable in Japanese/narrow layouts.
- Money tab uses canonical shared ledger rows and visible active filters.
- People uses 64 px member rows; balances align right.
- Archived/viewer state appears as a compact ribbon without duplicating a full warning card.

## 7.6 Shared expense detail

- Amount 32/38, merchant/title 18–20.
- Present paid-by and split breakdown as grouped rows, not a stack of cards.
- Receipt preview is compact and opens a viewer.
- Lifecycle/status is adjacent to title/amount.
- Edit/duplicate/void live in overflow; primary confirm action appears only when state requires it.

## 7.7 Activity/history

- Make this the canonical finance-ledger screen.
- Header/app bar 56, search 48, compact filter/sort row.
- Active filters visible and removable.
- Sticky month/day headers 28–32 px.
- One grouped surface per month or continuous list with inset separators; avoid a rounded card around every day.
- Simple row 64; shared/status row 72–80.
- At 390×844 show at least five simple rows after header/search/filter chrome.
- Amounts align to one trailing edge; status sits below metadata or as a compact badge.
- Loading skeletons and empty-period states preserve the same structure.

## 7.8 Transaction detail

- Compact amount hero 120–144 px or plain header section; do not require a large gradient card.
- Group metadata rows by “Transaction,” “Account & category,” “Shared/receipt,” and “Audit.”
- Make note and receipt scannable without oversized cards.
- Related items appear as compact navigation rows.
- Destructive consequences are explicit and consistent with lifecycle/undo work.

## 7.9 Quick Add

- Compact sheet for personal expense/income only.
- Top: type tabs, 32 px amount, currency.
- Middle: account, category, date; optional note/receipt shortcuts.
- Bottom: system numeric keyboard or purpose-built keypad only when it improves speed and accessibility.
- Save remains visible with keyboard open.
- Target completion: common expense in ≤6 taps after opening, excluding text entry.

## 7.10 Advanced add/edit and shared expense

- Full-screen route.
- Use sections with summaries: basics, payment, category/tags, shared payment/split, receipt, notes.
- Multi-payer and split preview receive dedicated steps or expanded sections.
- Show totals validation adjacent to the relevant section and in the final summary.
- Sticky final action does not obscure the last field.
- Editing, duplicating, and OCR review clearly identify their mode in title and submit copy.

## 7.11 Receipt/OCR

- Camera capture area gets most of the viewport; guidance overlays do not cover receipt edges.
- After capture, show a review screen with original image, extracted fields, confidence/uncertainty, and explicit apply controls.
- Kito may reassure or explain uncertainty at 48–64 px, never compete with the receipt.
- Attachment state remains visible on detail after save.

## 7.12 Filters, sorting, search, date pickers

- Small filter sets use content-height sheets.
- Activity’s complex filter uses a standard/full sheet with visible reset and pinned Apply.
- Date range offers Today, This month, Previous month, Custom where appropriate.
- Selected date range is textual and locale-aware; a wheel is not required.
- Search results preserve query and filter state when navigating to detail and back.

## 7.13 Budgets

- List groups Personal and Shared budgets; rows 72–80 with name, scope, used/limit, remaining/over, and progress.
- Progress height 6–8; status includes text.
- Detail hero 132–156 with used, remaining, days, previous-period delta, and compact chart.
- Editor uses `PkAmountField`, period picker, scope/category picker, and concise rollover/forecast explanations.

## 7.14 Subscriptions / recurring

- Group by Overdue / Due soon / Later; 68–76 px rows.
- Amount and due date align right; account/cadence is supporting copy.
- “Pay” is compact and does not turn every row into two large targets.
- Detail uses one summary hero and grouped schedule/payment history.
- Editor is a form route/sheet based on complexity, with one final action.

## 7.15 Categories, tags, payment methods

- Use 56–64 px management rows.
- Search field appears only once the list threshold is met.
- Icon/color are 32–36 visible; reorder/archive actions are secondary.
- Hierarchy uses indentation and disclosure, not nested oversized cards.

## 7.16 Settlements

- Settle-up plan uses compact debtor → creditor rows with aligned amounts.
- Proposal/confirmation status appears in title area and history row.
- Account/payment method selection uses shared pickers.
- Success may use Kito 112–144, but includes concise result and one primary continuation.
- History uses grouped ledger rows; detail uses grouped metadata and audit timeline.

## 7.17 Space members and invitations

- Member rows 64: avatar 40, name/role, balance or status, overflow action.
- Invite row indicates expiry/status without a separate large card.
- Invite review prioritizes inviter, space identity, role, permissions/consequences, and Accept/Decline.
- Kito may reinforce trust but stays below the permission facts.

## 7.18 AI and integrations

- AI Connections starts with a compact trust note, not a 96 px mascot card on every visit.
- Connections use grouped 64–72 px rows.
- Authorization keeps the client mark at 48–56, then plainly separates read access from write access.
- Write permission receives warning treatment and preview/approval explanation.
- Approval cards show requested action, exact data affected, requesting app, time, and approve/deny controls without decorative excess.
- Kito is useful at first connection, risk explanation, and empty state; routine activity is a ledger.

## 7.19 Notifications

- Group by Today / Earlier or Action required / Updates.
- Row 68–80 depending on action/status.
- Unread uses dot + semantics, not bold/color alone.
- Swipe dismiss has undo and an accessible alternative.
- Deep-link destination is clear in subtitle or action label.

## 7.20 More and settings

- Use grouped surfaces with 56 px rows and 20 px section gaps.
- Show at least seven setting rows in a 390×844 viewport.
- Profile header is compact; do not use an oversized card.
- Prototype/debug rows are hidden in release builds as required by the companion audit.
- Destructive/reset actions are separated from normal preferences.

## 7.21 Profile, appearance, language, currency, exchange rates

- Forms max width 560 on large displays.
- Profile avatar 64, not 80; edit target 48.
- Theme/language options use compact radio rows and show immediate preview where useful.
- Currency/exchange-rate information notices use dense informational surfaces.
- Long currency lists require search and recents; rows 56.

## 7.22 Authentication, onboarding, and invite entry

- Illustration max 35% of usable height.
- Headline 24–28, body 15, one primary CTA pinned safely.
- Onboarding pages scroll at large text sizes and short heights.
- Progress indicator is explicit and semantic.
- Sign-in errors preserve entered non-sensitive state and clearly state recovery.
- Auth error uses full-screen state only when the entire flow is blocked.

## 7.23 Empty, loading, error, offline, denied, archived, conflict, destructive, and success states

For every primary screen, specify:

- whether the state replaces the screen or appears inline;
- what remains visible for orientation;
- primary recovery action;
- whether Kito appears and at what size;
- screen-reader announcement behavior;
- offline/read-only write behavior;
- skeleton geometry;
- undo/confirmation pattern.

Use inline/section states when only one section fails. Full-screen states are reserved for entire-route failure or first use.

## 7.24 Tablet, desktop web, and landscape

- Home: one full-width hero, two-column content below.
- Accounts/Activity/Spaces: master list 360–420 plus detail pane when width permits.
- Forms: centered 560 px; supporting preview may occupy a second pane.
- Navigation rail at 900; extended at 1180.
- Do not stretch phone cards to 760+ px without reflow.
- Keyboard focus, hover, and 2 px/3:1 focus treatment are required on web/desktop.

---

# 8. Prioritized implementation tasks

## 8.1 Dependency and non-duplication map

Before starting these tasks:

1. Read `docs/prototype-completion-audit.md` completely.
2. Let its active model/component migrations land or rebase onto them.
3. Do not recreate its feature tasks under new names.
4. Apply this audit’s visual/component contracts to those features as they become available.

| Companion audit work | This audit’s responsibility |
|---|---|
| Permissions/read-only/offline/conflict | density, placement, hierarchy, state component variants |
| Multi-payer/splits/settlements | form progression, row design, validation visibility |
| Search/sort/filters | control dimensions, active-state visibility, sheet behavior |
| Charts/comparisons | chart dimensions, accessibility, placement, hierarchy |
| Tags/payment methods/notes/receipts | picker/row/attachment component design |
| Localization | responsive text behavior and Japanese visual QA |
| Loading/error/undo | visual state contracts and acceptance matrix |

## 8.2 Task sequence

### UI-001 — Stabilize and baseline

**Priority:** P0  
**Dependencies:** companion audit’s current migration point  
**Work:**

- restore a clean `flutter analyze` and test baseline without discarding active work;
- capture screenshots for every route/state in light and dark at 390×844;
- record current semantics and viewport row counts;
- create a visual-test manifest listing all routes/states.

**Primary files:** whole Flutter app, test/previews infrastructure  
**Acceptance:** baseline artifacts exist and analyzer/tests pass before visual refactoring.

### UI-002 — Introduce semantic design tokens

**Priority:** P0  
**Dependencies:** UI-001  
**Work:** implement sections 5.1–5.8: type aliases, spacing, radius, elevation, sizes, breakpoints, max widths, contrast tests.

**Primary files:** `pk_tokens.dart`, `pk_theme.dart`, `pk_format.dart`  
**Acceptance:** no feature screen needs a raw font size, standard radius, standard target size, or standard breakpoint.

### UI-003 — Rebuild surface and row primitives

**Priority:** P0  
**Dependencies:** UI-002  
**Work:** `PkCard` variants, `PkGroupedSurface`, canonical ledger/management row foundation, dividers, status/badge grammar.

**Primary files:** `pk_components.dart`, new focused component files if needed  
**Acceptance:** row geometry can be tested independently at default, 1.3×, and 2.0× text scales.

### UI-004 — Normalize headers, navigation, actions, and touch targets

**Priority:** P0  
**Dependencies:** UI-002  
**Work:** root/pushed headers, bottom nav, rail, central add, button hierarchy, icon actions, target inspection.

**Primary files:** `pk_navigation.dart`, `pk_components.dart`, `app_router.dart`, `pk_theme.dart`  
**Acceptance:** every custom action target is ≥48×48 and no root screen exposes duplicate primary add actions.

### UI-005 — Normalize sheets, search, filters, tabs, and pickers

**Priority:** P0  
**Dependencies:** UI-002, UI-004  
**Work:** enforce `PkSheetScaffold`, sheet height modes, active filters, chips, tabs, amount/date/entity pickers, keyboard behavior.

**Primary files:** `pk_pickers.dart`, `pk_states.dart`, feature sheets  
**Acceptance:** no hand-built modal header/action layout remains without a documented exception.

### UI-006 — Make Activity the canonical ledger

**Priority:** P0  
**Dependencies:** UI-003, UI-005  
**Work:** sticky groups, canonical row variants, amount alignment, active filters, skeleton/empty states, performance-safe grouping.

**Primary files:** `activity_screens.dart`, shared row components  
**Acceptance:** meets Activity viewport, semantics, filter persistence, and 500-item criteria.

### UI-007 — Separate Quick Add from advanced money editing

**Priority:** P0  
**Dependencies:** UI-005  
**Work:** compact quick sheet, full-screen advanced editor, progressive disclosure, pinned submit, mode titles, OCR/split handoff.

**Primary files:** `activity_screens.dart`, router, picker/state components  
**Acceptance:** common expense ≤6 taps; advanced shared flow remains fully reachable at 320 px and with keyboard open.

### UI-008 — Recompose Home hierarchy

**Priority:** P0  
**Dependencies:** UI-002–UI-004, companion dashboard data tasks  
**Work:** routine-vs-first-use welcome behavior, compact action-required block, hero, quick actions, section ordering, responsive two-column layout.

**Primary files:** `home_screen.dart`, `pk_brand.dart`, Kito components  
**Acceptance:** meets Home above-fold contract with and without an action-required item.

### UI-009 — Migrate Accounts and Spaces

**Priority:** P0  
**Dependencies:** UI-003, UI-004  
**Work:** grouped rows, compact heroes, action deduplication, details, tabs, members, shared expense/settlement/cycle surfaces.

**Primary files:** `accounts_screens.dart`, `spaces_screens.dart`  
**Acceptance:** list and detail viewport criteria pass; shared status never relies on color.

### UI-010 — Migrate budgets, subscriptions, categories, and management

**Priority:** P1  
**Dependencies:** UI-003, UI-005  
**Work:** grouped management rows, budget/subscription heroes, progress/status grammar, dense editors, related history.

**Primary files:** `finance_management_screens.dart`  
**Acceptance:** all management screens use canonical rows/sheets/inputs.

### UI-011 — Migrate AI, notifications, More, and settings

**Priority:** P1  
**Dependencies:** UI-003–UI-005  
**Work:** compact Kito trust notes, grouped connection/approval/notification/settings rows, debug gating, permission emphasis.

**Primary files:** `ai_screens.dart`, `settings_screens.dart`  
**Acceptance:** More shows ≥7 routine rows at 390×844; AI write permissions are visually and semantically distinct.

### UI-012 — Normalize Kito and state components

**Priority:** P1  
**Dependencies:** UI-002, UI-003  
**Work:** Kito size variants/budget, full vs section states, skeleton geometry, success/celebration, reduced motion.

**Primary files:** `kito_components.dart`, `pk_states.dart`, `pk_brand.dart`  
**Acceptance:** no routine screen reserves >64 px for Kito without an explicit large-state reason.

### UI-013 — Migrate authentication and onboarding

**Priority:** P1  
**Dependencies:** UI-004, UI-012  
**Work:** responsive illustration bounds, scroll-safe large type, CTA placement, progress semantics, error recovery.

**Primary files:** `onboarding_screens.dart`  
**Acceptance:** 320×568 and 2.0× text scale complete without clipping or unreachable actions.

### UI-014 — Responsive/tablet/master-detail pass

**Priority:** P1  
**Dependencies:** all screen migrations  
**Work:** 600/840/900/1180 breakpoints, two-column Home, master-detail Accounts/Activity/Spaces, form widths, landscape behavior.

**Primary files:** shell/router plus all primary screens  
**Acceptance:** no phone-only stretched layout above 840 px; navigation transitions preserve route/state.

### UI-015 — Accessibility and localization certification

**Priority:** P0 release gate  
**Dependencies:** all tasks  
**Work:** VoiceOver, TalkBack, keyboard, switch/voice alternatives, target inspection, contrast, focus, 1.3×/2.0× text, Japanese, RTL readiness.

**Primary files:** components, localization/tests  
**Acceptance:** every criterion in section 9 passes or has a documented product-approved exception.

### UI-016 — Visual regression and polish

**Priority:** P1 release gate  
**Dependencies:** UI-015  
**Work:** golden tests, motion/haptics, privacy mode layout, shadow/radius consistency, final screenshot comparison.

**Acceptance:** visual matrix is approved and no component-specific sizing hacks remain in feature code.

---

# 9. Acceptance criteria

## 9.1 Required device matrix

Test every primary screen and every shared component at:

- 320×568, light, 1.0× text;
- 360×800, dark, 1.0× text;
- 390×844, light and dark, 1.0× and 1.3× text;
- 430×932, light, 2.0× text;
- 768×1024 portrait and 1024×768 landscape;
- 1280×800 web/desktop with keyboard and pointer.

At minimum, onboarding, Add/Edit, Activity, Home, Space detail, filters, settings, authorization, and every full-screen state must be tested at 320×568 and 2.0× text even if that combination is not in the standard matrix.

## 9.2 Global visual criteria

- Exactly one dominant element per routine phone viewport.
- No routine screen has both a large Kito/banner and a large financial hero above the first data section.
- Standard card radius is 16; hero 20; sheet 24.
- Routine list objects are grouped with separators unless an exception is documented.
- No raw hard-coded standard font size/radius/touch target appears in feature code.
- Monetary columns align and use tabular figures.
- No amount, currency, status, or required field label clips at supported widths/scales.
- Light and dark retain the same hierarchy, not merely equivalent colors.

## 9.3 Viewport density criteria at 390×844, default text

- **Home:** header, complete hero, optional one-row action-required item, and start of first data section visible above nav.
- **Accounts:** compact summary plus at least five standard account rows visible above nav.
- **Spaces:** compact summary plus at least three 72 px space rows possible above nav.
- **Activity:** header/search/filter/group chrome plus at least five simple or four rich transaction rows.
- **More/settings:** at least seven 56 px rows, excluding app header.
- **Notifications:** at least six simple or five actionable rows after header/group label.
- **Quick Add:** type, amount, three key selectors, and Save remain reachable with keyboard/keypad.

These are layout capacities, not requirements to fabricate data. Empty fixtures use the relevant state.

## 9.4 Interaction criteria

- Every touch target is at least 48×48 logical pixels.
- Adjacent targets do not overlap.
- A visible pressed/selected/focused/disabled/loading state exists for every interactive component.
- Back navigation returns to prior query/filter/scroll state.
- Primary submission is idempotent while loading.
- Destructive action offers undo or an explicit consequence confirmation as defined by the companion audit.
- Gesture shortcuts have visible/semantic alternatives.

## 9.5 Accessibility criteria

- Normal text contrast ≥4.5:1; large text and meaningful non-text UI ≥3:1.
- Keyboard focus is clearly visible and ≥3:1 against adjacent colors.
- VoiceOver and TalkBack read financial rows in a useful order without duplicated decorative semantics.
- Text at 1.3× and 2.0× remains complete or reflows; no essential text is hidden behind ellipsis.
- Dynamic type does not make pinned actions cover content.
- Reduced motion removes nonessential movement.
- Color is never the only carrier of amount direction, budget health, role, permission, read state, or status.
- Charts expose equivalent textual data.
- Hidden balances announce privacy state.

## 9.6 Responsive criteria

- No overflow exceptions at 320 px.
- No single-column phone card stretches beyond a readable/form width on tablet.
- At 900 px, navigation changes to rail without resetting branch navigation.
- Master-detail preserves selected item and list filters.
- Landscape phone keeps primary action reachable and condenses hero/mascot before shrinking text.
- Japanese labels fit, wrap, or scroll intentionally; tabs and segmented controls never silently truncate mutually exclusive choices.

## 9.7 Screen-state criteria

Each primary route has approved evidence for:

- ready/populated;
- empty/first use;
- loading;
- load error with retry;
- offline/partial data;
- permission denied or not applicable;
- archived/read-only where applicable;
- destructive confirmation and undo where applicable;
- success;
- large data and long text;
- light/dark and large text.

State components must occupy only the failed scope: section failure stays inline; route failure may be full-screen.

## 9.8 Performance criteria

- 500 Activity items scroll smoothly on representative mid-range devices.
- Filtering/search does not animate/rebuild every visible row unnecessarily.
- Large mascot images are decoded near rendered size and do not block first meaningful paint.
- Skeleton-to-content transition does not cause major layout shift.
- No unbounded eager list is introduced during grouped-surface migration.

## 9.9 Testing requirements

- Widget tests for every shared component variant at narrow width and large text.
- Golden tests for light/dark and key state variants.
- Integration journeys for quick add, advanced shared expense, filter/back preservation, settlement proposal/confirmation, authorization, offline blocked write, destructive undo, and onboarding.
- Automated semantic-label and minimum-target checks where Flutter APIs allow.
- Manual VoiceOver and TalkBack sign-off.
- Analyzer and all existing tests pass with no ignored layout exceptions.

---

# 10. Definition of done

The Pockito mobile UI/UX production-readiness program is done only when all of the following are true:

1. `docs/prototype-completion-audit.md` dependencies used by these screens have landed or are explicitly deferred by product decision.
2. Tasks UI-001 through UI-016 are complete in dependency order.
3. The semantic type, spacing, radius, elevation, size, color, breakpoint, number, and accessibility tokens in this document exist in code.
4. Every significant screen uses shared headers, rows, surfaces, inputs, pickers, sheets, status grammar, and state variants; local substitutes have documented reasons.
5. The 390×844 viewport density targets pass without reducing touch targets or body legibility.
6. The full device/text/theme matrix passes with no overflow, clipped essential text, obscured action, or unsafe-area collision.
7. VoiceOver, TalkBack, keyboard, focus, contrast, reduced motion, and non-gesture alternatives are manually verified.
8. Activity behaves as the canonical production ledger and meets the 500-item stress test.
9. Quick Add is fast, while advanced/shared/OCR flows are complete and scroll-safe.
10. Home presents one clear dominant financial answer and prioritizes required actions over passive AI or decorative content.
11. Kito remains recognizably central to Pockito but obeys the contextual size/frequency budget.
12. Pockito’s visual identity remains blue/aqua/gold, warm, collaborative, and AI-aware without reproducing PayPay branding, colors, layout, modules, icons, components, or exact screen structures.
13. Light/dark golden baselines and route/state screenshots are reviewed and approved.
14. `flutter analyze`, unit/widget tests, golden tests, and integration tests pass.
15. No temporary prototype/debug surface is exposed in a release build.
16. A final audit finds no unresolved P0 or P1 item in this document; any exception names an owner, reason, risk, and target release.

When these conditions hold, another agent should not need to reinterpret the benchmark screenshots or repeat this research. It should be able to follow the task list, component contracts, screen specifications, and acceptance matrix directly.

