import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../../domain/repositories/pockito_repository.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});
  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final transactions = viewModel.filteredTransactions;
    // Grouping is memoised on the view model and rebuilt only when the filters
    // or the data change, so scrolling no longer regroups the whole ledger on
    // every frame.
    final groups = viewModel.activityGroups;
    final chips = _activeFilterChips(context, viewModel, repo);
    // Activity is reached from More and from Home, so it owns its own
    // Scaffold rather than borrowing the shell's.
    return Scaffold(
      body: PkPage(
        refresh: viewModel.simulateRefresh,
        slivers: [
          PkScreenHeader(
            title: context.t.activityTitle,
            subtitle: context.t.x0MoneyEventX1(
              transactions.length,
              transactions.length == 1 ? '' : 's',
            ),
            // Activity lives under More but is also opened straight from Home
            // and from links, so it always offers a way back.
            onBack: () =>
                context.canPop() ? context.pop() : context.go('/more'),
            actions: [
              IconButton(
                onPressed: () => _showFilters(context),
                tooltip: context.t.activityFilters,
                icon: Badge(
                  label: Text('${viewModel.activityFilterCount}'),
                  isLabelVisible: viewModel.activityFilterCount > 0,
                  child: const Icon(Icons.tune_rounded),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              0,
              PkSpacing.screen,
              PkSpacing.x3,
            ),
            sliver: SliverToBoxAdapter(
              child: PkSearchField(
                value: viewModel.activityQuery,
                hintText: context.t.activitySearchHint,
                resultCount: transactions.length,
                onChanged: viewModel.setActivityQuery,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(
              context.gutter,
              0,
              context.gutter,
              PkSpacing.x2,
            ),
            sliver: SliverToBoxAdapter(
              // Section 6.10: the control strip scrolls rather than wraps or
              // clips. At 2.0x text a sort label and a saved-view count are
              // wider than a 320 px phone, and neither may be cut off.
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    PkSortButton(
                      value: viewModel.activitySort,
                      options: const [
                        PkSort.dateDesc,
                        PkSort.dateAsc,
                        PkSort.amountDesc,
                        PkSort.amountAsc,
                        PkSort.nameAsc,
                        PkSort.nameDesc,
                      ],
                      onChanged: viewModel.setActivitySort,
                    ),
                    if (repo.savedViews.isNotEmpty) ...[
                      const SizedBox(width: PkSpacing.x2),
                      TextButton.icon(
                        key: const ValueKey('saved_views'),
                        onPressed: () => _showSavedViews(context, viewModel),
                        icon: const Icon(
                          Icons.bookmark_outline_rounded,
                          size: PkSize.icon,
                        ),
                        label: Text(
                          context.t.savedViewCount(repo.savedViews.length),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          // A count badge says something is filtered; it does not say what, and
          // it gives no way to undo one decision out of six.
          if (chips.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                0,
                PkSpacing.screen,
                PkSpacing.x2,
              ),
              sliver: SliverToBoxAdapter(
                child: PkActiveFilters(
                  chips: chips,
                  onResetAll: viewModel.clearActivityFilters,
                  onSave: () => _saveView(context, viewModel),
                ),
              ),
            ),
          if (transactions.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.search_off_rounded,
                title: viewModel.activityQuery.isEmpty && chips.isEmpty
                    ? context.t.activityNoneTitle
                    : context.t.activityNoMatchTitle,
                message: viewModel.activityQuery.isEmpty && chips.isEmpty
                    ? context.t.activityNoneBody
                    : context.t.activityNoMatchBody,
                actionLabel: viewModel.activityQuery.isEmpty && chips.isEmpty
                    ? context.t.addMoneyEvent
                    : context.t.clearFilters,
                onAction: viewModel.activityQuery.isEmpty && chips.isEmpty
                    ? () => context.push('/add')
                    : () {
                        viewModel
                          ..setActivityQuery('')
                          ..clearActivityFilters();
                      },
              ),
            )
          else ...[
            for (final entry in groups.entries)
              // A pinned header pins to the *viewport*, not to its own rows, so
              // one `SliverPersistentHeader` per day meant every day already
              // scrolled past stayed stuck to the top: by late in a long
              // ledger the reader had twenty stacked date bars and no
              // transactions visible at all.
              //
              // `SliverMainAxisGroup` scopes the pinning to the group, which is
              // what the behaviour was always meant to be — the header holds
              // while its own rows pass under it, then leaves with them.
              SliverMainAxisGroup(
                slivers: [
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _DayHeaderDelegate(
                      label: PkFormat.shortDate(
                        entry.key,
                        repo.today,
                        context.t,
                      ),
                      total: entry.value.fold<int>(
                        0,
                        (sum, item) =>
                            sum +
                            (item.type == MoneyEventType.income
                                ? item.amountMinor
                                : -item.amountMinor),
                      ),
                      currency: entry.value.first.currency,
                      background: context.pk.page,
                      textStyle:
                          Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: context.pk.textSecondary,
                          ) ??
                          const TextStyle(),
                      // Section 7.7: 28–32, growing with the reader's text size
                      // so its own label always fits inside it.
                      height: 30 * MediaQuery.textScalerOf(context).scale(1),
                    ),
                  ),
                  // Section 7.7: a continuous ledger with inset separators, not
                  // a rounded card around every day. The sticky header already
                  // marks where one day ends and the next begins; a card per
                  // day added a second boundary and cost a row of capacity
                  // each time.
                  SliverPadding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      context.gutter,
                      0,
                      context.gutter,
                      PkSpacing.headerToContent,
                    ),
                    sliver: SliverList.separated(
                      itemCount: entry.value.length,
                      separatorBuilder: (context, _) => Divider(
                        height: 1,
                        thickness: 1,
                        indent:
                            PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                        color: context.pk.borderSubtle,
                      ),
                      itemBuilder: (context, index) => _ActivityRow(
                        transaction: entry.value[index],
                        repository: repo,
                      ),
                    ),
                  ),
                ],
              ),
            if (viewModel.hasMoreActivity)
              SliverPadding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                  PkSpacing.screen,
                  0,
                  PkSpacing.screen,
                  PkSpacing.x6,
                ),
                sliver: SliverToBoxAdapter(
                  child: OutlinedButton.icon(
                    key: const ValueKey('activity_show_more'),
                    onPressed: viewModel.showMoreActivity,
                    icon: const Icon(Icons.expand_more_rounded),
                    label: Text(
                      context.t.showMoreLeft(
                        transactions.length - viewModel.activityLimit,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// One chip per active filter, each removable on its own.
  List<PkFilterChipData> _activeFilterChips(
    BuildContext context,
    PockitoAppViewModel viewModel,
    PockitoRepository repo,
  ) => [
    for (final type in viewModel.activityTypes)
      PkFilterChipData(
        id: 'type_${type.name}',
        label: type.labelIn(context.t),
        onRemove: () => viewModel.removeActivityFilter(type: type),
      ),
    if (viewModel.activityPeriod != ActivityPeriod.all)
      PkFilterChipData(
        id: 'period',
        label: viewModel.activityPeriod.label,
        onRemove: () => viewModel.removeActivityFilter(clearPeriod: true),
      ),
    for (final id in viewModel.activityCategoryIds)
      PkFilterChipData(
        id: 'category_$id',
        label: repo.categoryById(id)?.name ?? 'Category',
        onRemove: () => viewModel.removeActivityFilter(categoryId: id),
      ),
    for (final id in viewModel.activityAccountIds)
      PkFilterChipData(
        id: 'account_$id',
        label: repo.accountById(id)?.name ?? 'Account',
        onRemove: () => viewModel.removeActivityFilter(accountId: id),
      ),
    for (final id in viewModel.activitySpaceIds)
      PkFilterChipData(
        id: 'space_$id',
        label: repo.spaceById(id)?.name ?? 'Space',
        onRemove: () => viewModel.removeActivityFilter(spaceId: id),
      ),
    for (final id in viewModel.activityTagIds)
      PkFilterChipData(
        id: 'tag_$id',
        label: repo.tagById(id)?.name ?? context.t.tag,
        onRemove: () => viewModel.removeActivityFilter(tagId: id),
      ),
    for (final id in viewModel.activityPaymentMethodIds)
      PkFilterChipData(
        id: 'pm_$id',
        label: repo.paymentMethodById(id)?.name ?? context.t.paymentMethod,
        onRemove: () => viewModel.removeActivityFilter(paymentMethodId: id),
      ),
    if (viewModel.activityIncludeVoided)
      PkFilterChipData(
        id: 'voided',
        label: context.t.includingVoided,
        onRemove: () => viewModel.removeActivityFilter(clearVoided: true),
      ),
    if (!viewModel.activityIncludeDrafts)
      PkFilterChipData(
        id: 'drafts',
        label: context.t.draftsHidden,
        onRemove: () => viewModel.removeActivityFilter(clearDrafts: true),
      ),
  ];

  Future<void> _saveView(
    BuildContext context,
    PockitoAppViewModel viewModel,
  ) async {
    final name = await showPkTextPrompt(
      context,
      title: context.t.nameThisView,
      hint: context.t.eGReimbursableWorkTravel,
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    await viewModel.saveCurrentView(name.trim());
    if (context.mounted) {
      showPkSuccessToast(context, context.t.savedX0(name.trim()));
    }
  }

  Future<void> _showSavedViews(
    BuildContext context,
    PockitoAppViewModel viewModel,
  ) => showPkSheet<void>(
    context,
    builder: (context) => PkSheetScaffold(
      title: context.t.savedViews,
      subtitle: context.t.filterCombinationsYouBuiltOnce,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final view in viewModel.repository.savedViews)
            PkLedgerRow.management(
              key: ValueKey('saved_view_${view.id}'),
              leading: const Icon(Icons.bookmark_rounded),
              title: view.name,
              trailing: IconButton(
                tooltip: context.t.deleteX0(view.name),
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: () {
                  viewModel.repository.deleteView(view.id);
                  Navigator.pop(context);
                },
              ),
              onTap: () {
                viewModel.applySavedView(view);
                Navigator.pop(context);
              },
            ),
        ],
      ),
    ),
  );

  Future<void> _showFilters(BuildContext context) async {
    final viewModel = context.read<PockitoAppViewModel>();
    // Section 6.12: Activity's filter is the app's one genuinely multi-section
    // filter, so it takes the standard 80% cap rather than the 88% pseudo-
    // screen it used to be, and gets its header, reset and pinned Apply from
    // `PkSheetScaffold` like every other sheet.
    final result = await showPkSheet<_ActivityFilterSelection>(
      context,
      builder: (context) => _ActivityFilters(
        initialTypes: viewModel.activityTypes,
        initialPeriod: viewModel.activityPeriod,
        initialFrom: viewModel.activityFrom,
        initialTo: viewModel.activityTo,
        initialCategoryIds: viewModel.activityCategoryIds,
        initialAccountIds: viewModel.activityAccountIds,
        initialSpaceIds: viewModel.activitySpaceIds,
        initialTagIds: viewModel.activityTagIds,
        initialPaymentMethodIds: viewModel.activityPaymentMethodIds,
        initialIncludeVoided: viewModel.activityIncludeVoided,
        initialIncludeDrafts: viewModel.activityIncludeDrafts,
      ),
    );
    if (result != null) {
      viewModel.setActivityFilters(
        types: result.types,
        period: result.period,
        from: result.from,
        to: result.to,
        categoryIds: result.categoryIds,
        accountIds: result.accountIds,
        spaceIds: result.spaceIds,
        tagIds: result.tagIds,
        paymentMethodIds: result.paymentMethodIds,
        includeVoided: result.includeVoided,
        includeDrafts: result.includeDrafts,
      );
    }
  }
}

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transactionId});
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final transaction = repo.transactionById(transactionId);
    if (transaction == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.receipt_long_outlined,
          title: context.t.moneyEventNotFound,
          message: context.t.thisItemHasBeenRemoved,
        ),
      );
    }
    final category = transaction.categoryId == null
        ? null
        : repo.categoryById(transaction.categoryId!);
    final account = repo.accountById(
      transaction.fromAccountId ?? transaction.toAccountId ?? '',
    );
    final destinationAccount = repo.accountById(transaction.toAccountId ?? '');
    final split = transaction.splitId == null
        ? null
        : repo.sharedExpenseById(transaction.splitId!);
    final paymentMethod = transaction.paymentMethodId == null
        ? null
        : repo.paymentMethodById(transaction.paymentMethodId!);
    final tags = transaction.tagIds.map(repo.tagById).whereType<Tag>().toList();
    final subscription = transaction.subscriptionId == null
        ? null
        : repo.subscriptionById(transaction.subscriptionId!);
    final settlementSpaceId = transaction.settlementId == null
        ? null
        : repo.settlementById(transaction.settlementId!)?.spaceId;
    final relatedBudgets = repo.budgets
        .where(
          (budget) =>
              transaction.categoryId != null &&
              (budget.categoryId == transaction.categoryId ||
                  budget.categoryIds.contains(transaction.categoryId)),
        )
        .toList();
    final positive = transaction.type == MoneyEventType.income;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.moneyEvent),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'edit') {
                context.push('/add?transaction=${transaction.id}');
              }
              if (value == 'duplicate') {
                context.push('/add?duplicate=${transaction.id}');
              }
              switch (value) {
                case 'void':
                  await _void(context, transaction);
                case 'restore':
                  await PkGuardedAction.run(
                    context,
                    () => repo.restoreTransaction(transaction.id),
                    successMessage: context.t.restored,
                  );
                case 'confirm':
                  await PkGuardedAction.run(
                    context,
                    () => repo.confirmTransaction(transaction.id),
                    successMessage: context.t.confirmedItCountsFromNow,
                  );
              }
            },
            itemBuilder: (_) => [
              if (transaction.isDraft)
                PopupMenuItem(
                  value: 'confirm',
                  child: ListTile(
                    leading: Icon(Icons.check_circle_outline_rounded),
                    title: Text(context.t.actionConfirm),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              if (!transaction.isVoided) ...[
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit_outlined),
                    title: Text(context.t.edit),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.copy_outlined),
                    title: Text(context.t.duplicate),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'void',
                  child: ListTile(
                    leading: Icon(Icons.block_outlined),
                    title: Text(context.t.actionVoid),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ] else
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
          if (transaction.isVoided || transaction.isDraft)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x2,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: PkRecordStatusBanner(
                  status: transaction.status,
                  reason: transaction.voidReason,
                  voidedAt: transaction.voidedAt,
                  onConfirm: transaction.isDraft
                      ? () => PkGuardedAction.run(
                          context,
                          () => repo.confirmTransaction(transaction.id),
                          successMessage: context.t.confirmedItCountsFromNow,
                        )
                      : null,
                  onRestore: transaction.isVoided
                      ? () => PkGuardedAction.run(
                          context,
                          () => repo.restoreTransaction(transaction.id),
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
              child: _TransactionHero(
                transaction: transaction,
                positive: positive,
                category: category,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkCard(
                child: Column(
                  children: [
                    PkDetailRow(
                      label: context.t.type,
                      value:
                          transaction.type.name[0].toUpperCase() +
                          transaction.type.name.substring(1),
                    ),
                    PkDetailRow(
                      label: context.t.date,
                      value: PkFormat.longDate(
                        transaction.occurredOn,
                        context.t,
                      ),
                    ),
                    if (transaction.type == MoneyEventType.transfer) ...[
                      PkDetailRow(
                        label: context.t.from,
                        value: account?.name ?? context.t.notTracked,
                      ),
                      PkDetailRow(
                        label: context.t.to,
                        value: destinationAccount?.name ?? context.t.notTracked,
                      ),
                      PkDetailRow(
                        label: context.t.sent,
                        value: PkFormat.money(
                          transaction.amountMinor,
                          transaction.currency,
                        ),
                      ),
                      PkDetailRow(
                        label: context.t.received,
                        value: PkFormat.money(
                          transaction.destinationAmountMinor ??
                              transaction.amountMinor,
                          transaction.destinationCurrency ??
                              transaction.currency,
                        ),
                      ),
                      if (transaction.exchangeRate != null)
                        PkDetailRow(
                          label: context.t.exchangeRate,
                          value:
                              '1 ${transaction.currency} = ${transaction.exchangeRate!.toStringAsPrecision(7)} ${transaction.destinationCurrency} · ${transaction.fxRateMode?.name ?? 'captured'}',
                        ),
                      if (transaction.rateUpdatedAt != null)
                        PkDetailRow(
                          label: context.t.rateCaptured,
                          value: PkFormat.longDate(
                            transaction.rateUpdatedAt!,
                            context.t,
                          ),
                        ),
                      if (transaction.feeMinor > 0)
                        PkDetailRow(
                          label: context.t.fee,
                          value: PkFormat.money(
                            transaction.feeMinor,
                            transaction.feeCurrency ?? transaction.currency,
                          ),
                        ),
                    ] else
                      PkDetailRow(
                        label: context.t.accountLabel,
                        value: account?.name ?? context.t.notTracked,
                      ),
                    PkDetailRow(
                      label: context.t.categoryLabel,
                      value: category?.name ?? context.t.none,
                    ),
                    if (split != null)
                      PkDetailRow(
                        label: context.t.sharedSpace,
                        value:
                            repo.spaceById(split.spaceId)?.name ??
                            context.t.shared,
                      ),
                    if (transaction.source == 'mcp')
                      PkDetailRow(
                        label: context.t.addedVia,
                        value: transaction.client ?? context.t.aiConnection,
                      ),
                    if (paymentMethod != null)
                      PkDetailRow(
                        label: context.t.paidWith,
                        value: paymentMethod.last4 == null
                            ? paymentMethod.name
                            : '${paymentMethod.name} ····${paymentMethod.last4}',
                      ),
                    if (transaction.sourceCurrency != null) ...[
                      PkDetailRow(
                        label: context.t.originalAmount,
                        value: PkFormat.money(
                          transaction.sourceAmountMinor!,
                          transaction.sourceCurrency!,
                        ),
                      ),
                      // A converted figure without its rate is a number the
                      // user cannot check.
                      if (transaction.exchangeRate != null)
                        PkDetailRow(
                          label: context.t.rateUsed,
                          value:
                              '1 ${transaction.sourceCurrency} = '
                              '${transaction.exchangeRate!.toStringAsPrecision(6)} '
                              '${transaction.currency} · '
                              '${transaction.fxRateMode?.name ?? 'captured'}'
                              '${transaction.rateUpdatedAt == null ? '' : ' · ${PkFormat.shortDate(transaction.rateUpdatedAt!, repo.today, context.t)}'}',
                        ),
                    ],
                    if (transaction.adjustmentReason != null)
                      PkDetailRow(
                        label: context.t.correctionReason,
                        value: transaction.adjustmentReason!,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (transaction.note.isNotEmpty)
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
                      Row(
                        children: [
                          Icon(
                            Icons.sticky_note_2_outlined,
                            size: PkSize.iconSmall,
                            color: context.pk.textTertiary,
                          ),
                          const SizedBox(width: PkSpacing.x2),
                          Text(
                            context.t.note,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: PkSpacing.x2),
                      Text(
                        transaction.note,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (tags.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x4,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: Wrap(
                  spacing: PkSpacing.x2,
                  runSpacing: PkSpacing.x2,
                  children: [
                    for (final tag in tags)
                      Chip(
                        avatar: CircleAvatar(
                          radius: 6,
                          backgroundColor: PkPalette.categoryFillAt(
                            tag.colorIndex,
                          ),
                        ),
                        label: Text(tag.name),
                      ),
                  ],
                ),
              ),
            ),
          if (transaction.attachments.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                PkSpacing.screen,
                PkSpacing.x5,
                PkSpacing.screen,
                0,
              ),
              sliver: SliverToBoxAdapter(
                child: PkAttachmentStrip(
                  attachments: transaction.attachments,
                  title: context.t.receipts,
                ),
              ),
            ),
          // A detail screen that ends in a dead end makes the user go back to
          // the list to reach anything connected to what they are looking at.
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              PkSpacing.x5,
              PkSpacing.screen,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: PkRelatedItems(
                items: [
                  if (split != null)
                    PkRelatedItem(
                      icon: Icons.group_outlined,
                      label: context.t.sharedExpenseLabel,
                      detail:
                          repo.spaceById(split.spaceId)?.name ??
                          context.t.shared,
                      route: '/spaces/${split.spaceId}/expenses/${split.id}',
                    ),
                  if (account != null)
                    PkRelatedItem(
                      icon: PkIcons.named(account.icon),
                      label: account.name,
                      detail: PkFormat.money(
                        repo.accountBalance(account),
                        account.currency,
                      ),
                      route: '/accounts/${account.id}',
                    ),
                  if (subscription != null)
                    PkRelatedItem(
                      icon: Icons.autorenew_rounded,
                      label: subscription.name,
                      detail: 'Recurring',
                      route: '/subscriptions/${subscription.id}',
                    ),
                  if (settlementSpaceId != null)
                    PkRelatedItem(
                      icon: Icons.handshake_outlined,
                      label: context.t.settlement,
                      detail:
                          repo.spaceById(settlementSpaceId)?.name ??
                          context.t.shared,
                      route:
                          '/spaces/$settlementSpaceId/settlements/${transaction.settlementId}',
                    ),
                  for (final budget in relatedBudgets)
                    PkRelatedItem(
                      icon: Icons.donut_large_rounded,
                      label: budget.name,
                      detail: 'Budget',
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

  /// Voids the record rather than removing it.
  ///
  /// A money record that disappears without a trace is disqualifying in a
  /// finance app: the row stays, struck through, out of every balance, and the
  /// action is reversible from the toast for as long as it is on screen.
  Future<void> _void(BuildContext context, MoneyTransaction transaction) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final reason = await showPkReasonSheet(
      context,
      title: context.t.voidThisMoneyEvent,
      message: transaction.splitId == null
          ? context.t.itStaysInYourHistory2
          : context.t.theLinkedSharedExpenseIs,
      hint: context.t.whyOptional,
      confirmLabel: context.t.voidIt,
      destructive: true,
    );
    if (reason == null || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.voidTransaction(
        transaction.id,
        reason: reason.trim().isEmpty ? null : reason.trim(),
      ),
      token: 'void_${transaction.id}',
      undoMessage: context.t.voidedX02(transaction.merchant),
      onUndo: () => repo.restoreTransaction(transaction.id),
    );
    if (context.mounted) context.pop();
  }
}

class AddMoneyEventScreen extends StatefulWidget {
  const AddMoneyEventScreen({
    super.key,
    this.accountId,
    this.spaceId,
    this.transactionId,
    this.duplicateId,
    this.sharedExpenseId,
    this.duplicateSharedExpenseId,
    this.initialType,
    this.openScanner = false,
    this.initialCategoryId,
    this.initialAmount,
    this.initialMerchant,
  });
  final String? accountId;
  final String? spaceId;
  final String? transactionId;
  final String? duplicateId;
  final String? sharedExpenseId;
  final String? duplicateSharedExpenseId;

  /// Pre-selected kind of money event, set by the launcher behind the central
  /// add action so the user lands on the right form immediately.
  final MoneyEventType? initialType;

  /// Opens the receipt scanner as soon as the form is ready.
  final bool openScanner;

  /// Values carried over from Quick Add, so "More options" continues the entry
  /// rather than restarting it.
  final String? initialCategoryId;
  final String? initialAmount;
  final String? initialMerchant;

  @override
  State<AddMoneyEventScreen> createState() => _AddMoneyEventScreenState();
}

/// The value the scope picker uses for "not a Space". A sentinel rather than
/// `null` because the picker's selection is a single value, and `null` there
/// already means "nothing chosen".
const _personalScope = '__personal__';

class _AddMoneyEventScreenState extends State<AddMoneyEventScreen> {
  /// A card reads as its name plus the last four digits, which is the only
  /// thing that tells two cards from the same bank apart.
  String? _paymentMethodLabel(PockitoRepository repo, String? id) {
    if (id == null) return null;
    final method = repo.paymentMethods
        .where((item) => item.id == id)
        .firstOrNull;
    if (method == null) return null;
    return method.last4 == null
        ? method.name
        : '${method.name} ····${method.last4}';
  }

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amount;
  late final TextEditingController _merchant;
  late final TextEditingController _manualRate;
  late final TextEditingController _fee;
  late final TextEditingController _note;
  MoneyEventType _type = MoneyEventType.expense;
  String? _accountId;
  String? _toAccountId;
  String? _categoryId;
  String? _spaceId;
  String? _payerUserId;

  /// Who put money in and how much. Keyed by user; the values always add up to
  /// the total before the form will save.
  Map<String, int> _payers = {};
  DateTime _date = DateTime(2026, 8, 15);
  SplitMethod _splitMethod = SplitMethod.equal;
  Map<String, int> _shares = {};
  List<SplitItem> _items = const [];
  FxRateMode _fxRateMode = FxRateMode.automatic;
  List<String> _tagIds = const [];
  String? _paymentMethodId;
  List<ReceiptAttachment> _attachments = const [];

  /// The version the form was opened against. A save carrying a stale version
  /// is what the conflict sheet is built on.
  int _baseVersion = 1;
  int _sharedBaseVersion = 1;

  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    final sourceId = widget.transactionId ?? widget.duplicateId;
    var source = sourceId == null ? null : repo.transactionById(sourceId);
    final directSharedId =
        widget.sharedExpenseId ?? widget.duplicateSharedExpenseId;
    var split = directSharedId == null
        ? null
        : repo.sharedExpenseById(directSharedId);
    split ??= source?.splitId == null
        ? null
        : repo.sharedExpenseById(source!.splitId!);
    source ??= split == null
        ? null
        : repo.transactions
              .where((transaction) => transaction.splitId == split!.id)
              .firstOrNull;
    _type = source?.type == MoneyEventType.settlement
        ? MoneyEventType.expense
        : source?.type ?? widget.initialType ?? MoneyEventType.expense;
    _accountId =
        widget.accountId ??
        source?.fromAccountId ??
        source?.toAccountId ??
        repo.accounts
            .where((item) => item.isDefault && !item.archived)
            .firstOrNull
            ?.id;
    _toAccountId = source?.toAccountId;
    _categoryId =
        source?.categoryId ??
        split?.categoryId ??
        widget.initialCategoryId ??
        repo.categories.first.id;
    _spaceId = widget.spaceId ?? split?.spaceId;
    _payerUserId = split?.primaryPayerUserId ?? repo.currentUserId;
    _payers = {
      if (split != null)
        for (final payer in split.payers) payer.userId: payer.amountMinor,
    };
    _items = split?.items ?? const [];
    _tagIds = [...?source?.tagIds];
    _paymentMethodId = source?.paymentMethodId;
    _attachments = source != null
        ? source.attachments
        : split?.attachments ?? const [];
    _baseVersion = source?.version ?? 1;
    _sharedBaseVersion = split?.version ?? 1;
    final duplicating =
        widget.duplicateId != null || widget.duplicateSharedExpenseId != null;
    _date = duplicating
        ? repo.today
        : source?.occurredOn ?? split?.occurredOn ?? repo.today;
    final entryAmount = source?.amountMinor ?? split?.totalMinor;
    final entryCurrency = source?.currency ?? split?.currency;
    _amount = TextEditingController(
      text: entryAmount == null || entryCurrency == null
          // Whatever Quick Add already had, so "More options" continues the
          // entry instead of restarting it.
          ? widget.initialAmount ?? ''
          : (entryAmount / (entryCurrency == 'JPY' ? 1 : 100)).toStringAsFixed(
              entryCurrency == 'JPY' ? 0 : 2,
            ),
    );
    _merchant = TextEditingController(
      text: source?.merchant ?? split?.title ?? widget.initialMerchant ?? '',
    );
    _fxRateMode = source?.fxRateMode ?? repo.fxSettings.mode;
    _manualRate = TextEditingController(
      text: source?.exchangeRate?.toStringAsPrecision(7) ?? '',
    );
    _fee = TextEditingController(
      text: source == null || source.feeMinor == 0
          ? '0'
          : (source.feeMinor /
                    PockitoCurrencies.of(source.currency).minorUnitScale)
                .toStringAsFixed(
                  PockitoCurrencies.of(source.currency).decimals,
                ),
    );
    _note = TextEditingController(text: source?.note ?? split?.note ?? '');
    _splitMethod = split?.method ?? SplitMethod.equal;
    if (split != null) {
      _shares = {
        for (final share in split.shares) share.userId: share.amountMinor,
      };
    }
    if (widget.openScanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scanReceipt();
      });
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    _manualRate.dispose();
    _fee.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final categories = repo.categories
        .where(
          (item) =>
              item.type ==
              (_type == MoneyEventType.income
                  ? CategoryType.income
                  : CategoryType.expense),
        )
        .toList();
    final account = repo.accountById(_accountId ?? '');
    final toAccount = repo.accountById(_toAccountId ?? '');
    final space = repo.spaceById(_spaceId ?? '');
    final payerIsMe = _payerUserId == repo.currentUserId;
    final entryCurrency = _type == MoneyEventType.expense && space != null
        ? space.currency
        : account?.currency ?? repo.profile.reportingCurrency;
    final editing =
        widget.transactionId != null || widget.sharedExpenseId != null;
    final crossCurrencyTransfer =
        _type == MoneyEventType.transfer &&
        account != null &&
        toAccount != null &&
        account.currency != toAccount.currency;
    final automaticQuote = crossCurrencyTransfer
        ? repo.fxQuote(
            account.currency,
            toAccount.currency,
            mode: FxRateMode.automatic,
          )
        : null;
    final effectiveRate = crossCurrencyTransfer
        ? (_fxRateMode == FxRateMode.manual
              ? double.tryParse(_manualRate.text)
              : automaticQuote?.rate)
        : 1.0;
    final sourceMinor = account == null
        ? 0
        : ((double.tryParse(_amount.text) ?? 0) *
                  PockitoCurrencies.of(account.currency).minorUnitScale)
              .round();
    final destinationMinor =
        toAccount == null || effectiveRate == null || effectiveRate <= 0
        ? null
        : ((sourceMinor /
                      PockitoCurrencies.of(account!.currency).minorUnitScale) *
                  effectiveRate *
                  PockitoCurrencies.of(toAccount.currency).minorUnitScale)
              .round();
    final crossCurrencyShared =
        _type == MoneyEventType.expense &&
        space != null &&
        payerIsMe &&
        account != null &&
        account.currency != space.currency;
    final sharedAutomaticQuote = crossCurrencyShared
        ? repo.fxQuote(
            space.currency,
            account.currency,
            mode: FxRateMode.automatic,
          )
        : null;
    final sharedEffectiveRate = crossCurrencyShared
        ? (_fxRateMode == FxRateMode.manual
              ? double.tryParse(_manualRate.text)
              : sharedAutomaticQuote?.rate)
        : 1.0;
    final sharedWalletAmount =
        !crossCurrencyShared ||
            sharedEffectiveRate == null ||
            sharedEffectiveRate <= 0
        ? null
        : (((double.tryParse(_amount.text) ?? 0) * sharedEffectiveRate) *
                  PockitoCurrencies.of(account.currency).minorUnitScale)
              .round();
    final sharedEntryMinor =
        ((double.tryParse(_amount.text) ?? 0) *
                PockitoCurrencies.of(entryCurrency).minorUnitScale)
            .round();
    // A viewer, or anyone looking at an archived Space, sees the whole form
    // and can save none of it — so the form says so once, at the top, instead
    // of greying out a dozen controls with no explanation.
    final permissions = space == null ? null : repo.permissionsFor(space.id);
    final blocked = permissions != null && !permissions.canAddExpense;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(
          editing ? context.t.editMoneyEvent : context.t.addMoneyEvent,
        ),
        actions: [
          TextButton(
            onPressed: blocked ? null : _save,
            child: Text(editing ? 'Save' : context.t.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              // Section 7.24: a form column stays 560 wide however wide the
              // window; a stretched field is a phone layout that stopped
              // caring.
              child: PkContentColumn.form(
                child: ListView(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    PkSpacing.screen,
                    PkSpacing.x2,
                    PkSpacing.screen,
                    PkSpacing.x8,
                  ),
                  children: [
                    if (repo.offline) ...[
                      PkReadOnlyRibbon(
                        title: context.t.youReOffline,
                        reason: context.t.youCanFillThisIn,
                        icon: Icons.cloud_off_outlined,
                      ),
                      const SizedBox(height: PkSpacing.x4),
                    ],
                    if (blocked) ...[
                      PkDeniedNotice(
                        title: context.t.youCanTAddExpenses(space!.name),
                        reason: permissions.readOnly
                            ? permissions.role == SpaceRole.viewer
                                  ? context.t.viewersCanSeeEverythingAnd
                                  : context.t.thisSpaceIsArchivedSo
                            : context.t.youDoNotHavePermission,
                        whoCanHelp: repo.whoCanHelp(space.id, 'canAddExpense'),
                      ),
                      const SizedBox(height: PkSpacing.x4),
                    ],
                    SegmentedButton<MoneyEventType>(
                      segments: [
                        ButtonSegment(
                          value: MoneyEventType.expense,
                          label: Text(context.t.expense),
                          icon: Icon(Icons.north_east_rounded),
                        ),
                        ButtonSegment(
                          value: MoneyEventType.income,
                          label: Text(context.t.income),
                          icon: Icon(Icons.south_west_rounded),
                        ),
                        ButtonSegment(
                          value: MoneyEventType.transfer,
                          label: Text(context.t.transfer),
                          icon: Icon(Icons.swap_horiz_rounded),
                        ),
                      ],
                      selected: {_type},
                      onSelectionChanged: (value) => setState(() {
                        _type = value.first;
                        _spaceId = null;
                        _payerUserId = repo.currentUserId;
                        _categoryId = null;
                      }),
                    ),
                    if (_type == MoneyEventType.expense && !editing) ...[
                      const SizedBox(height: PkSpacing.x4),
                      OutlinedButton.icon(
                        onPressed: _scanReceipt,
                        icon: const Icon(Icons.document_scanner_outlined),
                        label: Text(context.t.quickScanReceipt),
                      ),
                    ],
                    const SizedBox(height: PkSpacing.x6),
                    PkAmountField(
                      controller: _amount,
                      currency: entryCurrency,
                      autofocus: !editing,
                      // Common amounts save typing on the field people use most.
                      quickAmounts:
                          PockitoCurrencies.of(entryCurrency).decimals == 0
                          ? const [500, 1000, 3000, 5000]
                          : const [5, 10, 25, 50],
                      validator: (value) =>
                          (double.tryParse(
                                    (value ?? '').replaceAll(',', '.'),
                                  ) ??
                                  0) <=
                              0
                          ? context.t.enterAnAmountGreaterThan
                          : null,
                      onChanged: (_) {
                        if (_shares.isNotEmpty) setState(() => _shares = {});
                      },
                    ),
                    const SizedBox(height: PkSpacing.x4),
                    PkTextField(
                      key: const ValueKey('transaction_merchant'),
                      controller: _merchant,
                      textCapitalization: TextCapitalization.sentences,
                      // Enter moves to the note rather than dismissing the
                      // keyboard halfway through the form.
                      textInputAction: TextInputAction.next,
                      label: _type == MoneyEventType.transfer
                          ? context.t.description
                          : _type == MoneyEventType.income
                          ? context.t.source
                          : context.t.merchant,
                      hint: _type == MoneyEventType.expense
                          ? context.t.whatWasThisFor
                          : null,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? context.t.addAShortDescription
                          : null,
                    ),
                    const SizedBox(height: PkSpacing.x4),
                    // The merchant says what it was. Months later the question
                    // is why, and that has nowhere else to live.
                    PkTextField(
                      key: const ValueKey('transaction_note'),
                      controller: _note,
                      minLines: 1,
                      maxLines: 4,
                      maxLength: 1000,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.newline,
                      label: context.t.noteOptional,
                      hint: context.t.whyThisHappenedOrAnything,
                    ),
                    const SizedBox(height: PkSpacing.x4),
                    if (_type != MoneyEventType.expense || payerIsMe)
                      PkSelectFormField<String>(
                        key: ValueKey('transaction_account_$_accountId'),
                        fieldKey: const ValueKey('transaction_account'),
                        label: _type == MoneyEventType.income
                            ? context.t.toAccount
                            : context.t.fromAccount,
                        initialValue: _accountId,
                        placeholder: context.t.chooseAnAccountX,
                        display: (value) =>
                            pkAccountLabel(context, repo, value),
                        leading: (value) => pkAccountLeading(repo, value),
                        pick: (context) => showPkAccountPicker(
                          context,
                          repo: repo,
                          selectedId: _accountId,
                          allowOutside:
                              _type == MoneyEventType.expense && space != null,
                          outsideLabel: context.t.paidOutsidePockitoNoWallet,
                        ),
                        onChanged: (value) =>
                            setState(() => _accountId = value),
                        validator: (value) =>
                            value == null ? context.t.chooseAnAccountX : null,
                      )
                    else
                      PkCard(
                        color: context.pk.sharedSurface,
                        borderColor: context.pk.sharedBorder,
                        child: PkLedgerRow.management(
                          leading: Icon(Icons.account_balance_wallet_outlined),
                          title: context.t.noAccountMovement,
                          subtitle: context.t.thePayerSAccountIs,
                        ),
                      ),
                    if (_type == MoneyEventType.transfer) ...[
                      const SizedBox(height: PkSpacing.x4),
                      PkSelectFormField<String>(
                        key: ValueKey('transaction_to_account_$_toAccountId'),
                        fieldKey: const ValueKey('transaction_to_account'),
                        label: context.t.toAccount,
                        initialValue: _toAccountId == _accountId
                            ? null
                            : _toAccountId,
                        placeholder: context.t.chooseTheDestination,
                        display: (value) =>
                            pkAccountLabel(context, repo, value),
                        leading: (value) => pkAccountLeading(repo, value),
                        pick: (context) => showPkAccountPicker(
                          context,
                          repo: repo,
                          selectedId: _toAccountId,
                          // The source account cannot also be the destination.
                          where: (item) => item.id != _accountId,
                        ),
                        onChanged: (value) => setState(() {
                          _toAccountId = value;
                          _manualRate.clear();
                        }),
                        validator: (value) => value == null
                            ? context.t.chooseTheDestination
                            : null,
                      ),
                      if (crossCurrencyTransfer) ...[
                        const SizedBox(height: PkSpacing.x4),
                        PkCard(
                          color: context.pk.sharedSurface,
                          borderColor: context.pk.sharedBorder,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.exchangeRate,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: PkSpacing.x3),
                              SegmentedButton<FxRateMode>(
                                key: const ValueKey('transfer_fx_mode'),
                                segments: [
                                  ButtonSegment(
                                    value: FxRateMode.automatic,
                                    label: Text(context.t.automatic),
                                  ),
                                  ButtonSegment(
                                    value: FxRateMode.manual,
                                    label: Text(context.t.manual),
                                  ),
                                ],
                                selected: {_fxRateMode},
                                onSelectionChanged: (value) => setState(() {
                                  _fxRateMode = value.first;
                                  if (_fxRateMode == FxRateMode.manual &&
                                      _manualRate.text.isEmpty &&
                                      automaticQuote != null) {
                                    _manualRate.text = automaticQuote.rate
                                        .toStringAsPrecision(7);
                                  }
                                }),
                              ),
                              const SizedBox(height: PkSpacing.x3),
                              if (_fxRateMode == FxRateMode.manual)
                                PkTextField(
                                  key: const ValueKey('transfer_manual_rate'),
                                  controller: _manualRate,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  onChanged: (_) => setState(() {}),
                                  validator: (value) =>
                                      _fxRateMode == FxRateMode.manual &&
                                          (double.tryParse(value ?? '') ?? 0) <=
                                              0
                                      ? context.t.rateMustBeMoreThan
                                      : null,
                                  label: context.t.l1X0InX1(
                                    account.currency,
                                    toAccount.currency,
                                  ),
                                  helper: context.t.capturedWithThisTransfer,
                                )
                              else if (automaticQuote != null) ...[
                                Text(
                                  '1 ${account.currency} ≈ ${automaticQuote.rate.toStringAsPrecision(6)} ${toAccount.currency}',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  context.t.x0UpdatedX1(
                                    automaticQuote.source.labelIn(context.t),
                                    PkFormat.shortDate(
                                      automaticQuote.updatedAt,
                                      repo.today,
                                      context.t,
                                    ),
                                  ),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ] else
                                Text(
                                  context
                                      .t
                                      .automaticRateUnavailableChooseManual,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: context.pk.danger),
                                ),
                              const SizedBox(height: PkSpacing.x4),
                              PkAmountField(
                                fieldKey: const ValueKey('transfer_fee'),
                                controller: _fee,
                                currency: account.currency,
                                label: context.t.feeOptional,
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: PkSpacing.x4),
                              if (destinationMinor != null)
                                PkCard(
                                  color: context.pk.surface,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.t.destinationReceives,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                      PkAmountText(
                                        amountMinor: destinationMinor,
                                        currency: toAccount.currency,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.headlineMedium,
                                      ),
                                      Text(
                                        context.t.fromX0X1Rate(
                                          PkFormat.money(
                                            sourceMinor,
                                            account.currency,
                                          ),
                                          _fxRateMode.name,
                                        ),
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ] else ...[
                      const SizedBox(height: PkSpacing.x4),
                      PkSelectFormField<String>(
                        key: ValueKey('transaction_category_$_categoryId'),
                        fieldKey: const ValueKey('transaction_category'),
                        label: context.t.categoryLabel,
                        initialValue:
                            categories.any((item) => item.id == _categoryId)
                            ? _categoryId
                            : null,
                        placeholder: context.t.chooseACategory,
                        display: (value) =>
                            repo.categoryById(value ?? '')?.name,
                        leading: (value) {
                          final category = repo.categoryById(value ?? '');
                          if (category == null) return null;
                          return PkIconTile(
                            icon: PkIcons.named(category.icon),
                            accent: PkPalette.categoryAt(category.colorIndex),
                            size: PkSize.avatarCompact,
                            iconSize: PkSize.iconSmall,
                          );
                        },
                        // The sheet keeps the parent/child hierarchy and adds
                        // search, which a flat menu of every category could
                        // never do once a household passed a dozen of them.
                        pick: (context) => showPkCategoryPicker(
                          context,
                          repo: repo,
                          type: _type == MoneyEventType.income
                              ? CategoryType.income
                              : CategoryType.expense,
                          selectedId: _categoryId,
                        ),
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                        validator: (value) =>
                            value == null ? context.t.chooseACategory : null,
                      ),
                    ],
                    const SizedBox(height: PkSpacing.x4),
                    PkDateField(
                      value: _date,
                      today: repo.today,
                      onChanged: (value) => setState(() => _date = value),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2027, 12, 31),
                    ),
                    if (_type != MoneyEventType.transfer) ...[
                      const SizedBox(height: PkSpacing.x4),
                      PkTagInput(
                        available: repo.tags,
                        selectedIds: _tagIds,
                        onChanged: (value) => setState(() => _tagIds = value),
                        onCreate: (name) => repo.saveTag(
                          Tag(id: '', name: name, colorIndex: 3),
                        ),
                      ),
                      const SizedBox(height: PkSpacing.x4),
                      // Category answers "on what". This answers "with which
                      // card", which is the other question people ask of a
                      // ledger and could not ask before.
                      PkSelectFormField<String>(
                        key: ValueKey('transaction_payment_$_paymentMethodId'),
                        fieldKey: const ValueKey('transaction_payment_method'),
                        label: context.t.paidWithOptional,
                        initialValue:
                            repo.paymentMethods.any(
                              (item) => item.id == _paymentMethodId,
                            )
                            ? _paymentMethodId
                            : null,
                        placeholder: context.t.notRecorded,
                        display: (value) => _paymentMethodLabel(repo, value),
                        pick: (context) => showPkOptionPicker<String>(
                          context,
                          title: context.t.paidWithOptional,
                          selected: _paymentMethodId,
                          options: [
                            for (final item in repo.paymentMethods)
                              PkOption(
                                value: item.id,
                                label: _paymentMethodLabel(repo, item.id)!,
                              ),
                          ],
                        ),
                        onChanged: (value) =>
                            setState(() => _paymentMethodId = value),
                      ),
                      const SizedBox(height: PkSpacing.x4),
                      PkAttachmentStrip(
                        attachments: _attachments,
                        title: context.t.receipts,
                        onAdd: _attachReceipt,
                        onRemove: (attachment) => setState(
                          () => _attachments = _attachments
                              .where((item) => item.id != attachment.id)
                              .toList(),
                        ),
                      ),
                    ],
                    if (_type == MoneyEventType.expense) ...[
                      const SizedBox(height: PkSpacing.x4),
                      PkCard(
                        color: _spaceId == null
                            ? null
                            : context.pk.sharedSurface,
                        borderColor: _spaceId == null
                            ? null
                            : context.pk.sharedBorder,
                        child: Column(
                          children: [
                            // C-10 / A-8: scope is one field, not a switch that
                            // reveals a second field. "Personal" is a value in
                            // the same list as the Spaces, so changing your mind
                            // costs the same one tap in either direction — and
                            // the field states the current answer rather than
                            // making the reader infer it from a toggle.
                            PkSelectField(
                              key: const ValueKey('transaction_scope'),
                              label: context.t.scope,
                              value: space == null
                                  ? context.t.personal
                                  : '${space.name} · ${space.currency}',
                              leading: space == null
                                  ? PkIconTile(
                                      icon: Icons.person_rounded,
                                      accent: PkAccent.ink(
                                        context.pk.textSecondary,
                                      ),
                                      size: PkSize.avatarCompact,
                                      iconSize: PkSize.iconSmall,
                                    )
                                  : PkIconTile(
                                      icon: PkIcons.named(space.icon),
                                      accent: PkPalette.categoryAt(
                                        space.colorIndex,
                                      ),
                                      size: PkSize.avatarCompact,
                                      iconSize: PkSize.iconSmall,
                                    ),
                              onTap: () async {
                                final active = repo.spaces
                                    .where(
                                      (item) =>
                                          item.status == SpaceStatus.active,
                                    )
                                    .toList();
                                final chosen = await showPkOptionPicker<String>(
                                  context,
                                  title: context.t.scope,
                                  selected: _spaceId ?? _personalScope,
                                  options: [
                                    PkOption(
                                      value: _personalScope,
                                      label: context.t.personal,
                                      hint: context.t.personalSpendingOnly,
                                      icon: Icons.person_rounded,
                                    ),
                                    for (final item in active)
                                      PkOption(
                                        value: item.id,
                                        label: item.name,
                                        hint: item.currency,
                                        icon: PkIcons.named(item.icon),
                                        accent: PkPalette.categoryAt(
                                          item.colorIndex,
                                        ),
                                      ),
                                  ],
                                );
                                if (chosen == null) return;
                                setState(() {
                                  _spaceId = chosen == _personalScope
                                      ? null
                                      : chosen;
                                  final selected = repo.spaceById(chosen);
                                  // Changing scope can strand the payer: the
                                  // person who paid may not be in the Space
                                  // just chosen.
                                  if (selected?.members.any(
                                        (member) =>
                                            member.userId == _payerUserId,
                                      ) !=
                                      true) {
                                    _payerUserId = repo.currentUserId;
                                  }
                                  // The split always belongs to one scope, so
                                  // it is re-derived rather than carried over.
                                  _shares = {};
                                });
                              },
                            ),
                            // The consequence of the choice, stated once,
                            // rather than a second toggle subtitle.
                            const SizedBox(height: PkSpacing.x2),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                _spaceId == null
                                    ? context.t.personalSpendingOnly
                                    : context.t.updatesTheAccountAndEveryone,
                                style: context.pkText.supporting.copyWith(
                                  color: context.pk.textSecondary,
                                ),
                              ),
                            ),
                            if (_spaceId != null) ...[
                              const SizedBox(height: PkSpacing.x3),
                              Builder(
                                builder: (context) {
                                  String nameOf(String id) =>
                                      id == repo.currentUserId
                                      ? context.t.you
                                      : repo.userById(id)?.name ??
                                            context.t.member;
                                  final current =
                                      space?.members.any(
                                            (member) =>
                                                member.userId == _payerUserId,
                                          ) ==
                                          true
                                      ? _payerUserId!
                                      : repo.currentUserId;
                                  return PkSelectField(
                                    key: const ValueKey('transaction_payer'),
                                    label: context.t.paidBy,
                                    value: nameOf(current),
                                    leading: PkAvatar(
                                      label:
                                          repo.userById(current)?.initials ??
                                          '?',
                                      size: PkSize.avatarCompact,
                                    ),
                                    onTap: () async {
                                      final chosen =
                                          await showPkOptionPicker<String>(
                                            context,
                                            title: context.t.paidBy,
                                            selected: current,
                                            options: [
                                              for (final member
                                                  in space?.members ?? const [])
                                                PkOption(
                                                  value: member.userId,
                                                  label: nameOf(member.userId),
                                                ),
                                            ],
                                          );
                                      if (chosen == null) return;
                                      setState(() {
                                        _payerUserId = chosen;
                                        _shares = {};
                                      });
                                    },
                                  );
                                },
                              ),
                              // "We both put money in" is one of the most common
                              // shapes a real bill takes, and a single payer
                              // field cannot record it at all.
                              const SizedBox(height: PkSpacing.x2),
                              if (space != null && space.members.length > 1)
                                _PayersEditor(
                                  space: space,
                                  currency: entryCurrency,
                                  totalMinor: sharedEntryMinor,
                                  payers: _payers,
                                  singlePayerUserId:
                                      _payerUserId ?? repo.currentUserId,
                                  onChanged: (value) =>
                                      setState(() => _payers = value),
                                ),
                              const SizedBox(height: PkSpacing.x3),
                              PkLedgerRow.management(
                                key: const ValueKey('edit_split'),
                                leading: const Icon(
                                  Icons.pie_chart_outline_rounded,
                                ),
                                title: context.t.split,
                                subtitle: _splitLabel(repo),
                                trailing: const Icon(
                                  Icons.chevron_right_rounded,
                                ),
                                onTap: _editSplit,
                              ),
                              if (crossCurrencyShared) ...[
                                const Divider(),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    context.t.walletConversion,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                const SizedBox(height: PkSpacing.x3),
                                SegmentedButton<FxRateMode>(
                                  key: const ValueKey('shared_fx_mode'),
                                  segments: [
                                    ButtonSegment(
                                      value: FxRateMode.automatic,
                                      label: Text(context.t.automatic),
                                    ),
                                    ButtonSegment(
                                      value: FxRateMode.manual,
                                      label: Text(context.t.manual),
                                    ),
                                  ],
                                  selected: {_fxRateMode},
                                  onSelectionChanged: (value) => setState(() {
                                    _fxRateMode = value.first;
                                    if (_fxRateMode == FxRateMode.manual &&
                                        _manualRate.text.isEmpty &&
                                        sharedAutomaticQuote != null) {
                                      _manualRate.text = sharedAutomaticQuote
                                          .rate
                                          .toStringAsPrecision(7);
                                    }
                                  }),
                                ),
                                const SizedBox(height: PkSpacing.x3),
                                if (_fxRateMode == FxRateMode.manual)
                                  PkTextField(
                                    key: const ValueKey('shared_manual_rate'),
                                    controller: _manualRate,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                          decimal: true,
                                        ),
                                    onChanged: (_) => setState(() {}),
                                    label: context.t.l1X0InX1(
                                      space.currency,
                                      account.currency,
                                    ),
                                  )
                                else if (sharedAutomaticQuote != null)
                                  Text(
                                    '1 ${space.currency} ≈ ${sharedAutomaticQuote.rate.toStringAsPrecision(6)} ${account.currency} · ${sharedAutomaticQuote.source.labelIn(context.t)}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  )
                                else
                                  Text(
                                    context.t.noAutomaticRateEnterA,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: context.pk.danger),
                                  ),
                                const SizedBox(height: PkSpacing.x3),
                                PkCard(
                                  color: context.pk.surface,
                                  child: Row(
                                    children: [
                                      const Icon(Icons.sync_alt_rounded),
                                      const SizedBox(width: PkSpacing.x3),
                                      Expanded(
                                        child: Text(
                                          context.t.x0SpaceAmount(
                                            PkFormat.money(
                                              ((double.tryParse(_amount.text) ??
                                                          0) *
                                                      PockitoCurrencies.of(
                                                        space.currency,
                                                      ).minorUnitScale)
                                                  .round(),
                                              space.currency,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        sharedWalletAmount == null
                                            ? '—'
                                            : '≈ ${PkFormat.money(sharedWalletAmount, account.currency)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: PkSpacing.x8),
                    // A guarded submit: double-tapping cannot produce two
                    // records, and the label names what is missing when it is
                    // off rather than merely greying out.
                    PkSubmitButton(
                      key: const ValueKey('save_transaction'),
                      enabled: !blocked && !repo.offline,
                      disabledReason: repo.offline
                          ? context.t.saveBlockedOffline
                          : context.t.saveBlockedPermission,
                      label: editing
                          ? context.t.saveChanges
                          : switch (_type) {
                              MoneyEventType.income => context.t.addIncome,
                              MoneyEventType.transfer => context.t.addTransfer,
                              _ => context.t.addExpense,
                            },
                      onSubmit: _save,
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
      ),
    );
  }

  Future<void> _scanReceipt() async {
    FocusScope.of(context).unfocus();
    await Future<void>.delayed(PkMotion.fast);
    if (!mounted) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    final currency =
        repo.accountById(_accountId ?? '')?.currency ??
        repo.profile.reportingCurrency;
    final draft = await Navigator.of(context).push<_ReceiptDraft>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _ReceiptScannerScreen(currency: currency),
      ),
    );
    if (draft == null || !mounted) return;
    setState(() {
      // The capture is kept whether or not the read worked.
      _attachments = [..._attachments, draft.attachment];
      if (draft.attachment.ocrStatus != OcrStatus.completed) return;
      _merchant.text = draft.merchant;
      final info = PockitoCurrencies.of(currency);
      _amount.text = (draft.amountMinor / info.minorUnitScale).toStringAsFixed(
        info.decimals,
      );
      _categoryId = 'c_gro';
      _date = draft.date;
      _shares = {};
    });
    showPkSuccessToast(
      context,
      draft.attachment.ocrStatus == OcrStatus.completed
          ? context.t.receiptKeptDetailsFilledIn
          : context.t.receiptKeptWeCouldNot,
    );
  }

  /// Attaches a receipt without asking us to read it.
  Future<void> _attachReceipt() async {
    final label = await showPkTextPrompt(
      context,
      title: context.t.attachAReceipt,
      hint: context.t.whatIsItEG,
      confirmLabel: context.t.attach,
    );
    if (label == null || label.trim().isEmpty || !mounted) return;
    setState(() {
      _attachments = [
        ..._attachments,
        ReceiptAttachment(
          id: 'r_${DateTime.now().microsecondsSinceEpoch}',
          label: label.trim(),
          capturedAt: _date,
          byteSize: 143000,
          previewSeed: label.hashCode.abs() % 97,
        ),
      ];
    });
  }

  String _splitLabel(dynamic repo) {
    final space = repo.spaceById(_spaceId!);
    if (_shares.isEmpty) {
      return space?.defaultSplitMethod == SplitMethod.percentage
          ? context.t.spaceDefault6040
          : context.t.equallyBetweenX0(space?.members.length ?? 0);
    }
    return context.t.x0x1X2People(
      _splitMethod.name[0].toUpperCase(),
      _splitMethod.name.substring(1),
      _shares.length,
    );
  }

  Future<void> _editSplit() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final space = repo.spaceById(_spaceId!);
    if (space == null) return;
    // Shared-expense input is always canonical in the Space currency. The
    // wallet conversion is separate and must never leak into split maths.
    final entryCurrency = space.currency;
    final entryAmount =
        ((double.tryParse(_amount.text) ?? 0) *
                PockitoCurrencies.of(entryCurrency).minorUnitScale)
            .round();
    if (entryAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.enterAnAmountBeforeEditing)),
      );
      return;
    }
    final spaceAmount = entryAmount;
    final result = await Navigator.of(context).push<_SplitResult>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _SplitEditor(
          space: space,
          totalMinor: spaceAmount,
          currency: space.currency,
          initialMethod: _splitMethod,
          initialShares: _shares,
          initialItems: _items,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _splitMethod = result.method;
        _shares = result.shares;
        _items = result.items;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = context.read<PockitoAppViewModel>().repository;
    final account = repo.accountById(_accountId ?? '');
    final space = repo.spaceById(_spaceId ?? '');
    final payerIsMe = _payerUserId == repo.currentUserId;
    final paidOutside = _accountId == '__outside__';
    if (_spaceId == null && account == null) return;
    if (_spaceId != null && payerIsMe && account == null && !paidOutside) {
      return;
    }
    final entryCurrency = space?.currency ?? account!.currency;
    final amount =
        (double.parse(_amount.text) *
                PockitoCurrencies.of(entryCurrency).minorUnitScale)
            .round();
    final existing = widget.transactionId == null
        ? null
        : repo.transactionById(widget.transactionId!);
    if (_spaceId == null) {
      final ledgerAccount = account!;
      final destination = _type == MoneyEventType.transfer
          ? repo.accountById(_toAccountId ?? '')
          : null;
      final crossCurrency =
          destination != null && destination.currency != ledgerAccount.currency;
      final quote = crossCurrency
          ? repo.fxQuote(
              ledgerAccount.currency,
              destination.currency,
              mode: _fxRateMode,
            )
          : null;
      final rate = crossCurrency
          ? (_fxRateMode == FxRateMode.manual
                ? double.tryParse(_manualRate.text)
                : quote?.rate)
          : 1.0;
      if (crossCurrency && (rate == null || rate <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.chooseAValidExchangeRate)),
        );
        return;
      }
      final destinationAmount = destination == null
          ? null
          : destination.currency == ledgerAccount.currency
          ? amount
          : ((amount /
                        PockitoCurrencies.of(
                          ledgerAccount.currency,
                        ).minorUnitScale) *
                    rate! *
                    PockitoCurrencies.of(destination.currency).minorUnitScale)
                .round();
      final fee = _type == MoneyEventType.transfer
          ? ((double.tryParse(_fee.text) ?? 0) *
                    PockitoCurrencies.of(ledgerAccount.currency).minorUnitScale)
                .round()
          : 0;
      final transaction = MoneyTransaction(
        id: existing?.id ?? '',
        type: _type,
        amountMinor: amount,
        currency: ledgerAccount.currency,
        occurredOn: _date,
        merchant: _merchant.text.trim(),
        fromAccountId: _type == MoneyEventType.income ? null : ledgerAccount.id,
        toAccountId: _type == MoneyEventType.income
            ? ledgerAccount.id
            : _type == MoneyEventType.transfer
            ? _toAccountId
            : null,
        destinationAmountMinor: _type == MoneyEventType.transfer
            ? destinationAmount
            : null,
        destinationCurrency: _type == MoneyEventType.transfer
            ? destination?.currency
            : null,
        exchangeRate: crossCurrency ? rate : null,
        fxRateMode: crossCurrency ? _fxRateMode : null,
        rateUpdatedAt: crossCurrency ? quote?.updatedAt ?? repo.today : null,
        feeMinor: fee,
        feeCurrency: fee > 0 ? ledgerAccount.currency : null,
        categoryId: _type == MoneyEventType.transfer ? null : _categoryId,
        note: _note.text.trim(),
        tagIds: _tagIds,
        paymentMethodId: _paymentMethodId,
        attachments: _attachments,
        status: existing?.status ?? RecordStatus.confirmed,
        version: _baseVersion,
      );
      final saved = await PkGuardedAction.run(
        context,
        () => repo.saveTransaction(transaction),
        token: 'save_${existing?.id ?? 'new'}',
        onConflict: (choice) =>
            _resolveConflict(choice, transaction: transaction),
      );
      if (saved == null) return;
    } else {
      final sharedSpace = space!;
      final spaceAmount = amount;
      final crossCurrency =
          payerIsMe &&
          account != null &&
          account.currency != sharedSpace.currency;
      final quote = crossCurrency
          ? repo.fxQuote(
              sharedSpace.currency,
              account.currency,
              mode: _fxRateMode,
            )
          : null;
      final rate = crossCurrency
          ? (_fxRateMode == FxRateMode.manual
                ? double.tryParse(_manualRate.text)
                : quote?.rate)
          : 1.0;
      if (crossCurrency && (rate == null || rate <= 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.enterAnExchangeRateFor)),
        );
        return;
      }
      final walletAmount = crossCurrency
          ? ((spaceAmount /
                        PockitoCurrencies.of(
                          sharedSpace.currency,
                        ).minorUnitScale) *
                    rate! *
                    PockitoCurrencies.of(account.currency).minorUnitScale)
                .round()
          : payerIsMe && account != null
          ? spaceAmount
          : null;
      final shares = _shares.isEmpty
          ? _defaultShares(sharedSpace, spaceAmount)
          : _shares.entries
                .map(
                  (entry) =>
                      SplitShare(userId: entry.key, amountMinor: entry.value),
                )
                .toList();
      final existingSplit = widget.sharedExpenseId != null
          ? repo.sharedExpenseById(widget.sharedExpenseId!)
          : existing?.splitId == null
          ? null
          : repo.sharedExpenseById(existing!.splitId!);
      final expense = SharedExpense(
        id: existingSplit?.id ?? '',
        spaceId: sharedSpace.id,
        title: _merchant.text.trim(),
        totalMinor: spaceAmount,
        currency: sharedSpace.currency,
        occurredOn: _date,
        categoryId: _categoryId!,
        method: _shares.isEmpty ? sharedSpace.defaultSplitMethod : _splitMethod,
        payers: _resolvedPayers(repo, spaceAmount, account),
        shares: shares,
        items: _splitMethod == SplitMethod.itemized ? _items : const [],
        cycleId: existingSplit?.cycleId ?? sharedSpace.currentCycleId,
        paidFromAccountId: payerIsMe ? account?.id : null,
        walletAmountMinor: walletAmount,
        walletCurrency: payerIsMe ? account?.currency : null,
        exchangeRate: crossCurrency ? rate : null,
        fxRateMode: crossCurrency ? _fxRateMode : null,
        rateUpdatedAt: crossCurrency ? quote?.updatedAt ?? repo.today : null,
        note: _note.text.trim(),
        tagIds: _tagIds,
        attachments: _attachments,
        status: existingSplit?.status ?? RecordStatus.confirmed,
        createdByUserId: existingSplit?.createdByUserId ?? repo.currentUserId,
        version: _sharedBaseVersion,
      );
      final saved = await PkGuardedAction.run(
        context,
        () => repo.saveSharedExpense(
          expense,
          accountId: payerIsMe ? account?.id : null,
        ),
        token: 'save_${existingSplit?.id ?? 'new'}',
        onConflict: (choice) => _resolveConflict(choice, expense: expense),
      );
      if (saved == null) return;
    }
    if (mounted) {
      showPkSuccessToast(
        context,
        existing == null
            ? context.t.moneyEventAdded
            : context.t.moneyEventUpdated,
      );
      context.pop();
    }
  }

  /// The payer lines this form produces.
  ///
  /// A single-payer expense is the common case and stays implicit: the form
  /// only asks who paid what once the user opts into more than one payer.
  List<ExpensePayer> _resolvedPayers(
    PockitoRepository repo,
    int total,
    Account? account,
  ) {
    if (_payers.length > 1) {
      return [
        for (final entry in _payers.entries)
          ExpensePayer(
            userId: entry.key,
            amountMinor: entry.value,
            accountId: entry.key == repo.currentUserId ? account?.id : null,
          ),
      ];
    }
    final payer = _payerUserId ?? repo.currentUserId;
    return [
      ExpensePayer(
        userId: payer,
        amountMinor: total,
        accountId: payer == repo.currentUserId ? account?.id : null,
      ),
    ];
  }

  /// What happens after the conflict sheet.
  ///
  /// "Keep theirs" reloads the form from the record as it now stands; "keep
  /// mine" retries the same write against the current version; "compare"
  /// leaves the form as it is so the two can be read side by side.
  Future<void> _resolveConflict(
    PkConflictChoice choice, {
    MoneyTransaction? transaction,
    SharedExpense? expense,
  }) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    switch (choice) {
      case PkConflictChoice.theirs:
        if (!mounted) return;
        setState(() {
          _baseVersion =
              repo.transactionById(transaction?.id ?? '')?.version ?? 1;
          _sharedBaseVersion =
              repo.sharedExpenseById(expense?.id ?? '')?.version ?? 1;
        });
        if (mounted) context.pop();
      case PkConflictChoice.mine:
        if (transaction != null) {
          final current = repo.transactionById(transaction.id);
          if (current == null) return;
          await PkGuardedAction.run(
            context,
            () => repo.saveTransaction(
              transaction.copyWith(version: current.version),
            ),
            successMessage: context.t.yourVersionWasKept,
          );
        }
        if (expense != null) {
          final current = repo.sharedExpenseById(expense.id);
          if (current == null || !mounted) return;
          await PkGuardedAction.run(
            context,
            () => repo.saveSharedExpense(
              expense.copyWith(version: current.version),
            ),
            successMessage: context.t.yourVersionWasKept,
          );
        }
        if (mounted) context.pop();
      case PkConflictChoice.merge:
        if (!mounted) return;
        setState(() {
          _baseVersion =
              repo.transactionById(transaction?.id ?? '')?.version ?? 1;
          _sharedBaseVersion =
              repo.sharedExpenseById(expense?.id ?? '')?.version ?? 1;
        });
        if (mounted) {
          showPkErrorToast(context, context.t.loadedTheirVersionSNumbers);
        }
    }
  }

  List<SplitShare> _defaultShares(SharedSpace space, int total) {
    if (space.defaultSplitMethod == SplitMethod.percentage &&
        space.defaultPercentages.isNotEmpty) {
      var used = 0;
      return space.members.indexed.map((entry) {
        final last = entry.$1 == space.members.length - 1;
        final amount = last
            ? total - used
            : (total * (space.defaultPercentages[entry.$2.userId] ?? 0) / 100)
                  .round();
        used += amount;
        return SplitShare(userId: entry.$2.userId, amountMinor: amount);
      }).toList();
    }
    if (space.defaultSplitMethod == SplitMethod.shares &&
        space.defaultAllocations.isNotEmpty) {
      final totalShares = space.members.fold<int>(
        0,
        (sum, member) => sum + (space.defaultAllocations[member.userId] ?? 0),
      );
      if (totalShares > 0) {
        var used = 0;
        return space.members.indexed.map((entry) {
          final last = entry.$1 == space.members.length - 1;
          final amount = last
              ? total - used
              : (total *
                        (space.defaultAllocations[entry.$2.userId] ?? 0) /
                        totalShares)
                    .round();
          used += amount;
          return SplitShare(userId: entry.$2.userId, amountMinor: amount);
        }).toList();
      }
    }
    final each = total ~/ space.members.length;
    final remainder = total - each * space.members.length;
    return space.members
        .map(
          (member) => SplitShare(
            userId: member.userId,
            amountMinor:
                each +
                (member.userId ==
                        context
                            .read<PockitoAppViewModel>()
                            .repository
                            .currentUserId
                    ? remainder
                    : 0),
          ),
        )
        .toList();
  }
}

class _ReceiptDraft {
  const _ReceiptDraft({
    required this.merchant,
    required this.amountMinor,
    required this.currency,
    required this.date,
    required this.attachment,
  });

  final String merchant;
  final int amountMinor;
  final String currency;
  final DateTime date;

  /// The capture itself. Scanning without keeping the image answers the
  /// question the user asked once and never again — "show me the receipt" is
  /// the main reason to scan at all.
  final ReceiptAttachment attachment;
}

class _ReceiptScannerScreen extends StatefulWidget {
  const _ReceiptScannerScreen({required this.currency});

  final String currency;

  @override
  State<_ReceiptScannerScreen> createState() => _ReceiptScannerScreenState();
}

class _ReceiptScannerScreenState extends State<_ReceiptScannerScreen> {
  int _step = 0;
  int _outcome = 0;

  _ReceiptDraft get _draft {
    final merchant = widget.currency == 'JPY'
        ? 'Maruetsu Petit'
        : 'Markthalle Neun';
    final amount = widget.currency == 'JPY' ? 2480 : 2385;
    final date = DateTime(2026, 8, 15);
    return _ReceiptDraft(
      merchant: merchant,
      amountMinor: amount,
      currency: widget.currency,
      date: date,
      attachment: ReceiptAttachment(
        id: 'r_${DateTime.now().microsecondsSinceEpoch}',
        label: context.t.receiptX0(merchant),
        capturedAt: date,
        // A low-confidence read is still a completed read; the user is the
        // one who decides whether to trust it.
        ocrStatus: OcrStatus.completed,
        byteSize: 162000 + _outcome * 4096,
        previewSeed: merchant.hashCode.abs() % 97,
        extractedTotalMinor: amount,
        extractedMerchant: merchant,
        extractedDate: date,
      ),
    );
  }

  @override
  // Section 7.11: the capture area gets most of the viewport, and section 6.12
  // sends anything that needs more than 80% of the screen to a route rather
  // than an 86% pseudo-screen with a drag handle it cannot honour.
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.pk.page,
    appBar: PkAppBar(
      automaticallyImplyLeading: false,
      title: Text(_step == 2 ? context.t.reviewReceipt : context.t.scanReceipt),
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          tooltip: context.t.closeScanner,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          context.gutter,
          PkSpacing.x3,
          context.gutter,
          PkSpacing.section,
        ),
        child: _content(context),
      ),
    ),
  );

  Widget _content(BuildContext context) => switch (_step) {
    0 => Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: PkPalette.slate900,
              borderRadius: BorderRadius.circular(PkRadius.extraLarge),
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.white24,
                    size: 88,
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(painter: const _ScannerFramePainter()),
                ),
                Positioned(
                  left: PkSpacing.x4,
                  right: PkSpacing.x4,
                  bottom: PkSpacing.x4,
                  child: Text(
                    context.t.fitTheWholeReceiptInside,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: PkSpacing.x4),
        FilledButton.icon(
          key: const ValueKey('scan_capture'),
          onPressed: _capture,
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(context.t.captureReceipt),
        ),
        const SizedBox(height: PkSpacing.x2),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: PkSpacing.x2,
          children: [
            TextButton(
              key: const ValueKey('scan_low_confidence'),
              onPressed: () => setState(() => _outcome = 1),
              child: Text(
                _outcome == 1
                    ? context.t.lowConfidenceMode
                    : context.t.previewLowConfidence,
              ),
            ),
            TextButton(
              key: const ValueKey('scan_failed_mode'),
              onPressed: () => setState(() => _outcome = 2),
              child: Text(
                _outcome == 2
                    ? context.t.failureMode
                    : context.t.previewFailedScan,
              ),
            ),
          ],
        ),
      ],
    ),
    1 => Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const KitoThinking(),
          SizedBox(height: PkSpacing.x3),
          SizedBox.square(
            dimension: 32,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
          SizedBox(height: PkSpacing.x4),
          Text(context.t.readingMerchantTotalAndDate),
        ],
      ),
    ),
    2 => ListView(
      padding: EdgeInsets.zero,
      children: [
        if (_outcome == 1) ...[
          KitoMessage(
            title: context.t.oneQuickCheck,
            message: context.t.merchantAndCategoryHaveLow,
            asset: KitoAsset.surprised,
            tone: KitoMessageTone.warning,
            compact: true,
          ),
          const SizedBox(height: PkSpacing.x3),
        ],
        PkCard(
          child: Column(
            children: [
              const KitoImage(
                asset: KitoAsset.receipt,
                width: 132,
                height: 132,
              ),
              const SizedBox(height: PkSpacing.x4),
              Text(
                _draft.merchant,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x2),
              PkAmountText(
                amountMinor: _draft.amountMinor,
                currency: _draft.currency,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: PkSpacing.x3),
              Text(
                context.t.augustGroceries,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: PkSpacing.x3),
        PkCard(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: .24),
          child: Text(context.t.thisIsALocalOcr),
        ),
        const SizedBox(height: PkSpacing.x6),
        FilledButton(
          key: const ValueKey('scan_use_details'),
          onPressed: () => Navigator.pop(context, _draft),
          child: Text(context.t.useTheseDetails),
        ),
        const SizedBox(height: PkSpacing.x2),
        TextButton(
          onPressed: () => setState(() => _step = 0),
          child: Text(context.t.retake),
        ),
      ],
    ),
    _ => ListView(
      padding: const EdgeInsets.symmetric(vertical: PkSpacing.x2),
      children: [
        const KitoImage.sized(asset: KitoAsset.confused, size: KitoSize.state),
        const SizedBox(height: PkSpacing.x4),
        Text(
          context.t.weCouldNotReadThis,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: PkSpacing.x2),
        Text(
          context.t.theImageMayBeBlurred,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: PkSpacing.x5),
        FilledButton.icon(
          key: const ValueKey('scan_retry'),
          onPressed: () => setState(() {
            _step = 0;
            _outcome = 0;
          }),
          icon: const Icon(Icons.refresh_rounded),
          label: Text(context.t.retryScan),
        ),
        const SizedBox(height: PkSpacing.x2),
        TextButton(
          key: const ValueKey('scan_manual_entry'),
          onPressed: () => Navigator.pop(
            context,
            _ReceiptDraft(
              merchant: '',
              amountMinor: 0,
              currency: widget.currency,
              date: DateTime(2026, 8, 15),
              // The read failed; the capture is still worth keeping, so the
              // charge can be checked against it later.
              attachment: ReceiptAttachment(
                id: 'r_${DateTime.now().microsecondsSinceEpoch}',
                label: context.t.unreadableReceipt,
                capturedAt: DateTime(2026, 8, 15),
                ocrStatus: OcrStatus.failed,
                byteSize: 98000,
                previewSeed: 31,
                failureReason: context.t.theImageWasTooBlurred,
              ),
            ),
          ),
          child: Text(context.t.enterDetailsManually),
        ),
      ],
    ),
  };

  Future<void> _capture() async {
    setState(() => _step = 1);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (mounted) setState(() => _step = _outcome == 2 ? 3 : 2);
  }
}

class _ScannerFramePainter extends CustomPainter {
  const _ScannerFramePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final frame = Rect.fromLTWH(34, 42, size.width - 68, size.height - 116);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    const length = 30.0;
    for (final path in [
      Path()
        ..moveTo(frame.left, frame.top + length)
        ..lineTo(frame.left, frame.top)
        ..lineTo(frame.left + length, frame.top),
      Path()
        ..moveTo(frame.right - length, frame.top)
        ..lineTo(frame.right, frame.top)
        ..lineTo(frame.right, frame.top + length),
      Path()
        ..moveTo(frame.right, frame.bottom - length)
        ..lineTo(frame.right, frame.bottom)
        ..lineTo(frame.right - length, frame.bottom),
      Path()
        ..moveTo(frame.left + length, frame.bottom)
        ..lineTo(frame.left, frame.bottom)
        ..lineTo(frame.left, frame.bottom - length),
    ]) {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityFilterSelection {
  const _ActivityFilterSelection({
    required this.types,
    required this.period,
    required this.categoryIds,
    required this.accountIds,
    required this.spaceIds,
    required this.tagIds,
    required this.paymentMethodIds,
    required this.includeVoided,
    required this.includeDrafts,
    this.from,
    this.to,
  });
  final Set<MoneyEventType> types;
  final ActivityPeriod period;
  final DateTime? from;
  final DateTime? to;
  final Set<String> categoryIds;
  final Set<String> accountIds;
  final Set<String> spaceIds;
  final Set<String> tagIds;
  final Set<String> paymentMethodIds;
  final bool includeVoided;
  final bool includeDrafts;
}

class _ActivityFilters extends StatefulWidget {
  const _ActivityFilters({
    required this.initialTypes,
    required this.initialPeriod,
    required this.initialFrom,
    required this.initialTo,
    required this.initialCategoryIds,
    required this.initialAccountIds,
    required this.initialSpaceIds,
    required this.initialTagIds,
    required this.initialPaymentMethodIds,
    required this.initialIncludeVoided,
    required this.initialIncludeDrafts,
  });
  final Set<MoneyEventType> initialTypes;
  final ActivityPeriod initialPeriod;
  final DateTime? initialFrom;
  final DateTime? initialTo;
  final Set<String> initialCategoryIds;
  final Set<String> initialAccountIds;
  final Set<String> initialSpaceIds;
  final Set<String> initialTagIds;
  final Set<String> initialPaymentMethodIds;
  final bool initialIncludeVoided;
  final bool initialIncludeDrafts;
  @override
  State<_ActivityFilters> createState() => _ActivityFiltersState();
}

class _ActivityFiltersState extends State<_ActivityFilters> {
  late final Set<MoneyEventType> _types = {...widget.initialTypes};
  late ActivityPeriod _period = widget.initialPeriod;
  late DateTime? _from = widget.initialFrom;
  late DateTime? _to = widget.initialTo;
  late final Set<String> _categories = {...widget.initialCategoryIds};
  late final Set<String> _accounts = {...widget.initialAccountIds};
  late final Set<String> _spaces = {...widget.initialSpaceIds};
  late final Set<String> _tags = {...widget.initialTagIds};
  late final Set<String> _paymentMethods = {...widget.initialPaymentMethodIds};
  late bool _includeVoided = widget.initialIncludeVoided;
  late bool _includeDrafts = widget.initialIncludeDrafts;

  int get _count =>
      _types.length +
      _categories.length +
      _accounts.length +
      _spaces.length +
      _tags.length +
      _paymentMethods.length +
      (_period == ActivityPeriod.all ? 0 : 1) +
      (_includeVoided ? 1 : 0) +
      (_includeDrafts ? 0 : 1);

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    return PkSheetScaffold(
      title: context.t.filterActivity,
      scrollable: false,
      resetLabel: context.t.clear,
      onReset: () => setState(() {
        _types.clear();
        _categories.clear();
        _accounts.clear();
        _spaces.clear();
        _tags.clear();
        _paymentMethods.clear();
        _period = ActivityPeriod.all;
        _from = null;
        _to = null;
        _includeVoided = false;
        _includeDrafts = true;
      }),
      footer: FilledButton(
        key: const ValueKey('apply_activity_filters'),
        onPressed: () => Navigator.pop(
          context,
          _ActivityFilterSelection(
            types: _types,
            period: _period,
            from: _from,
            to: _to,
            categoryIds: _categories,
            accountIds: _accounts,
            spaceIds: _spaces,
            tagIds: _tags,
            paymentMethodIds: _paymentMethods,
            includeVoided: _includeVoided,
            includeDrafts: _includeDrafts,
          ),
        ),
        child: Text(
          _count == 0
              ? context.t.showEverything
              : context.t.applyX0Filters(_count),
        ),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Text(context.t.date, style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: PkSpacing.x2,
            children: ActivityPeriod.values
                .map(
                  (period) => ChoiceChip(
                    key: ValueKey('activity_period_${period.name}'),
                    label: Text(switch (period) {
                      ActivityPeriod.all => context.t.allTime,
                      ActivityPeriod.thisMonth => 'This month',
                      ActivityPeriod.previousMonth => context.t.previousMonth,
                      ActivityPeriod.custom => 'Custom range',
                    }),
                    selected: _period == period,
                    onSelected: (_) async {
                      if (period != ActivityPeriod.custom) {
                        setState(() => _period = period);
                        return;
                      }
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: repo.today,
                        initialDateRange: _from != null && _to != null
                            ? DateTimeRange(start: _from!, end: _to!)
                            : DateTimeRange(
                                start: repo.today.subtract(
                                  const Duration(days: 30),
                                ),
                                end: repo.today,
                              ),
                      );
                      if (range != null) {
                        setState(() {
                          _period = period;
                          _from = range.start;
                          _to = range.end;
                        });
                      }
                    },
                  ),
                )
                .toList(),
          ),
          if (_period == ActivityPeriod.custom && _from != null && _to != null)
            Text(
              '${PkFormat.longDate(_from!, context.t)} → ${PkFormat.longDate(_to!, context.t)}',
            ),
          const SizedBox(height: PkSpacing.x4),
          Text(context.t.type, style: Theme.of(context).textTheme.titleMedium),
          Wrap(
            spacing: PkSpacing.x2,
            children: MoneyEventType.values
                .map(
                  (type) => FilterChip(
                    key: ValueKey('activity_type_${type.name}'),
                    label: Text(
                      type.name[0].toUpperCase() + type.name.substring(1),
                    ),
                    selected: _types.contains(type),
                    onSelected: (value) => setState(
                      () => value ? _types.add(type) : _types.remove(type),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: PkSpacing.x4),
          Text(
            context.t.categoryLabel,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          // A flat unsearchable chip list stops working somewhere
          // around a dozen categories, and the hierarchy is invisible
          // in it — so children are named under their parent.
          _FilterChipGroup(
            searchHint: context.t.searchCategories,
            options: [
              for (final parent in repo.categoryChildren(null)) ...[
                (parent.id, parent.name),
                for (final child in repo.categoryChildren(parent.id))
                  (child.id, '${parent.name} › ${child.name}'),
              ],
            ],
            selected: _categories,
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: PkSpacing.x4),
          Text(
            context.t.wallet,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          _FilterChipGroup(
            searchHint: context.t.searchAccounts,
            options: [
              for (final item in repo.accounts.where((item) => !item.archived))
                (item.id, item.name),
            ],
            selected: _accounts,
            onChanged: (value) => setState(() {}),
          ),
          if (repo.spaces.isNotEmpty) ...[
            const SizedBox(height: PkSpacing.x4),
            Text(
              context.t.spaceLabel,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _FilterChipGroup(
              searchHint: context.t.searchSpaces,
              options: [
                // Two Spaces can share a name, so the type comes with
                // it here as well.
                for (final item in repo.spaces)
                  (item.id, '${item.name} · ${item.type.label}'),
              ],
              selected: _spaces,
              onChanged: (value) => setState(() {}),
            ),
          ],
          if (repo.tags.isNotEmpty) ...[
            const SizedBox(height: PkSpacing.x4),
            Text(context.t.tag, style: Theme.of(context).textTheme.titleMedium),
            _FilterChipGroup(
              searchHint: context.t.searchTags,
              options: [for (final tag in repo.tags) (tag.id, tag.name)],
              selected: _tags,
              onChanged: (value) => setState(() {}),
            ),
          ],
          if (repo.paymentMethods.isNotEmpty) ...[
            const SizedBox(height: PkSpacing.x4),
            Text(
              context.t.paidWith,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _FilterChipGroup(
              searchHint: context.t.searchPaymentMethods,
              options: [
                for (final method in repo.paymentMethods)
                  (
                    method.id,
                    method.last4 == null
                        ? method.name
                        : '${method.name} ····${method.last4}',
                  ),
              ],
              selected: _paymentMethods,
              onChanged: (value) => setState(() {}),
            ),
          ],
          const SizedBox(height: PkSpacing.x4),
          Text(
            context.t.lifecycle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          // Voided rows are the audit trail. They are out of the way by
          // default and one tap from being visible.
          SwitchListTile.adaptive(
            key: const ValueKey('activity_include_voided'),
            contentPadding: EdgeInsets.zero,
            title: Text(context.t.showVoided),
            subtitle: Text(context.t.recordsThatWereUndoneKept),
            value: _includeVoided,
            onChanged: (value) => setState(() => _includeVoided = value),
          ),
          SwitchListTile.adaptive(
            key: const ValueKey('activity_include_drafts'),
            contentPadding: EdgeInsets.zero,
            title: Text(context.t.showDrafts),
            subtitle: Text(context.t.stagedRecordsThatDoNot),
            value: _includeDrafts,
            onChanged: (value) => setState(() => _includeDrafts = value),
          ),
        ],
      ),
    );
  }
}

class _TransactionHero extends StatelessWidget {
  const _TransactionHero({
    required this.transaction,
    required this.positive,
    required this.category,
  });
  final MoneyTransaction transaction;
  final bool positive;
  final Category? category;
  @override
  Widget build(BuildContext context) {
    final accent = positive
        ? PkAccent.ink(context.pk.owed)
        : PkPalette.categoryAt(category?.colorIndex ?? 2);
    return Column(
      children: [
        PkIconTile(
          icon: positive ? Icons.south_west_rounded : Icons.north_east_rounded,
          accent: accent,
          size: 64,
          iconSize: 30,
        ),
        const SizedBox(height: PkSpacing.x4),
        Text(
          transaction.merchant,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: PkSpacing.x2),
        PkAmountText(
          amountMinor: positive
              ? transaction.amountMinor
              : -transaction.amountMinor,
          currency: transaction.currency,
          signed: positive,
          color: positive ? context.pk.owed : null,
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ],
    );
  }
}

class _SplitResult {
  const _SplitResult(this.method, this.shares, {this.items = const []});
  final SplitMethod method;
  final Map<String, int> shares;

  /// Present only for an itemized split, where the lines are the reason the
  /// shares came out the way they did.
  final List<SplitItem> items;
}

class _SplitEditor extends StatefulWidget {
  const _SplitEditor({
    required this.space,
    required this.totalMinor,
    required this.currency,
    required this.initialMethod,
    required this.initialShares,
    this.initialItems = const [],
  });
  final SharedSpace space;
  final int totalMinor;
  final String currency;
  final SplitMethod initialMethod;
  final Map<String, int> initialShares;
  final List<SplitItem> initialItems;

  @override
  State<_SplitEditor> createState() => _SplitEditorState();
}

class _SplitEditorState extends State<_SplitEditor> {
  late SplitMethod _method = widget.initialMethod;
  late List<SplitItem> _items = [...widget.initialItems];
  late final Map<String, TextEditingController> _values = {
    for (final member in widget.space.members)
      member.userId: TextEditingController(),
  };

  /// The split is shown before it is committed, so nobody discovers what they
  /// agreed to only after the expense is saved.
  bool _previewing = false;
  var _itemSequence = 0;

  @override
  void initState() {
    super.initState();
    _setDefaults();
  }

  @override
  void dispose() {
    for (final controller in _values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _setDefaults() {
    final repo = context.read<PockitoAppViewModel>().repository;
    for (final member in widget.space.members) {
      final existing = widget.initialShares[member.userId];
      if (_method == SplitMethod.percentage) {
        _values[member.userId]!.text = existing == null
            ? (100 / widget.space.members.length).toStringAsFixed(1)
            : (existing / widget.totalMinor * 100).toStringAsFixed(1);
      } else if (_method == SplitMethod.shares) {
        _values[member.userId]!.text =
            (widget.space.defaultAllocations[member.userId] ?? 1).toString();
      } else if (_method == SplitMethod.exact) {
        final info = PockitoCurrencies.of(widget.currency);
        _values[member.userId]!.text = existing == null
            ? (widget.totalMinor /
                      widget.space.members.length /
                      info.minorUnitScale)
                  .toStringAsFixed(info.decimals)
            : (existing / info.minorUnitScale).toStringAsFixed(info.decimals);
      } else {
        _values[member.userId]!.text = PkFormat.money(
          (widget.totalMinor / widget.space.members.length).round(),
          widget.currency,
        );
      }
      assert(repo.userById(member.userId) != null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final shares = _computedShares();
    final sum = shares.values.fold(0, (a, b) => a + b);
    final valid = sum == widget.totalMinor && _configurationValid();
    // Section 4.6: split configuration is one of the flows the audit names as
    // a full-screen route rather than a sheet — it is a multi-control editor
    // with live validation that has to stay usable with the keyboard open.
    return Scaffold(
      backgroundColor: context.pk.page,
      appBar: PkAppBar(
        automaticallyImplyLeading: false,
        title: Text(context.t.splitExpense),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          context.gutter,
          0,
          context.gutter,
          PkSpacing.heroToContent,
        ),
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                context.t.x0InX1(
                  PkFormat.money(widget.totalMinor, widget.currency),
                  widget.space.name,
                ),
                style: context.pkText.supporting,
              ),
            ),
            const SizedBox(height: PkSpacing.x3),
            Wrap(
              spacing: PkSpacing.x2,
              runSpacing: PkSpacing.x2,
              children: SplitMethod.values
                  .map(
                    (method) => ChoiceChip(
                      key: ValueKey('split_${method.name}'),
                      label: Text(switch (method) {
                        SplitMethod.equal => context.t.equal,
                        SplitMethod.percentage => context.t.percentage,
                        SplitMethod.shares => context.t.shares,
                        SplitMethod.exact => context.t.exactAmounts,
                        SplitMethod.itemized => context.t.itemized,
                      }),
                      selected: _method == method,
                      onSelected: (_) => setState(() {
                        _method = method;
                        _setDefaults();
                      }),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: PkSpacing.x4),
            if (_method == SplitMethod.itemized)
              Expanded(child: _buildItems(repo, shares))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: widget.space.members.length,
                  separatorBuilder: (_, _) =>
                      Divider(color: context.pk.borderSubtle),
                  itemBuilder: (context, index) {
                    final member = widget.space.members[index];
                    final user = repo.userById(member.userId)!;
                    return Row(
                      children: [
                        PkAvatar(
                          label: user.initials,
                          color: PkPalette.categoryFillAt(index + 2),
                        ),
                        const SizedBox(width: PkSpacing.x3),
                        Expanded(
                          child: Text(
                            user.isYou
                                ? context.t.x0You2(user.name)
                                : user.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(
                          width: 120,
                          child: _method == SplitMethod.equal
                              ? Text(
                                  PkFormat.money(
                                    shares[member.userId] ?? 0,
                                    widget.currency,
                                  ),
                                  textAlign: TextAlign.right,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                )
                              // pk-exempt: an inline cell in a per-member
                              // split row, end-aligned against its neighbours.
                              // `PkTextField` carries a floating label and a
                              // 48 px box; neither fits a table cell.
                              : TextField(
                                  controller: _values[member.userId],
                                  textAlign: TextAlign.right,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    suffixText:
                                        _method == SplitMethod.percentage
                                        ? '%'
                                        : _method == SplitMethod.shares
                                        ? 'shares'
                                        : null,
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            PkCard(
              color: pkStatusSurface(
                context,
                valid ? PkStatusTone.shared : PkStatusTone.danger,
              ),
              borderColor: pkStatusBorder(
                context,
                valid ? PkStatusTone.shared : PkStatusTone.danger,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      valid
                          ? context.t.everythingIsAllocated
                          : _validationMessage(sum),
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: valid
                            ? context.pk.sharedStrong
                            : context.pk.danger,
                      ),
                    ),
                  ),
                  Text(
                    _method == SplitMethod.percentage
                        ? '${_enteredTotal().toStringAsFixed(1)}%'
                        : '${(sum / widget.totalMinor * 100).round()}%',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x4),
            FilledButton(
              key: const ValueKey('split_done'),
              onPressed: valid ? () => _review(shares) : null,
              child: Text(
                _previewing ? context.t.useThisSplit : context.t.previewSplit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The itemized editor: one row per line, with the people who had it.
  Widget _buildItems(PockitoRepository repo, Map<String, int> shares) {
    final info = PockitoCurrencies.of(widget.currency);
    final allocated = _items.fold(0, (sum, item) => sum + item.amountMinor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: _items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(PkSpacing.x6),
                    child: Text(
                      context.t.addALineForEach,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.pk.textSecondary,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: PkSpacing.x2),
                  itemBuilder: (context, index) {
                    final item = _items[index];
                    return PkCard(
                      key: ValueKey('split_item_${item.id}'),
                      padding: const EdgeInsets.all(PkSpacing.x3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.label,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              PkAmountText(
                                amountMinor: item.amountMinor,
                                currency: widget.currency,
                              ),
                              IconButton(
                                tooltip: context.t.removeX0(item.label),
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () => setState(
                                  () => _items = [..._items]..removeAt(index),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: PkSpacing.x2),
                          Wrap(
                            spacing: PkSpacing.x2,
                            runSpacing: PkSpacing.x2,
                            children: [
                              for (final member in widget.space.members)
                                FilterChip(
                                  key: ValueKey(
                                    'item_${item.id}_${member.userId}',
                                  ),
                                  label: Text(
                                    repo.userById(member.userId)?.isYou == true
                                        ? context.t.you
                                        : repo.userById(member.userId)?.name ??
                                              'Member',
                                  ),
                                  selected: item.participantIds.contains(
                                    member.userId,
                                  ),
                                  onSelected: (on) {
                                    PkHaptics.selection();
                                    setState(() {
                                      _items = [
                                        for (final entry in _items)
                                          entry.id == item.id
                                              ? entry.copyWith(
                                                  participantIds: on
                                                      ? [
                                                          ...entry
                                                              .participantIds,
                                                          member.userId,
                                                        ]
                                                      : entry.participantIds
                                                            .where(
                                                              (id) =>
                                                                  id !=
                                                                  member.userId,
                                                            )
                                                            .toList(),
                                                )
                                              : entry,
                                      ];
                                    });
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
        const SizedBox(height: PkSpacing.x2),
        Row(
          children: [
            Expanded(
              child: Text(
                allocated == widget.totalMinor
                    ? context.t.everyLineAccountedFor
                    : context.t.notItemisedSplitEvenly(
                        PkFormat.money(
                          widget.totalMinor - allocated,
                          widget.currency,
                        ),
                      ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            TextButton.icon(
              key: const ValueKey('split_item_add'),
              onPressed: () => _addItem(info),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(context.t.addLine),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addItem(CurrencyInfo info) async {
    final label = await showPkTextPrompt(
      context,
      title: context.t.whatWasOnTheBill,
      hint: context.t.eGTheWine,
    );
    if (label == null || label.trim().isEmpty || !mounted) return;
    final amount = await showPkTextPrompt(
      context,
      title: context.t.howMuchWas(label.trim()),
      hint: info.decimals == 0 ? '0' : '0.${'0' * info.decimals}',
      confirmLabel: context.t.add,
    );
    if (amount == null || !mounted) return;
    final value = double.tryParse(amount.replaceAll(',', '.'));
    if (value == null || value <= 0) {
      showPkErrorToast(context, context.t.thatAmountDidnTLook);
      return;
    }
    setState(() {
      _items = [
        ..._items,
        SplitItem(
          id: 'item_${_itemSequence++}',
          label: label.trim(),
          amountMinor: (value * info.minorUnitScale).round(),
          // Everyone by default: the common case is a shared line, and
          // unticking is easier than ticking.
          participantIds: widget.space.members
              .map((member) => member.userId)
              .toList(),
        ),
      ];
    });
  }

  /// Shows the resulting split, then commits it on a second press.
  Future<void> _review(Map<String, int> shares) async {
    if (!_previewing) {
      setState(() => _previewing = true);
      final repo = context.read<PockitoAppViewModel>().repository;
      if (!mounted) return;
      final accepted = await showPkSheet<bool>(
        context,
        builder: (context) => PkSheetScaffold(
          title: context.t.thisIsHowItLands,
          subtitle: context.t.x0InX1(
            PkFormat.money(widget.totalMinor, widget.currency),
            widget.space.name,
          ),
          footer: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                key: const ValueKey('split_preview_accept'),
                onPressed: () => Navigator.pop(context, true),
                child: Text(context.t.useThisSplit),
              ),
              const SizedBox(height: PkSpacing.x2),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(context.t.keepEditing),
              ),
            ],
          ),
          child: Builder(
            builder: (context) {
              String nameOf(String id) => repo.userById(id)?.isYou == true
                  ? context.t.you
                  : repo.userById(id)?.name ?? context.t.member;
              // C-5: colour-keyed to the rows beneath it, so the bar and the
              // list read as one answer rather than two.
              final segments = [
                for (final (index, member) in widget.space.members.indexed)
                  PkSplitSegment(
                    id: member.userId,
                    label: nameOf(member.userId),
                    amountMinor: shares[member.userId] ?? 0,
                    accent: PkPalette.categoryAt(index + 1),
                  ),
              ];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PkSplitBar(segments: segments, currency: widget.currency),
                  const SizedBox(height: PkSpacing.x4),
                  for (final segment in segments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                      child: Row(
                        children: [
                          SizedBox(
                            width: PkSize.avatarCompact,
                            height: PkSize.avatarCompact,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                PkAvatar(
                                  label:
                                      repo.userById(segment.id)?.initials ??
                                      '?',
                                  size: PkSize.avatarCompact,
                                ),
                                PositionedDirectional(
                                  end: -2,
                                  bottom: -2,
                                  child: PkSplitLegendDot(
                                    accent: segment.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: PkSpacing.x3),
                          Expanded(child: Text(segment.label)),
                          PkAmountText(
                            amountMinor: segment.amountMinor,
                            currency: widget.currency,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: PkSpacing.x3),
                  Text(
                    context.t.nothingIsSavedYetGoing,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            },
          ),
        ),
      );
      if (!mounted) return;
      setState(() => _previewing = false);
      if (accepted != true) return;
    }
    if (!mounted) return;
    Navigator.pop(
      context,
      _SplitResult(
        _method,
        shares,
        items: _method == SplitMethod.itemized ? _items : const [],
      ),
    );
  }

  Map<String, int> _computedShares() {
    if (_method == SplitMethod.equal) {
      final each = widget.totalMinor ~/ widget.space.members.length;
      var remainder = widget.totalMinor - each * widget.space.members.length;
      return {
        for (final member in widget.space.members)
          member.userId: each + (remainder-- > 0 ? 1 : 0),
      };
    }
    if (_method == SplitMethod.percentage) {
      var used = 0;
      final result = <String, int>{};
      for (final entry in widget.space.members.indexed) {
        final value = double.tryParse(_values[entry.$2.userId]!.text) ?? 0;
        final amount = entry.$1 == widget.space.members.length - 1
            ? widget.totalMinor - used
            : (widget.totalMinor * value / 100).round();
        used += amount;
        result[entry.$2.userId] = amount;
      }
      return result;
    }
    if (_method == SplitMethod.shares) {
      final totalShares = _enteredTotal();
      if (totalShares <= 0) return const {};
      var used = 0;
      final result = <String, int>{};
      for (final entry in widget.space.members.indexed) {
        final weight = double.tryParse(_values[entry.$2.userId]!.text) ?? 0;
        final amount = entry.$1 == widget.space.members.length - 1
            ? widget.totalMinor - used
            : (widget.totalMinor * weight / totalShares).round();
        used += amount;
        result[entry.$2.userId] = amount;
      }
      return result;
    }
    if (_method == SplitMethod.itemized) {
      final result = <String, int>{
        for (final member in widget.space.members) member.userId: 0,
      };
      var allocated = 0;
      for (final item in _items) {
        if (item.participantIds.isEmpty) continue;
        final each = item.amountMinor ~/ item.participantIds.length;
        var remainder = item.amountMinor - each * item.participantIds.length;
        for (final userId in item.participantIds) {
          final amount = each + (remainder-- > 0 ? 1 : 0);
          result[userId] = (result[userId] ?? 0) + amount;
          allocated += amount;
        }
      }
      // Whatever the lines do not cover — a service charge, a rounding gap —
      // is split evenly rather than silently dropped.
      final leftover = widget.totalMinor - allocated;
      if (leftover != 0 && widget.space.members.isNotEmpty) {
        final each = leftover ~/ widget.space.members.length;
        var remainder = leftover - each * widget.space.members.length;
        for (final member in widget.space.members) {
          result[member.userId] =
              (result[member.userId] ?? 0) + each + (remainder-- > 0 ? 1 : 0);
        }
      }
      return result;
    }
    final multiplier = PockitoCurrencies.of(widget.currency).minorUnitScale;
    return {
      for (final member in widget.space.members)
        member.userId:
            ((double.tryParse(_values[member.userId]!.text) ?? 0) * multiplier)
                .round(),
    };
  }

  double _enteredTotal() => widget.space.members.fold<double>(
    0,
    (sum, member) => sum + (double.tryParse(_values[member.userId]!.text) ?? 0),
  );

  bool _configurationValid() => switch (_method) {
    SplitMethod.equal => true,
    SplitMethod.percentage => (_enteredTotal() - 100).abs() < .01,
    SplitMethod.shares =>
      _enteredTotal() > 0 &&
          widget.space.members.every(
            (member) =>
                (double.tryParse(_values[member.userId]!.text) ?? -1) >= 0,
          ),
    SplitMethod.exact => true,
    // Every line has to belong to at least one person, or part of the bill is
    // allocated to nobody.
    SplitMethod.itemized =>
      _items.isNotEmpty &&
          _items.every((item) => item.participantIds.isNotEmpty),
  };

  String _validationMessage(int sum) {
    if (_method == SplitMethod.percentage) {
      return context.t.percentagesMustTotal;
    }
    if (_method == SplitMethod.shares) {
      return context.t.enterAtLeastOnePositive;
    }
    return '${PkFormat.money((widget.totalMinor - sum).abs(), widget.currency)} ${sum < widget.totalMinor ? 'left to allocate' : 'over'}';
  }
}

/// Records who put money into a shared expense.
///
/// A single payer stays a single line — the extra rows only appear once the
/// user says more than one person paid, so the common case is not taxed by the
/// harder one.
class _PayersEditor extends StatefulWidget {
  const _PayersEditor({
    required this.space,
    required this.currency,
    required this.totalMinor,
    required this.payers,
    required this.singlePayerUserId,
    required this.onChanged,
  });

  final SharedSpace space;
  final String currency;
  final int totalMinor;
  final Map<String, int> payers;
  final String singlePayerUserId;
  final ValueChanged<Map<String, int>> onChanged;

  @override
  State<_PayersEditor> createState() => _PayersEditorState();
}

class _PayersEditorState extends State<_PayersEditor> {
  final Map<String, TextEditingController> _values = {};

  bool get _split => widget.payers.length > 1;

  @override
  void dispose() {
    for (final controller in _values.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String userId, int amountMinor) {
    final info = PockitoCurrencies.of(widget.currency);
    return _values.putIfAbsent(
      userId,
      () => TextEditingController(
        text: (amountMinor / info.minorUnitScale).toStringAsFixed(
          info.decimals,
        ),
      ),
    );
  }

  void _enableSplit() {
    // Start from the whole amount on the person who was already the payer, so
    // turning this on changes nothing until the user moves a number.
    widget.onChanged({widget.singlePayerUserId: widget.totalMinor});
  }

  void _disableSplit() {
    for (final controller in _values.values) {
      controller.dispose();
    }
    _values.clear();
    widget.onChanged({});
  }

  void _push() {
    final info = PockitoCurrencies.of(widget.currency);
    widget.onChanged({
      for (final entry in _values.entries)
        entry.key:
            ((double.tryParse(entry.value.text.replaceAll(',', '.')) ?? 0) *
                    info.minorUnitScale)
                .round(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    if (!_split) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          key: const ValueKey('enable_multi_payer'),
          onPressed: _enableSplit,
          icon: const Icon(Icons.group_add_outlined, size: 18),
          label: Text(context.t.moreThanOnePersonPaid),
        ),
      );
    }
    final allocated = widget.payers.values.fold(0, (a, b) => a + b);
    final balanced = allocated == widget.totalMinor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                context.t.whoPaidWhat,
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            TextButton(
              key: const ValueKey('disable_multi_payer'),
              onPressed: _disableSplit,
              child: Text(context.t.onePayer),
            ),
          ],
        ),
        for (final member in widget.space.members)
          Padding(
            padding: const EdgeInsets.only(bottom: PkSpacing.x2),
            child: Row(
              children: [
                PkAvatar(
                  label: repo.userById(member.userId)?.initials ?? '?',
                  size: 32,
                ),
                const SizedBox(width: PkSpacing.x3),
                Expanded(
                  child: Text(
                    repo.userById(member.userId)?.isYou == true
                        ? context.t.you
                        : repo.userById(member.userId)?.name ?? 'Member',
                  ),
                ),
                SizedBox(
                  width: 118,
                  child: TextField(
                    key: ValueKey('payer_${member.userId}'),
                    controller: _controllerFor(
                      member.userId,
                      widget.payers[member.userId] ?? 0,
                    ),
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    // pk-exempt: an inline 118 px cell inside a member row, not
                    // a form field. `PkAmountField` is a centred 32 px input
                    // with its own label and preview and does not fit here.
                    decoration: InputDecoration(
                      prefixText: PockitoCurrencies.of(widget.currency).symbol,
                      isDense: true,
                    ),
                    onChanged: (_) {
                      _push();
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
        // The sum has to equal the total or the expense records money that
        // came from nowhere.
        Text(
          balanced
              ? context.t.payersAddUpTo(
                  PkFormat.money(widget.totalMinor, widget.currency),
                )
              : '${PkFormat.money((widget.totalMinor - allocated).abs(), widget.currency)} '
                    '${allocated > widget.totalMinor ? 'too much' : 'still unaccounted for'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: balanced ? context.pk.success : context.pk.danger,
          ),
        ),
      ],
    );
  }
}

/// The day header that stays put while its own rows scroll under it.
class _DayHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _DayHeaderDelegate({
    required this.label,
    required this.total,
    required this.currency,
    required this.background,
    required this.textStyle,
    required this.height,
  });

  final String label;
  final int total;
  final String currency;
  final Color background;
  final TextStyle textStyle;
  final double height;

  // The header has to grow with the reader's text size or its own label will
  // not fit inside it.
  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    color: background,
    padding: const EdgeInsetsDirectional.fromSTEB(
      PkSpacing.screen + PkSpacing.x1,
      0,
      PkSpacing.screen,
      PkSpacing.x2,
    ),
    alignment: AlignmentDirectional.centerStart,
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
        ),
        const SizedBox(width: PkSpacing.x2),
        // The day's net movement, so a long list still answers "what did that
        // day cost me" without adding it up by hand.
        Flexible(
          child: Text(
            PkFormat.money(total, currency, sign: true),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle.copyWith(
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    ),
  );

  @override
  bool shouldRebuild(_DayHeaderDelegate oldDelegate) =>
      oldDelegate.label != label ||
      oldDelegate.total != total ||
      oldDelegate.height != height ||
      oldDelegate.background != background;
}

/// A transaction row with the actions people expect on a list row.
///
/// Swipe reaches edit and void without opening the row; long-press opens the
/// same actions as a menu, for anyone who cannot swipe reliably.
class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.transaction, required this.repository});

  final MoneyTransaction transaction;
  final PockitoRepository repository;

  @override
  Widget build(BuildContext context) {
    final tile = PkTransactionTile(
      transaction: transaction,
      repository: repository,
      showDate: false,
      onTap: () => context.push('/activity/${transaction.id}'),
    );
    if (transaction.isVoided) {
      // A voided row stays in the list, visibly struck through and dimmed, and
      // offers restore rather than the usual actions.
      return Semantics(
        label: context.t.voidedX03(transaction.merchant),
        child: Opacity(
          opacity: .55,
          child: Stack(
            children: [
              tile,
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: Container(
                      height: 1,
                      margin: const EdgeInsets.symmetric(
                        horizontal: PkSpacing.x4,
                      ),
                      color: context.pk.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Dismissible(
      key: ValueKey('row_${transaction.id}'),
      background: _SwipeBackground(
        icon: Icons.edit_outlined,
        label: context.t.edit,
        color: Theme.of(context).colorScheme.primary,
        alignment: AlignmentDirectional.centerStart,
      ),
      secondaryBackground: _SwipeBackground(
        icon: Icons.block_outlined,
        label: context.t.actionVoid,
        color: context.pk.danger,
        alignment: AlignmentDirectional.centerEnd,
      ),
      confirmDismiss: (direction) async {
        PkHaptics.selection();
        if (direction == DismissDirection.startToEnd) {
          context.push('/add?transaction=${transaction.id}');
          return false;
        }
        final reason = await showPkReasonSheet(
          context,
          title: context.t.voidX0(transaction.merchant),
          message: context.t.itStaysInYourHistory2,
          hint: context.t.whyOptional,
          confirmLabel: context.t.voidIt,
          destructive: true,
        );
        if (reason == null || !context.mounted) return false;
        await PkGuardedAction.run(
          context,
          () => repository.voidTransaction(
            transaction.id,
            reason: reason.trim().isEmpty ? null : reason.trim(),
          ),
          token: 'void_${transaction.id}',
          undoMessage: context.t.voidedX02(transaction.merchant),
          onUndo: () => repository.restoreTransaction(transaction.id),
        );
        // The row is rebuilt from the record, which is now voided, so it is
        // never removed from the list by the gesture itself.
        return false;
      },
      // Section 9.4: a gesture shortcut always has a non-gesture alternative.
      // Swipe and long-press are both gestures, so the same two actions are
      // published to the semantics tree, where a screen reader offers them in
      // its own actions menu without any gesture at all.
      child: Semantics(
        label: transaction.merchant,
        customSemanticsActions: {
          CustomSemanticsAction(label: context.t.edit): () =>
              context.push('/add?transaction=${transaction.id}'),
          CustomSemanticsAction(label: context.t.actionVoid): () =>
              _showRowActions(context),
        },
        child: GestureDetector(
          onLongPress: () {
            PkHaptics.warning();
            _showRowActions(context);
          },
          child: tile,
        ),
      ),
    );
  }

  Future<void> _showRowActions(BuildContext context) => showPkSheet<void>(
    context,
    builder: (sheetContext) => PkSheetScaffold(
      title: transaction.merchant,
      subtitle: PkFormat.longDate(transaction.occurredOn, context.t),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PkLedgerRow.management(
            leading: const Icon(Icons.open_in_new_rounded),
            title: context.t.open,
            onTap: () {
              Navigator.pop(sheetContext);
              context.push('/activity/${transaction.id}');
            },
          ),
          PkLedgerRow.management(
            leading: const Icon(Icons.edit_outlined),
            title: context.t.edit,
            onTap: () {
              Navigator.pop(sheetContext);
              context.push('/add?transaction=${transaction.id}');
            },
          ),
          PkLedgerRow.management(
            leading: const Icon(Icons.copy_outlined),
            title: context.t.duplicate,
            onTap: () {
              Navigator.pop(sheetContext);
              context.push('/add?duplicate=${transaction.id}');
            },
          ),
          if (transaction.isDraft)
            PkLedgerRow.management(
              leading: const Icon(Icons.check_circle_outline_rounded),
              title: context.t.actionConfirm,
              onTap: () {
                Navigator.pop(sheetContext);
                PkGuardedAction.run(
                  context,
                  () => repository.confirmTransaction(transaction.id),
                  successMessage: context.t.confirmedItCountsFromNow,
                );
              },
            ),
        ],
      ),
    ),
  );
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.icon,
    required this.label,
    required this.color,
    required this.alignment,
  });

  final IconData icon;
  final String label;
  final Color color;

  /// Directional so the swipe affordance mirrors under right-to-left.
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) => Container(
    color: color.withValues(alpha: .12),
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x5),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: PkSize.icon),
        const SizedBox(width: PkSpacing.x2),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    ),
  );
}

/// A chip group that gains a search field once it is too long to scan.
class _FilterChipGroup extends StatefulWidget {
  const _FilterChipGroup({
    required this.searchHint,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final String searchHint;

  /// (id, label) pairs, already in the order they should appear.
  final List<(String, String)> options;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;

  @override
  State<_FilterChipGroup> createState() => _FilterChipGroupState();
}

class _FilterChipGroupState extends State<_FilterChipGroup> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visible = query.isEmpty
        ? widget.options
        : widget.options
              .where((option) => option.$2.toLowerCase().contains(query))
              .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.options.length > 8) ...[
          const SizedBox(height: PkSpacing.x2),
          PkSearchField(
            value: _query,
            hintText: widget.searchHint,
            resultCount: visible.length,
            onChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: PkSpacing.x2),
        ],
        Wrap(
          spacing: PkSpacing.x2,
          runSpacing: PkSpacing.x1,
          children: [
            for (final option in visible)
              FilterChip(
                key: ValueKey('filter_option_${option.$1}'),
                label: Text(option.$2),
                selected: widget.selected.contains(option.$1),
                onSelected: (value) {
                  PkHaptics.selection();
                  value
                      ? widget.selected.add(option.$1)
                      : widget.selected.remove(option.$1);
                  widget.onChanged(widget.selected);
                },
              ),
            if (visible.isEmpty)
              Text(
                context.t.nothingMatchesX0(_query),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ],
    );
  }
}
