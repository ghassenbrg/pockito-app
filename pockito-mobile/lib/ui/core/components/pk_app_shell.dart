import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../features/home/home_screen.dart';
import '../../features/settings/settings_screen.dart';

/// The navigation shell an authenticated user lives in.
///
/// Two destinations today. It exists now rather than later because adding the
/// finance sections should be a matter of adding destinations, not restructuring
/// how the app is navigated.
class PkAppShell extends StatefulWidget {
  const PkAppShell({super.key});

  @override
  State<PkAppShell> createState() => _PkAppShellState();
}

class _PkAppShellState extends State<PkAppShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      // IndexedStack rather than rebuilding: switching tabs should not discard
      // scroll position or re-fetch anything.
      body: IndexedStack(
        index: _index,
        children: const [HomeScreen(), SettingsScreen()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
