import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design_system/pk_tokens.dart';
import '../design_system/pk_labels.dart';
import 'pk_components.dart';

/// A primary destination in the Pockito shell.
///
/// The same list drives the floating phone navigation and the wide-screen rail
/// so the two can never drift apart.
@immutable
class PkNavDestination {
  const PkNavDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// The primary destination a screen belongs to.
///
/// Deep links replace the navigator stack, so a screen opened by link has
/// nothing to pop. Rather than stranding the reader, back takes them to the
/// destination that owns the screen.
String pockitoParentLocation(String location) {
  if (location.startsWith('/accounts')) return '/accounts';
  if (location.startsWith('/spaces')) return '/spaces';
  if (location.startsWith('/home')) return '/home';
  // Activity, budgets, subscriptions, categories, notifications, connections
  // and preferences all live under More.
  return '/more';
}

/// An app bar that is never a dead end.
///
/// `AppBar` only draws a back button when the navigator can pop, so a screen
/// reached by deep link showed no way out at all. This supplies one that falls
/// back to the owning destination.
class PkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PkAppBar({
    super.key,
    this.title,
    this.actions = const [],
    this.leading,
    this.bottom,
    this.automaticallyImplyLeading = true,
  });

  final Widget? title;
  final List<Widget> actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final stranded =
        leading == null &&
        automaticallyImplyLeading &&
        !(ModalRoute.of(context)?.canPop ?? false);
    return AppBar(
      title: title,
      actions: actions,
      bottom: bottom,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: stranded
          ? Builder(
              builder: (context) => IconButton(
                onPressed: () => context.go(
                  pockitoParentLocation(GoRouterState.of(context).uri.path),
                ),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            )
          : leading,
    );
  }
}

/// The central add action.
///
/// It wears Kito's own cobalt-to-aqua gradient so the app's primary action is
/// unmistakably Pockito, and it deliberately leaves gold free to keep meaning
/// "shared money" everywhere else in the product.
class PkAddButton extends StatelessWidget {
  const PkAddButton({
    super.key,
    required this.onPressed,
    this.size = PkSize.navAdd,
  });

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: context.t.addMoneyEvent,
    // A stable identifier alongside the translated name, so tests and
    // automation can find the control in any language.
    identifier: 'add_money_event',
    // A tooltip here would hang over the navigation labels on hover, so the
    // semantics label carries the accessible name on its own.
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: PkGradients.brand,
        boxShadow: PkShadows.floating(PkPalette.kitoBlue700),
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(Icons.add_rounded, size: size * .5, color: Colors.white),
        ),
      ),
    ),
  );
}

/// Pockito's floating phone navigation.
///
/// The bar is a rounded container that clears the screen edges and the gesture
/// indicator, so page content passes underneath it instead of butting against a
/// hard rule. The selected destination is marked three ways that do not depend
/// on colour alone: a filled icon, a tinted pill behind it, and a heavier label.
class PkBottomNav extends StatelessWidget {
  const PkBottomNav({
    super.key,
    required this.destinations,
    required this.currentIndex,
    required this.onSelected,
    required this.onAdd,
  });

  /// Handle for the density suite, which measures what fits *above* the bar.
  /// Counting rows the bar covers would overstate every screen.
  static const containerKey = ValueKey('pk_bottom_nav');

  final List<PkNavDestination> destinations;
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final VoidCallback onAdd;

