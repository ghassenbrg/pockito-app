import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_tokens.dart';
import '../../../core/design_system/pk_labels.dart';

/// Tags cut across categories.
///
/// "How much did the Berlin trip cost" is a question a category tree cannot
/// answer, because the trip was groceries and transport and restaurants.
class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final query = viewModel.queryFor('tags').trim().toLowerCase();
    final tags = repo.tags
        .where((tag) => query.isEmpty || tag.name.toLowerCase().contains(query))
        .toList();
    int usage(Tag tag) =>
        repo.transactions.where((item) => item.tagIds.contains(tag.id)).length +
        repo.sharedExpenses
            .where((item) => item.tagIds.contains(tag.id))
            .length;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.tags),
        actions: [
          IconButton(
            key: const ValueKey('add_tag'),
            tooltip: context.t.addTag,
            onPressed: () => _edit(context),
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
              listId: 'tags',
              totalCount: repo.tags.length,
              resultCount: tags.length,
              hintText: context.t.searchX0Tags(repo.tags.length),
              sortOptions: const [PkSort.nameAsc],
              sort: PkSort.nameAsc,
              onSortChanged: (_) {},
              query: viewModel.queryFor('tags'),
              onQueryChanged: (value) => viewModel.setQueryFor('tags', value),
            ),
            if (tags.isEmpty)
              PkListState.empty(
                icon: Icons.sell_outlined,
                title: query.isEmpty
                    ? context.t.noTagsYet
                    : context.t.nothingMatchesX0(query),
                message: query.isEmpty
                    ? context.t.tagsCutAcrossCategoriesA
                    : context.t.tryADifferentWordOr,
                actionLabel: query.isEmpty
                    ? context.t.addATag
                    : context.t.actionClearSearch,
                onAction: query.isEmpty
                    ? () => _edit(context)
                    : () => viewModel.setQueryFor('tags', ''),
              )
            else
              // Section 7.15: 56 px management rows on one surface.
              PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.avatarCompact + PkSpacing.x3,
                children: [
                  for (final tag in tags)
                    PkLedgerRow.management(
                      key: ValueKey('tag_row_${tag.id}'),
                      semanticIdentifier: 'tag_${tag.id}',
                      leading: CircleAvatar(
                        radius: PkSize.avatarCompact / 2,
                        backgroundColor: PkPalette.categoryAt(tag.colorIndex),
                      ),
                      title: tag.name,
                      subtitle: usage(tag) == 0
                          ? context.t.notUsedYet
                          : context.t.onX0RecordX1(
                              usage(tag),
                              usage(tag) == 1 ? '' : 's',
                            ),
                      showChevron: true,
                      onTap: () => _actions(context, tag),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, [Tag? tag]) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final name = await showPkTextPrompt(
      context,
      title: tag == null ? context.t.newTag : context.t.renameX0(tag.name),
      hint: context.t.eGBerlinTrip,
      initialValue: tag?.name ?? '',
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.saveTag(
        (tag ?? Tag(id: '', name: '', colorIndex: repo.tags.length % 12))
            .copyWith(name: name.trim()),
      ),
      successMessage: tag == null ? context.t.tagAdded : context.t.tagRenamed,
    );
  }

  Future<void> _actions(BuildContext context, Tag tag) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final action = await showPkSheet<String>(
      context,
      builder: (context) => PkSheetScaffold(
        title: tag.name,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit_outlined),
              title: Text(context.t.rename),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.filter_alt_outlined),
              title: Text(context.t.seeEverythingTaggedWithThis),
              onTap: () => Navigator.pop(context, 'filter'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.delete_outline_rounded,
                color: context.pk.danger,
              ),
              title: Text(
                context.t.delete,
                style: TextStyle(color: context.pk.danger),
              ),
              subtitle: Text(context.t.recordsKeepTheirOtherTags),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (!context.mounted || action == null) return;
    switch (action) {
      case 'edit':
        await _edit(context, tag);
      case 'filter':
        context.read<PockitoAppViewModel>().setActivityFilters(
          types: const {},
          period: ActivityPeriod.all,
          categoryIds: const {},
          accountIds: const {},
          spaceIds: const {},
          tagIds: {tag.id},
        );
        context.push('/activity');
      case 'delete':
        await PkGuardedAction.run(
          context,
          () => repo.deleteTag(tag.id),
          undoMessage: context.t.x0Deleted(tag.name),
          onUndo: () => repo.saveTag(tag.copyWith(archived: false)),
        );
    }
  }
}

