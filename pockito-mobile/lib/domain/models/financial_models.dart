import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'financial_models.freezed.dart';

enum AccountType { bank, card, cash, savings, digital }

/// `adjustment` exists so a balance can be corrected without inventing a fake
/// expense or income. It never counts as spending and never counts as earning.
enum MoneyEventType { expense, income, transfer, settlement, adjustment }

enum CategoryType { expense, income }

enum SpaceType { household, trip, couple, friends, other }

extension SpaceTypeLabel on SpaceType {
  /// Two Spaces can share a name — two "Household"s is the normal case, not
  /// an edge one — so the type has to appear wherever the name does.
  String get label => switch (this) {
    SpaceType.household => 'Household',
    SpaceType.trip => 'Trip',
    SpaceType.couple => 'Couple',
    SpaceType.friends => 'Friends',
    SpaceType.other => 'Other',
  };

  String get icon => switch (this) {
    SpaceType.household => 'housing',
    SpaceType.trip => 'travel',
    SpaceType.couple => 'gift',
    SpaceType.friends => 'group',
    SpaceType.other => 'group',
  };
}

enum SpaceStatus { active, archived }

enum SplitMethod { equal, percentage, shares, exact, itemized }

enum BudgetScope { personal, space }

enum SubscriptionStatus { active, paused, ended }

enum BudgetHealth { healthy, near, exceeded }

enum FxRateMode { automatic, manual }

enum InvitationStatus { pending, accepted, declined, revoked, expired }

/// Every money record moves through this lifecycle. A record is never removed:
/// `voided` keeps the history and drops out of every balance.
enum RecordStatus { draft, confirmed, voided }

/// A settlement is a claim until the other side agrees with it.
enum SettlementStatus { proposed, confirmed, cancelled }

/// Where a receipt is in its extraction lifecycle. `none` is an attachment the
/// user added by hand and never asked us to read.
enum OcrStatus { none, pending, processing, completed, failed }

enum BudgetPeriod { weekly, monthly, quarterly, yearly, custom }

/// One recurrence engine drives both. `subscription` is the filtered view the
/// Subscriptions screen shows; `template` is everything else that repeats.
enum RecurringKind { subscription, template }

enum PaymentMethodKind { card, bankTransfer, cash, direct, digital }

/// Fixed role ladder. `viewer` can read a Space and nothing else.
enum SpaceRole { owner, admin, member, viewer }

/// What a Space activity entry records. `denied` entries are the ones that
/// make the log an audit record rather than a feed of pleasantries.
enum ActivityOutcome { granted, denied }

enum SpaceActivityType {
  expenseAdded,
  expenseEdited,
  expenseVoided,
  settlementProposed,
  settlementConfirmed,
  settlementCancelled,
  memberInvited,
  memberJoined,
  memberRemoved,
  memberLeft,
  roleChanged,
  inviteRevoked,
  budgetChanged,
  settingsChanged,
  cycleClosed,
  permissionDenied,
}

@freezed
abstract class CurrencyInfo with _$CurrencyInfo {
  const factory CurrencyInfo({
    required String code,
    required String symbol,
    required int decimals,
    required String name,
    @Default('') String flag,
  }) = _CurrencyInfo;
}

