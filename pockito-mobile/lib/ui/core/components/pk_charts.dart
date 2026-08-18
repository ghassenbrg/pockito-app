import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/models/financial_models.dart';
import '../design_system/pk_format.dart';
import '../design_system/pk_labels.dart';
import '../design_system/pk_tokens.dart';

/// The colours charts are allowed to use.
///
/// Deliberately separate from [PkPalette.category], which exists to tint icon
/// tiles where a name and a glyph already carry identity. In a chart, adjacent
/// marks touch, so the set has to survive an all-pairs colour-vision check —
/// and the 12-colour tile palette does not (it holds two near-identical
/// purples and two ambers).
///
/// These four were validated all-pairs against both the light card surface
/// (#FFFFFF) and the dark one (#0D2239): lightness band, chroma floor,
/// normal-vision separation and contrast all pass, with colour-vision
/// separation in the floor band — which is legal *because* every mark here
/// also carries a direct label and a legend row, and slices are separated by a
/// surface-coloured gap.
///
/// Amber is absent on purpose: in Pockito amber means shared money, and a
/// palette that spent it on "category 3" would break that signal.
abstract final class PkChartPalette {
  static const series = <Color>[
    Color(0xFF0D9488), // teal
    Color(0xFF3B82F6), // blue
    Color(0xFF7C3AED), // violet
    Color(0xFFE11D48), // rose
  ];

  /// How many categories can be told apart by colour. Everything past this
  /// folds into a single neutral "Everything else" slice rather than being
  /// given a generated hue.
  static const maxSeries = 4;

  /// The neutral for the fold-in slice. Low chroma on purpose: it reads as
  /// "the rest", not as another category.
  static Color other(BuildContext context) => context.pk.textTertiary;

  /// The hue for a category, chosen by the category's own identity rather than
  /// by how much was spent on it — so a category does not change colour when
  /// it moves up or down the ranking.
  static Color forSlot(int slot) => series[slot % series.length];
}

/// Assigns chart colours to slices by identity, not by rank.
///
/// Slices are ordered by id to pick slots, so the same set of categories
/// always produces the same colours whichever one happens to be largest this
/// month.
List<Color> pkAssignSliceColors(
  BuildContext context,
  List<CategorySlice> slices,
) {
  final stable = slices.where((slice) => slice.id != '__other__').toList()
    ..sort((a, b) => a.id.compareTo(b.id));
  final slots = <String, Color>{};
  for (var index = 0; index < stable.length; index++) {
    slots[stable[index].id] = PkChartPalette.forSlot(index);
  }
  return [
    for (final slice in slices)
      slice.id == '__other__'
          ? PkChartPalette.other(context)
          : slots[slice.id] ?? PkChartPalette.other(context),
  ];
}

// -----------------------------------------------------------------------------
// Sparkline
// -----------------------------------------------------------------------------

/// A single series over time: spend per month, or an account's balance.
///
/// One series, so there is no legend — the title names it. The last point is
/// marked and labelled, because "where it is now" is the reading people take
/// from a trend line.
class PkSparkline extends StatelessWidget {
  const PkSparkline({
    super.key,
    required this.points,
    required this.currency,
    this.height = 72,
    this.color,
    this.showLastLabel = true,
    this.semanticLabel,
  });

