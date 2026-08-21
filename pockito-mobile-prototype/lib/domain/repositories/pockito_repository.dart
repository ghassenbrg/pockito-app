import 'package:flutter/foundation.dart' show Listenable;

import '../models/financial_models.dart';

/// How a list is ordered. One vocabulary shared by every sortable list, so the
/// control looks and behaves the same everywhere.
enum PkSort {
  dateDesc,
  dateAsc,
  amountDesc,
  amountAsc,
  nameAsc,
  nameDesc,
  balanceDesc,
  balanceAsc,
}

extension PkSortLabel on PkSort {
  String get label => switch (this) {
    PkSort.dateDesc => 'Newest first',
    PkSort.dateAsc => 'Oldest first',
    PkSort.amountDesc => 'Largest amount',
    PkSort.amountAsc => 'Smallest amount',
    PkSort.nameAsc => 'Name A–Z',
    PkSort.nameDesc => 'Name Z–A',
    PkSort.balanceDesc => 'Highest balance',
    PkSort.balanceAsc => 'Lowest balance',
  };
}

abstract interface class PockitoRepository implements Listenable {
  DateTime get today;
  String get currentUserId;
  UserProfile get profile;
  List<PockitoUser> get users;
  List<Account> get accounts;
  List<Category> get categories;
  List<Tag> get tags;
  List<PaymentMethod> get paymentMethods;
  List<SharedSpace> get spaces;

  /// Confirmed and draft shared expenses. Voided ones are reached through
  /// [allSharedExpenses].
  List<SharedExpense> get sharedExpenses;
  List<SharedExpense> get allSharedExpenses;
  List<MoneyTransaction> get transactions;
  List<MoneyTransaction> get allTransactions;
  List<Settlement> get settlements;
  List<Budget> get budgets;
  List<Subscription> get subscriptions;
  List<PockitoNotification> get notifications;
  NotificationPreferences get notificationPreferences;
  List<AiConnection> get aiConnections;
  List<AiApproval> get aiApprovals;
  List<SpaceInvitation> get invitations;
  List<SpaceCycle> get cycles;
  List<SpaceActivityEvent> get spaceActivity;
  List<SavedView> get savedViews;
  FxSettings get fxSettings;

  /// True when the prototype is simulating no connection. Writes are refused
  /// before they are submitted rather than failing halfway.
  bool get offline;

  Account? accountById(String id);
  Category? categoryById(String id);
  Tag? tagById(String id);
  PaymentMethod? paymentMethodById(String id);
  SharedSpace? spaceById(String id);
  SharedExpense? sharedExpenseById(String id);
  MoneyTransaction? transactionById(String id);
  Subscription? subscriptionById(String id);
  Settlement? settlementById(String id);
  Budget? budgetById(String id);
  PockitoUser? userById(String id);

  /// Children of [parentId], or top-level categories when it is null.
  List<Category> categoryChildren(String? parentId);

  /// What the current user may do in [spaceId].
  SpacePermissions permissionsFor(String spaceId);

  /// Names of the members who could perform [permission] when the current user
  /// cannot — the "who can help" half of a denied state.
  List<String> whoCanHelp(String spaceId, String permission);

  int accountBalance(Account account);

  /// Balance including credit headroom, or null when the account has none.
  int? accountAvailable(Account account);
  int netWorthMinor(String currency);
  SpendingSummary spendingForMonth(DateTime month);
  PeriodComparison spendingComparison(DateTime month);
  SharedSummary sharedSummary();
  int memberBalance(String spaceId, String userId, {bool lifetime = false});

  /// Who owes whom across every active Space, smallest set of payments.
  List<DebtEdge> debtEdges();

  /// Everything waiting on the user, most urgent first.
  List<ActionItem> actionItems();
  FinancialHealth financialHealth(DateTime month);

  /// Monthly outflow for the [months] months ending at [month].
  List<SeriesPoint> spendSeries(DateTime month, {int months = 6});
  List<CategorySlice> categoryBreakdown(DateTime month, {int limit = 6});

  /// Running balance of [account] over the last [days] days.
  List<SeriesPoint> accountBalanceSeries(Account account, {int days = 30});

  BudgetSnapshot budgetSnapshot(Budget budget);
  BudgetSnapshot budgetSnapshotForMonth(Budget budget, DateTime month);
  BudgetWindow budgetWindow(Budget budget, DateTime reference);

  int? convertMinor(int amountMinor, String fromCurrency, String toCurrency);
  FxQuote? fxQuote(String fromCurrency, String toCurrency, {FxRateMode? mode});
  List<Settlement> settlementRecommendations(String spaceId);

  /// Rows a CSV would produce, classified, before anything is written.
  ImportPreview previewImport(String csv);
  String exportCsv(List<MoneyTransaction> rows);
  String exportJson(List<MoneyTransaction> rows);