abstract final class PockitoCurrencies {
  static const all = <String, CurrencyInfo>{
    'EUR': CurrencyInfo(
      code: 'EUR',
      symbol: '€',
      decimals: 2,
      name: 'Euro',
      flag: '🇪🇺',
    ),
    'USD': CurrencyInfo(
      code: 'USD',
      symbol: r'$',
      decimals: 2,
      name: 'US Dollar',
      flag: '🇺🇸',
    ),
    'JPY': CurrencyInfo(
      code: 'JPY',
      symbol: '¥',
      decimals: 0,
      name: 'Japanese Yen',
      flag: '🇯🇵',
    ),
    'GBP': CurrencyInfo(
      code: 'GBP',
      symbol: '£',
      decimals: 2,
      name: 'British Pound',
      flag: '🇬🇧',
    ),
    'CHF': CurrencyInfo(
      code: 'CHF',
      symbol: 'Fr',
      decimals: 2,
      name: 'Swiss Franc',
      flag: '🇨🇭',
    ),
    'TND': CurrencyInfo(
      code: 'TND',
      symbol: 'DT',
      decimals: 3,
      name: 'Tunisian Dinar',
      flag: '🇹🇳',
    ),
    'SEK': CurrencyInfo(
      code: 'SEK',
      symbol: 'kr',
      decimals: 2,
      name: 'Swedish Krona',
      flag: '🇸🇪',
    ),
    'NOK': CurrencyInfo(
      code: 'NOK',
      symbol: 'kr',
      decimals: 2,
      name: 'Norwegian Krone',
      flag: '🇳🇴',
    ),
    'DKK': CurrencyInfo(
      code: 'DKK',
      symbol: 'kr',
      decimals: 2,
      name: 'Danish Krone',
      flag: '🇩🇰',
    ),
    'PLN': CurrencyInfo(
      code: 'PLN',
      symbol: 'zł',
      decimals: 2,
      name: 'Polish Złoty',
      flag: '🇵🇱',
    ),
    'CZK': CurrencyInfo(
      code: 'CZK',
      symbol: 'Kč',
      decimals: 2,
      name: 'Czech Koruna',
      flag: '🇨🇿',
    ),
    'CAD': CurrencyInfo(
      code: 'CAD',
      symbol: r'C$',
      decimals: 2,
      name: 'Canadian Dollar',
      flag: '🇨🇦',
    ),
    'AUD': CurrencyInfo(
      code: 'AUD',
      symbol: r'A$',
      decimals: 2,
      name: 'Australian Dollar',
      flag: '🇦🇺',
    ),
    'NZD': CurrencyInfo(
      code: 'NZD',
      symbol: r'NZ$',
      decimals: 2,
      name: 'New Zealand Dollar',
      flag: '🇳🇿',
    ),
    'SGD': CurrencyInfo(
      code: 'SGD',
      symbol: r'S$',
      decimals: 2,
      name: 'Singapore Dollar',
      flag: '🇸🇬',
    ),
    'HKD': CurrencyInfo(
      code: 'HKD',
      symbol: r'HK$',
      decimals: 2,
      name: 'Hong Kong Dollar',
      flag: '🇭🇰',
    ),
    'KRW': CurrencyInfo(
      code: 'KRW',
      symbol: '₩',
      decimals: 0,
      name: 'South Korean Won',
      flag: '🇰🇷',
    ),
    'CNY': CurrencyInfo(
      code: 'CNY',
      symbol: '¥',
      decimals: 2,
      name: 'Chinese Yuan',
      flag: '🇨🇳',
    ),
    'INR': CurrencyInfo(
      code: 'INR',
      symbol: '₹',
      decimals: 2,
      name: 'Indian Rupee',
      flag: '🇮🇳',
    ),
    'BRL': CurrencyInfo(
      code: 'BRL',
      symbol: r'R$',
      decimals: 2,
      name: 'Brazilian Real',
      flag: '🇧🇷',
    ),
    'MXN': CurrencyInfo(
      code: 'MXN',
      symbol: r'MX$',
      decimals: 2,
      name: 'Mexican Peso',
      flag: '🇲🇽',
    ),
    'ZAR': CurrencyInfo(
      code: 'ZAR',
      symbol: 'R',
      decimals: 2,
      name: 'South African Rand',
      flag: '🇿🇦',
    ),
    'AED': CurrencyInfo(
      code: 'AED',
      symbol: 'د.إ',
      decimals: 2,
      name: 'UAE Dirham',
      flag: '🇦🇪',
    ),
    'SAR': CurrencyInfo(
      code: 'SAR',
      symbol: '﷼',
      decimals: 2,
      name: 'Saudi Riyal',
      flag: '🇸🇦',
    ),
    'TRY': CurrencyInfo(
      code: 'TRY',
      symbol: '₺',
      decimals: 2,
      name: 'Turkish Lira',
      flag: '🇹🇷',
    ),
    'MAD': CurrencyInfo(
      code: 'MAD',
      symbol: 'د.م.',
      decimals: 2,
      name: 'Moroccan Dirham',
      flag: '🇲🇦',
    ),
    'EGP': CurrencyInfo(
      code: 'EGP',
      symbol: 'E£',
      decimals: 2,
      name: 'Egyptian Pound',
      flag: '🇪🇬',
    ),
    'THB': CurrencyInfo(
      code: 'THB',
      symbol: '฿',
      decimals: 2,
      name: 'Thai Baht',
      flag: '🇹🇭',
    ),
    'IDR': CurrencyInfo(
      code: 'IDR',
      symbol: 'Rp',
      decimals: 2,
      name: 'Indonesian Rupiah',
      flag: '🇮🇩',
    ),
    'ILS': CurrencyInfo(
      code: 'ILS',
      symbol: '₪',
      decimals: 2,
      name: 'Israeli Shekel',
      flag: '🇮🇱',
    ),
  };

  static CurrencyInfo of(String code) =>
      all[code] ??
      CurrencyInfo(code: code, symbol: code, decimals: 2, name: code);
}

extension CurrencyInfoValues on CurrencyInfo {
  int get minorUnitScale {
    var scale = 1;
    for (var index = 0; index < decimals; index++) {
      scale *= 10;
    }
    return scale;
  }
}

/// What a member is allowed to do in one Space.
///
/// Derived, never stored: role plus the Space's own status decide everything,
/// so there is a single place to change the matrix and no way for a stored
/// copy to drift from the role it was derived from.
@immutable
class SpacePermissions {
  const SpacePermissions({
    required this.role,
    required this.readOnly,
    required this.canAddExpense,
    required this.canEditOwnExpense,
    required this.canEditAnyExpense,
    required this.canVoidAnyExpense,
    required this.canSettle,
    required this.canManageBudgets,
    required this.canInvite,
    required this.canRemoveMember,
    required this.canChangeRoles,
    required this.canEditSettings,
    required this.canArchive,
    required this.canCloseCycle,
    required this.canLeave,
  });

