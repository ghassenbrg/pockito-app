import 'package:pockito/app/pockito_app_state.dart';
import 'package:pockito/config/pockito_config.dart';
import 'package:pockito/data/auth_service.dart';
import 'package:pockito/data/pockito_api.dart';
import 'package:pockito/data/pockito_exception.dart';
import 'package:pockito/data/preferences_cache.dart';
import 'package:pockito/domain/pockito_models.dart';

const testConfig = PockitoConfig(
  apiBaseUrl: 'http://api.test/api/v1',
  keycloakIssuer: 'http://auth.test/realms/pockito',
  keycloakClientId: 'pockito-mobile',
  redirectUri: 'app.pockito.pockito://oauth2redirect',
);

/// A session that can be scripted, standing in for the browser round-trip.
class FakeAuthService implements AuthService {
  FakeAuthService({this.storedSession = false, this.signInSucceeds = true});

  /// Whether a refresh token from a previous run is present.
  bool storedSession;

  /// False models the user backing out of the browser tab.
  bool signInSucceeds;

  bool signedOutRemotely = false;
  bool signedOutLocally = false;
  bool registerRequested = false;
  int signInCalls = 0;

  @override
  bool get hasSession => storedSession;

  @override
  Future<bool> restore() async => storedSession;

  @override
  Future<bool> signIn({bool register = false}) async {
    signInCalls++;
    registerRequested = register;
    if (!signInSucceeds) return false;
    storedSession = true;
    return true;
  }

  @override
  Future<String?> accessToken() async => storedSession ? 'test-access-token' : null;

  @override
  Future<void> signOut() async {
    signedOutRemotely = true;
    await signOutLocally();
  }

  @override
  Future<void> signOutLocally() async {
    signedOutLocally = true;
    storedSession = false;
  }

  @override
  String? get subject => storedSession ? 'test-subject' : null;
}

/// A backend that can be scripted, so tests describe behaviour rather than HTTP.
class FakeApi implements PockitoApi {
  FakeApi({Bootstrap? bootstrap, this.failure})
      : _bootstrap = bootstrap ?? defaultBootstrap(onboardingRequired: true);

  static Bootstrap defaultBootstrap({required bool onboardingRequired}) => Bootstrap(
        profile: Profile(
          subject: 'test-subject',
          displayName: onboardingRequired ? 'kito' : 'Kito Tester',
          email: 'kito@example.test',
          onboardingCompleted: !onboardingRequired,
        ),
        preferences: const Preferences(),
        onboardingRequired: onboardingRequired,
        supportedCurrencies: const ['EUR', 'USD', 'JPY'],
      );

  Bootstrap _bootstrap;

  /// When set, every call throws it. Models an outage or an expired session.
  PockitoException? failure;

  int bootstrapCalls = 0;
  String? lastDisplayName;
  Preferences? lastPreferences;
  List<int>? lastAvatarBytes;
  bool avatarRemoved = false;

  @override
  Future<Bootstrap> bootstrap() async {
    bootstrapCalls++;
    if (failure != null) throw failure!;
    return _bootstrap;
  }

  @override
  Future<Profile> updateDisplayName(String displayName) async {
    if (failure != null) throw failure!;
    lastDisplayName = displayName;
    final updated = Profile(
      subject: _bootstrap.profile.subject,
      displayName: displayName,
      email: _bootstrap.profile.email,
      avatarUrl: _bootstrap.profile.avatarUrl,
      onboardingCompleted: _bootstrap.profile.onboardingCompleted,
    );
    _bootstrap = Bootstrap(
      profile: updated,
      preferences: _bootstrap.preferences,
      onboardingRequired: _bootstrap.onboardingRequired,
      supportedCurrencies: _bootstrap.supportedCurrencies,
    );
    return updated;
  }

  @override
  Future<Preferences> updatePreferences(Preferences preferences) async {
    if (failure != null) throw failure!;
    lastPreferences = preferences;
    return preferences;
  }

  @override
  Future<Bootstrap> completeOnboarding({
    required String displayName,
    required Preferences preferences,
  }) async {
    if (failure != null) throw failure!;
    lastDisplayName = displayName;
    lastPreferences = preferences;
    _bootstrap = Bootstrap(
      profile: Profile(
        subject: 'test-subject',
        displayName: displayName,
        email: 'kito@example.test',
        onboardingCompleted: true,
      ),
      preferences: preferences,
      onboardingRequired: false,
      supportedCurrencies: _bootstrap.supportedCurrencies,
    );
    return _bootstrap;
  }

  @override
  Future<void> uploadAvatar({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) async {
    if (failure != null) throw failure!;
    lastAvatarBytes = bytes;
    _bootstrap = Bootstrap(
      profile: Profile(
        subject: _bootstrap.profile.subject,
        displayName: _bootstrap.profile.displayName,
        email: _bootstrap.profile.email,
        avatarUrl: 'https://storage.test/avatar.png',
        onboardingCompleted: _bootstrap.profile.onboardingCompleted,
      ),
      preferences: _bootstrap.preferences,
      onboardingRequired: _bootstrap.onboardingRequired,
      supportedCurrencies: _bootstrap.supportedCurrencies,
    );
  }

  @override
  Future<void> removeAvatar() async {
    if (failure != null) throw failure!;
    avatarRemoved = true;
  }
}

/// An in-memory stand-in for the on-device preference cache.
class FakeCache implements PreferencesCache {
  Preferences? stored;

  @override
  Future<Preferences?> read() async => stored;

  @override
  Future<void> write(Preferences preferences) async => stored = preferences;

  @override
  Future<void> clear() async => stored = null;
}

PockitoAppState buildState({
  FakeAuthService? auth,
  FakeApi? api,
  FakeCache? cache,
}) =>
    PockitoAppState(
      auth: auth ?? FakeAuthService(),
      api: api ?? FakeApi(),
      cache: cache ?? FakeCache(),
    );
