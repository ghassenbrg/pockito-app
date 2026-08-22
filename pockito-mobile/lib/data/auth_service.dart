import 'dart:convert';

import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/pockito_config.dart';
import 'pockito_exception.dart';

/// The Pockito session, backed by Keycloak.
///
/// Authorization Code with PKCE in a system browser tab (Custom Tabs on
/// Android, `ASWebAuthenticationSession` on iOS), so credentials are entered on
/// Keycloak's own page and never pass through Pockito. The refresh token is
/// kept in the platform keystore, which is what lets a session survive the app
/// being closed without storing anything sensitive in plain preferences.
class AuthService {
  AuthService({
    required PockitoConfig config,
    FlutterAppAuth? appAuth,
    FlutterSecureStorage? storage,
  })  : _config = config,
        _appAuth = appAuth ?? const FlutterAppAuth(),
        _storage = storage ??
            const FlutterSecureStorage(
              // Keys live in the Android keystore, not in plain SharedPreferences.
              aOptions: AndroidOptions.defaultOptions,
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  static const _refreshTokenKey = 'pockito.refresh_token';

  final PockitoConfig _config;
  final FlutterAppAuth _appAuth;
  final FlutterSecureStorage _storage;

  String? _accessToken;
  DateTime? _accessTokenExpiry;

  bool get hasSession => _accessToken != null;

  /// Signs in, or registers first when [register] is set.
  ///
  /// Returns false when the user backed out of the browser tab — a cancelled
  /// sign-in is a normal outcome, not an error to shout about.
  Future<bool> signIn({bool register = false}) async {
    try {
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          _config.keycloakClientId,
          _config.redirectUri,
          discoveryUrl: _config.discoveryUrl,
          scopes: PockitoConfig.scopes,
          // `prompt=create` is the standard OIDC way to open a registration
          // screen; the flow is otherwise identical to signing in.
          promptValues: register ? const ['create'] : null,
        ),
      );
      await _store(result);
      return true;
    } on FlutterAppAuthUserCancelledException {
      return false;
    } on FlutterAppAuthPlatformException catch (e) {
      throw PockitoException('auth.failed', 'Authorization failed: ${e.code}');
    }
  }

  /// Restores a session from the stored refresh token.
  ///
  /// A refresh token that Keycloak no longer accepts is discarded rather than
  /// retried, so an expired or revoked session lands the user on Welcome
  /// instead of a retry loop.
  Future<bool> restore() async {
    final String? refreshToken;
    try {
      refreshToken = await _storage.read(key: _refreshTokenKey);
    } on PlatformException {
      // The keystore is unavailable — a missing entitlement, a locked device, a
      // corrupt entry. There is no session we can prove, so treat it as signed
      // out rather than failing start-up.
      return false;
    }
    if (refreshToken == null) return false;
    try {
      final result = await _appAuth.token(TokenRequest(
        _config.keycloakClientId,
        _config.redirectUri,
        discoveryUrl: _config.discoveryUrl,
        refreshToken: refreshToken,
        scopes: PockitoConfig.scopes,
      ));
      await _store(result);
      return true;
    } on FlutterAppAuthPlatformException {
      await signOutLocally();
      return false;
    }
  }

  /// A valid access token, refreshing first if the current one has expired.
  Future<String?> accessToken() async {
    final expiry = _accessTokenExpiry;
    if (_accessToken != null && expiry != null && DateTime.now().isBefore(expiry)) {
      return _accessToken;
    }
    return await restore() ? _accessToken : null;
  }

  /// Ends the session with Keycloak, then locally.
  ///
  /// The local session is cleared even if the end-session call fails: the user
  /// asked to be signed out on this device, and a network problem must not
  /// leave them signed in.
  Future<void> signOut() async {
    final refreshToken = await _storage.read(key: _refreshTokenKey);
    try {
      if (refreshToken != null) {
        await _appAuth.endSession(EndSessionRequest(
          discoveryUrl: _config.discoveryUrl,
          postLogoutRedirectUrl: _config.redirectUri,
          idTokenHint: _idToken,
        ));
      }
    } catch (_) {
      // Fall through: the local session still has to go.
    } finally {
      await signOutLocally();
    }
  }

  Future<void> signOutLocally() async {
    _accessToken = null;
    _accessTokenExpiry = null;
    _idToken = null;
    try {
      await _storage.delete(key: _refreshTokenKey);
    } on PlatformException {
      // In-memory state is already cleared; an unreachable keystore must not
      // stop the user signing out.
    }
  }

  String? _idToken;

  Future<void> _store(TokenResponse result) async {
    _accessToken = result.accessToken;
    _idToken = result.idToken;
    // Refresh a minute early so a request never starts with a token that
    // expires mid-flight.
    final expiry = result.accessTokenExpirationDateTime;
    _accessTokenExpiry = expiry?.subtract(const Duration(minutes: 1));
    if (result.refreshToken != null) {
      try {
        await _storage.write(key: _refreshTokenKey, value: result.refreshToken);
      } on PlatformException {
        // The session works for now but will not survive a restart. Better than
        // refusing to sign the user in at all.
      }
    }
  }

  /// The Keycloak subject of the signed-in user, read from the access token.
  /// Used for diagnostics only — the backend derives identity from the token
  /// itself and never trusts a client-supplied subject.
  String? get subject {
    final token = _accessToken;
    if (token == null) return null;
    final parts = token.split('.');
    if (parts.length < 2) return null;
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      return (jsonDecode(payload) as Map<String, dynamic>)['sub'] as String?;
    } catch (_) {
      return null;
    }
  }
}
