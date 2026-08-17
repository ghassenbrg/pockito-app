import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../app/pockito_app_view_model.dart';
import '../../../../domain/models/financial_models.dart';
import '../../../core/components/pk_components.dart';
import '../../../core/design_system/pk_tokens.dart';
import '../../../core/design_system/pk_labels.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (mounted) context.go('/auth');
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      decoration: const BoxDecoration(gradient: PkGradients.brand),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const PkMark(size: 88),
          const SizedBox(height: PkSpacing.x5),
          Text(
            'Pockito',
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: PkSpacing.x2),
          Text(
            context.t.moneyTogether,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ],
      ),
    ),
  );
}

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.all(PkSpacing.x6),
            children: [
              const SizedBox(height: PkSpacing.stateGroup),
              // Section 7.22: the illustration is capped at 35% of the usable
              // height, so a short screen or 2.0x text keeps the sign-in
              // actions on the page.
              Align(
                alignment: Alignment.center,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (MediaQuery.sizeOf(context).height * .35).clamp(
                      0.0,
                      KitoSize.onboarding.extent,
                    ),
                  ),
                  child: const KitoReveal(
                    child: KitoImage.sized(
                      asset: KitoAsset.welcome,
                      size: KitoSize.onboarding,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              Text(
                context.t.welcomeToPockito,
                textAlign: TextAlign.center,
                style: context.pkText.screenTitle,
              ),
              const SizedBox(height: PkSpacing.x2),
              Text(
                context.t.personalAndSharedMoneyIn,
                textAlign: TextAlign.center,
                style: context.pkText.body.copyWith(
                  color: context.pk.textSecondary,
                ),
              ),
              const SizedBox(height: PkSpacing.x8),
              FilledButton.icon(
                onPressed: () => context.go('/onboarding'),
                icon: const Icon(Icons.apple_rounded),
                label: Text(context.t.continueWithApple),
              ),
              const SizedBox(height: PkSpacing.x3),
              OutlinedButton.icon(
                onPressed: () => context.go('/onboarding'),
                icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
                label: Text(context.t.continueWithGoogle),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: PkSpacing.x5),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: PkSpacing.x3,
                      ),
                      child: Text(context.t.or),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: context.t.email,
                  hintText: context.t.youExampleCom,
                ),
              ),
              const SizedBox(height: PkSpacing.x3),
              FilledButton.tonal(
                onPressed: () => context.go('/onboarding'),
                child: Text(context.t.continueWithEmail),
              ),
              const SizedBox(height: PkSpacing.x4),
              TextButton(
                onPressed: () => context.push('/auth/error'),
                child: Text(context.t.previewAuthenticationError),
              ),
              const SizedBox(height: PkSpacing.x5),
              Text(
                context.t.authenticationIsSimulatedLocallyIn,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AuthErrorScreen extends StatelessWidget {
  const AuthErrorScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(),
    body: LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.all(PkSpacing.x6),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 440,
            minHeight: constraints.maxHeight - PkSpacing.x12,
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const KitoImage.sized(
                  asset: KitoAsset.confused,
                  size: KitoSize.state,
                ),
                const SizedBox(height: PkSpacing.section),
                Text(
                  context.t.weCouldnTSignYou,
                  textAlign: TextAlign.center,
                  style: context.pkText.screenTitle,
                ),
                const SizedBox(height: PkSpacing.x2),
                Text(
                  context.t.nothingWasChangedCheckYour,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: context.pk.textSecondary,
                  ),
                ),
                const SizedBox(height: PkSpacing.x6),
                FilledButton(
                  onPressed: () => context.go('/auth'),
                  child: Text(context.t.tryAgain),
                ),
                const SizedBox(height: PkSpacing.x2),
                TextButton(
                  onPressed: () => context.go('/home'),
                  child: Text(context.t.returnToPrototype),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _name = TextEditingController(text: 'Ghassen');
  final _accountName = TextEditingController(text: 'Rakuten Bank');
  final _accountBalance = TextEditingController(text: '500000');
  int _step = 0;

  /// How many pages the flow has. Named so the progress bar and
  /// its announcement cannot disagree.
  static const _stepCount = 7;
  String _country = 'Japan';
  String _currency = 'JPY';
  AccountType _accountType = AccountType.bank;
  String _language = 'English';
  ThemeMode _themeMode = ThemeMode.system;
  String? _avatarPath;
  bool _share = false;
  String? _createdAccountId;
  String? _createdSpaceId;

  @override
  void dispose() {
    _controller.dispose();
    _name.dispose();
    _accountName.dispose();
    _accountBalance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(
      leading: _step == 0
          ? IconButton(
              onPressed: () => context.go('/home'),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              icon: const Icon(Icons.close_rounded),
            )
          : IconButton(
              onPressed: _back,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
      title: Semantics(
        label: context.t.onboardingStepX0OfX1(_step + 1, _stepCount),
        value: '${_step + 1}/$_stepCount',
        liveRegion: true,
        excludeSemantics: true,
        child: Row(
          children: List.generate(
            _stepCount,
            (index) => Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  end: index == _stepCount - 1 ? 0 : 5,
                ),
                child: AnimatedContainer(
                  duration: PkMotion.standard,
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= _step
                        ? PkPalette.kitoBlue600
                        : context.pk.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    body: PageView(
      controller: _controller,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (value) => setState(() => _step = value),
      children: [
        _OnboardingPage(
          icon: Icons.account_balance_wallet_outlined,
          mascot: KitoAsset.welcome,
          title: context.t.moneyThatMakesSense,
          message: context.t.seeYourOwnAccountsAnd,
          visual: const _LensVisual(),
          primaryLabel: context.t.getStarted,
          onPrimary: _next,
        ),
        _OnboardingPage(
          icon: Icons.person_outline_rounded,
          mascot: KitoAsset.avatar,
          title: context.t.makePockitoYours,
          message: context.t.setTheIdentityAndDefaults,
          visual: Column(
            children: [
              PkAvatar(label: _initials, size: 72),
              const SizedBox(height: PkSpacing.x3),
              OutlinedButton.icon(
                key: const ValueKey('onboarding_avatar'),
                onPressed: () => setState(
                  () => _avatarPath = _avatarPath == null
                      ? context.t.localProfileAvatar
                      : null,
                ),
                icon: Icon(
                  _avatarPath == null
                      ? Icons.add_a_photo_outlined
                      : Icons.check_circle_outline_rounded,
                ),
                label: Text(
                  _avatarPath == null
                      ? context.t.chooseProfilePhoto
                      : context.t.photoSelectedLocally,
                ),
              ),
              const SizedBox(height: PkSpacing.x4),
              TextFormField(
                key: const ValueKey('onboarding_name'),
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: context.t.name),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: PkSpacing.x4),
              DropdownButtonFormField<String>(
                key: const ValueKey('onboarding_language'),
                isExpanded: true,
                initialValue: _language,
                decoration: InputDecoration(labelText: context.t.language),
                items: [
                  DropdownMenuItem(
                    value: 'English',
                    child: Text(context.t.languageEnglish),
                  ),
                  const DropdownMenuItem(
                    value: 'Japanese',
                    child: Text('日本語'), // i18n-exempt: a language endonym
                  ),
                ],
                onChanged: (value) => setState(() => _language = value!),
              ),
              const SizedBox(height: PkSpacing.x4),
              DropdownButtonFormField<ThemeMode>(
                key: const ValueKey('onboarding_theme'),
                isExpanded: true,
                initialValue: _themeMode,
                decoration: InputDecoration(labelText: context.t.appearance),
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(context.t.useDeviceSetting),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(context.t.light),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(context.t.dark),
                  ),
                ],
                onChanged: (value) => setState(() => _themeMode = value!),
              ),
              if (_language == 'Japanese') ...[
                const SizedBox(height: PkSpacing.x3),
                PkCard(
                  color: context.pk.sharedSurface,
                  borderColor: context.pk.sharedBorder,
                  child: Text('言語はいつでも設定から変更できます。'),
                ),
              ],
            ],
          ),
          primaryLabel: context.t.continueLabel,
          onPrimary: _saveIdentityAndNext,
        ),
        _OnboardingPage(
          icon: Icons.public_rounded,
          mascot: KitoAsset.pointing,
          title: context.t.setYourHomeBase,
          message: context.t.thisOnlyControlsReportingEvery,
          visual: Column(
            children: [
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _country,
                decoration: InputDecoration(labelText: context.t.country),
                items:
                    const [
                          'Japan',
                          'Germany',
                          'Luxembourg',
                          'Tunisia',
                          'United Kingdom',
                          'United States',
                        ]
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                onChanged: (value) => setState(() {
                  _country = value!;
                  _currency = switch (value) {
                    'Japan' => 'JPY',
                    'Tunisia' => 'TND',
                    'United Kingdom' => 'GBP',
                    'United States' => 'USD',
                    _ => 'EUR',
                  };
                }),
              ),
              const SizedBox(height: PkSpacing.x4),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: _currency,
                decoration: InputDecoration(
                  labelText: context.t.reportingCurrency,
                ),
                items: PockitoCurrencies.all.keys
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _currency = value!),
              ),
            ],
          ),
          primaryLabel: context.t.continueLabel,
          onPrimary: _saveRegionAndNext,
        ),
        _OnboardingPage(
          icon: Icons.account_balance_rounded,
          mascot: KitoAsset.defaultPose,
          title: context.t.setupStepAccount,
          message: context.t.givePockitoOnePlaceWhere,
          visual: Column(
            children: [
              TextField(
                key: const ValueKey('onboarding_account_name'),
                controller: _accountName,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: context.t.accountName),
              ),
              const SizedBox(height: PkSpacing.x4),
              DropdownButtonFormField<AccountType>(
                isExpanded: true,
                initialValue: _accountType,
                decoration: InputDecoration(labelText: context.t.type),
                items: AccountType.values
                    .map(
                      (item) => DropdownMenuItem(
                        value: item,
                        child: Text(_accountTypeLabel(context, item)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _accountType = value!),
              ),
              const SizedBox(height: PkSpacing.x4),
              TextField(
                key: const ValueKey('onboarding_account_balance'),
                controller: _accountBalance,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: context.t.currentBalance,
                  prefixText: '${PockitoCurrencies.of(_currency).symbol} ',
                ),
              ),
            ],
          ),
          primaryLabel: context.t.addAccount,
          onPrimary: _saveAccountAndNext,
          secondaryLabel: context.t.useTheSampleAccount,
          onSecondary: _saveAccountAndNext,
        ),
        _OnboardingPage(
          icon: Icons.group_outlined,
          mascot: KitoAsset.sharedSpace,
          title: context.t.shareMoneyWithSomeone,
          message: context.t.createASpaceForA2,
          visual: Column(
            children: [
              PkCard(
                color: _share ? context.pk.sharedSurface : null,
                borderColor: _share ? context.pk.sharedBorder : null,
                onTap: () => setState(() => _share = true),
                child: Row(
                  children: [
                    Icon(Icons.home_outlined, color: context.pk.sharedStrong),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(child: Text(context.t.yesCreateASharedSpace)),
                    if (_share)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: PkPalette.amber700,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: PkSpacing.x3),
              PkCard(
                onTap: () => setState(() => _share = false),
                child: Row(
                  children: [
                    const Icon(Icons.person_outline_rounded),
                    const SizedBox(width: PkSpacing.x3),
                    Expanded(child: Text(context.t.notRightNow)),
                    if (!_share)
                      const Icon(
                        Icons.check_circle_rounded,
                        color: PkPalette.indigo600,
                      ),
                  ],
                ),
              ),
            ],
          ),
          primaryLabel: context.t.continueLabel,
          onPrimary: _saveOptionalSpaceAndNext,
        ),
        _OnboardingPage(
          icon: Icons.link_rounded,
          title: _share
              ? context.t.inviteSomeone
              : context.t.spacesAreReadyWhenYou,
          message: _share
              ? context.t.shareThisLinkTheInvite
              : context.t.youCanCreateAShared,
          visual: _share
              ? PkCard(
                  color: context.pk.sharedSurface,
                  borderColor: context.pk.sharedBorder,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _createdSpaceId == null
                            ? context.t.sharedSpace
                            : 'Household',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: PkSpacing.x2),
                      SelectableText(
                        'pockito.app/invite/${_createdSpaceId ?? 'ready-later'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: context.pk.sharedStrong,
                        ),
                      ),
                      const SizedBox(height: PkSpacing.x3),
                      OutlinedButton.icon(
                        onPressed: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.t.inviteLinkCopied),
                              ),
                            ),
                        icon: const Icon(Icons.copy_rounded),
                        label: Text(context.t.copyLink),
                      ),
                    ],
                  ),
                )
              : PkEmptyState(
                  icon: Icons.group_add_outlined,
                  title: context.t.noPressure,
                  message: context.t.pockitoWorksBeautifullyForPersonal,
                ),
          primaryLabel: context.t.continueLabel,
          onPrimary: _next,
        ),
        _OnboardingPage(
          icon: Icons.check_rounded,
          mascot: KitoAsset.celebrating,
          title: context.t.youReAllSet,
          message: context.t.yourOverviewAccountsSharedSpaces,
          visual: const _ReadyVisual(),
          primaryLabel: context.t.openPockito,
          onPrimary: () => context.go('/home'),
        ),
      ],
    ),
  );

  void _next() =>
      _controller.nextPage(duration: PkMotion.standard, curve: PkMotion.enter);

  String get _initials {
    final words = _name.text
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    return words.isEmpty
        ? '?'
        : words.take(2).map((word) => word[0].toUpperCase()).join();
  }

  Future<void> _saveIdentityAndNext() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.enterYourNameToContinue)),
      );
      return;
    }
    final repo = context.read<PockitoAppViewModel>().repository;
    await repo.saveProfile(
      repo.profile.copyWith(
        displayName: _name.text.trim(),
        email:
            '${_name.text.trim().toLowerCase().replaceAll(' ', '.')}@example.com',
        language: _language,
        themeMode: _themeMode,
        avatarPath: _avatarPath,
      ),
    );
    if (mounted) _next();
  }

  Future<void> _saveRegionAndNext() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final code = switch (_country) {
      'Japan' => 'JP',
      'Germany' => 'DE',
      'Luxembourg' => 'LU',
      'Tunisia' => 'TN',
      'United Kingdom' => 'GB',
      _ => 'US',
    };
    await repo.saveProfile(
      repo.profile.copyWith(
        country: code,
        countryName: _country,
        reportingCurrency: _currency,
        locale: _language == 'Japanese' ? 'ja-JP' : 'en-$code',
        timezone: _country == 'Japan' ? 'Asia/Tokyo' : repo.profile.timezone,
      ),
    );
    if (mounted) _next();
  }

  Future<void> _saveAccountAndNext() async {
    final repo = context.read<PockitoAppViewModel>().repository;
    final amount = double.tryParse(_accountBalance.text);
    if (_accountName.text.trim().isEmpty || amount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.t.addAnAccountNameAnd)));
      return;
    }
    final existing = _createdAccountId == null
        ? null
        : repo.accountById(_createdAccountId!);
    final saved = await repo.saveAccount(
      Account(
        id: existing?.id ?? '',
        name: _accountName.text.trim(),
        type: _accountType,
        currency: _currency,
        openingBalanceMinor:
            (amount * PockitoCurrencies.of(_currency).minorUnitScale).round(),
        isDefault: true,
        colorIndex: 4,
        icon: _accountType == AccountType.cash ? 'cash' : 'bank',
      ),
    );
    _createdAccountId = saved.id;
    if (mounted) _next();
  }

  Future<void> _saveOptionalSpaceAndNext() async {
    if (_share && _createdSpaceId == null) {
      final repo = context.read<PockitoAppViewModel>().repository;
      final space = await repo.saveSpace(
        SharedSpace(
          id: '',
          name: 'Household',
          type: SpaceType.household,
          currency: _currency,
          members: [
            SpaceMember(userId: repo.currentUserId, role: SpaceRole.owner),
          ],
          defaultSplitMethod: SplitMethod.equal,
          colorIndex: 2,
          icon: 'housing',
        ),
      );
      _createdSpaceId = space.id;
    }
    if (mounted) _next();
  }

  void _back() => _controller.previousPage(
    duration: PkMotion.standard,
    curve: PkMotion.enter,
  );
}

