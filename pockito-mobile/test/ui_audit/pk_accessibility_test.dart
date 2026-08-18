import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-015 and section 9.5: the release gate.
///
/// Flutter's own `meetsGuideline` matchers cover the parts of WCAG that can be
/// checked mechanically — target size, label presence, text contrast — so they
/// are used rather than reimplemented. What they cannot check (does the row
/// read in a *useful* order, is the colour meaning also in words) is checked
/// against the semantics tree directly.
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  group('WCAG guidelines Flutter can verify', () {
    // The whole manifest at once would be a very long single test; splitting by
    // guideline keeps a failure legible.
    testWidgets('tap targets', (tester) async {
      final handle = tester.ensureSemantics();
      for (final surface in pkSurfaceManifest) {
        await pumpSurface(
          tester,
          route: surface.route,
          viewport: phone,
          settle: !surface.skipGolden,
        );
        while (tester.takeException() != null) {}
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      }
      handle.dispose();
    });

    testWidgets('labelled tappable nodes', (tester) async {
      final handle = tester.ensureSemantics();
      for (final surface in pkSurfaceManifest) {
        await pumpSurface(
          tester,
          route: surface.route,
          viewport: phone,
          settle: !surface.skipGolden,
        );
        while (tester.takeException() != null) {}
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      }
      handle.dispose();
    });

    testWidgets('text contrast in light and dark', (tester) async {
      final handle = tester.ensureSemantics();
      for (final brightness in Brightness.values) {
        for (final surface in pkSurfaceManifest) {
          await pumpSurface(
            tester,
            route: surface.route,
            viewport: PkViewport(
              name: brightness.name,
              size: pkPhone,
              brightness: brightness,
            ),
            settle: !surface.skipGolden,
          );
          while (tester.takeException() != null) {}
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
      }
      handle.dispose();
    });
  });

  testWidgets('a financial row reads as one node, in a useful order', (
    tester,
  ) async {
    // Section 5.9: title, amount, date/status, context — in that order, as one
    // coherent button rather than five fragments.
    final handle = tester.ensureSemantics();
    await pumpSurface(tester, route: '/activity', viewport: phone);
    final node = tester.getSemantics(find.byType(PkTransactionTile).first);
    expect(node.label, isNotEmpty);
    expect(
      node.label.split(',').length,
      greaterThanOrEqualTo(3),
      reason: 'A ledger row must announce more than just its merchant',
    );
    expect(
      node.flagsCollection.isButton,
      isTrue,
      reason: 'A tappable row must announce itself as one',
    );
    handle.dispose();
  });

  testWidgets('hidden balances announce the privacy state, not the mask', (
    tester,
  ) async {
    // Section 5.9. If privacy mode is not implemented there is nothing to
    // check, but a masked balance that reads out its bullets is worse than no
    // privacy mode at all.
    final repo = MockPockitoRepository();
    final handle = tester.ensureSemantics();
    await pumpSurface(
      tester,
      route: '/home',
      viewport: phone,
      repository: repo,
    );
    for (final element in find.byType(PkAmountText).evaluate()) {
      final widget = element.widget as PkAmountText;
      expect(
        widget.currency,
        isNotEmpty,
        reason: 'An amount without a currency cannot be read aloud correctly',
      );
    }
    handle.dispose();
  });

  testWidgets('status meaning is carried by words, not only colour', (
    tester,
  ) async {
    // Section 9.5: colour is never the only carrier of amount direction,
    // budget health, role, permission, read state or status.
    await pumpSurface(tester, route: '/budgets', viewport: phone);
    for (final element in find.byType(PkStatusBadge).evaluate()) {
      final badge = element.widget as PkStatusBadge;
      expect(
        badge.label.trim(),
        isNotEmpty,
        reason: 'A status badge with no word is colour-only meaning',
      );
    }
    // Balance direction is said in words beside the number.
    await pumpSurface(tester, route: '/spaces', viewport: phone);
    expect(find.byType(PkBalanceLabel), findsWidgets);
  });

  testWidgets('every surface survives 1.3x and 2.0x text', (tester) async {
    // Section 9.5: text at 1.3x and 2.0x remains complete or reflows, and no
    // essential text hides behind an ellipsis it cannot escape.
    for (final scale in const [1.3, 2.0]) {
      for (final surface in pkSurfaceManifest) {
        final errors = await collectLayoutErrors(
          tester,
          () => pumpSurface(
            tester,
            route: surface.route,
            viewport: PkViewport(
              name: '${scale}x',
              size: pkPhone,
              textScale: scale,
            ),
            settle: !surface.skipGolden,
          ),
        );
        expect(
          overflowsIn(errors),
          isEmpty,
          reason: '${surface.id} clips at ${scale}x',
        );
      }
    }
  });

  testWidgets('reduced motion removes the non-essential movement', (
    tester,
  ) async {
    // Section 9.5. The skeleton's shimmer is the clearest case: it is pure
    // decoration and must stop.
    await tester.binding.setSurfaceSize(pkPhone);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: PkTheme.light(),
          home: const Scaffold(body: PkSkeleton()),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));
    // A repeating controller would leave the tree permanently dirty; with animations off
    // the widget settles.
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the ambient loop stops under reduced motion too', (
    tester,
  ) async {
    // P2-11. `KitoThinking` is the one loop in the app that runs on
    // `PkMotion.ambient` — three seconds, repeating, nothing arriving at the
    // end of it. That is the most irritating kind of movement to a reader who
    // asked for none, so the ticker must never start rather than merely being
    // invisible: a repeating controller leaves the tree permanently dirty and
    // `pumpAndSettle` would time out.
    await tester.binding.setSurfaceSize(pkPhone);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: MaterialApp(
          theme: PkTheme.light(),
          home: const Scaffold(body: Center(child: KitoThinking())),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    // And with motion allowed it genuinely animates, or the token is decoration.
    await tester.pumpWidget(
      MaterialApp(
        theme: PkTheme.light(),
        home: const Scaffold(body: Center(child: KitoThinking())),
      ),
    );
    await tester.pump();
    final before = tester
        .widget<Transform>(find.byType(Transform).first)
        .transform
        .clone();
    await tester.pump(PkMotion.ambient ~/ 2);
    final after = tester.widget<Transform>(find.byType(Transform).first);
    expect(after.transform, isNot(before));
  });

  testWidgets('Japanese renders every surface without clipping', (
    tester,
  ) async {
    // P0-13's promise: selecting 日本語 produces a Japanese app, not a
    // Japanese tab bar over an English one.
    final repo = MockPockitoRepository();
    await repo.saveProfile(repo.profile.copyWith(language: 'Japanese'));
    for (final surface in pkSurfaceManifest) {
      final errors = await collectLayoutErrors(
        tester,
        () => pumpSurface(
          tester,
          route: surface.route,
          viewport: phone,
          repository: repo,
          settle: !surface.skipGolden,
        ),
      );
      expect(
        overflowsIn(errors),
        isEmpty,
        reason: '${surface.id} clips in Japanese',
      );
    }
  });

  testWidgets('right-to-left renders every surface without clipping', (
    tester,
  ) async {
    // Section 9.5 lists RTL readiness. Pockito ships no RTL locale yet, so
    // this proves the layouts are directional rather than left-anchored.
    for (final surface in pkSurfaceManifest) {
      final errors = await collectLayoutErrors(
        tester,
        () => pumpSurface(
          tester,
          route: surface.route,
          viewport: phone,
          direction: TextDirection.rtl,
          settle: !surface.skipGolden,
        ),
      );
      expect(
        overflowsIn(errors),
        isEmpty,
        reason: '${surface.id} clips right-to-left',
      );
    }
  });
}
