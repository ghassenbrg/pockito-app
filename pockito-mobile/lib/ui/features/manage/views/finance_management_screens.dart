import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_tokens.dart';

class NetWorthBreakdownScreen extends StatelessWidget {
  const NetWorthBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final accounts = repo.accounts.where((item) => !item.archived).toList();
    final reporting = repo.profile.reportingCurrency;
    final netWorth = repo.netWorthMinor(reporting);
    // One quote per foreign currency actually present, so the disclosure is
    // about this screen's numbers rather than a general rate table.
    final currencies = accounts
        .map((account) => account.currency)
        .where((currency) => currency != reporting)
        .toSet();
    final quotes = currencies
        .map((currency) => repo.fxQuote(currency, reporting))
        .whereType<FxQuote>()
        .toList();
    final unconvertible = currencies
        .where((currency) => repo.fxQuote(currency, reporting) == null)
        .toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.homeNetWorth)),
      body: PkPage(
        bottomPadding: 32,
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x6,
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(PkSpacing.x5),
                decoration: BoxDecoration(
                  color: PkPalette.indigo600,
                  borderRadius: BorderRadius.circular(PkRadius.extraLarge),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.reportingTotal,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    PkAmountText(
                      amountMinor: netWorth,
                      currency: reporting,
                      style: Theme.of(
                        context,
                      ).textTheme.displayLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: PkSpacing.x3),
                    Text(
                      context.t.fxNetWorthNote(reporting),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // A converted total is not the number on anyone's statement. The
          // rates that produced it are stated, dated and attributed here.
          if (quotes.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                0,
                PkSpacing.screen,
                PkSpacing.x5,
              ),
              sliver: SliverToBoxAdapter(
                child: PkFxDisclosure(
                  quotes: quotes,
                  reportingCurrency: reporting,
                  history: repo.fxSettings.history,
                ),
              ),
            ),
          if (unconvertible.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                0,
                PkSpacing.screen,
                PkSpacing.x5,
              ),
              sliver: SliverToBoxAdapter(
                child: PkDeniedNotice(
                  title: context.t.fxMissingTitle,
                  reason: context.t.fxMissingBody(unconvertible.join(', ')),
                ),
              ),
            ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(
                title: context.t.navAccounts,
                trailing: Text(
                  '${accounts.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverList.separated(
              itemCount: accounts.length,
              separatorBuilder: (_, _) => const SizedBox(height: PkSpacing.x2),
              itemBuilder: (context, index) {
                final account = accounts[index];
                final balance = repo.accountBalance(account);
                final converted = repo.convertMinor(
                  balance,
                  account.currency,
                  reporting,
                );
                return PkCard(
                  onTap: () => context.push('/accounts/${account.id}'),
                  child: Row(
                    children: [
                      PkIconTile(
                        icon: PkIcons.named(account.icon),
                        color: PkPalette.categoryAt(account.colorIndex),
                      ),
                      const SizedBox(width: PkSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              account.currency == reporting
                                  ? context.t.reportingCurrency
                                  : converted == null
                                  ? context.t.noRateAvailable
                                  : context.t.atMockRate(
                                      PkFormat.money(balance, account.currency),
                                    ),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      converted == null
                          ? Text(
                              context.t.notCombined,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(color: context.pk.warning),
                            )
                          : PkAmountText(
                              amountMinor: converted,
                              currency: reporting,
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetsScreen extends StatelessWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final snapshots = repo.budgets.map(repo.budgetSnapshot).toList()
      ..sort((a, b) => b.progress.compareTo(a.progress));
    final personal = snapshots
        .where((item) => item.budget.scope == BudgetScope.personal)
        .toList();
    final shared = snapshots
        .where((item) => item.budget.scope == BudgetScope.space)
        .toList();
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.budgetsTitle),
        actions: [
          IconButton(
            onPressed: () => context.push('/budgets/new'),
            tooltip: context.t.createBudget,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: PkPage(
        bottomPadding: 32,
        slivers: [
          if (snapshots.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.donut_large_outlined,
                title: context.t.planWithoutPolicingYourself,
                message: context.t.budgetsShowPaceAndRemaining,
                actionLabel: context.t.createBudget,
                onAction: () => context.push('/budgets/new'),
              ),
            )
          else ...[
            _BudgetGroup(title: context.t.personal, snapshots: personal),
            _BudgetGroup(title: context.t.sharedSpaces, snapshots: shared),
          ],
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x5,
              PkSpacing.screen,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: FilledButton.icon(
                onPressed: () => context.push('/budgets/new'),
                icon: const Icon(Icons.add_rounded),
                label: Text(context.t.createBudget),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetDetailScreen extends StatelessWidget {
  const BudgetDetailScreen({super.key, required this.budgetId});
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final budget = repo.budgets
        .where((item) => item.id == budgetId)
        .firstOrNull;
    if (budget == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.donut_large_outlined,
          title: context.t.budgetNotFound,
          message: context.t.itMayHaveBeenDeleted,
        ),
      );
    }
    final snapshot = repo.budgetSnapshot(budget);
    final categoryIds = budget.categoryIds.isNotEmpty
        ? budget.categoryIds.toSet()
        : budget.categoryId == 'all'
        ? <String>{}
        : {budget.categoryId};
    final matching = repo.transactions.where((item) {
      if (item.type != MoneyEventType.expense) return false;
      if (budget.scope == BudgetScope.space) {
        final split = item.splitId == null
            ? null
            : repo.sharedExpenseById(item.splitId!);
        if (split?.spaceId != budget.spaceId) return false;
      } else if (item.splitId != null) {
        return false;
      }
      return (categoryIds.isEmpty || categoryIds.contains(item.categoryId)) &&
          (budget.accountIds.isEmpty ||
              budget.accountIds.contains(item.fromAccountId));
    }).toList();
    final previousMonths = List.generate(
      3,
      (index) => DateTime(repo.today.year, repo.today.month - index),
    );
    // The window is the budget's own period, which is no longer always a
    // calendar month.
    final daysRemaining = snapshot.window.end
        .difference(repo.today)
        .inDays
        .clamp(0, 400);
    final allowance = daysRemaining <= 0 || snapshot.remainingMinor <= 0
        ? 0
        : snapshot.remainingMinor ~/ daysRemaining;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(budget.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') context.push('/budgets/${budget.id}/edit');
              if (value == 'delete') await _deleteBudget(context, budget);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text(context.t.editBudget),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: ListTile(
                  leading: Icon(Icons.delete_outline_rounded),
                  title: Text(context.t.deleteBudget),
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
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x6,
            ),
            sliver: SliverToBoxAdapter(child: _BudgetHero(snapshot: snapshot)),
          ),
          // The arc answers "am I going to make it", which the bar alone
          // cannot: it carries the pace marker for where this period ends.
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(child: PkBudgetArc(snapshot: snapshot)),
                    const SizedBox(height: PkSpacing.x3),
                    PkChartDataTable(
                      rows: [
                        (context.t.used, snapshot.usedMinor),
                        (context.t.limit, snapshot.budget.limitMinor),
                        if (snapshot.rolloverMinor > 0)
                          (context.t.carriedOver, snapshot.rolloverMinor),
                        (
                          context.t.projectedEndOf(budget.period.noun),
                          snapshot.forecastMinor,
                        ),
                        if (snapshot.previousUsedMinor != null)
                          (
                            context.t.lastX02(budget.period.noun),
                            snapshot.previousUsedMinor!,
                          ),
                      ],
                      currency: budget.currency,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x4,
              PkSpacing.screen,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.scope,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    Text(
                      _budgetScopeDescription(context, repo, budget),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.pk.textSecondary,
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
              child: Row(
                children: [
                  Expanded(
                    child: _BudgetMetric(
                      label: context.t.budgetDaysLeft,
                      value: '$daysRemaining',
                    ),
                  ),
                  const SizedBox(width: PkSpacing.x2),
                  Expanded(
                    child: _BudgetMetric(
                      label: context.t.budgetDailyAllowance,
                      value: PkFormat.money(allowance, budget.currency),
                    ),
                  ),
                  const SizedBox(width: PkSpacing.x2),
                  Expanded(
                    child: _BudgetMetric(
                      label: context.t.budgetPace,
                      value: snapshot.health == BudgetHealth.exceeded
                          ? context.t.over
                          : snapshot.health == BudgetHealth.near
                          ? context.t.close
                          : context.t.onTrack,
                    ),
                  ),
                ],
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
              child: PkSectionHeader(
                title: context.t.includedSpending,
                trailing: Text(
                  '${matching.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          if (matching.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.receipt_long_outlined,
                title: context.t.nothingCountedYet,
                message: context.t.matchingExpensesWillAppearHere,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: matching
                        .map(
                          (item) => PkTransactionTile(
                            transaction: item,
                            repository: repo,
                            onTap: () => context.push('/activity/${item.id}'),
                          ),
                        )
                        .toList(),
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
              child: PkSectionHeader(title: context.t.monthlyHistory),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  children: previousMonths.map((month) {
                    final monthSnapshot = repo.budgetSnapshotForMonth(
                      budget,
                      month,
                    );
                    return _ManagementRow(
                      label:
                          '${month.year}-${month.month.toString().padLeft(2, '0')}',
                      value:
                          '${PkFormat.money(monthSnapshot.usedMinor, budget.currency)} · ${(monthSnapshot.progress * 100).round()}%',
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _budgetScopeDescription(
    BuildContext context,
    dynamic repo,
    Budget budget,
  ) {
    final categories = budget.categoryIds.isNotEmpty
        ? budget.categoryIds
        : budget.categoryId == 'all'
        ? const <String>[]
        : [budget.categoryId];
    final categoryLabel = categories.isEmpty
        ? context.t.allExpenses
        : categories.map((id) => repo.categoryById(id)?.name ?? id).join(' + ');
    final walletLabel = budget.accountIds.isEmpty
        ? context.t.allWallets
        : budget.accountIds
              .map((id) => repo.accountById(id)?.name ?? id)
              .join(' + ');
    if (budget.scope == BudgetScope.space) {
      return context.t.x0X1Only(
        categoryLabel,
        repo.spaceById(budget.spaceId ?? '')?.name ?? context.t.sharedSpace,
      );
    }
    return '$categoryLabel · $walletLabel';
  }

  Future<void> _deleteBudget(BuildContext context, Budget budget) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.deleteX02(budget.name)),
        content: Text(context.t.expensesStayUntouchedOnlyThis),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.pk.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<PockitoAppViewModel>().repository.deleteBudget(
      budget.id,
    );
    if (context.mounted) context.pop();
  }
}

class BudgetEditorScreen extends StatefulWidget {
  const BudgetEditorScreen({super.key, this.budgetId});
  final String? budgetId;
  @override
  State<BudgetEditorScreen> createState() => _BudgetEditorScreenState();
}

class _BudgetEditorScreenState extends State<BudgetEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _limit;
  BudgetScope _scope = BudgetScope.personal;
  String? _spaceId;
  late Set<String> _categoryIds;
  late Set<String> _accountIds;
  String _currency = 'EUR';
  bool _alertAt80 = true;
  bool _alertAt100 = true;
  BudgetPeriod _period = BudgetPeriod.monthly;
  int _customDays = 30;
  bool _rollover = false;
  int _version = 1;

  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.budgetId == null
        ? null
        : repo.budgets.where((item) => item.id == widget.budgetId).firstOrNull;
    _name = TextEditingController(text: existing?.name ?? '');
    _limit = TextEditingController(
      text: existing == null
          ? ''
          : (existing.limitMinor / (existing.currency == 'JPY' ? 1 : 100))
                .toStringAsFixed(existing.currency == 'JPY' ? 0 : 2),
    );
    _scope = existing?.scope ?? BudgetScope.personal;
    _spaceId = existing?.spaceId;
    _categoryIds = {
      ...?existing?.categoryIds,
      if (existing != null &&
          existing.categoryIds.isEmpty &&
          existing.categoryId != 'all')
        existing.categoryId,
    };
    _accountIds = {...?existing?.accountIds};
    _currency = existing?.currency ?? repo.profile.reportingCurrency;
    _alertAt80 = existing?.alerts.contains(80) ?? true;
    _alertAt100 = existing?.alerts.contains(100) ?? true;
    _period = existing?.period ?? BudgetPeriod.monthly;
    _customDays = existing?.customPeriodDays ?? 30;
    _rollover = existing?.rollover ?? false;
    _version = existing?.version ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _limit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final editing = widget.budgetId != null;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(editing ? context.t.editBudget : context.t.createBudget),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            PkSpacing.x2,
            PkSpacing.screen,
            PkSpacing.x3,
          ),
          child: PkSubmitButton(
            key: const ValueKey('save_budget'),
            label: editing ? context.t.saveChanges : context.t.createBudget,
            onSubmit: _save,
          ),
        ),
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
                  SegmentedButton<BudgetScope>(
                    segments: [
                      ButtonSegment(
                        value: BudgetScope.personal,
                        label: Text(context.t.personal),
                        icon: Icon(Icons.person_outline_rounded),
                      ),
                      ButtonSegment(
                        value: BudgetScope.space,
                        label: Text(context.t.shared),
                        icon: Icon(Icons.group_outlined),
                      ),
                    ],
                    selected: {_scope},
                    onSelectionChanged: (value) => setState(() {
                      _scope = value.first;
                      if (_scope == BudgetScope.space) {
                        _spaceId ??= repo.spaces
                            .where((item) => item.status == SpaceStatus.active)
                            .first
                            .id;
                        _currency = repo.spaceById(_spaceId!)!.currency;
                      } else {
                        _spaceId = null;
                        _currency = repo.profile.reportingCurrency;
                      }
                    }),
                  ),
                  const SizedBox(height: PkSpacing.x5),
                  TextFormField(
                    key: const ValueKey('budget_name'),
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t.budgetName,
                      hintText: context.t.eGGroceries,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.t.nameThisBudget
                        : null,
                  ),
                  if (_scope == BudgetScope.space) ...[
                    const SizedBox(height: PkSpacing.x4),
                    DropdownButtonFormField<String>(
                      initialValue: _spaceId,
                      decoration: InputDecoration(
                        labelText: context.t.spaceLabel,
                      ),
                      items: repo.spaces
                          .where((item) => item.status == SpaceStatus.active)
                          .map(
                            (item) => DropdownMenuItem(
                              value: item.id,
                              child: Text('${item.name} · ${item.currency}'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) => setState(() {
                        _spaceId = value;
                        _currency = repo.spaceById(value!)!.currency;
                      }),
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x4),
                  Text(
                    context.t.categories,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    _categoryIds.isEmpty
                        ? context.t.allExpenseCategories
                        : context.t.onlySelectedCategoriesCount,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Wrap(
                    spacing: PkSpacing.x2,
                    runSpacing: PkSpacing.x2,
                    children: [
                      FilterChip(
                        key: const ValueKey('budget_all_categories'),
                        label: Text(context.t.allExpenses),
                        selected: _categoryIds.isEmpty,
                        onSelected: (_) => setState(_categoryIds.clear),
                      ),
                      ...repo.categories
                          .where((item) => item.type == CategoryType.expense)
                          .map(
                            (item) => FilterChip(
                              key: ValueKey('budget_category_${item.id}'),
                              label: Text(item.name),
                              selected: _categoryIds.contains(item.id),
                              onSelected: (selected) => setState(() {
                                selected
                                    ? _categoryIds.add(item.id)
                                    : _categoryIds.remove(item.id);
                              }),
                            ),
                          ),
                    ],
                  ),
                  if (_scope == BudgetScope.personal) ...[
                    const SizedBox(height: PkSpacing.x4),
                    Text(
                      context.t.wallets,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      _accountIds.isEmpty
                          ? context.t.allWalletsAreIncluded
                          : context.t.onlySelectedWalletsCount,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    Wrap(
                      spacing: PkSpacing.x2,
                      runSpacing: PkSpacing.x2,
                      children: [
                        FilterChip(
                          key: const ValueKey('budget_all_wallets'),
                          label: Text(context.t.allWallets2),
                          selected: _accountIds.isEmpty,
                          onSelected: (_) => setState(_accountIds.clear),
                        ),
                        ...repo.accounts
                            .where((item) => !item.archived)
                            .map(
                              (item) => FilterChip(
                                key: ValueKey('budget_account_${item.id}'),
                                label: Text(item.name),
                                selected: _accountIds.contains(item.id),
                                onSelected: (selected) => setState(() {
                                  selected
                                      ? _accountIds.add(item.id)
                                      : _accountIds.remove(item.id);
                                }),
                              ),
                            ),
                      ],
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x4),
                  TextFormField(
                    key: const ValueKey('budget_limit'),
                    controller: _limit,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.t.x0Limit(_period.label),
                      prefixText: '${_symbol(_currency)} ',
                    ),
                    validator: (value) =>
                        (double.tryParse(value ?? '') ?? 0) <= 0
                        ? context.t.enterALimitGreaterThan
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x5),
                  // Not every budget is a calendar month: coffee is weekly and
                  // travel is annual.
                  Text(
                    context.t.resets,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  Wrap(
                    spacing: PkSpacing.x2,
                    runSpacing: PkSpacing.x2,
                    children: [
                      for (final period in BudgetPeriod.values)
                        ChoiceChip(
                          key: ValueKey('budget_period_${period.name}'),
                          label: Text(period.label),
                          selected: _period == period,
                          onSelected: (_) {
                            PkHaptics.selection();
                            setState(() => _period = period);
                          },
                        ),
                    ],
                  ),
                  if (_period == BudgetPeriod.custom) ...[
                    const SizedBox(height: PkSpacing.x3),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            context.t.everyX0Days(_customDays),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        IconButton(
                          tooltip: context.t.fewerDays,
                          onPressed: _customDays <= 2
                              ? null
                              : () => setState(() => _customDays -= 1),
                          icon: const Icon(Icons.remove_rounded),
                        ),
                        IconButton(
                          tooltip: context.t.moreDays,
                          onPressed: _customDays >= 365
                              ? null
                              : () => setState(() => _customDays += 1),
                          icon: const Icon(Icons.add_rounded),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x4),
                  PkCard(
                    child: SwitchListTile.adaptive(
                      key: const ValueKey('budget_rollover'),
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.t.carryTheLeftoverOver),
                      subtitle: Text(
                        context.t.whateverIsUnspentAtThe(_period.noun),
                      ),
                      value: _rollover,
                      onChanged: (value) => setState(() => _rollover = value),
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  PkCard(
                    child: Column(
                      children: [
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(context.t.alertAt80),
                          value: _alertAt80,
                          onChanged: (value) =>
                              setState(() => _alertAt80 = value),
                        ),
                        const Divider(),
                        SwitchListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          title: Text(context.t.alertAt100),
                          value: _alertAt100,
                          onChanged: (value) =>
                              setState(() => _alertAt100 = value),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _symbol(String code) => PockitoCurrencies.of(code).symbol;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.budgetId == null
        ? null
        : repo.budgets.where((item) => item.id == widget.budgetId).firstOrNull;
    final multiplier = PockitoCurrencies.of(_currency).minorUnitScale;
    await repo.saveBudget(
      Budget(
        id: existing?.id ?? '',
        name: _name.text.trim(),
        scope: _scope,
        categoryId: _categoryIds.isEmpty ? 'all' : _categoryIds.first,
        categoryIds: _categoryIds.toList(),
        accountIds: _scope == BudgetScope.personal
            ? _accountIds.toList()
            : const [],
        limitMinor: (double.parse(_limit.text) * multiplier).round(),
        currency: _currency,
        spaceId: _scope == BudgetScope.space ? _spaceId : null,
        alerts: [if (_alertAt80) 80, if (_alertAt100) 100],
        period: _period,
        customPeriodDays: _customDays,
        rollover: _rollover,
        startsOn: existing?.startsOn ?? repo.today,
        version: _version,
      ),
    );
    if (mounted) context.pop();
  }
}

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final query = viewModel.queryFor('subscriptions').trim().toLowerCase();
    final sort = viewModel.sortFor('subscriptions', PkSort.dateAsc);
    bool matches(Subscription item) =>
        query.isEmpty ||
        item.name.toLowerCase().contains(query) ||
        (repo.categoryById(item.categoryId)?.name ?? '').toLowerCase().contains(
          query,
        ) ||
        (repo.accountById(item.accountId)?.name ?? '').toLowerCase().contains(
          query,
        );
    int order(Subscription a, Subscription b) => switch (sort) {
      PkSort.amountDesc => b.amountMinor.compareTo(a.amountMinor),
      PkSort.amountAsc => a.amountMinor.compareTo(b.amountMinor),
      PkSort.nameAsc => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      PkSort.nameDesc => b.name.toLowerCase().compareTo(a.name.toLowerCase()),
      PkSort.dateDesc => (b.nextDueOn ?? DateTime(3000)).compareTo(
        a.nextDueOn ?? DateTime(3000),
      ),
      _ => (a.nextDueOn ?? DateTime(3000)).compareTo(
        b.nextDueOn ?? DateTime(3000),
      ),
    };
    final allActive = repo.subscriptions
        .where((item) => item.status == SubscriptionStatus.active)
        .toList();
    final active = allActive.where(matches).toList()..sort(order);
    final paused =
        repo.subscriptions
            .where(
              (item) =>
                  item.status == SubscriptionStatus.paused && matches(item),
            )
            .toList()
          ..sort(order);
    final reporting = repo.profile.reportingCurrency;
    final monthly = active.fold(0, (sum, item) {
      final native = _monthlyEquivalent(item);
      return sum + (repo.convertMinor(native, item.currency, reporting) ?? 0);
    });
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.subscriptions),
        actions: [
          IconButton(
            onPressed: () => context.push('/subscriptions/new'),
            tooltip: context.t.addSubscription,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: PkPage(
        bottomPadding: 32,
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x2,
              PkSpacing.screen,
              PkSpacing.x6,
            ),
            sliver: SliverToBoxAdapter(
              child: _SubscriptionHero(
                monthly: monthly,
                currency: reporting,
                count: allActive.length,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkListControls(
                listId: 'subscriptions',
                totalCount: repo.subscriptions.length,
                resultCount: active.length + paused.length,
                hintText: context.t.searchRecurringItems,
                sortOptions: const [
                  PkSort.dateAsc,
                  PkSort.dateDesc,
                  PkSort.amountDesc,
                  PkSort.amountAsc,
                  PkSort.nameAsc,
                  PkSort.nameDesc,
                ],
                sort: sort,
                onSortChanged: (value) =>
                    viewModel.setSortFor('subscriptions', value),
                query: viewModel.queryFor('subscriptions'),
                onQueryChanged: (value) =>
                    viewModel.setQueryFor('subscriptions', value),
              ),
            ),
          ),
          if (active.isEmpty && paused.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.autorenew_rounded,
                title: context.t.noActiveSubscriptions,
                message: context.t.addRecurringPaymentsToSee,
                actionLabel: context.t.addSubscription,
                onAction: () => context.push('/subscriptions/new'),
              ),
            )
          else
            // Section 7.14: Overdue / Due soon / Later, so what is late is the
            // first thing on the screen rather than an equal member of one
            // undifferentiated "Active" list.
            for (final group in _groupByUrgency(active, repo.today, context.t))
              SliverPadding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  context.gutter,
                  0,
                  context.gutter,
                  PkSpacing.section,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PkGroupLabel(
                        label: group.$1,
                        trailing: Text(
                          '${group.$2.length}',
                          style: context.pkText.supporting,
                        ),
                      ),
                      PkGroupedSurface(
                        indent:
                            PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                        children: [
                          for (final item in group.$2)
                            _SubscriptionCard(subscription: item),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          if (paused.isNotEmpty)
            SliverPadding(
              padding: EdgeInsetsDirectional.fromSTEB(
                context.gutter,
                0,
                context.gutter,
                PkSpacing.section,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PkGroupLabel(
                      label: context.t.paused,
                      trailing: Text(
                        '${paused.length}',
                        style: context.pkText.supporting,
                      ),
                    ),
                    PkGroupedSurface(
                      indent:
                          PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                      children: [
                        for (final item in paused)
                          _SubscriptionCard(subscription: item),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Overdue first, then what is due within a week, then the rest.
  ///
  /// Empty groups are dropped rather than shown as empty headings.
  static List<(String, List<Subscription>)> _groupByUrgency(
    List<Subscription> items,
    DateTime today,
    PkStrings t,
  ) {
    final overdue = <Subscription>[];
    final soon = <Subscription>[];
    final later = <Subscription>[];
    for (final item in items) {
      final due = item.nextDueOn;
      if (due == null) {
        later.add(item);
      } else if (due.isBefore(today)) {
        overdue.add(item);
      } else if (due.difference(today).inDays <= 7) {
        soon.add(item);
      } else {
        later.add(item);
      }
    }
    return [
      if (overdue.isNotEmpty) (t.subscriptionsOverdue, overdue),
      if (soon.isNotEmpty) (t.subscriptionsDueSoon, soon),
      if (later.isNotEmpty) (t.subscriptionsLater, later),
    ];
  }

  static int _monthlyEquivalent(Subscription item) =>
      switch (item.cadence.frequency) {
        'YEARLY' => item.amountMinor ~/ 12,
        'WEEKLY' => (item.amountMinor * 4.33).round(),
        'DAILY' => (item.amountMinor * 30.44).round(),
        _ => item.amountMinor ~/ item.cadence.interval,
      };
}

class SubscriptionDetailScreen extends StatelessWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});
  final String subscriptionId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final subscription = repo.subscriptionById(subscriptionId);
    if (subscription == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.autorenew_rounded,
          title: context.t.subscriptionNotFound,
          message: context.t.itMayHaveBeenRemoved4,
        ),
      );
    }
    final account = repo.accountById(subscription.accountId);
    final category = repo.categoryById(subscription.categoryId);
    final payments = repo.transactions
        .where((item) => item.subscriptionId == subscription.id)
        .toList();
    return Scaffold(
      appBar: PkAppBar(
        title: Text(subscription.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                context.push('/subscriptions/${subscription.id}/edit');
                return;
              }
              if (value == 'toggle') {
                await repo.saveSubscription(
                  subscription.copyWith(
                    status: subscription.status == SubscriptionStatus.active
                        ? SubscriptionStatus.paused
                        : SubscriptionStatus.active,
                  ),
                );
                return;
              }
              if (value == 'archive') {
                if (!context.mounted) return;
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(context.t.archiveX0(subscription.name)),
                    content: Text(context.t.paymentHistoryRemainsInActivity),
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
                  await repo.saveSubscription(
                    subscription.copyWith(archived: true),
                  );
                  if (context.mounted) context.pop();
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text(context.t.editSubscription),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'toggle',
                child: ListTile(
                  leading: Icon(
                    subscription.status == SubscriptionStatus.active
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                  ),
                  title: Text(
                    subscription.status == SubscriptionStatus.active
                        ? context.t.pause
                        : context.t.resume,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'archive',
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text(context.t.archive),
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
                    icon: PkIcons.named(subscription.icon),
                    color: PkPalette.categoryAt(category?.colorIndex ?? 2),
                    size: 64,
                    iconSize: 30,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  PkAmountText(
                    amountMinor: subscription.amountMinor,
                    currency: subscription.currency,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Text(
                    _cadenceLabel(context, subscription.cadence),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.pk.textSecondary,
                    ),
                  ),
                  if (subscription.status == SubscriptionStatus.paused)
                    Padding(
                      padding: const EdgeInsets.only(top: PkSpacing.x2),
                      child: Chip(
                        label: Text(context.t.paused),
                        avatar: const Icon(Icons.pause_rounded, size: 18),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  children: [
                    _ManagementRow(
                      label: context.t.nextDue,
                      value: subscription.nextDueOn == null
                          ? context.t.notScheduled
                          : PkFormat.longDate(
                              subscription.nextDueOn!,
                              context.t,
                            ),
                    ),
                    _ManagementRow(
                      label: context.t.accountLabel,
                      value: account?.name ?? context.t.unknown,
                    ),
                    _ManagementRow(
                      label: context.t.categoryLabel,
                      value: category?.name ?? context.t.uncategorised,
                    ),
                    _ManagementRow(
                      label: context.t.started,
                      value: PkFormat.longDate(
                        subscription.startsOn,
                        context.t,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (subscription.status == SubscriptionStatus.active)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x4,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _skip(context, subscription),
                        child: Text(context.t.skipNext),
                      ),
                    ),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => _pay(context, subscription),
                        child: Text(context.t.recordPayment),
                      ),
                    ),
                  ],
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
              child: PkSectionHeader(
                title: context.t.paymentHistory,
                trailing: Text(
                  '${payments.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          if (payments.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.history_rounded,
                title: context.t.noPaymentsRecorded,
                message: context.t.recordedPaymentsAppearHereAnd,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: payments
                        .map(
                          (item) => PkTransactionTile(
                            transaction: item,
                            repository: repo,
                            onTap: () => context.push('/activity/${item.id}'),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  static String _cadenceLabel(
    BuildContext context,
    SubscriptionCadence cadence,
  ) => switch (cadence.frequency) {
    'YEARLY' => context.t.everyYear,
    'WEEKLY' => context.t.everyWeek,
    'DAILY' => context.t.everyDay,
    _ =>
      cadence.interval == 1
          ? context.t.everyMonth
          : context.t.everyX0Months(cadence.interval),
  };

  Future<void> _pay(BuildContext context, Subscription subscription) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final account = repo.accountById(subscription.accountId);
    final walletAmount = account == null
        ? null
        : repo.convertMinor(
            subscription.amountMinor,
            subscription.currency,
            account.currency,
          );
    final conversion =
        account != null &&
            account.currency != subscription.currency &&
            walletAmount != null
        ? context.t.walletDebitUsingTheCurrent(
            PkFormat.money(walletAmount, account.currency),
            repo.fxSettings.mode.name,
          )
        : '';
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.recordX0(subscription.name)),
        content: Text(
          '${PkFormat.money(subscription.amountMinor, subscription.currency)} will be recorded from ${account?.name}.$conversion',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.record),
          ),
        ],
      ),
    );
    if (accepted == true) {
      await repo.recordSubscriptionPayment(
        subscription.id,
        accountId: subscription.accountId,
        date: repo.today,
      );
    }
  }

  Future<void> _skip(BuildContext context, Subscription subscription) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.skipThisPayment),
        content: Text(context.t.noExpenseIsRecordedThe),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.skip),
          ),
        ],
      ),
    );
    if (accepted == true && context.mounted) {
      await context.read<PockitoAppViewModel>().repository.skipSubscription(
        subscription.id,
      );
    }
  }
}

class SubscriptionEditorScreen extends StatefulWidget {
  const SubscriptionEditorScreen({super.key, this.subscriptionId});
  final String? subscriptionId;
  @override
  State<SubscriptionEditorScreen> createState() =>
      _SubscriptionEditorScreenState();
}

class _SubscriptionEditorScreenState extends State<SubscriptionEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _amount;
  String? _accountId;
  String? _categoryId;
  String _frequency = 'MONTHLY';
  String _currency = 'EUR';
  int _day = 1;

  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.subscriptionId == null
        ? null
        : repo.subscriptionById(widget.subscriptionId!);
    _name = TextEditingController(text: existing?.name ?? '');
    _amount = TextEditingController(
      text: existing == null
          ? ''
          : (existing.amountMinor /
                    PockitoCurrencies.of(existing.currency).minorUnitScale)
                .toStringAsFixed(
                  PockitoCurrencies.of(existing.currency).decimals,
                ),
    );
    _accountId =
        existing?.accountId ??
        repo.accounts.where((item) => item.isDefault).first.id;
    _categoryId = existing?.categoryId ?? 'c_ent';
    _frequency = existing?.cadence.frequency ?? 'MONTHLY';
    _currency =
        existing?.currency ??
        repo.accountById(_accountId ?? '')?.currency ??
        repo.profile.reportingCurrency;
    _day = existing?.cadence.dayOfMonth ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final editing = widget.subscriptionId != null;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(
          editing ? context.t.editSubscription : context.t.addSubscription,
        ),
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
                  TextFormField(
                    key: const ValueKey('subscription_name'),
                    controller: _name,
                    autofocus: !editing,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: context.t.name,
                      hintText: context.t.eGSpotify,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.t.nameThisSubscription
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  TextFormField(
                    key: const ValueKey('subscription_amount'),
                    controller: _amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.t.amount,
                      prefixText: '${PockitoCurrencies.of(_currency).symbol} ',
                    ),
                    validator: (value) =>
                        (double.tryParse(value ?? '') ?? 0) <= 0
                        ? context.t.enterAnAmount
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('subscription_currency'),
                    isExpanded: true,
                    initialValue: _currency,
                    decoration: InputDecoration(
                      labelText: context.t.billingCurrency,
                    ),
                    items: PockitoCurrencies.all.values
                        .map(
                          (item) => DropdownMenuItem(
                            value: item.code,
                            child: Text('${item.code} · ${item.name}'),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _currency = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  // Section 6.11: rich entities get the shared picker, which
                  // shows the account's own colour and icon, searches past
                  // eight rows, and wraps instead of clipping at large text.
                  PkSelectField(
                    key: const ValueKey('subscription_account'),
                    label: context.t.paidFrom,
                    value: repo.accountById(_accountId ?? '')?.name,
                    placeholder: context.t.chooseAnAccount,
                    leading: () {
                      final account = repo.accountById(_accountId ?? '');
                      if (account == null) return null;
                      return PkIconTile(
                        icon: PkIcons.named(account.icon),
                        color: PkPalette.categoryAt(account.colorIndex),
                        size: PkSize.avatarCompact,
                      );
                    }(),
                    onTap: () async {
                      final picked = await showPkAccountPicker(
                        context,
                        repo: repo,
                        title: context.t.paidFrom,
                        selectedId: _accountId,
                      );
                      if (picked != null) setState(() => _accountId = picked);
                    },
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  PkSelectField(
                    key: const ValueKey('subscription_category'),
                    label: context.t.categoryLabel,
                    value: repo.categoryById(_categoryId ?? '')?.name,
                    placeholder: context.t.chooseACategory,
                    leading: () {
                      final category = repo.categoryById(_categoryId ?? '');
                      if (category == null) return null;
                      return PkIconTile(
                        icon: PkIcons.named(category.icon),
                        color: PkPalette.categoryAt(category.colorIndex),
                        size: PkSize.avatarCompact,
                      );
                    }(),
                    onTap: () async {
                      final picked = await showPkCategoryPicker(
                        context,
                        repo: repo,
                        type: CategoryType.expense,
                        selectedId: _categoryId,
                      );
                      if (picked != null) setState(() => _categoryId = picked);
                    },
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  PkCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.autorenew_rounded),
                      title: Text(context.t.cadence),
                      subtitle: Text(
                        _frequency == 'MONTHLY'
                            ? context.t.monthlyOnDay(_day)
                            : _frequency.toLowerCase(),
                      ),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: _pickCadence,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x8),
                  FilledButton(
                    key: const ValueKey('save_subscription'),
                    onPressed: _save,
                    child: Text(
                      editing
                          ? context.t.saveChanges
                          : context.t.addSubscription,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCadence() async {
    final result = await showPkSheet<(String, int)>(
      context,
      size: PkSheetSize.compact,
      builder: (context) => _CadencePicker(frequency: _frequency, day: _day),
    );
    if (result != null) {
      setState(() {
        _frequency = result.$1;
        _day = result.$2;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.subscriptionId == null
        ? null
        : repo.subscriptionById(widget.subscriptionId!);
    await repo.saveSubscription(
      Subscription(
        id: existing?.id ?? '',
        name: _name.text.trim(),
        amountMinor:
            (double.parse(_amount.text) *
                    PockitoCurrencies.of(_currency).minorUnitScale)
                .round(),
        currency: _currency,
        accountId: _accountId!,
        categoryId: _categoryId!,
        icon: repo.categoryById(_categoryId!)?.icon ?? 'receipt',
        cadence: SubscriptionCadence(
          frequency: _frequency,
          dayOfMonth: _frequency == 'MONTHLY' ? _day : null,
        ),
        startsOn: existing?.startsOn ?? repo.today,
        nextDueOn:
            existing?.nextDueOn ??
            DateTime(repo.today.year, repo.today.month + 1, _day),
        lastPaidOn: existing?.lastPaidOn,
        status: existing?.status ?? SubscriptionStatus.active,
      ),
    );
    if (mounted) context.pop();
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final query = viewModel.queryFor('categories').trim().toLowerCase();
    bool matches(Category item) =>
        query.isEmpty || item.name.toLowerCase().contains(query);

    /// Parents first, each followed by its own children, so the tree reads as
    /// a tree. A parent survives the filter when one of its children matches.
    List<Category> tree(CategoryType type) => [
      for (final parent
          in repo.categoryChildren(null).where((item) => item.type == type))
        ...() {
          final children = repo
              .categoryChildren(parent.id)
              .where(matches)
              .toList();
          if (!matches(parent) && children.isEmpty) return <Category>[];
          return [parent, ...children];
        }(),
    ];
    final expense = tree(CategoryType.expense);
    final income = tree(CategoryType.income);
    final total = repo.categories.length;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.categories),
        actions: [
          IconButton(
            onPressed: () => _editCategory(context),
            tooltip: context.t.addCategory,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkListControls(
              listId: 'categories',
              totalCount: total,
              resultCount: expense.length + income.length,
              hintText: context.t.searchCategoriesCount(total),
              sortOptions: const [PkSort.nameAsc],
              sort: PkSort.nameAsc,
              onSortChanged: (_) {},
              query: viewModel.queryFor('categories'),
              onQueryChanged: (value) =>
                  viewModel.setQueryFor('categories', value),
            ),
            if (expense.isEmpty && income.isEmpty)
              PkListState.empty(
                icon: Icons.search_off_rounded,
                title: context.t.noCategoryMatches(query),
                message: context.t.tryADifferentNameOr2,
                actionLabel: context.t.actionClearSearch,
                onAction: () => viewModel.setQueryFor('categories', ''),
              )
            else ...[
              _CategoryGroup(title: context.t.expense, categories: expense),
              const SizedBox(height: PkSpacing.x6),
              _CategoryGroup(title: context.t.income, categories: income),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _editCategory(BuildContext context, [Category? category]) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final name = TextEditingController(text: category?.name ?? '');
    var type = category?.type ?? CategoryType.expense;
    var color = category?.colorIndex ?? 2;
    await showPkSheet<void>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x4,
            0,
            PkSpacing.x4,
            MediaQuery.viewInsetsOf(context).bottom + PkSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                category == null
                    ? context.t.addCategory
                    : context.t.editCategory,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x4),
              TextField(
                controller: name,
                autofocus: true,
                decoration: InputDecoration(labelText: context.t.name),
              ),
              const SizedBox(height: PkSpacing.x4),
              SegmentedButton<CategoryType>(
                segments: [
                  ButtonSegment(
                    value: CategoryType.expense,
                    label: Text(context.t.expense),
                  ),
                  ButtonSegment(
                    value: CategoryType.income,
                    label: Text(context.t.income),
                  ),
                ],
                selected: {type},
                onSelectionChanged: category?.system == true
                    ? null
                    : (value) => setModalState(() => type = value.first),
              ),
              const SizedBox(height: PkSpacing.x4),
              Wrap(
                spacing: PkSpacing.x2,
                runSpacing: PkSpacing.x2,
                children: List.generate(
                  PkPalette.category.length,
                  (index) => InkWell(
                    onTap: () => setModalState(() => color = index + 1),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: PkPalette.category[index],
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: color == index + 1
                              ? context.pk.textPrimary
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: PkSpacing.x5),
              FilledButton(
                onPressed: () {
                  if (name.text.trim().isEmpty) return;
                  final newCategory = Category(
                    id:
                        category?.id ??
                        'c_${DateTime.now().microsecondsSinceEpoch}',
                    name: name.text.trim(),
                    type: type,
                    icon: category?.icon ?? 'receipt',
                    colorIndex: color,
                    system: category?.system ?? false,
                  );
                  if (category == null) {
                    repo.addCategory(newCategory);
                  } else {
                    repo.updateCategory(newCategory);
                  }
                  Navigator.pop(context);
                },
                child: Text(context.t.saveCategory),
              ),
            ],
          ),
        ),
      ),
    );
    name.dispose();
  }
}

class _BudgetGroup extends StatelessWidget {
  const _BudgetGroup({required this.title, required this.snapshots});
  final String title;
  final List<BudgetSnapshot> snapshots;
  @override
  // Section 7.13: Personal and Shared are the two groups, each one surface of
  // 72–80 px rows rather than a card per budget.
  Widget build(BuildContext context) => SliverPadding(
    padding: EdgeInsetsDirectional.fromSTEB(
      context.gutter,
      PkSpacing.x3,
      context.gutter,
      PkSpacing.section,
    ),
    sliver: SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PkGroupLabel(
            label: title,
            trailing: Text(
              '${snapshots.length}',
              style: context.pkText.supporting,
            ),
          ),
          PkGroupedSurface(
            children: [
              for (final snapshot in snapshots)
                PkBudgetTile(
                  snapshot: snapshot,
                  onTap: () => context.push('/budgets/${snapshot.budget.id}'),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _BudgetHero extends StatelessWidget {
  const _BudgetHero({required this.snapshot});
  final BudgetSnapshot snapshot;
  @override
  Widget build(BuildContext context) {
    final color = snapshot.health == BudgetHealth.exceeded
        ? context.pk.danger
        : snapshot.health == BudgetHealth.near
        ? context.pk.warning
        : Theme.of(context).colorScheme.primary;
    return PkCard(
      child: Column(
        children: [
          SizedBox(
            width: 240,
            height: 170,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  top: 5,
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: snapshot.progress.clamp(0, 1),
                    strokeWidth: 14,
                    backgroundColor: context.pk.sunken,
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 5,
                  width: 160,
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(snapshot.progress * 100).round()}%',
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      Text(
                        context.t.budgetUsed,
                        style: context.pkText.supporting,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  // A full pose, not the avatar crop: the avatar asset is
                  // built for 32-56 px badges, not a 96 px illustration.
                  child: KitoImage(
                    asset: snapshot.health == BudgetHealth.healthy
                        ? KitoAsset.defaultPose
                        : KitoAsset.concerned,
                    width: 96,
                    height: 96,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: PkSpacing.x5),
          PkAmountText(
            amountMinor: snapshot.usedMinor,
            currency: snapshot.budget.currency,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            context.t.ofX0(
              PkFormat.money(
                snapshot.budget.limitMinor,
                snapshot.budget.currency,
              ),
            ),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
          const SizedBox(height: PkSpacing.x3),
          Text(
            snapshot.health == BudgetHealth.exceeded
                ? context.t.x0OverBudget(
                    PkFormat.money(
                      snapshot.remainingMinor.abs(),
                      snapshot.budget.currency,
                    ),
                  )
                : context.t.x0Remaining(
                    PkFormat.money(
                      snapshot.remainingMinor,
                      snapshot.budget.currency,
                    ),
                  ),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _BudgetMetric extends StatelessWidget {
  const _BudgetMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => PkCard(
    padding: const EdgeInsets.all(PkSpacing.x3),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    ),
  );
}

class _SubscriptionHero extends StatelessWidget {
  const _SubscriptionHero({
    required this.monthly,
    required this.currency,
    required this.count,
  });
  final int monthly;
  final String currency;
  final int count;
  @override
  Widget build(BuildContext context) => PkHeroPanel(
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.t.monthlyCost,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: PkSpacing.x2),
              PkAmountText(
                amountMinor: monthly,
                currency: currency,
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: Colors.white),
              ),
              Text(
                context.t.activeAnnualized(
                  count,
                  PkFormat.money(monthly * 12, currency),
                ),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        Icon(
          Icons.autorenew_rounded,
          color: Colors.white.withValues(alpha: .8),
          size: 42,
        ),
      ],
    ),
  );
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({required this.subscription});
  final Subscription subscription;
  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final due = subscription.nextDueOn == null
        ? context.t.notScheduled
        : PkFormat.shortDate(subscription.nextDueOn!, repo.today, context.t);
    final paused = subscription.status == SubscriptionStatus.paused;
    final account = repo.accountById(subscription.accountId)?.name ?? '';
    // Section 7.14: 68–76 px. The amount and the due date align right; the
    // account and cadence are supporting copy on the left.
    return PkLedgerRow(
      density: PkRowDensity.rich,
      semanticIdentifier: 'subscription_${subscription.id}',
      semanticLabel: [
        subscription.name,
        PkFormat.money(subscription.amountMinor, subscription.currency),
        if (paused) context.t.paused else context.t.dueX0(due),
        account,
      ].where((part) => part.isNotEmpty).join(', '),
      leading: PkIconTile(
        icon: PkIcons.named(subscription.icon),
        color: PkPalette.categoryAt(
          repo.categoryById(subscription.categoryId)?.colorIndex ?? 2,
        ),
      ),
      title: subscription.name,
      badges: [
        if (paused)
          PkStatusBadge(
            label: context.t.paused,
            tone: PkStatusTone.neutral,
            icon: Icons.pause_rounded,
          ),
      ],
      subtitle: account,
      trailing: PkAmountText(
        amountMinor: subscription.amountMinor,
        currency: subscription.currency,
        style: context.pkText.moneyRow,
      ),
      trailingSubtitle: paused
          ? null
          : Text(
              due,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.pkText.supporting,
            ),
      showChevron: true,
      onTap: () => context.push('/subscriptions/${subscription.id}'),
    );
  }
}

class _CadencePicker extends StatefulWidget {
  const _CadencePicker({required this.frequency, required this.day});
  final String frequency;
  final int day;
  @override
  State<_CadencePicker> createState() => _CadencePickerState();
}

class _CadencePickerState extends State<_CadencePicker> {
  late String _frequency = widget.frequency;
  late int _day = widget.day;
  @override
  Widget build(BuildContext context) => Padding(
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
        Text(context.t.cadence, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: PkSpacing.x4),
        DropdownButtonFormField<String>(
          initialValue: _frequency,
          decoration: InputDecoration(labelText: context.t.repeats),
          items: const ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY']
              .map(
                (item) => DropdownMenuItem(
                  value: item,
                  child: Text(item[0] + item.substring(1).toLowerCase()),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => _frequency = value!),
        ),
        if (_frequency == 'MONTHLY') ...[
          const SizedBox(height: PkSpacing.x4),
          DropdownButtonFormField<int>(
            initialValue: _day,
            decoration: InputDecoration(labelText: context.t.dayOfMonth),
            items: List.generate(
              28,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text('${index + 1}'),
              ),
            ),
            onChanged: (value) => setState(() => _day = value!),
          ),
        ],
        const SizedBox(height: PkSpacing.x5),
        FilledButton(
          onPressed: () => Navigator.pop(context, (_frequency, _day)),
          child: Text(context.t.actionDone),
        ),
      ],
    ),
  );
}

class _CategoryGroup extends StatelessWidget {
  const _CategoryGroup({required this.title, required this.categories});
  final String title;
  final List<Category> categories;
  @override
  // Section 7.15: 56–64 px management rows, icon and colour at 32–36, and a
  // hierarchy shown through indentation rather than nested oversized cards.
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PkGroupLabel(
        label: title,
        trailing: Text(
          '${categories.length}',
          style: context.pkText.supporting,
        ),
      ),
      PkGroupedSurface(
        indent: PkSpacing.x4 + PkSize.avatarCompact + PkSpacing.x3,
        children: [
          for (final category in categories)
            Padding(
              // Children are indented under their parent, which is the only
              // thing that makes a hierarchy legible in a flat list.
              padding: EdgeInsetsDirectional.only(
                start: category.parentId == null ? 0 : PkSpacing.x5,
              ),
              child: PkLedgerRow.management(
                key: ValueKey('category_${category.id}'),
                semanticIdentifier: 'category_${category.id}',
                leading: PkIconTile(
                  icon: PkIcons.named(category.icon),
                  color: PkPalette.categoryAt(category.colorIndex),
                  size: category.parentId == null
                      ? PkSize.iconTileDense
                      : PkSize.avatarCompact,
                ),
                title: category.name,
                subtitle: [
                  if (category.parentId != null) context.t.subcategory,
                  category.system
                      ? context.t.pockitoCategory
                      : context.t.customCategory,
                ].join(' · '),
                showChevron: true,
                onTap: () => _showActions(context, category),
              ),
            ),
        ],
      ),
    ],
  );

  Future<void> _showActions(BuildContext context, Category category) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final action = await showPkSheet<String>(
      context,
      builder: (context) => PkSheetScaffold(
        title: category.name,
        subtitle: category.system
            ? context.t.aPockitoCategoryItCan
            : context.t.yourOwnCategory,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              key: const ValueKey('category_edit'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.t.rename),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              key: const ValueKey('category_parent'),
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_tree_outlined),
              title: Text(
                category.parentId == null
                    ? context.t.nestUnderAnotherCategory
                    : context.t.moveOutOfParent(
                        repo.categoryById(category.parentId!)?.name ?? '',
                      ),
              ),
              onTap: () => Navigator.pop(context, 'parent'),
            ),
            ListTile(
              key: const ValueKey('category_hide'),
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                category.hidden
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              title: Text(
                category.hidden ? context.t.showAgain : context.t.hide,
              ),
              subtitle: Text(
                category.hidden
                    ? context.t.itReappearsInPickersAnd
                    : context.t.itStaysOnEveryRecord,
              ),
              onTap: () => Navigator.pop(context, 'hide'),
            ),
            // Deleting is only offered where it is actually possible.
            if (!category.system)
              ListTile(
                key: const ValueKey('category_delete'),
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.delete_outline_rounded,
                  color: context.pk.danger,
                ),
                title: Text(
                  context.t.delete,
                  style: TextStyle(color: context.pk.danger),
                ),
                onTap: () => Navigator.pop(context, 'delete'),
              ),
          ],
        ),
      ),
    );
    if (action == 'hide' && context.mounted) {
      await PkGuardedAction.run(
        context,
        () => repo.setCategoryHidden(category.id, !category.hidden),
        undoMessage: category.hidden
            ? context.t.isVisibleAgain(category.name)
            : context.t.x0Hidden(category.name),
        onUndo: () => repo.setCategoryHidden(category.id, category.hidden),
      );
      return;
    }
    if (action == 'parent' && context.mounted) {
      if (category.parentId != null) {
        await PkGuardedAction.run(
          context,
          () => repo.updateCategory(category.copyWith(parentId: null)),
          successMessage: context.t.isTopLevelAgain(category.name),
        );
        return;
      }
      // Only a top-level category can be a parent: one level is enough to
      // group, and deeper trees are where category systems go to die.
      final parentId = await showPkCategoryPicker(
        context,
        repo: repo,
        type: category.type,
        title: context.t.nestX0Under(category.name),
      );
      if (parentId == null || parentId == category.id || !context.mounted) {
        return;
      }
      if (repo.categoryById(parentId)?.parentId != null) {
        showPkErrorToast(context, context.t.categoriesOnlyNestOneLevel);
        return;
      }
      if (repo.categoryChildren(category.id).isNotEmpty) {
        showPkErrorToast(
          context,
          context.t.hasItsOwnSubcategoriesSo(category.name),
        );
        return;
      }
      await PkGuardedAction.run(
        context,
        () => repo.updateCategory(category.copyWith(parentId: parentId)),
        successMessage: context.t.x0NowSitsUnderX1(
          category.name,
          repo.categoryById(parentId)?.name ?? 'its parent',
        ),
      );
      return;
    }
    if (action == 'edit' && context.mounted) {
      final controller = TextEditingController(text: category.name);
      final name = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.t.editCategory),
          content: TextField(controller: controller, autofocus: true),
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
        repo.updateCategory(category.copyWith(name: name));
      }
    }
    if (action == 'delete' && context.mounted) {
      await _reassignAndDelete(context, category);
    }
  }

  Future<void> _reassignAndDelete(
    BuildContext context,
    Category category,
  ) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final used =
        repo.transactions.any((item) => item.categoryId == category.id) ||
        repo.sharedExpenses.any((item) => item.categoryId == category.id);
    if (!used) {
      await repo.deleteCategory(category.id);
      return;
    }
    String replacement = repo.categories
        .firstWhere(
          (item) => item.type == category.type && item.id != category.id,
        )
        .id;
    final confirmed = await showPkSheet<bool>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
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
                context.t.reassignBeforeDeleting,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                context.t.isUsedByExistingMoney(category.name),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: PkSpacing.x4),
              DropdownButtonFormField<String>(
                initialValue: replacement,
                decoration: InputDecoration(labelText: context.t.moveTo),
                items: repo.categories
                    .where(
                      (item) =>
                          item.type == category.type && item.id != category.id,
                    )
                    .map(
                      (item) => DropdownMenuItem(
                        value: item.id,
                        child: Text(item.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => replacement = value!),
              ),
              const SizedBox(height: PkSpacing.x5),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.pk.danger,
                ),
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.t.reassignAndDelete),
              ),
            ],
          ),
        ),
      ),
    );
    if (confirmed == true) {
      await repo.reassignAndDeleteCategory(category.id, replacement);
    }
  }
}

class _ManagementRow extends StatelessWidget {
  const _ManagementRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x3),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
