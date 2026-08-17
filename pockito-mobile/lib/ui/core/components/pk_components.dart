import 'package:flutter/material.dart';

import '../../../domain/models/financial_models.dart';
import '../../../domain/repositories/pockito_repository.dart';
import '../design_system/pk_assets.dart';
import '../design_system/pk_format.dart';
import '../design_system/pk_icons.dart';
import '../design_system/pk_tokens.dart';
import 'kito_components.dart';
import 'pk_charts.dart';
import 'pk_pickers.dart';
import 'pk_surfaces.dart';
import '../design_system/pk_labels.dart';

export 'kito_components.dart';
export 'pk_navigation.dart';
export 'pk_brand.dart';
export 'pk_states.dart';
export 'pk_pickers.dart';
export 'pk_records.dart';
export 'pk_charts.dart';
export 'pk_surfaces.dart';
export '../design_system/pk_assets.dart';
// The sort vocabulary belongs to the repository but is spoken by every list
// control, so screens get it with the components that use it.
export '../../../domain/repositories/pockito_repository.dart'
    show PkSort, PkSortLabel;

/// How wide a page's content column may grow, section 6.1.
///
/// A single 760 px column is too wide for body copy and far too wide for form
/// fields; centring a stretched phone layout is not responsive design.
enum PkPageWidth {
  /// Lists and mixed content. 640.
  reading(PkBreakpoints.readingMaxWidth),

  /// Any screen that is mostly fields. 560.
  form(PkBreakpoints.formMaxWidth),

  /// A dashboard that reflows into columns rather than stretching. 1120.
  dashboard(PkBreakpoints.dashboardMaxWidth);

  const PkPageWidth(this.maxWidth);

  final double maxWidth;
}

class PkPage extends StatelessWidget {
  const PkPage({
    super.key,
    required this.slivers,
    this.refresh,
    this.bottomPadding,
    this.width = PkPageWidth.reading,
  });

  final List<Widget> slivers;

  /// Only where refreshing has a real production meaning.
  final Future<void> Function()? refresh;

  /// Overrides the trailing space. Leave it unset: the default reserves
  /// exactly what this page sits above.
  final double? bottomPadding;

  final PkPageWidth width;

  @override
  Widget build(BuildContext context) {
    // Content scrolls behind the floating navigation, so the last row has to
    // be able to clear it. With `extendBody`, Scaffold reports the bar's full
    // height — including its safe-area inset — as the body's bottom padding,
    // so this is the exact clearance on shell pages and just the device inset
    // on pushed ones.
    final clearance =
        bottomPadding ??
        MediaQuery.paddingOf(context).bottom + PkSize.navClearance;
    final view = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        ...slivers,
        SliverToBoxAdapter(child: SizedBox(height: clearance)),
      ],
    );
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width.maxWidth),
          child: refresh == null
              ? view
              : RefreshIndicator(onRefresh: refresh!, child: view),
        ),
      ),
    );
  }
}

