/// A failure the user might see, carrying the backend's stable error code.
///
/// The code is what the UI translates; the message is diagnostic only and is
/// never rendered, so a backend exception string cannot reach a user.
class PockitoException implements Exception {
  const PockitoException(this.code, this.message, {this.status = 0, this.correlationId});

  /// The device could not reach Pockito at all.
  const PockitoException.offline()
      : code = 'network.unreachable',
        message = 'Pockito is unreachable',
        status = 0,
        correlationId = null;

  /// The session is gone and the user has to sign in again.
  const PockitoException.unauthenticated()
      : code = 'auth.unauthenticated',
        message = 'Session expired',
        status = 401,
        correlationId = null;

  final String code;
  final String message;
  final int status;
  final String? correlationId;

  /// Whether waiting and retrying is the sensible response.
  bool get isTransient => status == 0 || status == 502 || status == 503 || status == 504;

  @override
  String toString() => 'PockitoException($status, $code)';
}
