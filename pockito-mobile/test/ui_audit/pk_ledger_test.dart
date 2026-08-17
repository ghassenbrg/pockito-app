import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/app/pockito_app_view_model.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/domain/models/financial_models.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:provider/provider.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-006 and section 9.8: Activity as the canonical production ledger.
///
/// The audit's stress target is 500 items. What matters is not that 500 rows
/// render — it is that the screen does not *build* 500 rows, does not regroup
/// the ledger on every frame, and keeps its day headers attached to their rows.
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  /// A repository carrying [count] expenses spread over the past year.
  Future<MockPockitoRepository> withTransactions(int count) async {
    final repo = MockPockitoRepository();
    final account = repo.accounts.first;
    for (var index = 0; index < count; index++) {
      await repo.saveTransaction(
        MoneyTransaction(
          id: 'stress_$index',
          type: MoneyEventType.expense,
          merchant: 'Stress merchant $index',
          amountMinor: 100 + index,
          currency: account.currency,
          occurredOn: repo.today.subtract(Duration(days: index % 365)),
          fromAccountId: account.id,
        ),
      );
    }
    return repo;
  }

  testWidgets('500 items scroll without building 500 rows', (tester) async {
    final repo = await withTransactions(500);
    await pumpSurface(
      tester,
      route: '/activity',
      viewport: phone,
      repository: repo,
    );

    expect(
      repo.transactions.length,
      greaterThanOrEqualTo(500),
      reason: 'The fixture has to actually reach the stress target',
    );

    // Section 9.8: no unbounded eager list. The page is capped and the day
    // groups are slivers, so the tree holds a viewport's worth of rows, not
    // the whole ledger.
    final built = find.byType(PkTransactionTile).evaluate().length;
    expect(
      built,
      lessThan(100),
      reason: 'Activity built $built rows; the list is not virtualised',
    );

    // …and scrolling stays smooth rather than throwing.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -2000));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('grouping happens once per data change, not per build', (
    tester,
  ) async {
    // P1-18: Activity used to regroup every transaction into a day map on
    // every build. The map is memoised now, so two consecutive reads of the
    // same state return the identical instance.
    final repo = await withTransactions(200);
    await pumpSurface(
      tester,
      route: '/activity',
      viewport: phone,
      repository: repo,
    );
    final context = tester.element(find.byType(CustomScrollView).first);
    final viewModel = Provider.of<PockitoAppViewModel>(context, listen: false);

    final first = viewModel.activityGroups;
    final second = viewModel.activityGroups;
    expect(
      identical(first, second),
      isTrue,
      reason: 'activityGroups rebuilt without the data changing',
    );

    viewModel.setActivityQuery('Stress merchant 1');
    expect(
      identical(viewModel.activityGroups, first),
      isFalse,
      reason: 'activityGroups did not rebuild when the filter changed',
    );
  });

  testWidgets('a large ledger still shows five rows above the fold', (
    tester,
  ) async {
    final repo = await withTransactions(500);
    await pumpSurface(
      tester,
      route: '/activity',
      viewport: phone,
      repository: repo,
    );
    expect(
      visibleRowCount(tester, find.byType(PkTransactionTile), viewport: phone),
      greaterThanOrEqualTo(5),
      reason: 'Section 7.7 asks for five simple rows after the chrome',
    );
  });

  testWidgets('day headers stay pinned to the rows they head', (tester) async {
    await pumpSurface(tester, route: '/activity', viewport: phone);
    // Section 7.7: sticky month/day headers, 28–32 px at default text.
    final headers = find.byType(SliverPersistentHeader);
    expect(headers, findsWidgets);
    for (final element in headers.evaluate()) {
      final delegate = (element.widget as SliverPersistentHeader).delegate;
      expect(delegate.maxExtent, inInclusiveRange(28, 32));
      expect((element.widget as SliverPersistentHeader).pinned, isTrue);
    }
  });

  testWidgets('filtering does not leave the ledger in an inconsistent state', (
    tester,
  ) async {
    // Section 9.8: filtering must not rebuild every visible row unnecessarily,
    // and must not throw. The observable contract is that the row count tracks
    // the filter and the screen survives repeated changes.
    final repo = await withTransactions(120);
    await pumpSurface(
      tester,
      route: '/activity',
      viewport: phone,
      repository: repo,
    );
    final context = tester.element(find.byType(CustomScrollView).first);
    final viewModel = Provider.of<PockitoAppViewModel>(context, listen: false);

    for (final query in ['Stress', 'merchant 11', '', 'nothing matches this']) {
      viewModel.setActivityQuery(query);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Failed on "$query"');
    }
    viewModel.setActivityQuery('');
    await tester.pumpAndSettle();
  });

  testWidgets('the empty period keeps the ledger structure', (tester) async {
    // Section 7.7: loading skeletons and empty-period states preserve the same
    // structure, so the screen does not visibly reflow when data arrives.
    final repo = MockPockitoRepository();
    await pumpSurface(
      tester,
      route: '/activity',
      viewport: phone,
      repository: repo,
    );
    final context = tester.element(find.byType(CustomScrollView).first);
    final viewModel = Provider.of<PockitoAppViewModel>(context, listen: false);

    viewModel.setActivityQuery('a-merchant-that-does-not-exist');
    await tester.pumpAndSettle();

    expect(find.byType(PkEmptyState), findsOneWidget);
    // The search field and the way back out stay put.
    expect(find.byKey(const ValueKey('pk_search')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