  final List<SeriesPoint> points;
  final String currency;
  final double height;
  final Color? color;
  final bool showLastLabel;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            context.t.chartNotEnoughHistory,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      );
    }
    final tone = color ?? Theme.of(context).colorScheme.primary;
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final chart = SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => TweenAnimationBuilder<double>(
          duration: reducedMotion ? Duration.zero : PkMotion.slow,
          curve: PkMotion.enter,
          tween: Tween(begin: reducedMotion ? 1 : 0, end: 1),
          builder: (context, progress, _) => CustomPaint(
            size: Size(constraints.maxWidth, height),
            painter: _SparklinePainter(
              points: points,
              line: tone,
              fill: tone.withValues(alpha: .12),
              baseline: context.pk.borderSubtle,
              surface: context.pk.surface,
              progress: progress,
            ),
          ),
        ),
      ),
    );
    return Semantics(
      label:
          semanticLabel ??
          context.t.trendFromTo(
            points.first.label,
            points.last.label,
            points
                .map(
                  (p) => '${p.label} ${PkFormat.money(p.valueMinor, currency)}',
                )
                .join(', '),
          ),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          chart,
          const SizedBox(height: PkSpacing.x1),
          Row(
            children: [
              Text(
                points.first.label,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const Spacer(),
              if (showLastLabel)
                Flexible(
                  child: Text(
                    '${points.last.label} · '
                    '${PkFormat.money(points.last.valueMinor, currency)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: context.pk.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  const _SparklinePainter({
    required this.points,
    required this.line,
    required this.fill,
    required this.baseline,
    required this.surface,
    required this.progress,
  });

  final List<SeriesPoint> points;
  final Color line;
  final Color fill;
  final Color baseline;
  final Color surface;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.map((point) => point.valueMinor).toList();
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    // A flat series should read as flat, not as noise amplified to fill the
    // box, so a zero range collapses to the middle.
    final range = maxValue - minValue;
    const marker = 4.0;
    final usable = size.height - marker * 2;
    double yFor(int value) => range == 0
        ? size.height / 2
        : marker + usable - ((value - minValue) / range) * usable;
    final step = size.width / (points.length - 1);
    final offsets = [
      for (var index = 0; index < points.length; index++)
        Offset(index * step, yFor(values[index])),
    ];

    canvas.drawLine(
      Offset(0, size.height - 0.5),
      Offset(size.width, size.height - 0.5),
      Paint()
        ..color = baseline
        ..strokeWidth = 1,
    );

    final drawCount = math.max(2, (offsets.length * progress).ceil());
    final visible = offsets.take(drawCount).toList();
    final path = Path()..moveTo(visible.first.dx, visible.first.dy);
    for (final offset in visible.skip(1)) {
      path.lineTo(offset.dx, offset.dy);
    }
    final area = Path.from(path)
      ..lineTo(visible.last.dx, size.height)
      ..lineTo(visible.first.dx, size.height)
      ..close();
    canvas.drawPath(area, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    if (progress < 1) return;
    // A ring in the surface colour keeps the marker legible where it sits on
    // top of the line.
    canvas.drawCircle(offsets.last, marker + 2, Paint()..color = surface);
    canvas.drawCircle(offsets.last, marker, Paint()..color = line);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) =>
      oldDelegate.points != points ||
      oldDelegate.line != line ||
      oldDelegate.progress != progress;
}

// -----------------------------------------------------------------------------
// Category donut
// -----------------------------------------------------------------------------

/// Where the month's money went, as composition.
///
/// Shows at most [PkChartPalette.maxSeries] named slices; the rest fold into a
/// single neutral slice. That limit is not arbitrary — it is how many colours
/// survive an all-pairs colour-vision check on both surfaces, and inventing a
/// fifth hue would mean two slices nobody can reliably tell apart.
class PkCategoryDonut extends StatelessWidget {
  const PkCategoryDonut({
    super.key,
    required this.slices,
    required this.currency,
    required this.totalMinor,
    this.onSliceTap,
    this.centerLabel,
  });

  final List<CategorySlice> slices;
  final String currency;
  final int totalMinor;
  final void Function(CategorySlice)? onSliceTap;

  /// Null falls back to the localized word for spending.
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    if (slices.isEmpty || totalMinor <= 0) {
      return Text(
        context.t.chartNothingRecorded,
        style: Theme.of(context).textTheme.bodySmall,
      );
    }
    final colors = pkAssignSliceColors(context, slices);
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Below this the ring and a three-column legend cannot both fit, so
        // the legend moves under the ring rather than being squeezed.
        final stacked = constraints.maxWidth < 320;
        final ring = Semantics(
          label: context.t.spendingByCategory(
            slices
                .map(
                  (s) => '${s.label} ${PkFormat.money(s.valueMinor, currency)}',
                )
                .join(', '),
          ),
          excludeSemantics: true,
          child: SizedBox(
            width: 132,
            height: 132,
            child: TweenAnimationBuilder<double>(
              duration: reducedMotion ? Duration.zero : PkMotion.slow,
              curve: PkMotion.enter,
              tween: Tween(begin: reducedMotion ? 1 : 0, end: 1),
              builder: (context, progress, _) => CustomPaint(
                painter: _DonutPainter(
                  slices: slices,
                  colors: colors,
                  totalMinor: totalMinor,
                  surface: context.pk.surface,
                  progress: progress,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        centerLabel ?? context.t.spent,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Text(
                        PkFormat.compactMoney(totalMinor, currency),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontFeatures: const [
                                FontFeature.tabularFigures(),
                              ],
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        // The legend is not decoration: it is what carries identity, so colour
        // never has to.
        final legend = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < slices.length; index++)
              _LegendRow(
                slice: slices[index],
                color: colors[index],
                currency: currency,
                share: slices[index].valueMinor / totalMinor,
                onTap: onSliceTap == null
                    ? null
                    : () => onSliceTap!(slices[index]),
              ),
          ],
        );
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: ring),
              const SizedBox(height: PkSpacing.x3),
              legend,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ring,
            const SizedBox(width: PkSpacing.x4),
            Expanded(child: legend),
          ],
        );
      },
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.slice,
    required this.color,
    required this.currency,
    required this.share,
    this.onTap,
  });

  final CategorySlice slice;
  final Color color;
  final String currency;
  final double share;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final swatch = Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
    final label = Text(
      slice.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      // Text stays in ink, never the series colour: the swatch beside it is
      // what carries identity.
      style: Theme.of(context).textTheme.bodySmall,
    );
    final percent = Text(
      '${(share * 100).round()}%',
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: context.pk.textSecondary,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    final amount = Text(
      PkFormat.money(slice.valueMinor, currency),
      maxLines: 1,
      overflow: TextOverflow.fade,
      softWrap: false,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
    );
    // Three fixed-width tokens on one line stop fitting before 1.3x: the
    // label's `Expanded` shrinks to nothing and the row overflows anyway,
    // because a percentage and an amount cannot be squeezed. Above that the
    // numbers move under the name — the rule `PkLedgerRow` and `PkDetailRow`
    // already follow — rather than one of them being dropped.
    final stacked = MediaQuery.textScalerOf(context).scale(1) > 1.2;
    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: stacked
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: PkSpacing.x1),
                  child: swatch,
                ),
                const SizedBox(width: PkSpacing.x2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      label,
                      Row(
                        children: [
                          percent,
                          const SizedBox(width: PkSpacing.x2),
                          Flexible(child: amount),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              children: [
                swatch,
                const SizedBox(width: PkSpacing.x2),
                Expanded(child: label),
                const SizedBox(width: PkSpacing.x2),
                percent,
                const SizedBox(width: PkSpacing.x2),
                amount,
              ],
            ),
    );
    // A legend that only labels the ring may be as tight as it likes. One that
    // *navigates* is a control, and a control is 48 — the rows were 24, which
    // is how a chart legend became the smallest tap target in the app.
    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: PkSize.touch),
        child: row,
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({
    required this.slices,
    required this.colors,
    required this.totalMinor,
    required this.surface,
    required this.progress,
  });

  final List<CategorySlice> slices;
  final List<Color> colors;
  final int totalMinor;
  final Color surface;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    const stroke = 18.0;
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    final center = rect.center;
    var start = -math.pi / 2;
    // A gap in the surface colour between slices, so two touching fills never
    // read as one.
    final gap = slices.length > 1 ? 0.03 : 0.0;
    for (var index = 0; index < slices.length; index++) {
      final share = slices[index].valueMinor / totalMinor;
      final sweep = share * math.pi * 2 * progress;
      if (sweep <= gap) {
        start += sweep;
        continue;
      }
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start + gap / 2,
        sweep - gap,
        false,
        Paint()
          ..color = colors[index]
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.butt,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) =>
      oldDelegate.slices != slices ||
      oldDelegate.colors != colors ||
      oldDelegate.progress != progress;
}

