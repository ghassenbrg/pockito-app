/// The catalogue of every Pockito surface the UI/UX program has to prove.
///
/// `docs/pockito-mobile-ui-ux-audit.md` UI-001 asks for "a visual-test manifest
/// listing all routes/states". This file *is* that manifest: the acceptance,
/// responsive, accessibility and golden suites all iterate it rather than each
/// keeping a private list that drifts. Adding a route to the router without
/// adding it here is what the manifest-coverage test fails on.
library;

import 'package:flutter/material.dart';

/// How a surface is reached and what it is for.
enum PkSurfaceKind {
  /// A bottom-navigation branch root. Carries the shell and the floating nav.
  shellRoot,

  /// A pushed full-screen route.
  pushed,

  /// A route presented as a full-screen sheet (`fullscreenDialog`).
  sheetRoute,

  /// An entry/auth surface shown before the shell exists.
  entry,

  /// A prototype/debug surface that must not ship in a release build.
  debug,
}

/// One route in the manifest, with the fixtures needed to render it.
@immutable
class PkSurface {
  const PkSurface({
    required this.id,
    required this.route,
    required this.kind,
    this.states = const [PkSurfaceState.ready],
    this.densityFloor,
    this.skipGolden = false,
  });

  /// Stable identifier used for golden file names.
  final String id;

  /// The concrete location, already carrying any fixture ids it needs.
  final String route;

  final PkSurfaceKind kind;

  /// The states section 9.7 requires evidence for on this route.
  final List<PkSurfaceState> states;

  /// Minimum number of primary rows that must fit at 390x844, default text,
  /// per section 9.3. Null where the audit sets no capacity target.
  final int? densityFloor;

  /// Golden coverage is skipped for surfaces whose pixels are dominated by an
  /// animation or a live clock rather than layout.
  final bool skipGolden;

  @override
  String toString() => '$id ($route)';
}

/// The state matrix from section 9.7.
enum PkSurfaceState {
  ready,
  empty,
  loading,
  error,
  offline,
  denied,
  readOnly,
  success,
  largeData,
}

