import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_icons.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

/// Quick Add, section 7.9 and D-06.
///
/// A personal expense or income and nothing else: the task has to finish in one
/// viewport with the keyboard open, in no more than six taps after opening. It
/// deliberately does *not* grow — a multi-payer, multi-currency, receipt-backed
/// shared expense is a different job, and "More options" hands the whole state
/// over to the full editor rather than making this form carry both.
class QuickAddScreen extends StatefulWidget {
  const QuickAddScreen({super.key, this.initialType});

  final MoneyEventType? initialType;

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _merchant = TextEditingController();

  late MoneyEventType _type = widget.initialType ?? MoneyEventType.expense;
  String? _accountId;
  String? _categoryId;
  late DateTime _date;
  var _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    _initialised = true;
    final repo = context.read<PockitoAppViewModel>().repository;
    // The default account is the one the reader has already told us to use,
    // which is what removes two of the six taps.
    _accountId =
        (repo.accounts.where((item) => item.isDefault && !item.archived).isEmpty
                ? repo.accounts.where((item) => !item.archived).firstOrNull
                : repo.accounts.firstWhere((item) => item.isDefault))
            ?.id;
    _date = repo.today;
  }

  @override
  void dispose() {
    _amount.dispose();
    _merchant.dispose();
    super.dispose();
  }

  /// Hands the entered values to the full editor without losing them.
  void _openAdvanced() {
    final query = <String, String>{
      'type': _type.name,
      'account': ?_accountId,
      if (_amount.text.trim().isNotEmpty) 'amount': _amount.text.trim(),
      if (_merchant.text.trim().isNotEmpty) 'merchant': _merchant.text.trim(),
      'category': ?_categoryId,
    };
    Navigator.pop(context);
    context.push(Uri(path: '/add', queryParameters: query).toString());
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final viewModel = context.read<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final account = repo.accountById(_accountId ?? '');
    if (account == null) return;
    // Blocked before submission, not after, per P0-5 and section 4.6.
    if (repo.offline) {
      await showPkOfflineSheet(context, action: context.t.addMoneyEvent);
      return;
    }
    final scale = PockitoCurrencies.of(account.currency).minorUnitScale;
    final amount =
        ((double.tryParse(_amount.text.replaceAll(',', '.')) ?? 0) * scale)
            .round();
    final income = _type == MoneyEventType.income;
    final saved = await PkGuardedAction.run(
      context,
      () => repo.saveTransaction(
        MoneyTransaction(
          id: 'q_${DateTime.now().microsecondsSinceEpoch}',
          type: _type,
          amountMinor: amount,
          currency: account.currency,
          occurredOn: _date,
          merchant: _merchant.text.trim(),
          fromAccountId: income ? null : account.id,
          toAccountId: income ? account.id : null,
          categoryId: _categoryId,
        ),
      ),
      // Section 9.4: submission is idempotent while loading, so a double tap
      // cannot create two records.
      token: 'quick_add',
    );
    if (saved == null || !mounted) return;
    Navigator.pop(context);
    showPkSuccessToast(context, context.t.quickAddSaved);
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final account = repo.accountById(_accountId ?? '');
    final category = repo.categoryById(_categoryId ?? '');
    final currency = account?.currency ?? repo.profile.reportingCurrency;

    return PkSheetScaffold(
      title: _type == MoneyEventType.income
          ? context.t.quickRecordIncome
          : context.t.quickAddExpense,
      // The way out to the advanced flow lives in the header, so the sheet
      // never has to grow a second primary action at the bottom.
      actions: [
        TextButton(
          key: const ValueKey('quick_add_more'),
          onPressed: _openAdvanced,
          child: Text(context.t.quickAddMoreOptions),
        ),
      ],
      footer: PkSubmitButton(
        key: const ValueKey('quick_add_save'),
        label: _type == MoneyEventType.income
            ? context.t.addIncome
            : context.t.addExpense,
        onSubmit: _save,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top: type, then the amount. Section 7.9's order.
            SegmentedButton<MoneyEventType>(
              key: const ValueKey('quick_add_type'),
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: MoneyEventType.expense,
                  label: Text(context.t.expense),
                  icon: const Icon(Icons.north_east_rounded),
                ),
                ButtonSegment(
                  value: MoneyEventType.income,
                  label: Text(context.t.income),
                  icon: const Icon(Icons.south_west_rounded),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (value) => setState(() {
                _type = value.first;
                // A category belongs to one side of the ledger.
                _categoryId = null;
              }),
            ),
            const SizedBox(height: PkSpacing.x4),
            PkAmountField(
              controller: _amount,
              currency: currency,
              autofocus: true,
              quickAmounts: PockitoCurrencies.of(currency).decimals == 0
                  ? const [500, 1000, 3000, 5000]
                  : const [5, 10, 25, 50],
              validator: (value) =>
                  (double.tryParse((value ?? '').replaceAll(',', '.')) ?? 0) <=
                      0
                  ? context.t.enterAnAmountGreaterThan
                  : null,
            ),
            const SizedBox(height: PkSpacing.x3),
            TextFormField(
              key: const ValueKey('quick_add_merchant'),
              controller: _merchant,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: _type == MoneyEventType.income
                    ? context.t.source
                    : context.t.merchant,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? context.t.addAShortDescription
                  : null,
            ),
            const SizedBox(height: PkSpacing.x3),
            // Middle: the three selectors. Each is one tap to open and one to
            // choose, and each already carries a sensible default.
            PkSelectField(
              key: const ValueKey('quick_add_account'),
              label: context.t.accountLabel,
              value: account?.name,
              placeholder: context.t.chooseAnAccount,
              leading: account == null
                  ? null
                  : PkIconTile(
                      icon: PkIcons.named(account.icon),
                      color: PkPalette.categoryAt(account.colorIndex),
                      size: PkSize.avatarCompact,
                    ),
              onTap: () async {
                final picked = await showPkAccountPicker(
                  context,
                  repo: repo,
                  selectedId: _accountId,
                );
                if (picked != null) setState(() => _accountId = picked);
              },
            ),
            const SizedBox(height: PkSpacing.x3),
            PkSelectField(
              key: const ValueKey('quick_add_category'),
              label: context.t.categoryLabel,
              value: category?.name,
              placeholder: context.t.chooseACategory,
              leading: category == null
                  ? null
                  : PkIconTile(
                      icon: PkIcons.named(category.icon),
                      color: PkPalette.categoryAt(category.colorIndex),
                      size: PkSize.avatarCompact,
                    ),
              onTap: () async {
                final picked = await showPkCategoryPicker(
                  context,
                  repo: repo,
                  type: _type == MoneyEventType.income
                      ? CategoryType.income
                      : CategoryType.expense,
                  selectedId: _categoryId,
                );
                if (picked != null) setState(() => _categoryId = picked);
              },
            ),
            const SizedBox(height: PkSpacing.x3),
            PkDateField(
              value: _date,
              today: repo.today,
              onChanged: (value) => setState(() => _date = value),
            ),
          ],
        ),
      ),
    );
  }
}
