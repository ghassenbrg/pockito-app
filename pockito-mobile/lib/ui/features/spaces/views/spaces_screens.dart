import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../../domain/repositories/pockito_repository.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_tokens.dart';

class SpacesScreen extends StatefulWidget {
  const SpacesScreen({super.key});

  @override
  State<SpacesScreen> createState() => _SpacesScreenState();
}

class _SpacesScreenState extends State<SpacesScreen> {
  /// The Space shown in the detail pane on wide displays. Null on phones,
  /// where tapping a row pushes a route instead.
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    // Section 7.24: master list plus detail pane when the width permits.
    final wide = context.isMedium;
    final selected = wide ? _selectedId : null;
    return PkTwoPane(
      list: _buildList(context, wide),
      detail: selected == null
          ? null
          : SpaceDetailScreen(key: ValueKey(selected), spaceId: selected),
      placeholder: PkEmptyState.section(
        icon: Icons.group_outlined,
        title: context.t.navSpaces,
        message: context.t.sharedMoneyWithoutTheAwkward,
      ),
    );
  }

  Widget _buildList(BuildContext context, bool wide) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final all = repo.spaces
        .where((item) => item.status == SpaceStatus.active)
        .toList();
    final summary = repo.sharedSummary();
    final query = viewModel.queryFor('spaces').trim().toLowerCase();
    final sort = viewModel.sortFor('spaces', PkSort.nameAsc);
    int balanceOf(SharedSpace space) =>
        repo.convertMinor(
          repo.memberBalance(space.id, repo.currentUserId),
          space.currency,
          repo.profile.reportingCurrency,
        ) ??
        0;
    final spaces =
        all.where((space) {
          if (query.isEmpty) return true;
          return space.name.toLowerCase().contains(query) ||
              space.type.label.toLowerCase().contains(query) ||
              space.members.any(
                (member) => (repo.userById(member.userId)?.name ?? '')
                    .toLowerCase()
                    .contains(query),
              );
        }).toList()..sort(
          (a, b) => switch (sort) {
            PkSort.nameDesc => b.name.toLowerCase().compareTo(
              a.name.toLowerCase(),
            ),
            PkSort.balanceDesc => balanceOf(b).compareTo(balanceOf(a)),
            PkSort.balanceAsc => balanceOf(a).compareTo(balanceOf(b)),
            _ => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
          },
        );
    return PkPage(
      refresh: context.read<PockitoAppViewModel>().simulateRefresh,
      slivers: [
        PkScreenHeader(
          title: context.t.navSpaces,
          subtitle: context.t.sharedMoneyWithoutTheAwkward,
          actions: [
            // Section 7.4 and UI-P1-02: Create Space has one primary entry
            // point. It lives here rather than as a full-width button below a
            // list the reader has already scrolled past.
            IconButton(
              key: const ValueKey('spaces_add'),
              onPressed: () => context.push('/spaces/new'),
              tooltip: context.t.createASpace,
              icon: const Icon(Icons.add_rounded),
            ),
            PopupMenuButton<String>(
              tooltip: context.t.archivedSpaces,
              onSelected: (value) => context.push('/spaces/archived'),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'archived',
                  child: ListTile(
                    leading: Icon(Icons.archive_outlined),
                    title: Text(context.t.archivedSpaces),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ),
        SliverPadding(
          padding: EdgeInsetsDirectional.fromSTEB(
            context.gutter,
            0,
            context.gutter,
            PkSpacing.section,
          ),
          sliver: SliverToBoxAdapter(child: _SharedHero(summary: summary)),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          sliver: SliverToBoxAdapter(
            child: PkListControls(
              listId: 'spaces',
              totalCount: all.length,
              resultCount: spaces.length,
              hintText: context.t.searchSpacesOrTheirMembers(all.length),
              sortOptions: const [
                PkSort.nameAsc,
                PkSort.nameDesc,
                PkSort.balanceDesc,
                PkSort.balanceAsc,
              ],
              sort: sort,
              onSortChanged: (value) => viewModel.setSortFor('spaces', value),
              query: viewModel.queryFor('spaces'),
              onQueryChanged: (value) => viewModel.setQueryFor('spaces', value),
            ),
          ),
        ),
        if (spaces.isEmpty)
          SliverToBoxAdapter(
            child: query.isEmpty
                ? PkEmptyState(
                    icon: Icons.group_add_outlined,
                    title: context.t.shareMoneyWithLessFriction,
                    message: context.t.createASpaceForA,
                    actionLabel: context.t.createASpace,
                    onAction: () => context.push('/spaces/new'),
                  )
                : PkListState.empty(
                    icon: Icons.search_off_rounded,
                    title: context.t.noSpaceMatches(query),
                    message: context.t.tryADifferentNameType,
                    actionLabel: context.t.actionClearSearch,
                    onAction: () => viewModel.setQueryFor('spaces', ''),
                  ),
          )
        else
          // D-03 and section 7.4: one surface with separators, 72 px rows,
          // each showing type and currency so two Spaces called "Household"
          // can be told apart.
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter),
            sliver: SliverToBoxAdapter(
              child: PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                children: [
                  for (final space in spaces)
                    PkSpaceTile(
                      space: space,
                      balanceMinor: repo.memberBalance(
                        space.id,
                        repo.currentUserId,
                      ),
                      expenseCount: repo.sharedExpenses
                          .where((item) => item.spaceId == space.id)
                          .length,
                      onTap: () => wide
                          ? setState(() => _selectedId = space.id)
                          : context.push('/spaces/${space.id}'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class SpaceDetailScreen extends StatefulWidget {
  const SpaceDetailScreen({super.key, required this.spaceId});
  final String spaceId;
  @override
  State<SpaceDetailScreen> createState() => _SpaceDetailScreenState();
}

class _SpaceDetailScreenState extends State<SpaceDetailScreen> {
  int _tab = 0;
  bool _lifetime = false;
  bool _includeUnsettled = true;
  bool _includeSettled = true;
  bool _paidByMeOnly = false;
  String? _payerUserId;
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.group_off_outlined,
          title: context.t.spaceNotFound,
          message: context.t.itMayHaveBeenRemoved,
        ),
      );
    }
    final spaceExpenses =
        repo.sharedExpenses.where((item) => item.spaceId == space.id).toList()
          ..sort((a, b) => b.occurredOn.compareTo(a.occurredOn));
    final currentCycleExpenses = spaceExpenses
        .where((expense) => expense.cycleId == space.currentCycleId)
        .toList();
    final allExpenses = (_lifetime ? spaceExpenses : currentCycleExpenses);
    final currentHasSettlement = repo.settlements.any(
      (settlement) =>
          settlement.spaceId == space.id &&
          settlement.cycleId == space.currentCycleId &&
          settlement.isConfirmed,
    );
    final currentBalancesAreZero = space.members.every(
      (member) => repo.memberBalance(space.id, member.userId) == 0,
    );
    final expenses = allExpenses.where((expense) {
      final settled =
          expense.cycleId != space.currentCycleId ||
          (currentHasSettlement && currentBalancesAreZero);
      if (settled && !_includeSettled) return false;
      if (!settled && !_includeUnsettled) return false;
      // With several payers an expense counts as "paid by" everyone who put
      // money in, not only whoever put in the most.
      if (_paidByMeOnly && expense.paidBy(repo.currentUserId) == 0) {
        return false;
      }
      if (_payerUserId != null && expense.paidBy(_payerUserId!) == 0) {
        return false;
      }
      if (_categoryId != null && expense.categoryId != _categoryId) {
        return false;
      }
      return true;
    }).toList();
    final balance = repo.memberBalance(
      space.id,
      repo.currentUserId,
      lifetime: _lifetime,
    );
    final myRecommendation = repo
        .settlementRecommendations(space.id)
        .where(
          (item) =>
              item.fromUserId == repo.currentUserId ||
              item.toUserId == repo.currentUserId,
        )
        .firstOrNull;
    final balanceDescription = _lifetime || myRecommendation == null
        ? balance == 0
              ? context.t.everyoneIsSettled
              : balance > 0
              ? context.t.youReOwed
              : context.t.youOwe
        : myRecommendation.fromUserId == repo.currentUserId
        ? context.t.youOweX0(
            repo.userById(myRecommendation.toUserId)?.name ?? context.t.someone,
          )
        : context.t.x0OwesYou(
            repo.userById(myRecommendation.fromUserId)?.name ??
                context.t.someone,
          );
    return Scaffold(
      appBar: PkAppBar(
        title: Text(space.name),
        actions: [
          IconButton(
            onPressed: () => context.push('/spaces/${space.id}/settlements'),
            tooltip: context.t.settlementHistory,
            icon: const Icon(Icons.handshake_outlined),
          ),
          IconButton(
            onPressed: () => context.push('/spaces/${space.id}/members'),
            tooltip: context.t.members2,
            icon: const Icon(Icons.group_outlined),
          ),
          IconButton(
            onPressed: () => context.push('/spaces/${space.id}/settings'),
            tooltip: context.t.spaceSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: PkPage(
        bottomPadding: 120,
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x4,
            ),
            sliver: SliverToBoxAdapter(
              child: _SpaceHero(
                space: space,
                balance: balance,
                balanceDescription: balanceDescription,
                lifetime: _lifetime,
                onScopeChanged: (value) => setState(() => _lifetime = value),
                onBreakdown: () => _showBalanceBreakdown(context, space),
                onSettle: balance == 0
                    ? null
                    : () => context.push('/spaces/${space.id}/settle'),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            // Money / People / Activity, with Settings reached from the
            // header. Naming the sections after what they hold beats naming
            // them after the records they are built from.
            delegate: PkTabs(
              background: context.pk.page,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  0,
                  PkSpacing.screen,
                  PkSpacing.x2,
                ),
                child: SegmentedButton<int>(
                  key: const ValueKey('space_tabs'),
                  segments: [
                    ButtonSegment(
                      value: 0,
                      label: Text(context.t.money),
                      icon: Icon(Icons.receipt_long_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text(context.t.people),
                      icon: Icon(Icons.group_outlined, size: 16),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text(context.t.activityTitle),
                      icon: Icon(Icons.history_rounded, size: 16),
                    ),
                  ],
                  selected: {_tab},
                  onSelectionChanged: (value) {
                    PkHaptics.selection();
                    setState(() => _tab = value.first);
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              0,
              PkSpacing.screen,
              PkSpacing.x3,
            ),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                color: currentBalancesAreZero && currentCycleExpenses.isNotEmpty
                    ? context.pk.sharedSurface
                    : null,
                borderColor:
                    currentBalancesAreZero && currentCycleExpenses.isNotEmpty
                    ? context.pk.sharedBorder
                    : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          currentBalancesAreZero
                              ? Icons.check_circle_outline_rounded
                              : Icons.calendar_month_outlined,
                          color: currentBalancesAreZero
                              ? context.pk.sharedStrong
                              : context.pk.textSecondary,
                        ),
                        const SizedBox(width: PkSpacing.x3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentBalancesAreZero &&
                                        currentCycleExpenses.isNotEmpty
                                    ? context.t.everyoneIsSettled
                                    : context.t.cyclesPreserveYourHistory,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                currentBalancesAreZero &&
                                        currentCycleExpenses.isNotEmpty
                                    ? context.t.startANewCycleTo
                                    : context.t.x0PreviousX1(
                                        repo.cycles
                                            .where(
                                              (cycle) =>
                                                  cycle.spaceId == space.id,
                                            )
                                            .length,
                                        repo.cycles
                                                    .where(
                                                      (cycle) =>
                                                          cycle.spaceId ==
                                                          space.id,
                                                    )
                                                    .length ==
                                                1
                                            ? 'cycle'
                                            : 'cycles',
                                      ),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: PkSpacing.x3),
                    Wrap(
                      alignment: WrapAlignment.end,
                      spacing: PkSpacing.x2,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              context.push('/spaces/${space.id}/cycles'),
                          icon: const Icon(Icons.history_rounded),
                          label: Text(context.t.cycleHistory),
                        ),
                        if (currentBalancesAreZero &&
                            currentCycleExpenses.isNotEmpty)
                          FilledButton.icon(
                            key: const ValueKey('start_new_cycle'),
                            onPressed: () => _startNewCycle(context, space),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(context.t.startNewCycle),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_tab == 0) ...[
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x3,
                PkSpacing.screen,
                PkSpacing.x3,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.t.x0Expenses(expenses.length),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _showExpenseFilters(context),
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: Text(context.t.filter),
                    ),
                  ],
                ),
              ),
            ),
            if (expenses.isEmpty)
              SliverToBoxAdapter(
                child: PkEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: allExpenses.isEmpty
                      ? context.t.noSharedExpensesYet
                      : context.t.noExpensesMatchTheseFilters,
                  message: allExpenses.isEmpty
                      ? context.t.addTheFirstExpenseAnd
                      : context.t.tryShowingSettledAndUnsettled,
                  actionLabel: allExpenses.isEmpty
                      ? context.t.addExpense
                      : context.t.clearFilters,
                  onAction: allExpenses.isEmpty
                      ? () => context.push('/add?space=${space.id}')
                      : () => setState(() {
                          _includeUnsettled = true;
                          _includeSettled = true;
                          _paidByMeOnly = false;
                        }),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: PkSpacing.screen,
                ),
                sliver: SliverList.separated(
                  itemCount: expenses.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: PkSpacing.x2),
                  itemBuilder: (context, index) => _SharedExpenseTile(
                    expense: expenses[index],
                    onTap: () => context.push(
                      '/spaces/${space.id}/expenses/${expenses[index].id}',
                    ),
                  ),
                ),
              ),
          ] else if (_tab == 1) ...[
            // People: who is here, what they are allowed to do, and where
            // each of them stands.
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x4,
                PkSpacing.screen,
                PkSpacing.x3,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        context.t.spaceMemberCount(space.members.length),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    TextButton.icon(
                      key: const ValueKey('space_manage_people'),
                      onPressed: () =>
                          context.push('/spaces/${space.id}/members'),
                      icon: const Icon(Icons.tune_rounded, size: 18),
                      label: Text(context.t.spaceManagePeople),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
              sliver: SliverList.separated(
                itemCount: space.members.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: PkSpacing.x2),
                itemBuilder: (context, index) {
                  final member = space.members[index];
                  final user = repo.userById(member.userId);
                  if (user == null) return const SizedBox.shrink();
                  return PkMemberRow(
                    user: user,
                    role: member.role,
                    balanceMinor: repo.memberBalance(space.id, user.id),
                    currency: space.currency,
                    subtitle:
                        '${member.role.labelIn(context.t)} · '
                        '${member.role.summaryIn(context.t)}',
                    onTap: () => context.push('/spaces/${space.id}/members'),
                  );
                },
              ),
            ),
          ] else
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x4,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverList.separated(
                itemCount: allExpenses.length + space.members.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: PkSpacing.x2),
                itemBuilder: (context, index) {
                  if (index < allExpenses.length) {
                    return _ActivityEvent(
                      icon: Icons.receipt_long_outlined,
                      title: context.t.x0AddedX1(
                        repo
                                .userById(allExpenses[index].createdByUserId)
                                ?.name ??
                            'Someone',
                        allExpenses[index].title,
                      ),
                      detail:
                          '${PkFormat.money(allExpenses[index].totalMinor, allExpenses[index].currency)} · ${PkFormat.shortDate(allExpenses[index].occurredOn, repo.today, context.t)}',
                      via: allExpenses[index].client,
                    );
                  }
                  final member = space.members[index - allExpenses.length];
                  return _ActivityEvent(
                    icon: Icons.person_add_alt_rounded,
                    title: context.t.x0JoinedTheSpace(
                      repo.userById(member.userId)?.name ?? context.t.someone,
                    ),
                    detail: member.role.labelIn(context.t),
                  );
                },
              ),
            ),
          if (_tab == 2)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x4,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: OutlinedButton.icon(
                  key: const ValueKey('space_full_log'),
                  onPressed: () => context.push('/spaces/${space.id}/activity'),
                  icon: const Icon(Icons.receipt_long_outlined),
                  label: Text(context.t.spaceFullActivityLog),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/add?space=${space.id}'),
        backgroundColor: context.pk.shared,
        foregroundColor: PkPalette.slate900,
        icon: const Icon(Icons.add_rounded),
        label: Text(context.t.expense),
      ),
    );
  }

  Future<void> _showBalanceBreakdown(
    BuildContext context,
    SharedSpace space,
  ) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final scopedExpenses = repo.sharedExpenses
        .where(
          (expense) =>
              expense.spaceId == space.id &&
              (_lifetime || expense.cycleId == space.currentCycleId),
        )
        .toList();
    await showPkSheet<void>(
      context,
      builder: (context) => PkSheetScaffold(
        title: context.t.balanceBreakdown,
        subtitle: context.t.everyAmountIsInThe(space.currency),
        footer: FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.t.actionDone),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...space.members.map((member) {
              final user = repo.userById(member.userId)!;
              final balance = repo.memberBalance(
                space.id,
                member.userId,
                lifetime: _lifetime,
              );
              final paid = scopedExpenses.fold<int>(
                0,
                (sum, expense) => sum + expense.paidBy(member.userId),
              );
              final responsibility = scopedExpenses.fold<int>(
                0,
                (sum, expense) =>
                    sum +
                    (expense.shares
                            .where((share) => share.userId == member.userId)
                            .firstOrNull
                            ?.amountMinor ??
                        0),
              );
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: PkAvatar(label: user.initials),
                title: Text(
                  user.isYou ? context.t.x0You2(user.name) : user.name,
                ),
                subtitle: Text(
                  context.t.paidX0ShareX1(
                    PkFormat.money(paid, space.currency),
                    PkFormat.money(responsibility, space.currency),
                  ),
                ),
                trailing: PkBalanceLabel(
                  amountMinor: balance,
                  currency: space.currency,
                  compact: true,
                ),
              );
            }),
            if (!_lifetime &&
                repo.settlementRecommendations(space.id).isNotEmpty) ...[
              const Divider(),
              Text(
                context.t.whoPaysWhom,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: PkSpacing.x1),
              ...repo
                  .settlementRecommendations(space.id)
                  .map(
                    (item) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.arrow_forward_rounded),
                      title: Text(
                        '${item.fromUserId == repo.currentUserId ? 'You' : repo.userById(item.fromUserId)?.name} → ${item.toUserId == repo.currentUserId ? 'You' : repo.userById(item.toUserId)?.name}',
                      ),
                      trailing: PkAmountText(
                        amountMinor: item.amountMinor,
                        currency: item.currency,
                      ),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _startNewCycle(BuildContext context, SharedSpace space) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.startANewCycle),
        content: Text(context.t.currentBalancesAndSpaceBudget),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.notYet),
          ),
          FilledButton(
            key: const ValueKey('confirm_new_cycle'),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.startNewCycle),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<PockitoAppViewModel>().repository.startNewCycle(
      space.id,
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.newCycleStartedHistoryPreserved)),
      );
    }
  }

  Future<void> _showExpenseFilters(BuildContext context) async {
    var includeUnsettled = _includeUnsettled;
    var includeSettled = _includeSettled;
    var paidByMeOnly = _paidByMeOnly;
    var payerUserId = _payerUserId;
    var categoryId = _categoryId;
    final repo = context.read<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId)!;
    final result = await showPkSheet<(bool, bool, bool, String?, String?)>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x4,
            0,
            PkSpacing.x4,
            PkSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t.filterExpenses,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x4),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.t.unsettled),
                value: includeUnsettled,
                onChanged: (value) =>
                    setSheetState(() => includeUnsettled = value ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.t.settled),
                value: includeSettled,
                onChanged: (value) =>
                    setSheetState(() => includeSettled = value ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(context.t.paidByMe),
                value: paidByMeOnly,
                onChanged: (value) => setSheetState(() {
                  paidByMeOnly = value ?? false;
                  if (paidByMeOnly) payerUserId = null;
                }),
              ),
              DropdownButtonFormField<String>(
                initialValue: payerUserId ?? '__all__',
                decoration: InputDecoration(labelText: context.t.paidByMember),
                items: [
                  DropdownMenuItem(
                    value: '__all__',
                    child: Text(context.t.allMembers),
                  ),
                  ...space.members.map((member) {
                    final user = repo.userById(member.userId)!;
                    return DropdownMenuItem(
                      value: user.id,
                      child: Text(user.isYou ? context.t.you : user.name),
                    );
                  }),
                ],
                onChanged: paidByMeOnly
                    ? null
                    : (value) => setSheetState(
                        () => payerUserId = value == '__all__' ? null : value,
                      ),
              ),
              const SizedBox(height: PkSpacing.x3),
              DropdownButtonFormField<String>(
                initialValue: categoryId ?? '__all__',
                decoration: InputDecoration(labelText: context.t.categoryLabel),
                items: [
                  DropdownMenuItem(
                    value: '__all__',
                    child: Text(context.t.allCategories),
                  ),
                  ...repo.categories
                      .where((item) => item.type == CategoryType.expense)
                      .map(
                        (item) => DropdownMenuItem(
                          value: item.id,
                          child: Text(item.name),
                        ),
                      ),
                ],
                onChanged: (value) => setSheetState(
                  () => categoryId = value == '__all__' ? null : value,
                ),
              ),
              const SizedBox(height: PkSpacing.x3),
              FilledButton(
                onPressed: !includeUnsettled && !includeSettled
                    ? null
                    : () => Navigator.pop(context, (
                        includeUnsettled,
                        includeSettled,
                        paidByMeOnly,
                        payerUserId,
                        categoryId,
                      )),
                child: Text(context.t.applyFilters),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _includeUnsettled = result.$1;
      _includeSettled = result.$2;
      _paidByMeOnly = result.$3;
      _payerUserId = result.$4;
      _categoryId = result.$5;
    });
  }
}

