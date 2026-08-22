import 'package:flutter/material.dart';

import '../../../data/pockito_exception.dart';
import '../../../l10n/app_localizations.dart';
import '../design_system/pk_tokens.dart';

/// Turns a [PockitoException] into a sentence in the user's language.
///
/// The backend's raw message is never shown: only the stable error code is
/// translated, so a change in backend wording can never leak English text into
/// a Japanese screen, and an exception string can never reach a user.
String describeFailure(AppLocalizations l10n, PockitoException failure) {
  return switch (failure.code) {
    'network.unreachable' => l10n.errorOffline,
    'auth.unauthenticated' => l10n.authSessionExpired,
    'access.denied' => l10n.errorAccessDenied,
    'validation.failed' => l10n.errorValidation,
    'profile.display_name.blank' => l10n.errorDisplayNameBlank,
    'profile.display_name.too_long' => l10n.errorDisplayNameTooLong,
    'preferences.currency.unsupported' => l10n.errorCurrencyUnsupported,
    'avatar.too_large' => l10n.errorAvatarTooLarge,
    'avatar.unsupported_type' => l10n.errorAvatarUnsupportedType,
    'avatar.empty' => l10n.errorAvatarEmpty,
    'avatar.not_found' => l10n.errorAvatarNotFound,
    'core.unreachable' => l10n.errorCoreUnreachable,
    'auth.failed' => l10n.errorAuthUnavailable,
    _ => failure.isTransient ? l10n.errorTransient : l10n.errorUnexpected,
  };
}

/// An inline failure with a retry, for a screen that is otherwise usable.
class PkFailureNotice extends StatelessWidget {
  const PkFailureNotice({super.key, required this.failure, this.onRetry});

  final PockitoException failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(PkSpacing.x4),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(PkRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            describeFailure(l10n, failure),
            style: TextStyle(color: colors.onErrorContainer),
          ),
          if (failure.correlationId != null) ...[
            const SizedBox(height: PkSpacing.x1),
            Text(
              l10n.errorReference(failure.correlationId!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colors.onErrorContainer.withValues(alpha: 0.75),
                  ),
            ),
          ],
          if (onRetry != null) ...[
            const SizedBox(height: PkSpacing.x3),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ],
      ),
    );
  }
}

/// Shows a failure without taking over the screen, for an action that failed
/// while the surrounding page is still fine.
void showFailure(BuildContext context, PockitoException failure) {
  final l10n = AppLocalizations.of(context);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(describeFailure(l10n, failure))));
}
