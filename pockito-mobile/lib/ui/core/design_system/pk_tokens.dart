import 'package:flutter/material.dart';

/// The 4 px spacing grid, with the semantic aliases section 5.2 defines.
///
/// The `x*` names are the raw steps; the named aliases below say *why* a gap
/// exists, which is what stops a screen reaching for `x6` when it only meant
/// "these two controls belong together".
abstract final class PkSpacing {
  static const double x0 = 0;
  static const double hairline = 2;
  static const double x1 = 4;
  static const double x2 = 8;
  static const double x3 = 12;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
  static const double x12 = 48;
  static const double x16 = 64;

  /// Phone gutter.
  static const double screen = 16;

  /// Emergency gutter below 360 px, per section 4.7.
  static const double screenNarrow = 12;

  /// Gap between major sections. Section 5.2 moves this from 24 to 20: at 24
  /// every section announced itself equally, which is what made routine
  /// screens read as a stack of posters rather than one page.
  static const double section = 20;

  /// Gap between a section header and its content.
  static const double headerToContent = 12;

  /// Gap between tightly related controls.
  static const double tight = 8;

  /// Separation between a hero and the content beneath it.
  static const double heroToContent = 24;

  /// Grouping inside a full-screen state.
  static const double stateGroup = 32;

  /// Gap between standalone cards that are not grouped into one surface.
  static const double betweenCards = 10;
}

/// Corner radii, section 5.3.
///
/// The legacy `small`/`medium`/`large`/`extraLarge`/`modal` names are kept
/// because they are spoken across the whole app, but they now carry the
/// audit's values: routine cards are 16, not 24, and only heroes and sheets
/// are allowed past 20.
abstract final class PkRadius {
  /// Badges and tiny containers.
  static const double small = 8;

  /// Buttons, fields, icon tiles.
  static const double control = 12;

  /// Standard cards and grouped surfaces.
  static const double card = 16;

  /// Brand and financial heroes.
  static const double hero = 20;

  /// Modal sheet top corners.
  static const double sheet = 24;

  static const double full = 999;

  // Legacy aliases, mapped onto the semantic scale above.
  static const double medium = control;
  static const double large = card;
  static const double extraLarge = hero;
  static const double modal = sheet;
}

abstract final class PkSize {
  /// Cross-platform interactive floor. Apple asks for 44, Android and Flutter
  /// Material for 48; section 1.7 resolves that to 48 everywhere.
  static const double touch = 48;

  static const double row = 64;
  static const double nav = 68;
  static const double iconSmall = 16;
  static const double icon = 20;
  static const double iconLarge = 24;
  static const double fab = 56;
  static const double compactWidth = 600;
  static const double contentMaxWidth = 760;

  // ---- Row contracts, section 5.5 --------------------------------------
  /// Simple settings/management row.
  static const double rowSimple = 56;

  /// Standard finance row.
  static const double rowStandard = 64;

  /// Finance row carrying a second metadata line or a share.
  static const double rowRich = 72;

  /// Finance row carrying lifecycle status as well.
  static const double rowStatus = 80;

  // ---- Visible control sizes -------------------------------------------
  /// Icon tile in a dense ledger row.
  static const double iconTileDense = 38;

  /// Icon tile on a feature card.
  static const double iconTileFeature = 44;

  /// Avatar in a compact history row.
  static const double avatarCompact = 32;

  /// Avatar in a member row.
  static const double avatarMember = 40;

  /// Avatar on a profile screen.
  static const double avatarProfile = 64;

  /// Default filled/outlined button height.
  static const double button = 48;

  /// Height reserved for the final action of onboarding, authorization,
  /// destructive confirmation, or a long form.
  static const double buttonFinal = 52;

  /// Compact secondary button, inside a [touch]-sized region.
  static const double buttonCompact = 38;

  /// Visible chip height, inside a [touch]-sized region.
  static const double chip = 34;

  /// Visible height of sticky tabs.
  static const double tabs = 44;

  /// Height of the floating navigation container itself, excluding the gap it
  /// keeps from the screen edge and the device safe area.
  static const double navBar = 58;

  /// Diameter of the central add action that rides on the navigation bar.
  static const double navAdd = 56;

  /// Distance the floating navigation keeps from the screen edges. Matches the
  /// screen gutter so the bar sits on the same grid as the cards above it.
  static const double navInset = PkSpacing.screen;

  /// Minimum interactive size mandated for primary navigation targets.
  static const double navTarget = 48;

