/// The domain-neutral part of the Pockito component set.
///
/// Migrated from the prototype's component library, minus everything that
/// described money: amounts, balances, accounts, transactions, budgets and
/// shared spaces stayed behind, because the domain behind them does not exist
/// yet and a widget with nothing real to render is just a fake screen waiting
/// to happen.
library;

import 'package:flutter/material.dart';

import '../design_system/pk_tokens.dart';


/// How wide a page's content column may grow, section 6.1.
///
/// A single 760 px column is too wide for body copy and far too wide for form
/// fields; centring a stretched phone layout is not responsive design.
enum PkPageWidth {
  /// Lists and mixed content. 640.
  reading(PkBreakpoints.readingMaxWidth),

  /// Any screen that is mostly fields. 560.
  form(PkBreakpoints.formMaxWidth),

  /// A dashboard that reflows into columns rather than stretching. 1120.
  dashboard(PkBreakpoints.dashboardMaxWidth);

  const PkPageWidth(this.maxWidth);

  final double maxWidth;
}

class PkPage extends StatelessWidget {
  const PkPage({
    super.key,
    required this.slivers,
    this.refresh,
    this.bottomPadding,
    this.width = PkPageWidth.reading,
  });

  final List<Widget> slivers;

  /// Only where refreshing has a real production meaning.
  final Future<void> Function()? refresh;

  /// Overrides the trailing space. Leave it unset: the default reserves
  /// exactly what this page sits above.
  final double? bottomPadding;

  final PkPageWidth width;

  @override
  Widget build(BuildContext context) {
    // Content scrolls behind the floating navigation, so the last row has to
    // be able to clear it. With `extendBody`, Scaffold reports the bar's full
    // height — including its safe-area inset — as the body's bottom padding,
    // so this is the exact clearance on shell pages and just the device inset
    // on pushed ones.
    final clearance =
        bottomPadding ??
        MediaQuery.paddingOf(context).bottom + PkSize.navClearance;
    final view = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      slivers: [
        ...slivers,
        SliverToBoxAdapter(child: SizedBox(height: clearance)),
      ],
    );
    return SafeArea(
      bottom: false,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: width.maxWidth),
          child: refresh == null
              ? view
              : RefreshIndicator(onRefresh: refresh!, child: view),
        ),
      ),
    );
  }
}

/// The header of a root screen, section 6.2.
///
/// 24 px title with an optional 13 px subtitle and a 12 px gap below. It used
/// to be 28 while `PkAppBar` was 20, which is what made a root screen and a
/// pushed screen feel like two different products.
class PkScreenHeader extends StatelessWidget {
  const PkScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.onBack,
    this.actions = const [],
  });

  final String title;

  /// Omit this when it only restates a count already visible below.
  final String? subtitle;
  final Widget? leading;

  /// Explicit back behaviour for a screen that is always reached from
  /// somewhere, even when the navigator has nothing to pop — a deep link, for
  /// example. Without it the header falls back to popping when it can.
  final VoidCallback? onBack;

  /// At most two. Section 6.2 sends anything further to an overflow menu.
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    assert(
      actions.length <= 2,
      'A screen header shows at most two trailing actions; move the rest to '
      'an overflow menu (section 6.2).',
    );
    // Sliver-based screens have no AppBar, so a pushed one has to carry its own
    // back control. Branch roots cannot pop and correctly get none.
    final showBack =
        leading == null &&
        (onBack != null || (ModalRoute.of(context)?.canPop ?? false));
    return SliverPadding(
      padding: EdgeInsetsDirectional.fromSTEB(
        showBack ? PkSpacing.x2 : context.gutter,
        PkSpacing.x3,
        context.gutter,
        PkSpacing.headerToContent,
      ),
      sliver: SliverToBoxAdapter(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBack)
              IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            if (leading != null) ...[
              leading!,
              const SizedBox(width: PkSpacing.x3),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.pkText.screenTitle,
                    // Two lines only where localization needs them.
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.pkText.supporting,
                    ),
                ],
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
  }
}

class PkSkeleton extends StatefulWidget {
  const PkSkeleton({
    super.key,
    this.height = 64,
    this.width,
    this.radius = PkRadius.card,
  });
  final double height;

  /// Null stretches to the available width, which is what a full-width block
  /// placeholder wants. A row-shaped placeholder gives its own.
  final double? width;
  final double radius;

  @override
  State<PkSkeleton> createState() => _PkSkeletonState();
}

class _PkSkeletonState extends State<PkSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Section 9.5: reduced motion removes the movement, not merely its
    // appearance. The shimmer used to keep a ticker running on every skeleton
    // for a reader who had asked for no animation — invisible, but still a
    // frame callback per skeleton per frame, and a ticker alive at teardown.
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduced && _controller.isAnimating) {
      _controller.stop();
    } else if (!reduced && !_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: context.pk.sunken,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      );
    }
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(-1.5 + _controller.value * 3, 0),
            end: Alignment(-.5 + _controller.value * 3, 0),
            colors: [
              context.pk.sunken,
              context.pk.borderSubtle,
              context.pk.sunken,
            ],
          ),
        ),
      ),
    );
  }
}