  /// The permissions of a member with [role] in a Space whose status is
  /// [archived]. An archived Space is read-only for everyone including its
  /// owner — reopening it is the only write it accepts.
  factory SpacePermissions.forRole(SpaceRole role, {bool archived = false}) {
    final owner = role == SpaceRole.owner;
    final admin = owner || role == SpaceRole.admin;
    final writer = admin || role == SpaceRole.member;
    bool live(bool value) => value && !archived;
    return SpacePermissions(
      role: role,
      readOnly: archived || role == SpaceRole.viewer,
      canAddExpense: live(writer),
      canEditOwnExpense: live(writer),
      canEditAnyExpense: live(admin),
      canVoidAnyExpense: live(admin),
      canSettle: live(writer),
      canManageBudgets: live(admin),
      canInvite: live(admin),
      canRemoveMember: live(admin),
      canChangeRoles: live(owner),
      canEditSettings: live(admin),
      canArchive: owner,
      canCloseCycle: live(admin),
      canLeave: !owner,
    );
  }

  /// A member of a Space that does not exist, or one you are not part of.
  static const none = SpacePermissions(
    role: SpaceRole.viewer,
    readOnly: true,
    canAddExpense: false,
    canEditOwnExpense: false,
    canEditAnyExpense: false,
    canVoidAnyExpense: false,
    canSettle: false,
    canManageBudgets: false,
    canInvite: false,
    canRemoveMember: false,
    canChangeRoles: false,
    canEditSettings: false,
    canArchive: false,
    canCloseCycle: false,
    canLeave: false,
  );

  final SpaceRole role;

  /// True when nothing in the Space can be written, whatever the reason.
  final bool readOnly;
  final bool canAddExpense;
  final bool canEditOwnExpense;
  final bool canEditAnyExpense;
  final bool canVoidAnyExpense;
  final bool canSettle;
  final bool canManageBudgets;
  final bool canInvite;
  final bool canRemoveMember;
  final bool canChangeRoles;
  final bool canEditSettings;
  final bool canArchive;
  final bool canCloseCycle;
  final bool canLeave;

  /// Whether this member may edit an expense recorded by [authorUserId].
  bool canEditExpenseBy(String authorUserId, String myUserId) =>
      canEditAnyExpense || (canEditOwnExpense && authorUserId == myUserId);

  bool canVoidExpenseBy(String authorUserId, String myUserId) =>
      canVoidAnyExpense || (canEditOwnExpense && authorUserId == myUserId);

  @override
  bool operator ==(Object other) =>
      other is SpacePermissions &&
      other.role == role &&
      other.readOnly == readOnly &&
      other.canAddExpense == canAddExpense &&
      other.canEditAnyExpense == canEditAnyExpense &&
      other.canSettle == canSettle &&
      other.canManageBudgets == canManageBudgets &&
      other.canInvite == canInvite &&
      other.canChangeRoles == canChangeRoles &&
      other.canArchive == canArchive;

  @override
  int get hashCode => Object.hash(
    role,
    readOnly,
    canAddExpense,
    canEditAnyExpense,
    canSettle,
    canManageBudgets,
    canInvite,
    canChangeRoles,
    canArchive,
  );
}

extension SpaceRoleLabel on SpaceRole {
  String get label => switch (this) {
    SpaceRole.owner => 'Owner',
    SpaceRole.admin => 'Admin',
    SpaceRole.member => 'Member',
    SpaceRole.viewer => 'Viewer',
  };

  /// One line describing the role, used wherever a role is chosen or reviewed.
  String get summary => switch (this) {
    SpaceRole.owner =>
      'Full control, including roles and archiving. There is always one owner.',
    SpaceRole.admin =>
      'Can edit anyone’s expenses, manage budgets, invite and remove members.',
    SpaceRole.member => 'Can add expenses, edit their own, and settle up.',
    SpaceRole.viewer => 'Can see everything and change nothing.',
  };

  String get wireValue => switch (this) {
    SpaceRole.owner => 'OWNER',
    SpaceRole.admin => 'ADMIN',
    SpaceRole.member => 'MEMBER',
    SpaceRole.viewer => 'VIEWER',
  };

  static SpaceRole parse(String value) => switch (value.toUpperCase()) {
    'OWNER' => SpaceRole.owner,
    'ADMIN' => SpaceRole.admin,
    'VIEWER' => SpaceRole.viewer,
    _ => SpaceRole.member,
  };
}

