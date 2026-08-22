import 'package:flutter/foundation.dart';

import '../data/auth_service.dart';
import '../data/pockito_api.dart';
import '../data/pockito_exception.dart';
import '../data/preferences_cache.dart';
import '../domain/pockito_models.dart';

/// Where the app is in its lifecycle. The router reads only this.
enum AppStage {
  /// Restoring the session and the cached preferences.
  starting,

  /// No valid session: Welcome.
  loggedOut,

  /// Signed in, but the Pockito profile has not been set up yet.
  onboarding,

  /// Signed in and set up.
  ready,

  /// Signed in, but the profile could not be loaded. Neither Home nor
  /// onboarding would be honest here, so this is its own state.
  unavailable,
}

/// The single source of truth for session, profile and preferences.
///
/// Every screen reads from here and nothing else holds this state, which is
/// what keeps "am I signed in?" and "have I onboarded?" from being answered
/// differently in two places.
class PockitoAppState extends ChangeNotifier {
  PockitoAppState({
    required AuthService auth,
    required PockitoApi api,
    PreferencesCache? cache,
  })  : _auth = auth,
        _api = api,
        _cache = cache ?? PreferencesCache();

  final AuthService _auth;
  final PockitoApi _api;
  final PreferencesCache _cache;

  AppStage _stage = AppStage.starting;
  Bootstrap? _bootstrap;
  Preferences _preferences = const Preferences();
  PockitoException? _failure;
  bool _busy = false;

  AppStage get stage => _stage;
  Profile? get profile => _bootstrap?.profile;
  Preferences get preferences => _preferences;
  List<String> get supportedCurrencies =>
      _bootstrap?.supportedCurrencies ?? const ['EUR', 'USD', 'JPY'];
  PockitoException? get failure => _failure;
  bool get busy => _busy;

  /// Called once at start-up.
  ///
  /// Cached preferences are applied before the session is restored, so the very
  /// first frame is already in the right theme and language.
  Future<void> start() async {
    try {
      final cached = await _cache.read();
      if (cached != null) {
        _preferences = cached;
        notifyListeners();
      }
    } catch (_) {
      // The cache is an optimisation, not a requirement.
    }

    try {
      if (await _auth.restore()) {
        await _loadProfile();
        return;
      }
    } catch (error, stack) {
      // Start-up must always reach a stage the user can act on. Staying in
      // `starting` would leave them looking at a spinner with no way out.
      debugPrint('Pockito: could not restore the session: $error\n$stack');
    }
    _setStage(AppStage.loggedOut);
  }

  Future<bool> signIn({bool register = false}) async {
    _failure = null;
    _setBusy(true);
    try {
      if (!await _auth.signIn(register: register)) return false;
      await _loadProfile();
      return true;
    } on PockitoException catch (e) {
      _failure = e;
      _setStage(AppStage.unavailable);
      return false;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _cache.clear();
    _bootstrap = null;
    _preferences = const Preferences();
    _failure = null;
    _setStage(AppStage.loggedOut);
  }

  /// Fetches the profile and decides where the user belongs.
  Future<void> _loadProfile() async {
    try {
      final bootstrap = await _api.bootstrap();
      _bootstrap = bootstrap;
      await _applyPreferences(bootstrap.preferences);
      _failure = null;
      _setStage(bootstrap.onboardingRequired ? AppStage.onboarding : AppStage.ready);
    } on PockitoException catch (e) {
      if (e.code == 'auth.unauthenticated') {
        // The session died between restoring it and using it.
        await _auth.signOutLocally();
        _setStage(AppStage.loggedOut);
        return;
      }
      _failure = e;
      _setStage(AppStage.unavailable);
    }
  }

  /// Retries after a failure, without forcing the user to sign in again.
  Future<void> retry() async {
    _failure = null;
    _setStage(AppStage.starting);
    await _loadProfile();
  }

  Future<void> _applyPreferences(Preferences preferences) async {
    _preferences = preferences;
    await _cache.write(preferences);
    notifyListeners();
  }

  Future<void> updateDisplayName(String displayName) => _guard(() async {
        final profile = await _api.updateDisplayName(displayName.trim());
        _bootstrap = Bootstrap(
          profile: profile,
          preferences: _preferences,
          onboardingRequired: _bootstrap?.onboardingRequired ?? false,
          supportedCurrencies: supportedCurrencies,
        );
      });

  Future<void> updatePreferences(Preferences next) => _guard(() async {
        // Applied optimistically so the theme and language change under the
        // user's finger, then reconciled with what the server actually saved.
        final previous = _preferences;
        await _applyPreferences(next);
        try {
          await _applyPreferences(await _api.updatePreferences(next));
        } catch (_) {
          await _applyPreferences(previous);
          rethrow;
        }
      });

  Future<void> completeOnboarding({
    required String displayName,
    required Preferences preferences,
  }) =>
      _guard(() async {
        final bootstrap = await _api.completeOnboarding(
          displayName: displayName.trim(),
          preferences: preferences,
        );
        _bootstrap = bootstrap;
        await _applyPreferences(bootstrap.preferences);
        _setStage(AppStage.ready);
      });

  Future<void> uploadAvatar({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) =>
      _guard(() async {
        await _api.uploadAvatar(bytes: bytes, filename: filename, contentType: contentType);
        // The avatar URL is pre-signed per response, so it has to be refetched
        // rather than constructed.
        _bootstrap = await _api.bootstrap();
        notifyListeners();
      });

  Future<void> removeAvatar() => _guard(() async {
        await _api.removeAvatar();
        _bootstrap = await _api.bootstrap();
        notifyListeners();
      });

  /// Runs a user-initiated action, surfacing failures without losing the screen
  /// the user is on. An expired session is the one exception: there is nothing
  /// to retry, so the app returns to Welcome.
  Future<void> _guard(Future<void> Function() action) async {
    _failure = null;
    _setBusy(true);
    try {
      await action();
    } on PockitoException catch (e) {
      _failure = e;
      if (e.code == 'auth.unauthenticated') {
        await _auth.signOutLocally();
        _setStage(AppStage.loggedOut);
      }
      rethrow;
    } finally {
      _setBusy(false);
    }
  }

  void clearFailure() {
    if (_failure == null) return;
    _failure = null;
    notifyListeners();
  }

  void _setStage(AppStage stage) {
    _stage = stage;
    notifyListeners();
  }

  void _setBusy(bool busy) {
    _busy = busy;
    notifyListeners();
  }
}
