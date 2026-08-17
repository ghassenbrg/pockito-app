import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/app/pockito_app_view_model.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';
import 'package:provider/provider.dart';

/// The volumes the audit asks to be verified against: 25 Spaces, 50 members in
/// one Space, 500 expenses. A list that is pleasant with six rows and unusable
/// with five hundred has not been designed, only demonstrated.
void main() {
  late MockPockitoRepository repository;

  setUp(() {
    repository = MockPockitoRepository.stress();
  });

  Future<void> pump(WidgetTester tester, String route) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    appRouter.go(route);
    await tester.pumpWidget(PockitoBootstrap(repository: repository));
    await tester.pumpAndSettle();
  }

  test('the stress fixture really is at the target volumes', () {
    expect(repository.spaces.length, greaterThanOrEqualTo(25));
    expect(
      repository.spaceById('s_crowd')!.members.length,
      greaterThanOrEqualTo(50),
    );
    expect(repository.transactions.length, greaterThanOrEqualTo(500));
  });

  testWidgets('Activity pages instead of building the whole ledger', (
    tester,
  ) async {
    await pump(tester, '/activity');
    final viewModel = tester
        .element(find.byType(Scaffold).first)
        .read<PockitoAppViewModel>();

    expect(viewModel.filteredTransactions.length, greaterThan(500));
    // Only a page is materialised, however long the history is.
    expect(
      viewModel.activityGroups.values.fold<int>(
        0,
        (sum, rows) => sum + rows.length,
      ),
      PockitoAppViewModel.pageSize,
    );
    expect(viewModel.hasMoreActivity, isTrue);
    // The control sits past a page of rows, so reaching it is part of what is
    // being checked.
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('activity_show_more')),
      600,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 200,
    );
    expect(find.byKey(const ValueKey('activity_show_more')), findsOneWidget);

    viewModel.showMoreActivity();
    await tester.pumpAndSettle();
    expect(
      viewModel.activityGroups.values.fold<int>(
        0,
        (sum, rows) => sum + rows.length,
      ),
      PockitoAppViewModel.pageSize * 2,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('grouping is derived once, not on every read', (tester) async {
    await pump(tester, '/activity');
    final viewModel = tester
        .element(find.byType(Scaffold).first)
        .read<PockitoAppViewModel>();
    // Identical instance means the work was memoised rather than repeated,
    // which is what stops a long list regrouping itself on every frame.
    expect(
      identical(viewModel.activityGroups, viewModel.activityGroups),
      isTrue,
    );
    viewModel.setActivityQuery('sample');
    expect(
      identical(viewModel.activityGroups, viewModel.activityGroups),
      isTrue,
    );
  });

  testWidgets('25 Spaces stay searchable and sortable', (tester) async {
    await pump(tester, '/spaces');
    expect(find.byKey(const ValueKey('search_spaces')), findsOneWidget);
    expect(find.byKey(const ValueKey('sort_spaces')), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('search_spaces')),
      'Office',
    );
    await tester.pumpAndSettle();
    expect(find.text('Office lunch club'), findsOneWidget);
    expect(find.text('Tokyo Trip'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('a 50-member Space stays searchable', (tester) async {
    await pump(tester, '/spaces/s_crowd/members');
    expect(find.byKey(const ValueKey('pk_search')), findsOneWidget);

    await tester.enterText(find.byKey(const ValueKey('pk_search')), 'Member 4');
    await tester.pumpAndSettle();
    // The list narrows to the matches; the field itself also holds the text,
    // so the check is that non-matching members are gone.
    expect(find.byKey(const ValueKey('member_u_crowd_3')), findsOneWidget);
    expect(find.byKey(const ValueKey('member_u_crowd_11')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every primary surface renders at these volumes', (tester) async {
    for (final route in const [
      '/home',
      '/accounts',
      '/spaces',
      '/more',
      '/activity',
      '/budgets',
      '/subscriptions',
      '/categories',
      '/spaces/s_crowd',
      '/spaces/s_crowd/members',
    ]) {
      await pump(tester, route);
      expect(tester.takeException(), isNull, reason: 'Failed at $route');
    }
  });

  test('settle-up planning stays linear in the number of members', () {
    // The simplified plan must not grow quadratically: with 50 members the
    // worst case is one payment per member, never one per pair.
    final space = repository.spaceById('s_crowd')!;
    final plan = repository.settlementRecommendations(space.id);
    expect(plan.length, lessThanOrEqualTo(space.members.length));
  });

  test('search across everything stays bounded', () {
    final hits = PockitoAppViewModel(repository: repository).search('sample');
    // A query matching hundreds of rows returns a readable page, not all of
    // them.
    expect(hits.length, lessThanOrEqualTo(40));
    expect(hits.where((hit) => hit.kind == 'Activity').length, 25);
  });
}
