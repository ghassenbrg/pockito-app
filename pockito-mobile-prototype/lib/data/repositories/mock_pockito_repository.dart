import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart' show ThemeMode;

import '../../domain/models/financial_models.dart';
import '../../domain/repositories/pockito_repository.dart';

class MockPockitoRepository extends ChangeNotifier
    implements PockitoRepository {
  MockPockitoRepository({bool withSampleData = true, this.stressScale = 0})
    : _withSampleData = withSampleData {
    withSampleData ? _seed() : _seedEmpty();
  }

  MockPockitoRepository.empty() : this(withSampleData: false);

  /// Multiplies the seeded dataset so the target volumes from the audit —
  /// 25 spaces, 50 members in one space, 500 expenses — can be exercised
  /// without hand-writing them.
  MockPockitoRepository.stress() : this(stressScale: 1);

  final bool _withSampleData;
  final int stressScale;

  @override
  final DateTime today = DateTime(2026, 8, 15);

  @override
  final String currentUserId = 'u_me';

  late UserProfile _profile;
  final List<PockitoUser> _users = [];
  final List<Account> _accounts = [];
  final List<Category> _categories = [];
  final List<Tag> _tags = [];
  final List<PaymentMethod> _paymentMethods = [];
  final List<SharedSpace> _spaces = [];
  final List<SharedExpense> _sharedExpenses = [];
  final List<MoneyTransaction> _transactions = [];
  final List<Settlement> _settlements = [];
  final List<Budget> _budgets = [];
  final List<Subscription> _subscriptions = [];
  final List<PockitoNotification> _notifications = [];
  final List<AiConnection> _aiConnections = [];
  final List<AiApproval> _aiApprovals = [];
  final List<SpaceInvitation> _invitations = [];
  final List<SpaceCycle> _cycles = [];
  final List<SpaceActivityEvent> _activity = [];
  final List<SavedView> _savedViews = [];
  late FxSettings _fxSettings;
  NotificationPreferences _notificationPreferences =
      const NotificationPreferences();
  bool _offline = false;
  int _sequence = 1000;

  static const currencies = PockitoCurrencies.all;

  static const ratesToEur = <String, double>{
    'EUR': 1,
    'USD': .92,
    'JPY': .0059,
    'GBP': 1.17,
    'TND': .294,
    'SEK': .088,
    'NOK': .086,
    'DKK': .134,
    'PLN': .233,
    'CZK': .04,
    'CAD': .68,
    'AUD': .61,
    'SGD': .69,
    'KRW': .00068,
    'CNY': .13,
    'INR': .011,
    'MAD': .092,
    'THB': .026,
    'TRY': .028,
    'AED': .25,
  };

  @override
  UserProfile get profile => _profile;
  @override
  List<PockitoUser> get users => List.unmodifiable(_users);
  @override
  List<Account> get accounts => List.unmodifiable(
    _accounts.toList()..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)),
  );
  @override
  List<Category> get categories =>
      List.unmodifiable(_categories.where((item) => !item.hidden));
  @override
  List<Tag> get tags => List.unmodifiable(
    _tags.where((item) => !item.archived).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase())),
  );
  @override
  List<PaymentMethod> get paymentMethods =>
      List.unmodifiable(_paymentMethods.where((item) => !item.archived));
  @override
  List<SharedSpace> get spaces => List.unmodifiable(_spaces);
  @override
  List<SharedExpense> get sharedExpenses =>
      List.unmodifiable(_sharedExpenses.where((item) => !item.isVoided));
  @override
  List<SharedExpense> get allSharedExpenses =>
      List.unmodifiable(_sharedExpenses);
  @override
  List<MoneyTransaction> get transactions => List.unmodifiable(
    _transactions.where((item) => !item.isVoided).toList()
      ..sort((a, b) => b.occurredOn.compareTo(a.occurredOn)),
  );
  @override
  List<MoneyTransaction> get allTransactions => List.unmodifiable(
    _transactions.toList()
      ..sort((a, b) => b.occurredOn.compareTo(a.occurredOn)),
  );
  @override
  List<Settlement> get settlements => List.unmodifiable(_settlements);
  @override
  List<Budget> get budgets => List.unmodifiable(_budgets);
  @override
  List<Subscription> get subscriptions =>
      List.unmodifiable(_subscriptions.where((item) => !item.archived));
  @override
  List<PockitoNotification> get notifications => List.unmodifiable(
    _notifications.where((item) => !item.dismissed).toList()
      ..sort((a, b) => b.at.compareTo(a.at)),
  );
  @override
  NotificationPreferences get notificationPreferences =>
      _notificationPreferences;
  @override
  List<AiConnection> get aiConnections => List.unmodifiable(_aiConnections);
  @override
  List<AiApproval> get aiApprovals => List.unmodifiable(_aiApprovals);
  @override
  List<SpaceInvitation> get invitations => List.unmodifiable(_invitations);
  @override
  List<SpaceCycle> get cycles => List.unmodifiable(_cycles);
  @override
  List<SpaceActivityEvent> get spaceActivity => List.unmodifiable(
    _activity.toList()..sort((a, b) => b.at.compareTo(a.at)),
  );
  @override
  List<SavedView> get savedViews => List.unmodifiable(_savedViews);
  @override
  FxSettings get fxSettings => _fxSettings;
  @override
  bool get offline => _offline;

  DateTime _d(String value) => DateTime.parse(value);
  String _id(String prefix) => '${prefix}_${++_sequence}';

  // ---------------------------------------------------------------------------
  // Guards
  // ---------------------------------------------------------------------------

  /// Refuses a write while offline, before anything is touched.
  void _requireOnline(String action) {
    if (_offline) throw OfflineWriteException(action);
  }

  /// Refuses a write the current user is not allowed to make, and records the
  /// refusal in the Space's audit log.
  void _requirePermission(
    String spaceId, {
    required bool allowed,
    required String action,
    required String permission,
    required String reason,
  }) {
    if (allowed) return;
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.permissionDenied,
      summary: 'You tried to $action',
      outcome: ActivityOutcome.denied,
      permission: permission,
      detail: reason,
    );
    throw PermissionDeniedException(
      action: action,
      reason: reason,
      whoCanHelp: whoCanHelp(spaceId, permission),
    );
  }

  /// Refuses a write against a record someone else has already moved on.
  void _requireVersion({
    required String entityLabel,
    required int expected,
    required int actual,
    String actorName = 'Someone',
  }) {
    if (expected == actual) return;
    throw ConcurrentEditException(
      entityLabel: entityLabel,
      actorName: actorName,
      expectedVersion: expected,
      actualVersion: actual,
    );
  }

  void _logActivity({
    required String spaceId,
    required SpaceActivityType type,
    required String summary,
    ActivityOutcome outcome = ActivityOutcome.granted,
    String? actorUserId,
    String? entityId,
    String? entityLabel,
    String? permission,
    String? detail,
  }) {
    if (spaceId.isEmpty) return;
    _activity.add(
      SpaceActivityEvent(
        id: _id('act'),
        spaceId: spaceId,
        actorUserId: actorUserId ?? currentUserId,
        at: today,
        type: type,
        summary: summary,
        outcome: outcome,
        entityId: entityId,
        entityLabel: entityLabel,
        permission: permission,
        detail: detail,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Seeding
  // ---------------------------------------------------------------------------

  void _seed() {
    _fxSettings = FxSettings(
      lastUpdatedAt: DateTime.parse('2026-08-15T07:00:00'),
      provider: FxProvider.prototypeSnapshot,
      history: [
        FxRateChange(
          pair: 'JPY_EUR',
          rate: .0059,
          at: DateTime.parse('2026-08-15T07:00:00'),
          mode: FxRateMode.automatic,
          source: FxProvider.prototypeSnapshot,
          previousRate: .0061,
        ),
        FxRateChange(
          pair: 'USD_EUR',
          rate: .92,
          at: DateTime.parse('2026-08-14T07:00:00'),
          mode: FxRateMode.automatic,
          source: FxProvider.prototypeSnapshot,
          previousRate: .915,
        ),
      ],
    );
    _notificationPreferences = const NotificationPreferences();
    _offline = false;
    _invitations.clear();
    _cycles.clear();
    _activity.clear();
    _savedViews.clear();
    _users
      ..clear()
      ..addAll(const [
        PockitoUser(id: 'u_me', name: 'Ghassen', initials: 'G', isYou: true),
        PockitoUser(id: 'u_mira', name: 'Mira', initials: 'M'),
        PockitoUser(id: 'u_sam', name: 'Sam', initials: 'S'),
        PockitoUser(id: 'u_lina', name: 'Lina', initials: 'L'),
        PockitoUser(id: 'u_kana', name: 'Kana', initials: 'K'),
      ]);
    _profile = const UserProfile(
      userId: 'u_me',
      displayName: 'Ghassen',
      email: 'ghassen@example.com',
      country: 'DE',
      countryName: 'Germany',
      reportingCurrency: 'EUR',
      locale: 'en-DE',
      timezone: 'Europe/Berlin',
      recentCurrencies: ['EUR', 'JPY', 'USD'],
      completedSetupSteps: ['profile', 'account'],
    );
    _accounts
      ..clear()
      ..addAll(const [
        Account(
          id: 'a_rev',
          name: 'Revolut',
          type: AccountType.bank,
          currency: 'EUR',
          openingBalanceMinor: 320000,
          isDefault: true,
          colorIndex: 2,
          icon: 'card',
          sortOrder: 0,
        ),
        Account(
          id: 'a_n26',
          name: 'N26',
          type: AccountType.bank,
          currency: 'EUR',
          openingBalanceMinor: 148050,
          colorIndex: 3,
          icon: 'bank',
          sortOrder: 1,
        ),
        Account(
          id: 'a_visa',
          name: 'Visa',
          type: AccountType.card,
          currency: 'EUR',
          openingBalanceMinor: -42800,
          colorIndex: 5,
          icon: 'card',
          sortOrder: 2,
          creditLimitMinor: 250000,
        ),
        Account(
          id: 'a_sav',
          name: 'Savings',
          type: AccountType.savings,
          currency: 'EUR',
          openingBalanceMinor: 1250000,
          colorIndex: 1,
          icon: 'savings',
          sortOrder: 3,
          goalAmountMinor: 2000000,
        ),
        Account(
          id: 'a_chase',
          name: 'Chase',
          type: AccountType.bank,
          currency: 'USD',
          openingBalanceMinor: 214000,
          colorIndex: 8,
          icon: 'bank',
          sortOrder: 4,
        ),
        Account(
          id: 'a_cash',
          name: 'Cash',
          type: AccountType.cash,
          currency: 'JPY',
          openingBalanceMinor: 18400,
          colorIndex: 4,
          icon: 'cash',
          sortOrder: 5,
        ),
        Account(
          id: 'a_old',
          name: 'Old PayPal',
          type: AccountType.digital,
          currency: 'EUR',
          openingBalanceMinor: 0,
          archived: true,
          colorIndex: 10,
          icon: 'wallet',
          sortOrder: 6,
        ),
      ]);
    _categories
      ..clear()
      ..addAll(const [
        Category(
          id: 'c_gro',
          name: 'Groceries',
          type: CategoryType.expense,
          icon: 'cart',
          colorIndex: 1,
          system: true,
        ),
        Category(
          id: 'c_din',
          name: 'Restaurants',
          type: CategoryType.expense,
          icon: 'restaurant',
          colorIndex: 5,
          system: true,
        ),
        Category(
          id: 'c_cof',
          name: 'Coffee',
          type: CategoryType.expense,
          icon: 'restaurant',
          colorIndex: 7,
          parentId: 'c_din',
        ),
        Category(
          id: 'c_tra',
          name: 'Transport',
          type: CategoryType.expense,
          icon: 'transit',
          colorIndex: 3,
          system: true,
        ),
        Category(
          id: 'c_tax',
          name: 'Taxi',
          type: CategoryType.expense,
          icon: 'transit',
          colorIndex: 3,
          parentId: 'c_tra',
        ),
        Category(
          id: 'c_hou',
          name: 'Housing',
          type: CategoryType.expense,
          icon: 'housing',
          colorIndex: 4,
          system: true,
        ),
        Category(
          id: 'c_uti',
          name: 'Utilities',
          type: CategoryType.expense,
          icon: 'utilities',
          colorIndex: 7,
          system: true,
        ),
        Category(
          id: 'c_hea',
          name: 'Health',
          type: CategoryType.expense,
          icon: 'health',
          colorIndex: 9,
          system: true,
        ),
        Category(
          id: 'c_sho',
          name: 'Shopping',
          type: CategoryType.expense,
          icon: 'shopping',
          colorIndex: 6,
          system: true,
        ),
        Category(
          id: 'c_ent',
          name: 'Entertainment',
          type: CategoryType.expense,
          icon: 'entertainment',
          colorIndex: 12,
          system: true,
        ),
        Category(
          id: 'c_trv',
          name: 'Travel',
          type: CategoryType.expense,
          icon: 'travel',
          colorIndex: 8,
          system: true,
        ),
        Category(
          id: 'c_edu',
          name: 'Education',
          type: CategoryType.expense,
          icon: 'education',
          colorIndex: 11,
          system: true,
        ),
        Category(
          id: 'c_gif',
          name: 'Gifts',
          type: CategoryType.expense,
          icon: 'gift',
          colorIndex: 9,
          system: true,
        ),
        Category(
          id: 'c_fee',
          name: 'Fees',
          type: CategoryType.expense,
          icon: 'receipt',
          colorIndex: 10,
          system: true,
        ),
        Category(
          id: 'c_sal',
          name: 'Salary',
          type: CategoryType.income,
          icon: 'income',
          colorIndex: 1,
          system: true,
        ),
        Category(
          id: 'c_fre',
          name: 'Freelance',
          type: CategoryType.income,
          icon: 'income',
          colorIndex: 3,
          system: true,
        ),
        Category(
          id: 'c_ref',
          name: 'Refunds',
          type: CategoryType.income,
          icon: 'income',
          colorIndex: 11,
          system: true,
        ),
      ]);
    _tags
      ..clear()
      ..addAll(const [
        Tag(id: 'tg_berlin', name: 'Berlin trip', colorIndex: 3),
        Tag(id: 'tg_work', name: 'Work', colorIndex: 6),
        Tag(id: 'tg_reimb', name: 'Reimbursable', colorIndex: 9),
        Tag(id: 'tg_gift', name: 'Gift', colorIndex: 5),
      ]);
    _paymentMethods
      ..clear()
      ..addAll(const [
        PaymentMethod(
          id: 'pm_amex',
          name: 'Amex Gold',
          kind: PaymentMethodKind.card,
          last4: '3007',
          accountId: 'a_visa',
          colorIndex: 5,
        ),
        PaymentMethod(
          id: 'pm_rev',
          name: 'Revolut card',
          kind: PaymentMethodKind.card,
          last4: '4419',
          accountId: 'a_rev',
          colorIndex: 2,
        ),
        PaymentMethod(
          id: 'pm_cash',
          name: 'Cash',
          kind: PaymentMethodKind.cash,
          icon: 'cash',
          accountId: 'a_cash',
          colorIndex: 4,
        ),
        PaymentMethod(
          id: 'pm_sepa',
          name: 'SEPA direct debit',
          kind: PaymentMethodKind.direct,
          icon: 'bank',
          accountId: 'a_n26',
          colorIndex: 3,
        ),
      ]);
    _spaces
      ..clear()
      ..addAll([
        SharedSpace(
          id: 's_flat',
          name: 'Flat',
          type: SpaceType.household,
          currency: 'EUR',
          members: [
            SpaceMember(
              userId: 'u_me',
              role: SpaceRole.owner,
              joinedAt: _d('2025-09-01'),
            ),
            SpaceMember(userId: 'u_mira', joinedAt: _d('2025-09-01')),
          ],
          defaultSplitMethod: SplitMethod.percentage,
          defaultPercentages: const {'u_me': 60, 'u_mira': 40},
          colorIndex: 2,
          icon: 'housing',
        ),
        SharedSpace(
          id: 's_tokyo',
          name: 'Tokyo Trip',
          type: SpaceType.trip,
          currency: 'JPY',
          members: [
            SpaceMember(
              userId: 'u_me',
              role: SpaceRole.owner,
              joinedAt: _d('2026-07-20'),
            ),
            SpaceMember(
              userId: 'u_mira',
              role: SpaceRole.admin,
              joinedAt: _d('2026-07-20'),
            ),
            SpaceMember(userId: 'u_sam', joinedAt: _d('2026-07-22')),
            SpaceMember(
              userId: 'u_kana',
              role: SpaceRole.viewer,
              joinedAt: _d('2026-08-01'),
            ),
          ],
          defaultSplitMethod: SplitMethod.equal,
          colorIndex: 4,
          icon: 'travel',
        ),
        // Same name as the first Space on purpose: the list has to be able to
        // tell two "Flat"s apart by something other than their name.
        SharedSpace(
          id: 's_flat_old',
          name: 'Flat',
          type: SpaceType.friends,
          currency: 'EUR',
          members: [
            SpaceMember(
              userId: 'u_me',
              role: SpaceRole.member,
              joinedAt: _d('2024-03-01'),
            ),
            SpaceMember(
              userId: 'u_lina',
              role: SpaceRole.owner,
              joinedAt: _d('2024-03-01'),
            ),
          ],
          defaultSplitMethod: SplitMethod.equal,
          colorIndex: 7,
          icon: 'group',
        ),
        SharedSpace(
          id: 's_ski',
          name: 'Ski 2025',
          type: SpaceType.trip,
          currency: 'EUR',
          members: [
            SpaceMember(userId: 'u_me', role: SpaceRole.owner),
            SpaceMember(userId: 'u_sam'),
          ],
          defaultSplitMethod: SplitMethod.equal,
          status: SpaceStatus.archived,
          colorIndex: 10,
          icon: 'travel',
        ),
      ]);
    _sharedExpenses
      ..clear()
      ..addAll([
        SharedExpense(
          id: 'x_util',
          spaceId: 's_flat',
          title: 'Stadtwerke gas & power',
          totalMinor: 12400,
          currency: 'EUR',
          occurredOn: _d('2026-08-04'),
          categoryId: 'c_uti',
          method: SplitMethod.percentage,
          payers: const [ExpensePayer(userId: 'u_me', amountMinor: 12400)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 7440),
            SplitShare(userId: 'u_mira', amountMinor: 4960),
          ],
          createdByUserId: 'u_me',
        ),
        SharedExpense(
          id: 'x_shop',
          spaceId: 's_flat',
          title: 'Weekly shop',
          totalMinor: 8400,
          currency: 'EUR',
          occurredOn: _d('2026-08-09'),
          categoryId: 'c_gro',
          method: SplitMethod.percentage,
          payers: const [ExpensePayer(userId: 'u_mira', amountMinor: 8400)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 5040),
            SplitShare(userId: 'u_mira', amountMinor: 3360),
          ],
          createdByUserId: 'u_mira',
        ),
        SharedExpense(
          id: 'x_lokal',
          spaceId: 's_flat',
          title: 'Dinner at Lokal',
          totalMinor: 9800,
          currency: 'EUR',
          occurredOn: _d('2026-08-13'),
          categoryId: 'c_din',
          method: SplitMethod.equal,
          payers: const [ExpensePayer(userId: 'u_me', amountMinor: 9800)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 4900),
            SplitShare(userId: 'u_mira', amountMinor: 4900),
          ],
          source: 'mcp',
          client: 'ChatGPT',
          createdByUserId: 'u_me',
        ),
        SharedExpense(
          id: 'x_ryokan',
          spaceId: 's_tokyo',
          title: 'Ryokan Sakura',
          totalMinor: 42000,
          currency: 'JPY',
          occurredOn: _d('2026-08-07'),
          categoryId: 'c_hou',
          method: SplitMethod.equal,
          payers: const [ExpensePayer(userId: 'u_sam', amountMinor: 42000)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 14000),
            SplitShare(userId: 'u_mira', amountMinor: 14000),
            SplitShare(userId: 'u_sam', amountMinor: 14000),
          ],
          createdByUserId: 'u_sam',
        ),
        SharedExpense(
          id: 'x_shink',
          spaceId: 's_tokyo',
          title: 'Shinkansen tickets',
          totalMinor: 27600,
          currency: 'JPY',
          occurredOn: _d('2026-08-07'),
          categoryId: 'c_tra',
          method: SplitMethod.equal,
          payers: const [ExpensePayer(userId: 'u_me', amountMinor: 27600)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 9200),
            SplitShare(userId: 'u_mira', amountMinor: 9200),
            SplitShare(userId: 'u_sam', amountMinor: 9200),
          ],
          createdByUserId: 'u_me',
        ),
        // Two people put money in. This is the shape a single payer field
        // cannot record at all.
        SharedExpense(
          id: 'x_sushi',
          spaceId: 's_tokyo',
          title: 'Sushi Zanmai',
          totalMinor: 9600,
          currency: 'JPY',
          occurredOn: _d('2026-08-09'),
          categoryId: 'c_din',
          method: SplitMethod.equal,
          payers: const [
            ExpensePayer(userId: 'u_mira', amountMinor: 6600),
            ExpensePayer(
              userId: 'u_me',
              amountMinor: 3000,
              accountId: 'a_cash',
            ),
          ],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 3200),
            SplitShare(userId: 'u_mira', amountMinor: 3200),
            SplitShare(userId: 'u_sam', amountMinor: 3200),
          ],
          note: 'Mira put in the rest when my card was declined.',
          createdByUserId: 'u_mira',
        ),
        // A staged expense: recorded, not yet agreed to count.
        SharedExpense(
          id: 'x_draft_taxi',
          spaceId: 's_tokyo',
          title: 'Airport taxi',
          totalMinor: 7800,
          currency: 'JPY',
          occurredOn: _d('2026-08-14'),
          categoryId: 'c_tax',
          method: SplitMethod.equal,
          payers: const [ExpensePayer(userId: 'u_sam', amountMinor: 7800)],
          shares: const [
            SplitShare(userId: 'u_me', amountMinor: 2600),
            SplitShare(userId: 'u_mira', amountMinor: 2600),
            SplitShare(userId: 'u_sam', amountMinor: 2600),
          ],
          status: RecordStatus.draft,
          note: 'Sam still has to check the meter receipt.',
          createdByUserId: 'u_sam',
          attachments: [
            ReceiptAttachment(
              id: 'r_taxi',
              label: 'Taxi receipt',
              capturedAt: DateTime.parse('2026-08-14T22:14:00'),
              ocrStatus: OcrStatus.completed,
              byteSize: 184320,
              previewSeed: 7,
              extractedTotalMinor: 7800,
              extractedMerchant: 'Nihon Kotsu',
            ),
          ],
        ),
      ]);
    _transactions
      ..clear()
      ..addAll([
        _txn(
          't_sal',
          MoneyEventType.income,
          385000,
          'EUR',
          '2026-08-01',
          'Monthly salary',
          to: 'a_rev',
          category: 'c_sal',
        ),
        // Rent is recorded every month, including this one. A current month
        // missing an expense that every previous month carries would make the
        // month-on-month comparison read as a saving that never happened.
        _txn(
          't_rent',
          MoneyEventType.expense,
          128000,
          'EUR',
          '2026-08-01',
          'Rent',
          from: 'a_n26',
          category: 'c_hou',
          subscription: 'sb_rent',
          paymentMethod: 'pm_sepa',
        ),
        _txn(
          't_gym',
          MoneyEventType.expense,
          3900,
          'EUR',
          '2026-08-01',
          'Urban Sports',
          from: 'a_n26',
          category: 'c_hea',
          subscription: 'sb_gym',
          paymentMethod: 'pm_sepa',
        ),
        _txn(
          't_edeka',
          MoneyEventType.expense,
          4290,
          'EUR',
          '2026-08-03',
          'Edeka',
          from: 'a_rev',
          category: 'c_gro',
          paymentMethod: 'pm_rev',
        ),
        _txn(
          't_util',
          MoneyEventType.expense,
          12400,
          'EUR',
          '2026-08-04',
          'Stadtwerke gas & power',
          from: 'a_n26',
          category: 'c_uti',
          split: 'x_util',
        ),
        _txn(
          't_cof',
          MoneyEventType.expense,
          420,
          'EUR',
          '2026-08-04',
          'Bonanza Coffee',
          from: 'a_rev',
          category: 'c_cof',
          paymentMethod: 'pm_rev',
        ),
        _txn(
          't_bvg',
          MoneyEventType.expense,
          4900,
          'EUR',
          '2026-08-05',
          'BVG monthly ticket',
          from: 'a_rev',
          category: 'c_tra',
          note: 'Company reimburses half of this in September.',
          tags: const ['tg_work', 'tg_reimb'],
        ),
        _txn(
          't_nflx',
          MoneyEventType.expense,
          1099,
          'EUR',
          '2026-08-06',
          'Netflix',
          from: 'a_visa',
          category: 'c_ent',
          subscription: 'sb_nflx',
          paymentMethod: 'pm_amex',
        ),
        MoneyTransaction(
          id: 't_shink',
          type: MoneyEventType.expense,
          amountMinor: 16284,
          currency: 'EUR',
          occurredOn: _d('2026-08-07'),
          merchant: 'Shinkansen tickets',
          fromAccountId: 'a_rev',
          categoryId: 'c_tra',
          splitId: 'x_shink',
          sourceAmountMinor: 27600,
          sourceCurrency: 'JPY',
          exchangeRate: .0059,
        ),
        _txn(
          't_zal',
          MoneyEventType.expense,
          8600,
          'EUR',
          '2026-08-08',
          'Zalando',
          from: 'a_visa',
          category: 'c_sho',
          paymentMethod: 'pm_amex',
        ),
        _txn(
          't_tr1',
          MoneyEventType.transfer,
          50000,
          'EUR',
          '2026-08-11',
          'To Savings',
          from: 'a_rev',
          to: 'a_sav',
        ),
        _txn(
          't_rewe',
          MoneyEventType.expense,
          3250,
          'EUR',
          '2026-08-12',
          'Rewe',
          from: 'a_rev',
          category: 'c_gro',
          paymentMethod: 'pm_rev',
        ),
        MoneyTransaction(
          id: 't_lokal',
          type: MoneyEventType.expense,
          amountMinor: 9800,
          currency: 'EUR',
          occurredOn: _d('2026-08-13'),
          merchant: 'Dinner at Lokal',
          fromAccountId: 'a_rev',
          categoryId: 'c_din',
          splitId: 'x_lokal',
          source: 'mcp',
          client: 'ChatGPT',
        ),
        _txn(
          't_must',
          MoneyEventType.expense,
          1850,
          'EUR',
          '2026-08-14',
          "Mustafa's",
          from: 'a_rev',
          category: 'c_din',
        ),
        _txn(
          't_cash',
          MoneyEventType.expense,
          1200,
          'JPY',
          '2026-08-14',
          'Doutor',
          from: 'a_cash',
          category: 'c_cof',
          paymentMethod: 'pm_cash',
        ),
        // Your half of the Sushi Zanmai bill. A shared expense you put money
        // into moves your wallet exactly as much as you put in — no more.
        MoneyTransaction(
          id: 't_sushi',
          type: MoneyEventType.expense,
          amountMinor: 3000,
          currency: 'JPY',
          occurredOn: _d('2026-08-09'),
          merchant: 'Sushi Zanmai',
          fromAccountId: 'a_cash',
          categoryId: 'c_din',
          splitId: 'x_sushi',
          paymentMethodId: 'pm_cash',
        ),
        _txn(
          't_fre',
          MoneyEventType.income,
          62000,
          'EUR',
          '2026-08-15',
          'Design retainer',
          to: 'a_n26',
          category: 'c_fre',
          tags: const ['tg_work'],
        ),
        // A correction that keeps its history rather than a silent edit.
        MoneyTransaction(
          id: 't_adj',
          type: MoneyEventType.adjustment,
          amountMinor: 350,
          currency: 'JPY',
          occurredOn: _d('2026-08-15'),
          merchant: 'Balance correction',
          toAccountId: 'a_cash',
          adjustmentReason: 'Counted the wallet: ¥350 more than recorded.',
        ),
        // A voided row: visible, struck through, out of every balance.
        MoneyTransaction(
          id: 't_void',
          type: MoneyEventType.expense,
          amountMinor: 2400,
          currency: 'EUR',
          occurredOn: _d('2026-08-10'),
          merchant: 'Duplicate charge — Rewe',
          fromAccountId: 'a_rev',
          categoryId: 'c_gro',
          status: RecordStatus.voided,
          voidedAt: _d('2026-08-11'),
          voidReason: 'Charged twice; the bank reversed it.',
        ),
      ]);
    _seedHistory();
    _settlements
      ..clear()
      ..addAll([
        Settlement(
          id: 'st_jul',
          spaceId: 's_flat',
          fromUserId: 'u_mira',
          toUserId: 'u_me',
          amountMinor: 6200,
          currency: 'EUR',
          createdAt: _d('2026-07-31'),
          settledAt: _d('2026-07-31'),
          status: SettlementStatus.confirmed,
          note: 'July balance',
          cycleId: 'cycle_flat_july',
          proposedByUserId: 'u_mira',
          confirmedByUserId: 'u_me',
        ),
        Settlement(
          id: 'st_pend',
          spaceId: 's_tokyo',
          fromUserId: 'u_mira',
          toUserId: 'u_me',
          amountMinor: 5000,
          currency: 'JPY',
          createdAt: _d('2026-08-14'),
          note: 'Part of the trip',
          proposedByUserId: 'u_mira',
        ),
      ]);
    _cycles
      ..clear()
      ..add(
        SpaceCycle(
          id: 'cycle_flat_july',
          spaceId: 's_flat',
          label: 'July 2026',
          startedAt: _d('2026-07-01'),
          endedAt: _d('2026-07-31'),
          expenseIds: const ['x_jul_rent', 'x_jul_shop'],
          settlementIds: const ['st_jul'],
          spentMinor: 240000,
          currency: 'EUR',
          budgetLimitMinor: 300000,
          memberPaidMinor: const {'u_me': 150000, 'u_mira': 90000},
          memberResponsibilityMinor: const {'u_me': 143800, 'u_mira': 96200},
          categoryTotalsMinor: const {'c_hou': 180000, 'c_gro': 60000},
        ),
      );
    _budgets
      ..clear()
      ..addAll(const [
        Budget(
          id: 'b_gro',
          name: 'Groceries',
          scope: BudgetScope.personal,
          categoryId: 'c_gro',
          limitMinor: 25000,
          currency: 'EUR',
          rollover: true,
        ),
        Budget(
          id: 'b_din',
          name: 'Eating out',
          scope: BudgetScope.personal,
          categoryId: 'c_din',
          limitMinor: 12000,
          currency: 'EUR',
        ),
        Budget(
          id: 'b_sho',
          name: 'Shopping',
          scope: BudgetScope.personal,
          categoryId: 'c_sho',
          limitMinor: 6000,
          currency: 'EUR',
        ),
        Budget(
          id: 'b_cof',
          name: 'Coffee',
          scope: BudgetScope.personal,
          categoryId: 'c_cof',
          limitMinor: 1500,
          currency: 'EUR',
          period: BudgetPeriod.weekly,
        ),
        Budget(
          id: 'b_trv',
          name: 'Travel',
          scope: BudgetScope.personal,
          categoryId: 'c_trv',
          limitMinor: 240000,
          currency: 'EUR',
          period: BudgetPeriod.yearly,
        ),
        Budget(
          id: 'b_futil',
          name: 'Utilities',
          scope: BudgetScope.space,
          spaceId: 's_flat',
          categoryId: 'c_uti',
          limitMinor: 15000,
          currency: 'EUR',
        ),
        Budget(
          id: 'b_tdin',
          name: 'Eating out',
          scope: BudgetScope.space,
          spaceId: 's_tokyo',
          categoryId: 'c_din',
          limitMinor: 40000,
          currency: 'JPY',
        ),
      ]);
    _subscriptions
      ..clear()
      ..addAll([
        _sub(
          'sb_gym',
          'Urban Sports',
          3900,
          'a_n26',
          'c_hea',
          'health',
          1,
          '2026-09-01',
          '2026-08-01',
        ),
        _sub(
          'sb_nflx',
          'Netflix',
          1099,
          'a_visa',
          'c_ent',
          'entertainment',
          6,
          '2026-09-06',
          '2026-08-06',
        ),
        _sub(
          'sb_spot',
          'Spotify',
          1099,
          'a_rev',
          'c_ent',
          'entertainment',
          18,
          '2026-08-18',
          '2026-07-18',
        ),
        _sub(
          'sb_icl',
          'iCloud+',
          299,
          'a_visa',
          'c_fee',
          'receipt',
          14,
          '2026-08-14',
          '2026-07-14',
        ),
        Subscription(
          id: 'sb_dom',
          name: 'Domain renewal',
          amountMinor: 1400,
          currency: 'EUR',
          accountId: 'a_rev',
          categoryId: 'c_fee',
          icon: 'link',
          cadence: const SubscriptionCadence(
            frequency: 'YEARLY',
            monthOfYear: 11,
            dayOfMonth: 3,
          ),
          startsOn: _d('2021-11-03'),
          nextDueOn: _d('2026-11-03'),
          lastPaidOn: _d('2025-11-03'),
        ),
        Subscription(
          id: 'sb_pod',
          name: 'Podcast host',
          amountMinor: 1900,
          currency: 'EUR',
          accountId: 'a_rev',
          categoryId: 'c_ent',
          icon: 'entertainment',
          cadence: const SubscriptionCadence(dayOfMonth: 22),
          startsOn: _d('2024-02-22'),
          lastPaidOn: _d('2026-06-22'),
          status: SubscriptionStatus.paused,
        ),
        // The same engine, in its non-subscription shape.
        Subscription(
          id: 'sb_rent',
          name: 'Rent',
          amountMinor: 128000,
          currency: 'EUR',
          accountId: 'a_n26',
          categoryId: 'c_hou',
          icon: 'housing',
          cadence: const SubscriptionCadence(dayOfMonth: 1),
          startsOn: _d('2025-09-01'),
          nextDueOn: _d('2026-09-01'),
          lastPaidOn: _d('2026-08-01'),
          kind: RecurringKind.template,
          paymentMethodId: 'pm_sepa',
        ),
        Subscription(
          id: 'sb_pay',
          name: 'Monthly salary',
          amountMinor: 385000,
          currency: 'EUR',
          accountId: 'a_rev',
          categoryId: 'c_sal',
          icon: 'income',
          cadence: const SubscriptionCadence(dayOfMonth: 1),
          startsOn: _d('2024-01-01'),
          nextDueOn: _d('2026-09-01'),
          lastPaidOn: _d('2026-08-01'),
          kind: RecurringKind.template,
          eventType: MoneyEventType.income,
        ),
      ]);
    _notifications
      ..clear()
      ..addAll([
        PockitoNotification(
          id: 'n_1',
          type: 'AI_APPROVAL',
          at: DateTime.parse('2026-08-15T14:32'),
          title: 'Approval needed',
          body: 'ChatGPT wants to record a payment',
          destination: '/ai/approvals',
        ),
        PockitoNotification(
          id: 'n_2',
          type: 'SETTLEMENT_REQUEST',
          at: DateTime.parse('2026-08-14T18:40'),
          title: 'Settlement request',
          body: 'Mira says she paid you ¥5,000',
          destination: '/spaces/s_tokyo/settlements/st_pend',
          entityId: 'st_pend',
        ),
        PockitoNotification(
          id: 'n_3',
          type: 'AI_CHANGE',
          at: DateTime.parse('2026-08-13T19:12'),
          title: 'Expense added',
          body: 'ChatGPT added Dinner at Lokal to Flat',
          destination: '/spaces/s_flat/expenses/x_lokal',
          entityId: 'x_lokal',
        ),
        PockitoNotification(
          id: 'n_4',
          type: 'EXPENSE_ADDED',
          at: DateTime.parse('2026-08-09T11:02'),
          title: 'Shared expense',
          body: 'Mira added Weekly shop to Flat',
          destination: '/spaces/s_flat/expenses/x_shop',
          entityId: 'x_shop',
          read: true,
        ),
        PockitoNotification(
          id: 'n_5',
          type: 'BUDGET_ALERT',
          at: DateTime.parse('2026-08-08T09:30'),
          title: 'Budget reached',
          body: 'You have used 100% of Shopping',
          destination: '/budgets/b_sho',
          entityId: 'b_sho',
          read: true,
        ),
        PockitoNotification(
          id: 'n_6',
          type: 'SUBSCRIPTION_DUE',
          at: DateTime.parse('2026-08-16T08:00'),
          title: 'Spotify is due',
          body: '€10.99 comes out of Revolut on 18 August',
          destination: '/subscriptions/sb_spot',
          entityId: 'sb_spot',
        ),
      ]);
    _aiConnections
      ..clear()
      ..addAll([
        AiConnection(
          id: 'con_gpt',
          name: 'ChatGPT',
          status: 'ACTIVE',
          scopes: const [
            'Accounts',
            'Transactions',
            'Spaces',
            'Balances',
            'Write expenses',
          ],
          createdAt: _d('2026-08-12'),
          lastUsedAt: DateTime.parse('2026-08-15T14:32'),
          writeCount: 14,
          readCount: 312,
        ),
        AiConnection(
          id: 'con_cla',
          name: 'Claude',
          status: 'ACTIVE',
          scopes: const ['Accounts', 'Transactions', 'Analytics'],
          createdAt: _d('2026-08-05'),
          lastUsedAt: DateTime.parse('2026-08-15T09:12'),
          readCount: 87,
        ),
        AiConnection(
          id: 'con_lab',
          name: 'Finance Sidekick',
          status: 'SUSPENDED',
          scopes: const ['Transactions', 'Analytics'],
          createdAt: _d('2026-08-14'),
          lastUsedAt: DateTime.parse('2026-08-14T22:10'),
          verified: false,
          readCount: 9,
        ),
      ]);
    _aiApprovals
      ..clear()
      ..add(
        const AiApproval(
          id: 'apr_1',
          client: 'ChatGPT',
          summary: 'Record that Mira paid you ¥5,000',
          reason: 'You told ChatGPT that Mira paid part of the trip balance.',
          impact:
              'Your Tokyo Trip balance falls by ¥5,000 and Cash increases by ¥5,000.',
          spaceId: 's_tokyo',
          fromUserId: 'u_mira',
          toUserId: 'u_me',
          amountMinor: 5000,
          accountId: 'a_cash',
        ),
      );
    _invitations
      ..clear()
      ..addAll([
        SpaceInvitation(
          id: 'inv_pending',
          spaceId: 's_tokyo',
          name: 'Lina',
          email: 'lina@example.com',
          invitedAt: _d('2026-08-12'),
          expiresAt: _d('2026-08-19'),
          role: SpaceRole.member,
          invitedByUserId: 'u_me',
        ),
        SpaceInvitation(
          id: 'inv_expired',
          spaceId: 's_flat',
          name: 'Tom',
          email: 'tom@example.com',
          invitedAt: _d('2026-07-20'),
          expiresAt: _d('2026-07-27'),
          role: SpaceRole.viewer,
          invitedByUserId: 'u_me',
        ),
      ]);
    _seedActivity();
    if (stressScale > 0) _seedStress();
  }

  /// Six months of history behind the current month, so trends and
  /// previous-period comparisons have something real to read.
  void _seedHistory() {
    const shape = <int, List<List<Object>>>{
      1: [
        ['c_gro', 21400],
        ['c_din', 9800],
        ['c_tra', 4900],
        ['c_sho', 5400],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
      2: [
        ['c_gro', 24800],
        ['c_din', 13600],
        ['c_tra', 4900],
        ['c_sho', 3200],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
      3: [
        ['c_gro', 19600],
        ['c_din', 8200],
        ['c_tra', 4900],
        ['c_sho', 12400],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
      4: [
        ['c_gro', 23100],
        ['c_din', 11400],
        ['c_tra', 4900],
        ['c_sho', 4100],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
      5: [
        ['c_gro', 26200],
        ['c_din', 14900],
        ['c_tra', 4900],
        ['c_sho', 6800],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
      6: [
        ['c_gro', 22400],
        ['c_din', 10200],
        ['c_tra', 4900],
        ['c_sho', 2900],
        ['c_ent', 2198],
        ['c_hea', 3900],
      ],
    };
    const names = <String, String>{
      'c_gro': 'Groceries',
      'c_din': 'Restaurants',
      'c_tra': 'Transport',
      'c_sho': 'Shopping',
      'c_ent': 'Streaming',
      'c_hea': 'Urban Sports',
    };
    const rentMinor = 128000;
    const salaryMinor = 385000;
    var sweptToSavings = 0;
    for (final entry in shape.entries) {
      final month = DateTime(today.year, today.month - entry.key);
      var outflow = rentMinor;
      for (final row in entry.value) {
        final categoryId = row[0] as String;
        final amount = row[1] as int;
        outflow += amount;
        _transactions.add(
          MoneyTransaction(
            id: 'th_${month.year}${month.month}_$categoryId',
            type: MoneyEventType.expense,
            amountMinor: amount,
            currency: 'EUR',
            occurredOn: DateTime(month.year, month.month, 12),
            merchant: names[categoryId] ?? 'Spending',
            fromAccountId: 'a_rev',
            categoryId: categoryId,
          ),
        );
      }
      _transactions
        ..add(
          MoneyTransaction(
            id: 'th_${month.year}${month.month}_rent',
            type: MoneyEventType.expense,
            amountMinor: rentMinor,
            currency: 'EUR',
            occurredOn: DateTime(month.year, month.month, 1),
            merchant: 'Rent',
            fromAccountId: 'a_rev',
            categoryId: 'c_hou',
          ),
        )
        ..add(
          MoneyTransaction(
            id: 'th_${month.year}${month.month}_income',
            type: MoneyEventType.income,
            amountMinor: salaryMinor,
            currency: 'EUR',
            occurredOn: DateTime(month.year, month.month, 1),
            merchant: 'Monthly salary',
            toAccountId: 'a_rev',
            categoryId: 'c_sal',
          ),
        );
      // Whatever the month did not consume was swept into savings, the way a
      // real current account behaves. Without it, six months of history would
      // silently pile two years of salary into the everyday account.
      final surplus = salaryMinor - outflow;
      if (surplus > 0) {
        sweptToSavings += surplus;
        _transactions.add(
          MoneyTransaction(
            id: 'th_${month.year}${month.month}_sweep',
            type: MoneyEventType.transfer,
            amountMinor: surplus,
            currency: 'EUR',
            occurredOn: DateTime(month.year, month.month, 28),
            merchant: 'To Savings',
            fromAccountId: 'a_rev',
            toAccountId: 'a_sav',
          ),
        );
      }
    }
    // The savings account's opening balance is what was in it *before* the
    // history we now record, so today's balance is unchanged by adding it.
    final savingsIndex = _accounts.indexWhere((item) => item.id == 'a_sav');
    if (savingsIndex >= 0) {
      _accounts[savingsIndex] = _accounts[savingsIndex].copyWith(
        openingBalanceMinor:
            _accounts[savingsIndex].openingBalanceMinor - sweptToSavings,
      );
    }
  }

  void _seedActivity() {
    _activity.addAll([
      SpaceActivityEvent(
        id: 'act_1',
        spaceId: 's_flat',
        actorUserId: 'u_mira',
        at: DateTime.parse('2026-08-09T11:02'),
        type: SpaceActivityType.expenseAdded,
        summary: 'Mira added Weekly shop',
        entityId: 'x_shop',
        entityLabel: 'Weekly shop',
        detail: '€84.00 · split 60/40',
      ),
      SpaceActivityEvent(
        id: 'act_2',
        spaceId: 's_flat',
        actorUserId: 'u_me',
        at: DateTime.parse('2026-07-31T20:10'),
        type: SpaceActivityType.settlementConfirmed,
        summary: 'You confirmed Mira’s €62.00 payment',
        entityId: 'st_jul',
        entityLabel: 'July balance',
      ),
      SpaceActivityEvent(
        id: 'act_3',
        spaceId: 's_tokyo',
        actorUserId: 'u_kana',
        at: DateTime.parse('2026-08-11T09:44'),
        type: SpaceActivityType.permissionDenied,
        summary: 'Kana tried to add an expense',
        outcome: ActivityOutcome.denied,
        permission: 'canAddExpense',
        detail: 'Viewers can see everything and change nothing.',
      ),
      SpaceActivityEvent(
        id: 'act_4',
        spaceId: 's_tokyo',
        actorUserId: 'u_me',
        at: DateTime.parse('2026-08-01T10:00'),
        type: SpaceActivityType.roleChanged,
        summary: 'You made Mira an admin',
        entityId: 'u_mira',
        entityLabel: 'Mira',
        detail: 'Member → Admin',
      ),
      SpaceActivityEvent(
        id: 'act_5',
        spaceId: 's_tokyo',
        actorUserId: 'u_mira',
        at: DateTime.parse('2026-08-14T18:40'),
        type: SpaceActivityType.settlementProposed,
        summary: 'Mira says she paid you ¥5,000',
        entityId: 'st_pend',
        entityLabel: 'Part of the trip',
      ),
    ]);
  }

  /// Grows the dataset to the volumes the audit asks to be verified against.
  void _seedStress() {
    final random = math.Random(7);
    for (var index = 0; index < 22; index++) {
      final id = 'sx_$index';
      _spaces.add(
        SharedSpace(
          id: id,
          name: index.isEven ? 'Household' : 'Trip ${index + 1}',
          type: index.isEven ? SpaceType.household : SpaceType.trip,
          currency: 'EUR',
          members: [
            const SpaceMember(userId: 'u_me', role: SpaceRole.owner),
            const SpaceMember(userId: 'u_mira'),
          ],
          defaultSplitMethod: SplitMethod.equal,
          colorIndex: index % 12,
          icon: index.isEven ? 'housing' : 'travel',
        ),
      );
    }
    // One Space carrying 50 members.
    final crowd = <SpaceMember>[
      const SpaceMember(userId: 'u_me', role: SpaceRole.owner),
    ];
    for (var index = 0; index < 49; index++) {
      final userId = 'u_crowd_$index';
      _users.add(
        PockitoUser(
          id: userId,
          name: 'Member ${index + 1}',
          initials: 'M${index + 1}',
        ),
      );
      crowd.add(SpaceMember(userId: userId));
    }
    _spaces.add(
      SharedSpace(
        id: 's_crowd',
        name: 'Office lunch club',
        type: SpaceType.friends,
        currency: 'EUR',
        members: crowd,
        defaultSplitMethod: SplitMethod.equal,
        colorIndex: 6,
        icon: 'group',
      ),
    );
    for (var index = 0; index < 500; index++) {
      final day = today.subtract(Duration(days: random.nextInt(360)));
      _transactions.add(
        MoneyTransaction(
          id: 'ts_$index',
          type: MoneyEventType.expense,
          amountMinor: 200 + random.nextInt(24000),
          currency: 'EUR',
          occurredOn: DateTime(day.year, day.month, day.day),
          merchant: 'Sample merchant $index',
          fromAccountId: 'a_rev',
          categoryId: _categories[random.nextInt(_categories.length)].id,
        ),
      );
    }
  }

  void _seedEmpty() {
    _seed();
    _profile = const UserProfile(
      userId: 'u_me',
      displayName: 'New user',
      email: '',
      country: 'JP',
      countryName: 'Japan',
      reportingCurrency: 'JPY',
      locale: 'en-JP',
      timezone: 'Asia/Tokyo',
    );
    _users
      ..clear()
      ..add(
        const PockitoUser(
          id: 'u_me',
          name: 'New user',
          initials: 'NU',
          isYou: true,
        ),
      );
    _accounts.clear();
    _spaces.clear();
    _sharedExpenses.clear();
    _transactions.clear();
    _settlements.clear();
    _budgets.clear();
    _subscriptions.clear();
    _notifications.clear();
    _aiConnections.clear();
    _aiApprovals.clear();
    _invitations.clear();
    _cycles.clear();
    _activity.clear();
    _tags.clear();
    _paymentMethods.clear();
    _savedViews.clear();
  }

  MoneyTransaction _txn(
    String id,
    MoneyEventType type,
    int amount,
    String currency,
    String date,
    String merchant, {
    String? from,
    String? to,
    String? category,
    String? split,
    String? subscription,
    String? paymentMethod,
    String note = '',
    List<String> tags = const [],
  }) => MoneyTransaction(
    id: id,
    type: type,
    amountMinor: amount,
    currency: currency,
    occurredOn: _d(date),
    merchant: merchant,
    fromAccountId: from,
    toAccountId: to,
    categoryId: category,
    splitId: split,
    subscriptionId: subscription,
    paymentMethodId: paymentMethod,
    note: note,
    tagIds: tags,
  );

  Subscription _sub(
    String id,
    String name,
    int amount,
    String account,
    String category,
    String icon,
    int day,
    String next,
    String paid,
  ) => Subscription(
    id: id,
    name: name,
    amountMinor: amount,
    currency: 'EUR',
    accountId: account,
    categoryId: category,
    icon: icon,
    cadence: SubscriptionCadence(dayOfMonth: day),
    startsOn: _d('2024-01-01'),
    nextDueOn: _d(next),
    lastPaidOn: _d(paid),
  );

  // ---------------------------------------------------------------------------
  // Lookups
  // ---------------------------------------------------------------------------

  @override
  Account? accountById(String id) => _first(_accounts, (item) => item.id == id);
  @override
  Category? categoryById(String id) =>
      _first(_categories, (item) => item.id == id);
  @override
  Tag? tagById(String id) => _first(_tags, (item) => item.id == id);
  @override
  PaymentMethod? paymentMethodById(String id) =>
      _first(_paymentMethods, (item) => item.id == id);
  @override
  SharedSpace? spaceById(String id) => _first(_spaces, (item) => item.id == id);
  @override
  SharedExpense? sharedExpenseById(String id) =>
      _first(_sharedExpenses, (item) => item.id == id);
  @override
  MoneyTransaction? transactionById(String id) =>
      _first(_transactions, (item) => item.id == id);
  @override
  Subscription? subscriptionById(String id) =>
      _first(_subscriptions, (item) => item.id == id);
  @override
  Settlement? settlementById(String id) =>
      _first(_settlements, (item) => item.id == id);
  @override
  Budget? budgetById(String id) => _first(_budgets, (item) => item.id == id);
  @override
  PockitoUser? userById(String id) => _first(_users, (item) => item.id == id);

  @override
  List<Category> categoryChildren(String? parentId) => List.unmodifiable(
    _categories.where((item) => !item.hidden && item.parentId == parentId),
  );

  T? _first<T>(Iterable<T> items, bool Function(T) test) {
    for (final item in items) {
      if (test(item)) return item;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Permissions
  // ---------------------------------------------------------------------------

  @override
  SpacePermissions permissionsFor(String spaceId) {
    final space = spaceById(spaceId);
    if (space == null) return SpacePermissions.none;
    final member = _first(
      space.members,
      (item) => item.userId == currentUserId && item.active,
    );
    if (member == null) return SpacePermissions.none;
    return SpacePermissions.forRole(
      member.role,
      archived: space.status == SpaceStatus.archived,
    );
  }

  SpacePermissions _permissionsForMember(SharedSpace space, SpaceMember m) =>
      SpacePermissions.forRole(
        m.role,
        archived: space.status == SpaceStatus.archived,
      );

  @override
  List<String> whoCanHelp(String spaceId, String permission) {
    final space = spaceById(spaceId);
    if (space == null) return const [];
    bool holds(SpacePermissions p) => switch (permission) {
      'canAddExpense' => p.canAddExpense,
      'canEditAnyExpense' => p.canEditAnyExpense,
      'canVoidAnyExpense' => p.canVoidAnyExpense,
      'canSettle' => p.canSettle,
      'canManageBudgets' => p.canManageBudgets,
      'canInvite' => p.canInvite,
      'canRemoveMember' => p.canRemoveMember,
      'canChangeRoles' => p.canChangeRoles,
      'canEditSettings' => p.canEditSettings,
      'canArchive' => p.canArchive,
      'canCloseCycle' => p.canCloseCycle,
      _ => false,
    };
    return space.members
        .where(
          (member) =>
              member.active &&
              member.userId != currentUserId &&
              holds(_permissionsForMember(space, member)),
        )
        .map((member) => userById(member.userId)?.name ?? 'A member')
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Derived money
  // ---------------------------------------------------------------------------

  Iterable<MoneyTransaction> get _live =>
      _transactions.where((item) => item.countsTowardsBalances);

  Iterable<SharedExpense> get _liveShared =>
      _sharedExpenses.where((item) => item.countsTowardsBalances);

  @override
  int accountBalance(Account account) {
    var value = account.openingBalanceMinor;
    for (final transaction in _live) {
      if (transaction.fromAccountId == account.id) {
        value -= transaction.amountMinor;
        if (transaction.feeMinor > 0 &&
            (transaction.feeCurrency ?? transaction.currency) ==
                account.currency) {
          value -= transaction.feeMinor;
        }
      }
      if (transaction.toAccountId == account.id) {
        value +=
            transaction.destinationCurrency == account.currency &&
                transaction.destinationAmountMinor != null
            ? transaction.destinationAmountMinor!
            : transaction.amountMinor;
      }
    }
    return value;
  }

  @override
  int? accountAvailable(Account account) {
    final limit = account.creditLimitMinor;
    if (limit == null) return null;
    return limit + accountBalance(account);
  }

  @override
  int? convertMinor(int amountMinor, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amountMinor;
    final quote = fxQuote(fromCurrency, toCurrency);
    final fromInfo = currencies[fromCurrency];
    final toInfo = currencies[toCurrency];
    if (quote == null || fromInfo == null || toInfo == null) {
      return null;
    }

    final fromScale = math.pow(10, fromInfo.decimals);
    final toScale = math.pow(10, toInfo.decimals);
    final amountInMajorUnits = amountMinor / fromScale;
    final convertedMajorUnits = amountInMajorUnits * quote.rate;
    return (convertedMajorUnits * toScale).round();
  }

  @override
  FxQuote? fxQuote(String fromCurrency, String toCurrency, {FxRateMode? mode}) {
    final selectedMode = mode ?? _fxSettings.mode;
    if (fromCurrency == toCurrency) {
      return FxQuote(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        rate: 1,
        mode: selectedMode,
        updatedAt: _fxSettings.lastUpdatedAt,
        source: selectedMode == FxRateMode.manual
            ? FxProvider.manualRate
            : _fxSettings.provider,
      );
    }
    if (selectedMode == FxRateMode.manual) {
      final direct = _fxSettings.manualRates['${fromCurrency}_$toCurrency'];
      final reverse = _fxSettings.manualRates['${toCurrency}_$fromCurrency'];
      final rate =
          direct ?? (reverse == null || reverse == 0 ? null : 1 / reverse);
      if (rate == null) return null;
      return FxQuote(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        rate: rate,
        mode: FxRateMode.manual,
        updatedAt: _fxSettings.lastUpdatedAt,
        source: FxProvider.manualRate,
      );
    }
    final fromRate = ratesToEur[fromCurrency];
    final toRate = ratesToEur[toCurrency];
    if (fromRate == null || toRate == null) return null;
    return FxQuote(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
      rate: fromRate / toRate,
      mode: FxRateMode.automatic,
      updatedAt: _fxSettings.lastUpdatedAt,
      source: _fxSettings.provider,
    );
  }

  @override
  int netWorthMinor(String currency) => _accounts
      .where((account) => !account.archived)
      .map(
        (account) =>
            convertMinor(accountBalance(account), account.currency, currency),
      )
      .whereType<int>()
      .fold(0, (sum, value) => sum + value);

  bool _sameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  @override
  SpendingSummary spendingForMonth(DateTime month) {
    var spent = 0;
    var outflow = 0;
    var income = 0;
    final reporting = profile.reportingCurrency;
    for (final transaction in _live.where(
      (item) => _sameMonth(item.occurredOn, month),
    )) {
      final converted = convertMinor(
        transaction.amountMinor,
        transaction.currency,
        reporting,
      );
      if (converted == null) continue;
      if (transaction.type == MoneyEventType.expense) {
        outflow += converted;
        if (transaction.splitId == null) spent += converted;
      } else if (transaction.type == MoneyEventType.income) {
        income += converted;
      }
    }
    for (final expense in _liveShared.where(
      (item) => _sameMonth(item.occurredOn, month),
    )) {
      final mine = _first(
        expense.shares,
        (share) => share.userId == currentUserId,
      );
      if (mine == null) continue;
      spent += convertMinor(mine.amountMinor, expense.currency, reporting) ?? 0;
    }
    return SpendingSummary(
      spentMinor: spent,
      outflowMinor: outflow,
      incomeMinor: income,
      currency: reporting,
    );
  }

  static const _monthNames = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  PeriodComparison spendingComparison(DateTime month) {
    final previous = DateTime(month.year, month.month - 1);
    return PeriodComparison(
      currentMinor: spendingForMonth(month).spentMinor,
      previousMinor: spendingForMonth(previous).spentMinor,
      currency: profile.reportingCurrency,
      previousLabel: _monthNames[previous.month - 1],
    );
  }

  @override
  List<SeriesPoint> spendSeries(DateTime month, {int months = 6}) {
    final points = <SeriesPoint>[];
    for (var offset = months - 1; offset >= 0; offset--) {
      final target = DateTime(month.year, month.month - offset);
      points.add(
        SeriesPoint(
          at: target,
          valueMinor: spendingForMonth(target).spentMinor,
          label: _monthNames[target.month - 1].substring(0, 3),
        ),
      );
    }
    return points;
  }

  @override
  List<CategorySlice> categoryBreakdown(DateTime month, {int limit = 6}) {
    final reporting = profile.reportingCurrency;
    final totals = <String, int>{};
    for (final transaction in _live.where(
      (item) =>
          item.type == MoneyEventType.expense &&
          item.splitId == null &&
          item.categoryId != null &&
          _sameMonth(item.occurredOn, month),
    )) {
      final converted =
          convertMinor(
            transaction.amountMinor,
            transaction.currency,
            reporting,
          ) ??
          0;
      totals[transaction.categoryId!] =
          (totals[transaction.categoryId!] ?? 0) + converted;
    }
    for (final expense in _liveShared.where(
      (item) => _sameMonth(item.occurredOn, month),
    )) {
      final mine = _first(
        expense.shares,
        (share) => share.userId == currentUserId,
      );
      if (mine == null) continue;
      final converted =
          convertMinor(mine.amountMinor, expense.currency, reporting) ?? 0;
      totals[expense.categoryId] =
          (totals[expense.categoryId] ?? 0) + converted;
    }
    final entries = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final slices = <CategorySlice>[];
    for (final entry in entries.take(limit)) {
      final category = categoryById(entry.key);
      slices.add(
        CategorySlice(
          id: entry.key,
          label: category?.name ?? 'Uncategorised',
          valueMinor: entry.value,
          colorIndex: category?.colorIndex ?? 10,
          icon: category?.icon ?? 'receipt',
        ),
      );
    }
    if (entries.length > limit) {
      slices.add(
        CategorySlice(
          id: '__other__',
          // The UI translates this; the id is what identifies it.
          label: 'Everything else',
          valueMinor: entries
              .skip(limit)
              .fold(0, (sum, entry) => sum + entry.value),
          colorIndex: 10,
          icon: 'receipt',
        ),
      );
    }
    return slices;
  }

  @override
  List<SeriesPoint> accountBalanceSeries(Account account, {int days = 30}) {
    final closing = accountBalance(account);
    final start = DateTime(
      today.year,
      today.month,
      today.day,
    ).subtract(Duration(days: days - 1));
    // Walk backwards from the known closing balance, undoing each day's
    // movement, then emit the series forwards.
    final deltas = List<int>.filled(days, 0);
    for (final transaction in _live) {
      final when = DateTime(
        transaction.occurredOn.year,
        transaction.occurredOn.month,
        transaction.occurredOn.day,
      );
      if (when.isBefore(start)) continue;
      final index = when.difference(start).inDays;
      if (index < 0 || index >= days) continue;
      if (transaction.fromAccountId == account.id) {
        deltas[index] -= transaction.amountMinor;
      }
      if (transaction.toAccountId == account.id) {
        deltas[index] +=
            transaction.destinationCurrency == account.currency &&
                transaction.destinationAmountMinor != null
            ? transaction.destinationAmountMinor!
            : transaction.amountMinor;
      }
    }
    final running = List<int>.filled(days, 0);
    var value = closing;
    for (var index = days - 1; index >= 0; index--) {
      running[index] = value;
      value -= deltas[index];
    }
    return [
      for (var index = 0; index < days; index++)
        SeriesPoint(
          at: start.add(Duration(days: index)),
          valueMinor: running[index],
          label: '${start.add(Duration(days: index)).day}',
        ),
    ];
  }

  @override
  int memberBalance(String spaceId, String userId, {bool lifetime = false}) {
    final space = spaceById(spaceId);
    if (space == null) return 0;
    return _memberBalances(space, lifetime: lifetime)[userId] ?? 0;
  }

  Map<String, int> _memberBalances(
    SharedSpace space, {
    required bool lifetime,
  }) {
    final net = <String, int>{
      for (final member in space.members) member.userId: 0,
    };
    for (final expense in _liveShared.where(
      (item) =>
          item.spaceId == space.id &&
          (lifetime || item.cycleId == space.currentCycleId),
    )) {
      for (final payer in expense.payers) {
        net[payer.userId] = (net[payer.userId] ?? 0) + payer.amountMinor;
      }
      for (final share in expense.shares) {
        net[share.userId] = (net[share.userId] ?? 0) - share.amountMinor;
      }
    }
    for (final settlement in _settlements.where(
      (item) =>
          item.spaceId == space.id &&
          item.isConfirmed &&
          (lifetime || item.cycleId == space.currentCycleId),
    )) {
      net[settlement.fromUserId] =
          (net[settlement.fromUserId] ?? 0) + settlement.amountMinor;
      net[settlement.toUserId] =
          (net[settlement.toUserId] ?? 0) - settlement.amountMinor;
    }
    return net;
  }

  List<Settlement> _plan(SharedSpace space, Map<String, int> balances) {
    final debtors =
        balances.entries
            .where((entry) => entry.value < 0)
            .map((entry) => MapEntry(entry.key, -entry.value))
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final creditors =
        balances.entries.where((entry) => entry.value > 0).toList()
          ..sort((a, b) => b.value.compareTo(a.value));
    final result = <Settlement>[];
    var debtorIndex = 0;
    var creditorIndex = 0;
    while (debtorIndex < debtors.length && creditorIndex < creditors.length) {
      final debtor = debtors[debtorIndex];
      final creditor = creditors[creditorIndex];
      final amount = math.min(debtor.value, creditor.value);
      if (amount > 0) {
        result.add(
          Settlement(
            id: '',
            spaceId: space.id,
            fromUserId: debtor.key,
            toUserId: creditor.key,
            amountMinor: amount,
            currency: space.currency,
            createdAt: today,
            cycleId: space.currentCycleId,
            proposedByUserId: currentUserId,
          ),
        );
      }
      debtors[debtorIndex] = MapEntry(debtor.key, debtor.value - amount);
      creditors[creditorIndex] = MapEntry(
        creditor.key,
        creditor.value - amount,
      );
      if (debtors[debtorIndex].value == 0) debtorIndex++;
      if (creditors[creditorIndex].value == 0) creditorIndex++;
    }
    return result;
  }

  @override
  List<Settlement> settlementRecommendations(String spaceId) {
    final space = spaceById(spaceId);
    if (space == null) return const [];
    return _plan(space, _memberBalances(space, lifetime: false));
  }

  @override
  List<DebtEdge> debtEdges() {
    final edges = <DebtEdge>[];
    for (final space in _spaces.where(
      (item) => item.status == SpaceStatus.active,
    )) {
      for (final settlement in _plan(
        space,
        _memberBalances(space, lifetime: false),
      )) {
        if (settlement.fromUserId != currentUserId &&
            settlement.toUserId != currentUserId) {
          continue;
        }
        edges.add(
          DebtEdge(
            spaceId: space.id,
            fromUserId: settlement.fromUserId,
            toUserId: settlement.toUserId,
            amountMinor: settlement.amountMinor,
            currency: settlement.currency,
          ),
        );
      }
    }
    edges.sort((a, b) => b.amountMinor.compareTo(a.amountMinor));
    return edges;
  }

  @override
  SharedSummary sharedSummary() {
    var owed = 0;
    var owing = 0;
    for (final space in _spaces.where(
      (item) => item.status == SpaceStatus.active,
    )) {
      final converted = convertMinor(
        memberBalance(space.id, currentUserId),
        space.currency,
        profile.reportingCurrency,
      );
      if (converted == null) continue;
      if (converted >= 0) {
        owed += converted;
      } else {
        owing += -converted;
      }
    }
    return SharedSummary(
      owedMinor: owed,
      owingMinor: owing,
      currency: profile.reportingCurrency,
    );
  }

  @override
  List<ActionItem> actionItems() {
    final items = <ActionItem>[];
    for (final invitation in _invitations.where(
      (item) =>
          item.status == InvitationStatus.pending &&
          !item.isExpiredAt(today) &&
          item.userId == currentUserId,
    )) {
      items.add(
        ActionItem(
          id: invitation.id,
          kind: ActionItemKind.invitation,
          title:
              'Invitation to ${spaceById(invitation.spaceId)?.name ?? 'a Space'}',
          detail: 'Review what you would be joining',
          destination: '/invite-review',
          priority: 0,
        ),
      );
    }
    for (final settlement in _settlements.where(
      (item) => item.canConfirm(currentUserId),
    )) {
      final other = userById(settlement.fromUserId)?.name ?? 'A member';
      items.add(
        ActionItem(
          id: settlement.id,
          kind: ActionItemKind.settlementProposal,
          title: '$other says they paid you',
          detail: 'in ${spaceById(settlement.spaceId)?.name ?? 'a Space'}',
          amountMinor: settlement.amountMinor,
          currency: settlement.currency,
          destination:
              '/spaces/${settlement.spaceId}/settlements/${settlement.id}',
          priority: 1,
        ),
      );
    }
    for (final approval in _aiApprovals.where(
      (item) => item.state == 'PENDING',
    )) {
      items.add(
        ActionItem(
          id: approval.id,
          kind: ActionItemKind.aiApproval,
          title: '${approval.client} needs approval',
          detail: approval.summary,
          destination: '/ai/approvals',
          priority: 3,
        ),
      );
    }
    for (final expense in _sharedExpenses.where((item) => item.isDraft)) {
      items.add(
        ActionItem(
          id: expense.id,
          kind: ActionItemKind.draftRecord,
          title: 'Draft: ${expense.title}',
          detail:
              'Waiting to be confirmed in '
              '${spaceById(expense.spaceId)?.name ?? 'a Space'}',
          destination: '/spaces/${expense.spaceId}/expenses/${expense.id}',
          priority: 2,
        ),
      );
    }
    for (final transaction in _transactions.where((item) => item.isDraft)) {
      items.add(
        ActionItem(
          id: transaction.id,
          kind: ActionItemKind.draftRecord,
          title: 'Draft: ${transaction.merchant}',
          detail: 'Waiting to be confirmed',
          destination: '/activity/${transaction.id}',
          priority: 2,
        ),
      );
    }
    for (final budget in _budgets) {
      final snapshot = budgetSnapshot(budget);
      if (snapshot.health == BudgetHealth.exceeded) {
        items.add(
          ActionItem(
            id: budget.id,
            kind: ActionItemKind.budgetBreach,
            title: '${budget.name} is over',
            detail: 'past the ${budget.period.noun} limit by',
            amountMinor: snapshot.remainingMinor.abs(),
            currency: budget.currency,
            destination: '/budgets/${budget.id}',
            priority: 4,
          ),
        );
      }
    }
    items.sort((a, b) => a.priority.compareTo(b.priority));
    return items;
  }

  @override
  FinancialHealth financialHealth(DateTime month) {
    final summary = spendingForMonth(month);
    final reporting = profile.reportingCurrency;
    var upcoming = 0;
    for (final subscription in subscriptions.where(
      (item) => item.status == SubscriptionStatus.active,
    )) {
      final due = subscription.nextDueOn;
      if (due == null || !_sameMonth(due, month) || due.isBefore(today)) {
        continue;
      }
      upcoming +=
          convertMinor(
            subscription.amountMinor,
            subscription.currency,
            reporting,
          ) ??
          0;
    }
    final net = summary.incomeMinor - summary.outflowMinor;
    final current = categoryBreakdown(month, limit: 99);
    final unusual = <CategorySlice>[];
    for (final slice in current) {
      if (slice.id == '__other__') continue;
      var history = 0;
      var months = 0;
      for (var offset = 1; offset <= 3; offset++) {
        final past = DateTime(month.year, month.month - offset);
        final match = _first(
          categoryBreakdown(past, limit: 99),
          (item) => item.id == slice.id,
        );
        if (match == null) continue;
        history += match.valueMinor;
        months++;
      }
      if (months == 0) continue;
      final average = history / months;
      if (average > 0 && slice.valueMinor > average * 1.5) {
        unusual.add(slice);
      }
    }
    return FinancialHealth(
      incomeMinor: summary.incomeMinor,
      outflowMinor: summary.outflowMinor,
      netMinor: net,
      disposableMinor: net - upcoming,
      upcomingMinor: upcoming,
      currency: reporting,
      savingsRate: summary.incomeMinor == 0 ? 0 : net / summary.incomeMinor,
      unusual: unusual,
    );
  }

  // ---------------------------------------------------------------------------
  // Budgets
  // ---------------------------------------------------------------------------

  @override
  BudgetWindow budgetWindow(Budget budget, DateTime reference) {
    final day = DateTime(reference.year, reference.month, reference.day);
    switch (budget.period) {
      case BudgetPeriod.weekly:
        final start = day.subtract(Duration(days: day.weekday - 1));
        return BudgetWindow(
          start: start,
          end: start.add(const Duration(days: 7)),
          label: 'Week of ${start.day} ${_monthNames[start.month - 1]}',
        );
      case BudgetPeriod.monthly:
        final start = DateTime(reference.year, reference.month);
        return BudgetWindow(
          start: start,
          end: DateTime(reference.year, reference.month + 1),
          label: '${_monthNames[start.month - 1]} ${start.year}',
        );
      case BudgetPeriod.quarterly:
        final quarter = ((reference.month - 1) ~/ 3) * 3 + 1;
        final start = DateTime(reference.year, quarter);
        return BudgetWindow(
          start: start,
          end: DateTime(reference.year, quarter + 3),
          label: 'Q${(quarter ~/ 3) + 1} ${start.year}',
        );
      case BudgetPeriod.yearly:
        return BudgetWindow(
          start: DateTime(reference.year),
          end: DateTime(reference.year + 1),
          label: '${reference.year}',
        );
      case BudgetPeriod.custom:
        final anchor = budget.startsOn ?? DateTime(reference.year);
        final length = math.max(1, budget.customPeriodDays);
        final elapsed = day.difference(anchor).inDays;
        final periods = elapsed < 0 ? 0 : elapsed ~/ length;
        final start = anchor.add(Duration(days: periods * length));
        return BudgetWindow(
          start: start,
          end: start.add(Duration(days: length)),
          label:
              '$length days from ${start.day} ${_monthNames[start.month - 1]}',
        );
    }
  }

  BudgetWindow _previousWindow(Budget budget, BudgetWindow window) {
    final before = window.start.subtract(const Duration(days: 1));
    return budgetWindow(budget, before);
  }

  int _budgetUsage(Budget budget, BudgetWindow window) {
    var used = 0;
    final categoryIds = budget.categoryIds.isNotEmpty
        ? budget.categoryIds.toSet()
        : budget.categoryId.isEmpty || budget.categoryId == 'all'
        ? <String>{}
        : {budget.categoryId, ..._descendantIds(budget.categoryId)};
    bool categoryMatches(String? id) =>
        categoryIds.isEmpty || (id != null && categoryIds.contains(id));
    bool accountMatches(String? id) =>
        budget.accountIds.isEmpty ||
        (id != null && budget.accountIds.contains(id));
    bool inWindow(DateTime when) =>
        !when.isBefore(window.start) && when.isBefore(window.end);

    if (budget.scope == BudgetScope.personal) {
      for (final transaction in _live.where(
        (item) =>
            categoryMatches(item.categoryId) &&
            accountMatches(item.fromAccountId) &&
            item.type == MoneyEventType.expense &&
            item.splitId == null &&
            inWindow(item.occurredOn),
      )) {
        used +=
            convertMinor(
              transaction.amountMinor,
              transaction.currency,
              budget.currency,
            ) ??
            0;
      }
      for (final expense in _liveShared.where(
        (item) => categoryMatches(item.categoryId) && inWindow(item.occurredOn),
      )) {
        final linked = _first(
          _live,
          (transaction) => transaction.splitId == expense.id,
        );
        if (!accountMatches(linked?.fromAccountId)) continue;
        final mine = _first(
          expense.shares,
          (share) => share.userId == currentUserId,
        );
        if (mine != null) {
          used +=
              convertMinor(
                mine.amountMinor,
                expense.currency,
                budget.currency,
              ) ??
              0;
        }
      }
    } else {
      final space = spaceById(budget.spaceId ?? '');
      for (final expense in _liveShared.where(
        (item) =>
            item.spaceId == budget.spaceId &&
            categoryMatches(item.categoryId) &&
            inWindow(item.occurredOn) &&
            (space == null || item.cycleId == space.currentCycleId),
      )) {
        used += expense.shares.fold(0, (sum, share) => sum + share.amountMinor);
      }
    }
    return used;
  }

  Set<String> _descendantIds(String categoryId) => _categories
      .where((item) => item.parentId == categoryId)
      .map((item) => item.id)
      .toSet();

  @override
  BudgetSnapshot budgetSnapshot(Budget budget) =>
      budgetSnapshotForMonth(budget, today);

  @override
  BudgetSnapshot budgetSnapshotForMonth(Budget budget, DateTime month) {
    // A month picker moves through months; a weekly or yearly budget is still
    // anchored to the day inside that month the user is looking at.
    final reference = _sameMonth(month, today)
        ? today
        : DateTime(month.year, month.month, 1);
    final window = budgetWindow(budget, reference);
    final used = _budgetUsage(budget, window);
    final previousWindow = _previousWindow(budget, window);
    final previousUsed = _budgetUsage(budget, previousWindow);
    final rollover = budget.rollover
        ? math.max(0, budget.limitMinor - previousUsed)
        : 0;
    final effectiveLimit = budget.limitMinor + rollover;
    final progress = effectiveLimit == 0 ? 0.0 : used / effectiveLimit;
    final health = progress > 1
        ? BudgetHealth.exceeded
        : progress >= .8
        ? BudgetHealth.near
        : BudgetHealth.healthy;
    final totalDays = window.end.difference(window.start).inDays;
    final elapsedDays = reference.difference(window.start).inDays + 1;
    final forecast = elapsedDays <= 0 || elapsedDays > totalDays
        ? used
        : (used / elapsedDays * totalDays).round();
    return BudgetSnapshot(
      budget: budget,
      usedMinor: used,
      remainingMinor: effectiveLimit - used,
      progress: progress,
      health: health,
      window: window,
      rolloverMinor: rollover,
      forecastMinor: forecast,
      previousUsedMinor: previousUsed,
    );
  }

  // ---------------------------------------------------------------------------
  // Import / export
  // ---------------------------------------------------------------------------

  @override
  ImportPreview previewImport(String csv) {
    final lines = const LineSplitter()
        .convert(csv)
        .where((line) => line.trim().isNotEmpty)
        .toList();
    if (lines.isEmpty) {
      return const ImportPreview(rows: [], headers: []);
    }
    final headers = _splitCsvLine(lines.first).map((h) => h.trim()).toList();
    int columnOf(String name) =>
        headers.indexWhere((h) => h.toLowerCase() == name);
    final dateIndex = columnOf('date');
    final descriptionIndex = columnOf('description');
    final amountIndex = columnOf('amount');
    final currencyIndex = columnOf('currency');
    final categoryIndex = columnOf('category');
    final accountIndex = columnOf('account');
    final rows = <ImportRow>[];
    for (var index = 1; index < lines.length; index++) {
      final cells = _splitCsvLine(lines[index]);
      String cell(int at) =>
          at < 0 || at >= cells.length ? '' : cells[at].trim();
      final description = cell(descriptionIndex);
      final rawDate = cell(dateIndex);
      final rawAmount = cell(amountIndex);
      final date = DateTime.tryParse(rawDate);
      final amount = double.tryParse(rawAmount.replaceAll(',', '.'));
      if (date == null || amount == null || description.isEmpty) {
        rows.add(
          ImportRow(
            lineNumber: index + 1,
            state: ImportRowState.invalid,
            description: description.isEmpty ? lines[index] : description,
            problem: date == null
                ? 'Could not read the date “$rawDate”'
                : amount == null
                ? 'Could not read the amount “$rawAmount”'
                : 'Missing a description',
          ),
        );
        continue;
      }
      final currency = cell(currencyIndex).isEmpty
          ? profile.reportingCurrency
          : cell(currencyIndex).toUpperCase();
      final scale = PockitoCurrencies.of(currency).minorUnitScale;
      final minor = (amount.abs() * scale).round();
      final account =
          _first(_accounts, (item) => item.name == cell(accountIndex)) ??
          _first(_accounts, (item) => item.isDefault) ??
          (_accounts.isEmpty ? null : _accounts.first);
      final category = _first(
        _categories,
        (item) => item.name.toLowerCase() == cell(categoryIndex).toLowerCase(),
      );
      final income = amount > 0;
      final draft = MoneyTransaction(
        id: '',
        type: income ? MoneyEventType.income : MoneyEventType.expense,
        amountMinor: minor,
        currency: currency,
        occurredOn: date,
        merchant: description,
        fromAccountId: income ? null : account?.id,
        toAccountId: income ? account?.id : null,
        categoryId: category?.id,
        source: 'import',
      );
      final duplicate = _transactions.any(
        (item) =>
            item.merchant.toLowerCase() == description.toLowerCase() &&
            item.amountMinor == minor &&
            item.occurredOn.year == date.year &&
            item.occurredOn.month == date.month &&
            item.occurredOn.day == date.day,
      );
      rows.add(
        ImportRow(
          lineNumber: index + 1,
          state: duplicate ? ImportRowState.duplicate : ImportRowState.valid,
          description: description,
          transaction: draft,
          problem: duplicate
              ? 'Already recorded on ${date.day}/${date.month}'
              : null,
        ),
      );
    }
    return ImportPreview(rows: rows, headers: headers);
  }

  List<String> _splitCsvLine(String line) {
    final cells = <String>[];
    final buffer = StringBuffer();
    var quoted = false;
    for (var index = 0; index < line.length; index++) {
      final char = line[index];
      if (char == '"') {
        if (quoted && index + 1 < line.length && line[index + 1] == '"') {
          buffer.write('"');
          index++;
        } else {
          quoted = !quoted;
        }
      } else if (char == ',' && !quoted) {
        cells.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    cells.add(buffer.toString());
    return cells;
  }

  String _csvCell(String value) => value.contains(RegExp('[",\n]'))
      ? '"${value.replaceAll('"', '""')}"'
      : value;

  @override
  String exportCsv(List<MoneyTransaction> rows) {
    final buffer = StringBuffer(
      'date,description,amount,currency,type,category,account,note,tags,status\n',
    );
    for (final row in rows) {
      final scale = PockitoCurrencies.of(row.currency).minorUnitScale;
      final signed = row.type == MoneyEventType.income
          ? row.amountMinor
          : -row.amountMinor;
      final accountId = row.fromAccountId ?? row.toAccountId;
      buffer.writeln(
        [
          '${row.occurredOn.year}-${row.occurredOn.month.toString().padLeft(2, '0')}-${row.occurredOn.day.toString().padLeft(2, '0')}',
          _csvCell(row.merchant),
          (signed / scale).toStringAsFixed(
            PockitoCurrencies.of(row.currency).decimals,
          ),
          row.currency,
          row.type.name,
          _csvCell(
            row.categoryId == null
                ? ''
                : categoryById(row.categoryId!)?.name ?? '',
          ),
          _csvCell(accountId == null ? '' : accountById(accountId)?.name ?? ''),
          _csvCell(row.note),
          _csvCell(row.tagIds.map((id) => tagById(id)?.name ?? id).join(' ')),
          row.status.name,
        ].join(','),
      );
    }
    return buffer.toString();
  }

  @override
  String exportJson(List<MoneyTransaction> rows) =>
      const JsonEncoder.withIndent('  ').convert({
        'exportedAt': today.toIso8601String(),
        'reportingCurrency': profile.reportingCurrency,
        'count': rows.length,
        'transactions': [
          for (final row in rows)
            {
              'id': row.id,
              'date': row.occurredOn.toIso8601String(),
              'description': row.merchant,
              'amountMinor': row.amountMinor,
              'currency': row.currency,
              'type': row.type.name,
              'status': row.status.name,
              'category': row.categoryId == null
                  ? null
                  : categoryById(row.categoryId!)?.name,
              'account': (row.fromAccountId ?? row.toAccountId) == null
                  ? null
                  : accountById(row.fromAccountId ?? row.toAccountId!)?.name,
              'note': row.note,
              'tags': [for (final id in row.tagIds) tagById(id)?.name ?? id],
              'shared': row.splitId != null,
            },
        ],
      });

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  @override
  Future<void> saveProfile(UserProfile profile) async {
    _requireOnline('save your profile');
    _profile = profile;
    final userIndex = _users.indexWhere((item) => item.id == currentUserId);
    final words = profile.displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    final initials = words.isEmpty
        ? '?'
        : words.take(2).map((word) => word[0].toUpperCase()).join();
    final user = PockitoUser(
      id: currentUserId,
      name: profile.displayName,
      initials: initials,
      isYou: true,
    );
    if (userIndex < 0) {
      _users.add(user);
    } else {
      _users[userIndex] = user;
    }
    notifyListeners();
  }

  @override
  Future<Account> saveAccount(Account account) async {
    _requireOnline('save this account');
    final index = _accounts.indexWhere((item) => item.id == account.id);
    if (index >= 0) {
      _requireVersion(
        entityLabel: _accounts[index].name,
        expected: account.version,
        actual: _accounts[index].version,
      );
    }
    final saved = account.id.isEmpty
        ? account.copyWith(id: _id('a'), sortOrder: _accounts.length)
        : account.copyWith(version: account.version + 1);
    if (index < 0) {
      _accounts.add(saved);
      _markSetup('account');
    } else {
      _accounts[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> archiveAccount(String accountId, bool archived) async {
    _requireOnline(archived ? 'archive this account' : 'restore this account');
    final index = _accounts.indexWhere((item) => item.id == accountId);
    if (index < 0) return;
    _accounts[index] = _accounts[index].copyWith(archived: archived);
    notifyListeners();
  }

  @override
  Future<void> reorderAccounts(List<String> orderedIds) async {
    _requireOnline('reorder your accounts');
    for (var index = 0; index < orderedIds.length; index++) {
      final at = _accounts.indexWhere((item) => item.id == orderedIds[index]);
      if (at >= 0) _accounts[at] = _accounts[at].copyWith(sortOrder: index);
    }
    notifyListeners();
  }

  @override
  Future<SharedSpace> saveSpace(SharedSpace space) async {
    _requireOnline('save this Space');
    final index = _spaces.indexWhere((item) => item.id == space.id);
    if (index >= 0) {
      final permissions = permissionsFor(space.id);
      _requirePermission(
        space.id,
        allowed: permissions.canEditSettings,
        action: 'change this Space’s settings',
        permission: 'canEditSettings',
        reason: permissions.readOnly
            ? 'This Space is read-only for you.'
            : '${permissions.role.label}s cannot change Space settings.',
      );
      _requireVersion(
        entityLabel: _spaces[index].name,
        expected: space.version,
        actual: _spaces[index].version,
      );
    }
    final saved = space.id.isEmpty
        ? space.copyWith(
            id: _id('s'),
            currentCycleId: _id('cycle'),
            // A Space always has exactly one owner. Left to the caller this
            // is one forgotten field away from a Space nobody can administer.
            members: _withOwner(space.members),
          )
        : space.copyWith(
            version: space.version + 1,
            members: _withOwner(space.members),
          );
    if (index < 0) {
      _spaces.add(saved);
      _markSetup('space');
    } else {
      _spaces[index] = saved;
      _logActivity(
        spaceId: saved.id,
        type: SpaceActivityType.settingsChanged,
        summary: 'You changed the Space settings',
      );
    }
    notifyListeners();
    return saved;
  }

  /// Guarantees the member list has an owner, promoting the creator when the
  /// caller did not name one.
  List<SpaceMember> _withOwner(List<SpaceMember> members) {
    if (members.any(
      (member) => member.active && member.role == SpaceRole.owner,
    )) {
      return members;
    }
    if (members.any((member) => member.userId == currentUserId)) {
      return [
        for (final member in members)
          member.userId == currentUserId
              ? member.copyWith(role: SpaceRole.owner)
              : member,
      ];
    }
    return [
      SpaceMember(
        userId: currentUserId,
        role: SpaceRole.owner,
        joinedAt: today,
      ),
      ...members,
    ];
  }

  @override
  Future<void> archiveSpace(String spaceId, bool archived) async {
    _requireOnline(archived ? 'archive this Space' : 'reopen this Space');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canArchive,
      action: archived ? 'archive this Space' : 'reopen this Space',
      permission: 'canArchive',
      reason: 'Only the owner can archive or reopen a Space.',
    );
    final index = _spaces.indexWhere((item) => item.id == spaceId);
    if (index < 0) return;
    _spaces[index] = _spaces[index].copyWith(
      status: archived ? SpaceStatus.archived : SpaceStatus.active,
    );
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.settingsChanged,
      summary: archived ? 'You archived the Space' : 'You reopened the Space',
    );
    notifyListeners();
  }

  @override
  Future<SpaceInvitation> inviteMember(
    String spaceId, {
    required String name,
    required String email,
    SpaceRole role = SpaceRole.member,
    int expiryDays = 7,
  }) async {
    _requireOnline('send this invitation');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canInvite,
      action: 'invite someone to this Space',
      permission: 'canInvite',
      reason: permissions.readOnly
          ? 'This Space is read-only for you.'
          : 'Only owners and admins can invite people.',
    );
    final invitation = SpaceInvitation(
      id: _id('invite'),
      spaceId: spaceId,
      name: name.trim(),
      email: email.trim(),
      invitedAt: today,
      expiresAt: today.add(Duration(days: expiryDays)),
      expiryDays: expiryDays,
      role: role,
      invitedByUserId: currentUserId,
    );
    _invitations.add(invitation);
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.memberInvited,
      summary: 'You invited ${invitation.name}',
      entityId: invitation.id,
      entityLabel: invitation.name,
      detail: 'As ${role.label} · expires in $expiryDays days',
    );
    notifyListeners();
    return invitation;
  }

  @override
  Future<void> revokeInvitation(String invitationId) async {
    _requireOnline('revoke this invitation');
    final index = _invitations.indexWhere((item) => item.id == invitationId);
    if (index < 0) return;
    final invitation = _invitations[index];
    final permissions = permissionsFor(invitation.spaceId);
    _requirePermission(
      invitation.spaceId,
      allowed: permissions.canInvite,
      action: 'revoke this invitation',
      permission: 'canInvite',
      reason: 'Only owners and admins manage invitations.',
    );
    _invitations[index] = invitation.copyWith(
      status: InvitationStatus.revoked,
      respondedAt: today,
    );
    _logActivity(
      spaceId: invitation.spaceId,
      type: SpaceActivityType.inviteRevoked,
      summary: 'You revoked ${invitation.name}’s invitation',
      entityId: invitation.id,
      entityLabel: invitation.name,
    );
    notifyListeners();
  }

  @override
  Future<SpaceInvitation> resendInvitation(String invitationId) async {
    _requireOnline('resend this invitation');
    final index = _invitations.indexWhere((item) => item.id == invitationId);
    if (index < 0) throw StateError('Invitation not found');
    final invitation = _invitations[index];
    final permissions = permissionsFor(invitation.spaceId);
    _requirePermission(
      invitation.spaceId,
      allowed: permissions.canInvite,
      action: 'resend this invitation',
      permission: 'canInvite',
      reason: 'Only owners and admins manage invitations.',
    );
    final refreshed = invitation.copyWith(
      status: InvitationStatus.pending,
      invitedAt: today,
      expiresAt: today.add(Duration(days: invitation.expiryDays)),
      respondedAt: null,
      resendCount: invitation.resendCount + 1,
    );
    _invitations[index] = refreshed;
    _logActivity(
      spaceId: invitation.spaceId,
      type: SpaceActivityType.memberInvited,
      summary: 'You resent ${invitation.name}’s invitation',
      entityId: invitation.id,
      entityLabel: invitation.name,
    );
    notifyListeners();
    return refreshed;
  }

  @override
  Future<void> respondToInvitation(
    String invitationId,
    InvitationStatus status,
  ) async {
    _requireOnline('respond to this invitation');
    final index = _invitations.indexWhere((item) => item.id == invitationId);
    if (index < 0) return;
    var invitation = _invitations[index];
    if (invitation.isExpiredAt(today) && status == InvitationStatus.accepted) {
      throw StateError('This invitation expired on ${invitation.expiresAt}');
    }
    if (status == InvitationStatus.accepted) {
      final existingUser = _users
          .where(
            (user) => user.name.toLowerCase() == invitation.name.toLowerCase(),
          )
          .firstOrNull;
      final userId = existingUser?.id ?? _id('u');
      if (existingUser == null) {
        final words = invitation.name.trim().split(RegExp(r'\s+'));
        _users.add(
          PockitoUser(
            id: userId,
            name: invitation.name,
            initials: words
                .where((word) => word.isNotEmpty)
                .take(2)
                .map((word) => word[0].toUpperCase())
                .join(),
          ),
        );
      }
      final spaceIndex = _spaces.indexWhere(
        (space) => space.id == invitation.spaceId,
      );
      if (spaceIndex >= 0 &&
          !_spaces[spaceIndex].members.any(
            (member) => member.userId == userId,
          )) {
        _spaces[spaceIndex] = _spaces[spaceIndex].copyWith(
          members: [
            ..._spaces[spaceIndex].members,
            SpaceMember(userId: userId, role: invitation.role, joinedAt: today),
          ],
        );
      }
      invitation = invitation.copyWith(userId: userId);
      _logActivity(
        spaceId: invitation.spaceId,
        actorUserId: userId,
        type: SpaceActivityType.memberJoined,
        summary: '${invitation.name} joined as ${invitation.role.label}',
        entityId: userId,
        entityLabel: invitation.name,
      );
    }
    _invitations[index] = invitation.copyWith(
      status: status,
      respondedAt: status == InvitationStatus.pending ? null : today,
    );
    notifyListeners();
  }

  @override
  Future<void> setMemberRole(
    String spaceId,
    String userId,
    SpaceRole role,
  ) async {
    _requireOnline('change this role');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canChangeRoles,
      action: 'change roles in this Space',
      permission: 'canChangeRoles',
      reason: 'Only the owner can change roles.',
    );
    final index = _spaces.indexWhere((item) => item.id == spaceId);
    if (index < 0) return;
    final space = _spaces[index];
    final member = _first(space.members, (item) => item.userId == userId);
    if (member == null) return;
    if (member.role == SpaceRole.owner && role != SpaceRole.owner) {
      final owners = space.members
          .where((item) => item.active && item.role == SpaceRole.owner)
          .length;
      if (owners <= 1) {
        throw StateError(
          'A Space always needs one owner. Make someone else the owner first.',
        );
      }
    }
    _spaces[index] = space.copyWith(
      members: [
        for (final item in space.members)
          item.userId == userId ? item.copyWith(role: role) : item,
      ],
    );
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.roleChanged,
      summary:
          'You made ${userById(userId)?.name ?? 'a member'} '
          'a ${role.label.toLowerCase()}',
      entityId: userId,
      entityLabel: userById(userId)?.name,
      detail: '${member.role.label} → ${role.label}',
    );
    notifyListeners();
  }

  @override
  Future<void> removeMember(String spaceId, String userId) async {
    _requireOnline('remove this member');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canRemoveMember,
      action: 'remove someone from this Space',
      permission: 'canRemoveMember',
      reason: 'Only owners and admins can remove members.',
    );
    final index = _spaces.indexWhere((item) => item.id == spaceId);
    if (index < 0) return;
    final space = _spaces[index];
    final member = _first(space.members, (item) => item.userId == userId);
    if (member == null) return;
    if (member.role == SpaceRole.owner) {
      throw StateError(
        'The owner cannot be removed. Transfer ownership first.',
      );
    }
    final balance = memberBalance(spaceId, userId);
    if (balance != 0) {
      throw StateError(
        '${userById(userId)?.name ?? 'This member'} still has an unsettled '
        'balance. Settle up before removing them.',
      );
    }
    _spaces[index] = space.copyWith(
      members: space.members
          .where((item) => item.userId != userId)
          .toList(growable: false),
    );
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.memberRemoved,
      summary: 'You removed ${userById(userId)?.name ?? 'a member'}',
      entityId: userId,
      entityLabel: userById(userId)?.name,
    );
    notifyListeners();
  }

  @override
  Future<void> leaveSpace(String spaceId) async {
    _requireOnline('leave this Space');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canLeave,
      action: 'leave this Space',
      permission: 'canLeave',
      reason: 'You own this Space. Make someone else the owner before leaving.',
    );
    final balance = memberBalance(spaceId, currentUserId);
    if (balance != 0) {
      throw StateError(
        'You still have an unsettled balance here. Settle up before leaving.',
      );
    }
    final index = _spaces.indexWhere((item) => item.id == spaceId);
    if (index < 0) return;
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.memberLeft,
      summary: 'You left the Space',
    );
    _spaces[index] = _spaces[index].copyWith(
      members: _spaces[index].members
          .where((item) => item.userId != currentUserId)
          .toList(growable: false),
    );
    notifyListeners();
  }

  @override
  Future<SpaceCycle> startNewCycle(String spaceId) async {
    _requireOnline('close this cycle');
    final permissions = permissionsFor(spaceId);
    _requirePermission(
      spaceId,
      allowed: permissions.canCloseCycle,
      action: 'close this cycle',
      permission: 'canCloseCycle',
      reason: 'Only owners and admins can close a cycle.',
    );
    final space = spaceById(spaceId);
    if (space == null) throw StateError('Space not found');
    final balances = _memberBalances(space, lifetime: false);
    if (balances.values.any((value) => value != 0)) {
      throw StateError('Everyone must be settled before starting a new cycle');
    }
    final expenses = _liveShared
        .where(
          (expense) =>
              expense.spaceId == space.id &&
              expense.cycleId == space.currentCycleId,
        )
        .toList();
    final settlements = _settlements
        .where(
          (settlement) =>
              settlement.spaceId == space.id &&
              settlement.cycleId == space.currentCycleId,
        )
        .toList();
    final memberPaid = <String, int>{};
    final memberResponsibility = <String, int>{};
    final categoryTotals = <String, int>{};
    for (final expense in expenses) {
      for (final payer in expense.payers) {
        memberPaid[payer.userId] =
            (memberPaid[payer.userId] ?? 0) + payer.amountMinor;
      }
      categoryTotals[expense.categoryId] =
          (categoryTotals[expense.categoryId] ?? 0) + expense.totalMinor;
      for (final share in expense.shares) {
        memberResponsibility[share.userId] =
            (memberResponsibility[share.userId] ?? 0) + share.amountMinor;
      }
    }
    final budget = _budgets
        .where(
          (item) => item.scope == BudgetScope.space && item.spaceId == space.id,
        )
        .firstOrNull;
    final startedAt = expenses.isEmpty
        ? DateTime(today.year, today.month, 1)
        : expenses
              .map((expense) => expense.occurredOn)
              .reduce((a, b) => a.isBefore(b) ? a : b);
    final cycle = SpaceCycle(
      id: space.currentCycleId,
      spaceId: space.id,
      label: '${_monthNames[startedAt.month - 1]} ${startedAt.year}',
      startedAt: startedAt,
      endedAt: today,
      expenseIds: expenses.map((expense) => expense.id).toList(),
      settlementIds: settlements.map((settlement) => settlement.id).toList(),
      spentMinor: expenses.fold(0, (sum, item) => sum + item.totalMinor),
      currency: space.currency,
      budgetLimitMinor: budget?.limitMinor ?? 0,
      memberPaidMinor: memberPaid,
      memberResponsibilityMinor: memberResponsibility,
      categoryTotalsMinor: categoryTotals,
    );
    _cycles.add(cycle);
    final spaceIndex = _spaces.indexWhere((item) => item.id == space.id);
    _spaces[spaceIndex] = space.copyWith(currentCycleId: _id('cycle'));
    _logActivity(
      spaceId: spaceId,
      type: SpaceActivityType.cycleClosed,
      summary: 'You closed ${cycle.label}',
      entityId: cycle.id,
      entityLabel: cycle.label,
    );
    notifyListeners();
    return cycle;
  }

  @override
  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction) async {
    _requireOnline('save this transaction');
    if (transaction.amountMinor <= 0) {
      throw ArgumentError.value(transaction.amountMinor, 'amountMinor');
    }
    if (transaction.type == MoneyEventType.transfer) {
      if (transaction.fromAccountId == transaction.toAccountId) {
        throw ArgumentError('Transfer accounts must differ');
      }
      final from = accountById(transaction.fromAccountId ?? '');
      final to = accountById(transaction.toAccountId ?? '');
      if (from == null || to == null) {
        throw ArgumentError('Transfer accounts are required');
      }
      if (from.currency != to.currency &&
          (transaction.destinationAmountMinor == null ||
              transaction.destinationCurrency != to.currency ||
              transaction.exchangeRate == null)) {
        throw ArgumentError('Cross-currency transfer requires a captured rate');
      }
    }
    final index = _transactions.indexWhere((item) => item.id == transaction.id);
    if (index >= 0) {
      _requireVersion(
        entityLabel: _transactions[index].merchant,
        expected: transaction.version,
        actual: _transactions[index].version,
        actorName: 'Kana',
      );
    }
    final saved = transaction.id.isEmpty
        ? transaction.copyWith(id: _id('t'))
        : transaction.copyWith(version: transaction.version + 1);
    if (index < 0) {
      _transactions.add(saved);
      _markSetup('transaction');
    } else {
      _transactions[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<SharedExpense> saveSharedExpense(
    SharedExpense expense, {
    String? accountId,
  }) async {
    _requireOnline('save this shared expense');
    final allocated = expense.shares.fold(
      0,
      (sum, share) => sum + share.amountMinor,
    );
    if (allocated != expense.totalMinor) {
      throw ArgumentError(
        'Shared expense allocation must equal its total ($allocated != ${expense.totalMinor})',
      );
    }
    if (expense.payers.isEmpty) {
      throw ArgumentError('A shared expense needs at least one payer');
    }
    if (expense.allocatedMinor != expense.totalMinor) {
      throw ArgumentError(
        'Payers must add up to the total '
        '(${expense.allocatedMinor} != ${expense.totalMinor})',
      );
    }
    final index = _sharedExpenses.indexWhere((item) => item.id == expense.id);
    final permissions = permissionsFor(expense.spaceId);
    if (index < 0) {
      _requirePermission(
        expense.spaceId,
        allowed: permissions.canAddExpense,
        action: 'add an expense to this Space',
        permission: 'canAddExpense',
        reason: permissions.readOnly
            ? permissions.role == SpaceRole.viewer
                  ? 'Viewers can see everything and change nothing.'
                  : 'This Space is archived, so it is read-only.'
            : 'You do not have permission to add expenses here.',
      );
    } else {
      final existing = _sharedExpenses[index];
      _requirePermission(
        expense.spaceId,
        allowed: permissions.canEditExpenseBy(
          existing.createdByUserId,
          currentUserId,
        ),
        action: 'edit this expense',
        permission: 'canEditAnyExpense',
        reason: permissions.readOnly
            ? 'This Space is read-only for you.'
            : 'Only admins can edit an expense someone else recorded.',
      );
      _requireVersion(
        entityLabel: existing.title,
        expected: expense.version,
        actual: existing.version,
        actorName: userById(existing.createdByUserId)?.name ?? 'Someone',
      );
    }
    final space = spaceById(expense.spaceId);
    if (index >= 0 &&
        space != null &&
        _sharedExpenses[index].cycleId != space.currentCycleId) {
      throw StateError('Closed-cycle expenses are immutable');
    }
    var saved = expense.id.isEmpty
        ? expense.copyWith(
            id: _id('x'),
            cycleId: space?.currentCycleId ?? expense.cycleId,
            createdByUserId: expense.createdByUserId.isEmpty
                ? currentUserId
                : expense.createdByUserId,
          )
        : expense.copyWith(
            cycleId: _sharedExpenses[index].cycleId,
            createdByUserId: _sharedExpenses[index].createdByUserId,
            version: expense.version + 1,
          );
    // Only your own contribution can touch your ledger; the account is the one
    // recorded against your payer line.
    final myPayment = _first(
      saved.payers,
      (payer) => payer.userId == currentUserId,
    );
    if (myPayment != null && accountId != null) {
      final account = accountById(accountId);
      if (account != null) {
        final quote = fxQuote(saved.currency, account.currency);
        // An explicitly supplied wallet amount is what the bank actually
        // charged, and always beats a rate we computed ourselves.
        final walletAmount =
            saved.walletAmountMinor ??
            convertMinor(
              myPayment.amountMinor,
              saved.currency,
              account.currency,
            ) ??
            myPayment.amountMinor;
        saved = saved.copyWith(
          paidFromAccountId: account.id,
          walletAmountMinor: walletAmount,
          walletCurrency: account.currency,
          exchangeRate: account.currency == saved.currency
              ? 1
              : saved.exchangeRate ?? quote?.rate,
          fxRateMode: account.currency == saved.currency
              ? null
              : saved.fxRateMode ?? quote?.mode,
          rateUpdatedAt: account.currency == saved.currency
              ? null
              : saved.rateUpdatedAt ?? quote?.updatedAt,
          payers: [
            for (final payer in saved.payers)
              payer.userId == currentUserId
                  ? payer.copyWith(accountId: account.id)
                  : payer,
          ],
        );
      }
    } else {
      saved = saved.copyWith(
        paidFromAccountId: null,
        walletAmountMinor: null,
        walletCurrency: null,
        exchangeRate: null,
        fxRateMode: null,
        rateUpdatedAt: null,
      );
    }
    if (index < 0) {
      _sharedExpenses.add(saved);
    } else {
      _sharedExpenses[index] = saved;
    }
    _syncLinkedTransaction(saved, accountId: accountId);
    _logActivity(
      spaceId: saved.spaceId,
      type: index < 0
          ? SpaceActivityType.expenseAdded
          : SpaceActivityType.expenseEdited,
      summary: index < 0
          ? 'You added ${saved.title}'
          : 'You edited ${saved.title}',
      entityId: saved.id,
      entityLabel: saved.title,
      detail: saved.hasMultiplePayers ? '${saved.payers.length} payers' : null,
    );
    notifyListeners();
    return saved;
  }

  /// Mirrors your own contribution into your personal ledger, or removes the
  /// mirror when you no longer paid anything.
  void _syncLinkedTransaction(SharedExpense saved, {String? accountId}) {
    final linkedIndex = _transactions.indexWhere(
      (item) => item.splitId == saved.id,
    );
    final myPayment = _first(
      saved.payers,
      (payer) => payer.userId == currentUserId,
    );
    final account = accountId == null ? null : accountById(accountId);
    if (myPayment != null && account != null && !saved.isVoided) {
      final amount = saved.walletAmountMinor ?? myPayment.amountMinor;
      final linked = MoneyTransaction(
        id: linkedIndex < 0 ? _id('t') : _transactions[linkedIndex].id,
        type: MoneyEventType.expense,
        amountMinor: amount,
        currency: account.currency,
        occurredOn: saved.occurredOn,
        merchant: saved.title,
        fromAccountId: account.id,
        categoryId: saved.categoryId,
        splitId: saved.id,
        sourceAmountMinor: account.currency == saved.currency
            ? null
            : myPayment.amountMinor,
        sourceCurrency: account.currency == saved.currency
            ? null
            : saved.currency,
        exchangeRate: saved.exchangeRate,
        fxRateMode: saved.fxRateMode,
        rateUpdatedAt: saved.rateUpdatedAt,
        status: saved.status,
        note: saved.note,
        tagIds: saved.tagIds,
        attachments: saved.attachments,
        version: linkedIndex < 0 ? 1 : _transactions[linkedIndex].version + 1,
      );
      if (linkedIndex < 0) {
        _transactions.add(linked);
      } else {
        _transactions[linkedIndex] = linked;
      }
    } else if (linkedIndex >= 0) {
      // The mirror is derived, so it goes away with its source rather than
      // lingering as an orphan the user cannot explain.
      _transactions.removeAt(linkedIndex);
    }
  }

  @override
  Future<void> voidTransaction(String id, {String? reason}) async {
    _requireOnline('void this transaction');
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final splitId = _transactions[index].splitId;
    _transactions[index] = _transactions[index].copyWith(
      status: RecordStatus.voided,
      voidedAt: today,
      voidReason: reason,
      version: _transactions[index].version + 1,
    );
    if (splitId != null) await voidSharedExpense(splitId, reason: reason);
    notifyListeners();
  }

  @override
  Future<void> voidSharedExpense(String id, {String? reason}) async {
    _requireOnline('void this expense');
    final index = _sharedExpenses.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final expense = _sharedExpenses[index];
    final permissions = permissionsFor(expense.spaceId);
    _requirePermission(
      expense.spaceId,
      allowed: permissions.canVoidExpenseBy(
        expense.createdByUserId,
        currentUserId,
      ),
      action: 'void this expense',
      permission: 'canVoidAnyExpense',
      reason: permissions.readOnly
          ? 'This Space is read-only for you.'
          : 'Only admins can void an expense someone else recorded.',
    );
    final space = spaceById(expense.spaceId);
    if (space != null && expense.cycleId != space.currentCycleId) {
      throw StateError('Closed-cycle expenses are immutable');
    }
    _sharedExpenses[index] = expense.copyWith(
      status: RecordStatus.voided,
      voidedAt: today,
      voidReason: reason,
      version: expense.version + 1,
    );
    final linkedIndex = _transactions.indexWhere((item) => item.splitId == id);
    if (linkedIndex >= 0) {
      _transactions[linkedIndex] = _transactions[linkedIndex].copyWith(
        status: RecordStatus.voided,
        voidedAt: today,
        voidReason: reason,
      );
    }
    _logActivity(
      spaceId: expense.spaceId,
      type: SpaceActivityType.expenseVoided,
      summary: 'You voided ${expense.title}',
      entityId: expense.id,
      entityLabel: expense.title,
      detail: reason,
    );
    notifyListeners();
  }

  @override
  Future<void> restoreTransaction(String id) async {
    _requireOnline('restore this transaction');
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index < 0) return;
    final splitId = _transactions[index].splitId;
    _transactions[index] = _transactions[index].copyWith(
      status: RecordStatus.confirmed,
      voidedAt: null,
      voidReason: null,
    );
    if (splitId != null) await restoreSharedExpense(splitId);
    notifyListeners();
  }

  @override
  Future<void> restoreSharedExpense(String id) async {
    _requireOnline('restore this expense');
    final index = _sharedExpenses.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _sharedExpenses[index] = _sharedExpenses[index].copyWith(
      status: RecordStatus.confirmed,
      voidedAt: null,
      voidReason: null,
    );
    final linkedIndex = _transactions.indexWhere((item) => item.splitId == id);
    if (linkedIndex >= 0) {
      _transactions[linkedIndex] = _transactions[linkedIndex].copyWith(
        status: RecordStatus.confirmed,
        voidedAt: null,
        voidReason: null,
      );
    }
    notifyListeners();
  }

  @override
  Future<void> confirmTransaction(String id) async {
    _requireOnline('confirm this transaction');
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index < 0 || !_transactions[index].isDraft) return;
    _transactions[index] = _transactions[index].copyWith(
      status: RecordStatus.confirmed,
      version: _transactions[index].version + 1,
    );
    notifyListeners();
  }

  @override
  Future<void> confirmSharedExpense(String id) async {
    _requireOnline('confirm this expense');
    final index = _sharedExpenses.indexWhere((item) => item.id == id);
    if (index < 0 || !_sharedExpenses[index].isDraft) return;
    final expense = _sharedExpenses[index];
    final permissions = permissionsFor(expense.spaceId);
    _requirePermission(
      expense.spaceId,
      allowed: permissions.canEditExpenseBy(
        expense.createdByUserId,
        currentUserId,
      ),
      action: 'confirm this expense',
      permission: 'canEditAnyExpense',
      reason: permissions.readOnly
          ? 'This Space is read-only for you.'
          : 'Only admins can confirm an expense someone else drafted.',
    );
    _sharedExpenses[index] = expense.copyWith(
      status: RecordStatus.confirmed,
      version: expense.version + 1,
    );
    final linkedIndex = _transactions.indexWhere((item) => item.splitId == id);
    if (linkedIndex >= 0) {
      _transactions[linkedIndex] = _transactions[linkedIndex].copyWith(
        status: RecordStatus.confirmed,
      );
    }
    _logActivity(
      spaceId: expense.spaceId,
      type: SpaceActivityType.expenseEdited,
      summary: 'You confirmed ${expense.title}',
      entityId: expense.id,
      entityLabel: expense.title,
    );
    notifyListeners();
  }

  @override
  Future<Budget> saveBudget(Budget budget) async {
    _requireOnline('save this budget');
    if (budget.scope == BudgetScope.space && budget.spaceId != null) {
      final permissions = permissionsFor(budget.spaceId!);
      _requirePermission(
        budget.spaceId!,
        allowed: permissions.canManageBudgets,
        action: 'manage this Space’s budgets',
        permission: 'canManageBudgets',
        reason: permissions.readOnly
            ? 'This Space is read-only for you.'
            : 'Only owners and admins manage shared budgets.',
      );
    }
    final index = _budgets.indexWhere((item) => item.id == budget.id);
    if (index >= 0) {
      _requireVersion(
        entityLabel: _budgets[index].name,
        expected: budget.version,
        actual: _budgets[index].version,
      );
    }
    final saved = budget.id.isEmpty
        ? budget.copyWith(id: _id('b'))
        : budget.copyWith(version: budget.version + 1);
    if (index < 0) {
      _budgets.add(saved);
      _markSetup('budget');
    } else {
      _budgets[index] = saved;
      if (saved.spaceId != null) {
        _logActivity(
          spaceId: saved.spaceId!,
          type: SpaceActivityType.budgetChanged,
          summary: 'You changed the ${saved.name} budget',
          entityId: saved.id,
          entityLabel: saved.name,
        );
      }
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> deleteBudget(String id) async {
    _requireOnline('delete this budget');
    final budget = budgetById(id);
    if (budget != null &&
        budget.scope == BudgetScope.space &&
        budget.spaceId != null) {
      final permissions = permissionsFor(budget.spaceId!);
      _requirePermission(
        budget.spaceId!,
        allowed: permissions.canManageBudgets,
        action: 'delete this budget',
        permission: 'canManageBudgets',
        reason: 'Only owners and admins manage shared budgets.',
      );
    }
    _budgets.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  @override
  Future<void> restoreBudget(Budget budget) async {
    if (_budgets.any((item) => item.id == budget.id)) return;
    _budgets.add(budget);
    notifyListeners();
  }

  @override
  Future<Subscription> saveSubscription(Subscription subscription) async {
    _requireOnline('save this recurring item');
    final index = _subscriptions.indexWhere(
      (item) => item.id == subscription.id,
    );
    if (index >= 0) {
      _requireVersion(
        entityLabel: _subscriptions[index].name,
        expected: subscription.version,
        actual: _subscriptions[index].version,
      );
    }
    final saved = subscription.id.isEmpty
        ? subscription.copyWith(id: _id('sb'))
        : subscription.copyWith(version: subscription.version + 1);
    if (index < 0) {
      _subscriptions.add(saved);
    } else {
      _subscriptions[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> deleteSubscription(String id) async {
    _requireOnline('delete this recurring item');
    final index = _subscriptions.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _subscriptions[index] = _subscriptions[index].copyWith(archived: true);
    notifyListeners();
  }

  @override
  Future<Category> addCategory(Category category) async {
    _requireOnline('add this category');
    final saved = category.id.isEmpty
        ? category.copyWith(id: _id('c'))
        : category;
    _categories.add(saved);
    notifyListeners();
    return saved;
  }

  @override
  Future<Category> updateCategory(Category category) async {
    _requireOnline('update this category');
    final index = _categories.indexWhere((item) => item.id == category.id);
    if (index >= 0) {
      _requireVersion(
        entityLabel: _categories[index].name,
        expected: category.version,
        actual: _categories[index].version,
      );
      _categories[index] = category.copyWith(version: category.version + 1);
    }
    notifyListeners();
    return category;
  }

  @override
  Future<void> deleteCategory(String id) async {
    _requireOnline('delete this category');
    _categories.removeWhere((item) => item.id == id && !item.system);
    notifyListeners();
  }

  @override
  Future<void> setCategoryHidden(String id, bool hidden) async {
    _requireOnline(hidden ? 'hide this category' : 'show this category');
    final index = _categories.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _categories[index] = _categories[index].copyWith(hidden: hidden);
    notifyListeners();
  }

  @override
  Future<void> reassignAndDeleteCategory(
    String id,
    String replacementId,
  ) async {
    _requireOnline('reassign this category');
    for (var index = 0; index < _transactions.length; index++) {
      if (_transactions[index].categoryId == id) {
        _transactions[index] = _transactions[index].copyWith(
          categoryId: replacementId,
        );
      }
    }
    for (var index = 0; index < _sharedExpenses.length; index++) {
      if (_sharedExpenses[index].categoryId == id) {
        _sharedExpenses[index] = _sharedExpenses[index].copyWith(
          categoryId: replacementId,
        );
      }
    }
    for (var index = 0; index < _budgets.length; index++) {
      if (_budgets[index].categoryId == id) {
        _budgets[index] = _budgets[index].copyWith(categoryId: replacementId);
      }
    }
    for (var index = 0; index < _subscriptions.length; index++) {
      if (_subscriptions[index].categoryId == id) {
        _subscriptions[index] = _subscriptions[index].copyWith(
          categoryId: replacementId,
        );
      }
    }
    for (var index = 0; index < _categories.length; index++) {
      if (_categories[index].parentId == id) {
        _categories[index] = _categories[index].copyWith(parentId: null);
      }
    }
    _categories.removeWhere((item) => item.id == id && !item.system);
    notifyListeners();
  }

  @override
  Future<Tag> saveTag(Tag tag) async {
    _requireOnline('save this tag');
    final index = _tags.indexWhere((item) => item.id == tag.id);
    final saved = tag.id.isEmpty ? tag.copyWith(id: _id('tg')) : tag;
    if (index < 0) {
      _tags.add(saved);
    } else {
      _tags[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> deleteTag(String id) async {
    _requireOnline('delete this tag');
    final index = _tags.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _tags[index] = _tags[index].copyWith(archived: true);
    for (var index = 0; index < _transactions.length; index++) {
      final row = _transactions[index];
      if (row.tagIds.contains(id)) {
        _transactions[index] = row.copyWith(
          tagIds: row.tagIds.where((item) => item != id).toList(),
        );
      }
    }
    notifyListeners();
  }

  @override
  Future<PaymentMethod> savePaymentMethod(PaymentMethod method) async {
    _requireOnline('save this payment method');
    final index = _paymentMethods.indexWhere((item) => item.id == method.id);
    final saved = method.id.isEmpty ? method.copyWith(id: _id('pm')) : method;
    if (index < 0) {
      _paymentMethods.add(saved);
    } else {
      _paymentMethods[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> deletePaymentMethod(String id) async {
    _requireOnline('delete this payment method');
    final index = _paymentMethods.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _paymentMethods[index] = _paymentMethods[index].copyWith(archived: true);
    for (var at = 0; at < _transactions.length; at++) {
      if (_transactions[at].paymentMethodId == id) {
        _transactions[at] = _transactions[at].copyWith(paymentMethodId: null);
      }
    }
    notifyListeners();
  }

  DateTime _nextDue(Subscription subscription) {
    final base = subscription.nextDueOn ?? today;
    final interval = subscription.cadence.interval;
    switch (subscription.cadence.frequency) {
      case 'DAILY':
        return base.add(Duration(days: interval));
      case 'WEEKLY':
        return base.add(Duration(days: 7 * interval));
      case 'YEARLY':
        return DateTime(
          base.year + interval,
          base.month,
          math.min(base.day, 28),
        );
      default:
        return DateTime(
          base.year,
          base.month + interval,
          math.min(base.day, 28),
        );
    }
  }

  @override
  Future<MoneyTransaction> recordSubscriptionPayment(
    String subscriptionId, {
    required String accountId,
    required DateTime date,
  }) async {
    _requireOnline('record this payment');
    final subscription = subscriptionById(subscriptionId);
    if (subscription == null) throw StateError('Recurring item not found');
    final account = accountById(accountId);
    if (account == null) throw StateError('Payment account not found');
    final crossCurrency = account.currency != subscription.currency;
    final quote = crossCurrency
        ? fxQuote(subscription.currency, account.currency)
        : null;
    final walletAmount = crossCurrency
        ? convertMinor(
            subscription.amountMinor,
            subscription.currency,
            account.currency,
          )
        : subscription.amountMinor;
    if (walletAmount == null) {
      throw StateError('No exchange rate is available for this payment');
    }
    final income = subscription.eventType == MoneyEventType.income;
    final transaction = MoneyTransaction(
      id: _id('t'),
      type: subscription.eventType,
      amountMinor: walletAmount,
      currency: account.currency,
      occurredOn: date,
      merchant: subscription.name,
      fromAccountId: income ? null : accountId,
      toAccountId: income ? accountId : null,
      categoryId: subscription.categoryId,
      subscriptionId: subscription.id,
      paymentMethodId: subscription.paymentMethodId,
      tagIds: subscription.tagIds,
      sourceAmountMinor: crossCurrency ? subscription.amountMinor : null,
      sourceCurrency: crossCurrency ? subscription.currency : null,
      exchangeRate: quote?.rate,
      fxRateMode: quote?.mode,
      rateUpdatedAt: quote?.updatedAt,
    );
    _transactions.add(transaction);
    final index = _subscriptions.indexWhere(
      (item) => item.id == subscriptionId,
    );
    _subscriptions[index] = subscription.copyWith(
      lastPaidOn: date,
      nextDueOn: _nextDue(subscription),
    );
    notifyListeners();
    return transaction;
  }

  @override
  Future<List<MoneyTransaction>> materialiseDueOccurrences() async {
    _requireOnline('post the recurring items that are due');
    final created = <MoneyTransaction>[];
    for (final subscription in _subscriptions.where(
      (item) =>
          !item.archived &&
          item.status == SubscriptionStatus.active &&
          item.nextDueOn != null &&
          !item.nextDueOn!.isAfter(today),
    )) {
      final account = accountById(subscription.accountId);
      if (account == null) continue;
      final income = subscription.eventType == MoneyEventType.income;
      final amount =
          convertMinor(
            subscription.amountMinor,
            subscription.currency,
            account.currency,
          ) ??
          subscription.amountMinor;
      final transaction = MoneyTransaction(
        id: _id('t'),
        type: subscription.eventType,
        amountMinor: amount,
        currency: account.currency,
        occurredOn: subscription.nextDueOn!,
        merchant: subscription.name,
        fromAccountId: income ? null : account.id,
        toAccountId: income ? account.id : null,
        categoryId: subscription.categoryId,
        subscriptionId: subscription.id,
        paymentMethodId: subscription.paymentMethodId,
        tagIds: subscription.tagIds,
        // The engine never posts a money record on its own authority: an
        // occurrence nobody looked at is how a ledger quietly stops matching
        // reality. `autoPost` is the explicit opt-out.
        status: subscription.autoPost
            ? RecordStatus.confirmed
            : RecordStatus.draft,
        source: 'recurring',
      );
      _transactions.add(transaction);
      created.add(transaction);
      final index = _subscriptions.indexWhere(
        (item) => item.id == subscription.id,
      );
      _subscriptions[index] = subscription.copyWith(
        nextDueOn: _nextDue(subscription),
      );
    }
    if (created.isNotEmpty) notifyListeners();
    return created;
  }

  @override
  Future<Settlement> simulateCounterpartyResponse(
    String settlementId, {
    required bool confirm,
  }) async {
    final index = _settlements.indexWhere((item) => item.id == settlementId);
    if (index < 0) throw StateError('Settlement not found');
    final settlement = _settlements[index];
    if (!settlement.isPending) return settlement;
    if (!confirm) {
      _settlements[index] = settlement.copyWith(
        status: SettlementStatus.cancelled,
        cancelledByUserId: settlement.confirmerUserId,
        cancelledAt: today,
        cancelReason: 'They said this did not happen',
        version: settlement.version + 1,
      );
      _logActivity(
        spaceId: settlement.spaceId,
        actorUserId: settlement.confirmerUserId,
        type: SpaceActivityType.settlementCancelled,
        summary:
            '${userById(settlement.confirmerUserId)?.name ?? 'They'} '
            'rejected the settlement',
        entityId: settlement.id,
      );
      notifyListeners();
      return _settlements[index];
    }
    final confirmed = settlement.copyWith(
      status: SettlementStatus.confirmed,
      settledAt: today,
      confirmedByUserId: settlement.confirmerUserId,
      version: settlement.version + 1,
    );
    _settlements[index] = confirmed;
    final ledgerAccount = _pendingSettlementAccounts.remove(settlementId);
    if (ledgerAccount != null) {
      final account = accountById(ledgerAccount);
      final amount = account == null
          ? settlement.amountMinor
          : convertMinor(
                  settlement.amountMinor,
                  settlement.currency,
                  account.currency,
                ) ??
                settlement.amountMinor;
      final iPay = settlement.fromUserId == currentUserId;
      _transactions.add(
        MoneyTransaction(
          id: _id('t'),
          type: MoneyEventType.settlement,
          amountMinor: amount,
          currency: account?.currency ?? settlement.currency,
          occurredOn: today,
          merchant:
              'Settled with ${userById(iPay ? settlement.toUserId : settlement.fromUserId)?.name ?? 'member'}',
          fromAccountId: iPay ? ledgerAccount : null,
          toAccountId: iPay ? null : ledgerAccount,
          settlementId: confirmed.id,
        ),
      );
    }
    _logActivity(
      spaceId: confirmed.spaceId,
      actorUserId: confirmed.confirmerUserId,
      type: SpaceActivityType.settlementConfirmed,
      summary:
          '${userById(confirmed.confirmerUserId)?.name ?? 'They'} '
          'confirmed the settlement',
      entityId: confirmed.id,
    );
    _notifications.add(
      PockitoNotification(
        id: _id('n'),
        type: NotificationEvent.settlementConfirmed.wireType,
        at: today,
        title: 'Settlement confirmed',
        body:
            '${userById(confirmed.confirmerUserId)?.name ?? 'They'} confirmed '
            'your payment',
        destination: '/spaces/${confirmed.spaceId}/settlements/${confirmed.id}',
        entityId: confirmed.id,
      ),
    );
    notifyListeners();
    return confirmed;
  }

  @override
  Future<void> skipSubscription(String subscriptionId) async {
    _requireOnline('skip this payment');
    final subscription = subscriptionById(subscriptionId);
    if (subscription == null) return;
    final index = _subscriptions.indexWhere(
      (item) => item.id == subscriptionId,
    );
    _subscriptions[index] = subscription.copyWith(
      nextDueOn: _nextDue(subscription),
    );
    notifyListeners();
  }

  @override
  Future<Settlement> proposeSettlement(
    Settlement settlement, {
    String? accountId,
  }) async {
    _requireOnline('propose this settlement');
    final permissions = permissionsFor(settlement.spaceId);
    _requirePermission(
      settlement.spaceId,
      allowed: permissions.canSettle,
      action: 'settle up in this Space',
      permission: 'canSettle',
      reason: permissions.readOnly
          ? permissions.role == SpaceRole.viewer
                ? 'Viewers can see everything and change nothing.'
                : 'This Space is archived, so it is read-only.'
          : 'You do not have permission to settle here.',
    );
    final space = spaceById(settlement.spaceId);
    final proposed = settlement.copyWith(
      id: settlement.id.isEmpty ? _id('st') : settlement.id,
      status: SettlementStatus.proposed,
      createdAt: today,
      cycleId: space?.currentCycleId ?? settlement.cycleId,
      proposedByUserId: currentUserId,
    );
    final index = _settlements.indexWhere((item) => item.id == proposed.id);
    if (index < 0) {
      _settlements.add(proposed);
    } else {
      _settlements[index] = proposed;
    }
    // The account is remembered, not spent: nothing moves until it is
    // confirmed.
    _pendingSettlementAccounts[proposed.id] = accountId;
    _logActivity(
      spaceId: proposed.spaceId,
      type: SpaceActivityType.settlementProposed,
      summary: proposed.fromUserId == currentUserId
          ? 'You said you paid ${userById(proposed.toUserId)?.name ?? 'a member'}'
          : 'You recorded a payment from ${userById(proposed.fromUserId)?.name ?? 'a member'}',
      entityId: proposed.id,
      entityLabel: proposed.note.isEmpty ? 'Settlement' : proposed.note,
    );
    notifyListeners();
    // Recording that someone paid *you* is itself the confirmation — you are
    // the only one who can attest that the money arrived.
    if (proposed.toUserId == currentUserId) {
      return confirmSettlement(proposed.id, accountId: accountId);
    }
    return proposed;
  }

  final Map<String, String?> _pendingSettlementAccounts = {};

  @override
  Future<Settlement> confirmSettlement(
    String settlementId, {
    String? accountId,
  }) async {
    _requireOnline('confirm this settlement');
    final index = _settlements.indexWhere((item) => item.id == settlementId);
    if (index < 0) throw StateError('Settlement not found');
    final settlement = _settlements[index];
    if (settlement.isConfirmed) return settlement;
    if (settlement.status != SettlementStatus.proposed) {
      throw StateError('This settlement is already ${settlement.status.name}');
    }
    if (!settlement.canConfirm(currentUserId)) {
      throw PermissionDeniedException(
        action: 'confirm this settlement',
        reason:
            'Only ${userById(settlement.toUserId)?.name ?? 'the recipient'} '
            'can confirm that the money arrived.',
        whoCanHelp: [userById(settlement.toUserId)?.name ?? 'The recipient'],
      );
    }
    final permissions = permissionsFor(settlement.spaceId);
    _requirePermission(
      settlement.spaceId,
      allowed: permissions.canSettle,
      action: 'confirm this settlement',
      permission: 'canSettle',
      reason: 'You do not have permission to settle here.',
    );
    final confirmed = settlement.copyWith(
      status: SettlementStatus.confirmed,
      settledAt: today,
      confirmedByUserId: currentUserId,
      version: settlement.version + 1,
    );
    _settlements[index] = confirmed;
    final ledgerAccount =
        accountId ?? _pendingSettlementAccounts.remove(settlementId);
    if (ledgerAccount != null) {
      final account = accountById(ledgerAccount);
      final amount = account == null
          ? settlement.amountMinor
          : convertMinor(
                  settlement.amountMinor,
                  settlement.currency,
                  account.currency,
                ) ??
                settlement.amountMinor;
      final iPay = settlement.fromUserId == currentUserId;
      _transactions.add(
        MoneyTransaction(
          id: _id('t'),
          type: MoneyEventType.settlement,
          amountMinor: amount,
          currency: account?.currency ?? settlement.currency,
          occurredOn: today,
          merchant:
              'Settled with ${userById(iPay ? settlement.toUserId : settlement.fromUserId)?.name ?? 'member'}',
          fromAccountId: iPay ? ledgerAccount : null,
          toAccountId: iPay ? null : ledgerAccount,
          settlementId: confirmed.id,
        ),
      );
    }
    _logActivity(
      spaceId: confirmed.spaceId,
      type: SpaceActivityType.settlementConfirmed,
      summary: 'You confirmed the settlement',
      entityId: confirmed.id,
      entityLabel: confirmed.note.isEmpty ? 'Settlement' : confirmed.note,
    );
    notifyListeners();
    return confirmed;
  }

  @override
  Future<void> cancelSettlement(String settlementId, {String? reason}) async {
    _requireOnline('cancel this settlement');
    final index = _settlements.indexWhere((item) => item.id == settlementId);
    if (index < 0 || _settlements[index].status != SettlementStatus.proposed) {
      return;
    }
    final settlement = _settlements[index];
    _settlements[index] = settlement.copyWith(
      status: SettlementStatus.cancelled,
      cancelledByUserId: currentUserId,
      cancelledAt: today,
      cancelReason: reason,
      version: settlement.version + 1,
    );
    _pendingSettlementAccounts.remove(settlementId);
    _logActivity(
      spaceId: settlement.spaceId,
      type: SpaceActivityType.settlementCancelled,
      summary: 'You cancelled the settlement',
      entityId: settlement.id,
      detail: reason,
    );
    notifyListeners();
  }

  @override
  Future<MoneyTransaction> recordAdjustment({
    required String accountId,
    required int targetBalanceMinor,
    required String reason,
    DateTime? date,
  }) async {
    _requireOnline('record this correction');
    final account = accountById(accountId);
    if (account == null) throw StateError('Account not found');
    if (reason.trim().isEmpty) {
      throw ArgumentError('A correction needs a reason');
    }
    final delta = targetBalanceMinor - accountBalance(account);
    if (delta == 0) {
      throw StateError('That is already the balance — nothing to correct.');
    }
    final transaction = MoneyTransaction(
      id: _id('t'),
      type: MoneyEventType.adjustment,
      amountMinor: delta.abs(),
      currency: account.currency,
      occurredOn: date ?? today,
      merchant: 'Balance correction',
      fromAccountId: delta < 0 ? accountId : null,
      toAccountId: delta > 0 ? accountId : null,
      adjustmentReason: reason.trim(),
    );
    _transactions.add(transaction);
    notifyListeners();
    return transaction;
  }

  @override
  Future<void> markNotificationRead(String id) async {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(read: true);
    }
    notifyListeners();
  }

  @override
  Future<void> markAllNotificationsRead() async {
    for (var index = 0; index < _notifications.length; index++) {
      _notifications[index] = _notifications[index].copyWith(read: true);
    }
    notifyListeners();
  }

  @override
  Future<void> dismissNotification(String id, bool dismissed) async {
    final index = _notifications.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _notifications[index] = _notifications[index].copyWith(
      dismissed: dismissed,
    );
    notifyListeners();
  }

  @override
  Future<void> saveNotificationPreferences(
    NotificationPreferences prefs,
  ) async {
    _notificationPreferences = prefs;
    notifyListeners();
  }

  @override
  Future<void> approveAiApproval(String id) async {
    _requireOnline('approve this request');
    final index = _aiApprovals.indexWhere((item) => item.id == id);
    if (index < 0 || _aiApprovals[index].state != 'PENDING') {
      return;
    }
    final approval = _aiApprovals[index];
    // Approving *is* the confirmation, so the proposal and the confirmation
    // both happen here rather than leaving a proposal nobody can see.
    final proposed = await proposeSettlement(
      Settlement(
        id: _id('st'),
        spaceId: approval.spaceId,
        fromUserId: approval.fromUserId,
        toUserId: approval.toUserId,
        amountMinor: approval.amountMinor,
        currency: spaceById(approval.spaceId)?.currency ?? 'EUR',
        createdAt: today,
        source: 'mcp',
      ),
      accountId: approval.accountId,
    );
    await confirmSettlement(proposed.id, accountId: approval.accountId);
    _aiApprovals[index] = approval.copyWith(state: 'APPROVED');
    for (
      var notificationIndex = 0;
      notificationIndex < _notifications.length;
      notificationIndex++
    ) {
      if (_notifications[notificationIndex].type == 'AI_APPROVAL') {
        _notifications[notificationIndex] = _notifications[notificationIndex]
            .copyWith(read: true);
      }
    }
    notifyListeners();
  }

  @override
  Future<void> rejectAiApproval(String id) async {
    _requireOnline('reject this request');
    final index = _aiApprovals.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _aiApprovals[index] = _aiApprovals[index].copyWith(state: 'REJECTED');
    }
    notifyListeners();
  }

  @override
  Future<void> saveAiConnection(AiConnection connection) async {
    _requireOnline('save this connection');
    final index = _aiConnections.indexWhere((item) => item.id == connection.id);
    if (index < 0) {
      _aiConnections.add(connection);
    } else {
      _aiConnections[index] = connection;
    }
    notifyListeners();
  }

  @override
  Future<void> disconnectAiConnection(String id) async {
    _requireOnline('disconnect this app');
    _aiConnections.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  @override
  Future<void> setThemeMode(String mode) async {
    _profile = _profile.copyWith(
      themeMode: switch (mode) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      },
    );
    notifyListeners();
  }

  @override
  Future<void> saveFxSettings(FxSettings settings) async {
    _fxSettings = settings;
    notifyListeners();
  }

  @override
  Future<void> setManualRate(String pair, double rate) async {
    final previous = _fxSettings.manualRates[pair];
    _fxSettings = _fxSettings.copyWith(
      manualRates: {..._fxSettings.manualRates, pair: rate},
      history: [
        FxRateChange(
          pair: pair,
          rate: rate,
          at: today,
          mode: FxRateMode.manual,
          source: FxProvider.manualConfiguration,
          previousRate: previous,
        ),
        ..._fxSettings.history,
      ],
    );
    notifyListeners();
  }

  @override
  Future<SavedView> saveView(SavedView view) async {
    final saved = view.id.isEmpty ? view.copyWith(id: _id('sv')) : view;
    final index = _savedViews.indexWhere((item) => item.id == saved.id);
    if (index < 0) {
      _savedViews.add(saved);
    } else {
      _savedViews[index] = saved;
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> deleteView(String id) async {
    _savedViews.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  @override
  Future<void> setOffline(bool value) async {
    _offline = value;
    notifyListeners();
  }

  @override
  Future<List<MoneyTransaction>> importTransactions(
    List<ImportRow> rows,
  ) async {
    _requireOnline('import these transactions');
    final saved = <MoneyTransaction>[];
    for (final row in rows) {
      final draft = row.transaction;
      if (draft == null) continue;
      final record = draft.copyWith(id: _id('t'));
      _transactions.add(record);
      saved.add(record);
    }
    notifyListeners();
    return saved;
  }

  @override
  Future<void> markSetupStep(String step) async {
    _markSetup(step);
    notifyListeners();
  }

  void _markSetup(String step) {
    if (_profile.completedSetupSteps.contains(step)) return;
    _profile = _profile.copyWith(
      completedSetupSteps: [..._profile.completedSetupSteps, step],
    );
  }

  @override
  Future<void> simulateRemoteEdit(String kind, String id) async {
    switch (kind) {
      case 'transaction':
        final index = _transactions.indexWhere((item) => item.id == id);
        if (index >= 0) {
          _transactions[index] = _transactions[index].copyWith(
            version: _transactions[index].version + 1,
          );
        }
      case 'sharedExpense':
        final index = _sharedExpenses.indexWhere((item) => item.id == id);
        if (index >= 0) {
          _sharedExpenses[index] = _sharedExpenses[index].copyWith(
            version: _sharedExpenses[index].version + 1,
          );
        }
      case 'budget':
        final index = _budgets.indexWhere((item) => item.id == id);
        if (index >= 0) {
          _budgets[index] = _budgets[index].copyWith(
            version: _budgets[index].version + 1,
          );
        }
      case 'space':
        final index = _spaces.indexWhere((item) => item.id == id);
        if (index >= 0) {
          _spaces[index] = _spaces[index].copyWith(
            version: _spaces[index].version + 1,
          );
        }
    }
    notifyListeners();
  }

  @override
  Future<void> reset() async {
    _sequence = 1000;
    _pendingSettlementAccounts.clear();
    _withSampleData ? _seed() : _seedEmpty();
    notifyListeners();
  }
}
