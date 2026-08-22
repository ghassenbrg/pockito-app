import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show MediaType;

import '../config/pockito_config.dart';
import '../domain/pockito_models.dart';
import 'auth_service.dart';
import 'pockito_exception.dart';

/// The only path from the app to Pockito API.
///
/// Attaches the access token, sets a correlation id so a user-reported failure
/// can be found in the logs, and converts every non-2xx response into a
/// [PockitoException] carrying the backend's stable code. Screens never build
/// requests themselves.
class PockitoApi {
  PockitoApi({required PockitoConfig config, required AuthService auth, http.Client? client})
      : _config = config,
        _auth = auth,
        _client = client ?? http.Client();

  static const _timeout = Duration(seconds: 15);

  final PockitoConfig _config;
  final AuthService _auth;
  final http.Client _client;

  Future<Bootstrap> bootstrap() async =>
      Bootstrap.fromJson(await _json('GET', '/bootstrap'));

  Future<Profile> updateDisplayName(String displayName) async =>
      Profile.fromJson(await _json('PUT', '/me', body: {'displayName': displayName}));

  Future<Preferences> updatePreferences(Preferences preferences) async =>
      Preferences.fromJson(await _json('PUT', '/me/preferences', body: preferences.toJson()));

  Future<Bootstrap> completeOnboarding({
    required String displayName,
    required Preferences preferences,
  }) async =>
      Bootstrap.fromJson(await _json('POST', '/onboarding/complete', body: {
        'displayName': displayName,
        'preferences': preferences.toJson(),
      }));

  Future<void> uploadAvatar({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) async {
    final token = await _requireToken();
    final request = http.MultipartRequest('POST', Uri.parse('${_config.apiBaseUrl}/me/avatar'))
      ..headers['Authorization'] = 'Bearer $token'
      ..headers['X-Correlation-Id'] = _correlationId()
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
        contentType: MediaType.parse(contentType),
      ));

    try {
      final streamed = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      _throwIfFailed(response);
    } on SocketException {
      throw const PockitoException.offline();
    } on http.ClientException {
      throw const PockitoException.offline();
    }
  }

  Future<void> removeAvatar() async => _send('DELETE', '/me/avatar');

  Future<Map<String, dynamic>> _json(String method, String path, {Object? body}) async {
    final response = await _send(method, path, body: body);
    if (response.body.isEmpty) return const {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<http.Response> _send(String method, String path, {Object? body}) async {
    final token = await _requireToken();
    final uri = Uri.parse('${_config.apiBaseUrl}$path');
    final headers = {
      'Authorization': 'Bearer $token',
      'X-Correlation-Id': _correlationId(),
      if (body != null) 'Content-Type': 'application/json',
    };

    try {
      final request = http.Request(method, uri)
        ..headers.addAll(headers)
        ..encoding = utf8;
      if (body != null) request.body = jsonEncode(body);

      final streamed = await _client.send(request).timeout(_timeout);
      final response = await http.Response.fromStream(streamed);
      _throwIfFailed(response);
      return response;
    } on SocketException {
      throw const PockitoException.offline();
    } on http.ClientException {
      throw const PockitoException.offline();
    }
  }

  Future<String> _requireToken() async {
    final token = await _auth.accessToken();
    if (token == null) throw const PockitoException.unauthenticated();
    return token;
  }

  void _throwIfFailed(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    if (response.statusCode == 401) throw const PockitoException.unauthenticated();

    String code = _fallbackCode(response.statusCode);
    String message = 'Request failed';
    String? correlationId = response.headers['x-correlation-id'];
    try {
      final problem = jsonDecode(response.body) as Map<String, dynamic>;
      code = problem['code'] as String? ?? code;
      message = problem['message'] as String? ?? message;
      correlationId = problem['correlationId'] as String? ?? correlationId;
    } catch (_) {
      // A non-JSON body means something in front of the API answered; the
      // status-derived code above is the best we can say.
    }
    throw PockitoException(code, message,
        status: response.statusCode, correlationId: correlationId);
  }

  static String _fallbackCode(int status) => switch (status) {
        403 => 'access.denied',
        404 => 'resource.not_found',
        413 => 'avatar.too_large',
        503 || 504 => 'core.unreachable',
        _ => 'internal.error',
      };

  /// Matches the id the backend echoes in `X-Correlation-Id`.
  static String _correlationId() =>
      'mob-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
}
