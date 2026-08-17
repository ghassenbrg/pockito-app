import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The release gates that are about *how the code is written*, not about how it
/// renders: UI-002's "no feature screen needs a raw value", UI-005's "no
/// hand-built modal remains", and the audit's rule that prototype scaffolding
/// must not ship.
///
/// These read the source because that is the only place the rule lives. A
/// screen that hard-codes `fontSize: 28` renders fine — it just puts the
/// hierarchy back where the programme started, silently, one screen at a time.
void main() {
  final featureFiles = Directory('lib/ui/features')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  final componentFiles = Directory('lib/ui/core/components')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();

  /// Lines with their 1-based numbers, minus comments and anything an
  /// exemption marker covers, so a rule cannot be tripped by prose that merely
  /// mentions it.
  ///
  /// A marker exempts the whole expression it introduces, not just the next
  /// line — the formatter is free to split that expression across as many
  /// lines as it likes, and an exemption that stopped at the first one would
  /// silently start failing after a reformat.
  Iterable<(int, String)> statements(File file) sync* {
    final lines = file.readAsLinesSync();
    var exempting = false;
    var depth = 0;
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final trimmed = line.trimLeft();
      if (line.contains('i18n-exempt') || line.contains('pk-exempt')) {
        exempting = true;
        depth = 0;
        continue;
      }
      if (trimmed.startsWith('//')) continue;
      if (exempting) {
        for (final rune in line.split('')) {
          if (rune == '(' || rune == '[') depth++;
          if (rune == ')' || rune == ']') depth--;
        }
        // The expression closes when the depth is back to level and the line
        // has been terminated.
        if (depth <= 0 && (trimmed.endsWith(',') || trimmed.endsWith(';'))) {
          exempting = false;
        }
        continue;
      }
      yield (index + 1, line);
    }
  }

  group('UI-002 · feature code speaks in tokens', () {
    test('no raw font size outside the theme', () {
      final offenders = <String>[];
      for (final file in featureFiles) {
        for (final (number, line) in statements(file)) {
          if (RegExp(r'fontSize:\s*\d').hasMatch(line)) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use a `context.pkText` role instead of a literal size:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no raw corner radius outside the token scale', () {
      final offenders = <String>[];
      // `BorderRadius.circular(2)` and friends under 8 are optical details on
      // drawn shapes — progress bars, chart strokes — not surface radii.
      final literal = RegExp(r'Radius\.circular\(\s*(\d+(?:\.\d+)?)\s*\)');
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          for (final match in literal.allMatches(line)) {
            final value = double.parse(match.group(1)!);
            if (value >= 8) offenders.add('${file.path}:$number → $value');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkRadius.small/control/card/hero/sheet/full:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no raw 44 or 48 touch target', () {
      final offenders = <String>[];
      final literal = RegExp(r'(minWidth|minHeight|minimumSize).*\b(44|48)\b');
      for (final file in featureFiles) {
        for (final (number, line) in statements(file)) {
          if (literal.hasMatch(line)) offenders.add('${file.path}:$number');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkSize.touch so the floor moves in one place:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no raw breakpoint width', () {
      final offenders = <String>[];
      final literal = RegExp(
        r'maxWidth\s*[<>=]+\s*(360|600|760|840|900|1180)\b'
        r'|constraints\.maxWidth\s*[<>=]+\s*(360|600|760|840|900|1180)\b',
      );
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          if (literal.hasMatch(line)) offenders.add('${file.path}:$number');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkBreakpoints so the shape changes in one place:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('`VisualDensity.compact` never shrinks a target', () {
      // D-04: chrome may be compact; the region that accepts the tap may not.
      // `VisualDensity.compact` reduces the *target*, so it is banned outright
      // and tight padding is used instead.
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          if (line.contains('VisualDensity.compact')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Reduce padding instead; the target stays PkSize.touch:\n'
            '  ${offenders.join('\n  ')}',
      );
    });
  });

  group('UI-005 · one sheet presenter', () {
    test('`showModalBottomSheet` is only called by `showPkSheet`', () {
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        // The shared presenter is the one legitimate caller.
        if (file.path.endsWith('pk_pickers.dart')) continue;
        for (final (number, line) in statements(file)) {
          if (line.contains('showModalBottomSheet')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use showPkSheet, which carries the section 6.12 height contract:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no sheet sets its own fractional height', () {
      // Section 6.12 replaces 82–88% pseudo-screens with the compact/standard
      // contract, and sends anything taller to a full-screen route.
      final offenders = <String>[];
      final literal = RegExp(
        r'heightFactor:\s*\.\d|height:\s*MediaQuery\.sizeOf\(context\)\.height\s*\*',
      );
      for (final file in [...featureFiles, ...componentFiles]) {
        if (file.path.endsWith('pk_pickers.dart')) continue;
        for (final (number, line) in statements(file)) {
          if (literal.hasMatch(line)) offenders.add('${file.path}:$number');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Choose PkSheetSize.compact/standard, or make it a route:\n'
            '  ${offenders.join('\n  ')}',
      );
    });
  });

  group('localization', () {
    test('no user-facing literal survives in lib/ui', () {
      // The companion audit's P0-13 release gate, restated here so the UI
      // programme cannot reintroduce one while moving screens around.
      // Selecting 日本語 has to produce a Japanese app, not a Japanese tab bar.
      final slot = RegExp(
        r"(?:Text\(\s*|label:\s*|labelText:\s*|title:\s*|hintText:\s*|hint:\s*"
        r"|tooltip:\s*|subtitle:\s*|message:\s*|actionLabel:\s*"
        r"|semanticLabel:\s*|suffixText:\s*)(?:const\s+)?(?:Text\(\s*)?"
        r"'([^'\\]{3,})'",
      );
      // Interpolations join values that are already translated where they are
      // produced, so the literal parts are what matter. A word with three
      // consecutive Latin letters is prose; a currency code or a separator is
      // not.
      final interpolation = RegExp(r'\$\{[^}]*\}|\$\w+');
      final prose = RegExp(r'[A-Za-z]{3}');
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          for (final match in slot.allMatches(line)) {
            final value = match.group(1)!;
            if (!prose.hasMatch(value.replaceAll(interpolation, ''))) continue;
            offenders.add('${file.path}:$number → "$value"');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Move these into the ARB bundles, or mark a real exception with '
            '`// i18n-exempt` and say why:\n  ${offenders.join('\n  ')}',
      );
    });

    test('every ARB key exists in both languages', () {
      // Parsed rather than matched: `@key` metadata carries nested names that
      // a line-based regex would mistake for messages.
      Set<String> messagesIn(String path) {
        final bundle =
            jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;
        return bundle.keys.where((key) => !key.startsWith('@')).toSet();
      }

      final englishKeys = messagesIn('lib/l10n/app_en.arb');
      final japaneseKeys = messagesIn('lib/l10n/app_ja.arb');
      expect(
        englishKeys.difference(japaneseKeys),
        isEmpty,
        reason: 'Japanese is advertised; it may not be partially implemented',
      );
      expect(
        japaneseKeys.difference(englishKeys),
        isEmpty,
        reason: 'A Japanese-only key has no English source',
      );
    });
  });
}