/// The header of a root screen, section 6.2.
///
/// 24 px title with an optional 13 px subtitle and a 12 px gap below. It used
/// to be 28 while `PkAppBar` was 20, which is what made a root screen and a
/// pushed screen feel like two different products.
class PkScreenHeader extends StatelessWidget {
  const PkScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onBack,
    this.actions = const [],
  });

  final String title;

  /// Omit this when it only restates a count already visible below.
  final String? subtitle;
  final Widget? leading;

  /// Explicit back behaviour for a screen that is always reached from
  /// somewhere, even when the navigator has nothing to pop — a deep link, for
  /// example. Without it the header falls back to popping when it can.
  final VoidCallback? onBack;

  /// At most two. Section 6.2 sends anything further to an overflow menu.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    assert(
      actions.length <= 2,
      'A screen header shows at most two trailing actions; move the rest to '
      'an overflow menu (section 6.2).',
    );
    // Sliver-based screens have no AppBar, so a pushed one has to carry its own
    // back control. Branch roots cannot pop and correctly get none.
    final showBack =
        leading == null &&
        (onBack != null || (ModalRoute.of(context)?.canPop ?? false));
    return SliverPadding(
      padding: EdgeInsetsDirectional.fromSTEB(
        showBack ? PkSpacing.x2 : context.gutter,
        PkSpacing.x3,
        context.gutter,
        PkSpacing.headerToContent,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBack)
              IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            if (leading != null) ...[
              leading!,
              const SizedBox(width: PkSpacing.x3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.pkText.screenTitle,
                    // Two lines only where localization needs them.
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.pkText.supporting,
                    ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}

class PkMark extends StatelessWidget {
  const PkMark({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size * .24),
      boxShadow: PkShadows.card(PkPalette.kitoBlue700),
    ),
    child: KitoImage(
      asset: KitoAsset.appIcon,
      width: size,
      height: size,
      fit: BoxFit.cover,
      semanticLabel: context.t.pockitoAppIconFeaturingKito,
    ),
  );
}

/// How much room the hero is allowed, section 6.4.
enum PkHeroDensity {
  /// A summary above a list — Accounts, Spaces, Subscriptions. 120–144.
  compact(PkSpacing.x4),

  /// The one dominant financial answer on a screen. 148–168.
  standard(PkSpacing.x5),

  /// Only where the hero *is* the screen.
  expanded(PkSpacing.x5);

  const PkHeroDensity(this.padding);

  final double padding;
}

/// The coloured summary panel at the top of a primary screen.
///
/// Home, Accounts, an account, a Space and Subscriptions all lead with one of
/// these. They used to be five hand-rolled containers with different fills and
/// only one of them lifted off the page; sharing the panel gives every screen
/// the same opening gesture and the same light source.
class PkHeroPanel extends StatelessWidget {
  const PkHeroPanel({
    super.key,
    required this.child,
    this.color,
    this.padding,
    this.density = PkHeroDensity.standard,
  });

  final Widget child;

  /// Tint for a hero that belongs to one account, Space or category. Omit it
  /// for the Pockito brand gradient.
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final PkHeroDensity density;

  @override
  Widget build(BuildContext context) {
    final base = color;
    // Section 4.7 and D-02: on a short screen the hero compacts before any
    // financial text is allowed to shrink.
    final effective =
        padding ??
        EdgeInsets.all(
          context.isShort ? PkHeroDensity.compact.padding : density.padding,
        );
    return Container(
      padding: effective,
      decoration: BoxDecoration(
        gradient: base == null
            ? PkGradients.hero
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.lerp(base, PkPalette.kitoNavy900, .24)!, base],
              ),
        borderRadius: BorderRadius.circular(PkRadius.hero),
        boxShadow: PkShadows.hero(base ?? PkPalette.kitoBlue700),
      ),
      child: child,
    );
  }
}

class PkAvatar extends StatelessWidget {
  const PkAvatar({super.key, required this.label, this.size = 40, this.color});
  final String label;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color ?? PkPalette.indigo50,
      shape: BoxShape.circle,
      border: Border.all(
        color: (color ?? PkPalette.indigo600).withValues(alpha: .18),
      ),
    ),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color == null ? PkPalette.indigo700 : Colors.white,
      ),
    ),
  );
}

/// The coloured square that identifies an account, category or Space.
///
/// Section 5.5 gives it two sizes: 38 with a 20 px glyph in a dense ledger
/// row, and 44 with a 22 px glyph on a feature card. The visible tile is
/// smaller than the touch target it sits inside — the row supplies that.
class PkIconTile extends StatelessWidget {
  const PkIconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = PkSize.iconTileDense,
    this.iconSize,
  });

  /// The larger treatment, for a card rather than a ledger row.
  const PkIconTile.feature({super.key, required this.icon, required this.color})
    : size = PkSize.iconTileFeature,
      iconSize = 22;

  final IconData icon;
  final Color color;
  final double size;
  final double? iconSize;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(PkRadius.control),
      border: Border.all(color: color.withValues(alpha: .12)),
    ),
    child: Icon(
      icon,
      color: color,
      size: iconSize ?? (size >= PkSize.iconTileFeature ? 22 : PkSize.icon),
    ),
  );
}

