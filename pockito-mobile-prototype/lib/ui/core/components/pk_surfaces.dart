/// Pockito's surface and row foundation.
///
/// Section 6.3–6.8 of the UI/UX audit. Before this file, a setting, an
/// account, a Space, a budget and an AI connection were each drawn as a
/// standalone rounded card with its own padding — which is what made routine
/// screens fragment into a column of posters and fit three rows where they
/// should fit six. The rule that replaces it: a card identifies a *group*, a
/// row identifies an *object*, and the row decides its height from what it
/// actually has to say.
library;

import 'package:flutter/material.dart';

import '../design_system/pk_tokens.dart';

// -----------------------------------------------------------------------------
// Cards and grouped surfaces
// -----------------------------------------------------------------------------

/// What a card is for, which is what decides how it is drawn.
enum PkCardVariant {
  /// Radius 16, padding 16, flat. The default for heterogeneous content.
  standard,

  /// Radius 16, padding 12. For dense dashboard tiles.
  dense,

  /// Radius 16, no outer padding, internal separators, no shadow. The
  /// container for a list of rows.
  group,

  /// The only variant that lifts. Reserved for actionable dashboard,
  /// approval, warning and insight content per section 4.4.
  raised,
}

/// A Pockito surface.
///
/// Use a card only when section 4.4 allows it: heterogeneous dashboard
/// content, an independent action boundary, something dismissible or elevated,
/// a warning/insight/approval, or a horizontally scrolling item. Everything
/// else is a [PkGroupedSurface] or a plain section.
class PkCard extends StatelessWidget {
  const PkCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.borderColor,
    this.variant = PkCardVariant.standard,
    this.semanticLabel,
  });

  /// A card whose only job is to hold a list of rows.
  const PkCard.group({
    super.key,
    required this.child,
    this.color,
    this.borderColor,
  }) : onTap = null,
       padding = EdgeInsets.zero,
       variant = PkCardVariant.group,
       semanticLabel = null;

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? borderColor;
  final PkCardVariant variant;
  final String? semanticLabel;

  EdgeInsetsGeometry get _padding =>
      padding ??
      switch (variant) {
        PkCardVariant.standard => const EdgeInsets.all(PkSpacing.x4),
        PkCardVariant.dense => const EdgeInsets.all(PkSpacing.x3),
        PkCardVariant.group => EdgeInsets.zero,
        PkCardVariant.raised => const EdgeInsets.all(PkSpacing.x4),
      };

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: _padding, child: child);
    final surface = Material(
      color: color ?? context.pk.surface,
      // Section 5.4: one shadow, and only on the variant that is genuinely
      // lifted above the page. A repeated list card carries none.
      elevation: variant == PkCardVariant.raised ? 2 : 0,
      shadowColor: PkPalette.kitoNavy900.withValues(alpha: .10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PkRadius.card),
        side: BorderSide(color: borderColor ?? context.pk.borderSubtle),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
    if (semanticLabel == null) return surface;
    return Semantics(
      container: true,
      label: semanticLabel,
      button: onTap != null,
      child: surface,
    );
  }
}

/// One surface holding many rows, with hairline separators between them.
///
/// This is the shape section 4.4 and D-03 ask for on Accounts, Spaces,
/// settings, members, notifications, categories, subscriptions and AI
/// connections: group-level whitespace outside, continuity inside.
class PkGroupedSurface extends StatelessWidget {
  const PkGroupedSurface({
    super.key,
    required this.children,
    this.color,
    this.indent = PkSpacing.x4,
  });

  final List<Widget> children;
  final Color? color;

