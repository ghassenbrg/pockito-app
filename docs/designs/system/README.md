# Pockito Design System

**v0.1.0 — foundations**

| File | What it is |
|---|---|
| `tokens.json` | Source of truth. Machine-readable, with a `$note` on every non-obvious decision. |
| `tokens.css` | CSS custom properties, generated from `tokens.json`. Light + dark. |
| `icons.svg` | 48-icon SVG sprite. Material Symbols Rounded geometry, drawn as strokes. |
| `index.html` | Living reference — renders the whole system and composes it into the Home screen. |

## Where the values come from

Anchored on the **hand-authored logo SVGs** (`../pockito-logo-horizontal-*.svg`, `../favicon.svg`), which
decode exactly onto Tailwind's palette:

| Brand role | Value | Tailwind |
|---|---|---|
| Primary | `#4F46E5` | indigo-600 |
| Gradient partner | `#06B6D4` | cyan-500 |
| Accent | `#FBBF24` | amber-400 |
| Ink | `#0F172A` | slate-900 |

Because the brand was built on Tailwind's ramps, the scales are already determined — the system adopts
them rather than inventing parallel ones.

`HOME-IMAGEGEN-FLAT-PROOF.png` is treated as **direction, not source**. Its blues sample to `#3546E5`
and `#1D2AE8`, which are artifacts of a generated flat proof rather than brand decisions.

## The one rule to know

**Amber means shared.** It is the coin in the mark, and in the product it marks that an amount involves
more than one person: the share rule, the owed nudge, space avatars, shared budget bars, the add button.

It never carries *direction* — whether you are owed or owing is a separate token (`balance.owedToYou`,
`balance.youOwe`) and always an explicit label.

**Amber is never text.** `#FBBF24` measures 1.67:1 on white. Amber-coloured words use
`shared.strong` (`amber-700`) at 4.84:1.

## The signature: the share rule

A hairline beneath a shared amount, filled in amber to the proportion that belongs to the current user.
A 50/50 split fills half; a 60/40 fills 60%. It encodes real data rather than decorating, and it scales
from a 64px row marker to a full-width hero rule to a per-person segmented bar in the split editor.

```html
<div class="pk-share-rule"><div class="pk-share-rule__mine" style="width:50%"></div></div>
```

## Icons

**Material Symbols Rounded** — the set life-os-mobile already uses through Flutter's `Icons.*`,
with outlined objects and rounded chrome. Drawn here as strokes on a 24px grid so one set serves
every size and colour.

```html
<svg class="pk-icon"><use href="icons.svg#i-home"/></svg>
```

| Rule | Why |
|---|---|
| No emoji, ever | Platform-dependent and off-brand — the reference page used them at first and it was wrong |
| No currency glyphs | `income` and `expense` are drawn as **direction**, not a `$` — a currency glyph would be wrong in a multi-currency product |
| Filled variants are rare | Only the active nav item and category circles. Everything else is outlined |
| Always `currentColor` | Icons never carry a hardcoded fill |

48 icons across four sets: navigation (5), chrome (18), finance (14), category (11).
For Flutter, these map back to their `Icons.*` equivalents — the sprite exists for web and for
design tooling.

## Accessibility

Every ratio in `tokens.json → a11y.measured` was **computed, not estimated**. Three primitives were
rejected during the first pass for failing body text:

| Rejected | Ratio | Replaced with |
|---|---|---|
| slate-400 as `text.tertiary` | 2.56 | slate-500 (4.76) |
| emerald-600 as `balance.owedToYou` | 3.77 | emerald-700 (5.48) |
| amber-600 as `shared.strong` | 3.07 | amber-700 (4.84) |

Colour is never the only signal: balance direction carries a label, budget status carries a value,
transaction direction carries a sign.

## Not yet built

This is the **token and foundation layer**. There is no component library yet — no `package.json`,
no build, no `dist/`. That is the next step, and it is what `/design-sync` needs before it can push
this system to claude.ai/design.

## Open item

The logo files say **Pockito**; the product specs in `../../docs/` say **Pokito**. One spelling needs
to win before any of this ships.
