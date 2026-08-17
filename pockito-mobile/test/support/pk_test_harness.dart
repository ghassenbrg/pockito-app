/// Shared plumbing for the audit's acceptance suites.
///
/// Every suite needs the same three things — put a route on screen at a chosen
/// viewport, notice layout overflow rather than letting it print and pass, and
/// measure what actually fits above the navigation. Keeping them here is what
/// lets the density, responsive, accessibility and golden suites all speak
/// about the same rendering.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/main.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';
import 'package:pockito/ui/core/navigation/app_router.dart';

import 'pk_surface_manifest.dart';

/// Renders the whole app at [viewport] and settles on [route].
///
/// Returns the repository so a test can assert against the same fixtures the
/// screen is showing.
Future<MockPockitoRepository> pumpSurface(
  WidgetTester tester, {
  required String route,
  PkViewport viewport = const PkViewport(name: 'phone', size: pkPhone),
  TextDirection direction = TextDirection.ltr,
  MockPockitoRepository? repository,
  bool settle = true,
}) async {
  await tester.binding.setSurfaceSize(viewport.size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final repo = repository ?? MockPockitoRepository();
  appRouter.go(route);
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(
        size: viewport.size,
        platformBrightness: viewport.brightness,
        textScaler: TextScaler.linear(viewport.textScale),
      ),
      child: Directionality(
        textDirection: direction,
        child: PockitoBootstrap(repository: repo),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // Surfaces that never settle run a continuous animation. Pump past the
    // route transition anyway, so the *previous* route has finished leaving —
    // otherwise a suite that walks the manifest sees two screens at once.
    await tester.pump();
    for (var frame = 0; frame < 8; frame++) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }
  return repo;
}

/// Runs [body] while collecting every framework error, including the layout
/// overflow reports that otherwise only print.
///
/// Flutter reports a `RenderFlex` overflow through `FlutterError.onError` and
/// the test binding turns it into a pending exception, but only the first one
/// survives `takeException`. The audit needs all of them, per route.
Future<List<String>> collectLayoutErrors(
  WidgetTester tester,
  Future<void> Function() body,
) async {
  final errors = <String>[];
  final previous = FlutterError.onError;
  FlutterError.onError = (details) => errors.add(details.exceptionAsString());
  try {
    await body();
  } finally {
    FlutterError.onError = previous;
  }
  // Anything the binding queued before the override took effect.
  Object? pending = tester.takeException();
  while (pending != null) {
    errors.add(pending.toString());
    pending = tester.takeException();
  }
  return errors;
}

/// Overflow reports only — the subset section 9.6 forbids outright.
List<String> overflowsIn(List<String> errors) => [
  for (final error in errors)
    if (error.contains('overflowed') || error.contains('OVERFLOWING')) error,
];

/// The vertical band a phone user can see without scrolling: the viewport
/// minus whatever the floating navigation occupies.
///
/// Section 9.3 states its density targets "above nav", so a measurement that
/// counted rows behind the bar would overstate every screen.
double visibleContentBottom(WidgetTester tester, PkViewport viewport) {
  final navFinder = find.byKey(PkBottomNav.containerKey);
  if (navFinder.evaluate().isEmpty) return viewport.size.height;
  return tester.getTopLeft(navFinder).dy;
}

/// How many of [finder]'s instances are fully visible above the navigation.
///
/// A row that is half-covered is not a row the user can read, so partial rows
/// do not count towards a density floor.
int visibleRowCount(
  WidgetTester tester,
  Finder finder, {
  PkViewport viewport = const PkViewport(name: 'phone', size: pkPhone),
}) {
  final bottom = visibleContentBottom(tester, viewport);
  var count = 0;
  for (final element in finder.evaluate()) {
    final box = element.renderObject;
    if (box is! RenderBox || !box.hasSize) continue;
    final origin = box.localToGlobal(Offset.zero);
    if (origin.dy >= 0 && origin.dy + box.size.height <= bottom) count++;
  }
  return count;
}

/// Every interactive region the app rendered, with its measured size.
///
/// Used by the target-size gate: section 9.4 requires 48x48 for every touch
/// target, and the only way to prove that across 50 routes is to walk the
/// render tree rather than trust each screen.
Iterable<({String description, Size size})> measuredTargets(
  WidgetTester tester,
) sync* {
  for (final type in const <Type>[
    IconButton,
    TextButton,
    FilledButton,
    OutlinedButton,
    InkWell,
    InkResponse,
  ]) {
    for (final element in find.byType(type).evaluate()) {
      final box = element.renderObject;
      if (box is! RenderBox || !box.hasSize) continue;
      yield (description: '$type', size: box.size);
    }
  }
}

/// The smallest target the audit accepts, restated so tests read as intent
/// rather than as a bare number.
const double pkMinimumTarget = PkSize.touch;