  /// How far the separator is inset from the leading edge, so it starts under
  /// the text rather than cutting through the icon column.
  final double indent;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();
    return PkCard.group(
      color: color,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            if (index > 0)
              Divider(
                height: 1,
                thickness: 1,
                indent: indent,
                endIndent: 0,
                color: context.pk.borderSubtle,
              ),
            children[index],
          ],
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Status grammar
// -----------------------------------------------------------------------------

/// The severity a status carries, section 5.6 and 6.6.
///
/// Pending, overdue, paid, archived, offline, denied, shared, AI-generated,
/// verified and budget health used to be told through a mix of pills, colours,
/// banners and subtitles. One grammar means a reader learns the vocabulary
/// once.
enum PkStatusTone { neutral, info, success, warning, danger, shared, ai }

/// The ink a tone carries, so a badge, a bar and an arc cannot disagree about
/// what "near the limit" looks like.
Color pkStatusInk(BuildContext context, PkStatusTone tone) => switch (tone) {
  PkStatusTone.neutral => context.pk.textSecondary,
  PkStatusTone.info => Theme.of(context).colorScheme.primary,
  PkStatusTone.success => context.pk.success,
  PkStatusTone.warning => context.pk.warning,
  PkStatusTone.danger => context.pk.danger,
  PkStatusTone.shared => context.pk.sharedStrong,
  PkStatusTone.ai => context.pk.ai,
};

/// The wash a tone carries, and the hairline around it.
///
/// These exist because the alternative kept being written by hand: a `PkCard`
/// filled with `PkPalette.indigo50` or `PkPalette.rose50`. Those are *light*
/// tints with no dark counterpart, so in dark mode they became near-white
/// blocks — and the text inside them, drawn in `textPrimary`, is near-white
/// too. An unread notification was a white card with white writing on it.
///
/// Deriving the wash from the tone's own ink over the current surface means
/// there is one definition per tone rather than one per theme, and no way to
/// ship the light half without the dark one.
Color pkStatusSurface(BuildContext context, PkStatusTone tone) {
  if (tone == PkStatusTone.shared) return context.pk.sharedSurface;
  // Dark needs slightly more of the ink to separate from the page at all;
  // light needs less before the wash starts competing with the text on it.
  final alpha = Theme.of(context).brightness == Brightness.dark ? .16 : .09;
  return Color.alphaBlend(
    pkStatusInk(context, tone).withValues(alpha: alpha),
    context.pk.surface,
  );
}

Color pkStatusBorder(BuildContext context, PkStatusTone tone) =>
    tone == PkStatusTone.shared
    ? context.pk.sharedBorder
    : pkStatusInk(context, tone).withValues(alpha: .32);

/// A compact status label. Colour is never the only carrier: the badge always
/// shows its word, and an icon where one adds meaning.
class PkStatusBadge extends StatelessWidget {
  const PkStatusBadge({
    super.key,
    required this.label,
    this.tone = PkStatusTone.neutral,
    this.icon,
  });

  final String label;
  final PkStatusTone tone;
  final IconData? icon;

  Color _foreground(BuildContext context) => pkStatusInk(context, tone);

