import 'package:flutter/widgets.dart';

import '../../../app/pockito_app_view_model.dart';
import '../../../domain/models/financial_models.dart';
import '../../../domain/repositories/pockito_repository.dart';
import '../../../l10n/app_localizations.dart';

export '../../../l10n/app_localizations.dart';

extension PkStringsContext on BuildContext {
  /// The translated strings for the current locale.
  PkStrings get t => PkStrings.of(this);
}

/// Translated names for the domain's enums.
///
/// The enums themselves stay language-free — a role is a role whatever the
/// reader speaks — and every screen asks here for the words. The English
/// getters on the enums remain for logs, tests and wire values.
extension PkRoleStrings on SpaceRole {
  String labelIn(PkStrings t) => switch (this) {
    SpaceRole.owner => t.roleOwner,
    SpaceRole.admin => t.roleAdmin,
    SpaceRole.member => t.roleMember,
    SpaceRole.viewer => t.roleViewer,
  };

  String summaryIn(PkStrings t) => switch (this) {
    SpaceRole.owner => t.roleOwnerSummary,
    SpaceRole.admin => t.roleAdminSummary,
    SpaceRole.member => t.roleMemberSummary,
    SpaceRole.viewer => t.roleViewerSummary,
  };
}

extension PkMoneyEventTypeStrings on MoneyEventType {
  String labelIn(PkStrings t) => switch (this) {
    MoneyEventType.expense => t.eventTypeExpense,
    MoneyEventType.income => t.eventTypeIncome,
    MoneyEventType.transfer => t.eventTypeTransfer,
    MoneyEventType.settlement => t.eventTypeSettlement,
    MoneyEventType.adjustment => t.eventTypeAdjustment,
  };
}

extension PkAccountTypeStrings on AccountType {
  String labelIn(PkStrings t) => switch (this) {
    AccountType.bank => t.accountTypeBank,
    AccountType.card => t.accountTypeCard,
    AccountType.cash => t.accountTypeCash,
    AccountType.savings => t.accountTypeSavings,
    AccountType.digital => t.accountTypeDigital,
  };
}

extension PkSpaceTypeStrings on SpaceType {
  String labelIn(PkStrings t) => switch (this) {
    SpaceType.household => t.spaceTypeHousehold,
    SpaceType.trip => t.spaceTypeTrip,
    SpaceType.couple => t.spaceTypeCouple,
    SpaceType.friends => t.spaceTypeFriends,
    SpaceType.other => t.spaceTypeOther,
  };
}

extension PkSortStrings on PkSort {
  String labelIn(PkStrings t) => switch (this) {
    PkSort.dateDesc => t.sortNewestFirst,
    PkSort.dateAsc => t.sortOldestFirst,
    PkSort.amountDesc => t.sortLargestAmount,
    PkSort.amountAsc => t.sortSmallestAmount,
    PkSort.nameAsc => t.sortNameAsc,
    PkSort.nameDesc => t.sortNameDesc,
    PkSort.balanceDesc => t.sortHighestBalance,
    PkSort.balanceAsc => t.sortLowestBalance,
  };
}

extension PkActivityPeriodStrings on ActivityPeriod {
  String labelIn(PkStrings t) => switch (this) {
    ActivityPeriod.all => t.periodAnyTime,
    ActivityPeriod.thisMonth => t.periodThisMonth,
    ActivityPeriod.previousMonth => t.periodLastMonth,
    ActivityPeriod.custom => t.periodCustom,
  };
}

extension FxProviderLabel on FxProvider {
  String labelIn(PkStrings t) => switch (this) {
    FxProvider.prototypeSnapshot => t.prototypeMarketSnapshot,
    FxProvider.manualConfiguration => t.manualConfiguration,
    FxProvider.manualRate => t.fxManualRate,
  };
}

extension BudgetPeriodNoun on BudgetPeriod {
  /// The noun that completes a sentence like "by the end of the …".
  String nounIn(PkStrings t) => switch (this) {
    BudgetPeriod.weekly => t.periodNounWeek,
    BudgetPeriod.monthly => t.periodNounMonth,
    BudgetPeriod.quarterly => t.periodNounQuarter,
    BudgetPeriod.yearly => t.periodNounYear,
    BudgetPeriod.custom => t.periodNounPeriod,
  };
}
