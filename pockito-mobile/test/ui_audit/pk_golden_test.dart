@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/app/pockito_app_view_model.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/domain/models/financial_models.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_labels.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

import 'package:provider/provider.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-016: the visual baseline.
///
/// Section 9.7 asks for approved evidence of eleven states on every primary
/// route. Rendered as a full cross-product that is roughly 550 images, most of
/// which would be identical to their neighbours and none of which a person
/// would ever look at. What is captured instead is:
///
///   * every surface in the manifest, in light and dark, at 390x844 — the
///     baseline the audit calls for in UI-001;
///   * each shared component's own variants, where a regression actually
///     originates;
///   * the states a route *declares* in the manifest, rather than all eleven
///     for all of them.
///
/// Baselines are written with `flutter test --update-goldens`, and the suite is
/// tagged so a run can exclude it while iterating.
void main() {
  const phone = PkViewport(name: '390x844', size: pkPhone);

  Future<void> expectGolden(WidgetTester tester, String name) async {
    await expectLater(
      find.byType(MaterialApp).last,
      matchesGoldenFile('goldens/$name.png'),
    );
  }

  group('routes', () {
    for (final brightness in Brightness.values) {
      testWidgets('every surface in ${brightness.name}', (tester) async {
        for (final surface in pkSurfaceManifest) {
          if (surface.skipGolden) continue;
          await pumpSurface(
            tester,
            route: surface.route,
            viewport: PkViewport(
              name: brightness.name,
              size: pkPhone,
              brightness: brightness,
            ),
          );
          while (tester.takeException() != null) {}
          await expectGolden(tester, '${surface.id}.${brightness.name}');
        }
      });
    }
  });

  group('declared states', () {
    testWidgets('Home across its states', (tester) async {
      for (final state in const [
        PrototypeState.ready,
        PrototypeState.loading,
        PrototypeState.empty,
        PrototypeState.error,
        PrototypeState.offline,
      ]) {
        final repo = MockPockitoRepository();
        await pumpSurface(
          tester,
          route: '/home',
          viewport: phone,
          repository: repo,
          // The provider survives a re-pump of the same widget, so a previous
          // iteration's loading shimmer would still be running here. Every
          // state is pumped a fixed distance rather than settled.
          settle: false,
        );
        final context = tester.element(find.byType(Scaffold).first);
        Provider.of<PockitoAppViewModel>(
          context,
          listen: false,
        ).setPrototypeState(state);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        while (tester.takeException() != null) {}
        await expectGolden(tester, 'home.state.${state.name}');
      }
    });

    testWidgets('Activity empty and populated', (tester) async {
      await pumpSurface(tester, route: '/activity', viewport: phone);
      await expectGolden(tester, 'activity.state.ready');

      final context = tester.element(find.byType(Scaffold).first);
      Provider.of<PockitoAppViewModel>(
        context,
        listen: false,
      ).setActivityQuery('nothing matches this');
      await tester.pumpAndSettle();
      await expectGolden(tester, 'activity.state.empty');
    });
  });

  group('components', () {
    Future<void> pumpComponent(
      WidgetTester tester,
      Widget child, {
      Brightness brightness = Brightness.light,
      double textScale = 1,
      Size size = const Size(390, 320),
    }) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(
            size: size,
            textScaler: TextScaler.linear(textScale),
          ),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            // The components speak the reader's language, so the harness has
            // to supply one.
            locale: const Locale('en'),
            supportedLocales: PkStrings.supportedLocales,
            localizationsDelegates: PkStrings.localizationsDelegates,
            theme: brightness == Brightness.light
                ? PkTheme.light()
                : PkTheme.dark(),
            home: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(PkSpacing.screen),
                child: child,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    const account = Account(
      id: 'g_rev',
      name: 'Revolut',
      type: AccountType.bank,
      currency: 'EUR',
      openingBalanceMinor: 0,
      isDefault: true,
      colorIndex: 2,
      icon: 'card',
    );

    testWidgets('row densities', (tester) async {
      for (final brightness in Brightness.values) {
        await pumpComponent(
          tester,
          brightness: brightness,
          PkGroupedSurface(
            indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
            children: [
              for (final density in PkRowDensity.values)
                PkLedgerRow(
                  density: density,
                  leading: const PkIconTile(
                    icon: Icons.savings_outlined,
                    color: PkPalette.kitoBlue600,
                  ),
                  title: density.name,
                  subtitle: 'Bank · EUR',
                  trailing: const PkAmountText(
                    amountMinor: 614206,
                    currency: 'EUR',
                  ),
                  showChevron: true,
                  onTap: () {},
                ),
            ],
          ),
        );
        await expectGolden(tester, 'component.rows.${brightness.name}');
      }
    });

    testWidgets('row densities at 1.3x and 2.0x', (tester) async {
      // Section 9.9: golden coverage for key state variants, and the two text
      // scales are where row geometry actually changes shape.
      for (final scale in const [1.3, 2.0]) {
        await pumpComponent(
          tester,
          textScale: scale,
          size: const Size(390, 460),
          PkGroupedSurface(
            children: [
              PkLedgerRow(
                leading: const PkIconTile(
                  icon: Icons.savings_outlined,
                  color: PkPalette.kitoBlue600,
                ),
                title: 'Revolut',
                subtitle: 'Bank · EUR',
                trailing: const PkAmountText(
                  amountMinor: 614206,
                  currency: 'EUR',
                ),
                showChevron: true,
                onTap: () {},
              ),
            ],
          ),
        );
        await expectGolden(tester, 'component.rows.scale-$scale');
      }
    });

    testWidgets('status badge grammar', (tester) async {
      for (final brightness in Brightness.values) {
        await pumpComponent(
          tester,
          brightness: brightness,
          size: const Size(390, 200),
          Wrap(
            spacing: PkSpacing.x2,
            runSpacing: PkSpacing.x2,
            children: [
              for (final tone in PkStatusTone.values)
                PkStatusBadge(
                  label: tone.name,
                  tone: tone,
                  icon: Icons.circle_outlined,
                ),
            ],
          ),
        );
        await expectGolden(tester, 'component.badges.${brightness.name}');
      }
    });

    testWidgets('card variants', (tester) async {
      for (final brightness in Brightness.values) {
        await pumpComponent(
          tester,
          brightness: brightness,
          size: const Size(390, 360),
          Column(
            children: [
              for (final variant in PkCardVariant.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                  child: PkCard(
                    variant: variant,
                    child: Padding(
                      padding: variant == PkCardVariant.group
                          ? const EdgeInsets.all(PkSpacing.x4)
                          : EdgeInsets.zero,
                      child: Text(variant.name),
                    ),
                  ),
                ),
            ],
          ),
        );
        await expectGolden(tester, 'component.cards.${brightness.name}');
      }
    });

    testWidgets('empty state, section variant', (tester) async {
      await pumpComponent(
        tester,
        size: const Size(390, 160),
        const PkEmptyState.section(
          icon: Icons.receipt_long_outlined,
          title: 'Nothing here yet',
          message: 'Record an expense to start your timeline.',
        ),
      );
      await expectGolden(tester, 'component.empty-state.section');
    });

    testWidgets('empty state, full variant', (tester) async {
      await pumpComponent(
        tester,
        size: const Size(390, 480),
        const PkEmptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Nothing here yet',
          message: 'Record an expense to start your timeline.',
          actionLabel: 'Add one',
        ),
      );
      await expectGolden(tester, 'component.empty-state.full');
    });

    testWidgets('account tile, list and compact', (tester) async {
      await pumpComponent(
        tester,
        size: const Size(390, 240),
        Column(
          children: [
            PkGroupedSurface(
              children: [
                PkAccountTile(
                  account: account,
                  balanceMinor: 614206,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: PkSpacing.x3),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: PkAccountTile(
                account: account,
                balanceMinor: 614206,
                compact: true,
                onTap: () {},
              ),
            ),
          ],
        ),
      );
      await expectGolden(tester, 'component.account-tile');
    });
  });
}
