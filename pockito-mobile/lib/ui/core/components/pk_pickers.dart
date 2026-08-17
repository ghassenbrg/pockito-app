import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/models/financial_models.dart';
import '../../../domain/repositories/pockito_repository.dart';
import '../design_system/pk_format.dart';
import '../design_system/pk_icons.dart';
import '../design_system/pk_labels.dart';
import '../design_system/pk_tokens.dart';
import 'pk_components.dart';

/// The one bottom-sheet layout in the app.
///
/// Four screens used to build their own header, drag handle and action row.
/// They drifted apart in padding, title weight and where the close control
/// sat; sharing the shell keeps every sheet opening the same way.
class PkSheetScaffold extends StatelessWidget {
  const PkSheetScaffold({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.actions = const [],
    this.footer,
    this.scrollable = true,
    this.onReset,
    this.resetLabel,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final List<Widget> actions;

  /// Pinned below the content, for the sheet's primary action.
  final Widget? footer;
  final bool scrollable;

  /// Clears the sheet's own selections. Section 6.12 puts reset in the header,
  /// beside the title, so a filter sheet always offers the same way back to
  /// the default without hunting for it among the content.
  final VoidCallback? onReset;
  final String? resetLabel;

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x5,
        PkSpacing.x3,
        PkSpacing.x3,
        PkSpacing.x3,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.pkText.sectionTitle),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: context.pkText.supporting),
                ],
              ],
            ),
          ),
          // The trailing group shrinks before the title does, and its labels
          // ellipsize rather than pushing Close off the screen at large text
          // sizes. Close itself is never allowed to shrink: a modal always
          // has to be closable.
          Flexible(
            child: DefaultTextStyle.merge(
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onReset != null)
                    Flexible(
                      child: TextButton(
                        key: const ValueKey('pk_sheet_reset'),
                        onPressed: onReset,
                        child: Text(resetLabel ?? context.t.actionResetAll),
                      ),
                    ),
                  for (final action in actions) Flexible(child: action),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
    final body = Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        PkSpacing.x5,
        0,
        PkSpacing.x5,
        PkSpacing.x5,
      ),
      child: child,
    );
    // The scaffold paints its own sheet surface rather than relying on whatever
    // material happens to be behind it: a sheet opened on the root navigator,
    // or one given a transparent background so it can paint a viewfinder, has
    // no material ancestor at all, and its chips and ripples need one.
    return Material(
      color: context.pk.surface,
      surfaceTintColor: Colors.transparent,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(PkRadius.sheet),
      ),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              header,
              Flexible(
                child: scrollable ? SingleChildScrollView(child: body) : body,
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    PkSpacing.x5,
                    0,
                    PkSpacing.x5,
                    PkSpacing.x5,
                  ),
                  child: footer!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// How tall a sheet is allowed to grow, section 6.12.
enum PkSheetSize {
  /// Hugs its content and never passes 60% of the screen. For selection and
  /// short confirmations.
  compact(.6),

  /// Hugs its content up to 80%. For multi-section filters and editors that
  /// still belong in a sheet.
  standard(.8);

  const PkSheetSize(this.maxFraction);

  /// Share of the screen height the sheet may occupy.
  final double maxFraction;
}

/// Presents a sheet with the audit's height contract.
///
/// The drag handle is deliberately absent: `PkSheetScaffold` draws a full
/// header with a Close control, and section 6.12 asks for one modality signal,
/// not two. A task that needs more than 80% of the screen is a full-screen
/// route, not a sheet.
Future<T?> showPkSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  PkSheetSize size = PkSheetSize.standard,
  bool useRootNavigator = false,
  Color? backgroundColor,
}) => showModalBottomSheet<T>(
  context: context,
  useSafeArea: true,
  showDragHandle: false,
  isScrollControlled: true,
  useRootNavigator: useRootNavigator,
  // Only for a sheet that paints its own full-bleed surface — the receipt
  // capture, whose viewfinder cannot sit on a card.
  backgroundColor: backgroundColor,
  constraints: const BoxConstraints(maxWidth: PkBreakpoints.readingMaxWidth),
  // The height cap is applied to the *content*, not through the route's own
  // constraints. A scroll-controlled sheet positions itself from the box it is
  // given, so capping there anchors a short sheet as if it were the full cap
  // and pushes its last rows off the bottom of the screen.
  builder: (context) => ConstrainedBox(
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * size.maxFraction,
    ),
    child: builder(context),
  ),
);

