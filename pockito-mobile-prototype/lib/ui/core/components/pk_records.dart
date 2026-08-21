import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/financial_models.dart';
import '../design_system/pk_format.dart';
import '../design_system/pk_labels.dart';
import '../design_system/pk_tokens.dart';
import 'pk_components.dart';

/// The band explaining why a record is not counting.
///
/// A struck-through row alone tells the user something happened; it does not
/// tell them what, when, or whether they can put it back.
class PkRecordStatusBanner extends StatelessWidget {
  const PkRecordStatusBanner({
    super.key,
    required this.status,
    this.reason,
    this.voidedAt,
    this.onConfirm,
    this.onRestore,
  });

  final RecordStatus status;
  final String? reason;
  final DateTime? voidedAt;
  final VoidCallback? onConfirm;
  final VoidCallback? onRestore;

  @override
  Widget build(BuildContext context) {
    if (status == RecordStatus.confirmed) return const SizedBox.shrink();
    final voided = status == RecordStatus.voided;
    final tone = voided ? context.pk.danger : context.pk.sharedStrong;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(PkSpacing.x4),
        decoration: BoxDecoration(
          color: voided
              ? context.pk.danger.withValues(alpha: .08)
              : context.pk.sharedSurface,
          borderRadius: BorderRadius.circular(PkRadius.large),
          border: Border.all(
            color: voided
                ? context.pk.danger.withValues(alpha: .3)
                : context.pk.sharedBorder,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              voided ? Icons.block_rounded : Icons.edit_note_rounded,
              size: PkSize.icon,
              color: tone,
            ),
            const SizedBox(width: PkSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voided
                        ? context.t.statusVoided
                        : context.t.recordDraftBanner,
                    style: context.pkText.rowTitle.copyWith(color: tone),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    voided
                        ? [
                            context.t.recordVoidedBody,
                            if (reason != null) '“$reason”',
                            if (voidedAt != null)
                              context.t.voidedX0(
                                PkFormat.longDate(voidedAt!, context.t),
                              ),
                          ].join(' ')
                        : context.t.recordDraftBody,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (onConfirm != null || onRestore != null) ...[
                    const SizedBox(height: PkSpacing.x3),
                    if (onConfirm != null)
                      FilledButton.icon(
                        key: const ValueKey('record_confirm'),
                        onPressed: onConfirm,
                        icon: const Icon(Icons.check_rounded, size: 18),
                        label: Text(context.t.actionConfirm),
                      )
                    else
                      OutlinedButton.icon(
                        key: const ValueKey('record_restore'),
                        onPressed: onRestore,
                        icon: const Icon(Icons.restore_rounded, size: 18),
                        label: Text(context.t.actionRestore),
                      ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A small badge for a non-confirmed record, used inside list rows.
class PkRecordStatusBadge extends StatelessWidget {
  const PkRecordStatusBadge({super.key, required this.status});

  final RecordStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == RecordStatus.confirmed) return const SizedBox.shrink();
    final voided = status == RecordStatus.voided;
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 6),
      child: PkStatusBadge(
        label: voided ? context.t.statusVoided : context.t.statusDraft,
        tone: voided ? PkStatusTone.danger : PkStatusTone.warning,
        icon: voided ? Icons.block_rounded : Icons.edit_note_rounded,
      ),
    );
  }
}

/// Receipts kept against a record, with a full-screen viewer.
///
/// The prototype stores no image bytes, so each attachment renders as a
/// deterministic placeholder derived from its seed — the shape of the feature
/// is real even though the pixels are not.
class PkAttachmentStrip extends StatelessWidget {
  const PkAttachmentStrip({
    super.key,
    required this.attachments,
    this.title,
    this.onAdd,
    this.onRemove,
  });

  final List<ReceiptAttachment> attachments;
  final String? title;
  final VoidCallback? onAdd;
  final void Function(ReceiptAttachment)? onRemove;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              title ?? context.t.attachments,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (onAdd != null)
            TextButton.icon(
              key: const ValueKey('attachment_add'),
              onPressed: onAdd,
              icon: const Icon(Icons.add_photo_alternate_outlined, size: 18),
              label: Text(context.t.attach),
            ),
        ],
      ),
      const SizedBox(height: PkSpacing.x2),
      if (attachments.isEmpty)
        Text(
          context.t.noReceiptKeptScanningOne,
          style: Theme.of(context).textTheme.bodySmall,
        )
      else
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: attachments.length,
            separatorBuilder: (_, _) => const SizedBox(width: PkSpacing.x3),
            itemBuilder: (context, index) => _AttachmentThumb(
              attachment: attachments[index],
              onOpen: () => _open(context, attachments[index]),
              onRemove: onRemove == null
                  ? null
                  : () => onRemove!(attachments[index]),
            ),
          ),
        ),
    ],
  );

  void _open(BuildContext context, ReceiptAttachment attachment) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (context) => _AttachmentViewer(attachment: attachment),
        ),
      );
}

