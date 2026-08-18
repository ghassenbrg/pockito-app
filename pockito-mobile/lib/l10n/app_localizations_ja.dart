// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class PkStringsJa extends PkStrings {
  PkStringsJa([String locale = 'ja']) : super(locale);

  @override
  String get navHome => 'ホーム';

  @override
  String get navAccounts => '口座';

  @override
  String get navSpaces => 'スペース';

  @override
  String get navMore => 'その他';

  @override
  String get addMoneyEvent => '記録を追加';

  @override
  String get actionCancel => 'キャンセル';

  @override
  String get actionSave => '保存';

  @override
  String get actionDone => '完了';

  @override
  String get actionRetry => 'もう一度';

  @override
  String get actionUndo => '元に戻す';

  @override
  String get actionClearSearch => '検索をクリア';

  @override
  String get actionResetAll => 'すべて解除';

  @override
  String get actionSaveView => 'この条件を保存';

  @override
  String get actionGotIt => 'わかりました';

  @override
  String get actionSearch => '検索';

  @override
  String get sortNewestFirst => '新しい順';

  @override
  String get sortOldestFirst => '古い順';

  @override
  String get sortLargestAmount => '金額の大きい順';

  @override
  String get sortSmallestAmount => '金額の小さい順';

  @override
  String get sortNameAsc => '名前順（A→Z）';

  @override
  String get sortNameDesc => '名前順（Z→A）';

  @override
  String get sortHighestBalance => '残高の多い順';

  @override
  String get sortLowestBalance => '残高の少ない順';

  @override
  String get sortBy => '並べ替え';

  @override
  String get roleOwner => 'オーナー';

  @override
  String get roleAdmin => '管理者';

  @override
  String get roleMember => 'メンバー';

  @override
  String get roleViewer => '閲覧者';

  @override
  String get roleOwnerSummary => '役割の変更とアーカイブを含む、すべての操作ができます。オーナーは常に1人います。';

  @override
  String get roleAdminSummary => '誰の支出でも編集でき、予算の管理、メンバーの招待と削除ができます。';

  @override
  String get roleMemberSummary => '支出を追加し、自分の支出を編集し、精算できます。';

  @override
  String get roleViewerSummary => 'すべて見られますが、変更はできません。';

  @override
  String get spaceTypeHousehold => '家計';

  @override
  String get spaceTypeTrip => '旅行';

  @override
  String get spaceTypeCouple => 'ふたり';

  @override
  String get spaceTypeFriends => '友人';

  @override
  String get spaceTypeOther => 'その他';

  @override
  String get readOnlyViewerTitle => '閲覧のみの権限です';

  @override
  String get readOnlyViewerReason => '閲覧者はすべて見られますが、変更はできません。';

  @override
  String readOnlyArchivedTitle(String space) {
    return '$space はアーカイブ済みです';
  }

  @override
  String get readOnlyArchivedReason =>
      'アーカイブされたスペースは履歴を保持し、新しい変更を受け付けません。追加や変更をするには再開してください。';

  @override
  String get actionReopen => '再開する';

  @override
  String offlineTitle(String action) {
    return 'オフラインのため、$actionできませんでした';
  }

  @override
  String get offlineBody =>
      '途中まで保存されたものはありません。変更は始まる前に止められました。入力した内容はそのままです。接続できたらもう一度お試しください。';

  @override
  String get offlineNotNow => 'あとで';

  @override
  String deniedWhoCanHelpOne(String name) {
    return '$name に頼んでください。';
  }

  @override
  String deniedWhoCanHelpMany(String names) {
    return '$names のいずれかに頼んでください。';
  }

  @override
  String get deniedDefaultTitle => 'ここではこの操作はできません';

  @override
  String conflictTitle(String name) {
    return '編集中に $name がこれを変更しました';
  }

  @override
  String conflictBody(String label) {
    return '「$label」に2つの版があります。まだ何も上書きされていません。どちらを残すか選んでください。';
  }

  @override
  String conflictKeepTheirs(String name) {
    return '$name の版を残す';
  }

  @override
  String get conflictKeepTheirsDetail => 'あなたの編集は破棄され、フォームが再読み込みされます。';

  @override
  String get conflictKeepMine => '自分の版を残す';

  @override
  String get conflictKeepMineDetail => 'あなたの版が相手の版に置き換わります。どちらを選んでも変更履歴には残ります。';

  @override
  String get conflictCompare => 'まず見比べる';

  @override
  String get conflictCompareDetail => '相手の版を並べて読み込み、項目ごとに決めます。';

  @override
  String get recordVoided => '取り消し済み';

  @override
  String get recordDraft => '下書き';

  @override
  String get recordDraftBanner => '下書き — まだ集計されていません';

  @override
  String get recordDraftBody => '残高や予算はまだ動いていません。内容が正しいと確認できたら確定してください。';

  @override
  String get recordVoidedBody => '履歴には残りますが、どの集計にも含まれません。';

  @override
  String get actionConfirm => '確定';

  @override
  String get actionRestore => '元に戻す';

  @override
  String get actionVoid => '取り消す';

  @override
  String get chartViewAsTable => '表で見る';

  @override
  String get chartNotEnoughHistory => '推移を描くにはまだ履歴が足りません。';

  @override
  String get chartNothingRecorded => 'この期間の記録がないため、内訳はまだありません。';

  @override
  String get chartEverythingElse => 'その他すべて';

  @override
  String comparisonFlat(String period) {
    return '$period とほぼ同じ';
  }

  @override
  String comparisonMore(int percent, String period) {
    return '$period より $percent% 多い';
  }

  @override
  String comparisonLess(int percent, String period) {
    return '$period より $percent% 少ない';
  }

  @override
  String get homeSpent => '支出';

  @override
  String get homeIn => '収入';

  @override
  String get homeNetWorth => '純資産';

  @override
  String homeThingsNeedYou(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '対応が必要な項目が$count件',
    );
    return '$_temp0';
  }

  @override
  String homeAndMore(int count) {
    return 'ほか $count 件';
  }

  @override
  String get homeWhoOwesWhom => '誰が誰に払うか';

  @override
  String get homeEveryoneSettled => 'どのスペースも精算済みです。';

  @override
  String get homeNoSpacesYet => '共有スペースはまだありません。割り勘を始めるときに作成してください。';

  @override
  String get homeSpendingTrend => '支出の推移';

  @override
  String get homeWhereItWent => '何に使ったか';

  @override
  String get homeThisMonthInFull => '今月の全体';

  @override
  String get homeAccounts => '口座';

  @override
  String get homeBudgets => '予算';

  @override
  String get homeUpcoming => 'これから';

  @override
  String get homeRecent => '最近';

  @override
  String get homeSeeAll => 'すべて見る';

  @override
  String get homeViewActivity => '履歴を見る';

  @override
  String homeYouOwe(String name) {
    return '$name に支払います';
  }

  @override
  String homeOwesYou(String name) {
    return '$name から受け取ります';
  }

  @override
  String homeYouKept(String amount) {
    return '今月は $amount 残りました';
  }

  @override
  String homeYouOverspent(String amount) {
    return '収入より $amount 多く使いました';
  }

  @override
  String homeStillFree(String amount) {
    return '確定分を除いて $amount 使えます';
  }

  @override
  String get homeMoneyIn => '入ったお金';

  @override
  String get homeMoneyOut => '出たお金';

  @override
  String get homeKept => '残った割合';

  @override
  String get homeKeptDetail => '入ったお金のうち';

  @override
  String get homeStillDue => 'これから引き落とし';

  @override
  String get homeStillDueDetail => '今月残っているサブスク';

  @override
  String get searchTitle => '検索';

  @override
  String get searchHintGlobal => '口座、スペース、カテゴリ、予算、履歴…';

  @override
  String get searchEmptyTitle => 'すべてを検索';

  @override
  String get searchEmptyBody =>
      '2文字以上入力してください。口座、スペース、カテゴリ、予算、定期項目、そして履歴全体から探します。';

  @override
  String searchNoMatchTitle(String query) {
    return '「$query」に一致するものがありません';
  }

  @override
  String get searchNoMatchBody => '文字数を減らすか、店名・メモ・メンバー名で試してください。';

  @override
  String get searchKindAccount => '口座';

  @override
  String get searchKindSpace => 'スペース';

  @override
  String get searchKindCategory => 'カテゴリ';

  @override
  String get searchKindRecurring => '定期';

  @override
  String get searchKindBudget => '予算';

  @override
  String get searchKindActivity => '履歴';

  @override
  String get activityTitle => '履歴';

  @override
  String activityCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件の記録',
    );
    return '$_temp0';
  }

  @override
  String get activitySearchHint => '店名・メモ・カテゴリ・タグ・口座を検索';

  @override
  String get activityFilters => '絞り込み';

  @override
  String activityShowMore(int count) {
    return 'もっと見る · 残り $count 件';
  }

  @override
  String get activityNoneTitle => 'まだ記録がありません';

  @override
  String get activityNoneBody => '支出・収入・振替を記録すると、ここに時系列で並びます。';

  @override
  String get activityNoMatchTitle => '一致する記録がありません';

  @override
  String get activityNoMatchBody => '別の言葉で試すか、絞り込みを解除してください。';

  @override
  String activitySavedViews(int count) {
    return '保存済み $count 件';
  }

  @override
  String get periodAnyTime => 'すべての期間';

  @override
  String get periodThisMonth => '今月';

  @override
  String get periodLastMonth => '先月';

  @override
  String get periodCustom => '期間を指定';

  @override
  String fxConvertedTo(String currency) {
    return '$currency に換算';
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
  String get fxRateHistory => 'レートの履歴';

  @override
  String get fxManualRate => '手動で入力したレート';

  @override
  String fxNetWorthNote(String currency) {
    return '$currency に換算しています。使用したレートと取得日はすべて下に表示されます。';
  }

  @override
  String get fxMissingTitle => '合計に含まれていない残高があります';

  @override
  String fxMissingBody(String currencies) {
    return '$currencies のレートがないため、それらの残高は推測になる合計に含めず、個別に表示しています。';
  }

  @override
  String get setupTitle => 'はじめの設定';

  @override
  String setupProgress(int done, int total) {
    return '$total 件中 $done 件';
  }

  @override
  String get setupHide => '非表示にする';

  @override
  String get setupStepProfile => '名前と表示通貨を設定する';

  @override
  String get setupStepAccount => '最初の口座を追加する';

  @override
  String get setupStepTransaction => '使ったお金を記録する';

  @override
  String get setupStepSpace => '共有スペースを作る';

  @override
  String get setupStepBudget => '気になる予算を決める';

  @override
  String get quickScanReceipt => 'レシートを読み取る';

  @override
  String get quickSharedExpense => '割り勘の支出';

  @override
  String get quickSettleUp => '精算する';

  @override
  String get quickRecordIncome => '収入を記録';

  @override
  String get quickNewBudget => '予算を作る';

  @override
  String get saveBlockedOffline => 'オフラインです — 少し待ってからお試しください';

  @override
  String get saveBlockedPermission => 'ここでは支出を追加できません';

  @override
  String notifAll(int count) {
    return 'すべて（$count）';
  }

  @override
  String notifWaitingCount(int count) {
    return '対応が必要（$count）';
  }

  @override
  String notifUpdatesCount(int count) {
    return 'お知らせ（$count）';
  }

  @override
  String get notifWaiting => '対応が必要';

  @override
  String get notifUpdates => 'お知らせ';

  @override
  String get notifNothingWaiting => '対応が必要なものはありません';

  @override
  String get notifNoUpdates => 'お知らせはありません';

  @override
  String get notifSwitchFilter => '他のものを見るには絞り込みを切り替えてください。';

  @override
  String get notifShowAll => 'すべて表示';

  @override
  String get notifMasterSwitch => '以下すべての通知をまとめて切り替えます';

  @override
  String get notifMarkAllRead => 'すべて既読にする';

  @override
  String get notifDismissed => '通知を閉じました';

  @override
  String get aiSectionTitle => 'お金について尋ねる';

  @override
  String get aiExplainMonth => '今月を説明する';

  @override
  String get aiExplainMonthDetail => '何が動いたか、その理由';

  @override
  String get aiCompareMonths => '2つの月を比べる';

  @override
  String get aiCompareMonthsDetail => 'カテゴリごとに、変化の大きい順';

  @override
  String get aiFlagUnusual => 'いつもと違うものを探す';

  @override
  String get aiFlagUnusualDetail => '各カテゴリ自身の直近の平均と比較';

  @override
  String get aiAnswerFootnote => 'あなたの記録から読み取ったものです。生成された文章ではありません。';

  @override
  String get aiThisMonth => '今月';

  @override
  String get aiAgainstLastMonth => '先月との比較';

  @override
  String get aiAnythingUnusual => 'いつもと違うもの';

  @override
  String aiSpentVs(
    String amount,
    String direction,
    String period,
    String previous,
  ) {
    return '$amount 使いました。$period（$previous）と比べて$directionです。';
  }

  @override
  String get aiDirectionSame => 'ほぼ同じ';

  @override
  String get aiDirectionMore => '多い';

  @override
  String get aiDirectionLess => '少ない';

  @override
  String aiBiggestShare(String category, String amount) {
    return '最も大きかったのは $category で、$amount でした。';
  }

  @override
  String aiKept(String kept, String income) {
    return '入ってきた $income のうち $kept が残りました。';
  }

  @override
  String aiOverspent(String amount) {
    return '収入より $amount 多く使いました。';
  }

  @override
  String aiStillDue(String amount) {
    return '今月中にあと $amount のサブスクの引き落としがあります。';
  }

  @override
  String aiDeltaUp(String category, String amount) {
    return '$category：$amount 増加';
  }

  @override
  String aiDeltaDown(String category, String amount) {
    return '$category：$amount 減少';
  }

  @override
  String get aiNothingToCompare => 'どちらの月にも比べるものがありません。';

  @override
  String get aiNothingUnusual =>
      'どのカテゴリも直近の平均から大きくは離れていません。高くないという意味ではなく、いつも通りだという意味です。';

  @override
  String aiUnusualLine(String category, String amount) {
    return '$category は直近3か月の平均を大きく上回り、$amount です。';
  }

  @override
  String spaceMemberCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'メンバー$count人',
    );
    return '$_temp0';
  }

  @override
  String get spaceManagePeople => '管理';

  @override
  String get spaceFullActivityLog => 'アクティビティ全体';

  @override
  String get currencyNoRate => '換算レートがありません';

  @override
  String currencyAvailable(int count) {
    return '$count 種類の通貨に対応';
  }

  @override
  String get hapticsTitle => '触覚フィードバック';

  @override
  String get hapticsDetail => '選択・保存・取り消しの確認時に短く振動します';

  @override
  String get widgetTitle => 'ホーム画面ウィジェット';

  @override
  String get widgetRefresh => 'ホーム画面に送る';

  @override
  String get widgetPushed => 'ウィジェットを更新しました';

  @override
  String get widgetIntro =>
      'アプリと同じ数値をもとに、ウィジェットに表示される内容そのものです。どこをタップしても Pockito が開きます。';

  @override
  String get widgetSizeSmall => '小 · 純資産のみ';

  @override
  String get widgetSizeMedium => '中 · 純資産と今月';

  @override
  String get widgetSizeLarge => '大 · 誰が誰に払うかも表示';

  @override
  String get widgetTapOpens => 'タップするとホームが開きます';

  @override
  String get weCouldnTFindThat => 'その画面は見つかりませんでした';

  @override
  String nothingOpensAtYourMoney(Object p0) {
    return '$p0 には何もありません。お金とデータはそのままです。';
  }

  @override
  String get goToHome => 'ホームへ';

  @override
  String get closeToTheLimit => '上限に近づいています';

  @override
  String atThisPaceYouFinish(Object p0, Object p1) {
    return 'このペースだと、$p0の終わりには $p1 超過します。';
  }

  @override
  String atThisPaceYouFinish2(Object p0, Object p1) {
    return 'このペースだと、$p0の終わりには $p1 になります。';
  }

  @override
  String includesCarriedOverFromLast(Object p0, Object p1) {
    return '前の$p1から繰り越した $p0 を含みます。';
  }

  @override
  String get pockitoAppIconFeaturingKito => 'キトのPockitoアプリアイコン';

  @override
  String percentOfUsed(Object p0, Object p1) {
    return '$p1 の $p0% を使用';
  }

  @override
  String get offlineChangesStayOnThis => 'オフライン · 変更はこの端末に保存されます';

  @override
  String get stayInTheLoop => '最新の状況を受け取る';

  @override
  String get getNotifiedWhenSomeoneAdds =>
      '誰かが共有の支出を追加したとき、返してくれたとき、予算に注意が必要なときにお知らせします。';

  @override
  String get miraAddedGroceries => 'Mira が食料品を追加 · €84.00';

  @override
  String get miraSaysShePaidYou => 'Mira が ¥5,000 支払ったと言っています';

  @override
  String get youVeUsedOfGroceries => '食料品の 80% を使いました';

  @override
  String get turnOnNotifications => '通知をオンにする';

  @override
  String get prototypeOnlyNoSystemPermission => 'プロトタイプのみ · システムの許可は求めません';

  @override
  String get pickWhatHappenedYouCan => '何が起きたか選んでください。保存前にどの項目も変更できます。';

  @override
  String get readAReceipt => 'レシートを読み取る';

  @override
  String get pickADate => '日付を選ぶ';

  @override
  String get chooseAnAccount => '口座を選ぶ';

  @override
  String get outsidePockitoNoWalletMovement => 'Pockito 外 · 口座は動きません';

  @override
  String get chooseACategory => 'カテゴリを選ぶ';

  @override
  String get chooseACurrency => '通貨を選ぶ';

  @override
  String noDecimalPlaces(Object p0) {
    return '$p0 · 小数なし';
  }

  @override
  String decimalPlaces(Object p0, Object p1) {
    return '$p0 · 小数点以下 $p1 桁';
  }

  @override
  String get chooseAMember => 'メンバーを選ぶ';

  @override
  String get eGBerlinTrip => '例：ベルリン旅行';

  @override
  String get noReceiptKeptScanningOne =>
      'レシートは保存されていません。読み取ると画像が残るので、数か月後でも支払いを確認できます。';

  @override
  String get connectedToThis => 'これに関連するもの';

  @override
  String canDoThis(Object p0) {
    return '$p0 なら実行できます。';
  }

  @override
  String get keepItAsItIs => 'このままにする';

  @override
  String typeToContinue(Object p0) {
    return '続けるには「$p0」と入力してください。';
  }

  @override
  String get thatDidnTWork => 'うまくいきませんでした';

  @override
  String get thatDidnTLoad => '読み込めませんでした';

  @override
  String get theListIsStillOn => '一覧は端末に残っています。読み込みに失敗しただけです。';

  @override
  String get yourSpendingIsSteadyShared =>
      '支出は安定しています。共有の費用と振替は、個人の支出とすでに分けられています。';

  @override
  String isOverItsLimitYour(Object p0) {
    return '$p0 が上限を超えました。他の残高は変わっていません。';
  }

  @override
  String isGettingCloseToIts(Object p0) {
    return '$p0 が上限に近づいています。今見直しておくと、今月を無理なく過ごせます。';
  }

  @override
  String get weCouldNotRefreshYour => '概要を更新できませんでした';

  @override
  String get yourLocalDataIsSafe => '端末のデータは無事です。もう一度読み込んでみてください。';

  @override
  String markedAsPaid(Object p0) {
    return '$p0 を支払い済みにしました';
  }

  @override
  String get yourMoneyFinallyInOne => 'お金を、ひとつの場所に。';

  @override
  String get addAnAccountToTrack =>
      '自分のお金を記録する口座を追加するか、信頼できる人と支出を分け合うスペースを作りましょう。';

  @override
  String get chooseWhereToBegin => 'どこから始めますか';

  @override
  String get seeBalancesActivityAndNet => '残高・履歴・純資産をまとめて見られます。';

  @override
  String get createASharedSpace => '共有スペースを作る';

  @override
  String get splitAHomeTripOr => '家・旅行・プロジェクトの費用を、迷わず分けられます。';

  @override
  String get exploreWithSampleData => 'サンプルデータで試す';

  @override
  String acrossAccounts(Object p0, Object p1) {
    return '$p0 口座 · $p1';
  }

  @override
  String get nothingLeftYourAccounts => '口座から出たお金はありません';

  @override
  String ofThatLeftYourAccounts(Object p0, Object p1) {
    return '口座から出た $p1 のうち $p0%';
  }

  @override
  String get nothingCameInThisMonth => '今月の収入はありません';

  @override
  String get noDueDate => '予定日なし';

  @override
  String dueInDays(Object p0) {
    return 'あと $p0 日';
  }

  @override
  String thingsNeedYou(Object p0) {
    return '対応が必要な項目が $p0 件';
  }

  @override
  String isWellAboveItsRecent(Object p0, Object p1) {
    return '$p0 は直近の平均を大きく上回り、$p1 です。';
  }

  @override
  String showMoreLeft(Object p0) {
    return 'もっと見る · 残り $p0 件';
  }

  @override
  String get nameThisView => 'この条件に名前をつける';

  @override
  String get eGReimbursableWorkTravel => '例：立替の出張費';

  @override
  String get filterCombinationsYouBuiltOnce => '一度作った絞り込みの組み合わせです。';

  @override
  String get moneyEventNotFound => '記録が見つかりません';

  @override
  String get thisItemHasBeenRemoved => 'この項目は端末のデータから削除されています。';

  @override
  String get confirmedItCountsFromNow => '確定しました。ここから集計に含まれます';

  @override
  String get voidThisMoneyEvent => 'この記録を取り消しますか？';

  @override
  String get itStaysInYourHistory2 => '履歴には取り消し線つきで残り、残高や予算の集計からは外れます。';

  @override
  String get theLinkedSharedExpenseIs =>
      '関連する共有支出も取り消され、全員の残高が更新されます。どちらの行も履歴には残ります。';

  @override
  String get editMoneyEvent => '記録を編集';

  @override
  String get youCanFillThisIn => '入力はできますが、接続が戻るまで保存はできません。途中まで書き込まれることはありません。';

  @override
  String youCanTAddExpenses(Object p0) {
    return '$p0 には支出を追加できません';
  }

  @override
  String get viewersCanSeeEverythingAnd => '閲覧者はすべて見られますが、変更はできません。';

  @override
  String get thisSpaceIsArchivedSo => 'このスペースはアーカイブ済みのため、閲覧のみです。';

  @override
  String get youDoNotHavePermission => 'ここに支出を追加する権限がありません。';

  @override
  String get enterAnAmountGreaterThan => '0 より大きい金額を入力してください';

  @override
  String get whatWasThisFor => '何に使いましたか？';

  @override
  String get addAShortDescription => '短い説明を入れてください';

  @override
  String get whyThisHappenedOrAnything => 'そうなった理由や、覚えておきたいこと';

  @override
  String get paidOutsidePockitoNoWallet => 'Pockito 外で支払い · 口座は動きません';

  @override
  String get noAccountMovement => '口座の動きなし';

  @override
  String get thePayerSAccountIs => '支払った人の口座は、あなたの記録の外にあります。';

  @override
  String get chooseTheDestination => '送り先を選んでください';

  @override
  String get capturedWithThisTransfer => 'この振替と一緒に記録されました';

  @override
  String get rateMustBeMoreThan => 'レートは 0 より大きい必要があります';

  @override
  String get automaticRateUnavailableChooseManual =>
      '自動レートを取得できません。続けるには手動を選んでください。';

  @override
  String get paidWithOptional => '支払い方法（任意）';

  @override
  String get shareThisExpense => 'この支出を分け合う';

  @override
  String get personalSpendingOnly => '個人の支出のみ';

  @override
  String get updatesTheAccountAndEveryone => '口座と全員の残高を更新します';

  @override
  String get noAutomaticRateEnterA => '自動レートがありません。続けるには手動でレートを入力してください。';

  @override
  String get receiptKeptDetailsFilledIn => 'レシートを保存 · 内容を入力しました。保存前に確認してください';

  @override
  String get receiptKeptWeCouldNot => 'レシートを保存 · 読み取れなかったため、何も入力していません';

  @override
  String get attachAReceipt => 'レシートを添付';

  @override
  String get whatIsItEG => 'これは何ですか？ 例：飲食店の伝票';

  @override
  String get enterAnAmountBeforeEditing => '分け方を編集する前に金額を入力してください';

  @override
  String get chooseAValidExchangeRate => '続けるには有効な為替レートを選んでください';

  @override
  String get enterAnExchangeRateFor => 'この口座からの支払いに使う為替レートを入力してください';

  @override
  String get moneyEventAdded => '記録を追加しました';

  @override
  String get moneyEventUpdated => '記録を更新しました';

  @override
  String get yourVersionWasKept => 'あなたの版を残しました';

  @override
  String get loadedTheirVersionSNumbers =>
      '相手の版の数値を読み込みました。各項目を確認してから保存してください。';

  @override
  String get fitTheWholeReceiptInside => 'レシート全体を枠に収めてください';

  @override
  String get previewLowConfidence => '低信頼の例を見る';

  @override
  String get previewFailedScan => '読み取り失敗の例を見る';

  @override
  String get readingMerchantTotalAndDate => '店名・合計・日付を読み取っています…';

  @override
  String get oneQuickCheck => 'ひとつ確認してください';

  @override
  String get merchantAndCategoryHaveLow => '店名とカテゴリの信頼度が低めです。保存前にどの項目も編集できます。';

  @override
  String get augustGroceries => '2026年8月15日 · 食料品';

  @override
  String get thisIsALocalOcr =>
      'これは端末内での読み取りシミュレーションです。どこにも送信しておらず、保存前にすべての項目を編集できます。';

  @override
  String get useTheseDetails => 'この内容を使う';

  @override
  String get weCouldNotReadThis => 'この書類は読み取れませんでした';

  @override
  String get theImageMayBeBlurred =>
      '画像がぼやけている、見切れている、または接続がない可能性があります。金融データは作成されていません。';

  @override
  String get theImageWasTooBlurred => '画像がぼやけていて読み取れませんでした。自動入力は行っていません。';

  @override
  String get enterDetailsManually => '手入力する';

  @override
  String get searchPaymentMethods => '支払い方法を検索';

  @override
  String get recordsThatWereUndoneKept => '取り消されたが履歴として残っている記録';

  @override
  String get stagedRecordsThatDoNot => 'まだ集計に含まれない下書きの記録';

  @override
  String get everythingIsAllocated => 'すべて割り当て済みです';

  @override
  String get useThisSplit => 'この分け方を使う';

  @override
  String get addALineForEach =>
      '伝票の項目ごとに行を追加し、誰が食べた・使ったかを選んでください。項目にしなかった分は均等に分けられます。';

  @override
  String get everyLineAccountedFor => 'すべての項目を計上しました';

  @override
  String notItemisedSplitEvenly(Object p0) {
    return '$p0 は項目化されていません — 均等に分けます';
  }

  @override
  String get whatWasOnTheBill => '伝票には何がありましたか？';

  @override
  String get eGTheWine => '例：ワイン';

  @override
  String howMuchWas(Object p0) {
    return '$p0 はいくらでしたか？';
  }

  @override
  String get thatAmountDidnTLook => 'その金額は数値として読み取れませんでした';

  @override
  String get thisIsHowItLands => 'この形で確定します';

  @override
  String get nothingIsSavedYetGoing => 'まだ何も保存されていません。戻れば編集を続けられます。';

  @override
  String get percentagesMustTotal => '割合の合計は 100% にしてください';

  @override
  String get enterAtLeastOnePositive => '1つ以上のプラスの割合を入力してください';

  @override
  String get moreThanOnePersonPaid => '複数人が支払った';

  @override
  String get whoPaidWhat => '誰がいくら払ったか';

  @override
  String payersAddUpTo(Object p0) {
    return '支払いの合計は $p0 です';
  }

  @override
  String get sharedMoneyWithoutTheAwkward => '気まずい計算のいらない、共有のお金';

  @override
  String searchSpacesOrTheirMembers(Object p0) {
    return '$p0 件のスペースやメンバーを検索';
  }

  @override
  String get shareMoneyWithLessFriction => 'お金の共有を、もっと軽く';

  @override
  String get createASpaceForA => '家・旅行・ふたり・友人グループごとにスペースを作れます。';

  @override
  String get createASpace => 'スペースを作る';

  @override
  String noSpaceMatches(Object p0) {
    return '「$p0」に一致するスペースがありません';
  }

  @override
  String get tryADifferentNameType => '別の名前・種類・メンバーで試してください。';

  @override
  String get spaceNotFound => 'スペースが見つかりません';

  @override
  String get itMayHaveBeenRemoved => '削除された可能性があります。';

  @override
  String get everyoneIsSettled => '全員精算済みです';

  @override
  String get cyclesPreserveYourHistory => 'サイクルは履歴を残します';

  @override
  String get startANewCycleTo =>
      '新しいサイクルを始めると、現在の残高とスペース予算がゼロに戻ります。過去の記録は消えません。';

  @override
  String get startNewCycle => '新しいサイクルを始める';

  @override
  String get noSharedExpensesYet => '共有の支出はまだありません';

  @override
  String get noExpensesMatchTheseFilters => 'この絞り込みに一致する支出はありません';

  @override
  String get addTheFirstExpenseAnd => '最初の支出を追加すれば、Pockito が全員の残高をはっきりさせます。';

  @override
  String get tryShowingSettledAndUnsettled =>
      '精算済みと未精算の両方を表示するか、すべての支払者を含めてみてください。';

  @override
  String joinedTheSpace(Object p0) {
    return '$p0 がスペースに参加しました';
  }

  @override
  String everyAmountIsInThe(Object p0) {
    return '金額はすべて、スペースの通貨 $p0 で表示しています。';
  }

  @override
  String get whoPaysWhom => '誰が誰に払うか';

  @override
  String get startANewCycle => '新しいサイクルを始めますか？';

  @override
  String get currentBalancesAndSpaceBudget =>
      '現在の残高とスペース予算の使用状況がゼロに戻ります。支出・負担・分析・精算は前のサイクルに残ります。';

  @override
  String get newCycleStartedHistoryPreserved => '新しいサイクルを開始しました · 履歴は保持されています';

  @override
  String get paidByMe => '自分が支払った';

  @override
  String get paidByMember => '支払ったメンバー';

  @override
  String get expenseNotFound => '支出が見つかりません';

  @override
  String get thisExpenseHasBeenRemoved => 'この支出は削除されています。';

  @override
  String get thisClosedCycleRecordIs => '終了したサイクルの記録は、合計を信頼できるものに保つため閲覧のみです。';

  @override
  String get chargedToYourWallet => '口座からの引き落とし';

  @override
  String get whoPaysWhat => '誰がいくら負担するか';

  @override
  String get theSpaceThisBelongsTo => 'この記録が属するスペース';

  @override
  String get yourAccountMovement => 'あなたの口座の動き';

  @override
  String get itStaysVisibleToEveryone =>
      '全員に取り消し線つきで表示され、スペースの残高からは外れます。関連するあなたの口座の動きも取り消されます。';

  @override
  String get kanaExampleComFranExample => 'kana@example.com, fran@example.com';

  @override
  String get whatAreYouSharing => '何を共有しますか？';

  @override
  String get theSpaceCurrencyIsThe => 'スペースの通貨が、残高の唯一の基準になります。';

  @override
  String get youCanShareAnInvite => '招待リンクは今すぐ共有しても、あとからでも構いません。';

  @override
  String get eGFlatOrTokyo => '例：自宅、東京旅行';

  @override
  String get nameYourSpace => 'スペースに名前をつける';

  @override
  String get monthlySpaceBudgetOptional => 'スペースの月次予算（任意）';

  @override
  String get resetsForANewMonth => '新しい月やサイクルでリセットされます';

  @override
  String get enterABudgetGreaterThan => '0 より大きい予算を入力してください';

  @override
  String get separateMultiplePeopleWithCommas => '複数人はカンマで区切ってください';

  @override
  String get inviteLinkReady => '招待リンクを用意しました';

  @override
  String get inviteLinkCopied => '招待リンクをコピーしました';

  @override
  String get createAndInvite => '作成して招待する';

  @override
  String get notificationPreviewsTurnedOn => '通知プレビューをオンにしました';

  @override
  String createdInvitationsPending(Object p0) {
    return '$p0 を作成しました · 招待は保留中です';
  }

  @override
  String get itMayHaveBeenRemoved2 => '削除されたか、あなたが退出した可能性があります。';

  @override
  String get youCanTInvitePeople => 'ここでは人を招待できません';

  @override
  String get onlyOwnersAndAdminsCan => '招待できるのはオーナーと管理者だけです。';

  @override
  String get tryADifferentNameOr => '別の名前で試すか、検索をクリアしてください。';

  @override
  String inviteResentTo(Object p0) {
    return '$p0 に招待を再送しました';
  }

  @override
  String newInviteSentTo(Object p0) {
    return '$p0 に新しい招待を送りました';
  }

  @override
  String get noInvitationsYet => '招待はまだありません';

  @override
  String get inviteKanaFranOrAnyone => 'Kana や Fran など、お金を共有する相手を招待しましょう。';

  @override
  String invitedAsExpiresInDays(Object p0, Object p1, Object p2) {
    return '$p0 を $p1 として招待 · $p2 日で期限切れ';
  }

  @override
  String revokeSInvite(Object p0) {
    return '$p0 の招待を取り消しますか？';
  }

  @override
  String get theLinkStopsWorkingImmediately => 'リンクはすぐに無効になります。いつでも再招待できます。';

  @override
  String sInviteRevoked(Object p0) {
    return '$p0 の招待を取り消しました';
  }

  @override
  String get youCanTChangeRoles => 'ここでは役割を変更できません';

  @override
  String get onlyTheOwnerCanChange => '役割を変更できるのはオーナーだけです。';

  @override
  String get youCanTRemoveThis => 'このメンバーは削除できません';

  @override
  String get theOwnerCannotBeRemoved => 'オーナーは削除できません。先に所有権を譲ってください。';

  @override
  String get onlyOwnersAndAdminsCan2 => 'メンバーを削除できるのはオーナーと管理者だけです。';

  @override
  String get removeFromSpace => 'スペースから削除';

  @override
  String get youCanTLeaveThis => 'このスペースからは退出できません';

  @override
  String get youAreTheOnlyOwner =>
      'あなたが唯一のオーナーです。スペースが管理者不在にならないよう、先に他の人をオーナーにしてください。';

  @override
  String get thisSpaceCannotBeLeft => '今このスペースからは退出できません。';

  @override
  String get whatTheyCanDoChanges => 'できることはすぐに変わります。';

  @override
  String isNowA(Object p0, Object p1) {
    return '$p0 を$p1にしました';
  }

  @override
  String get youLoseAccessToIts =>
      '支出と残高が見られなくなります。再参加にはオーナーか管理者からの新しい招待が必要です。';

  @override
  String get settleTheBalanceFirst => '先に精算してください';

  @override
  String hasABalanceInThis(Object p0, Object p1) {
    return '$p0 はこのサイクルで $p1 の残高があります。履歴の整合性を保つため、削除の前に精算してください。';
  }

  @override
  String get theyWillKeepAccessTo => '過去の記録は引き続き見られますが、新しい支出は追加できなくなります。';

  @override
  String get linkExpiresIn => 'リンクの有効期限';

  @override
  String get copyInviteLink => '招待リンクをコピー';

  @override
  String get onlyOwnersAndAdminsCan3 => 'スペースの設定を変更できるのはオーナーと管理者だけです。';

  @override
  String isOpenAgain(Object p0) {
    return '$p0 を再開しました';
  }

  @override
  String members(Object p0, Object p1, Object p2) {
    return '$p0 · $p1 · メンバー$p2人';
  }

  @override
  String get whoChangedWhatAndWhen => '誰が、いつ、何を変えたか';

  @override
  String get includesMemberAndSettingsChanges => 'メンバーや設定の変更も含みます';

  @override
  String get onlyTheOwnerCanArchive => 'スペースをアーカイブ・再開できるのはオーナーだけです。';

  @override
  String get automaticallyPreFillsEveryNew => '新しい支出に自動で入ります。いつでも上書きできます。';

  @override
  String get exactAmountsDependOnThe =>
      '金額指定は支出の合計に応じて決まります。新しい支出はまず均等に割り当てられ、分け方の編集で確定します。';

  @override
  String get everyoneReceivesAnEqualResponsibility => '全員が同じ負担になります。';

  @override
  String percentagesMustTotalCurrently(Object p0) {
    return '割合の合計は 100% にしてください（現在 $p0%）。';
  }

  @override
  String get enterAtLeastOnePositive2 => '1つ以上のプラスの割合を入力してください。';

  @override
  String get saveDefaultSplit => '既定の分け方を保存';

  @override
  String equalAcrossMembers(Object p0) {
    return 'メンバー $p0 人で均等';
  }

  @override
  String get exactAmountsConfirmPerExpense => '金額指定 · 支出ごとに確定';

  @override
  String get itemizedAssignEachLinePer => '項目別 · 支出ごとに各行を割り当て';

  @override
  String get membersCanNoLongerAdd => 'メンバーは支出を追加できなくなりますが、履歴はすべて残ります。';

  @override
  String get thereAreNoOutstandingPayments => 'このサイクルに未払いはありません。';

  @override
  String get thisRecordsASettlementNever => 'これは精算の記録で、支出にはなりません。';

  @override
  String get eGAugustUtilities => '例：8月の光熱費';

  @override
  String get enterAValidAmount => '有効な金額を入力してください';

  @override
  String amountCannotExceed(Object p0) {
    return '金額は $p0 を超えられません';
  }

  @override
  String confirmsThisBeforeAnyBalance(Object p0) {
    return '$p0 が確認するまで残高は動きません。それまでは取り消せます。';
  }

  @override
  String get youAreTheOneBeing => '受け取るのはあなたなので、記録するとその場で確定します。';

  @override
  String get sendForConfirmation => '確認を依頼する';

  @override
  String get partialSettlementRecorded => '一部の精算を記録しました';

  @override
  String everyMemberIsAtExpenses(Object p0) {
    return '全員が $p0 です。支出と精算はこのサイクルの履歴に残ります。';
  }

  @override
  String get backToSpaces => 'スペースへ戻る';

  @override
  String get settleRemainingBalance => '残りを精算する';

  @override
  String get viewSettlementHistory => '精算の履歴を見る';

  @override
  String get itsSettlementHistoryIsNo => '精算の履歴は表示できません。';

  @override
  String get noSettlementsYet => '精算はまだありません';

  @override
  String get whenSomeonePaysAnotherBack => '誰かが誰かに返したとき、ここに記録されます。';

  @override
  String get settlementNotFound => '精算が見つかりません';

  @override
  String get itMayHaveBeenRemoved3 => '端末のデータから削除された可能性があります。';

  @override
  String get waitingOnConfirmation => '確認待ちです';

  @override
  String saysThisMoneyReachedYou(Object p0) {
    return '$p0 はこのお金があなたに届いたと言っています。まだ何も動いていません。確認すると残高が動きます。';
  }

  @override
  String get thatDidnTHappen => '受け取っていない';

  @override
  String get youProposedItSoConfirming =>
      'あなたが申請したため、自分で確認すると片方が一方的に「支払われた」と宣言できてしまいます。';

  @override
  String get cancelThisProposal => 'この申請を取り消す';

  @override
  String get whereDidTheMoneyLand => 'お金はどこに入りましたか？';

  @override
  String get cancelThisSettlement => 'この精算を取り消す';

  @override
  String get itStaysInTheHistory => '履歴には取り消しとして残ります。何も動いていないので、残高は変わりません。';

  @override
  String get cycleHistoryIsNoLonger => 'サイクルの履歴は表示できません。';

  @override
  String get openCurrentCycle => '現在のサイクルを開く';

  @override
  String get noPreviousCycles => '過去のサイクルはありません';

  @override
  String get onceEveryoneIsSettledStart =>
      '全員の精算が終わったら、新しいサイクルを始めるとこの期間がここに残ります。';

  @override
  String expensesSettlements(Object p0, Object p1) {
    return '支出 $p0 件 · 精算 $p1 件';
  }

  @override
  String get cycleNotFound => 'サイクルが見つかりません';

  @override
  String get thisHistoricalSnapshotIsUnavailable => 'この過去のスナップショットは表示できません。';

  @override
  String get settledCycleReadOnly => '終了したサイクル · 閲覧のみ';

  @override
  String get thisSnapshotDoesNotChange => '現在のサイクルが変わっても、このスナップショットは変わりません。';

  @override
  String theSnapshotRetainsExpenseReferences(Object p0) {
    return 'このスナップショットには支出 $p0 件の参照と、すべての集計値が残っています。';
  }

  @override
  String get returnToCurrentCycle => '現在のサイクルへ戻る';

  @override
  String get noArchivedSpaces => 'アーカイブしたスペースはありません';

  @override
  String get finishedTripsAndOldGroups => '終わった旅行や、使わなくなったグループはここに置けます。';

  @override
  String get acrossAllSpaces => 'すべてのスペース';

  @override
  String get itsActivityLogIsNo => 'アクティビティの記録は表示できません。';

  @override
  String get searchThisLog => 'この記録を検索';

  @override
  String get refusedActionsOnly => '拒否された操作のみ';

  @override
  String get nothingRecordedYet => 'まだ記録はありません';

  @override
  String get nobodyHasBeenRefusedAn => 'ここで操作を拒否された人はいません。';

  @override
  String get addingAnExpenseOrChanging => '支出の追加や設定の変更が、誰が行ったかとともにここに表示されます。';

  @override
  String get startWithAnAccount => 'まず口座から';

  @override
  String get accountsAreWhereMoneyEnters => '口座は、Pockito にお金が入り、出ていく場所です。';

  @override
  String noAccountMatches(Object p0) {
    return '「$p0」に一致する口座がありません';
  }

  @override
  String get tryADifferentNameType2 => '別の名前・種類・通貨で試してください。';

  @override
  String get accountNotFound => '口座が見つかりません';

  @override
  String get correctTheBalance => '残高を修正する';

  @override
  String balanceOverTheLastDays(Object p0, Object p1) {
    return '$p0 の直近30日間の残高。最終値は $p1';
  }

  @override
  String get availableToSpend => '使える金額';

  @override
  String get recordThisAccountSFirst => 'この口座の最初の記録を作りましょう。';

  @override
  String get itsHistoryStaysAvailableYou => '履歴は残ります。アーカイブした口座から元に戻せます。';

  @override
  String get eGRevolut => '例：Revolut';

  @override
  String get giveThisAccountAName => 'この口座に名前をつけてください';

  @override
  String get creditLimitOptional => '利用限度額（任意）';

  @override
  String get letsPockitoShowWhatIs => '残っている利用可能額も表示できるようになります';

  @override
  String get savingsGoalOptional => '貯蓄の目標額（任意）';

  @override
  String get showsProgressOnTheAccount => '口座に進捗を表示します';

  @override
  String get preselectedWhenRecordingAnExpense => '支出を記録するとき、最初から選ばれます';

  @override
  String get noArchivedAccounts => 'アーカイブした口座はありません';

  @override
  String get archivedAccountsWillAppearHere => 'アーカイブした口座は、履歴を保ったままここに表示されます。';

  @override
  String get availableByCurrency => '通貨ごとの残高';

  @override
  String get currenciesStaySeparateUntilReporting =>
      '通貨は表示用にまとめるまで別々のままです。レートがない通貨を勝手に合算することはありません。';

  @override
  String get inThisMonth => '今月の収入';

  @override
  String get outThisMonth => '今月の支出';

  @override
  String get connectAnApp => 'アプリを連携する';

  @override
  String get youStayInControl => '決めるのはあなたです';

  @override
  String get kitoSurfacesAiInsightsBut =>
      'キトが AI の気づきを届けますが、連携先が見られるのは許可したデータだけで、お金に関わる書き込みは必ず事前に確認できます。';

  @override
  String get noConnectedApps => '連携中のアプリはありません';

  @override
  String get connectAnAiApplicationAnd => 'AI アプリを連携し、読み取れる・変更できる範囲を細かく選べます。';

  @override
  String get suspendedReviewNeeded => '一時停止中 · 確認が必要です';

  @override
  String get verifiedByPockito => 'Pockito が確認済み';

  @override
  String get customMcpClient => 'カスタム MCP クライアント';

  @override
  String get chooseAnApplication => 'アプリを選ぶ';

  @override
  String get thisPrototypeSimulatesAuthorizationNo =>
      'これは認可のシミュレーションです。トークンも外部接続も作られません。';

  @override
  String get unverifiedApplicationUseExtraCare => '未確認のアプリです · 特に注意してください';

  @override
  String get allowAccessToPockito => 'Pockito へのアクセスを許可しますか？';

  @override
  String get chooseTheMinimumAccessThis =>
      'このアプリに必要な最小限の範囲を選んでください。あとから取り消せます。';

  @override
  String get namesTypesCurrenciesAndBalances => '名前・種類・通貨・残高';

  @override
  String get moneyEventsAndCategories => '記録とカテゴリ';

  @override
  String get sharedExpensesAndWhoOwes => '共有の支出と、誰が誰に払うか';

  @override
  String get calculatedSpendingAndBudgetSummaries => '集計した支出と予算のまとめ';

  @override
  String get allowFinancialChanges => 'お金の変更を許可する';

  @override
  String get createAndUpdateExpensesOr => '支出や定期項目の作成・更新';

  @override
  String get writesArePreviewedFirstHigh =>
      '書き込みは先にプレビューされます。影響の大きい操作は Pockito での承認を待たせられます。';

  @override
  String get connectionNotFound => '連携が見つかりません';

  @override
  String get itMayHaveBeenDisconnected => '解除された可能性があります。';

  @override
  String get theAppLosesAccessImmediately =>
      'アプリはすぐにアクセスできなくなります。すでに作成された記録は、作成元とともに残ります。';

  @override
  String get noAiActivity => 'AI の操作履歴はありません';

  @override
  String get readsAndWritesFromConnected =>
      '連携アプリの読み取りと書き込みが、誰の操作かとともにここに表示されます。';

  @override
  String get blockedMemberInvitation => 'メンバー招待をブロックしました';

  @override
  String get financeSidekickOutsideGrantedCapabilities =>
      'Finance Sidekick · 許可した範囲外です';

  @override
  String get nothingNeedsApproval => '承認が必要なものはありません';

  @override
  String get highImpactActionsRequestedBy => '連携アプリからの影響の大きい操作は、ここで承認を待ちます。';

  @override
  String get requestsYourApproval => 'あなたの承認を求めています';

  @override
  String get approvedAndRecorded => '承認して記録しました';

  @override
  String get noTagsYet => 'タグはまだありません';

  @override
  String get tagsCutAcrossCategoriesA =>
      'タグはカテゴリをまたぎます。「ベルリン旅行」タグをつければ、食料品も交通費も飲食も一箇所にまとまります。';

  @override
  String get tryADifferentWordOr => '別の言葉で試すか、新しいタグを追加してください。';

  @override
  String get addATag => 'タグを追加';

  @override
  String get notUsedYet => 'まだ使われていません';

  @override
  String get seeEverythingTaggedWithThis => 'このタグがついたものをすべて見る';

  @override
  String get recordsKeepTheirOtherTags => '記録の他のタグはそのまま残り、他には何も変わりません。';

  @override
  String get addPaymentMethod => '支払い方法を追加';

  @override
  String get noPaymentMethodsYet => '支払い方法はまだありません';

  @override
  String get anAccountSaysWhereThe =>
      '口座はお金がどこにあるかを表します。支払い方法は、どのカード・どの引き落としで出ていったかを表します。';

  @override
  String get newPaymentMethod => '新しい支払い方法';

  @override
  String get eGAmexGold => '例：Amex Gold';

  @override
  String get lastFourDigitsOptional => '下4桁（任意）';

  @override
  String get paymentMethodAdded => '支払い方法を追加しました';

  @override
  String get dateDescriptionAmountCurrencyCategory =>
      'date,description,amount,currency,category,account\n2026-08-16,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-16,Refund from Zalando,24.00,EUR,Refunds,Visa\n2026-08-12,Rewe,-32.50,EUR,Groceries,Revolut\n2026-08-99,Broken row,-10.00,EUR,Groceries,Revolut\n';

  @override
  String get pasteCsvWithAHeader =>
      '見出し行つきの CSV を貼り付けてください：date, description, amount, currency, category, account。マイナスの金額は支出です。';

  @override
  String get checkTheRows => '行を確認する';

  @override
  String toImportAlreadyRecordedUnreadable(Object p0, Object p1, Object p2) {
    return '取り込み $p0 件 · 登録済み $p1 件 · 読み取れず $p2 件';
  }

  @override
  String get nothingHereCanBeImported => '取り込めるものがありません';

  @override
  String get itIsOnYourClipboard => 'クリップボードにコピーしました。コピーした内容そのものは以下のとおりです。';

  @override
  String get itMayHaveBeenRemoved4 => '削除された可能性があります。';

  @override
  String get pockitoThinksThisAccountHolds => 'Pockito が把握している残高';

  @override
  String get whatIsActuallyThere => '実際の残高';

  @override
  String thisRecordsACorrectionOf(Object p0) {
    return '$p0 増やす修正として記録します。収入ではなく、収入の集計には入りません。';
  }

  @override
  String thisRecordsACorrectionOf2(Object p0) {
    return '$p0 減らす修正として記録します。支出ではなく、支出の集計には入りません。';
  }

  @override
  String get whyDoesItDiffer => 'なぜ違いますか？';

  @override
  String get eGCountedTheWallet => '例：財布の中を数えた';

  @override
  String get recordTheCorrection => '修正を記録する';

  @override
  String get enterTheRealBalance => '実際の残高を入力してください';

  @override
  String get sayWhyItDiffers => '違う理由を書いてください';

  @override
  String get noRateAvailable => 'レートがありません';

  @override
  String atMockRate(Object p0) {
    return '仮レートで $p0';
  }

  @override
  String get planWithoutPolicingYourself => '自分を取り締まらずに計画する';

  @override
  String get budgetsShowPaceAndRemaining => '予算はペースと残額を示すだけで、ふつうの支出を責めたりはしません。';

  @override
  String get budgetNotFound => '予算が見つかりません';

  @override
  String get itMayHaveBeenDeleted => '削除された可能性があります。';

  @override
  String projectedEndOf(Object p0) {
    return '$p0末の見込み';
  }

  @override
  String get nothingCountedYet => 'まだ集計対象がありません';

  @override
  String get matchingExpensesWillAppearHere => '条件に合う支出は自動でここに表示されます。';

  @override
  String get expensesStayUntouchedOnlyThis => '支出はそのままです。この上限とアラートだけが削除されます。';

  @override
  String get eGGroceries => '例：食料品';

  @override
  String get nameThisBudget => 'この予算に名前をつけてください';

  @override
  String get allExpenseCategories => 'すべての支出カテゴリ';

  @override
  String get onlySelectedCategoriesCount => '選んだカテゴリだけが対象です';

  @override
  String get allWalletsAreIncluded => 'すべての口座が対象です';

  @override
  String get onlySelectedWalletsCount => '選んだ口座だけが対象です';

  @override
  String get enterALimitGreaterThan => '0 より大きい上限を入力してください';

  @override
  String get carryTheLeftoverOver => '余りを繰り越す';

  @override
  String whateverIsUnspentAtThe(Object p0) {
    return '$p0の終わりに使わなかった分が、次の$p0に足されます。';
  }

  @override
  String get searchRecurringItems => '定期項目を検索';

  @override
  String get noActiveSubscriptions => '有効なサブスクはありません';

  @override
  String get addRecurringPaymentsToSee => '定期的な支払いを追加すると、次の請求と月あたりの費用が分かります。';

  @override
  String get subscriptionNotFound => 'サブスクが見つかりません';

  @override
  String get paymentHistoryRemainsInActivity =>
      '支払いの履歴は履歴画面に残ります。定期項目が一覧から外れるだけです。';

  @override
  String get noPaymentsRecorded => '記録された支払いはありません';

  @override
  String get recordedPaymentsAppearHereAnd => '記録した支払いは、ここと履歴画面に表示されます。';

  @override
  String walletDebitUsingTheCurrent(Object p0, Object p1) {
    return '\n\n口座からの引き落とし：現在の $p1 レートでおよそ $p0。';
  }

  @override
  String willBeRecordedFrom(Object p0, Object p1, Object p2) {
    return '$p1 から $p0 を記録します。$p2';
  }

  @override
  String get skipThisPayment => 'この支払いを飛ばしますか？';

  @override
  String get noExpenseIsRecordedThe => '支出は記録されません。次回の予定日が1回分進みます。';

  @override
  String get eGSpotify => '例：Spotify';

  @override
  String get nameThisSubscription => 'このサブスクに名前をつけてください';

  @override
  String get enterAnAmount => '金額を入力してください';

  @override
  String monthlyOnDay(Object p0) {
    return '毎月 $p0 日';
  }

  @override
  String noCategoryMatches(Object p0) {
    return '「$p0」に一致するカテゴリがありません';
  }

  @override
  String get tryADifferentNameOr2 => '別の名前で試すか、新しいカテゴリを追加してください。';

  @override
  String activeAnnualized(Object p0, Object p1) {
    return '有効 $p0 · 年換算 $p1';
  }

  @override
  String get dayOfMonth => '毎月の日にち';

  @override
  String get aPockitoCategoryItCan =>
      'Pockito の標準カテゴリです。すでに使っている記録があるため、削除はできませんが非表示にはできます。';

  @override
  String get yourOwnCategory => '自分で作ったカテゴリ';

  @override
  String get nestUnderAnotherCategory => '別のカテゴリの下に入れる';

  @override
  String get itReappearsInPickersAnd => '選択肢と絞り込みに再び表示されます。';

  @override
  String get itStaysOnEveryRecord => 'すでに使っている記録には残り、選択肢には出なくなります。';

  @override
  String isVisibleAgain(Object p0) {
    return '$p0 を再表示しました';
  }

  @override
  String isTopLevelAgain(Object p0) {
    return '$p0 を最上位に戻しました';
  }

  @override
  String get categoriesOnlyNestOneLevel => 'カテゴリの入れ子は1階層までです。';

  @override
  String hasItsOwnSubcategoriesSo(Object p0) {
    return '$p0 には子カテゴリがあるため、子カテゴリにはできません。';
  }

  @override
  String get reassignBeforeDeleting => '削除の前に付け替える';

  @override
  String isUsedByExistingMoney(Object p0) {
    return '$p0 は既存の記録で使われています。どこに移すか選んでください。';
  }

  @override
  String get reassignAndDelete => '付け替えて削除';

  @override
  String get everythingBeyondYourDayTo => '日々のお金の、その先にあるもの';

  @override
  String get cutAcrossCategoriesBerlinTrip => 'カテゴリをまたぐ印 — 「ベルリン旅行」「仕事」など';

  @override
  String get answerHowMuchWentOn => '「Amex でいくら使ったか」に答えられます';

  @override
  String get netWorthAndThisMonth => '純資産と今月を、ひと目で';

  @override
  String get csvInCsvOrJson => 'CSV を取り込み、CSV か JSON で書き出し';

  @override
  String get budgetsSharedMoneyAndApprovals => '予算・共有のお金・承認';

  @override
  String get replayOnboardingPreviewAnInvite => '初回体験のやり直し、招待のプレビュー、状態カタログ';

  @override
  String get exploreTheFirstRunExperience => '初回の体験を確かめる';

  @override
  String get previewAnIncomingSpaceInvite => '届いた招待を確かめる';

  @override
  String get loadingEmptyErrorAndOffline => '読み込み中・空・エラー・オフライン';

  @override
  String get resetPrototypeData => 'プロトタイプのデータをリセット';

  @override
  String get resetAllPrototypeData => 'プロトタイプのデータをすべてリセットしますか？';

  @override
  String get everyLocalChangeIsReplaced => '端末での変更はすべて、元の一貫したサンプルデータに置き換わります。';

  @override
  String get prototypeDataReset => 'プロトタイプのデータをリセットしました';

  @override
  String get avatarColoursRotateLocallyIn => 'このプロトタイプでは、アバターの色は端末内で順番に変わります';

  @override
  String get thisChangesReportingTotalsOnly =>
      '変わるのは表示用の合計だけです。口座やスペースの通貨が勝手に変わることはありません。';

  @override
  String get howShouldPockitoConvertCurrencies => '通貨の換算方法';

  @override
  String get originalAmountsAreAlwaysPreserved =>
      '元の金額は常に保持されます。換算後の合計は目安で、使用したレートが添えられます。';

  @override
  String get automaticSnapshotActive => '自動スナップショットが有効です';

  @override
  String get mockedLocallyForThePrototype =>
      'プロトタイプ用に端末内で用意した値です。外部の為替サービスは呼び出しません。';

  @override
  String get manualRatesRemainActiveUntil =>
      '手動レートは、戻すまで有効なままです。必要な通貨ペアに有効なレートがないと、振替は保存できません。';

  @override
  String yourManualRate(Object p0, Object p1) {
    return '手動の $p0 → $p1 レート';
  }

  @override
  String get saveManualRates => '手動レートを保存';

  @override
  String enterAValidRateFor(Object p0) {
    return '$p0 の有効なレートを入力してください';
  }

  @override
  String get manualExchangeRatesSaved => '手動レートを保存しました';

  @override
  String get followYourDevice => '端末の設定に合わせる';

  @override
  String alwaysUseMode(Object p0) {
    return '常に$p0を使う';
  }

  @override
  String get typographyBordersAndSemanticColours =>
      '文字・境界線・意味を持つ色が、まとめて切り替わります。';

  @override
  String get notificationPreviewEnabled => '通知プレビューが有効です';

  @override
  String get noSystemPermissionIsRequested => 'このプロトタイプではシステムの許可を求めません。';

  @override
  String get kitoTheOfficialPockitoMascot => 'Pockito の公式マスコット、キト';

  @override
  String get moneyWithKitoPrototype => 'キトと一緒のお金 · プロトタイプ 0.1.0';

  @override
  String get pockitoGivesPersonalAndShared =>
      'Pockito は、個人のお金と共有のお金にひとつの居場所を与えます。キトは、気づき・空の状態・節目に寄り添う落ち着いた相棒です。この Flutter 版は端末内のサンプルデータだけを使っています。';

  @override
  String get noPersonalDataLeavesThis => '個人データがこのプロトタイプの外に出ることはありません。';

  @override
  String get prototypeTermsAreIntentionallyLocal => 'プロトタイプの規約は、あくまで端末内の説明用です。';

  @override
  String get sharedExpensesBudgetAlertsAnd => '共有の支出・予算のお知らせ・承認がここに表示されます。';

  @override
  String get homeScreenStates => 'ホーム画面の状態';

  @override
  String get chooseAStateReturnHome => '状態を選んでホームに戻り、実際の表示を確かめてください。';

  @override
  String get purposefulEmptyState => '意味のある空の状態';

  @override
  String get everyEmptySurfaceExplainsWhat =>
      '空の画面はどれも、ここに何が入るのかを説明し、次にできることを示します。';

  @override
  String get coherentFixtureData => '一貫したサンプルデータ';

  @override
  String get recoverableFullScreenError => '回復できる全画面エラー';

  @override
  String get welcomeToPockito => 'Pockito へようこそ';

  @override
  String get personalAndSharedMoneyIn => '個人のお金と共有のお金を、ひとつの場所に。';

  @override
  String get continueWithApple => 'Apple で続ける';

  @override
  String get continueWithGoogle => 'Google で続ける';

  @override
  String get youExampleCom => 'you@example.com';

  @override
  String get continueWithEmail => 'メールで続ける';

  @override
  String get previewAuthenticationError => '認証エラーを確かめる';

  @override
  String get authenticationIsSimulatedLocallyIn =>
      'この UI プロトタイプでは、認証は端末内のシミュレーションです。';

  @override
  String get weCouldnTSignYou => 'サインインできませんでした';

  @override
  String get nothingWasChangedCheckYour =>
      '何も変更されていません。接続を確認してもう一度お試しになるか、別のサインイン方法を選んでください。';

  @override
  String get returnToPrototype => 'プロトタイプに戻る';

  @override
  String get moneyThatMakesSense => '納得できるお金の見え方';

  @override
  String get seeYourOwnAccountsAnd => '自分のお金と、分け合っているお金を、二重に数えずに見られます。';

  @override
  String get makePockitoYours => 'Pockito を自分仕様に';

  @override
  String get setTheIdentityAndDefaults =>
      '共有スペースで相手に見える名前と初期設定を決めます。あとから変更できます。';

  @override
  String get localProfileAvatar => 'local://profile/avatar';

  @override
  String get chooseProfilePhoto => 'プロフィール写真を選ぶ';

  @override
  String get photoSelectedLocally => '端末内で写真を選びました';

  @override
  String get useDeviceSetting => '端末の設定を使う';

  @override
  String get setYourHomeBase => '拠点を設定する';

  @override
  String get thisOnlyControlsReportingEvery =>
      'これは表示用の設定だけです。口座もスペースも、それぞれの通貨を保ちます。';

  @override
  String get givePockitoOnePlaceWhere => 'お金が入り、出ていく場所を Pockito にひとつ教えてください。';

  @override
  String get useTheSampleAccount => 'サンプルの口座を使う';

  @override
  String get shareMoneyWithSomeone => '誰かとお金を共有しますか？';

  @override
  String get createASpaceForA2 => '家・旅行・ふたり・グループごとにスペースを作れます。あとからでも構いません。';

  @override
  String get yesCreateASharedSpace => 'はい、共有スペースを作ります';

  @override
  String get notRightNow => '今はしない';

  @override
  String get spacesAreReadyWhenYou => 'スペースはいつでも作れます';

  @override
  String get shareThisLinkTheInvite =>
      'このリンクを共有してください。招待は7日で期限切れになり、取り消すこともできます。';

  @override
  String get youCanCreateAShared => '共有スペースは、スペースのタブからいつでも作れます。';

  @override
  String get pockitoWorksBeautifullyForPersonal =>
      'Pockito は個人のお金だけでも十分に役立ちます。';

  @override
  String get youReAllSet => '準備ができました';

  @override
  String get yourOverviewAccountsSharedSpaces => '概要・口座・共有スペース・履歴を、いつでも見られます。';

  @override
  String get enterYourNameToContinue => '続けるには名前を入力してください';

  @override
  String get addAnAccountNameAnd => '口座の名前と有効な残高を入力してください';

  @override
  String get joinBookClub => 'Book Club に参加しますか？';

  @override
  String get samInvitedYouToA => 'Sam が EUR を使う4人の共有スペースに招待しました。';

  @override
  String get joinedBookClubLocally => '端末内で Book Club に参加しました';

  @override
  String get whatLeftYourAccounts => '口座から出た金額';

  @override
  String get onlyYourShare => '自分の負担分のみ';

  @override
  String get aCompleteSampleDatasetIs => 'ひととおりのサンプルデータが用意されています';

  @override
  String get youCanAddEditSplit => '実際の金融サービスにつながずに、追加・編集・割り勘・精算まで試せます。';

  @override
  String get confirmSettlement => '精算を確定する';

  @override
  String expenseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '支出$count件',
    );
    return '$_temp0';
  }

  @override
  String settlementCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '精算$count件',
    );
    return '$_temp0';
  }

  @override
  String paymentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '支払い$count件',
    );
    return '$_temp0';
  }

  @override
  String cycleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '過去のサイクル$count件',
    );
    return '$_temp0';
  }

  @override
  String recordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '記録$count件',
    );
    return '$_temp0';
  }

  @override
  String activeAccountCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有効な口座$count件',
    );
    return '$_temp0';
  }

  @override
  String memberCountPlain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'メンバー$count人',
    );
    return '$_temp0';
  }

  @override
  String peopleCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count人',
    );
    return '$_temp0';
  }

  @override
  String connectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '連携$count件',
    );
    return '$_temp0';
  }

  @override
  String budgetCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有効な予算$count件',
    );
    return '$_temp0';
  }

  @override
  String categoryCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'カテゴリ$count件',
    );
    return '$_temp0';
  }

  @override
  String methodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '支払い方法$count件',
    );
    return '$_temp0';
  }

  @override
  String savedViewCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '保存済み$count件',
    );
    return '$_temp0';
  }

  @override
  String activeSubscriptionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '有効$count件',
    );
    return '$_temp0';
  }

  @override
  String tagCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'タグ$count件',
    );
    return '$_temp0';
  }

  @override
  String get chooseAnAccountX => '口座を選ぶ';

  @override
  String exportsExactlyWhatActivityIs(Object p0) {
    return 'いま履歴に表示されている $p0 をそのまま書き出します。台帳全体ではありません。';
  }

  @override
  String readFromThisReceipt(Object p0) {
    return 'このレシートから読み取った内容：$p0';
  }

  @override
  String spendingByCategory(Object p0) {
    return 'カテゴリ別の支出。$p0';
  }

  @override
  String trendFromTo(Object p0, Object p1, Object p2) {
    return '$p0 から $p1 までの推移。$p2';
  }

  @override
  String nobodyMatches(Object p0) {
    return '「$p0」に一致する人がいません';
  }

  @override
  String nothingMatchesQuery(Object p0) {
    return '「$p0」に一致するものがありません。';
  }

  @override
  String searchCategoriesCount(Object p0) {
    return '$p0 件のカテゴリを検索';
  }

  @override
  String proposedByAwaiting(Object p0, Object p1) {
    return '$p0 が申請 · $p1 の確認待ち';
  }

  @override
  String moveOutOf(Object p0) {
    return '$p0 から出す';
  }

  @override
  String get yourWord => 'あなた';

  @override
  String get theirWord => '相手';

  @override
  String get statusLabel => '状態';

  @override
  String get confirmedWord => '確定済み';

  @override
  String get cancelledWord => '取り消し済み';

  @override
  String moveOutOfParent(Object p0) {
    return '$p0 から出す';
  }

  @override
  String get unverifiedClient => '未確認のクライアント';

  @override
  String get animatedSkeletons => 'スケルトンのアニメーション';

  @override
  String get firstUseGuidance => '初回利用のガイド';

  @override
  String get localModeBanner => 'ローカルモードのバナー';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get aiApp => 'AIアプリ';

  @override
  String get kitoNoticed => 'Kitoが気づきました';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get spent => '支出額';

  @override
  String x0Over(Object p0) {
    return '$p0超過';
  }

  @override
  String x0Left(Object p0) {
    return '残り$p0';
  }

  @override
  String x0X1OfX2X3X4(Object p0, Object p1, Object p2, Object p3, Object p4) {
    return '$p0：$p2中$p1。$p3。$p4';
  }

  @override
  String ofX0(Object p0) {
    return '$p0中';
  }

  @override
  String get settled => '精算済み';

  @override
  String get youReOwed => '受け取り';

  @override
  String get youOwe => '支払い';

  @override
  String get transfer => '振替';

  @override
  String get uncategorised => '未分類';

  @override
  String get shared => '共有';

  @override
  String yourShareX0(Object p0) {
    return 'あなたの負担 $p0';
  }

  @override
  String x0OfX1X2(Object p0, Object p1, Object p2) {
    return '$p1中$p0 · $p2';
  }

  @override
  String lastX0(Object p0) {
    return '前回の$p0';
  }

  @override
  String get retry => '再試行';

  @override
  String get addMoney => 'お金を記録';

  @override
  String get expense => '支出';

  @override
  String get income => '収入';

  @override
  String get betweenAccounts => '口座間';

  @override
  String get scan => 'スキャン';

  @override
  String x0Results(Object p0) {
    return '$p0件の結果';
  }

  @override
  String get amount => '金額';

  @override
  String get date => '日付';

  @override
  String get lastWeek => '先週';

  @override
  String get searchAccounts => '口座を検索';

  @override
  String get searchCategories => 'カテゴリを検索';

  @override
  String inX0(Object p0) {
    return '$p0内';
  }

  @override
  String searchX0Currencies(Object p0) {
    return '$p0件の通貨を検索';
  }

  @override
  String get all => 'すべて';

  @override
  String get you => 'あなた';

  @override
  String x0You(Object p0) {
    return '$p0（あなた）';
  }

  @override
  String get searchMembers => 'メンバーを検索';

  @override
  String get tags => 'タグ';

  @override
  String get newTag => '新しいタグ';

  @override
  String get clear => 'クリア';

  @override
  String voidedX0(Object p0) {
    return '$p0を取り消しました。';
  }

  @override
  String get attachments => '添付';

  @override
  String get attach => '添付する';

  @override
  String removeX0(Object p0) {
    return '$p0を削除';
  }

  @override
  String get queued => '待機中';

  @override
  String get reading => '読み取り中';

  @override
  String get read => '読み取り済み';

  @override
  String get unreadable => '読み取り不可';

  @override
  String capturedX0(Object p0) {
    return '$p0に撮影';
  }

  @override
  String get reason => '理由';

  @override
  String get delete => '削除';

  @override
  String youCanTX0(Object p0) {
    return '$p0はできません';
  }

  @override
  String get saving => '保存中…';

  @override
  String get loading => '読み込み中';

  @override
  String payX0(Object p0) {
    return '$p0を支払いますか？';
  }

  @override
  String x0WillBeRecordedFromX1ThisIsLocalPrototypeDa(Object p0, Object p1) {
    return '$p1から$p0が記録されます。これはローカルのプロトタイプデータです。';
  }

  @override
  String get recordPayment => '支払いを記録';

  @override
  String get view => '表示';

  @override
  String get assistant => 'アシスタント';

  @override
  String get notifications => '通知';

  @override
  String get addAccount => '口座を追加';

  @override
  String get createSpace => 'スペースを作成';

  @override
  String get and => 'と';

  @override
  String overdueByX0DayX1(Object p0, Object p1) {
    return '$p0日遅延';
  }

  @override
  String get dueToday => '今日が期日';

  @override
  String get pay => '支払う';

  @override
  String get add => '追加';

  @override
  String get chooseMonth => '月を選択';

  @override
  String x0MoneyEventX1(Object p0, Object p1) {
    return '$p0件の記録';
  }

  @override
  String get clearFilters => 'フィルタをクリア';

  @override
  String get tag => 'タグ';

  @override
  String get paymentMethod => '支払い方法';

  @override
  String get includingVoided => '取り消し済みを含む';

  @override
  String get draftsHidden => '下書きは非表示';

  @override
  String savedX0(Object p0) {
    return '「$p0」を保存しました';
  }

  @override
  String get savedViews => '保存したビュー';

  @override
  String deleteX0(Object p0) {
    return '$p0を削除';
  }

  @override
  String get moneyEvent => 'お金の記録';

  @override
  String get restored => '復元しました';

  @override
  String get edit => '編集';

  @override
  String get duplicate => '複製';

  @override
  String get type => '種類';

  @override
  String get from => '送出元';

  @override
  String get notTracked => '対象外';

  @override
  String get to => '送出先';

  @override
  String get sent => '送金額';

  @override
  String get received => '受取額';

  @override
  String get exchangeRate => '為替レート';

  @override
  String get rateCaptured => 'レート取得';

  @override
  String get fee => '手数料';

  @override
  String get none => 'なし';

  @override
  String get sharedSpace => '共有スペース';

  @override
  String get addedVia => '追加元';

  @override
  String get aiConnection => 'AI連携';

  @override
  String get paidWith => '支払い方法';

  @override
  String get originalAmount => '元の金額';

  @override
  String get rateUsed => '適用レート';

  @override
  String get correctionReason => '修正理由';

  @override
  String get note => 'メモ';

  @override
  String get receipts => 'レシート';

  @override
  String get settlement => '精算';

  @override
  String get whyOptional => '理由（任意）';

  @override
  String get voidIt => '取り消す';

  @override
  String voidedX02(Object p0) {
    return '$p0を取り消しました';
  }

  @override
  String get youReOffline => 'オフラインです';

  @override
  String get description => '説明';

  @override
  String get source => '取得元';

  @override
  String get merchant => '店舗';

  @override
  String get noteOptional => 'メモ（任意）';

  @override
  String get toAccount => '入金先口座';

  @override
  String get fromAccount => '出金元口座';

  @override
  String get automatic => '自動';

  @override
  String get manual => '手動';

  @override
  String l1X0InX1(Object p0, Object p1) {
    return '$p1に${p0}1件';
  }

  @override
  String x0UpdatedX1(Object p0, Object p1) {
    return '$p0 · $p1に更新';
  }

  @override
  String get feeOptional => '手数料（任意）';

  @override
  String get destinationReceives => '入金先の受取額';

  @override
  String fromX0X1Rate(Object p0, Object p1) {
    return '≈ $p0から · $p1レート';
  }

  @override
  String get notRecorded => '未記録';

  @override
  String get paidBy => '支払者';

  @override
  String get split => '分担';

  @override
  String get walletConversion => 'ウォレット換算';

  @override
  String x0SpaceAmount(Object p0) {
    return '$p0スペース金額';
  }

  @override
  String get saveChanges => '変更を保存';

  @override
  String get addIncome => '収入を追加';

  @override
  String get addTransfer => '振替を追加';

  @override
  String get addExpense => '支出を追加';

  @override
  String get spaceDefault6040 => 'スペース既定 · 60/40';

  @override
  String equallyBetweenX0(Object p0) {
    return '$p0で均等';
  }

  @override
  String x0x1X2People(Object p0, Object p1, Object p2) {
    return '$p0$p1 · $p2人';
  }

  @override
  String receiptX0(Object p0) {
    return 'レシート · $p0';
  }

  @override
  String get reviewReceipt => 'レシートを確認';

  @override
  String get scanReceipt => 'レシートをスキャン';

  @override
  String get closeScanner => 'スキャナを閉じる';

  @override
  String get captureReceipt => 'レシートを撮影';

  @override
  String get lowConfidenceMode => '低信頼モード ✓';

  @override
  String get failureMode => '失敗モード ✓';

  @override
  String get retake => '撮り直す';

  @override
  String get retryScan => '再スキャン';

  @override
  String get unreadableReceipt => '読み取れないレシート';

  @override
  String get filterActivity => '履歴を絞り込む';

  @override
  String get allTime => '全期間';

  @override
  String get previousMonth => '前月';

  @override
  String get wallet => 'ウォレット';

  @override
  String get searchSpaces => 'スペースを検索';

  @override
  String get searchTags => 'タグを検索';

  @override
  String get lifecycle => '状態';

  @override
  String get showVoided => '取り消し済みを表示';

  @override
  String get showDrafts => '下書きを表示';

  @override
  String get showEverything => 'すべて表示';

  @override
  String applyX0Filters(Object p0) {
    return '$p0件のフィルタを適用';
  }

  @override
  String get splitExpense => '支出を分担';

  @override
  String x0InX1(Object p0, Object p1) {
    return '$p1で$p0';
  }

  @override
  String get equal => '均等';

  @override
  String get percentage => '割合';

  @override
  String get shares => '口数';

  @override
  String get exactAmounts => '金額指定';

  @override
  String get itemized => '品目別';

  @override
  String x0You2(Object p0) {
    return '$p0 · あなた';
  }

  @override
  String get previewSplit => '分担をプレビュー';

  @override
  String get addLine => '明細を追加';

  @override
  String get keepEditing => '編集を続ける';

  @override
  String get onePayer => '単独支払い';

  @override
  String voidedX03(Object p0) {
    return '取り消し：$p0';
  }

  @override
  String voidX0(Object p0) {
    return '$p0を取り消しますか？';
  }

  @override
  String get open => '開く';

  @override
  String get archivedSpaces => 'アーカイブ済みスペース';

  @override
  String youOweX0(Object p0) {
    return '$p0の支払い';
  }

  @override
  String x0OwesYou(Object p0) {
    return '$p0からの受け取り';
  }

  @override
  String get settlementHistory => '精算履歴';

  @override
  String get members2 => 'メンバー';

  @override
  String get spaceSettings => 'スペース設定';

  @override
  String get money => 'お金';

  @override
  String get people => '人数';

  @override
  String x0PreviousX1(Object p0, Object p1) {
    return '過去$p0$p1';
  }

  @override
  String get cycleHistory => 'サイクル履歴';

  @override
  String x0Expenses(Object p0) {
    return '支出$p0件';
  }

  @override
  String get filter => '絞り込み';

  @override
  String x0AddedX1(Object p0, Object p1) {
    return '$p0が$p1に追加';
  }

  @override
  String get balanceBreakdown => '残高の内訳';

  @override
  String paidX0ShareX1(Object p0, Object p1) {
    return '支払い $p0 · 負担 $p1';
  }

  @override
  String get notYet => 'まだです';

  @override
  String get filterExpenses => '支出を絞り込む';

  @override
  String get unsettled => '未精算';

  @override
  String get allMembers => '全メンバー';

  @override
  String get allCategories => '全カテゴリ';

  @override
  String get applyFilters => 'フィルタを適用';

  @override
  String get editExpense => '支出を編集';

  @override
  String get historicalExpense => '過去の支出';

  @override
  String get recordedBy => '記録者';

  @override
  String get someone => '誰か';

  @override
  String get splitMethod => '分担方法';

  @override
  String get sharedBudget => '共有予算';

  @override
  String get inviteSomeone => '招待する';

  @override
  String get spaceName => 'スペース名';

  @override
  String get spaceCurrency => 'スペースの通貨';

  @override
  String get icon => 'アイコン';

  @override
  String get colour => '色';

  @override
  String get names => '名前';

  @override
  String get emails => 'メールアドレス';

  @override
  String get copy => 'コピー';

  @override
  String get skipInvitation => '招待をスキップ';

  @override
  String x0Monthly(Object p0) {
    return '月額$p0';
  }

  @override
  String get membersInvites => 'メンバーと招待';

  @override
  String get invite => '招待';

  @override
  String searchX0Members(Object p0) {
    return '$p0人のメンバーを検索';
  }

  @override
  String pendingInvitesX0(Object p0) {
    return '保留中の招待（$p0）';
  }

  @override
  String x0AsX1X2X3(Object p0, Object p1, Object p2, Object p3) {
    return '$p0 · $p1として · $p2$p3';
  }

  @override
  String get pending => '保留中';

  @override
  String get resend => '再送';

  @override
  String get revoke => '取り消す';

  @override
  String x0JoinedAsX1(Object p0, Object p1) {
    return '$p0が$p1として参加';
  }

  @override
  String get simulateAcceptance => '承諾をシミュレート';

  @override
  String get simulateDecline => '辞退をシミュレート';

  @override
  String get invitationHistory => '招待履歴';

  @override
  String x0AsX1(Object p0, Object p1) {
    return '$p0 · $p1として';
  }

  @override
  String get inviteAgain => '再度招待';

  @override
  String get keepIt => 'そのままにする';

  @override
  String get viewBalances => '残高を見る';

  @override
  String get changeRole => '権限を変更';

  @override
  String currentlyX0(Object p0) {
    return '現在は$p0';
  }

  @override
  String leaveX0(Object p0) {
    return '$p0から退出';
  }

  @override
  String x0SRole(Object p0) {
    return '$p0の権限';
  }

  @override
  String leaveX02(Object p0) {
    return '$p0から退出しますか？';
  }

  @override
  String get leave => '退出';

  @override
  String youLeftX0(Object p0) {
    return '$p0から退出しました';
  }

  @override
  String x0SBalance(Object p0) {
    return '$p0の残高';
  }

  @override
  String get currentCycle => '今サイクル';

  @override
  String get lifetime => '通算';

  @override
  String removeX02(Object p0) {
    return '$p0を削除しますか？';
  }

  @override
  String get remove => '削除';

  @override
  String x0Removed(Object p0) {
    return '$p0を削除しました';
  }

  @override
  String inviteToX0(Object p0) {
    return '$p0に招待';
  }

  @override
  String get name => '名前';

  @override
  String get email => 'メールアドレス';

  @override
  String get joinAs => '参加時の権限';

  @override
  String x0DayX1(Object p0, Object p1) {
    return '$p0日';
  }

  @override
  String get sendInvite => '招待を送る';

  @override
  String get defaultSplit => '既定の分担';

  @override
  String youAreX0(Object p0) {
    return 'あなたは$p0です';
  }

  @override
  String get activityLog => 'アクティビティログ';

  @override
  String get newExpenses => '新しい支出';

  @override
  String get settlements => '精算';

  @override
  String get allActivity => 'すべての履歴';

  @override
  String get reopenSpace => 'スペースを再開';

  @override
  String get archiveSpace => 'スペースをアーカイブ';

  @override
  String get renameSpace => 'スペース名を変更';

  @override
  String get exact => '金額指定';

  @override
  String archiveX0(Object p0) {
    return '$p0をアーカイブしますか？';
  }

  @override
  String get archive => 'アーカイブ';

  @override
  String backToX0(Object p0) {
    return '$p0に戻る';
  }

  @override
  String get suggestedPayments => 'おすすめの精算';

  @override
  String x0PayX1X2(Object p0, Object p1, Object p2) {
    return '$p0が$p2を支払う';
  }

  @override
  String get paidFrom => '出金元';

  @override
  String get receivedIn => '入金先';

  @override
  String get walletMovement => 'ウォレットの移動';

  @override
  String get reviewSettlement => '精算を確認';

  @override
  String get goBack => '戻る';

  @override
  String x0PaymentX1RemainThisWalletMovementDidNotCou(Object p0, Object p1) {
    return 'あと$p0件の支払いが残っています。このウォレットの移動は支出には計上されません。';
  }

  @override
  String x0X1X2Total(Object p0, Object p1, Object p2) {
    return '$p0 $p1 · 合計$p2';
  }

  @override
  String get pastSettlements => '過去の精算';

  @override
  String cycleClosedX0(Object p0) {
    return '$p0にサイクル終了';
  }

  @override
  String get newSettlement => '新しい精算';

  @override
  String x0PaidX1(Object p0, Object p1) {
    return '$p0が$p1を支払い';
  }

  @override
  String get aMember => 'メンバー';

  @override
  String get settlementDetail => '精算の詳細';

  @override
  String get settlementConfirmed => '精算を確定しました';

  @override
  String get settlementCancelled => '精算を取り消しました';

  @override
  String x0ConfirmsThisBeforeAnyBalanceMoves(Object p0) {
    return '残高が動く前に$p0が確認します。';
  }

  @override
  String onlyX0CanConfirmThis(Object p0) {
    return '確認できるのは$p0だけです';
  }

  @override
  String get theRecipient => '受取人';

  @override
  String get cancelSettlement => '精算を取り消す';

  @override
  String get spaceCycles => 'スペースのサイクル';

  @override
  String x0ExpensesX1(Object p0, Object p1) {
    return '支出$p0件 · $p1';
  }

  @override
  String x0OfX1Budget(Object p0, Object p1) {
    return '予算$p1中$p0';
  }

  @override
  String previousCyclesX0(Object p0) {
    return '過去のサイクル（$p0）';
  }

  @override
  String get period => '期間';

  @override
  String get noBudget => '予算なし';

  @override
  String get finalStatus => '最終状態';

  @override
  String get everyoneSettled => '全員精算済み';

  @override
  String get memberContributions => 'メンバー別の内訳';

  @override
  String responsibleForX0(Object p0) {
    return '負担 $p0';
  }

  @override
  String paidX0(Object p0) {
    return '支払い $p0';
  }

  @override
  String get categories => 'カテゴリ';

  @override
  String expensesX0(Object p0) {
    return '支出（$p0）';
  }

  @override
  String get allTimeBalance => '通算残高';

  @override
  String get cycle => 'サイクル';

  @override
  String get breakdown => '内訳';

  @override
  String x0PaidX12(Object p0, Object p1) {
    return '$p0が支払い · $p1';
  }

  @override
  String viaX0(Object p0) {
    return '$p0経由';
  }

  @override
  String x0Activity(Object p0) {
    return '$p0の履歴';
  }

  @override
  String get friendly => 'やさしい';

  @override
  String get detailed => 'くわしい';

  @override
  String get accountActions => '口座の操作';

  @override
  String get reorderAccounts => '口座を並べ替え';

  @override
  String get archivedAccounts => 'アーカイブ済み口座';

  @override
  String searchX0Accounts(Object p0) {
    return '$p0件の口座を検索';
  }

  @override
  String get editAccount => '口座を編集';

  @override
  String get archiveAccount => '口座をアーカイブ';

  @override
  String get last30Days => '過去30日';

  @override
  String ofX0Limit(Object p0) {
    return '上限$p0中';
  }

  @override
  String get savingsGoal => '貯蓄目標';

  @override
  String x0OfX1(Object p0, Object p1) {
    return '$p1中$p0';
  }

  @override
  String get recentActivity => '最近の履歴';

  @override
  String get accountName => '口座名';

  @override
  String get accountType => '口座の種類';

  @override
  String get currency => '通貨';

  @override
  String get openingBalance => '開始残高';

  @override
  String get currentBalance => '現在の残高';

  @override
  String get defaultAccount => '既定の口座';

  @override
  String x0Added(Object p0) {
    return '$p0を追加しました';
  }

  @override
  String get accountUpdated => '口座を更新しました';

  @override
  String x0X1Rate(Object p0, Object p1) {
    return '≈ $p0 · $p1レート';
  }

  @override
  String get aiIntegrations => 'AIと連携';

  @override
  String get connections => '連携';

  @override
  String lastUsedX0(Object p0) {
    return '最終利用 $p0';
  }

  @override
  String get authorizationRequest => '認可リクエスト';

  @override
  String get verifiedApplication => '認証済みアプリ';

  @override
  String get transactions => '取引';

  @override
  String get spacesBalances => 'スペースと残高';

  @override
  String get analytics => '分析';

  @override
  String allowX0(Object p0) {
    return '$p0を許可';
  }

  @override
  String get donTAllow => '許可しない';

  @override
  String get financialChanges => '金銭に関わる変更';

  @override
  String get connected => '連携中';

  @override
  String get suspended => '停止中';

  @override
  String get lastUsed => '最終利用';

  @override
  String get reads => '読み取り';

  @override
  String get writes => '書き込み';

  @override
  String get permissions => '権限';

  @override
  String get disconnectApp => 'アプリの連携を解除';

  @override
  String get connectionPermissions => '連携の権限';

  @override
  String get savePermissions => '権限を保存';

  @override
  String disconnectX0(Object p0) {
    return '$p0の連携を解除しますか？';
  }

  @override
  String get disconnect => '解除';

  @override
  String get aiActivity => 'AIの操作履歴';

  @override
  String addedX0(Object p0) {
    return '$p0に追加';
  }

  @override
  String get pendingApprovals => '承認待ち';

  @override
  String get recordedOn => '記録日';

  @override
  String get reject => '却下';

  @override
  String get approve => '承認';

  @override
  String get requestRejected => 'リクエストを却下しました';

  @override
  String get addTag => 'タグを追加';

  @override
  String searchX0Tags(Object p0) {
    return '$p0件のタグを検索';
  }

  @override
  String nothingMatchesX0(Object p0) {
    return '「$p0」に一致しません';
  }

  @override
  String onX0RecordX1(Object p0, Object p1) {
    return '$p0件に付与';
  }

  @override
  String renameX0(Object p0) {
    return '$p0の名前を変更';
  }

  @override
  String get tagAdded => 'タグを追加しました';

  @override
  String get tagRenamed => 'タグ名を変更しました';

  @override
  String get rename => '名前を変更';

  @override
  String x0Deleted(Object p0) {
    return '$p0を削除しました';
  }

  @override
  String get paymentMethods => '支払い方法';

  @override
  String get addOne => '追加する';

  @override
  String get card => 'カード';

  @override
  String get bankTransfer => '銀行振込';

  @override
  String get cash => '現金';

  @override
  String get directDebit => '口座引落';

  @override
  String get digitalWallet => '電子ウォレット';

  @override
  String x0Records(Object p0) {
    return '$p0件';
  }

  @override
  String get saved => '保存しました';

  @override
  String get importExport => 'インポートとエクスポート';

  @override
  String get export => 'エクスポート';

  @override
  String get import => 'インポート';

  @override
  String lineX0X1(Object p0, Object p1) {
    return '$p0行目 · $p1';
  }

  @override
  String importX0RecordX1(Object p0, Object p1) {
    return '$p0件を取り込む';
  }

  @override
  String x0Imported(Object p0) {
    return '$p0件を取り込みました';
  }

  @override
  String x0Copied(Object p0) {
    return '$p0をコピーしました';
  }

  @override
  String correctX0(Object p0) {
    return '$p0を修正';
  }

  @override
  String get balanceCorrected => '残高を修正しました';

  @override
  String get reportingTotal => '換算合計';

  @override
  String get reportingCurrency => '表示通貨';

  @override
  String get notCombined => '合算しません';

  @override
  String get createBudget => '予算を作成';

  @override
  String get personal => '個人';

  @override
  String get sharedSpaces => '共有スペース';

  @override
  String get editBudget => '予算を編集';

  @override
  String get deleteBudget => '予算を削除';

  @override
  String get used => '使用済み';

  @override
  String get limit => '上限';

  @override
  String get carriedOver => '繰り越し';

  @override
  String lastX02(Object p0) {
    return '前回の$p0';
  }

  @override
  String get scope => '対象';

  @override
  String get over => '超過';

  @override
  String get close => '閉じる';

  @override
  String get onTrack => '順調';

  @override
  String get includedSpending => '対象の支出';

  @override
  String get monthlyHistory => '月別の推移';

  @override
  String get allExpenses => 'すべての支出';

  @override
  String get allWallets => 'すべてのウォレット';

  @override
  String x0X1Only(Object p0, Object p1) {
    return '$p0 · $p1のみ';
  }

  @override
  String deleteX02(Object p0) {
    return '$p0を削除しますか？';
  }

  @override
  String get budgetName => '予算名';

  @override
  String get wallets => 'ウォレット';

  @override
  String get allWallets2 => 'すべてのウォレット';

  @override
  String x0Limit(Object p0) {
    return '上限$p0';
  }

  @override
  String get resets => 'リセット';

  @override
  String everyX0Days(Object p0) {
    return '$p0日ごと';
  }

  @override
  String get fewerDays => '日数を減らす';

  @override
  String get moreDays => '日数を増やす';

  @override
  String get alertAt80 => '80%で通知';

  @override
  String get alertAt100 => '100%で通知';

  @override
  String get subscriptions => 'サブスク';

  @override
  String get active => '有効';

  @override
  String get addSubscription => 'サブスクを追加';

  @override
  String get paused => '一時停止中';

  @override
  String get editSubscription => 'サブスクを編集';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get nextDue => '次回の支払い';

  @override
  String get notScheduled => '予定なし';

  @override
  String get unknown => '不明';

  @override
  String get started => '開始';

  @override
  String get skipNext => '次回をスキップ';

  @override
  String get paymentHistory => '支払い履歴';

  @override
  String get everyYear => '毎年';

  @override
  String get everyWeek => '毎週';

  @override
  String get everyDay => '毎日';

  @override
  String get everyMonth => '毎月';

  @override
  String everyX0Months(Object p0) {
    return '$p0か月ごと';
  }

  @override
  String recordX0(Object p0) {
    return '$p0を記録しますか？';
  }

  @override
  String get record => '記録';

  @override
  String get skip => 'スキップ';

  @override
  String get billingCurrency => '請求通貨';

  @override
  String get cadence => '周期';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get editCategory => 'カテゴリを編集';

  @override
  String get saveCategory => 'カテゴリを保存';

  @override
  String x0OverBudget(Object p0) {
    return '予算を$p0超過';
  }

  @override
  String x0Remaining(Object p0) {
    return '残り$p0';
  }

  @override
  String get monthlyCost => '月あたりの費用';

  @override
  String get repeats => '繰り返し';

  @override
  String get subcategory => 'サブカテゴリ';

  @override
  String get pockitoCategory => 'Pockitoのカテゴリ';

  @override
  String get customCategory => 'カスタムカテゴリ';

  @override
  String get showAgain => '再表示';

  @override
  String get hide => '非表示';

  @override
  String x0Hidden(Object p0) {
    return '$p0を非表示にしました';
  }

  @override
  String nestX0Under(Object p0) {
    return '$p0の親カテゴリ';
  }

  @override
  String x0NowSitsUnderX1(Object p0, Object p1) {
    return '$p0を$p1の下に移動しました';
  }

  @override
  String get moveTo => '移動先';

  @override
  String x0MoneyEvents(Object p0) {
    return '$p0件の記録';
  }

  @override
  String x0Active(Object p0) {
    return '$p0件が有効';
  }

  @override
  String get defaultCurrency => '既定の通貨';

  @override
  String x0ReportingOnly(Object p0) {
    return '$p0 · 表示のみ';
  }

  @override
  String get exchangeRates => '為替レート';

  @override
  String automaticX0(Object p0) {
    return '自動 · $p0';
  }

  @override
  String get manualRates => '手動レート';

  @override
  String get preferences => '設定';

  @override
  String get appearance => '外観';

  @override
  String get language => '言語';

  @override
  String get aboutPockito => 'Pockitoについて';

  @override
  String get prototypeTools => 'プロトタイプ用ツール';

  @override
  String get prototype => 'プロトタイプ';

  @override
  String get replayOnboarding => 'オンボーディングを再生';

  @override
  String get invitationReview => '招待の確認';

  @override
  String get stateCatalogue => '状態カタログ';

  @override
  String get reset => 'リセット';

  @override
  String get editProfile => 'プロフィールを編集';

  @override
  String get displayName => '表示名';

  @override
  String get country => '国';

  @override
  String get saveProfile => 'プロフィールを保存';

  @override
  String reportingInX0(Object p0) {
    return '$p0で表示';
  }

  @override
  String providerX0(Object p0) {
    return '提供元 · $p0';
  }

  @override
  String lastUpdatedX0(Object p0) {
    return '最終更新 · $p0';
  }

  @override
  String get manualConfiguration => '手動設定';

  @override
  String get preview => 'プレビュー';

  @override
  String get pockitoSurface => 'Pockitoの画面';

  @override
  String get language2 => '言語';

  @override
  String get privacy => 'プライバシー';

  @override
  String get terms => '利用規約';

  @override
  String get licences => 'ライセンス';

  @override
  String get allQuiet => '変わりありません';

  @override
  String get components => 'コンポーネント';

  @override
  String get moneyTogether => 'お金を、いっしょに。';

  @override
  String get bankAccount => '銀行口座';

  @override
  String get getStarted => 'はじめる';

  @override
  String get light => 'ライト';

  @override
  String get dark => 'ダーク';

  @override
  String get savings => '貯蓄';

  @override
  String get copyLink => 'リンクをコピー';

  @override
  String get noPressure => '急ぎではありません';

  @override
  String get openPockito => 'Pockitoを開く';

  @override
  String get spaceInvitation => 'スペースへの招待';

  @override
  String get l4People => '4人';

  @override
  String get invitedBy => '招待者';

  @override
  String get joinSpace => 'スペースに参加';

  @override
  String get decline => '辞退';

  @override
  String get cashFlow => '収支の流れ';

  @override
  String get yourSpending => 'あなたの支出';

  @override
  String get defaultLabel => 'デフォルト';

  @override
  String get continueLabel => '続ける';

  @override
  String get home => '自宅';

  @override
  String get trip => '旅行';

  @override
  String get couple => 'カップル';

  @override
  String get or => 'または';

  @override
  String get tryAgain => '再試行';

  @override
  String get prototypeMarketSnapshot => 'プロトタイプの市場スナップショット';

  @override
  String get cancel => 'キャンセル';

  @override
  String get notNow => 'あとで';

  @override
  String onTrackForX0ByTheEndOfTheX1(Object p0, Object p1) {
    return 'この$p1の終わりまでに$p0の見込みで、順調です。';
  }

  @override
  String get theSelectedAccount => '選択した口座';

  @override
  String get expiresToday => '今日で期限切れ';

  @override
  String expiresInX0Days(Object p0) {
    return 'あと$p0日で期限切れ';
  }

  @override
  String resentX0Times(Object p0) {
    return ' · $p0回再送';
  }

  @override
  String get periodNounWeek => '週';

  @override
  String get periodNounMonth => '月';

  @override
  String get periodNounQuarter => '四半期';

  @override
  String get periodNounYear => '年';

  @override
  String get periodNounPeriod => '期間';

  @override
  String get awaitingYourConfirmation => 'あなたの確認待ち';

  @override
  String get awaitingTheirConfirmation => '相手の確認待ち';

  @override
  String get cancelled => '取り消し済み';

  @override
  String x0JoinedTheSpace(Object p0) {
    return '$p0がスペースに参加しました';
  }

  @override
  String get accountTypeBank => '銀行';

  @override
  String get accountTypeCard => 'カード';

  @override
  String get accountTypeCash => '現金';

  @override
  String get accountTypeSavings => '貯蓄';

  @override
  String get accountTypeDigital => 'デジタル';

  @override
  String get statusVoided => '無効';

  @override
  String get statusDraft => '下書き';

  @override
  String get budgetsTitle => '予算';

  @override
  String get moreTitle => 'その他';

  @override
  String get notifUnread => '未読';

  @override
  String get notifToday => '今日';

  @override
  String get notifEarlier => 'それ以前';

  @override
  String get categoryLabel => 'カテゴリ';

  @override
  String get addHintMoneyOut => '支出';

  @override
  String get addHintMoneyIn => '収入';

  @override
  String get accountLabel => '口座';

  @override
  String get spaceLabel => 'スペース';

  @override
  String get budgetLabel => '予算';

  @override
  String get sharedExpenseLabel => '共有支出';

  @override
  String get budgetDaysLeft => '残り日数';

  @override
  String get budgetDailyAllowance => '1日あたり';

  @override
  String get languageEnglish => 'English';

  @override
  String get profileSampleCountry => 'ドイツ';

  @override
  String get aboutVersion => 'プロトタイプ 0.1.0';

  @override
  String get budgetPace => 'ペース';

  @override
  String get sampleMemberNames => 'カナ, フラン';

  @override
  String get eventTypeExpense => '支出';

  @override
  String get eventTypeIncome => '収入';

  @override
  String get eventTypeTransfer => '振替';

  @override
  String get eventTypeSettlement => '精算';

  @override
  String get eventTypeAdjustment => '調整';

  @override
  String get quickAddExpense => 'かんたん支出';

  @override
  String get quickAddMoreOptions => '詳細設定';

  @override
  String get quickAddSaved => '追加しました';

  @override
  String get budgetUsed => '使用';

  @override
  String get subscriptionsOverdue => '期限切れ';

  @override
  String get subscriptionsDueSoon => 'まもなく';

  @override
  String get subscriptionsLater => 'その後';

  @override
  String dueX0(String x0) {
    return '$x0に予定';
  }

  @override
  String get aiVerified => '認証済み';

  @override
  String onboardingStepX0OfX1(int x0, int x1) {
    return 'ステップ $x0 / $x1';
  }

  @override
  String colourOptionX0(int x0) {
    return '色 $x0';
  }

  @override
  String get changeAvatar => 'アバターを変更';

  @override
  String get balanceHidden => '残高は非表示';

  @override
  String get privacyHideBalances => '残高を隠す';

  @override
  String get privacyHideBalancesDetail => 'レイアウトを変えずに金額を伏せます。';

  @override
  String get done => '完了';

  @override
  String get selected => '選択中';

  @override
  String get addANote => 'メモを追加';

  @override
  String get member => 'メンバー';

  @override
  String get cadenceDaily => '毎日';

  @override
  String get cadenceWeekly => '毎週';

  @override
  String get cadenceMonthly => '毎月';

  @override
  String get cadenceYearly => '毎年';

  @override
  String get countryJapan => '日本';

  @override
  String get countryGermany => 'ドイツ';

  @override
  String get countryLuxembourg => 'ルクセンブルク';

  @override
  String get countryTunisia => 'チュニジア';

  @override
  String get countryUnitedKingdom => 'イギリス';

  @override
  String get countryUnitedStates => 'アメリカ';

  @override
  String get balanceImpactTitle => 'この記録で変わること';

  @override
  String balanceImpactWillOwe(String name) {
    return '$nameさんがあなたに借りることになります';
  }

  @override
  String balanceImpactYouWillOwe(String name) {
    return 'あなたが$nameさんに借りることになります';
  }

  @override
  String get balanceImpactNoChange => '二人の貸し借りは変わりません';

  @override
  String balanceImpactWith(String name) {
    return '$nameさんとの残高';
  }

  @override
  String splitBarLabel(String name, int percent, String amount) {
    return '$name、$percent%（$amount）';
  }

  @override
  String get splitBarTitle => '分担の内訳';

  @override
  String get iconGroupMoney => 'お金';

  @override
  String get iconGroupFood => '食事';

  @override
  String get iconGroupHome => '住まい・請求';

  @override
  String get iconGroupTransport => '移動';

  @override
  String get iconGroupTravel => '旅行';

  @override
  String get iconGroupHealth => '健康';

  @override
  String get iconGroupLeisure => '趣味・娯楽';

  @override
  String get iconGroupShopping => '買い物';

  @override
  String get iconGroupWork => '仕事・学び';

  @override
  String get iconGroupPeople => '人';

  @override
  String get iconGroupOther => 'その他';

  @override
  String get chooseAnIcon => 'アイコンを選ぶ';

  @override
  String get searchIcons => 'アイコンを検索';

  @override
  String get searchKindDestination => '移動';

  @override
  String get searchTermsHome => 'ホーム,ダッシュボード,概要,純資産';

  @override
  String get searchTermsAccounts => '口座,ウォレット,銀行,残高,現金';

  @override
  String get searchTermsSpaces => 'スペース,共有,グループ,家計,割り勘,メンバー';

  @override
  String get searchTermsActivity => '履歴,取引,明細,支出';

  @override
  String get searchTermsBudgets => '予算,上限,支出計画';

  @override
  String get searchTermsSubscriptions => 'サブスク,定期,更新,請求';

  @override
  String get searchTermsCategories => 'カテゴリ,タグ,ラベル';

  @override
  String get searchTermsNotifications => '通知,お知らせ,受信箱';

  @override
  String get searchTermsSettings => '設定,環境設定,プロフィール,通貨,テーマ';

  @override
  String get searchTermsAssistant => 'アシスタント,AI,キト,インサイト';

  @override
  String get recordHistory => 'この記録のあゆみ';

  @override
  String get timelineRecorded => '記録';

  @override
  String get timelineEdited => '編集';

  @override
  String timelineEditedDetail(Object p0) {
    return '記録後に$p0回更新されました';
  }

  @override
  String get timelineVoided => '取り消し';

  @override
  String get timelineAwaitingConfirmation => '確定待ち';

  @override
  String get timelineAwaitingDetail => '誰かが確定するまで残高は動きません';

  @override
  String get timelineSettled => '精算済み';

  @override
  String get timelineSettledDetail => '締めたサイクルの一部のため、読み取り専用です';

  @override
  String timelineByX0On(Object p0, Object p1) {
    return '$p0・$p1';
  }

  @override
  String timelineAddedByAssistant(Object p0) {
    return '$p0が追加しました';
  }

  @override
  String get homeInsights => '推移';

  @override
  String get homeInsightsSubtitle => '今月の使い道と、前月との比較';

  @override
  String homeAccountsSummary(Object p0, Object p1) {
    return '$p1件で$p0';
  }

  @override
  String homeUpcomingSummary(Object p0) {
    return '$p0の予定';
  }

  @override
  String get homeUpcomingNone => '予定なし';

  @override
  String homeWhereItWentSummary(Object p0, Object p1) {
    return '$p1に$p0';
  }

  @override
  String get homeNothingSpentYet => 'まだ支出はありません';
}
