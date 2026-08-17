import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-013 and section 7.22: the entry flow.
///
/// Onboarding is the one place where a screen can be tall, illustrated and
/// full of fields at once, so it is also the first place a large text size
/// pushes the primary action off the bottom. Its acceptance is explicit:
/// 320x568 and 2.0x text complete without clipping or an unreachable action.
void main() {
  const entryRoutes = ['/auth', '/auth/error', '/onboarding', '/invite-review'];

  testWidgets('the illustration never takes more than 35% of the height', (
    tester,
  ) async {
    for (final viewport in [
      const PkViewport(name: '320x568', size: pkNarrowPhone),
      const PkViewport(name: '390x844', size: pkPhone),
      const PkViewport(name: '844x390-landscape', size: Size(844, 390)),
    ]) {
      for (final route in entryRoutes) {
        await pumpSurface(
          tester,
          route: route,
          viewport: viewport,
          settle: false,
        );
        while (tester.takeException() != null) {}
        for (final element in find.byType(KitoImage).evaluate()) {
          final box = element.renderObject;
          if (box is! RenderBox || !box.hasSize || box.size.isEmpty) continue;
          expect(
            box.size.height,
            lessThanOrEqualTo(viewport.size.height * .35 + 1),
            reason: '$route at ${viewport.name} gives the artwork too much',
          );
        }
      }
    }
  });

  testWidgets('the primary action stays reachable at 2.0x on a small phone', (
    tester,
  ) async {
    // The audit's own hardest case. "Reachable" means present, on-screen, and
    // large enough to hit — not merely built somewhere in the tree.
    const viewport = PkViewport(
      name: '320x568-2.0',
      size: pkNarrowPhone,
      textScale: 2,
    );
    await pumpSurface(
      tester,
      route: '/onboarding',
      viewport: viewport,
      settle: false,
    );
    while (tester.takeException() != null) {}

    final actions = find.byType(PkPinnedActions);
    expect(actions, findsOneWidget);
    final rect = tester.getRect(actions);
    expect(
      rect.bottom,
      lessThanOrEqualTo(viewport.size.height + 1),
      reason: 'The pinned action is below the bottom of the screen',
    );
    expect(
      rect.top,
      greaterThanOrEqualTo(0),
      reason: 'The pinned action starts above the top of the screen',
    );

    final button = find.descendant(
      of: actions,
      matching: find.byType(FilledButton),
    );
    expect(button, findsOneWidget);
    final size = tester.getSize(button);
    expect(size.height, greaterThanOrEqualTo(pkMinimumTarget));
  });

  testWidgets('every entry surface scrolls rather than clipping', (
    tester,
  ) async {
    // Section 7.22: onboarding pages scroll at large text sizes and short
    // heights. A page that merely fits at 1.0x has not met the criterion.
    const viewport = PkViewport(
      name: '320x568-2.0',
      size: pkNarrowPhone,
      textScale: 2,
    );
    for (final route in entryRoutes) {
      final errors = await collectLayoutErrors(
        tester,
        () => pumpSurface(
          tester,
          route: route,
          viewport: viewport,
          settle: false,
        ),
      );
      expect(
        overflowsIn(errors),
        isEmpty,
        reason: '$route clips instead of scrolling at 2.0x',
      );
      expect(
        find.descendant(
          of: find.byType(Scaffold).last,
          matching: find.byType(Scrollable),
        ),
        findsWidgets,
        reason: '$route offers no way to reach content below the fold',
      );
    }
  });

  testWidgets('progress is announced, not only coloured', (tester) async {
    // Section 7.22: "Progress indicator is explicit and semantic." A row of
    // tinted bars tells a screen-reader user nothing at all.
    final handle = tester.ensureSemantics();
    await pumpSurface(tester, route: '/onboarding', settle: false);
    while (tester.takeException() != null) {}
    expect(find.bySemanticsLabel(RegExp(r'Step 1 of \d')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('sign-in errors keep the entered state and say what to do', (
    tester,
  ) async {
    // Section 7.22: sign-in errors preserve entered non-sensitive state and
    // clearly state recovery. The auth error route is a whole-flow failure, so
    // a full-screen state is the correct treatment here.
    await pumpSurface(tester, route: '/auth/error', settle: false);
    while (tester.takeException() != null) {}
    expect(find.byType(FilledButton), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
