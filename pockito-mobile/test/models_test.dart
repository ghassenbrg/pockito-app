import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/domain/pockito_models.dart';

void main() {
  group('initials', () {
    Profile named(String name) => Profile(subject: 's', displayName: name);

    test('uses the first letter of the first and last words', () {
      expect(named('Kito Tester').initials, 'KT');
      expect(named('Ada Byron Lovelace').initials, 'AL');
    });

    test('takes two letters from a single word', () {
      expect(named('Kito').initials, 'KI');
    });

    test('handles a one-character name', () {
      expect(named('K').initials, 'K');
    });

    test('copes with stray whitespace rather than rendering a blank circle', () {
      expect(named('  Kito   Tester  ').initials, 'KT');
      expect(named('   ').initials, '?');
    });
  });

  group('wire formats', () {
    test('map the backend enums both ways', () {
      expect(AppTheme.fromWire('DARK'), AppTheme.dark);
      expect(AppLanguage.fromWire('JA'), AppLanguage.ja);
      expect(const Preferences(theme: AppTheme.light).toJson()['theme'], 'LIGHT');
    });

    test('fall back to safe defaults for anything unrecognised', () {
      // A backend that adds a theme must not crash an older client.
      expect(AppTheme.fromWire('NEON'), AppTheme.system);
      expect(AppLanguage.fromWire(null), AppLanguage.en);
      expect(AppLanguage.fromTag('ja-JP'), AppLanguage.ja);
      expect(AppLanguage.fromTag('fr-FR'), AppLanguage.en);
    });

    test('parse a bootstrap response', () {
      final bootstrap = Bootstrap.fromJson({
        'profile': {
          'subject': 'sub-1',
          'displayName': 'Kito',
          'email': 'kito@example.test',
          'avatarUrl': null,
          'onboardingCompleted': false,
        },
        'preferences': {'language': 'JA', 'theme': 'DARK', 'defaultCurrency': 'JPY'},
        'onboardingRequired': true,
        'supportedCurrencies': ['EUR', 'JPY'],
      });

      expect(bootstrap.onboardingRequired, isTrue);
      expect(bootstrap.preferences.language, AppLanguage.ja);
      expect(bootstrap.supportedCurrencies, ['EUR', 'JPY']);
    });
  });
}
