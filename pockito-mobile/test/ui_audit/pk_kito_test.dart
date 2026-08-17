import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-012 and D-08: Kito's contextual size and frequency budget.
///
/// Kito is the thing Life OS has no answer to, and the way to keep him one is
/// to spend him where he earns his place. These are the limits section 4.5
/// sets, checked against what actually renders rather than against intent.
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  /// Every piece of Kito artwork on screen, with its rendered extent.
  List<double> kitoExtents(WidgetTester tester) => [
    for (final element in find.byType(KitoImage).evaluate())
      if (element.renderObject case final RenderBox box)
        if (box.hasSize && !box.size.isEmpty) box.size.width,
  ];

  testWidgets('the size budget holds on every surface', (tester) async {
    final oversized = <String>[];
    for (final surface in pkSurfaceManifest) {
      await pumpSurface(
        tester,
        route: surface.route,
        viewport: phone,
        settle: !surface.skipGolden,
      );
      while (tester.takeException() != null) {}
      for (final extent in kitoExtents(tester)) {
        // The largest moment section 4.5 allows anywhere is the onboarding
        // hero at 180. Nothing may exceed it.
        if (extent > KitoSize.onboarding.budget.max) {
          oversized.add('${surface.id}: ${extent.toStringAsFixed(0)} px');
        }
      }
    }
    expect(
      oversized,
      isEmpty,
      reason:
          'Kito exceeds his largest allowance:\n  ${oversized.join('\n  ')}',
    );
  });

  testWidgets('routine screens reserve no more than 64 px for Kito', (
    tester,
  ) async {
    // D-08: "no routine screen reserves >64 px for Kito without an explicit
    // large-state reason". These are the routine surfaces — populated lists
    // and dashboards, where a full-screen state is not in play.
    const routine = [
      '/home',
      '/accounts',
      '/spaces',
      '/more',
      '/activity',
      '/budgets',
      '/subscriptions',
      '/categories',
      '/ai',
      '/notifications',
    ];
    final oversized = <String>[];
    for (final route in routine) {
      await pumpSurface(tester, route: route, viewport: phone);
      while (tester.takeException() != null) {}
      for (final extent in kitoExtents(tester)) {
        if (extent > KitoSize.insight.budget.max) {
          oversized.add('$route: ${extent.toStringAsFixed(0)} px');
        }
      }
    }
    expect(
      oversized,
      isEmpty,
      reason:
          'A routine screen gives Kito a large-state allowance:\n'
          '  ${oversized.join('\n  ')}',
    );
  });

  testWidgets('no viewport shows more than one Kito', (tester) async {
    // Section 4.5: one instance per viewport. Two mascots in one screen read
    // as decoration rather than as a voice.
    final crowded = <String>[];
    for (final surface in pkSurfaceManifest) {
      await pumpSurface(
        tester,
        route: surface.route,
        viewport: phone,
        settle: !surface.skipGolden,
      );
      while (tester.takeException() != null) {}
      final bottom = visibleContentBottom(tester, phone);
      // A `PageView` lays its neighbours out beside the current page, so
      // visibility is a question about both axes, not just the vertical one.
      final viewport = Rect.fromLTWH(0, 0, phone.size.width, bottom);
      var visible = 0;
      for (final element in find.byType(KitoImage).evaluate()) {
        final box = element.renderObject;
        if (box is! RenderBox || !box.hasSize || box.size.isEmpty) continue;
        // The app icon is a brand mark, not an appearance by the character.
        if ((element.widget as KitoImage).asset == KitoAsset.appIcon) continue;
        final rect = box.localToGlobal(Offset.zero) & box.size;
        if (!rect.intersect(viewport).isEmpty) visible++;
      }
      if (visible > 1) crowded.add('${surface.id}: $visible');
    }
    expect(
      crowded,
      isEmpty,
      reason: 'More than one Kito in a viewport:\n  ${crowded.join('\n  ')}',
    );
  });

  testWidgets('the named sizes stay inside their own budgets', (tester) async {
    // The enum is the contract; this stops a value drifting out of the band
    // the audit set for its moment.
    for (final size in KitoSize.values) {
      expect(
        size.extent,
        inInclusiveRange(size.budget.min, size.budget.max),
        reason: '${size.name} is outside section 4.5',
      );
    }
  });

  testWidgets('a short screen compacts Kito before the financial data', (
    tester,
  ) async {
    // Section 4.5: "Hide or compact Kito before shrinking financial data on
    // short screens." Landscape phone is the case that proves it.
    const landscape = PkViewport(name: '844x390', size: Size(844, 390));
    await pumpSurface(tester, route: '/spaces', viewport: landscape);
    while (tester.takeException() != null) {}
    for (final extent in kitoExtents(tester)) {
      expect(
        extent,
        lessThanOrEqualTo(KitoSize.insight.budget.max),
        reason: 'Kito kept his full size on a short screen',
      );
    }
    // …while the balances are still there at full size.
    expect(find.byType(PkAmountText), findsWidgets);
  });
}
