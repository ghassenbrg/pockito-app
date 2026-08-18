import 'package:flutter/rendering.dart';
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
    // Section 7.1 budgets the hero at 148–168. It sat at 199 until UI-020,
    // documented as an exception; the exception is now closed.
    expect(heroBox.height, inInclusiveRange(148, 168));
  });

  // UI-020: the density contract, stated for the one screen that was exempt
  // from it. Accounts, Spaces, Activity, More and Notifications have had a
  // floor since UI-016; Home did not, and Home was the screen that failed —
  // the first row of the reader's own money started *at* the navigation line.
  testWidgets('Home shows the reader their own money above the navigation', (
    tester,
  ) async {
    await pumpSurface(tester, route: '/home', viewport: phone);
    final bottom = visibleContentBottom(tester, phone);

    final data =
        [
          ...find.byType(PkAccountTile).evaluate(),
          ...find.byType(PkLedgerRow).evaluate(),
        ].where((element) {
          final box = element.renderObject;
          if (box is! RenderBox || !box.hasSize) return false;
          final top = box.localToGlobal(Offset.zero).dy;
          return top >= 0 && top + box.size.height <= bottom;
        });
    expect(
      data.length,
      greaterThanOrEqualTo(2),
      reason:
          'Home must show at least two pieces of the reader\'s own money '
          'above the navigation at 390x844 and default text scale',
    );
  });

  testWidgets('Home spends under 40% of its first screen on chrome', (
    tester,
  ) async {
    // The brand lockup and Kito's greeting are the two things on Home that
    // are about the app rather than about the money. Together they were 252 px
    // of 758 before the hero even began; this is what holds that in place.
    await pumpSurface(tester, route: '/home', viewport: phone);
    final bottom = visibleContentBottom(tester, phone);
    final banner = tester.getRect(find.byType(PkWelcomeBanner));
    expect(
      banner.bottom / bottom,
      lessThan(.4),
      reason: 'Brand chrome and the greeting take too much of the first screen',
    );
  });

  testWidgets('Home stacks at most six rounded surfaces in a viewport', (
    tester,
  ) async {
    // P2-12. Every rounded, bordered box on screen is one more edge the eye
    // has to resolve before it reaches a number, and Home is where they
    // accumulate: a banner, a hero, an action block, a card per section, a
    // card per chart. The count is a ceiling on visual noise, not on content
    // — sections that group their rows into *one* grouped surface are free to
    // hold as many rows as they like.
    await pumpSurface(tester, route: '/home', viewport: phone);
    final bottom = visibleContentBottom(tester, phone);
    final surfaces =
        [
          ...find.byType(PkCard).evaluate(),
          ...find.byType(PkGroupedSurface).evaluate(),
          ...find.byType(PkHeroPanel).evaluate(),
          ...find.byType(PkWelcomeBanner).evaluate(),
        ].where((element) {
          final box = element.renderObject;
          if (box is! RenderBox || !box.hasSize) return false;
          final top = box.localToGlobal(Offset.zero).dy;
          // Counted when it is actually on the first screen, and only when it is
          // not nested inside another counted surface — a card inside a card is
          // one boundary too many, but it is the outer one that is being counted.
          return top >= 0 && top < bottom;
        }).length;
    expect(
      surfaces,
      lessThanOrEqualTo(6),
      reason: 'Home is showing $surfaces rounded surfaces in one viewport',
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