  @override
  Widget build(BuildContext context) {
    final color = _foreground(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: tone == PkStatusTone.shared
            ? context.pk.sharedSurface
            : color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(PkRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 3),
          ],
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.pkText.micro.copyWith(
                color: color,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Rows
// -----------------------------------------------------------------------------

/// How much a row has to say, which is what sets its height.
///
/// Section B-05: density is content-dependent. A row never takes "whatever the
/// children happen to require" — it declares which of four contracts it is.
enum PkRowDensity {
  /// A setting, a category, a payment method. 56.
  management(PkSize.rowSimple),

  /// A transaction, an account, a member. 64.
  standard(PkSize.rowStandard),

  /// Carries a share, an equivalent value, or a second metadata line. 72.
  rich(PkSize.rowRich),

  /// Also carries lifecycle status. 80.
  status(PkSize.rowStatus);

  const PkRowDensity(this.minHeight);

  final double minHeight;
}

/// The canonical Pockito list row.
///
/// Every finance and management row in the app composes this: transaction,
/// account, space, budget, subscription, settlement, notification, member and
/// AI connection. It owns the scan axis (what on the left, how much on the
/// right), the metadata order, the 48 px target, and the one coherent
/// semantics node section 5.9 requires.
class PkLedgerRow extends StatelessWidget {
  const PkLedgerRow({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.subtitleWidget,
    this.badges = const [],
    this.trailing,
    this.trailingSubtitle,
    this.onTap,
    this.onLongPress,
    this.density = PkRowDensity.standard,
    this.showChevron = false,
    this.struckThrough = false,
    this.semanticLabel,
    this.semanticIdentifier,
    this.footer,
    this.enabled = true,
    this.destructive = false,
  });

  /// A management row: 56 px, no amount column, usually a chevron or a switch.
  const PkLedgerRow.management({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showChevron = false,
    this.semanticLabel,
    this.semanticIdentifier,
    this.enabled = true,
    this.struckThrough = false,
    this.destructive = false,
  }) : subtitleWidget = null,
       badges = const [],
       trailingSubtitle = null,
       onLongPress = null,
       density = PkRowDensity.management,
       footer = null;

  /// The object's icon, avatar or colour tile. Kept at [PkSize.iconTileDense]
  /// in ledgers so the row reads as a ledger and not as a menu of cards.
  final Widget? leading;

  final String title;

  /// One metadata line. Section 4.3 allows at most two in a list row, so the
  /// second has to arrive as [trailingSubtitle] or [footer].
  final String? subtitle;

  /// A metadata line that is not plain text — a progress bar, an FX note.
  final Widget? subtitleWidget;

  /// Compact inline badges that sit after the title without displacing it.
  final List<Widget> badges;

  /// The amount or status. Right-aligned, tabular.
  final Widget? trailing;

  /// Date, share, or status beneath the amount.
  final Widget? trailingSubtitle;

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final PkRowDensity density;
  final bool showChevron;

  /// A voided record stays visible and struck through rather than vanishing.
  final bool struckThrough;

  /// Overrides the composed announcement. Prefer letting the row build it:
  /// title, amount, then context, in that order.
  final String? semanticLabel;

  /// Stable handle for tests and automation, independent of language.
  final String? semanticIdentifier;

  /// Full-width content beneath the row proper — a progress bar, a comparison.
  final Widget? footer;

  final bool enabled;

  /// Deletes, removals, "leave this Space". Four sheets were each colouring
  /// their own title `danger` by hand, which meant four chances to forget and
  /// no single place to change what destructive looks like.
  final bool destructive;

  /// Above this text scale the amount moves beneath the title instead of
  /// competing with it for a width neither can have. Section 5.1.
  static const double _stackAboveScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final stacked = scale >= _stackAboveScale;
    final titleStyle = context.pkText.rowTitle.copyWith(
      decoration: struckThrough ? TextDecoration.lineThrough : null,
      color: !enabled
          ? context.pk.textTertiary
          : destructive
          ? context.pk.danger
          : null,
    );

    // Badges shrink before the title does: the object's name is what the
    // reader is scanning for.
    //
    // Two `Flexible`s do *not* express that. `Row` splits the free space by
    // flex factor, so a title and a badge both at flex 1 each get half the
    // line whatever they actually need — which is how "Approval requested"
    // ended up rendered as "Appro…" beside a badge with room to spare. The
    // badge is laid out inflexibly at its own width instead, capped so it can
    // never take the line, and the title takes everything that is left.
    final titleLine = badges.isEmpty
        ? Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle,
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              // A badge has an incompressible floor of its own — padding plus
              // glyph — so the cap is never allowed below it, or the badge
              // overflows itself on a narrow row. Squeezed that far it shows
              // its icon alone, which still carries the meaning; the words are
              // in the row's composed announcement either way.
              const badgeFloor = 30.0;
              final share = (constraints.maxWidth * .42 / badges.length)
                  .floorToDouble();
              final badgeCap = share < badgeFloor ? badgeFloor : share - 1;
              return Row(
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                  ),
                  for (final badge in badges) ...[
                    const SizedBox(width: PkSpacing.x1),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: badgeCap),
                      child: badge,
                    ),
                  ],
                ],
              );
            },
          );

    final leadingColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleLine,
        if (subtitle != null)
          Text(
            subtitle!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.pkText.supporting,
          ),
        ?subtitleWidget,
        if (stacked && (trailing != null || trailingSubtitle != null)) ...[
          const SizedBox(height: PkSpacing.x1),
          DefaultTextStyle.merge(
            textAlign: TextAlign.start,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [?trailing, ?trailingSubtitle],
            ),
          ),
        ],
      ],
    );

    // The same flex trap as the title line, one level up: `Expanded` and
    // `Flexible` are both flex 1, so the name-and-metadata column was handed
    // half the row no matter how little the amount column needed. That is why
    // "Household · EUR · 2 members" clipped to "Household · EUR · 2 …" beside
    // an amount with slack to spare.
    //
    // The amount column is measured at its own width instead — an amount must
    // never be the thing that truncates — and capped so a long status line
    // beneath it still cannot swallow the row.
    final row = LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: stacked
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: context.isNarrow ? PkSpacing.x2 : PkSpacing.x3),
          ],
          Expanded(child: leadingColumn),
          if (!stacked && (trailing != null || trailingSubtitle != null)) ...[
            const SizedBox(width: PkSpacing.x2),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth * .55),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [?trailing, ?trailingSubtitle],
              ),
            ),
          ],
          if (showChevron)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: PkSpacing.x1),
              child: Icon(
                Icons.chevron_right_rounded,
                size: PkSize.chevron,
                color: context.pk.textTertiary,
              ),
            ),
        ],
      ),
    );

    final body = Padding(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: context.isNarrow ? PkSpacing.x3 : PkSpacing.x4,
        vertical: PkSpacing.x3,
      ),
      child: footer == null
          ? row
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                row,
                const SizedBox(height: PkSpacing.x2),
                footer!,
              ],
            ),
    );

    // The row's minimum height is a floor, not a cap: at large text sizes it
    // grows rather than clipping, which is what section 5.1 asks for.
    final sized = ConstrainedBox(
      constraints: BoxConstraints(minHeight: density.minHeight),
      child: body,
    );

    return Semantics(
      container: true,
      button: onTap != null,
      enabled: enabled,
      label: semanticLabel,
      identifier: semanticIdentifier,
      // A composed label replaces the children's own announcements, so a
      // screen reader hears one row rather than five fragments.
      excludeSemantics: semanticLabel != null,
      child: onTap == null
          ? sized
          : InkWell(onTap: onTap, onLongPress: onLongPress, child: sized),
    );
  }
}