/// Whether balances are masked, and what the mask must not give away.
///
/// Section 2.4 and 5.9: privacy mode preserves the layout when balances are
/// hidden, and a hidden balance announces "Balance hidden" rather than reading
/// out its own bullets.
class PkPrivacy extends InheritedWidget {
  const PkPrivacy({super.key, required this.hidden, required super.child});

  final bool hidden;

  static bool of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PkPrivacy>()?.hidden ?? false;

  @override
  bool updateShouldNotify(PkPrivacy oldWidget) => hidden != oldWidget.hidden;
}

class PkAmountText extends StatelessWidget {
  const PkAmountText({
    super.key,
    required this.amountMinor,
    required this.currency,
    this.style,
    this.signed = false,
    this.color,
    this.maskable = true,
  });
  final int amountMinor;
  final String currency;
  final TextStyle? style;
  final bool signed;
  final Color? color;

  /// False for a figure that is not a balance — a percentage, a limit being
  /// entered — which privacy mode has no reason to hide.
  final bool maskable;

  @override
  Widget build(BuildContext context) {
    final text = PkFormat.money(amountMinor, currency, sign: signed);
    final resolved = (style ?? context.pkText.moneyRow).copyWith(
      color: color,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    if (!maskable || !PkPrivacy.of(context)) {
      return Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: resolved,
      );
    }
    // The mask is the same string rendered as bullets, so the row keeps the
    // width it had and nothing reflows when privacy is switched on.
    return Semantics(
      label: context.t.balanceHidden,
      excludeSemantics: true,
      child: Text(
        text.replaceAll(RegExp(r'[0-9]'), '•'),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: resolved,
      ),
    );
  }
}

class PkProgressBar extends StatelessWidget {
  const PkProgressBar({
    super.key,
    required this.value,
    this.color,
    this.height = 8,
  });
  final double value;
  final Color? color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(PkRadius.full),
    child: TweenAnimationBuilder<double>(
      duration: PkMotion.slow,
      curve: PkMotion.enter,
      tween: Tween(begin: 0, end: value.clamp(0, 1)),
      builder: (context, animated, _) => LinearProgressIndicator(
        value: animated,
        minHeight: height,
        backgroundColor: context.pk.sunken,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

/// A shared balance, with its direction said in words as well as colour.
///
/// Section 9.5 forbids colour as the only carrier of amount direction; this
/// component is the pattern the rest of the app follows.
class PkBalanceLabel extends StatelessWidget {
  const PkBalanceLabel({
    super.key,
    required this.amountMinor,
    required this.currency,
    this.compact = false,
  });
  final int amountMinor;
  final String currency;
  final bool compact;

  /// The same meaning as a sentence, for a composed row announcement.
  static String announce(
    BuildContext context,
    int amountMinor,
    String currency,
  ) => amountMinor == 0
      ? context.t.settled
      : '${amountMinor > 0 ? context.t.youReOwed : context.t.youOwe} '
            '${PkFormat.money(amountMinor.abs(), currency)}';

  @override
  Widget build(BuildContext context) {
    final settled = amountMinor == 0;
    final owed = amountMinor > 0;
    final color = settled
        ? context.pk.textTertiary
        : owed
        ? context.pk.owed
        : context.pk.owing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        PkAmountText(
          amountMinor: amountMinor.abs(),
          currency: currency,
          color: color,
          style: compact
              ? context.pkText.moneyRow
              : context.pkText.moneySection,
        ),
        Text(
          settled
              ? context.t.settled
              : owed
              ? context.t.youReOwed
              : context.t.youOwe,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.pkText.supporting.copyWith(color: color),
        ),
      ],
    );
  }
}

class PkShareRule extends StatelessWidget {
  const PkShareRule({super.key, required this.fraction, this.width = 64});
  final double fraction;
  final double width;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: LinearProgressIndicator(
        value: fraction.clamp(.04, 1),
        minHeight: 2,
        backgroundColor: context.pk.borderSubtle,
        color: context.pk.shared,
      ),
    ),
  );
}

/// An account in a list.
///
/// Section 6.7: the default rendering is a grouped row, not one card per
/// object. Metadata order is fixed at type · currency · default so the eye
/// learns one shape.
class PkAccountTile extends StatelessWidget {
  const PkAccountTile({
    super.key,
    required this.account,
    required this.balanceMinor,
    required this.onTap,
    this.compact = false,
    this.equivalentMinor,
    this.equivalentCurrency,
  });
  final Account account;
  final int balanceMinor;
  final VoidCallback onTap;

