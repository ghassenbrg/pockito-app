import 'package:flutter/material.dart';

import '../design_system/pk_assets.dart';
import '../design_system/pk_tokens.dart';
import '../design_system/pk_labels.dart';

enum KitoMessageTone { brand, neutral, success, warning, danger }

/// Kito's size budget, section 4.5 and D-08.
///
/// Kito is a genuine differentiator, and the way to keep him one is to spend
/// him where he earns his place: reassurance, explanation, progress, delight.
/// A mascot that occupies 96 px on every routine list is a tax on the viewport
/// rather than a welcome. Every appearance names which moment it is.
enum KitoSize {
  /// Routine inline helper beside a line of copy. 48–64.
  inline(56),

  /// An insight card on a dashboard. 56–64.
  insight(60),

  /// A full-screen empty or error state. 88–112.
  state(112),

  /// A success or celebration moment. 112–144.
  celebration(144),

  /// The onboarding hero, capped at 35% of usable height by its own layout.
  onboarding(168);

  const KitoSize(this.extent);

  /// The artwork's rendered width and height in logical pixels.
  final double extent;

  /// What section 4.5 allows this moment, used by the acceptance suite.
  ({double min, double max}) get budget => switch (this) {
    KitoSize.inline => (min: 48, max: 64),
    KitoSize.insight => (min: 56, max: 64),
    KitoSize.state => (min: 88, max: 112),
    KitoSize.celebration => (min: 112, max: 144),
    KitoSize.onboarding => (min: 140, max: 180),
  };
}

class KitoImage extends StatelessWidget {
  /// Kito artwork.
  ///
  /// Kito is decorative by default: the copy beside him already says what the
  /// state is, so announcing the picture too would just make the screen reader
  /// read everything twice. Pass [semanticLabel] only where the artwork itself
  /// carries information no text repeats.
  const KitoImage({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
  }) : size = null;

  /// Kito at one of the sizes section 4.5 defines for the moment he is in.
  ///
  /// Prefer this over a raw width: it says *why* the artwork is this big, and
  /// it is what the acceptance suite checks.
  const KitoImage.sized({
    super.key,
    required this.asset,
    required KitoSize this.size,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
  }) : width = null,
       height = null;

  final KitoAsset asset;
  final KitoSize? size;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final extent = size?.extent;
    final image = Image.asset(
      asset.path,
      width: width ?? extent,
      height: height ?? extent,
      // Section 9.8: large mascot artwork is decoded near its rendered size
      // rather than at source resolution, so it does not hold up first paint.
      cacheWidth: extent == null
          ? null
          : (extent * MediaQuery.devicePixelRatioOf(context)).round(),
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.high,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
    return semanticLabel == null ? ExcludeSemantics(child: image) : image;
  }
}

class KitoReveal extends StatefulWidget {
  const KitoReveal({
    super.key,
    required this.child,
    this.offset = const Offset(0, .06),
  });

  final Widget child;
  final Offset offset;

  @override
  State<KitoReveal> createState() => _KitoRevealState();
}

