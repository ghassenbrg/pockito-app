import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../support/pk_surface_manifest.dart';

/// UI-001: the manifest is the audit's coverage contract.
///
/// Every other suite iterates `pkSurfaceManifest`, so a route that is not in
/// it is a route with no responsive, density, target, contrast, Kito or golden
/// coverage at all — and nothing would say so. This is what says so.
void main() {
  test('every router path appears in the manifest', () {
    final source = File(
      'lib/ui/core/navigation/app_router.dart',
    ).readAsStringSync();
    // Paths as the router declares them, with their parameters intact.
    final declared = RegExp(r"path: '([^']+)'")
        .allMatches(source)
        .map((match) => match.group(1)!)
        .where((path) => path != '/settings') // A redirect, not a surface.
        .toSet();

    /// A manifest route matches a declaration when it fills in that
    /// declaration's parameters — `/spaces/s_flat` covers `/spaces/:spaceId`.
    bool covered(String declaredPath) {
      final pattern = RegExp(
        '^${declaredPath.split('/').map((segment) => segment.startsWith(':') ? '[^/]+' : RegExp.escape(segment)).join('/')}\$',
      );
      return pkSurfaceManifest.any(
        (surface) => pattern.hasMatch(surface.route.split('?').first),
      );
    }

    final uncovered = declared.where((path) => !covered(path)).toList()..sort();
    expect(
      uncovered,
      isEmpty,
      reason:
          'These routes have no acceptance coverage at all. Add them to '
          'pkSurfaceManifest with the states section 9.7 requires:\n'
          '  ${uncovered.join('\n  ')}',
    );
  });

  test('every manifest entry has a unique id and route', () {
    final ids = pkSurfaceManifest.map((surface) => surface.id).toList();
    final routes = pkSurfaceManifest.map((surface) => surface.route).toList();
    expect(ids.toSet(), hasLength(ids.length), reason: 'Duplicate surface id');
    expect(
      routes.toSet(),
      hasLength(routes.length),
      reason: 'Duplicate surface route',
    );
  });

  test('the density floors match section 9.3', () {
    // Restated here so the manifest cannot quietly relax a target the audit
    // fixed.
    const expected = {
      'accounts': 5,
      'spaces': 3,
      'activity': 5,
      'more': 7,
      'notifications': 6,
    };
    for (final entry in expected.entries) {
      final surface = pkSurfaceManifest.firstWhere(
        (item) => item.id == entry.key,
      );
      expect(surface.densityFloor, entry.value, reason: entry.key);
    }
  });

  test('every debug surface is marked as one', () {
    // Definition of done, item 15. A prototype surface that is not labelled
    // debug is one nobody will remember to strip.
    for (final surface in pkSurfaceManifest) {
      if (surface.route.contains('/states')) {
        expect(surface.kind, PkSurfaceKind.debug, reason: surface.id);
      }
    }
  });
}
