import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/financial_models.dart';
import '../../features/accounts/views/accounts_screens.dart';
import '../../features/activity/views/activity_screens.dart';
import '../../features/activity/views/quick_add_screen.dart';
import '../../features/home/views/home_screen.dart';
import '../../features/manage/views/ai_screens.dart';
import '../../features/manage/views/data_screens.dart';
import '../../features/manage/views/finance_management_screens.dart';
import '../../features/manage/views/settings_screens.dart';
import '../../features/onboarding/views/onboarding_screens.dart';
import '../../features/search/views/global_search_screen.dart';
import '../../features/widget/views/home_widget_screen.dart';
import '../../features/spaces/views/spaces_screens.dart';
import '../components/pk_components.dart';
import '../design_system/pk_labels.dart';
import '../design_system/pk_tokens.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _accountsNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'accounts');
final _spacesNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'spaces');
final _moreNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'more');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          PockitoShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _accountsNavigatorKey,
          routes: [
            GoRoute(
              path: '/accounts',
              builder: (context, state) => const AccountsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _spacesNavigatorKey,
          routes: [
            GoRoute(
              path: '/spaces',
              builder: (context, state) => const SpacesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _moreNavigatorKey,
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/activity',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      path: '/widget',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HomeWidgetPreviewScreen(),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => GlobalSearchScreen(
        initialQuery: state.uri.queryParameters['q'] ?? '',
      ),
    ),
    // The hub was called Settings before it became a primary destination.
    // Existing links and deep links keep working.
    GoRoute(
      path: '/settings',
      parentNavigatorKey: _rootNavigatorKey,
      redirect: (context, state) => '/more',
    ),
    GoRoute(
      path: '/splash',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _fadePage(state, const SplashScreen()),
    ),
    GoRoute(
      path: '/auth',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _fadePage(state, const SignInScreen()),
    ),
    GoRoute(
      path: '/auth/error',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AuthErrorScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/invite-review',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const IncomingInviteReviewScreen(),
    ),
    // D-06: a personal expense or income opens the compact sheet; everything
    // advanced — transfers, shared, multi-payer, OCR, editing — opens the
    // full-screen editor at `/add`.
    GoRoute(
      path: '/add/quick',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        QuickAddScreen(
          initialType: state.uri.queryParameters['type'] == 'income'
              ? MoneyEventType.income
              : MoneyEventType.expense,
        ),
      ),
    ),
    GoRoute(
      path: '/add',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        AddMoneyEventScreen(
          accountId: state.uri.queryParameters['account'],
          spaceId: state.uri.queryParameters['space'],
          // Handed over by Quick Add when the reader asks for more options,
          // so nothing they already typed has to be typed again.
          initialCategoryId: state.uri.queryParameters['category'],
          initialAmount: state.uri.queryParameters['amount'],
          initialMerchant: state.uri.queryParameters['merchant'],
          transactionId: state.uri.queryParameters['transaction'],
          duplicateId: state.uri.queryParameters['duplicate'],
          sharedExpenseId: state.uri.queryParameters['shared'],
          duplicateSharedExpenseId:
              state.uri.queryParameters['duplicateShared'],
          initialType: switch (state.uri.queryParameters['type']) {
            'income' => MoneyEventType.income,
            'transfer' => MoneyEventType.transfer,
            'expense' => MoneyEventType.expense,
            _ => null,
          },
          openScanner: state.uri.queryParameters['scan'] == '1',
        ),
      ),
    ),
    GoRoute(
      path: '/home/net-worth',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NetWorthBreakdownScreen(),
    ),
    GoRoute(
      path: '/accounts/new',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const AccountEditorScreen()),
    ),
    GoRoute(
      path: '/accounts/archived',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ArchivedAccountsScreen(),
    ),
    GoRoute(
      path: '/accounts/reorder',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ReorderAccountsScreen(),
    ),
    GoRoute(
      path: '/accounts/:accountId/edit',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        AccountEditorScreen(accountId: state.pathParameters['accountId']),
      ),
    ),
    GoRoute(
      path: '/accounts/:accountId/reconcile',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        ReconcileAccountScreen(accountId: state.pathParameters['accountId']!),
      ),
    ),
    GoRoute(
      path: '/accounts/:accountId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          AccountDetailScreen(accountId: state.pathParameters['accountId']!),
    ),
    GoRoute(
      path: '/spaces/new',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const CreateSpaceScreen()),
    ),
    GoRoute(
      path: '/spaces/archived',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ArchivedSpacesScreen(),
    ),
    GoRoute(
      path: '/spaces/:spaceId/members',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SpaceMembersScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/activity',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SpaceActivityLogScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SpaceSettingsScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/settle',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SettleUpScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/settled',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _fadePage(
        state,
        SettlementSuccessScreen(spaceId: state.pathParameters['spaceId']!),
      ),
    ),
    GoRoute(
      path: '/spaces/:spaceId/settlements',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SettlementHistoryScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/settlements/:settlementId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SettlementDetailScreen(
        spaceId: state.pathParameters['spaceId']!,
        settlementId: state.pathParameters['settlementId']!,
      ),
    ),
    GoRoute(
      path: '/spaces/:spaceId/cycles',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SpaceCyclesScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/spaces/:spaceId/cycles/:cycleId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SpaceCycleDetailScreen(
        spaceId: state.pathParameters['spaceId']!,
        cycleId: state.pathParameters['cycleId']!,
      ),
    ),
    GoRoute(
      path: '/spaces/:spaceId/expenses/:expenseId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SharedExpenseDetailScreen(
        spaceId: state.pathParameters['spaceId']!,
        expenseId: state.pathParameters['expenseId']!,
      ),
    ),
    GoRoute(
      path: '/spaces/:spaceId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          SpaceDetailScreen(spaceId: state.pathParameters['spaceId']!),
    ),
    GoRoute(
      path: '/activity/:transactionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => TransactionDetailScreen(
        transactionId: state.pathParameters['transactionId']!,
      ),
    ),
    GoRoute(
      path: '/budgets',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BudgetsScreen(),
    ),
    GoRoute(
      path: '/budgets/new',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const BudgetEditorScreen()),
    ),
    GoRoute(
      path: '/budgets/:budgetId/edit',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        BudgetEditorScreen(budgetId: state.pathParameters['budgetId']),
      ),
    ),
    GoRoute(
      path: '/budgets/:budgetId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          BudgetDetailScreen(budgetId: state.pathParameters['budgetId']!),
    ),
    GoRoute(
      path: '/subscriptions',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SubscriptionsScreen(),
    ),
    GoRoute(
      path: '/subscriptions/new',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const SubscriptionEditorScreen()),
    ),
    GoRoute(
      path: '/subscriptions/:subscriptionId/edit',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) => _sheetPage(
        state,
        SubscriptionEditorScreen(
          subscriptionId: state.pathParameters['subscriptionId'],
        ),
      ),
    ),
    GoRoute(
      path: '/subscriptions/:subscriptionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SubscriptionDetailScreen(
        subscriptionId: state.pathParameters['subscriptionId']!,
      ),
    ),
    GoRoute(
      path: '/tags',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TagsScreen(),
    ),
    GoRoute(
      path: '/payment-methods',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/data',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DataScreen(),
    ),
    GoRoute(
      path: '/categories',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CategoriesScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/settings/profile',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const EditProfileScreen()),
    ),
    GoRoute(
      path: '/settings/currency',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CurrencySettingsScreen(),
    ),
    GoRoute(
      path: '/settings/exchange-rates',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ExchangeRatesScreen(),
    ),
    GoRoute(
      path: '/settings/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/appearance',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const AppearanceScreen()),
    ),
    GoRoute(
      path: '/settings/language',
      parentNavigatorKey: _rootNavigatorKey,
      pageBuilder: (context, state) =>
          _sheetPage(state, const LanguageScreen()),
    ),
    GoRoute(
      path: '/settings/about',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: '/settings/states',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PrototypeStatesScreen(),
    ),
    GoRoute(
      path: '/ai',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AiConnectionsScreen(),
    ),
    GoRoute(
      path: '/ai/connect',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConnectAiScreen(),
    ),
    GoRoute(
      path: '/ai/authorize',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => AiAuthorizationScreen(
        client: state.uri.queryParameters['client'] ?? context.t.aiApp,
        verified: state.uri.queryParameters['verified'] == 'true',
      ),
    ),
    GoRoute(
      path: '/ai/activity',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AiActivityScreen(),
    ),
    GoRoute(
      path: '/ai/approvals',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AiApprovalsScreen(),
    ),
    GoRoute(
      path: '/ai/:connectionId',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => AiConnectionDetailScreen(
        connectionId: state.pathParameters['connectionId']!,
      ),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(),
    body: PkEmptyState(
      icon: Icons.map_outlined,
      title: context.t.weCouldnTFindThat,
      message: context.t.nothingOpensAtYourMoney(state.uri.path),
      actionLabel: context.t.goToHome,
      onAction: () => context.go('/home'),
    ),
  ),
);

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) =>
    CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: PkMotion.standard,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: PkMotion.enter),
            child: child,
          ),
    );

