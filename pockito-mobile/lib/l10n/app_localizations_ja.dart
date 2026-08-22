// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'Pockito';

  @override
  String get commonRetry => '再試行';

  @override
  String get commonNext => '次へ';

  @override
  String get commonBack => '戻る';

  @override
  String get commonSave => '保存';

  @override
  String get commonSaved => '保存しました';

  @override
  String get commonLoading => '読み込み中…';

  @override
  String get commonCancel => 'キャンセル';

  @override
  String get commonDone => '完了';

  @override
  String get welcomeTitle => 'Pockito へようこそ';

  @override
  String get welcomeTagline => '個人のお金も、みんなのお金も、シンプルに。';

  @override
  String get welcomeLogIn => 'ログイン';

  @override
  String get welcomeCreateAccount => 'アカウント作成';

  @override
  String get welcomeSecurityNote =>
      'Pockito は安全なログインページを開きます。パスワードをこのアプリに入力することはありません。';

  @override
  String get authSigningIn => 'ログインしています…';

  @override
  String get authCancelled => 'ログインをキャンセルしました。';

  @override
  String get authSessionExpired => 'セッションが終了しました。もう一度ログインしてください。';

  @override
  String get onboardingProfileTitle => 'お名前を教えてください';

  @override
  String get onboardingProfileBody =>
      'Pockito があなたに呼びかけるとき、また共有相手に表示されるときに使う名前です。';

  @override
  String get onboardingAvatarTitle => '写真を追加';

  @override
  String get onboardingAvatarBody => '任意です。設定しない場合はイニシャルが表示されます。';

  @override
  String get onboardingLanguageTitle => '言語を選択';

  @override
  String get onboardingLanguageBody => '設定画面でいつでも変更できます。';

  @override
  String get onboardingAppearanceTitle => '外観を選択';

  @override
  String get onboardingAppearanceBody => '「システム」は端末の設定に従います。';

  @override
  String get onboardingCurrencyTitle => '既定の通貨を設定';

  @override
  String get onboardingCurrencyBody => '新しい金額を入力するときの初期値になります。';

  @override
  String get onboardingFinish => '設定を完了';

  @override
  String onboardingStepOf(int current, int total) {
    return 'ステップ $current / $total';
  }

  @override
  String get profileDisplayName => '表示名';

  @override
  String get profileDisplayNameHint => '例: キト';

  @override
  String get profileDisplayNameRequired => '名前を入力してください。';

  @override
  String get avatarUpload => '写真をアップロード';

  @override
  String get avatarReplace => '写真を変更';

  @override
  String get avatarRemove => '写真を削除';

  @override
  String get avatarHint => 'PNG・JPEG・WebP、2 MB まで。';

  @override
  String get avatarFromCamera => '写真を撮る';

  @override
  String get avatarFromGallery => 'ライブラリから選択';

  @override
  String get preferencesLanguage => '言語';

  @override
  String get preferencesAppearance => '外観';

  @override
  String get preferencesCurrency => '既定の通貨';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  @override
  String get themeSystem => 'システム';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String homeGreetingMorning(String name) {
    return 'おはようございます、$nameさん';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'こんにちは、$nameさん';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'こんばんは、$nameさん';
  }

  @override
  String get homeSubtitle => 'Pockito アカウントの準備ができました。';

  @override
  String get homeNothingTitle => 'まだ記録はありません';

  @override
  String get homeNothingBody =>
      '支出・予算・共有スペースは次のリリースで追加されます。プロフィールと設定はアカウントに保存されるので、どの端末でも引き継がれます。';

  @override
  String get navHome => 'ホーム';

  @override
  String get navSettings => '設定';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsProfile => 'プロフィール';

  @override
  String settingsIdentity(String email) {
    return '$email でログイン中。メールアドレスとパスワードは Pockito のログインサービスが管理します。';
  }

  @override
  String get settingsSession => 'セッション';

  @override
  String get settingsSignOut => 'ログアウト';

  @override
  String get settingsSignOutConfirm => 'この端末で Pockito からログアウトしますか？';

  @override
  String errorReference(String id) {
    return '参照番号: $id';
  }

  @override
  String get errorOffline => 'オフラインのようです。通信環境をご確認ください。';

  @override
  String get errorTransient => '現在 Pockito に問題が発生しています。少し時間をおいてお試しください。';

  @override
  String get errorUnexpected => '問題が発生しました。もう一度お試しください。';

  @override
  String get errorAccessDenied => 'この操作を行う権限がありません。';

  @override
  String get errorValidation => '入力内容をご確認ください。';

  @override
  String get errorDisplayNameBlank => '表示名を入力してください。';

  @override
  String get errorDisplayNameTooLong => '表示名が長すぎます。';

  @override
  String get errorCurrencyUnsupported => 'その通貨はまだ対応していません。';

  @override
  String get errorAvatarTooLarge => '画像のサイズが大きすぎます。上限は 2 MB です。';

  @override
  String get errorAvatarUnsupportedType => 'PNG・JPEG・WebP の画像を選択してください。';

  @override
  String get errorAvatarEmpty => 'ファイルが空のようです。';

  @override
  String get errorAvatarNotFound => '削除できる写真がありません。';

  @override
  String get errorCoreUnreachable => 'Pockito は一時的にご利用いただけません。しばらくしてからお試しください。';

  @override
  String get errorAuthUnavailable => 'ログインサービスに接続できません。';
}