  /// Breathing room a scrolling page leaves *beyond* whatever it sits above.
  ///
  /// `PkPage` adds this to the bottom inset reported by the Scaffold, so a
  /// shell page clears the floating navigation and a pushed page clears the
  /// gesture indicator, without either carrying a permanent empty band.
  static const double navClearance = PkSpacing.x6;
}

/// Named layout thresholds, section 5.8.
///
/// A max-width container is not responsive design; these are the widths at
/// which Pockito actually changes shape.
abstract final class PkBreakpoints {
  /// Below this the gutter tightens and trailing values may stack.
  static const double compactNarrow = 360;

  /// Phone to small tablet.
  static const double compact = 600;

  /// Small tablet to large tablet; two-pane becomes worthwhile.
  static const double medium = 840;

  /// Bottom navigation becomes a rail.
  static const double navigationRail = 900;

  /// The rail extends and the dashboard may use its widest layout.
  static const double expanded = 1180;

  /// Below this height a phone is effectively landscape: heroes and mascots
  /// compact before any financial text is allowed to shrink.
  static const double shortHeight = 700;

  /// A single form column never exceeds this, however wide the display.
  static const double formMaxWidth = 560;

  /// Body copy stays inside a comfortable measure.
  static const double readingMaxWidth = 640;

  /// A dashboard may spread this far before it starts wasting the display.
  static const double dashboardMaxWidth = 1120;

  /// The list side of a master-detail layout.
  static const double listPaneWidth = 380;
}

/// What the current constraints mean, so a screen asks a question rather than
/// comparing numbers.
extension PkLayoutContext on BuildContext {
  Size get _screen => MediaQuery.sizeOf(this);

  /// True below 360 px, where the emergency gutter applies.
  bool get isNarrow => _screen.width < PkBreakpoints.compactNarrow;

  /// True on a phone-width layout.
  bool get isCompact => _screen.width < PkBreakpoints.compact;

  /// True where a two-pane layout is worthwhile.
  bool get isMedium => _screen.width >= PkBreakpoints.medium;

  /// True where the shell shows a navigation rail instead of a bottom bar.
  bool get isExpanded => _screen.width >= PkBreakpoints.navigationRail;

  /// True where vertical space is the binding constraint — landscape phones
  /// and split-screen. Heroes and mascots compact here.
  bool get isShort => _screen.height < PkBreakpoints.shortHeight;

  /// The gutter this width deserves.
  double get gutter => isNarrow ? PkSpacing.screenNarrow : PkSpacing.screen;
}

abstract final class PkMotion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration standard = Duration(milliseconds: 250);
  static const Duration slow = Duration(milliseconds: 350);
  static const Curve curve = Curves.easeInOutCubic;
  static const Curve enter = Curves.easeOutCubic;
}

abstract final class PkGradients {
  static const brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      PkPalette.kitoBlue700,
      PkPalette.kitoBlue500,
      PkPalette.kitoAqua500,
    ],
    stops: [0, .58, 1],
  );

  /// The financial hero.
  ///
  /// The aqua end used to be #138FAF, on which even pure white measures
  /// 3.77:1 — below the 4.5:1 section 9.5 requires of the supporting text that
  /// sits over exactly that corner. Taking it down to #12798F keeps the
  /// cobalt-to-aqua sweep and makes every word on it legible.
  static const hero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF173FAD), Color(0xFF245DD8), Color(0xFF12798F)],
    stops: [0, .62, 1],
  );

  static const warm = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [PkPalette.kitoCream50, PkPalette.kitoBlue50],
  );
}

/// Elevation, section 5.4.
///
/// A repeated list card carrying blur 20 at y 8 is what made routine screens
/// read as promotional. Raised is now one restrained layer, and the hero keeps
/// only enough lift to separate it from the page.
abstract final class PkShadows {
  /// No shadow at all. Grouped surfaces and flat cards rely on a border.
  static const List<BoxShadow> none = <BoxShadow>[];

  /// Actionable dashboard, approval and insight content.
  static List<BoxShadow> card(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: .06),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];

  /// The one financial hero on a screen.
  static List<BoxShadow> hero(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: .18),
      blurRadius: 18,
      offset: const Offset(0, 7),
    ),
  ];

  /// Lift for surfaces that float above scrolling content, such as the primary
  /// navigation. Two layers keep the edge crisp while the ambient shadow stays
  /// soft enough to read as warm rather than heavy.
  static List<BoxShadow> floating(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: .16),
      blurRadius: 28,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: color.withValues(alpha: .08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];
}

