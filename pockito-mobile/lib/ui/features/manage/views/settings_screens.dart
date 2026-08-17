import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_format.dart';
import '../../../core/design_system/pk_labels.dart';
import '../../../core/design_system/pk_tokens.dart';

/// The More hub: every surface that is not one of the three money destinations.
///
/// This is the screen that used to be reachable only from the small avatar on
/// Home. Promoting it to a primary destination is what made Budgets,
/// Subscriptions, Categories and Connections discoverable.
class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    // Same header treatment as the other three primary destinations, so the
    // four branch roots read as one product rather than three plus a settings
    // page.
    return PkPage(
      slivers: [
        PkScreenHeader(title: context.t.navMore),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: context.gutter),
          sliver: SliverList.list(
            children: [
              // Section 7.20: the profile header is compact, not an oversized
              // card. It is one grouped row like everything below it.
              PkGroupedSurface(
                children: [
                  PkLedgerRow(
                    semanticIdentifier: 'more_profile',
                    semanticLabel:
                        '${repo.profile.displayName}, ${repo.profile.email}',
                    leading: PkAvatar(
                      label: repo.profile.displayName.characters.first,
                      size: PkSize.avatarMember,
                    ),
                    title: repo.profile.displayName,
                    subtitle: repo.profile.email,
                    showChevron: true,
                    onTap: () => context.push('/settings/profile'),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.section),
              _SettingsGroup(
                title: context.t.money,
                items: [
                  _SettingsItem(
                    icon: Icons.schedule_outlined,
                    title: context.t.activityTitle,
                    subtitle: context.t.x0MoneyEvents(repo.transactions.length),
                    route: '/activity',
                  ),
                  _SettingsItem(
                    icon: Icons.donut_large_outlined,
                    title: context.t.budgetsTitle,
                    subtitle: context.t.budgetCount(repo.budgets.length),
                    route: '/budgets',
                  ),
                  _SettingsItem(
                    icon: Icons.autorenew_rounded,
                    title: context.t.subscriptions,
                    subtitle: context.t.x0Active(
                      repo.subscriptions
                          .where(
                            (item) => item.status == SubscriptionStatus.active,
                          )
                          .length,
                    ),
                    route: '/subscriptions',
                  ),
                  _SettingsItem(
                    icon: Icons.category_outlined,
                    title: context.t.categories,
                    subtitle: context.t.categoryCount(repo.categories.length),
                    route: '/categories',
                  ),
                  _SettingsItem(
                    icon: Icons.sell_outlined,
                    title: context.t.tags,
                    subtitle: repo.tags.isEmpty
                        ? context.t.cutAcrossCategoriesBerlinTrip
                        : context.t.tagCount(repo.tags.length),
                    route: '/tags',
                  ),
                  _SettingsItem(
                    icon: Icons.credit_card_outlined,
                    title: context.t.paymentMethods,
                    subtitle: repo.paymentMethods.isEmpty
                        ? context.t.answerHowMuchWentOn
                        : context.t.methodCount(repo.paymentMethods.length),
                    route: '/payment-methods',
                  ),
                  _SettingsItem(
                    icon: Icons.widgets_outlined,
                    title: context.t.widgetTitle,
                    subtitle: context.t.netWorthAndThisMonth,
                    route: '/widget',
                  ),
                  _SettingsItem(
                    icon: Icons.import_export_rounded,
                    title: context.t.importExport,
                    subtitle: context.t.csvInCsvOrJson,
                    route: '/data',
                  ),
                  _SettingsItem(
                    icon: Icons.currency_exchange_rounded,
                    title: context.t.defaultCurrency,
                    subtitle: context.t.x0ReportingOnly(
                      repo.profile.reportingCurrency,
                    ),
                    route: '/settings/currency',
                  ),
                  _SettingsItem(
                    icon: Icons.sync_alt_rounded,
                    title: context.t.exchangeRates,
                    subtitle: repo.fxSettings.mode == FxRateMode.automatic
                        ? context.t.automaticX0(
                            repo.fxSettings.provider.labelIn(context.t),
                          )
                        : context.t.manualRates,
                    route: '/settings/exchange-rates',
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.section),
              _SettingsGroup(
                title: context.t.connected,
                items: [
                  _SettingsItem(
                    icon: Icons.auto_awesome_outlined,
                    title: context.t.aiIntegrations,
                    subtitle: context.t.connectionCount(
                      repo.aiConnections.length,
                    ),
                    route: '/ai',
                  ),
                  _SettingsItem(
                    icon: Icons.notifications_none_rounded,
                    title: context.t.notifications,
                    subtitle: context.t.budgetsSharedMoneyAndApprovals,
                    route: '/settings/notifications',
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.section),
              // Section 2.4: privacy mode masks every amount while keeping the
              // layout, so a glance over the shoulder sees the shape of the
              // screen and none of the numbers.
              PkGroupedSurface(
                indent: PkSpacing.x4 + PkSize.iconLarge + PkSpacing.x3,
                children: [
                  PkLedgerRow.management(
                    leading: Icon(
                      repo.profile.balancesHidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: PkSize.iconLarge,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: context.t.privacyHideBalances,
                    subtitle: context.t.privacyHideBalancesDetail,
                    trailing: Switch.adaptive(
                      key: const ValueKey('hide_balances'),
                      value: repo.profile.balancesHidden,
                      onChanged: (value) => repo.saveProfile(
                        repo.profile.copyWith(balancesHidden: value),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: PkSpacing.section),
              _SettingsGroup(
                title: context.t.preferences,
                items: [
                  _SettingsItem(
                    icon: Icons.brightness_6_outlined,
                    title: context.t.appearance,
                    subtitle: repo.profile.themeMode.name,
                    route: '/settings/appearance',
                  ),
                  _SettingsItem(
                    icon: Icons.language_rounded,
                    title: context.t.language,
                    subtitle: repo.profile.language == 'Japanese'
                        ? '日本語'
                        : repo.profile.language,
                    route: '/settings/language',
                  ),
                  _SettingsItem(
                    icon: Icons.info_outline_rounded,
                    title: context.t.aboutPockito,
                    subtitle: context.t.aboutVersion,
                    route: '/settings/about',
                  ),
                ],
              ),
              // Definition of done, item 15: no prototype or debug surface is
              // exposed in a release build. The switch and everything behind it
              // are compiled out entirely rather than merely defaulted off — a
              // preference the user could flip is still an exposed surface.
              if (kPkDebugSurfaces) ...[
                const SizedBox(height: PkSpacing.section),
                PkGroupedSurface(
                  children: [
                    PkLedgerRow.management(
                      title: context.t.prototypeTools,
                      subtitle: context.t.replayOnboardingPreviewAnInvite,
                      trailing: Switch.adaptive(
                        key: const ValueKey('debug_tools'),
                        value: repo.profile.debugToolsEnabled,
                        onChanged: (value) => repo.saveProfile(
                          repo.profile.copyWith(debugToolsEnabled: value),
                        ),
                      ),
                    ),
                  ],
                ),
                if (repo.profile.debugToolsEnabled) ...[
                  const SizedBox(height: PkSpacing.section),
                  _SettingsGroup(
                    title: context.t.prototype,
                    items: [
                      _SettingsItem(
                        icon: Icons.play_circle_outline_rounded,
                        title: context.t.replayOnboarding,
                        subtitle: context.t.exploreTheFirstRunExperience,
                        route: '/onboarding',
                      ),
                      _SettingsItem(
                        icon: Icons.mark_email_unread_outlined,
                        title: context.t.invitationReview,
                        subtitle: context.t.previewAnIncomingSpaceInvite,
                        route: '/invite-review',
                      ),
                      _SettingsItem(
                        icon: Icons.grid_view_rounded,
                        title: context.t.stateCatalogue,
                        subtitle: context.t.loadingEmptyErrorAndOffline,
                        route: '/settings/states',
                      ),
                    ],
                  ),
                ],
              ],
              const SizedBox(height: PkSpacing.section),
              // Destructive and reset actions sit apart from the preferences
              // above them, per section 7.20.
              OutlinedButton.icon(
                onPressed: () => _reset(context),
                icon: const Icon(Icons.restart_alt_rounded),
                label: Text(context.t.resetPrototypeData),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _reset(BuildContext context) async {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.t.resetAllPrototypeData),
        content: Text(context.t.everyLocalChangeIsReplaced),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.t.reset),
          ),
        ],
      ),
    );
    if (accepted != true || !context.mounted) return;
    await context.read<PockitoAppViewModel>().repository.reset();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.prototypeDataReset)));
    }
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _name;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    final profile = context.read<PockitoAppViewModel>().repository.profile;
    _name = TextEditingController(text: profile.displayName);
    _email = TextEditingController(text: profile.email);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(title: Text(context.t.editProfile)),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            padding: const EdgeInsets.all(PkSpacing.screen),
            children: [
              Align(
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    PkAvatar(
                      label: _name.text.isEmpty
                          ? 'G'
                          : _name.text.characters.first,
                      size: 80,
                    ),
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: IconButton.filled(
                        tooltip: context.t.changeAvatar,
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  context.t.avatarColoursRotateLocallyIn,
                                ),
                              ),
                            ),
                        icon: const Icon(Icons.edit_rounded, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: PkSpacing.x6),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: context.t.displayName),
              ),
              const SizedBox(height: PkSpacing.x4),
              TextField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: context.t.email),
              ),
              const SizedBox(height: PkSpacing.x4),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: context.t.country,
                  hintText: context.t.profileSampleCountry,
                ),
              ),
              const SizedBox(height: PkSpacing.x8),
              FilledButton(
                onPressed: _save,
                child: Text(context.t.saveProfile),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _save() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.saveProfile(
      repo.profile.copyWith(
        displayName: _name.text.trim(),
        email: _email.text.trim(),
      ),
    );
    if (mounted) context.pop();
  }
}