/// Every surface the audit's acceptance matrix covers.
///
/// Fixture ids come from `MockPockitoRepository`.
const List<PkSurface> pkSurfaceManifest = [
  // ---- Primary destinations -------------------------------------------
  PkSurface(
    id: 'home',
    route: '/home',
    kind: PkSurfaceKind.shellRoot,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.empty,
      PkSurfaceState.loading,
      PkSurfaceState.offline,
    ],
  ),
  PkSurface(
    id: 'accounts',
    route: '/accounts',
    kind: PkSurfaceKind.shellRoot,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.empty,
      PkSurfaceState.loading,
    ],
    densityFloor: 5,
  ),
  PkSurface(
    id: 'spaces',
    route: '/spaces',
    kind: PkSurfaceKind.shellRoot,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.empty,
      PkSurfaceState.loading,
    ],
    densityFloor: 3,
  ),
  PkSurface(
    id: 'more',
    route: '/more',
    kind: PkSurfaceKind.shellRoot,
    densityFloor: 7,
  ),

  // ---- Money -----------------------------------------------------------
  PkSurface(
    id: 'activity',
    route: '/activity',
    kind: PkSurfaceKind.pushed,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.empty,
      PkSurfaceState.loading,
      PkSurfaceState.largeData,
    ],
    densityFloor: 5,
  ),
  PkSurface(
    id: 'transaction-detail',
    route: '/activity/t_coffee',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'add-money-event',
    route: '/add',
    kind: PkSurfaceKind.sheetRoute,
    skipGolden: true,
  ),
  PkSurface(
    id: 'quick-add',
    route: '/add/quick',
    kind: PkSurfaceKind.sheetRoute,
    skipGolden: true,
  ),
  PkSurface(
    id: 'net-worth',
    route: '/home/net-worth',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'home-insights',
    route: '/home/insights',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(id: 'search', route: '/search', kind: PkSurfaceKind.pushed),

  // ---- Accounts --------------------------------------------------------
  PkSurface(
    id: 'account-detail',
    route: '/accounts/a_rev',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'account-editor',
    route: '/accounts/new',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'account-reconcile',
    route: '/accounts/a_rev/reconcile',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'account-edit',
    route: '/accounts/a_rev/edit',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'accounts-archived',
    route: '/accounts/archived',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'accounts-reorder',
    route: '/accounts/reorder',
    kind: PkSurfaceKind.pushed,
  ),

  // ---- Spaces ----------------------------------------------------------
  PkSurface(
    id: 'space-detail',
    route: '/spaces/s_flat',
    kind: PkSurfaceKind.pushed,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.readOnly,
      PkSurfaceState.denied,
    ],
  ),
  PkSurface(
    id: 'space-members',
    route: '/spaces/s_flat/members',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-settings',
    route: '/spaces/s_flat/settings',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-activity',
    route: '/spaces/s_flat/activity',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-settle',
    route: '/spaces/s_flat/settle',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-settlements',
    route: '/spaces/s_flat/settlements',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-cycles',
    route: '/spaces/s_flat/cycles',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'space-cycle-detail',
    route: '/spaces/s_flat/cycles/cycle_flat_july',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'shared-expense-detail',
    route: '/spaces/s_flat/expenses/x_util',
    kind: PkSurfaceKind.pushed,
    states: [
      PkSurfaceState.ready,
      PkSurfaceState.readOnly,
      PkSurfaceState.denied,
    ],
  ),
  PkSurface(
    id: 'settlement-detail',
    route: '/spaces/s_flat/settlements/st_jul',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'settlement-success',
    route: '/spaces/s_flat/settled',
    kind: PkSurfaceKind.pushed,
    states: [PkSurfaceState.success],
    // A celebration animation, so its pixels are motion rather than layout.
    skipGolden: true,
  ),
  PkSurface(
    id: 'space-create',
    route: '/spaces/new',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'spaces-archived',
    route: '/spaces/archived',
    kind: PkSurfaceKind.pushed,
  ),

  // ---- Management ------------------------------------------------------
  PkSurface(id: 'budgets', route: '/budgets', kind: PkSurfaceKind.pushed),
  PkSurface(
    id: 'budget-detail',
    route: '/budgets/b_gro',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'budget-editor',
    route: '/budgets/new',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'budget-edit',
    route: '/budgets/b_gro/edit',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'subscriptions',
    route: '/subscriptions',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'subscription-editor',
    route: '/subscriptions/new',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'subscription-edit',
    route: '/subscriptions/sb_dom/edit',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'subscription-detail',
    route: '/subscriptions/sb_dom',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(id: 'categories', route: '/categories', kind: PkSurfaceKind.pushed),
  PkSurface(id: 'tags', route: '/tags', kind: PkSurfaceKind.pushed),
  PkSurface(
    id: 'payment-methods',
    route: '/payment-methods',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(id: 'data', route: '/data', kind: PkSurfaceKind.pushed),

  // ---- AI --------------------------------------------------------------
  PkSurface(id: 'ai-connections', route: '/ai', kind: PkSurfaceKind.pushed),
  PkSurface(id: 'ai-connect', route: '/ai/connect', kind: PkSurfaceKind.pushed),
  PkSurface(
    id: 'ai-authorize',
    route: '/ai/authorize',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'ai-activity',
    route: '/ai/activity',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'ai-approvals',
    route: '/ai/approvals',
    kind: PkSurfaceKind.pushed,
  ),

  // ---- System ----------------------------------------------------------
  PkSurface(
    id: 'notifications',
    route: '/notifications',
    kind: PkSurfaceKind.pushed,
    densityFloor: 6,
  ),
  PkSurface(
    id: 'settings-profile',
    route: '/settings/profile',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'settings-currency',
    route: '/settings/currency',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'settings-exchange-rates',
    route: '/settings/exchange-rates',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'settings-notifications',
    route: '/settings/notifications',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(
    id: 'settings-appearance',
    route: '/settings/appearance',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'settings-language',
    route: '/settings/language',
    kind: PkSurfaceKind.sheetRoute,
  ),
  PkSurface(
    id: 'settings-about',
    route: '/settings/about',
    kind: PkSurfaceKind.pushed,
  ),
  PkSurface(id: 'widget', route: '/widget', kind: PkSurfaceKind.pushed),

  // ---- Entry -----------------------------------------------------------
  PkSurface(
    id: 'splash',
    route: '/splash',
    kind: PkSurfaceKind.entry,
    skipGolden: true,
  ),
  PkSurface(id: 'sign-in', route: '/auth', kind: PkSurfaceKind.entry),
  PkSurface(
    id: 'auth-error',
    route: '/auth/error',
    kind: PkSurfaceKind.entry,
    states: [PkSurfaceState.error],
  ),
  PkSurface(
    id: 'onboarding',
    route: '/onboarding',
    kind: PkSurfaceKind.entry,
    skipGolden: true,
  ),
  PkSurface(
    id: 'invite-review',
    route: '/invite-review',
    kind: PkSurfaceKind.entry,
  ),

  // ---- Debug -----------------------------------------------------------
  PkSurface(
    id: 'prototype-states',
    route: '/settings/states',
    kind: PkSurfaceKind.debug,
    skipGolden: true,
  ),
];

/// The device matrix from section 9.1.
@immutable
class PkViewport {
  const PkViewport({
    required this.name,
    required this.size,
    this.brightness = Brightness.light,
    this.textScale = 1,
  });

  final String name;
  final Size size;
  final Brightness brightness;
  final double textScale;

  @override
  String toString() => name;
}

const pkPhone = Size(390, 844);
const pkNarrowPhone = Size(320, 568);

const List<PkViewport> pkDeviceMatrix = [
  PkViewport(name: '320x568-light-1.0', size: pkNarrowPhone),
  PkViewport(
    name: '360x800-dark-1.0',
    size: Size(360, 800),
    brightness: Brightness.dark,
  ),
  PkViewport(name: '390x844-light-1.0', size: pkPhone),
  PkViewport(
    name: '390x844-dark-1.0',
    size: pkPhone,
    brightness: Brightness.dark,
  ),
  PkViewport(name: '390x844-light-1.3', size: pkPhone, textScale: 1.3),
  PkViewport(name: '430x932-light-2.0', size: Size(430, 932), textScale: 2),
  PkViewport(name: '768x1024-tablet-portrait', size: Size(768, 1024)),
  PkViewport(name: '1024x768-tablet-landscape', size: Size(1024, 768)),
  PkViewport(name: '1280x800-desktop', size: Size(1280, 800)),
];

/// The subset section 9.1 mandates even outside the standard matrix.
const List<PkViewport> pkStressMatrix = [
  PkViewport(name: '320x568-light-1.0', size: pkNarrowPhone),
  PkViewport(name: '320x568-light-2.0', size: pkNarrowPhone, textScale: 2),
];