// -----------------------------------------------------------------------------
// Search
// -----------------------------------------------------------------------------

/// The search field every list over roughly eight rows carries.
class PkSearchField extends StatefulWidget {
  const PkSearchField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.hintText,
    this.autofocus = false,
    this.resultCount,
  });

  final String value;
  final ValueChanged<String> onChanged;
  final String hintText;
  final bool autofocus;

  /// Announced to screen readers when it changes, so a filtered list is not
  /// silent.
  final int? resultCount;

  @override
  State<PkSearchField> createState() => _PkSearchFieldState();
}

class _PkSearchFieldState extends State<PkSearchField> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.value,
  );

  @override
  void didUpdateWidget(PkSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) _controller.text = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: widget.resultCount != null,
    label: widget.resultCount == null
        ? null
        : context.t.x0Results(widget.resultCount!),
    child: TextField(
      key: const ValueKey('pk_search'),
      controller: _controller,
      autofocus: widget.autofocus,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: context.t.actionClearSearch,
                icon: const Icon(Icons.close_rounded),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged('');
                  setState(() {});
                },
              ),
        isDense: true,
      ),
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
    ),
  );
}

// -----------------------------------------------------------------------------
// Sort
// -----------------------------------------------------------------------------

/// The sort entry point, showing the sort that is actually in force.
class PkSortButton extends StatelessWidget {
  const PkSortButton({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final PkSort value;
  final List<PkSort> options;
  final ValueChanged<PkSort> onChanged;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    key: const ValueKey('pk_sort'),
    onPressed: () async {
      final picked = await showPkSheet<PkSort>(
        context,
        builder: (context) => PkSheetScaffold(
          title: context.t.sortBy,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in options)
                RadioListTile<PkSort>(
                  key: ValueKey('sort_${option.name}'),
                  value: option,
                  // ignore: deprecated_member_use
                  groupValue: value,
                  // ignore: deprecated_member_use
                  onChanged: (picked) => Navigator.pop(context, picked),
                  title: Text(option.labelIn(context.t)),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      );
      if (picked != null) {
        PkHaptics.selection();
        onChanged(picked);
      }
    },
    icon: const Icon(Icons.swap_vert_rounded, size: PkSize.icon),
    label: Text(value.labelIn(context.t)),
  );
}

// -----------------------------------------------------------------------------
// Filters
// -----------------------------------------------------------------------------

/// One active filter, rendered as a chip the user can remove on its own.
class PkFilterChipData {
  const PkFilterChipData({
    required this.id,
    required this.label,
    required this.onRemove,
  });

  final String id;
  final String label;
  final VoidCallback onRemove;
}

/// The row of active filters, with per-chip removal and a reset.
///
/// A count badge tells the user that something is filtered; it does not tell
/// them what, and it gives them no way to undo one decision out of six.
class PkActiveFilters extends StatelessWidget {
  const PkActiveFilters({
    super.key,
    required this.chips,
    required this.onResetAll,
    this.onSave,
  });

  final List<PkFilterChipData> chips;
  final VoidCallback onResetAll;

  /// Offers to remember this combination as a saved view.
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    if (chips.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.x3),
      child: Wrap(
        spacing: PkSpacing.x2,
        runSpacing: PkSpacing.x2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          for (final chip in chips)
            InputChip(
              key: ValueKey('filter_chip_${chip.id}'),
              label: Text(chip.label),
              onDeleted: () {
                PkHaptics.selection();
                chip.onRemove();
              },
              deleteIcon: const Icon(Icons.close_rounded, size: 16),
            ),
          TextButton(
            key: const ValueKey('filter_reset_all'),
            onPressed: onResetAll,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x2),
              minimumSize: const Size(PkSize.touch, PkSize.touch),
            ),
            child: Text(context.t.actionResetAll),
          ),
          if (onSave != null)
            TextButton.icon(
              key: const ValueKey('filter_save_view'),
              onPressed: onSave,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: PkSpacing.x2),
                minimumSize: const Size(PkSize.touch, PkSize.touch),
              ),
              icon: const Icon(Icons.bookmark_add_outlined, size: 16),
              label: Text(context.t.actionSaveView),
            ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Amount
// -----------------------------------------------------------------------------

/// The money input.
///
/// A plain `TextFormField` at display size does not know what currency it is
/// in: it lets a user type three decimals into a yen amount, offers a keypad
/// with a decimal point that yen has no use for, and formats nothing until
/// after save.
class PkAmountField extends StatefulWidget {
  const PkAmountField({
    super.key,
    required this.controller,
    required this.currency,
    this.label,
    this.autofocus = false,
    this.quickAmounts = const [],
    this.onChanged,
    this.validator,
    this.signed = false,
    this.negative = false,
    this.onSignChanged,
    this.fieldKey,
  });