  /// The horizontally scrolling card used in Home's account strip. Section 4.4
  /// keeps a card here because it participates in horizontal scrolling.
  final bool compact;
  final int? equivalentMinor;
  final String? equivalentCurrency;

  @override
  Widget build(BuildContext context) {
    final color = PkPalette.categoryAt(account.colorIndex);
    if (compact) {
      return PkCard(
        variant: PkCardVariant.dense,
        onTap: onTap,
        child: SizedBox(
          width: 108,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.pkText.supporting,
              ),
              const SizedBox(height: 2),
              PkAmountText(
                amountMinor: balanceMinor,
                currency: account.currency,
                style: context.pkText.moneyRow,
              ),
            ],
          ),
        ),
      );
    }
    final typeLabel = account.type.labelIn(context.t);
    return PkLedgerRow(
      semanticIdentifier: 'account_${account.id}',
      semanticLabel: [
        account.name,
        PkFormat.money(balanceMinor, account.currency),
        typeLabel,
        if (account.isDefault) context.t.defaultLabel,
      ].join(', '),
      leading: PkIconTile(icon: PkIcons.named(account.icon), color: color),
      title: account.name,
      badges: [
        if (account.isDefault)
          PkStatusBadge(label: context.t.defaultLabel, tone: PkStatusTone.info),
      ],
      subtitle: '$typeLabel · ${account.currency}',
      trailing: PkAmountText(
        amountMinor: balanceMinor,
        currency: account.currency,
        style: context.pkText.moneyRow,
      ),
      trailingSubtitle: equivalentMinor != null && equivalentCurrency != null
          // Section 5.7: a converted value never sits on the same visual tier
          // as the amount it converts.
          ? Text(
              '≈ ${PkFormat.money(equivalentMinor!, equivalentCurrency!)}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.pkText.supporting,
            )
          : null,
      showChevron: true,
      onTap: onTap,
    );
  }
}

/// A Space in a list. 72 px: type, currency and members all have to be
/// visible so two Spaces called "Household" can be told apart (P1-20).
class PkSpaceTile extends StatelessWidget {
  const PkSpaceTile({
    super.key,
    required this.space,
    required this.balanceMinor,
    required this.expenseCount,
    required this.onTap,
  });
  final SharedSpace space;
  final int balanceMinor;
  final int expenseCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = PkPalette.categoryAt(space.colorIndex);
    final subtitle =
        '${space.type.labelIn(context.t)} · ${space.currency} · '
        '${context.t.memberCountPlain(space.members.length)}';
    return PkLedgerRow(
      density: PkRowDensity.rich,
      semanticIdentifier: 'space_${space.id}',
      semanticLabel: [
        space.name,
        subtitle,
        PkBalanceLabel.announce(context, balanceMinor, space.currency),
      ].join(', '),
      leading: PkIconTile(icon: PkIcons.named(space.icon), color: color),
      title: space.name,
      subtitle: subtitle,
      trailing: PkBalanceLabel(
        amountMinor: balanceMinor,
        currency: space.currency,
        compact: true,
      ),
      showChevron: true,
      onTap: onTap,
    );
  }
}

/// The canonical ledger row, section 6.6.
///
/// Merchant left, amount right, one metadata line by default and a second only
/// when a share or a lifecycle state genuinely needs it. Transfer, settlement,
/// shared, pending, voided and OCR-review are variants of this row rather than
/// six different rows.
class PkTransactionTile extends StatelessWidget {
  const PkTransactionTile({
    super.key,
    required this.transaction,
    required this.repository,
    required this.onTap,
    this.showDate = true,
    this.onLongPress,
  });
  final MoneyTransaction transaction;
  final PockitoRepository repository;
  final VoidCallback onTap;

