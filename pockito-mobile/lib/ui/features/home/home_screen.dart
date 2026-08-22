import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/pockito_app_state.dart';
import '../../../domain/pockito_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/components/pk_profile_avatar.dart';
import '../../core/design_system/pk_tokens.dart';

/// The authenticated home.
///
/// Sparse on purpose. The finance domains land here in later phases; what this
/// screen proves today is that a real session, a real profile and a real avatar
/// all arrive correctly.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = context.watch<PockitoAppState>();
    final profile = state.profile;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? l10n.homeGreetingMorning(profile.displayName)
        : hour < 18
            ? l10n.homeGreetingAfternoon(profile.displayName)
            : l10n.homeGreetingEvening(profile.displayName);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => context.read<PockitoAppState>().retry(),
          child: ListView(
            padding: EdgeInsets.all(context.gutter),
            children: [
              Row(
                children: [
                  PkProfileAvatar(profile: profile, size: 56),
                  const SizedBox(width: PkSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(greeting, style: theme.textTheme.titleLarge),
                        const SizedBox(height: PkSpacing.x1),
                        Text(
                          l10n.homeSubtitle,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.section),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(PkSpacing.x5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.homeNothingTitle, style: theme.textTheme.titleMedium),
                      const SizedBox(height: PkSpacing.x2),
                      Text(
                        l10n.homeNothingBody,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: PkSpacing.x5),
                      Wrap(
                        spacing: PkSpacing.x6,
                        runSpacing: PkSpacing.x4,
                        children: [
                          _Fact(label: l10n.preferencesCurrency, value: state.preferences.defaultCurrency),
                          _Fact(
                            label: l10n.preferencesLanguage,
                            value: state.preferences.language == AppLanguage.ja
                                ? l10n.languageJa
                                : l10n.languageEn,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: PkSpacing.x1),
        Text(value, style: theme.textTheme.titleMedium),
      ],
    );
  }
}