  Future<void> saveProfile(UserProfile profile);
  Future<Account> saveAccount(Account account);
  Future<void> archiveAccount(String accountId, bool archived);
  Future<void> reorderAccounts(List<String> orderedIds);
  Future<SharedSpace> saveSpace(SharedSpace space);
  Future<void> archiveSpace(String spaceId, bool archived);
  Future<SpaceInvitation> inviteMember(
    String spaceId, {
    required String name,
    required String email,
    SpaceRole role,
    int expiryDays,
  });
  Future<void> respondToInvitation(
    String invitationId,
    InvitationStatus status,
  );
  Future<void> revokeInvitation(String invitationId);
  Future<SpaceInvitation> resendInvitation(String invitationId);
  Future<void> setMemberRole(String spaceId, String userId, SpaceRole role);
  Future<void> removeMember(String spaceId, String userId);
  Future<void> leaveSpace(String spaceId);
  Future<SpaceCycle> startNewCycle(String spaceId);

  Future<MoneyTransaction> saveTransaction(MoneyTransaction transaction);
  Future<SharedExpense> saveSharedExpense(
    SharedExpense expense, {
    String? accountId,
  });

  /// Marks a record voided. It stays visible, struck through, and out of every
  /// balance. Nothing is ever removed.
  Future<void> voidTransaction(String id, {String? reason});
  Future<void> voidSharedExpense(String id, {String? reason});
  Future<void> restoreTransaction(String id);
  Future<void> restoreSharedExpense(String id);

  /// Promotes a draft to confirmed.
  Future<void> confirmTransaction(String id);
  Future<void> confirmSharedExpense(String id);

  Future<Budget> saveBudget(Budget budget);
  Future<void> deleteBudget(String id);

  /// Restores a budget that was just deleted, for Undo.
  Future<void> restoreBudget(Budget budget);
  Future<Subscription> saveSubscription(Subscription subscription);
  Future<void> deleteSubscription(String id);
  Future<Category> addCategory(Category category);
  Future<Category> updateCategory(Category category);
  Future<void> deleteCategory(String id);
  Future<void> reassignAndDeleteCategory(String id, String replacementId);
  Future<void> setCategoryHidden(String id, bool hidden);
  Future<Tag> saveTag(Tag tag);
  Future<void> deleteTag(String id);
  Future<PaymentMethod> savePaymentMethod(PaymentMethod method);
  Future<void> deletePaymentMethod(String id);
  Future<MoneyTransaction> recordSubscriptionPayment(
    String subscriptionId, {
    required String accountId,
    required DateTime date,
  });
  Future<void> skipSubscription(String subscriptionId);

  /// Posts every recurring item that has come due. Occurrences arrive as
  /// drafts unless the item opts into `autoPost`.
  Future<List<MoneyTransaction>> materialiseDueOccurrences();

  /// The prototype's stand-in for the other side acting on a proposal, so the
  /// propose→confirm loop is walkable on one device.
  Future<Settlement> simulateCounterpartyResponse(
    String settlementId, {
    required bool confirm,
  });

  /// Records a claim that money moved. It shifts no balance until the other
  /// side confirms it.
  Future<Settlement> proposeSettlement(
    Settlement settlement, {
    String? accountId,
  });
  Future<Settlement> confirmSettlement(
    String settlementId, {
    String? accountId,
  });
  Future<void> cancelSettlement(String settlementId, {String? reason});

  /// Corrects an account balance without inventing an expense or income.
  Future<MoneyTransaction> recordAdjustment({
    required String accountId,
    required int targetBalanceMinor,
    required String reason,
    DateTime? date,
  });

  Future<void> markNotificationRead(String id);
  Future<void> markAllNotificationsRead();
  Future<void> dismissNotification(String id, bool dismissed);
  Future<void> saveNotificationPreferences(NotificationPreferences prefs);
  Future<void> approveAiApproval(String id);
  Future<void> rejectAiApproval(String id);
  Future<void> saveAiConnection(AiConnection connection);
  Future<void> disconnectAiConnection(String id);
  Future<void> setThemeMode(String mode);
  Future<void> saveFxSettings(FxSettings settings);
  Future<void> setManualRate(String pair, double rate);
  Future<SavedView> saveView(SavedView view);
  Future<void> deleteView(String id);
  Future<void> setOffline(bool value);
  Future<List<MoneyTransaction>> importTransactions(List<ImportRow> rows);
  Future<void> markSetupStep(String step);
  Future<void> reset();

  /// Bumps a record's version behind the user's back, so the conflict path is
  /// reachable in a prototype with no second device.
  Future<void> simulateRemoteEdit(String kind, String id);
}
