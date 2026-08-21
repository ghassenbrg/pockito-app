import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../domain/models/financial_models.dart';
import '../core/components/pk_components.dart';
import '../core/design_system/pk_theme.dart';
import '../core/design_system/pk_tokens.dart';

Widget _frame(Widget child, {ThemeMode mode = ThemeMode.light}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: PkTheme.light(),
  darkTheme: PkTheme.dark(),
  themeMode: mode,
  home: Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(PkSpacing.x4),
        child: child,
      ),
    ),
  ),
);

@Preview(
  name: 'Account cards · light',
  group: 'Money cards',
  size: Size(390, 520),
)
Widget accountCardsLightPreview() => _frame(
  Column(
    children: [
      PkAccountTile(
        account: const Account(
          id: 'preview',
          name: 'Revolut',
          type: AccountType.bank,
          currency: 'EUR',
          openingBalanceMinor: 0,
          isDefault: true,
          colorIndex: 2,
          icon: 'card',
        ),
        balanceMinor: 614206,
        onTap: _noop,
      ),
      const SizedBox(height: PkSpacing.x3),
      PkAccountTile(
        account: const Account(
          id: 'preview-large',
          name: 'A very long international everyday account',
          type: AccountType.bank,
          currency: 'JPY',
          openingBalanceMinor: 0,
          colorIndex: 4,
          icon: 'bank',
        ),
        balanceMinor: 126450000,
        onTap: _noop,
      ),
    ],
  ),
);

@Preview(
  name: 'Account cards · dark',
  group: 'Money cards',
  size: Size(390, 520),
)
Widget accountCardsDarkPreview() => _frame(
  Column(
    children: [
      PkAccountTile(
        account: const Account(
          id: 'preview',
          name: 'Revolut',
          type: AccountType.bank,
          currency: 'EUR',
          openingBalanceMinor: 0,
          isDefault: true,
          colorIndex: 2,
          icon: 'card',
        ),
        balanceMinor: 614206,
        onTap: _noop,
      ),
      const SizedBox(height: PkSpacing.x3),
      PkAccountTile(
        account: const Account(
          id: 'preview-card',
          name: 'Visa',
          type: AccountType.card,
          currency: 'EUR',
          openingBalanceMinor: 0,
          colorIndex: 5,
          icon: 'card',
        ),
        balanceMinor: -52499,
        onTap: _noop,
      ),
    ],
  ),
  mode: ThemeMode.dark,
);

@Preview(
  name: 'Balance directions',
  group: 'Semantic states',
  size: Size(390, 360),
)
Widget balanceStatesPreview() => _frame(
  PkCard(
    child: Column(
      children: const [
        Row(
          children: [
            Expanded(child: Text('Positive balance')),
            PkBalanceLabel(amountMinor: 4820, currency: 'EUR'),
          ],
        ),
        Divider(height: 32),
        Row(
          children: [
            Expanded(child: Text('Negative balance')),
            PkBalanceLabel(amountMinor: -1380, currency: 'EUR'),
          ],
        ),
        Divider(height: 32),
        Row(
          children: [
            Expanded(child: Text('Settled')),
            PkBalanceLabel(amountMinor: 0, currency: 'EUR'),
          ],
        ),
      ],
    ),
  ),
);

@Preview(
  name: 'Budget thresholds',
  group: 'Semantic states',
  size: Size(390, 620),
)
Widget budgetStatesPreview() => _frame(
  Column(
    children: [
      PkBudgetTile(
        snapshot: BudgetSnapshot(
          budget: const Budget(
            id: 'ok',
            name: 'Groceries',
            scope: BudgetScope.personal,
            categoryId: 'groceries',
            limitMinor: 25000,
            currency: 'EUR',
          ),
          usedMinor: 11380,
          remainingMinor: 13620,
          progress: .4552,
          health: BudgetHealth.healthy,
          window: _augustWindow,
        ),
        onTap: _noop,
      ),
      const SizedBox(height: PkSpacing.x3),
      PkBudgetTile(
        snapshot: BudgetSnapshot(
          budget: const Budget(
            id: 'near',
            name: 'Utilities',
            scope: BudgetScope.space,
            categoryId: 'utilities',
            limitMinor: 15000,
            currency: 'EUR',
          ),
          usedMinor: 12400,
          remainingMinor: 2600,
          progress: .826,
          health: BudgetHealth.near,
          window: _augustWindow,
        ),
        onTap: _noop,
      ),
      const SizedBox(height: PkSpacing.x3),
      PkBudgetTile(
        snapshot: BudgetSnapshot(
          budget: const Budget(
            id: 'over',
            name: 'Shopping',
            scope: BudgetScope.personal,
            categoryId: 'shopping',
            limitMinor: 6000,
            currency: 'EUR',
          ),
          usedMinor: 8600,
          remainingMinor: -2600,
          progress: 1.433,
          health: BudgetHealth.exceeded,
          window: _augustWindow,
        ),
        onTap: _noop,
      ),
    ],
  ),
);

@Preview(
  name: 'Loading and empty',
  group: 'Universal states',
  size: Size(390, 700),
)
Widget universalStatesPreview() => _frame(
  const Column(
    children: [
      PkSkeleton(height: 120),
      SizedBox(height: PkSpacing.x3),
      PkSkeleton(height: 72),
      SizedBox(height: PkSpacing.x5),
      PkEmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'No activity yet',
        message:
            'Record an expense, income or transfer to start your timeline.',
      ),
    ],
  ),
);

void _noop() {}

/// The window every budget preview is measured over, so the three tiles differ
/// only in the thing they are there to show: their health.
final _augustWindow = BudgetWindow(
  start: DateTime(2026, 8),
  end: DateTime(2026, 9),
  label: 'August 2026',
);
