import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';

/// Corner pixels of a packaged icon, clockwise from the top left.
Future<List<({int r, int g, int b, int a})>> _corners(String path) async {
  final image = await decodeImageFromList(File(path).readAsBytesSync());
  final data = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  final bytes = data.buffer.asUint8List();
  ({int r, int g, int b, int a}) at(int x, int y) {
    final offset = (y * image.width + x) * 4;
    return (
      r: bytes[offset],
      g: bytes[offset + 1],
      b: bytes[offset + 2],
      a: bytes[offset + 3],
    );
  }

  return [
    at(0, 0),
    at(image.width - 1, 0),
    at(image.width - 1, image.height - 1),
    at(0, image.height - 1),
  ];
}

/// PNG IHDR reports colour type 4 and 6 for the two formats that carry alpha.
bool _hasAlphaChannel(String path) {
  final bytes = File(path).readAsBytesSync();
  final colourType = bytes[25];
  return colourType == 4 || colourType == 6;
}

({int width, int height}) _size(String path) {
  final bytes = File(path).readAsBytesSync();
  final view = ByteData.sublistView(Uint8List.fromList(bytes));
  return (width: view.getUint32(16), height: view.getUint32(20));
}

void main() {
  test('every semantic Kito runtime asset and platform icon is packaged', () {
    for (final asset in KitoAsset.values) {
      expect(
        File(asset.path).existsSync(),
        isTrue,
        reason: 'Missing ${asset.path}',
      );
    }

    for (final icon in const [
      'assets/mascot/kito/app-icon/kito-app-icon-master.png',
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
      'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png',
      'android/app/src/main/res/drawable-nodpi/kito_avatar_foreground.png',
      'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
      'web/icons/Icon-512.png',
      'web/icons/Icon-maskable-512.png',
      'web/favicon.png',
    ]) {
      expect(File(icon).existsSync(), isTrue, reason: 'Missing $icon');
    }
  });

  test(
    'the Android adaptive foreground is square so Kito is never stretched',
    () {
      const path =
          'android/app/src/main/res/drawable-nodpi/kito_avatar_foreground.png';
      final size = _size(path);
      expect(
        size.width,
        size.height,
        reason:
            'A non-square foreground is stretched by the adaptive icon mask',
      );
      expect(_hasAlphaChannel(path), isTrue, reason: 'Foreground needs alpha');
    },
  );

  test('iOS icons are opaque, as the App Store requires', () {
    const path =
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png';
    expect(_hasAlphaChannel(path), isFalse);
  });

  testWidgets('packaged icons run full bleed so platform masks stay clean', (
    tester,
  ) async {
    // Image decoding needs the real event loop, not the fake test clock.
    await tester.runAsync(() async {
      // The master art bakes in its own rounded corners over solid black. Any
      // icon that ships those corners shows black slivers inside the iOS
      // squircle and the Android and PWA masks.
      for (final path in const [
        'ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png',
        'web/icons/Icon-maskable-512.png',
        'assets/mascot/kito/runtime/kito-app-icon.png',
      ]) {
        for (final corner in await _corners(path)) {
          expect(corner.a, 255, reason: '$path should be opaque');
          expect(
            corner.r + corner.g + corner.b,
            greaterThan(60),
            reason: '$path still has a baked dark corner',
          );
        }
      }

      // Icons that carry their own shape must have transparent corners
      // instead, so a launcher mask does not stack two roundings.
      for (final path in const [
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png',
        'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_round.png',
        'web/icons/Icon-512.png',
      ]) {
        for (final corner in await _corners(path)) {
          expect(corner.a, 0, reason: '$path should have alpha corners');
        }
      }
    });
  });

  testWidgets('Kito messages adapt to both themes and reduced motion', (
    tester,
  ) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: PkTheme.light(),
          darkTheme: PkTheme.dark(),
          themeMode: mode,
          home: const MediaQuery(
            data: MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 320,
                  child: KitoReveal(
                    child: KitoMessage(
                      title: 'Kito noticed',
                      message: 'This receipt needs one quick check.',
                      asset: KitoAsset.surprised,
                      compact: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Kito noticed'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity)).duration,
        Duration.zero,
      );
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('decorative Kito artwork stays out of the screen reader', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: PkTheme.light(),
        home: const Scaffold(
          body: PkEmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'No activity yet',
            message: 'Record an expense to start your timeline.',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The copy is announced; the illustration beside it is not repeated.
    expect(find.bySemanticsLabel('No activity yet'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Kito')), findsNothing);
    handle.dispose();
  });

  test('empty states use the pose the mascot guide prescribes', () {
    KitoAsset resolve(IconData icon) => (PkEmptyState(
      icon: icon,
      title: 'x',
      message: 'y',
    )).debugResolvedMascot;

    // A recoverable error must not be drawn with the optimistic empty pose.
    expect(resolve(Icons.map_outlined), KitoAsset.confused);
    expect(resolve(Icons.sync_problem_rounded), KitoAsset.confused);
    expect(resolve(Icons.link_off_rounded), KitoAsset.confused);
    expect(resolve(Icons.notifications_none_rounded), KitoAsset.sleeping);
    expect(resolve(Icons.group_add_outlined), KitoAsset.sharedSpace);
    expect(resolve(Icons.check_circle_outline_rounded), KitoAsset.celebrating);
    expect(resolve(Icons.receipt_long_outlined), KitoAsset.empty);
  });
}