abstract final class PkPalette {
  static const kitoCanvas = Color(0xFFF7F9FD);
  static const kitoCream50 = Color(0xFFFFFBF4);
  static const kitoCream100 = Color(0xFFFFF4E1);
  static const kitoBlue50 = Color(0xFFEDF5FF);
  static const kitoBlue100 = Color(0xFFD9E9FF);
  static const kitoBlue300 = Color(0xFF7EB5FF);
  static const kitoBlue400 = Color(0xFF4A8CFF);
  static const kitoBlue500 = Color(0xFF286CF2);
  static const kitoBlue600 = Color(0xFF1F55D5);
  static const kitoBlue700 = Color(0xFF173FAD);
  static const kitoBlue800 = Color(0xFF123488);
  static const kitoAqua300 = Color(0xFF65E0E7);
  static const kitoAqua400 = Color(0xFF34CDD9);
  static const kitoAqua500 = Color(0xFF17B6C8);
  static const kitoLeaf = Color(0xFF45CED3);
  static const kitoGold300 = Color(0xFFFFD56A);
  static const kitoGold400 = Color(0xFFF9B928);

  /// Gold as *ink*, for the words and glyphs that carry shared-money meaning.
  ///
  /// Deliberately much darker than the fill. At #D88A00 it measured 2.6:1
  /// against the light page — below even the 3:1 section 5.6 asks of a colour
  /// that carries meaning — and a badge sets its label at 11 px, which WCAG
  /// counts as normal text and holds to 4.5:1. This clears that on the page,
  /// on a card and on a sunken surface. The hue is unchanged, so "shared
  /// money is gold" still reads; it is now legible as well.
  static const kitoGold600 = Color(0xFF9A6100);
  static const kitoNavy50 = Color(0xFFF0F5FA);
  static const kitoNavy100 = Color(0xFFDDE7F0);
  static const kitoNavy400 = Color(0xFF6F8498);
  static const kitoNavy500 = Color(0xFF4D657D);
  static const kitoNavy600 = Color(0xFF324B65);
  static const kitoNavy700 = Color(0xFF17314D);
  static const kitoNavy800 = Color(0xFF0D2239);
  static const kitoNavy900 = Color(0xFF071625);

  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);

  static const indigo50 = kitoBlue50;
  static const indigo100 = kitoBlue100;
  static const indigo400 = kitoBlue400;
  static const indigo500 = kitoBlue500;
  static const indigo600 = kitoBlue600;
  static const indigo700 = kitoBlue700;
  static const indigo800 = kitoBlue800;
  static const indigo950 = kitoNavy900;

  static const cyan500 = kitoAqua500;

  /// Aqua as ink. The brand aqua is a *fill*: at 2.45:1 on white it cannot
  /// carry a word. This is the same hue taken down to a legible value.
  static const kitoAqua700 = Color(0xFF0E7C88);
  static const amber50 = kitoCream50;
  static const amber200 = Color(0xFFFBE4A6);
  static const amber300 = kitoGold300;
  static const amber400 = kitoGold400;
  static const amber700 = kitoGold600;
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald400 = Color(0xFF34D399);
  static const emerald700 = Color(0xFF047857);
  static const rose50 = Color(0xFFFFF1F2);
  static const rose400 = Color(0xFFFB7185);

  /// Rose as ink. #E11D48 measured 4.46:1 on the page — a hair under the
  /// 4.5:1 an 11 px badge label needs.
  static const rose600 = Color(0xFFD01640);

  static const category = <Color>[
    Color(0xFF10B981),
    kitoBlue600,
    kitoAqua500,
    kitoGold400,
    Color(0xFFF43F5E),
    Color(0xFF8B5CF6),
    Color(0xFFF59E0B),
    Color(0xFF0EA5E9),
    Color(0xFFEC4899),
    Color(0xFF64748B),
    Color(0xFF14B8A6),
    Color(0xFFA855F7),
  ];

  static Color categoryAt(int index) =>
      category[(index - 1).clamp(0, category.length - 1)];
}

@immutable
class PkSemanticColors extends ThemeExtension<PkSemanticColors> {
  const PkSemanticColors({
    required this.page,
    required this.surface,
    required this.raised,
    required this.sunken,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.borderSubtle,
    required this.borderDefault,
    required this.shared,
    required this.sharedStrong,
    required this.sharedSurface,
    required this.sharedBorder,
    required this.owed,
    required this.owing,
    required this.success,
    required this.danger,
    required this.warning,
    required this.ai,
  });

