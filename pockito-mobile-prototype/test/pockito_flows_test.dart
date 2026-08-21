import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pockito/app/pockito_app_view_model.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/domain/models/financial_models.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/l10n/app_localizations.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';
import 'package:pockito/ui/features/activity/views/activity_screens.dart';
import 'package:pockito/ui/features/activity/views/quick_add_screen.dart';
import 'package:pockito/ui/features/home/views/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  Future<MockPockitoRepository> pumpPockito(
    WidgetTester tester, {
    Size size = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(size);
    final repository = MockPockitoRepository();
    appRouter.go('/home');
    await tester.pumpWidget(
      // `setSurfaceSize` resizes the render view but leaves `MediaQuery` at the
      // default 800x600, so anything that lays itself out from the reported
      // screen size — a modal sheet's position, a breakpoint — would be
      // measuring a different phone from the one being rendered.
      MediaQuery(
        data: MediaQueryData(size: size),
        child: PockitoBootstrap(repository: repository),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  tearDown(() {
    appRouter.go('/home');
  });

  testWidgets('bottom navigation preserves complete primary destinations', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.tap(find.text('Accounts').last);
    await tester.pumpAndSettle();
    // Section 6.2 drops the header subtitle that restated a count already
    // visible below it; the accounts themselves are the proof of arrival.
    expect(find.text('Revolut'), findsWidgets);

    await tester.tap(find.text('Spaces').last);
    await tester.pumpAndSettle();
    expect(
      find.text('Shared money, without the awkward maths'),
      findsOneWidget,
    );

    // Activity now lives in the More hub and keeps a real back route.
    await tester.tap(find.text('More').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Activity'));
    await tester.pumpAndSettle();
    expect(find.text('72 money events'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('More'), findsWidgets);
  });

  testWidgets('Activity opened by link still offers a way back', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // A deep link replaces the stack, so there is nothing to pop. The screen
    // must not become a dead end.
    appRouter.go('/activity');
    await tester.pumpAndSettle();
    expect(find.text('72 money events'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_rounded));
    await tester.pumpAndSettle();
    expect(find.text('More'), findsWidgets);
    expect(find.text('Money'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('no routed surface is a dead end when opened by link', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Opening by link replaces the stack, so nothing can pop. Every one of
    // these must still offer a way back to the destination that owns it.
    const cases = {
      '/budgets': '/more',
      '/subscriptions': '/more',
      '/categories': '/more',
      '/notifications': '/more',
      '/settings/about': '/more',
      '/ai': '/more',
      '/activity': '/more',
      '/accounts/a_rev': '/accounts',
      '/accounts/archived': '/accounts',
      '/spaces/s_flat': '/spaces',
      '/home/net-worth': '/home',
    };

    for (final entry in cases.entries) {
      appRouter.go(entry.key);
      await tester.pumpAndSettle();
      final back = find.byIcon(Icons.arrow_back_rounded);
      expect(back, findsWidgets, reason: 'No way back from ${entry.key}');
      await tester.tap(back.first);
      await tester.pumpAndSettle();
      expect(
        appRouter.state.uri.path,
        entry.value,
        reason: '${entry.key} should fall back to ${entry.value}',
      );
      expect(tester.takeException(), isNull, reason: 'Failed at ${entry.key}');
    }
  });

  testWidgets('the central add action launches every money event kind', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Future<void> openLauncher() async {
      await tester.tap(find.bySemanticsLabel('Add money event'));
      await tester.pumpAndSettle();
    }

    await openLauncher();
    expect(find.text('Add money'), findsOneWidget);
    for (final label in const ['Expense', 'Income', 'Transfer', 'Scan']) {
      expect(find.text(label), findsOneWidget, reason: 'Missing $label');
    }

    // D-06: a personal income is a Quick Add job — it opens the compact sheet
    // with income already selected, and Save is reachable without scrolling.
    await tester.tap(find.byKey(const ValueKey('add_launcher_income')));
    await tester.pumpAndSettle();
    expect(find.byType(QuickAddScreen), findsOneWidget);
    expect(find.byKey(const ValueKey('quick_add_save')), findsOneWidget);
    expect(find.text('Add income'), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    await openLauncher();
    await tester.tap(find.byKey(const ValueKey('add_launcher_transfer')));
    await tester.pumpAndSettle();
    expect(find.text('To account'), findsOneWidget);
    expect(find.text('From account'), findsOneWidget);
    await tester.tap(find.byTooltip('Close'));
    await tester.pumpAndSettle();

    // Scan goes straight into the receipt scanner without a second tap.
    await openLauncher();
    await tester.tap(find.byKey(const ValueKey('add_launcher_scan')));
    await tester.pumpAndSettle();
    expect(find.text('Fit the whole receipt inside the frame'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation targets stay large enough and mark selection '
      'without relying on colour', (tester) async {
    await pumpPockito(tester, size: const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Scoped to the bar: Home's own "Accounts" section header now fits in the
    // same viewport, so a bare label lookup would be ambiguous.
    for (final label in const ['Home', 'Accounts', 'Spaces', 'More']) {
      final size = tester.getSize(
        find.descendant(
          of: find.byType(PkBottomNav),
          matching: find.bySemanticsLabel(label),
        ),
      );
      expect(
        size.width,
        greaterThanOrEqualTo(48),
        reason: '$label is too narrow to tap',
      );
      expect(
        size.height,
        greaterThanOrEqualTo(48),
        reason: '$label is too short to tap',
      );
    }

    // Home is selected: filled icon. Spaces is not: outlined icon.
    expect(find.byIcon(Icons.home_rounded), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsNothing);
    expect(find.byIcon(Icons.group_outlined), findsOneWidget);

    await tester.tap(find.text('Spaces').last);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.group_rounded), findsOneWidget);
    expect(find.byIcon(Icons.home_outlined), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation survives an open keyboard and a gesture inset', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(320, 568));
    appRouter.go('/home');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          size: Size(320, 568),
          viewInsets: EdgeInsets.only(bottom: 336),
          viewPadding: EdgeInsets.only(bottom: 34),
          padding: EdgeInsets.only(bottom: 34),
        ),
        child: PockitoBootstrap(repository: MockPockitoRepository()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PkBottomNav), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('navigation honours reduced motion', (tester) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(390, 844));
    appRouter.go('/home');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: PockitoBootstrap(repository: MockPockitoRepository()),
      ),
    );
    await tester.pumpAndSettle();

    final animated = tester.widgetList<AnimatedContainer>(
      find.descendant(
        of: find.byType(PkBottomNav),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect(animated, isNotEmpty);
    for (final container in animated) {
      expect(container.duration, Duration.zero);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('home exposes purposeful empty state and sample-data recovery', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final context = tester.element(find.byType(HomeScreen));
    context.read<PockitoAppViewModel>().setPrototypeState(PrototypeState.empty);
    await tester.pumpAndSettle();

    expect(find.text('Your money, finally in one place.'), findsOneWidget);
    expect(find.text('Add your first account'), findsOneWidget);
    expect(find.text('Create a shared space'), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -650));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Explore with sample data'));
    await tester.pumpAndSettle();
    expect(find.text('€21,329.22'), findsOneWidget);
    expect(find.text('€1,899.73'), findsOneWidget);
  });

  testWidgets('shared expense edit preserves another member as payer', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockPockitoRepository();
    final router = GoRouter(
      initialLocation: '/edit',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(),
          routes: [
            GoRoute(
              path: 'edit',
              builder: (context, state) =>
                  const AddMoneyEventScreen(sharedExpenseId: 'x_shop'),
            ),
          ],
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PockitoAppViewModel(repository: repository),
        // A screen built outside the app shell still needs the app's own
        // localization delegates: every screen now reads its words from them.
        child: MaterialApp.router(
          theme: PkTheme.light(),
          routerConfig: router,
          supportedLocales: PkStrings.supportedLocales,
          localizationsDelegates: PkStrings.localizationsDelegates,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit money event'), findsOneWidget);
    expect(find.text('No account movement'), findsOneWidget);
    expect(find.text('84.00'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Mira'), findsOneWidget);
    await tester.drag(find.byType(ListView).first, const Offset(0, 700));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(1), 'Market hall');
    await tester.tap(find.text('Save').first);
    await tester.pump();

    final updated = repository.sharedExpenseById('x_shop')!;
    expect(updated.title, 'Market hall');
    expect(updated.primaryPayerUserId, 'u_mira');
    expect(
      repository.transactions.any(
        (transaction) => transaction.splitId == updated.id,
      ),
      isFalse,
    );
  });

  testWidgets('home renders without overflow across compact phone sizes', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final size in const [Size(320, 568), Size(390, 844), Size(430, 932)]) {
      await pumpPockito(tester, size: size);
      expect(tester.takeException(), isNull, reason: 'Failed at $size');
      expect(find.byType(PkWelcomeBanner), findsOneWidget);
      expect(find.byType(PkHeroPanel), findsOneWidget);
      expect(find.text('€21,329.22'), findsOneWidget);
    }
  });

  testWidgets('changing to Japanese updates primary navigation immediately', (
    tester,
  ) async {
    final repository = await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    appRouter.go('/settings/language');
    await tester.pumpAndSettle();
    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();
    expect(repository.profile.language, 'Japanese');

    appRouter.go('/home');
    await tester.pumpAndSettle();
    // By semantics rather than by text: Home is dense enough now that its
    // "Accounts" section header is on screen too, and both are correctly
    // translated. The navigation destination is the one under test.
    for (final label in const ['ホーム', '口座', 'スペース', 'その他']) {
      expect(
        find.descendant(
          of: find.byType(PkBottomNav),
          matching: find.bySemanticsLabel(label),
        ),
        findsOneWidget,
        reason: label,
      );
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('Japanese navigation labels fit at 320 px with large text', (
    tester,
  ) async {
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.binding.setSurfaceSize(const Size(320, 568));
    final repository = MockPockitoRepository();
    await repository.saveProfile(
      repository.profile.copyWith(language: 'Japanese'),
    );
    appRouter.go('/home');
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: PockitoBootstrap(repository: repository),
      ),
    );
    await tester.pumpAndSettle();

    for (final label in const ['ホーム', '口座', 'スペース', 'その他']) {
      expect(find.text(label), findsOneWidget, reason: 'Missing $label');
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('activity filters fit long multilingual account names', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockPockitoRepository.empty();
    for (final account in const [
      Account(
        id: '',
        name: 'BGL Luxembourg',
        type: AccountType.bank,
        currency: 'EUR',
        openingBalanceMinor: 245000,
      ),
      Account(
        id: '',
        name: 'Revolut Savings',
        type: AccountType.savings,
        currency: 'EUR',
        openingBalanceMinor: 0,
      ),
    ]) {
      await repository.saveAccount(account);
    }
    appRouter.go('/activity');
    await tester.pumpWidget(PockitoBootstrap(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Filters'));
    await tester.pumpAndSettle();
    // The sheet grew: it now carries tags, payment methods and the lifecycle
    // switches as well, so the wallet group needs a longer scroll to reach.
    for (
      var attempt = 0;
      attempt < 12 && find.text('BGL Luxembourg').evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -220));
      await tester.pumpAndSettle();
    }
    expect(find.text('BGL Luxembourg'), findsOneWidget);
    expect(find.text('Revolut Savings'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account detail edits the same account and preserves history', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repository = MockPockitoRepository.empty();
    final account = await repository.saveAccount(
      const Account(
        id: '',
        name: 'Rakuten Bank',
        type: AccountType.bank,
        currency: 'JPY',
        openingBalanceMinor: 500000,
      ),
    );
    await repository.saveTransaction(
      MoneyTransaction(
        id: '',
        type: MoneyEventType.income,
        amountMinor: 350000,
        currency: 'JPY',
        occurredOn: repository.today,
        merchant: 'Salary',
        toAccountId: account.id,
        categoryId: 'c_sal',
      ),
    );
    appRouter.go('/accounts/${account.id}');
    await tester.pumpWidget(PockitoBootstrap(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Salary'), findsOneWidget);
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit account'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('account_name')),
      'Rakuten Bank Japan',
    );
    await tester.tap(find.byKey(const ValueKey('save_account')));
    await tester.pumpAndSettle();

    expect(repository.accountById(account.id)!.name, 'Rakuten Bank Japan');
    expect(
      repository.accountBalance(repository.accountById(account.id)!),
      850000,
    );
    expect(find.text('Salary'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('receipt scan failure retries into low-confidence review', (
    tester,
  ) async {
    final repository = await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final before = repository.transactions.length;
    appRouter.go('/add');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Scan a receipt'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('scan_failed_mode')));
    await tester.tap(find.byKey(const ValueKey('scan_capture')));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();
    expect(find.text('We could not read this document'), findsOneWidget);
    expect(repository.transactions, hasLength(before));

    await tester.tap(find.byKey(const ValueKey('scan_retry')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('scan_low_confidence')));
    await tester.tap(find.byKey(const ValueKey('scan_capture')));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();
    expect(find.text('One quick check'), findsOneWidget);
    expect(find.textContaining('low confidence'), findsOneWidget);
    expect(repository.transactions, hasLength(before));
    expect(tester.takeException(), isNull);
  });

  testWidgets('receipt scan simulation reviews and fills the expense form', (
    tester,
  ) async {
    await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    appRouter.go('/add');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Scan a receipt'));
    await tester.pumpAndSettle();
    expect(find.text('Fit the whole receipt inside the frame'), findsOneWidget);

    await tester.tap(find.text('Capture receipt'));
    await tester.pump(const Duration(milliseconds: 750));
    await tester.pumpAndSettle();
    expect(find.text('Markthalle Neun'), findsOneWidget);
    expect(find.text('€23.85'), findsOneWidget);

    await tester.drag(find.byType(ListView).last, const Offset(0, -360));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Use these details'));
    await tester.pumpAndSettle();
    expect(find.text('Markthalle Neun'), findsOneWidget);
    final amountField = tester.widget<TextFormField>(
      find.byType(TextFormField).first,
    );
    expect(amountField.controller?.text, '23.85');
    expect(tester.takeException(), isNull);
  });

  testWidgets('accepting an invite creates the local space and pre-prompts', (
    tester,
  ) async {
    final repository = await pumpPockito(tester);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    appRouter.go('/invite-review');
    await tester.pumpAndSettle();

    await tester.tap(find.text('Join space'));
    await tester.pumpAndSettle();
    expect(find.text('Stay in the loop'), findsOneWidget);
    expect(
      find.text('Prototype only · no system permission is requested'),
      findsOneWidget,
    );

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    final joined = repository.spaces.singleWhere(
      (space) => space.name == 'Book Club',
    );
    expect(joined.members, hasLength(4));
    expect(find.text('Book Club'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('every routed prototype surface renders at phone width', (
    tester,
  ) async {
    await pumpPockito(tester, size: const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const routes = [
      '/auth',
      '/auth/error',
      '/onboarding',
      '/invite-review',
      '/add',
      '/add?type=income',
      '/add?type=transfer',
      '/more',
      '/activity',
      '/home/net-worth',
      '/accounts/new',
      '/accounts/archived',
      '/accounts/reorder',
      '/accounts/a_rev/edit',
      '/accounts/a_rev',
      '/spaces/new',
      '/spaces/archived',
      '/spaces/s_flat/members',
      '/spaces/s_flat/settings',
      '/spaces/s_flat/settle',
      '/spaces/s_flat/settled',
      '/spaces/s_flat/settlements',
      '/spaces/s_flat/settlements/st_jul',
      '/spaces/s_flat/cycles',
      '/spaces/s_flat/cycles/cycle_flat_july',
      '/spaces/s_flat/expenses/x_lokal',
      '/spaces/s_flat',
      '/activity/t_lokal',
      '/budgets',
      '/budgets/new',
      '/budgets/b_gro/edit',
      '/budgets/b_gro',
      '/subscriptions',
      '/subscriptions/new',
      '/subscriptions/sb_nflx/edit',
      '/subscriptions/sb_nflx',
      '/categories',
      '/notifications',
      '/settings',
      '/settings/profile',
      '/settings/currency',
      '/settings/exchange-rates',
      '/settings/notifications',
      '/settings/appearance',
      '/settings/language',
      '/settings/about',
      '/settings/states',
      '/ai',
      '/ai/connect',
      '/ai/authorize?name=ChatGPT',
      '/ai/activity',
      '/ai/approvals',
      '/ai/con_gpt',
      '/not-a-real-page',
    ];

    for (final route in routes) {
      appRouter.go(route);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(tester.takeException(), isNull, reason: 'Failed route $route');
    }
  });
}