  final TextEditingController controller;
  final String currency;

  /// Null falls back to the localized word for an amount.
  final String? label;
  final bool autofocus;

  /// Common values offered as chips, in major units.
  final List<int> quickAmounts;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;

  /// Shows a +/− control, for a field that can record either direction.
  final bool signed;
  final bool negative;
  final ValueChanged<bool>? onSignChanged;
  final Key? fieldKey;

  @override
  State<PkAmountField> createState() => _PkAmountFieldState();
}

class _PkAmountFieldState extends State<PkAmountField> {
  @override
  Widget build(BuildContext context) {
    final info = PockitoCurrencies.of(widget.currency);
    final decimals = info.decimals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.signed) ...[
              IconButton.filledTonal(
                key: const ValueKey('amount_sign'),
                tooltip: widget.negative
                    ? context.t.addHintMoneyOut
                    : context.t.addHintMoneyIn,
                onPressed: () {
                  PkHaptics.selection();
                  widget.onSignChanged?.call(!widget.negative);
                },
                icon: Icon(
                  widget.negative ? Icons.remove_rounded : Icons.add_rounded,
                ),
              ),
              const SizedBox(width: PkSpacing.x2),
            ],
            Expanded(
              // Section 6.11: the money input is already the largest text on
              // the screen, so its own scaling is capped — 32 px at 2.0x is
              // 64 px, which no phone width holds beside a currency prefix.
              // Every other string on the form still scales in full.
              child: MediaQuery.withClampedTextScaling(
                maxScaleFactor: 1.6,
                child: TextFormField(
                  key: widget.fieldKey ?? const ValueKey('transaction_amount'),
                  controller: widget.controller,
                  autofocus: widget.autofocus,
                  // Zero-decimal currencies get a plain number pad: a decimal
                  // point that cannot legally be used is a dead key.
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: decimals > 0,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      decimals > 0 ? RegExp(r'[0-9.,]') : RegExp(r'[0-9]'),
                    ),
                    _DecimalLimitFormatter(decimals),
                  ],
                  textAlign: TextAlign.center,
                  style: context.pkText.moneyInput.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  decoration: InputDecoration(
                    prefixText: '${info.symbol} ',
                    // Section 5.7: the currency stays attached to the number
                    // and may be smaller than it. Letting the prefix inherit
                    // the input's own size is what pushed the field past the
                    // screen edge at 2.0x.
                    prefixStyle: context.pkText.moneySection.copyWith(
                      color: context.pk.textSecondary,
                    ),
                    hintText: decimals == 0 ? '0' : '0.${'0' * decimals}',
                    labelText: widget.label ?? context.t.amount,
                    helperText: _preview(info),
                    helperMaxLines: 2,
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    isDense: true,
                  ),
                  validator: widget.validator,
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
        if (widget.quickAmounts.isNotEmpty) ...[
          const SizedBox(height: PkSpacing.x3),
          Wrap(
            spacing: PkSpacing.x2,
            alignment: WrapAlignment.center,
            children: [
              for (final amount in widget.quickAmounts)
                ActionChip(
                  key: ValueKey('quick_amount_$amount'),
                  label: Text(
                    PkFormat.money(
                      amount * info.minorUnitScale,
                      widget.currency,
                    ),
                  ),
                  onPressed: () {
                    PkHaptics.selection();
                    widget.controller.text = decimals == 0
                        ? '$amount'
                        : amount.toStringAsFixed(decimals);
                    widget.onChanged?.call(widget.controller.text);
                    setState(() {});
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }

  /// Echoes the typed value back formatted, so a mistyped amount is visible
  /// before the form is submitted rather than after.
  String? _preview(CurrencyInfo info) {
    final raw = widget.controller.text.replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value == 0) return null;
    return PkFormat.money(
      (value * info.minorUnitScale).round(),
      widget.currency,
    );
  }
}

/// Keeps a typed amount inside the currency's precision.
class _DecimalLimitFormatter extends TextInputFormatter {
  const _DecimalLimitFormatter(this.decimals);
  final int decimals;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '.');
    if (text.isEmpty) return newValue;
    final separators = '.'.allMatches(text).length;
    if (separators > 1) return oldValue;
    final dot = text.indexOf('.');
    if (dot >= 0 && text.length - dot - 1 > decimals) return oldValue;
    return newValue.copyWith(
      text: text,
      selection: TextSelection.collapsed(
        offset: newValue.selection.baseOffset.clamp(0, text.length),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Entity selection
// -----------------------------------------------------------------------------

/// The one field shape every rich selector wears, section 6.11.
///
/// A `DropdownButtonFormField` renders an entity as a bare string, cannot show
/// its icon or colour, has no search once the list passes eight, and clips
/// rather than wraps at large text sizes. This shows the current value with its
/// identity intact and opens a sheet to change it.
class PkSelectField extends StatelessWidget {
  const PkSelectField({
    super.key,
    required this.label,
    required this.onTap,
    this.value,
    this.placeholder,
    this.leading,
    this.errorText,
    this.enabled = true,
  });

  final String label;

  /// The current selection, already formatted for reading. Null shows
  /// [placeholder].
  final String? value;
  final String? placeholder;

  /// The selected entity's icon tile, colour swatch or avatar.
  final Widget? leading;
  final String? errorText;
  final VoidCallback onTap;
  final bool enabled;

  /// What the field is currently showing, whichever of the two it is.
  String get _shown => value ?? placeholder ?? '';

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: enabled,
    label: '$label, $_shown',
    excludeSemantics: true,
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(PkRadius.control),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          enabled: enabled,
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading!,
              const SizedBox(width: PkSpacing.x2),
            ],
            Expanded(
              child: Text(
                _shown,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: value == null
                    ? context.pkText.body.copyWith(
                        color: context.pk.textTertiary,
                      )
                    : context.pkText.body,
              ),
            ),
            Icon(
              Icons.expand_more_rounded,
              size: PkSize.icon,
              color: context.pk.textSecondary,
            ),
          ],
        ),
      ),
    ),
  );
}

// -----------------------------------------------------------------------------
// Date
// -----------------------------------------------------------------------------

/// A date control with the shortcuts people actually reach for.
class PkDateField extends StatelessWidget {
  const PkDateField({
    super.key,
    required this.value,
    required this.today,
    required this.onChanged,
    this.label,
    this.firstDate,
    this.lastDate,
  });