@freezed
abstract class PockitoUser with _$PockitoUser {
  const factory PockitoUser({
    required String id,
    required String name,
    required String initials,
    @Default(false) bool isYou,
  }) = _PockitoUser;
}

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String userId,
    required String displayName,
    required String email,
    required String country,
    required String countryName,
    required String reportingCurrency,
    required String locale,
    required String timezone,
    @Default(ThemeMode.system) ThemeMode themeMode,
    @Default('English') String language,
    String? avatarPath,
    @Default(<String>[]) List<String> recentCurrencies,
    @Default(false) bool hapticsOff,

    /// Masks every balance in the app without changing the layout, so a
    /// glance over the shoulder shows the shape of the screen and none of
    /// the numbers.
    @Default(false) bool balancesHidden,
    @Default(<String>[]) List<String> completedSetupSteps,
    @Default(false) bool setupChecklistDismissed,
    @Default(false) bool debugToolsEnabled,
  }) = _UserProfile;
}

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    required String currency,
    required int openingBalanceMinor,
    @Default(false) bool isDefault,
    @Default(false) bool archived,
    @Default(0) int colorIndex,
    @Default('wallet') String icon,
    @Default(0) int sortOrder,
    @Default('') String note,

    /// Spending headroom on a card. Available balance is the credit limit plus
    /// the (negative) current balance.
    int? creditLimitMinor,

    /// Savings target. Progress is the current balance against it.
    int? goalAmountMinor,
    DateTime? goalTargetDate,
    @Default(1) int version,
  }) = _Account;
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required CategoryType type,
    required String icon,
    @Default(0) int colorIndex,
    @Default(false) bool system,

    /// Parent in the category tree. One level deep: a child never has children.
    String? parentId,

    /// System categories cannot be deleted, so they are hidden instead.
    @Default(false) bool hidden,
    @Default(1) int version,
  }) = _Category;
}

@freezed
abstract class Tag with _$Tag {
  const factory Tag({
    required String id,
    required String name,
    @Default(0) int colorIndex,
    @Default(false) bool archived,
  }) = _Tag;
}

@freezed
abstract class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String id,
    required String name,
    required PaymentMethodKind kind,
    @Default('card') String icon,
    @Default(0) int colorIndex,
    String? last4,

    /// The account this method draws on, when it maps to one.
    String? accountId,
    @Default(false) bool archived,
  }) = _PaymentMethod;
}

@freezed
abstract class ReceiptAttachment with _$ReceiptAttachment {
  const factory ReceiptAttachment({
    required String id,
    required String label,
    required DateTime capturedAt,
    @Default(OcrStatus.none) OcrStatus ocrStatus,
    @Default(0) int byteSize,

    /// Stand-in for the stored image in this local prototype: a stable seed the
    /// viewer renders a deterministic placeholder from.
    @Default(0) int previewSeed,
    int? extractedTotalMinor,
    String? extractedMerchant,
    DateTime? extractedDate,
    String? failureReason,
  }) = _ReceiptAttachment;
}

@freezed
abstract class SpaceMember with _$SpaceMember {
  const factory SpaceMember({
    required String userId,
    @Default(SpaceRole.member) SpaceRole role,
    @Default(true) bool active,
    DateTime? joinedAt,
  }) = _SpaceMember;
}

@freezed
abstract class SharedSpace with _$SharedSpace {
  const factory SharedSpace({
    required String id,
    required String name,
    required SpaceType type,
    required String currency,
    required List<SpaceMember> members,
    required SplitMethod defaultSplitMethod,
    @Default(<String, int>{}) Map<String, int> defaultPercentages,
    @Default(<String, int>{}) Map<String, int> defaultAllocations,
    @Default('current') String currentCycleId,
    @Default(SpaceStatus.active) SpaceStatus status,
    @Default(0) int colorIndex,
    @Default('group') String icon,
    @Default(true) bool notifyNewExpenses,
    @Default(true) bool notifySettlements,
    @Default(false) bool notifyAllActivity,
    @Default(1) int version,
  }) = _SharedSpace;
}

@freezed
abstract class SplitShare with _$SplitShare {
  const factory SplitShare({required String userId, required int amountMinor}) =
      _SplitShare;
}

/// One line of an itemized split: who had what, and for how much.
@freezed
abstract class SplitItem with _$SplitItem {
  const factory SplitItem({
    required String id,
    required String label,
    required int amountMinor,
    required List<String> participantIds,
  }) = _SplitItem;
}

/// One of possibly several people who put money into a shared expense.
@freezed
abstract class ExpensePayer with _$ExpensePayer {
  const factory ExpensePayer({
    required String userId,
    required int amountMinor,

    /// The payer's own account, recorded only when the payer is you — nobody
    /// else's ledger lives in this app.
    String? accountId,
  }) = _ExpensePayer;
}

@freezed
abstract class SharedExpense with _$SharedExpense {
  const factory SharedExpense({
    required String id,
    required String spaceId,
    required String title,
    required int totalMinor,
    required String currency,
    required DateTime occurredOn,
    required String categoryId,
    required SplitMethod method,

    /// Everyone who paid. The sum of `amountMinor` always equals `totalMinor`.
    required List<ExpensePayer> payers,
    required List<SplitShare> shares,
    @Default(<SplitItem>[]) List<SplitItem> items,
    @Default('current') String cycleId,
    String? paidFromAccountId,
    int? walletAmountMinor,
    String? walletCurrency,
    double? exchangeRate,
    FxRateMode? fxRateMode,
    DateTime? rateUpdatedAt,
    @Default('mobile') String source,
    String? client,
    @Default(RecordStatus.confirmed) RecordStatus status,
    @Default('') String note,
    @Default(<String>[]) List<String> tagIds,
    @Default(<ReceiptAttachment>[]) List<ReceiptAttachment> attachments,

    /// Who recorded it. Editing someone else's expense needs admin rights.
    @Default('') String createdByUserId,
    DateTime? voidedAt,
    String? voidReason,
    @Default(1) int version,
  }) = _SharedExpense;
}