CustomTransitionPage<void> _sheetPage(
  GoRouterState state,
  Widget child,
) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: child,
  fullscreenDialog: true,
  transitionDuration: PkMotion.standard,
  reverseTransitionDuration: PkMotion.fast,
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: child,
      ),
);

class PockitoShell extends StatelessWidget {
  const PockitoShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final destinations = pockitoDestinations(context.t);
      final wide = constraints.maxWidth >= 900;
      void select(int index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
      void add() => showPkAddLauncher(context);
      if (wide) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                right: false,
                child: NavigationRail(
                  extended: constraints.maxWidth >= 1180,
                  minExtendedWidth: 216,
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: select,
                  backgroundColor: context.pk.surface,
                  indicatorColor:
                      Theme.of(context).brightness == Brightness.light
                      ? PkPalette.kitoBlue50
                      : PkPalette.kitoNavy700,
                  leading: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: PkSpacing.x3),
                        child: PkMark(size: 52),
                      ),
                      const SizedBox(height: PkSpacing.x5),
                      PkAddButton(onPressed: add, size: 48),
                      const SizedBox(height: PkSpacing.x5),
                    ],
                  ),
                  destinations: [
                    for (final destination in destinations)
                      NavigationRailDestination(
                        icon: Icon(destination.icon),
                        selectedIcon: Icon(destination.selectedIcon),
                        label: Text(destination.label),
                      ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: context.pk.borderSubtle),
              Expanded(child: navigationShell),
            ],
          ),
        );
      }
      return Scaffold(
        // The bar floats over the page: content passes underneath it rather
        // than stopping at a hard edge. Scaffold then reports the bar's height
        // to the body through MediaQuery padding, which is what PkPage uses to
        // reserve exactly enough trailing space to scroll the last row clear.
        extendBody: true,
        body: navigationShell,
        bottomNavigationBar: PkBottomNav(
          destinations: destinations,
          currentIndex: navigationShell.currentIndex,
          onSelected: select,
          onAdd: add,
        ),
      );
    },
  );
}

/// Pockito's primary destinations, in shell-branch order.
///
/// Activity, budgets, subscriptions, categories, connections and preferences
/// all live behind More, which is the same hub that used to be reached only
/// from the small avatar on Home.
List<PkNavDestination> pockitoDestinations(PkStrings t) => [
  PkNavDestination(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
    label: t.navHome,
  ),
  PkNavDestination(
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
    label: t.navAccounts,
  ),
  PkNavDestination(
    icon: Icons.group_outlined,
    selectedIcon: Icons.group_rounded,
    label: t.navSpaces,
  ),
  PkNavDestination(
    icon: Icons.grid_view_outlined,
    selectedIcon: Icons.grid_view_rounded,
    label: t.navMore,
  ),
];