/// A read-only fact: what it is on the left, what it says on the right.
///
/// Four screens had grown their own private version of this — `_DetailRow`,
/// `_ExpenseDetailRow`, `_ManagementRow` and `_InfoRow` — differing only in
/// vertical padding and which text style they happened to reach for. They also
/// each announced as two separate strings, so a screen reader read a column of
/// labels and then a column of values.
class PkDetailRow extends StatelessWidget {
  const PkDetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueWidget,
    this.trailing,
    this.onTap,
  }) : compact = false;

  /// Tighter vertical rhythm, for a dense panel of facts rather than a list.
  const PkDetailRow.compact({
    super.key,
    required this.label,
    required this.value,
    this.valueWidget,
    this.trailing,
    this.onTap,
  }) : compact = true;

  final String label;

  /// The plain-text value, and the string the row announces.
  final String value;

  /// A richer rendering of the same value — an amount, a badge. It has to say
  /// the same thing [value] does, because that is what is announced.
  final Widget? valueWidget;

  final Widget? trailing;
  final VoidCallback? onTap;
  final bool compact;

  /// Above this scale the value moves under the label rather than fighting it
  /// for a width neither can have — the rule [PkLedgerRow] already follows.
  static const double _stackAboveScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final stacked =
        MediaQuery.textScalerOf(context).scale(1) >= _stackAboveScale;
    final labelText = Text(
      label,
      style: context.pkText.supporting.copyWith(
        color: context.pk.textSecondary,
      ),
    );
    final valueText =
        valueWidget ??
        Text(
          value,
          textAlign: stacked ? TextAlign.start : TextAlign.end,
          style: context.pkText.bodyStrong,
        );

    final body = Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? PkSpacing.x2 : PkSpacing.x3,
      ),
      child: stacked
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                labelText,
                const SizedBox(height: PkSpacing.x1),
                valueText,
                ?trailing,
              ],
            )
          // The same flex trap `PkLedgerRow` had: two flex-1 children split
          // the row down the middle, so "Category" was handed as much width
          // as "Restaurants · Revolut · Shared with Flat". The label is
          // measured at its own width — capped, because a long label in
          // Japanese must not take the row either — and the value, which is
          // the half the reader came for, gets what is left.
          : LayoutBuilder(
              builder: (context, constraints) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth * .45,
                    ),
                    child: labelText,
                  ),
                  const SizedBox(width: PkSpacing.x4),
                  Expanded(child: valueText),
                  ?trailing,
                ],
              ),
            ),
    );

    return Semantics(
      container: true,
      button: onTap != null,
      // One node, so the pair is heard as the fact it is.
      label: '$label, $value',
      excludeSemantics: true,
      child: onTap == null
          ? body
          : InkWell(
              onTap: onTap,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: PkSize.touch),
                child: body,
              ),
            ),
    );
  }
}

// -----------------------------------------------------------------------------
// Section headers
// -----------------------------------------------------------------------------

/// A section heading, section 6.8.
///
/// 18/24 title, 8–12 below, one compact action with a full 48 target. Count
/// and "See all" may not both appear unless each answers a different question.
class PkSectionHeader extends StatelessWidget {
  const PkSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
    this.trailing,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: PkSpacing.headerToContent),
    child: Row(
      // Title and action button are both flex children of equal weight, so
      // Flutter splits the row's width 50/50 between them before either one
      // renders, then the button shrinks to its actual text inside that
      // half — landing near the midpoint instead of the true right edge.
      // spaceBetween pushes any space the two don't use into the gap
      // between them instead of leaving it stranded after the button.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.pkText.sectionTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: context.pkText.supporting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        ?trailing,
        // "See all" is inflexible at default text and 100 px wide at 2.0x,
        // where it pushed the whole header past the gutter. The title is what
        // the section is; the way in may ellipsize.
        if (actionLabel != null)
          Flexible(
            child: TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                minimumSize: const Size(PkSize.touch, PkSize.touch),
                padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x2),
                textStyle: context.pkText.bodyStrong,
              ),
              child: Text(
                actionLabel!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
      ],
    ),
  );
}

