import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

class AiConnectionsScreen extends StatelessWidget {
  const AiConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.aiIntegrations),
        actions: [
          IconButton(
            onPressed: () => context.push('/ai/connect'),
            tooltip: context.t.connectAnApp,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      body: PkPage(
        bottomPadding: 32,
        slivers: [
          // Section 7.18: AI Connections opens with a *compact* trust note. A
          // 96 px mascot card on every visit is reassurance the reader has
          // already had; the words still carry the promise.
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(
              context.gutter,
              PkSpacing.x2,
              context.gutter,
              PkSpacing.section,
            ),
            sliver: SliverToBoxAdapter(
              child: KitoMessage(
                title: context.t.youStayInControl,
                message: context.t.kitoSurfacesAiInsightsBut,
                asset: KitoAsset.thinking,
                compact: true,
              ),
            ),
          ),
          // Three things a traditional UI is genuinely slower at. Not a
          // chat box: each one is a question with a defined answer, computed
          // from the same records every other screen reads.
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(title: context.t.aiSectionTitle),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsetsDirectional.fromSTEB(
              PkSpacing.screen,
              0,
              PkSpacing.screen,
              PkSpacing.x6,
            ),
            sliver: SliverToBoxAdapter(
              child: PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.iconLarge + PkSpacing.x3,
                children: [
                  PkLedgerRow.management(
                    key: const ValueKey('ai_explain_month'),
                    leading: const Icon(
                      Icons.insights_rounded,
                      size: PkSize.iconLarge,
                    ),
                    title: context.t.aiExplainMonth,
                    subtitle: context.t.aiExplainMonthDetail,
                    showChevron: true,
                    onTap: () => _explainMonth(context),
                  ),
                  PkLedgerRow.management(
                    key: const ValueKey('ai_compare_months'),
                    leading: const Icon(
                      Icons.compare_arrows_rounded,
                      size: PkSize.iconLarge,
                    ),
                    title: context.t.aiCompareMonths,
                    subtitle: context.t.aiCompareMonthsDetail,
                    showChevron: true,
                    onTap: () => _compareMonths(context),
                  ),
                  PkLedgerRow.management(
                    key: const ValueKey('ai_flag_unusual'),
                    leading: const Icon(
                      Icons.priority_high_rounded,
                      size: PkSize.iconLarge,
                    ),
                    title: context.t.aiFlagUnusual,
                    subtitle: context.t.aiFlagUnusualDetail,
                    showChevron: true,
                    onTap: () => _flagUnusual(context),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: PkSpacing.screen),
            sliver: SliverToBoxAdapter(
              child: PkSectionHeader(
                title: context.t.connections,
                actionLabel: context.t.activityTitle,
                onAction: () => context.push('/ai/activity'),
              ),
            ),
          ),
          if (repo.aiConnections.isEmpty)
            SliverToBoxAdapter(
              child: PkEmptyState(
                icon: Icons.auto_awesome_outlined,
                mascot: KitoAsset.thinking,
                title: context.t.noConnectedApps,
                message: context.t.connectAnAiApplicationAnd,
                actionLabel: context.t.connectAnApp,
                onAction: () => context.push('/ai/connect'),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              sliver: SliverToBoxAdapter(
                child: PkGroupedSurface(
                  indent: PkSpacing.x4 + PkSize.iconTileFeature + PkSpacing.x3,
                  children: [
                    for (final connection in repo.aiConnections)
                      PkLedgerRow(
                        semanticIdentifier: 'ai_connection_${connection.id}',
                        leading: _AiMark(name: connection.name),
                        title: connection.name,
                        badges: [
                          if (connection.verified)
                            PkStatusBadge(
                              label: context.t.aiVerified,
                              tone: PkStatusTone.info,
                              icon: Icons.verified_rounded,
                            ),
                        ],
                        subtitle: connection.status == 'SUSPENDED'
                            ? context.t.suspendedReviewNeeded
                            : context.t.lastUsedX0(
                                PkFormat.shortDate(
                                  connection.lastUsedAt,
                                  repo.today,
                                  context.t,
                                ),
                              ),
                        showChevron: true,
                        onTap: () => context.push('/ai/${connection.id}'),
                      ),
                  ],
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsetsDirectional.fromSTEB(
              context.gutter,
              PkSpacing.section,
              context.gutter,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/ai/connect'),
                icon: const Icon(Icons.add_link_rounded),
                label: Text(context.t.connectAnApp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// What actually happened this month, in sentences.
  ///
  /// Everything here is read from the same records the rest of the app reads
  /// — no model, no guess — so the answer can be checked against the screens
  /// it summarises.
  Future<void> _explainMonth(BuildContext context) {
    final viewModel = context.read<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final month = viewModel.selectedMonth;
    final comparison = repo.spendingComparison(month);
    final health = repo.financialHealth(month);
    final top = repo.categoryBreakdown(month, limit: 3);
    final currency = repo.profile.reportingCurrency;
    final t = context.t;
    return _showAnswer(
      context,
      title: t.aiThisMonth,
      lines: [
        t.aiSpentVs(
          PkFormat.money(comparison.currentMinor, currency),
          comparison.isFlat
              ? t.aiDirectionSame
              : comparison.isUp
              ? t.aiDirectionMore
              : t.aiDirectionLess,
          comparison.previousLabel,
          PkFormat.money(comparison.previousMinor, currency),
        ),
        if (top.isNotEmpty)
          t.aiBiggestShare(
            top.first.label,
            PkFormat.money(top.first.valueMinor, currency),
          ),
        health.netMinor >= 0
            ? t.aiKept(
                PkFormat.money(health.netMinor, currency),
                PkFormat.money(health.incomeMinor, currency),
              )
            : t.aiOverspent(PkFormat.money(health.netMinor.abs(), currency)),
        if (health.upcomingMinor > 0)
          t.aiStillDue(PkFormat.money(health.upcomingMinor, currency)),
      ],
    );
  }

  Future<void> _compareMonths(BuildContext context) {
    final viewModel = context.read<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final month = viewModel.selectedMonth;
    final previous = DateTime(month.year, month.month - 1);
    final currency = repo.profile.reportingCurrency;
    final now = {
      for (final slice in repo.categoryBreakdown(month, limit: 99))
        slice.id: slice,
    };
    final before = {
      for (final slice in repo.categoryBreakdown(previous, limit: 99))
        slice.id: slice.valueMinor,
    };
    final deltas = <(String, int)>[
      for (final id in {...now.keys, ...before.keys})
        (
          now[id]?.label ??
              repo.categoryById(id)?.name ??
              context.t.uncategorised,
          (now[id]?.valueMinor ?? 0) - (before[id] ?? 0),
        ),
    ]..sort((a, b) => b.$2.abs().compareTo(a.$2.abs()));
    final t = context.t;
    return _showAnswer(
      context,
      title: t.aiAgainstLastMonth,
      lines: [
        for (final delta in deltas.take(6))
          delta.$2 >= 0
              ? t.aiDeltaUp(delta.$1, PkFormat.money(delta.$2.abs(), currency))
              : t.aiDeltaDown(
                  delta.$1,
                  PkFormat.money(delta.$2.abs(), currency),
                ),
        if (deltas.isEmpty) t.aiNothingToCompare,
      ],
    );
  }

  Future<void> _flagUnusual(BuildContext context) {
    final viewModel = context.read<PockitoAppViewModel>();
    final repo = viewModel.repository;
    final health = repo.financialHealth(viewModel.selectedMonth);
    final currency = repo.profile.reportingCurrency;
    final t = context.t;
    return _showAnswer(
      context,
      title: t.aiAnythingUnusual,
      lines: health.unusual.isEmpty
          ? [t.aiNothingUnusual]
          : [
              for (final slice in health.unusual)
                t.aiUnusualLine(
                  slice.label,
                  PkFormat.money(slice.valueMinor, currency),
                ),
            ],
    );
  }

  Future<void> _showAnswer(
    BuildContext context, {
    required String title,
    required List<String> lines,
  }) => showPkSheet<void>(
    context,
    builder: (context) => PkSheetScaffold(
      title: title,
      subtitle: context.t.aiAnswerFootnote,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: PkSpacing.x2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: context.pk.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: PkSpacing.x3),
                  Expanded(
                    child: Text(
                      line,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

class ConnectAiScreen extends StatelessWidget {
  const ConnectAiScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final apps = [
      ('ChatGPT', true, context.t.verifiedByPockito),
      ('Claude', true, context.t.verifiedByPockito),
      (context.t.customMcpClient, false, context.t.unverifiedClient),
    ];
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.connectAnApp)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            Text(
              context.t.chooseAnApplication,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: PkSpacing.x2),
            Text(
              context.t.thisPrototypeSimulatesAuthorizationNo,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
            ),
            const SizedBox(height: PkSpacing.x5),
            ...apps.map(
              (app) => Padding(
                padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                child: PkCard(
                  onTap: () => context.push(
                    '/ai/authorize?client=${Uri.encodeComponent(app.$1)}&verified=${app.$2}',
                  ),
                  child: Row(
                    children: [
                      _AiMark(name: app.$1),
                      const SizedBox(width: PkSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    app.$1,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                ),
                                if (app.$2) ...[
                                  const SizedBox(width: 5),
                                  const Icon(
                                    Icons.verified_rounded,
                                    color: PkPalette.indigo600,
                                    size: 17,
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              app.$3,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AiAuthorizationScreen extends StatefulWidget {
  const AiAuthorizationScreen({
    super.key,
    required this.client,
    required this.verified,
  });
  final String client;
  final bool verified;
  @override
  State<AiAuthorizationScreen> createState() => _AiAuthorizationScreenState();
}

class _AiAuthorizationScreenState extends State<AiAuthorizationScreen> {
  bool _accounts = true;
  bool _transactions = true;
  bool _spaces = true;
  bool _analytics = true;
  bool _writes = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(
      title: Text(context.t.authorizationRequest),
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          onPressed: () => context.pop(),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.all(PkSpacing.screen),
            children: [
              Row(
                children: [
                  _AiMark(name: widget.client, size: 56),
                  const SizedBox(width: PkSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.client,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                              ),
                            ),
                            if (widget.verified) ...[
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified_rounded,
                                color: PkPalette.indigo600,
                              ),
                            ],
                          ],
                        ),
                        Text(
                          widget.verified
                              ? context.t.verifiedApplication
                              : context.t.unverifiedApplicationUseExtraCare,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: widget.verified
                                    ? context.pk.textSecondary
                                    : context.pk.warning,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.x5),
              Text(
                context.t.allowAccessToPockito,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                context.t.chooseTheMinimumAccessThis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.pk.textSecondary,
                ),
              ),
              const SizedBox(height: PkSpacing.x5),
              PkCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      title: Text(context.t.navAccounts),
                      subtitle: Text(context.t.namesTypesCurrenciesAndBalances),
                      value: _accounts,
                      onChanged: (value) => setState(() => _accounts = value),
                    ),
                    SwitchListTile.adaptive(
                      title: Text(context.t.transactions),
                      subtitle: Text(context.t.moneyEventsAndCategories),
                      value: _transactions,
                      onChanged: (value) =>
                          setState(() => _transactions = value),
                    ),
                    SwitchListTile.adaptive(
                      title: Text(context.t.spacesBalances),
                      subtitle: Text(context.t.sharedExpensesAndWhoOwes),
                      value: _spaces,
                      onChanged: (value) => setState(() => _spaces = value),
                    ),
                    SwitchListTile.adaptive(
                      title: Text(context.t.analytics),
                      subtitle: Text(
                        context.t.calculatedSpendingAndBudgetSummaries,
                      ),
                      value: _analytics,
                      onChanged: (value) => setState(() => _analytics = value),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PkSpacing.section),
              // Section 7.18: write permission is plainly separated from read
              // access and carries warning treatment — it is the one choice on
              // this screen that can change the reader's money.
              PkCard(
                variant: _writes
                    ? PkCardVariant.raised
                    : PkCardVariant.standard,
                color: _writes ? context.pk.sharedSurface : null,
                borderColor: _writes ? context.pk.sharedBorder : null,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      key: const ValueKey('ai_allow_writes'),
                      contentPadding: EdgeInsets.zero,
                      // Colour is not the carrier: the row says "can change
                      // your money" whether or not it is switched on.
                      secondary: Icon(
                        Icons.edit_note_rounded,
                        color: _writes
                            ? context.pk.warning
                            : context.pk.textSecondary,
                      ),
                      title: Text(
                        context.t.allowFinancialChanges,
                        style: context.pkText.rowTitle,
                      ),
                      subtitle: Text(context.t.createAndUpdateExpensesOr),
                      value: _writes,
                      onChanged: (value) => setState(() => _writes = value),
                    ),
                    if (_writes) ...[
                      const SizedBox(height: PkSpacing.x2),
                      PkInlineNotice(
                        icon: Icons.verified_user_outlined,
                        tone: PkStatusTone.warning,
                        message: context.t.writesArePreviewedFirstHigh,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: PkSpacing.stateGroup),
              // Section 6.9: 52 is for the final action of an authorization,
              // which this is.
              SizedBox(
                height: PkSize.buttonFinal,
                child: FilledButton(
                  onPressed: _authorize,
                  child: Text(context.t.allowX0(widget.client)),
                ),
              ),
              const SizedBox(height: PkSpacing.x2),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(context.t.donTAllow),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _authorize() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final scopes = <String>[
      if (_accounts) 'Accounts',
      if (_transactions) context.t.transactions,
      if (_spaces) context.t.spacesBalances,
      if (_analytics) context.t.analytics,
      if (_writes) context.t.financialChanges,
    ];
    final id = 'con_${DateTime.now().microsecondsSinceEpoch}';
    await repo.saveAiConnection(
      AiConnection(
        id: id,
        name: widget.client,
        status: 'ACTIVE',
        scopes: scopes,
        createdAt: repo.today,
        lastUsedAt: repo.today,
        verified: widget.verified,
      ),
    );
    if (mounted) context.go('/ai/$id');
  }
}

class AiConnectionDetailScreen extends StatelessWidget {
  const AiConnectionDetailScreen({super.key, required this.connectionId});
  final String connectionId;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final connection = repo.aiConnections
        .where((item) => item.id == connectionId)
        .firstOrNull;
    if (connection == null) {
      return Scaffold(
        appBar: PkAppBar(),
        body: PkEmptyState(
          icon: Icons.link_off_rounded,
          title: context.t.connectionNotFound,
          message: context.t.itMayHaveBeenDisconnected,
        ),
      );
    }
    return Scaffold(
      appBar: PkAppBar(title: Text(connection.name)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            Center(
              child: Column(
                children: [
                  _AiMark(name: connection.name, size: 72),
                  const SizedBox(height: PkSpacing.x3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        connection.status == 'ACTIVE'
                            ? context.t.connected
                            : context.t.suspended,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: connection.status == 'ACTIVE'
                              ? context.pk.owed
                              : context.pk.danger,
                        ),
                      ),
                      if (connection.verified) ...[
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.verified_rounded,
                          color: PkPalette.indigo600,
                          size: 18,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkCard(
              child: Column(
                children: [
                  _InfoRow(
                    label: context.t.connected,
                    value: PkFormat.longDate(connection.createdAt, context.t),
                  ),
                  _InfoRow(
                    label: context.t.lastUsed,
                    value: PkFormat.longDate(connection.lastUsedAt, context.t),
                  ),
                  _InfoRow(
                    label: context.t.reads,
                    value: '${connection.readCount}',
                  ),
                  _InfoRow(
                    label: context.t.writes,
                    value: '${connection.writeCount}',
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            PkSectionHeader(
              title: context.t.permissions,
              actionLabel: context.t.edit,
              onAction: () => _editPermissions(context, connection),
            ),
            PkCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: connection.scopes
                    .map(
                      (scope) => ListTile(
                        leading: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: PkPalette.indigo600,
                        ),
                        title: Text(scope),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: PkSpacing.x6),
            OutlinedButton.icon(
              onPressed: () => _disconnect(context, connection),
              icon: const Icon(Icons.link_off_rounded),
              label: Text(context.t.disconnectApp),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editPermissions(
    BuildContext context,
    AiConnection connection,
  ) async {
    var scopes = {...connection.scopes};
    final saved = await showPkSheet<Set<String>>(
      context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.x4,
            0,
            PkSpacing.x4,
            PkSpacing.x6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.t.connectionPermissions,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: PkSpacing.x4),
              ...[
                'Accounts',
                context.t.transactions,
                context.t.spacesBalances,
                context.t.analytics,
                context.t.financialChanges,
              ].map(
                (scope) => CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(scope),
                  value: scopes.contains(scope),
                  onChanged: (value) => setState(
                    () => value! ? scopes.add(scope) : scopes.remove(scope),
                  ),
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              FilledButton(
                onPressed: () => Navigator.pop(context, scopes),
                child: Text(context.t.savePermissions),
              ),
            ],
          ),
        ),
      ),
    );
    if (saved != null && context.mounted) {
      await context.read<PockitoAppViewModel>().repository.saveAiConnection(
        connection.copyWith(scopes: saved.toList()),
      );
    }
  }

  Future<void> _disconnect(
    BuildContext context,
    AiConnection connection,
  ) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.disconnectX0(connection.name)),
        content: Text(context.t.theAppLosesAccessImmediately),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.pk.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.disconnect),
          ),
        ],
      ),
    );
    if (accepted != true || !context.mounted) return;
    await context.read<PockitoAppViewModel>().repository.disconnectAiConnection(
      connection.id,
    );
    if (context.mounted) context.go('/ai');
  }
}

class AiActivityScreen extends StatelessWidget {
  const AiActivityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final attributed = repo.transactions
        .where((item) => item.source == 'mcp')
        .toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.aiActivity)),
      body: attributed.isEmpty
          ? PkEmptyState(
              icon: Icons.auto_awesome_outlined,
              title: context.t.noAiActivity,
              message: context.t.readsAndWritesFromConnected,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(PkSpacing.screen),
              itemCount: attributed.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: PkSpacing.x2),
              itemBuilder: (context, index) {
                if (index == attributed.length) {
                  return PkCard(
                    color: PkPalette.rose50,
                    borderColor: PkPalette.rose400.withValues(alpha: .3),
                    child: Row(
                      children: [
                        Icon(Icons.block_rounded, color: context.pk.danger),
                        const SizedBox(width: PkSpacing.x3),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.t.blockedMemberInvitation,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                context
                                    .t
                                    .financeSidekickOutsideGrantedCapabilities,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final transaction = attributed[index];
                return PkCard(
                  onTap: () => context.push('/activity/${transaction.id}'),
                  child: Row(
                    children: [
                      _AiMark(name: transaction.client ?? 'AI', size: 42),
                      const SizedBox(width: PkSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.t.addedX0(transaction.merchant),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${transaction.client ?? 'AI'} · ${PkFormat.shortDate(transaction.occurredOn, repo.today, context.t)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      PkAmountText(
                        amountMinor: transaction.amountMinor,
                        currency: transaction.currency,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class AiApprovalsScreen extends StatelessWidget {
  const AiApprovalsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final pending = repo.aiApprovals
        .where((item) => item.state == 'PENDING')
        .toList();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.pendingApprovals)),
      body: pending.isEmpty
          ? PkEmptyState(
              icon: Icons.verified_user_outlined,
              title: context.t.nothingNeedsApproval,
              message: context.t.highImpactActionsRequestedBy,
            )
          : ListView.separated(
              padding: const EdgeInsets.all(PkSpacing.screen),
              itemCount: pending.length,
              separatorBuilder: (_, _) => const SizedBox(height: PkSpacing.x3),
              itemBuilder: (context, index) =>
                  _ApprovalCard(approval: pending[index]),
            ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({required this.approval});
  final AiApproval approval;
  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final space = repo.spaceById(approval.spaceId)!;
    return PkCard(
      borderColor: context.pk.sharedBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AiMark(name: approval.client),
              const SizedBox(width: PkSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      approval.client,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      context.t.requestsYourApproval,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(context.t.pending),
                backgroundColor: context.pk.sharedSurface,
                labelStyle: TextStyle(color: context.pk.sharedStrong),
              ),
            ],
          ),
          const SizedBox(height: PkSpacing.x5),
          Text(
            approval.summary,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: PkSpacing.x3),
          Text(
            approval.reason,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
          ),
          const SizedBox(height: PkSpacing.x4),
          PkCard(
            color: context.pk.sharedSurface,
            borderColor: context.pk.sharedBorder,
            child: Column(
              children: [
                _InfoRow(label: context.t.spaceLabel, value: space.name),
                _InfoRow(
                  label: context.t.from,
                  value: repo.userById(approval.fromUserId)?.name ?? 'Member',
                ),
                _InfoRow(
                  label: context.t.to,
                  value: repo.userById(approval.toUserId)?.isYou == true
                      ? context.t.you
                      : repo.userById(approval.toUserId)?.name ?? 'Member',
                ),
                _InfoRow(
                  label: context.t.amount,
                  value: PkFormat.money(approval.amountMinor, space.currency),
                ),
                _InfoRow(
                  label: context.t.recordedOn,
                  value:
                      repo.accountById(approval.accountId)?.name ?? 'Account',
                ),
              ],
            ),
          ),
          const SizedBox(height: PkSpacing.x4),
          Text(
            approval.impact,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.pk.textSecondary),
          ),
          const SizedBox(height: PkSpacing.x5),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _reject(context),
                  child: Text(context.t.reject),
                ),
              ),
              const SizedBox(width: PkSpacing.x3),
              Expanded(
                child: FilledButton(
                  onPressed: () => _approve(context),
                  child: Text(context.t.approve),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _approve(BuildContext context) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.approveAiApproval(approval.id);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.approvedAndRecorded)));
    }
  }

  Future<void> _reject(BuildContext context) async {
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.rejectAiApproval(approval.id);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.requestRejected)));
    }
  }
}

class _AiMark extends StatelessWidget {
  const _AiMark({required this.name, this.size = 48});
  final String name;
  final double size;
  @override
  Widget build(BuildContext context) {
    final lower = name.toLowerCase();
    final color = lower.contains('chat')
        ? PkPalette.slate900
        : lower.contains('claude')
        ? const Color(0xFFD97757)
        : PkPalette.indigo600;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(PkRadius.medium),
      ),
      child: Icon(
        lower.contains('chat')
            ? Icons.auto_awesome_rounded
            : lower.contains('claude')
            ? Icons.flare_rounded
            : Icons.memory_rounded,
        color: Colors.white,
        size: size * .48,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ],
    ),
  );
}
