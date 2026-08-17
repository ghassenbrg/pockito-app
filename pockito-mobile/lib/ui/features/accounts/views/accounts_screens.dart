import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_tokens.dart';
import '../../../core/design_system/pk_labels.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  /// The account shown in the detail pane on wide displays. Null on phones,
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
          : AccountDetailScreen(key: ValueKey(selected), accountId: selected),
      placeholder: PkEmptyState.section(
        icon: Icons.account_balance_wallet_outlined,
        title: context.t.navAccounts,
        message: context.t.accountsAreWhereMoneyEnters,
      ),
    );
  }

  Widget _buildList(BuildContext context, bool wide) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final all = repo.accounts.where((item) => !item.archived).toList();
    final byCurrency = <String, int>{};
    for (final account in all) {
      byCurrency[account.currency] =
          (byCurrency[account.currency] ?? 0) + repo.accountBalance(account);
    }
    final query = viewModel.queryFor('accounts').trim().toLowerCase();
    final sort = viewModel.sortFor('accounts', PkSort.nameAsc);
    final accounts =
        all.where((account) {
          if (query.isEmpty) return true;
          return account.name.toLowerCase().contains(query) ||
              account.currency.toLowerCase().contains(query) ||
              account.type.name.toLowerCase().contains(query);
        }).toList()..sort(
          (a, b) => switch (sort) {
            PkSort.nameAsc => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
            PkSort.nameDesc => b.name.toLowerCase().compareTo(
              a.name.toLowerCase(),
            ),
            PkSort.balanceDesc =>
              repo.accountBalance(b).compareTo(repo.accountBalance(a)),
            PkSort.balanceAsc =>
              repo.accountBalance(a).compareTo(repo.accountBalance(b)),
            // The user's own order is the default and stays available.
            _ => a.sortOrder.compareTo(b.sortOrder),
          },
        );
    return PkPage(
      refresh: context.read<PockitoAppViewModel>().simulateRefresh,
      slivers: [
        PkScreenHeader(
          title: context.t.navAccounts,
          // Section 6.2: the subtitle is dropped because the count it carried
          // is already visible in the summary and the list beneath it.
          actions: [
            // Section 7.2 and UI-P1-02: one primary add entry point. It lives
            // here rather than as a full-width button at the end of a list the
            // reader has already scrolled past.
            IconButton(
              key: const ValueKey('accounts_add'),
              onPressed: () => context.push('/accounts/new'),
              tooltip: context.t.addAccount,
              icon: const Icon(Icons.add_rounded),
            ),
            PopupMenuButton<String>(
              tooltip: context.t.accountActions,
              onSelected: (value) => context.push(
                value == 'archived'
                    ? '/accounts/archived'
                    : '/accounts/reorder',
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'reorder',
                  child: ListTile(
                    leading: Icon(Icons.swap_vert_rounded),
                    title: Text(context.t.reorderAccounts),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'archived',
                  child: ListTile(
                    leading: Icon(Icons.archive_outlined),
                    title: Text(context.t.archivedAccounts),
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
          sliver: SliverToBoxAdapter(
            child: _AccountTotals(byCurrency: byCurrency),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          sliver: SliverToBoxAdapter(
            child: PkListControls(
              listId: 'accounts',
              totalCount: all.length,
              resultCount: accounts.length,
              hintText: context.t.searchX0Accounts(all.length),
              sortOptions: const [
                PkSort.dateDesc,
                PkSort.nameAsc,
                PkSort.nameDesc,
                PkSort.balanceDesc,
                PkSort.balanceAsc,
              ],
              sort: sort,
              onSortChanged: (value) => viewModel.setSortFor('accounts', value),
              query: viewModel.queryFor('accounts'),
              onQueryChanged: (value) =>
                  viewModel.setQueryFor('accounts', value),
            ),
          ),
        ),
        if (accounts.isEmpty)
          SliverToBoxAdapter(
            child: query.isEmpty
                ? PkEmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: context.t.startWithAnAccount,
                    message: context.t.accountsAreWhereMoneyEnters,
                    actionLabel: context.t.addAccount,
                    onAction: () => context.push('/accounts/new'),
                  )
                : PkListState.empty(
                    icon: Icons.search_off_rounded,
                    title: context.t.noAccountMatches(query),
                    message: context.t.tryADifferentNameType2,
                    actionLabel: context.t.actionClearSearch,
                    onAction: () => viewModel.setQueryFor('accounts', ''),
                  ),
          )
        else
          // D-03: one surface with separators rather than a card per account.
          // That alone is what takes the list from three visible rows to six.
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: context.gutter),
            sliver: SliverToBoxAdapter(
              child: PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                children: [
                  for (final account in accounts)
                    PkAccountTile(
                      account: account,
                      balanceMinor: repo.accountBalance(account),
                      equivalentMinor:
                          account.currency == repo.profile.reportingCurrency
                          ? null
                          : repo.convertMinor(
                              repo.accountBalance(account),
                              account.currency,
                              repo.profile.reportingCurrency,
                            ),
                      equivalentCurrency: repo.profile.reportingCurrency,
                      onTap: () => wide
                          ? setState(() => _selectedId = account.id)
                          : context.push('/accounts/${account.id}'),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class AccountDetailScreen extends StatelessWidget {
  const AccountDetailScreen({super.key, required this.accountId});
  final String accountId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final account = repo.accountById(accountId);
    if (account == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.search_off_rounded,
          title: context.t.accountNotFound,
          message: context.t.itMayHaveBeenRemoved,
        ),
      );
    }
    final transactions = repo.transactions
        .where(
          (item) =>
              item.fromAccountId == account.id ||
              item.toAccountId == account.id,
        )
        .toList();
    final monthExpense = transactions
        .where(
          (item) =>
              item.type == MoneyEventType.expense &&
              item.occurredOn.month == repo.today.month,
        )
        .fold(0, (sum, item) => sum + item.amountMinor);
    final monthIncome = transactions
        .where(
          (item) =>
              item.type == MoneyEventType.income &&
              item.occurredOn.month == repo.today.month,
        )
        .fold(0, (sum, item) => sum + item.amountMinor);
    final available = repo.accountAvailable(account);
    return Scaffold(
      appBar: PkAppBar(
        title: Text(account.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') context.push('/accounts/${account.id}/edit');
              if (value == 'reconcile') {
                context.push('/accounts/${account.id}/reconcile');
              }
              if (value == 'archive') {
                final confirmed = await _confirmArchive(context, account);
                if (confirmed && context.mounted) {
                  await repo.archiveAccount(account.id, true);
                  if (context.mounted) context.pop();
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit_outlined),
                  title: Text(context.t.editAccount),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'reconcile',
                child: ListTile(
                  leading: Icon(Icons.rule_rounded),
                  title: Text(context.t.correctTheBalance),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'archive',
                child: ListTile(
                  leading: Icon(Icons.archive_outlined),
                  title: Text(context.t.archiveAccount),
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
              child: _AccountHero(
                account: account,
                balance: repo.accountBalance(account),
                spent: monthExpense,
                income: monthIncome,
                equivalentMinor:
                    account.currency == repo.profile.reportingCurrency
                    ? null
                    : repo.convertMinor(
                        repo.accountBalance(account),
                        account.currency,
                        repo.profile.reportingCurrency,
                      ),
                equivalentCurrency: repo.profile.reportingCurrency,
                quote: repo.fxQuote(
                  account.currency,
                  repo.profile.reportingCurrency,
                ),
              ),
            ),
          ),
          // Balance over time, plus whatever this account's shape adds:
          // headroom on a card, progress on a savings goal.
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              0,
              PkSpacing.screen,
              PkSpacing.x5,
            ),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.t.last30Days,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    PkSparkline(
                      points: repo.accountBalanceSeries(account),
                      currency: account.currency,
                      semanticLabel: context.t.balanceOverTheLastDays(
                        account.name,
                        PkFormat.money(
                          repo.accountBalance(account),
                          account.currency,
                        ),
                      ),
                    ),
                    if (available != null) ...[
                      const SizedBox(height: PkSpacing.x4),
                      Text(
                        context.t.availableToSpend,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 2),
                      // A card's balance is what you owe; the useful number is
                      // what is left before you hit the limit.
                      Row(
                        children: [
                          Expanded(
                            child: PkAmountText(
                              amountMinor: available,
                              currency: account.currency,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Text(
                            context.t.ofX0Limit(
                              PkFormat.money(
                                account.creditLimitMinor!,
                                account.currency,
                              ),
                            ),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: PkSpacing.x2),
                      PkProgressBar(
                        value: account.creditLimitMinor == 0
                            ? 0
                            : (-repo.accountBalance(account)) /
                                  account.creditLimitMinor!,
                        color: context.pk.warning,
                      ),
                    ],
                    if (account.goalAmountMinor != null) ...[
                      const SizedBox(height: PkSpacing.x4),
                      Text(
                        context.t.savingsGoal,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              context.t.x0OfX1(
                                PkFormat.money(
                                  repo.accountBalance(account),
                                  account.currency,
                                ),
                                PkFormat.money(
                                  account.goalAmountMinor!,
                                  account.currency,
                                ),
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            '${((repo.accountBalance(account) / account.goalAmountMinor!) * 100).clamp(0, 999).round()}%',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: PkSpacing.x2),
                      PkProgressBar(
                        value:
                            repo.accountBalance(account) /
                            account.goalAmountMinor!,
                        color: context.pk.success,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(
                title: context.t.recentActivity,
                trailing: Text(
                  '${transactions.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          ),
          if (transactions.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.receipt_long_outlined,
                title: context.t.activityNoneTitle,
                message: context.t.recordThisAccountSFirst,
                actionLabel: context.t.addMoneyEvent,
                onAction: () => context.push('/add?account=${account.id}'),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
              sliver: SliverToBoxAdapter(
                child: PkCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: transactions
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
              PkSpacing.x5,
              PkSpacing.screen,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: FilledButton.icon(
                onPressed: () => context.push('/add?account=${account.id}'),
                icon: const Icon(Icons.add_rounded),
                label: Text(context.t.addMoneyEvent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmArchive(BuildContext context, Account account) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.t.archiveX0(account.name)),
          content: Text(context.t.itsHistoryStaysAvailableYou),
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
      ) ??
      false;
}

class AccountEditorScreen extends StatefulWidget {
  const AccountEditorScreen({super.key, this.accountId});
  final String? accountId;

  @override
  State<AccountEditorScreen> createState() => _AccountEditorScreenState();
}

class _AccountEditorScreenState extends State<AccountEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _opening;
  late final TextEditingController _creditLimit;
  late final TextEditingController _goal;
  AccountType _type = AccountType.bank;
  String _currency = 'EUR';
  bool _default = false;
  int _color = 2;
  int _version = 1;

  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.accountId == null
        ? null
        : repo.accountById(widget.accountId!);
    _name = TextEditingController(text: existing?.name ?? '');
    _opening = TextEditingController(
      text: existing == null
          ? ''
          : (existing.openingBalanceMinor /
                    PockitoCurrencies.of(existing.currency).minorUnitScale)
                .toStringAsFixed(
                  PockitoCurrencies.of(existing.currency).decimals,
                ),
    );
    _creditLimit = TextEditingController(
      text: existing?.creditLimitMinor == null
          ? ''
          : (existing!.creditLimitMinor! /
                    PockitoCurrencies.of(existing.currency).minorUnitScale)
                .toStringAsFixed(
                  PockitoCurrencies.of(existing.currency).decimals,
                ),
    );
    _goal = TextEditingController(
      text: existing?.goalAmountMinor == null
          ? ''
          : (existing!.goalAmountMinor! /
                    PockitoCurrencies.of(existing.currency).minorUnitScale)
                .toStringAsFixed(
                  PockitoCurrencies.of(existing.currency).decimals,
                ),
    );
    _type = existing?.type ?? AccountType.bank;
    _currency = existing?.currency ?? repo.profile.reportingCurrency;
    _default = existing?.isDefault ?? false;
    _color = existing?.colorIndex ?? 2;
    _version = existing?.version ?? 1;
  }

  @override
  void dispose() {
    _name.dispose();
    _opening.dispose();
    _creditLimit.dispose();
    _goal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.accountId != null;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(editing ? context.t.editAccount : context.t.addAccount),
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
                    key: const ValueKey('account_name'),
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    autofocus: !editing,
                    decoration: InputDecoration(
                      labelText: context.t.accountName,
                      hintText: context.t.eGRevolut,
                    ),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.t.giveThisAccountAName
                        : null,
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<AccountType>(
                    key: const ValueKey('account_type'),
                    initialValue: _type,
                    decoration: InputDecoration(
                      labelText: context.t.accountType,
                    ),
                    items: AccountType.values
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type.name[0].toUpperCase() +
                                  type.name.substring(1),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() => _type = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  DropdownButtonFormField<String>(
                    key: const ValueKey('account_currency'),
                    initialValue: _currency,
                    decoration: InputDecoration(labelText: context.t.currency),
                    items: PockitoCurrencies.all.keys
                        .map(
                          (code) =>
                              DropdownMenuItem(value: code, child: Text(code)),
                        )
                        .toList(),
                    onChanged: editing
                        ? null
                        : (value) => setState(() => _currency = value!),
                  ),
                  const SizedBox(height: PkSpacing.x4),
                  TextFormField(
                    key: const ValueKey('account_balance'),
                    controller: _opening,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: editing
                          ? context.t.openingBalance
                          : context.t.currentBalance,
                      prefixText: '${_symbol(_currency)} ',
                    ),
                    validator: (value) => double.tryParse(value ?? '') == null
                        ? context.t.enterAValidAmount
                        : null,
                  ),
                  // A card's useful number is its headroom, and a savings
                  // account's is its progress. Neither exists without these.
                  if (_type == AccountType.card) ...[
                    const SizedBox(height: PkSpacing.x4),
                    TextFormField(
                      key: const ValueKey('account_credit_limit'),
                      controller: _creditLimit,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.t.creditLimitOptional,
                        helperText: context.t.letsPockitoShowWhatIs,
                        prefixText: '${_symbol(_currency)} ',
                      ),
                    ),
                  ],
                  if (_type == AccountType.savings) ...[
                    const SizedBox(height: PkSpacing.x4),
                    TextFormField(
                      key: const ValueKey('account_goal'),
                      controller: _goal,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: context.t.savingsGoalOptional,
                        helperText: context.t.showsProgressOnTheAccount,
                        prefixText: '${_symbol(_currency)} ',
                      ),
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x4),
                  PkCard(
                    child: SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: Text(context.t.defaultAccount),
                      subtitle: Text(
                        context.t.preselectedWhenRecordingAnExpense,
                      ),
                      value: _default,
                      onChanged: (value) => setState(() => _default = value),
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x5),
                  Text(
                    context.t.colour,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  // D-04: the swatch is 40 because that is the right size for
                  // a colour chip, but the region that accepts the tap is the
                  // full 48 — the transparent padding supplies it.
                  Wrap(
                    spacing: PkSpacing.x2,
                    runSpacing: PkSpacing.x2,
                    children: List.generate(PkPalette.category.length, (index) {
                      final selected = _color == index + 1;
                      const swatch = 40.0;
                      const inset = (PkSize.touch - swatch) / 2;
                      return Semantics(
                        button: true,
                        selected: selected,
                        // Colour alone cannot name a colour: the swatch's
                        // position is its only other identity, so the label
                        // says which one it is.
                        label: context.t.colourOptionX0(index + 1),
                        excludeSemantics: true,
                        child: InkResponse(
                          onTap: () => setState(() => _color = index + 1),
                          radius: PkSize.touch / 2,
                          containedInkWell: false,
                          child: Padding(
                            padding: const EdgeInsets.all(inset),
                            child: Container(
                              width: swatch,
                              height: swatch,
                              decoration: BoxDecoration(
                                color: PkPalette.category[index],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: selected
                                      ? context.pk.textPrimary
                                      : Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: selected
                                  ? const Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: PkSize.icon,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: PkSpacing.x8),
                  FilledButton(
                    key: const ValueKey('save_account'),
                    onPressed: _save,
                    child: Text(
                      editing ? context.t.saveChanges : context.t.addAccount,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: Text(context.t.cancel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _symbol(String currency) => PockitoCurrencies.of(currency).symbol;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    final existing = widget.accountId == null
        ? null
        : repo.accountById(widget.accountId!);
    final decimals = PockitoCurrencies.of(_currency).minorUnitScale;
    final account = Account(
      id: existing?.id ?? '',
      name: _name.text.trim(),
      type: _type,
      currency: _currency,
      openingBalanceMinor: (double.parse(_opening.text) * decimals).round(),
      isDefault: _default,
      archived: existing?.archived ?? false,
      colorIndex: _color,
      creditLimitMinor:
          _type == AccountType.card && _creditLimit.text.trim().isNotEmpty
          ? ((double.tryParse(_creditLimit.text.replaceAll(',', '.')) ?? 0) *
                    decimals)
                .round()
          : null,
      goalAmountMinor:
          _type == AccountType.savings && _goal.text.trim().isNotEmpty
          ? ((double.tryParse(_goal.text.replaceAll(',', '.')) ?? 0) * decimals)
                .round()
          : null,
      version: _version,
      icon: switch (_type) {
        AccountType.bank => 'bank',
        AccountType.card => 'card',
        AccountType.cash => 'cash',
        AccountType.savings => 'savings',
        AccountType.digital => 'wallet',
      },
      sortOrder: existing?.sortOrder ?? repo.accounts.length,
    );
    await repo.saveAccount(account);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            existing == null
                ? context.t.x0Added(account.name)
                : context.t.accountUpdated,
          ),
        ),
      );
      context.pop();
    }
  }
}

class ArchivedAccountsScreen extends StatelessWidget {
  const ArchivedAccountsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final accounts = repo.accounts.where((item) => item.archived).toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.archivedAccounts)),
      body: accounts.isEmpty
          ? PkEmptyState(
              icon: Icons.archive_outlined,
              title: context.t.noArchivedAccounts,
              message: context.t.archivedAccountsWillAppearHere,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(PkSpacing.screen),
              itemCount: accounts.length,
              separatorBuilder: (_, _) => const SizedBox(height: PkSpacing.x2),
              itemBuilder: (context, index) {
                final account = accounts[index];
                return PkCard(
                  child: Row(
                    children: [
                      PkIconTile(
                        icon: PkIcons.named(account.icon),
                        color: PkPalette.categoryAt(account.colorIndex),
                      ),
                      const SizedBox(width: PkSpacing.x3),
                      Expanded(
                        child: Text(
                          account.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () => repo.archiveAccount(account.id, false),
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

class ReorderAccountsScreen extends StatefulWidget {
  const ReorderAccountsScreen({super.key});
  @override
  State<ReorderAccountsScreen> createState() => _ReorderAccountsScreenState();
}

class _ReorderAccountsScreenState extends State<ReorderAccountsScreen> {
  late List<Account> _accounts;
  @override
  void initState() {
    super.initState();
    _accounts =
        context
            .read<PockitoAppViewModel>()
            .repository
            .accounts
            .where((item) => !item.archived)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(
      title: Text(context.t.reorderAccounts),
      actions: [
        TextButton(onPressed: _save, child: Text(context.t.actionDone)),
      ],
    ),
    body: ReorderableListView.builder(
      padding: const EdgeInsets.all(PkSpacing.screen),
      itemCount: _accounts.length,
      onReorderItem: (oldIndex, newIndex) => setState(() {
        final item = _accounts.removeAt(oldIndex);
        _accounts.insert(newIndex, item);
      }),
      itemBuilder: (context, index) {
        final account = _accounts[index];
        return Padding(
          key: ValueKey(account.id),
          padding: const EdgeInsets.only(bottom: PkSpacing.x2),
          child: PkCard(
            child: Row(
              children: [
                Icon(Icons.drag_handle_rounded, color: context.pk.textTertiary),
                const SizedBox(width: PkSpacing.x3),
                PkIconTile(
                  icon: PkIcons.named(account.icon),
                  color: PkPalette.categoryAt(account.colorIndex),
                  size: 40,
                ),
                const SizedBox(width: PkSpacing.x3),
                Expanded(
                  child: Text(
                    account.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

  Future<void> _save() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    for (var index = 0; index < _accounts.length; index++) {
      await repo.saveAccount(_accounts[index].copyWith(sortOrder: index));
    }
    if (mounted) context.pop();
  }
}

/// The Accounts summary, section 7.2: a compact 120–144 hero, not a panel that
/// pushes the first account row below the fold.
class _AccountTotals extends StatelessWidget {
  const _AccountTotals({required this.byCurrency});
  final Map<String, int> byCurrency;

  @override
  Widget build(BuildContext context) => PkHeroPanel(
    density: PkHeroDensity.compact,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.t.availableByCurrency,
          style: context.pkText.supporting.copyWith(color: Colors.white),
        ),
        const SizedBox(height: PkSpacing.x2),
        Wrap(
          spacing: PkSpacing.x5,
          runSpacing: PkSpacing.x2,
          children: byCurrency.entries
              .map(
                (entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PkAmountText(
                      amountMinor: entry.value,
                      currency: entry.key,
                      // Section 6.4: supporting totals use `moneySection`.
                      // Only one value on a screen may be `moneyHero`, and on
                      // Accounts that value belongs to no single currency.
                      style: context.pkText.moneySection.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      entry.key,
                      style: context.pkText.micro.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: PkSpacing.x2),
        Text(
          context.t.currenciesStaySeparateUntilReporting,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.pkText.supporting.copyWith(color: Colors.white),
        ),
      ],
    ),
  );
}

class _AccountHero extends StatelessWidget {
  const _AccountHero({
    required this.account,
    required this.balance,
    required this.spent,
    required this.income,
    this.equivalentMinor,
    this.equivalentCurrency,
    this.quote,
  });
  final Account account;
  final int balance;
  final int spent;
  final int income;
  final int? equivalentMinor;
  final String? equivalentCurrency;
  final FxQuote? quote;
  @override
  Widget build(BuildContext context) => PkHeroPanel(
    color: PkPalette.categoryAt(account.colorIndex),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.t.currentBalance,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: PkSpacing.x2),
        PkAmountText(
          amountMinor: balance,
          currency: account.currency,
          style: Theme.of(
            context,
          ).textTheme.displayLarge?.copyWith(color: Colors.white),
        ),
        if (equivalentMinor != null && equivalentCurrency != null) ...[
          const SizedBox(height: PkSpacing.x1),
          Text(
            context.t.x0X1Rate(
              PkFormat.money(equivalentMinor!, equivalentCurrency!),
              quote?.mode == FxRateMode.manual ? 'manual' : 'automatic',
            ),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
          ),
        ],
        const SizedBox(height: PkSpacing.x4),
        Row(
          children: [
            Expanded(
              child: _MiniMetric(
                label: context.t.inThisMonth,
                value: PkFormat.money(income, account.currency),
              ),
            ),
            Expanded(
              child: _MiniMetric(
                label: context.t.outThisMonth,
                value: PkFormat.money(spent, account.currency),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: Colors.white),
      ),
      const SizedBox(height: 2),
      Text(
        value,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: Colors.white),
      ),
    ],
  );
}