  /// False when the row sits under a day header that already says the date.
  /// Section 6.6: the date appears in the group header *or* the row, never
  /// both.
  final bool showDate;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final category = transaction.categoryId == null
        ? null
        : repository.categoryById(transaction.categoryId!);
    final accountId = transaction.fromAccountId ?? transaction.toAccountId;
    final account = accountId == null
        ? null
        : repository.accountById(accountId);
    final shared = transaction.splitId == null
        ? null
        : repository.sharedExpenseById(transaction.splitId!);
    final color = category == null
        ? PkPalette.slate500
        : PkPalette.categoryAt(category.colorIndex);
    final positive = transaction.type == MoneyEventType.income;
    final transfer =
        transaction.type == MoneyEventType.transfer ||
        transaction.type == MoneyEventType.settlement;
    final mine = shared?.shares
        .where((item) => item.userId == repository.currentUserId)
        .firstOrNull;
    final voided = transaction.status == RecordStatus.voided;
    final draft = transaction.status == RecordStatus.draft;

    final subtitle = [
      category?.name ??
          (transfer ? context.t.transfer : context.t.uncategorised),
      account?.name,
      if (shared != null)
        repository.spaceById(shared.spaceId)?.name ?? context.t.shared,
    ].whereType<String>().join(' · ');
    final amount = PkFormat.money(
      positive ? transaction.amountMinor : -transaction.amountMinor,
      transaction.currency,
      sign: positive,
    );
    final date = PkFormat.shortDate(
      transaction.occurredOn,
      repository.today,
      context.t,
    );