extension SharedExpensePayers on SharedExpense {
  /// The payer who put in the most, used wherever one name has to stand for
  /// the expense. With a single payer this is simply that payer.
  String get primaryPayerUserId =>
      payers.isEmpty ? createdByUserId : _largestPayer.userId;

  ExpensePayer get _largestPayer =>
      payers.reduce((a, b) => b.amountMinor > a.amountMinor ? b : a);

  bool get hasMultiplePayers => payers.length > 1;

  int paidBy(String userId) => payers
      .where((payer) => payer.userId == userId)
      .fold(0, (sum, payer) => sum + payer.amountMinor);

  int get allocatedMinor =>
      payers.fold(0, (sum, payer) => sum + payer.amountMinor);

  bool get isVoided => status == RecordStatus.voided;
  bool get isDraft => status == RecordStatus.draft;

  /// Voided rows never move a balance; drafts are staged and do not either.
  bool get countsTowardsBalances => status == RecordStatus.confirmed;
}

@freezed
abstract class MoneyTransaction with _$MoneyTransaction {
  const factory MoneyTransaction({
    required String id,
    required MoneyEventType type,
    required int amountMinor,
    required String currency,
    required DateTime occurredOn,
    required String merchant,
    String? fromAccountId,
    String? toAccountId,
    String? categoryId,
    String? splitId,
    String? settlementId,
    String? subscriptionId,
    int? sourceAmountMinor,
    String? sourceCurrency,
    int? destinationAmountMinor,
    String? destinationCurrency,
    double? exchangeRate,
    FxRateMode? fxRateMode,
    DateTime? rateUpdatedAt,
    @Default(0) int feeMinor,
    String? feeCurrency,
    @Default('mobile') String source,
    String? client,
    @Default(RecordStatus.confirmed) RecordStatus status,

    /// Why, in the user's words. `merchant` says what it was; this says why.
    @Default('') String note,
    @Default(<String>[]) List<String> tagIds,
    String? paymentMethodId,
    @Default(<ReceiptAttachment>[]) List<ReceiptAttachment> attachments,
    String? adjustmentReason,
    DateTime? voidedAt,
    String? voidReason,
    @Default(1) int version,
  }) = _MoneyTransaction;
}

extension MoneyTransactionLifecycle on MoneyTransaction {
  bool get isVoided => status == RecordStatus.voided;
  bool get isDraft => status == RecordStatus.draft;
  bool get countsTowardsBalances => status == RecordStatus.confirmed;
}

@freezed
abstract class Settlement with _$Settlement {
  const factory Settlement({
    required String id,
    required String spaceId,
    required String fromUserId,
    required String toUserId,
    required int amountMinor,
    required String currency,
    required DateTime createdAt,
    DateTime? settledAt,
    @Default(SettlementStatus.proposed) SettlementStatus status,
    @Default('') String note,
    @Default('mobile') String source,
    @Default('current') String cycleId,

    /// Who proposed it. The other side is the one who can confirm.
    @Default('') String proposedByUserId,
    String? confirmedByUserId,
    String? cancelledByUserId,
    DateTime? cancelledAt,
    String? cancelReason,
    @Default(1) int version,
  }) = _Settlement;
}

extension SettlementLifecycle on Settlement {
  bool get isConfirmed => status == SettlementStatus.confirmed;
  bool get isPending => status == SettlementStatus.proposed;

  /// The recipient confirms, because the recipient is the only one who knows
  /// the money arrived. Nobody can declare on someone else's behalf that they
  /// have been paid.
  String get confirmerUserId => toUserId;

  bool canConfirm(String userId) => isPending && toUserId == userId;

  /// Either side can walk away from a proposal.
  bool canCancel(String userId) =>
      isPending && (userId == fromUserId || userId == toUserId);
}

@freezed
abstract class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String name,
    required BudgetScope scope,
    required String categoryId,
    required int limitMinor,
    required String currency,
    String? spaceId,
    @Default(<String>[]) List<String> categoryIds,
    @Default(<String>[]) List<String> accountIds,
    DateTime? startsOn,
    @Default(<int>[80, 100]) List<int> alerts,
    @Default(BudgetPeriod.monthly) BudgetPeriod period,

    /// Length of a custom period, in days. Ignored for the named periods.
    @Default(30) int customPeriodDays,

    /// Carries whatever was left of the last period into this one.
    @Default(false) bool rollover,
    @Default(1) int version,
  }) = _Budget;
}

extension BudgetPeriodLabel on BudgetPeriod {
  String get label => switch (this) {
    BudgetPeriod.weekly => 'Weekly',
    BudgetPeriod.monthly => 'Monthly',
    BudgetPeriod.quarterly => 'Quarterly',
    BudgetPeriod.yearly => 'Yearly',
    BudgetPeriod.custom => 'Custom',
  };

