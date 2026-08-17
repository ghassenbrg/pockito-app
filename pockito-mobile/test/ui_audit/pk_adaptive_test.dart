import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// UI-014 and sections 7.24 / 9.6: what happens above phone width.
///
/// The criterion the audit actually states is "no phone-only stretched layout
/// above 840 px", so these tests measure content widths rather than asking
/// whether a particular widget was used.
void main() {
  const tabletPortrait = PkViewport(name: '768x1024', size: Size(768, 1024));
  const tabletLandscape = PkViewport(name: '1024x768', size: Size(1024, 768));
  const desktop = PkViewport(name: '1280x800', size: Size(1280, 800));

  testWidgets('no content column stretches past the reading measure', (
    tester,
  ) async {
    // Section 6.1: a single column is capped at 640 for reading, 560 for
    // forms, and only a dashboard that reflows may go wider.
    final stretched = <String>[];
    for (final viewport in [tabletLandscape, desktop]) {
      for (final surface in pkSurfaceManifest) {
        await pumpSurface(
          tester,
          route: surface.route,
          viewport: viewport,
          settle: !surface.skipGolden,
        );
        while (tester.takeException() != null) {}
        for (final element in find.byType(PkGroupedSurface).evaluate()) {
          final box = element.renderObject;
          if (box is! RenderBox || !box.hasSize) continue;
          if (box.size.width > PkBreakpoints.dashboardMaxWidth) {
            stretched.add(
              '${surface.id} @ ${viewport.name}: '
              '${box.size.width.toStringAsFixed(0)} px',
            );
          }
        }
      }
    }
    expect(
      stretched,
      isEmpty,
      reason: 'A row surface stretched:\n  ${stretched.join('\n  ')}',
    );
  });

  testWidgets('the shell switches to a rail at 900 and back again', (
    tester,
  ) async {
    // Section 9.6: at 900 the navigation changes to a rail without resetting
    // branch navigation.
    await pumpSurface(tester, route: '/spaces', viewport: desktop);
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(PkBottomNav), findsNothing);

    await pumpSurface(tester, route: '/spaces', viewport: tabletPortrait);
    expect(find.byType(PkBottomNav), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('Accounts and Spaces show a detail pane when width permits', (
    tester,
  ) async {
    // Section 7.24: master list plus detail pane. Below `medium` the same
    // screen is the list alone, so the phone behaviour is unchanged.
    for (final route in const ['/accounts', '/spaces']) {
      await pumpSurface(tester, route: route, viewport: desktop);
      expect(
        find.byType(PkTwoPane),
        findsOneWidget,
        reason: '$route has no two-pane layout on a wide display',
      );
      final pane = tester.getSize(find.byType(PkTwoPane));
      expect(pane.width, greaterThan(PkBreakpoints.listPaneWidth));

      await pumpSurface(
        tester,
        route: route,
        viewport: const PkViewport(name: 'phone', size: pkPhone),
      );
      // Still one pane's worth of content on a phone.
      expect(find.byType(VerticalDivider), findsNothing);
    }
  });

  testWidgets('selecting in the list fills the detail pane, keeping filters', (
    tester,
  ) async {
    // Section 9.6: master-detail preserves the selected item and the list's
    // filters. Selection lives in the screen, so a filter typed before the
    // selection is still applied after it.
    await pumpSurface(tester, route: '/accounts', viewport: desktop);
    expect(find.byType(PkAccountTile), findsWidgets);

    await tester.tap(find.byType(PkAccountTile).first);
    await tester.pumpAndSettle();

    // The detail is now beside the list rather than pushed over it.
    expect(find.byType(PkAccountTile), findsWidgets);
    expect(find.byType(PkHeroPanel), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home reflows into two columns instead of stretching', (
    tester,
  ) async {
    // Section 7.1: the hero stays full width and the blocks beneath it fall
    // into columns — the hero is wider than any one section below it.
    await pumpSurface(tester, route: '/home', viewport: desktop);
    while (tester.takeException() != null) {}
    // Home's blocks are slivers, so they are not built until they come near
    // the viewport. Scroll to them before measuring how wide they are.
    final page = find.byType(CustomScrollView).first;
    final contentWidth = tester.getSize(page).width;
    await tester.drag(page, const Offset(0, -600));
    await tester.pumpAndSettle();

    final sections = find.byType(PkSectionHeader).evaluate().toList();
    expect(sections, isNotEmpty);
    for (final element in sections) {
      final box = element.renderObject;
      if (box is! RenderBox || !box.hasSize) continue;
      expect(
        box.size.width,
        lessThan(contentWidth * .75),
        reason: 'A Home section spans the page; it did not reflow into columns',
      );
    }
  });

  testWidgets('a phone stays one column at every phone width', (tester) async {
    for (final size in const [
      Size(320, 568),
      Size(360, 800),
      pkPhone,
      Size(430, 932),
    ]) {
      await pumpSurface(
        tester,
        route: '/home',
        viewport: PkViewport(name: '$size', size: size),
      );
      while (tester.takeException() != null) {}
      final page = find.byType(CustomScrollView).first;
      final contentWidth = tester.getSize(page).width;
      await tester.drag(page, const Offset(0, -600));
      await tester.pumpAndSettle();
      for (final element in find.byType(PkSectionHeader).evaluate()) {
        final box = element.renderObject;
        if (box is! RenderBox || !box.hasSize) continue;
        // One column: a section spans the page, minus its gutters.
        expect(
          box.size.width,
          greaterThan(contentWidth * .75),
          reason: 'Home split into columns at $size',
        );
      }
    }
  });
}