class _KitoRevealState extends State<KitoReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reducedMotion ? Duration.zero : PkMotion.slow;
    return AnimatedSlide(
      duration: duration,
      curve: PkMotion.enter,
      offset: _visible ? Offset.zero : widget.offset,
      child: AnimatedOpacity(
        duration: duration,
        curve: PkMotion.enter,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}

class KitoMessage extends StatelessWidget {
  const KitoMessage({
    super.key,
    required this.title,
    required this.message,
    this.asset = KitoAsset.avatar,
    this.tone = KitoMessageTone.brand,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  /// Null falls back to Kito's own voice in the reader's language.
  final String? title;
  final String message;
  final KitoAsset asset;
  final KitoMessageTone tone;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = _colors(context);
    return Semantics(
      container: true,
      label: '$title. $message',
      child: Container(
        decoration: BoxDecoration(
          color: colors.$1,
          borderRadius: BorderRadius.circular(PkRadius.extraLarge),
          border: Border.all(color: colors.$2),
        ),
        padding: EdgeInsets.all(compact ? PkSpacing.x3 : PkSpacing.x4),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Section 6.14: the message never stacks a large image above its
            // own text. It used to do that below 340 px, which is exactly the
            // width where the copy could least afford it — so the artwork now
            // stays inline and inside the size budget at every width.
            final image = KitoImage.sized(
              asset: asset,
              // 6.14: compact art is the default; `large` is explicit, and
              // even then it stays inside the insight-card allowance.
              size: compact ? KitoSize.inline : KitoSize.insight,
            );
            final copy = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title ?? context.t.kitoNoticed,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: colors.$3),
                ),
                const SizedBox(height: PkSpacing.x1),
                Text(
                  message,
                  style: context.pkText.supporting.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
                if (actionLabel != null) ...[
                  const SizedBox(height: PkSpacing.x2),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      foregroundColor: colors.$3,
                      minimumSize: const Size(PkSize.touch, PkSize.touch),
                    ),
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            );
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                image,
                const SizedBox(width: PkSpacing.x3),
                Expanded(child: copy),
              ],
            );
          },
        ),
      ),
    );
  }

  (Color, Color, Color) _colors(BuildContext context) => switch (tone) {
    KitoMessageTone.brand => (
      Theme.of(context).brightness == Brightness.light
          ? PkPalette.kitoBlue50
          : PkPalette.kitoNavy800,
      Theme.of(context).brightness == Brightness.light
          ? PkPalette.kitoBlue100
          : PkPalette.kitoNavy700,
      Theme.of(context).colorScheme.primary,
    ),
    KitoMessageTone.neutral => (
      context.pk.sunken,
      context.pk.borderSubtle,
      context.pk.textPrimary,
    ),
    KitoMessageTone.success => (
      Theme.of(context).brightness == Brightness.light
          ? PkPalette.emerald50
          : PkPalette.kitoNavy800,
      context.pk.success.withValues(alpha: .28),
      context.pk.success,
    ),
    KitoMessageTone.warning => (
      context.pk.sharedSurface,
      context.pk.sharedBorder,
      context.pk.warning,
    ),
    KitoMessageTone.danger => (
      Theme.of(context).brightness == Brightness.light
          ? PkPalette.rose50
          : PkPalette.kitoNavy800,
      context.pk.danger.withValues(alpha: .28),
      context.pk.danger,
    ),
  };
}

class KitoInsightCard extends StatelessWidget {
  const KitoInsightCard({
    super.key,
    required this.message,
    this.title,
    this.asset = KitoAsset.thinking,
    this.tone = KitoMessageTone.brand,
    this.onTap,
  });

  /// Null falls back to Kito's own voice in the reader's language.
  final String? title;
  final String message;
  final KitoAsset asset;

  /// An insight about a budget that needs attention must not look like a calm
  /// brand note, or the warning stops being credible.
  final KitoMessageTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(PkRadius.extraLarge),
      child: KitoMessage(
        title: title,
        message: message,
        asset: asset,
        tone: tone,
        compact: true,
      ),
    ),
  );
}

class KitoCelebration extends StatelessWidget {
  const KitoCelebration({
    super.key,
    required this.title,
    required this.message,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  /// Null falls back to Kito's own voice in the reader's language.
  final String? title;
  final String message;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) => KitoReveal(
    offset: const Offset(0, .04),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const KitoImage.sized(
          asset: KitoAsset.celebrating,
          size: KitoSize.celebration,
        ),
        const SizedBox(height: PkSpacing.x4),
        Text(
          title ?? context.t.kitoNoticed,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: PkSpacing.x2),
        Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: context.pk.textSecondary),
        ),
        if (primaryLabel != null) ...[
          const SizedBox(height: PkSpacing.x6),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPrimary,
              child: Text(primaryLabel!),
            ),
          ),
        ],
        if (secondaryLabel != null) ...[
          const SizedBox(height: PkSpacing.x2),
          TextButton(onPressed: onSecondary, child: Text(secondaryLabel!)),
        ],
      ],
    ),
  );
}