  final DateTime value;
  final DateTime today;
  final ValueChanged<DateTime> onChanged;
  final String? label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    final shortcuts = <String, DateTime>{
      context.t.today: DateTime(today.year, today.month, today.day),
      context.t.yesterday: DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(const Duration(days: 1)),
      context.t.lastWeek: DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(const Duration(days: 7)),
    };
    final current = DateTime(value.year, value.month, value.day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InputDecorator(
          decoration: InputDecoration(labelText: label ?? context.t.date),
          child: Row(
            children: [
              Expanded(child: Text(PkFormat.longDate(value, context.t))),
              IconButton(
                key: const ValueKey('pk_date_pick'),
                tooltip: context.t.pickADate,
                icon: const Icon(Icons.calendar_today_rounded, size: 18),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: value,
                    firstDate: firstDate ?? DateTime(today.year - 5),
                    lastDate: lastDate ?? DateTime(today.year + 1, 12, 31),
                  );
                  if (picked != null) {
                    PkHaptics.selection();
                    onChanged(picked);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: PkSpacing.x2),
        Wrap(
          spacing: PkSpacing.x2,
          children: [
            for (final entry in shortcuts.entries)
              ChoiceChip(
                key: ValueKey('date_shortcut_${entry.key}'),
                label: Text(entry.key),
                selected: current == entry.value,
                onSelected: (_) {
                  PkHaptics.selection();
                  onChanged(entry.value);
                },
              ),
          ],
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Account
// -----------------------------------------------------------------------------

abstract final class PkAccountPicker {
  /// Sentinel for "paid outside Pockito", so no wallet moves.
  static const outside = '__outside__';
}

Future<String?> showPkAccountPicker(
  BuildContext context, {
  required PockitoRepository repo,
  String? title,
  String? selectedId,
  bool allowOutside = false,
  String? outsideLabel,
  bool Function(Account)? where,
}) {
  final accounts = repo.accounts
      .where((item) => !item.archived && (where?.call(item) ?? true))
      .toList();
  return showPkSheet<String>(
    context,
    builder: (context) => _SearchableList<Account>(
      title: title ?? context.t.chooseAnAccountX,
      items: accounts,
      searchHint: context.t.searchAccounts,
      matches: (account, query) =>
          account.name.toLowerCase().contains(query) ||
          account.currency.toLowerCase().contains(query),
      leading: (context, account) => PkIconTile(
        icon: PkIcons.named(account.icon),
        color: PkPalette.categoryAt(account.colorIndex),
        size: 40,
        iconSize: 19,
      ),
      titleOf: (account) => account.name,
      // Showing the balance is the point: picking an account you cannot cover
      // is the mistake this control exists to prevent.
      subtitleOf: (account) =>
          '${account.currency} · ${PkFormat.money(repo.accountBalance(account), account.currency)}',
      selected: (account) => account.id == selectedId,
      idOf: (account) => account.id,
      extra: allowOutside
          ? _ExtraOption(
              id: PkAccountPicker.outside,
              icon: Icons.public_off_rounded,
              label: outsideLabel ?? context.t.outsidePockitoNoWalletMovement,
              selected: selectedId == PkAccountPicker.outside,
            )
          : null,
    ),
  );
}

// -----------------------------------------------------------------------------
// Category
// -----------------------------------------------------------------------------

Future<String?> showPkCategoryPicker(
  BuildContext context, {
  required PockitoRepository repo,
  required CategoryType type,
  String? selectedId,
  String? title,
}) {
  // Parents first, each followed by its children, so the hierarchy reads as a
  // hierarchy rather than an alphabetised pile.
  final ordered = <Category>[];
  for (final parent
      in repo.categoryChildren(null).where((item) => item.type == type)) {
    ordered
      ..add(parent)
      ..addAll(repo.categoryChildren(parent.id));
  }
  return showPkSheet<String>(
    context,
    builder: (context) => _SearchableList<Category>(
      title: title ?? context.t.chooseACategory,
      items: ordered,
      searchHint: context.t.searchCategories,
      matches: (category, query) => category.name.toLowerCase().contains(query),
      indentOf: (category) => category.parentId == null ? 0 : 1,
      leading: (context, category) => PkIconTile(
        icon: PkIcons.named(category.icon),
        color: PkPalette.categoryAt(category.colorIndex),
        size: 40,
        iconSize: 19,
      ),
      titleOf: (category) => category.name,
      subtitleOf: (category) => category.parentId == null
          ? null
          : context.t.inX0(repo.categoryById(category.parentId!)?.name ?? ''),
      selected: (category) => category.id == selectedId,
      idOf: (category) => category.id,
    ),
  );
}

// -----------------------------------------------------------------------------
// Currency
// -----------------------------------------------------------------------------

Future<String?> showPkCurrencyPicker(
  BuildContext context, {
  required PockitoRepository repo,
  String? selectedCode,
  String? title,
}) {
  final recents = repo.profile.recentCurrencies
      .map((code) => PockitoCurrencies.all[code])
      .whereType<CurrencyInfo>()
      .toList();
  final rest =
      PockitoCurrencies.all.values
          .where((info) => !recents.any((item) => item.code == info.code))
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));
  return showPkSheet<String>(
    context,
    builder: (context) => _SearchableList<CurrencyInfo>(
      title: title ?? context.t.chooseACurrency,
      items: [...recents, ...rest],
      searchHint: context.t.searchX0Currencies(PockitoCurrencies.all.length),
      sectionOf: (info) => recents.any((item) => item.code == info.code)
          ? 'Recent'
          : context.t.all,
      matches: (info, query) =>
          info.code.toLowerCase().contains(query) ||
          info.name.toLowerCase().contains(query) ||
          info.symbol.toLowerCase().contains(query),
      leading: (context, info) => SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            info.flag.isEmpty ? info.symbol : info.flag,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
      titleOf: (info) => '${info.code} · ${info.name}',
      subtitleOf: (info) => info.decimals == 0
          ? context.t.noDecimalPlaces(info.symbol)
          : context.t.decimalPlaces(info.symbol, info.decimals),
      selected: (info) => info.code == selectedCode,
      idOf: (info) => info.code,
    ),
  );
}

// -----------------------------------------------------------------------------
// Members
// -----------------------------------------------------------------------------

/// One person, rendered the same way in every list that shows people.
class PkMemberChip extends StatelessWidget {
  const PkMemberChip({
    super.key,
    required this.user,
    this.role,
    this.trailing,
    this.selected = false,
    this.onTap,
  });

  final PockitoUser user;
  final SpaceRole? role;
  final String? trailing;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => RawChip(
    avatar: PkAvatar(label: user.initials, size: 24),
    label: Text(
      [
        user.isYou ? context.t.you : user.name,
        ?role?.label,
        ?trailing,
      ].join(' · '),
    ),
    selected: selected,
    showCheckmark: false,
    onPressed: onTap,
  );
}

/// A member row with avatar, role and balance, shared by every members list.
class PkMemberRow extends StatelessWidget {
  const PkMemberRow({
    super.key,
    required this.user,
    required this.role,
    this.balanceMinor,
    this.currency,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final PockitoUser user;
  final SpaceRole role;
  final int? balanceMinor;
  final String? currency;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final name = user.isYou ? context.t.x0You(user.name) : user.name;
    final detail = subtitle ?? role.labelIn(context.t);
    // Section 7.17: 64 px, avatar 40, name and role on the left, balance
    // right — the same scan axis as every other Pockito row.
    return PkLedgerRow(
      semanticIdentifier: 'member_${user.id}',
      semanticLabel: [
        name,
        detail,
        if (balanceMinor != null && currency != null)
          PkBalanceLabel.announce(context, balanceMinor!, currency!),
      ].join(', '),
      leading: PkAvatar(label: user.initials, size: PkSize.avatarMember),
      title: name,
      subtitle: detail,
      trailing: balanceMinor != null && currency != null
          ? PkBalanceLabel(
              amountMinor: balanceMinor!,
              currency: currency!,
              compact: true,
            )
          : null,
      trailingSubtitle: trailing,
      onTap: onTap,
    );
  }
}

Future<String?> showPkMemberPicker(
  BuildContext context, {
  required PockitoRepository repo,
  required List<SpaceMember> members,
  String? selectedId,
  String? title,
  bool Function(SpaceMember)? where,
}) {
  final users = members
      .where((member) => member.active && (where?.call(member) ?? true))
      .map((member) => (member, repo.userById(member.userId)))
      .where((pair) => pair.$2 != null)
      .toList();
  return showPkSheet<String>(
    context,
    builder: (context) => _SearchableList<(SpaceMember, PockitoUser?)>(
      title: title ?? context.t.chooseAMember,
      items: users,
      searchHint: context.t.searchMembers,
      matches: (pair, query) =>
          (pair.$2?.name ?? '').toLowerCase().contains(query),
      leading: (context, pair) =>
          PkAvatar(label: pair.$2?.initials ?? '?', size: 40),
      titleOf: (pair) =>
          pair.$2?.isYou == true ? context.t.you : pair.$2?.name ?? 'Member',
      subtitleOf: (pair) => pair.$1.role.labelIn(context.t),
      selected: (pair) => pair.$1.userId == selectedId,
      idOf: (pair) => pair.$1.userId,
    ),
  );
}

// -----------------------------------------------------------------------------
// Tags
// -----------------------------------------------------------------------------

/// Chip input for tags, with inline creation.
class PkTagInput extends StatelessWidget {
  const PkTagInput({
    super.key,
    required this.available,
    required this.selectedIds,
    required this.onChanged,
    this.onCreate,
    this.label,
  });

  final List<Tag> available;
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;
  final Future<Tag?> Function(String name)? onCreate;
  final String? label;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label ?? context.t.tags,
        style: Theme.of(context).textTheme.labelLarge,
      ),
      const SizedBox(height: PkSpacing.x2),
      Wrap(
        spacing: PkSpacing.x2,
        runSpacing: PkSpacing.x2,
        children: [
          for (final tag in available)
            FilterChip(
              key: ValueKey('tag_${tag.id}'),
              label: Text(tag.name),
              avatar: CircleAvatar(
                radius: 6,
                backgroundColor: PkPalette.categoryAt(tag.colorIndex),
              ),
              selected: selectedIds.contains(tag.id),
              onSelected: (on) {
                PkHaptics.selection();
                onChanged(
                  on
                      ? [...selectedIds, tag.id]
                      : selectedIds
                            .where((id) => id != tag.id)
                            .toList(growable: false),
                );
              },
            ),
          if (onCreate != null)
            ActionChip(
              key: const ValueKey('tag_create'),
              avatar: const Icon(Icons.add_rounded, size: 16),
              label: Text(context.t.newTag),
              onPressed: () async {
                final name = await showPkTextPrompt(
                  context,
                  title: context.t.newTag,
                  hint: context.t.eGBerlinTrip,
                );
                if (name == null || name.trim().isEmpty) return;
                final tag = await onCreate!(name.trim());
                if (tag != null) onChanged([...selectedIds, tag.id]);
              },
            ),
        ],
      ),
    ],
  );
}

Future<String?> showPkTextPrompt(
  BuildContext context, {
  required String title,
  required String hint,
  String initialValue = '',
  String confirmLabel = 'Save',
  int maxLength = 60,
  int maxLines = 1,
}) {
  final controller = TextEditingController(text: initialValue);
  return showPkSheet<String>(
    context,
    builder: (context) => PkSheetScaffold(
      title: title,
      child: StatefulBuilder(
        builder: (context, setSheetState) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              key: const ValueKey('pk_text_prompt'),
              controller: controller,
              autofocus: true,
              maxLength: maxLength,
              maxLines: maxLines,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: hint,
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: context.t.clear,
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          controller.clear();
                          setSheetState(() {});
                        },
                      ),
              ),
              onChanged: (_) => setSheetState(() {}),
              onSubmitted: maxLines == 1
                  ? (value) => Navigator.pop(context, value)
                  : null,
            ),
            const SizedBox(height: PkSpacing.x3),
            FilledButton(
              key: const ValueKey('pk_text_prompt_save'),
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(confirmLabel),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(() async {
    // The sheet's result arrives before its exit animation has removed the
    // field, so the controller has to outlive the route.
    await Future<void>.delayed(PkMotion.standard);
    controller.dispose();
  });
}

// -----------------------------------------------------------------------------
// Tabs and tiles
// -----------------------------------------------------------------------------

/// The pinned tab strip, promoted out of the Spaces screen so every tabbed
/// surface pins its tabs the same way.
class PkTabs extends SliverPersistentHeaderDelegate {
  const PkTabs({required this.child, required this.background});

  final Widget child;
  final Color background;

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(color: background, child: child);

  @override
  bool shouldRebuild(PkTabs oldDelegate) =>
      oldDelegate.child != child || oldDelegate.background != background;
}

/// A label-over-figure tile. Two screens hand-rolled their own; this is the
/// one they now share.
class PkStatTile extends StatelessWidget {
  const PkStatTile({
    super.key,
    required this.label,
    required this.value,
    this.detail,
    this.detailColor,
    this.icon,
    this.onTap,
  });

  final String label;
  final String value;
  final String? detail;
  final Color? detailColor;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => PkCard(
    onTap: onTap,
    padding: const EdgeInsets.all(PkSpacing.x4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: PkSize.iconSmall,
                color: context.pk.textTertiary,
              ),
              const SizedBox(width: PkSpacing.x1),
            ],
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: PkSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        if (detail != null) ...[
          const SizedBox(height: 2),
          Text(
            detail!,
            maxLines: 2,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: detailColor),
          ),
        ],
      ],
    ),
  );
}

