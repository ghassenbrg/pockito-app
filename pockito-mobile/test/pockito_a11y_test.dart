import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';

/// The checks the audit asks for that are about who can use the app, not about
/// what it can do: reading direction, contrast-independent meaning, tap
/// targets, and both themes.
void main() {
  const routes = [
    '/home',
    '/accounts',
    '/spaces',
    '/more',
    '/activity',
    '/budgets',
    '/subscriptions',
    '/categories',
    '/tags',
    '/payment-methods',
    '/data',
    '/notifications',
    '/search',
    '/settings/notifications',
    '/spaces/s_flat',
    '/spaces/s_flat/members',
    '/spaces/s_flat/settings',
    '/spaces/s_flat/activity',
    '/accounts/a_rev',
    '/budgets/b_gro',
  ];

  Future<void> pump(
    WidgetTester tester, {
    required String route,
    TextDirection direction = TextDirection.ltr,
    Brightness brightness = Brightness.light,
    double textScale = 1,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockPockitoRepository();
    appRouter.go(route);
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          platformBrightness: brightness,
          textScaler: TextScaler.linear(textScale),
        ),
        child: Directionality(
          textDirection: direction,
          child: PockitoBootstrap(repository: repository),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('every primary surface survives right-to-left', (tester) async {
    for (final route in routes) {
      await pump(tester, route: route, direction: TextDirection.rtl);
      expect(tester.takeException(), isNull, reason: 'RTL failed at $route');
    }
  });

  testWidgets('every primary surface renders in dark mode', (tester) async {
    for (final route in routes) {
      await pump(tester, route: route, brightness: Brightness.dark);
      expect(tester.takeException(), isNull, reason: 'Dark failed at $route');
    }
  });

  testWidgets('every primary surface survives larger text', (tester) async {
    for (final route in routes) {
      await pump(tester, route: route, textScale: 1.3);
      expect(
        tester.takeException(),
        isNull,
        reason: 'Text scaling failed at $route',
      );
    }
  });

  testWidgets('icon-only controls carry a label for screen readers', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    for (final route in routes) {
      await pump(tester, route: route);
      for (final element in find.byType(IconButton).evaluate()) {
        final button = element.widget as IconButton;
        final labelled =
            (button.tooltip != null && button.tooltip!.isNotEmpty) ||
            find
                .descendant(
                  of: find.byWidget(button),
                  matching: find.byType(Semantics),
                )
                .evaluate()
                .isNotEmpty;
        expect(
          labelled,
          isTrue,
          reason: 'An icon-only button on $route has no label',
        );
      }
    }
    handle.dispose();
  });

  testWidgets('primary tap targets stay reachable', (tester) async {
    final handle = tester.ensureSemantics();
    await pump(tester, route: '/home');
    // Scoped to the bar: Home's own section headers use the same words.
    for (final label in const ['Home', 'Accounts', 'Spaces', 'More']) {
      final size = tester.getSize(
        find.descendant(
          of: find.byType(PkBottomNav),
          matching: find.bySemanticsLabel(label),
        ),
      );
      expect(size.width, greaterThanOrEqualTo(48), reason: '$label too narrow');
      expect(size.height, greaterThanOrEqualTo(48), reason: '$label too short');
    }
    handle.dispose();
  });
}
