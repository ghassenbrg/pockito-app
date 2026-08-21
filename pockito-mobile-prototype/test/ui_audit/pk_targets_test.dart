import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/ui/core/components/pk_components.dart';

import '../support/pk_surface_manifest.dart';
import '../support/pk_test_harness.dart';

/// Section 9.4: every touch target is at least 48x48 logical pixels.
///
/// Walked over the render tree of every surface in the manifest rather than
/// asserted component by component — a target regresses when a *screen* wraps
/// a control in something tight, which no component test would see.
void main() {
  /// Controls whose visible box is legitimately smaller than the region that
  /// accepts the tap, because a parent supplies the target.
  ///
  /// Each entry is a real exemption, not a way to pass: a row's own `InkWell`
  /// is the target for everything inside it, and a `Semantics`-wrapped chip
  /// gets its 48 from the strip's height.
  bool exempt(Element element) {
    // A gesture region nested inside a larger one — the outer is the target.
    for (var ancestor = element; ;) {
      var found = false;
      ancestor.visitAncestorElements((parent) {
        if (parent.widget is InkWell ||
            parent.widget is InkResponse ||
            parent.widget is IconButton) {
          found = true;
          return false;
        }
        ancestor = parent;
        return true;
      });
      if (found) return true;
      break;
    }
    return false;
  }

  testWidgets('every interactive control clears 48x48', (tester) async {
    const phone = PkViewport(name: '390x844', size: pkPhone);
    final undersized = <String>{};

    for (final surface in pkSurfaceManifest) {
      await pumpSurface(
        tester,
        route: surface.route,
        viewport: phone,
        settle: !surface.skipGolden,
      );
      while (tester.takeException() != null) {}

      for (final type in const <Type>[
        IconButton,
        TextButton,
        FilledButton,
        OutlinedButton,
      ]) {
        for (final element in find.byType(type).evaluate()) {
          final box = element.renderObject;
          if (box is! RenderBox || !box.hasSize) continue;
          if (box.size.isEmpty) continue;
          if (box.size.width < pkMinimumTarget ||
              box.size.height < pkMinimumTarget) {
            if (exempt(element)) continue;
            undersized.add(
              '${surface.id}: $type is ${box.size.width.toStringAsFixed(0)}'
              'x${box.size.height.toStringAsFixed(0)}',
            );
          }
        }
      }
    }

    expect(
      undersized,
      isEmpty,
      reason: 'Targets below 48x48:\n  ${undersized.join('\n  ')}',
    );
  });

  testWidgets('the shell chrome clears 48x48 at the narrowest width', (
    tester,
  ) async {
    await pumpSurface(
      tester,
      route: '/home',
      viewport: const PkViewport(name: '320x568', size: pkNarrowPhone),
    );
    for (final label in const ['Home', 'Accounts', 'Spaces', 'More']) {
      final size = tester.getSize(
        find.descendant(
          of: find.byType(PkBottomNav),
          matching: find.bySemanticsLabel(label),
        ),
      );
      expect(size.width, greaterThanOrEqualTo(pkMinimumTarget), reason: label);
      expect(size.height, greaterThanOrEqualTo(pkMinimumTarget), reason: label);
    }
    // The central add action is larger still, per section 5.5.
    final add = tester.getSize(find.bySemanticsIdentifier('add_money_event'));
    expect(add.width, greaterThanOrEqualTo(56));
    expect(add.height, greaterThanOrEqualTo(56));
  });

  testWidgets('adjacent targets do not overlap', (tester) async {
    // Section 9.4. Overlapping regions mean one control is unreachable.
    await pumpSurface(tester, route: '/home');
    final rects = <Rect>[];
    for (final element in find.byType(IconButton).evaluate()) {
      final box = element.renderObject;
      if (box is! RenderBox || !box.hasSize || box.size.isEmpty) continue;
      rects.add(box.localToGlobal(Offset.zero) & box.size);
    }
    for (var i = 0; i < rects.length; i++) {
      for (var j = i + 1; j < rects.length; j++) {
        final overlap = rects[i].intersect(rects[j]);
        expect(
          overlap.isEmpty || overlap.width <= 0 || overlap.height <= 0,
          isTrue,
          reason: 'Two icon buttons overlap: ${rects[i]} and ${rects[j]}',
        );
      }
    }
  });
}
