import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/pockito_app_state.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/components/pk_feedback.dart';
import '../../core/components/kito_components.dart';
import '../../core/design_system/pk_assets.dart';
import '../../core/design_system/pk_tokens.dart';

/// The unauthenticated entry point.
///
/// Both buttons open Keycloak in a system browser tab. There is deliberately no
/// password field anywhere in this app: credentials are Keycloak's business.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = context.watch<PockitoAppState>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: PkBreakpoints.formMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // KitoSize.onboarding rather than a raw height: the size scale is
                  // part of the design system, and it is what keeps Kito from
                  // creeping up screen by screen.
                  const KitoImage.sized(asset: KitoAsset.welcome, size: KitoSize.onboarding),
                  const SizedBox(height: PkSpacing.x6),
                  Text(
                    l10n.welcomeTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  Text(
                    l10n.welcomeTagline,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: PkSpacing.x8),
                  if (state.failure != null) ...[
                    PkFailureNotice(failure: state.failure!),
                    const SizedBox(height: PkSpacing.x4),
                  ],
                  FilledButton(
                    onPressed: state.busy ? null : () => context.read<PockitoAppState>().signIn(),
                    child: Text(l10n.welcomeLogIn),
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  OutlinedButton(
                    onPressed: state.busy
                        ? null
                        : () => context.read<PockitoAppState>().signIn(register: true),
                    child: Text(l10n.welcomeCreateAccount),
                  ),
                  const SizedBox(height: PkSpacing.x6),
                  Text(
                    l10n.welcomeSecurityNote,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