  final Color page;
  final Color surface;
  final Color raised;
  final Color sunken;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color borderSubtle;
  final Color borderDefault;
  final Color shared;
  final Color sharedStrong;
  final Color sharedSurface;
  final Color sharedBorder;
  final Color owed;
  final Color owing;
  final Color success;
  final Color danger;
  final Color warning;

  /// Ink for anything an assistant did or is asking to do.
  final Color ai;

  static const light = PkSemanticColors(
    page: PkPalette.kitoCanvas,
    surface: Colors.white,
    raised: Colors.white,
    sunken: PkPalette.kitoNavy50,
    textPrimary: PkPalette.kitoNavy900,
    textSecondary: PkPalette.kitoNavy600,
    textTertiary: PkPalette.kitoNavy500,
    borderSubtle: PkPalette.kitoNavy100,
    borderDefault: Color(0xFFCBD8E5),
    shared: PkPalette.amber400,
    sharedStrong: PkPalette.amber700,
    sharedSurface: PkPalette.amber50,
    sharedBorder: PkPalette.amber200,
    owed: PkPalette.emerald700,
    owing: PkPalette.amber700,
    success: PkPalette.emerald700,
    danger: PkPalette.rose600,
    warning: PkPalette.amber700,
    ai: PkPalette.kitoAqua700,
  );

  static const dark = PkSemanticColors(
    page: PkPalette.kitoNavy900,
    surface: PkPalette.kitoNavy800,
    raised: PkPalette.kitoNavy700,
    sunken: Color(0xFF091B2E),
    textPrimary: PkPalette.slate50,
    textSecondary: PkPalette.slate400,
    textTertiary: PkPalette.slate400,
    borderSubtle: Color(0xFF1E3954),
    borderDefault: Color(0xFF31506D),
    shared: PkPalette.amber400,
    sharedStrong: PkPalette.amber300,
    sharedSurface: Color(0xFF362A12),
    sharedBorder: Color(0xFF755313),
    owed: PkPalette.emerald400,
    owing: PkPalette.amber300,
    success: PkPalette.emerald400,
    danger: PkPalette.rose400,
    warning: PkPalette.amber300,
    ai: PkPalette.kitoAqua300,
  );

  @override
  PkSemanticColors copyWith({
    Color? page,
    Color? surface,
    Color? raised,
    Color? sunken,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? borderSubtle,
    Color? borderDefault,
    Color? shared,
    Color? sharedStrong,
    Color? sharedSurface,
    Color? sharedBorder,
    Color? owed,
    Color? owing,
    Color? success,
    Color? danger,
    Color? warning,
    Color? ai,
  }) => PkSemanticColors(
    page: page ?? this.page,
    surface: surface ?? this.surface,
    raised: raised ?? this.raised,
    sunken: sunken ?? this.sunken,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textTertiary: textTertiary ?? this.textTertiary,
    borderSubtle: borderSubtle ?? this.borderSubtle,
    borderDefault: borderDefault ?? this.borderDefault,
    shared: shared ?? this.shared,
    sharedStrong: sharedStrong ?? this.sharedStrong,
    sharedSurface: sharedSurface ?? this.sharedSurface,
    sharedBorder: sharedBorder ?? this.sharedBorder,
    owed: owed ?? this.owed,
    owing: owing ?? this.owing,
    success: success ?? this.success,
    danger: danger ?? this.danger,
    warning: warning ?? this.warning,
    ai: ai ?? this.ai,
  );