class CurrencySettingsScreen extends StatelessWidget {
  const CurrencySettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final current = PockitoCurrencies.of(repo.profile.reportingCurrency);
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.defaultCurrency)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkCard(
              color: PkPalette.indigo50,
              borderColor: PkPalette.indigo100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    color: PkPalette.indigo600,
                  ),
                  const SizedBox(width: PkSpacing.x3),
                  Expanded(
                    child: Text(
                      context.t.thisChangesReportingTotalsOnly,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PkPalette.indigo700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x4),
            // A searchable picker with recents and flags: a plain dropdown of
            // thirty currencies is a scroll, not a choice.
            PkCard(
              child: ListTile(
                key: const ValueKey('pick_reporting_currency'),
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  current.flag.isEmpty ? current.symbol : current.flag,
                  // pk-exempt: a flag glyph is artwork sized to the row, not
                  // type on the reading scale.
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text('${current.code} · ${current.name}'),
                subtitle: Text(
                  repo.fxQuote(current.code, current.code) == null
                      ? context.t.currencyNoRate
                      : context.t.currencyAvailable(
                          PockitoCurrencies.all.length,
                        ),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () async {
                  final picked = await showPkCurrencyPicker(
                    context,
                    repo: repo,
                    selectedCode: repo.profile.reportingCurrency,
                  );
                  if (picked == null || !context.mounted) return;
                  await PkGuardedAction.run(
                    context,
                    () => repo.saveProfile(
                      repo.profile.copyWith(
                        reportingCurrency: picked,
                        // Remember what was picked so the next choice is faster.
                        recentCurrencies: [
                          picked,
                          ...repo.profile.recentCurrencies.where(
                            (code) => code != picked,
                          ),
                        ].take(5).toList(),
                      ),
                    ),
                    successMessage: context.t.reportingInX0(picked),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExchangeRatesScreen extends StatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  State<ExchangeRatesScreen> createState() => _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends State<ExchangeRatesScreen> {
  late FxRateMode _mode;
  final _controllers = <String, TextEditingController>{};

  @override
  void initState() {
    super.initState();
    final repo = context.read<PockitoAppViewModel>().repository;
    _mode = repo.fxSettings.mode;
    final base = repo.profile.reportingCurrency;
    final targets = {
      'EUR',
      'USD',
      'TND',
      ...repo.accounts.map((account) => account.currency),
    }..remove(base);
    for (final target in targets) {
      final key = '${base}_$target';
      final rate =
          repo.fxSettings.manualRates[key] ?? repo.fxQuote(base, target)?.rate;
      _controllers[key] = TextEditingController(
        text: rate == null ? '' : rate.toStringAsPrecision(7),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final base = repo.profile.reportingCurrency;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.exchangeRates)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSpacing.screen,
            PkSpacing.x2,
            PkSpacing.screen,
            PkSpacing.x8,
          ),
          children: [
            Text(
              context.t.howShouldPockitoConvertCurrencies,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: PkSpacing.x2),
            Text(
              context.t.originalAmountsAreAlwaysPreserved,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: PkSpacing.x5),
            SegmentedButton<FxRateMode>(
              key: const ValueKey('fx_mode'),
              segments: [
                ButtonSegment(
                  value: FxRateMode.automatic,
                  icon: Icon(Icons.autorenew_rounded),
                  label: Text(context.t.automatic),
                ),
                ButtonSegment(
                  value: FxRateMode.manual,
                  icon: Icon(Icons.edit_outlined),
                  label: Text(context.t.manual),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (value) => _changeMode(value.first),
            ),
            const SizedBox(height: PkSpacing.x5),
            if (_mode == FxRateMode.automatic)
              PkCard(
                color: PkPalette.indigo50,
                borderColor: PkPalette.indigo100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.verified_outlined),
                      title: Text(context.t.automaticSnapshotActive),
                      subtitle: Text(context.t.mockedLocallyForThePrototype),
                    ),
                    Text(
                      context.t.providerX0(
                        repo.fxSettings.provider.labelIn(context.t),
                      ),
                    ),
                    Text(
                      context.t.lastUpdatedX0(
                        PkFormat.longDate(
                          repo.fxSettings.lastUpdatedAt,
                          context.t,
                        ),
                      ),
                    ),
                    const SizedBox(height: PkSpacing.x3),
                    ..._controllers.keys.map((key) {
                      final parts = key.split('_');
                      final quote = repo.fxQuote(parts[0], parts[1]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: PkSpacing.x2),
                        child: Text(
                          '1 ${parts[0]} ≈ ${quote?.rate.toStringAsPrecision(6) ?? '—'} ${parts[1]}',
                        ),
                      );
                    }),
                  ],
                ),
              )
            else ...[
              PkCard(
                color: context.pk.sharedSurface,
                borderColor: context.pk.sharedBorder,
                child: Text(context.t.manualRatesRemainActiveUntil),
              ),
              const SizedBox(height: PkSpacing.x4),
              ..._controllers.entries.map((entry) {
                final target = entry.key.split('_').last;
                return Padding(
                  padding: const EdgeInsets.only(bottom: PkSpacing.x4),
                  child: TextFormField(
                    key: ValueKey('fx_rate_$target'),
                    controller: entry.value,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: context.t.l1X0InX1(base, target),
                      helperText: context.t.yourManualRate(base, target),
                    ),
                  ),
                );
              }),
              FilledButton.icon(
                key: const ValueKey('save_manual_rates'),
                onPressed: _saveManualRates,
                icon: const Icon(Icons.save_outlined),
                label: Text(context.t.saveManualRates),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _changeMode(FxRateMode mode) async {
    setState(() => _mode = mode);
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.saveFxSettings(
      repo.fxSettings.copyWith(mode: mode, lastUpdatedAt: repo.today),
    );
  }

  Future<void> _saveManualRates() async {
    final rates = <String, double>{};
    for (final entry in _controllers.entries) {
      final rate = double.tryParse(entry.value.text);
      if (rate == null || rate <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.t.enterAValidRateFor(entry.key))),
        );
        return;
      }
      rates[entry.key] = rate;
    }
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.saveFxSettings(
      repo.fxSettings.copyWith(
        mode: FxRateMode.manual,
        manualRates: rates,
        lastUpdatedAt: repo.today,
        provider: FxProvider.manualConfiguration,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.manualExchangeRatesSaved)),
      );
    }
  }
}

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    final selected = viewModel.repository.profile.themeMode;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.appearance)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkCard(
              padding: EdgeInsets.zero,
              child: RadioGroup<ThemeMode>(
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) viewModel.setThemeMode(value);
                },
                child: Column(
                  children: ThemeMode.values
                      .map(
                        (mode) => RadioListTile<ThemeMode>(
                          title: Text(
                            mode.name[0].toUpperCase() + mode.name.substring(1),
                          ),
                          subtitle: Text(
                            mode == ThemeMode.system
                                ? context.t.followYourDevice
                                : context.t.alwaysUseMode(mode.name),
                          ),
                          value: mode,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: PkSpacing.x5),
            // Haptics are a comfort setting for some people and an accessibility
            // one for others, so they get a switch rather than being assumed.
            PkCard(
              child: SwitchListTile.adaptive(
                key: const ValueKey('haptics_switch'),
                contentPadding: EdgeInsets.zero,
                title: Text(context.t.hapticsTitle),
                subtitle: Text(context.t.hapticsDetail),
                value: !viewModel.repository.profile.hapticsOff,
                onChanged: (value) => viewModel.repository.saveProfile(
                  viewModel.repository.profile.copyWith(hapticsOff: !value),
                ),
              ),
            ),
            const SizedBox(height: PkSpacing.x5),
            Text(
              context.t.preview,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: PkSpacing.x3),
            PkCard(
              child: Row(
                children: [
                  const PkMark(size: 48),
                  const SizedBox(width: PkSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t.pockitoSurface,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          context.t.typographyBordersAndSemanticColours,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});
  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final prefs = repo.notificationPreferences;
    // Grouped by whether the event is waiting on the user or merely telling
    // them something, because that is the distinction people actually tune.
    final actionRequired = NotificationEvent.values
        .where((event) => event.actionRequired)
        .toList();
    final updates = NotificationEvent.values
        .where((event) => !event.actionRequired)
        .toList();
    Widget group(String title, List<NotificationEvent> events) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PkSectionHeader(title: title),
        PkCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final event in events)
                SwitchListTile.adaptive(
                  key: ValueKey('notify_${event.name}'),
                  title: Text(event.label),
                  value: prefs.isOn(event),
                  onChanged: prefs.enabled
                      ? (value) => repo.saveNotificationPreferences(
                          prefs.copyWith(
                            mutedEvents:
                                {...prefs.mutedEvents, if (!value) event.name}
                                  ..removeWhere(
                                    (name) => value && name == event.name,
                                  ),
                          ),
                        )
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.notifications)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkCard(
              color: context.pk.sharedSurface,
              borderColor: context.pk.sharedBorder,
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active_outlined,
                    color: context.pk.sharedStrong,
                  ),
                  const SizedBox(width: PkSpacing.x3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.t.notificationPreviewEnabled,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text(
                          context.t.noSystemPermissionIsRequested,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: PkSpacing.x4),
            PkCard(
              child: SwitchListTile.adaptive(
                key: const ValueKey('notify_all'),
                contentPadding: EdgeInsets.zero,
                title: Text(context.t.notifications),
                subtitle: Text(context.t.notifMasterSwitch),
                value: prefs.enabled,
                onChanged: (value) => repo.saveNotificationPreferences(
                  prefs.copyWith(enabled: value),
                ),
              ),
            ),
            const SizedBox(height: PkSpacing.x5),
            // Every switch here maps to an event the app can actually fire, so
            // turning one off has a defined effect rather than a plausible one.
            group(context.t.notifWaiting, actionRequired),
            const SizedBox(height: PkSpacing.x5),
            group(context.t.notifUpdates, updates),
          ],
        ),
      ),
    );
  }
}

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    const languages = {
      'English': 'English',
      'German': 'Deutsch',
      'French': 'Français',
      'Japanese': '日本語',
    };
    final selected = repo.profile.language == '日本語'
        ? 'Japanese'
        : repo.profile.language;
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.language2)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            PkCard(
              padding: EdgeInsets.zero,
              child: RadioGroup<String>(
                groupValue: selected,
                onChanged: (value) {
                  if (value != null) {
                    repo.saveProfile(repo.profile.copyWith(language: value));
                  }
                },
                child: Column(
                  children: languages.entries
                      .map(
                        (language) => RadioListTile<String>(
                          title: Text(language.value),
                          subtitle: language.key == 'Japanese'
                              ? const Text('ナビゲーションを日本語で表示')
                              : null,
                          value: language.key,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(title: Text(context.t.aboutPockito)),
    // Section 7.24: rows keep a readable measure however wide the
    // window. A 1248 px settings row is not a wide layout.
    body: PkContentColumn(
      child: ListView(
        padding: const EdgeInsets.all(PkSpacing.screen),
        children: [
          const SizedBox(height: PkSpacing.x4),
          Center(
            child: KitoImage(
              asset: KitoAsset.defaultPose,
              width: 164,
              height: 164,
              semanticLabel: context.t.kitoTheOfficialPockitoMascot,
            ),
          ),
          const SizedBox(height: PkSpacing.x3),
          Text(
            'Pockito',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Text(
            context.t.moneyWithKitoPrototype,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: PkSpacing.x6),
          PkCard(
            child: Text(
              context.t.pockitoGivesPersonalAndShared,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(height: PkSpacing.x4),
          PkCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  title: Text(context.t.privacy),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () => _showInfo(
                    context,
                    context.t.privacy,
                    context.t.noPersonalDataLeavesThis,
                  ),
                ),
                ListTile(
                  title: Text(context.t.terms),
                  trailing: const Icon(Icons.open_in_new_rounded, size: 18),
                  onTap: () => _showInfo(
                    context,
                    context.t.terms,
                    context.t.prototypeTermsAreIntentionallyLocal,
                  ),
                ),
                ListTile(
                  title: Text(context.t.licences),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => showLicensePage(
                    context: context,
                    applicationName: 'Pockito',
                    applicationVersion: '0.1.0',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  void _showInfo(BuildContext context, String title, String body) =>
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.t.actionDone),
            ),
          ],
        ),
      );
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  /// null shows everything; true shows only what is waiting on the user.
  bool? _actionRequiredOnly;

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<PockitoAppViewModel>().repository;
    final all = repo.notifications;
    final notifications = all.where((item) {
      if (_actionRequiredOnly == null) return true;
      final event = NotificationEventInfo.fromWire(item.type);
      return (event?.actionRequired ?? false) == _actionRequiredOnly;
    }).toList();
    // Section 7.19 groups by Today / Earlier, not by every calendar day: one
    // label per distinct date turned a seven-item list into seven headed
    // sections and cost more vertical room than the notifications themselves.
    final today = DateTime(repo.today.year, repo.today.month, repo.today.day);
    final groups = <String, List<PockitoNotification>>{};
    for (final item in notifications) {
      final day = DateTime(item.at.year, item.at.month, item.at.day);
      final label = day.isBefore(today)
          ? context.t.notifEarlier
          : context.t.notifToday;
      groups.putIfAbsent(label, () => []).add(item);
    }
    final hasUnread = all.any((item) => !item.read);
    final waiting = all
        .where(
          (item) =>
              NotificationEventInfo.fromWire(item.type)?.actionRequired ??
              false,
        )
        .length;
    return Scaffold(
      appBar: PkAppBar(
        title: Text(context.t.notifications),
        actions: [
          // Section 6.2: an app-bar action is compact. A worded button here
          // is wider than the phone at 2.0x text, so the name lives in the
          // tooltip and the semantics rather than beside the title.
          IconButton(
            key: const ValueKey('mark_all_read'),
            onPressed: hasUnread ? repo.markAllNotificationsRead : null,
            tooltip: context.t.notifMarkAllRead,
            icon: const Icon(Icons.done_all_rounded),
          ),
        ],
      ),
      // Section 7.24: rows keep a readable measure however wide the window.
      body: PkContentColumn(
        child: all.isEmpty
            ? PkEmptyState(
                icon: Icons.notifications_none_rounded,
                title: context.t.allQuiet,
                message: context.t.sharedExpensesBudgetAlertsAnd,
              )
            : ListView(
                padding: const EdgeInsets.all(PkSpacing.screen),
                children: [
                  // Section 6.10: filter chips scroll rather than wrap, so three
                  // long Japanese labels cannot silently become two rows of
                  // chrome above the list they filter.
                  SizedBox(
                    height: PkSize.touch,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        ChoiceChip(
                          key: const ValueKey('notif_filter_all'),
                          label: Text(context.t.notifAll(all.length)),
                          selected: _actionRequiredOnly == null,
                          onSelected: (_) =>
                              setState(() => _actionRequiredOnly = null),
                        ),
                        const SizedBox(width: PkSpacing.x2),
                        ChoiceChip(
                          key: const ValueKey('notif_filter_action'),
                          label: Text(context.t.notifWaitingCount(waiting)),
                          selected: _actionRequiredOnly == true,
                          onSelected: (_) =>
                              setState(() => _actionRequiredOnly = true),
                        ),
                        const SizedBox(width: PkSpacing.x2),
                        ChoiceChip(
                          key: const ValueKey('notif_filter_updates'),
                          label: Text(
                            context.t.notifUpdatesCount(all.length - waiting),
                          ),
                          selected: _actionRequiredOnly == false,
                          onSelected: (_) =>
                              setState(() => _actionRequiredOnly = false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x3),
                  if (notifications.isEmpty)
                    PkListState.empty(
                      icon: Icons.notifications_off_outlined,
                      title: _actionRequiredOnly == true
                          ? context.t.notifNothingWaiting
                          : context.t.notifNoUpdates,
                      message: context.t.notifSwitchFilter,
                      actionLabel: context.t.notifShowAll,
                      onAction: () =>
                          setState(() => _actionRequiredOnly = null),
                    ),
                  // D-03: one surface per day group, with separators inside,
                  // instead of a rounded card around every notification.
                  for (final entry in groups.entries) ...[
                    PkGroupLabel(label: entry.key),
                    PkGroupedSurface(
                      indent:
                          PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
                      children: [
                        for (final item in entry.value)
                          _NotificationRow(item: item),
                      ],
                    ),
                    const SizedBox(height: PkSpacing.section),
                  ],
                ],
              ),
      ),
    );
  }
}

/// One notification, deep-linking to the thing it is about.
class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final PockitoNotification item;

  @override
  Widget build(BuildContext context) {
    final repo = context.read<PockitoAppViewModel>().repository;
    final event = NotificationEventInfo.fromWire(item.type);
    final actionRequired = event?.actionRequired ?? false;
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsetsDirectional.only(end: PkSpacing.x5),
        decoration: BoxDecoration(
          color: context.pk.danger,
          borderRadius: BorderRadius.circular(PkRadius.large),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        PkHaptics.selection();
        repo.dismissNotification(item.id, true);
        showPkUndoToast(
          context,
          message: context.t.notifDismissed,
          onUndo: () => repo.dismissNotification(item.id, false),
        );
      },
      // Section 7.19: 68–80 depending on action and status, unread carried by
      // a dot *and* semantics rather than by weight or colour alone.
      child: ColoredBox(
        color: item.read ? Colors.transparent : PkPalette.indigo50,
        child: PkLedgerRow(
          density: actionRequired ? PkRowDensity.status : PkRowDensity.rich,
          semanticIdentifier: 'notification_${item.id}',
          semanticLabel: [
            if (!item.read) context.t.notifUnread,
            item.title,
            item.body,
            PkFormat.shortDate(item.at, repo.today, context.t),
            if (actionRequired) context.t.notifWaiting,
          ].join(', '),
          leading: PkIconTile(
            icon: _notificationIcon(item.type),
            color: item.type == 'BUDGET_ALERT'
                ? context.pk.warning
                : item.type.startsWith('AI')
                ? PkPalette.indigo600
                : context.pk.sharedStrong,
          ),
          title: item.title,
          badges: [
            if (actionRequired)
              PkStatusBadge(
                label: context.t.notifWaiting,
                tone: PkStatusTone.shared,
                icon: Icons.pending_actions_rounded,
              ),
          ],
          subtitle: item.body,
          trailing: Text(
            PkFormat.shortDate(item.at, repo.today, context.t),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.pkText.supporting,
          ),
          trailingSubtitle: item.read
              ? null
              : Padding(
                  padding: const EdgeInsets.only(top: PkSpacing.x1),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: PkPalette.indigo600,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
          showChevron: true,
          onTap: () async {
            await repo.markNotificationRead(item.id);
            // Deep-link straight to the record, not to the list it lives in.
            if (context.mounted) context.push(item.destination);
          },
        ),
      ),
    );
  }

  IconData _notificationIcon(String type) => switch (type) {
    'BUDGET_ALERT' => Icons.donut_large_rounded,
    'SETTLEMENT_REQUEST' || 'SETTLEMENT_CONFIRMED' => Icons.handshake_outlined,
    'EXPENSE_ADDED' || 'EXPENSE_EDITED' => Icons.receipt_long_outlined,
    'SUBSCRIPTION_DUE' => Icons.autorenew_rounded,
    'INVITE_RECEIVED' || 'MEMBER_JOINED' => Icons.person_add_alt_outlined,
    _ => Icons.auto_awesome_outlined,
  };
}

class PrototypeStatesScreen extends StatelessWidget {
  const PrototypeStatesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PockitoAppViewModel>();
    return Scaffold(
      appBar: PkAppBar(title: Text(context.t.stateCatalogue)),
      // Section 7.24: rows keep a readable measure however wide the
      // window. A 1248 px settings row is not a wide layout.
      body: PkContentColumn(
        child: ListView(
          padding: const EdgeInsets.all(PkSpacing.screen),
          children: [
            Text(
              context.t.homeScreenStates,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: PkSpacing.x2),
            Text(
              context.t.chooseAStateReturnHome,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: context.pk.textSecondary),
            ),
            const SizedBox(height: PkSpacing.x5),
            PkCard(
              padding: EdgeInsets.zero,
              child: RadioGroup<PrototypeState>(
                groupValue: viewModel.prototypeState,
                onChanged: (value) {
                  if (value != null) viewModel.setPrototypeState(value);
                },
                child: Column(
                  children: PrototypeState.values
                      .map(
                        (state) => RadioListTile<PrototypeState>(
                          title: Text(
                            state.name[0].toUpperCase() +
                                state.name.substring(1),
                          ),
                          subtitle: Text(_stateDescription(context, state)),
                          value: state,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: PkSpacing.x5),
            PkSectionHeader(title: context.t.components),
            const PkSkeleton(height: 72),
            const SizedBox(height: PkSpacing.x3),
            PkEmptyState(
              icon: Icons.inbox_outlined,
              title: context.t.purposefulEmptyState,
              message: context.t.everyEmptySurfaceExplainsWhat,
            ),
          ],
        ),
      ),
    );
  }

  String _stateDescription(BuildContext context, PrototypeState state) =>
      switch (state) {
        PrototypeState.ready => context.t.coherentFixtureData,
        PrototypeState.loading => context.t.animatedSkeletons,
        PrototypeState.empty => context.t.firstUseGuidance,
        PrototypeState.error => context.t.recoverableFullScreenError,
        PrototypeState.offline => context.t.localModeBanner,
      };
}

/// A labelled group of settings rows on one surface, section 7.20.
///
/// A quiet group label rather than a full section header: on More the labels
/// are wayfinding, not headlines, and using 18 px titles for seven of them was
/// half of why the screen only fitted four rows.
class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.title, required this.items});
  final String title;
  final List<_SettingsItem> items;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PkGroupLabel(label: title),
      PkGroupedSurface(
        indent: PkSpacing.x4 + PkSize.iconLarge + PkSpacing.x3,
        children: items,
      ),
    ],
  );
}

/// One 56 px settings row.
class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) => PkLedgerRow.management(
    semanticIdentifier: 'more_${route.replaceAll('/', '_')}',
    semanticLabel: '$title, $subtitle',
    leading: Icon(
      icon,
      size: PkSize.iconLarge,
      color: Theme.of(context).colorScheme.primary,
    ),
    title: title,
    subtitle: subtitle,
    showChevron: true,
    onTap: () => context.push(route),
  );
}