class SharedExpenseDetailScreen extends StatelessWidget {
  const SharedExpenseDetailScreen({
    super.key,
    required this.spaceId,
    required this.expenseId,
  });
  final String spaceId;
  final String expenseId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final expense = repo.sharedExpenseById(expenseId);
    final space = repo.spaceById(spaceId);
    if (expense == null || space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.receipt_long_outlined,
          title: context.t.expenseNotFound,
          message: context.t.thisExpenseHasBeenRemoved,
        ),
      );
    }
    final category = repo.categoryById(expense.categoryId);
    final payer = repo.userById(expense.primaryPayerUserId);
    final historical = expense.cycleId != space.currentCycleId;
    final permissions = repo.permissionsFor(space.id);
    final canEdit = permissions.canEditExpenseBy(
      expense.createdByUserId,
      repo.currentUserId,
    );
    final canVoid = permissions.canVoidExpenseBy(
      expense.createdByUserId,
      repo.currentUserId,
    );
    final linkedTransaction = repo.transactions
        .where((item) => item.splitId == expense.id)
        .firstOrNull;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.sharedExpenseLabel),
        actions: historical
            ? const []
            : [
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    switch (value) {
                      case 'edit':
                        context.push('/add?shared=${expense.id}');
                      case 'duplicate':
                        context.push('/add?duplicateShared=${expense.id}');
                      case 'void':
                        await _void(context, repo, expense);
                      case 'restore':
                        await PkGuardedAction.run(
                          context,
                          () => repo.restoreSharedExpense(expense.id),
                          successMessage: context.t.restored,
                        );
                      case 'confirm':
                        await PkGuardedAction.run(
                          context,
                          () => repo.confirmSharedExpense(expense.id),
                          successMessage: context.t.confirmedItCountsFromNow,
                        );
                    }
                  },
                  itemBuilder: (_) => [
                    if (expense.isDraft && canEdit)
                      PopupMenuItem(
                        value: 'confirm',
                        child: ListTile(
                          leading: Icon(Icons.check_circle_outline_rounded),
                          title: Text(context.t.actionConfirm),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    if (!expense.isVoided) ...[
                      PopupMenuItem(
                        value: 'edit',
                        enabled: canEdit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text(context.t.editExpense),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'duplicate',
                        enabled: permissions.canAddExpense,
                        child: ListTile(
                          leading: Icon(Icons.copy_outlined),
                          title: Text(context.t.duplicate),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      PopupMenuItem(
                        value: 'void',
                        enabled: canVoid,
                        child: ListTile(
                          leading: Icon(Icons.block_outlined),
                          title: Text(context.t.actionVoid),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ] else if (canVoid)
                      PopupMenuItem(
                        value: 'restore',
                        child: ListTile(
                          leading: Icon(Icons.restore_rounded),
                          title: Text(context.t.actionRestore),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
              ],
      ),
      body: PkPage(
        bottomPadding: 32,
        slivers: [
          if (permissions.readOnly && !historical)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x2,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: PkReadOnlyRibbon.forSpace(
                  t: context.t,
                  permissions: permissions,
                  archived: space.status == SpaceStatus.archived,
                  spaceName: space.name,
                ),
              ),
            ),
          if (expense.isVoided || expense.isDraft)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x2,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: PkRecordStatusBanner(
                  status: expense.status,
                  reason: expense.voidReason,
                  voidedAt: expense.voidedAt,
                  onConfirm: expense.isDraft && canEdit
                      ? () => PkGuardedAction.run(
                          context,
                          () => repo.confirmSharedExpense(expense.id),
                          successMessage: context.t.confirmedItCountsFromNow,
                        )
                      : null,
                  onRestore: expense.isVoided && canVoid
                      ? () => PkGuardedAction.run(
                          context,
                          () => repo.restoreSharedExpense(expense.id),
                          successMessage: context.t.restored,
                        )
                      : null,
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x6,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  PkIconTile(
                    icon: PkIcons.named(category?.icon ?? 'receipt'),
                    color: PkPalette.categoryAt(category?.colorIndex ?? 2),
                    size: 64,
                    iconSize: 30,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  Text(
                    expense.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  PkAmountText(
                    amountMinor: expense.totalMinor,
                    currency: expense.currency,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Text(
                    '${space.name} · ${PkFormat.longDate(expense.occurredOn, context.t)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          if (historical)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                0,
                PkSpacing.screen,
                PkSpacing.x4,
              ),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  color: context.pk.sharedSurface,
                  borderColor: context.pk.sharedBorder,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.lock_clock_outlined),
                    title: Text(context.t.historicalExpense),
                    subtitle: Text(context.t.thisClosedCycleRecordIs),
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  children: [
                    _ExpenseDetailRow(
                      label: expense.hasMultiplePayers
                          ? context.t.paidBy
                          : context.t.paidBy,
                      value: expense.hasMultiplePayers
                          ? expense.payers
                                .map(
                                  (item) =>
                                      '${repo.userById(item.userId)?.isYou == true ? 'You' : repo.userById(item.userId)?.name ?? 'Member'} '
                                      '${PkFormat.money(item.amountMinor, expense.currency)}',
                                )
                                .join(' · ')
                          : payer?.isYou == true
                          ? context.t.you
                          : payer?.name ?? 'Member',
                    ),
                    _ExpenseDetailRow(
                      label: context.t.recordedBy,
                      value:
                          repo.userById(expense.createdByUserId)?.isYou == true
                          ? context.t.you
                          : repo.userById(expense.createdByUserId)?.name ??
                                context.t.someone,
                    ),
                    _ExpenseDetailRow(
                      label: context.t.categoryLabel,
                      value: category?.name ?? context.t.uncategorised,
                    ),
                    _ExpenseDetailRow(
                      label: context.t.splitMethod,
                      value:
                          expense.method.name[0].toUpperCase() +
                          expense.method.name.substring(1),
                    ),
                    if (expense.walletCurrency != null &&
                        expense.walletCurrency != expense.currency)
                      _ExpenseDetailRow(
                        label: context.t.chargedToYourWallet,
                        value:
                            '${PkFormat.money(expense.walletAmountMinor ?? 0, expense.walletCurrency!)}'
                            '${expense.exchangeRate == null ? '' : ' · 1 ${expense.currency} = ${expense.exchangeRate!.toStringAsPrecision(6)} ${expense.walletCurrency}'}'
                            '${expense.fxRateMode == null ? '' : ' · ${expense.fxRateMode!.name}'}',
                      ),
                    if (expense.note.isNotEmpty)
                      _ExpenseDetailRow(
                        label: context.t.note,
                        value: expense.note,
                      ),
                    if (expense.source == 'mcp')
                      _ExpenseDetailRow(
                        label: context.t.addedVia,
                        value: expense.client ?? context.t.aiConnection,
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x6,
              PkSpacing.screen,
              PkSpacing.x3,
            ),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(title: context.t.whoPaysWhat),
            ),
          ),
          if (expense.items.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                0,
                PkSpacing.screen,
                PkSpacing.x3,
              ),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  color: context.pk.sunken,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in expense.items)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(
                            '${item.label} · '
                            '${PkFormat.money(item.amountMinor, expense.currency)} · '
                            '${item.participantIds.map((id) => repo.userById(id)?.isYou == true ? 'you' : repo.userById(id)?.name ?? '?').join(', ')}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: expense.shares.map((share) {
                    final user = repo.userById(share.userId)!;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PkSpacing.x4,
                        vertical: PkSpacing.x3,
                      ),
                      child: Row(
                        children: [
                          PkAvatar(label: user.initials),
                          const SizedBox(width: PkSpacing.x3),
                          Expanded(
                            child: Text(
                              user.isYou
                                  ? context.t.x0You2(user.name)
                                  : user.name,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              PkAmountText(
                                amountMinor: share.amountMinor,
                                currency: expense.currency,
                              ),
                              Text(
                                '${(share.amountMinor / expense.totalMinor * 100).round()}%',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          if (expense.attachments.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x6,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: PkAttachmentStrip(
                  attachments: expense.attachments,
                  title: context.t.receipts,
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x6,
              PkSpacing.screen,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: PkRelatedItems(
                items: [
                  PkRelatedItem(
                    icon: PkIcons.named(space.icon),
                    label: space.name,
                    detail: context.t.theSpaceThisBelongsTo,
                    route: '/spaces/${space.id}',
                  ),
                  if (linkedTransaction != null)
                    PkRelatedItem(
                      icon: Icons.account_balance_wallet_outlined,
                      label: context.t.yourAccountMovement,
                      detail: PkFormat.money(
                        linkedTransaction.amountMinor,
                        linkedTransaction.currency,
                      ),
                      route: '/activity/${linkedTransaction.id}',
                    ),
                  for (final budget in repo.budgets.where(
                    (item) =>
                        item.spaceId == space.id &&
                        (item.categoryId == expense.categoryId ||
                            item.categoryId == 'all'),
                  ))
                    PkRelatedItem(
                      icon: Icons.donut_large_rounded,
                      label: budget.name,
                      detail: context.t.sharedBudget,
                      route: '/budgets/${budget.id}',
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Voids the expense instead of removing it.
  ///
  /// Everyone in the Space can still see that it existed and that it was
  /// undone — a shared ledger where a row can vanish is one nobody can argue
  /// from.
  Future<void> _void(
    BuildContext context,
    PockitoRepository repo,
    SharedExpense expense,
  ) async {
    final reason = await showPkReasonSheet(
      context,
      title: context.t.voidX0(expense.title),
      message: context.t.itStaysVisibleToEveryone,
      hint: context.t.whyOptional,
      confirmLabel: context.t.voidIt,
      destructive: true,
    );
    if (reason == null || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.voidSharedExpense(
        expense.id,
        reason: reason.trim().isEmpty ? null : reason.trim(),
      ),
      token: 'void_${expense.id}',
      undoMessage: context.t.voidedX02(expense.title),
      onUndo: () => repo.restoreSharedExpense(expense.id),
    );
    if (context.mounted) context.pop();
  }
}

class CreateSpaceScreen extends StatefulWidget {
  const CreateSpaceScreen({super.key});
  @override
  State<CreateSpaceScreen> createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends State<CreateSpaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _inviteNames = TextEditingController(text: 'Kana, Fran');
  final _inviteEmails = TextEditingController(
    text: 'kana@example.com, fran@example.com', // i18n-exempt
  );
  final _budget = TextEditingController(text: '300000');
  int _step = 0;
  SpaceType _type = SpaceType.household;
  late String _currency;
  int _colorIndex = 2;
  String _icon = 'housing';

  @override
  void initState() {
    super.initState();
    _currency = context
        .read<PockitoAppViewModel>()
        .repository
        .profile
        .reportingCurrency;
  }

  @override
  void dispose() {
    _name.dispose();
    _inviteNames.dispose();
    _inviteEmails.dispose();
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(
      title: Text(context.t.createASpace),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(context.t.cancel),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(PkSpacing.screen),
              children: [
                Row(
                  children: List.generate(
                    2,
                    (index) => Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.only(
                          end: index == 0 ? 8 : 0,
                        ),
                        child: PkProgressBar(
                          value: index <= _step ? 1 : 0,
                          color: index <= _step
                              ? context.pk.shared
                              : context.pk.borderSubtle,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: PkSpacing.x6),
                Text(
                  _step == 0
                      ? context.t.whatAreYouSharing
                      : context.t.inviteSomeone,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: PkSpacing.x2),
                Text(
                  _step == 0
                      ? context.t.theSpaceCurrencyIsThe
                      : context.t.youCanShareAnInvite,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
                const SizedBox(height: PkSpacing.x6),
                if (_step == 0) ...[
                  TextFormField(
                    key: const ValueKey('space_name'),
                    controller: _name,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t.spaceName,
                      hintText: context.t.eGFlatOrTokyo,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.t.nameYourSpace
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<SpaceType>(
                    initialValue: _type,
                    decoration: InputDecoration(labelText: context.t.type),
                    items: SpaceType.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item,
                            child: Text(
                              item.name[0].toUpperCase() +
                                  item.name.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _type = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('space_currency'),
                    initialValue: _currency,
                    decoration: InputDecoration(
                      labelText: context.t.spaceCurrency,
                    ),
                    items: PockitoCurrencies.all.keys
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _currency = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('space_icon'),
                    initialValue: _icon,
                    decoration: InputDecoration(labelText: context.t.icon),
                    items:
                        {
                              'housing': context.t.home,
                              'group': context.t.people,
                              'travel': context.t.trip,
                              'heart': context.t.couple,
                            }.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.key,
                                child: Text(entry.value),
                              ),
                            )
                            .toList(),
                    onChanged: (value) => setState(() => _icon = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  Text(
                    context.t.colour,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Wrap(
                    spacing: PkSpacing.x2,
                    children: List.generate(8, (index) {
                      final value = index + 1;
                      return ChoiceChip(
                        key: ValueKey('space_color_$value'),
                        avatar: CircleAvatar(
                          backgroundColor: PkPalette.categoryAt(value),
                        ),
                        label: Text('$value'),
                        selected: _colorIndex == value,
                        onSelected: (_) => setState(() => _colorIndex = value),
                      );
                    }),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  TextFormField(
                    key: const ValueKey('space_budget'),
                    controller: _budget,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.t.monthlySpaceBudgetOptional,
                      prefixText: '${PockitoCurrencies.of(_currency).symbol} ',
                      helperText: context.t.resetsForANewMonth,
                    ),
                    validator: (value) =>
                        value != null &&
                            value.isNotEmpty &&
                            (double.tryParse(value) ?? -1) <= 0
                        ? context.t.enterABudgetGreaterThan
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x6),
                  FilledButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _step = 1);
                      }
                    },
                    child: Text(context.t.continueLabel),
                  ),
                ] else ...[
                  TextField(
                    key: const ValueKey('space_invite_names'),
                    controller: _inviteNames,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t.names,
                      hintText: context.t.sampleMemberNames,
                      helperText: context.t.separateMultiplePeopleWithCommas,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  TextField(
                    key: const ValueKey('space_invite_emails'),
                    controller: _inviteEmails,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: context.t.emails,
                      hintText:
                          'kana@example.com, fran@example.com', // i18n-exempt
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  PkCard(
                    color: context.pk.sharedSurface,
                    borderColor: context.pk.sharedBorder,
                    child: Row(
                      children: [
                        Icon(
                          Icons.link_rounded,
                          color: context.pk.sharedStrong,
                        ),
                        const SizedBox(width: PkSpacing.x3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.inviteLinkReady,
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                              Text(
                                'pockito.app/invite/${_name.text.toLowerCase().replaceAll(' ', '-')}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(context.t.inviteLinkCopied),
                                ),
                              ),
                          child: Text(context.t.copy),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x6),
                  FilledButton(
                    onPressed: _create,
                    child: Text(
                      _inviteNames.text.trim().isEmpty
                          ? context.t.createSpace
                          : context.t.createAndInvite,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  TextButton(
                    onPressed: _create,
                    child: Text(context.t.skipInvitation),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _create() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    // Read before the await: the strings outlive the context across the gap.
    final t = context.t;
    final space = await repo.saveSpace(
      SharedSpace(
        id: '',
        name: _name.text.trim(),
        type: _type,
        currency: _currency,
        members: [
          SpaceMember(userId: repo.currentUserId, role: SpaceRole.owner),
        ],
        defaultSplitMethod: SplitMethod.equal,
        colorIndex: _colorIndex,
        icon: _icon,
      ),
    );
    final budgetValue = double.tryParse(_budget.text);
    if (budgetValue != null && budgetValue > 0) {
      await repo.saveBudget(
        Budget(
          id: '',
          name: t.x0Monthly(space.name),
          scope: BudgetScope.space,
          categoryId: 'all',
          limitMinor:
              (budgetValue * PockitoCurrencies.of(_currency).minorUnitScale)
                  .round(),
          currency: _currency,
          spaceId: space.id,
          startsOn: DateTime(repo.today.year, repo.today.month),
        ),
      );
    }
    final names = _inviteNames.text
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
    final emails = _inviteEmails.text
        .split(',')
        .map((value) => value.trim())
        .toList();
    for (final entry in names.indexed) {
      await repo.inviteMember(
        space.id,
        name: entry.$2,
        email: entry.$1 < emails.length && emails[entry.$1].isNotEmpty
            ? emails[entry.$1]
            : '${entry.$2.toLowerCase().replaceAll(' ', '.')}@example.com',
      );
    }
    if (!mounted) return;
    final enabled = await showPkNotificationPrePrompt(context);
    if (!mounted) return;
    if (enabled == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.notificationPreviewsTurnedOn)),
      );
    }
    context.go('/spaces');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.t.createdInvitationsPending(space.name))),
    );
  }
}

class SpaceMembersScreen extends StatefulWidget {
  const SpaceMembersScreen({super.key, required this.spaceId});
  final String spaceId;

  @override
  State<SpaceMembersScreen> createState() => _SpaceMembersScreenState();
}

class _SpaceMembersScreenState extends State<SpaceMembersScreen> {
  String _query = '';

  String get spaceId => widget.spaceId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.group_off_outlined,
          title: context.t.spaceNotFound,
          message: context.t.itMayHaveBeenRemoved2,
        ),
      );
    }
    final permissions = repo.permissionsFor(space.id);
    final invitations = repo.invitations
        .where((invitation) => invitation.spaceId == space.id)
        .toList();
    final pending = invitations
        .where(
          (invitation) =>
              invitation.effectiveStatus(repo.today) ==
              InvitationStatus.pending,
        )
        .toList();
    final resolved = invitations
        .where(
          (invitation) =>
              invitation.effectiveStatus(repo.today) !=
              InvitationStatus.pending,
        )
        .toList();
    // Above roughly eight rows a list stops being scannable, so members get a
    // search field of their own.
    final query = _query.trim().toLowerCase();
    final members = space.members.where((member) {
      if (query.isEmpty) return true;
      final user = repo.userById(member.userId);
      return (user?.name ?? '').toLowerCase().contains(query) ||
          member.role.labelIn(context.t).toLowerCase().contains(query);
    }).toList();
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.membersInvites),
        actions: [
          PkPermissionGate(
            allowed: permissions.canInvite,
            title: context.t.youCanTInvitePeople,
            reason: permissions.readOnly
                ? permissions.role == SpaceRole.viewer
                      ? context.t.viewersCanSeeEverythingAnd
                      : context.t.thisSpaceIsArchivedSo
                : context.t.onlyOwnersAndAdminsCan,
            whoCanHelp: repo.whoCanHelp(space.id, 'canInvite'),
            child: TextButton(
              key: const ValueKey('invite_member'),
              onPressed: () => _showInvite(context, space),
              child: Text(context.t.invite),
            ),
          ),
        ],
      ),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            if (permissions.readOnly) ...[
              PkReadOnlyRibbon.forSpace(
                t: context.t,
                permissions: permissions,
                archived: space.status == SpaceStatus.archived,
                spaceName: space.name,
              ),
              const SizedBox(height: PkSpacing.x4),
            ],
            PkSectionHeader(
              title: context.t.members2,
              trailing: Text(
                '${space.members.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            if (space.members.length > 8) ...[
              PkSearchField(
                value: _query,
                hintText: context.t.searchX0Members(space.members.length),
                resultCount: members.length,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: PkSpacing.x3),
            ],
            if (members.isEmpty)
              PkListState.empty(
                icon: Icons.group_off_outlined,
                title: context.t.nobodyMatches(_query),
                message: context.t.tryADifferentNameOr,
                actionLabel: context.t.actionClearSearch,
                onAction: () => setState(() => _query = ''),
              )
            else
              PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.avatarMember + PkSpacing.x3,
                children: [
                  for (final member in members)
                    if (repo.userById(member.userId) case final user?)
                      PkMemberRow(
                        key: ValueKey('member_${user.id}'),
                        user: user,
                        role: member.role,
                        balanceMinor: repo.memberBalance(space.id, user.id),
                        currency: space.currency,
                        subtitle: member.role.labelIn(context.t),
                        onTap: () =>
                            _memberActions(context, repo, space, member, user),
                      ),
                ],
              ),
            if (pending.isNotEmpty) ...[
              const SizedBox(height: PkSpacing.x6),
              PkSectionHeader(
                title: context.t.pendingInvitesX0(pending.length),
              ),
              ...pending.map((invitation) {
                final daysLeft = invitation.expiresAt
                    .difference(repo.today)
                    .inDays;
                return Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                  child: PkCard(
                    key: ValueKey('invite_${invitation.id}'),
                    variant: PkCardVariant.dense,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PkLedgerRow(
                          density: PkRowDensity.rich,
                          leading: PkAvatar(
                            label: invitation.name.characters.first,
                            color: context.pk.sharedStrong,
                          ),
                          title: invitation.name,
                          badges: [
                            PkStatusBadge(
                              label: context.t.pending,
                              tone: PkStatusTone.shared,
                              icon: Icons.schedule_rounded,
                            ),
                          ],
                          // An invite with no visible expiry is a link the user
                          // assumes lives forever.
                          subtitle: context.t.x0AsX1X2X3(
                            invitation.email,
                            invitation.role.labelIn(context.t),
                            daysLeft <= 0
                                ? context.t.expiresToday
                                : context.t.expiresInX0Days(daysLeft),
                            invitation.resendCount > 0
                                ? context.t.resentX0Times(
                                    invitation.resendCount,
                                  )
                                : '',
                          ),
                        ),
                        Wrap(
                          spacing: PkSpacing.x2,
                          children: [
                            if (permissions.canInvite) ...[
                              TextButton.icon(
                                key: ValueKey('resend_${invitation.id}'),
                                onPressed: () => PkGuardedAction.run(
                                  context,
                                  () => repo.resendInvitation(invitation.id),
                                  successMessage: context.t.inviteResentTo(
                                    invitation.name,
                                  ),
                                ),
                                icon: const Icon(Icons.send_rounded, size: 16),
                                label: Text(context.t.resend),
                              ),
                              TextButton.icon(
                                key: ValueKey('revoke_${invitation.id}'),
                                onPressed: () =>
                                    _revoke(context, repo, invitation),
                                icon: const Icon(
                                  Icons.link_off_rounded,
                                  size: 16,
                                ),
                                label: Text(context.t.revoke),
                              ),
                            ],
                            // The other side of the invite happens on their
                            // device. These stand in for it.
                            FilledButton.tonal(
                              key: ValueKey('accept_${invitation.name}'),
                              onPressed: () => PkGuardedAction.run(
                                context,
                                () => repo.respondToInvitation(
                                  invitation.id,
                                  InvitationStatus.accepted,
                                ),
                                successMessage: context.t.x0JoinedAsX1(
                                  invitation.name,
                                  invitation.role
                                      .labelIn(context.t)
                                      .toLowerCase(),
                                ),
                              ),
                              child: Text(context.t.simulateAcceptance),
                            ),
                            TextButton(
                              key: ValueKey('decline_${invitation.name}'),
                              onPressed: () => repo.respondToInvitation(
                                invitation.id,
                                InvitationStatus.declined,
                              ),
                              child: Text(context.t.simulateDecline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
            if (resolved.isNotEmpty) ...[
              const SizedBox(height: PkSpacing.x6),
              PkSectionHeader(title: context.t.invitationHistory),
              PkCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: resolved.map((invitation) {
                    final status = invitation.effectiveStatus(repo.today);
                    return ListTile(
                      leading: Icon(switch (status) {
                        InvitationStatus.accepted =>
                          Icons.check_circle_outline_rounded,
                        InvitationStatus.expired => Icons.timer_off_outlined,
                        InvitationStatus.revoked => Icons.link_off_rounded,
                        _ => Icons.cancel_outlined,
                      }),
                      title: Text(invitation.name),
                      subtitle: Text(
                        context.t.x0AsX1(
                          invitation.email,
                          invitation.role.labelIn(context.t),
                        ),
                      ),
                      trailing:
                          status == InvitationStatus.expired &&
                              permissions.canInvite
                          ? TextButton(
                              key: ValueKey('reinvite_${invitation.id}'),
                              onPressed: () => PkGuardedAction.run(
                                context,
                                () => repo.resendInvitation(invitation.id),
                                successMessage: context.t.newInviteSentTo(
                                  invitation.name,
                                ),
                              ),
                              child: Text(context.t.inviteAgain),
                            )
                          : Text(
                              status.name[0].toUpperCase() +
                                  status.name.substring(1),
                            ),
                    );
                  }).toList(),
                ),
              ),
            ],
            if (pending.isEmpty && resolved.isEmpty) ...[
              const SizedBox(height: PkSpacing.x6),
              PkEmptyState(
                icon: Icons.person_add_alt_outlined,
                title: context.t.noInvitationsYet,
                message: context.t.inviteKanaFranOrAnyone,
                actionLabel: context.t.inviteSomeone,
                onAction: () => _showInvite(context, space),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _showInvite(BuildContext context, SharedSpace space) async {
    final invite = await showPkSheet<_InviteDraft>(
      context,
      builder: (context) => _InviteMemberSheet(spaceName: space.name),
    );
    if (invite == null || !context.mounted) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    await PkGuardedAction.run(
      context,
      () => repo.inviteMember(
        space.id,
        name: invite.name,
        email: invite.email.isEmpty
            ? '${invite.name.toLowerCase().replaceAll(' ', '.')}@example.com'
            : invite.email,
        role: invite.role,
        expiryDays: invite.expiryDays,
      ),
      successMessage: context.t.invitedAsExpiresInDays(
        invite.name,
        invite.role.labelIn(context.t).toLowerCase(),
        invite.expiryDays,
      ),
    );
  }

  Future<void> _revoke(
    BuildContext context,
    PockitoRepository repo,
    SpaceInvitation invitation,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.revokeSInvite(invitation.name)),
        content: Text(context.t.theLinkStopsWorkingImmediately),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.keepIt),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.pk.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.revoke),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.revokeInvitation(invitation.id),
      undoMessage: context.t.sInviteRevoked(invitation.name),
      onUndo: () => repo.resendInvitation(invitation.id),
    );
  }

  Future<void> _memberActions(
    BuildContext context,
    PockitoRepository repo,
    SharedSpace space,
    SpaceMember member,
    PockitoUser user,
  ) {
    final permissions = repo.permissionsFor(space.id);
    final owners = space.members
        .where((item) => item.active && item.role == SpaceRole.owner)
        .length;
    final isMe = user.id == repo.currentUserId;
    return showPkSheet<void>(
      context,
      builder: (context) => PkSheetScaffold(
        title: isMe ? context.t.x0You(user.name) : user.name,
        subtitle:
            '${member.role.labelIn(context.t)} · '
            '${member.role.summaryIn(context.t)}',
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.swap_horiz_rounded),
              title: Text(context.t.viewBalances),
              onTap: () {
                Navigator.pop(context);
                _showMemberBalance(context, repo, space, user);
              },
            ),
            if (!isMe)
              PkPermissionGate(
                allowed: permissions.canChangeRoles,
                title: context.t.youCanTChangeRoles,
                reason: context.t.onlyTheOwnerCanChange,
                whoCanHelp: repo.whoCanHelp(space.id, 'canChangeRoles'),
                child: ListTile(
                  key: const ValueKey('member_change_role'),
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.admin_panel_settings_outlined),
                  title: Text(context.t.changeRole),
                  subtitle: Text(
                    context.t.currentlyX0(
                      member.role.labelIn(context.t).toLowerCase(),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _changeRole(context, repo, space, member, user);
                  },
                ),
              ),
            if (!isMe)
              PkPermissionGate(
                allowed:
                    permissions.canRemoveMember &&
                    member.role != SpaceRole.owner,
                title: context.t.youCanTRemoveThis,
                reason: member.role == SpaceRole.owner
                    ? context.t.theOwnerCannotBeRemoved
                    : context.t.onlyOwnersAndAdminsCan2,
                whoCanHelp: repo.whoCanHelp(space.id, 'canRemoveMember'),
                child: ListTile(
                  key: const ValueKey('member_remove'),
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.person_remove_outlined,
                    color: context.pk.danger,
                  ),
                  title: Text(
                    context.t.removeFromSpace,
                    style: TextStyle(color: context.pk.danger),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _removeMember(context, repo, space, user);
                  },
                ),
              ),
            if (isMe)
              PkPermissionGate(
                allowed: permissions.canLeave,
                title: context.t.youCanTLeaveThis,
                reason: owners <= 1 && member.role == SpaceRole.owner
                    ? context.t.youAreTheOnlyOwner
                    : context.t.thisSpaceCannotBeLeft,
                child: ListTile(
                  key: const ValueKey('member_leave'),
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.logout_rounded, color: context.pk.danger),
                  title: Text(
                    context.t.leaveX0(space.name),
                    style: TextStyle(color: context.pk.danger),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _leave(context, repo, space);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _changeRole(
    BuildContext context,
    PockitoRepository repo,
    SharedSpace space,
    SpaceMember member,
    PockitoUser user,
  ) async {
    final picked = await showPkSheet<SpaceRole>(
      context,
      builder: (context) => PkSheetScaffold(
        title: context.t.x0SRole(user.name),
        subtitle: context.t.whatTheyCanDoChanges,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final role in SpaceRole.values)
              RadioListTile<SpaceRole>(
                key: ValueKey('role_${role.name}'),
                value: role,
                // ignore: deprecated_member_use
                groupValue: member.role,
                // ignore: deprecated_member_use
                onChanged: (value) => Navigator.pop(context, value),
                title: Text(role.label),
                subtitle: Text(role.summary),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
    if (picked == null || picked == member.role || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.setMemberRole(space.id, user.id, picked),
      successMessage: context.t.isNowA(user.name, picked.label.toLowerCase()),
      undoMessage: context.t.isNowA(user.name, picked.label.toLowerCase()),
      onUndo: () => repo.setMemberRole(space.id, user.id, member.role),
    );
  }

  Future<void> _leave(
    BuildContext context,
    PockitoRepository repo,
    SharedSpace space,
  ) async {
    final confirmed = await showPkTypedConfirm(
      context,
      title: context.t.leaveX02(space.name),
      message: context.t.youLoseAccessToIts,
      confirmationWord: space.name,
      confirmLabel: context.t.leave,
    );
    if (!confirmed || !context.mounted) return;
    final left = await PkGuardedAction.runVoid(
      context,
      () => repo.leaveSpace(space.id),
      successMessage: context.t.youLeftX0(space.name),
    );
    if (left && context.mounted) context.go('/spaces');
  }

  Future<void> _showMemberBalance(
    BuildContext context,
    dynamic repo,
    SharedSpace space,
    PockitoUser user,
  ) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(context.t.x0SBalance(user.name)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExpenseDetailRow(
            label: context.t.currentCycle,
            value: PkFormat.money(
              repo.memberBalance(space.id, user.id),
              space.currency,
              sign: true,
            ),
          ),
          _ExpenseDetailRow(
            label: context.t.lifetime,
            value: PkFormat.money(
              repo.memberBalance(space.id, user.id, lifetime: true),
              space.currency,
              sign: true,
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.t.actionDone),
        ),
      ],
    ),
  );

  Future<void> _removeMember(
    BuildContext context,
    dynamic repo,
    SharedSpace space,
    PockitoUser user,
  ) async {
    final balance = repo.memberBalance(space.id, user.id);
    if (balance != 0) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.t.settleTheBalanceFirst),
          content: Text(
            context.t.hasABalanceInThis(
              user.name,
              PkFormat.money(balance.abs(), space.currency),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t.notNow),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                context.push('/spaces/${space.id}/settle');
              },
              child: Text(context.t.quickSettleUp),
            ),
          ],
        ),
      );
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.removeX02(user.name)),
        content: Text(context.t.theyWillKeepAccessTo),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.pk.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.remove),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await repo.saveSpace(
      space.copyWith(
        members: space.members
            .where((member) => member.userId != user.id)
            .toList(),
        defaultPercentages: Map.of(space.defaultPercentages)..remove(user.id),
        defaultAllocations: Map.of(space.defaultAllocations)..remove(user.id),
      ),
    );
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.x0Removed(user.name))));
    }
  }
}

/// What the invite sheet returns: who, at what role, and for how long.
class _InviteDraft {
  const _InviteDraft({
    required this.name,
    required this.email,
    required this.role,
    required this.expiryDays,
  });

  final String name;
  final String email;
  final SpaceRole role;
  final int expiryDays;
}

class _InviteMemberSheet extends StatefulWidget {
  const _InviteMemberSheet({required this.spaceName});

  final String spaceName;

  @override
  State<_InviteMemberSheet> createState() => _InviteMemberSheetState();
}

class _InviteMemberSheetState extends State<_InviteMemberSheet> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  SpaceRole _role = SpaceRole.member;

  /// A week is long enough to accept and short enough that a forwarded link
  /// does not stay live indefinitely.
  int _expiryDays = 7;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsetsDirectional.fromSTEB(
      PkSpacing.x4,
      PkSpacing.x2,
      PkSpacing.x4,
      PkSpacing.x6 + MediaQuery.viewInsetsOf(context).bottom,
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.t.inviteToX0(widget.spaceName),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: PkSpacing.x4),
        TextField(
          key: const ValueKey('invite_name'),
          controller: _name,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: context.t.name),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: PkSpacing.x3),
        TextField(
          key: const ValueKey('invite_email'),
          controller: _email,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(labelText: context.t.email),
        ),
        const SizedBox(height: PkSpacing.x4),
        // Naming the role at invite time is what makes the invitee's review
        // screen able to say what they are agreeing to.
        Text(context.t.joinAs, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: PkSpacing.x2),
        for (final role in const [
          SpaceRole.admin,
          SpaceRole.member,
          SpaceRole.viewer,
        ])
          RadioListTile<SpaceRole>(
            key: ValueKey('invite_role_${role.name}'),
            value: role,
            // ignore: deprecated_member_use
            groupValue: _role,
            // ignore: deprecated_member_use
            onChanged: (value) => setState(() => _role = value ?? _role),
            title: Text(role.label),
            subtitle: Text(role.summary),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        const SizedBox(height: PkSpacing.x3),
        Text(
          context.t.linkExpiresIn,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: PkSpacing.x2),
        Wrap(
          spacing: PkSpacing.x2,
          children: [
            for (final days in const [1, 7, 14, 30])
              ChoiceChip(
                key: ValueKey('invite_expiry_$days'),
                label: Text(context.t.x0DayX1(days, days == 1 ? '' : 's')),
                selected: _expiryDays == days,
                onSelected: (_) => setState(() => _expiryDays = days),
              ),
          ],
        ),
        const SizedBox(height: PkSpacing.x4),
        OutlinedButton.icon(
          onPressed: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.t.inviteLinkCopied))),
          icon: const Icon(Icons.link_rounded),
          label: Text(context.t.copyInviteLink),
        ),
        const SizedBox(height: PkSpacing.x2),
        FilledButton(
          key: const ValueKey('send_invite'),
          onPressed: _name.text.trim().isEmpty
              ? null
              : () => Navigator.pop(
                  context,
                  _InviteDraft(
                    name: _name.text.trim(),
                    email: _email.text.trim(),
                    role: _role,
                    expiryDays: _expiryDays,
                  ),
                ),
          child: Text(context.t.sendInvite),
        ),
      ],
    ),
  );
}

class SpaceSettingsScreen extends StatefulWidget {
  const SpaceSettingsScreen({super.key, required this.spaceId});
  final String spaceId;

  @override
  State<SpaceSettingsScreen> createState() => _SpaceSettingsScreenState();
}

class _SpaceSettingsScreenState extends State<SpaceSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.group_off_outlined,
          title: context.t.spaceNotFound,
          message: context.t.itMayHaveBeenRemoved2,
        ),
      );
    }
    final permissions = repo.permissionsFor(space.id);
    final archived = space.status == SpaceStatus.archived;
    final canEdit = permissions.canEditSettings;
    final reason = permissions.readOnly
        ? archived
              ? context.t.thisSpaceIsArchivedSo
              : context.t.viewersCanSeeEverythingAnd
        : context.t.onlyOwnersAndAdminsCan3;
    final helpers = repo.whoCanHelp(space.id, 'canEditSettings');
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.spaceSettings)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            if (permissions.readOnly) ...[
              PkReadOnlyRibbon.forSpace(
                t: context.t,
                permissions: permissions,
                archived: archived,
                spaceName: space.name,
                onReopen: permissions.canArchive
                    ? () => PkGuardedAction.run(
                        context,
                        () => repo.archiveSpace(space.id, false),
                        successMessage: context.t.isOpenAgain(space.name),
                      )
                    : null,
              ),
              const SizedBox(height: PkSpacing.x4),
            ],
            PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  PkPermissionGate(
                    allowed: canEdit,
                    reason: reason,
                    whoCanHelp: helpers,
                    child: ListTile(
                      key: const ValueKey('space_rename'),
                      leading: PkIconTile(
                        icon: PkIcons.named(space.icon),
                        color: PkPalette.categoryAt(space.colorIndex),
                        size: 40,
                      ),
                      title: Text(space.name),
                      // Two Spaces can share a name; the type is what tells them
                      // apart, so it belongs wherever the name appears.
                      subtitle: Text(
                        context.t.members(
                          space.type.label,
                          space.currency,
                          space.members.length,
                        ),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _rename(context, repo, space),
                    ),
                  ),
                  PkPermissionGate(
                    allowed: canEdit,
                    reason: reason,
                    whoCanHelp: helpers,
                    child: ListTile(
                      key: const ValueKey('space_default_split'),
                      leading: const Icon(Icons.pie_chart_outline_rounded),
                      title: Text(context.t.defaultSplit),
                      subtitle: Text(_defaultSplitLabel(repo, space)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => _defaultSplit(context, repo, space),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.group_outlined),
                    title: Text(context.t.membersInvites),
                    subtitle: Text(
                      context.t.youAreX0(
                        permissions.role.labelIn(context.t).toLowerCase(),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push('/spaces/${widget.spaceId}/members'),
                  ),
                  ListTile(
                    key: const ValueKey('space_activity_log'),
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(context.t.activityLog),
                    subtitle: Text(context.t.whoChangedWhatAndWhen),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () =>
                        context.push('/spaces/${widget.spaceId}/activity'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(title: context.t.notifications),
            PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile.adaptive(
                    title: Text(context.t.newExpenses),
                    value: space.notifyNewExpenses,
                    onChanged: archived
                        ? null
                        : (value) => repo.saveSpace(
                            space.copyWith(notifyNewExpenses: value),
                          ),
                  ),
                  SwitchListTile.adaptive(
                    title: Text(context.t.settlements),
                    value: space.notifySettlements,
                    onChanged: archived
                        ? null
                        : (value) => repo.saveSpace(
                            space.copyWith(notifySettlements: value),
                          ),
                  ),
                  SwitchListTile.adaptive(
                    title: Text(context.t.allActivity),
                    subtitle: Text(context.t.includesMemberAndSettingsChanges),
                    value: space.notifyAllActivity,
                    onChanged: archived
                        ? null
                        : (value) => repo.saveSpace(
                            space.copyWith(notifyAllActivity: value),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkPermissionGate(
              allowed: permissions.canArchive,
              reason: context.t.onlyTheOwnerCanArchive,
              whoCanHelp: repo.whoCanHelp(space.id, 'canArchive'),
              child: OutlinedButton.icon(
                key: const ValueKey('space_archive'),
                onPressed: () => archived
                    ? PkGuardedAction.run(
                        context,
                        () => repo.archiveSpace(space.id, false),
                        successMessage: context.t.isOpenAgain(space.name),
                      )
                    : _archive(context, repo, space),
                icon: Icon(
                  archived ? Icons.unarchive_outlined : Icons.archive_outlined,
                ),
                label: Text(
                  archived ? context.t.reopenSpace : context.t.archiveSpace,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rename(
    BuildContext context,
    dynamic repo,
    SharedSpace space,
  ) async {
    final controller = TextEditingController(text: space.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.renameSpace),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: context.t.spaceName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(context.t.actionSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.isNotEmpty) {
      await repo.saveSpace(space.copyWith(name: name));
    }
  }

  Future<void> _defaultSplit(
    BuildContext context,
    dynamic repo,
    SharedSpace space,
  ) async {
    var method = space.defaultSplitMethod;
    final values = <String, TextEditingController>{
      for (final member in space.members)
        member.userId: TextEditingController(
          text: method == SplitMethod.percentage
              ? (space.defaultPercentages[member.userId] ??
                        (100 / space.members.length).round())
                    .toString()
              : (space.defaultAllocations[member.userId] ?? 1).toString(),
        ),
    };
    final saved = await showPkSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          double total() => values.values.fold(
            0,
            (sum, controller) => sum + (double.tryParse(controller.text) ?? 0),
          );
          final valid = switch (method) {
            SplitMethod.percentage => (total() - 100).abs() < .01,
            SplitMethod.shares => total() > 0,
            _ => true,
          };
          return PkSheetScaffold(
            title: context.t.defaultSplit,
            subtitle: context.t.automaticallyPreFillsEveryNew,
            // The member list scrolls on its own, so the sheet must not wrap
            // it in a second scroll view.
            scrollable: false,
            footer: FilledButton(
              key: const ValueKey('save_default_split'),
              onPressed: valid ? () => Navigator.pop(context, true) : null,
              child: Text(context.t.saveDefaultSplit),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: PkSpacing.x4),
                Wrap(
                  spacing: PkSpacing.x2,
                  runSpacing: PkSpacing.x2,
                  children: SplitMethod.values
                      .map(
                        (item) => ChoiceChip(
                          key: ValueKey('default_split_${item.name}'),
                          label: Text(switch (item) {
                            SplitMethod.equal => context.t.equal,
                            SplitMethod.percentage => context.t.percentage,
                            SplitMethod.shares => context.t.shares,
                            SplitMethod.exact => context.t.exact,
                            SplitMethod.itemized => context.t.itemized,
                          }),
                          selected: method == item,
                          onSelected: (_) => setSheetState(() => method = item),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: PkSpacing.x4),
                if (method == SplitMethod.exact)
                  PkCard(
                    color: context.pk.sharedSurface,
                    borderColor: context.pk.sharedBorder,
                    child: Text(context.t.exactAmountsDependOnThe),
                  )
                else if (method == SplitMethod.percentage ||
                    method == SplitMethod.shares)
                  Expanded(
                    child: ListView(
                      children: space.members.map((member) {
                        final user = repo.userById(member.userId);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: PkSpacing.x3),
                          child: TextField(
                            key: ValueKey('default_value_${user?.name}'),
                            controller: values[member.userId],
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: user?.isYou == true
                                  ? context.t.x0You2(user?.name)
                                  : user?.name ?? context.t.roleMember,
                              suffixText: method == SplitMethod.percentage
                                  ? '%'
                                  : context.t.shares,
                            ),
                            onChanged: (_) => setSheetState(() {}),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                else
                  Expanded(
                    child: Center(
                      child: Text(
                        context.t.everyoneReceivesAnEqualResponsibility,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ),
                if (!valid)
                  Text(
                    method == SplitMethod.percentage
                        ? context.t.percentagesMustTotalCurrently(
                            total().toStringAsFixed(1),
                          )
                        : context.t.enterAtLeastOnePositive2,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: context.pk.danger),
                  ),
              ],
            ),
          );
        },
      ),
    );
    if (saved == true) {
      await repo.saveSpace(
        space.copyWith(
          defaultSplitMethod: method,
          defaultPercentages: method == SplitMethod.percentage
              ? {
                  for (final entry in values.entries)
                    entry.key: (double.parse(entry.value.text)).round(),
                }
              : {},
          defaultAllocations: method == SplitMethod.shares
              ? {
                  for (final entry in values.entries)
                    entry.key: (double.parse(entry.value.text)).round(),
                }
              : {},
        ),
      );
    }
    // The modal result completes before its reverse animation has removed the
    // text fields. Keep their controllers alive until that route is gone.
    await Future<void>.delayed(PkMotion.standard);
    for (final controller in values.values) {
      controller.dispose();
    }
  }

  String _defaultSplitLabel(
    dynamic repo,
    SharedSpace space,
  ) => switch (space.defaultSplitMethod) {
    SplitMethod.equal => context.t.equalAcrossMembers(space.members.length),
    SplitMethod.percentage =>
      space.members
          .map(
            (member) =>
                '${repo.userById(member.userId)?.isYou == true ? 'You' : repo.userById(member.userId)?.name} ${space.defaultPercentages[member.userId] ?? 0}%',
          )
          .join(' · '),
    SplitMethod.shares =>
      space.members
          .map(
            (member) =>
                '${repo.userById(member.userId)?.isYou == true ? 'You' : repo.userById(member.userId)?.name} ${space.defaultAllocations[member.userId] ?? 1}',
          )
          .join(' · '),
    SplitMethod.exact => context.t.exactAmountsConfirmPerExpense,
    SplitMethod.itemized => context.t.itemizedAssignEachLinePer,
  };

  Future<void> _archive(
    BuildContext context,
    dynamic repo,
    SharedSpace space,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.archiveX0(space.name)),
        content: Text(context.t.membersCanNoLongerAdd),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.archive),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await repo.saveSpace(space.copyWith(status: SpaceStatus.archived));
      if (context.mounted) context.go('/spaces');
    }
  }
}

class SettleUpScreen extends StatefulWidget {
  const SettleUpScreen({super.key, required this.spaceId});
  final String spaceId;
  @override
  State<SettleUpScreen> createState() => _SettleUpScreenState();
}

class _SettleUpScreenState extends State<SettleUpScreen> {
  late final TextEditingController _amount;
  late final TextEditingController _note;
  String? _accountId;
  String? _fromUserId;
  String? _toUserId;
  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId)!;
    final recommendation = repo.settlementRecommendations(space.id).firstOrNull;
    final balance = recommendation?.amountMinor ?? 0;
    _fromUserId = recommendation?.fromUserId;
    _toUserId = recommendation?.toUserId;
    _amount = TextEditingController(
      text: (balance / PockitoCurrencies.of(space.currency).minorUnitScale)
          .toStringAsFixed(PockitoCurrencies.of(space.currency).decimals),
    );
    _note = TextEditingController();
    _accountId =
        repo.accounts
            .where(
              (item) =>
                  !item.archived &&
                  item.currency == space.currency &&
                  (_fromUserId == repo.currentUserId ||
                      _toUserId == repo.currentUserId),
            )
            .firstOrNull
            ?.id ??
        '__outside__';
  }

  void _useRecommendation(Settlement recommendation, SharedSpace space) {
    setState(() {
      _fromUserId = recommendation.fromUserId;
      _toUserId = recommendation.toUserId;
      _amount.text =
          (recommendation.amountMinor /
                  PockitoCurrencies.of(space.currency).minorUnitScale)
              .toStringAsFixed(PockitoCurrencies.of(space.currency).decimals);
      final repo = context.read<PockitoAppViewModel>().repository;
      if (_fromUserId != repo.currentUserId &&
          _toUserId != repo.currentUserId) {
        _accountId = '__outside__';
      }
    });
  }

  String _personName(dynamic repo, String? userId) {
    if (userId == repo.currentUserId) return context.t.you;
    return repo.userById(userId ?? '')?.name ?? 'Member';
  }

  int get _enteredMinor {
    final repo = context.read<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId)!;
    return ((double.tryParse(_amount.text) ?? 0) *
            PockitoCurrencies.of(space.currency).minorUnitScale)
        .round();
  }

  int _maxOutstanding(PockitoRepository repo, SharedSpace space) {
    return repo
            .settlementRecommendations(space.id)
            .where(
              (item) =>
                  item.fromUserId == _fromUserId && item.toUserId == _toUserId,
            )
            .firstOrNull
            ?.amountMinor ??
        0;
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId)!;
    final recommendations = repo.settlementRecommendations(space.id);
    final from = repo.userById(_fromUserId ?? '');
    final to = repo.userById(_toUserId ?? '');
    final settled = recommendations.isEmpty;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.quickSettleUp),
        actions: [
          IconButton(
            onPressed: () => context.push('/spaces/${space.id}/settlements'),
            tooltip: context.t.settlementHistory,
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(PkSpacing.screen),
              children: [
                if (settled)
                  PkEmptyState(
                    icon: Icons.check_circle_outline_rounded,
                    title: context.t.everyoneIsSettled,
                    message: context.t.thereAreNoOutstandingPayments,
                    actionLabel: context.t.backToX0(space.name),
                    onAction: () => context.pop(),
                  )
                else ...[
                  Text(
                    context.t.suggestedPayments,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Wrap(
                    spacing: PkSpacing.x2,
                    runSpacing: PkSpacing.x2,
                    children: recommendations.map((item) {
                      final selected =
                          item.fromUserId == _fromUserId &&
                          item.toUserId == _toUserId;
                      return ChoiceChip(
                        key: ValueKey(
                          'settlement_${item.fromUserId}_${item.toUserId}',
                        ),
                        selected: selected,
                        onSelected: (_) => _useRecommendation(item, space),
                        label: Text(
                          '${_personName(repo, item.fromUserId)} → ${_personName(repo, item.toUserId)} · ${PkFormat.money(item.amountMinor, space.currency)}',
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PkAvatar(label: from?.initials ?? '?', size: 56),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: PkSpacing.x3,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: context.pk.sharedStrong,
                        ),
                      ),
                      PkAvatar(label: to?.initials ?? '?', size: 56),
                    ],
                  ),
                  const SizedBox(height: PkSpacing.x5),
                  Text(
                    context.t.x0PayX1X2(
                      _personName(repo, _fromUserId),
                      _fromUserId == repo.currentUserId ? '' : 's',
                      _personName(repo, _toUserId),
                    ),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Text(
                    context.t.thisRecordsASettlementNever,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.pk.textSecondary,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x6),
                  TextField(
                    key: const ValueKey('settlement_amount'),
                    controller: _amount,
                    textAlign: TextAlign.center,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: Theme.of(context).textTheme.displayLarge,
                    decoration: InputDecoration(
                      prefixText: '${_symbol(space.currency)} ',
                      labelText: context.t.amount,
                      floatingLabelAlignment: FloatingLabelAlignment.center,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _accountId,
                    decoration: InputDecoration(
                      labelText: _fromUserId == repo.currentUserId
                          ? context.t.paidFrom
                          : _toUserId == repo.currentUserId
                          ? context.t.receivedIn
                          : context.t.walletMovement,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: '__outside__',
                        child: Text(context.t.outsidePockitoNoWalletMovement),
                      ),
                      ...repo.accounts
                          .where((item) => !item.archived)
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text('${item.name} · ${item.currency}'),
                            ),
                          ),
                    ],
                    onChanged: (value) => setState(() => _accountId = value),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  TextField(
                    controller: _note,
                    key: const ValueKey('settlement_note'),
                    decoration: InputDecoration(
                      labelText: context.t.noteOptional,
                      hintText: context.t.eGAugustUtilities,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x8),
                  FilledButton(
                    key: const ValueKey('review_settlement'),
                    onPressed: () => _review(context, space),
                    child: Text(context.t.reviewSettlement),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _symbol(String code) => PockitoCurrencies.of(code).symbol;

  Future<void> _review(BuildContext context, SharedSpace space) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final amount = _enteredMinor;
    final maxOutstanding = _maxOutstanding(repo, space);
    if (amount <= 0 || _fromUserId == null || _toUserId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.enterAValidAmount)));
      return;
    }
    if (amount > maxOutstanding) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.t.amountCannotExceed(
              PkFormat.money(maxOutstanding, space.currency),
            ),
          ),
        ),
      );
      return;
    }
    final needsTheirConfirmation = _toUserId != repo.currentUserId;
    final recipientName = _personName(repo, _toUserId);
    final confirmed = await showPkSheet<bool>(
      context,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x4,
            0,
            PkSpacing.x4,
            PkSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t.reviewSettlement,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x4),
              _ExpenseDetailRow(label: context.t.spaceLabel, value: space.name),
              _ExpenseDetailRow(
                label: context.t.from,
                value: _personName(repo, _fromUserId),
              ),
              _ExpenseDetailRow(
                label: context.t.to,
                value: _personName(repo, _toUserId),
              ),
              _ExpenseDetailRow(
                label: context.t.amount,
                value: PkFormat.money(amount, space.currency),
              ),
              _ExpenseDetailRow(
                label: context.t.accountLabel,
                value: _accountId == '__outside__'
                    ? context.t.outsidePockitoNoWalletMovement
                    : repo.accountById(_accountId!)?.name ?? 'Account',
              ),
              const SizedBox(height: PkSpacing.x4),
              // A settlement only shifts balances once the person receiving
              // the money agrees it arrived. Say so before the button, so
              // nobody expects the balance to move immediately.
              PkCard(
                color: needsTheirConfirmation
                    ? context.pk.sharedSurface
                    : context.pk.sunken,
                borderColor: needsTheirConfirmation
                    ? context.pk.sharedBorder
                    : context.pk.borderSubtle,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      needsTheirConfirmation
                          ? Icons.hourglass_top_rounded
                          : Icons.check_circle_outline_rounded,
                      size: PkSize.icon,
                      color: needsTheirConfirmation
                          ? context.pk.sharedStrong
                          : context.pk.success,
                    ),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(
                      child: Text(
                        needsTheirConfirmation
                            ? context.t.confirmsThisBeforeAnyBalance(
                                recipientName,
                              )
                            : context.t.youAreTheOneBeing,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  needsTheirConfirmation
                      ? context.t.sendForConfirmation
                      : context.t.confirmSettlement,
                ),
              ),
              const SizedBox(height: PkSpacing.x2),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.t.goBack),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final settlement = await repo.proposeSettlement(
      Settlement(
        id: '',
        spaceId: space.id,
        fromUserId: _fromUserId!,
        toUserId: _toUserId!,
        amountMinor: amount,
        currency: space.currency,
        createdAt: repo.today,
        note: _note.text.trim(),
      ),
      accountId: _accountId == '__outside__' ? null : _accountId,
    );
    if (!context.mounted) return;
    if (settlement.isConfirmed) {
      context.go('/spaces/${space.id}/settled');
    } else {
      context.go('/spaces/${space.id}/settlements/${settlement.id}?proposed=1');
    }
  }
}

class SettlementSuccessScreen extends StatelessWidget {
  const SettlementSuccessScreen({super.key, required this.spaceId});
  final String spaceId;
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(spaceId)!;
    final remaining = repo.settlementRecommendations(spaceId);
    final fullySettled = remaining.isEmpty;
    final currentHasExpenses = repo.sharedExpenses.any(
      (item) =>
          item.spaceId == space.id && item.cycleId == space.currentCycleId,
    );
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(PkSpacing.x6),
              children: [
                const SizedBox(height: PkSpacing.x6),
                Align(
                  child: KitoReveal(
                    child: KitoImage(
                      asset: fullySettled
                          ? KitoAsset.celebrating
                          : KitoAsset.defaultPose,
                      width: 176,
                      height: 176,
                    ),
                  ),
                ),
                const SizedBox(height: PkSpacing.x6),
                Text(
                  fullySettled
                      ? context.t.everyoneIsSettled
                      : context.t.partialSettlementRecorded,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: PkSpacing.x2),
                Text(
                  fullySettled
                      ? context.t.everyMemberIsAtExpenses(
                          PkFormat.money(0, space.currency),
                        )
                      : context.t.x0PaymentX1RemainThisWalletMovementDidNotCou(
                          remaining.length,
                          remaining.length == 1 ? '' : 's',
                        ),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
                const SizedBox(height: PkSpacing.x8),
                if (fullySettled && currentHasExpenses) ...[
                  FilledButton.icon(
                    key: const ValueKey('settlement_start_new_cycle'),
                    onPressed: () async {
                      await repo.startNewCycle(space.id);
                      if (context.mounted) context.go('/spaces');
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(context.t.startNewCycle),
                  ),
                  const SizedBox(height: PkSpacing.x2),
                ],
                FilledButton(
                  onPressed: () => context.go('/spaces'),
                  child: Text(context.t.backToSpaces),
                ),
                if (!fullySettled) ...[
                  const SizedBox(height: PkSpacing.x2),
                  OutlinedButton(
                    onPressed: () => context.go('/spaces/$spaceId/settle'),
                    child: Text(context.t.settleRemainingBalance),
                  ),
                ],
                const SizedBox(height: PkSpacing.x2),
                TextButton(
                  onPressed: () => context.go('/spaces/$spaceId/settlements'),
                  child: Text(context.t.viewSettlementHistory),
                ),
                const SizedBox(height: PkSpacing.x6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettlementHistoryScreen extends StatelessWidget {
  const SettlementHistoryScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.group_off_outlined,
          title: context.t.spaceNotFound,
          message: context.t.itsSettlementHistoryIsNo,
        ),
      );
    }
    final settlements =
        repo.settlements.where((item) => item.spaceId == spaceId).toList()
          ..sort((a, b) {
            final aDate = a.settledAt ?? a.createdAt;
            final bDate = b.settledAt ?? b.createdAt;
            return bDate.compareTo(aDate);
          });
    final pending = settlements.where((item) => item.isPending).toList();
    final completed = settlements.where((item) => !item.isPending).toList();
    final confirmed = completed.where((item) => item.isConfirmed).toList();
    final confirmedTotal = confirmed.fold(
      0,
      (sum, settlement) => sum + settlement.amountMinor,
    );
    final cycleClosedOn = confirmed
        .map((item) => item.settledAt)
        .whereType<DateTime>()
        .firstOrNull;

    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.settlementHistory)),
      body: PkPage(
        bottomPadding: space.status == SpaceStatus.active ? 112 : 32,
        refresh: context.read<PockitoAppViewModel>().simulateRefresh,
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x4,
            ),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                color: context.pk.sunken,
                child: Row(
                  children: [
                    PkIconTile(
                      icon: Icons.handshake_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            space.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            context.t.x0X1X2Total(
                              confirmed.length,
                              confirmed.length == 1
                                  ? 'settlement'
                                  : 'settlements',
                              PkFormat.money(confirmedTotal, space.currency),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (settlements.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.handshake_outlined,
                title: context.t.noSettlementsYet,
                message: context.t.whenSomeonePaysAnotherBack,
                actionLabel: space.status == SpaceStatus.active
                    ? 'Settle up'
                    : null,
                onAction: space.status == SpaceStatus.active
                    ? () => context.push('/spaces/$spaceId/settle')
                    : null,
              ),
            )
          else ...[
            if (pending.isNotEmpty) ...[
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  0,
                  PkSpacing.screen,
                  PkSpacing.x2,
                ),
                sliver: SliverToBoxAdapter(
                  child: PkSectionHeader(title: context.t.pending),
                ),
              ),
              _SettlementList(
                space: space,
                settlements: pending,
                repository: repo,
              ),
            ],
            if (completed.isNotEmpty) ...[
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  pending.isEmpty ? 0 : PkSpacing.x5,
                  PkSpacing.screen,
                  PkSpacing.x2,
                ),
                sliver: SliverToBoxAdapter(
                  child: PkSectionHeader(title: context.t.pastSettlements),
                ),
              ),
              _SettlementList(
                space: space,
                settlements: completed,
                repository: repo,
              ),
            ],
            if (cycleClosedOn != null)
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  PkSpacing.x5,
                  PkSpacing.screen,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: context.pk.borderSubtle)),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: PkSpacing.x2,
                          ),
                          child: Text(
                            context.t.cycleClosedX0(
                              PkFormat.shortDate(
                                cycleClosedOn,
                                repo.today,
                                context.t,
                              ),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.pkText.micro,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: context.pk.borderSubtle)),
                    ],
                  ),
                ),
              ),
          ],
        ],
      ),
      bottomNavigationBar: space.status == SpaceStatus.active
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  PkSpacing.x2,
                  PkSpacing.screen,
                  PkSpacing.x3,
                ),
                child: FilledButton.icon(
                  onPressed: () => context.push('/spaces/$spaceId/settle'),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(context.t.newSettlement),
                ),
              ),
            )
          : null,
    );
  }
}