class IncomingInviteReviewScreen extends StatelessWidget {
  const IncomingInviteReviewScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: PkAppBar(title: Text(context.t.spaceInvitation)),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: const EdgeInsets.all(PkSpacing.x6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PkIconTile(
                      icon: Icons.menu_book_rounded,
                      color: context.pk.sharedStrong,
                      size: 72,
                      iconSize: 34,
                    ),
                    const SizedBox(height: PkSpacing.x5),
                    Text(
                      context.t.joinBookClub,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    Text(
                      context.t.samInvitedYouToA,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: context.pk.textSecondary,
                      ),
                    ),
                    const SizedBox(height: PkSpacing.x6),
                    PkCard(
                      child: Column(
                        children: [
                          _InviteRow(
                            label: context.t.spaceLabel,
                            value: 'Book Club',
                          ),
                          _InviteRow(
                            label: context.t.members2,
                            value: context.t.l4People,
                          ),
                          _InviteRow(label: context.t.currency, value: 'EUR'),
                          _InviteRow(label: context.t.invitedBy, value: 'Sam'),
                        ],
                      ),
                    ),
                    const SizedBox(height: PkSpacing.x6),
                    FilledButton(
                      onPressed: () async {
                        final repo = context
                            .read<PockitoAppViewModel>()
                            .repository;
                        final space = await repo.saveSpace(
                          SharedSpace(
                            id: '',
                            name: 'Book Club',
                            type: SpaceType.other,
                            currency: 'EUR',
                            members: const [
                              SpaceMember(
                                userId: 'u_sam',
                                role: SpaceRole.owner,
                              ),
                              SpaceMember(userId: 'u_me'),
                              SpaceMember(userId: 'u_mira'),
                              SpaceMember(userId: 'u_lina'),
                            ],
                            defaultSplitMethod: SplitMethod.equal,
                            colorIndex: 6,
                            icon: 'group',
                          ),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(context.t.joinedBookClubLocally),
                          ),
                        );
                        await showPkNotificationPrePrompt(context);
                        if (context.mounted) {
                          context.go('/spaces/${space.id}');
                        }
                      },
                      child: Text(context.t.joinSpace),
                    ),
                    const SizedBox(height: PkSpacing.x2),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(context.t.decline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.message,
    required this.visual,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.mascot,
  });
  final IconData icon;
  final String title;
  final String message;
  final Widget visual;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final KitoAsset? mascot;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: LayoutBuilder(
      builder: (context, constraints) {
        // Section 7.22: the illustration never takes more than 35% of the
        // usable height. On a short screen or at 2.0x text that is what stops
        // the artwork pushing the fields and the CTA off the page.
        final artBudget = (constraints.maxHeight * .35).clamp(0.0, 168.0);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: PkBreakpoints.formMaxWidth,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(
                      context.gutter,
                      PkSpacing.x4,
                      context.gutter,
                      PkSpacing.x4,
                    ),
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          PkIconTile.feature(
                            icon: icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          if (mascot != null) ...[
                            const Spacer(),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: artBudget,
                                maxWidth: artBudget,
                              ),
                              child: KitoReveal(
                                child: KitoImage.sized(
                                  asset: mascot!,
                                  size: KitoSize.state,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: PkSpacing.x4),
                      // 7.22: headline 24–28. `screenTitle` is 24.
                      Text(title, style: context.pkText.screenTitle),
                      const SizedBox(height: PkSpacing.x2),
                      Text(
                        message,
                        style: context.pkText.body.copyWith(
                          color: context.pk.textSecondary,
                        ),
                      ),
                      const SizedBox(height: PkSpacing.section),
                      visual,
                    ],
                  ),
                ),
                // One primary CTA, pinned safely: it stays reachable however
                // long the content above it grows.
                PkPinnedActions(
                  secondary: secondaryLabel == null
                      ? null
                      : TextButton(
                          onPressed: onSecondary,
                          child: Text(secondaryLabel!),
                        ),
                  child: SizedBox(
                    height: PkSize.buttonFinal,
                    child: FilledButton(
                      onPressed: onPrimary,
                      child: Text(primaryLabel),
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

class _LensVisual extends StatelessWidget {
  const _LensVisual();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      PkCard(
        child: Row(
          children: [
            const PkIconTile(
              icon: Icons.account_balance_wallet_outlined,
              color: PkPalette.indigo600,
            ),
            const SizedBox(width: PkSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t.cashFlow,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    context.t.whatLeftYourAccounts,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text('€98.00', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
      const SizedBox(height: PkSpacing.x3),
      PkCard(
        color: context.pk.sharedSurface,
        borderColor: context.pk.sharedBorder,
        child: Row(
          children: [
            PkIconTile(
              icon: Icons.group_outlined,
              color: context.pk.sharedStrong,
            ),
            const SizedBox(width: PkSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.t.yourSpending,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    context.t.onlyYourShare,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              '€49.00',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: context.pk.sharedStrong),
            ),
          ],
        ),
      ),
    ],
  );
}

class _ReadyVisual extends StatelessWidget {
  const _ReadyVisual();
  @override
  Widget build(BuildContext context) => PkCard(
    child: Column(
      children: [
        Row(
          children: [
            const PkMark(size: 44),
            const SizedBox(width: PkSpacing.x3),
            Expanded(
              child: Text(
                context.t.aCompleteSampleDatasetIs,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Icon(Icons.check_circle_rounded, color: PkPalette.indigo600),
          ],
        ),
        const SizedBox(height: PkSpacing.x3),
        Text(
          context.t.youCanAddEditSplit,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}

class _InviteRow extends StatelessWidget {
  const _InviteRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x2),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
        Text(value, style: Theme.of(context).textTheme.labelMedium),
      ],
    ),
  );
}

String _accountTypeLabel(BuildContext context, AccountType type) =>
    switch (type) {
      AccountType.bank => context.t.bankAccount,
      AccountType.card => context.t.card,
      AccountType.cash => context.t.cash,
      AccountType.savings => context.t.savings,
      AccountType.digital => context.t.digitalWallet,
    };
