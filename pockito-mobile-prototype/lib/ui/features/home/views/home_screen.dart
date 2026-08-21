import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final accounts = repo.accounts.where((item) => !item.archived).toList();
    final spaces = repo.spaces
        .where((item) => item.status == SpaceStatus.active)
        .toList();
    final budgets = repo.budgets.map(repo.budgetSnapshot).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    final upcoming =
        repo.subscriptions
            .where(
              (item) =>
                  item.status == SubscriptionStatus.active &&
                  item.nextDueOn != null,
            )
            .toList()
          ..sort((a, b) => a.nextDueOn!.compareTo(b.nextDueOn!));
    final recent = repo.transactions.take(5).toList();
    final actions = repo.actionItems();
    final debts = repo.debtEdges();
    final comparison = repo.spendingComparison(viewModel.selectedMonth);
    // Four is the number of categories that can be told apart by colour on
    // both surfaces; the rest fold into one neutral slice.
    final breakdown = repo.categoryBreakdown(
      viewModel.selectedMonth,
      limit: PkChartPalette.maxSeries,
    );
    final done = repo.profile.completedSetupSteps;
    final setupSteps = [
      PkSetupStep(
        id: 'profile',
        label: context.t.setupStepProfile,
        done: done.contains('profile'),
        onTap: () => context.push('/settings/profile'),
      ),
      PkSetupStep(
        id: 'account',
        label: context.t.setupStepAccount,
        done: done.contains('account') || accounts.isNotEmpty,
        onTap: () => context.push('/accounts/new'),
      ),
      PkSetupStep(
        id: 'transaction',
        label: context.t.setupStepTransaction,
        done: done.contains('transaction') || repo.transactions.isNotEmpty,
        onTap: () => context.push('/add'),
      ),
      PkSetupStep(
        id: 'space',
        label: context.t.setupStepSpace,
        done: done.contains('space') || spaces.isNotEmpty,
        onTap: () => context.push('/spaces/new'),
      ),
      PkSetupStep(
        id: 'budget',
        label: context.t.setupStepBudget,
        done: done.contains('budget') || repo.budgets.isNotEmpty,
        onTap: () => context.push('/budgets/new'),
      ),
    ];
    // Whether the reader is still setting Pockito up, which is what the
    // checklist is for. It disappears once every step is done.
    final firstUse =
        setupSteps.any((step) => !step.done) &&
        !repo.profile.setupChecklistDismissed;
    final attentionBudget = budgets
        .where((item) => item.health != BudgetHealth.healthy)
        .firstOrNull;
    final kitoInsight = attentionBudget == null
        ? context.t.yourSpendingIsSteadyShared
        : attentionBudget.health == BudgetHealth.exceeded
        ? context.t.isOverItsLimitYour(attentionBudget.budget.name)
        : context.t.isGettingCloseToIts(attentionBudget.budget.name);

    if (viewModel.prototypeState == PrototypeState.loading) {
      return const _HomeLoading();
    }
    if (viewModel.prototypeState == PrototypeState.empty) {
      return const _HomeEmpty();
    }
    if (viewModel.prototypeState == PrototypeState.error) {
      return PkPage(
        slivers: [
          const _HomeBrandHeader(),
          SliverToBoxAdapter(
            child: PkEmptyState(
              icon: Icons.sync_problem_rounded,
              title: context.t.weCouldNotRefreshYour,
              message: context.t.yourLocalDataIsSafe,
              actionLabel: context.t.actionRetry,
              onAction: viewModel.simulateRefresh,
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        if (viewModel.prototypeState == PrototypeState.offline)
          PkOfflineBanner(
            onRetry: () => viewModel.setPrototypeState(PrototypeState.ready),
          ),
        Expanded(
          child: PkPage(
            // Section 7.24: Home is a dashboard, so it is allowed the wider
            // measure — but only because its content reflows into columns
            // rather than stretching.
            width: PkPageWidth.dashboard,
            refresh: viewModel.simulateRefresh,
            slivers: [
              const _HomeBrandHeader(),
              // Kito's greeting opens Home every visit: it is the app saying
              // hello by name, which is the warmth the product is for.
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  context.gutter,
                  PkSpacing.x3,
                  context.gutter,
                  PkSpacing.x4,
                ),
                sliver: SliverToBoxAdapter(
                  child: PkWelcomeBanner(
                    // The greeting is about the reader's day, so it follows
                    // the real clock rather than the fixture's ledger date.
                    greeting: pkGreeting(DateTime.now(), context.t),
                    name: repo.profile.displayName,
                    date: pkLongDate(DateTime.now(), context.t.localeName),
                  ),
                ),
              ),
              // A fast way to start something, right where the greeting
              // leaves off — before the numbers, not after them.
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  context.gutter,
                  0,
                  context.gutter,
                  PkSpacing.x4,
                ),
                sliver: SliverToBoxAdapter(
                  child: PkQuickActions(
                    actions: [
                      PkQuickAction(
                        id: 'scan',
                        icon: Icons.document_scanner_outlined,
                        label: context.t.quickScanReceipt,
                        onTap: () => context.push('/add?scan=1'),
                      ),
                      if (spaces.isNotEmpty)
                        PkQuickAction(
                          id: 'shared',
                          // Distinct from the Spaces navigation icon: this is
                          // about splitting one expense, not about the
                          // destination.
                          icon: Icons.call_split_rounded,
                          label: context.t.quickSharedExpense,
                          onTap: () =>
                              context.push('/add?space=${spaces.first.id}'),
                        ),
                      if (debts.isNotEmpty)
                        PkQuickAction(
                          id: 'settle',
                          icon: Icons.handshake_outlined,
                          label: context.t.quickSettleUp,
                          onTap: () => context.push(
                            '/spaces/${debts.first.spaceId}/settle',
                          ),
                        ),
                      PkQuickAction(
                        id: 'income',
                        icon: Icons.south_west_rounded,
                        label: context.t.quickRecordIncome,
                        onTap: () => context.push('/add?type=income'),
                      ),
                      PkQuickAction(
                        id: 'budget',
                        icon: Icons.donut_large_rounded,
                        label: context.t.quickNewBudget,
                        onTap: () => context.push('/budgets/new'),
                      ),
                    ],
                  ),
                ),
              ),
              // Everything waiting on the user, ranked, above every passive
              // summary — including the hero. An AI connection request is
              // rarer and less urgent than an unsettled balance or a pending
              // invite, and none of them should sit below net worth.
              if (actions.isNotEmpty)
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    context.gutter,
                    0,
                    context.gutter,
                    PkSpacing.x3,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _ActionRequiredBlock(items: actions),
                  ),
                ),
              // The one dominant element: the primary financial answer.
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  context.gutter,
                  0,
                  context.gutter,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: _HeroCard(
                    month: viewModel.selectedMonth,
                    onMonthTap: () => _pickMonth(context),
                    onNetWorthTap: () => context.push('/home/net-worth'),
                  ),
                ),
              ),
              // A new user lands on a page of zeroes with no idea which of
              // six things to do first. This names them in order and
              // disappears once they are done.
              if (firstUse)
                SliverPadding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    context.gutter,
                    PkSpacing.x3,
                    context.gutter,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: PkSetupChecklist(
                      steps: setupSteps,
                      onDismiss: () => repo.saveProfile(
                        repo.profile.copyWith(setupChecklistDismissed: true),
                      ),
                    ),
                  ),
                ),
              // Section 7.1 and 7.24: one full-width hero, then the
              // remaining blocks in one column on a phone and two on
              // anything wider.
              _HomeSections(
                sections: [
                  // UI-020 §5, progressive disclosure. These four used to be
                  // four section headers, four cards and two charts — roughly
                  // 224 px of chrome before the first number, in the part of
                  // the screen competing with the hero. They are now four
                  // 56 px rows in one surface: the same height, four answers
                  // instead of four headings, and four "See all" buttons that
                  // no longer need to exist because the whole row is the way
                  // in. "Who owes whom" and "Budgets" stay full below, because
                  // those are the two a reader acts on rather than reads.
                  _HomeSection(
                    top: PkSpacing.section,
                    child: PkGroupedSurface(
                      children: [
                        PkLedgerRow.management(
                          key: const ValueKey('home_accounts_row'),
                          leading: const PkIconTile(
                            icon: Icons.account_balance_wallet_outlined,
                            accent: PkPalette.brand,
                            size: PkSize.iconTileDense,
                          ),
                          title: context.t.homeAccounts,
                          subtitle: context.t.homeAccountsSummary(
                            PkFormat.money(
                              repo.netWorthMinor(
                                repo.profile.reportingCurrency,
                              ),
                              repo.profile.reportingCurrency,
                            ),
                            accounts.length,
                          ),
                          showChevron: true,
                          onTap: () => context.go('/accounts'),
                        ),
                        PkLedgerRow.management(
                          key: const ValueKey('home_upcoming_row'),
                          leading: const PkIconTile(
                            icon: Icons.event_repeat_outlined,
                            accent: PkPalette.brand,
                            size: PkSize.iconTileDense,
                          ),
                          title: context.t.homeUpcoming,
                          subtitle: upcoming.isEmpty
                              ? context.t.homeUpcomingNone
                              : context.t.homeUpcomingSummary(
                                  PkFormat.money(
                                    upcoming.fold<int>(
                                      0,
                                      (sum, item) => sum + item.amountMinor,
                                    ),
                                    upcoming.first.currency,
                                  ),
                                ),
                          showChevron: true,
                          onTap: () => context.push('/subscriptions'),
                        ),
                        PkLedgerRow.management(
                          key: const ValueKey('home_trend_row'),
                          leading: const PkIconTile(
                            icon: Icons.show_chart_rounded,
                            accent: PkPalette.brand,
                            size: PkSize.iconTileDense,
                          ),
                          title: context.t.homeSpendingTrend,
                          subtitle: pkComparisonReading(comparison, context.t),
                          showChevron: true,
                          onTap: () => context.push('/home/insights'),
                        ),
                        PkLedgerRow.management(
                          key: const ValueKey('home_breakdown_row'),
                          leading: const PkIconTile(
                            icon: Icons.donut_small_rounded,
                            accent: PkPalette.brand,
                            size: PkSize.iconTileDense,
                          ),
                          title: context.t.homeWhereItWent,
                          subtitle: breakdown.isEmpty
                              ? context.t.homeNothingSpentYet
                              : context.t.homeWhereItWentSummary(
                                  PkFormat.money(
                                    breakdown.first.valueMinor,
                                    repo.profile.reportingCurrency,
                                  ),
                                  breakdown.first.label,
                                ),
                          showChevron: true,
                          onTap: () => context.push('/home/insights'),
                        ),
                      ],
                    ),
                  ),
                  // The Spaces tab already leads with the same two totals, so
                  // repeating them here bought nothing. What that tab does *not*
                  // show at a glance is who actually owes whom.
                  _HomeSection(
                    header: PkSectionHeader(
                      title: context.t.homeWhoOwesWhom,
                      actionLabel: context.t.homeSeeAll,
                      onAction: () => context.go('/spaces'),
                    ),
                    child: debts.isEmpty
                        ? PkCard(
                            variant: PkCardVariant.dense,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  size: PkSize.icon,
                                  color: context.pk.success,
                                ),
                                const SizedBox(width: PkSpacing.x3),
                                Expanded(
                                  child: Text(
                                    spaces.isEmpty
                                        ? context.t.homeNoSpacesYet
                                        : context.t.homeEveryoneSettled,
                                    style: context.pkText.body,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : PkGroupedSurface(
                            children: [
                              for (final edge in debts.take(3))
                                _DebtRow(edge: edge),
                            ],
                          ),
                  ),
                  _HomeSection(
                    header: PkSectionHeader(
                      title: context.t.homeBudgets,
                      actionLabel: context.t.homeSeeAll,
                      onAction: () => context.push('/budgets'),
                    ),
                    child: PkGroupedSurface(
                      children: [
                        for (final snapshot in budgets.take(2))
                          PkBudgetTile(
                            snapshot: snapshot,
                            onTap: () =>
                                context.push('/budgets/${snapshot.budget.id}'),
                          ),
                      ],
                    ),
                  ),
                  // Section 7.1: Kito's reading of the month sits *below* the
                  // finance content it is commenting on, and stays compact
                  // unless the insight is urgent.
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: PkSpacing.section,
                    ),
                    child: KitoInsightCard(
                      message: kitoInsight,
                      // Thinking for an observation, concern for a budget that
                      // needs attention, with the surface tone to match.
                      asset: attentionBudget == null
                          ? KitoAsset.thinking
                          : KitoAsset.concerned,
                      tone: switch (attentionBudget?.health) {
                        null => KitoMessageTone.brand,
                        BudgetHealth.exceeded => KitoMessageTone.danger,
                        _ => KitoMessageTone.warning,
                      },
                      onTap: () => context.push(
                        attentionBudget == null
                            ? '/activity'
                            : '/budgets/${attentionBudget.budget.id}',
                      ),
                    ),
                  ),
                  // Cash flow, savings rate and what is still committed, behind
                  // one tap so Home stays calm for people who only wanted the
                  // headline.
                  _HomeSection(
                    header: PkSectionHeader(
                      title: context.t.homeThisMonthInFull,
                    ),
                    child: _FinancialHealthPanel(
                      health: repo.financialHealth(viewModel.selectedMonth),
                    ),
                  ),
                  _HomeSection(
                    header: PkSectionHeader(
                      title: context.t.homeRecent,
                      actionLabel: context.t.homeSeeAll,
                      onAction: () => context.push('/activity'),
                    ),
                    child: PkGroupedSurface(
                      indent:
                          PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                      children: [
                        for (final transaction in recent)
                          PkTransactionTile(
                            transaction: transaction,
                            repository: repo,
                            onTap: () =>
                                context.push('/activity/${transaction.id}'),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickMonth(BuildContext context) async {
    final viewModel = context.read<PockitoAppViewModel>();
    final selected = await showPkSheet<DateTime>(
      context,
      size: PkSheetSize.compact,
      builder: (context) => _MonthPicker(selected: viewModel.selectedMonth),
    );
    if (selected != null) viewModel.selectMonth(selected);
  }
}

/// Brand row at the very top of Home: the lockup, then the three actions.
class _HomeBrandHeader extends StatelessWidget {
  const _HomeBrandHeader();

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    // UI-020 §5: the wordmark and its three actions used to hold 76 px of
    // permanent height at the very top of a screen whose whole problem was
    // that the reader's own money started below the fold. Floating costs
    // nothing — the header is there on arrival, leaves as the reader scrolls
    // into the ledger, and snaps back on any upward flick, which is where a
    // reader reaches for search or notifications anyway.
    return SliverAppBar(
      floating: true,
      snap: true,
      automaticallyImplyLeading: false,
      backgroundColor: context.pk.page,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: PkSize.touch + PkSpacing.x3,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: PkSpacing.screen,
        ),
        child: Row(
          children: [
            // The actions have a fixed footprint; the lockup takes what is
            // left and scales down on very narrow screens.
            const Flexible(
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: PkWordmark(),
              ),
            ),
            const SizedBox(width: PkSpacing.x2),
            PkIconAction(
              key: const ValueKey('open_search'),
              icon: Icons.search_rounded,
              tooltip: context.t.actionSearch,
              // Search looks across everything — accounts, Spaces, categories,
              // budgets and activity — rather than standing in for Activity.
              size: _HomeAvatarAction.headerActionSize,
              onPressed: () => context.push('/search'),
            ),
            PkIconAction(
              key: const ValueKey('open_assistant'),
              icon: Icons.auto_awesome_rounded,
              tooltip: context.t.assistant,
              color: Theme.of(context).colorScheme.primary,
              size: _HomeAvatarAction.headerActionSize,
              onPressed: () => context.push('/ai'),
            ),
            PkIconAction(
              icon: Icons.notifications_none_rounded,
              tooltip: context.t.notifications,
              showBadge: repo.notifications.any((item) => !item.read),
              size: _HomeAvatarAction.headerActionSize,
              onPressed: () => context.push('/notifications'),
            ),
            _HomeAvatarAction(
              displayName: repo.profile.displayName,
              onPressed: () => context.push('/settings/profile'),
            ),
          ],
        ),
      ),
    );
  }
}

/// The reader's avatar, sized to match the other header actions so the whole
/// row reads as one height.
class _HomeAvatarAction extends StatelessWidget {
  const _HomeAvatarAction({required this.displayName, required this.onPressed});

  final String displayName;
  final VoidCallback onPressed;

  /// Glyph size shared with the search, assistant and notifications actions.
  /// Smaller than [PkWordmark.defaultHeight] so the row doesn't compete with
  /// the lockup for visual weight.
  static const double headerActionSize = 26;

  /// Matches [PkWordmark.defaultHeight] so the avatar stands as tall as the
  /// lockup at the other end of the row.
  static const double _avatarSize = PkWordmark.defaultHeight;

  /// Matches the inset the neighbouring [PkIconAction]s use, so the avatar
  /// sits as close to the bell as the icons sit to each other.
  static const double _inset = PkSpacing.x2;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: displayName,
    child: Semantics(
      button: true,
      label: displayName,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onPressed,
        radius: (_avatarSize + PkSpacing.x2) / 2,
        containedInkWell: false,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(_inset),
          child: PkAvatar(
            label: displayName.characters.first,
            size: _avatarSize,
          ),
        ),
      ),
    ),
  );
}

