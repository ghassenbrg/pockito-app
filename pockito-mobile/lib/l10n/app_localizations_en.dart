// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Pockito';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonNext => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSave => 'Save';

  @override
  String get commonSaved => 'Saved';

  @override
  String get commonLoading => 'Loading…';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDone => 'Done';

  @override
  String get welcomeTitle => 'Welcome to Pockito';

  @override
  String get welcomeTagline => 'Personal and shared money, kept simple.';

  @override
  String get welcomeLogIn => 'Log in';

  @override
  String get welcomeCreateAccount => 'Create account';

  @override
  String get welcomeSecurityNote =>
      'Pockito opens a secure sign-in page. Your password is never typed into this app.';

  @override
  String get authSigningIn => 'Signing you in…';

  @override
  String get authCancelled => 'Sign-in was cancelled.';

  @override
  String get authSessionExpired =>
      'Your session has ended. Please sign in again.';

  @override
  String get onboardingProfileTitle => 'What should we call you?';

  @override
  String get onboardingProfileBody =>
      'This is the name Pockito greets you with, and the name anyone you share money with will see.';

  @override
  String get onboardingAvatarTitle => 'Add a photo';

  @override
  String get onboardingAvatarBody =>
      'Optional. Without one, Pockito shows your initials.';

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageBody =>
      'You can change this at any time in Settings.';

  @override
  String get onboardingAppearanceTitle => 'Pick an appearance';

  @override
  String get onboardingAppearanceBody => 'System follows your device setting.';

  @override
  String get onboardingCurrencyTitle => 'Set your default currency';

  @override
  String get onboardingCurrencyBody =>
      'Pockito uses this as the starting point for new amounts.';

  @override
  String get onboardingFinish => 'Finish setup';

  @override
  String onboardingStepOf(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profileDisplayNameHint => 'e.g. Kito';

  @override
  String get profileDisplayNameRequired => 'Please enter a name.';

  @override
  String get avatarUpload => 'Upload a photo';

  @override
  String get avatarReplace => 'Change photo';

  @override
  String get avatarRemove => 'Remove photo';

  @override
  String get avatarHint => 'PNG, JPEG or WebP, up to 2 MB.';

  @override
  String get avatarFromCamera => 'Take a photo';

  @override
  String get avatarFromGallery => 'Choose from library';

  @override
  String get preferencesLanguage => 'Language';

  @override
  String get preferencesAppearance => 'Appearance';

  @override
  String get preferencesCurrency => 'Default currency';

  @override
  String get languageEn => 'English';

  @override
  String get languageJa => '日本語';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String homeGreetingMorning(String name) {
    return 'Good morning, $name';
  }

  @override
  String homeGreetingAfternoon(String name) {
    return 'Good afternoon, $name';
  }

  @override
  String homeGreetingEvening(String name) {
    return 'Good evening, $name';
  }

  @override
  String get homeSubtitle => 'Your Pockito account is ready.';

  @override
  String get homeNothingTitle => 'Nothing to track yet';

  @override
  String get homeNothingBody =>
      'Expenses, budgets and shared spaces arrive in the next release. Your profile and settings are saved to your account, so they follow you to every device.';

  @override
  String get navHome => 'Home';

  @override
  String get navSettings => 'Settings';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsProfile => 'Profile';

  @override
  String settingsIdentity(String email) {
    return 'Signed in as $email. Your email and password are managed by the Pockito sign-in service.';
  }

  @override
  String get settingsSession => 'Session';

  @override
  String get settingsSignOut => 'Sign out';

  @override
  String get settingsSignOutConfirm => 'Sign out of Pockito on this device?';

  @override
  String errorReference(String id) {
    return 'Reference: $id';
  }

  @override
  String get errorOffline =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get errorTransient =>
      'Pockito is having trouble right now. Please try again in a moment.';

  @override
  String get errorUnexpected => 'Something went wrong. Please try again.';

  @override
  String get errorAccessDenied => 'You don\'t have permission to do that.';

  @override
  String get errorValidation => 'Please check the details you entered.';

  @override
  String get errorDisplayNameBlank => 'Your display name can\'t be empty.';

  @override
  String get errorDisplayNameTooLong => 'Your display name is too long.';

  @override
  String get errorCurrencyUnsupported => 'That currency isn\'t supported yet.';

  @override
  String get errorAvatarTooLarge =>
      'That image is too large. The limit is 2 MB.';

  @override
  String get errorAvatarUnsupportedType =>
      'Please choose a PNG, JPEG or WebP image.';

  @override
  String get errorAvatarEmpty => 'That file appears to be empty.';

  @override
  String get errorAvatarNotFound => 'There\'s no photo to remove.';

  @override
  String get errorCoreUnreachable =>
      'Pockito is temporarily unavailable. Please try again shortly.';

  @override
  String get errorAuthUnavailable =>
      'The sign-in service can\'t be reached right now.';
}