// -----------------------------------------------------------------------------
// Internals
// -----------------------------------------------------------------------------

class _ExtraOption {
  const _ExtraOption({
    required this.id,
    required this.icon,
    required this.label,
    required this.selected,
  });

  final String id;
  final IconData icon;
  final String label;
  final bool selected;
}

/// The list body behind every picker: search above roughly eight rows,
/// optional sections, optional one-level indentation.
class _SearchableList<T> extends StatefulWidget {
  const _SearchableList({
    super.key,
    required this.title,
    required this.items,
    required this.searchHint,
    required this.matches,
    required this.leading,
    required this.titleOf,
    required this.selected,
    required this.idOf,
    this.subtitleOf,
    this.sectionOf,
    this.indentOf,
    this.extra,
  });

  final String title;
  final List<T> items;
  final String searchHint;
  final bool Function(T, String) matches;
  final Widget Function(BuildContext, T) leading;
  final String Function(T) titleOf;
  final String? Function(T)? subtitleOf;
  final String Function(T)? sectionOf;
  final int Function(T)? indentOf;
  final bool Function(T) selected;
  final String Function(T) idOf;
  final _ExtraOption? extra;

  @override
  State<_SearchableList<T>> createState() => _SearchableListState<T>();
}

class _SearchableListState<T> extends State<_SearchableList<T>> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visible = query.isEmpty
        ? widget.items
        : widget.items.where((item) => widget.matches(item, query)).toList();
    // Below this many rows a search field is a control that costs more than
    // it saves.
    final searchable = widget.items.length > 8;
    String? lastSection;
    return PkSheetScaffold(
      title: widget.title,
      scrollable: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (searchable) ...[
            PkSearchField(
              value: _query,
              hintText: widget.searchHint,
              resultCount: visible.length,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: PkSpacing.x2),
          ],
          Flexible(
            child: visible.isEmpty && widget.extra == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: PkSpacing.x8),
                    child: Text(
                      context.t.nothingMatchesQuery(_query),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: [
                      if (widget.extra != null)
                        ListTile(
                          key: ValueKey('picker_${widget.extra!.id}'),
                          leading: PkIconTile(
                            icon: widget.extra!.icon,
                            color: context.pk.textTertiary,
                            size: 40,
                            iconSize: 19,
                          ),
                          title: Text(widget.extra!.label),
                          trailing: widget.extra!.selected
                              ? const Icon(Icons.check_rounded)
                              : null,
                          onTap: () => Navigator.pop(context, widget.extra!.id),
                        ),
                      for (final item in visible) ...[
                        if (widget.sectionOf != null &&
                            widget.sectionOf!(item) != lastSection)
                          Builder(
                            builder: (context) {
                              lastSection = widget.sectionOf!(item);
                              return Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                  0,
                                  PkSpacing.x3,
                                  0,
                                  PkSpacing.x1,
                                ),
                                child: Text(
                                  lastSection!,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                              );
                            },
                          ),
                        Padding(
                          padding: EdgeInsets.only(
                            left:
                                (widget.indentOf?.call(item) ?? 0) *
                                PkSpacing.x6,
                          ),
                          child: ListTile(
                            key: ValueKey('picker_${widget.idOf(item)}'),
                            contentPadding: EdgeInsets.zero,
                            leading: widget.leading(context, item),
                            title: Text(widget.titleOf(item)),
                            subtitle: widget.subtitleOf?.call(item) == null
                                ? null
                                : Text(widget.subtitleOf!(item)!),
                            trailing: widget.selected(item)
                                ? const Icon(Icons.check_rounded)
                                : null,
                            onTap: () {
                              PkHaptics.selection();
                              Navigator.pop(context, widget.idOf(item));
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// The search-and-sort strip a list carries once it stops being scannable.
///
/// Below [threshold] rows the controls would cost more room than they save, so
/// the strip renders nothing at all.
class PkListControls extends StatelessWidget {
  const PkListControls({
    super.key,
    required this.listId,
    required this.totalCount,
    required this.resultCount,
    required this.hintText,
    required this.sortOptions,
    required this.sort,
    required this.onSortChanged,
    required this.query,
    required this.onQueryChanged,
    this.threshold = 8,
    this.trailing,
  });

  final String listId;
  final int totalCount;
  final int resultCount;
  final String hintText;
  final List<PkSort> sortOptions;
  final PkSort sort;
  final ValueChanged<PkSort> onSortChanged;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final int threshold;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final searchable = totalCount > threshold;
    if (!searchable && trailing == null && sortOptions.length < 2) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: PkSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (searchable) ...[
            PkSearchField(
              key: ValueKey('search_$listId'),
              value: query,
              hintText: hintText,
              resultCount: resultCount,
              onChanged: onQueryChanged,
            ),
            const SizedBox(height: PkSpacing.x2),
          ],
          // Section 6.10: the control strip scrolls rather than clipping. A
          // sort label and a trailing action are both prose, and at 2.0x they
          // are wider than the phone they sit on.
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (sortOptions.length > 1)
                  PkSortButton(
                    key: ValueKey('sort_$listId'),
                    value: sort,
                    options: sortOptions,
                    onChanged: onSortChanged,
                  ),
                if (trailing != null) ...[
                  const SizedBox(width: PkSpacing.x2),
                  trailing!,
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