  String get noun => switch (this) {
    BudgetPeriod.weekly => 'week',
    BudgetPeriod.monthly => 'month',
    BudgetPeriod.quarterly => 'quarter',
    BudgetPeriod.yearly => 'year',
    BudgetPeriod.custom => 'period',
  };
}

/// The window a budget is being measured over.
@freezed
abstract class BudgetWindow with _$BudgetWindow {
  const factory BudgetWindow({
    required DateTime start,

    /// Exclusive: the first instant that is no longer in the window.
    required DateTime end,
    required String label,
  }) = _BudgetWindow;
}

@freezed
abstract class SubscriptionCadence with _$SubscriptionCadence {
  const factory SubscriptionCadence({
    @Default('MONTHLY') String frequency,
    @Default(1) int interval,
    int? dayOfMonth,
    int? monthOfYear,
  }) = _SubscriptionCadence;
}

/// The single recurring engine. Subscriptions are the `subscription`-kind view
/// over it; anything else that repeats is a `template`.
@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String name,
    required int amountMinor,
    required String currency,
    required String accountId,
    required String categoryId,
    required String icon,
    required SubscriptionCadence cadence,
    required DateTime startsOn,
    DateTime? nextDueOn,
    DateTime? lastPaidOn,
    @Default(SubscriptionStatus.active) SubscriptionStatus status,
    @Default(false) bool archived,
    @Default(RecurringKind.subscription) RecurringKind kind,
    DateTime? endsOn,
    @Default(MoneyEventType.expense) MoneyEventType eventType,

    /// Occurrences always materialise as drafts you confirm. Auto-posting a
    /// money record nobody looked at is how ledgers rot.
    @Default(false) bool autoPost,
    @Default(<String>[]) List<String> tagIds,
    String? paymentMethodId,
    @Default('') String note,
    @Default(1) int version,
  }) = _Subscription;
}

@freezed
abstract class FxSettings with _$FxSettings {
  const factory FxSettings({
    @Default(FxRateMode.automatic) FxRateMode mode,
    @Default(<String, double>{}) Map<String, double> manualRates,
    required DateTime lastUpdatedAt,

    /// Which rate source is in force. A stable identifier rather than a
    /// display string, so stored data does not change with the reader's
    /// language; the UI translates it at render.
    @Default(FxProvider.prototypeSnapshot) FxProvider provider,
    @Default(<FxRateChange>[]) List<FxRateChange> history,
  }) = _FxSettings;
}

/// Where a rate came from. Stored as an identifier rather than a display
/// string so persisted data does not shift with the reader's language.
/// [manualRate] applies to a quote, never to the settings themselves.
enum FxProvider { prototypeSnapshot, manualConfiguration, manualRate }

/// One recorded change to a rate, so a manual override is never anonymous.
@freezed
abstract class FxRateChange with _$FxRateChange {
  const factory FxRateChange({
    required String pair,
    required double rate,
    required DateTime at,
    required FxRateMode mode,
    required FxProvider source,
    double? previousRate,
  }) = _FxRateChange;
}

@freezed
abstract class FxQuote with _$FxQuote {
  const factory FxQuote({
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    required FxRateMode mode,
    required DateTime updatedAt,
    required FxProvider source,
  }) = _FxQuote;
}

@freezed
abstract class SpaceInvitation with _$SpaceInvitation {
  const factory SpaceInvitation({
    required String id,
    required String spaceId,
    required String name,
    required String email,
    required DateTime invitedAt,
    @Default(InvitationStatus.pending) InvitationStatus status,
    DateTime? respondedAt,
    String? userId,

    /// Invites expire so a forwarded link does not stay live forever.
    required DateTime expiresAt,
    @Default(7) int expiryDays,
    @Default(SpaceRole.member) SpaceRole role,
    @Default('') String invitedByUserId,
    @Default(0) int resendCount,
  }) = _SpaceInvitation;
}

extension SpaceInvitationState on SpaceInvitation {
  bool isExpiredAt(DateTime now) =>
      status == InvitationStatus.pending && !now.isBefore(expiresAt);

  InvitationStatus effectiveStatus(DateTime now) =>
      isExpiredAt(now) ? InvitationStatus.expired : status;
}

@freezed
abstract class SpaceCycle with _$SpaceCycle {
  const factory SpaceCycle({
    required String id,
    required String spaceId,
    required String label,
    required DateTime startedAt,
    required DateTime endedAt,
    required List<String> expenseIds,
    required List<String> settlementIds,
    required int spentMinor,
    required String currency,
    @Default(0) int budgetLimitMinor,
    @Default(<String, int>{}) Map<String, int> memberPaidMinor,
    @Default(<String, int>{}) Map<String, int> memberResponsibilityMinor,
    @Default(<String, int>{}) Map<String, int> categoryTotalsMinor,
  }) = _SpaceCycle;
}