/// The cards and accounts money actually leaves by.
class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final methods = repo.paymentMethods;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.paymentMethods),
        actions: [
          IconButton(
            key: const ValueKey('add_payment_method'),
            tooltip: context.t.addPaymentMethod,
            onPressed: () => _edit(context),
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
            if (methods.isEmpty)
              PkListState.empty(
                icon: Icons.credit_card_outlined,
                title: context.t.noPaymentMethodsYet,
                message: context.t.anAccountSaysWhereThe,
                actionLabel: context.t.addOne,
                onAction: () => _edit(context),
              )
            else
              // Section 7.15: 56 px management rows on one surface.
              PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.avatarCompact + PkSpacing.x3,
                children: [
                  for (final method in methods)
                    PkLedgerRow.management(
                      key: ValueKey('pm_row_${method.id}'),
                      semanticIdentifier: 'payment_method_${method.id}',
                      leading: PkIconTile(
                        icon: PkIcons.named(method.icon),
                        color: PkPalette.categoryAt(method.colorIndex),
                        size: PkSize.avatarCompact,
                      ),
                      title: method.last4 == null
                          ? method.name
                          : '${method.name} ····${method.last4}',
                      subtitle: [
                        switch (method.kind) {
                          PaymentMethodKind.card => context.t.card,
                          PaymentMethodKind.bankTransfer =>
                            context.t.bankTransfer,
                          PaymentMethodKind.cash => context.t.cash,
                          PaymentMethodKind.direct => context.t.directDebit,
                          PaymentMethodKind.digital => context.t.digitalWallet,
                        },
                        if (method.accountId != null)
                          repo.accountById(method.accountId!)?.name ?? '',
                        context.t.x0Records(
                          repo.transactions
                              .where(
                                (item) => item.paymentMethodId == method.id,
                              )
                              .length,
                        ),
                      ].where((part) => part.isNotEmpty).join(' · '),
                      trailing: IconButton(
                        tooltip: context.t.deleteX0(method.name),
                        icon: const Icon(Icons.delete_outline_rounded),
                        onPressed: () => PkGuardedAction.run(
                          context,
                          () => repo.deletePaymentMethod(method.id),
                          undoMessage: context.t.x0Deleted(method.name),
                          onUndo: () => repo.savePaymentMethod(
                            method.copyWith(archived: false),
                          ),
                        ),
                      ),
                      onTap: () => _edit(context, method),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, [PaymentMethod? method]) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final name = await showPkTextPrompt(
      context,
      title: method == null
          ? context.t.newPaymentMethod
          : context.t.renameX0(method.name),
      hint: context.t.eGAmexGold,
      initialValue: method?.name ?? '',
    );
    if (name == null || name.trim().isEmpty || !context.mounted) return;
    final last4 = await showPkTextPrompt(
      context,
      title: context.t.lastFourDigitsOptional,
      hint: '3007',
      initialValue: method?.last4 ?? '',
      maxLength: 4,
      confirmLabel: 'Save',
    );
    if (!context.mounted) return;
    await PkGuardedAction.run(
      context,
      () => repo.savePaymentMethod(
        (method ??
                PaymentMethod(
                  id: '',
                  name: '',
                  kind: PaymentMethodKind.card,
                  colorIndex: repo.paymentMethods.length % 12,
                ))
            .copyWith(
              name: name.trim(),
              last4: last4 == null || last4.trim().isEmpty
                  ? null
                  : last4.trim(),
            ),
      ),
      successMessage: method == null
          ? context.t.paymentMethodAdded
          : context.t.saved,
    );
  }
}

/// CSV in, CSV or JSON out.
///
/// The import always shows what it is about to do — valid, invalid and
/// already-recorded rows — before a single record is written.
class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late final TextEditingController _csv = TextEditingController(text: _sample);
  ImportPreview? _preview;

  static const _sample =
      'date,description,amount,currency,category,account\n'
      '2026-08-16,Rewe,-32.50,EUR,Groceries,Revolut\n'
      '2026-08-16,Refund from Zalando,24.00,EUR,Refunds,Visa\n'
      '2026-08-12,Rewe,-32.50,EUR,Groceries,Revolut\n'
      '2026-08-99,Broken row,-10.00,EUR,Groceries,Revolut\n';

  @override
  void dispose() {
    _csv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final viewModel = context.read<PockitoAppViewModel>();
    final preview = _preview;
    final valid =
        preview?.rows
            .where((row) => row.state == ImportRowState.valid)
            .toList() ??
        const <ImportRow>[];
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.importExport)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkSectionHeader(title: context.t.export),
            PkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.exportsExactlyWhatActivityIs(
                      context.t.recordCount(
                        viewModel.filteredTransactions.length,
                      ),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const ValueKey('export_csv'),
                          onPressed: () => _export(
                            context,
                            repo.exportCsv(viewModel.filteredTransactions),
                            'CSV',
                          ),
                          icon: const Icon(Icons.table_chart_outlined),
                          label: const Text('CSV'), // i18n-exempt: format name
                        ),
                      ),
                      const SizedBox(width: PkSpacing.x2),
                      Expanded(
                        child: OutlinedButton.icon(
                          key: const ValueKey('export_json'),
                          onPressed: () => _export(
                            context,
                            repo.exportJson(viewModel.filteredTransactions),
                            'JSON',
                          ),
                          icon: const Icon(Icons.data_object_rounded),
                          label: const Text('JSON'), // i18n-exempt: format name
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(title: context.t.import),
            PkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.t.pasteCsvWithAHeader,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  TextField(
                    key: const ValueKey('import_csv'),
                    controller: _csv,
                    minLines: 4,
                    maxLines: 10,
                    // pk-exempt: CSV is data, not prose — it aligns by column, so its size
                    // is fixed rather than following the reading scale.
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                    // i18n-exempt: the name of the file format
                    decoration: const InputDecoration(labelText: 'CSV'),
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  OutlinedButton.icon(
                    key: const ValueKey('import_preview'),
                    onPressed: () => setState(
                      () => _preview = repo.previewImport(_csv.text),
                    ),
                    icon: const Icon(Icons.preview_outlined),
                    label: Text(context.t.checkTheRows),
                  ),
                ],
              ),
            ),
            if (preview != null) ...[
              const SizedBox(height: PkSpacing.x4),
              PkCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      context.t.toImportAlreadyRecordedUnreadable(
                        valid.length,
                        preview.rows
                            .where(
                              (row) => row.state == ImportRowState.duplicate,
                            )
                            .length,
                        preview.rows
                            .where((row) => row.state == ImportRowState.invalid)
                            .length,
                      ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: PkSpacing.x3),
                    for (final row in preview.rows)
                      Padding(
                        padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              switch (row.state) {
                                ImportRowState.valid =>
                                  Icons.check_circle_outline_rounded,
                                ImportRowState.duplicate =>
                                  Icons.content_copy_outlined,
                                ImportRowState.invalid =>
                                  Icons.error_outline_rounded,
                              },
                              size: PkSize.iconSmall,
                              color: switch (row.state) {
                                ImportRowState.valid => context.pk.success,
                                ImportRowState.duplicate => context.pk.warning,
                                ImportRowState.invalid => context.pk.danger,
                              },
                            ),
                            const SizedBox(width: PkSpacing.x2),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    context.t.lineX0X1(
                                      row.lineNumber,
                                      row.description,
                                    ),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                  if (row.problem != null)
                                    Text(
                                      row.problem!,
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
                    const SizedBox(height: PkSpacing.x2),
                    PkSubmitButton(
                      key: const ValueKey('import_commit'),
                      label: context.t.importX0RecordX1(
                        valid.length,
                        valid.length == 1 ? '' : 's',
                      ),
                      enabled: valid.isNotEmpty,
                      disabledReason: context.t.nothingHereCanBeImported,
                      icon: Icons.download_rounded,
                      onSubmit: () async {
                        final saved = await PkGuardedAction.run(
                          context,
                          () => repo.importTransactions(valid),
                          successMessage: context.t.x0Imported(valid.length),
                        );
                        if (saved != null && mounted) {
                          setState(() => _preview = null);
                        }
                      },
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

  Future<void> _export(
    BuildContext context,
    String payload,
    String format,
  ) async {
    // The prototype has no file system to write to, so the export goes to the
    // clipboard and is shown in full — nothing is claimed to have been saved
    // somewhere the user cannot find.
    await Clipboard.setData(ClipboardData(text: payload));
    if (!context.mounted) return;
    await showPkSheet<void>(
      context,
      builder: (context) => PkSheetScaffold(
        title: context.t.x0Copied(format),
        subtitle: context.t.itIsOnYourClipboard,
        child: Container(
          padding: const EdgeInsets.all(PkSpacing.x3),
          decoration: BoxDecoration(
            color: context.pk.sunken,
            borderRadius: BorderRadius.circular(PkRadius.medium),
          ),
          child: SelectableText(
            payload.length > 4000
                ? '${payload.substring(0, 4000)}\n…'
                : payload,
            // pk-exempt: the export payload is data, shown at a fixed monospace size.
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11),
          ),
        ),
      ),
    );
  }
}

/// Corrects an account's balance without inventing an expense.
///
/// Every ledger drifts from reality eventually — a cash wallet especially. The
/// alternative to this screen is a fake "Misc" expense that pollutes spending
/// forever.
class ReconcileAccountScreen extends StatefulWidget {
  const ReconcileAccountScreen({super.key, required this.accountId});

  final String accountId;

  @override
  State<ReconcileAccountScreen> createState() => _ReconcileAccountScreenState();
}

class _ReconcileAccountScreenState extends State<ReconcileAccountScreen> {
  final _amount = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _amount.dispose();
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final account = repo.accountById(widget.accountId);
    if (account == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.account_balance_wallet_outlined,
          title: context.t.accountNotFound,
          message: context.t.itMayHaveBeenRemoved4,
        ),
      );
    }
    final current = repo.accountBalance(account);
    final info = PockitoCurrencies.of(account.currency);
    final target = _amount.text.trim().isEmpty
        ? null
        : ((double.tryParse(_amount.text.replaceAll(',', '.')) ?? 0) *
                  info.minorUnitScale)
              .round();
    final delta = target == null ? null : target - current;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.correctX0(account.name))),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.all(PkSpacing.screen),
              children: [
                PkCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.t.pockitoThinksThisAccountHolds,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      PkAmountText(
                        amountMinor: current,
                        currency: account.currency,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: PkSpacing.x5),
                PkAmountField(
                  fieldKey: const ValueKey('reconcile_amount'),
                  controller: _amount,
                  currency: account.currency,
                  label: context.t.whatIsActuallyThere,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: PkSpacing.x4),
                if (delta != null && delta != 0)
                  PkCard(
                    color: context.pk.sunken,
                    child: Text(
                      delta > 0
                          ? context.t.thisRecordsACorrectionOf(
                              PkFormat.money(delta, account.currency),
                            )
                          : context.t.thisRecordsACorrectionOf2(
                              PkFormat.money(delta.abs(), account.currency),
                            ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                const SizedBox(height: PkSpacing.x4),
                TextField(
                  key: const ValueKey('reconcile_reason'),
                  controller: _reason,
                  maxLength: 140,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    labelText: context.t.whyDoesItDiffer,
                    hintText: context.t.eGCountedTheWallet,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: PkSpacing.x4),
                PkSubmitButton(
                  key: const ValueKey('reconcile_save'),
                  label: context.t.recordTheCorrection,
                  icon: Icons.rule_rounded,
                  enabled:
                      delta != null &&
                      delta != 0 &&
                      _reason.text.trim().isNotEmpty,
                  disabledReason: delta == null || delta == 0
                      ? context.t.enterTheRealBalance
                      : context.t.sayWhyItDiffers,
                  onSubmit: () async {
                    final saved = await PkGuardedAction.run(
                      context,
                      () => repo.recordAdjustment(
                        accountId: account.id,
                        targetBalanceMinor: target!,
                        reason: _reason.text.trim(),
                      ),
                      successMessage: context.t.balanceCorrected,
                    );
                    if (saved != null && context.mounted) context.pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