  @override
  PkSemanticColors lerp(PkSemanticColors? other, double t) {
    if (other == null) return this;
    return PkSemanticColors(
      page: Color.lerp(page, other.page, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      raised: Color.lerp(raised, other.raised, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      shared: Color.lerp(shared, other.shared, t)!,
      sharedStrong: Color.lerp(sharedStrong, other.sharedStrong, t)!,
      sharedSurface: Color.lerp(sharedSurface, other.sharedSurface, t)!,
      sharedBorder: Color.lerp(sharedBorder, other.sharedBorder, t)!,
      owed: Color.lerp(owed, other.owed, t)!,
      owing: Color.lerp(owing, other.owing, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      ai: Color.lerp(ai, other.ai, t)!,
    );
  }
}

/// Pockito's semantic type scale, section 5.1.
///
/// Feature code asks for the *role* — "this is a row title", "this is the one
/// hero amount" — instead of picking a Material name whose size happens to
/// look right. That is what keeps the hierarchy from inflating again the next
/// time a screen is added.
@immutable
class PkTypography extends ThemeExtension<PkTypography> {
  const PkTypography({
    required this.moneyHero,
    required this.moneyInput,
    required this.moneySection,
    required this.moneyRow,
    required this.screenTitle,
    required this.appBarTitle,
    required this.sectionTitle,
    required this.rowTitle,
    required this.body,
    required this.bodyStrong,
    required this.supporting,
    required this.label,
    required this.micro,
  });

  /// Net worth, account or space primary balance. 32/38.
  final TextStyle moneyHero;

  /// Amount entry. 32/38.
  final TextStyle moneyInput;

  /// Secondary summary total. 24/30.
  final TextStyle moneySection;

  /// Trailing amount on a transaction or account row. 15/20.
  final TextStyle moneyRow;

  /// Root screen title. 24/30.
  final TextStyle screenTitle;

  /// Pushed screen title. 18/24.
  final TextStyle appBarTitle;

  /// Section heading. 18/24.
  final TextStyle sectionTitle;

  /// Merchant, account, member, setting. 15/20.
  final TextStyle rowTitle;

  /// Primary explanatory copy. 15/22.
  final TextStyle body;

  /// Emphasised body or action copy. 15/22.
  final TextStyle bodyStrong;

  /// Account, category, date, context. 13/18.
  final TextStyle supporting;

  /// Chips, field labels, group labels. 12/16.
  final TextStyle label;

  /// Badges only. Never essential prose, a balance, an error, or a
  /// destructive consequence. 11/14.
  final TextStyle micro;

  @override
  PkTypography copyWith({
    TextStyle? moneyHero,
    TextStyle? moneyInput,
    TextStyle? moneySection,
    TextStyle? moneyRow,
    TextStyle? screenTitle,
    TextStyle? appBarTitle,
    TextStyle? sectionTitle,
    TextStyle? rowTitle,
    TextStyle? body,
    TextStyle? bodyStrong,
    TextStyle? supporting,
    TextStyle? label,
    TextStyle? micro,
  }) => PkTypography(
    moneyHero: moneyHero ?? this.moneyHero,
    moneyInput: moneyInput ?? this.moneyInput,
    moneySection: moneySection ?? this.moneySection,
    moneyRow: moneyRow ?? this.moneyRow,
    screenTitle: screenTitle ?? this.screenTitle,
    appBarTitle: appBarTitle ?? this.appBarTitle,
    sectionTitle: sectionTitle ?? this.sectionTitle,
    rowTitle: rowTitle ?? this.rowTitle,
    body: body ?? this.body,
    bodyStrong: bodyStrong ?? this.bodyStrong,
    supporting: supporting ?? this.supporting,
    label: label ?? this.label,
    micro: micro ?? this.micro,
  );

  @override
  PkTypography lerp(PkTypography? other, double t) {
    if (other == null) return this;
    return PkTypography(
      moneyHero: TextStyle.lerp(moneyHero, other.moneyHero, t)!,
      moneyInput: TextStyle.lerp(moneyInput, other.moneyInput, t)!,
      moneySection: TextStyle.lerp(moneySection, other.moneySection, t)!,
      moneyRow: TextStyle.lerp(moneyRow, other.moneyRow, t)!,
      screenTitle: TextStyle.lerp(screenTitle, other.screenTitle, t)!,
      appBarTitle: TextStyle.lerp(appBarTitle, other.appBarTitle, t)!,
      sectionTitle: TextStyle.lerp(sectionTitle, other.sectionTitle, t)!,
      rowTitle: TextStyle.lerp(rowTitle, other.rowTitle, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      bodyStrong: TextStyle.lerp(bodyStrong, other.bodyStrong, t)!,
      supporting: TextStyle.lerp(supporting, other.supporting, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
      micro: TextStyle.lerp(micro, other.micro, t)!,
    );
  }
}

extension PkThemeContext on BuildContext {
  PkSemanticColors get pk => Theme.of(this).extension<PkSemanticColors>()!;

  /// Pockito's semantic type scale. Prefer this over `textTheme` in feature
  /// code: it names the role rather than a Material size.
  PkTypography get pkText => Theme.of(this).extension<PkTypography>()!;
}

/// Whether the prototype's own scaffolding may appear at all.
///
/// Definition of done, item 15: no temporary prototype or debug surface is
/// exposed in a release build. Gating on a compile-time constant rather than a
/// stored preference means the rows do not exist to be found — a switch the
/// user could turn on is still an exposed surface.
const bool kPkDebugSurfaces = !bool.fromEnvironment('dart.vm.product');
