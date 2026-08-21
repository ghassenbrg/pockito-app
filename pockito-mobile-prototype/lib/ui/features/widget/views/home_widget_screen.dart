import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../../domain/repositories/pockito_repository.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

/// The figures a home-screen widget shows.
///
/// Deliberately tiny: a widget is glanced at, not read. Net worth answers
/// "am I fine", this month's spend answers "how is it going", and the count of
/// things waiting answers "do I need to open the app".
class PkHomeWidgetData {
  const PkHomeWidgetData({
    required this.netWorthMinor,
    required this.spentMinor,
    required this.currency,
    required this.comparison,
    required this.waitingCount,
    required this.topDebt,
  });

  factory PkHomeWidgetData.from(PockitoRepository repo, DateTime month) {
    final debts = repo.debtEdges();
    return PkHomeWidgetData(
      netWorthMinor: repo.netWorthMinor(repo.profile.reportingCurrency),
      spentMinor: repo.spendingForMonth(month).spentMinor,
      currency: repo.profile.reportingCurrency,
      comparison: repo.spendingComparison(month),
      waitingCount: repo.actionItems().length,
      topDebt: debts.isEmpty ? null : debts.first,
    );
  }

  final int netWorthMinor;
  final int spentMinor;
  final String currency;
  final PeriodComparison comparison;
  final int waitingCount;
  final DebtEdge? topDebt;

  /// The flat payload the native widget reads. Strings, because a widget
  /// renders text and must not re-run the app's money formatting.
  ///
  /// Takes the strings and the repository rather than a `BuildContext`: the
  /// push happens wherever the app's data changes, which is not always
  /// somewhere with a `Localizations` ancestor.
  Map<String, String> toPayload(PkStrings t, PockitoRepository repo) => {
    'netWorth': PkFormat.money(netWorthMinor, currency),
    'spent': PkFormat.money(spentMinor, currency),
    'spentLabel': t.homeSpent,
    'netWorthLabel': t.homeNetWorth,
    'comparison': comparisonText(t),
    'waiting': waitingCount == 0 ? '' : t.homeThingsNeedYou(waitingCount),
    'debt': debtText(t, repo),
  };

  String comparisonText(PkStrings t) {
    final ratio = comparison.ratio;
    if (comparison.isFlat || ratio == null) {
      return t.comparisonFlat(comparison.previousLabel);
    }
    final percent = (ratio.abs() * 100).round();
    return comparison.isUp
        ? t.comparisonMore(percent, comparison.previousLabel)
        : t.comparisonLess(percent, comparison.previousLabel);
  }

  String debtText(PkStrings t, PockitoRepository repo) {
    final edge = topDebt;
    if (edge == null) return '';
    final iOwe = edge.fromUserId == repo.currentUserId;
    final other = repo.userById(iOwe ? edge.toUserId : edge.fromUserId)?.name;
    final amount = PkFormat.money(edge.amountMinor, edge.currency);
    // Both halves are already translated; this only joins them.
    return iOwe
        ? '${t.homeYouOwe(other ?? '')} · $amount' // i18n-exempt
        : '${t.homeOwesYou(other ?? '')} · $amount'; // i18n-exempt
  }
}

/// Keeps the home-screen widget in step with the app.
///
/// Lives *inside* `MaterialApp`, because building the payload needs the
/// translated strings and therefore a `Localizations` ancestor.
class PkHomeWidgetSync extends StatefulWidget {
  const PkHomeWidgetSync({super.key, required this.child});

  final Widget child;

  @override
  State<PkHomeWidgetSync> createState() => _PkHomeWidgetSyncState();
}