class _SettlementList extends StatelessWidget {
  const _SettlementList({
    required this.space,
    required this.settlements,
    required this.repository,
  });

  final SharedSpace space;
  final List<Settlement> settlements;
  final PockitoRepository repository;

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
    sliver: SliverToBoxAdapter(
      child: PkCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: settlements.map((settlement) {
            final from = repository.userById(settlement.fromUserId);
            final to = repository.userById(settlement.toUserId);
            final fromLabel = from?.isYou == true
                ? context.t.you
                : from?.name ?? 'Member';
            final toLabel = to?.isYou == true ? 'you' : to?.name ?? 'member';
            final statusColor = settlement.isConfirmed
                ? context.pk.success
                : settlement.isPending
                ? context.pk.warning
                : context.pk.textTertiary;
            return ListTile(
              leading: PkIconTile(
                icon: Icons.handshake_outlined,
                color: statusColor,
                size: 40,
              ),
              title: Text(context.t.x0PaidX1(fromLabel, toLabel)),
              subtitle: Text(
                _settlementSubtitle(context, repository, settlement),
              ),
              trailing: PkAmountText(
                amountMinor: settlement.amountMinor,
                currency: settlement.currency,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              onTap: () => context.push(
                '/spaces/${space.id}/settlements/${settlement.id}',
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

class SettlementDetailScreen extends StatelessWidget {
  const SettlementDetailScreen({
    super.key,
    required this.spaceId,
    required this.settlementId,
  });
  final String spaceId;
  final String settlementId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final settlement = repo.settlements
        .where((item) => item.id == settlementId)
        .firstOrNull;
    final space = repo.spaceById(spaceId);
    if (settlement == null || space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.handshake_outlined,
          title: context.t.settlementNotFound,
          message: context.t.itMayHaveBeenRemoved3,
        ),
      );
    }
    final from = repo.userById(settlement.fromUserId);
    final to = repo.userById(settlement.toUserId);
    final proposed = settlement.isPending;
    final confirmed = settlement.isConfirmed;
    // Only the person receiving the money can say it arrived. Everyone else
    // sees the proposal and, if they are party to it, the option to cancel.
    final iConfirm = settlement.canConfirm(repo.currentUserId);
    final iCanCancel = settlement.canCancel(repo.currentUserId);
    final proposer =
        repo.userById(settlement.proposedByUserId)?.name ?? context.t.aMember;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.settlementDetail)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            const SizedBox(height: PkSpacing.x4),
            PkIconTile(
              icon: proposed
                  ? Icons.schedule_rounded
                  : confirmed
                  ? Icons.handshake_rounded
                  : Icons.block_rounded,
              color: proposed
                  ? context.pk.warning
                  : confirmed
                  ? context.pk.owed
                  : context.pk.textTertiary,
              size: 64,
              iconSize: 30,
            ),
            const SizedBox(height: PkSpacing.x4),
            Text(
              proposed
                  ? context.t.waitingOnConfirmation
                  : confirmed
                  ? context.t.settlementConfirmed
                  : context.t.settlementCancelled,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (proposed) ...[
              const SizedBox(height: PkSpacing.x2),
              Text(
                iConfirm
                    ? context.t.saysThisMoneyReachedYou(proposer)
                    : context.t.x0ConfirmsThisBeforeAnyBalanceMoves(
                        to?.name ?? 'The recipient',
                      ),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.pk.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: PkSpacing.x2),
            Center(
              child: PkAmountText(
                amountMinor: settlement.amountMinor,
                currency: settlement.currency,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkCard(
              child: Column(
                children: [
                  _ExpenseDetailRow(
                    label: context.t.spaceLabel,
                    value: space.name,
                  ),
                  _ExpenseDetailRow(
                    label: context.t.from,
                    value: from?.isYou == true
                        ? context.t.you
                        : from?.name ?? 'Member',
                  ),
                  _ExpenseDetailRow(
                    label: context.t.to,
                    value: to?.isYou == true
                        ? context.t.you
                        : to?.name ?? 'Member',
                  ),
                  _ExpenseDetailRow(
                    label: context.t.statusLabel,
                    value: proposed
                        ? context.t.proposedByAwaiting(
                            proposer,
                            to?.isYou == true
                                ? context.t.yourWord
                                : to?.name ?? context.t.theirWord,
                          )
                        : confirmed
                        ? context.t.confirmedWord
                        : context.t.cancelledWord,
                  ),
                  if (settlement.cancelReason != null)
                    _ExpenseDetailRow(
                      label: context.t.reason,
                      value: settlement.cancelReason!,
                    ),
                  if (settlement.note.isNotEmpty)
                    _ExpenseDetailRow(
                      label: context.t.note,
                      value: settlement.note,
                    ),
                ],
              ),
            ),
            if (proposed) ...[
              const SizedBox(height: PkSpacing.x5),
              if (iConfirm)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        key: const ValueKey('settlement_cancel'),
                        onPressed: () => _cancel(context, repo, settlement),
                        child: Text(context.t.thatDidnTHappen),
                      ),
                    ),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(
                      child: FilledButton(
                        key: const ValueKey('settlement_confirm'),
                        onPressed: () => _confirm(context, repo, settlement),
                        child: Text(context.t.actionConfirm),
                      ),
                    ),
                  ],
                )
              else ...[
                PkDeniedNotice(
                  title: context.t.onlyX0CanConfirmThis(
                    to?.name ?? 'the recipient',
                  ),
                  reason: context.t.youProposedItSoConfirming,
                  whoCanHelp: [to?.name ?? context.t.theRecipient],
                ),
                if (iCanCancel) ...[
                  const SizedBox(height: PkSpacing.x3),
                  OutlinedButton(
                    key: const ValueKey('settlement_cancel'),
                    onPressed: () => _cancel(context, repo, settlement),
                    child: Text(context.t.cancelThisProposal),
                  ),
                ],
              ],
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirm(
    BuildContext context,
    PockitoRepository repo,
    Settlement settlement,
  ) async {
    final accountId = await showPkAccountPicker(
      context,
      repo: repo,
      title: context.t.whereDidTheMoneyLand,
      allowOutside: true,
      outsideLabel: context.t.outsidePockitoNoWalletMovement,
    );
    if (accountId == null || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.confirmSettlement(
        settlement.id,
        accountId: accountId == PkAccountPicker.outside ? null : accountId,
      ),
    );
    if (context.mounted) context.go('/spaces/$spaceId/settled');
  }

  Future<void> _cancel(
    BuildContext context,
    PockitoRepository repo,
    Settlement settlement,
  ) async {
    final reason = await showPkReasonSheet(
      context,
      title: context.t.cancelThisSettlement,
      message: context.t.itStaysInTheHistory,
      hint: context.t.whyOptional,
      confirmLabel: context.t.cancelSettlement,
      destructive: true,
    );
    if (reason == null || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.cancelSettlement(
        settlement.id,
        reason: reason.trim().isEmpty ? null : reason.trim(),
      ),
      successMessage: context.t.settlementCancelled,
    );
    if (context.mounted) context.pop();
  }
}

class SpaceCyclesScreen extends StatelessWidget {
  const SpaceCyclesScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.history_toggle_off_rounded,
          title: context.t.spaceNotFound,
          message: context.t.cycleHistoryIsNoLonger,
        ),
      );
    }
    final cycles =
        repo.cycles.where((cycle) => cycle.spaceId == space.id).toList()
          ..sort((a, b) => b.endedAt.compareTo(a.endedAt));
    final currentExpenses = repo.sharedExpenses.where(
      (expense) =>
          expense.spaceId == space.id &&
          expense.cycleId == space.currentCycleId,
    );
    final currentSpent = currentExpenses.fold<int>(
      0,
      (sum, expense) => sum + expense.totalMinor,
    );
    final spaceBudget = repo.budgets
        .where(
          (budget) =>
              budget.scope == BudgetScope.space && budget.spaceId == space.id,
        )
        .firstOrNull;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.spaceCycles)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            PkSpacing.x2,
            PkSpacing.screen,
            PkSpacing.x8,
          ),
          children: [
            PkCard(
              color: context.pk.sharedSurface,
              borderColor: context.pk.sharedBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chip(label: Text(context.t.currentCycle)),
                  const SizedBox(height: PkSpacing.x3),
                  Text(
                    context.t.x0ExpensesX1(
                      currentExpenses.length,
                      PkFormat.money(currentSpent, space.currency),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (spaceBudget != null) ...[
                    const SizedBox(height: PkSpacing.x3),
                    PkProgressBar(
                      value: spaceBudget.limitMinor == 0
                          ? 0
                          : currentSpent / spaceBudget.limitMinor,
                      color: context.pk.shared,
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    Text(
                      context.t.x0OfX1Budget(
                        PkFormat.money(currentSpent, space.currency),
                        PkFormat.money(spaceBudget.limitMinor, space.currency),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x3),
                  OutlinedButton(
                    onPressed: () => context.go('/spaces/${space.id}'),
                    child: Text(context.t.openCurrentCycle),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(title: context.t.previousCyclesX0(cycles.length)),
            if (cycles.isEmpty)
              PkEmptyState(
                icon: Icons.calendar_month_outlined,
                title: context.t.noPreviousCycles,
                message: context.t.onceEveryoneIsSettledStart,
              )
            else
              // A closed cycle is a finance row: it composes the canonical
              // one, so the amount moves beneath the title at large text
              // sizes rather than pushing the row off the screen.
              PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                children: [
                  for (final cycle in cycles)
                    PkLedgerRow(
                      density: PkRowDensity.rich,
                      semanticIdentifier: 'cycle_${cycle.id}',
                      leading: const PkIconTile(
                        icon: Icons.event_available_outlined,
                        color: PkPalette.indigo600,
                      ),
                      title: cycle.label,
                      subtitle: context.t.expensesSettlements(
                        cycle.expenseIds.length,
                        cycle.settlementIds.length,
                      ),
                      trailing: PkAmountText(
                        amountMinor: cycle.spentMinor,
                        currency: cycle.currency,
                        style: context.pkText.moneyRow,
                      ),
                      trailingSubtitle: Text(
                        context.t.settled,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.pkText.supporting,
                      ),
                      showChevron: true,
                      onTap: () => context.push(
                        '/spaces/${space.id}/cycles/${cycle.id}',
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class SpaceCycleDetailScreen extends StatelessWidget {
  const SpaceCycleDetailScreen({
    super.key,
    required this.spaceId,
    required this.cycleId,
  });

  final String spaceId;
  final String cycleId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(spaceId);
    final cycle = repo.cycles
        .where((item) => item.id == cycleId && item.spaceId == spaceId)
        .firstOrNull;
    if (space == null || cycle == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.history_toggle_off_rounded,
          title: context.t.cycleNotFound,
          message: context.t.thisHistoricalSnapshotIsUnavailable,
        ),
      );
    }
    final expenses = cycle.expenseIds
        .map(repo.sharedExpenseById)
        .whereType<SharedExpense>()
        .toList();
    return Scaffold(
      appBar: PkAppBar(title: Text('${space.name} · ${cycle.label}')),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            PkSpacing.x2,
            PkSpacing.screen,
            PkSpacing.x8,
          ),
          children: [
            PkCard(
              color: context.pk.sharedSurface,
              borderColor: context.pk.sharedBorder,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.lock_clock_outlined),
                title: Text(context.t.settledCycleReadOnly),
                subtitle: Text(context.t.thisSnapshotDoesNotChange),
              ),
            ),
            const SizedBox(height: PkSpacing.x4),
            PkCard(
              child: Column(
                children: [
                  _ExpenseDetailRow(
                    label: context.t.period,
                    value:
                        '${PkFormat.longDate(cycle.startedAt, context.t)} → ${PkFormat.longDate(cycle.endedAt, context.t)}',
                  ),
                  _ExpenseDetailRow(
                    label: context.t.spent,
                    value: PkFormat.money(cycle.spentMinor, cycle.currency),
                  ),
                  _ExpenseDetailRow(
                    label: context.t.budgetLabel,
                    value: cycle.budgetLimitMinor == 0
                        ? context.t.noBudget
                        : '${PkFormat.money(cycle.budgetLimitMinor, cycle.currency)} · ${(cycle.spentMinor / cycle.budgetLimitMinor * 100).round()}%',
                  ),
                  _ExpenseDetailRow(
                    label: context.t.finalStatus,
                    value: context.t.everyoneSettled,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(title: context.t.memberContributions),
            PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: cycle.memberPaidMinor.keys.map((userId) {
                  final user = repo.userById(userId);
                  final paid = cycle.memberPaidMinor[userId] ?? 0;
                  final responsibility =
                      cycle.memberResponsibilityMinor[userId] ?? 0;
                  return ListTile(
                    leading: PkAvatar(label: user?.initials ?? '?'),
                    title: Text(
                      user?.isYou == true
                          ? context.t.you
                          : user?.name ?? 'Member',
                    ),
                    subtitle: Text(
                      context.t.responsibleForX0(
                        PkFormat.money(responsibility, cycle.currency),
                      ),
                    ),
                    trailing: Text(
                      context.t.paidX0(PkFormat.money(paid, cycle.currency)),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(title: context.t.categories),
            PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: cycle.categoryTotalsMinor.entries
                    .map(
                      (entry) => ListTile(
                        title: Text(
                          repo.categoryById(entry.key)?.name ??
                              context.t.uncategorised,
                        ),
                        trailing: PkAmountText(
                          amountMinor: entry.value,
                          currency: cycle.currency,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(
              title: context.t.expensesX0(cycle.expenseIds.length),
            ),
            if (expenses.isEmpty)
              PkCard(
                child: Text(
                  context.t.theSnapshotRetainsExpenseReferences(
                    cycle.expenseIds.length,
                  ),
                ),
              )
            else
              ...expenses.map(
                (expense) => Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                  child: _SharedExpenseTile(
                    expense: expense,
                    onTap: () => context.push(
                      '/spaces/${space.id}/expenses/${expense.id}',
                    ),
                  ),
                ),
              ),
            const SizedBox(height: PkSpacing.x4),
            OutlinedButton(
              onPressed: () => context.go('/spaces/${space.id}'),
              child: Text(context.t.returnToCurrentCycle),
            ),
          ],
        ),
      ),
    );
  }
}

class ArchivedSpacesScreen extends StatelessWidget {
  const ArchivedSpacesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final spaces = repo.spaces
        .where((item) => item.status == SpaceStatus.archived)
        .toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.archivedSpaces)),
      body: spaces.isEmpty
          ? PkEmptyState(
              icon: Icons.archive_outlined,
              title: context.t.noArchivedSpaces,
              message: context.t.finishedTripsAndOldGroups,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(PkSpacing.screen),
              itemCount: spaces.length,
              separatorBuilder: (_, _) => const SizedBox(height: PkSpacing.x2),
              itemBuilder: (context, index) {
                final space = spaces[index];
                return PkCard(
                  child: Row(
                    children: [
                      PkIconTile(
                        icon: PkIcons.named(space.icon),
                        color: PkPalette.categoryAt(space.colorIndex),
                      ),
                      const SizedBox(width: PkSpacing.x3),
                      Expanded(
                        child: Text(
                          space.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => repo.saveSpace(
                          space.copyWith(status: SpaceStatus.active),
                        ),
                        child: Text(context.t.actionRestore),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _SharedHero extends StatelessWidget {
  const _SharedHero({required this.summary});
  final SharedSummary summary;
  @override
  // Section 7.4: a compact 120–144 summary. Kito comes down from 82x70 to the
  // 48–64 section 4.5 allows a routine inline appearance — this is a list
  // header, not a moment that needs reassurance.
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(PkSpacing.x4),
    decoration: BoxDecoration(
      color: context.pk.sharedSurface,
      border: Border.all(color: context.pk.sharedBorder),
      borderRadius: BorderRadius.circular(PkRadius.hero),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.people_alt_outlined,
              size: PkSize.icon,
              color: context.pk.sharedStrong,
            ),
            const SizedBox(width: PkSpacing.x2),
            Expanded(
              child: Text(
                context.t.acrossAllSpaces,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.pkText.label.copyWith(
                  color: context.pk.sharedStrong,
                ),
              ),
            ),
            if (!context.isShort)
              const KitoImage(
                asset: KitoAsset.sharedSpace,
                width: 56,
                height: 48,
              ),
          ],
        ),
        const SizedBox(height: PkSpacing.x2),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.t.youReOwed,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pkText.supporting,
                  ),
                  PkAmountText(
                    amountMinor: summary.owedMinor,
                    currency: summary.currency,
                    color: context.pk.owed,
                    style: context.pkText.moneySection,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.t.youOwe,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.pkText.supporting,
                  ),
                  PkAmountText(
                    amountMinor: summary.owingMinor,
                    currency: summary.currency,
                    color: summary.owingMinor == 0
                        ? context.pk.textTertiary
                        : context.pk.owing,
                    style: context.pkText.moneySection,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SpaceHero extends StatelessWidget {
  const _SpaceHero({
    required this.space,
    required this.balance,
    required this.balanceDescription,
    required this.lifetime,
    required this.onScopeChanged,
    required this.onBreakdown,
    this.onSettle,
  });
  final SharedSpace space;
  final int balance;
  final String balanceDescription;
  final bool lifetime;
  final ValueChanged<bool> onScopeChanged;
  final VoidCallback onBreakdown;
  final VoidCallback? onSettle;
  @override
  Widget build(BuildContext context) {
    final color = PkPalette.categoryAt(space.colorIndex);
    return PkHeroPanel(
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final label = Text(
                lifetime ? context.t.allTimeBalance : context.t.currentCycle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              );
              final selector = SegmentedButton<bool>(
                showSelectedIcon: false,
                expandedInsets: EdgeInsets.zero,
                style: SegmentedButton.styleFrom(
                  backgroundColor: Colors.white.withValues(alpha: .12),
                  selectedBackgroundColor: Colors.white,
                  selectedForegroundColor: color,
                  foregroundColor: Colors.white,
                  side: BorderSide.none,
                  // D-04: the segment reads as a compact pill through its
                  // padding, but each half still accepts a 48 px tap. Shrink-
                  // wrapping the target to match the 32 px chrome is exactly
                  // the conflation section 9.4 rules out.
                  minimumSize: const Size(0, PkSize.touch),
                  padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x3),
                ),
                segments: [
                  ButtonSegment(value: false, label: Text(context.t.cycle)),
                  ButtonSegment(value: true, label: Text(context.t.allTime)),
                ],
                selected: {lifetime},
                onSelectionChanged: (value) => onScopeChanged(value.first),
              );
              if (constraints.maxWidth < 440) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    label,
                    const SizedBox(height: PkSpacing.x2),
                    selector,
                  ],
                );
              }
              return Row(
                children: [
                  label,
                  const Spacer(),
                  SizedBox(width: 220, child: selector),
                ],
              );
            },
          ),
          const SizedBox(height: PkSpacing.x4),
          PkAmountText(
            amountMinor: balance.abs(),
            currency: space.currency,
            style: Theme.of(
              context,
            ).textTheme.displayLarge?.copyWith(color: Colors.white),
          ),
          Text(
            balanceDescription,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: PkSpacing.x5),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onBreakdown,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: .45),
                    ),
                  ),
                  child: Text(context.t.breakdown),
                ),
              ),
              if (onSettle != null) ...[
                const SizedBox(width: PkSpacing.x3),
                Expanded(
                  child: FilledButton(
                    onPressed: onSettle,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: color,
                    ),
                    child: Text(context.t.quickSettleUp),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SharedExpenseTile extends StatelessWidget {
  const _SharedExpenseTile({required this.expense, required this.onTap});
  final SharedExpense expense;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final category = repo.categoryById(expense.categoryId);
    final payer = repo.userById(expense.primaryPayerUserId);
    final mine = expense.shares
        .where((item) => item.userId == repo.currentUserId)
        .firstOrNull;
    return PkCard(
      onTap: onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Scales with the reader's text size for the same reason the
          // transaction row does: the same width holds less at 130%.
          final compact =
              constraints.maxWidth <
              280 * MediaQuery.textScalerOf(context).scale(1);
          final amount = <Widget>[
            PkAmountText(
              amountMinor: expense.totalMinor,
              currency: expense.currency,
            ),
            if (mine != null)
              Text(
                context.t.yourShareX0(
                  PkFormat.money(mine.amountMinor, expense.currency),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            if (mine != null)
              PkShareRule(
                fraction: mine.amountMinor / expense.totalMinor,
                width: compact ? 80 : 64,
              ),
          ];
          return Row(
            crossAxisAlignment: compact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              PkIconTile(
                icon: PkIcons.named(category?.icon ?? 'receipt'),
                color: PkPalette.categoryAt(category?.colorIndex ?? 2),
                size: compact ? 40 : 48,
              ),
              SizedBox(width: compact ? PkSpacing.x2 : PkSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      expense.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      context.t.x0PaidX12(
                        payer?.isYou == true
                            ? context.t.you
                            : payer?.name ?? context.t.someone,
                        PkFormat.shortDate(
                          expense.occurredOn,
                          repo.today,
                          context.t,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (compact) ...[
                      const SizedBox(height: PkSpacing.x2),
                      ...amount,
                    ],
                  ],
                ),
              ),
              if (!compact)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: amount,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ActivityEvent extends StatelessWidget {
  const _ActivityEvent({
    required this.icon,
    required this.title,
    required this.detail,
    this.via,
  });
  final IconData icon;
  final String title;
  final String detail;
  final String? via;
  @override
  Widget build(BuildContext context) => PkCard(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PkIconTile(icon: icon, color: PkPalette.indigo600),
        const SizedBox(width: PkSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(detail, style: Theme.of(context).textTheme.bodySmall),
              if (via != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    context.t.viaX0(via!),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _ExpenseDetailRow extends StatelessWidget {
  const _ExpenseDetailRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x3),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

/// The Space's audit record.
///
/// The friendly feed answers "what happened"; the detailed view answers
/// "who did it, to what, and was it allowed" — which is the question that
/// matters when two people disagree about a number.
class SpaceActivityLogScreen extends StatefulWidget {
  const SpaceActivityLogScreen({super.key, required this.spaceId});
  final String spaceId;

  @override
  State<SpaceActivityLogScreen> createState() => _SpaceActivityLogScreenState();
}

class _SpaceActivityLogScreenState extends State<SpaceActivityLogScreen> {
  bool _detailed = false;
  bool _deniedOnly = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final space = repo.spaceById(widget.spaceId);
    if (space == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.group_off_outlined,
          title: context.t.spaceNotFound,
          message: context.t.itsActivityLogIsNo,
        ),
      );
    }
    final query = _query.trim().toLowerCase();
    final events = repo.spaceActivity.where((event) {
      if (event.spaceId != space.id) return false;
      if (_deniedOnly && event.outcome != ActivityOutcome.denied) return false;
      if (query.isEmpty) return true;
      return event.summary.toLowerCase().contains(query) ||
          (event.entityLabel ?? '').toLowerCase().contains(query) ||
          (repo.userById(event.actorUserId)?.name ?? '').toLowerCase().contains(
            query,
          );
    }).toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.x0Activity(space.name))),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            SegmentedButton<bool>(
              key: const ValueKey('activity_log_mode'),
              segments: [
                ButtonSegment(value: false, label: Text(context.t.friendly)),
                ButtonSegment(value: true, label: Text(context.t.detailed)),
              ],
              selected: {_detailed},
              onSelectionChanged: (value) {
                PkHaptics.selection();
                setState(() => _detailed = value.first);
              },
            ),
            const SizedBox(height: PkSpacing.x3),
            PkSearchField(
              value: _query,
              hintText: context.t.searchThisLog,
              resultCount: events.length,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: PkSpacing.x2),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: FilterChip(
                key: const ValueKey('activity_log_denied'),
                label: Text(context.t.refusedActionsOnly),
                selected: _deniedOnly,
                onSelected: (value) {
                  PkHaptics.selection();
                  setState(() => _deniedOnly = value);
                },
              ),
            ),
            const SizedBox(height: PkSpacing.x3),
            if (events.isEmpty)
              PkListState.empty(
                icon: Icons.history_toggle_off_rounded,
                title: context.t.nothingRecordedYet,
                message: _deniedOnly
                    ? context.t.nobodyHasBeenRefusedAn
                    : context.t.addingAnExpenseOrChanging,
              )
            else
              PkCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final event in events)
                      ListTile(
                        key: ValueKey('activity_${event.id}'),
                        leading: PkIconTile(
                          icon: _iconFor(event.type),
                          color: event.outcome == ActivityOutcome.denied
                              ? context.pk.danger
                              : Theme.of(context).colorScheme.primary,
                          size: 40,
                          iconSize: 19,
                        ),
                        title: Text(
                          _detailed
                              ? '${repo.userById(event.actorUserId)?.name ?? 'Someone'} · ${event.type.name}'
                              : event.summary,
                        ),
                        subtitle: Text(
                          _detailed
                              ? [
                                  PkFormat.longDate(event.at, context.t),
                                  if (event.entityLabel != null)
                                    event.entityLabel!,
                                  if (event.permission != null)
                                    'permission: ${event.permission}',
                                  'outcome: ${event.outcome.name}',
                                  if (event.detail != null) event.detail!,
                                ].join(' · ')
                              : [
                                  PkFormat.shortDate(
                                    event.at,
                                    repo.today,
                                    context.t,
                                  ),
                                  if (event.detail != null) event.detail!,
                                ].join(' · '),
                        ),
                        isThreeLine: _detailed,
                        trailing: event.outcome == ActivityOutcome.denied
                            ? Icon(
                                Icons.block_rounded,
                                size: PkSize.iconSmall,
                                color: context.pk.danger,
                              )
                            : null,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(SpaceActivityType type) => switch (type) {
    SpaceActivityType.expenseAdded ||
    SpaceActivityType.expenseEdited => Icons.receipt_long_outlined,
    SpaceActivityType.expenseVoided => Icons.block_outlined,
    SpaceActivityType.settlementProposed ||
    SpaceActivityType.settlementConfirmed ||
    SpaceActivityType.settlementCancelled => Icons.handshake_outlined,
    SpaceActivityType.memberInvited ||
    SpaceActivityType.memberJoined => Icons.person_add_alt_outlined,
    SpaceActivityType.memberRemoved ||
    SpaceActivityType.memberLeft => Icons.person_remove_outlined,
    SpaceActivityType.roleChanged => Icons.admin_panel_settings_outlined,
    SpaceActivityType.inviteRevoked => Icons.link_off_rounded,
    SpaceActivityType.budgetChanged => Icons.donut_large_rounded,
    SpaceActivityType.settingsChanged => Icons.tune_rounded,
    SpaceActivityType.cycleClosed => Icons.restart_alt_rounded,
    SpaceActivityType.permissionDenied => Icons.do_not_disturb_on_outlined,
  };
}

/// Date, plus who the settlement is still waiting on — the part that tells a
/// reader whether anything is expected of them.
String _settlementSubtitle(
  BuildContext context,
  PockitoRepository repository,
  Settlement settlement,
) {
  final date = PkFormat.shortDate(
    settlement.settledAt ?? settlement.createdAt,
    repository.today,
    context.t,
  );
  if (settlement.isConfirmed) return date;
  final status = settlement.isPending
      ? repository.userById(settlement.toUserId)?.isYou == true
            ? context.t.awaitingYourConfirmation
            : context.t.awaitingTheirConfirmation
      : context.t.cancelled;
  return '$date · $status';
}
