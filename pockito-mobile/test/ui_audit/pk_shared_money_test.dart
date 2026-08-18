import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/l10n/app_localizations.dart';
import 'package:pockito/ui/core/components/pk_components.dart';
import 'package:pockito/ui/core/design_system/pk_theme.dart';
import 'package:pockito/ui/core/design_system/pk_tokens.dart';

/// UI-021, C-4 and C-5: the two components that carry the thing Pockito is
/// actually for.
///
/// Both are about *shared* money, which is the one place in a finance app
/// where saving a record changes a relationship. The assertions here are
/// mostly about what the components say rather than how they look — a split
/// bar that reads as colour alone, or an impact card that shows a delta
/// without saying which way it points, would render perfectly and still fail
/// the reader it was built for.
void main() {
  Widget host(Widget child, {Size size = const Size(390, 844)}) => MaterialApp(
    theme: PkTheme.light(),
    localizationsDelegates: PkStrings.localizationsDelegates,
    supportedLocales: PkStrings.supportedLocales,
    home: Scaffold(
      body: Center(
        child: MediaQuery(
          data: MediaQueryData(size: size),
          child: SizedBox(width: 320, child: child),
        ),
      ),
    ),
  );

  List<PkSplitSegment> segments(List<int> amounts) => [
    for (final (index, amount) in amounts.indexed)
      PkSplitSegment(
        id: 'member_$index',
        label: 'Member $index',
        amountMinor: amount,
        accent: PkPalette.categoryAt(index + 1),
      ),
  ];

  group('PkSplitBar (C-5)', () {
    testWidgets('draws one segment per person, widths in proportion', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(PkSplitBar(segments: segments([7500, 2500]), currency: 'JPY')),
      );
      await tester.pumpAndSettle();

      final first = tester.getSize(
        find.byKey(const ValueKey('split_segment_member_0')),
      );
      final second = tester.getSize(
        find.byKey(const ValueKey('split_segment_member_1')),
      );
      expect(first.width / second.width, closeTo(3, .15));
    });

    testWidgets('a tiny share stays findable rather than rounding away', (
      tester,
    ) async {
      // The reason widths are computed instead of flexed. At 1% of a 320 px
      // bar a share is 3 px, which is a hairline, not a person.
      await tester.pumpWidget(
        host(PkSplitBar(segments: segments([99000, 1000]), currency: 'JPY')),
      );
      await tester.pumpAndSettle();

      final small = tester.getSize(
        find.byKey(const ValueKey('split_segment_member_1')),
      );
      expect(small.width, greaterThanOrEqualTo(6));
      // …and the bar still fits its box.
      final bar = tester.getSize(find.byType(PkSplitBar));
      final large = tester.getSize(
        find.byKey(const ValueKey('split_segment_member_0')),
      );
      expect(large.width + small.width, lessThanOrEqualTo(bar.width + .5));
    });

    testWidgets('says the whole division in words, not only in colour', (
      tester,
    ) async {
      // Section 9.5: colour is never the only carrier. A split bar is the
      // purest case of that risk in the app.
      await tester.pumpWidget(
        host(PkSplitBar(segments: segments([7500, 2500]), currency: 'JPY')),
      );
      await tester.pumpAndSettle();

      final node = tester.getSemantics(find.byType(PkSplitBar));
      expect(node.label, contains('Member 0'));
      expect(node.label, contains('Member 1'));
      expect(node.label, contains('75'));
      expect(node.label, contains('25'));
    });

    testWidgets('an empty split renders nothing rather than an empty bar', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(const PkSplitBar(segments: [], currency: 'JPY')),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(ClipRRect), findsNothing);
    });
  });

  group('PkBalanceImpact (C-4)', () {
    testWidgets('states the direction in words and the before and after', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const PkBalanceImpact(
            counterpartyName: 'Mira',
            previousMinor: 340000,
            deltaMinor: 120000,
            currency: 'JPY',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Mira will owe you'), findsOneWidget);
      // Before and after are both shown: a delta on its own does not answer
      // "where does this leave us".
      expect(find.textContaining('→'), findsOneWidget);
      final node = tester.getSemantics(find.byType(PkBalanceImpact));
      expect(node.label, contains('Mira'));
      expect(node.label, contains('→'));
    });

    testWidgets('the other direction reads as the reader owing', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const PkBalanceImpact(
            counterpartyName: 'Mira',
            previousMinor: 0,
            deltaMinor: -120000,
            currency: 'JPY',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('You will owe Mira'), findsOneWidget);
    });

    testWidgets('a settlement that changes nothing says so', (tester) async {
      await tester.pumpWidget(
        host(
          const PkBalanceImpact(
            counterpartyName: 'Mira',
            previousMinor: 50000,
            deltaMinor: 0,
            currency: 'JPY',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Nothing changes'), findsOneWidget);
    });

    testWidgets('survives 2.0x text without overflowing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: PkTheme.light(),
          localizationsDelegates: PkStrings.localizationsDelegates,
          supportedLocales: PkStrings.supportedLocales,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SizedBox(
                  width: 320,
                  child: PkBalanceImpact(
                    counterpartyName: 'Maximiliana Aleksandrovna',
                    previousMinor: 340000,
                    deltaMinor: 120000,
                    currency: 'JPY',
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('status grammar (P1-8)', () {
    testWidgets('a bar refuses to be given both a colour and a tone', (
      tester,
    ) async {
      // The assertion is the point: two sources for one meaning is what let a
      // budget read amber on the bar and red on the badge.
      expect(
        () => PkProgressBar(
          value: .5,
          color: const Color(0xFF000000),
          tone: PkStatusTone.danger,
        ),
        throwsAssertionError,
      );
    });

    testWidgets('a toned bar and a toned badge resolve to one ink', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) {
              final ink = pkStatusInk(context, PkStatusTone.danger);
              expect(ink, context.pk.danger);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
    });
  });

  group('PkRecordTimeline (C-8)', () {
    const entries = [
      PkTimelineEntry(title: 'Recorded', detail: 'Mira · 13 August 2026'),
      PkTimelineEntry(
        title: 'Edited',
        detail: 'Revised once since it was recorded',
        tone: PkStatusTone.info,
      ),
      PkTimelineEntry(
        title: 'Waiting to be confirmed',
        detail: 'It does not move a balance until someone confirms it',
        tone: PkStatusTone.warning,
        done: false,
      ),
    ];

    testWidgets('each step is one announcement, not two fragments', (
      tester,
    ) async {
      // The whole point of the rail is that a disagreement about a number can
      // be settled by reading it. A screen reader hearing a column of titles
      // and then a column of details cannot settle anything.
      await tester.pumpWidget(host(const PkRecordTimeline(entries: entries)));
      await tester.pumpAndSettle();
      final handle = tester.ensureSemantics();
      expect(
        find.bySemanticsLabel('Recorded, Mira · 13 August 2026'),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('an unfinished step reads as unfinished without colour', (
      tester,
    ) async {
      // The marker for a step that has not happened is a hollow ring; a done
      // one is a filled disc with a tick. Rendering both the same and letting
      // the tone carry it would fail anyone who cannot see the tone.
      await tester.pumpWidget(host(const PkRecordTimeline(entries: entries)));
      await tester.pumpAndSettle();
      // Two done steps, so two ticks — the pending one has none.
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    });

    testWidgets('an empty history renders nothing at all', (tester) async {
      // A record with no history should not leave an empty card behind.
      await tester.pumpWidget(host(const PkRecordTimeline(entries: [])));
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(PkRecordTimeline)).height, 0);
    });
  });
}