/// One line of a Space's audit log.
@freezed
abstract class SpaceActivityEvent with _$SpaceActivityEvent {
  const factory SpaceActivityEvent({
    required String id,
    required String spaceId,
    required String actorUserId,
    required DateTime at,
    required SpaceActivityType type,

    /// Plain-language sentence for the friendly view.
    required String summary,
    @Default(ActivityOutcome.granted) ActivityOutcome outcome,
    String? entityId,
    String? entityLabel,

    /// The permission that was checked, present on denied entries.
    String? permission,
    String? detail,
  }) = _SpaceActivityEvent;
}

@freezed
abstract class PockitoNotification with _$PockitoNotification {
  const factory PockitoNotification({
    required String id,
    required String type,
    required DateTime at,
    required String title,
    required String body,
    required String destination,
    String? entityId,
    @Default(false) bool read,
    @Default(false) bool dismissed,
  }) = _PockitoNotification;
}

/// The catalogue notification preferences are written against, so a preference
/// switch always maps to an event that can actually fire.
enum NotificationEvent {
  expenseAdded,
  expenseEdited,
  settlementProposed,
  settlementConfirmed,
  memberJoined,
  inviteReceived,
  budgetThreshold,
  subscriptionDue,
  aiApproval,
  aiChange,
}

extension NotificationEventInfo on NotificationEvent {
  String get wireType => switch (this) {
    NotificationEvent.expenseAdded => 'EXPENSE_ADDED',
    NotificationEvent.expenseEdited => 'EXPENSE_EDITED',
    NotificationEvent.settlementProposed => 'SETTLEMENT_REQUEST',
    NotificationEvent.settlementConfirmed => 'SETTLEMENT_CONFIRMED',
    NotificationEvent.memberJoined => 'MEMBER_JOINED',
    NotificationEvent.inviteReceived => 'INVITE_RECEIVED',
    NotificationEvent.budgetThreshold => 'BUDGET_ALERT',
    NotificationEvent.subscriptionDue => 'SUBSCRIPTION_DUE',
    NotificationEvent.aiApproval => 'AI_APPROVAL',
    NotificationEvent.aiChange => 'AI_CHANGE',
  };

  String get label => switch (this) {
    NotificationEvent.expenseAdded => 'Shared expense added',
    NotificationEvent.expenseEdited => 'Shared expense edited',
    NotificationEvent.settlementProposed => 'Someone says they paid you',
    NotificationEvent.settlementConfirmed => 'A settlement was confirmed',
    NotificationEvent.memberJoined => 'Someone joined a Space',
    NotificationEvent.inviteReceived => 'You were invited to a Space',
    NotificationEvent.budgetThreshold => 'A budget crosses a threshold',
    NotificationEvent.subscriptionDue => 'A subscription is due',
    NotificationEvent.aiApproval => 'An AI app needs approval',
    NotificationEvent.aiChange => 'An AI app changed something',
  };

  /// Whether the event is waiting on the user rather than merely informing.
  bool get actionRequired => switch (this) {
    NotificationEvent.settlementProposed ||
    NotificationEvent.inviteReceived ||
    NotificationEvent.aiApproval => true,
    _ => false,
  };

  static NotificationEvent? fromWire(String type) {
    for (final event in NotificationEvent.values) {
      if (event.wireType == type) return event;
    }
    return null;
  }
}

@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const factory NotificationPreferences({
    @Default(true) bool enabled,
    @Default(<String>{}) Set<String> mutedEvents,
    @Default(true) bool quietHoursOff,
  }) = _NotificationPreferences;
}

extension NotificationPreferenceLookup on NotificationPreferences {
  bool isOn(NotificationEvent event) =>
      enabled && !mutedEvents.contains(event.name);
}

@freezed
abstract class AiConnection with _$AiConnection {
  const factory AiConnection({
    required String id,
    required String name,
    required String status,
    required List<String> scopes,
    required DateTime createdAt,
    required DateTime lastUsedAt,
    @Default(true) bool verified,
    @Default(0) int writeCount,
    @Default(0) int readCount,
  }) = _AiConnection;
}

@freezed
abstract class AiApproval with _$AiApproval {
  const factory AiApproval({
    required String id,
    required String client,
    required String summary,
    required String reason,
    required String impact,
    required String spaceId,
    required String fromUserId,
    required String toUserId,
    required int amountMinor,
    required String accountId,
    @Default('PENDING') String state,
  }) = _AiApproval;
}

@freezed
abstract class BudgetSnapshot with _$BudgetSnapshot {
  const factory BudgetSnapshot({
    required Budget budget,
    required int usedMinor,
    required int remainingMinor,
    required double progress,
    required BudgetHealth health,
    required BudgetWindow window,

    /// Carried in from the previous period when the budget rolls over.
    @Default(0) int rolloverMinor,

    /// Straight-line projection of where the period ends at the current pace.
    @Default(0) int forecastMinor,

    /// The same budget over the previous period, for comparison.
    int? previousUsedMinor,
  }) = _BudgetSnapshot;
}

@freezed
abstract class SharedSummary with _$SharedSummary {
  const factory SharedSummary({
    required int owedMinor,
    required int owingMinor,
    required String currency,
  }) = _SharedSummary;
}

@freezed
abstract class SpendingSummary with _$SpendingSummary {
  const factory SpendingSummary({
    required int spentMinor,
    required int outflowMinor,
    required int incomeMinor,
    required String currency,
  }) = _SpendingSummary;
}