class _HomeEmpty extends StatelessWidget {
  const _HomeEmpty();

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    return PkPage(
      slivers: [
        const _HomeBrandHeader(),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            PkSpacing.x3,
            PkSpacing.screen,
            PkSpacing.x5,
          ),
          sliver: SliverToBoxAdapter(
            child: PkWelcomeBanner(
              greeting: pkGreeting(DateTime.now(), context.t),
              name: repo.profile.displayName,
              date: pkLongDate(DateTime.now(), context.t.localeName),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            0,
            PkSpacing.screen,
            PkSpacing.x6,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.t.yourMoneyFinallyInOne,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: PkSpacing.x2),
                Text(
                  context.t.addAnAccountToTrack,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.t.chooseWhereToBegin,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: PkSpacing.x3),
                _EmptySetupCard(
                  icon: Icons.account_balance_wallet_outlined,
                  title: context.t.setupStepAccount,
                  message: context.t.seeBalancesActivityAndNet,
                  actionLabel: context.t.addAccount,
                  onTap: () => context.push('/accounts/new'),
                ),
                const SizedBox(height: PkSpacing.x3),
                _EmptySetupCard(
                  icon: Icons.group_outlined,
                  title: context.t.createASharedSpace,
                  message: context.t.splitAHomeTripOr,
                  actionLabel: context.t.createSpace,
                  onTap: () => context.push('/spaces/new'),
                ),
                const SizedBox(height: PkSpacing.x6),
                TextButton(
                  onPressed: () => context
                      .read<PockitoAppViewModel>()
                      .setPrototypeState(PrototypeState.ready),
                  child: Text(context.t.exploreWithSampleData),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptySetupCard extends StatelessWidget {
  const _EmptySetupCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => PkCard(
    onTap: onTap,
    child: Row(
      children: [
        PkIconTile(
          icon: icon,
          accent: PkAccent.ink(Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: PkSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 3),
              Text(
                message,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: context.pk.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: PkSpacing.x2),
        Text(
          actionLabel,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    ),
  );
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.month,
    required this.onMonthTap,
    required this.onNetWorthTap,
  });
  final DateTime month;
  final VoidCallback onMonthTap;
  final VoidCallback onNetWorthTap;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final summary = repo.spendingForMonth(month);
    final netWorth = repo.netWorthMinor(repo.profile.reportingCurrency);
    final spentComparison = repo.spendingComparison(month);
    final previous = repo.spendingForMonth(
      DateTime(month.year, month.month - 1),
    );
    // Income names its real sources rather than asserting two that may not
    // exist in this month's data.
    final incomeSources = repo.categories
        .where(
          (category) =>
              category.type == CategoryType.income &&
              repo.transactions.any(
                (item) =>
                    item.categoryId == category.id &&
                    item.type == MoneyEventType.income &&
                    item.occurredOn.year == month.year &&
                    item.occurredOn.month == month.month,
              ),
        )
        .map((category) => category.name)
        .toList();
    final accountCount = repo.accounts.where((item) => !item.archived).length;
    return PkHeroPanel(
      // Section 7.1 budgets this hero at 148–168. The label, the amount and the
      // month control share one row rather than stacking into three, which is
      // what buys the room for the comparison P0-12 requires without pushing
      // the first data section below the fold. UI-020 brings the padding down
      // one step as well: at 16 the panel measured 181, and the 13 px over
      // budget were the difference between the account strip clearing the
      // navigation and sitting under it.
      padding: const EdgeInsets.all(PkSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Semantics(
                  button: true,
                  label:
                      '${context.t.homeNetWorth}, '
                      '${PkFormat.money(netWorth, repo.profile.reportingCurrency)}, '
                      '${context.t.acrossAccounts(accountCount, repo.profile.reportingCurrency)}',
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: onNetWorthTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.t.homeNetWorth,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.pkText.label.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        // Section 5.1: the one `pkMoneyHero` value on the
                        // screen, down from the 40 px that made every routine
                        // balance shout.
                        PkAmountText(
                          amountMinor: netWorth,
                          currency: repo.profile.reportingCurrency,
                          style: context.pkText.moneyHero.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: PkSpacing.x2),
              // The month control is a 34-high chip inside a 48 target, per
              // section 6.10, rather than exposing its whole target as chrome.
              Semantics(
                button: true,
                label: DateFormat('MMMM').format(month),
                excludeSemantics: true,
                child: InkWell(
                  onTap: onMonthTap,
                  borderRadius: BorderRadius.circular(PkRadius.full),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: PkSize.touch,
                      minWidth: PkSize.touch,
                    ),
                    child: Center(
                      widthFactor: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PkSpacing.x3,
                          vertical: 6,
                        ),
                        // A white wash on the hero *lightens* the background
                        // under a white label: at 14% the month control
                        // measured 4.39:1, under the 4.5 a 12 px word needs.
                        // Scrimming darker raises it to about 7:1, and the
                        // hairline keeps the pill's edge readable.
                        decoration: BoxDecoration(
                          color: PkPalette.kitoNavy900.withValues(alpha: .22),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: .28),
                          ),
                          borderRadius: BorderRadius.circular(PkRadius.full),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                DateFormat('MMMM').format(month),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.pkText.label.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white,
                              size: PkSize.iconSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.x1),
          Divider(height: 1, color: Colors.white.withValues(alpha: .16)),
          const SizedBox(height: PkSpacing.x1),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _HeroMetric(
                  label: context.t.homeSpent,
                  amount: PkFormat.money(summary.spentMinor, summary.currency),
                  note: summary.outflowMinor == 0
                      ? context.t.nothingLeftYourAccounts
                      : context.t.ofThatLeftYourAccounts(
                          (summary.spentMinor / summary.outflowMinor * 100)
                              .round(),
                          PkFormat.money(
                            summary.outflowMinor,
                            summary.currency,
                          ),
                        ),
                  // Without a baseline this figure carries no judgement.
                  comparison: spentComparison,
                ),
              ),
              const SizedBox(width: PkSpacing.x5),
              Expanded(
                child: _HeroMetric(
                  label: context.t.homeIn,
                  amount: PkFormat.money(summary.incomeMinor, summary.currency),
                  note: incomeSources.isEmpty
                      ? context.t.nothingCameInThisMonth
                      : incomeSources.take(3).join(context.t.and),
                  comparison: PeriodComparison(
                    currentMinor: summary.incomeMinor,
                    previousMinor: previous.incomeMinor,
                    currency: summary.currency,
                    previousLabel: spentComparison.previousLabel,
                  ),
                  upIsBad: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.amount,
    required this.note,
    this.comparison,
    this.upIsBad = true,
  });
  final String label;
  final String amount;
  final String note;
  final PeriodComparison? comparison;
  final bool upIsBad;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.pkText.label.copyWith(color: Colors.white),
      ),
      // Section 7.1: the supporting metrics are 20–24, not a second display
      // value competing with net worth.
      Text(
        amount,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
        style: context.pkText.moneySection.copyWith(color: Colors.white),
      ),
      if (comparison != null)
        PkComparisonLabel(
          comparison: comparison!,
          upIsBad: upIsBad,
          compact: true,
          onLight: true,
        ),
      // The note is supporting context, and on a short screen it is the first
      // thing the hero can afford to lose. Section 5.1 forbids `micro` for
      // prose, and 9.5 holds prose to 4.5:1 — so it is `supporting`, in full
      // white rather than a 70% wash that would not clear the ratio.
      if (!context.isShort)
        Text(
          note,
          // One line, not two. Section 7.1 budgets this hero at 148–168 and a
          // wrapping note was what took it to 199 — which is 31 px of prose
          // charged against the first row of the reader's own money.
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.pkText.supporting.copyWith(color: Colors.white),
        ),
    ],
  );
}

/// One titled block of Home content.
///
/// Section 7.1: on 600+ widths the hero stays full width and the blocks
/// beneath it fall into two columns. Rendering each as its own sliver made
/// that impossible, so a section is a plain widget and Home decides how to
/// arrange them.
class _HomeSection extends StatelessWidget {
  const _HomeSection({
    required this.child,
    this.header,
    this.top = PkSpacing.section,
  });

  /// Null for a block that is a strip of controls rather than a named group —
  /// a heading over five shortcut chips only repeats what the chips say.
  final Widget? header;
  final Widget child;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsDirectional.only(top: top),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [?header, child],
    ),
  );
}

/// Lays Home's sections out in one column on a phone and two on anything
/// wider, so a tablet is not one stretched phone column.
class _HomeSections extends StatelessWidget {
  const _HomeSections({required this.sections});

  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.symmetric(horizontal: context.gutter);
    // Two columns start at the `medium` breakpoint rather than at `compact`.
    // Section 4.7 permits them from 600, but a 600–839 window splits into two
    // ~280 px columns, which is narrower than the phone layout they replace —
    // the ledger rows inside them start truncating. 840 is the first width
    // where both columns are genuinely comfortable.
    if (!context.isMedium) {
      return SliverPadding(
        padding: padding,
        sliver: SliverList.list(children: sections),
      );
    }
    // Alternating rather than split down the middle: the order the audit sets
    // in section 7.1 still reads top-to-bottom, left-to-right.
    final left = <Widget>[];
    final right = <Widget>[];
    for (var index = 0; index < sections.length; index++) {
      (index.isEven ? left : right).add(sections[index]);
    }
    return SliverPadding(
      padding: padding,
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: left,
              ),
            ),
            const SizedBox(width: PkSpacing.section),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthPicker extends StatelessWidget {
  const _MonthPicker({required this.selected});
  final DateTime selected;
  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (index) => DateTime(2026, 12 - index));
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x4,
        0,
        PkSpacing.x4,
        PkSpacing.x6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                context.t.chooseMonth,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          ...months.map(
            (month) => PkLedgerRow.management(
              title: DateFormat('MMMM yyyy').format(month),
              trailing:
                  month.year == selected.year && month.month == selected.month
                  ? Icon(
                      Icons.check_circle_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
              onTap: () => Navigator.pop(context, month),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeLoading extends StatelessWidget {
  const _HomeLoading();
  @override
  Widget build(BuildContext context) => PkPage(
    slivers: [
      const _HomeBrandHeader(),
      SliverPadding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          PkSpacing.screen,
          PkSpacing.x3,
          PkSpacing.screen,
          0,
        ),
        sliver: const SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 2172 / 724,
            child: PkSkeleton(radius: PkRadius.extraLarge),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          PkSpacing.screen,
          PkSpacing.x5,
          PkSpacing.screen,
          0,
        ),
        sliver: SliverList.list(
          children: const [
            PkSkeleton(height: 264, radius: PkRadius.extraLarge),
            SizedBox(height: PkSpacing.x6),
            PkSkeleton(height: 82),
            SizedBox(height: PkSpacing.x3),
            PkSkeleton(height: 160),
            SizedBox(height: PkSpacing.x3),
            PkSkeleton(height: 100),
          ],
        ),
      ),
    ],
  );
}

/// Everything waiting on the user, most urgent first.
///
/// This block exists because Home used to lead with whatever happened to have
/// a banner — an AI approval — while a pending invitation or an unconfirmed
/// settlement sat further down among the passive summaries.
class _ActionRequiredBlock extends StatelessWidget {
  const _ActionRequiredBlock({required this.items});