class _AttachmentThumb extends StatelessWidget {
  const _AttachmentThumb({
    required this.attachment,
    required this.onOpen,
    this.onRemove,
  });

  final ReceiptAttachment attachment;
  final VoidCallback onOpen;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 108,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Material(
                  color: context.pk.sunken,
                  borderRadius: BorderRadius.circular(PkRadius.medium),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    key: ValueKey('attachment_${attachment.id}'),
                    onTap: onOpen,
                    child: CustomPaint(
                      painter: _ReceiptPainter(
                        seed: attachment.previewSeed,
                        ink: context.pk.textTertiary,
                        paper: context.pk.surface,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 4,
                top: 4,
                child: _OcrBadge(status: attachment.ocrStatus),
              ),
              if (onRemove != null)
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    tooltip: context.t.removeX0(attachment.label),
                    icon: const Icon(Icons.cancel_rounded, size: 18),
                    onPressed: onRemove,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          attachment.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _OcrBadge extends StatelessWidget {
  const _OcrBadge({required this.status});
  final OcrStatus status;

  @override
  Widget build(BuildContext context) {
    if (status == OcrStatus.none) return const SizedBox.shrink();
    final (label, tone, icon) = switch (status) {
      OcrStatus.pending => (
        context.t.queued,
        context.pk.textTertiary,
        Icons.schedule_rounded,
      ),
      OcrStatus.processing => (
        context.t.reading,
        context.pk.sharedStrong,
        Icons.hourglass_top_rounded,
      ),
      OcrStatus.completed => (
        context.t.read,
        context.pk.success,
        Icons.check_rounded,
      ),
      OcrStatus.failed => (
        context.t.unreadable,
        context.pk.danger,
        Icons.error_outline_rounded,
      ),
      OcrStatus.none => ('', context.pk.textTertiary, Icons.circle),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.pk.surface,
        borderRadius: BorderRadius.circular(PkRadius.full),
        border: Border.all(color: tone.withValues(alpha: .4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: tone),
          const SizedBox(width: 3),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: tone, letterSpacing: 0),
          ),
        ],
      ),
    );
  }
}

