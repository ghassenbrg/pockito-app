/// Every environment-specific value the app needs, in one place.
///
/// Supplied at build time with `--dart-define`, so a build is pinned to an
/// environment and no endpoint is ever hard-coded into a screen. The defaults
/// point at the local development stack in `infra/local`.
class PockitoConfig {
  const PockitoConfig({
    required this.apiBaseUrl,
    required this.keycloakIssuer,
    required this.keycloakClientId,
    required this.redirectUri,
  });

  /// Reads the configuration this binary was built with.
  factory PockitoConfig.fromEnvironment() {
    return const PockitoConfig(
      apiBaseUrl: String.fromEnvironment(
        'POCKITO_API_BASE_URL',
        defaultValue: 'http://localhost:8080/api/v1',
      ),
      keycloakIssuer: String.fromEnvironment(
        'POCKITO_KEYCLOAK_ISSUER',
        defaultValue: 'http://localhost:8180/realms/pockito',
      ),
      keycloakClientId: String.fromEnvironment(
        'POCKITO_KEYCLOAK_CLIENT_ID',
        defaultValue: 'pockito-mobile',
      ),
      // Matches the custom scheme registered in the Android manifest and the
      // iOS Info.plist, and the redirect URI allowed on the Keycloak client.
      redirectUri: String.fromEnvironment(
        'POCKITO_REDIRECT_URI',
        defaultValue: 'app.pockito.pockito://oauth2redirect',
      ),
    );
  }

  final String apiBaseUrl;
  final String keycloakIssuer;
  final String keycloakClientId;
  final String redirectUri;

  String get discoveryUrl => '$keycloakIssuer/.well-known/openid-configuration';

  /// The scopes Pockito needs. `offline_access` is what makes a session survive
  /// the app being closed, so it is not optional here.
  static const List<String> scopes = ['openid', 'profile', 'email', 'offline_access'];
}