  final List<ActionItem> items;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    label: context.t.thingsNeedYou(items.length),
    child: PkCard(
      color: context.pk.sharedSurface,
      borderColor: context.pk.sharedBorder,
      padding: const EdgeInsets.symmetric(vertical: PkSpacing.x2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.x4,
              PkSpacing.x2,
              PkSpacing.x4,
              PkSpacing.x1,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.priority_high_rounded,
                  size: PkSize.iconSmall,
                  color: context.pk.sharedStrong,
                ),
                const SizedBox(width: PkSpacing.x2),
                Expanded(
                  child: Text(
                    context.t.homeThingsNeedYou(items.length),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: context.pk.sharedStrong,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // One row, and a count for the rest. The block's job is to say
          // "something needs you" and name the most pressing one; listing two
          // cost 56 px of the viewport the data itself needs.
          // These are the things waiting on the reader, so they get the row
          // system's full target rather than a `dense` tile that shrank it.
          for (final item in items.take(1))
            Builder(
              builder: (context) {
                final detail = item.amountMinor == null || item.currency == null
                    ? item.detail
                    : '${PkFormat.money(item.amountMinor!, item.currency!)} '
                          '${item.detail}';
                return PkLedgerRow.management(
                  key: ValueKey('action_${item.id}'),
                  semanticIdentifier: 'action_${item.id}',
                  semanticLabel: '${item.title}, $detail',
                  leading: Icon(switch (item.kind) {
                    ActionItemKind.invitation => Icons.mail_outline_rounded,
                    ActionItemKind.settlementProposal =>
                      Icons.handshake_outlined,
                    ActionItemKind.draftRecord => Icons.edit_note_rounded,
                    ActionItemKind.budgetBreach => Icons.donut_large_rounded,
                    ActionItemKind.aiApproval => Icons.auto_awesome_outlined,
                    ActionItemKind.subscriptionDue => Icons.autorenew_rounded,
                  }, color: context.pk.sharedStrong),
                  title: item.title,
                  subtitle: detail,
                  showChevron: true,
                  onTap: () => context.push(item.destination),
                );
              },
            ),
          if (items.length > 1)
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.x4,
                0,
                PkSpacing.x4,
                PkSpacing.x2,
              ),
              child: Text(
                context.t.homeAndMore(items.length - 1),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    ),
  );
}

/// One line of "who owes whom", the part the Spaces tab does not show.
class _DebtRow extends StatelessWidget {
  const _DebtRow({required this.edge});