  /// How far the add action rises above the bar's top edge.
  static const double _lift = 12;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    // Half the destinations sit either side of the central add action.
    final half = (destinations.length / 2).ceil();
    return SafeArea(
      top: false,
      child: MediaQuery.withClampedTextScaling(
        // The bar has a fixed height by design; clamping keeps every label
        // readable at large text sizes instead of clipping it.
        maxScaleFactor: 1.3,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            PkSize.navInset,
            0,
            PkSize.navInset,
            PkSize.navInset,
          ),
          child: SizedBox(
            key: containerKey,
            height: PkSize.navBar + _lift,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: PkSize.navBar,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      // `raised` rather than `surface`: in dark mode the page
                      // and the surface are nearly the same navy, and a
                      // floating bar has to read as lifted off the page.
                      color: context.pk.raised,
                      borderRadius: BorderRadius.circular(PkRadius.modal),
                      border: Border.all(
                        color: light
                            ? context.pk.borderSubtle
                            : context.pk.borderDefault,
                      ),
                      boxShadow: PkShadows.floating(
                        light ? PkPalette.kitoBlue700 : Colors.black,
                      ),
                    ),
                    child: Row(
                      children: [
                        for (var index = 0; index < half; index++)
                          Expanded(child: _item(index)),
                        const SizedBox(width: PkSize.navAdd + PkSpacing.x2),
                        for (
                          var index = half;
                          index < destinations.length;
                          index++
                        )
                          Expanded(child: _item(index)),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: PkSize.navAdd,
                  child: Center(child: PkAddButton(onPressed: onAdd)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int index) => _PkNavItem(
    destination: destinations[index],
    selected: index == currentIndex,
    onTap: () => onSelected(index),
  );
}

class _PkNavItem extends StatelessWidget {
  const _PkNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final PkNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;
    final primary = Theme.of(context).colorScheme.primary;
    final color = selected ? primary : context.pk.textTertiary;
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : PkMotion.fast;
    return Semantics(
      selected: selected,
      button: true,
      label: destination.label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: onTap,
        radius: 40,
        containedInkWell: false,
        // Material's default grey hover reads exactly like the selected pill.
        // Brand-tinted, lighter feedback keeps the two states distinct.
        hoverColor: primary.withValues(alpha: .05),
        splashColor: primary.withValues(alpha: .10),
        highlightColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: PkSize.navTarget,
            minHeight: PkSize.navTarget,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: duration,
                curve: PkMotion.enter,
                padding: const EdgeInsets.symmetric(
                  horizontal: PkSpacing.x3,
                  vertical: PkSpacing.x1,
                ),
                decoration: BoxDecoration(
                  // The dark bar is already navy-700, so a navy-700 pill would
                  // be invisible. A translucent cobalt wash keeps the third,
                  // non-colour-dependent cue readable on both themes.
                  color: selected
                      ? (light
                            ? PkPalette.kitoBlue100
                            : primary.withValues(alpha: .22))
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(PkRadius.full),
                ),
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  size: PkSize.iconLarge - 2,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  destination.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: color,
                    letterSpacing: 0,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The fast transaction launcher behind the central add action.
///
/// Every option jumps straight into the existing add flow with the right kind
/// of money event already chosen, so the launcher removes a step instead of
/// adding one.
Future<void> showPkAddLauncher(
  BuildContext context, {
  String? accountId,
  String? spaceId,
}) async {
  // Four 56 px rows and a header fit the compact contract comfortably.
  final choice = await showPkSheet<String>(
    context,
    size: PkSheetSize.compact,
    // The launcher is opened from inside a shell branch, so it has to sit on
    // the root navigator — otherwise the route it chooses is pushed into the
    // branch behind it and nothing appears to happen.
    useRootNavigator: true,
    builder: (context) => const _PkAddLauncher(),
  );
  if (choice == null || !context.mounted) return;
  final query = <String, String>{
    'type': choice == 'scan' ? 'expense' : choice,
    if (choice == 'scan') 'scan': '1',
    'account': ?accountId,
    'space': ?spaceId,
  };
  // D-06: a plain personal expense or income can be finished in one viewport,
  // so it gets the compact sheet. A transfer, a scan or anything already bound
  // to a Space is advanced work and opens the full editor.
  final quick = (choice == 'expense' || choice == 'income') && spaceId == null;
  context.push(
    Uri(path: quick ? '/add/quick' : '/add', queryParameters: query).toString(),
  );
}

class _PkAddLauncher extends StatelessWidget {
  const _PkAddLauncher();

  @override
  Widget build(BuildContext context) => PkSheetScaffold(
    title: context.t.addMoney,
    subtitle: context.t.pickWhatHappenedYouCan,
    // Section 6.15: three to five contextual choices, each 56–64 px, each with
    // text and an icon. A 2x2 grid of tall cards was neither: it cost twice
    // the height and made the four options read as a menu of features rather
    // than as one question with four answers.
    child: PkGroupedSurface(
      indent: PkSpacing.x4 + PkSize.iconTileDense + PkSpacing.x3,
      children: [
        _PkAddOption(
          id: 'expense',
          icon: Icons.north_east_rounded,
          label: context.t.expense,
          hint: context.t.addHintMoneyOut,
          color: Theme.of(context).colorScheme.primary,
        ),
        _PkAddOption(
          id: 'income',
          icon: Icons.south_west_rounded,
          label: context.t.income,
          hint: context.t.addHintMoneyIn,
          color: context.pk.success,
        ),
        _PkAddOption(
          id: 'transfer',
          icon: Icons.swap_horiz_rounded,
          label: context.t.transfer,
          hint: context.t.betweenAccounts,
          color: PkPalette.kitoAqua500,
        ),
        _PkAddOption(
          id: 'scan',
          icon: Icons.document_scanner_outlined,
          label: context.t.scan,
          hint: context.t.readAReceipt,
          color: context.pk.textSecondary,
        ),
      ],
    ),
  );
}

class _PkAddOption extends StatelessWidget {
  const _PkAddOption({
    required this.id,
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
  });

  final String id;
  final IconData icon;
  final String label;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) => PkLedgerRow.management(
    key: ValueKey('add_launcher_$id'),
    semanticIdentifier: 'add_launcher_$id',
    leading: PkIconTile(icon: icon, color: color),
    title: label,
    subtitle: hint,
    showChevron: true,
    onTap: () => Navigator.pop(context, id),
  );
}
