import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'app/pockito_app_state.dart';
import 'config/pockito_config.dart';
import 'data/auth_service.dart';
import 'data/pockito_api.dart';
import 'l10n/app_localizations.dart';
import 'domain/pockito_models.dart';
import 'ui/core/components/pk_app_shell.dart';
import 'ui/core/components/pk_feedback.dart';
import 'ui/core/design_system/pk_theme.dart';
import 'ui/features/onboarding/onboarding_screen.dart';
import 'ui/features/welcome/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final config = PockitoConfig.fromEnvironment();
  final auth = AuthService(config: config);
  final api = PockitoApi(config: config, auth: auth);

  runApp(PockitoApp(state: PockitoAppState(auth: auth, api: api)..start()));
}

class PockitoApp extends StatelessWidget {
  const PockitoApp({super.key, required this.state});

  final PockitoAppState state;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<PockitoAppState>(
        builder: (context, state, _) {
          return MaterialApp(
            title: 'Pockito',
            debugShowCheckedModeBanner: false,
            theme: PkTheme.light(),
            darkTheme: PkTheme.dark(),
            themeMode: switch (state.preferences.theme) {
              AppTheme.system => ThemeMode.system,
              AppTheme.light => ThemeMode.light,
              AppTheme.dark => ThemeMode.dark,
            },
            locale: Locale(state.preferences.language.tag),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const PockitoRoot(),
          );
        },
      ),
    );
  }
}

/// Chooses the screen from the app's stage, and nothing else.
///
/// Routing by state rather than by navigation history is what makes "signed
/// out" and "onboarding incomplete" impossible to get around: there is no route
/// to push that skips them.
class PockitoRoot extends StatelessWidget {
  const PockitoRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PockitoAppState>();
    return switch (state.stage) {
      AppStage.starting => const _SplashScreen(),
      AppStage.loggedOut => const WelcomeScreen(),
      AppStage.onboarding => const OnboardingScreen(),
      AppStage.ready => const PkAppShell(),
      AppStage.unavailable => const _UnavailableScreen(),
    };
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// Shown when the user is signed in but their profile could not be fetched.
///
/// Deliberately not a silent fall-through to Home: with no profile, Home would
/// have to invent one.
class _UnavailableScreen extends StatelessWidget {
  const _UnavailableScreen();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<PockitoAppState>();
    final failure = state.failure;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: failure == null
                ? const CircularProgressIndicator()
                : PkFailureNotice(
                    failure: failure,
                    onRetry: () => context.read<PockitoAppState>().retry(),
                  ),
          ),
        ),
      ),
    );
  }
}