  final DebtEdge edge;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final iOwe = edge.fromUserId == repo.currentUserId;
    final other = repo.userById(iOwe ? edge.toUserId : edge.fromUserId);
    final space = repo.spaceById(edge.spaceId);
    return PkLedgerRow.management(
      key: ValueKey('debt_${edge.spaceId}_${edge.fromUserId}_${edge.toUserId}'),
      leading: PkAvatar(label: other?.initials ?? '?'),
      title: iOwe
          ? context.t.homeYouOwe(other?.name ?? '')
          : context.t.homeOwesYou(other?.name ?? ''),
      subtitle:
          '${space?.name ?? ''} · ${space?.type.labelIn(context.t) ?? ''}',
      trailing: PkAmountText(
        amountMinor: edge.amountMinor,
        currency: edge.currency,
        color: iOwe ? context.pk.owing : context.pk.owed,
      ),
      onTap: () => context.push('/spaces/${edge.spaceId}/settle'),
    );
  }
}

/// Cash flow, savings rate, what is still committed and anything unusual.
///
/// Collapsed by default: these are the figures a careful user wants and a
/// casual one does not, and Home should stay calm for the second.
class _FinancialHealthPanel extends StatelessWidget {
  const _FinancialHealthPanel({required this.health});

  final FinancialHealth health;