/// A section label used above a grouped surface — quieter than a section
/// header, for "Today", "Personal", "Action required".
class PkGroupLabel extends StatelessWidget {
  const PkGroupLabel({super.key, required this.label, this.trailing});

  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: PkSpacing.x2),
    child: Row(
      children: [
        Expanded(
          // Deliberately not upper-cased: Japanese has no case, and screen
          // readers can spell out all-caps words letter by letter. Weight and
          // colour carry the demotion instead.
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.pkText.label.copyWith(
              color: context.pk.textTertiary,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

/// A read-only ribbon, offline note or denied reason rendered inline without
/// stealing the layout around it, section 6.13.
class PkInlineNotice extends StatelessWidget {
  const PkInlineNotice({
    super.key,
    required this.message,
    required this.icon,
    this.tone = PkStatusTone.info,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final IconData icon;
  final PkStatusTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      PkStatusTone.danger => context.pk.danger,
      PkStatusTone.warning => context.pk.warning,
      PkStatusTone.success => context.pk.success,
      PkStatusTone.shared => context.pk.sharedStrong,
      PkStatusTone.ai => context.pk.ai,
      PkStatusTone.neutral => context.pk.textSecondary,
      PkStatusTone.info => Theme.of(context).colorScheme.primary,
    };
    return Container(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x3,
        PkSpacing.x2,
        PkSpacing.x2,
        PkSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(PkRadius.control),
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Row(
        children: [
          Icon(icon, size: PkSize.icon, color: color),
          const SizedBox(width: PkSpacing.x2),
          Expanded(
            child: Text(
              message,
              style: context.pkText.supporting.copyWith(
                color: context.pk.textPrimary,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: color,
                minimumSize: const Size(PkSize.touch, PkSize.touch),
                padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x2),
              ),
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}

/// A pinned action bar that sits above the keyboard and the safe area.
///
/// Section 4.6: the primary submit stays reachable with the keyboard open, and
/// section 9.5: dynamic type must not let it cover content.
class PkPinnedActions extends StatelessWidget {
  const PkPinnedActions({super.key, required this.child, this.secondary});

  final Widget child;
  final Widget? secondary;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: context.pk.page,
      border: Border(top: BorderSide(color: context.pk.borderSubtle)),
    ),
    child: SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          context.gutter,
          PkSpacing.x3,
          context.gutter,
          PkSpacing.x3 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            child,
            if (secondary != null) ...[
              const SizedBox(height: PkSpacing.x2),
              secondary!,
            ],
          ],
        ),
      ),
    ),
  );
}

/// A list beside its detail on displays wide enough to hold both.
///
/// Section 7.24. Below [PkBreakpoints.medium] this is the list and nothing
/// else, and tapping a row pushes a route exactly as it always did — the phone
/// behaviour is untouched. At or above it, the same list narrows to a pane and
/// the detail renders beside it, which is what stops a tablet showing one
/// stretched phone column.
///
/// The selection lives in the list screen's own state rather than in the
/// router, so widening or narrowing the window cannot strand the reader on a
/// route that no longer exists.
class PkTwoPane extends StatelessWidget {
  const PkTwoPane({
    super.key,
    required this.list,
    required this.detail,
    required this.placeholder,
  });

  final Widget list;

  /// The detail for the current selection, or null when nothing is selected.
  final Widget? detail;

  /// Shown in the detail pane before anything is selected. Section 9.7 counts
  /// this as the pane's own empty state.
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    if (!context.isMedium) return list;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: PkBreakpoints.listPaneWidth, child: list),
        VerticalDivider(width: 1, color: context.pk.borderSubtle),
        Expanded(
          child: ClipRect(child: detail ?? Center(child: placeholder)),
        ),
      ],
    );
  }
}

/// Centres content at the measure section 5.8 sets for it, whatever the
/// display width.
///
/// A field or a list row stretched across a 1280 px window is not a wide
/// layout, it is a phone layout that stopped caring. Wrapping the body rather
/// than the page keeps the screen's own scrolling and app bar untouched.
class PkContentColumn extends StatelessWidget {
  /// Lists and mixed content. 640.
  const PkContentColumn({super.key, required this.child})
    : maxWidth = PkBreakpoints.readingMaxWidth;

  /// A screen that is mostly fields. 560.
  const PkContentColumn.form({super.key, required this.child})
    : maxWidth = PkBreakpoints.formMaxWidth;

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    ),
  );
}