// -----------------------------------------------------------------------------
// Budget arc
// -----------------------------------------------------------------------------

/// One budget against its limit, with the pace it is running at.
///
/// The arc's colour is a reserved status colour, never a categorical one, and
/// it is always paired with a written reading — a ring that is merely red
/// tells a colourblind user nothing.
class PkBudgetArc extends StatelessWidget {
  const PkBudgetArc({
    super.key,
    required this.snapshot,
    this.size = 148,
    this.showForecast = true,
  });

  final BudgetSnapshot snapshot;
  final double size;
  final bool showForecast;

  @override
  Widget build(BuildContext context) {
    final tone = switch (snapshot.health) {
      BudgetHealth.exceeded => context.pk.danger,
      BudgetHealth.near => context.pk.warning,
      BudgetHealth.healthy => context.pk.success,
    };
    final reading = switch (snapshot.health) {
      BudgetHealth.exceeded => context.t.x0Over(
        PkFormat.money(snapshot.remainingMinor.abs(), snapshot.budget.currency),
      ),
      BudgetHealth.near => context.t.closeToTheLimit,
      BudgetHealth.healthy => context.t.x0Left(
        PkFormat.money(snapshot.remainingMinor, snapshot.budget.currency),
      ),
    };
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    // Where the period will land at the current pace, as a fraction of the
    // limit — the number that turns "you have spent X" into "you are going to
    // run out".
    final forecastShare = snapshot.budget.limitMinor == 0
        ? 0.0
        : snapshot.forecastMinor / snapshot.budget.limitMinor;
    return Semantics(
      label: context.t.x0X1OfX2X3X4(
        snapshot.budget.name,
        PkFormat.money(snapshot.usedMinor, snapshot.budget.currency),
        PkFormat.money(snapshot.budget.limitMinor, snapshot.budget.currency),
        reading,
        showForecast
            ? context.t.onTrackForX0ByTheEndOfTheX1(
                PkFormat.money(
                  snapshot.forecastMinor,
                  snapshot.budget.currency,
                ),
                snapshot.budget.period.nounIn(context.t),
              )
            : '',
      ),
      excludeSemantics: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size * .62,
            child: TweenAnimationBuilder<double>(
              duration: reducedMotion ? Duration.zero : PkMotion.slow,
              curve: PkMotion.enter,
              tween: Tween(
                begin: reducedMotion ? snapshot.progress : 0,
                end: snapshot.progress,
              ),
              builder: (context, progress, _) => CustomPaint(
                painter: _ArcPainter(
                  progress: progress,
                  forecast: showForecast ? forecastShare : null,
                  tone: tone,
                  track: context.pk.sunken,
                  surface: context.pk.surface,
                  marker: context.pk.textTertiary,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: size * .14),
                    // The arc is a drawn shape of a fixed diameter, so its
                    // inner label scales down to stay inside it rather than
                    // spilling over the stroke. Section 9.5 is still met: the
                    // same figures are text in the legend beneath, which does
                    // scale.
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(snapshot.progress * 100).round()}%',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                          Text(
                            context.t.ofX0(
                              PkFormat.compactMoney(
                                snapshot.budget.limitMinor,
                                snapshot.budget.currency,
                              ),
                            ),
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: PkSpacing.x2),
          // Colour and words together, always.
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                switch (snapshot.health) {
                  BudgetHealth.exceeded => Icons.error_outline_rounded,
                  BudgetHealth.near => Icons.warning_amber_rounded,
                  BudgetHealth.healthy => Icons.check_circle_outline_rounded,
                },
                size: PkSize.iconSmall,
                color: tone,
              ),
              const SizedBox(width: PkSpacing.x1),
              Flexible(
                child: Text(
                  reading,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: tone),
                ),
              ),
            ],
          ),
          if (showForecast && snapshot.forecastMinor > 0) ...[
            const SizedBox(height: 2),
            Text(
              snapshot.forecastMinor > snapshot.budget.limitMinor
                  ? context.t.atThisPaceYouFinish(
                      snapshot.budget.period.noun,
                      PkFormat.money(
                        snapshot.forecastMinor - snapshot.budget.limitMinor,
                        snapshot.budget.currency,
                      ),
                    )
                  : context.t.atThisPaceYouFinish2(
                      snapshot.budget.period.noun,
                      PkFormat.money(
                        snapshot.forecastMinor,
                        snapshot.budget.currency,
                      ),
                    ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (snapshot.rolloverMinor > 0) ...[
            const SizedBox(height: 2),
            Text(
              context.t.includesCarriedOverFromLast(
                PkFormat.money(
                  snapshot.rolloverMinor,
                  snapshot.budget.currency,
                ),
                snapshot.budget.period.noun,
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  const _ArcPainter({
    required this.progress,
    required this.forecast,
    required this.tone,
    required this.track,
    required this.surface,
    required this.marker,
  });

  final double progress;
  final double? forecast;
  final Color tone;
  final Color track;
  final Color surface;
  final Color marker;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 14.0;
    final radius = (size.width - stroke) / 2;
    final center = Offset(size.width / 2, size.height - stroke / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi,
      false,
      Paint()
        ..color = track
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
    final swept = progress.clamp(0.0, 1.0) * math.pi;
    if (swept > 0) {
      canvas.drawArc(
        rect,
        math.pi,
        swept,
        false,
        Paint()
          ..color = tone
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..strokeCap = StrokeCap.round,
      );
    }
    // The pace marker: where this period ends if nothing changes.
    final forecastShare = forecast;
    if (forecastShare != null && forecastShare > progress) {
      final angle = math.pi + forecastShare.clamp(0.0, 1.0) * math.pi;
      final point = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      canvas
        ..drawCircle(point, 5, Paint()..color = surface)
        ..drawCircle(
          point,
          3.5,
          Paint()
            ..color = marker
            ..style = PaintingStyle.fill,
        );
    }
  }

  @override
  bool shouldRepaint(_ArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.tone != tone ||
      oldDelegate.forecast != forecast;
}

// -----------------------------------------------------------------------------
// Comparison
// -----------------------------------------------------------------------------

/// A figure alongside the same figure last period.
///
/// A number with no baseline carries no judgement: €1,899 is only high or low
/// against what last month was.
/// How a period compares with the one before it, in words.
///
/// Extracted so a row that only has space for the sentence says exactly what
/// the chart beside it would have said. Two phrasings of one comparison is how
/// a summary and its detail start disagreeing.
String pkComparisonReading(PeriodComparison comparison, PkStrings t) {
  if (comparison.isFlat) return t.comparisonFlat(comparison.previousLabel);
  final ratio = comparison.ratio;
  final percent = ratio == null ? 100 : (ratio.abs() * 100).round();
  return comparison.isUp
      ? t.comparisonMore(percent, comparison.previousLabel)
      : t.comparisonLess(percent, comparison.previousLabel);
}

class PkComparisonLabel extends StatelessWidget {
  const PkComparisonLabel({
    super.key,
    required this.comparison,
    this.upIsBad = true,
    this.compact = false,
    this.onLight = false,
  });

  final PeriodComparison comparison;

  /// Spending up is bad; income up is good. Direction alone does not say.
  final bool upIsBad;
  final bool compact;

  /// Rendered on a coloured hero, where the semantic ink colours would vanish.
  final bool onLight;

  @override
  Widget build(BuildContext context) {
    final flat = comparison.isFlat;
    final up = comparison.isUp;
    final good = flat ? null : (up ? !upIsBad : upIsBad);
    final tone = onLight
        ? Colors.white.withValues(alpha: .92)
        : flat
        ? context.pk.textSecondary
        : good!
        ? context.pk.success
        : context.pk.danger;
    // "About the same as July" is what a person says. A percentage that reads
    // 3% is noise dressed up as a finding.
    final reading = pkComparisonReading(comparison, context.t);
    return Semantics(
      label:
          '$reading. '
          '${comparison.previousLabel}: '
          '${PkFormat.money(comparison.previousMinor, comparison.currency)}.',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            flat
                ? Icons.trending_flat_rounded
                : up
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: compact ? 14 : PkSize.iconSmall,
            color: tone,
          ),
          const SizedBox(width: PkSpacing.x1),
          Flexible(
            child: Text(
              reading,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  (compact
                          ? Theme.of(context).textTheme.labelSmall
                          : Theme.of(context).textTheme.labelMedium)
                      ?.copyWith(color: tone),
            ),
          ),
        ],
      ),
    );
  }
}

/// The numbers behind a chart, for anyone the chart does not serve.
///
/// Present on every chart surface: it is what discharges a contrast warning
/// honestly, and it is the only version that works in a screen reader.
class PkChartDataTable extends StatelessWidget {
  const PkChartDataTable({
    super.key,
    required this.rows,
    required this.currency,
    this.label,
  });

  final List<(String, int)> rows;
  final String currency;
  final String? label;

  @override
  Widget build(BuildContext context) => Theme(
    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
    child: ExpansionTile(
      key: const ValueKey('chart_table'),
      tilePadding: EdgeInsets.zero,
      title: Text(
        label ?? context.t.chartViewAsTable,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.$1,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  PkFormat.money(row.$2, currency),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}
