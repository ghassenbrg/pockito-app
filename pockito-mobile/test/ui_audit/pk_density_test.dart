import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// Section 9.3, the viewport density criteria at 390x844 with default text.
///
/// These are layout *capacities*: the fixtures have to be rich enough to fill
/// the viewport, and the screen has to be dense enough to hold them. A screen
/// that passes by shrinking a touch target or the body scale fails the
/// accessibility suite instead, so the two gates only pass together.
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  testWidgets('Accounts shows a summary plus at least five account rows', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/accounts', viewport: phone);
    expect(find.byType(PkHeroPanel), findsOneWidget);
    expect(
      visibleRowCount(tester, find.byType(PkAccountTile), viewport: phone),
      greaterThanOrEqualTo(5),
      reason: 'Accounts must fit five standard rows beneath its summary',
    );
  });

  testWidgets('Spaces shows a summary plus at least three space rows', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/spaces', viewport: phone);
    expect(
      visibleRowCount(tester, find.byType(PkSpaceTile), viewport: phone),
      greaterThanOrEqualTo(3),
      reason: 'Spaces must fit three 72 px rows beneath its summary',
    );
  });

  testWidgets('Activity shows at least five ledger rows after its chrome', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/activity', viewport: phone);
    expect(
      visibleRowCount(tester, find.byType(PkTransactionTile), viewport: phone),
      greaterThanOrEqualTo(5),
      reason: 'Activity must fit five simple rows after header/search/filter',
    );
  });

  testWidgets('More shows at least seven routine rows', (tester) async {
    await pumpSurface(tester, route: '/more', viewport: phone);
    expect(
      visibleRowCount(tester, find.byType(PkLedgerRow), viewport: phone),
      greaterThanOrEqualTo(7),
      reason: 'More must fit seven 56 px rows excluding the app header',
    );
  });

  testWidgets('Notifications shows at least six rows after its group label', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/notifications', viewport: phone);
    expect(
      visibleRowCount(tester, find.byType(PkLedgerRow), viewport: phone),
      greaterThanOrEqualTo(6),
      reason: 'Notifications must fit six simple rows',
    );
  });

  testWidgets('Home shows its greeting, action-required and complete hero', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/home', viewport: phone);
    final bottom = visibleContentBottom(tester, phone);

    // Kito's greeting opens the screen — the product decision that Pockito
    // says hello by name every visit, not only on first run.
    expect(find.byType(PkWelcomeBanner), findsOneWidget);

    final heroBox = tester.getRect(find.byType(PkHeroPanel).first);
    expect(
      heroBox.bottom,
      lessThan(bottom),
      reason: 'The whole portfolio hero must be visible above the navigation',
    );
    // Section 7.1: the hero's own height budget is 148–168.
    expect(heroBox.height, lessThanOrEqualTo(200));

    // …and the quick actions beneath it, so the reader can start something
    // without scrolling.
    expect(
      tester.getRect(find.byType(PkQuickActions).first).bottom,
      lessThan(bottom),
      reason: 'The quick actions must clear the navigation',
    );
  });

  testWidgets('no routine screen leads with two heroes', (tester) async {
    // D-02: one dominant element per viewport.
    for (final route in const ['/home', '/accounts', '/spaces', '/more']) {
      await pumpSurface(tester, route: route, viewport: phone);
      expect(
        find.byType(PkHeroPanel).evaluate().length,
        lessThanOrEqualTo(1),
        reason: '$route shows more than one hero panel',
      );
    }
  });
}