class _PkHomeWidgetSyncState extends State<PkHomeWidgetSync> {
  PockitoAppViewModel? _viewModel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final viewModel = context.read<PockitoAppViewModel>();
    if (identical(viewModel, _viewModel)) return;
    _viewModel?.removeListener(_push);
    _viewModel = viewModel..addListener(_push);
    WidgetsBinding.instance.addPostFrameCallback((_) => _push());
  }

  @override
  void dispose() {
    _viewModel?.removeListener(_push);
    super.dispose();
  }

  void _push() {
    if (!mounted) return;
    final repo = _viewModel!.repository;
    PkHomeWidgetBridge.push(
      PkHomeWidgetData.from(
        repo,
        _viewModel!.selectedMonth,
      ).toPayload(PkStrings.of(context), repo),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// How much room the widget has.
enum PkWidgetSize { small, medium, large }

/// Pushes the widget's figures to the platform, so the home screen shows the
/// same numbers the app does.
///
/// The channel is one-way and cheap: the app hands over already-formatted
/// strings whenever its data changes, and the native side stores and redraws.
abstract final class PkHomeWidgetBridge {
  static const _channel = MethodChannel('app.pockito/widget'); // i18n-exempt

  @visibleForTesting
  static MethodChannel get channel => _channel;

  static Future<void> push(Map<String, String> payload) async {
    try {
      await _channel.invokeMethod<void>('update', payload);
    } on MissingPluginException {
      // The widget host is not present — on web, in tests, or on a platform
      // without home-screen widgets. Nothing to do, and nothing is wrong.
    } on PlatformException {
      // The widget failed to redraw. The app is unaffected, so this must not
      // surface as an error to the user.
    }
  }
}

/// Exactly what the home-screen widget renders.
///
/// Shared by the in-app preview and the platform widget, so the design is
/// reviewed and the implementation is checked against one source rather than
/// two that drift.
class PkHomeWidgetSurface extends StatelessWidget {
  const PkHomeWidgetSurface({
    super.key,
    required this.data,
    required this.size,
  });

  final PkHomeWidgetData data;
  final PkWidgetSize size;

  @override
  Widget build(BuildContext context) {
    final compact = size == PkWidgetSize.small;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: PkGradients.hero,
        borderRadius: BorderRadius.circular(PkRadius.hero),
      ),
      // A home-screen widget is a fixed canvas the OS gives us: it cannot
      // grow with the reader's text size the way a screen can, so the preview
      // shows the truth by scaling its contents down inside the same box.
      child: MediaQuery.withNoTextScaling(
        child: Padding(
          padding: EdgeInsets.all(compact ? PkSpacing.x3 : PkSpacing.x4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const PkMark(size: 20),
                  const SizedBox(width: PkSpacing.x2),
                  Expanded(
                    child: Text(
                      compact ? data.currency : context.t.homeNetWorth,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                  // Only shown when something is actually waiting, so the badge
                  // never becomes background noise.
                  if (data.waitingCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .22),
                        borderRadius: BorderRadius.circular(PkRadius.full),
                      ),
                      child: Text(
                        '${data.waitingCount}',
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                PkFormat.money(data.netWorthMinor, data.currency),
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style:
                    (compact
                            ? Theme.of(context).textTheme.titleLarge
                            : Theme.of(context).textTheme.headlineMedium)
                        ?.copyWith(
                          color: Colors.white,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
              ),
              if (!compact) ...[
                const SizedBox(height: PkSpacing.x3),
                Divider(color: Colors.white.withValues(alpha: .18), height: 1),
                const SizedBox(height: PkSpacing.x3),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.t.homeSpent,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: Colors.white60),
                          ),
                          Text(
                            PkFormat.money(data.spentMinor, data.currency),
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: PkSpacing.x3),
                    Flexible(
                      child: PkComparisonLabel(
                        comparison: data.comparison,
                        compact: true,
                        onLight: true,
                      ),
                    ),
                  ],
                ),
              ],
              if (size == PkWidgetSize.large && data.topDebt != null) ...[
                const SizedBox(height: PkSpacing.x3),
                Divider(color: Colors.white.withValues(alpha: .18), height: 1),
                const SizedBox(height: PkSpacing.x3),
                Row(
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      size: PkSize.iconSmall,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: PkSpacing.x2),
                    Expanded(
                      child: Text(
                        data.debtText(
                          context.t,
                          context.read<PockitoAppViewModel>().repository,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// The widget as the user will see it, at every size the platforms offer.
///
/// A home-screen widget cannot be reviewed on the home screen until it ships,
/// so it is reviewed here — from the same data and the same surface the
/// platform widget renders.
class HomeWidgetPreviewScreen extends StatelessWidget {
  const HomeWidgetPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final data = PkHomeWidgetData.from(
      viewModel.repository,
      viewModel.selectedMonth,
    );
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.widgetTitle),
        actions: [
          IconButton(
            key: const ValueKey('widget_push'),
            tooltip: context.t.widgetRefresh,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () async {
              await PkHomeWidgetBridge.push(
                data.toPayload(context.t, viewModel.repository),
              );
              if (context.mounted) {
                showPkSuccessToast(context, context.t.widgetPushed);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(PkSpacing.screen),
        children: [
          Text(
            context.t.widgetIntro,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
          const SizedBox(height: PkSpacing.x5),
          for (final entry in const {
            PkWidgetSize.small: (155.0, 155.0),
            PkWidgetSize.medium: (329.0, 155.0),
            PkWidgetSize.large: (329.0, 210.0),
          }.entries) ...[
            Text(switch (entry.key) {
              PkWidgetSize.small => context.t.widgetSizeSmall,
              PkWidgetSize.medium => context.t.widgetSizeMedium,
              PkWidgetSize.large => context.t.widgetSizeLarge,
            }, style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: PkSpacing.x2),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: SizedBox(
                key: ValueKey('widget_${entry.key.name}'),
                width: entry.value.$1,
                height: entry.value.$2,
                child: PkHomeWidgetSurface(data: data, size: entry.key),
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
          ],
          OutlinedButton.icon(
            key: const ValueKey('widget_open_app'),
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.open_in_new_rounded),
            label: Text(context.t.widgetTapOpens),
          ),
        ],
      ),
    );
  }
}
