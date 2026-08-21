import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/main.dart';
import 'package:pockito/l10n/app_localizations.dart';
import 'package:pockito/ui/core/components/pk_brand.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';

void main() {
  setUpAll(() async => initializeDateFormatting());

  test('the greeting follows the time of day', () async {
    final en = await PkStrings.delegate.load(const Locale('en'));
    String at(int hour) => pkGreeting(DateTime(2026, 8, 16, hour), en);

    expect(at(0), 'Good morning');
    expect(at(11), 'Good morning');
    expect(at(12), 'Good afternoon');
    expect(at(17), 'Good afternoon');
    expect(at(18), 'Good evening');
    expect(at(23), 'Good evening');
  });

  test('the greeting follows the reader language', () async {
    final ja = await PkStrings.delegate.load(const Locale('ja'));
    expect(pkGreeting(DateTime(2026, 8, 16, 9), ja), 'おはようございます');
    expect(pkGreeting(DateTime(2026, 8, 16, 14), ja), 'こんにちは');
    expect(pkGreeting(DateTime(2026, 8, 16, 21), ja), 'こんばんは');
  });

  test('the date is formatted for the reader locale', () {
    final date = DateTime(2026, 8, 16);
    expect(pkLongDate(date, 'en'), 'Sunday, August 16');
    // Japanese formats the same day differently, proving the locale is used.
    final japanese = pkLongDate(date, 'ja');
    expect(japanese, isNot('Sunday, August 16'));
    expect(japanese, contains('16'));
  });

  testWidgets('the Home header carries one wordmark and three actions', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(390, 844));
    appRouter.go('/home');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: PockitoBootstrap(repository: MockPockitoRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PkWordmark), findsOneWidget);
    expect(find.byType(PkIconAction), findsNWidgets(3));
    for (final action in const ['Search', 'Assistant', 'Notifications']) {
      expect(find.bySemanticsLabel(action), findsOneWidget, reason: action);
    }

    // Section 5.5 and D-04: the visible circle is 36, but the interactive
    // region around it is the full cross-platform 48.
    for (final action in const ['Search', 'Assistant', 'Notifications']) {
      final size = tester.getSize(find.bySemanticsLabel(action));
      expect(size.width, greaterThanOrEqualTo(PkSize.touch), reason: action);
      expect(size.height, greaterThanOrEqualTo(PkSize.touch), reason: action);
    }

    // Kito's greeting opens Home on every visit.
    expect(find.byType(PkWelcomeBanner), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the banner shows the profile name, not a fixed one', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(390, 844));
    final repository = MockPockitoRepository();
    await repository.saveProfile(
      repository.profile.copyWith(displayName: 'Amina'),
    );
    appRouter.go('/home');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(390, 844)),
        child: PockitoBootstrap(repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PkWelcomeBanner), findsOneWidget);
    expect(find.text('Amina'), findsWidgets);
    // Whatever today is, the banner shows it rather than a baked-in string.
    expect(find.text(pkLongDate(DateTime.now(), 'en')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('the banner survives a very long name and large text', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final size in const [Size(320, 568), Size(390, 844)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(
        MaterialApp(
          theme: PkTheme.light(),
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(1.8)),
            child: Scaffold(
              body: Padding(
                padding: EdgeInsets.all(PkSpacing.screen),
                child: PkWelcomeBanner(
                  greeting: 'Good afternoon',
                  name: 'Maximiliana Aleksandrovna Wojciechowska',
                  date: 'Wednesday, September 24',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'Failed at $size');
    }
  });

  testWidgets('the lockup follows the theme, ink on light, white on dark', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: PkTheme.light(),
          darkTheme: PkTheme.dark(),
          themeMode: mode,
          home: const Scaffold(body: Center(child: PkWordmark())),
        ),
      );
      await tester.pumpAndSettle();

      final picture = tester.widget<SvgPicture>(find.byType(SvgPicture));
      final loader = picture.bytesLoader as SvgAssetLoader;
      expect(
        loader.assetName,
        mode == ThemeMode.light
            ? PkBrandAssets.logoLight
            : PkBrandAssets.logoDark,
        reason: 'Wrong lockup for $mode',
      );
    }
    expect(tester.takeException(), isNull);
  });
}
