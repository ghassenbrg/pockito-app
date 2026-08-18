import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'app/pockito_app_view_model.dart';
import 'l10n/app_localizations.dart';
import 'data/repositories/mock_pockito_repository.dart';
import 'domain/repositories/pockito_repository.dart';
import 'ui/core/components/pk_components.dart';
import 'ui/core/design_system/pk_theme.dart';
import 'ui/features/widget/views/home_widget_screen.dart';
import 'ui/core/navigation/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // Date symbols for every locale the app offers, so the Home greeting can
  // format its date in the reader's language.
  await initializeDateFormatting();
  runApp(const PockitoBootstrap());
}

class PockitoBootstrap extends StatelessWidget {
  const PockitoBootstrap({super.key, this.repository});

  final PockitoRepository? repository;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) =>
        PockitoAppViewModel(repository: repository ?? MockPockitoRepository()),
    child: const PockitoApp(),
  );
}

class PockitoApp extends StatelessWidget {
  const PockitoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<PockitoAppViewModel, ThemeMode>(
      (viewModel) => viewModel.repository.profile.themeMode,
    );
    final language = context.select<PockitoAppViewModel, String>(
      (viewModel) => viewModel.repository.profile.language,
    );
    // One preference silences every haptic in the app, so the components can
    // ask for feedback without each checking first.
    PkHaptics.enabled = !context.select<PockitoAppViewModel, bool>(
      (viewModel) => viewModel.repository.profile.hapticsOff,
    );
    return MaterialApp.router(
      title: 'Pockito',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: PkTheme.light(),
      darkTheme: PkTheme.dark(),
      themeMode: themeMode,
      themeAnimationDuration: const Duration(milliseconds: 250),
      themeAnimationCurve: Curves.easeOutCubic,
      // The language the user picked drives the whole framework — dates,
      // pickers, Material's own labels — not only Pockito's strings.
      locale: pkLocaleFor(language),
      supportedLocales: PkStrings.supportedLocales,
      localizationsDelegates: PkStrings.localizationsDelegates,
      // Inside the app, so the widget's payload can be built in the reader's
      // language.
      builder: (context, child) => GestureDetector(
        // A tap anywhere that isn't itself a control — a field, a button —
        // closes the keyboard, so it never sits pinned over half the screen
        // once the reader has looked away from what they were typing.
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        // …and it stays out of the accessibility tree. It is a convenience for
        // a pointer, not a control: advertised, it becomes an unlabelled
        // button the size of the whole screen sitting above every route, and a
        // screen reader has no way to know it means nothing.
        excludeFromSemantics: true,
        child: PkPrivacy(
          // One switch masks every balance in the app; each amount does not
          // have to remember to ask.
          hidden: context.select<PockitoAppViewModel, bool>(
            (viewModel) => viewModel.repository.profile.balancesHidden,
          ),
          child: PkHomeWidgetSync(child: child ?? const SizedBox.shrink()),
        ),
      ),
    );
  }
}

/// The locale behind the language name stored on the profile.
///
/// The profile holds a human-readable name because that is what the language
/// picker shows; this is the single place that turns it into a locale.
Locale pkLocaleFor(String language) => switch (language) {
  'Japanese' || '日本語' => const Locale('ja'),
  _ => const Locale('en'),
};