/// A single point in a time series, used by every chart primitive.
@freezed
abstract class SeriesPoint with _$SeriesPoint {
  const factory SeriesPoint({
    required DateTime at,
    required int valueMinor,
    required String label,
  }) = _SeriesPoint;
}

/// One slice of a categorical breakdown.
@freezed
abstract class CategorySlice with _$CategorySlice {
  const factory CategorySlice({
    required String id,
    required String label,
    required int valueMinor,
    required int colorIndex,
    required String icon,
  }) = _CategorySlice;
}

/// A figure alongside the same figure last period.
@freezed
abstract class PeriodComparison with _$PeriodComparison {
  const factory PeriodComparison({
    required int currentMinor,
    required int previousMinor,
    required String currency,
    required String previousLabel,
  }) = _PeriodComparison;
}

extension PeriodComparisonReading on PeriodComparison {
  int get deltaMinor => currentMinor - previousMinor;

  /// Relative change, or null when the baseline is zero and a ratio would be
  /// meaningless rather than infinite.
  double? get ratio => previousMinor == 0
      ? null
      : (currentMinor - previousMinor) / previousMinor;

  /// Under a twentieth of the baseline reads as "about the same" — a number
  /// that moved by nothing is not news.
  bool get isFlat {
    if (previousMinor == 0) return currentMinor == 0;
    return (ratio!).abs() < .05;
  }

  bool get isUp => !isFlat && deltaMinor > 0;
  bool get isDown => !isFlat && deltaMinor < 0;
}

/// Who owes whom, resolved to the smallest set of payments.
@freezed
abstract class DebtEdge with _$DebtEdge {
  const factory DebtEdge({
    required String spaceId,
    required String fromUserId,
    required String toUserId,
    required int amountMinor,
    required String currency,
  }) = _DebtEdge;
}

/// One thing waiting on the user, ranked so Home can lead with the most urgent.
@freezed
abstract class ActionItem with _$ActionItem {
  const factory ActionItem({
    required String id,
    required ActionItemKind kind,
    required String title,
    required String detail,
    required String destination,

    /// Lower sorts first.
    required int priority,

    /// Money involved, when there is any. Kept as an amount rather than a
    /// formatted string so the UI can render it in the reader's format.
    int? amountMinor,
    String? currency,
  }) = _ActionItem;
}

enum ActionItemKind {
  invitation,
  settlementProposal,
  draftRecord,
  budgetBreach,
  aiApproval,
  subscriptionDue,
}

/// The health figures behind Home's progressive disclosure.
@freezed
abstract class FinancialHealth with _$FinancialHealth {
  const factory FinancialHealth({
    required int incomeMinor,
    required int outflowMinor,
    required int netMinor,
    required int disposableMinor,
    required int upcomingMinor,
    required String currency,
    required double savingsRate,
    @Default(<CategorySlice>[]) List<CategorySlice> unusual,
  }) = _FinancialHealth;
}

/// A named, re-applicable set of Activity filters.
@freezed
abstract class SavedView with _$SavedView {
  const factory SavedView({
    required String id,
    required String name,
    required Map<String, List<String>> selections,
    required String period,
    DateTime? from,
    DateTime? to,
    @Default('') String query,
    @Default('dateDesc') String sort,
  }) = _SavedView;
}

/// The outcome of a CSV import, shown before anything is written.
@freezed
abstract class ImportPreview with _$ImportPreview {
  const factory ImportPreview({
    required List<ImportRow> rows,
    required List<String> headers,
  }) = _ImportPreview;
}

enum ImportRowState { valid, invalid, duplicate }

@freezed
abstract class ImportRow with _$ImportRow {
  const factory ImportRow({
    required int lineNumber,
    required ImportRowState state,
    required String description,
    MoneyTransaction? transaction,
    String? problem,
  }) = _ImportRow;
}

/// Raised when a write is attempted against a record someone else has moved on.
class ConcurrentEditException implements Exception {
  const ConcurrentEditException({
    required this.entityLabel,
    required this.actorName,
    required this.expectedVersion,
    required this.actualVersion,
  });

  final String entityLabel;
  final String actorName;
  final int expectedVersion;
  final int actualVersion;

  @override
  String toString() =>
      'ConcurrentEditException($entityLabel, expected $expectedVersion, '
      'found $actualVersion)';
}

/// Raised when a write is attempted without the permission it needs.
class PermissionDeniedException implements Exception {
  const PermissionDeniedException({
    required this.action,
    required this.reason,
    this.whoCanHelp,
  });

  final String action;
  final String reason;

  /// Names of the people who could do it instead, when there are any.
  final List<String>? whoCanHelp;

  @override
  String toString() => 'PermissionDeniedException($action: $reason)';
}

/// Raised when a write is attempted while the prototype is in its offline
/// state. Writes are refused before submission, never half-applied.
class OfflineWriteException implements Exception {
  const OfflineWriteException(this.action);
  final String action;

  @override
  String toString() => 'OfflineWriteException($action)';
}
