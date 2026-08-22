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

/// Everything a signed-in user can change about themselves, plus sign-out.
///
/// Preferences save on selection rather than behind a Save button: each is a
/// single independent value and the effect is immediately visible, which makes
/// a confirm step feel like an obstacle. The display name does get a Save,
/// because half-typed text is not a choice.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();
  String _savedName = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<PockitoAppState>().profile;
    if (profile != null && _savedName != profile.displayName) {
      _savedName = profile.displayName;
      _nameController.text = profile.displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _nameChanged {
    final typed = _nameController.text.trim();
    return typed.isNotEmpty && typed != _savedName;
  }

  Future<void> _saveName() async {
    try {
      await context.read<PockitoAppState>().updateDisplayName(_nameController.text);
      if (mounted) {
        setState(() => _savedName = _nameController.text.trim());
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.commonSaved)));
      }
    } on PockitoException catch (e) {
      if (mounted) showFailure(context, e);
    }
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final state = context.read<PockitoAppState>();
    final picked = await _picker.pickImage(
      source: source,
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

  Future<void> _confirmSignOut() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(l10n.settingsSignOutConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.settingsSignOut),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<PockitoAppState>().signOut();
    }
  }

  Future<void> _update(Preferences next) async {
    try {
      await context.read<PockitoAppState>().updatePreferences(next);
    } on PockitoException catch (e) {
      if (mounted) showFailure(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = context.watch<PockitoAppState>();
    final profile = state.profile;
    if (profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(context.gutter),
          children: [
            Text(l10n.settingsTitle, style: theme.textTheme.headlineSmall),
            const SizedBox(height: PkSpacing.section),

            _Section(
              title: l10n.settingsProfile,
              children: [
                Row(
                  children: [
                    PkProfileAvatar(profile: profile, size: 72),
                    const SizedBox(width: PkSpacing.x5),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          OutlinedButton.icon(
                            onPressed: state.busy
                                ? null
                                : () => _pickAvatar(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library_outlined),
                            label: Text(profile.avatarUrl == null
                                ? l10n.avatarUpload
                                : l10n.avatarReplace),
                          ),
                          if (profile.avatarUrl != null)
                            TextButton(
                              onPressed: state.busy
                                  ? null
                                  : () => context.read<PockitoAppState>().removeAvatar(),
                              child: Text(l10n.avatarRemove),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: PkSpacing.x4),
                TextField(
                  controller: _nameController,
                  maxLength: 80,
                  decoration: InputDecoration(labelText: l10n.profileDisplayName),
                  onChanged: (_) => setState(() {}),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: !_nameChanged || state.busy ? null : _saveName,
                    child: Text(l10n.commonSave),
                  ),
                ),
                const SizedBox(height: PkSpacing.x3),
                Text(
                  l10n.settingsIdentity(profile.email ?? '—'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),

            _Section(
              title: l10n.preferencesLanguage,
              children: [
                Wrap(
                  spacing: PkSpacing.x2,
                  children: [
                    for (final language in AppLanguage.values)
                      ChoiceChip(
                        label: Text(language == AppLanguage.ja ? l10n.languageJa : l10n.languageEn),
                        selected: state.preferences.language == language,
                        onSelected: state.busy
                            ? null
                            : (_) => _update(state.preferences.copyWith(language: language)),
                      ),
                  ],
                ),
              ],
            ),

            _Section(
              title: l10n.preferencesAppearance,
              children: [
                Wrap(
                  spacing: PkSpacing.x2,
                  children: [
                    for (final appTheme in AppTheme.values)
                      ChoiceChip(
                        label: Text(switch (appTheme) {
                          AppTheme.system => l10n.themeSystem,
                          AppTheme.light => l10n.themeLight,
                          AppTheme.dark => l10n.themeDark,
                        }),
                        selected: state.preferences.theme == appTheme,
                        onSelected: state.busy
                            ? null
                            : (_) => _update(state.preferences.copyWith(theme: appTheme)),
                      ),
                  ],
                ),
              ],
            ),

            _Section(
              title: l10n.preferencesCurrency,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: state.preferences.defaultCurrency,
                  items: [
                    for (final code in state.supportedCurrencies)
                      DropdownMenuItem(value: code, child: Text(code)),
                  ],
                  onChanged: state.busy
                      ? null
                      : (code) {
                          if (code != null) {
                            _update(state.preferences.copyWith(defaultCurrency: code));
                          }
                        },
                ),
              ],
            ),

            _Section(
              title: l10n.settingsSession,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.tonal(
                    onPressed: state.busy ? null : _confirmSignOut,
                    child: Text(l10n.settingsSignOut),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.section),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(PkSpacing.x5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: PkSpacing.headerToContent),
              ...children,
            ],
          ),
        ),
      ),
    );
  }
}
