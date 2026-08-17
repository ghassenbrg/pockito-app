import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/components/pk_components.dart';

void main() {
  testWidgets('Pockito launches into the complete home shell', (tester) async {
    // A real phone viewport: Home's slivers build lazily, so the default
    // 800x600 test window would leave the hero unbuilt and the assertion
    // would be about the window rather than about the app.
    const phone = Size(390, 844);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(phone);
    await tester.pumpWidget(
      const MediaQuery(
        data: MediaQueryData(size: phone),
        child: PockitoBootstrap(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PkWordmark), findsOneWidget);
    expect(find.byType(PkWelcomeBanner), findsOneWidget);
    expect(find.byType(PkHeroPanel), findsOneWidget);
    expect(find.text('Accounts'), findsWidgets);
    expect(find.text('Spaces'), findsWidgets);
    expect(find.text('More'), findsWidgets);
    expect(find.bySemanticsLabel('Add money event'), findsOneWidget);
  });
}
