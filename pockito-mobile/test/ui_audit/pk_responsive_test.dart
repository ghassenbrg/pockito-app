import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// Section 9.6, the responsive criteria.
///
/// "No overflow exceptions at 320 px" is the one criterion in the audit that
/// can be proved outright, so it is proved for every surface in the manifest at
/// every viewport in the device matrix rather than sampled.
void main() {
  group('every surface lays out cleanly across the device matrix', () {
    for (final viewport in pkDeviceMatrix) {
      testWidgets(viewport.name, (tester) async {
        final broken = <String, String>{};
        for (final surface in pkSurfaceManifest) {
          final errors = await collectLayoutErrors(
            tester,
            () => pumpSurface(
              tester,
              route: surface.route,
              viewport: viewport,
              settle: !surface.skipGolden,
            ),
          );
          final overflows = overflowsIn(errors);
          if (overflows.isNotEmpty) broken[surface.id] = overflows.first;
        }
        expect(
          broken,
          isEmpty,
          reason:
              'Overflow at ${viewport.name}:\n'
              '${broken.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}',
        );
      });
    }
  });

  group('the surfaces section 9.1 singles out survive the hardest case', () {
    // Onboarding, add/edit, Activity, Home, Space detail, filters, settings and
    // authorization must hold together at 320x568 and 2.0x text even though
    // that combination is not in the standard matrix.
    const mandated = [
      '/onboarding',
      '/add',
      '/activity',
      '/home',
      '/spaces/s_flat',
      '/more',
      '/settings/notifications',
      '/ai/authorize',
    ];
    for (final viewport in pkStressMatrix) {
      testWidgets(viewport.name, (tester) async {
        final broken = <String, String>{};
        for (final route in mandated) {
          final errors = await collectLayoutErrors(
            tester,
            () => pumpSurface(tester, route: route, viewport: viewport),
          );
          final overflows = overflowsIn(errors);
          if (overflows.isNotEmpty) broken[route] = overflows.first;
        }
        expect(
          broken,
          isEmpty,
          reason:
              'Overflow at ${viewport.name}:\n'
              '${broken.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}',
        );
      });
    }
  });

  testWidgets('right-to-left holds at the narrowest supported width', (
    tester,
  ) async {
    final broken = <String, String>{};
    for (final surface in pkSurfaceManifest) {
      final errors = await collectLayoutErrors(
        tester,
        () => pumpSurface(
          tester,
          route: surface.route,
          viewport: pkStressMatrix.first,
          direction: TextDirection.rtl,
          // Splash and onboarding run a continuous animation, so they are
          // pumped a fixed distance rather than settled.
          settle: !surface.skipGolden,
        ),
      );
      final overflows = overflowsIn(errors);
      if (overflows.isNotEmpty) broken[surface.id] = overflows.first;
    }
    expect(
      broken,
      isEmpty,
      reason:
          'RTL overflow:\n'
          '${broken.entries.map((e) => '  ${e.key}: ${e.value}').join('\n')}',
    );
  });
}
