import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../design_system/pk_tokens.dart';
import '../design_system/pk_labels.dart';

/// Paths for the brand artwork that is not part of the mascot library.
abstract final class PkBrandAssets {
  static const appIcon = 'assets/brand/app-icon.png';
  static const welcomeHeader = 'assets/brand/welcome-header.png';

  /// The horizontal lockup. The file names describe the surface the artwork is
  /// made for, not the ink: `-dark` sets "Pockito" in white for dark
  /// backgrounds, `-light` sets it in ink for light ones.
  static const logoDark = 'assets/brand/pockito-logo-horizontal-dark.svg';
  static const logoLight = 'assets/brand/pockito-logo-horizontal-light.svg';

  /// The lockup for [brightness], so a screen can never pair the wrong one.
  static String logoFor(Brightness brightness) =>
      brightness == Brightness.dark ? logoDark : logoLight;
}

/// The official Pockito horizontal lockup.
///
/// The variant follows the active theme: the dark-type lockup on light
/// surfaces, the light-type lockup on dark ones, so a screen can never ship the
/// wrong one.
class PkWordmark extends StatelessWidget {
  const PkWordmark({super.key, this.height = 34});

  /// Height of the lockup. The artwork is 415×145, so the width follows.
  final double height;

  /// Intrinsic aspect of the lockup artwork.
  static const double _aspect = 415 / 145;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Pockito', // i18n-exempt: the product name
    excludeSemantics: true,
    // A lockup is a graphic, not body copy: it keeps its proportions instead
    // of growing with the reader's text size, and scales down rather than
    // overflowing when the row it sits in runs out of room.
    child: MediaQuery.withNoTextScaling(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: SvgPicture.asset(
          PkBrandAssets.logoFor(Theme.of(context).brightness),
          height: height,
          width: height * _aspect,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

/// A circular header action.
///
/// Search, the assistant and notifications share one component so their size,
/// touch target, border and spacing cannot drift apart.
class PkIconAction extends StatelessWidget {
  const PkIconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.showBadge = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  /// Overrides the icon colour. The assistant uses it to pick up the brand
  /// accent, which is what distinguishes it from the two neutral actions.
  final Color? color;
  final bool showBadge;

  /// The visible circle. Section B-03 and D-04 decouple this from the touch
  /// target: the chrome is 36, and the transparent padding around it brings the
  /// interactive region up to [PkSize.touch].
  static const double _visible = 36;

  @override
  Widget build(BuildContext context) {
    const inset = (PkSize.touch - _visible) / 2;
    final button = Material(
      color: context.pk.surface,
      shape: CircleBorder(side: BorderSide(color: context.pk.borderSubtle)),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: _visible,
        height: _visible,
        child: Icon(
          icon,
          size: PkSize.icon,
          color: color ?? context.pk.textPrimary,
        ),
      ),
    );
    final target = InkResponse(
      onTap: onPressed,
      radius: PkSize.touch / 2,
      containedInkWell: false,
      child: Padding(
        padding: const EdgeInsets.all(inset),
        child: showBadge
            ? Badge(
                alignment: Alignment.topRight,
                offset: const Offset(-2, 2),
                child: button,
              )
            : button,
      ),
    );
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        excludeSemantics: true,
        child: target,
      ),
    );
  }
}

/// Time-of-day greeting, in the reader's language.
String pkGreeting(DateTime now, PkStrings t) {
  if (now.hour < 12) return t.goodMorning;
  if (now.hour < 18) return t.goodAfternoon;
  return t.goodEvening;
}

/// Long date in the reader's locale, e.g. "Sunday, August 16".
///
/// Falls back to the default locale when the locale's date symbols have not
/// been loaded, which keeps widget tests working without extra setup.
String pkLongDate(DateTime date, String localeName) {
  try {
    return DateFormat.MMMMEEEEd(localeName).format(date);
  } on Exception {
    return DateFormat.MMMMEEEEd().format(date);
  }
}

/// The Home welcome banner: Kito's artwork with the greeting set into the
/// clear space the illustration leaves on its left.
///
/// The artwork is a single light-toned asset used in both themes, so the
/// overlay ink is fixed to the brand navy rather than the theme's text colour —
/// theme-derived text would turn near-white on a pale blue banner in dark mode.
class PkWelcomeBanner extends StatelessWidget {
  const PkWelcomeBanner({
    super.key,
    required this.greeting,
    required this.name,
    required this.date,
  });

  final String greeting;
  final String name;
  final String date;

  /// Intrinsic aspect of `welcome-header.png`.
  static const double _aspect = 2172 / 724;

  /// The artwork leaves a clear pale-blue field between the coin on the far
  /// left and Kito on the right. Text is inset past the coin and stops before
  /// Kito's head.
  static const double _textLeft = .15;
  static const double _textWidth = .44;

  static const _ink = PkPalette.kitoNavy900;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width = constraints.maxWidth;
      return ClipRRect(
        borderRadius: BorderRadius.circular(PkRadius.hero),
        child: ConstrainedBox(
          // The natural aspect is the floor. If the greeting needs more room —
          // a long name, or a large text scale — the banner grows and the
          // artwork covers, keeping Kito anchored on the right.
          constraints: BoxConstraints(minHeight: width / _aspect),
          child: Stack(
            // The text block is shorter than the banner, so it has to be told
            // to sit in the middle: a Stack aligns non-positioned children to
            // the top by default.
            alignment: AlignmentDirectional.centerStart,
            children: [
              // The greeting is inked in navy because the artwork behind it is
              // a pale field. That ink is only safe if the pale field is
              // guaranteed — an image that has not decoded yet, or fails to,
              // would otherwise leave navy text on whatever the page is, which
              // in dark mode is navy. The backdrop is the artwork's own
              // colour, so nothing changes once the image paints over it.
              // pk-exempt: this is not a themed surface. It is the artwork's
              // own pale field, standing in for the image until it paints, and
              // it must stay light in both themes because the ink on it is
              // fixed navy to match the illustration.
              const Positioned.fill(
                child: ColoredBox(color: PkPalette.kitoBlue50),
              ),
              Positioned.fill(
                child: Image.asset(
                  PkBrandAssets.welcomeHeader,
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.centerEnd,
                  filterQuality: FilterQuality.high,
                ),
              ),
              Padding(
                // Heavier bottom padding lifts the block off the small
                // decorative ring and the leaves in the lower left.
                padding: EdgeInsetsDirectional.fromSTEB(
                  width * _textLeft,
                  PkSpacing.x3,
                  0,
                  PkSpacing.x8,
                ),
                child: SizedBox(
                  width: width * _textWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _ink.withValues(alpha: .72),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.pkText.screenTitle.copyWith(color: _ink),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        date,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _ink.withValues(alpha: .62),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
