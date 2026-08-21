import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/domain/models/financial_models.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  registerPockitoAcceptanceTests();
}

void registerPockitoAcceptanceTests() {
  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();
    // Floating snackbars are transient confirmations that briefly sit over the
    // bottom of the page. Let them expire so the journey taps real content.
    final snackBar = find.byType(SnackBar);
    if (snackBar.evaluate().isNotEmpty) {
      ScaffoldMessenger.of(
        tester.element(snackBar.first),
      ).removeCurrentSnackBar();
      await tester.pumpAndSettle();
    }
    final error = tester.takeException();
    expect(error, isNull);
  }

  /// Goes back one screen.
  ///
  /// `tester.pageBack()` finds the back control by its English tooltip, which
  /// stops working the moment the app is genuinely localized — so this looks
  /// for the control itself.
  Future<void> goBack(WidgetTester tester) async {
    final material = find.byType(BackButton);
    if (material.evaluate().isNotEmpty) {
      await tester.tap(material.first);
    } else {
      final icon = find.byIcon(Icons.arrow_back_rounded);
      expect(icon, findsWidgets, reason: 'No way back from this screen');
      await tester.tap(icon.first);
    }
    await settle(tester);
  }

  /// Taps a control by its visible label, in whichever language it is showing.
  ///
  /// The journey deliberately switches the app to Japanese, so a label that
  /// has been localized will not be found by its English words. Passing both
  /// keeps the test about the flow rather than about the translation.
  Future<void> tapText(
    WidgetTester tester,
    String text, {
    bool last = false,
    String? ja,
  }) async {
    var finder = find.text(text);
    if (ja != null && finder.evaluate().isEmpty) finder = find.text(ja);
    expect(finder, findsWidgets, reason: 'Could not find "$text"');
    await tester.ensureVisible(last ? finder.last : finder.first);
    await tester.pumpAndSettle();
    await tester.tap(last ? finder.last : finder.first);
    await settle(tester);
  }

  /// Scrolls the nearest list until [key] has actually been built.
  ///
  /// A lazy `ListView` only builds a little beyond the viewport, so a field
  /// elsewhere in a long form is not merely off-screen — it does not exist
  /// yet, and `ensureVisible` cannot reach it. The field may be above the
  /// current position as easily as below, so this rewinds to the top before
  /// walking down.
  Future<void> reveal(WidgetTester tester, Key key) async {
    final finder = find.byKey(key);
    if (finder.evaluate().isNotEmpty) return;
    final lists = find.byType(ListView);
    if (lists.evaluate().isEmpty) return;
    for (var attempt = 0; attempt < 10; attempt++) {
      await tester.drag(lists.last, const Offset(0, 400));
      await tester.pumpAndSettle();
      if (finder.evaluate().isNotEmpty) return;
    }
    for (var attempt = 0; attempt < 14; attempt++) {
      await tester.drag(lists.last, const Offset(0, -280));
      await tester.pumpAndSettle();
      if (finder.evaluate().isNotEmpty) return;
    }
  }

  /// A tooltip finder that accepts either language, for the same reason.
  Finder tooltip(String text, {String? ja}) {
    final finder = find.byTooltip(text);
    if (ja != null && finder.evaluate().isEmpty) return find.byTooltip(ja);
    return finder;
  }

  /// Selects a dropdown option by its visible label, in either language.
  Future<void> choose(
    WidgetTester tester,
    Key key,
    String option, {
    String? ja,
  }) async {
    await reveal(tester, key);
    final field = find.byKey(key);
    expect(field, findsOneWidget);
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.tap(field);
    await tester.pumpAndSettle();
    // UI-018 replaced the dropdown menus with sheets. A sheet over roughly
    // eight rows carries a search field, and the long ones — every ISO
    // currency — build lazily, so the row being chosen may not exist yet.
    // Filtering first is what the reader would do and what makes the journey
    // independent of how far down the list an option happens to sit.
    final search = find.byType(PkSearchField);
    if (search.evaluate().isNotEmpty) {
      await tester.enterText(search, option.split(' · ').first);
      await tester.pumpAndSettle();
    }
    var item = find.text(option);
    if (ja != null && item.evaluate().isEmpty) item = find.text(ja);
    expect(item, findsWidgets, reason: 'Could not select "$option"');
    await tester.tap(item.last);
    await settle(tester);
  }

  Future<void> enter(WidgetTester tester, Key key, String value) async {
    await reveal(tester, key);
    final field = find.byKey(key);
    expect(field, findsOneWidget);
    await tester.ensureVisible(field);
    await tester.pumpAndSettle();
    await tester.enterText(field, value);
    await tester.pump();
  }

  Future<void> tapKey(WidgetTester tester, Key key) async {
    await reveal(tester, key);
    final finder = find.byKey(key);
    expect(finder, findsOneWidget);
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    final scrollables = find.ancestor(
      of: finder,
      matching: find.byType(Scrollable),
    );
    if (tester.getCenter(finder).dy > 740 &&
        scrollables.evaluate().isNotEmpty) {
      await tester.fling(scrollables.first, const Offset(0, -500), 1200);
      await tester.pumpAndSettle();
    }
    await tester.tap(finder);
    await settle(tester);
  }

  /// Selects a value from one of the shared picker sheets, which is how Quick
  /// Add and every migrated selector work now (section 6.11).
  Future<void> pick(
    WidgetTester tester,
    Key field,
    String option, {
    String? ja,
  }) async {
    await tapKey(tester, field);
    var item = find.text(option);
    if (ja != null && item.evaluate().isEmpty) item = find.text(ja);
    expect(item, findsWidgets, reason: 'Could not pick "$option"');
    await tester.tap(item.last);
    await settle(tester);
  }

  Future<void> addAccount(
    WidgetTester tester, {
    required String name,
    required String type,
    required String typeJa,
    required String currency,
    required String currencyName,
    required String balance,
  }) async {
    // Section 7.2 leaves one add entry point on Accounts — the app-bar action —
    // rather than repeating it as a full-width button past the end of the
    // list. The stable key keeps the journey language-independent.
    await tapKey(tester, const ValueKey('accounts_add'));
    await enter(tester, const ValueKey('account_name'), name);
    await choose(tester, const ValueKey('account_type'), type, ja: typeJa);
    await choose(
      tester,
      const ValueKey('account_currency'),
      '$currency · $currencyName',
    );
    await enter(tester, const ValueKey('account_balance'), balance);
    final save = find.byKey(const ValueKey('save_account'));
    await tester.ensureVisible(save);
    await tester.tap(save);
    await settle(tester);
  }

  /// Opens the fast transaction launcher behind the central add action and
  /// picks one of Expense, Income, Transfer or Scan.
  Future<void> openAdd(WidgetTester tester, [String kind = 'expense']) async {
    // The accessible name is translated, so the journey looks for the stable
    // identifier rather than the English words.
    final add = find.bySemanticsIdentifier('add_money_event');
    expect(add, findsOneWidget);
    await tester.tap(add);
    await settle(tester);
    await tapKey(tester, ValueKey('add_launcher_$kind'));
  }

  Future<void> saveMoneyEvent(WidgetTester tester) async {
    final save = find.byKey(const ValueKey('save_transaction'));
    for (var attempt = 0; attempt < 6 && save.evaluate().isEmpty; attempt++) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -420));
      await tester.pumpAndSettle();
    }
    await tapKey(tester, const ValueKey('save_transaction'));
  }

  testWidgets('mandatory Pockito journey remains coherent from a clean user', (
    tester,
  ) async {
    const surface = Size(390, 844);
    await tester.binding.setSurfaceSize(surface);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final repo = MockPockitoRepository.empty();
    appRouter.go('/auth');
    await tester.pumpWidget(
      // `setSurfaceSize` resizes the render view but leaves `MediaQuery` at
      // its default, so anything that lays itself out from the reported screen
      // size would be measuring a different phone from the rendered one.
      MediaQuery(
        data: const MediaQueryData(size: surface),
        child: PockitoBootstrap(repository: repo),
      ),
    );
    await settle(tester);

    // New account and onboarding, including avatar, Japanese language support,
    // JPY reporting, and the first real wallet.
    await tapText(tester, 'Continue with email', ja: 'メールで続ける');
    await tapText(tester, 'Get started', ja: 'はじめる');
    await enter(tester, const ValueKey('onboarding_name'), 'Ghassen');
    await tapKey(tester, const ValueKey('onboarding_avatar'));
    await choose(tester, const ValueKey('onboarding_language'), '日本語');
    await tapText(tester, 'Continue', ja: '続ける');
    await tapText(tester, 'Continue', ja: '続ける');
    await enter(
      tester,
      const ValueKey('onboarding_account_name'),
      'Rakuten Bank',
    );
    await enter(tester, const ValueKey('onboarding_account_balance'), '500000');
    await tapText(tester, 'Add account', ja: '口座を追加');
    await tapText(tester, 'Continue', ja: '続ける');
    await tapText(tester, 'Continue', ja: '続ける');
    await tapText(tester, 'Open Pockito', ja: 'Pockitoを開く');
    expect(repo.profile.reportingCurrency, 'JPY');
    expect(repo.profile.language, 'Japanese');
    expect(repo.profile.avatarPath, isNotNull);
    expect(repo.accounts.single.name, 'Rakuten Bank');

    // All required native and foreign-currency accounts are created using the
    // same account sheet a real user reaches from bottom navigation.
    // With real localization the navigation label is rendered by the
    // framework's own selected/unselected pair, so it legitimately appears
    // more than once.
    expect(find.text('口座'), findsWidgets);
    await tapText(tester, '口座', last: true);
    await addAccount(
      tester,
      name: 'Cash',
      type: 'Cash',
      typeJa: '現金',
      currency: 'JPY',
      currencyName: 'Japanese Yen',
      balance: '10000',
    );
    await addAccount(
      tester,
      name: 'BGL Luxembourg',
      type: 'Bank',
      typeJa: '銀行',
      currency: 'EUR',
      currencyName: 'Euro',
      balance: '2450',
    );
    await addAccount(
      tester,
      name: 'BIAT Tunisia',
      type: 'Bank',
      typeJa: '銀行',
      currency: 'TND',
      currencyName: 'Tunisian Dinar',
      balance: '1200',
    );
    await addAccount(
      tester,
      name: 'Revolut Savings',
      type: 'Savings',
      typeJa: '貯蓄',
      currency: 'EUR',
      currencyName: 'Euro',
      balance: '0',
    );
    expect(repo.accounts, hasLength(5));

    // Income, personal expense, same-currency transfer, and a manual
    // cross-currency transfer are all entered through the primary + action.
    // D-06: a personal income and a personal expense are Quick Add's job, and
    // the journey proves the fast path finishes without leaving the sheet.
    await openAdd(tester, 'income');
    await enter(tester, const ValueKey('transaction_amount'), '350000');
    await enter(tester, const ValueKey('quick_add_merchant'), 'Salary');
    await pick(
      tester,
      const ValueKey('quick_add_account'),
      'Rakuten Bank',
      ja: 'Rakuten Bank',
    );
    await pick(tester, const ValueKey('quick_add_category'), 'Salary');
    await tapKey(tester, const ValueKey('quick_add_save'));

    await openAdd(tester);
    await enter(tester, const ValueKey('transaction_amount'), '1200');
    await enter(tester, const ValueKey('quick_add_merchant'), 'Lunch');
    await pick(
      tester,
      const ValueKey('quick_add_account'),
      'Rakuten Bank',
      ja: 'Rakuten Bank',
    );
    await pick(tester, const ValueKey('quick_add_category'), 'Restaurants');
    await tapKey(tester, const ValueKey('quick_add_save'));

    await openAdd(tester, 'transfer');
    await enter(tester, const ValueKey('transaction_amount'), '20000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Cash withdrawal',
    );
    await choose(tester, const ValueKey('transaction_account'), 'Rakuten Bank');
    await choose(tester, const ValueKey('transaction_to_account'), 'Cash');
    await saveMoneyEvent(tester);

    await openAdd(tester, 'transfer');
    await enter(tester, const ValueKey('transaction_amount'), '100000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Move to Revolut',
    );
    await choose(tester, const ValueKey('transaction_account'), 'Rakuten Bank');
    await choose(
      tester,
      const ValueKey('transaction_to_account'),
      'Revolut Savings',
    );
    await tester.tap(find.text('手動'));
    await settle(tester);
    await enter(tester, const ValueKey('transfer_manual_rate'), '0.0059');
    await saveMoneyEvent(tester);

    final rakuten = repo.accounts.singleWhere((a) => a.name == 'Rakuten Bank');
    final cash = repo.accounts.singleWhere((a) => a.name == 'Cash');
    final revolut = repo.accounts.singleWhere(
      (a) => a.name == 'Revolut Savings',
    );
    expect(repo.accountBalance(rakuten), 728800);
    expect(repo.accountBalance(cash), 30000);
    expect(repo.accountBalance(revolut), 59000);
    expect(
      repo.transactions.where((t) => t.type == MoneyEventType.transfer),
      hasLength(2),
    );
    expect(repo.spendingForMonth(repo.today).spentMinor, 1200);

    // Scan never commits by itself: capture -> review -> editable form -> save.
    await openAdd(tester, 'scan');
    await tapText(tester, 'Capture receipt', ja: 'レシートを撮影');
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).last, const Offset(0, -420));
    await tester.pumpAndSettle();
    await tapKey(tester, const ValueKey('scan_use_details'));
    expect(
      repo.transactions.any((t) => t.merchant == 'Maruetsu Petit'),
      isFalse,
    );
    await choose(tester, const ValueKey('transaction_account'), 'Rakuten Bank');
    await saveMoneyEvent(tester);
    expect(
      repo.transactions.any((t) => t.merchant == 'Maruetsu Petit'),
      isTrue,
    );

    // A ¥200,000 all-expenses budget is created through Settings, then a
    // Household space with its own ¥300,000 cycle budget and real invitations.
    await tapText(tester, 'ホーム', last: true);
    await tapText(tester, 'その他', last: true);
    await tapText(tester, 'Exchange rates', ja: '為替レート');
    await tapText(tester, 'Manual', ja: '手動');
    expect(repo.fxSettings.mode, FxRateMode.manual);
    await tapText(tester, 'Automatic', ja: '自動');
    expect(repo.fxSettings.mode, FxRateMode.automatic);
    await tapText(tester, 'Manual', ja: '手動');
    await tester.drag(find.byType(ListView).last, const Offset(0, -520));
    await tester.pumpAndSettle();
    await tapKey(tester, const ValueKey('save_manual_rates'));
    expect(repo.fxSettings.provider, FxProvider.manualConfiguration);
    await goBack(tester);
    await tapText(tester, 'Budgets', ja: '予算');
    await tapText(tester, 'Create budget', last: true, ja: '予算を作成');
    await enter(tester, const ValueKey('budget_name'), 'Monthly spending');
    await tester.drag(find.byType(ListView).last, const Offset(0, -480));
    await tester.pumpAndSettle();
    await enter(tester, const ValueKey('budget_limit'), '200000');
    await tester.drag(find.byType(ListView).last, const Offset(0, -320));
    await tester.pumpAndSettle();
    await tapKey(tester, const ValueKey('save_budget'));
    expect(repo.budgets.single.limitMinor, 200000);

    // Back through actual navigation, never by directly opening a feature route.
    await goBack(tester);
    await tapText(tester, 'スペース', last: true);
    await tapText(tester, 'Create a space', last: true, ja: 'スペースを作る');
    await enter(tester, const ValueKey('space_name'), 'Household');
    await enter(tester, const ValueKey('space_budget'), '300000');
    // UI-022: the icon field opens the catalogue, which is a grid of marks
    // rather than a list of words — so the journey picks by the entry's stable
    // identifier instead of by a label no icon has.
    await reveal(tester, const ValueKey('space_icon'));
    await tester.tap(find.byKey(const ValueKey('space_icon')));
    await tester.pumpAndSettle();
    final peopleIcon = find.bySemanticsIdentifier('icon_people.group');
    await tester.ensureVisible(peopleIcon);
    await tester.pumpAndSettle();
    await tester.tap(peopleIcon);
    await settle(tester);
    await tapKey(tester, const ValueKey('space_color_4'));
    await tapText(tester, 'Continue', ja: '続ける');
    await tapText(tester, 'Create and invite', ja: '作成して招待する');
    if (find.text('Not now').evaluate().isNotEmpty ||
        find.text('あとで').evaluate().isNotEmpty) {
      await tapText(tester, 'Not now', ja: 'あとで');
    }
    final household = repo.spaces.singleWhere((s) => s.name == 'Household');
    expect(household.currency, 'JPY');
    // The catalogue stores namespaced ids; the legacy names still resolve for
    // anything saved before UI-022.
    expect(household.icon, 'people.group');
    expect(household.colorIndex, 4);
    expect(
      repo.invitations.where((i) => i.spaceId == household.id),
      hasLength(2),
    );
    expect(
      repo.budgets.singleWhere((b) => b.spaceId == household.id).limitMinor,
      300000,
    );

    // Invitation state is operated from Members. Acceptance changes actual
    // membership, not just a badge.
    await tapText(tester, 'Household', ja: '家計');
    await tester.tap(tooltip('Members', ja: 'メンバー'));
    await settle(tester);
    await tapText(tester, 'Simulate acceptance', ja: '承諾をシミュレート');
    await tapText(tester, 'Simulate acceptance', ja: '承諾をシミュレート');
    expect(repo.spaceById(household.id)!.members, hasLength(3));

    // Declined invitations remain distinguishable from accepted members.
    await tapText(tester, 'Invite', ja: '招待');
    await enter(tester, const ValueKey('invite_name'), 'Aiko');
    await enter(tester, const ValueKey('invite_email'), 'aiko@example.com');
    await tapKey(tester, const ValueKey('send_invite'));
    await tapKey(tester, const ValueKey('decline_Aiko'));
    expect(
      repo.invitations.singleWhere((item) => item.name == 'Aiko').status,
      InvitationStatus.declined,
    );
    expect(repo.spaceById(household.id)!.members, hasLength(3));

    // Configure the three-member default split through Space settings.
    await goBack(tester);
    await tester.tap(tooltip('Space settings', ja: 'スペース設定'));
    await settle(tester);
    await tapText(tester, 'Default split', ja: '既定の分担');
    await tapKey(tester, const ValueKey('default_split_percentage'));
    await enter(tester, const ValueKey('default_value_Ghassen'), '60');
    await enter(tester, const ValueKey('default_value_Kana'), '40');
    await enter(tester, const ValueKey('default_value_Fran'), '0');
    await tapKey(tester, const ValueKey('save_default_split'));
    expect(
      repo.spaceById(household.id)!.defaultSplitMethod,
      SplitMethod.percentage,
    );
    await goBack(tester);

    // Shared expense from a tracked JPY wallet.
    //
    // The Money tab drops its floating "Expense" button while the Space has
    // no expenses yet, because the empty state already carries its own call
    // to action and the two would sit on top of each other. The journey takes
    // the one a first-time reader is actually offered.
    await tapText(tester, 'Add expense', last: true, ja: '支出を追加');
    await enter(tester, const ValueKey('transaction_amount'), '10000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Household groceries',
    );
    await choose(tester, const ValueKey('transaction_account'), 'Rakuten Bank');
    await choose(tester, const ValueKey('transaction_category'), 'Groceries');
    await saveMoneyEvent(tester);

    // Kana records an out-of-Pockito utility expense; no Pockito wallet changes.
    final beforeOutside = repo.accounts.map(repo.accountBalance).toList();
    await tapText(tester, 'Expense', last: true, ja: '支出');
    await enter(tester, const ValueKey('transaction_amount'), '8000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Kana utilities',
    );
    await choose(tester, const ValueKey('transaction_category'), 'Housing');
    await choose(tester, const ValueKey('transaction_payer'), 'Kana');
    await saveMoneyEvent(tester);
    expect(
      repo.accounts.map(repo.accountBalance),
      orderedEquals(beforeOutside),
    );

    // Fran also contributes outside Pockito. The default 60/40/0 rule still
    // allocates responsibility while only the Space ledger changes.
    await tapText(tester, 'Expense', last: true, ja: '支出');
    await enter(tester, const ValueKey('transaction_amount'), '6000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Fran household supplies',
    );
    await choose(tester, const ValueKey('transaction_category'), 'Shopping');
    await choose(tester, const ValueKey('transaction_payer'), 'Fran');
    await saveMoneyEvent(tester);
    expect(
      repo.accounts.map(repo.accountBalance),
      orderedEquals(beforeOutside),
    );

    // A JPY Space expense paid from EUR preserves both canonical and wallet
    // amounts, with the rate visible in the form before saving.
    await tapText(tester, 'Expense', last: true, ja: '支出');
    await enter(tester, const ValueKey('transaction_amount'), '17000');
    await enter(
      tester,
      const ValueKey('transaction_merchant'),
      'Foreign household supplies',
    );
    await choose(tester, const ValueKey('transaction_category'), 'Groceries');
    await choose(
      tester,
      const ValueKey('transaction_account'),
      'BGL Luxembourg',
    );
    for (
      var attempt = 0;
      attempt < 5 &&
          find.byKey(const ValueKey('edit_split')).evaluate().isEmpty;
      attempt++
    ) {
      await tester.drag(find.byType(ListView).last, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tapKey(tester, const ValueKey('edit_split'));
    await tapKey(tester, const ValueKey('split_equal'));
    await tapKey(tester, const ValueKey('split_done'));
    await tapKey(tester, const ValueKey('split_preview_accept'));
    await enter(tester, const ValueKey('shared_manual_rate'), '0.0059');
    await saveMoneyEvent(tester);

    // Editing and deleting use the same records and recalculate every derived
    // view instead of creating independent screen-local copies.
    await tapText(tester, 'Household groceries');
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    await tapText(tester, 'Edit expense', ja: '支出を編集');
    await enter(tester, const ValueKey('transaction_amount'), '12000');
    await saveMoneyEvent(tester);
    expect(
      repo.sharedExpenses
          .singleWhere((x) => x.title == 'Household groceries')
          .totalMinor,
      12000,
    );
    await goBack(tester);
    await tapText(tester, 'Kana utilities');
    await tester.tap(find.byType(PopupMenuButton<String>));
    await tester.pumpAndSettle();
    // Delete is void: the row survives, out of every balance, and can be put
    // back from the toast.
    await tapText(tester, 'Void', ja: '取り消す');
    await tapKey(tester, const ValueKey('reason_confirm'));
    expect(
      repo.sharedExpenses.any((x) => x.title == 'Kana utilities'),
      isFalse,
      reason: 'a voided expense drops out of the live list',
    );
    expect(
      repo.allSharedExpenses.singleWhere((x) => x.title == 'Kana utilities'),
      isA<SharedExpense>().having(
        (x) => x.status,
        'status',
        RecordStatus.voided,
      ),
      reason: 'and stays in the history rather than being destroyed',
    );

    final spaceExpenses = repo.sharedExpenses
        .where((item) => item.spaceId == household.id)
        .toList();
    expect(spaceExpenses, hasLength(3));
    expect(spaceExpenses.last.currency, 'JPY');
    expect(spaceExpenses.last.walletCurrency, 'EUR');
    expect(spaceExpenses.last.exchangeRate, isNotNull);
    expect(spaceExpenses.last.method, SplitMethod.equal);
    expect(
      repo
          .spaceById(household.id)!
          .members
          .fold(
            0,
            (sum, member) =>
                sum + repo.memberBalance(household.id, member.userId),
          ),
      0,
    );
    expect(
      repo
          .budgetSnapshot(
            repo.budgets.singleWhere((b) => b.spaceId == household.id),
          )
          .usedMinor,
      35000,
    );
    final kanaId = repo.users.singleWhere((user) => user.name == 'Kana').id;
    final franId = repo.users.singleWhere((user) => user.name == 'Fran').id;
    expect(repo.memberBalance(household.id, repo.currentUserId), 12533);
    expect(repo.memberBalance(household.id, kanaId), -12867);
    expect(repo.memberBalance(household.id, franId), 334);
    final currentPaid = <String, int>{};
    final currentResponsibility = <String, int>{};
    for (final expense in spaceExpenses) {
      for (final payer in expense.payers) {
        currentPaid[payer.userId] =
            (currentPaid[payer.userId] ?? 0) + payer.amountMinor;
      }
      for (final share in expense.shares) {
        currentResponsibility[share.userId] =
            (currentResponsibility[share.userId] ?? 0) + share.amountMinor;
      }
    }
    expect(currentPaid[repo.currentUserId], 29000);
    expect(currentPaid[franId], 6000);
    expect(currentResponsibility[repo.currentUserId], 16467);
    expect(currentResponsibility[kanaId], 12867);
    expect(currentResponsibility[franId], 5666);

    // The current-cycle breakdown exposes paid amount, responsibility and
    // the simplified settlement plan without asking users to do arithmetic.
    await tapText(tester, 'Breakdown', ja: '内訳');
    expect(
      find.textContaining('Paid ¥').evaluate().isNotEmpty
          ? find.textContaining('Paid ¥')
          : find.textContaining('支払い ¥'),
      findsWidgets,
    );
    expect(find.text('誰が誰に払うか'), findsOneWidget);
    await tapText(tester, 'Done', ja: '完了');

    // Partial then final settlement. A settlement you propose is a claim: it
    // moves nothing until the person receiving the money confirms it. Only
    // then does the wallet move, and expense totals never change either way.
    /// Records one settlement and drives it to confirmed.
    ///
    /// Which half of the loop runs depends on who is receiving the money: you
    /// can attest that money reached *you*, so that confirms immediately; a
    /// payment you say you made is only a claim until the other side agrees.
    Future<void> settleOnce(String? amount) async {
      final before = repo.settlements.length;
      final balanceBefore = repo.memberBalance(
        household.id,
        repo.currentUserId,
      );
      if (amount == null) {
        await tapText(tester, 'Settle remaining balance', ja: '残りを精算する');
      } else {
        await tapText(tester, 'Settle up', ja: '精算する');
        await enter(tester, const ValueKey('settlement_amount'), amount);
      }
      await tapKey(tester, const ValueKey('review_settlement'));
      // The journey is running in Japanese, so which half of the loop applies
      // is decided by the button that is actually on screen.
      final theyConfirm =
          find.text('Send for confirmation').evaluate().isNotEmpty ||
          find.text('確認を依頼する').evaluate().isNotEmpty;
      await tapText(
        tester,
        theyConfirm ? 'Send for confirmation' : 'Confirm settlement',
        ja: theyConfirm ? '確認を依頼する' : '精算を確定する',
      );
      expect(
        repo.settlements.length,
        before + 1,
        reason: 'the settlement must be recorded either way',
      );
      final settlement = repo.settlements.last;
      if (!theyConfirm) {
        expect(
          settlement.status,
          SettlementStatus.confirmed,
          reason: 'recording money that reached you confirms it',
        );
        return;
      }
      expect(settlement.status, SettlementStatus.proposed);
      expect(
        repo.memberBalance(household.id, repo.currentUserId),
        balanceBefore,
        reason: 'a proposed settlement must not move a balance',
      );
      await repo.simulateCounterpartyResponse(settlement.id, confirm: true);
      await settle(tester);
    }

    await settleOnce('3000');
    expect(repo.settlementRecommendations(household.id), isNotEmpty);
    expect(
      repo
          .settlementRecommendations(household.id)
          .fold<int>(0, (sum, settlement) => sum + settlement.amountMinor),
      9867,
    );
    await settleOnce(null);
    expect(repo.settlementRecommendations(household.id), isNotEmpty);
    await settleOnce(null);
    expect(repo.settlementRecommendations(household.id), isEmpty);
    expect(
      repo
          .spaceById(household.id)!
          .members
          .map((member) => repo.memberBalance(household.id, member.userId)),
      everyElement(0),
    );
    expect(
      repo.sharedExpenses.where((x) => x.spaceId == household.id),
      hasLength(3),
    );
    // A settlement between two other members lands on its own detail screen
    // rather than your celebration screen, so the cycle is closed from the
    // Space — the entry point that exists however the balance reached zero.
    await goBack(tester);
    if (find.byKey(const ValueKey('start_new_cycle')).evaluate().isEmpty) {
      await tapText(tester, 'Household', ja: '家計');
    }
    await tapKey(tester, const ValueKey('start_new_cycle'));
    await tapKey(tester, const ValueKey('confirm_new_cycle'));
    expect(
      repo.cycles.where((cycle) => cycle.spaceId == household.id),
      hasLength(1),
    );
    expect(
      repo
          .budgetSnapshot(
            repo.budgets.singleWhere((b) => b.spaceId == household.id),
          )
          .usedMinor,
      0,
    );
    expect(
      repo.sharedExpenses.where(
        (expense) =>
            expense.spaceId == household.id &&
            expense.cycleId == repo.spaceById(household.id)!.currentCycleId,
      ),
      isEmpty,
    );
    final closedCycle = repo.cycles.singleWhere(
      (cycle) => cycle.spaceId == household.id,
    );
    expect(closedCycle.spentMinor, 35000);
    expect(closedCycle.budgetLimitMinor, 300000);
    expect(closedCycle.memberPaidMinor[repo.currentUserId], 29000);
    expect(closedCycle.memberPaidMinor[franId], 6000);
    expect(closedCycle.memberResponsibilityMinor[repo.currentUserId], 16467);
    expect(closedCycle.memberResponsibilityMinor[kanaId], 12867);
    expect(closedCycle.memberResponsibilityMinor[franId], 5666);
    expect(closedCycle.categoryTotalsMinor['c_gro'], 29000);
    expect(closedCycle.categoryTotalsMinor['c_sho'], 6000);
    expect(closedCycle.settlementIds, hasLength(3));

    // Previous-cycle analytics are reachable from the normal Space UI and
    // retain the closed period's totals after current state resets.
    await tapText(tester, 'Household', ja: '家計');
    await tapText(tester, 'Cycle history', ja: 'サイクル履歴');
    expect(find.text('過去のサイクル（1）'), findsOneWidget);
    await tapText(tester, 'August 2026');
    expect(find.text('終了したサイクル · 閲覧のみ'), findsOneWidget);
    expect(find.text('¥35,000'), findsWidgets);
    await goBack(tester);
    await goBack(tester);
    await goBack(tester);

    // Subscription creation and payment preserve recurrence and wallet history.
    await tapText(tester, 'ホーム', last: true);
    await tapText(tester, 'その他', last: true);
    await tapText(tester, 'Subscriptions', ja: 'サブスク');
    await tapText(tester, 'Add subscription', last: true, ja: 'サブスクを追加');
    await enter(tester, const ValueKey('subscription_name'), 'Netflix');
    await enter(tester, const ValueKey('subscription_amount'), '1490');
    await choose(
      tester,
      const ValueKey('subscription_currency'),
      'JPY · Japanese Yen',
    );
    await choose(
      tester,
      const ValueKey('subscription_account'),
      'Rakuten Bank',
    );
    await tapKey(tester, const ValueKey('save_subscription'));
    await tapText(tester, 'Netflix');
    await tapText(tester, 'Record payment', ja: '支払いを記録');
    await tapText(tester, 'Record', ja: '記録');
    expect(
      repo.transactions.where((t) => t.subscriptionId != null),
      hasLength(1),
    );

    // Subscription totals, filtered history and dashboard/category analytics
    // are all reached by normal back and bottom-navigation transitions.
    await goBack(tester);
    expect(find.text('月あたりの費用'), findsOneWidget);
    expect(find.text('有効 1 · 年換算 ¥17,880'), findsOneWidget);
    await goBack(tester);
    await tapText(tester, 'Activity', ja: '履歴');
    await tester.tap(tooltip('Filters', ja: '絞り込み'));
    await settle(tester);
    await tapKey(tester, const ValueKey('activity_period_thisMonth'));
    await tapKey(tester, const ValueKey('activity_type_expense'));
    await tapKey(tester, const ValueKey('apply_activity_filters'));
    expect(find.text('5件の記録'), findsOneWidget);
    await goBack(tester);

    // Home leads with what needs the user, then explains the month: a trend
    // with a baseline, and a breakdown of where the money went.
    //
    // UI-020 §5 moved both charts one tap away — on Home they are two rows
    // carrying their own summary, and the charts themselves live on Trends.
    // The journey follows the row, which is the part that actually has to
    // keep working: a summary that leads nowhere is worse than no summary.
    await tapText(tester, 'ホーム', last: true);
    // The journey runs in Japanese, so Home's own chrome is in Japanese —
    // which is the point of the language setting. Category names come from
    // the user's data and stay as entered.
    final breakdown = find.text('何に使ったか');
    await tester.scrollUntilVisible(
      breakdown,
      420,
      scrollable: find.byType(Scrollable).first,
    );
    expect(breakdown, findsOneWidget);
    await tapKey(tester, const ValueKey('home_breakdown_row'));
    expect(find.text('Groceries'), findsWidgets);
    // The donut's numbers are reachable without reading colour.
    expect(find.byType(PkCategoryDonut), findsOneWidget);
    expect(find.text('支出の推移'), findsOneWidget);
    expect(find.text('表で見る'), findsWidgets);
    await goBack(tester);

    // Final wallet histories and balances use the same records as every other
    // surface, including received settlements and the paid subscription.
    await tapText(tester, '口座', last: true);
    await tapText(tester, 'Rakuten Bank');
    expect(find.text('Salary'), findsOneWidget);
    expect(find.text('Lunch'), findsOneWidget);
    expect(find.text('Household groceries'), findsOneWidget);
    expect(find.text('Move to Revolut'), findsOneWidget);
    expect(repo.accountBalance(rakuten), 725363);
    expect(repo.accountBalance(cash), 30000);
    expect(repo.accountBalance(revolut), 59000);
    expect(
      repo.accountBalance(
        repo.accounts.singleWhere((item) => item.name == 'BGL Luxembourg'),
      ),
      234970,
    );
    expect(
      repo
          .budgetSnapshot(
            repo.budgets.singleWhere(
              (budget) => budget.scope == BudgetScope.personal,
            ),
          )
          .usedMinor,
      21637,
    );
    final finalSpending = repo.spendingForMonth(repo.today);
    expect(finalSpending.spentMinor, 21637);
    expect(finalSpending.incomeMinor, 350000);
    expect(
      repo.transactions
          .where((transaction) => transaction.type == MoneyEventType.transfer)
          .fold<int>(0, (sum, transaction) => sum + transaction.amountMinor),
      120000,
    );
    expect(
      repo.transactions
          .where((transaction) => transaction.subscriptionId != null)
          .single
          .amountMinor,
      1490,
    );

    // The final global invariants are checked on the same repository mutated by
    // the UI journey.
    for (final expense in repo.sharedExpenses) {
      expect(
        expense.shares.fold(0, (sum, share) => sum + share.amountMinor),
        expense.totalMinor,
      );
    }
    for (final space in repo.spaces) {
      expect(
        space.members.fold(
          0,
          (sum, member) => sum + repo.memberBalance(space.id, member.userId),
        ),
        0,
      );
    }
  });
}
