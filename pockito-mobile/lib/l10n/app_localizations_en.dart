// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class PkStringsEn extends PkStrings {
  PkStringsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navSpaces => 'Spaces';

  @override
  String get navMore => 'More';

  @override
  String get addMoneyEvent => 'Add money event';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionSave => 'Save';

  @override
  String get actionDone => 'Done';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionUndo => 'Undo';

  @override
  String get actionClearSearch => 'Clear search';

  @override
  String get actionResetAll => 'Reset all';

  @override
  String get actionSaveView => 'Save view';

  @override
  String get actionGotIt => 'Got it';

  @override
  String get actionSearch => 'Search';

  @override
  String get sortNewestFirst => 'Newest first';

  @override
  String get sortOldestFirst => 'Oldest first';

  @override
  String get sortLargestAmount => 'Largest amount';

  @override
  String get sortSmallestAmount => 'Smallest amount';

  @override
  String get sortNameAsc => 'Name A–Z';

  @override
  String get sortNameDesc => 'Name Z–A';

  @override
  String get sortHighestBalance => 'Highest balance';

  @override
  String get sortLowestBalance => 'Lowest balance';

  @override
  String get sortBy => 'Sort by';

  @override
  String get roleOwner => 'Owner';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Member';

  @override
  String get roleViewer => 'Viewer';

  @override
  String get roleOwnerSummary =>
      'Full control, including roles and archiving. There is always one owner.';

  @override
  String get roleAdminSummary =>
      'Can edit anyone’s expenses, manage budgets, invite and remove members.';

  @override
  String get roleMemberSummary =>
      'Can add expenses, edit their own, and settle up.';

  @override
  String get roleViewerSummary => 'Can see everything and change nothing.';

  @override
  String get spaceTypeHousehold => 'Household';

  @override
  String get spaceTypeTrip => 'Trip';

  @override
  String get spaceTypeCouple => 'Couple';

  @override
  String get spaceTypeFriends => 'Friends';

  @override
  String get spaceTypeOther => 'Other';

  @override
  String get readOnlyViewerTitle => 'You have view-only access';

  @override
  String get readOnlyViewerReason =>
      'Viewers can see everything here and change nothing.';

  @override
  String readOnlyArchivedTitle(String space) {
    return '$space is archived';
  }

  @override
  String get readOnlyArchivedReason =>
      'Archived Spaces keep their history and accept no new writes. Reopen it to add or change anything.';

  @override
  String get actionReopen => 'Reopen';

  @override
  String offlineTitle(String action) {
    return 'You’re offline, so we didn’t $action';
  }

  @override
  String get offlineBody =>
      'Nothing was half-saved — the change was stopped before it started. What you typed is still here; try again when you have a connection.';

  @override
  String get offlineNotNow => 'Not now';

  @override
  String deniedWhoCanHelpOne(String name) {
    return 'Ask $name to do it.';
  }

  @override
  String deniedWhoCanHelpMany(String names) {
    return 'Ask one of $names.';
  }

  @override
  String get deniedDefaultTitle => 'You can’t do that here';

  @override
  String conflictTitle(String name) {
    return '$name changed this while you were editing';
  }

  @override
  String conflictBody(String label) {
    return 'Two versions of “$label” exist. Nothing has been overwritten — pick which one wins.';
  }

  @override
  String conflictKeepTheirs(String name) {
    return 'Keep $name’s version';
  }

  @override
  String get conflictKeepTheirsDetail =>
      'Your edits are discarded and the form reloads.';

  @override
  String get conflictKeepMine => 'Keep mine';

  @override
  String get conflictKeepMineDetail =>
      'Your version replaces theirs. The change stays in the activity log either way.';

  @override
  String get conflictCompare => 'Compare them first';

  @override
  String get conflictCompareDetail =>
      'Reload theirs alongside yours and decide field by field.';

  @override
  String get recordVoided => 'Voided';

  @override
  String get recordDraft => 'Draft';

  @override
  String get recordDraftBanner => 'Draft — not counted yet';

  @override
  String get recordDraftBody =>
      'Nothing about your balances or budgets has moved. Confirm it when you are sure it is right.';

  @override
  String get recordVoidedBody =>
      'It stays in your history and counts towards nothing.';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionRestore => 'Restore';

  @override
  String get actionVoid => 'Void';

  @override
  String get chartViewAsTable => 'View as a table';

  @override
  String get chartNotEnoughHistory => 'Not enough history yet to draw a trend.';

  @override
  String get chartNothingRecorded =>
      'Nothing has been recorded this period, so there is nothing to break down yet.';

  @override
  String get chartEverythingElse => 'Everything else';

  @override
  String comparisonFlat(String period) {
    return 'About the same as $period';
  }

  @override
  String comparisonMore(int percent, String period) {
    return '$percent% more than $period';
  }

  @override
  String comparisonLess(int percent, String period) {
    return '$percent% less than $period';
  }

  @override
  String get homeSpent => 'SPENT';

  @override
  String get homeIn => 'IN';

  @override
  String get homeNetWorth => 'Net worth';

  @override
  String homeThingsNeedYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count things need you',
      one: '1 thing needs you',
    );
    return '$_temp0';
  }

  @override
  String homeAndMore(int count) {
    return 'and $count more';
  }

  @override
  String get homeWhoOwesWhom => 'Who owes whom';

  @override
  String get homeEveryoneSettled => 'Everyone is settled across your Spaces.';

  @override
  String get homeNoSpacesYet =>
      'No shared Spaces yet. Create one when you start splitting something.';

  @override
  String get homeSpendingTrend => 'Spending trend';

  @override
  String get homeWhereItWent => 'Where it went';

  @override
  String get homeThisMonthInFull => 'This month in full';

  @override
  String get homeAccounts => 'Accounts';

  @override
  String get homeBudgets => 'Budgets';

  @override
  String get homeUpcoming => 'Upcoming';

  @override
  String get homeRecent => 'Recent';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeViewActivity => 'View activity';

  @override
  String homeYouOwe(String name) {
    return 'You owe $name';
  }

  @override
  String homeOwesYou(String name) {
    return '$name owes you';
  }

  @override
  String homeYouKept(String amount) {
    return 'You kept $amount this month';
  }

  @override
  String homeYouOverspent(String amount) {
    return 'You spent $amount more than came in';
  }

  @override
  String homeStillFree(String amount) {
    return '$amount still free after what is already committed';
  }

  @override
  String get homeMoneyIn => 'Money in';

  @override
  String get homeMoneyOut => 'Money out';

  @override
  String get homeKept => 'Kept';

  @override
  String get homeKeptDetail => 'of what came in';

  @override
  String get homeStillDue => 'Still due';

  @override
  String get homeStillDueDetail => 'subscriptions left this month';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHintGlobal =>
      'Accounts, Spaces, categories, budgets, activity…';

  @override
  String get searchEmptyTitle => 'Search everything';

  @override
  String get searchEmptyBody =>
      'Type at least two letters. This looks across accounts, Spaces, categories, budgets, recurring items and your whole activity.';

  @override
  String searchNoMatchTitle(String query) {
    return 'Nothing matches “$query”';
  }

  @override
  String get searchNoMatchBody =>
      'Try fewer letters, or a merchant, note or member name.';

  @override
  String get searchKindAccount => 'Account';

  @override
  String get searchKindSpace => 'Space';

  @override
  String get searchKindCategory => 'Category';

  @override
  String get searchKindRecurring => 'Recurring';

  @override
  String get searchKindBudget => 'Budget';

  @override
  String get searchKindActivity => 'Activity';

  @override
  String get activityTitle => 'Activity';

  @override
  String activityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count money events',
      one: '1 money event',
    );
    return '$_temp0';
  }

  @override
  String get activitySearchHint =>
      'Search merchant, note, category, tag or account';

  @override
  String get activityFilters => 'Filters';

  @override
  String activityShowMore(int count) {
    return 'Show more · $count left';
  }

  @override
  String get activityNoneTitle => 'No activity yet';

  @override
  String get activityNoneBody =>
      'Record an expense, income or transfer to start your timeline.';

  @override
  String get activityNoMatchTitle => 'No matching money events';

  @override
  String get activityNoMatchBody =>
      'Try another phrase or clear the active filters.';

  @override
  String activitySavedViews(int count) {
    return '$count saved';
  }

  @override
  String get periodAnyTime => 'Any time';

  @override
  String get periodThisMonth => 'This month';

  @override
  String get periodLastMonth => 'Last month';

  @override
  String get periodCustom => 'Custom range';

  @override
  String fxConvertedTo(String currency) {
    return 'Converted to $currency';
  }

  @override
  String fxRateLine(
    String from,
    String rate,
    String to,
    String source,
    String date,
  ) {
    return '1 $from = $rate $to · $source · $date';
  }

  @override
  String get fxRateHistory => 'Rate history';

  @override
  String get fxManualRate => 'your manual rate';

  @override
  String fxNetWorthNote(String currency) {
    return 'Converted to $currency. Every rate used is listed below, with the day it was captured.';
  }

  @override
  String get fxMissingTitle => 'Some balances are not in this total';

  @override
  String fxMissingBody(String currencies) {
    return 'There is no rate for $currencies, so those balances are shown on their own rather than folded into a number that would be a guess.';
  }

  @override
  String get setupTitle => 'Getting set up';

  @override
  String setupProgress(int done, int total) {
    return '$done of $total';
  }

  @override
  String get setupHide => 'Hide this';

  @override
  String get setupStepProfile => 'Add your name and reporting currency';

  @override
  String get setupStepAccount => 'Add your first account';

  @override
  String get setupStepTransaction => 'Record something you spent';

  @override
  String get setupStepSpace => 'Create a Space for shared money';

  @override
  String get setupStepBudget => 'Set a budget you care about';

  @override
  String get quickScanReceipt => 'Scan a receipt';

  @override
  String get quickSharedExpense => 'Shared expense';

  @override
  String get quickSettleUp => 'Settle up';

  @override
  String get quickRecordIncome => 'Record income';

  @override
  String get quickNewBudget => 'New budget';

  @override
  String get saveBlockedOffline => 'Offline — try again in a moment';

  @override
  String get saveBlockedPermission => 'You can’t add expenses here';

  @override
  String notifAll(int count) {
    return 'All ($count)';
  }

  @override
  String notifWaitingCount(int count) {
    return 'Waiting on you ($count)';
  }

  @override
  String notifUpdatesCount(int count) {
    return 'Updates ($count)';
  }

  @override
  String get notifWaiting => 'Waiting on you';

  @override
  String get notifUpdates => 'Updates';

  @override
  String get notifNothingWaiting => 'Nothing is waiting on you';

  @override
  String get notifNoUpdates => 'No updates';

  @override
  String get notifSwitchFilter => 'Switch the filter to see everything else.';

  @override
  String get notifShowAll => 'Show all';

  @override
  String get notifMasterSwitch => 'The master switch for everything below';

  @override
  String get notifMarkAllRead => 'Mark all read';

  @override
  String get notifDismissed => 'Notification dismissed';

  @override
  String get aiSectionTitle => 'Ask about your money';

  @override
  String get aiExplainMonth => 'Explain this month';

  @override
  String get aiExplainMonthDetail => 'What moved, and what is behind it';

  @override
  String get aiCompareMonths => 'Compare two months';

  @override
  String get aiCompareMonthsDetail =>
      'Category by category, largest change first';

  @override
  String get aiFlagUnusual => 'Flag anything unusual';

  @override
  String get aiFlagUnusualDetail =>
      'Against each category’s own recent average';

  @override
  String get aiAnswerFootnote =>
      'Read from your own records — nothing was generated.';

  @override
  String get aiThisMonth => 'This month';

  @override
  String get aiAgainstLastMonth => 'Against last month';

  @override
  String get aiAnythingUnusual => 'Anything unusual';

  @override
  String aiSpentVs(
    String amount,
    String direction,
    String period,
    String previous,
  ) {
    return 'You spent $amount, $direction $period ($previous).';
  }

  @override
  String get aiDirectionSame => 'about the same as';

  @override
  String get aiDirectionMore => 'more than';

  @override
  String get aiDirectionLess => 'less than';

  @override
  String aiBiggestShare(String category, String amount) {
    return 'The biggest share went on $category: $amount.';
  }

  @override
  String aiKept(String kept, String income) {
    return 'You kept $kept of the $income that came in.';
  }

  @override
  String aiOverspent(String amount) {
    return 'You spent $amount more than came in.';
  }

  @override
  String aiStillDue(String amount) {
    return '$amount of subscriptions is still due before the month ends.';
  }

  @override
  String aiDeltaUp(String category, String amount) {
    return '$category: up $amount';
  }

  @override
  String aiDeltaDown(String category, String amount) {
    return '$category: down $amount';
  }

  @override
  String get aiNothingToCompare =>
      'There is nothing in either month to compare.';

  @override
  String get aiNothingUnusual =>
      'Nothing is far from its own recent average. That is not the same as nothing being expensive — only that nothing is out of character.';

  @override
  String aiUnusualLine(String category, String amount) {
    return '$category is well above its own average for the last three months, at $amount.';
  }

  @override
  String spaceMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get spaceManagePeople => 'Manage';

  @override
  String get spaceFullActivityLog => 'Full activity log';

  @override
  String get currencyNoRate => 'No conversion rate available';

  @override
  String currencyAvailable(int count) {
    return '$count currencies available';
  }

  @override
  String get hapticsTitle => 'Haptic feedback';

  @override
  String get hapticsDetail =>
      'A short tap on selection, saving and destructive confirms';

  @override
  String get widgetTitle => 'Home screen widget';

  @override
  String get widgetRefresh => 'Send to the home screen';

  @override
  String get widgetPushed => 'Home screen widget updated';

  @override
  String get widgetIntro =>
      'This is exactly what the widget shows, drawn from the same figures as the app. Tapping it anywhere opens Pockito.';

  @override
  String get widgetSizeSmall => 'Small · net worth only';

  @override
  String get widgetSizeMedium => 'Medium · net worth and this month';

  @override
  String get widgetSizeLarge => 'Large · adds who owes whom';

  @override
  String get widgetTapOpens => 'Tapping the widget opens Home';

  @override
  String get weCouldnTFindThat => 'We couldn’t find that screen';

  @override
  String nothingOpensAtYourMoney(Object p0) {
    return 'Nothing opens at $p0. Your money and data are untouched.';
  }

  @override
  String get goToHome => 'Go to Home';

  @override
  String get closeToTheLimit => 'Close to the limit';

  @override
  String atThisPaceYouFinish(Object p0, Object p1) {
    return 'At this pace you finish the $p0 $p1 over.';
  }

  @override
  String atThisPaceYouFinish2(Object p0, Object p1) {
    return 'At this pace you finish the $p0 at $p1.';
  }

  @override
  String includesCarriedOverFromLast(Object p0, Object p1) {
    return 'Includes $p0 carried over from last $p1.';
  }

  @override
  String get pockitoAppIconFeaturingKito => 'Pockito app icon featuring Kito';

  @override
  String percentOfUsed(Object p0, Object p1) {
    return '$p0 percent of $p1 used';
  }

  @override
  String get offlineChangesStayOnThis =>
      'Offline · changes stay on this device';

  @override
  String get stayInTheLoop => 'Stay in the loop';

  @override
  String get getNotifiedWhenSomeoneAdds =>
      'Get notified when someone adds a shared expense, pays you back, or when a budget needs attention.';

  @override
  String get miraAddedGroceries => 'Mira added Groceries · €84.00';

  @override
  String get miraSaysShePaidYou => 'Mira says she paid you ¥5,000';

  @override
  String get youVeUsedOfGroceries => 'You’ve used 80% of Groceries';

  @override
  String get turnOnNotifications => 'Turn on notifications';

  @override
  String get prototypeOnlyNoSystemPermission =>
      'Prototype only · no system permission is requested';

  @override
  String get pickWhatHappenedYouCan =>
      'Pick what happened. You can change any detail before saving.';

  @override
  String get readAReceipt => 'Read a receipt';

  @override
  String get pickADate => 'Pick a date';

  @override
  String get chooseAnAccount => 'Choose an account';

  @override
  String get outsidePockitoNoWalletMovement =>
      'Outside Pockito · no wallet movement';

  @override
  String get chooseACategory => 'Choose a category';

  @override
  String get chooseACurrency => 'Choose a currency';

  @override
  String noDecimalPlaces(Object p0) {
    return '$p0 · no decimal places';
  }

  @override
  String decimalPlaces(Object p0, Object p1) {
    return '$p0 · $p1 decimal places';
  }

  @override
  String get chooseAMember => 'Choose a member';

  @override
  String get eGBerlinTrip => 'e.g. Berlin trip';

  @override
  String get noReceiptKeptScanningOne =>
      'No receipt kept. Scanning one keeps the capture, so you can check the charge months later.';

  @override
  String get connectedToThis => 'Connected to this';

  @override
  String canDoThis(Object p0) {
    return '$p0 can do this.';
  }

  @override
  String get keepItAsItIs => 'Keep it as it is';

  @override
  String typeToContinue(Object p0) {
    return 'Type “$p0” to continue.';
  }

  @override
  String get thatDidnTWork => 'That didn’t work';

  @override
  String get thatDidnTLoad => 'That didn’t load';

  @override
  String get theListIsStillOn =>
      'The list is still on your device — this was a problem reading it.';

  @override
  String get yourSpendingIsSteadyShared =>
      'Your spending is steady. Shared costs and transfers are already separated from personal spending.';

  @override
  String isOverItsLimitYour(Object p0) {
    return '$p0 is over its limit. Your other balances are unchanged.';
  }

  @override
  String isGettingCloseToIts(Object p0) {
    return '$p0 is getting close to its limit. A quick review now can keep the month comfortable.';
  }

  @override
  String get weCouldNotRefreshYour => 'We could not refresh your overview';

  @override
  String get yourLocalDataIsSafe =>
      'Your local data is safe. Try loading it again.';

  @override
  String markedAsPaid(Object p0) {
    return '$p0 marked as paid';
  }

  @override
  String get yourMoneyFinallyInOne => 'Your money, finally in one place.';

  @override
  String get addAnAccountToTrack =>
      'Add an account to track your own money, or start a space to share expenses with people you trust.';

  @override
  String get chooseWhereToBegin => 'Choose where to begin';

  @override
  String get seeBalancesActivityAndNet =>
      'See balances, activity and net worth together.';

  @override
  String get createASharedSpace => 'Create a shared space';

  @override
  String get splitAHomeTripOr =>
      'Split a home, trip or project without guesswork.';

  @override
  String get exploreWithSampleData => 'Explore with sample data';

  @override
  String acrossAccounts(Object p0, Object p1) {
    return 'Across $p0 accounts · $p1';
  }

  @override
  String get nothingLeftYourAccounts => 'Nothing left your accounts';

  @override
  String ofThatLeftYourAccounts(Object p0, Object p1) {
    return '$p0% of $p1 that left your accounts';
  }

  @override
  String get nothingCameInThisMonth => 'Nothing came in this month';

  @override
  String get noDueDate => 'No due date';

  @override
  String dueInDays(Object p0) {
    return 'Due in $p0 days';
  }

  @override
  String thingsNeedYou(Object p0) {
    return '$p0 things need you';
  }

  @override
  String isWellAboveItsRecent(Object p0, Object p1) {
    return '$p0 is well above its recent average at $p1.';
  }

  @override
  String showMoreLeft(Object p0) {
    return 'Show more · $p0 left';
  }

  @override
  String get nameThisView => 'Name this view';

  @override
  String get eGReimbursableWorkTravel => 'e.g. Reimbursable work travel';

  @override
  String get filterCombinationsYouBuiltOnce =>
      'Filter combinations you built once.';

  @override
  String get moneyEventNotFound => 'Money event not found';

  @override
  String get thisItemHasBeenRemoved =>
      'This item has been removed from your local prototype.';

  @override
  String get confirmedItCountsFromNow => 'Confirmed — it counts from now on';

  @override
  String get voidThisMoneyEvent => 'Void this money event?';

  @override
  String get itStaysInYourHistory2 =>
      'It stays in your history, struck through, and stops counting towards balances and budgets.';

  @override
  String get theLinkedSharedExpenseIs =>
      'The linked shared expense is voided too, and everyone’s balances update. Both rows stay visible in the history.';

  @override
  String get editMoneyEvent => 'Edit money event';

  @override
  String get youCanFillThisIn =>
      'You can fill this in, but saving is blocked until there is a connection — nothing gets half-written.';

  @override
  String youCanTAddExpenses(Object p0) {
    return 'You can’t add expenses to $p0';
  }

  @override
  String get viewersCanSeeEverythingAnd =>
      'Viewers can see everything and change nothing.';

  @override
  String get thisSpaceIsArchivedSo =>
      'This Space is archived, so it is read-only.';

  @override
  String get youDoNotHavePermission =>
      'You do not have permission to add expenses here.';

  @override
  String get enterAnAmountGreaterThan => 'Enter an amount greater than zero';

  @override
  String get whatWasThisFor => 'What was this for?';

  @override
  String get addAShortDescription => 'Add a short description';

  @override
  String get whyThisHappenedOrAnything =>
      'Why this happened, or anything to remember';

  @override
  String get paidOutsidePockitoNoWallet =>
      'Paid outside Pockito · no wallet movement';

  @override
  String get noAccountMovement => 'No account movement';

  @override
  String get thePayerSAccountIs =>
      'The payer’s account is outside your personal ledger.';

  @override
  String get chooseTheDestination => 'Choose the destination';

  @override
  String get capturedWithThisTransfer => 'Captured with this transfer';

  @override
  String get rateMustBeMoreThan => 'Rate must be more than zero';

  @override
  String get automaticRateUnavailableChooseManual =>
      'Automatic rate unavailable. Choose Manual to continue.';

  @override
  String get paidWithOptional => 'Paid with (optional)';

  @override
  String get shareThisExpense => 'Share this expense';

  @override
  String get personalSpendingOnly => 'Personal spending only';

  @override
  String get updatesTheAccountAndEveryone =>
      'Updates the account and everyone’s balance';

  @override
  String get noAutomaticRateEnterA =>
      'No automatic rate. Enter a manual rate to continue.';

  @override
  String get receiptKeptDetailsFilledIn =>
      'Receipt kept · details filled in — review before saving';

  @override
  String get receiptKeptWeCouldNot =>
      'Receipt kept · we could not read it, so nothing was filled in';

  @override
  String get attachAReceipt => 'Attach a receipt';

  @override
  String get whatIsItEG => 'What is it? e.g. Restaurant bill';

  @override
  String get enterAnAmountBeforeEditing =>
      'Enter an amount before editing the split';

  @override
  String get chooseAValidExchangeRate =>
      'Choose a valid exchange rate to continue';

  @override
  String get enterAnExchangeRateFor =>
      'Enter an exchange rate for this wallet payment';

  @override
  String get moneyEventAdded => 'Money event added';

  @override
  String get moneyEventUpdated => 'Money event updated';

  @override
  String get yourVersionWasKept => 'Your version was kept';

  @override
  String get loadedTheirVersionSNumbers =>
      'Loaded their version’s numbers — check each field, then save.';

  @override
  String get fitTheWholeReceiptInside =>
      'Fit the whole receipt inside the frame';

  @override
  String get previewLowConfidence => 'Preview low confidence';

  @override
  String get previewFailedScan => 'Preview failed scan';

  @override
  String get readingMerchantTotalAndDate => 'Reading merchant, total and date…';

  @override
  String get oneQuickCheck => 'One quick check';

  @override
  String get merchantAndCategoryHaveLow =>
      'Merchant and category have low confidence. Every field stays editable before saving.';

  @override
  String get augustGroceries => '15 August 2026 · Groceries';

  @override
  String get thisIsALocalOcr =>
      'This is a local OCR simulation. Nothing was uploaded and you can edit every field before saving.';

  @override
  String get useTheseDetails => 'Use these details';

  @override
  String get weCouldNotReadThis => 'We could not read this document';

  @override
  String get theImageMayBeBlurred =>
      'The image may be blurred, cropped or offline. No financial data was created.';

  @override
  String get theImageWasTooBlurred =>
      'The image was too blurred to read. Nothing was filled in for you.';

  @override
  String get enterDetailsManually => 'Enter details manually';

  @override
  String get searchPaymentMethods => 'Search payment methods';

  @override
  String get recordsThatWereUndoneKept =>
      'Records that were undone, kept for the history';

  @override
  String get stagedRecordsThatDoNot => 'Staged records that do not count yet';

  @override
  String get everythingIsAllocated => 'Everything is allocated';

  @override
  String get useThisSplit => 'Use this split';

  @override
  String get addALineForEach =>
      'Add a line for each thing on the bill, then tick who had it. Anything you don’t itemise is split evenly.';

  @override
  String get everyLineAccountedFor => 'Every line accounted for';

  @override
  String notItemisedSplitEvenly(Object p0) {
    return '$p0 not itemised — split evenly';
  }

  @override
  String get whatWasOnTheBill => 'What was on the bill?';

  @override
  String get eGTheWine => 'e.g. the wine';

  @override
  String howMuchWas(Object p0) {
    return 'How much was $p0?';
  }

  @override
  String get thatAmountDidnTLook => 'That amount didn’t look like a number';

  @override
  String get thisIsHowItLands => 'This is how it lands';

  @override
  String get nothingIsSavedYetGoing =>
      'Nothing is saved yet. Going back keeps the editor open.';

  @override
  String get percentagesMustTotal => 'Percentages must total 100%';

  @override
  String get enterAtLeastOnePositive => 'Enter at least one positive share';

  @override
  String get moreThanOnePersonPaid => 'More than one person paid';

  @override
  String get whoPaidWhat => 'Who paid what';

  @override
  String payersAddUpTo(Object p0) {
    return 'Payers add up to $p0';
  }

  @override
  String get sharedMoneyWithoutTheAwkward =>
      'Shared money, without the awkward maths';

  @override
  String searchSpacesOrTheirMembers(Object p0) {
    return 'Search $p0 Spaces or their members';
  }

  @override
  String get shareMoneyWithLessFriction => 'Share money with less friction';

  @override
  String get createASpaceForA =>
      'Create a space for a home, trip, couple or group of friends.';

  @override
  String get createASpace => 'Create a space';

  @override
  String noSpaceMatches(Object p0) {
    return 'No Space matches “$p0”';
  }

  @override
  String get tryADifferentNameType => 'Try a different name, type or member.';

  @override
  String get spaceNotFound => 'Space not found';

  @override
  String get itMayHaveBeenRemoved =>
      'It may have been removed from the prototype.';

  @override
  String get everyoneIsSettled => 'Everyone is settled';

  @override
  String get cyclesPreserveYourHistory => 'Cycles preserve your history';

  @override
  String get startANewCycleTo =>
      'Start a new cycle to reset current balances and the space budget. Nothing historical is deleted.';

  @override
  String get startNewCycle => 'Start new cycle';

  @override
  String get noSharedExpensesYet => 'No shared expenses yet';

  @override
  String get noExpensesMatchTheseFilters => 'No expenses match these filters';

  @override
  String get addTheFirstExpenseAnd =>
      'Add the first expense and Pockito will keep everyone’s balance clear.';

  @override
  String get tryShowingSettledAndUnsettled =>
      'Try showing settled and unsettled expenses, or include every payer.';

  @override
  String joinedTheSpace(Object p0) {
    return '$p0 joined the space';
  }

  @override
  String everyAmountIsInThe(Object p0) {
    return 'Every amount is in $p0, the space currency.';
  }

  @override
  String get whoPaysWhom => 'Who pays whom';

  @override
  String get startANewCycle => 'Start a new cycle?';

  @override
  String get currentBalancesAndSpaceBudget =>
      'Current balances and space-budget usage restart at zero. Expenses, contributions, analytics and settlements remain in the previous cycle.';

  @override
  String get newCycleStartedHistoryPreserved =>
      'New cycle started · history preserved';

  @override
  String get paidByMe => 'Paid by me';

  @override
  String get paidByMember => 'Paid by member';

  @override
  String get expenseNotFound => 'Expense not found';

  @override
  String get thisExpenseHasBeenRemoved => 'This expense has been removed.';

  @override
  String get thisClosedCycleRecordIs =>
      'This closed-cycle record is read-only so its totals remain trustworthy.';

  @override
  String get chargedToYourWallet => 'Charged to your wallet';

  @override
  String get whoPaysWhat => 'Who pays what';

  @override
  String get theSpaceThisBelongsTo => 'The Space this belongs to';

  @override
  String get yourAccountMovement => 'Your account movement';

  @override
  String get itStaysVisibleToEveryone =>
      'It stays visible to everyone, struck through, and stops counting towards the Space balance. Your linked account movement is undone with it.';

  @override
  String get kanaExampleComFranExample => 'kana@example.com, fran@example.com';

  @override
  String get whatAreYouSharing => 'What are you sharing?';

  @override
  String get theSpaceCurrencyIsThe =>
      'The space currency is the single source of truth for balances.';

  @override
  String get youCanShareAnInvite =>
      'You can share an invite link now or do it later.';

  @override
  String get eGFlatOrTokyo => 'e.g. Flat or Tokyo Trip';

  @override
  String get nameYourSpace => 'Name your space';

  @override
  String get monthlySpaceBudgetOptional => 'Monthly space budget (optional)';

  @override
  String get resetsForANewMonth => 'Resets for a new month or space cycle';

  @override
  String get enterABudgetGreaterThan => 'Enter a budget greater than zero';

  @override
  String get separateMultiplePeopleWithCommas =>
      'Separate multiple people with commas';

  @override
  String get inviteLinkReady => 'Invite link ready';

  @override
  String get inviteLinkCopied => 'Invite link copied';

  @override
  String get createAndInvite => 'Create and invite';

  @override
  String get notificationPreviewsTurnedOn => 'Notification previews turned on';

  @override
  String createdInvitationsPending(Object p0) {
    return '$p0 created · invitations pending';
  }

  @override
  String get itMayHaveBeenRemoved2 =>
      'It may have been removed or you may have left it.';

  @override
  String get youCanTInvitePeople => 'You can’t invite people here';

  @override
  String get onlyOwnersAndAdminsCan =>
      'Only owners and admins can invite people.';

  @override
  String get tryADifferentNameOr => 'Try a different name or clear the search.';

  @override
  String inviteResentTo(Object p0) {
    return 'Invite resent to $p0';
  }

  @override
  String newInviteSentTo(Object p0) {
    return 'New invite sent to $p0';
  }

  @override
  String get noInvitationsYet => 'No invitations yet';

  @override
  String get inviteKanaFranOrAnyone =>
      'Invite Kana, Fran, or anyone you share money with.';

  @override
  String invitedAsExpiresInDays(Object p0, Object p1, Object p2) {
    return '$p0 invited as $p1 · expires in $p2 days';
  }

  @override
  String revokeSInvite(Object p0) {
    return 'Revoke $p0’s invite?';
  }

  @override
  String get theLinkStopsWorkingImmediately =>
      'The link stops working immediately. You can invite them again at any time.';

  @override
  String sInviteRevoked(Object p0) {
    return '$p0’s invite revoked';
  }

  @override
  String get youCanTChangeRoles => 'You can’t change roles here';

  @override
  String get onlyTheOwnerCanChange => 'Only the owner can change roles.';

  @override
  String get youCanTRemoveThis => 'You can’t remove this member';

  @override
  String get theOwnerCannotBeRemoved =>
      'The owner cannot be removed. Transfer ownership first.';

  @override
  String get onlyOwnersAndAdminsCan2 =>
      'Only owners and admins can remove members.';

  @override
  String get removeFromSpace => 'Remove from Space';

  @override
  String get youCanTLeaveThis => 'You can’t leave this Space';

  @override
  String get youAreTheOnlyOwner =>
      'You are the only owner. Make someone else the owner first, so the Space is never left unmanaged.';

  @override
  String get thisSpaceCannotBeLeft => 'This Space cannot be left right now.';

  @override
  String get whatTheyCanDoChanges => 'What they can do changes immediately.';

  @override
  String isNowA(Object p0, Object p1) {
    return '$p0 is now a $p1';
  }

  @override
  String get youLoseAccessToIts =>
      'You lose access to its expenses and balances. Rejoining needs a new invitation from an owner or admin.';

  @override
  String get settleTheBalanceFirst => 'Settle the balance first';

  @override
  String hasABalanceInThis(Object p0, Object p1) {
    return '$p0 has a $p1 balance in this cycle. Settle it before removing them so the history stays consistent.';
  }

  @override
  String get theyWillKeepAccessTo =>
      'They will keep access to their past records but cannot add new expenses.';

  @override
  String get linkExpiresIn => 'Link expires in';

  @override
  String get copyInviteLink => 'Copy invite link';

  @override
  String get onlyOwnersAndAdminsCan3 =>
      'Only owners and admins can change Space settings.';

  @override
  String isOpenAgain(Object p0) {
    return '$p0 is open again';
  }

  @override
  String members(Object p0, Object p1, Object p2) {
    return '$p0 · $p1 · $p2 members';
  }

  @override
  String get whoChangedWhatAndWhen => 'Who changed what, and when';

  @override
  String get includesMemberAndSettingsChanges =>
      'Includes member and settings changes';

  @override
  String get onlyTheOwnerCanArchive =>
      'Only the owner can archive or reopen a Space.';

  @override
  String get automaticallyPreFillsEveryNew =>
      'Automatically pre-fills every new expense. It can always be overridden.';

  @override
  String get exactAmountsDependOnThe =>
      'Exact amounts depend on the expense total. New expenses start equally allocated and require confirmation in the split editor.';

  @override
  String get everyoneReceivesAnEqualResponsibility =>
      'Everyone receives an equal responsibility.';

  @override
  String percentagesMustTotalCurrently(Object p0) {
    return 'Percentages must total 100% (currently $p0%).';
  }

  @override
  String get enterAtLeastOnePositive2 => 'Enter at least one positive share.';

  @override
  String get saveDefaultSplit => 'Save default split';

  @override
  String equalAcrossMembers(Object p0) {
    return 'Equal across $p0 members';
  }

  @override
  String get exactAmountsConfirmPerExpense =>
      'Exact amounts · confirm per expense';

  @override
  String get itemizedAssignEachLinePer =>
      'Itemized · assign each line per expense';

  @override
  String get membersCanNoLongerAdd =>
      'Members can no longer add expenses, but the complete history remains available.';

  @override
  String get thereAreNoOutstandingPayments =>
      'There are no outstanding payments in this cycle.';

  @override
  String get thisRecordsASettlementNever =>
      'This records a settlement, never spending.';

  @override
  String get eGAugustUtilities => 'e.g. August utilities';

  @override
  String get enterAValidAmount => 'Enter a valid amount';

  @override
  String amountCannotExceed(Object p0) {
    return 'Amount cannot exceed $p0';
  }

  @override
  String confirmsThisBeforeAnyBalance(Object p0) {
    return '$p0 confirms this before any balance moves. You can cancel it until then.';
  }

  @override
  String get youAreTheOneBeing =>
      'You are the one being paid, so recording it confirms it straight away.';

  @override
  String get sendForConfirmation => 'Send for confirmation';

  @override
  String get partialSettlementRecorded => 'Partial settlement recorded';

  @override
  String everyMemberIsAtExpenses(Object p0) {
    return 'Every member is at $p0. Expenses and settlements remain in this cycle’s history.';
  }

  @override
  String get backToSpaces => 'Back to spaces';

  @override
  String get settleRemainingBalance => 'Settle remaining balance';

  @override
  String get viewSettlementHistory => 'View settlement history';

  @override
  String get itsSettlementHistoryIsNo =>
      'Its settlement history is no longer available.';

  @override
  String get noSettlementsYet => 'No settlements yet';

  @override
  String get whenSomeonePaysAnotherBack =>
      'When someone pays another back, it’ll be recorded here.';

  @override
  String get settlementNotFound => 'Settlement not found';

  @override
  String get itMayHaveBeenRemoved3 =>
      'It may have been removed from the local prototype.';

  @override
  String get waitingOnConfirmation => 'Waiting on confirmation';

  @override
  String saysThisMoneyReachedYou(Object p0) {
    return '$p0 says this money reached you. Nothing has moved yet — confirming is what shifts the balance.';
  }

  @override
  String get thatDidnTHappen => 'That didn’t happen';

  @override
  String get youProposedItSoConfirming =>
      'You proposed it, so confirming it yourself would let one person declare the other has been paid.';

  @override
  String get cancelThisProposal => 'Cancel this proposal';

  @override
  String get whereDidTheMoneyLand => 'Where did the money land?';

  @override
  String get cancelThisSettlement => 'Cancel this settlement';

  @override
  String get itStaysInTheHistory =>
      'It stays in the history as cancelled. Nothing about the balance changes, because nothing moved.';

  @override
  String get cycleHistoryIsNoLonger => 'Cycle history is no longer available.';

  @override
  String get openCurrentCycle => 'Open current cycle';

  @override
  String get noPreviousCycles => 'No previous cycles';

  @override
  String get onceEveryoneIsSettledStart =>
      'Once everyone is settled, start a new cycle to preserve this period here.';

  @override
  String expensesSettlements(Object p0, Object p1) {
    return '$p0 expenses · $p1 settlements';
  }

  @override
  String get cycleNotFound => 'Cycle not found';

  @override
  String get thisHistoricalSnapshotIsUnavailable =>
      'This historical snapshot is unavailable.';

  @override
  String get settledCycleReadOnly => 'Settled cycle · read-only';

  @override
  String get thisSnapshotDoesNotChange =>
      'This snapshot does not change when the current cycle changes.';

  @override
  String theSnapshotRetainsExpenseReferences(Object p0) {
    return 'The snapshot retains $p0 expense references and all aggregate totals.';
  }

  @override
  String get returnToCurrentCycle => 'Return to current cycle';

  @override
  String get noArchivedSpaces => 'No archived spaces';

  @override
  String get finishedTripsAndOldGroups =>
      'Finished trips and old groups can live here.';

  @override
  String get acrossAllSpaces => 'Across all spaces';

  @override
  String get itsActivityLogIsNo => 'Its activity log is no longer available.';

  @override
  String get searchThisLog => 'Search this log';

  @override
  String get refusedActionsOnly => 'Refused actions only';

  @override
  String get nothingRecordedYet => 'Nothing recorded yet';

  @override
  String get nobodyHasBeenRefusedAn =>
      'Nobody has been refused an action here.';

  @override
  String get addingAnExpenseOrChanging =>
      'Adding an expense or changing a setting will show up here, with who did it.';

  @override
  String get startWithAnAccount => 'Start with an account';

  @override
  String get accountsAreWhereMoneyEnters =>
      'Accounts are where money enters and leaves Pockito.';

  @override
  String noAccountMatches(Object p0) {
    return 'No account matches “$p0”';
  }

  @override
  String get tryADifferentNameType2 =>
      'Try a different name, type or currency.';

  @override
  String get accountNotFound => 'Account not found';

  @override
  String get correctTheBalance => 'Correct the balance';

  @override
  String balanceOverTheLastDays(Object p0, Object p1) {
    return '$p0 balance over the last 30 days, ending at $p1';
  }

  @override
  String get availableToSpend => 'Available to spend';

  @override
  String get recordThisAccountSFirst =>
      'Record this account’s first money event.';

  @override
  String get itsHistoryStaysAvailableYou =>
      'Its history stays available. You can restore it from Archived accounts.';

  @override
  String get eGRevolut => 'e.g. Revolut';

  @override
  String get giveThisAccountAName => 'Give this account a name';

  @override
  String get creditLimitOptional => 'Credit limit (optional)';

  @override
  String get letsPockitoShowWhatIs =>
      'Lets Pockito show what is left to spend, not only what is owed';

  @override
  String get savingsGoalOptional => 'Savings goal (optional)';

  @override
  String get showsProgressOnTheAccount => 'Shows progress on the account';

  @override
  String get preselectedWhenRecordingAnExpense =>
      'Preselected when recording an expense';

  @override
  String get noArchivedAccounts => 'No archived accounts';

  @override
  String get archivedAccountsWillAppearHere =>
      'Archived accounts will appear here with their history intact.';

  @override
  String get availableByCurrency => 'Available by currency';

  @override
  String get currenciesStaySeparateUntilReporting =>
      'Currencies stay separate until reporting. Pockito never combines money without a rate.';

  @override
  String get inThisMonth => 'IN THIS MONTH';

  @override
  String get outThisMonth => 'OUT THIS MONTH';

  @override
  String get connectAnApp => 'Connect an app';

  @override
  String get youStayInControl => 'You stay in control';

  @override
  String get kitoSurfacesAiInsightsBut =>
      'Kito surfaces AI insights, but connections only see approved data and financial writes always get a preview.';

  @override
  String get noConnectedApps => 'No connected apps';

  @override
  String get connectAnAiApplicationAnd =>
      'Connect an AI application and choose exactly what it can read or change.';

  @override
  String get suspendedReviewNeeded => 'Suspended · review needed';

  @override
  String get verifiedByPockito => 'Verified by Pockito';

  @override
  String get customMcpClient => 'Custom MCP client';

  @override
  String get chooseAnApplication => 'Choose an application';

  @override
  String get thisPrototypeSimulatesAuthorizationNo =>
      'This prototype simulates authorization. No token or external connection is created.';

  @override
  String get unverifiedApplicationUseExtraCare =>
      'Unverified application · use extra care';

  @override
  String get allowAccessToPockito => 'Allow access to Pockito?';

  @override
  String get chooseTheMinimumAccessThis =>
      'Choose the minimum access this app needs. You can revoke it later.';

  @override
  String get namesTypesCurrenciesAndBalances =>
      'Names, types, currencies and balances';

  @override
  String get moneyEventsAndCategories => 'Money events and categories';

  @override
  String get sharedExpensesAndWhoOwes => 'Shared expenses and who owes whom';

  @override
  String get calculatedSpendingAndBudgetSummaries =>
      'Calculated spending and budget summaries';

  @override
  String get allowFinancialChanges => 'Allow financial changes';

  @override
  String get createAndUpdateExpensesOr =>
      'Create and update expenses or subscriptions';

  @override
  String get writesArePreviewedFirstHigh =>
      'Writes are previewed first. High-risk actions can wait for approval in Pockito.';

  @override
  String get connectionNotFound => 'Connection not found';

  @override
  String get itMayHaveBeenDisconnected => 'It may have been disconnected.';

  @override
  String get theAppLosesAccessImmediately =>
      'The app loses access immediately. Money events it previously created stay attributed and visible.';

  @override
  String get noAiActivity => 'No AI activity';

  @override
  String get readsAndWritesFromConnected =>
      'Reads and writes from connected apps will appear here with attribution.';

  @override
  String get blockedMemberInvitation => 'Blocked member invitation';

  @override
  String get financeSidekickOutsideGrantedCapabilities =>
      'Finance Sidekick · outside granted capabilities';

  @override
  String get nothingNeedsApproval => 'Nothing needs approval';

  @override
  String get highImpactActionsRequestedBy =>
      'High-impact actions requested by connected apps will wait here.';

  @override
  String get requestsYourApproval => 'Requests your approval';

  @override
  String get approvedAndRecorded => 'Approved and recorded';

  @override
  String get noTagsYet => 'No tags yet';

  @override
  String get tagsCutAcrossCategoriesA =>
      'Tags cut across categories. A “Berlin trip” tag collects its groceries, transport and restaurants in one place.';

  @override
  String get tryADifferentWordOr => 'Try a different word, or add a new tag.';

  @override
  String get addATag => 'Add a tag';

  @override
  String get notUsedYet => 'Not used yet';

  @override
  String get seeEverythingTaggedWithThis => 'See everything tagged with this';

  @override
  String get recordsKeepTheirOtherTags =>
      'Records keep their other tags; nothing else changes.';

  @override
  String get addPaymentMethod => 'Add payment method';

  @override
  String get noPaymentMethodsYet => 'No payment methods yet';

  @override
  String get anAccountSaysWhereThe =>
      'An account says where the money lives. A payment method says how it left — which card, which direct debit.';

  @override
  String get newPaymentMethod => 'New payment method';

  @override
  String get eGAmexGold => 'e.g. Amex Gold';

  @override
  String get lastFourDigitsOptional => 'Last four digits (optional)';

  @override
  String get paymentMethodAdded => 'Payment method added';

  @override
  String get dateDescriptionAmountCurrencyCategory =>
      'date,description,amount,currency,category,account\n2026-08-16,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-16,Refund from Zalando,24.00,EUR,Refunds,Visa\n2026-08-12,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-99,Broken row,-10.00,EUR,Groceries,Revolut\n';

  @override
  String get pasteCsvWithAHeader =>
      'Paste CSV with a header row: date, description, amount, currency, category, account. A negative amount is money out.';

  @override
  String get checkTheRows => 'Check the rows';

  @override
  String toImportAlreadyRecordedUnreadable(Object p0, Object p1, Object p2) {
    return '$p0 to import · $p1 already recorded · $p2 unreadable';
  }

  @override
  String get nothingHereCanBeImported => 'Nothing here can be imported';

  @override
  String get itIsOnYourClipboard =>
      'It is on your clipboard. Here is exactly what was copied.';

  @override
  String get itMayHaveBeenRemoved4 => 'It may have been removed.';

  @override
  String get pockitoThinksThisAccountHolds =>
      'Pockito thinks this account holds';

  @override
  String get whatIsActuallyThere => 'What is actually there';

  @override
  String thisRecordsACorrectionOf(Object p0) {
    return 'This records a correction of $p0 in. It is not income and never counts as earning.';
  }

  @override
  String thisRecordsACorrectionOf2(Object p0) {
    return 'This records a correction of $p0 out. It is not an expense and never counts as spending.';
  }

  @override
  String get whyDoesItDiffer => 'Why does it differ?';

  @override
  String get eGCountedTheWallet => 'e.g. Counted the wallet';

  @override
  String get recordTheCorrection => 'Record the correction';

  @override
  String get enterTheRealBalance => 'Enter the real balance';

  @override
  String get sayWhyItDiffers => 'Say why it differs';

  @override
  String get noRateAvailable => 'No rate available';

  @override
  String atMockRate(Object p0) {
    return '$p0 at mock rate';
  }

  @override
  String get planWithoutPolicingYourself => 'Plan without policing yourself';

  @override
  String get budgetsShowPaceAndRemaining =>
      'Budgets show pace and remaining allowance without judging ordinary spending.';

  @override
  String get budgetNotFound => 'Budget not found';

  @override
  String get itMayHaveBeenDeleted => 'It may have been deleted.';

  @override
  String projectedEndOf(Object p0) {
    return 'Projected end of $p0';
  }

  @override
  String get nothingCountedYet => 'Nothing counted yet';

  @override
  String get matchingExpensesWillAppearHere =>
      'Matching expenses will appear here automatically.';

  @override
  String get expensesStayUntouchedOnlyThis =>
      'Expenses stay untouched. Only this limit and its alerts are removed.';

  @override
  String get eGGroceries => 'e.g. Groceries';

  @override
  String get nameThisBudget => 'Name this budget';

  @override
  String get allExpenseCategories => 'All expense categories';

  @override
  String get onlySelectedCategoriesCount => 'Only selected categories count';

  @override
  String get allWalletsAreIncluded => 'All wallets are included';

  @override
  String get onlySelectedWalletsCount => 'Only selected wallets count';

  @override
  String get enterALimitGreaterThan => 'Enter a limit greater than zero';

  @override
  String get carryTheLeftoverOver => 'Carry the leftover over';

  @override
  String whateverIsUnspentAtThe(Object p0) {
    return 'Whatever is unspent at the end of a $p0 is added to the next one.';
  }

  @override
  String get searchRecurringItems => 'Search recurring items';

  @override
  String get noActiveSubscriptions => 'No active subscriptions';

  @override
  String get addRecurringPaymentsToSee =>
      'Add recurring payments to see upcoming charges and monthly cost.';

  @override
  String get subscriptionNotFound => 'Subscription not found';

  @override
  String get paymentHistoryRemainsInActivity =>
      'Payment history remains in Activity. The recurring item leaves the active list.';

  @override
  String get noPaymentsRecorded => 'No payments recorded';

  @override
  String get recordedPaymentsAppearHereAnd =>
      'Recorded payments appear here and in Activity.';

  @override
  String walletDebitUsingTheCurrent(Object p0, Object p1) {
    return '\n\nWallet debit: ≈ $p0 using the current $p1 rate.';
  }

  @override
  String willBeRecordedFrom(Object p0, Object p1, Object p2) {
    return '$p0 will be recorded from $p1.$p2';
  }

  @override
  String get skipThisPayment => 'Skip this payment?';

  @override
  String get noExpenseIsRecordedThe =>
      'No expense is recorded. The next due date advances by one billing period.';

  @override
  String get eGSpotify => 'e.g. Spotify';

  @override
  String get nameThisSubscription => 'Name this subscription';

  @override
  String get enterAnAmount => 'Enter an amount';

  @override
  String monthlyOnDay(Object p0) {
    return 'Monthly on day $p0';
  }

  @override
  String noCategoryMatches(Object p0) {
    return 'No category matches “$p0”';
  }

  @override
  String get tryADifferentNameOr2 =>
      'Try a different name, or add a new category.';

  @override
  String activeAnnualized(Object p0, Object p1) {
    return '$p0 active · $p1 annualized';
  }

  @override
  String get dayOfMonth => 'Day of month';

  @override
  String get aPockitoCategoryItCan =>
      'A Pockito category — it can be hidden but never deleted, because records may still point at it.';

  @override
  String get yourOwnCategory => 'Your own category';

  @override
  String get nestUnderAnotherCategory => 'Nest under another category';

  @override
  String get itReappearsInPickersAnd => 'It reappears in pickers and filters.';

  @override
  String get itStaysOnEveryRecord =>
      'It stays on every record that already uses it, and stops appearing in pickers.';

  @override
  String isVisibleAgain(Object p0) {
    return '$p0 is visible again';
  }

  @override
  String isTopLevelAgain(Object p0) {
    return '$p0 is top-level again';
  }

  @override
  String get categoriesOnlyNestOneLevel =>
      'Categories only nest one level deep.';

  @override
  String hasItsOwnSubcategoriesSo(Object p0) {
    return '$p0 has its own subcategories, so it cannot become one.';
  }

  @override
  String get reassignBeforeDeleting => 'Reassign before deleting';

  @override
  String isUsedByExistingMoney(Object p0) {
    return '$p0 is used by existing money events. Choose where they should move.';
  }

  @override
  String get reassignAndDelete => 'Reassign and delete';

  @override
  String get everythingBeyondYourDayTo =>
      'Everything beyond your day-to-day money';

  @override
  String get cutAcrossCategoriesBerlinTrip =>
      'Cut across categories — “Berlin trip”, “Work”';

  @override
  String get answerHowMuchWentOn => 'Answer “how much went on the Amex”';

  @override
  String get netWorthAndThisMonth => 'Net worth and this month, at a glance';

  @override
  String get csvInCsvOrJson => 'CSV in, CSV or JSON out';

  @override
  String get budgetsSharedMoneyAndApprovals =>
      'Budgets, shared money and approvals';

  @override
  String get replayOnboardingPreviewAnInvite =>
      'Replay onboarding, preview an invite, browse the state catalogue';

  @override
  String get exploreTheFirstRunExperience => 'Explore the first-run experience';

  @override
  String get previewAnIncomingSpaceInvite => 'Preview an incoming space invite';

  @override
  String get loadingEmptyErrorAndOffline => 'Loading, empty, error and offline';

  @override
  String get resetPrototypeData => 'Reset prototype data';

  @override
  String get resetAllPrototypeData => 'Reset all prototype data?';

  @override
  String get everyLocalChangeIsReplaced =>
      'Every local change is replaced with the original coherent Pockito fixture data.';

  @override
  String get prototypeDataReset => 'Prototype data reset';

  @override
  String get avatarColoursRotateLocallyIn =>
      'Avatar colours rotate locally in this prototype';

  @override
  String get thisChangesReportingTotalsOnly =>
      'This changes reporting totals only. Account and space currencies never change silently.';

  @override
  String get howShouldPockitoConvertCurrencies =>
      'How should Pockito convert currencies?';

  @override
  String get originalAmountsAreAlwaysPreserved =>
      'Original amounts are always preserved. Converted totals are approximate and carry the captured rate.';

  @override
  String get automaticSnapshotActive => 'Automatic snapshot active';

  @override
  String get mockedLocallyForThePrototype =>
      'Mocked locally for the prototype; no live FX service is called.';

  @override
  String get manualRatesRemainActiveUntil =>
      'Manual rates remain active until you switch back. Transfers cannot be saved when a required pair has no valid rate.';

  @override
  String yourManualRate(Object p0, Object p1) {
    return 'Your manual $p0 → $p1 rate';
  }

  @override
  String get saveManualRates => 'Save manual rates';

  @override
  String enterAValidRateFor(Object p0) {
    return 'Enter a valid rate for $p0';
  }

  @override
  String get manualExchangeRatesSaved => 'Manual exchange rates saved';

  @override
  String get followYourDevice => 'Follow your device';

  @override
  String alwaysUseMode(Object p0) {
    return 'Always use $p0 mode';
  }

  @override
  String get typographyBordersAndSemanticColours =>
      'Typography, borders and semantic colours adapt together.';

  @override
  String get notificationPreviewEnabled => 'Notification preview enabled';

  @override
  String get noSystemPermissionIsRequested =>
      'No system permission is requested in this prototype.';

  @override
  String get kitoTheOfficialPockitoMascot =>
      'Kito, the official Pockito mascot';

  @override
  String get moneyWithKitoPrototype => 'Money, with Kito · Prototype 0.1.0';

  @override
  String get pockitoGivesPersonalAndShared =>
      'Pockito gives personal and shared money one coherent home. Kito is the calm, helpful companion for insights, empty states and meaningful milestones. This Flutter build uses local fixture data only.';

  @override
  String get noPersonalDataLeavesThis =>
      'No personal data leaves this local prototype.';

  @override
  String get prototypeTermsAreIntentionallyLocal =>
      'Prototype terms are intentionally local and illustrative.';

  @override
  String get sharedExpensesBudgetAlertsAnd =>
      'Shared expenses, budget alerts and approvals will appear here.';

  @override
  String get homeScreenStates => 'Home screen states';

  @override
  String get chooseAStateReturnHome =>
      'Choose a state, return Home, and inspect the production treatment.';

  @override
  String get purposefulEmptyState => 'Purposeful empty state';

  @override
  String get everyEmptySurfaceExplainsWhat =>
      'Every empty surface explains what belongs here and offers a meaningful next action.';

  @override
  String get coherentFixtureData => 'Coherent fixture data';

  @override
  String get recoverableFullScreenError => 'Recoverable full-screen error';

  @override
  String get welcomeToPockito => 'Welcome to Pockito';

  @override
  String get personalAndSharedMoneyIn =>
      'Personal and shared money in one coherent place.';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get youExampleCom => 'you@example.com';

  @override
  String get continueWithEmail => 'Continue with email';

  @override
  String get previewAuthenticationError => 'Preview authentication error';

  @override
  String get authenticationIsSimulatedLocallyIn =>
      'Authentication is simulated locally in this UI prototype.';

  @override
  String get weCouldnTSignYou => 'We couldn’t sign you in';

  @override
  String get nothingWasChangedCheckYour =>
      'Nothing was changed. Check your connection and try again, or choose another sign-in method.';

  @override
  String get returnToPrototype => 'Return to prototype';

  @override
  String get moneyThatMakesSense => 'Money that makes sense';

  @override
  String get seeYourOwnAccountsAnd =>
      'See your own accounts and the money you share, without double-counting either.';

  @override
  String get makePockitoYours => 'Make Pockito yours';

  @override
  String get setTheIdentityAndDefaults =>
      'Set the identity and defaults people will see in shared spaces. You can change these later.';

  @override
  String get localProfileAvatar => 'local://profile/avatar';

  @override
  String get chooseProfilePhoto => 'Choose profile photo';

  @override
  String get photoSelectedLocally => 'Photo selected locally';

  @override
  String get useDeviceSetting => 'Use device setting';

  @override
  String get setYourHomeBase => 'Set your home base';

  @override
  String get thisOnlyControlsReportingEvery =>
      'This only controls reporting. Every account and space keeps its own currency.';

  @override
  String get givePockitoOnePlaceWhere =>
      'Give Pockito one place where money enters and leaves.';

  @override
  String get useTheSampleAccount => 'Use the sample account';

  @override
  String get shareMoneyWithSomeone => 'Share money with someone?';

  @override
  String get createASpaceForA2 =>
      'Create a space for a home, trip, couple or group. You can always do this later.';

  @override
  String get yesCreateASharedSpace => 'Yes, create a shared space';

  @override
  String get notRightNow => 'Not right now';

  @override
  String get spacesAreReadyWhenYou => 'Spaces are ready when you are';

  @override
  String get shareThisLinkTheInvite =>
      'Share this link. The invite expires in seven days and can be revoked.';

  @override
  String get youCanCreateAShared =>
      'You can create a shared space from the Spaces tab at any time.';

  @override
  String get pockitoWorksBeautifullyForPersonal =>
      'Pockito works beautifully for personal money too.';

  @override
  String get youReAllSet => 'You’re all set';

  @override
  String get yourOverviewAccountsSharedSpaces =>
      'Your overview, accounts, shared spaces and activity are ready to explore.';

  @override
  String get enterYourNameToContinue => 'Enter your name to continue';

  @override
  String get addAnAccountNameAnd => 'Add an account name and valid balance';

  @override
  String get joinBookClub => 'Join Book Club?';

  @override
  String get samInvitedYouToA =>
      'Sam invited you to a 4-person shared space using EUR.';

  @override
  String get joinedBookClubLocally => 'Joined Book Club locally';

  @override
  String get whatLeftYourAccounts => 'What left your accounts';

  @override
  String get onlyYourShare => 'Only your share';

  @override
  String get aCompleteSampleDatasetIs => 'A complete sample dataset is ready';

  @override
  String get youCanAddEditSplit =>
      'You can add, edit, split, settle and explore without connecting any real financial service.';

  @override
  String get confirmSettlement => 'Confirm settlement';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expenses',
      one: '1 expense',
    );
    return '$_temp0';
  }

  @override
  String settlementCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count settlements',
      one: '1 settlement',
    );
    return '$_temp0';
  }

  @override
  String paymentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
    );
    return '$_temp0';
  }

  @override
  String cycleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count previous cycles',
      one: '1 previous cycle',
    );
    return '$_temp0';
  }

  @override
  String recordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String activeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active accounts',
      one: '1 active account',
    );
    return '$_temp0';
  }

  @override
  String memberCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people',
      one: '1 person',
    );
    return '$_temp0';
  }

  @override
  String connectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count connections',
      one: '1 connection',
    );
    return '$_temp0';
  }

  @override
  String budgetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active budgets',
      one: '1 active budget',
    );
    return '$_temp0';
  }

  @override
  String categoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories',
      one: '1 category',
    );
    return '$_temp0';
  }

  @override
  String methodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payment methods',
      one: '1 payment method',
    );
    return '$_temp0';
  }

  @override
  String savedViewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count saved',
      one: '1 saved',
    );
    return '$_temp0';
  }

  @override
  String activeSubscriptionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active',
      one: '1 active',
    );
    return '$_temp0';
  }

  @override
  String tagCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tags',
      one: '1 tag',
    );
    return '$_temp0';
  }

  @override
  String get chooseAnAccountX => 'Choose an account';

  @override
  String exportsExactlyWhatActivityIs(Object p0) {
    return 'Exports exactly what Activity is showing right now — $p0 after your filters, not the whole ledger.';
  }

  @override
  String readFromThisReceipt(Object p0) {
    return 'Read from this receipt: $p0';
  }

  @override
  String spendingByCategory(Object p0) {
    return 'Spending by category. $p0';
  }

  @override
  String trendFromTo(Object p0, Object p1, Object p2) {
    return 'Trend from $p0 to $p1. $p2';
  }

  @override
  String nobodyMatches(Object p0) {
    return 'Nobody matches “$p0”';
  }

  @override
  String nothingMatchesQuery(Object p0) {
    return 'Nothing matches “$p0”.';
  }

  @override
  String searchCategoriesCount(Object p0) {
    return 'Search $p0 categories';
  }

  @override
  String proposedByAwaiting(Object p0, Object p1) {
    return 'Proposed by $p0 · awaiting $p1 confirmation';
  }

  @override
  String moveOutOf(Object p0) {
    return 'Move out of $p0';
  }

  @override
  String get yourWord => 'your';

  @override
  String get theirWord => 'their';

  @override
  String get statusLabel => 'Status';

  @override
  String get confirmedWord => 'Confirmed';

  @override
  String get cancelledWord => 'Cancelled';

  @override
  String moveOutOfParent(Object p0) {
    return 'Move out of $p0';
  }

  @override
  String get unverifiedClient => 'Unverified client';

  @override
  String get animatedSkeletons => 'Animated skeletons';

  @override
  String get firstUseGuidance => 'First-use guidance';

  @override
  String get localModeBanner => 'Local-mode banner';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get aiApp => 'AI app';

  @override
  String get kitoNoticed => 'Kito noticed';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get spent => 'Spent';

  @override
  String x0Over(Object p0) {
    return '$p0 over';
  }

  @override
  String x0Left(Object p0) {
    return '$p0 left';
  }

  @override
  String x0X1OfX2X3X4(Object p0, Object p1, Object p2, Object p3, Object p4) {
    return '$p0: $p1 of $p2. $p3. $p4';
  }

  @override
  String ofX0(Object p0) {
    return 'of $p0';
  }

  @override
  String get settled => 'Settled';

  @override
  String get youReOwed => 'You\'re owed';

  @override
  String get youOwe => 'You owe';

  @override
  String get transfer => 'Transfer';

  @override
  String get uncategorised => 'Uncategorised';

  @override
  String get shared => 'Shared';

  @override
  String yourShareX0(Object p0) {
    return 'Your share $p0';
  }

  @override
  String x0OfX1X2(Object p0, Object p1, Object p2) {
    return '$p0 of $p1 · $p2';
  }

  @override
  String lastX0(Object p0) {
    return 'last $p0';
  }

  @override
  String get retry => 'Retry';

  @override
  String get addMoney => 'Add money';

  @override
  String get expense => 'Expense';

  @override
  String get income => 'Income';

  @override
  String get betweenAccounts => 'Between accounts';

  @override
  String get scan => 'Scan';

  @override
  String x0Results(Object p0) {
    return '$p0 results';
  }

  @override
  String get amount => 'Amount';

  @override
  String get date => 'Date';

  @override
  String get lastWeek => 'Last week';

  @override
  String get searchAccounts => 'Search accounts';

  @override
  String get searchCategories => 'Search categories';

  @override
  String inX0(Object p0) {
    return 'in $p0';
  }

  @override
  String searchX0Currencies(Object p0) {
    return 'Search $p0 currencies';
  }

  @override
  String get all => 'All';

  @override
  String get you => 'You';

  @override
  String x0You(Object p0) {
    return '$p0 (you)';
  }

  @override
  String get searchMembers => 'Search members';

  @override
  String get tags => 'Tags';

  @override
  String get newTag => 'New tag';

  @override
  String get clear => 'Clear';

  @override
  String voidedX0(Object p0) {
    return 'Voided $p0.';
  }

  @override
  String get attachments => 'Attachments';

  @override
  String get attach => 'Attach';

  @override
  String removeX0(Object p0) {
    return 'Remove $p0';
  }

  @override
  String get queued => 'Queued';

  @override
  String get reading => 'Reading';

  @override
  String get read => 'Read';

  @override
  String get unreadable => 'Unreadable';

  @override
  String capturedX0(Object p0) {
    return 'Captured $p0';
  }

  @override
  String get reason => 'Reason';

  @override
  String get delete => 'Delete';

  @override
  String youCanTX0(Object p0) {
    return 'You can’t $p0';
  }

  @override
  String get saving => 'Saving…';

  @override
  String get loading => 'Loading';

  @override
  String payX0(Object p0) {
    return 'Pay $p0?';
  }

  @override
  String x0WillBeRecordedFromX1ThisIsLocalPrototypeDa(Object p0, Object p1) {
    return '$p0 will be recorded from $p1. This is local prototype data.';
  }

  @override
  String get recordPayment => 'Record payment';

  @override
  String get view => 'View';

  @override
  String get assistant => 'Assistant';

  @override
  String get notifications => 'Notifications';

  @override
  String get addAccount => 'Add account';

  @override
  String get createSpace => 'Create space';

  @override
  String get and => ' and ';

  @override
  String overdueByX0DayX1(Object p0, Object p1) {
    return 'Overdue by $p0 day$p1';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String get pay => 'Pay';

  @override
  String get add => 'Add';

  @override
  String get chooseMonth => 'Choose month';

  @override
  String x0MoneyEventX1(Object p0, Object p1) {
    return '$p0 money event$p1';
  }

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get tag => 'Tag';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get includingVoided => 'Including voided';

  @override
  String get draftsHidden => 'Drafts hidden';

  @override
  String savedX0(Object p0) {
    return 'Saved “$p0”';
  }

  @override
  String get savedViews => 'Saved views';

  @override
  String deleteX0(Object p0) {
    return 'Delete $p0';
  }

  @override
  String get moneyEvent => 'Money event';

  @override
  String get restored => 'Restored';

  @override
  String get edit => 'Edit';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get type => 'Type';

  @override
  String get from => 'From';

  @override
  String get notTracked => 'Not tracked';

  @override
  String get to => 'To';

  @override
  String get sent => 'Sent';

  @override
  String get received => 'Received';

  @override
  String get exchangeRate => 'Exchange rate';

  @override
  String get rateCaptured => 'Rate captured';

  @override
  String get fee => 'Fee';

  @override
  String get none => 'None';

  @override
  String get sharedSpace => 'Shared space';

  @override
  String get addedVia => 'Added via';

  @override
  String get aiConnection => 'AI connection';

  @override
  String get paidWith => 'Paid with';

  @override
  String get originalAmount => 'Original amount';

  @override
  String get rateUsed => 'Rate used';

  @override
  String get correctionReason => 'Correction reason';

  @override
  String get note => 'Note';

  @override
  String get receipts => 'Receipts';

  @override
  String get settlement => 'Settlement';

  @override
  String get whyOptional => 'Why? (optional)';

  @override
  String get voidIt => 'Void it';

  @override
  String voidedX02(Object p0) {
    return 'Voided $p0';
  }

  @override
  String get youReOffline => 'You’re offline';

  @override
  String get description => 'Description';

  @override
  String get source => 'Source';

  @override
  String get merchant => 'Merchant';

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get toAccount => 'To account';

  @override
  String get fromAccount => 'From account';

  @override
  String get automatic => 'Automatic';

  @override
  String get manual => 'Manual';

  @override
  String l1X0InX1(Object p0, Object p1) {
    return '1 $p0 in $p1';
  }

  @override
  String x0UpdatedX1(Object p0, Object p1) {
    return '$p0 · updated $p1';
  }

  @override
  String get feeOptional => 'Fee (optional)';

  @override
  String get destinationReceives => 'Destination receives';

  @override
  String fromX0X1Rate(Object p0, Object p1) {
    return '≈ from $p0 · $p1 rate';
  }

  @override
  String get notRecorded => 'Not recorded';

  @override
  String get paidBy => 'Paid by';

  @override
  String get split => 'Split';

  @override
  String get walletConversion => 'Wallet conversion';

  @override
  String x0SpaceAmount(Object p0) {
    return '$p0 space amount';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get addIncome => 'Add income';

  @override
  String get addTransfer => 'Add transfer';

  @override
  String get addExpense => 'Add expense';

  @override
  String get spaceDefault6040 => 'Space default · 60/40';

  @override
  String equallyBetweenX0(Object p0) {
    return 'Equally between $p0';
  }

  @override
  String x0x1X2People(Object p0, Object p1, Object p2) {
    return '$p0$p1 · $p2 people';
  }

  @override
  String receiptX0(Object p0) {
    return 'Receipt · $p0';
  }

  @override
  String get reviewReceipt => 'Review receipt';

  @override
  String get scanReceipt => 'Scan receipt';

  @override
  String get closeScanner => 'Close scanner';

  @override
  String get captureReceipt => 'Capture receipt';

  @override
  String get lowConfidenceMode => 'Low-confidence mode ✓';

  @override
  String get failureMode => 'Failure mode ✓';

  @override
  String get retake => 'Retake';

  @override
  String get retryScan => 'Retry scan';

  @override
  String get unreadableReceipt => 'Unreadable receipt';

  @override
  String get filterActivity => 'Filter activity';

  @override
  String get allTime => 'All time';

  @override
  String get previousMonth => 'Previous month';

  @override
  String get wallet => 'Wallet';

  @override
  String get searchSpaces => 'Search Spaces';

  @override
  String get searchTags => 'Search tags';

  @override
  String get lifecycle => 'Lifecycle';

  @override
  String get showVoided => 'Show voided';

  @override
  String get showDrafts => 'Show drafts';

  @override
  String get showEverything => 'Show everything';

  @override
  String applyX0Filters(Object p0) {
    return 'Apply $p0 filters';
  }

  @override
  String get splitExpense => 'Split expense';

  @override
  String x0InX1(Object p0, Object p1) {
    return '$p0 in $p1';
  }

  @override
  String get equal => 'Equal';

  @override
  String get percentage => 'Percentage';

  @override
  String get shares => 'Shares';

  @override
  String get exactAmounts => 'Exact amounts';

  @override
  String get itemized => 'Itemized';

  @override
  String x0You2(Object p0) {
    return '$p0 · You';
  }

  @override
  String get previewSplit => 'Preview split';

  @override
  String get addLine => 'Add line';

  @override
  String get keepEditing => 'Keep editing';

  @override
  String get onePayer => 'One payer';

  @override
  String voidedX03(Object p0) {
    return 'Voided: $p0';
  }

  @override
  String voidX0(Object p0) {
    return 'Void $p0?';
  }

  @override
  String get open => 'Open';

  @override
  String get archivedSpaces => 'Archived spaces';

  @override
  String youOweX0(Object p0) {
    return 'You owe $p0';
  }

  @override
  String x0OwesYou(Object p0) {
    return '$p0 owes you';
  }

  @override
  String get settlementHistory => 'Settlement history';

  @override
  String get members2 => 'Members';

  @override
  String get spaceSettings => 'Space settings';

  @override
  String get money => 'Money';

  @override
  String get people => 'People';

  @override
  String x0PreviousX1(Object p0, Object p1) {
    return '$p0 previous $p1';
  }

  @override
  String get cycleHistory => 'Cycle history';

  @override
  String x0Expenses(Object p0) {
    return '$p0 expenses';
  }

  @override
  String get filter => 'Filter';

  @override
  String x0AddedX1(Object p0, Object p1) {
    return '$p0 added $p1';
  }

  @override
  String get balanceBreakdown => 'Balance breakdown';

  @override
  String paidX0ShareX1(Object p0, Object p1) {
    return 'Paid $p0 · share $p1';
  }

  @override
  String get notYet => 'Not yet';

  @override
  String get filterExpenses => 'Filter expenses';

  @override
  String get unsettled => 'Unsettled';

  @override
  String get allMembers => 'All members';

  @override
  String get allCategories => 'All categories';

  @override
  String get applyFilters => 'Apply filters';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get historicalExpense => 'Historical expense';

  @override
  String get recordedBy => 'Recorded by';

  @override
  String get someone => 'Someone';

  @override
  String get splitMethod => 'Split method';

  @override
  String get sharedBudget => 'Shared budget';

  @override
  String get inviteSomeone => 'Invite someone';

  @override
  String get spaceName => 'Space name';

  @override
  String get spaceCurrency => 'Space currency';

  @override
  String get icon => 'Icon';

  @override
  String get colour => 'Colour';

  @override
  String get names => 'Names';

  @override
  String get emails => 'Emails';

  @override
  String get copy => 'Copy';

  @override
  String get skipInvitation => 'Skip invitation';

  @override
  String x0Monthly(Object p0) {
    return '$p0 monthly';
  }

  @override
  String get membersInvites => 'Members & invites';

  @override
  String get invite => 'Invite';

  @override
  String searchX0Members(Object p0) {
    return 'Search $p0 members';
  }

  @override
  String pendingInvitesX0(Object p0) {
    return 'Pending invites ($p0)';
  }

  @override
  String x0AsX1X2X3(Object p0, Object p1, Object p2, Object p3) {
    return '$p0 · as $p1 · $p2$p3';
  }

  @override
  String get pending => 'Pending';

  @override
  String get resend => 'Resend';

  @override
  String get revoke => 'Revoke';

  @override
  String x0JoinedAsX1(Object p0, Object p1) {
    return '$p0 joined as $p1';
  }

  @override
  String get simulateAcceptance => 'Simulate acceptance';

  @override
  String get simulateDecline => 'Simulate decline';

  @override
  String get invitationHistory => 'Invitation history';

  @override
  String x0AsX1(Object p0, Object p1) {
    return '$p0 · as $p1';
  }

  @override
  String get inviteAgain => 'Invite again';

  @override
  String get keepIt => 'Keep it';

  @override
  String get viewBalances => 'View balances';

  @override
  String get changeRole => 'Change role';

  @override
  String currentlyX0(Object p0) {
    return 'Currently $p0';
  }

  @override
  String leaveX0(Object p0) {
    return 'Leave $p0';
  }

  @override
  String x0SRole(Object p0) {
    return '$p0’s role';
  }

  @override
  String leaveX02(Object p0) {
    return 'Leave $p0?';
  }

  @override
  String get leave => 'Leave';

  @override
  String youLeftX0(Object p0) {
    return 'You left $p0';
  }

  @override
  String x0SBalance(Object p0) {
    return '$p0’s balance';
  }

  @override
  String get currentCycle => 'Current cycle';

  @override
  String get lifetime => 'Lifetime';

  @override
  String removeX02(Object p0) {
    return 'Remove $p0?';
  }

  @override
  String get remove => 'Remove';

  @override
  String x0Removed(Object p0) {
    return '$p0 removed';
  }

  @override
  String inviteToX0(Object p0) {
    return 'Invite to $p0';
  }

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get joinAs => 'Join as';

  @override
  String x0DayX1(Object p0, Object p1) {
    return '$p0 day$p1';
  }

  @override
  String get sendInvite => 'Send invite';

  @override
  String get defaultSplit => 'Default split';

  @override
  String youAreX0(Object p0) {
    return 'You are $p0';
  }

  @override
  String get activityLog => 'Activity log';

  @override
  String get newExpenses => 'New expenses';

  @override
  String get settlements => 'Settlements';

  @override
  String get allActivity => 'All activity';

  @override
  String get reopenSpace => 'Reopen Space';

  @override
  String get archiveSpace => 'Archive Space';

  @override
  String get renameSpace => 'Rename space';

  @override
  String get exact => 'Exact';

  @override
  String archiveX0(Object p0) {
    return 'Archive $p0?';
  }

  @override
  String get archive => 'Archive';

  @override
  String backToX0(Object p0) {
    return 'Back to $p0';
  }

  @override
  String get suggestedPayments => 'Suggested payments';

  @override
  String x0PayX1X2(Object p0, Object p1, Object p2) {
    return '$p0 pay$p1 $p2';
  }

  @override
  String get paidFrom => 'Paid from';

  @override
  String get receivedIn => 'Received in';

  @override
  String get walletMovement => 'Wallet movement';

  @override
  String get reviewSettlement => 'Review settlement';

  @override
  String get goBack => 'Go back';

  @override
  String x0PaymentX1RemainThisWalletMovementDidNotCou(Object p0, Object p1) {
    return '$p0 payment$p1 remain. This wallet movement did not count as spending.';
  }

  @override
  String x0X1X2Total(Object p0, Object p1, Object p2) {
    return '$p0 $p1 · $p2 total';
  }

  @override
  String get pastSettlements => 'Past settlements';

  @override
  String cycleClosedX0(Object p0) {
    return 'Cycle closed $p0';
  }

  @override
  String get newSettlement => 'New settlement';

  @override
  String x0PaidX1(Object p0, Object p1) {
    return '$p0 paid $p1';
  }

  @override
  String get aMember => 'A member';

  @override
  String get settlementDetail => 'Settlement detail';

  @override
  String get settlementConfirmed => 'Settlement confirmed';

  @override
  String get settlementCancelled => 'Settlement cancelled';

  @override
  String x0ConfirmsThisBeforeAnyBalanceMoves(Object p0) {
    return '$p0 confirms this before any balance moves.';
  }

  @override
  String onlyX0CanConfirmThis(Object p0) {
    return 'Only $p0 can confirm this';
  }

  @override
  String get theRecipient => 'The recipient';

  @override
  String get cancelSettlement => 'Cancel settlement';

  @override
  String get spaceCycles => 'Space cycles';

  @override
  String x0ExpensesX1(Object p0, Object p1) {
    return '$p0 expenses · $p1';
  }

  @override
  String x0OfX1Budget(Object p0, Object p1) {
    return '$p0 of $p1 budget';
  }

  @override
  String previousCyclesX0(Object p0) {
    return 'Previous cycles ($p0)';
  }

  @override
  String get period => 'Period';

  @override
  String get noBudget => 'No budget';

  @override
  String get finalStatus => 'Final status';

  @override
  String get everyoneSettled => 'Everyone settled';

  @override
  String get memberContributions => 'Member contributions';

  @override
  String responsibleForX0(Object p0) {
    return 'Responsible for $p0';
  }

  @override
  String paidX0(Object p0) {
    return 'Paid $p0';
  }

  @override
  String get categories => 'Categories';

  @override
  String expensesX0(Object p0) {
    return 'Expenses ($p0)';
  }

  @override
  String get allTimeBalance => 'All-time balance';

  @override
  String get cycle => 'Cycle';

  @override
  String get breakdown => 'Breakdown';

  @override
  String x0PaidX12(Object p0, Object p1) {
    return '$p0 paid · $p1';
  }

  @override
  String viaX0(Object p0) {
    return 'via $p0';
  }

  @override
  String x0Activity(Object p0) {
    return '$p0 activity';
  }

  @override
  String get friendly => 'Friendly';

  @override
  String get detailed => 'Detailed';

  @override
  String get accountActions => 'Account actions';

  @override
  String get reorderAccounts => 'Reorder accounts';

  @override
  String get archivedAccounts => 'Archived accounts';

  @override
  String searchX0Accounts(Object p0) {
    return 'Search $p0 accounts';
  }

  @override
  String get editAccount => 'Edit account';

  @override
  String get archiveAccount => 'Archive account';

  @override
  String get last30Days => 'Last 30 days';

  @override
  String ofX0Limit(Object p0) {
    return 'of $p0 limit';
  }

  @override
  String get savingsGoal => 'Savings goal';

  @override
  String x0OfX1(Object p0, Object p1) {
    return '$p0 of $p1';
  }

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get accountName => 'Account name';

  @override
  String get accountType => 'Account type';

  @override
  String get currency => 'Currency';

  @override
  String get openingBalance => 'Opening balance';

  @override
  String get currentBalance => 'Current balance';

  @override
  String get defaultAccount => 'Default account';

  @override
  String x0Added(Object p0) {
    return '$p0 added';
  }

  @override
  String get accountUpdated => 'Account updated';

  @override
  String x0X1Rate(Object p0, Object p1) {
    return '≈ $p0 · $p1 rate';
  }

  @override
  String get aiIntegrations => 'AI & integrations';

  @override
  String get connections => 'Connections';

  @override
  String lastUsedX0(Object p0) {
    return 'Last used $p0';
  }

  @override
  String get authorizationRequest => 'Authorization request';

  @override
  String get verifiedApplication => 'Verified application';

  @override
  String get transactions => 'Transactions';

  @override
  String get spacesBalances => 'Spaces & balances';

  @override
  String get analytics => 'Analytics';

  @override
  String allowX0(Object p0) {
    return 'Allow $p0';
  }

  @override
  String get donTAllow => 'Don’t allow';

  @override
  String get financialChanges => 'Financial changes';

  @override
  String get connected => 'Connected';

  @override
  String get suspended => 'Suspended';

  @override
  String get lastUsed => 'Last used';

  @override
  String get reads => 'Reads';

  @override
  String get writes => 'Writes';

  @override
  String get permissions => 'Permissions';

  @override
  String get disconnectApp => 'Disconnect app';

  @override
  String get connectionPermissions => 'Connection permissions';

  @override
  String get savePermissions => 'Save permissions';

  @override
  String disconnectX0(Object p0) {
    return 'Disconnect $p0?';
  }

  @override
  String get disconnect => 'Disconnect';

  @override
  String get aiActivity => 'AI activity';

  @override
  String addedX0(Object p0) {
    return 'Added $p0';
  }

  @override
  String get pendingApprovals => 'Pending approvals';

  @override
  String get recordedOn => 'Recorded on';

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get requestRejected => 'Request rejected';

  @override
  String get addTag => 'Add tag';

  @override
  String searchX0Tags(Object p0) {
    return 'Search $p0 tags';
  }

  @override
  String nothingMatchesX0(Object p0) {
    return 'Nothing matches “$p0”';
  }

  @override
  String onX0RecordX1(Object p0, Object p1) {
    return 'On $p0 record$p1';
  }

  @override
  String renameX0(Object p0) {
    return 'Rename $p0';
  }

  @override
  String get tagAdded => 'Tag added';

  @override
  String get tagRenamed => 'Tag renamed';

  @override
  String get rename => 'Rename';

  @override
  String x0Deleted(Object p0) {
    return '$p0 deleted';
  }

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get addOne => 'Add one';

  @override
  String get card => 'Card';

  @override
  String get bankTransfer => 'Bank transfer';

  @override
  String get cash => 'Cash';

  @override
  String get directDebit => 'Direct debit';

  @override
  String get digitalWallet => 'Digital wallet';

  @override
  String x0Records(Object p0) {
    return '$p0 records';
  }

  @override
  String get saved => 'Saved';

  @override
  String get importExport => 'Import & export';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String lineX0X1(Object p0, Object p1) {
    return 'Line $p0 · $p1';
  }

  @override
  String importX0RecordX1(Object p0, Object p1) {
    return 'Import $p0 record$p1';
  }

  @override
  String x0Imported(Object p0) {
    return '$p0 imported';
  }

  @override
  String x0Copied(Object p0) {
    return '$p0 copied';
  }

  @override
  String correctX0(Object p0) {
    return 'Correct $p0';
  }

  @override
  String get balanceCorrected => 'Balance corrected';

  @override
  String get reportingTotal => 'Reporting total';

  @override
  String get reportingCurrency => 'Reporting currency';

  @override
  String get notCombined => 'Not combined';

  @override
  String get createBudget => 'Create budget';

  @override
  String get personal => 'Personal';

  @override
  String get sharedSpaces => 'Shared spaces';

  @override
  String get editBudget => 'Edit budget';

  @override
  String get deleteBudget => 'Delete budget';

  @override
  String get used => 'Used';

  @override
  String get limit => 'Limit';

  @override
  String get carriedOver => 'Carried over';

  @override
  String lastX02(Object p0) {
    return 'Last $p0';
  }

  @override
  String get scope => 'Scope';

  @override
  String get over => 'Over';

  @override
  String get close => 'Close';

  @override
  String get onTrack => 'On track';

  @override
  String get includedSpending => 'Included spending';

  @override
  String get monthlyHistory => 'Monthly history';

  @override
  String get allExpenses => 'All expenses';

  @override
  String get allWallets => 'all wallets';

  @override
  String x0X1Only(Object p0, Object p1) {
    return '$p0 · $p1 only';
  }

  @override
  String deleteX02(Object p0) {
    return 'Delete $p0?';
  }

  @override
  String get budgetName => 'Budget name';

  @override
  String get wallets => 'Wallets';

  @override
  String get allWallets2 => 'All wallets';

  @override
  String x0Limit(Object p0) {
    return '$p0 limit';
  }

  @override
  String get resets => 'Resets';

  @override
  String everyX0Days(Object p0) {
    return 'Every $p0 days';
  }

  @override
  String get fewerDays => 'Fewer days';

  @override
  String get moreDays => 'More days';

  @override
  String get alertAt80 => 'Alert at 80%';

  @override
  String get alertAt100 => 'Alert at 100%';

  @override
  String get subscriptions => 'Subscriptions';

  @override
  String get active => 'Active';

  @override
  String get addSubscription => 'Add subscription';

  @override
  String get paused => 'Paused';

  @override
  String get editSubscription => 'Edit subscription';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get nextDue => 'Next due';

  @override
  String get notScheduled => 'Not scheduled';

  @override
  String get unknown => 'Unknown';

  @override
  String get started => 'Started';

  @override
  String get skipNext => 'Skip next';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get everyYear => 'Every year';

  @override
  String get everyWeek => 'Every week';

  @override
  String get everyDay => 'Every day';

  @override
  String get everyMonth => 'Every month';

  @override
  String everyX0Months(Object p0) {
    return 'Every $p0 months';
  }

  @override
  String recordX0(Object p0) {
    return 'Record $p0?';
  }

  @override
  String get record => 'Record';

  @override
  String get skip => 'Skip';

  @override
  String get billingCurrency => 'Billing currency';

  @override
  String get cadence => 'Cadence';

  @override
  String get addCategory => 'Add category';

  @override
  String get editCategory => 'Edit category';

  @override
  String get saveCategory => 'Save category';

  @override
  String x0OverBudget(Object p0) {
    return '$p0 over budget';
  }

  @override
  String x0Remaining(Object p0) {
    return '$p0 remaining';
  }

  @override
  String get monthlyCost => 'Monthly cost';

  @override
  String get repeats => 'Repeats';

  @override
  String get subcategory => 'Subcategory';

  @override
  String get pockitoCategory => 'Pockito category';

  @override
  String get customCategory => 'Custom category';

  @override
  String get showAgain => 'Show again';

  @override
  String get hide => 'Hide';

  @override
  String x0Hidden(Object p0) {
    return '$p0 hidden';
  }

  @override
  String nestX0Under(Object p0) {
    return 'Nest $p0 under';
  }

  @override
  String x0NowSitsUnderX1(Object p0, Object p1) {
    return '$p0 now sits under $p1';
  }

  @override
  String get moveTo => 'Move to';

  @override
  String x0MoneyEvents(Object p0) {
    return '$p0 money events';
  }

  @override
  String x0Active(Object p0) {
    return '$p0 active';
  }

  @override
  String get defaultCurrency => 'Default currency';

  @override
  String x0ReportingOnly(Object p0) {
    return '$p0 · Reporting only';
  }

  @override
  String get exchangeRates => 'Exchange rates';

  @override
  String automaticX0(Object p0) {
    return 'Automatic · $p0';
  }

  @override
  String get manualRates => 'Manual rates';

  @override
  String get preferences => 'Preferences';

  @override
  String get appearance => 'Appearance';

  @override
  String get language => 'Language';

  @override
  String get aboutPockito => 'About Pockito';

  @override
  String get prototypeTools => 'Prototype tools';

  @override
  String get prototype => 'Prototype';

  @override
  String get replayOnboarding => 'Replay onboarding';

  @override
  String get invitationReview => 'Invitation review';

  @override
  String get stateCatalogue => 'State catalogue';

  @override
  String get reset => 'Reset';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get displayName => 'Display name';

  @override
  String get country => 'Country';

  @override
  String get saveProfile => 'Save profile';

  @override
  String reportingInX0(Object p0) {
    return 'Reporting in $p0';
  }

  @override
  String providerX0(Object p0) {
    return 'Provider · $p0';
  }

  @override
  String lastUpdatedX0(Object p0) {
    return 'Last updated · $p0';
  }

  @override
  String get manualConfiguration => 'Manual configuration';

  @override
  String get preview => 'Preview';

  @override
  String get pockitoSurface => 'Pockito surface';

  @override
  String get language2 => 'Language · 言語';

  @override
  String get privacy => 'Privacy';

  @override
  String get terms => 'Terms';

  @override
  String get licences => 'Licences';

  @override
  String get allQuiet => 'All quiet';

  @override
  String get components => 'Components';

  @override
  String get moneyTogether => 'Money, together.';

  @override
  String get bankAccount => 'Bank account';

  @override
  String get getStarted => 'Get started';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get savings => 'Savings';

  @override
  String get copyLink => 'Copy link';

  @override
  String get noPressure => 'No pressure';

  @override
  String get openPockito => 'Open Pockito';

  @override
  String get spaceInvitation => 'Space invitation';

  @override
  String get l4People => '4 people';

  @override
  String get invitedBy => 'Invited by';

  @override
  String get joinSpace => 'Join space';

  @override
  String get decline => 'Decline';

  @override
  String get cashFlow => 'Cash flow';

  @override
  String get yourSpending => 'Your spending';

  @override
  String get defaultLabel => 'Default';

  @override
  String get continueLabel => 'Continue';

  @override
  String get home => 'Home';

  @override
  String get trip => 'Trip';

  @override
  String get couple => 'Couple';

  @override
  String get or => 'or';

  @override
  String get tryAgain => 'Try again';

  @override
  String get prototypeMarketSnapshot => 'Prototype market snapshot';

  @override
  String get cancel => 'Cancel';

  @override
  String get notNow => 'Not now';

  @override
  String onTrackForX0ByTheEndOfTheX1(Object p0, Object p1) {
    return 'On track for $p0 by the end of the $p1.';
  }

  @override
  String get theSelectedAccount => 'the selected account';

  @override
  String get expiresToday => 'expires today';

  @override
  String expiresInX0Days(Object p0) {
    return 'expires in $p0 days';
  }

  @override
  String resentX0Times(Object p0) {
    return ' · resent $p0×';
  }

  @override
  String get periodNounWeek => 'week';

  @override
  String get periodNounMonth => 'month';

  @override
  String get periodNounQuarter => 'quarter';

  @override
  String get periodNounYear => 'year';

  @override
  String get periodNounPeriod => 'period';

  @override
  String get awaitingYourConfirmation => 'Awaiting your confirmation';

  @override
  String get awaitingTheirConfirmation => 'Awaiting their confirmation';

  @override
  String get cancelled => 'Cancelled';

  @override
  String x0JoinedTheSpace(Object p0) {
    return '$p0 joined the space';
  }

  @override
  String get accountTypeBank => 'Bank';

  @override
  String get accountTypeCard => 'Card';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeSavings => 'Savings';

  @override
  String get accountTypeDigital => 'Digital';

  @override
  String get statusVoided => 'Voided';

  @override
  String get statusDraft => 'Draft';

  @override
  String get budgetsTitle => 'Budgets';

  @override
  String get moreTitle => 'More';

  @override
  String get notifUnread => 'Unread';

  @override
  String get notifToday => 'Today';

  @override
  String get notifEarlier => 'Earlier';

  @override
  String get categoryLabel => 'Category';

  @override
  String get addHintMoneyOut => 'Money out';

  @override
  String get addHintMoneyIn => 'Money in';

  @override
  String get accountLabel => 'Account';

  @override
  String get spaceLabel => 'Space';

  @override
  String get budgetLabel => 'Budget';

  @override
  String get sharedExpenseLabel => 'Shared expense';

  @override
  String get budgetDaysLeft => 'Days left';

  @override
  String get budgetDailyAllowance => 'Daily allowance';

  @override
  String get languageEnglish => 'English';

  @override
  String get profileSampleCountry => 'Germany';

  @override
  String get aboutVersion => 'Prototype 0.1.0';

  @override
  String get budgetPace => 'Pace';

  @override
  String get sampleMemberNames => 'Kana, Fran';

  @override
  String get eventTypeExpense => 'Expense';

  @override
  String get eventTypeIncome => 'Income';

  @override
  String get eventTypeTransfer => 'Transfer';

  @override
  String get eventTypeSettlement => 'Settlement';

  @override
  String get eventTypeAdjustment => 'Adjustment';

  @override
  String get quickAddExpense => 'Quick expense';

  @override
  String get quickAddMoreOptions => 'More options';

  @override
  String get quickAddSaved => 'Added';

  @override
  String get budgetUsed => 'used';

  @override
  String get subscriptionsOverdue => 'Overdue';

  @override
  String get subscriptionsDueSoon => 'Due soon';

  @override
  String get subscriptionsLater => 'Later';

  @override
  String dueX0(String x0) {
    return 'Due $x0';
  }

  @override
  String get aiVerified => 'Verified';

  @override
  String onboardingStepX0OfX1(int x0, int x1) {
    return 'Step $x0 of $x1';
  }

  @override
  String colourOptionX0(int x0) {
    return 'Colour $x0';
  }

  @override
  String get changeAvatar => 'Change avatar';

  @override
  String get balanceHidden => 'Balance hidden';

  @override
  String get privacyHideBalances => 'Hide balances';

  @override
  String get privacyHideBalancesDetail =>
      'Mask every amount without changing the layout.';

  @override
  String get done => 'Done';

  @override
  String get selected => 'selected';

  @override
  String get addANote => 'Add a note';

  @override
  String get member => 'Member';

  @override
  String get cadenceDaily => 'Daily';

  @override
  String get cadenceWeekly => 'Weekly';

  @override
  String get cadenceMonthly => 'Monthly';

  @override
  String get cadenceYearly => 'Yearly';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryLuxembourg => 'Luxembourg';

  @override
  String get countryTunisia => 'Tunisia';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get balanceImpactTitle => 'What this changes';

  @override
  String balanceImpactWillOwe(String name) {
    return '$name will owe you';
  }

  @override
  String balanceImpactYouWillOwe(String name) {
    return 'You will owe $name';
  }

  @override
  String get balanceImpactNoChange => 'Nothing changes between you';

  @override
  String balanceImpactWith(String name) {
    return 'Your balance with $name';
  }

  @override
  String splitBarLabel(String name, int percent, String amount) {
    return '$name, $percent% — $amount';
  }

  @override
  String get splitBarTitle => 'How this splits';

  @override
  String get iconGroupMoney => 'Money';

  @override
  String get iconGroupFood => 'Food & drink';

  @override
  String get iconGroupHome => 'Home & bills';

  @override
  String get iconGroupTransport => 'Getting around';

  @override
  String get iconGroupTravel => 'Travel';

  @override
  String get iconGroupHealth => 'Health';

  @override
  String get iconGroupLeisure => 'Leisure';

  @override
  String get iconGroupShopping => 'Shopping';

  @override
  String get iconGroupWork => 'Work & study';

  @override
  String get iconGroupPeople => 'People';

  @override
  String get iconGroupOther => 'Other';

  @override
  String get chooseAnIcon => 'Choose an icon';

  @override
  String get searchIcons => 'Search icons';

  @override
  String get searchKindDestination => 'Go to';

  @override
  String get searchTermsHome => 'home,dashboard,overview,net worth';

  @override
  String get searchTermsAccounts => 'accounts,wallet,bank,balance,cash';

  @override
  String get searchTermsSpaces => 'spaces,shared,group,household,split,members';

  @override
  String get searchTermsActivity =>
      'activity,transactions,history,ledger,expenses';

  @override
  String get searchTermsBudgets => 'budgets,limit,spending plan';

  @override
  String get searchTermsSubscriptions =>
      'subscriptions,recurring,renewals,bills';

  @override
  String get searchTermsCategories => 'categories,tags,labels';

  @override
  String get searchTermsNotifications => 'notifications,alerts,inbox';

  @override
  String get searchTermsSettings =>
      'settings,preferences,profile,currency,theme';

  @override
  String get searchTermsAssistant => 'assistant,ai,kito,insights';

  @override
  String get recordHistory => 'How this got here';

  @override
  String get timelineRecorded => 'Recorded';

  @override
  String get timelineEdited => 'Edited';

  @override
  String timelineEditedDetail(Object p0) {
    return 'Revised $p0 times since it was recorded';
  }

  @override
  String get timelineVoided => 'Voided';

  @override
  String get timelineAwaitingConfirmation => 'Waiting to be confirmed';

  @override
  String get timelineAwaitingDetail =>
      'It does not move a balance until someone confirms it';

  @override
  String get timelineSettled => 'Settled';

  @override
  String get timelineSettledDetail =>
      'Part of a closed cycle, so it is read-only now';

  @override
  String timelineByX0On(Object p0, Object p1) {
    return '$p0 · $p1';
  }

  @override
  String timelineAddedByAssistant(Object p0) {
    return 'Added by $p0';
  }

  @override
  String get homeInsights => 'Trends';

  @override
  String get homeInsightsSubtitle =>
      'Where the month went, and how it compares';

  @override
  String homeAccountsSummary(Object p0, Object p1) {
    return '$p0 across $p1';
  }

  @override
  String homeUpcomingSummary(Object p0) {
    return '$p0 due';
  }

  @override
  String get homeUpcomingNone => 'Nothing due';

  @override
  String homeWhereItWentSummary(Object p0, Object p1) {
    return '$p0 in $p1';
  }

  @override
  String get homeNothingSpentYet => 'Nothing spent yet';
}
