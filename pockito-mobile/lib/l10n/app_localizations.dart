import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of PkStrings
/// returned by `PkStrings.of(context)`.
///
/// Applications need to include `PkStrings.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: PkStrings.localizationsDelegates,
///   supportedLocales: PkStrings.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the PkStrings.supportedLocales
/// property.
abstract class PkStrings {
  PkStrings(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static PkStrings of(BuildContext context) {
    return Localizations.of<PkStrings>(context, PkStrings)!;
  }

  static const LocalizationsDelegate<PkStrings> delegate = _PkStringsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navSpaces.
  ///
  /// In en, this message translates to:
  /// **'Spaces'**
  String get navSpaces;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @addMoneyEvent.
  ///
  /// In en, this message translates to:
  /// **'Add money event'**
  String get addMoneyEvent;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get actionUndo;

  /// No description provided for @actionClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get actionClearSearch;

  /// No description provided for @actionResetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get actionResetAll;

  /// No description provided for @actionSaveView.
  ///
  /// In en, this message translates to:
  /// **'Save view'**
  String get actionSaveView;

  /// No description provided for @actionGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get actionGotIt;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @sortNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewestFirst;

  /// No description provided for @sortOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldestFirst;

  /// No description provided for @sortLargestAmount.
  ///
  /// In en, this message translates to:
  /// **'Largest amount'**
  String get sortLargestAmount;

  /// No description provided for @sortSmallestAmount.
  ///
  /// In en, this message translates to:
  /// **'Smallest amount'**
  String get sortSmallestAmount;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get sortNameDesc;

  /// No description provided for @sortHighestBalance.
  ///
  /// In en, this message translates to:
  /// **'Highest balance'**
  String get sortHighestBalance;

  /// No description provided for @sortLowestBalance.
  ///
  /// In en, this message translates to:
  /// **'Lowest balance'**
  String get sortLowestBalance;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @roleOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get roleOwner;

  /// No description provided for @roleAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get roleMember;

  /// No description provided for @roleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get roleViewer;

  /// No description provided for @roleOwnerSummary.
  ///
  /// In en, this message translates to:
  /// **'Full control, including roles and archiving. There is always one owner.'**
  String get roleOwnerSummary;

  /// No description provided for @roleAdminSummary.
  ///
  /// In en, this message translates to:
  /// **'Can edit anyone’s expenses, manage budgets, invite and remove members.'**
  String get roleAdminSummary;

  /// No description provided for @roleMemberSummary.
  ///
  /// In en, this message translates to:
  /// **'Can add expenses, edit their own, and settle up.'**
  String get roleMemberSummary;

  /// No description provided for @roleViewerSummary.
  ///
  /// In en, this message translates to:
  /// **'Can see everything and change nothing.'**
  String get roleViewerSummary;

  /// No description provided for @spaceTypeHousehold.
  ///
  /// In en, this message translates to:
  /// **'Household'**
  String get spaceTypeHousehold;

  /// No description provided for @spaceTypeTrip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get spaceTypeTrip;

  /// No description provided for @spaceTypeCouple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get spaceTypeCouple;

  /// No description provided for @spaceTypeFriends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get spaceTypeFriends;

  /// No description provided for @spaceTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get spaceTypeOther;

  /// No description provided for @readOnlyViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'You have view-only access'**
  String get readOnlyViewerTitle;

  /// No description provided for @readOnlyViewerReason.
  ///
  /// In en, this message translates to:
  /// **'Viewers can see everything here and change nothing.'**
  String get readOnlyViewerReason;

  /// No description provided for @readOnlyArchivedTitle.
  ///
  /// In en, this message translates to:
  /// **'{space} is archived'**
  String readOnlyArchivedTitle(String space);

  /// No description provided for @readOnlyArchivedReason.
  ///
  /// In en, this message translates to:
  /// **'Archived Spaces keep their history and accept no new writes. Reopen it to add or change anything.'**
  String get readOnlyArchivedReason;

  /// No description provided for @actionReopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get actionReopen;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re offline, so we didn’t {action}'**
  String offlineTitle(String action);

  /// No description provided for @offlineBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing was half-saved — the change was stopped before it started. What you typed is still here; try again when you have a connection.'**
  String get offlineBody;

  /// No description provided for @offlineNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get offlineNotNow;

  /// No description provided for @deniedWhoCanHelpOne.
  ///
  /// In en, this message translates to:
  /// **'Ask {name} to do it.'**
  String deniedWhoCanHelpOne(String name);

  /// No description provided for @deniedWhoCanHelpMany.
  ///
  /// In en, this message translates to:
  /// **'Ask one of {names}.'**
  String deniedWhoCanHelpMany(String names);

  /// No description provided for @deniedDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'You can’t do that here'**
  String get deniedDefaultTitle;

  /// No description provided for @conflictTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} changed this while you were editing'**
  String conflictTitle(String name);

  /// No description provided for @conflictBody.
  ///
  /// In en, this message translates to:
  /// **'Two versions of “{label}” exist. Nothing has been overwritten — pick which one wins.'**
  String conflictBody(String label);

  /// No description provided for @conflictKeepTheirs.
  ///
  /// In en, this message translates to:
  /// **'Keep {name}’s version'**
  String conflictKeepTheirs(String name);

  /// No description provided for @conflictKeepTheirsDetail.
  ///
  /// In en, this message translates to:
  /// **'Your edits are discarded and the form reloads.'**
  String get conflictKeepTheirsDetail;

  /// No description provided for @conflictKeepMine.
  ///
  /// In en, this message translates to:
  /// **'Keep mine'**
  String get conflictKeepMine;

  /// No description provided for @conflictKeepMineDetail.
  ///
  /// In en, this message translates to:
  /// **'Your version replaces theirs. The change stays in the activity log either way.'**
  String get conflictKeepMineDetail;

  /// No description provided for @conflictCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare them first'**
  String get conflictCompare;

  /// No description provided for @conflictCompareDetail.
  ///
  /// In en, this message translates to:
  /// **'Reload theirs alongside yours and decide field by field.'**
  String get conflictCompareDetail;

  /// No description provided for @recordVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get recordVoided;

  /// No description provided for @recordDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get recordDraft;

  /// No description provided for @recordDraftBanner.
  ///
  /// In en, this message translates to:
  /// **'Draft — not counted yet'**
  String get recordDraftBanner;

  /// No description provided for @recordDraftBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing about your balances or budgets has moved. Confirm it when you are sure it is right.'**
  String get recordDraftBody;

  /// No description provided for @recordVoidedBody.
  ///
  /// In en, this message translates to:
  /// **'It stays in your history and counts towards nothing.'**
  String get recordVoidedBody;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get actionRestore;

  /// No description provided for @actionVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get actionVoid;

  /// No description provided for @chartViewAsTable.
  ///
  /// In en, this message translates to:
  /// **'View as a table'**
  String get chartViewAsTable;

  /// No description provided for @chartNotEnoughHistory.
  ///
  /// In en, this message translates to:
  /// **'Not enough history yet to draw a trend.'**
  String get chartNotEnoughHistory;

  /// No description provided for @chartNothingRecorded.
  ///
  /// In en, this message translates to:
  /// **'Nothing has been recorded this period, so there is nothing to break down yet.'**
  String get chartNothingRecorded;

  /// No description provided for @chartEverythingElse.
  ///
  /// In en, this message translates to:
  /// **'Everything else'**
  String get chartEverythingElse;

  /// No description provided for @comparisonFlat.
  ///
  /// In en, this message translates to:
  /// **'About the same as {period}'**
  String comparisonFlat(String period);

  /// No description provided for @comparisonMore.
  ///
  /// In en, this message translates to:
  /// **'{percent}% more than {period}'**
  String comparisonMore(int percent, String period);

  /// No description provided for @comparisonLess.
  ///
  /// In en, this message translates to:
  /// **'{percent}% less than {period}'**
  String comparisonLess(int percent, String period);

  /// No description provided for @homeSpent.
  ///
  /// In en, this message translates to:
  /// **'SPENT'**
  String get homeSpent;

  /// No description provided for @homeIn.
  ///
  /// In en, this message translates to:
  /// **'IN'**
  String get homeIn;

  /// No description provided for @homeNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Net worth'**
  String get homeNetWorth;

  /// No description provided for @homeThingsNeedYou.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 thing needs you} other{{count} things need you}}'**
  String homeThingsNeedYou(int count);

  /// No description provided for @homeAndMore.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String homeAndMore(int count);

  /// No description provided for @homeWhoOwesWhom.
  ///
  /// In en, this message translates to:
  /// **'Who owes whom'**
  String get homeWhoOwesWhom;

  /// No description provided for @homeEveryoneSettled.
  ///
  /// In en, this message translates to:
  /// **'Everyone is settled across your Spaces.'**
  String get homeEveryoneSettled;

  /// No description provided for @homeNoSpacesYet.
  ///
  /// In en, this message translates to:
  /// **'No shared Spaces yet. Create one when you start splitting something.'**
  String get homeNoSpacesYet;

  /// No description provided for @homeSpendingTrend.
  ///
  /// In en, this message translates to:
  /// **'Spending trend'**
  String get homeSpendingTrend;

  /// No description provided for @homeWhereItWent.
  ///
  /// In en, this message translates to:
  /// **'Where it went'**
  String get homeWhereItWent;

  /// No description provided for @homeThisMonthInFull.
  ///
  /// In en, this message translates to:
  /// **'This month in full'**
  String get homeThisMonthInFull;

  /// No description provided for @homeAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get homeAccounts;

  /// No description provided for @homeBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get homeBudgets;

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get homeUpcoming;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeViewActivity.
  ///
  /// In en, this message translates to:
  /// **'View activity'**
  String get homeViewActivity;

  /// No description provided for @homeYouOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe {name}'**
  String homeYouOwe(String name);

  /// No description provided for @homeOwesYou.
  ///
  /// In en, this message translates to:
  /// **'{name} owes you'**
  String homeOwesYou(String name);

  /// No description provided for @homeYouKept.
  ///
  /// In en, this message translates to:
  /// **'You kept {amount} this month'**
  String homeYouKept(String amount);

  /// No description provided for @homeYouOverspent.
  ///
  /// In en, this message translates to:
  /// **'You spent {amount} more than came in'**
  String homeYouOverspent(String amount);

  /// No description provided for @homeStillFree.
  ///
  /// In en, this message translates to:
  /// **'{amount} still free after what is already committed'**
  String homeStillFree(String amount);

  /// No description provided for @homeMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get homeMoneyIn;

  /// No description provided for @homeMoneyOut.
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get homeMoneyOut;

  /// No description provided for @homeKept.
  ///
  /// In en, this message translates to:
  /// **'Kept'**
  String get homeKept;

  /// No description provided for @homeKeptDetail.
  ///
  /// In en, this message translates to:
  /// **'of what came in'**
  String get homeKeptDetail;

  /// No description provided for @homeStillDue.
  ///
  /// In en, this message translates to:
  /// **'Still due'**
  String get homeStillDue;

  /// No description provided for @homeStillDueDetail.
  ///
  /// In en, this message translates to:
  /// **'subscriptions left this month'**
  String get homeStillDueDetail;

  /// No description provided for @searchTitle.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTitle;

  /// No description provided for @searchHintGlobal.
  ///
  /// In en, this message translates to:
  /// **'Accounts, Spaces, categories, budgets, activity…'**
  String get searchHintGlobal;

  /// No description provided for @searchEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Search everything'**
  String get searchEmptyTitle;

  /// No description provided for @searchEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Type at least two letters. This looks across accounts, Spaces, categories, budgets, recurring items and your whole activity.'**
  String get searchEmptyBody;

  /// No description provided for @searchNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{query}”'**
  String searchNoMatchTitle(String query);

  /// No description provided for @searchNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try fewer letters, or a merchant, note or member name.'**
  String get searchNoMatchBody;

  /// No description provided for @searchKindAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get searchKindAccount;

  /// No description provided for @searchKindSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get searchKindSpace;

  /// No description provided for @searchKindCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get searchKindCategory;

  /// No description provided for @searchKindRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get searchKindRecurring;

  /// No description provided for @searchKindBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get searchKindBudget;

  /// No description provided for @searchKindActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get searchKindActivity;

  /// No description provided for @activityTitle.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activityTitle;

  /// No description provided for @activityCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 money event} other{{count} money events}}'**
  String activityCount(int count);

  /// No description provided for @activitySearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search merchant, note, category, tag or account'**
  String get activitySearchHint;

  /// No description provided for @activityFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get activityFilters;

  /// No description provided for @activityShowMore.
  ///
  /// In en, this message translates to:
  /// **'Show more · {count} left'**
  String activityShowMore(int count);

  /// No description provided for @activityNoneTitle.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get activityNoneTitle;

  /// No description provided for @activityNoneBody.
  ///
  /// In en, this message translates to:
  /// **'Record an expense, income or transfer to start your timeline.'**
  String get activityNoneBody;

  /// No description provided for @activityNoMatchTitle.
  ///
  /// In en, this message translates to:
  /// **'No matching money events'**
  String get activityNoMatchTitle;

  /// No description provided for @activityNoMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Try another phrase or clear the active filters.'**
  String get activityNoMatchBody;

  /// No description provided for @activitySavedViews.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String activitySavedViews(int count);

  /// No description provided for @periodAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Any time'**
  String get periodAnyTime;

  /// No description provided for @periodThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get periodThisMonth;

  /// No description provided for @periodLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month'**
  String get periodLastMonth;

  /// No description provided for @periodCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom range'**
  String get periodCustom;

  /// No description provided for @fxConvertedTo.
  ///
  /// In en, this message translates to:
  /// **'Converted to {currency}'**
  String fxConvertedTo(String currency);

  /// No description provided for @fxRateLine.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {rate} {to} · {source} · {date}'**
  String fxRateLine(
    String from,
    String rate,
    String to,
    String source,
    String date,
  );

  /// No description provided for @fxRateHistory.
  ///
  /// In en, this message translates to:
  /// **'Rate history'**
  String get fxRateHistory;

  /// No description provided for @fxManualRate.
  ///
  /// In en, this message translates to:
  /// **'your manual rate'**
  String get fxManualRate;

  /// No description provided for @fxNetWorthNote.
  ///
  /// In en, this message translates to:
  /// **'Converted to {currency}. Every rate used is listed below, with the day it was captured.'**
  String fxNetWorthNote(String currency);

  /// No description provided for @fxMissingTitle.
  ///
  /// In en, this message translates to:
  /// **'Some balances are not in this total'**
  String get fxMissingTitle;

  /// No description provided for @fxMissingBody.
  ///
  /// In en, this message translates to:
  /// **'There is no rate for {currencies}, so those balances are shown on their own rather than folded into a number that would be a guess.'**
  String fxMissingBody(String currencies);

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Getting set up'**
  String get setupTitle;

  /// No description provided for @setupProgress.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total}'**
  String setupProgress(int done, int total);

  /// No description provided for @setupHide.
  ///
  /// In en, this message translates to:
  /// **'Hide this'**
  String get setupHide;

  /// No description provided for @setupStepProfile.
  ///
  /// In en, this message translates to:
  /// **'Add your name and reporting currency'**
  String get setupStepProfile;

  /// No description provided for @setupStepAccount.
  ///
  /// In en, this message translates to:
  /// **'Add your first account'**
  String get setupStepAccount;

  /// No description provided for @setupStepTransaction.
  ///
  /// In en, this message translates to:
  /// **'Record something you spent'**
  String get setupStepTransaction;

  /// No description provided for @setupStepSpace.
  ///
  /// In en, this message translates to:
  /// **'Create a Space for shared money'**
  String get setupStepSpace;

  /// No description provided for @setupStepBudget.
  ///
  /// In en, this message translates to:
  /// **'Set a budget you care about'**
  String get setupStepBudget;

  /// No description provided for @quickScanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan a receipt'**
  String get quickScanReceipt;

  /// No description provided for @quickSharedExpense.
  ///
  /// In en, this message translates to:
  /// **'Shared expense'**
  String get quickSharedExpense;

  /// No description provided for @quickSettleUp.
  ///
  /// In en, this message translates to:
  /// **'Settle up'**
  String get quickSettleUp;

  /// No description provided for @quickRecordIncome.
  ///
  /// In en, this message translates to:
  /// **'Record income'**
  String get quickRecordIncome;

  /// No description provided for @quickNewBudget.
  ///
  /// In en, this message translates to:
  /// **'New budget'**
  String get quickNewBudget;

  /// No description provided for @saveBlockedOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline — try again in a moment'**
  String get saveBlockedOffline;

  /// No description provided for @saveBlockedPermission.
  ///
  /// In en, this message translates to:
  /// **'You can’t add expenses here'**
  String get saveBlockedPermission;

  /// No description provided for @notifAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String notifAll(int count);

  /// No description provided for @notifWaitingCount.
  ///
  /// In en, this message translates to:
  /// **'Waiting on you ({count})'**
  String notifWaitingCount(int count);

  /// No description provided for @notifUpdatesCount.
  ///
  /// In en, this message translates to:
  /// **'Updates ({count})'**
  String notifUpdatesCount(int count);

  /// No description provided for @notifWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting on you'**
  String get notifWaiting;

  /// No description provided for @notifUpdates.
  ///
  /// In en, this message translates to:
  /// **'Updates'**
  String get notifUpdates;

  /// No description provided for @notifNothingWaiting.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting on you'**
  String get notifNothingWaiting;

  /// No description provided for @notifNoUpdates.
  ///
  /// In en, this message translates to:
  /// **'No updates'**
  String get notifNoUpdates;

  /// No description provided for @notifSwitchFilter.
  ///
  /// In en, this message translates to:
  /// **'Switch the filter to see everything else.'**
  String get notifSwitchFilter;

  /// No description provided for @notifShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get notifShowAll;

  /// No description provided for @notifMasterSwitch.
  ///
  /// In en, this message translates to:
  /// **'The master switch for everything below'**
  String get notifMasterSwitch;

  /// No description provided for @notifMarkAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get notifMarkAllRead;

  /// No description provided for @notifDismissed.
  ///
  /// In en, this message translates to:
  /// **'Notification dismissed'**
  String get notifDismissed;

  /// No description provided for @aiSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about your money'**
  String get aiSectionTitle;

  /// No description provided for @aiExplainMonth.
  ///
  /// In en, this message translates to:
  /// **'Explain this month'**
  String get aiExplainMonth;

  /// No description provided for @aiExplainMonthDetail.
  ///
  /// In en, this message translates to:
  /// **'What moved, and what is behind it'**
  String get aiExplainMonthDetail;

  /// No description provided for @aiCompareMonths.
  ///
  /// In en, this message translates to:
  /// **'Compare two months'**
  String get aiCompareMonths;

  /// No description provided for @aiCompareMonthsDetail.
  ///
  /// In en, this message translates to:
  /// **'Category by category, largest change first'**
  String get aiCompareMonthsDetail;

  /// No description provided for @aiFlagUnusual.
  ///
  /// In en, this message translates to:
  /// **'Flag anything unusual'**
  String get aiFlagUnusual;

  /// No description provided for @aiFlagUnusualDetail.
  ///
  /// In en, this message translates to:
  /// **'Against each category’s own recent average'**
  String get aiFlagUnusualDetail;

  /// No description provided for @aiAnswerFootnote.
  ///
  /// In en, this message translates to:
  /// **'Read from your own records — nothing was generated.'**
  String get aiAnswerFootnote;

  /// No description provided for @aiThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get aiThisMonth;

  /// No description provided for @aiAgainstLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Against last month'**
  String get aiAgainstLastMonth;

  /// No description provided for @aiAnythingUnusual.
  ///
  /// In en, this message translates to:
  /// **'Anything unusual'**
  String get aiAnythingUnusual;

  /// No description provided for @aiSpentVs.
  ///
  /// In en, this message translates to:
  /// **'You spent {amount}, {direction} {period} ({previous}).'**
  String aiSpentVs(
    String amount,
    String direction,
    String period,
    String previous,
  );

  /// No description provided for @aiDirectionSame.
  ///
  /// In en, this message translates to:
  /// **'about the same as'**
  String get aiDirectionSame;

  /// No description provided for @aiDirectionMore.
  ///
  /// In en, this message translates to:
  /// **'more than'**
  String get aiDirectionMore;

  /// No description provided for @aiDirectionLess.
  ///
  /// In en, this message translates to:
  /// **'less than'**
  String get aiDirectionLess;

  /// No description provided for @aiBiggestShare.
  ///
  /// In en, this message translates to:
  /// **'The biggest share went on {category}: {amount}.'**
  String aiBiggestShare(String category, String amount);

  /// No description provided for @aiKept.
  ///
  /// In en, this message translates to:
  /// **'You kept {kept} of the {income} that came in.'**
  String aiKept(String kept, String income);

  /// No description provided for @aiOverspent.
  ///
  /// In en, this message translates to:
  /// **'You spent {amount} more than came in.'**
  String aiOverspent(String amount);

  /// No description provided for @aiStillDue.
  ///
  /// In en, this message translates to:
  /// **'{amount} of subscriptions is still due before the month ends.'**
  String aiStillDue(String amount);

  /// No description provided for @aiDeltaUp.
  ///
  /// In en, this message translates to:
  /// **'{category}: up {amount}'**
  String aiDeltaUp(String category, String amount);

  /// No description provided for @aiDeltaDown.
  ///
  /// In en, this message translates to:
  /// **'{category}: down {amount}'**
  String aiDeltaDown(String category, String amount);

  /// No description provided for @aiNothingToCompare.
  ///
  /// In en, this message translates to:
  /// **'There is nothing in either month to compare.'**
  String get aiNothingToCompare;

  /// No description provided for @aiNothingUnusual.
  ///
  /// In en, this message translates to:
  /// **'Nothing is far from its own recent average. That is not the same as nothing being expensive — only that nothing is out of character.'**
  String get aiNothingUnusual;

  /// No description provided for @aiUnusualLine.
  ///
  /// In en, this message translates to:
  /// **'{category} is well above its own average for the last three months, at {amount}.'**
  String aiUnusualLine(String category, String amount);

  /// No description provided for @spaceMemberCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String spaceMemberCount(int count);

  /// No description provided for @spaceManagePeople.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get spaceManagePeople;

  /// No description provided for @spaceFullActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Full activity log'**
  String get spaceFullActivityLog;

  /// No description provided for @currencyNoRate.
  ///
  /// In en, this message translates to:
  /// **'No conversion rate available'**
  String get currencyNoRate;

  /// No description provided for @currencyAvailable.
  ///
  /// In en, this message translates to:
  /// **'{count} currencies available'**
  String currencyAvailable(int count);

  /// No description provided for @hapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get hapticsTitle;

  /// No description provided for @hapticsDetail.
  ///
  /// In en, this message translates to:
  /// **'A short tap on selection, saving and destructive confirms'**
  String get hapticsDetail;

  /// No description provided for @widgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget'**
  String get widgetTitle;

  /// No description provided for @widgetRefresh.
  ///
  /// In en, this message translates to:
  /// **'Send to the home screen'**
  String get widgetRefresh;

  /// No description provided for @widgetPushed.
  ///
  /// In en, this message translates to:
  /// **'Home screen widget updated'**
  String get widgetPushed;

  /// No description provided for @widgetIntro.
  ///
  /// In en, this message translates to:
  /// **'This is exactly what the widget shows, drawn from the same figures as the app. Tapping it anywhere opens Pockito.'**
  String get widgetIntro;

  /// No description provided for @widgetSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small · net worth only'**
  String get widgetSizeSmall;

  /// No description provided for @widgetSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium · net worth and this month'**
  String get widgetSizeMedium;

  /// No description provided for @widgetSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large · adds who owes whom'**
  String get widgetSizeLarge;

  /// No description provided for @widgetTapOpens.
  ///
  /// In en, this message translates to:
  /// **'Tapping the widget opens Home'**
  String get widgetTapOpens;

  /// No description provided for @weCouldnTFindThat.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t find that screen'**
  String get weCouldnTFindThat;

  /// No description provided for @nothingOpensAtYourMoney.
  ///
  /// In en, this message translates to:
  /// **'Nothing opens at {p0}. Your money and data are untouched.'**
  String nothingOpensAtYourMoney(Object p0);

  /// No description provided for @goToHome.
  ///
  /// In en, this message translates to:
  /// **'Go to Home'**
  String get goToHome;

  /// No description provided for @closeToTheLimit.
  ///
  /// In en, this message translates to:
  /// **'Close to the limit'**
  String get closeToTheLimit;

  /// No description provided for @atThisPaceYouFinish.
  ///
  /// In en, this message translates to:
  /// **'At this pace you finish the {p0} {p1} over.'**
  String atThisPaceYouFinish(Object p0, Object p1);

  /// No description provided for @atThisPaceYouFinish2.
  ///
  /// In en, this message translates to:
  /// **'At this pace you finish the {p0} at {p1}.'**
  String atThisPaceYouFinish2(Object p0, Object p1);

  /// No description provided for @includesCarriedOverFromLast.
  ///
  /// In en, this message translates to:
  /// **'Includes {p0} carried over from last {p1}.'**
  String includesCarriedOverFromLast(Object p0, Object p1);

  /// No description provided for @pockitoAppIconFeaturingKito.
  ///
  /// In en, this message translates to:
  /// **'Pockito app icon featuring Kito'**
  String get pockitoAppIconFeaturingKito;

  /// No description provided for @percentOfUsed.
  ///
  /// In en, this message translates to:
  /// **'{p0} percent of {p1} used'**
  String percentOfUsed(Object p0, Object p1);

  /// No description provided for @offlineChangesStayOnThis.
  ///
  /// In en, this message translates to:
  /// **'Offline · changes stay on this device'**
  String get offlineChangesStayOnThis;

  /// No description provided for @stayInTheLoop.
  ///
  /// In en, this message translates to:
  /// **'Stay in the loop'**
  String get stayInTheLoop;

  /// No description provided for @getNotifiedWhenSomeoneAdds.
  ///
  /// In en, this message translates to:
  /// **'Get notified when someone adds a shared expense, pays you back, or when a budget needs attention.'**
  String get getNotifiedWhenSomeoneAdds;

  /// No description provided for @miraAddedGroceries.
  ///
  /// In en, this message translates to:
  /// **'Mira added Groceries · €84.00'**
  String get miraAddedGroceries;

  /// No description provided for @miraSaysShePaidYou.
  ///
  /// In en, this message translates to:
  /// **'Mira says she paid you ¥5,000'**
  String get miraSaysShePaidYou;

  /// No description provided for @youVeUsedOfGroceries.
  ///
  /// In en, this message translates to:
  /// **'You’ve used 80% of Groceries'**
  String get youVeUsedOfGroceries;

  /// No description provided for @turnOnNotifications.
  ///
  /// In en, this message translates to:
  /// **'Turn on notifications'**
  String get turnOnNotifications;

  /// No description provided for @prototypeOnlyNoSystemPermission.
  ///
  /// In en, this message translates to:
  /// **'Prototype only · no system permission is requested'**
  String get prototypeOnlyNoSystemPermission;

  /// No description provided for @pickWhatHappenedYouCan.
  ///
  /// In en, this message translates to:
  /// **'Pick what happened. You can change any detail before saving.'**
  String get pickWhatHappenedYouCan;

  /// No description provided for @readAReceipt.
  ///
  /// In en, this message translates to:
  /// **'Read a receipt'**
  String get readAReceipt;

  /// No description provided for @pickADate.
  ///
  /// In en, this message translates to:
  /// **'Pick a date'**
  String get pickADate;

  /// No description provided for @chooseAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Choose an account'**
  String get chooseAnAccount;

  /// No description provided for @outsidePockitoNoWalletMovement.
  ///
  /// In en, this message translates to:
  /// **'Outside Pockito · no wallet movement'**
  String get outsidePockitoNoWalletMovement;

  /// No description provided for @chooseACategory.
  ///
  /// In en, this message translates to:
  /// **'Choose a category'**
  String get chooseACategory;

  /// No description provided for @chooseACurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose a currency'**
  String get chooseACurrency;

  /// No description provided for @noDecimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'{p0} · no decimal places'**
  String noDecimalPlaces(Object p0);

  /// No description provided for @decimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'{p0} · {p1} decimal places'**
  String decimalPlaces(Object p0, Object p1);

  /// No description provided for @chooseAMember.
  ///
  /// In en, this message translates to:
  /// **'Choose a member'**
  String get chooseAMember;

  /// No description provided for @eGBerlinTrip.
  ///
  /// In en, this message translates to:
  /// **'e.g. Berlin trip'**
  String get eGBerlinTrip;

  /// No description provided for @noReceiptKeptScanningOne.
  ///
  /// In en, this message translates to:
  /// **'No receipt kept. Scanning one keeps the capture, so you can check the charge months later.'**
  String get noReceiptKeptScanningOne;

  /// No description provided for @connectedToThis.
  ///
  /// In en, this message translates to:
  /// **'Connected to this'**
  String get connectedToThis;

  /// No description provided for @canDoThis.
  ///
  /// In en, this message translates to:
  /// **'{p0} can do this.'**
  String canDoThis(Object p0);

  /// No description provided for @keepItAsItIs.
  ///
  /// In en, this message translates to:
  /// **'Keep it as it is'**
  String get keepItAsItIs;

  /// No description provided for @typeToContinue.
  ///
  /// In en, this message translates to:
  /// **'Type “{p0}” to continue.'**
  String typeToContinue(Object p0);

  /// No description provided for @thatDidnTWork.
  ///
  /// In en, this message translates to:
  /// **'That didn’t work'**
  String get thatDidnTWork;

  /// No description provided for @thatDidnTLoad.
  ///
  /// In en, this message translates to:
  /// **'That didn’t load'**
  String get thatDidnTLoad;

  /// No description provided for @theListIsStillOn.
  ///
  /// In en, this message translates to:
  /// **'The list is still on your device — this was a problem reading it.'**
  String get theListIsStillOn;

  /// No description provided for @yourSpendingIsSteadyShared.
  ///
  /// In en, this message translates to:
  /// **'Your spending is steady. Shared costs and transfers are already separated from personal spending.'**
  String get yourSpendingIsSteadyShared;

  /// No description provided for @isOverItsLimitYour.
  ///
  /// In en, this message translates to:
  /// **'{p0} is over its limit. Your other balances are unchanged.'**
  String isOverItsLimitYour(Object p0);

  /// No description provided for @isGettingCloseToIts.
  ///
  /// In en, this message translates to:
  /// **'{p0} is getting close to its limit. A quick review now can keep the month comfortable.'**
  String isGettingCloseToIts(Object p0);

  /// No description provided for @weCouldNotRefreshYour.
  ///
  /// In en, this message translates to:
  /// **'We could not refresh your overview'**
  String get weCouldNotRefreshYour;

  /// No description provided for @yourLocalDataIsSafe.
  ///
  /// In en, this message translates to:
  /// **'Your local data is safe. Try loading it again.'**
  String get yourLocalDataIsSafe;

  /// No description provided for @markedAsPaid.
  ///
  /// In en, this message translates to:
  /// **'{p0} marked as paid'**
  String markedAsPaid(Object p0);

  /// No description provided for @yourMoneyFinallyInOne.
  ///
  /// In en, this message translates to:
  /// **'Your money, finally in one place.'**
  String get yourMoneyFinallyInOne;

  /// No description provided for @addAnAccountToTrack.
  ///
  /// In en, this message translates to:
  /// **'Add an account to track your own money, or start a space to share expenses with people you trust.'**
  String get addAnAccountToTrack;

  /// No description provided for @chooseWhereToBegin.
  ///
  /// In en, this message translates to:
  /// **'Choose where to begin'**
  String get chooseWhereToBegin;

  /// No description provided for @seeBalancesActivityAndNet.
  ///
  /// In en, this message translates to:
  /// **'See balances, activity and net worth together.'**
  String get seeBalancesActivityAndNet;

  /// No description provided for @createASharedSpace.
  ///
  /// In en, this message translates to:
  /// **'Create a shared space'**
  String get createASharedSpace;

  /// No description provided for @splitAHomeTripOr.
  ///
  /// In en, this message translates to:
  /// **'Split a home, trip or project without guesswork.'**
  String get splitAHomeTripOr;

  /// No description provided for @exploreWithSampleData.
  ///
  /// In en, this message translates to:
  /// **'Explore with sample data'**
  String get exploreWithSampleData;

  /// No description provided for @acrossAccounts.
  ///
  /// In en, this message translates to:
  /// **'Across {p0} accounts · {p1}'**
  String acrossAccounts(Object p0, Object p1);

  /// No description provided for @nothingLeftYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'Nothing left your accounts'**
  String get nothingLeftYourAccounts;

  /// No description provided for @ofThatLeftYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'{p0}% of {p1} that left your accounts'**
  String ofThatLeftYourAccounts(Object p0, Object p1);

  /// No description provided for @nothingCameInThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Nothing came in this month'**
  String get nothingCameInThisMonth;

  /// No description provided for @noDueDate.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get noDueDate;

  /// No description provided for @dueInDays.
  ///
  /// In en, this message translates to:
  /// **'Due in {p0} days'**
  String dueInDays(Object p0);

  /// No description provided for @thingsNeedYou.
  ///
  /// In en, this message translates to:
  /// **'{p0} things need you'**
  String thingsNeedYou(Object p0);

  /// No description provided for @isWellAboveItsRecent.
  ///
  /// In en, this message translates to:
  /// **'{p0} is well above its recent average at {p1}.'**
  String isWellAboveItsRecent(Object p0, Object p1);

  /// No description provided for @showMoreLeft.
  ///
  /// In en, this message translates to:
  /// **'Show more · {p0} left'**
  String showMoreLeft(Object p0);

  /// No description provided for @nameThisView.
  ///
  /// In en, this message translates to:
  /// **'Name this view'**
  String get nameThisView;

  /// No description provided for @eGReimbursableWorkTravel.
  ///
  /// In en, this message translates to:
  /// **'e.g. Reimbursable work travel'**
  String get eGReimbursableWorkTravel;

  /// No description provided for @filterCombinationsYouBuiltOnce.
  ///
  /// In en, this message translates to:
  /// **'Filter combinations you built once.'**
  String get filterCombinationsYouBuiltOnce;

  /// No description provided for @moneyEventNotFound.
  ///
  /// In en, this message translates to:
  /// **'Money event not found'**
  String get moneyEventNotFound;

  /// No description provided for @thisItemHasBeenRemoved.
  ///
  /// In en, this message translates to:
  /// **'This item has been removed from your local prototype.'**
  String get thisItemHasBeenRemoved;

  /// No description provided for @confirmedItCountsFromNow.
  ///
  /// In en, this message translates to:
  /// **'Confirmed — it counts from now on'**
  String get confirmedItCountsFromNow;

  /// No description provided for @voidThisMoneyEvent.
  ///
  /// In en, this message translates to:
  /// **'Void this money event?'**
  String get voidThisMoneyEvent;

  /// No description provided for @itStaysInYourHistory2.
  ///
  /// In en, this message translates to:
  /// **'It stays in your history, struck through, and stops counting towards balances and budgets.'**
  String get itStaysInYourHistory2;

  /// No description provided for @theLinkedSharedExpenseIs.
  ///
  /// In en, this message translates to:
  /// **'The linked shared expense is voided too, and everyone’s balances update. Both rows stay visible in the history.'**
  String get theLinkedSharedExpenseIs;

  /// No description provided for @editMoneyEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit money event'**
  String get editMoneyEvent;

  /// No description provided for @youCanFillThisIn.
  ///
  /// In en, this message translates to:
  /// **'You can fill this in, but saving is blocked until there is a connection — nothing gets half-written.'**
  String get youCanFillThisIn;

  /// No description provided for @youCanTAddExpenses.
  ///
  /// In en, this message translates to:
  /// **'You can’t add expenses to {p0}'**
  String youCanTAddExpenses(Object p0);

  /// No description provided for @viewersCanSeeEverythingAnd.
  ///
  /// In en, this message translates to:
  /// **'Viewers can see everything and change nothing.'**
  String get viewersCanSeeEverythingAnd;

  /// No description provided for @thisSpaceIsArchivedSo.
  ///
  /// In en, this message translates to:
  /// **'This Space is archived, so it is read-only.'**
  String get thisSpaceIsArchivedSo;

  /// No description provided for @youDoNotHavePermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to add expenses here.'**
  String get youDoNotHavePermission;

  /// No description provided for @enterAnAmountGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount greater than zero'**
  String get enterAnAmountGreaterThan;

  /// No description provided for @whatWasThisFor.
  ///
  /// In en, this message translates to:
  /// **'What was this for?'**
  String get whatWasThisFor;

  /// No description provided for @addAShortDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a short description'**
  String get addAShortDescription;

  /// No description provided for @whyThisHappenedOrAnything.
  ///
  /// In en, this message translates to:
  /// **'Why this happened, or anything to remember'**
  String get whyThisHappenedOrAnything;

  /// No description provided for @paidOutsidePockitoNoWallet.
  ///
  /// In en, this message translates to:
  /// **'Paid outside Pockito · no wallet movement'**
  String get paidOutsidePockitoNoWallet;

  /// No description provided for @noAccountMovement.
  ///
  /// In en, this message translates to:
  /// **'No account movement'**
  String get noAccountMovement;

  /// No description provided for @thePayerSAccountIs.
  ///
  /// In en, this message translates to:
  /// **'The payer’s account is outside your personal ledger.'**
  String get thePayerSAccountIs;

  /// No description provided for @chooseTheDestination.
  ///
  /// In en, this message translates to:
  /// **'Choose the destination'**
  String get chooseTheDestination;

  /// No description provided for @capturedWithThisTransfer.
  ///
  /// In en, this message translates to:
  /// **'Captured with this transfer'**
  String get capturedWithThisTransfer;

  /// No description provided for @rateMustBeMoreThan.
  ///
  /// In en, this message translates to:
  /// **'Rate must be more than zero'**
  String get rateMustBeMoreThan;

  /// No description provided for @automaticRateUnavailableChooseManual.
  ///
  /// In en, this message translates to:
  /// **'Automatic rate unavailable. Choose Manual to continue.'**
  String get automaticRateUnavailableChooseManual;

  /// No description provided for @paidWithOptional.
  ///
  /// In en, this message translates to:
  /// **'Paid with (optional)'**
  String get paidWithOptional;

  /// No description provided for @shareThisExpense.
  ///
  /// In en, this message translates to:
  /// **'Share this expense'**
  String get shareThisExpense;

  /// No description provided for @personalSpendingOnly.
  ///
  /// In en, this message translates to:
  /// **'Personal spending only'**
  String get personalSpendingOnly;

  /// No description provided for @updatesTheAccountAndEveryone.
  ///
  /// In en, this message translates to:
  /// **'Updates the account and everyone’s balance'**
  String get updatesTheAccountAndEveryone;

  /// No description provided for @noAutomaticRateEnterA.
  ///
  /// In en, this message translates to:
  /// **'No automatic rate. Enter a manual rate to continue.'**
  String get noAutomaticRateEnterA;

  /// No description provided for @receiptKeptDetailsFilledIn.
  ///
  /// In en, this message translates to:
  /// **'Receipt kept · details filled in — review before saving'**
  String get receiptKeptDetailsFilledIn;

  /// No description provided for @receiptKeptWeCouldNot.
  ///
  /// In en, this message translates to:
  /// **'Receipt kept · we could not read it, so nothing was filled in'**
  String get receiptKeptWeCouldNot;

  /// No description provided for @attachAReceipt.
  ///
  /// In en, this message translates to:
  /// **'Attach a receipt'**
  String get attachAReceipt;

  /// No description provided for @whatIsItEG.
  ///
  /// In en, this message translates to:
  /// **'What is it? e.g. Restaurant bill'**
  String get whatIsItEG;

  /// No description provided for @enterAnAmountBeforeEditing.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount before editing the split'**
  String get enterAnAmountBeforeEditing;

  /// No description provided for @chooseAValidExchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Choose a valid exchange rate to continue'**
  String get chooseAValidExchangeRate;

  /// No description provided for @enterAnExchangeRateFor.
  ///
  /// In en, this message translates to:
  /// **'Enter an exchange rate for this wallet payment'**
  String get enterAnExchangeRateFor;

  /// No description provided for @moneyEventAdded.
  ///
  /// In en, this message translates to:
  /// **'Money event added'**
  String get moneyEventAdded;

  /// No description provided for @moneyEventUpdated.
  ///
  /// In en, this message translates to:
  /// **'Money event updated'**
  String get moneyEventUpdated;

  /// No description provided for @yourVersionWasKept.
  ///
  /// In en, this message translates to:
  /// **'Your version was kept'**
  String get yourVersionWasKept;

  /// No description provided for @loadedTheirVersionSNumbers.
  ///
  /// In en, this message translates to:
  /// **'Loaded their version’s numbers — check each field, then save.'**
  String get loadedTheirVersionSNumbers;

  /// No description provided for @fitTheWholeReceiptInside.
  ///
  /// In en, this message translates to:
  /// **'Fit the whole receipt inside the frame'**
  String get fitTheWholeReceiptInside;

  /// No description provided for @previewLowConfidence.
  ///
  /// In en, this message translates to:
  /// **'Preview low confidence'**
  String get previewLowConfidence;

  /// No description provided for @previewFailedScan.
  ///
  /// In en, this message translates to:
  /// **'Preview failed scan'**
  String get previewFailedScan;

  /// No description provided for @readingMerchantTotalAndDate.
  ///
  /// In en, this message translates to:
  /// **'Reading merchant, total and date…'**
  String get readingMerchantTotalAndDate;

  /// No description provided for @oneQuickCheck.
  ///
  /// In en, this message translates to:
  /// **'One quick check'**
  String get oneQuickCheck;

  /// No description provided for @merchantAndCategoryHaveLow.
  ///
  /// In en, this message translates to:
  /// **'Merchant and category have low confidence. Every field stays editable before saving.'**
  String get merchantAndCategoryHaveLow;

  /// No description provided for @augustGroceries.
  ///
  /// In en, this message translates to:
  /// **'15 August 2026 · Groceries'**
  String get augustGroceries;

  /// No description provided for @thisIsALocalOcr.
  ///
  /// In en, this message translates to:
  /// **'This is a local OCR simulation. Nothing was uploaded and you can edit every field before saving.'**
  String get thisIsALocalOcr;

  /// No description provided for @useTheseDetails.
  ///
  /// In en, this message translates to:
  /// **'Use these details'**
  String get useTheseDetails;

  /// No description provided for @weCouldNotReadThis.
  ///
  /// In en, this message translates to:
  /// **'We could not read this document'**
  String get weCouldNotReadThis;

  /// No description provided for @theImageMayBeBlurred.
  ///
  /// In en, this message translates to:
  /// **'The image may be blurred, cropped or offline. No financial data was created.'**
  String get theImageMayBeBlurred;

  /// No description provided for @theImageWasTooBlurred.
  ///
  /// In en, this message translates to:
  /// **'The image was too blurred to read. Nothing was filled in for you.'**
  String get theImageWasTooBlurred;

  /// No description provided for @enterDetailsManually.
  ///
  /// In en, this message translates to:
  /// **'Enter details manually'**
  String get enterDetailsManually;

  /// No description provided for @searchPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Search payment methods'**
  String get searchPaymentMethods;

  /// No description provided for @recordsThatWereUndoneKept.
  ///
  /// In en, this message translates to:
  /// **'Records that were undone, kept for the history'**
  String get recordsThatWereUndoneKept;

  /// No description provided for @stagedRecordsThatDoNot.
  ///
  /// In en, this message translates to:
  /// **'Staged records that do not count yet'**
  String get stagedRecordsThatDoNot;

  /// No description provided for @everythingIsAllocated.
  ///
  /// In en, this message translates to:
  /// **'Everything is allocated'**
  String get everythingIsAllocated;

  /// No description provided for @useThisSplit.
  ///
  /// In en, this message translates to:
  /// **'Use this split'**
  String get useThisSplit;

  /// No description provided for @addALineForEach.
  ///
  /// In en, this message translates to:
  /// **'Add a line for each thing on the bill, then tick who had it. Anything you don’t itemise is split evenly.'**
  String get addALineForEach;

  /// No description provided for @everyLineAccountedFor.
  ///
  /// In en, this message translates to:
  /// **'Every line accounted for'**
  String get everyLineAccountedFor;

  /// No description provided for @notItemisedSplitEvenly.
  ///
  /// In en, this message translates to:
  /// **'{p0} not itemised — split evenly'**
  String notItemisedSplitEvenly(Object p0);

  /// No description provided for @whatWasOnTheBill.
  ///
  /// In en, this message translates to:
  /// **'What was on the bill?'**
  String get whatWasOnTheBill;

  /// No description provided for @eGTheWine.
  ///
  /// In en, this message translates to:
  /// **'e.g. the wine'**
  String get eGTheWine;

  /// No description provided for @howMuchWas.
  ///
  /// In en, this message translates to:
  /// **'How much was {p0}?'**
  String howMuchWas(Object p0);

  /// No description provided for @thatAmountDidnTLook.
  ///
  /// In en, this message translates to:
  /// **'That amount didn’t look like a number'**
  String get thatAmountDidnTLook;

  /// No description provided for @thisIsHowItLands.
  ///
  /// In en, this message translates to:
  /// **'This is how it lands'**
  String get thisIsHowItLands;

  /// No description provided for @nothingIsSavedYetGoing.
  ///
  /// In en, this message translates to:
  /// **'Nothing is saved yet. Going back keeps the editor open.'**
  String get nothingIsSavedYetGoing;

  /// No description provided for @percentagesMustTotal.
  ///
  /// In en, this message translates to:
  /// **'Percentages must total 100%'**
  String get percentagesMustTotal;

  /// No description provided for @enterAtLeastOnePositive.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one positive share'**
  String get enterAtLeastOnePositive;

  /// No description provided for @moreThanOnePersonPaid.
  ///
  /// In en, this message translates to:
  /// **'More than one person paid'**
  String get moreThanOnePersonPaid;

  /// No description provided for @whoPaidWhat.
  ///
  /// In en, this message translates to:
  /// **'Who paid what'**
  String get whoPaidWhat;

  /// No description provided for @payersAddUpTo.
  ///
  /// In en, this message translates to:
  /// **'Payers add up to {p0}'**
  String payersAddUpTo(Object p0);

  /// No description provided for @sharedMoneyWithoutTheAwkward.
  ///
  /// In en, this message translates to:
  /// **'Shared money, without the awkward maths'**
  String get sharedMoneyWithoutTheAwkward;

  /// No description provided for @searchSpacesOrTheirMembers.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} Spaces or their members'**
  String searchSpacesOrTheirMembers(Object p0);

  /// No description provided for @shareMoneyWithLessFriction.
  ///
  /// In en, this message translates to:
  /// **'Share money with less friction'**
  String get shareMoneyWithLessFriction;

  /// No description provided for @createASpaceForA.
  ///
  /// In en, this message translates to:
  /// **'Create a space for a home, trip, couple or group of friends.'**
  String get createASpaceForA;

  /// No description provided for @createASpace.
  ///
  /// In en, this message translates to:
  /// **'Create a space'**
  String get createASpace;

  /// No description provided for @noSpaceMatches.
  ///
  /// In en, this message translates to:
  /// **'No Space matches “{p0}”'**
  String noSpaceMatches(Object p0);

  /// No description provided for @tryADifferentNameType.
  ///
  /// In en, this message translates to:
  /// **'Try a different name, type or member.'**
  String get tryADifferentNameType;

  /// No description provided for @spaceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Space not found'**
  String get spaceNotFound;

  /// No description provided for @itMayHaveBeenRemoved.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed from the prototype.'**
  String get itMayHaveBeenRemoved;

  /// No description provided for @everyoneIsSettled.
  ///
  /// In en, this message translates to:
  /// **'Everyone is settled'**
  String get everyoneIsSettled;

  /// No description provided for @cyclesPreserveYourHistory.
  ///
  /// In en, this message translates to:
  /// **'Cycles preserve your history'**
  String get cyclesPreserveYourHistory;

  /// No description provided for @startANewCycleTo.
  ///
  /// In en, this message translates to:
  /// **'Start a new cycle to reset current balances and the space budget. Nothing historical is deleted.'**
  String get startANewCycleTo;

  /// No description provided for @startNewCycle.
  ///
  /// In en, this message translates to:
  /// **'Start new cycle'**
  String get startNewCycle;

  /// No description provided for @noSharedExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No shared expenses yet'**
  String get noSharedExpensesYet;

  /// No description provided for @noExpensesMatchTheseFilters.
  ///
  /// In en, this message translates to:
  /// **'No expenses match these filters'**
  String get noExpensesMatchTheseFilters;

  /// No description provided for @addTheFirstExpenseAnd.
  ///
  /// In en, this message translates to:
  /// **'Add the first expense and Pockito will keep everyone’s balance clear.'**
  String get addTheFirstExpenseAnd;

  /// No description provided for @tryShowingSettledAndUnsettled.
  ///
  /// In en, this message translates to:
  /// **'Try showing settled and unsettled expenses, or include every payer.'**
  String get tryShowingSettledAndUnsettled;

  /// No description provided for @joinedTheSpace.
  ///
  /// In en, this message translates to:
  /// **'{p0} joined the space'**
  String joinedTheSpace(Object p0);

  /// No description provided for @everyAmountIsInThe.
  ///
  /// In en, this message translates to:
  /// **'Every amount is in {p0}, the space currency.'**
  String everyAmountIsInThe(Object p0);

  /// No description provided for @whoPaysWhom.
  ///
  /// In en, this message translates to:
  /// **'Who pays whom'**
  String get whoPaysWhom;

  /// No description provided for @startANewCycle.
  ///
  /// In en, this message translates to:
  /// **'Start a new cycle?'**
  String get startANewCycle;

  /// No description provided for @currentBalancesAndSpaceBudget.
  ///
  /// In en, this message translates to:
  /// **'Current balances and space-budget usage restart at zero. Expenses, contributions, analytics and settlements remain in the previous cycle.'**
  String get currentBalancesAndSpaceBudget;

  /// No description provided for @newCycleStartedHistoryPreserved.
  ///
  /// In en, this message translates to:
  /// **'New cycle started · history preserved'**
  String get newCycleStartedHistoryPreserved;

  /// No description provided for @paidByMe.
  ///
  /// In en, this message translates to:
  /// **'Paid by me'**
  String get paidByMe;

  /// No description provided for @paidByMember.
  ///
  /// In en, this message translates to:
  /// **'Paid by member'**
  String get paidByMember;

  /// No description provided for @expenseNotFound.
  ///
  /// In en, this message translates to:
  /// **'Expense not found'**
  String get expenseNotFound;

  /// No description provided for @thisExpenseHasBeenRemoved.
  ///
  /// In en, this message translates to:
  /// **'This expense has been removed.'**
  String get thisExpenseHasBeenRemoved;

  /// No description provided for @thisClosedCycleRecordIs.
  ///
  /// In en, this message translates to:
  /// **'This closed-cycle record is read-only so its totals remain trustworthy.'**
  String get thisClosedCycleRecordIs;

  /// No description provided for @chargedToYourWallet.
  ///
  /// In en, this message translates to:
  /// **'Charged to your wallet'**
  String get chargedToYourWallet;

  /// No description provided for @whoPaysWhat.
  ///
  /// In en, this message translates to:
  /// **'Who pays what'**
  String get whoPaysWhat;

  /// No description provided for @theSpaceThisBelongsTo.
  ///
  /// In en, this message translates to:
  /// **'The Space this belongs to'**
  String get theSpaceThisBelongsTo;

  /// No description provided for @yourAccountMovement.
  ///
  /// In en, this message translates to:
  /// **'Your account movement'**
  String get yourAccountMovement;

  /// No description provided for @itStaysVisibleToEveryone.
  ///
  /// In en, this message translates to:
  /// **'It stays visible to everyone, struck through, and stops counting towards the Space balance. Your linked account movement is undone with it.'**
  String get itStaysVisibleToEveryone;

  /// No description provided for @kanaExampleComFranExample.
  ///
  /// In en, this message translates to:
  /// **'kana@example.com, fran@example.com'**
  String get kanaExampleComFranExample;

  /// No description provided for @whatAreYouSharing.
  ///
  /// In en, this message translates to:
  /// **'What are you sharing?'**
  String get whatAreYouSharing;

  /// No description provided for @theSpaceCurrencyIsThe.
  ///
  /// In en, this message translates to:
  /// **'The space currency is the single source of truth for balances.'**
  String get theSpaceCurrencyIsThe;

  /// No description provided for @youCanShareAnInvite.
  ///
  /// In en, this message translates to:
  /// **'You can share an invite link now or do it later.'**
  String get youCanShareAnInvite;

  /// No description provided for @eGFlatOrTokyo.
  ///
  /// In en, this message translates to:
  /// **'e.g. Flat or Tokyo Trip'**
  String get eGFlatOrTokyo;

  /// No description provided for @nameYourSpace.
  ///
  /// In en, this message translates to:
  /// **'Name your space'**
  String get nameYourSpace;

  /// No description provided for @monthlySpaceBudgetOptional.
  ///
  /// In en, this message translates to:
  /// **'Monthly space budget (optional)'**
  String get monthlySpaceBudgetOptional;

  /// No description provided for @resetsForANewMonth.
  ///
  /// In en, this message translates to:
  /// **'Resets for a new month or space cycle'**
  String get resetsForANewMonth;

  /// No description provided for @enterABudgetGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'Enter a budget greater than zero'**
  String get enterABudgetGreaterThan;

  /// No description provided for @separateMultiplePeopleWithCommas.
  ///
  /// In en, this message translates to:
  /// **'Separate multiple people with commas'**
  String get separateMultiplePeopleWithCommas;

  /// No description provided for @inviteLinkReady.
  ///
  /// In en, this message translates to:
  /// **'Invite link ready'**
  String get inviteLinkReady;

  /// No description provided for @inviteLinkCopied.
  ///
  /// In en, this message translates to:
  /// **'Invite link copied'**
  String get inviteLinkCopied;

  /// No description provided for @createAndInvite.
  ///
  /// In en, this message translates to:
  /// **'Create and invite'**
  String get createAndInvite;

  /// No description provided for @notificationPreviewsTurnedOn.
  ///
  /// In en, this message translates to:
  /// **'Notification previews turned on'**
  String get notificationPreviewsTurnedOn;

  /// No description provided for @createdInvitationsPending.
  ///
  /// In en, this message translates to:
  /// **'{p0} created · invitations pending'**
  String createdInvitationsPending(Object p0);

  /// No description provided for @itMayHaveBeenRemoved2.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed or you may have left it.'**
  String get itMayHaveBeenRemoved2;

  /// No description provided for @youCanTInvitePeople.
  ///
  /// In en, this message translates to:
  /// **'You can’t invite people here'**
  String get youCanTInvitePeople;

  /// No description provided for @onlyOwnersAndAdminsCan.
  ///
  /// In en, this message translates to:
  /// **'Only owners and admins can invite people.'**
  String get onlyOwnersAndAdminsCan;

  /// No description provided for @tryADifferentNameOr.
  ///
  /// In en, this message translates to:
  /// **'Try a different name or clear the search.'**
  String get tryADifferentNameOr;

  /// No description provided for @inviteResentTo.
  ///
  /// In en, this message translates to:
  /// **'Invite resent to {p0}'**
  String inviteResentTo(Object p0);

  /// No description provided for @newInviteSentTo.
  ///
  /// In en, this message translates to:
  /// **'New invite sent to {p0}'**
  String newInviteSentTo(Object p0);

  /// No description provided for @noInvitationsYet.
  ///
  /// In en, this message translates to:
  /// **'No invitations yet'**
  String get noInvitationsYet;

  /// No description provided for @inviteKanaFranOrAnyone.
  ///
  /// In en, this message translates to:
  /// **'Invite Kana, Fran, or anyone you share money with.'**
  String get inviteKanaFranOrAnyone;

  /// No description provided for @invitedAsExpiresInDays.
  ///
  /// In en, this message translates to:
  /// **'{p0} invited as {p1} · expires in {p2} days'**
  String invitedAsExpiresInDays(Object p0, Object p1, Object p2);

  /// No description provided for @revokeSInvite.
  ///
  /// In en, this message translates to:
  /// **'Revoke {p0}’s invite?'**
  String revokeSInvite(Object p0);

  /// No description provided for @theLinkStopsWorkingImmediately.
  ///
  /// In en, this message translates to:
  /// **'The link stops working immediately. You can invite them again at any time.'**
  String get theLinkStopsWorkingImmediately;

  /// No description provided for @sInviteRevoked.
  ///
  /// In en, this message translates to:
  /// **'{p0}’s invite revoked'**
  String sInviteRevoked(Object p0);

  /// No description provided for @youCanTChangeRoles.
  ///
  /// In en, this message translates to:
  /// **'You can’t change roles here'**
  String get youCanTChangeRoles;

  /// No description provided for @onlyTheOwnerCanChange.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can change roles.'**
  String get onlyTheOwnerCanChange;

  /// No description provided for @youCanTRemoveThis.
  ///
  /// In en, this message translates to:
  /// **'You can’t remove this member'**
  String get youCanTRemoveThis;

  /// No description provided for @theOwnerCannotBeRemoved.
  ///
  /// In en, this message translates to:
  /// **'The owner cannot be removed. Transfer ownership first.'**
  String get theOwnerCannotBeRemoved;

  /// No description provided for @onlyOwnersAndAdminsCan2.
  ///
  /// In en, this message translates to:
  /// **'Only owners and admins can remove members.'**
  String get onlyOwnersAndAdminsCan2;

  /// No description provided for @removeFromSpace.
  ///
  /// In en, this message translates to:
  /// **'Remove from Space'**
  String get removeFromSpace;

  /// No description provided for @youCanTLeaveThis.
  ///
  /// In en, this message translates to:
  /// **'You can’t leave this Space'**
  String get youCanTLeaveThis;

  /// No description provided for @youAreTheOnlyOwner.
  ///
  /// In en, this message translates to:
  /// **'You are the only owner. Make someone else the owner first, so the Space is never left unmanaged.'**
  String get youAreTheOnlyOwner;

  /// No description provided for @thisSpaceCannotBeLeft.
  ///
  /// In en, this message translates to:
  /// **'This Space cannot be left right now.'**
  String get thisSpaceCannotBeLeft;

  /// No description provided for @whatTheyCanDoChanges.
  ///
  /// In en, this message translates to:
  /// **'What they can do changes immediately.'**
  String get whatTheyCanDoChanges;

  /// No description provided for @isNowA.
  ///
  /// In en, this message translates to:
  /// **'{p0} is now a {p1}'**
  String isNowA(Object p0, Object p1);

  /// No description provided for @youLoseAccessToIts.
  ///
  /// In en, this message translates to:
  /// **'You lose access to its expenses and balances. Rejoining needs a new invitation from an owner or admin.'**
  String get youLoseAccessToIts;

  /// No description provided for @settleTheBalanceFirst.
  ///
  /// In en, this message translates to:
  /// **'Settle the balance first'**
  String get settleTheBalanceFirst;

  /// No description provided for @hasABalanceInThis.
  ///
  /// In en, this message translates to:
  /// **'{p0} has a {p1} balance in this cycle. Settle it before removing them so the history stays consistent.'**
  String hasABalanceInThis(Object p0, Object p1);

  /// No description provided for @theyWillKeepAccessTo.
  ///
  /// In en, this message translates to:
  /// **'They will keep access to their past records but cannot add new expenses.'**
  String get theyWillKeepAccessTo;

  /// No description provided for @linkExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Link expires in'**
  String get linkExpiresIn;

  /// No description provided for @copyInviteLink.
  ///
  /// In en, this message translates to:
  /// **'Copy invite link'**
  String get copyInviteLink;

  /// No description provided for @onlyOwnersAndAdminsCan3.
  ///
  /// In en, this message translates to:
  /// **'Only owners and admins can change Space settings.'**
  String get onlyOwnersAndAdminsCan3;

  /// No description provided for @isOpenAgain.
  ///
  /// In en, this message translates to:
  /// **'{p0} is open again'**
  String isOpenAgain(Object p0);

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'{p0} · {p1} · {p2} members'**
  String members(Object p0, Object p1, Object p2);

  /// No description provided for @whoChangedWhatAndWhen.
  ///
  /// In en, this message translates to:
  /// **'Who changed what, and when'**
  String get whoChangedWhatAndWhen;

  /// No description provided for @includesMemberAndSettingsChanges.
  ///
  /// In en, this message translates to:
  /// **'Includes member and settings changes'**
  String get includesMemberAndSettingsChanges;

  /// No description provided for @onlyTheOwnerCanArchive.
  ///
  /// In en, this message translates to:
  /// **'Only the owner can archive or reopen a Space.'**
  String get onlyTheOwnerCanArchive;

  /// No description provided for @automaticallyPreFillsEveryNew.
  ///
  /// In en, this message translates to:
  /// **'Automatically pre-fills every new expense. It can always be overridden.'**
  String get automaticallyPreFillsEveryNew;

  /// No description provided for @exactAmountsDependOnThe.
  ///
  /// In en, this message translates to:
  /// **'Exact amounts depend on the expense total. New expenses start equally allocated and require confirmation in the split editor.'**
  String get exactAmountsDependOnThe;

  /// No description provided for @everyoneReceivesAnEqualResponsibility.
  ///
  /// In en, this message translates to:
  /// **'Everyone receives an equal responsibility.'**
  String get everyoneReceivesAnEqualResponsibility;

  /// No description provided for @percentagesMustTotalCurrently.
  ///
  /// In en, this message translates to:
  /// **'Percentages must total 100% (currently {p0}%).'**
  String percentagesMustTotalCurrently(Object p0);

  /// No description provided for @enterAtLeastOnePositive2.
  ///
  /// In en, this message translates to:
  /// **'Enter at least one positive share.'**
  String get enterAtLeastOnePositive2;

  /// No description provided for @saveDefaultSplit.
  ///
  /// In en, this message translates to:
  /// **'Save default split'**
  String get saveDefaultSplit;

  /// No description provided for @equalAcrossMembers.
  ///
  /// In en, this message translates to:
  /// **'Equal across {p0} members'**
  String equalAcrossMembers(Object p0);

  /// No description provided for @exactAmountsConfirmPerExpense.
  ///
  /// In en, this message translates to:
  /// **'Exact amounts · confirm per expense'**
  String get exactAmountsConfirmPerExpense;

  /// No description provided for @itemizedAssignEachLinePer.
  ///
  /// In en, this message translates to:
  /// **'Itemized · assign each line per expense'**
  String get itemizedAssignEachLinePer;

  /// No description provided for @membersCanNoLongerAdd.
  ///
  /// In en, this message translates to:
  /// **'Members can no longer add expenses, but the complete history remains available.'**
  String get membersCanNoLongerAdd;

  /// No description provided for @thereAreNoOutstandingPayments.
  ///
  /// In en, this message translates to:
  /// **'There are no outstanding payments in this cycle.'**
  String get thereAreNoOutstandingPayments;

  /// No description provided for @thisRecordsASettlementNever.
  ///
  /// In en, this message translates to:
  /// **'This records a settlement, never spending.'**
  String get thisRecordsASettlementNever;

  /// No description provided for @eGAugustUtilities.
  ///
  /// In en, this message translates to:
  /// **'e.g. August utilities'**
  String get eGAugustUtilities;

  /// No description provided for @enterAValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get enterAValidAmount;

  /// No description provided for @amountCannotExceed.
  ///
  /// In en, this message translates to:
  /// **'Amount cannot exceed {p0}'**
  String amountCannotExceed(Object p0);

  /// No description provided for @confirmsThisBeforeAnyBalance.
  ///
  /// In en, this message translates to:
  /// **'{p0} confirms this before any balance moves. You can cancel it until then.'**
  String confirmsThisBeforeAnyBalance(Object p0);

  /// No description provided for @youAreTheOneBeing.
  ///
  /// In en, this message translates to:
  /// **'You are the one being paid, so recording it confirms it straight away.'**
  String get youAreTheOneBeing;

  /// No description provided for @sendForConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Send for confirmation'**
  String get sendForConfirmation;

  /// No description provided for @partialSettlementRecorded.
  ///
  /// In en, this message translates to:
  /// **'Partial settlement recorded'**
  String get partialSettlementRecorded;

  /// No description provided for @everyMemberIsAtExpenses.
  ///
  /// In en, this message translates to:
  /// **'Every member is at {p0}. Expenses and settlements remain in this cycle’s history.'**
  String everyMemberIsAtExpenses(Object p0);

  /// No description provided for @backToSpaces.
  ///
  /// In en, this message translates to:
  /// **'Back to spaces'**
  String get backToSpaces;

  /// No description provided for @settleRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Settle remaining balance'**
  String get settleRemainingBalance;

  /// No description provided for @viewSettlementHistory.
  ///
  /// In en, this message translates to:
  /// **'View settlement history'**
  String get viewSettlementHistory;

  /// No description provided for @itsSettlementHistoryIsNo.
  ///
  /// In en, this message translates to:
  /// **'Its settlement history is no longer available.'**
  String get itsSettlementHistoryIsNo;

  /// No description provided for @noSettlementsYet.
  ///
  /// In en, this message translates to:
  /// **'No settlements yet'**
  String get noSettlementsYet;

  /// No description provided for @whenSomeonePaysAnotherBack.
  ///
  /// In en, this message translates to:
  /// **'When someone pays another back, it’ll be recorded here.'**
  String get whenSomeonePaysAnotherBack;

  /// No description provided for @settlementNotFound.
  ///
  /// In en, this message translates to:
  /// **'Settlement not found'**
  String get settlementNotFound;

  /// No description provided for @itMayHaveBeenRemoved3.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed from the local prototype.'**
  String get itMayHaveBeenRemoved3;

  /// No description provided for @waitingOnConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Waiting on confirmation'**
  String get waitingOnConfirmation;

  /// No description provided for @saysThisMoneyReachedYou.
  ///
  /// In en, this message translates to:
  /// **'{p0} says this money reached you. Nothing has moved yet — confirming is what shifts the balance.'**
  String saysThisMoneyReachedYou(Object p0);

  /// No description provided for @thatDidnTHappen.
  ///
  /// In en, this message translates to:
  /// **'That didn’t happen'**
  String get thatDidnTHappen;

  /// No description provided for @youProposedItSoConfirming.
  ///
  /// In en, this message translates to:
  /// **'You proposed it, so confirming it yourself would let one person declare the other has been paid.'**
  String get youProposedItSoConfirming;

  /// No description provided for @cancelThisProposal.
  ///
  /// In en, this message translates to:
  /// **'Cancel this proposal'**
  String get cancelThisProposal;

  /// No description provided for @whereDidTheMoneyLand.
  ///
  /// In en, this message translates to:
  /// **'Where did the money land?'**
  String get whereDidTheMoneyLand;

  /// No description provided for @cancelThisSettlement.
  ///
  /// In en, this message translates to:
  /// **'Cancel this settlement'**
  String get cancelThisSettlement;

  /// No description provided for @itStaysInTheHistory.
  ///
  /// In en, this message translates to:
  /// **'It stays in the history as cancelled. Nothing about the balance changes, because nothing moved.'**
  String get itStaysInTheHistory;

  /// No description provided for @cycleHistoryIsNoLonger.
  ///
  /// In en, this message translates to:
  /// **'Cycle history is no longer available.'**
  String get cycleHistoryIsNoLonger;

  /// No description provided for @openCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'Open current cycle'**
  String get openCurrentCycle;

  /// No description provided for @noPreviousCycles.
  ///
  /// In en, this message translates to:
  /// **'No previous cycles'**
  String get noPreviousCycles;

  /// No description provided for @onceEveryoneIsSettledStart.
  ///
  /// In en, this message translates to:
  /// **'Once everyone is settled, start a new cycle to preserve this period here.'**
  String get onceEveryoneIsSettledStart;

  /// No description provided for @expensesSettlements.
  ///
  /// In en, this message translates to:
  /// **'{p0} expenses · {p1} settlements'**
  String expensesSettlements(Object p0, Object p1);

  /// No description provided for @cycleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Cycle not found'**
  String get cycleNotFound;

  /// No description provided for @thisHistoricalSnapshotIsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This historical snapshot is unavailable.'**
  String get thisHistoricalSnapshotIsUnavailable;

  /// No description provided for @settledCycleReadOnly.
  ///
  /// In en, this message translates to:
  /// **'Settled cycle · read-only'**
  String get settledCycleReadOnly;

  /// No description provided for @thisSnapshotDoesNotChange.
  ///
  /// In en, this message translates to:
  /// **'This snapshot does not change when the current cycle changes.'**
  String get thisSnapshotDoesNotChange;

  /// No description provided for @theSnapshotRetainsExpenseReferences.
  ///
  /// In en, this message translates to:
  /// **'The snapshot retains {p0} expense references and all aggregate totals.'**
  String theSnapshotRetainsExpenseReferences(Object p0);

  /// No description provided for @returnToCurrentCycle.
  ///
  /// In en, this message translates to:
  /// **'Return to current cycle'**
  String get returnToCurrentCycle;

  /// No description provided for @noArchivedSpaces.
  ///
  /// In en, this message translates to:
  /// **'No archived spaces'**
  String get noArchivedSpaces;

  /// No description provided for @finishedTripsAndOldGroups.
  ///
  /// In en, this message translates to:
  /// **'Finished trips and old groups can live here.'**
  String get finishedTripsAndOldGroups;

  /// No description provided for @acrossAllSpaces.
  ///
  /// In en, this message translates to:
  /// **'Across all spaces'**
  String get acrossAllSpaces;

  /// No description provided for @itsActivityLogIsNo.
  ///
  /// In en, this message translates to:
  /// **'Its activity log is no longer available.'**
  String get itsActivityLogIsNo;

  /// No description provided for @searchThisLog.
  ///
  /// In en, this message translates to:
  /// **'Search this log'**
  String get searchThisLog;

  /// No description provided for @refusedActionsOnly.
  ///
  /// In en, this message translates to:
  /// **'Refused actions only'**
  String get refusedActionsOnly;

  /// No description provided for @nothingRecordedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing recorded yet'**
  String get nothingRecordedYet;

  /// No description provided for @nobodyHasBeenRefusedAn.
  ///
  /// In en, this message translates to:
  /// **'Nobody has been refused an action here.'**
  String get nobodyHasBeenRefusedAn;

  /// No description provided for @addingAnExpenseOrChanging.
  ///
  /// In en, this message translates to:
  /// **'Adding an expense or changing a setting will show up here, with who did it.'**
  String get addingAnExpenseOrChanging;

  /// No description provided for @startWithAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Start with an account'**
  String get startWithAnAccount;

  /// No description provided for @accountsAreWhereMoneyEnters.
  ///
  /// In en, this message translates to:
  /// **'Accounts are where money enters and leaves Pockito.'**
  String get accountsAreWhereMoneyEnters;

  /// No description provided for @noAccountMatches.
  ///
  /// In en, this message translates to:
  /// **'No account matches “{p0}”'**
  String noAccountMatches(Object p0);

  /// No description provided for @tryADifferentNameType2.
  ///
  /// In en, this message translates to:
  /// **'Try a different name, type or currency.'**
  String get tryADifferentNameType2;

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFound;

  /// No description provided for @correctTheBalance.
  ///
  /// In en, this message translates to:
  /// **'Correct the balance'**
  String get correctTheBalance;

  /// No description provided for @balanceOverTheLastDays.
  ///
  /// In en, this message translates to:
  /// **'{p0} balance over the last 30 days, ending at {p1}'**
  String balanceOverTheLastDays(Object p0, Object p1);

  /// No description provided for @availableToSpend.
  ///
  /// In en, this message translates to:
  /// **'Available to spend'**
  String get availableToSpend;

  /// No description provided for @recordThisAccountSFirst.
  ///
  /// In en, this message translates to:
  /// **'Record this account’s first money event.'**
  String get recordThisAccountSFirst;

  /// No description provided for @itsHistoryStaysAvailableYou.
  ///
  /// In en, this message translates to:
  /// **'Its history stays available. You can restore it from Archived accounts.'**
  String get itsHistoryStaysAvailableYou;

  /// No description provided for @eGRevolut.
  ///
  /// In en, this message translates to:
  /// **'e.g. Revolut'**
  String get eGRevolut;

  /// No description provided for @giveThisAccountAName.
  ///
  /// In en, this message translates to:
  /// **'Give this account a name'**
  String get giveThisAccountAName;

  /// No description provided for @creditLimitOptional.
  ///
  /// In en, this message translates to:
  /// **'Credit limit (optional)'**
  String get creditLimitOptional;

  /// No description provided for @letsPockitoShowWhatIs.
  ///
  /// In en, this message translates to:
  /// **'Lets Pockito show what is left to spend, not only what is owed'**
  String get letsPockitoShowWhatIs;

  /// No description provided for @savingsGoalOptional.
  ///
  /// In en, this message translates to:
  /// **'Savings goal (optional)'**
  String get savingsGoalOptional;

  /// No description provided for @showsProgressOnTheAccount.
  ///
  /// In en, this message translates to:
  /// **'Shows progress on the account'**
  String get showsProgressOnTheAccount;

  /// No description provided for @preselectedWhenRecordingAnExpense.
  ///
  /// In en, this message translates to:
  /// **'Preselected when recording an expense'**
  String get preselectedWhenRecordingAnExpense;

  /// No description provided for @noArchivedAccounts.
  ///
  /// In en, this message translates to:
  /// **'No archived accounts'**
  String get noArchivedAccounts;

  /// No description provided for @archivedAccountsWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Archived accounts will appear here with their history intact.'**
  String get archivedAccountsWillAppearHere;

  /// No description provided for @availableByCurrency.
  ///
  /// In en, this message translates to:
  /// **'Available by currency'**
  String get availableByCurrency;

  /// No description provided for @currenciesStaySeparateUntilReporting.
  ///
  /// In en, this message translates to:
  /// **'Currencies stay separate until reporting. Pockito never combines money without a rate.'**
  String get currenciesStaySeparateUntilReporting;

  /// No description provided for @inThisMonth.
  ///
  /// In en, this message translates to:
  /// **'IN THIS MONTH'**
  String get inThisMonth;

  /// No description provided for @outThisMonth.
  ///
  /// In en, this message translates to:
  /// **'OUT THIS MONTH'**
  String get outThisMonth;

  /// No description provided for @connectAnApp.
  ///
  /// In en, this message translates to:
  /// **'Connect an app'**
  String get connectAnApp;

  /// No description provided for @youStayInControl.
  ///
  /// In en, this message translates to:
  /// **'You stay in control'**
  String get youStayInControl;

  /// No description provided for @kitoSurfacesAiInsightsBut.
  ///
  /// In en, this message translates to:
  /// **'Kito surfaces AI insights, but connections only see approved data and financial writes always get a preview.'**
  String get kitoSurfacesAiInsightsBut;

  /// No description provided for @noConnectedApps.
  ///
  /// In en, this message translates to:
  /// **'No connected apps'**
  String get noConnectedApps;

  /// No description provided for @connectAnAiApplicationAnd.
  ///
  /// In en, this message translates to:
  /// **'Connect an AI application and choose exactly what it can read or change.'**
  String get connectAnAiApplicationAnd;

  /// No description provided for @suspendedReviewNeeded.
  ///
  /// In en, this message translates to:
  /// **'Suspended · review needed'**
  String get suspendedReviewNeeded;

  /// No description provided for @verifiedByPockito.
  ///
  /// In en, this message translates to:
  /// **'Verified by Pockito'**
  String get verifiedByPockito;

  /// No description provided for @customMcpClient.
  ///
  /// In en, this message translates to:
  /// **'Custom MCP client'**
  String get customMcpClient;

  /// No description provided for @chooseAnApplication.
  ///
  /// In en, this message translates to:
  /// **'Choose an application'**
  String get chooseAnApplication;

  /// No description provided for @thisPrototypeSimulatesAuthorizationNo.
  ///
  /// In en, this message translates to:
  /// **'This prototype simulates authorization. No token or external connection is created.'**
  String get thisPrototypeSimulatesAuthorizationNo;

  /// No description provided for @unverifiedApplicationUseExtraCare.
  ///
  /// In en, this message translates to:
  /// **'Unverified application · use extra care'**
  String get unverifiedApplicationUseExtraCare;

  /// No description provided for @allowAccessToPockito.
  ///
  /// In en, this message translates to:
  /// **'Allow access to Pockito?'**
  String get allowAccessToPockito;

  /// No description provided for @chooseTheMinimumAccessThis.
  ///
  /// In en, this message translates to:
  /// **'Choose the minimum access this app needs. You can revoke it later.'**
  String get chooseTheMinimumAccessThis;

  /// No description provided for @namesTypesCurrenciesAndBalances.
  ///
  /// In en, this message translates to:
  /// **'Names, types, currencies and balances'**
  String get namesTypesCurrenciesAndBalances;

  /// No description provided for @moneyEventsAndCategories.
  ///
  /// In en, this message translates to:
  /// **'Money events and categories'**
  String get moneyEventsAndCategories;

  /// No description provided for @sharedExpensesAndWhoOwes.
  ///
  /// In en, this message translates to:
  /// **'Shared expenses and who owes whom'**
  String get sharedExpensesAndWhoOwes;

  /// No description provided for @calculatedSpendingAndBudgetSummaries.
  ///
  /// In en, this message translates to:
  /// **'Calculated spending and budget summaries'**
  String get calculatedSpendingAndBudgetSummaries;

  /// No description provided for @allowFinancialChanges.
  ///
  /// In en, this message translates to:
  /// **'Allow financial changes'**
  String get allowFinancialChanges;

  /// No description provided for @createAndUpdateExpensesOr.
  ///
  /// In en, this message translates to:
  /// **'Create and update expenses or subscriptions'**
  String get createAndUpdateExpensesOr;

  /// No description provided for @writesArePreviewedFirstHigh.
  ///
  /// In en, this message translates to:
  /// **'Writes are previewed first. High-risk actions can wait for approval in Pockito.'**
  String get writesArePreviewedFirstHigh;

  /// No description provided for @connectionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Connection not found'**
  String get connectionNotFound;

  /// No description provided for @itMayHaveBeenDisconnected.
  ///
  /// In en, this message translates to:
  /// **'It may have been disconnected.'**
  String get itMayHaveBeenDisconnected;

  /// No description provided for @theAppLosesAccessImmediately.
  ///
  /// In en, this message translates to:
  /// **'The app loses access immediately. Money events it previously created stay attributed and visible.'**
  String get theAppLosesAccessImmediately;

  /// No description provided for @noAiActivity.
  ///
  /// In en, this message translates to:
  /// **'No AI activity'**
  String get noAiActivity;

  /// No description provided for @readsAndWritesFromConnected.
  ///
  /// In en, this message translates to:
  /// **'Reads and writes from connected apps will appear here with attribution.'**
  String get readsAndWritesFromConnected;

  /// No description provided for @blockedMemberInvitation.
  ///
  /// In en, this message translates to:
  /// **'Blocked member invitation'**
  String get blockedMemberInvitation;

  /// No description provided for @financeSidekickOutsideGrantedCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Finance Sidekick · outside granted capabilities'**
  String get financeSidekickOutsideGrantedCapabilities;

  /// No description provided for @nothingNeedsApproval.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs approval'**
  String get nothingNeedsApproval;

  /// No description provided for @highImpactActionsRequestedBy.
  ///
  /// In en, this message translates to:
  /// **'High-impact actions requested by connected apps will wait here.'**
  String get highImpactActionsRequestedBy;

  /// No description provided for @requestsYourApproval.
  ///
  /// In en, this message translates to:
  /// **'Requests your approval'**
  String get requestsYourApproval;

  /// No description provided for @approvedAndRecorded.
  ///
  /// In en, this message translates to:
  /// **'Approved and recorded'**
  String get approvedAndRecorded;

  /// No description provided for @noTagsYet.
  ///
  /// In en, this message translates to:
  /// **'No tags yet'**
  String get noTagsYet;

  /// No description provided for @tagsCutAcrossCategoriesA.
  ///
  /// In en, this message translates to:
  /// **'Tags cut across categories. A “Berlin trip” tag collects its groceries, transport and restaurants in one place.'**
  String get tagsCutAcrossCategoriesA;

  /// No description provided for @tryADifferentWordOr.
  ///
  /// In en, this message translates to:
  /// **'Try a different word, or add a new tag.'**
  String get tryADifferentWordOr;

  /// No description provided for @addATag.
  ///
  /// In en, this message translates to:
  /// **'Add a tag'**
  String get addATag;

  /// No description provided for @notUsedYet.
  ///
  /// In en, this message translates to:
  /// **'Not used yet'**
  String get notUsedYet;

  /// No description provided for @seeEverythingTaggedWithThis.
  ///
  /// In en, this message translates to:
  /// **'See everything tagged with this'**
  String get seeEverythingTaggedWithThis;

  /// No description provided for @recordsKeepTheirOtherTags.
  ///
  /// In en, this message translates to:
  /// **'Records keep their other tags; nothing else changes.'**
  String get recordsKeepTheirOtherTags;

  /// No description provided for @addPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add payment method'**
  String get addPaymentMethod;

  /// No description provided for @noPaymentMethodsYet.
  ///
  /// In en, this message translates to:
  /// **'No payment methods yet'**
  String get noPaymentMethodsYet;

  /// No description provided for @anAccountSaysWhereThe.
  ///
  /// In en, this message translates to:
  /// **'An account says where the money lives. A payment method says how it left — which card, which direct debit.'**
  String get anAccountSaysWhereThe;

  /// No description provided for @newPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'New payment method'**
  String get newPaymentMethod;

  /// No description provided for @eGAmexGold.
  ///
  /// In en, this message translates to:
  /// **'e.g. Amex Gold'**
  String get eGAmexGold;

  /// No description provided for @lastFourDigitsOptional.
  ///
  /// In en, this message translates to:
  /// **'Last four digits (optional)'**
  String get lastFourDigitsOptional;

  /// No description provided for @paymentMethodAdded.
  ///
  /// In en, this message translates to:
  /// **'Payment method added'**
  String get paymentMethodAdded;

  /// No description provided for @dateDescriptionAmountCurrencyCategory.
  ///
  /// In en, this message translates to:
  /// **'date,description,amount,currency,category,account\n2026-08-16,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-16,Refund from Zalando,24.00,EUR,Refunds,Visa\n2026-08-12,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-99,Broken row,-10.00,EUR,Groceries,Revolut\n'**
  String get dateDescriptionAmountCurrencyCategory;

  /// No description provided for @pasteCsvWithAHeader.
  ///
  /// In en, this message translates to:
  /// **'Paste CSV with a header row: date, description, amount, currency, category, account. A negative amount is money out.'**
  String get pasteCsvWithAHeader;

  /// No description provided for @checkTheRows.
  ///
  /// In en, this message translates to:
  /// **'Check the rows'**
  String get checkTheRows;

  /// No description provided for @toImportAlreadyRecordedUnreadable.
  ///
  /// In en, this message translates to:
  /// **'{p0} to import · {p1} already recorded · {p2} unreadable'**
  String toImportAlreadyRecordedUnreadable(Object p0, Object p1, Object p2);

  /// No description provided for @nothingHereCanBeImported.
  ///
  /// In en, this message translates to:
  /// **'Nothing here can be imported'**
  String get nothingHereCanBeImported;

  /// No description provided for @itIsOnYourClipboard.
  ///
  /// In en, this message translates to:
  /// **'It is on your clipboard. Here is exactly what was copied.'**
  String get itIsOnYourClipboard;

  /// No description provided for @itMayHaveBeenRemoved4.
  ///
  /// In en, this message translates to:
  /// **'It may have been removed.'**
  String get itMayHaveBeenRemoved4;

  /// No description provided for @pockitoThinksThisAccountHolds.
  ///
  /// In en, this message translates to:
  /// **'Pockito thinks this account holds'**
  String get pockitoThinksThisAccountHolds;

  /// No description provided for @whatIsActuallyThere.
  ///
  /// In en, this message translates to:
  /// **'What is actually there'**
  String get whatIsActuallyThere;

  /// No description provided for @thisRecordsACorrectionOf.
  ///
  /// In en, this message translates to:
  /// **'This records a correction of {p0} in. It is not income and never counts as earning.'**
  String thisRecordsACorrectionOf(Object p0);

  /// No description provided for @thisRecordsACorrectionOf2.
  ///
  /// In en, this message translates to:
  /// **'This records a correction of {p0} out. It is not an expense and never counts as spending.'**
  String thisRecordsACorrectionOf2(Object p0);

  /// No description provided for @whyDoesItDiffer.
  ///
  /// In en, this message translates to:
  /// **'Why does it differ?'**
  String get whyDoesItDiffer;

  /// No description provided for @eGCountedTheWallet.
  ///
  /// In en, this message translates to:
  /// **'e.g. Counted the wallet'**
  String get eGCountedTheWallet;

  /// No description provided for @recordTheCorrection.
  ///
  /// In en, this message translates to:
  /// **'Record the correction'**
  String get recordTheCorrection;

  /// No description provided for @enterTheRealBalance.
  ///
  /// In en, this message translates to:
  /// **'Enter the real balance'**
  String get enterTheRealBalance;

  /// No description provided for @sayWhyItDiffers.
  ///
  /// In en, this message translates to:
  /// **'Say why it differs'**
  String get sayWhyItDiffers;

  /// No description provided for @noRateAvailable.
  ///
  /// In en, this message translates to:
  /// **'No rate available'**
  String get noRateAvailable;

  /// No description provided for @atMockRate.
  ///
  /// In en, this message translates to:
  /// **'{p0} at mock rate'**
  String atMockRate(Object p0);

  /// No description provided for @planWithoutPolicingYourself.
  ///
  /// In en, this message translates to:
  /// **'Plan without policing yourself'**
  String get planWithoutPolicingYourself;

  /// No description provided for @budgetsShowPaceAndRemaining.
  ///
  /// In en, this message translates to:
  /// **'Budgets show pace and remaining allowance without judging ordinary spending.'**
  String get budgetsShowPaceAndRemaining;

  /// No description provided for @budgetNotFound.
  ///
  /// In en, this message translates to:
  /// **'Budget not found'**
  String get budgetNotFound;

  /// No description provided for @itMayHaveBeenDeleted.
  ///
  /// In en, this message translates to:
  /// **'It may have been deleted.'**
  String get itMayHaveBeenDeleted;

  /// No description provided for @projectedEndOf.
  ///
  /// In en, this message translates to:
  /// **'Projected end of {p0}'**
  String projectedEndOf(Object p0);

  /// No description provided for @nothingCountedYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing counted yet'**
  String get nothingCountedYet;

  /// No description provided for @matchingExpensesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Matching expenses will appear here automatically.'**
  String get matchingExpensesWillAppearHere;

  /// No description provided for @expensesStayUntouchedOnlyThis.
  ///
  /// In en, this message translates to:
  /// **'Expenses stay untouched. Only this limit and its alerts are removed.'**
  String get expensesStayUntouchedOnlyThis;

  /// No description provided for @eGGroceries.
  ///
  /// In en, this message translates to:
  /// **'e.g. Groceries'**
  String get eGGroceries;

  /// No description provided for @nameThisBudget.
  ///
  /// In en, this message translates to:
  /// **'Name this budget'**
  String get nameThisBudget;

  /// No description provided for @allExpenseCategories.
  ///
  /// In en, this message translates to:
  /// **'All expense categories'**
  String get allExpenseCategories;

  /// No description provided for @onlySelectedCategoriesCount.
  ///
  /// In en, this message translates to:
  /// **'Only selected categories count'**
  String get onlySelectedCategoriesCount;

  /// No description provided for @allWalletsAreIncluded.
  ///
  /// In en, this message translates to:
  /// **'All wallets are included'**
  String get allWalletsAreIncluded;

  /// No description provided for @onlySelectedWalletsCount.
  ///
  /// In en, this message translates to:
  /// **'Only selected wallets count'**
  String get onlySelectedWalletsCount;

  /// No description provided for @enterALimitGreaterThan.
  ///
  /// In en, this message translates to:
  /// **'Enter a limit greater than zero'**
  String get enterALimitGreaterThan;

  /// No description provided for @carryTheLeftoverOver.
  ///
  /// In en, this message translates to:
  /// **'Carry the leftover over'**
  String get carryTheLeftoverOver;

  /// No description provided for @whateverIsUnspentAtThe.
  ///
  /// In en, this message translates to:
  /// **'Whatever is unspent at the end of a {p0} is added to the next one.'**
  String whateverIsUnspentAtThe(Object p0);

  /// No description provided for @searchRecurringItems.
  ///
  /// In en, this message translates to:
  /// **'Search recurring items'**
  String get searchRecurringItems;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions'**
  String get noActiveSubscriptions;

  /// No description provided for @addRecurringPaymentsToSee.
  ///
  /// In en, this message translates to:
  /// **'Add recurring payments to see upcoming charges and monthly cost.'**
  String get addRecurringPaymentsToSee;

  /// No description provided for @subscriptionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Subscription not found'**
  String get subscriptionNotFound;

  /// No description provided for @paymentHistoryRemainsInActivity.
  ///
  /// In en, this message translates to:
  /// **'Payment history remains in Activity. The recurring item leaves the active list.'**
  String get paymentHistoryRemainsInActivity;

  /// No description provided for @noPaymentsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get noPaymentsRecorded;

  /// No description provided for @recordedPaymentsAppearHereAnd.
  ///
  /// In en, this message translates to:
  /// **'Recorded payments appear here and in Activity.'**
  String get recordedPaymentsAppearHereAnd;

  /// No description provided for @walletDebitUsingTheCurrent.
  ///
  /// In en, this message translates to:
  /// **'\n\nWallet debit: ≈ {p0} using the current {p1} rate.'**
  String walletDebitUsingTheCurrent(Object p0, Object p1);

  /// No description provided for @willBeRecordedFrom.
  ///
  /// In en, this message translates to:
  /// **'{p0} will be recorded from {p1}.{p2}'**
  String willBeRecordedFrom(Object p0, Object p1, Object p2);

  /// No description provided for @skipThisPayment.
  ///
  /// In en, this message translates to:
  /// **'Skip this payment?'**
  String get skipThisPayment;

  /// No description provided for @noExpenseIsRecordedThe.
  ///
  /// In en, this message translates to:
  /// **'No expense is recorded. The next due date advances by one billing period.'**
  String get noExpenseIsRecordedThe;

  /// No description provided for @eGSpotify.
  ///
  /// In en, this message translates to:
  /// **'e.g. Spotify'**
  String get eGSpotify;

  /// No description provided for @nameThisSubscription.
  ///
  /// In en, this message translates to:
  /// **'Name this subscription'**
  String get nameThisSubscription;

  /// No description provided for @enterAnAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get enterAnAmount;

  /// No description provided for @monthlyOnDay.
  ///
  /// In en, this message translates to:
  /// **'Monthly on day {p0}'**
  String monthlyOnDay(Object p0);

  /// No description provided for @noCategoryMatches.
  ///
  /// In en, this message translates to:
  /// **'No category matches “{p0}”'**
  String noCategoryMatches(Object p0);

  /// No description provided for @tryADifferentNameOr2.
  ///
  /// In en, this message translates to:
  /// **'Try a different name, or add a new category.'**
  String get tryADifferentNameOr2;

  /// No description provided for @activeAnnualized.
  ///
  /// In en, this message translates to:
  /// **'{p0} active · {p1} annualized'**
  String activeAnnualized(Object p0, Object p1);

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of month'**
  String get dayOfMonth;

  /// No description provided for @aPockitoCategoryItCan.
  ///
  /// In en, this message translates to:
  /// **'A Pockito category — it can be hidden but never deleted, because records may still point at it.'**
  String get aPockitoCategoryItCan;

  /// No description provided for @yourOwnCategory.
  ///
  /// In en, this message translates to:
  /// **'Your own category'**
  String get yourOwnCategory;

  /// No description provided for @nestUnderAnotherCategory.
  ///
  /// In en, this message translates to:
  /// **'Nest under another category'**
  String get nestUnderAnotherCategory;

  /// No description provided for @itReappearsInPickersAnd.
  ///
  /// In en, this message translates to:
  /// **'It reappears in pickers and filters.'**
  String get itReappearsInPickersAnd;

  /// No description provided for @itStaysOnEveryRecord.
  ///
  /// In en, this message translates to:
  /// **'It stays on every record that already uses it, and stops appearing in pickers.'**
  String get itStaysOnEveryRecord;

  /// No description provided for @isVisibleAgain.
  ///
  /// In en, this message translates to:
  /// **'{p0} is visible again'**
  String isVisibleAgain(Object p0);

  /// No description provided for @isTopLevelAgain.
  ///
  /// In en, this message translates to:
  /// **'{p0} is top-level again'**
  String isTopLevelAgain(Object p0);

  /// No description provided for @categoriesOnlyNestOneLevel.
  ///
  /// In en, this message translates to:
  /// **'Categories only nest one level deep.'**
  String get categoriesOnlyNestOneLevel;

  /// No description provided for @hasItsOwnSubcategoriesSo.
  ///
  /// In en, this message translates to:
  /// **'{p0} has its own subcategories, so it cannot become one.'**
  String hasItsOwnSubcategoriesSo(Object p0);

  /// No description provided for @reassignBeforeDeleting.
  ///
  /// In en, this message translates to:
  /// **'Reassign before deleting'**
  String get reassignBeforeDeleting;

  /// No description provided for @isUsedByExistingMoney.
  ///
  /// In en, this message translates to:
  /// **'{p0} is used by existing money events. Choose where they should move.'**
  String isUsedByExistingMoney(Object p0);

  /// No description provided for @reassignAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Reassign and delete'**
  String get reassignAndDelete;

  /// No description provided for @everythingBeyondYourDayTo.
  ///
  /// In en, this message translates to:
  /// **'Everything beyond your day-to-day money'**
  String get everythingBeyondYourDayTo;

  /// No description provided for @cutAcrossCategoriesBerlinTrip.
  ///
  /// In en, this message translates to:
  /// **'Cut across categories — “Berlin trip”, “Work”'**
  String get cutAcrossCategoriesBerlinTrip;

  /// No description provided for @answerHowMuchWentOn.
  ///
  /// In en, this message translates to:
  /// **'Answer “how much went on the Amex”'**
  String get answerHowMuchWentOn;

  /// No description provided for @netWorthAndThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Net worth and this month, at a glance'**
  String get netWorthAndThisMonth;

  /// No description provided for @csvInCsvOrJson.
  ///
  /// In en, this message translates to:
  /// **'CSV in, CSV or JSON out'**
  String get csvInCsvOrJson;

  /// No description provided for @budgetsSharedMoneyAndApprovals.
  ///
  /// In en, this message translates to:
  /// **'Budgets, shared money and approvals'**
  String get budgetsSharedMoneyAndApprovals;

  /// No description provided for @replayOnboardingPreviewAnInvite.
  ///
  /// In en, this message translates to:
  /// **'Replay onboarding, preview an invite, browse the state catalogue'**
  String get replayOnboardingPreviewAnInvite;

  /// No description provided for @exploreTheFirstRunExperience.
  ///
  /// In en, this message translates to:
  /// **'Explore the first-run experience'**
  String get exploreTheFirstRunExperience;

  /// No description provided for @previewAnIncomingSpaceInvite.
  ///
  /// In en, this message translates to:
  /// **'Preview an incoming space invite'**
  String get previewAnIncomingSpaceInvite;

  /// No description provided for @loadingEmptyErrorAndOffline.
  ///
  /// In en, this message translates to:
  /// **'Loading, empty, error and offline'**
  String get loadingEmptyErrorAndOffline;

  /// No description provided for @resetPrototypeData.
  ///
  /// In en, this message translates to:
  /// **'Reset prototype data'**
  String get resetPrototypeData;

  /// No description provided for @resetAllPrototypeData.
  ///
  /// In en, this message translates to:
  /// **'Reset all prototype data?'**
  String get resetAllPrototypeData;

  /// No description provided for @everyLocalChangeIsReplaced.
  ///
  /// In en, this message translates to:
  /// **'Every local change is replaced with the original coherent Pockito fixture data.'**
  String get everyLocalChangeIsReplaced;

  /// No description provided for @prototypeDataReset.
  ///
  /// In en, this message translates to:
  /// **'Prototype data reset'**
  String get prototypeDataReset;

  /// No description provided for @avatarColoursRotateLocallyIn.
  ///
  /// In en, this message translates to:
  /// **'Avatar colours rotate locally in this prototype'**
  String get avatarColoursRotateLocallyIn;

  /// No description provided for @thisChangesReportingTotalsOnly.
  ///
  /// In en, this message translates to:
  /// **'This changes reporting totals only. Account and space currencies never change silently.'**
  String get thisChangesReportingTotalsOnly;

  /// No description provided for @howShouldPockitoConvertCurrencies.
  ///
  /// In en, this message translates to:
  /// **'How should Pockito convert currencies?'**
  String get howShouldPockitoConvertCurrencies;

  /// No description provided for @originalAmountsAreAlwaysPreserved.
  ///
  /// In en, this message translates to:
  /// **'Original amounts are always preserved. Converted totals are approximate and carry the captured rate.'**
  String get originalAmountsAreAlwaysPreserved;

  /// No description provided for @automaticSnapshotActive.
  ///
  /// In en, this message translates to:
  /// **'Automatic snapshot active'**
  String get automaticSnapshotActive;

  /// No description provided for @mockedLocallyForThePrototype.
  ///
  /// In en, this message translates to:
  /// **'Mocked locally for the prototype; no live FX service is called.'**
  String get mockedLocallyForThePrototype;

  /// No description provided for @manualRatesRemainActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Manual rates remain active until you switch back. Transfers cannot be saved when a required pair has no valid rate.'**
  String get manualRatesRemainActiveUntil;

  /// No description provided for @yourManualRate.
  ///
  /// In en, this message translates to:
  /// **'Your manual {p0} → {p1} rate'**
  String yourManualRate(Object p0, Object p1);

  /// No description provided for @saveManualRates.
  ///
  /// In en, this message translates to:
  /// **'Save manual rates'**
  String get saveManualRates;

  /// No description provided for @enterAValidRateFor.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid rate for {p0}'**
  String enterAValidRateFor(Object p0);

  /// No description provided for @manualExchangeRatesSaved.
  ///
  /// In en, this message translates to:
  /// **'Manual exchange rates saved'**
  String get manualExchangeRatesSaved;

  /// No description provided for @followYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Follow your device'**
  String get followYourDevice;

  /// No description provided for @alwaysUseMode.
  ///
  /// In en, this message translates to:
  /// **'Always use {p0} mode'**
  String alwaysUseMode(Object p0);

  /// No description provided for @typographyBordersAndSemanticColours.
  ///
  /// In en, this message translates to:
  /// **'Typography, borders and semantic colours adapt together.'**
  String get typographyBordersAndSemanticColours;

  /// No description provided for @notificationPreviewEnabled.
  ///
  /// In en, this message translates to:
  /// **'Notification preview enabled'**
  String get notificationPreviewEnabled;

  /// No description provided for @noSystemPermissionIsRequested.
  ///
  /// In en, this message translates to:
  /// **'No system permission is requested in this prototype.'**
  String get noSystemPermissionIsRequested;

  /// No description provided for @kitoTheOfficialPockitoMascot.
  ///
  /// In en, this message translates to:
  /// **'Kito, the official Pockito mascot'**
  String get kitoTheOfficialPockitoMascot;

  /// No description provided for @moneyWithKitoPrototype.
  ///
  /// In en, this message translates to:
  /// **'Money, with Kito · Prototype 0.1.0'**
  String get moneyWithKitoPrototype;

  /// No description provided for @pockitoGivesPersonalAndShared.
  ///
  /// In en, this message translates to:
  /// **'Pockito gives personal and shared money one coherent home. Kito is the calm, helpful companion for insights, empty states and meaningful milestones. This Flutter build uses local fixture data only.'**
  String get pockitoGivesPersonalAndShared;

  /// No description provided for @noPersonalDataLeavesThis.
  ///
  /// In en, this message translates to:
  /// **'No personal data leaves this local prototype.'**
  String get noPersonalDataLeavesThis;

  /// No description provided for @prototypeTermsAreIntentionallyLocal.
  ///
  /// In en, this message translates to:
  /// **'Prototype terms are intentionally local and illustrative.'**
  String get prototypeTermsAreIntentionallyLocal;

  /// No description provided for @sharedExpensesBudgetAlertsAnd.
  ///
  /// In en, this message translates to:
  /// **'Shared expenses, budget alerts and approvals will appear here.'**
  String get sharedExpensesBudgetAlertsAnd;

  /// No description provided for @homeScreenStates.
  ///
  /// In en, this message translates to:
  /// **'Home screen states'**
  String get homeScreenStates;

  /// No description provided for @chooseAStateReturnHome.
  ///
  /// In en, this message translates to:
  /// **'Choose a state, return Home, and inspect the production treatment.'**
  String get chooseAStateReturnHome;

  /// No description provided for @purposefulEmptyState.
  ///
  /// In en, this message translates to:
  /// **'Purposeful empty state'**
  String get purposefulEmptyState;

  /// No description provided for @everyEmptySurfaceExplainsWhat.
  ///
  /// In en, this message translates to:
  /// **'Every empty surface explains what belongs here and offers a meaningful next action.'**
  String get everyEmptySurfaceExplainsWhat;

  /// No description provided for @coherentFixtureData.
  ///
  /// In en, this message translates to:
  /// **'Coherent fixture data'**
  String get coherentFixtureData;

  /// No description provided for @recoverableFullScreenError.
  ///
  /// In en, this message translates to:
  /// **'Recoverable full-screen error'**
  String get recoverableFullScreenError;

  /// No description provided for @welcomeToPockito.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pockito'**
  String get welcomeToPockito;

  /// No description provided for @personalAndSharedMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Personal and shared money in one coherent place.'**
  String get personalAndSharedMoneyIn;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @youExampleCom.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get youExampleCom;

  /// No description provided for @continueWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// No description provided for @previewAuthenticationError.
  ///
  /// In en, this message translates to:
  /// **'Preview authentication error'**
  String get previewAuthenticationError;

  /// No description provided for @authenticationIsSimulatedLocallyIn.
  ///
  /// In en, this message translates to:
  /// **'Authentication is simulated locally in this UI prototype.'**
  String get authenticationIsSimulatedLocallyIn;

  /// No description provided for @weCouldnTSignYou.
  ///
  /// In en, this message translates to:
  /// **'We couldn’t sign you in'**
  String get weCouldnTSignYou;

  /// No description provided for @nothingWasChangedCheckYour.
  ///
  /// In en, this message translates to:
  /// **'Nothing was changed. Check your connection and try again, or choose another sign-in method.'**
  String get nothingWasChangedCheckYour;

  /// No description provided for @returnToPrototype.
  ///
  /// In en, this message translates to:
  /// **'Return to prototype'**
  String get returnToPrototype;

  /// No description provided for @moneyThatMakesSense.
  ///
  /// In en, this message translates to:
  /// **'Money that makes sense'**
  String get moneyThatMakesSense;

  /// No description provided for @seeYourOwnAccountsAnd.
  ///
  /// In en, this message translates to:
  /// **'See your own accounts and the money you share, without double-counting either.'**
  String get seeYourOwnAccountsAnd;

  /// No description provided for @makePockitoYours.
  ///
  /// In en, this message translates to:
  /// **'Make Pockito yours'**
  String get makePockitoYours;

  /// No description provided for @setTheIdentityAndDefaults.
  ///
  /// In en, this message translates to:
  /// **'Set the identity and defaults people will see in shared spaces. You can change these later.'**
  String get setTheIdentityAndDefaults;

  /// No description provided for @localProfileAvatar.
  ///
  /// In en, this message translates to:
  /// **'local://profile/avatar'**
  String get localProfileAvatar;

  /// No description provided for @chooseProfilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose profile photo'**
  String get chooseProfilePhoto;

  /// No description provided for @photoSelectedLocally.
  ///
  /// In en, this message translates to:
  /// **'Photo selected locally'**
  String get photoSelectedLocally;

  /// No description provided for @useDeviceSetting.
  ///
  /// In en, this message translates to:
  /// **'Use device setting'**
  String get useDeviceSetting;

  /// No description provided for @setYourHomeBase.
  ///
  /// In en, this message translates to:
  /// **'Set your home base'**
  String get setYourHomeBase;

  /// No description provided for @thisOnlyControlsReportingEvery.
  ///
  /// In en, this message translates to:
  /// **'This only controls reporting. Every account and space keeps its own currency.'**
  String get thisOnlyControlsReportingEvery;

  /// No description provided for @givePockitoOnePlaceWhere.
  ///
  /// In en, this message translates to:
  /// **'Give Pockito one place where money enters and leaves.'**
  String get givePockitoOnePlaceWhere;

  /// No description provided for @useTheSampleAccount.
  ///
  /// In en, this message translates to:
  /// **'Use the sample account'**
  String get useTheSampleAccount;

  /// No description provided for @shareMoneyWithSomeone.
  ///
  /// In en, this message translates to:
  /// **'Share money with someone?'**
  String get shareMoneyWithSomeone;

  /// No description provided for @createASpaceForA2.
  ///
  /// In en, this message translates to:
  /// **'Create a space for a home, trip, couple or group. You can always do this later.'**
  String get createASpaceForA2;

  /// No description provided for @yesCreateASharedSpace.
  ///
  /// In en, this message translates to:
  /// **'Yes, create a shared space'**
  String get yesCreateASharedSpace;

  /// No description provided for @notRightNow.
  ///
  /// In en, this message translates to:
  /// **'Not right now'**
  String get notRightNow;

  /// No description provided for @spacesAreReadyWhenYou.
  ///
  /// In en, this message translates to:
  /// **'Spaces are ready when you are'**
  String get spacesAreReadyWhenYou;

  /// No description provided for @shareThisLinkTheInvite.
  ///
  /// In en, this message translates to:
  /// **'Share this link. The invite expires in seven days and can be revoked.'**
  String get shareThisLinkTheInvite;

  /// No description provided for @youCanCreateAShared.
  ///
  /// In en, this message translates to:
  /// **'You can create a shared space from the Spaces tab at any time.'**
  String get youCanCreateAShared;

  /// No description provided for @pockitoWorksBeautifullyForPersonal.
  ///
  /// In en, this message translates to:
  /// **'Pockito works beautifully for personal money too.'**
  String get pockitoWorksBeautifullyForPersonal;

  /// No description provided for @youReAllSet.
  ///
  /// In en, this message translates to:
  /// **'You’re all set'**
  String get youReAllSet;

  /// No description provided for @yourOverviewAccountsSharedSpaces.
  ///
  /// In en, this message translates to:
  /// **'Your overview, accounts, shared spaces and activity are ready to explore.'**
  String get yourOverviewAccountsSharedSpaces;

  /// No description provided for @enterYourNameToContinue.
  ///
  /// In en, this message translates to:
  /// **'Enter your name to continue'**
  String get enterYourNameToContinue;

  /// No description provided for @addAnAccountNameAnd.
  ///
  /// In en, this message translates to:
  /// **'Add an account name and valid balance'**
  String get addAnAccountNameAnd;

  /// No description provided for @joinBookClub.
  ///
  /// In en, this message translates to:
  /// **'Join Book Club?'**
  String get joinBookClub;

  /// No description provided for @samInvitedYouToA.
  ///
  /// In en, this message translates to:
  /// **'Sam invited you to a 4-person shared space using EUR.'**
  String get samInvitedYouToA;

  /// No description provided for @joinedBookClubLocally.
  ///
  /// In en, this message translates to:
  /// **'Joined Book Club locally'**
  String get joinedBookClubLocally;

  /// No description provided for @whatLeftYourAccounts.
  ///
  /// In en, this message translates to:
  /// **'What left your accounts'**
  String get whatLeftYourAccounts;

  /// No description provided for @onlyYourShare.
  ///
  /// In en, this message translates to:
  /// **'Only your share'**
  String get onlyYourShare;

  /// No description provided for @aCompleteSampleDatasetIs.
  ///
  /// In en, this message translates to:
  /// **'A complete sample dataset is ready'**
  String get aCompleteSampleDatasetIs;

  /// No description provided for @youCanAddEditSplit.
  ///
  /// In en, this message translates to:
  /// **'You can add, edit, split, settle and explore without connecting any real financial service.'**
  String get youCanAddEditSplit;

  /// No description provided for @confirmSettlement.
  ///
  /// In en, this message translates to:
  /// **'Confirm settlement'**
  String get confirmSettlement;

  /// No description provided for @expenseCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expense} other{{count} expenses}}'**
  String expenseCount(int count);

  /// No description provided for @settlementCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 settlement} other{{count} settlements}}'**
  String settlementCount(int count);

  /// No description provided for @paymentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment} other{{count} payments}}'**
  String paymentCount(int count);

  /// No description provided for @cycleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 previous cycle} other{{count} previous cycles}}'**
  String cycleCount(int count);

  /// No description provided for @recordCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 record} other{{count} records}}'**
  String recordCount(int count);

  /// No description provided for @activeAccountCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active account} other{{count} active accounts}}'**
  String activeAccountCount(int count);

  /// No description provided for @memberCountPlain.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String memberCountPlain(int count);

  /// No description provided for @peopleCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 person} other{{count} people}}'**
  String peopleCount(int count);

  /// No description provided for @connectionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 connection} other{{count} connections}}'**
  String connectionCount(int count);

  /// No description provided for @budgetCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active budget} other{{count} active budgets}}'**
  String budgetCount(int count);

  /// No description provided for @categoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 category} other{{count} categories}}'**
  String categoryCount(int count);

  /// No description provided for @methodCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment method} other{{count} payment methods}}'**
  String methodCount(int count);

  /// No description provided for @savedViewCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 saved} other{{count} saved}}'**
  String savedViewCount(int count);

  /// No description provided for @activeSubscriptionCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active} other{{count} active}}'**
  String activeSubscriptionCount(int count);

  /// No description provided for @tagCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tag} other{{count} tags}}'**
  String tagCount(int count);

  /// No description provided for @chooseAnAccountX.
  ///
  /// In en, this message translates to:
  /// **'Choose an account'**
  String get chooseAnAccountX;

  /// No description provided for @exportsExactlyWhatActivityIs.
  ///
  /// In en, this message translates to:
  /// **'Exports exactly what Activity is showing right now — {p0} after your filters, not the whole ledger.'**
  String exportsExactlyWhatActivityIs(Object p0);

  /// No description provided for @readFromThisReceipt.
  ///
  /// In en, this message translates to:
  /// **'Read from this receipt: {p0}'**
  String readFromThisReceipt(Object p0);

  /// No description provided for @spendingByCategory.
  ///
  /// In en, this message translates to:
  /// **'Spending by category. {p0}'**
  String spendingByCategory(Object p0);

  /// No description provided for @trendFromTo.
  ///
  /// In en, this message translates to:
  /// **'Trend from {p0} to {p1}. {p2}'**
  String trendFromTo(Object p0, Object p1, Object p2);

  /// No description provided for @nobodyMatches.
  ///
  /// In en, this message translates to:
  /// **'Nobody matches “{p0}”'**
  String nobodyMatches(Object p0);

  /// No description provided for @nothingMatchesQuery.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{p0}”.'**
  String nothingMatchesQuery(Object p0);

  /// No description provided for @searchCategoriesCount.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} categories'**
  String searchCategoriesCount(Object p0);

  /// No description provided for @proposedByAwaiting.
  ///
  /// In en, this message translates to:
  /// **'Proposed by {p0} · awaiting {p1} confirmation'**
  String proposedByAwaiting(Object p0, Object p1);

  /// No description provided for @moveOutOf.
  ///
  /// In en, this message translates to:
  /// **'Move out of {p0}'**
  String moveOutOf(Object p0);

  /// No description provided for @yourWord.
  ///
  /// In en, this message translates to:
  /// **'your'**
  String get yourWord;

  /// No description provided for @theirWord.
  ///
  /// In en, this message translates to:
  /// **'their'**
  String get theirWord;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @confirmedWord.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedWord;

  /// No description provided for @cancelledWord.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledWord;

  /// No description provided for @moveOutOfParent.
  ///
  /// In en, this message translates to:
  /// **'Move out of {p0}'**
  String moveOutOfParent(Object p0);

  /// No description provided for @unverifiedClient.
  ///
  /// In en, this message translates to:
  /// **'Unverified client'**
  String get unverifiedClient;

  /// No description provided for @animatedSkeletons.
  ///
  /// In en, this message translates to:
  /// **'Animated skeletons'**
  String get animatedSkeletons;

  /// No description provided for @firstUseGuidance.
  ///
  /// In en, this message translates to:
  /// **'First-use guidance'**
  String get firstUseGuidance;

  /// No description provided for @localModeBanner.
  ///
  /// In en, this message translates to:
  /// **'Local-mode banner'**
  String get localModeBanner;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @aiApp.
  ///
  /// In en, this message translates to:
  /// **'AI app'**
  String get aiApp;

  /// No description provided for @kitoNoticed.
  ///
  /// In en, this message translates to:
  /// **'Kito noticed'**
  String get kitoNoticed;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get goodEvening;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @x0Over.
  ///
  /// In en, this message translates to:
  /// **'{p0} over'**
  String x0Over(Object p0);

  /// No description provided for @x0Left.
  ///
  /// In en, this message translates to:
  /// **'{p0} left'**
  String x0Left(Object p0);

  /// No description provided for @x0X1OfX2X3X4.
  ///
  /// In en, this message translates to:
  /// **'{p0}: {p1} of {p2}. {p3}. {p4}'**
  String x0X1OfX2X3X4(Object p0, Object p1, Object p2, Object p3, Object p4);

  /// No description provided for @ofX0.
  ///
  /// In en, this message translates to:
  /// **'of {p0}'**
  String ofX0(Object p0);

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @youReOwed.
  ///
  /// In en, this message translates to:
  /// **'You\'re owed'**
  String get youReOwed;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get youOwe;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @uncategorised.
  ///
  /// In en, this message translates to:
  /// **'Uncategorised'**
  String get uncategorised;

  /// No description provided for @shared.
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get shared;

  /// No description provided for @yourShareX0.
  ///
  /// In en, this message translates to:
  /// **'Your share {p0}'**
  String yourShareX0(Object p0);

  /// No description provided for @x0OfX1X2.
  ///
  /// In en, this message translates to:
  /// **'{p0} of {p1} · {p2}'**
  String x0OfX1X2(Object p0, Object p1, Object p2);

  /// No description provided for @lastX0.
  ///
  /// In en, this message translates to:
  /// **'last {p0}'**
  String lastX0(Object p0);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add money'**
  String get addMoney;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @betweenAccounts.
  ///
  /// In en, this message translates to:
  /// **'Between accounts'**
  String get betweenAccounts;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @x0Results.
  ///
  /// In en, this message translates to:
  /// **'{p0} results'**
  String x0Results(Object p0);

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @lastWeek.
  ///
  /// In en, this message translates to:
  /// **'Last week'**
  String get lastWeek;

  /// No description provided for @searchAccounts.
  ///
  /// In en, this message translates to:
  /// **'Search accounts'**
  String get searchAccounts;

  /// No description provided for @searchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories'**
  String get searchCategories;

  /// No description provided for @inX0.
  ///
  /// In en, this message translates to:
  /// **'in {p0}'**
  String inX0(Object p0);

  /// No description provided for @searchX0Currencies.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} currencies'**
  String searchX0Currencies(Object p0);

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @x0You.
  ///
  /// In en, this message translates to:
  /// **'{p0} (you)'**
  String x0You(Object p0);

  /// No description provided for @searchMembers.
  ///
  /// In en, this message translates to:
  /// **'Search members'**
  String get searchMembers;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @newTag.
  ///
  /// In en, this message translates to:
  /// **'New tag'**
  String get newTag;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @voidedX0.
  ///
  /// In en, this message translates to:
  /// **'Voided {p0}.'**
  String voidedX0(Object p0);

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @attach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get attach;

  /// No description provided for @removeX0.
  ///
  /// In en, this message translates to:
  /// **'Remove {p0}'**
  String removeX0(Object p0);

  /// No description provided for @queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get queued;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get reading;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @unreadable.
  ///
  /// In en, this message translates to:
  /// **'Unreadable'**
  String get unreadable;

  /// No description provided for @capturedX0.
  ///
  /// In en, this message translates to:
  /// **'Captured {p0}'**
  String capturedX0(Object p0);

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @youCanTX0.
  ///
  /// In en, this message translates to:
  /// **'You can’t {p0}'**
  String youCanTX0(Object p0);

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get saving;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @payX0.
  ///
  /// In en, this message translates to:
  /// **'Pay {p0}?'**
  String payX0(Object p0);

  /// No description provided for @x0WillBeRecordedFromX1ThisIsLocalPrototypeDa.
  ///
  /// In en, this message translates to:
  /// **'{p0} will be recorded from {p1}. This is local prototype data.'**
  String x0WillBeRecordedFromX1ThisIsLocalPrototypeDa(Object p0, Object p1);

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get recordPayment;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get assistant;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @addAccount.
  ///
  /// In en, this message translates to:
  /// **'Add account'**
  String get addAccount;

  /// No description provided for @createSpace.
  ///
  /// In en, this message translates to:
  /// **'Create space'**
  String get createSpace;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @overdueByX0DayX1.
  ///
  /// In en, this message translates to:
  /// **'Overdue by {p0} day{p1}'**
  String overdueByX0DayX1(Object p0, Object p1);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @chooseMonth.
  ///
  /// In en, this message translates to:
  /// **'Choose month'**
  String get chooseMonth;

  /// No description provided for @x0MoneyEventX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} money event{p1}'**
  String x0MoneyEventX1(Object p0, Object p1);

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @tag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get paymentMethod;

  /// No description provided for @includingVoided.
  ///
  /// In en, this message translates to:
  /// **'Including voided'**
  String get includingVoided;

  /// No description provided for @draftsHidden.
  ///
  /// In en, this message translates to:
  /// **'Drafts hidden'**
  String get draftsHidden;

  /// No description provided for @savedX0.
  ///
  /// In en, this message translates to:
  /// **'Saved “{p0}”'**
  String savedX0(Object p0);

  /// No description provided for @savedViews.
  ///
  /// In en, this message translates to:
  /// **'Saved views'**
  String get savedViews;

  /// No description provided for @deleteX0.
  ///
  /// In en, this message translates to:
  /// **'Delete {p0}'**
  String deleteX0(Object p0);

  /// No description provided for @moneyEvent.
  ///
  /// In en, this message translates to:
  /// **'Money event'**
  String get moneyEvent;

  /// No description provided for @restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get restored;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @notTracked.
  ///
  /// In en, this message translates to:
  /// **'Not tracked'**
  String get notTracked;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @received.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get exchangeRate;

  /// No description provided for @rateCaptured.
  ///
  /// In en, this message translates to:
  /// **'Rate captured'**
  String get rateCaptured;

  /// No description provided for @fee.
  ///
  /// In en, this message translates to:
  /// **'Fee'**
  String get fee;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get none;

  /// No description provided for @sharedSpace.
  ///
  /// In en, this message translates to:
  /// **'Shared space'**
  String get sharedSpace;

  /// No description provided for @addedVia.
  ///
  /// In en, this message translates to:
  /// **'Added via'**
  String get addedVia;

  /// No description provided for @aiConnection.
  ///
  /// In en, this message translates to:
  /// **'AI connection'**
  String get aiConnection;

  /// No description provided for @paidWith.
  ///
  /// In en, this message translates to:
  /// **'Paid with'**
  String get paidWith;

  /// No description provided for @originalAmount.
  ///
  /// In en, this message translates to:
  /// **'Original amount'**
  String get originalAmount;

  /// No description provided for @rateUsed.
  ///
  /// In en, this message translates to:
  /// **'Rate used'**
  String get rateUsed;

  /// No description provided for @correctionReason.
  ///
  /// In en, this message translates to:
  /// **'Correction reason'**
  String get correctionReason;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @receipts.
  ///
  /// In en, this message translates to:
  /// **'Receipts'**
  String get receipts;

  /// No description provided for @settlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get settlement;

  /// No description provided for @whyOptional.
  ///
  /// In en, this message translates to:
  /// **'Why? (optional)'**
  String get whyOptional;

  /// No description provided for @voidIt.
  ///
  /// In en, this message translates to:
  /// **'Void it'**
  String get voidIt;

  /// No description provided for @voidedX02.
  ///
  /// In en, this message translates to:
  /// **'Voided {p0}'**
  String voidedX02(Object p0);

  /// No description provided for @youReOffline.
  ///
  /// In en, this message translates to:
  /// **'You’re offline'**
  String get youReOffline;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @merchant.
  ///
  /// In en, this message translates to:
  /// **'Merchant'**
  String get merchant;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @toAccount.
  ///
  /// In en, this message translates to:
  /// **'To account'**
  String get toAccount;

  /// No description provided for @fromAccount.
  ///
  /// In en, this message translates to:
  /// **'From account'**
  String get fromAccount;

  /// No description provided for @automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get automatic;

  /// No description provided for @manual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// No description provided for @l1X0InX1.
  ///
  /// In en, this message translates to:
  /// **'1 {p0} in {p1}'**
  String l1X0InX1(Object p0, Object p1);

  /// No description provided for @x0UpdatedX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} · updated {p1}'**
  String x0UpdatedX1(Object p0, Object p1);

  /// No description provided for @feeOptional.
  ///
  /// In en, this message translates to:
  /// **'Fee (optional)'**
  String get feeOptional;

  /// No description provided for @destinationReceives.
  ///
  /// In en, this message translates to:
  /// **'Destination receives'**
  String get destinationReceives;

  /// No description provided for @fromX0X1Rate.
  ///
  /// In en, this message translates to:
  /// **'≈ from {p0} · {p1} rate'**
  String fromX0X1Rate(Object p0, Object p1);

  /// No description provided for @notRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get notRecorded;

  /// No description provided for @paidBy.
  ///
  /// In en, this message translates to:
  /// **'Paid by'**
  String get paidBy;

  /// No description provided for @split.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get split;

  /// No description provided for @walletConversion.
  ///
  /// In en, this message translates to:
  /// **'Wallet conversion'**
  String get walletConversion;

  /// No description provided for @x0SpaceAmount.
  ///
  /// In en, this message translates to:
  /// **'{p0} space amount'**
  String x0SpaceAmount(Object p0);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @addTransfer.
  ///
  /// In en, this message translates to:
  /// **'Add transfer'**
  String get addTransfer;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @spaceDefault6040.
  ///
  /// In en, this message translates to:
  /// **'Space default · 60/40'**
  String get spaceDefault6040;

  /// No description provided for @equallyBetweenX0.
  ///
  /// In en, this message translates to:
  /// **'Equally between {p0}'**
  String equallyBetweenX0(Object p0);

  /// No description provided for @x0x1X2People.
  ///
  /// In en, this message translates to:
  /// **'{p0}{p1} · {p2} people'**
  String x0x1X2People(Object p0, Object p1, Object p2);

  /// No description provided for @receiptX0.
  ///
  /// In en, this message translates to:
  /// **'Receipt · {p0}'**
  String receiptX0(Object p0);

  /// No description provided for @reviewReceipt.
  ///
  /// In en, this message translates to:
  /// **'Review receipt'**
  String get reviewReceipt;

  /// No description provided for @scanReceipt.
  ///
  /// In en, this message translates to:
  /// **'Scan receipt'**
  String get scanReceipt;

  /// No description provided for @closeScanner.
  ///
  /// In en, this message translates to:
  /// **'Close scanner'**
  String get closeScanner;

  /// No description provided for @captureReceipt.
  ///
  /// In en, this message translates to:
  /// **'Capture receipt'**
  String get captureReceipt;

  /// No description provided for @lowConfidenceMode.
  ///
  /// In en, this message translates to:
  /// **'Low-confidence mode ✓'**
  String get lowConfidenceMode;

  /// No description provided for @failureMode.
  ///
  /// In en, this message translates to:
  /// **'Failure mode ✓'**
  String get failureMode;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @retryScan.
  ///
  /// In en, this message translates to:
  /// **'Retry scan'**
  String get retryScan;

  /// No description provided for @unreadableReceipt.
  ///
  /// In en, this message translates to:
  /// **'Unreadable receipt'**
  String get unreadableReceipt;

  /// No description provided for @filterActivity.
  ///
  /// In en, this message translates to:
  /// **'Filter activity'**
  String get filterActivity;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// No description provided for @previousMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get previousMonth;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @searchSpaces.
  ///
  /// In en, this message translates to:
  /// **'Search Spaces'**
  String get searchSpaces;

  /// No description provided for @searchTags.
  ///
  /// In en, this message translates to:
  /// **'Search tags'**
  String get searchTags;

  /// No description provided for @lifecycle.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle'**
  String get lifecycle;

  /// No description provided for @showVoided.
  ///
  /// In en, this message translates to:
  /// **'Show voided'**
  String get showVoided;

  /// No description provided for @showDrafts.
  ///
  /// In en, this message translates to:
  /// **'Show drafts'**
  String get showDrafts;

  /// No description provided for @showEverything.
  ///
  /// In en, this message translates to:
  /// **'Show everything'**
  String get showEverything;

  /// No description provided for @applyX0Filters.
  ///
  /// In en, this message translates to:
  /// **'Apply {p0} filters'**
  String applyX0Filters(Object p0);

  /// No description provided for @splitExpense.
  ///
  /// In en, this message translates to:
  /// **'Split expense'**
  String get splitExpense;

  /// No description provided for @x0InX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} in {p1}'**
  String x0InX1(Object p0, Object p1);

  /// No description provided for @equal.
  ///
  /// In en, this message translates to:
  /// **'Equal'**
  String get equal;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @shares.
  ///
  /// In en, this message translates to:
  /// **'Shares'**
  String get shares;

  /// No description provided for @exactAmounts.
  ///
  /// In en, this message translates to:
  /// **'Exact amounts'**
  String get exactAmounts;

  /// No description provided for @itemized.
  ///
  /// In en, this message translates to:
  /// **'Itemized'**
  String get itemized;

  /// No description provided for @x0You2.
  ///
  /// In en, this message translates to:
  /// **'{p0} · You'**
  String x0You2(Object p0);

  /// No description provided for @previewSplit.
  ///
  /// In en, this message translates to:
  /// **'Preview split'**
  String get previewSplit;

  /// No description provided for @addLine.
  ///
  /// In en, this message translates to:
  /// **'Add line'**
  String get addLine;

  /// No description provided for @keepEditing.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get keepEditing;

  /// No description provided for @onePayer.
  ///
  /// In en, this message translates to:
  /// **'One payer'**
  String get onePayer;

  /// No description provided for @voidedX03.
  ///
  /// In en, this message translates to:
  /// **'Voided: {p0}'**
  String voidedX03(Object p0);

  /// No description provided for @voidX0.
  ///
  /// In en, this message translates to:
  /// **'Void {p0}?'**
  String voidX0(Object p0);

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @archivedSpaces.
  ///
  /// In en, this message translates to:
  /// **'Archived spaces'**
  String get archivedSpaces;

  /// No description provided for @youOweX0.
  ///
  /// In en, this message translates to:
  /// **'You owe {p0}'**
  String youOweX0(Object p0);

  /// No description provided for @x0OwesYou.
  ///
  /// In en, this message translates to:
  /// **'{p0} owes you'**
  String x0OwesYou(Object p0);

  /// No description provided for @settlementHistory.
  ///
  /// In en, this message translates to:
  /// **'Settlement history'**
  String get settlementHistory;

  /// No description provided for @members2.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members2;

  /// No description provided for @spaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Space settings'**
  String get spaceSettings;

  /// No description provided for @money.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get money;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @x0PreviousX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} previous {p1}'**
  String x0PreviousX1(Object p0, Object p1);

  /// No description provided for @cycleHistory.
  ///
  /// In en, this message translates to:
  /// **'Cycle history'**
  String get cycleHistory;

  /// No description provided for @x0Expenses.
  ///
  /// In en, this message translates to:
  /// **'{p0} expenses'**
  String x0Expenses(Object p0);

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @x0AddedX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} added {p1}'**
  String x0AddedX1(Object p0, Object p1);