  @override
  Widget build(BuildContext context) {
    final positive = health.netMinor >= 0;
    return PkCard(
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: const ValueKey('financial_health'),
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: PkSpacing.x2),
          title: Row(
            children: [
              Icon(
                positive
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                size: PkSize.icon,
                color: positive ? context.pk.success : context.pk.danger,
              ),
              const SizedBox(width: PkSpacing.x2),
              Expanded(
                child: Text(
                  positive
                      ? context.t.homeYouKept(
                          PkFormat.money(health.netMinor, health.currency),
                        )
                      : context.t.homeYouOverspent(
                          PkFormat.money(
                            health.netMinor.abs(),
                            health.currency,
                          ),
                        ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          subtitle: Text(
            context.t.homeStillFree(
              PkFormat.money(health.disposableMinor, health.currency),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          children: [
            Row(
              children: [
                Expanded(
                  child: PkStatTile(
                    label: context.t.homeMoneyIn,
                    value: PkFormat.money(health.incomeMinor, health.currency),
                    icon: Icons.south_west_rounded,
                  ),
                ),
                const SizedBox(width: PkSpacing.x2),
                Expanded(
                  child: PkStatTile(
                    label: context.t.homeMoneyOut,
                    value: PkFormat.money(health.outflowMinor, health.currency),
                    icon: Icons.north_east_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: PkSpacing.x2),
            Row(
              children: [
                Expanded(
                  child: PkStatTile(
                    label: context.t.homeKept,
                    value: '${(health.savingsRate * 100).round()}%',
                    detail: context.t.homeKeptDetail,
                    icon: Icons.savings_outlined,
                  ),
                ),
                const SizedBox(width: PkSpacing.x2),
                Expanded(
                  child: PkStatTile(
                    label: context.t.homeStillDue,
                    value: PkFormat.money(
                      health.upcomingMinor,
                      health.currency,
                    ),
                    detail: context.t.homeStillDueDetail,
                    icon: Icons.autorenew_rounded,
                  ),
                ),
              ],
            ),
            if (health.unusual.isNotEmpty) ...[
              const SizedBox(height: PkSpacing.x3),
              // "Unusual" is stated against its own baseline, so it is a
              // finding rather than an opinion.
              for (final slice in health.unusual.take(2))
                Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.x1),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: PkSize.iconSmall,
                        color: context.pk.warning,
                      ),
                      const SizedBox(width: PkSpacing.x2),
                      Expanded(
                        child: Text(
                          context.t.isWellAboveItsRecent(
                            slice.label,
                            PkFormat.money(slice.valueMinor, health.currency),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

/// The two charts that used to sit on Home, one tap away.
///
/// UI-020 §5: the spending trend and the category breakdown each cost Home a
/// section header, a card and a chart in the first viewport — roughly a
/// quarter of the screen spent on two things a reader consults occasionally
/// and reads once. Collapsing them into rows only works if the rows lead
/// somewhere, so this is where they lead. Nothing was dropped: both charts,
/// both comparison labels and both accessible data tables are here in full.
class HomeInsightsScreen extends StatelessWidget {
  const HomeInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final reporting = repo.profile.reportingCurrency;
    final trend = repo.spendSeries(viewModel.selectedMonth);
    final comparison = repo.spendingComparison(viewModel.selectedMonth);
    final breakdown = repo.categoryBreakdown(
      viewModel.selectedMonth,
      limit: PkChartPalette.maxSeries,
    );
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.homeInsights)),
      body: PkPage(
        bottomPadding: PkSpacing.x8,
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x3,
              PkSpacing.screen,
              PkSpacing.headerToContent,
            ),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(title: context.t.homeSpendingTrend),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PkSparkline(points: trend, currency: reporting),
                    const SizedBox(height: PkSpacing.x2),
                    PkComparisonLabel(comparison: comparison),
                    PkChartDataTable(
                      rows: [
                        for (final point in trend)
                          (point.label, point.valueMinor),
                      ],
                      currency: reporting,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (breakdown.isNotEmpty) ...[
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.section,
                PkSpacing.screen,
                PkSpacing.headerToContent,
              ),
              sliver: SliverToBoxAdapter(
                child: PkSectionHeader(
                  title: context.t.homeWhereItWent,
                  actionLabel: context.t.homeViewActivity,
                  onAction: () => context.push('/activity'),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PkCategoryDonut(
                        slices: breakdown,
                        currency: reporting,
                        totalMinor: breakdown.fold(
                          0,
                          (sum, slice) => sum + slice.valueMinor,
                        ),
                        onSliceTap: (slice) => context.push('/activity'),
                      ),
                      PkChartDataTable(
                        rows: [
                          for (final slice in breakdown)
                            (slice.label, slice.valueMinor),
                        ],
                        currency: reporting,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
