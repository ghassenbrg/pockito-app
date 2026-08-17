import 'package:flutter/material.dart';

import 'pk_tokens.dart';

abstract final class PkTheme {
  static ThemeData light() => _theme(Brightness.light, PkSemanticColors.light);
  static ThemeData dark() => _theme(Brightness.dark, PkSemanticColors.dark);

  static ThemeData _theme(Brightness brightness, PkSemanticColors semantic) {
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: PkPalette.kitoBlue600,
        brightness: brightness,
        primary: brightness == Brightness.light
            ? PkPalette.kitoBlue600
            : PkPalette.kitoBlue300,
        secondary: PkPalette.kitoAqua500,
        tertiary: PkPalette.kitoGold400,
        error: brightness == Brightness.light
            ? PkPalette.rose600
            : PkPalette.rose400,
        surface: semantic.surface,
      ),
    );
    // Section 5.1. Every routine tier moves down one step — display 40→32,
    // screen title 28→24, section title 20→18, row title 17→15 — while body
    // and supporting text stay where they were. The inflation was above the
    // body scale, so that is the only place the scale changes.
    final typography = PkTypography(
      moneyHero: _style(32, 38, FontWeight.w800, semantic.textPrimary, -0.6),
      moneyInput: _style(32, 38, FontWeight.w700, semantic.textPrimary, -0.6),
      moneySection: _style(24, 30, FontWeight.w700, semantic.textPrimary, -0.3),
      moneyRow: _style(15, 20, FontWeight.w700, semantic.textPrimary),
      screenTitle: _style(24, 30, FontWeight.w700, semantic.textPrimary, -0.4),
      appBarTitle: _style(18, 24, FontWeight.w700, semantic.textPrimary, -0.2),
      sectionTitle: _style(18, 24, FontWeight.w700, semantic.textPrimary, -0.2),
      rowTitle: _style(15, 20, FontWeight.w600, semantic.textPrimary),
      body: _style(15, 22, FontWeight.w400, semantic.textPrimary),
      bodyStrong: _style(15, 22, FontWeight.w600, semantic.textPrimary),
      supporting: _style(13, 18, FontWeight.w400, semantic.textSecondary),
      label: _style(12, 16, FontWeight.w600, semantic.textSecondary),
      micro: _style(11, 14, FontWeight.w600, semantic.textTertiary, .4),
    );
    // The Material names stay in service — the framework's own widgets read
    // them — but they now resolve to the same semantic scale, so a screen that
    // reaches for `titleLarge` cannot land outside the system.
    final textTheme = base.textTheme.copyWith(
      displayLarge: typography.moneyHero,
      displayMedium: typography.moneySection,
      headlineLarge: typography.screenTitle,
      headlineMedium: _style(
        20,
        26,
        FontWeight.w700,
        semantic.textPrimary,
        -0.2,
      ),
      headlineSmall: typography.sectionTitle,
      titleLarge: typography.sectionTitle,
      titleMedium: typography.rowTitle,
      titleSmall: typography.label,
      bodyLarge: _style(16, 24, FontWeight.w400, semantic.textPrimary),
      bodyMedium: typography.body,
      bodySmall: typography.supporting,
      labelLarge: typography.bodyStrong,
      labelMedium: _style(13, 18, FontWeight.w600, semantic.textPrimary),
      labelSmall: typography.micro,
    );
    return base.copyWith(
      scaffoldBackgroundColor: semantic.page,
      canvasColor: semantic.page,
      textTheme: textTheme,
      extensions: [semantic, typography],
      dividerColor: semantic.borderSubtle,
      splashFactory: InkSparkle.splashFactory,
      focusColor: PkPalette.kitoAqua400.withValues(alpha: .16),
      appBarTheme: AppBarTheme(
        backgroundColor: semantic.page,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: kToolbarHeight,
        // Section 6.2: a pushed screen's title is 18, not the 20 that used to
        // make it compete with the root header it was pushed from.
        titleTextStyle: typography.appBarTitle,
        iconTheme: IconThemeData(color: semantic.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: semantic.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: PkPalette.kitoNavy900.withValues(alpha: .08),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.card),
          side: BorderSide(color: semantic.borderSubtle),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: PkSize.nav,
        backgroundColor: semantic.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: brightness == Brightness.light
            ? PkPalette.kitoBlue50
            : PkPalette.kitoNavy700,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? base.colorScheme.primary
                : semantic.textTertiary,
            size: 22,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelSmall!.copyWith(
            color: states.contains(WidgetState.selected)
                ? base.colorScheme.primary
                : semantic.textTertiary,
            letterSpacing: 0,
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: semantic.surface,
        modalBackgroundColor: semantic.surface,
        modalBarrierColor: Colors.black.withValues(alpha: .35),
        surfaceTintColor: Colors.transparent,
        // Section 6.12: a sheet built with `PkSheetScaffold` carries a full
        // header with Close, which already communicates modality, so the
        // handle is opted into rather than drawn everywhere by default.
        showDragHandle: false,
        dragHandleColor: semantic.borderDefault,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(PkRadius.sheet),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: semantic.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: typography.sectionTitle,
        contentTextStyle: typography.body,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.hero),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semantic.sunken,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: PkSpacing.x4,
          vertical: 14,
        ),
        constraints: const BoxConstraints(minHeight: PkSize.touch),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PkRadius.control),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PkRadius.control),
          borderSide: BorderSide(color: semantic.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PkRadius.control),
          // 2 px at 3:1 is the focus treatment section 7.24 requires on web
          // and desktop; using it everywhere keeps one appearance.
          borderSide: BorderSide(color: base.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PkRadius.control),
          borderSide: BorderSide(color: semantic.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PkRadius.control),
          borderSide: BorderSide(color: semantic.danger, width: 2),
        ),
        labelStyle: textTheme.bodyMedium?.copyWith(
          color: semantic.textSecondary,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(color: semantic.textTertiary),
      ),
      // Section 6.9: 48 is the default height. 52 is reserved for the final
      // action of onboarding, authorization, a destructive confirmation or a
      // long form, and is asked for explicitly through `PkSubmitButton.final`.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(PkSize.touch, PkSize.button),
          padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PkRadius.control),
          ),
          textStyle: typography.bodyStrong,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(PkSize.touch, PkSize.button),
          padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PkRadius.control),
          ),
          side: BorderSide(color: semantic.borderDefault),
          textStyle: typography.bodyStrong,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: brightness == Brightness.light
            ? PkPalette.slate900
            : PkPalette.slate50,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: brightness == Brightness.light
              ? Colors.white
              : PkPalette.slate900,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.large),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: base.colorScheme.primary,
          minimumSize: const Size(PkSize.touch, PkSize.touch),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(PkRadius.control),
          ),
          textStyle: typography.bodyStrong,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: semantic.textPrimary,
          minimumSize: const Size(PkSize.touch, PkSize.touch),
          shape: const CircleBorder(),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PkPalette.kitoGold400,
        foregroundColor: PkPalette.kitoNavy900,
        elevation: 6,
        focusElevation: 8,
        hoverElevation: 8,
        shape: const CircleBorder(),
      ),
      // Section 6.10: the chip's visible height is 34, and the 48 target comes
      // from the transparent tap padding the material density adds around it.
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: semantic.sunken,
        selectedColor: brightness == Brightness.light
            ? PkPalette.kitoBlue50
            : PkPalette.kitoNavy700,
        side: BorderSide(color: semantic.borderSubtle),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.full),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: PkSpacing.x1),
        padding: const EdgeInsets.symmetric(
          horizontal: PkSpacing.x2,
          vertical: 6,
        ),
        labelStyle: typography.label.copyWith(color: semantic.textPrimary),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(
            Size(PkSize.touch, PkSize.button),
          ),
          textStyle: WidgetStatePropertyAll(typography.label),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(PkRadius.control),
            ),
          ),
          side: WidgetStatePropertyAll(
            BorderSide(color: semantic.borderDefault),
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? (brightness == Brightness.light
                      ? PkPalette.kitoBlue50
                      : PkPalette.kitoNavy700)
                : semantic.surface,
          ),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : semantic.textTertiary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? base.colorScheme.primary
              : semantic.borderDefault,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? base.colorScheme.primary
              : Colors.transparent,
        ),
        side: BorderSide(color: semantic.borderDefault, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.small / 2),
        ),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? base.colorScheme.primary
              : semantic.textTertiary,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: base.colorScheme.primary,
        linearTrackColor: semantic.sunken,
        circularTrackColor: semantic.sunken,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: semantic.textSecondary,
        textColor: semantic.textPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.large),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: semantic.raised,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.large),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: brightness == Brightness.light
              ? PkPalette.kitoNavy900
              : PkPalette.kitoCream50,
          borderRadius: BorderRadius.circular(PkRadius.small),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: brightness == Brightness.light
              ? Colors.white
              : PkPalette.kitoNavy900,
        ),
      ),
    );
  }

  static TextStyle _style(
    double size,
    double lineHeight,
    FontWeight weight,
    Color color, [
    double tracking = 0,
  ]) => TextStyle(
    fontFamily: 'Inter',
    fontFamilyFallback: const [
      'SF Pro Display',
      'Hiragino Sans',
      'Noto Sans JP',
      'Segoe UI',
      'Roboto',
    ],
    fontSize: size,
    height: lineHeight / size,
    fontWeight: weight,
    color: color,
    letterSpacing: tracking,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