  /// No description provided for @balanceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Balance breakdown'**
  String get balanceBreakdown;

  /// No description provided for @paidX0ShareX1.
  ///
  /// In en, this message translates to:
  /// **'Paid {p0} · share {p1}'**
  String paidX0ShareX1(Object p0, Object p1);

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get notYet;

  /// No description provided for @filterExpenses.
  ///
  /// In en, this message translates to:
  /// **'Filter expenses'**
  String get filterExpenses;

  /// No description provided for @unsettled.
  ///
  /// In en, this message translates to:
  /// **'Unsettled'**
  String get unsettled;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get allMembers;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get allCategories;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get applyFilters;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @historicalExpense.
  ///
  /// In en, this message translates to:
  /// **'Historical expense'**
  String get historicalExpense;

  /// No description provided for @recordedBy.
  ///
  /// In en, this message translates to:
  /// **'Recorded by'**
  String get recordedBy;

  /// No description provided for @someone.
  ///
  /// In en, this message translates to:
  /// **'Someone'**
  String get someone;

  /// No description provided for @splitMethod.
  ///
  /// In en, this message translates to:
  /// **'Split method'**
  String get splitMethod;

  /// No description provided for @sharedBudget.
  ///
  /// In en, this message translates to:
  /// **'Shared budget'**
  String get sharedBudget;

