import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';

import '../../../app/pockito_app_state.dart';
import '../../../data/pockito_exception.dart';
import '../../../domain/pockito_models.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/components/pk_feedback.dart';
import '../../core/components/pk_profile_avatar.dart';
import '../../core/design_system/pk_tokens.dart';

/// First-login setup: name, photo, language, appearance, currency.
///
/// Language and appearance take effect the moment they are chosen, so the user
/// can see what they are picking. Everything is submitted in one call at the
/// end, so nobody ends up marked as onboarded with settings that failed to save.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

enum _Step { profile, avatar, language, appearance, currency }

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  _Step _step = _Step.profile;
  late Preferences _draft;
  bool _seeded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_seeded) return;
    // Start from whatever the backend already knows, so returning to an
    // unfinished setup does not begin from a blank form.
    final state = context.read<PockitoAppState>();
    _nameController.text = state.profile?.displayName ?? '';
    _draft = state.preferences;
    _seeded = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canAdvance =>
      _step != _Step.profile || _nameController.text.trim().isNotEmpty;

  bool get _isLastStep => _step == _Step.values.last;

  Future<void> _next() async {
    final state = context.read<PockitoAppState>();
    if (!_isLastStep) {
      setState(() => _step = _Step.values[_Step.values.indexOf(_step) + 1]);
      return;
    }
    try {
      await state.completeOnboarding(
        displayName: _nameController.text,
        preferences: _draft,
      );
    } on PockitoException catch (e) {
      if (mounted) showFailure(context, e);
    }
  }

  void _back() {
    final index = _Step.values.indexOf(_step);
    if (index > 0) setState(() => _step = _Step.values[index - 1]);
  }

  /// Applies a preference immediately so the choice is visible, and persists it
  /// with the rest of the answers when setup finishes.
  Future<void> _choosePreference(Preferences next) async {
    setState(() => _draft = next);
    await context.read<PockitoAppState>().updatePreferences(next);
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final state = context.read<PockitoAppState>();
    final picked = await _picker.pickImage(
      source: source,
      // Resized on device: a 12 MP camera photo would be rejected by the 2 MB
      // limit, and nothing needs more than this for an avatar.
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;
    try {
      await state.uploadAvatar(
        bytes: await picked.readAsBytes(),
        filename: picked.name,
        contentType: lookupMimeType(picked.name) ?? 'image/jpeg',
      );
    } on PockitoException catch (e) {
      if (mounted) showFailure(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = context.watch<PockitoAppState>();
    final index = _Step.values.indexOf(_step);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: PkBreakpoints.formMaxWidth),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Semantics(
                    label: l10n.onboardingStepOf(index + 1, _Step.values.length),
                    child: Row(
                      children: [
                        for (var i = 0; i < _Step.values.length; i++) ...[
                          Expanded(
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: i <= index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(PkRadius.small),
                              ),
                            ),
                          ),
                          if (i < _Step.values.length - 1) const SizedBox(width: PkSpacing.x2),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x8),
                  Text(_title(l10n), style: theme.textTheme.headlineSmall),
                  const SizedBox(height: PkSpacing.x2),
                  Text(
                    _body(l10n),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: PkSpacing.x6),
                  _content(l10n, state),
                  const SizedBox(height: PkSpacing.x8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (index > 0)
                        TextButton(
                          onPressed: state.busy ? null : _back,
                          child: Text(l10n.commonBack),
                        ),
                      const SizedBox(width: PkSpacing.x3),
                      FilledButton(
                        onPressed: !_canAdvance || state.busy ? null : _next,
                        child: Text(_isLastStep ? l10n.onboardingFinish : l10n.commonNext),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n) => switch (_step) {
        _Step.profile => l10n.onboardingProfileTitle,
        _Step.avatar => l10n.onboardingAvatarTitle,
        _Step.language => l10n.onboardingLanguageTitle,
        _Step.appearance => l10n.onboardingAppearanceTitle,
        _Step.currency => l10n.onboardingCurrencyTitle,
      };

  String _body(AppLocalizations l10n) => switch (_step) {
        _Step.profile => l10n.onboardingProfileBody,
        _Step.avatar => l10n.onboardingAvatarBody,
        _Step.language => l10n.onboardingLanguageBody,
        _Step.appearance => l10n.onboardingAppearanceBody,
        _Step.currency => l10n.onboardingCurrencyBody,
      };

  Widget _content(AppLocalizations l10n, PockitoAppState state) {
    switch (_step) {
      case _Step.profile:
        return TextField(
          controller: _nameController,
          maxLength: 80,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            labelText: l10n.profileDisplayName,
            hintText: l10n.profileDisplayNameHint,
          ),
          onChanged: (_) => setState(() {}),
        );

      case _Step.avatar:
        final profile = state.profile;
        return Row(
          children: [
            if (profile != null) PkProfileAvatar(profile: profile, size: 88),
            const SizedBox(width: PkSpacing.x5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OutlinedButton.icon(
                    onPressed: state.busy ? null : () => _pickAvatar(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(profile?.avatarUrl == null ? l10n.avatarUpload : l10n.avatarReplace),
                  ),
                  const SizedBox(height: PkSpacing.x2),
                  OutlinedButton.icon(
                    onPressed: state.busy ? null : () => _pickAvatar(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: Text(l10n.avatarFromCamera),
                  ),
                  if (profile?.avatarUrl != null) ...[
                    const SizedBox(height: PkSpacing.x2),
                    TextButton(
                      onPressed: state.busy
                          ? null
                          : () => context.read<PockitoAppState>().removeAvatar(),
                      child: Text(l10n.avatarRemove),
                    ),
                  ],
                  const SizedBox(height: PkSpacing.x2),
                  Text(l10n.avatarHint, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        );

      case _Step.language:
        return Wrap(
          spacing: PkSpacing.x2,
          children: [
            for (final language in AppLanguage.values)
              ChoiceChip(
                label: Text(language == AppLanguage.ja ? l10n.languageJa : l10n.languageEn),
                selected: _draft.language == language,
                onSelected: (_) => _choosePreference(_draft.copyWith(language: language)),
              ),
          ],
        );

      case _Step.appearance:
        return Wrap(
          spacing: PkSpacing.x2,
          children: [
            for (final theme in AppTheme.values)
              ChoiceChip(
                label: Text(switch (theme) {
                  AppTheme.system => l10n.themeSystem,
                  AppTheme.light => l10n.themeLight,
                  AppTheme.dark => l10n.themeDark,
                }),
                selected: _draft.theme == theme,
                onSelected: (_) => _choosePreference(_draft.copyWith(theme: theme)),
              ),
          ],
        );

      case _Step.currency:
        return DropdownButtonFormField<String>(
          initialValue: _draft.defaultCurrency,
          decoration: InputDecoration(labelText: l10n.preferencesCurrency),
          items: [
            for (final code in state.supportedCurrencies)
              DropdownMenuItem(value: code, child: Text(code)),
          ],
          onChanged: (code) {
            if (code != null) setState(() => _draft = _draft.copyWith(defaultCurrency: code));
          },
        );
    }
  }
}
