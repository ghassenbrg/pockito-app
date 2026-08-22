/// The client-side mirror of `shared/pockito-contracts`. The backend owns these
/// shapes; this file follows it.
library;

enum AppTheme {
  system('SYSTEM'),
  light('LIGHT'),
  dark('DARK');

  const AppTheme(this.wire);

  final String wire;

  static AppTheme fromWire(String? value) =>
      AppTheme.values.firstWhere((t) => t.wire == value, orElse: () => AppTheme.system);
}

enum AppLanguage {
  en('EN', 'en'),
  ja('JA', 'ja');

  const AppLanguage(this.wire, this.tag);

  final String wire;
  final String tag;

  static AppLanguage fromWire(String? value) =>
      AppLanguage.values.firstWhere((l) => l.wire == value, orElse: () => AppLanguage.en);

  static AppLanguage fromTag(String? tag) {
    final primary = (tag ?? 'en').split(RegExp('[-_]')).first.toLowerCase();
    return AppLanguage.values.firstWhere((l) => l.tag == primary, orElse: () => AppLanguage.en);
  }
}

class Profile {
  const Profile({
    required this.subject,
    required this.displayName,
    this.email,
    this.avatarUrl,
    this.onboardingCompleted = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        subject: json['subject'] as String,
        displayName: json['displayName'] as String,
        email: json['email'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
        onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      );

  final String subject;
  final String displayName;
  final String? email;
  final String? avatarUrl;
  final bool onboardingCompleted;

  /// One or two letters for the avatar fallback.
  String get initials {
    final parts = displayName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      final single = parts.first;
      return (single.length == 1 ? single : single.substring(0, 2)).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class Preferences {
  const Preferences({
    this.language = AppLanguage.en,
    this.theme = AppTheme.system,
    this.defaultCurrency = 'EUR',
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        language: AppLanguage.fromWire(json['language'] as String?),
        theme: AppTheme.fromWire(json['theme'] as String?),
        defaultCurrency: json['defaultCurrency'] as String? ?? 'EUR',
      );

  final AppLanguage language;
  final AppTheme theme;
  final String defaultCurrency;

  Map<String, dynamic> toJson() => {
        'language': language.wire,
        'theme': theme.wire,
        'defaultCurrency': defaultCurrency,
      };

  Preferences copyWith({AppLanguage? language, AppTheme? theme, String? defaultCurrency}) =>
      Preferences(
        language: language ?? this.language,
        theme: theme ?? this.theme,
        defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      );
}

class Bootstrap {
  const Bootstrap({
    required this.profile,
    required this.preferences,
    required this.onboardingRequired,
    this.supportedCurrencies = const ['EUR', 'USD', 'JPY'],
  });

  factory Bootstrap.fromJson(Map<String, dynamic> json) => Bootstrap(
        profile: Profile.fromJson(json['profile'] as Map<String, dynamic>),
        preferences: Preferences.fromJson(json['preferences'] as Map<String, dynamic>),
        onboardingRequired: json['onboardingRequired'] as bool? ?? false,
        supportedCurrencies:
            (json['supportedCurrencies'] as List<dynamic>?)?.cast<String>() ??
                const ['EUR', 'USD', 'JPY'],
      );

  final Profile profile;
  final Preferences preferences;
  final bool onboardingRequired;
  final List<String> supportedCurrencies;
}