    return PkLedgerRow(
      // A shared row carries a second trailing line, so it earns 72 rather
      // than the 64 a simple event gets.
      density: mine != null || voided || draft
          ? PkRowDensity.rich
          : PkRowDensity.standard,
      semanticIdentifier: 'transaction_${transaction.id}',
      semanticLabel: [
        transaction.merchant,
        amount,
        date,
        subtitle,
        if (voided) context.t.statusVoided,
        if (draft) context.t.statusDraft,
      ].join(', '),
      leading: PkIconTile(
        icon: PkIcons.named(
          category?.icon ?? (transfer ? 'wallet' : 'receipt'),
        ),
        color: voided ? context.pk.textTertiary : color,
      ),
      title: transaction.merchant,
      struckThrough: voided,
      badges: [
        if (voided)
          PkStatusBadge(
            label: context.t.statusVoided,
            tone: PkStatusTone.danger,
            icon: Icons.block_rounded,
          )
        else if (draft)
          PkStatusBadge(
            label: context.t.statusDraft,
            tone: PkStatusTone.warning,
            icon: Icons.edit_note_rounded,
          ),
      ],
      subtitle: subtitle,
      trailing: PkAmountText(
        amountMinor: positive
            ? transaction.amountMinor
            : -transaction.amountMinor,
        currency: transaction.currency,
        signed: positive,
        style: context.pkText.moneyRow.copyWith(
          decoration: voided ? TextDecoration.lineThrough : null,
          color: voided ? context.pk.textTertiary : null,
        ),
      ),
      trailingSubtitle: mine != null
          ? Text(
              context.t.yourShareX0(
                PkFormat.money(mine.amountMinor, shared!.currency),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.pkText.supporting,
            )
          : showDate
          ? Text(date, style: context.pkText.supporting)
          : null,
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}

class PkBudgetTile extends StatelessWidget {
  const PkBudgetTile({super.key, required this.snapshot, required this.onTap});
  final BudgetSnapshot snapshot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isSpace = snapshot.budget.scope == BudgetScope.space;
    final barColor = switch (snapshot.health) {
      BudgetHealth.exceeded => context.pk.danger,
      BudgetHealth.near => context.pk.shared,
      BudgetHealth.healthy =>
        isSpace ? context.pk.shared : Theme.of(context).colorScheme.primary,
    };
    final remaining = snapshot.health == BudgetHealth.exceeded
        ? context.t.x0Over(
            PkFormat.money(
              snapshot.remainingMinor.abs(),
              snapshot.budget.currency,
            ),
          )
        : context.t.x0Left(
            PkFormat.money(snapshot.remainingMinor, snapshot.budget.currency),
          );
    final usage = context.t.x0OfX1X2(
      PkFormat.money(snapshot.usedMinor, snapshot.budget.currency),
      PkFormat.money(snapshot.budget.limitMinor, snapshot.budget.currency),
      snapshot.window.label,
    );
    // Section 7.13: a budget row is 72–80 because it carries name, scope,
    // used/limit, remaining and progress. It is the clearest case in the app
    // of a row that has genuinely earned its height.
    return PkLedgerRow(
      density: PkRowDensity.status,
      semanticIdentifier: 'budget_${snapshot.budget.id}',
      semanticLabel: [
        snapshot.budget.name,
        if (isSpace) context.t.shared,
        usage,
        remaining,
        context.t.percentOfUsed(
          (snapshot.progress * 100).round(),
          snapshot.budget.name,
        ),
      ].join(', '),
      title: snapshot.budget.name,
      badges: [
        if (isSpace)
          PkStatusBadge(
            label: context.t.shared,
            tone: PkStatusTone.shared,
            icon: Icons.group_rounded,
          ),
      ],
      subtitle: usage,
      trailing: Text(
        remaining,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.pkText.label.copyWith(
          color: snapshot.health == BudgetHealth.exceeded
              ? context.pk.danger
              : context.pk.textSecondary,
        ),
      ),
      showChevron: true,
      onTap: onTap,
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Section 5.9: a progress bar exposes label, value, maximum and
          // status, so the bar is never the only place the number lives.
          Semantics(
            label: context.t.percentOfUsed(
              (snapshot.progress * 100).round(),
              snapshot.budget.name,
            ),
            value: '${(snapshot.progress * 100).round()}%',
            child: PkProgressBar(
              value: snapshot.progress,
              color: barColor,
              height: 6,
            ),
          ),
          if (snapshot.previousUsedMinor != null) ...[
            const SizedBox(height: PkSpacing.x2),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: PkComparisonLabel(
                comparison: PeriodComparison(
                  currentMinor: snapshot.usedMinor,
                  previousMinor: snapshot.previousUsedMinor!,
                  currency: snapshot.budget.currency,
                  previousLabel: context.t.lastX0(snapshot.budget.period.noun),
                ),
                compact: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty, first-use and recoverable-error states, section 6.13.
///
/// `full` takes the screen when the whole route has nothing to show. `section`
/// stays under 120 px and is what a single failed or empty section inside an
/// otherwise working screen uses — section 9.7 requires a state to occupy only
/// the scope that actually failed.
class PkEmptyState extends StatelessWidget {
  const PkEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.mascot,
  }) : compact = false;

  /// The inline variant: no more than 120 px tall, Kito at 48–64.
  const PkEmptyState.section({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.mascot,
  }) : compact = true;

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final KitoAsset? mascot;
  final bool compact;

  /// Pose for the state, following `docs/kito-mascot-guide.md`.
  ///
  /// A recoverable error must not be illustrated with the optimistic
  /// empty-wallet pose, and a finished settlement must not look like an
  /// unfinished one, so the recognised icons map to their real meaning and
  /// anything unknown falls back to the neutral empty pose.
  @visibleForTesting
  KitoAsset get debugResolvedMascot => _resolvedMascot;

  KitoAsset get _resolvedMascot {
    if (mascot != null) return mascot!;
    return switch (icon) {
      Icons.notifications_none_rounded ||
      Icons.notifications_off_outlined => KitoAsset.sleeping,
      Icons.sync_problem_rounded ||
      Icons.error_outline_rounded ||
      Icons.cloud_off_outlined ||
      Icons.group_off_outlined ||
      Icons.link_off_rounded ||
      Icons.map_outlined => KitoAsset.confused,
      Icons.group_add_outlined ||
      Icons.group_outlined ||
      Icons.person_add_alt_outlined => KitoAsset.sharedSpace,
      Icons.check_circle_outline_rounded => KitoAsset.celebrating,
      Icons.auto_awesome_outlined => KitoAsset.thinking,
      _ => KitoAsset.empty,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PkSpacing.x4,
          vertical: PkSpacing.x4,
        ),
        child: Row(
          children: [
            KitoImage.sized(asset: _resolvedMascot, size: KitoSize.inline),
            const SizedBox(width: PkSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: context.pkText.rowTitle),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.pkText.supporting,
                  ),
                  if (actionLabel != null)
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: onAction,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(PkSize.touch, PkSize.touch),
                        ),
                        child: Text(actionLabel!),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    // Section 4.5: a full-screen empty state gets 88–112 px of Kito, and on a
    // short screen the mascot compacts before the copy does.
    final art = context.isShort ? 88.0 : 112.0;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: PkSpacing.x6,
        vertical: PkSpacing.stateGroup,
      ),
      // Section 7.22 and 9.5: at 2.0x text a full-screen state can be taller
      // than the viewport it occupies, so it scrolls rather than clipping the
      // recovery action off the bottom.
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: PkBreakpoints.readingMaxWidth,
            ),
            child: KitoReveal(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  KitoImage(asset: _resolvedMascot, width: art, height: art),
                  const SizedBox(height: PkSpacing.x3),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.pkText.sectionTitle,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: context.pkText.body.copyWith(
                      color: context.pk.textSecondary,
                    ),
                  ),
                  if (actionLabel != null) ...[
                    const SizedBox(height: PkSpacing.section),
                    FilledButton(
                      onPressed: onAction,
                      child: Text(actionLabel!),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PkSkeleton extends StatefulWidget {
  const PkSkeleton({
    super.key,
    this.height = 64,
    this.width,
    this.radius = PkRadius.card,
  });
  final double height;

  /// Null stretches to the available width, which is what a full-width block
  /// placeholder wants. A row-shaped placeholder gives its own.
  final double? width;
  final double radius;

  @override
  State<PkSkeleton> createState() => _PkSkeletonState();
}

class _PkSkeletonState extends State<PkSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Section 9.5: reduced motion removes the movement, not merely its
    // appearance. The shimmer used to keep a ticker running on every skeleton
    // for a reader who had asked for no animation — invisible, but still a
    // frame callback per skeleton per frame, and a ticker alive at teardown.
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduced && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: context.pk.sunken,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1.5 + _controller.value * 3, 0),
            end: Alignment(-.5 + _controller.value * 3, 0),
            colors: [
              context.pk.sunken,
              context.pk.borderSubtle,
              context.pk.sunken,
            ],
          ),
        ),
      ),
    );
  }
}

