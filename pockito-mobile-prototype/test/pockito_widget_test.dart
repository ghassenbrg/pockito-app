import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';
import 'package:pockito/ui/features/widget/views/home_widget_screen.dart';

/// The home-screen widget: what it shows, and that the app keeps it in step.
void main() {
  late List<MethodCall> calls;

  setUp(() {
    calls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(PkHomeWidgetBridge.channel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(PkHomeWidgetBridge.channel, null);
  });

  Future<MockPockitoRepository> pump(WidgetTester tester, String route) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockPockitoRepository();
    appRouter.go(route);
    await tester.pumpWidget(PockitoBootstrap(repository: repository));
    await tester.pumpAndSettle();
    return repository;
  }

  testWidgets('the app pushes the widget’s figures on launch', (tester) async {
    await pump(tester, '/home');
    expect(calls, isNotEmpty);
    final payload = calls.first.arguments as Map<Object?, Object?>;
    expect(calls.first.method, 'update');
    // Already-formatted strings: the widget renders text and must never
    // re-run the app's money formatting.
    expect(payload['netWorth'], '€21,329.22');
    expect(payload['spent'], '€1,899.73');
    expect(payload['comparison'], contains('July'));
    expect(payload['waiting'], isNotEmpty);
  });

  testWidgets('it pushes again when the data changes', (tester) async {
    final repository = await pump(tester, '/home');
    final before = calls.length;
    await repository.saveTransaction(
      repository.transactionById('t_rewe')!.copyWith(amountMinor: 9999),
    );
    await tester.pumpAndSettle();
    expect(
      calls.length,
      greaterThan(before),
      reason: 'the widget must follow the app rather than poll',
    );
  });

  testWidgets('every widget size renders', (tester) async {
    await pump(tester, '/widget');
    for (final size in PkWidgetSize.values) {
      expect(
        find.byKey(ValueKey('widget_${size.name}')),
        findsOneWidget,
        reason: '${size.name} widget is missing from the preview',
      );
    }
    expect(find.byType(PkHomeWidgetSurface), findsNWidgets(3));
    expect(tester.takeException(), isNull);
  });

  testWidgets('the widget survives an empty ledger', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    appRouter.go('/widget');
    await tester.pumpWidget(
      PockitoBootstrap(repository: MockPockitoRepository.empty()),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('a missing widget host is not an error', (tester) async {
    // On web, in tests, and on any platform without home-screen widgets the
    // channel is absent. The app must carry on regardless.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(PkHomeWidgetBridge.channel, null);
    await pump(tester, '/home');
    expect(tester.takeException(), isNull);
  });
}
