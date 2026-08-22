import 'package:shared_preferences/shared_preferences.dart';

import '../domain/pockito_models.dart';

/// A local copy of the user's language and appearance.
///
/// The server is authoritative, but reading these before the first network call
/// is what stops the app opening in the wrong theme and language for as long as
/// `/bootstrap` takes. Nothing sensitive is stored here.
class PreferencesCache {
  static const _themeKey = 'pockito.theme';
  static const _languageKey = 'pockito.language';
  static const _currencyKey = 'pockito.currency';

  Future<Preferences?> read() async {
    final store = await SharedPreferences.getInstance();
    final theme = store.getString(_themeKey);
    if (theme == null) return null;
    return Preferences(
      theme: AppTheme.fromWire(theme),
      language: AppLanguage.fromWire(store.getString(_languageKey)),
      defaultCurrency: store.getString(_currencyKey) ?? 'EUR',
    );
  }

  Future<void> write(Preferences preferences) async {
    final store = await SharedPreferences.getInstance();
    await store.setString(_themeKey, preferences.theme.wire);
    await store.setString(_languageKey, preferences.language.wire);
    await store.setString(_currencyKey, preferences.defaultCurrency);
  }

  Future<void> clear() async {
    final store = await SharedPreferences.getInstance();
    await store.remove(_themeKey);
    await store.remove(_languageKey);
    await store.remove(_currencyKey);
  }
}