class PkOfflineBanner extends StatelessWidget {
  const PkOfflineBanner({super.key, this.onRetry});
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Container(
    color: context.pk.sharedSurface,
    padding: const EdgeInsets.symmetric(
      horizontal: PkSpacing.x4,
      vertical: PkSpacing.x3,
    ),
    child: Row(
      children: [
        Icon(
          Icons.cloud_off_outlined,
          size: 20,
          color: context.pk.sharedStrong,
        ),
        const SizedBox(width: PkSpacing.x2),
        Expanded(
          child: Text(
            context.t.offlineChangesStayOnThis,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.pk.sharedStrong),
          ),
        ),
        if (onRetry != null)
          TextButton(onPressed: onRetry, child: Text(context.t.retry)),
      ],
    ),
  );
}

Future<bool?> showPkNotificationPrePrompt(BuildContext context) =>
    showPkSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x5,
            PkSpacing.x2,
            PkSpacing.x5,
            PkSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.center,
                child: KitoImage(
                  asset: KitoAsset.avatar,
                  width: 84,
                  height: 84,
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              Text(
                context.t.stayInTheLoop,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                context.t.getNotifiedWhenSomeoneAdds,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.pk.textSecondary,
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              _NotificationExample(
                icon: Icons.receipt_long_outlined,
                text: context.t.miraAddedGroceries,
              ),
              _NotificationExample(
                icon: Icons.handshake_outlined,
                text: context.t.miraSaysShePaidYou,
              ),
              _NotificationExample(
                icon: Icons.donut_large_rounded,
                text: context.t.youVeUsedOfGroceries,
              ),
              const SizedBox(height: PkSpacing.x5),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.t.turnOnNotifications),
              ),
              const SizedBox(height: PkSpacing.x2),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.t.notNow),
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                context.t.prototypeOnlyNoSystemPermission,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
    );

class _NotificationExample extends StatelessWidget {
  const _NotificationExample({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x2),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: PkSpacing.x3),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
