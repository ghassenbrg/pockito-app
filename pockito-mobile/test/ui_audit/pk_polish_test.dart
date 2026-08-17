import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-016: motion, haptics, privacy mode, and the shadow/radius consistency
/// the golden baselines lock in.
///
/// The goldens catch a *change*; these catch the rules a change would have to
/// break, so a failure says what went wrong rather than "these pixels differ".
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  group('privacy mode (2.4, 5.9)', () {
    testWidgets('masking preserves the layout exactly', (tester) async {
      // The point of a mask that keeps its width is that nothing moves when
      // privacy goes on — otherwise the switch itself is a tell.
      final repo = MockPockitoRepository();
      await pumpSurface(
        tester,
        route: '/accounts',
        viewport: phone,
        repository: repo,
      );
      final before = [
        for (final element in find.byType(PkAccountTile).evaluate())
          (element.renderObject! as RenderBox).size,
      ];
      expect(before, isNotEmpty);

      await repo.saveProfile(repo.profile.copyWith(balancesHidden: true));
      await tester.pumpAndSettle();

      final after = [
        for (final element in find.byType(PkAccountTile).evaluate())
          (element.renderObject! as RenderBox).size,
      ];
      expect(after, equals(before), reason: 'Privacy mode reflowed the list');
    });

    testWidgets('a hidden balance shows no digits and says why', (
      tester,
    ) async {
      final repo = MockPockitoRepository();
      await repo.saveProfile(repo.profile.copyWith(balancesHidden: true));
      final handle = tester.ensureSemantics();
      await pumpSurface(
        tester,
        route: '/accounts',
        viewport: phone,
        repository: repo,
      );

      for (final element in find.byType(PkAmountText).evaluate()) {
        final text = find.descendant(
          of: find.byWidget(element.widget),
          matching: find.byType(Text),
        );
        for (final node in text.evaluate()) {
          final value = (node.widget as Text).data ?? '';
          expect(
            RegExp(r'[0-9]').hasMatch(value),
            isFalse,
            reason: 'A masked balance still shows digits: "$value"',
          );
        }
      }
      expect(find.bySemanticsLabel('Balance hidden'), findsWidgets);
      handle.dispose();
    });
  });

  group('motion (4.8)', () {
    test('the durations match the strategy', () {
      expect(PkMotion.fast.inMilliseconds, 150);
      expect(PkMotion.standard.inMilliseconds, inInclusiveRange(200, 250));
      expect(PkMotion.slow.inMilliseconds, inInclusiveRange(300, 350));
    });
  });

  group('haptics (P2-1)', () {
    test('one preference silences every call', () {
      // `PkHaptics` is a no-op on a platform without haptics and when the
      // reader has turned them off, so a screen can ask for feedback without
      // checking first.
      PkHaptics.enabled = false;
      addTearDown(() => PkHaptics.enabled = true);
      expect(() {
        PkHaptics.selection();
        PkHaptics.success();
        PkHaptics.warning();
        PkHaptics.error();
      }, returnsNormally);
    });
  });

  group('surface consistency (9.2)', () {
    testWidgets('every card uses the standard radius', (tester) async {
      // "Standard card radius is 16; hero 20; sheet 24." A card that drew its
      // own radius is exactly the drift the token layer exists to prevent.
      for (final surface in pkSurfaceManifest) {
        await pumpSurface(
          tester,
          route: surface.route,
          viewport: phone,
          settle: !surface.skipGolden,
        );
        while (tester.takeException() != null) {}
        for (final element in find.byType(PkCard).evaluate()) {
          final material = find.descendant(
            of: find.byWidget(element.widget),
            matching: find.byType(Material),
          );
          if (material.evaluate().isEmpty) continue;
          final shape = (material.evaluate().first.widget as Material).shape;
          if (shape is! RoundedRectangleBorder) continue;
          final radius = shape.borderRadius.resolve(TextDirection.ltr).topLeft;
          expect(
            radius.x,
            PkRadius.card,
            reason: '${surface.id} has a card at ${radius.x}, not 16',
          );
        }
      }
    });

    test('only one shadow layer, and only where it is earned', () {
      // Section 5.4: do not combine a strong border and a strong shadow, and
      // keep raised content to a single restrained layer.
      expect(PkShadows.card(PkPalette.kitoNavy900), hasLength(1));
      expect(PkShadows.hero(PkPalette.kitoBlue700), hasLength(1));
      expect(PkShadows.none, isEmpty);
    });

    testWidgets('light and dark keep the same hierarchy', (tester) async {
      // Section 9.2: the two themes retain the same hierarchy, not merely
      // equivalent colours — so the type scale is identical in both and only
      // the surfaces differ.
      final light = PkTheme.light().extension<PkTypography>()!;
      final dark = PkTheme.dark().extension<PkTypography>()!;
      expect(light.moneyHero.fontSize, dark.moneyHero.fontSize);
      expect(light.screenTitle.fontSize, dark.screenTitle.fontSize);
      expect(light.rowTitle.fontWeight, dark.rowTitle.fontWeight);
      expect(
        PkSemanticColors.light.page,
        isNot(PkSemanticColors.dark.page),
        reason: 'The two themes must differ somewhere',
      );
    });
  });

  group('no sizing hacks remain in feature code (UI-016)', () {
    testWidgets('rows come from the shared foundation', (tester) async {
      // The acceptance criterion is "no component-specific sizing hacks remain
      // in feature code". The observable form: the primary list screens build
      // their rows from `PkLedgerRow`, so their geometry is one contract.
      for (final route in const [
        '/accounts',
        '/spaces',
        '/activity',
        '/more',
        '/notifications',
        '/categories',
        '/tags',
        '/payment-methods',
        '/subscriptions',
        '/budgets',
      ]) {
        await pumpSurface(tester, route: route, viewport: phone);
        while (tester.takeException() != null) {}
        expect(
          find.byType(PkLedgerRow),
          findsWidgets,
          reason: '$route still builds its own rows',
        );
      }
    });
  });
}