class _AttachmentViewer extends StatelessWidget {
  const _AttachmentViewer({required this.attachment});
  final ReceiptAttachment attachment;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(attachment.label)),
    body: Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            maxScale: 4,
            child: Center(
              child: AspectRatio(
                aspectRatio: .62,
                child: Container(
                  margin: const EdgeInsets.all(PkSpacing.x5),
                  decoration: BoxDecoration(
                    color: context.pk.surface,
                    borderRadius: BorderRadius.circular(PkRadius.medium),
                    boxShadow: PkShadows.card(PkPalette.kitoNavy900),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CustomPaint(
                    painter: _ReceiptPainter(
                      seed: attachment.previewSeed,
                      ink: context.pk.textTertiary,
                      paper: context.pk.surface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(PkSpacing.screen),
            child: PkCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _OcrBadge(status: attachment.ocrStatus),
                      const SizedBox(width: PkSpacing.x2),
                      Expanded(
                        child: Text(
                          context.t.capturedX0(
                            PkFormat.longDate(attachment.capturedAt, context.t),
                          ),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  if (attachment.extractedMerchant != null ||
                      attachment.extractedTotalMinor != null) ...[
                    const SizedBox(height: PkSpacing.x2),
                    Text(
                      context.t.readFromThisReceipt(
                        [
                          attachment.extractedMerchant,
                          if (attachment.extractedTotalMinor != null)
                            '${attachment.extractedTotalMinor}',
                        ].whereType<String>().join(' · '),
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (attachment.failureReason != null) ...[
                    const SizedBox(height: PkSpacing.x2),
                    Text(
                      attachment.failureReason!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: context.pk.danger),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

/// Draws a receipt-shaped placeholder. Deterministic from the seed, so the
/// same attachment always looks the same.
class _ReceiptPainter extends CustomPainter {
  const _ReceiptPainter({
    required this.seed,
    required this.ink,
    required this.paper,
  });

  final int seed;
  final Color ink;
  final Color paper;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = paper);
    final line = Paint()
      ..color = ink.withValues(alpha: .32)
      ..strokeCap = StrokeCap.round;
    final margin = size.width * .14;
    var y = size.height * .16;
    var state = seed * 2654435761 % 4294967296;
    var index = 0;
    while (y < size.height * .9) {
      state = (state * 1103515245 + 12345) % 2147483648;
      final width = (size.width - margin * 2) * (.35 + (state % 60) / 100);
      final thick = index == 0 ? 3.0 : 1.6;
      line.strokeWidth = thick;
      canvas.drawLine(
        Offset(margin, y),
        Offset(margin + (index == 0 ? size.width - margin * 2 : width), y),
        line,
      );
      y += size.height * (index == 0 ? .09 : .058);
      index++;
    }
  }

  @override
  bool shouldRepaint(_ReceiptPainter oldDelegate) =>
      oldDelegate.seed != seed ||
      oldDelegate.ink != ink ||
      oldDelegate.paper != paper;
}

/// One thing connected to what the user is looking at.
class PkRelatedItem {
  const PkRelatedItem({
    required this.icon,
    required this.label,
    required this.detail,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String detail;
  final String route;
}

/// The connections block at the foot of a detail screen.
class PkRelatedItems extends StatelessWidget {
  const PkRelatedItems({super.key, required this.items, this.title});

  final List<PkRelatedItem> items;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? context.t.connectedToThis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: PkSpacing.x2),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: PkSpacing.x2),
            child: PkCard(
              onTap: () => context.push(item.route),
              padding: const EdgeInsets.all(PkSpacing.x3),
              child: Row(
                children: [
                  PkIconTile(
                    icon: item.icon,
                    accent: PkAccent.ink(Theme.of(context).colorScheme.primary),
                    size: 36,
                    iconSize: 17,
                  ),
                  const SizedBox(width: PkSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          item.detail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: context.pk.textTertiary,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

/// States the rate behind any converted figure.
///
/// A number that has been through a conversion is not the number the user
/// saw on their statement. Saying which rate, from when, and where it came
/// from is what makes the converted figure checkable rather than merely
/// plausible.
class PkFxDisclosure extends StatelessWidget {
  const PkFxDisclosure({
    super.key,
    required this.quotes,
    required this.reportingCurrency,
    this.history = const [],
  });

  final List<FxQuote> quotes;
  final String reportingCurrency;
  final List<FxRateChange> history;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) return const SizedBox.shrink();
    return Semantics(
      container: true,
      // A Material, not a decorated box: the rate history is an ExpansionTile
      // and needs somewhere to paint its ink.
      child: Material(
        color: context.pk.sunken,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PkRadius.medium),
          side: BorderSide(color: context.pk.borderSubtle),
        ),
        child: Padding(
          padding: const EdgeInsets.all(PkSpacing.x3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.sync_alt_rounded,
                    size: PkSize.iconSmall,
                    color: context.pk.textTertiary,
                  ),
                  const SizedBox(width: PkSpacing.x2),
                  Expanded(
                    child: Text(
                      context.t.fxConvertedTo(reportingCurrency),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.x2),
              for (final quote in quotes)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    context.t.fxRateLine(
                      quote.fromCurrency,
                      quote.rate.toStringAsPrecision(6),
                      quote.toCurrency,
                      quote.mode == FxRateMode.manual
                          ? context.t.fxManualRate
                          : quote.source.labelIn(context.t),
                      PkFormat.longDate(quote.updatedAt, context.t),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              if (history.isNotEmpty) ...[
                const SizedBox(height: PkSpacing.x2),
                Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    key: const ValueKey('fx_history'),
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      context.t.fxRateHistory,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    children: [
                      for (final change in history.take(8))
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  // A currency pair and a date: no prose to
                                  // translate.
                                  // i18n-exempt
                                  '${change.pair.replaceAll('_', ' → ')} · '
                                  '${PkFormat.longDate(change.at, context.t)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              Text(
                                change.previousRate == null
                                    ? change.rate.toStringAsPrecision(6)
                                    : '${change.previousRate!.toStringAsPrecision(6)} → '
                                          '${change.rate.toStringAsPrecision(6)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              // A rate someone typed in is not a rate a market
                              // quoted, and the log says which is which.
                              if (change.mode == FxRateMode.manual) ...[
                                const SizedBox(width: PkSpacing.x2),
                                Icon(
                                  Icons.edit_outlined,
                                  size: 12,
                                  color: context.pk.warning,
                                ),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// One thing that happened to a record.
@immutable
class PkTimelineEntry {
  const PkTimelineEntry({
    required this.title,
    required this.detail,
    this.tone = PkStatusTone.neutral,
    this.done = true,
  });

  final String title;

  /// When, and by whom. The two things a disagreement about a number turns on.
  final String detail;

  final PkStatusTone tone;

  /// False for a step that is expected but has not happened — a settlement
  /// waiting on the other person, an invite not yet accepted.
  final bool done;
}

/// How a record got to where it is.
///
/// `PkRecordStatusBanner` says what state a record is *in*. This says how it
/// arrived — created, edited, settled, voided — which is the question two
/// people actually have when they disagree about a shared number. The Space
/// activity log answers it for a whole Space; nothing answered it for one
/// record.
class PkRecordTimeline extends StatelessWidget {
  const PkRecordTimeline({super.key, required this.entries});

  final List<PkTimelineEntry> entries;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final (index, entry) in entries.indexed)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: PkSpacing.x6,
                  child: Column(
                    children: [
                      _PkTimelineMarker(entry: entry),
                      if (index < entries.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: context.pk.borderSubtle,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: PkSpacing.x3),
                Expanded(
                  child: Semantics(
                    container: true,
                    label: '${entry.title}, ${entry.detail}',
                    excludeSemantics: true,
                    child: Padding(
                      padding: EdgeInsetsDirectional.only(
                        bottom: index == entries.length - 1 ? 0 : PkSpacing.x4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(entry.title, style: context.pkText.rowTitle),
                          Text(entry.detail, style: context.pkText.supporting),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _PkTimelineMarker extends StatelessWidget {
  const _PkTimelineMarker({required this.entry});

  final PkTimelineEntry entry;

  @override
  Widget build(BuildContext context) {
    final ink = pkStatusInk(context, entry.tone);
    if (!entry.done) {
      // A hollow ring for something still expected: the rail should read as
      // unfinished at a glance, not only in the words.
      return Container(
        width: PkSpacing.x5,
        height: PkSpacing.x5,
        margin: const EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          color: context.pk.surface,
          shape: BoxShape.circle,
          border: Border.all(color: context.pk.borderDefault, width: 2),
        ),
      );
    }
    return Container(
      width: PkSpacing.x5,
      height: PkSpacing.x5,
      margin: const EdgeInsets.only(top: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: ink, shape: BoxShape.circle),
      child: Icon(
        Icons.check_rounded,
        size: PkSpacing.x3,
        color: context.pk.surface,
      ),
    );
  }
}

/// One person's slice of a shared expense.
class PkSplitSegment {
  const PkSplitSegment({
    required this.id,
    required this.label,
    required this.amountMinor,
    required this.accent,
  });

  final String id;
  final String label;
  final int amountMinor;
  final PkAccent accent;
}

/// How a shared expense divides, as one bar.
///
/// `PkShareRule` — the 64 px, 2 px, unlabelled bar this replaces — could show
/// one person's fraction and nothing else, on the one feature Pockito is built
/// around. This shows every share at once, keyed by colour to the member rows
/// beneath it, and says the same thing in words for a reader who cannot use
/// the colours at all.
class PkSplitBar extends StatelessWidget {
  const PkSplitBar({
    super.key,
    required this.segments,
    required this.currency,
    this.height = 10,
  });

  final List<PkSplitSegment> segments;
  final String currency;
  final double height;

  /// No slice is allowed to vanish. A 1% share still has to be findable, and
  /// a hairline is not a share.
  static const double _minSegment = 6;

  int get _total =>
      segments.fold(0, (sum, segment) => sum + segment.amountMinor);

  /// The same division as a sentence, in the order the bar draws it.
  String announce(BuildContext context) {
    final total = _total;
    return segments
        .map(
          (segment) => context.t.splitBarLabel(
            segment.label,
            total == 0 ? 0 : (segment.amountMinor / total * 100).round(),
            PkFormat.money(segment.amountMinor, currency),
          ),
        )
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (segments.isEmpty) return const SizedBox.shrink();
    final total = _total;
    return Semantics(
      container: true,
      label: '${context.t.splitBarTitle}: ${announce(context)}',
      excludeSemantics: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Widths are computed rather than flexed: `Expanded` cannot hold a
          // floor, so a 1% slice would round away to nothing.
          final available = constraints.maxWidth;
          final raw = [
            for (final segment in segments)
              total == 0
                  ? available / segments.length
                  : available * segment.amountMinor / total,
          ];
          final widths = [
            for (final value in raw) value.clamp(_minSegment, available),
          ];
          final overflow =
              widths.fold(0.0, (sum, value) => sum + value) - available;
          if (overflow > 0) {
            // Take the excess back from whoever can most afford it.
            final slack = [
              for (final value in widths) (value - _minSegment).clamp(0, value),
            ];
            final slackTotal = slack.fold(0.0, (sum, value) => sum + value);
            if (slackTotal > 0) {
              for (var index = 0; index < widths.length; index++) {
                widths[index] -= overflow * slack[index] / slackTotal;
              }
            }
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(PkRadius.full),
            child: SizedBox(
              height: height,
              child: Row(
                children: [
                  for (var index = 0; index < segments.length; index++)
                    SizedBox(
                      key: ValueKey('split_segment_${segments[index].id}'),
                      width: widths[index],
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: segments[index].accent.fill,
                          // A hairline between slices so two similar hues do
                          // not read as one.
                          border: index == 0
                              ? null
                              : BorderDirectional(
                                  start: BorderSide(color: context.pk.surface),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// The colour key that ties a member row to its slice of [PkSplitBar].
class PkSplitLegendDot extends StatelessWidget {
  const PkSplitLegendDot({super.key, required this.accent, this.size = 10});

  final PkAccent accent;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: accent.fill,
      shape: BoxShape.circle,
      border: Border.all(color: context.pk.surface, width: 1.5),
    ),
  );
}

/// What saving this will do to the balance between two people.
///
/// The split preview answers "how does this divide". This answers the question
/// the reader actually has at the moment they tap save: *what does this change
/// between me and them*. Shared money is the one place in a finance app where
/// a record alters a relationship, and stating that before the tap rather than
/// after is the difference between a ledger and a thing people trust.
class PkBalanceImpact extends StatelessWidget {
  const PkBalanceImpact({
    super.key,
    required this.counterpartyName,
    required this.previousMinor,
    required this.deltaMinor,
    required this.currency,
  });

  final String counterpartyName;

  /// The balance before this record. Positive means they owe the reader.
  final int previousMinor;

  /// What this record adds to it, in the same direction.
  final int deltaMinor;

  final String currency;

  int get _next => previousMinor + deltaMinor;

  String _direction(BuildContext context) {
    if (deltaMinor == 0) return context.t.balanceImpactNoChange;
    return deltaMinor > 0
        ? context.t.balanceImpactWillOwe(counterpartyName)
        : context.t.balanceImpactYouWillOwe(counterpartyName);
  }

  @override
  Widget build(BuildContext context) {
    final gaining = deltaMinor > 0;
    final tone = deltaMinor == 0
        ? context.pk.textSecondary
        : gaining
        ? context.pk.owed
        : context.pk.owing;
    final before = PkBalanceLabel.announce(context, previousMinor, currency);
    final after = PkBalanceLabel.announce(context, _next, currency);
    return Semantics(
      container: true,
      label: [
        context.t.balanceImpactTitle,
        _direction(context),
        if (deltaMinor != 0) PkFormat.money(deltaMinor.abs(), currency),
        '${context.t.balanceImpactWith(counterpartyName)}: $before → $after',
      ].join(', '),
      excludeSemantics: true,
      child: PkCard(
        variant: PkCardVariant.dense,
        color: context.pk.sunken,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.t.balanceImpactTitle,
              style: context.pkText.label.copyWith(
                color: context.pk.textSecondary,
              ),
            ),
            const SizedBox(height: PkSpacing.x2),
            Row(
              children: [
                Icon(
                  deltaMinor == 0
                      ? Icons.remove_rounded
                      : gaining
                      ? Icons.north_east_rounded
                      : Icons.south_west_rounded,
                  size: PkSize.icon,
                  color: tone,
                ),
                const SizedBox(width: PkSpacing.x2),
                Expanded(
                  child: Text(
                    _direction(context),
                    style: context.pkText.bodyStrong,
                  ),
                ),
                if (deltaMinor != 0)
                  PkAmountText(
                    amountMinor: deltaMinor.abs(),
                    currency: currency,
                    color: tone,
                  ),
              ],
            ),
            const SizedBox(height: PkSpacing.x2),
            Text(
              '${context.t.balanceImpactWith(counterpartyName)}: '
              '$before → $after',
              style: context.pkText.supporting,
            ),
          ],
        ),
      ),
    );
  }
}

/// The actions that make sense on the surface the user is already looking at.
class PkQuickActions extends StatelessWidget {
  const PkQuickActions({super.key, required this.actions});

  final List<PkQuickAction> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.pk.surface,
        borderRadius: BorderRadius.circular(PkRadius.large),
        border: Border.all(color: context.pk.borderSubtle),
      ),
      child: Material(
        type: MaterialType.transparency,
        // Intrinsic rather than a fixed height: a two-line label at 2.0x text
        // scale needs more room than the 1.0x row does, and this grows with
        // it instead of clipping.
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: PkSpacing.x2,
            vertical: PkSpacing.x3,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                for (var index = 0; index < actions.length; index++) ...[
                  if (index > 0) const SizedBox(width: PkSpacing.x1),
                  _PkQuickActionButton(action: actions[index]),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PkQuickActionButton extends StatelessWidget {
  const _PkQuickActionButton({required this.action});

  final PkQuickAction action;

  @override
  Widget build(BuildContext context) {
    final ink = PkPalette.brand.ink(context);
    return SizedBox(
      width: 88,
      child: InkWell(
        key: ValueKey('quick_${action.id}'),
        borderRadius: BorderRadius.circular(PkRadius.control),
        onTap: () {
          PkHaptics.selection();
          action.onTap();
        },
        child: Semantics(
          button: true,
          label: action.label,
          excludeSemantics: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, size: PkSize.iconLarge, color: ink),
              const SizedBox(height: PkSpacing.x1),
              Text(
                action.label,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: context.pkText.label.copyWith(
                  color: ink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PkQuickAction {
  const PkQuickAction({
    required this.id,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String id;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

/// The first-run checklist.
///
/// A new user lands on an app full of zeroes with no idea which of six things
/// to do first. This names them, in order, and gets out of the way once they
/// are done.
class PkSetupChecklist extends StatelessWidget {
  const PkSetupChecklist({
    super.key,
    required this.steps,
    required this.onDismiss,
  });

  final List<PkSetupStep> steps;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final done = steps.where((step) => step.done).length;
    if (done == steps.length) return const SizedBox.shrink();
    return PkCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  context.t.setupTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                context.t.setupProgress(done, steps.length),
                style: Theme.of(context).textTheme.labelMedium,
              ),
              IconButton(
                key: const ValueKey('dismiss_checklist'),
                tooltip: context.t.setupHide,
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: onDismiss,
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.x2),
          PkProgressBar(value: done / steps.length),
          const SizedBox(height: PkSpacing.x3),
          // P1-9: `ListTile(dense: true)` shrank the step below the 48 px the
          // rest of the app guarantees — the one place a screen escaped the
          // row system. A done step keeps its target too: it is still a
          // statement the reader can land on.
          for (final step in steps)
            PkLedgerRow.management(
              key: ValueKey('setup_${step.id}'),
              semanticIdentifier: 'setup_${step.id}',
              leading: Icon(
                step.done
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: step.done ? context.pk.success : context.pk.textTertiary,
              ),
              title: step.label,
              struckThrough: step.done,
              showChevron: !step.done,
              enabled: !step.done,
              onTap: step.done ? null : step.onTap,
            ),
        ],
      ),
    );
  }
}

class PkSetupStep {
  const PkSetupStep({
    required this.id,
    required this.label,
    required this.done,
    required this.onTap,
  });

  final String id;
  final String label;
  final bool done;
  final VoidCallback onTap;
}
