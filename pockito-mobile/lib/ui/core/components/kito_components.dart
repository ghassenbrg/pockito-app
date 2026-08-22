/// Kito, Pockito's mascot.
///
/// Migrated from the prototype with the size discipline intact — the rules
/// about where Kito is allowed to appear and how large are what keep him a
/// character rather than clip art. The message, celebration and insight
/// variants stayed behind: they exist to narrate finance events, and there are
/// no finance events yet.
library;

import 'package:flutter/material.dart';

import '../design_system/pk_assets.dart';
import '../design_system/pk_tokens.dart';


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