  /// No description provided for @inviteSomeone.
  ///
  /// In en, this message translates to:
  /// **'Invite someone'**
  String get inviteSomeone;

  /// No description provided for @spaceName.
  ///
  /// In en, this message translates to:
  /// **'Space name'**
  String get spaceName;

  /// No description provided for @spaceCurrency.
  ///
  /// In en, this message translates to:
  /// **'Space currency'**
  String get spaceCurrency;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @names.
  ///
  /// In en, this message translates to:
  /// **'Names'**
  String get names;

  /// No description provided for @emails.
  ///
  /// In en, this message translates to:
  /// **'Emails'**
  String get emails;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @skipInvitation.
  ///
  /// In en, this message translates to:
  /// **'Skip invitation'**
  String get skipInvitation;

  /// No description provided for @x0Monthly.
  ///
  /// In en, this message translates to:
  /// **'{p0} monthly'**
  String x0Monthly(Object p0);

  /// No description provided for @membersInvites.
  ///
  /// In en, this message translates to:
  /// **'Members & invites'**
  String get membersInvites;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @searchX0Members.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} members'**
  String searchX0Members(Object p0);

  /// No description provided for @pendingInvitesX0.
  ///
  /// In en, this message translates to:
  /// **'Pending invites ({p0})'**
  String pendingInvitesX0(Object p0);

  /// No description provided for @x0AsX1X2X3.
  ///
  /// In en, this message translates to:
  /// **'{p0} · as {p1} · {p2}{p3}'**
  String x0AsX1X2X3(Object p0, Object p1, Object p2, Object p3);

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @revoke.
  ///
  /// In en, this message translates to:
  /// **'Revoke'**
  String get revoke;

  /// No description provided for @x0JoinedAsX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} joined as {p1}'**
  String x0JoinedAsX1(Object p0, Object p1);

  /// No description provided for @simulateAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Simulate acceptance'**
  String get simulateAcceptance;

  /// No description provided for @simulateDecline.
  ///
  /// In en, this message translates to:
  /// **'Simulate decline'**
  String get simulateDecline;

  /// No description provided for @invitationHistory.
  ///
  /// In en, this message translates to:
  /// **'Invitation history'**
  String get invitationHistory;

  /// No description provided for @x0AsX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} · as {p1}'**
  String x0AsX1(Object p0, Object p1);

  /// No description provided for @inviteAgain.
  ///
  /// In en, this message translates to:
  /// **'Invite again'**
  String get inviteAgain;

  /// No description provided for @keepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get keepIt;

  /// No description provided for @viewBalances.
  ///
  /// In en, this message translates to:
  /// **'View balances'**
  String get viewBalances;

  /// No description provided for @changeRole.
  ///
  /// In en, this message translates to:
  /// **'Change role'**
  String get changeRole;

  /// No description provided for @currentlyX0.
  ///
  /// In en, this message translates to:
  /// **'Currently {p0}'**
  String currentlyX0(Object p0);

  /// No description provided for @leaveX0.
  ///
  /// In en, this message translates to:
  /// **'Leave {p0}'**
  String leaveX0(Object p0);

  /// No description provided for @x0SRole.
  ///
  /// In en, this message translates to:
  /// **'{p0}’s role'**
  String x0SRole(Object p0);

  /// No description provided for @leaveX02.
  ///
  /// In en, this message translates to:
  /// **'Leave {p0}?'**
  String leaveX02(Object p0);

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @youLeftX0.
  ///
  /// In en, this message translates to:
  /// **'You left {p0}'**
  String youLeftX0(Object p0);

  /// No description provided for @x0SBalance.
  ///
  /// In en, this message translates to:
  /// **'{p0}’s balance'**
  String x0SBalance(Object p0);

  /// No description provided for @currentCycle.
  ///
  /// In en, this message translates to:
  /// **'Current cycle'**
  String get currentCycle;

  /// No description provided for @lifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetime;

  /// No description provided for @removeX02.
  ///
  /// In en, this message translates to:
  /// **'Remove {p0}?'**
  String removeX02(Object p0);

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @x0Removed.
  ///
  /// In en, this message translates to:
  /// **'{p0} removed'**
  String x0Removed(Object p0);

  /// No description provided for @inviteToX0.
  ///
  /// In en, this message translates to:
  /// **'Invite to {p0}'**
  String inviteToX0(Object p0);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @joinAs.
  ///
  /// In en, this message translates to:
  /// **'Join as'**
  String get joinAs;

  /// No description provided for @x0DayX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} day{p1}'**
  String x0DayX1(Object p0, Object p1);

  /// No description provided for @sendInvite.
  ///
  /// In en, this message translates to:
  /// **'Send invite'**
  String get sendInvite;

  /// No description provided for @defaultSplit.
  ///
  /// In en, this message translates to:
  /// **'Default split'**
  String get defaultSplit;

  /// No description provided for @youAreX0.
  ///
  /// In en, this message translates to:
  /// **'You are {p0}'**
  String youAreX0(Object p0);

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity log'**
  String get activityLog;

  /// No description provided for @newExpenses.
  ///
  /// In en, this message translates to:
  /// **'New expenses'**
  String get newExpenses;

  /// No description provided for @settlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get settlements;

  /// No description provided for @allActivity.
  ///
  /// In en, this message translates to:
  /// **'All activity'**
  String get allActivity;

  /// No description provided for @reopenSpace.
  ///
  /// In en, this message translates to:
  /// **'Reopen Space'**
  String get reopenSpace;

  /// No description provided for @archiveSpace.
  ///
  /// In en, this message translates to:
  /// **'Archive Space'**
  String get archiveSpace;

  /// No description provided for @renameSpace.
  ///
  /// In en, this message translates to:
  /// **'Rename space'**
  String get renameSpace;

  /// No description provided for @exact.
  ///
  /// In en, this message translates to:
  /// **'Exact'**
  String get exact;

  /// No description provided for @archiveX0.
  ///
  /// In en, this message translates to:
  /// **'Archive {p0}?'**
  String archiveX0(Object p0);

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @backToX0.
  ///
  /// In en, this message translates to:
  /// **'Back to {p0}'**
  String backToX0(Object p0);

  /// No description provided for @suggestedPayments.
  ///
  /// In en, this message translates to:
  /// **'Suggested payments'**
  String get suggestedPayments;

  /// No description provided for @x0PayX1X2.
  ///
  /// In en, this message translates to:
  /// **'{p0} pay{p1} {p2}'**
  String x0PayX1X2(Object p0, Object p1, Object p2);

  /// No description provided for @paidFrom.
  ///
  /// In en, this message translates to:
  /// **'Paid from'**
  String get paidFrom;

  /// No description provided for @receivedIn.
  ///
  /// In en, this message translates to:
  /// **'Received in'**
  String get receivedIn;

  /// No description provided for @walletMovement.
  ///
  /// In en, this message translates to:
  /// **'Wallet movement'**
  String get walletMovement;

  /// No description provided for @reviewSettlement.
  ///
  /// In en, this message translates to:
  /// **'Review settlement'**
  String get reviewSettlement;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// No description provided for @x0PaymentX1RemainThisWalletMovementDidNotCou.
  ///
  /// In en, this message translates to:
  /// **'{p0} payment{p1} remain. This wallet movement did not count as spending.'**
  String x0PaymentX1RemainThisWalletMovementDidNotCou(Object p0, Object p1);

  /// No description provided for @x0X1X2Total.
  ///
  /// In en, this message translates to:
  /// **'{p0} {p1} · {p2} total'**
  String x0X1X2Total(Object p0, Object p1, Object p2);

  /// No description provided for @pastSettlements.
  ///
  /// In en, this message translates to:
  /// **'Past settlements'**
  String get pastSettlements;

  /// No description provided for @cycleClosedX0.
  ///
  /// In en, this message translates to:
  /// **'Cycle closed {p0}'**
  String cycleClosedX0(Object p0);

  /// No description provided for @newSettlement.
  ///
  /// In en, this message translates to:
  /// **'New settlement'**
  String get newSettlement;

  /// No description provided for @x0PaidX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} paid {p1}'**
  String x0PaidX1(Object p0, Object p1);

  /// No description provided for @aMember.
  ///
  /// In en, this message translates to:
  /// **'A member'**
  String get aMember;

  /// No description provided for @settlementDetail.
  ///
  /// In en, this message translates to:
  /// **'Settlement detail'**
  String get settlementDetail;

  /// No description provided for @settlementConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Settlement confirmed'**
  String get settlementConfirmed;

  /// No description provided for @settlementCancelled.
  ///
  /// In en, this message translates to:
  /// **'Settlement cancelled'**
  String get settlementCancelled;

  /// No description provided for @x0ConfirmsThisBeforeAnyBalanceMoves.
  ///
  /// In en, this message translates to:
  /// **'{p0} confirms this before any balance moves.'**
  String x0ConfirmsThisBeforeAnyBalanceMoves(Object p0);

  /// No description provided for @onlyX0CanConfirmThis.
  ///
  /// In en, this message translates to:
  /// **'Only {p0} can confirm this'**
  String onlyX0CanConfirmThis(Object p0);

  /// No description provided for @theRecipient.
  ///
  /// In en, this message translates to:
  /// **'The recipient'**
  String get theRecipient;

  /// No description provided for @cancelSettlement.
  ///
  /// In en, this message translates to:
  /// **'Cancel settlement'**
  String get cancelSettlement;

  /// No description provided for @spaceCycles.
  ///
  /// In en, this message translates to:
  /// **'Space cycles'**
  String get spaceCycles;

  /// No description provided for @x0ExpensesX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} expenses · {p1}'**
  String x0ExpensesX1(Object p0, Object p1);

  /// No description provided for @x0OfX1Budget.
  ///
  /// In en, this message translates to:
  /// **'{p0} of {p1} budget'**
  String x0OfX1Budget(Object p0, Object p1);

  /// No description provided for @previousCyclesX0.
  ///
  /// In en, this message translates to:
  /// **'Previous cycles ({p0})'**
  String previousCyclesX0(Object p0);

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @noBudget.
  ///
  /// In en, this message translates to:
  /// **'No budget'**
  String get noBudget;

  /// No description provided for @finalStatus.
  ///
  /// In en, this message translates to:
  /// **'Final status'**
  String get finalStatus;

  /// No description provided for @everyoneSettled.
  ///
  /// In en, this message translates to:
  /// **'Everyone settled'**
  String get everyoneSettled;

  /// No description provided for @memberContributions.
  ///
  /// In en, this message translates to:
  /// **'Member contributions'**
  String get memberContributions;

  /// No description provided for @responsibleForX0.
  ///
  /// In en, this message translates to:
  /// **'Responsible for {p0}'**
  String responsibleForX0(Object p0);

  /// No description provided for @paidX0.
  ///
  /// In en, this message translates to:
  /// **'Paid {p0}'**
  String paidX0(Object p0);

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @expensesX0.
  ///
  /// In en, this message translates to:
  /// **'Expenses ({p0})'**
  String expensesX0(Object p0);

  /// No description provided for @allTimeBalance.
  ///
  /// In en, this message translates to:
  /// **'All-time balance'**
  String get allTimeBalance;

  /// No description provided for @cycle.
  ///
  /// In en, this message translates to:
  /// **'Cycle'**
  String get cycle;

  /// No description provided for @breakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get breakdown;

  /// No description provided for @x0PaidX12.
  ///
  /// In en, this message translates to:
  /// **'{p0} paid · {p1}'**
  String x0PaidX12(Object p0, Object p1);

  /// No description provided for @viaX0.
  ///
  /// In en, this message translates to:
  /// **'via {p0}'**
  String viaX0(Object p0);

  /// No description provided for @x0Activity.
  ///
  /// In en, this message translates to:
  /// **'{p0} activity'**
  String x0Activity(Object p0);

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @detailed.
  ///
  /// In en, this message translates to:
  /// **'Detailed'**
  String get detailed;

  /// No description provided for @accountActions.
  ///
  /// In en, this message translates to:
  /// **'Account actions'**
  String get accountActions;

  /// No description provided for @reorderAccounts.
  ///
  /// In en, this message translates to:
  /// **'Reorder accounts'**
  String get reorderAccounts;

  /// No description provided for @archivedAccounts.
  ///
  /// In en, this message translates to:
  /// **'Archived accounts'**
  String get archivedAccounts;

  /// No description provided for @searchX0Accounts.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} accounts'**
  String searchX0Accounts(Object p0);

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit account'**
  String get editAccount;

  /// No description provided for @archiveAccount.
  ///
  /// In en, this message translates to:
  /// **'Archive account'**
  String get archiveAccount;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @ofX0Limit.
  ///
  /// In en, this message translates to:
  /// **'of {p0} limit'**
  String ofX0Limit(Object p0);

  /// No description provided for @savingsGoal.
  ///
  /// In en, this message translates to:
  /// **'Savings goal'**
  String get savingsGoal;

  /// No description provided for @x0OfX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} of {p1}'**
  String x0OfX1(Object p0, Object p1);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @accountName.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountName;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account type'**
  String get accountType;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @openingBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get openingBalance;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current balance'**
  String get currentBalance;

  /// No description provided for @defaultAccount.
  ///
  /// In en, this message translates to:
  /// **'Default account'**
  String get defaultAccount;

  /// No description provided for @x0Added.
  ///
  /// In en, this message translates to:
  /// **'{p0} added'**
  String x0Added(Object p0);

  /// No description provided for @accountUpdated.
  ///
  /// In en, this message translates to:
  /// **'Account updated'**
  String get accountUpdated;

  /// No description provided for @x0X1Rate.
  ///
  /// In en, this message translates to:
  /// **'≈ {p0} · {p1} rate'**
  String x0X1Rate(Object p0, Object p1);

  /// No description provided for @aiIntegrations.
  ///
  /// In en, this message translates to:
  /// **'AI & integrations'**
  String get aiIntegrations;

  /// No description provided for @connections.
  ///
  /// In en, this message translates to:
  /// **'Connections'**
  String get connections;

  /// No description provided for @lastUsedX0.
  ///
  /// In en, this message translates to:
  /// **'Last used {p0}'**
  String lastUsedX0(Object p0);

  /// No description provided for @authorizationRequest.
  ///
  /// In en, this message translates to:
  /// **'Authorization request'**
  String get authorizationRequest;

  /// No description provided for @verifiedApplication.
  ///
  /// In en, this message translates to:
  /// **'Verified application'**
  String get verifiedApplication;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @spacesBalances.
  ///
  /// In en, this message translates to:
  /// **'Spaces & balances'**
  String get spacesBalances;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @allowX0.
  ///
  /// In en, this message translates to:
  /// **'Allow {p0}'**
  String allowX0(Object p0);

  /// No description provided for @donTAllow.
  ///
  /// In en, this message translates to:
  /// **'Don’t allow'**
  String get donTAllow;

  /// No description provided for @financialChanges.
  ///
  /// In en, this message translates to:
  /// **'Financial changes'**
  String get financialChanges;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No description provided for @lastUsed.
  ///
  /// In en, this message translates to:
  /// **'Last used'**
  String get lastUsed;

  /// No description provided for @reads.
  ///
  /// In en, this message translates to:
  /// **'Reads'**
  String get reads;

  /// No description provided for @writes.
  ///
  /// In en, this message translates to:
  /// **'Writes'**
  String get writes;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @disconnectApp.
  ///
  /// In en, this message translates to:
  /// **'Disconnect app'**
  String get disconnectApp;

  /// No description provided for @connectionPermissions.
  ///
  /// In en, this message translates to:
  /// **'Connection permissions'**
  String get connectionPermissions;

  /// No description provided for @savePermissions.
  ///
  /// In en, this message translates to:
  /// **'Save permissions'**
  String get savePermissions;

  /// No description provided for @disconnectX0.
  ///
  /// In en, this message translates to:
  /// **'Disconnect {p0}?'**
  String disconnectX0(Object p0);

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @aiActivity.
  ///
  /// In en, this message translates to:
  /// **'AI activity'**
  String get aiActivity;

  /// No description provided for @addedX0.
  ///
  /// In en, this message translates to:
  /// **'Added {p0}'**
  String addedX0(Object p0);

  /// No description provided for @pendingApprovals.
  ///
  /// In en, this message translates to:
  /// **'Pending approvals'**
  String get pendingApprovals;

  /// No description provided for @recordedOn.
  ///
  /// In en, this message translates to:
  /// **'Recorded on'**
  String get recordedOn;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @requestRejected.
  ///
  /// In en, this message translates to:
  /// **'Request rejected'**
  String get requestRejected;

  /// No description provided for @addTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTag;

  /// No description provided for @searchX0Tags.
  ///
  /// In en, this message translates to:
  /// **'Search {p0} tags'**
  String searchX0Tags(Object p0);

  /// No description provided for @nothingMatchesX0.
  ///
  /// In en, this message translates to:
  /// **'Nothing matches “{p0}”'**
  String nothingMatchesX0(Object p0);

  /// No description provided for @onX0RecordX1.
  ///
  /// In en, this message translates to:
  /// **'On {p0} record{p1}'**
  String onX0RecordX1(Object p0, Object p1);

  /// No description provided for @renameX0.
  ///
  /// In en, this message translates to:
  /// **'Rename {p0}'**
  String renameX0(Object p0);

  /// No description provided for @tagAdded.
  ///
  /// In en, this message translates to:
  /// **'Tag added'**
  String get tagAdded;

  /// No description provided for @tagRenamed.
  ///
  /// In en, this message translates to:
  /// **'Tag renamed'**
  String get tagRenamed;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @x0Deleted.
  ///
  /// In en, this message translates to:
  /// **'{p0} deleted'**
  String x0Deleted(Object p0);

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get paymentMethods;

  /// No description provided for @addOne.
  ///
  /// In en, this message translates to:
  /// **'Add one'**
  String get addOne;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @bankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank transfer'**
  String get bankTransfer;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @directDebit.
  ///
  /// In en, this message translates to:
  /// **'Direct debit'**
  String get directDebit;

  /// No description provided for @digitalWallet.
  ///
  /// In en, this message translates to:
  /// **'Digital wallet'**
  String get digitalWallet;

  /// No description provided for @x0Records.
  ///
  /// In en, this message translates to:
  /// **'{p0} records'**
  String x0Records(Object p0);

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @importExport.
  ///
  /// In en, this message translates to:
  /// **'Import & export'**
  String get importExport;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @lineX0X1.
  ///
  /// In en, this message translates to:
  /// **'Line {p0} · {p1}'**
  String lineX0X1(Object p0, Object p1);

  /// No description provided for @importX0RecordX1.
  ///
  /// In en, this message translates to:
  /// **'Import {p0} record{p1}'**
  String importX0RecordX1(Object p0, Object p1);

  /// No description provided for @x0Imported.
  ///
  /// In en, this message translates to:
  /// **'{p0} imported'**
  String x0Imported(Object p0);

  /// No description provided for @x0Copied.
  ///
  /// In en, this message translates to:
  /// **'{p0} copied'**
  String x0Copied(Object p0);

  /// No description provided for @correctX0.
  ///
  /// In en, this message translates to:
  /// **'Correct {p0}'**
  String correctX0(Object p0);

  /// No description provided for @balanceCorrected.
  ///
  /// In en, this message translates to:
  /// **'Balance corrected'**
  String get balanceCorrected;

  /// No description provided for @reportingTotal.
  ///
  /// In en, this message translates to:
  /// **'Reporting total'**
  String get reportingTotal;

  /// No description provided for @reportingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Reporting currency'**
  String get reportingCurrency;

  /// No description provided for @notCombined.
  ///
  /// In en, this message translates to:
  /// **'Not combined'**
  String get notCombined;

  /// No description provided for @createBudget.
  ///
  /// In en, this message translates to:
  /// **'Create budget'**
  String get createBudget;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @sharedSpaces.
  ///
  /// In en, this message translates to:
  /// **'Shared spaces'**
  String get sharedSpaces;

  /// No description provided for @editBudget.
  ///
  /// In en, this message translates to:
  /// **'Edit budget'**
  String get editBudget;

  /// No description provided for @deleteBudget.
  ///
  /// In en, this message translates to:
  /// **'Delete budget'**
  String get deleteBudget;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'Used'**
  String get used;

  /// No description provided for @limit.
  ///
  /// In en, this message translates to:
  /// **'Limit'**
  String get limit;

  /// No description provided for @carriedOver.
  ///
  /// In en, this message translates to:
  /// **'Carried over'**
  String get carriedOver;

  /// No description provided for @lastX02.
  ///
  /// In en, this message translates to:
  /// **'Last {p0}'**
  String lastX02(Object p0);

  /// No description provided for @scope.
  ///
  /// In en, this message translates to:
  /// **'Scope'**
  String get scope;

  /// No description provided for @over.
  ///
  /// In en, this message translates to:
  /// **'Over'**
  String get over;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @onTrack.
  ///
  /// In en, this message translates to:
  /// **'On track'**
  String get onTrack;

  /// No description provided for @includedSpending.
  ///
  /// In en, this message translates to:
  /// **'Included spending'**
  String get includedSpending;

  /// No description provided for @monthlyHistory.
  ///
  /// In en, this message translates to:
  /// **'Monthly history'**
  String get monthlyHistory;

  /// No description provided for @allExpenses.
  ///
  /// In en, this message translates to:
  /// **'All expenses'**
  String get allExpenses;

  /// No description provided for @allWallets.
  ///
  /// In en, this message translates to:
  /// **'all wallets'**
  String get allWallets;

  /// No description provided for @x0X1Only.
  ///
  /// In en, this message translates to:
  /// **'{p0} · {p1} only'**
  String x0X1Only(Object p0, Object p1);

  /// No description provided for @deleteX02.
  ///
  /// In en, this message translates to:
  /// **'Delete {p0}?'**
  String deleteX02(Object p0);

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget name'**
  String get budgetName;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @allWallets2.
  ///
  /// In en, this message translates to:
  /// **'All wallets'**
  String get allWallets2;

  /// No description provided for @x0Limit.
  ///
  /// In en, this message translates to:
  /// **'{p0} limit'**
  String x0Limit(Object p0);

  /// No description provided for @resets.
  ///
  /// In en, this message translates to:
  /// **'Resets'**
  String get resets;

  /// No description provided for @everyX0Days.
  ///
  /// In en, this message translates to:
  /// **'Every {p0} days'**
  String everyX0Days(Object p0);

  /// No description provided for @fewerDays.
  ///
  /// In en, this message translates to:
  /// **'Fewer days'**
  String get fewerDays;

  /// No description provided for @moreDays.
  ///
  /// In en, this message translates to:
  /// **'More days'**
  String get moreDays;

  /// No description provided for @alertAt80.
  ///
  /// In en, this message translates to:
  /// **'Alert at 80%'**
  String get alertAt80;

  /// No description provided for @alertAt100.
  ///
  /// In en, this message translates to:
  /// **'Alert at 100%'**
  String get alertAt100;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @addSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get addSubscription;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @editSubscription.
  ///
  /// In en, this message translates to:
  /// **'Edit subscription'**
  String get editSubscription;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next due'**
  String get nextDue;

  /// No description provided for @notScheduled.
  ///
  /// In en, this message translates to:
  /// **'Not scheduled'**
  String get notScheduled;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get started;

  /// No description provided for @skipNext.
  ///
  /// In en, this message translates to:
  /// **'Skip next'**
  String get skipNext;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get paymentHistory;

  /// No description provided for @everyYear.
  ///
  /// In en, this message translates to:
  /// **'Every year'**
  String get everyYear;

  /// No description provided for @everyWeek.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get everyWeek;

  /// No description provided for @everyDay.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get everyDay;

  /// No description provided for @everyMonth.
  ///
  /// In en, this message translates to:
  /// **'Every month'**
  String get everyMonth;

  /// No description provided for @everyX0Months.
  ///
  /// In en, this message translates to:
  /// **'Every {p0} months'**
  String everyX0Months(Object p0);

  /// No description provided for @recordX0.
  ///
  /// In en, this message translates to:
  /// **'Record {p0}?'**
  String recordX0(Object p0);

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @billingCurrency.
  ///
  /// In en, this message translates to:
  /// **'Billing currency'**
  String get billingCurrency;

  /// No description provided for @cadence.
  ///
  /// In en, this message translates to:
  /// **'Cadence'**
  String get cadence;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get editCategory;

  /// No description provided for @saveCategory.
  ///
  /// In en, this message translates to:
  /// **'Save category'**
  String get saveCategory;

  /// No description provided for @x0OverBudget.
  ///
  /// In en, this message translates to:
  /// **'{p0} over budget'**
  String x0OverBudget(Object p0);

  /// No description provided for @x0Remaining.
  ///
  /// In en, this message translates to:
  /// **'{p0} remaining'**
  String x0Remaining(Object p0);

  /// No description provided for @monthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost'**
  String get monthlyCost;

  /// No description provided for @repeats.
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get repeats;

  /// No description provided for @subcategory.
  ///
  /// In en, this message translates to:
  /// **'Subcategory'**
  String get subcategory;

  /// No description provided for @pockitoCategory.
  ///
  /// In en, this message translates to:
  /// **'Pockito category'**
  String get pockitoCategory;

  /// No description provided for @customCategory.
  ///
  /// In en, this message translates to:
  /// **'Custom category'**
  String get customCategory;

  /// No description provided for @showAgain.
  ///
  /// In en, this message translates to:
  /// **'Show again'**
  String get showAgain;

  /// No description provided for @hide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hide;

  /// No description provided for @x0Hidden.
  ///
  /// In en, this message translates to:
  /// **'{p0} hidden'**
  String x0Hidden(Object p0);

  /// No description provided for @nestX0Under.
  ///
  /// In en, this message translates to:
  /// **'Nest {p0} under'**
  String nestX0Under(Object p0);

  /// No description provided for @x0NowSitsUnderX1.
  ///
  /// In en, this message translates to:
  /// **'{p0} now sits under {p1}'**
  String x0NowSitsUnderX1(Object p0, Object p1);

  /// No description provided for @moveTo.
  ///
  /// In en, this message translates to:
  /// **'Move to'**
  String get moveTo;

  /// No description provided for @x0MoneyEvents.
  ///
  /// In en, this message translates to:
  /// **'{p0} money events'**
  String x0MoneyEvents(Object p0);

  /// No description provided for @x0Active.
  ///
  /// In en, this message translates to:
  /// **'{p0} active'**
  String x0Active(Object p0);

  /// No description provided for @defaultCurrency.
  ///
  /// In en, this message translates to:
  /// **'Default currency'**
  String get defaultCurrency;

  /// No description provided for @x0ReportingOnly.
  ///
  /// In en, this message translates to:
  /// **'{p0} · Reporting only'**
  String x0ReportingOnly(Object p0);

  /// No description provided for @exchangeRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get exchangeRates;

  /// No description provided for @automaticX0.
  ///
  /// In en, this message translates to:
  /// **'Automatic · {p0}'**
  String automaticX0(Object p0);

  /// No description provided for @manualRates.
  ///
  /// In en, this message translates to:
  /// **'Manual rates'**
  String get manualRates;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @aboutPockito.
  ///
  /// In en, this message translates to:
  /// **'About Pockito'**
  String get aboutPockito;

  /// No description provided for @prototypeTools.
  ///
  /// In en, this message translates to:
  /// **'Prototype tools'**
  String get prototypeTools;

  /// No description provided for @prototype.
  ///
  /// In en, this message translates to:
  /// **'Prototype'**
  String get prototype;

  /// No description provided for @replayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Replay onboarding'**
  String get replayOnboarding;

  /// No description provided for @invitationReview.
  ///
  /// In en, this message translates to:
  /// **'Invitation review'**
  String get invitationReview;

  /// No description provided for @stateCatalogue.
  ///
  /// In en, this message translates to:
  /// **'State catalogue'**
  String get stateCatalogue;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @reportingInX0.
  ///
  /// In en, this message translates to:
  /// **'Reporting in {p0}'**
  String reportingInX0(Object p0);

  /// No description provided for @providerX0.
  ///
  /// In en, this message translates to:
  /// **'Provider · {p0}'**
  String providerX0(Object p0);

  /// No description provided for @lastUpdatedX0.
  ///
  /// In en, this message translates to:
  /// **'Last updated · {p0}'**
  String lastUpdatedX0(Object p0);

  /// No description provided for @manualConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Manual configuration'**
  String get manualConfiguration;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @pockitoSurface.
  ///
  /// In en, this message translates to:
  /// **'Pockito surface'**
  String get pockitoSurface;

  /// No description provided for @language2.
  ///
  /// In en, this message translates to:
  /// **'Language · 言語'**
  String get language2;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @licences.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get licences;

  /// No description provided for @allQuiet.
  ///
  /// In en, this message translates to:
  /// **'All quiet'**
  String get allQuiet;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @moneyTogether.
  ///
  /// In en, this message translates to:
  /// **'Money, together.'**
  String get moneyTogether;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get bankAccount;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get getStarted;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @noPressure.
  ///
  /// In en, this message translates to:
  /// **'No pressure'**
  String get noPressure;

  /// No description provided for @openPockito.
  ///
  /// In en, this message translates to:
  /// **'Open Pockito'**
  String get openPockito;

  /// No description provided for @spaceInvitation.
  ///
  /// In en, this message translates to:
  /// **'Space invitation'**
  String get spaceInvitation;

  /// No description provided for @l4People.
  ///
  /// In en, this message translates to:
  /// **'4 people'**
  String get l4People;

  /// No description provided for @invitedBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by'**
  String get invitedBy;

  /// No description provided for @joinSpace.
  ///
  /// In en, this message translates to:
  /// **'Join space'**
  String get joinSpace;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @cashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash flow'**
  String get cashFlow;

  /// No description provided for @yourSpending.
  ///
  /// In en, this message translates to:
  /// **'Your spending'**
  String get yourSpending;

  /// No description provided for @defaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultLabel;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @couple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get couple;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @prototypeMarketSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Prototype market snapshot'**
  String get prototypeMarketSnapshot;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @onTrackForX0ByTheEndOfTheX1.
  ///
  /// In en, this message translates to:
  /// **'On track for {p0} by the end of the {p1}.'**
  String onTrackForX0ByTheEndOfTheX1(Object p0, Object p1);

  /// No description provided for @theSelectedAccount.
  ///
  /// In en, this message translates to:
  /// **'the selected account'**
  String get theSelectedAccount;

  /// No description provided for @expiresToday.
  ///
  /// In en, this message translates to:
  /// **'expires today'**
  String get expiresToday;

  /// No description provided for @expiresInX0Days.
  ///
  /// In en, this message translates to:
  /// **'expires in {p0} days'**
  String expiresInX0Days(Object p0);

  /// No description provided for @resentX0Times.
  ///
  /// In en, this message translates to:
  /// **' · resent {p0}×'**
  String resentX0Times(Object p0);

  /// No description provided for @periodNounWeek.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get periodNounWeek;

  /// No description provided for @periodNounMonth.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get periodNounMonth;

  /// No description provided for @periodNounQuarter.
  ///
  /// In en, this message translates to:
  /// **'quarter'**
  String get periodNounQuarter;

  /// No description provided for @periodNounYear.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get periodNounYear;

  /// No description provided for @periodNounPeriod.
  ///
  /// In en, this message translates to:
  /// **'period'**
  String get periodNounPeriod;

  /// No description provided for @awaitingYourConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting your confirmation'**
  String get awaitingYourConfirmation;

  /// No description provided for @awaitingTheirConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Awaiting their confirmation'**
  String get awaitingTheirConfirmation;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @x0JoinedTheSpace.
  ///
  /// In en, this message translates to:
  /// **'{p0} joined the space'**
  String x0JoinedTheSpace(Object p0);

  /// No description provided for @accountTypeBank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get accountTypeBank;

  /// No description provided for @accountTypeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get accountTypeCard;

  /// No description provided for @accountTypeCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get accountTypeCash;

  /// No description provided for @accountTypeSavings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get accountTypeSavings;

  /// No description provided for @accountTypeDigital.
  ///
  /// In en, this message translates to:
  /// **'Digital'**
  String get accountTypeDigital;

  /// No description provided for @statusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get statusVoided;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @budgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgetsTitle;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @notifUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifUnread;

  /// No description provided for @notifToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get notifToday;

  /// No description provided for @notifEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get notifEarlier;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryLabel;

  /// No description provided for @addHintMoneyOut.
  ///
  /// In en, this message translates to:
  /// **'Money out'**
  String get addHintMoneyOut;

  /// No description provided for @addHintMoneyIn.
  ///
  /// In en, this message translates to:
  /// **'Money in'**
  String get addHintMoneyIn;

  /// No description provided for @accountLabel.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountLabel;

  /// No description provided for @spaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get spaceLabel;

  /// No description provided for @budgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budgetLabel;

  /// No description provided for @sharedExpenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Shared expense'**
  String get sharedExpenseLabel;

  /// No description provided for @budgetDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'Days left'**
  String get budgetDaysLeft;

  /// No description provided for @budgetDailyAllowance.
  ///
  /// In en, this message translates to:
  /// **'Daily allowance'**
  String get budgetDailyAllowance;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @profileSampleCountry.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get profileSampleCountry;

  /// No description provided for @aboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Prototype 0.1.0'**
  String get aboutVersion;

  /// No description provided for @budgetPace.
  ///
  /// In en, this message translates to:
  /// **'Pace'**
  String get budgetPace;

  /// No description provided for @sampleMemberNames.
  ///
  /// In en, this message translates to:
  /// **'Kana, Fran'**
  String get sampleMemberNames;

  /// No description provided for @eventTypeExpense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get eventTypeExpense;

  /// No description provided for @eventTypeIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get eventTypeIncome;

  /// No description provided for @eventTypeTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get eventTypeTransfer;

  /// No description provided for @eventTypeSettlement.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get eventTypeSettlement;

  /// No description provided for @eventTypeAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Adjustment'**
  String get eventTypeAdjustment;

  /// No description provided for @quickAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Quick expense'**
  String get quickAddExpense;

  /// No description provided for @quickAddMoreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get quickAddMoreOptions;

  /// No description provided for @quickAddSaved.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get quickAddSaved;

  /// No description provided for @budgetUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get budgetUsed;

  /// No description provided for @subscriptionsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get subscriptionsOverdue;

  /// No description provided for @subscriptionsDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due soon'**
  String get subscriptionsDueSoon;

  /// No description provided for @subscriptionsLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get subscriptionsLater;

  /// No description provided for @dueX0.
  ///
  /// In en, this message translates to:
  /// **'Due {x0}'**
  String dueX0(String x0);

  /// No description provided for @aiVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get aiVerified;

  /// No description provided for @onboardingStepX0OfX1.
  ///
  /// In en, this message translates to:
  /// **'Step {x0} of {x1}'**
  String onboardingStepX0OfX1(int x0, int x1);

  /// No description provided for @colourOptionX0.
  ///
  /// In en, this message translates to:
  /// **'Colour {x0}'**
  String colourOptionX0(int x0);

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get changeAvatar;

  /// No description provided for @balanceHidden.
  ///
  /// In en, this message translates to:
  /// **'Balance hidden'**
  String get balanceHidden;

  /// No description provided for @privacyHideBalances.
  ///
  /// In en, this message translates to:
  /// **'Hide balances'**
  String get privacyHideBalances;

  /// No description provided for @privacyHideBalancesDetail.
  ///
  /// In en, this message translates to:
  /// **'Mask every amount without changing the layout.'**
  String get privacyHideBalancesDetail;
}

class _PkStringsDelegate extends LocalizationsDelegate<PkStrings> {
  const _PkStringsDelegate();

  @override
  Future<PkStrings> load(Locale locale) {
    return SynchronousFuture<PkStrings>(lookupPkStrings(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_PkStringsDelegate old) => false;
}

PkStrings lookupPkStrings(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return PkStringsEn();
    case 'ja':
      return PkStringsJa();
  }

  throw FlutterError(
    'PkStrings.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
