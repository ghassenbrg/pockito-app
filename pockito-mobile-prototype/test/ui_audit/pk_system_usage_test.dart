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

    test('a category fill never becomes a mark', () {
      // UI-017. `PkIconTile` now refuses a bare `Color`, so the tile itself is
      // safe by type. This closes the other half: `categoryFillAt` is for
      // areas — a swatch, a chart slice, a hero tint — and handing it to an
      // `Icon` or a `TextStyle` puts an illegible colour back on a mark, which
      // is the defect PkAccent was introduced to make unrepresentable.
      final offenders = <String>[];
      final marks = RegExp(
        r'(Icon\(|IconData|style:|TextStyle\(|foregroundColor:|labelStyle)',
      );
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          if (!line.contains('categoryFillAt')) continue;
          if (marks.hasMatch(line)) offenders.add('${file.path}:$number');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Ask for the accent and take `.ink(context)` from it:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('the category palette is only read through its accessors', () {
      // Indexing `PkPalette.category` directly bypasses the accent entirely.
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          if (line.contains('PkPalette.category[')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkPalette.categoryAt (accent) or categoryFillAt (area):\n'
            '  ${offenders.join('\n  ')}',
      );
    });
  });

  group('UI-024 · a surface cannot be light-only', () {
    test('no screen fills a surface with a fixed light tint', () {
      // `PkPalette.indigo50` and its siblings are the *light* end of a ramp
      // with no dark counterpart. Painted as a `color:` they survive the theme
      // switch unchanged, so an unread notification became a near-white card
      // with near-white writing on it, and the FX and currency notices went
      // the same way. `pkStatusSurface` derives the wash from the tone's ink
      // over whatever surface is current, so there is no light-only half to
      // forget.
      final tint = RegExp(
        r'(color|borderColor|backgroundColor):[^,]*'
        r'PkPalette\.[A-Za-z]+(50|100|200)\b',
      );
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          // A brightness test on the same statement is the explicit,
          // reviewed form of the same decision and stays allowed.
          if (tint.hasMatch(line) && !line.contains('Brightness.')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use pkStatusSurface / pkStatusBorder, or branch on brightness:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no screen inks a glyph with a light-only tier', () {
      // The other half of the same defect. `indigo600` on `indigo50` reads in
      // both themes only because the *background* was frozen too; the moment
      // the surface followed the theme, every verified tick, unread dot and
      // notice icon painted dark blue on dark blue. A saturated fill is still
      // allowed — a hero panel or an accent block is a fill, not a glyph — so
      // the rule is scoped to `color:` on ink-bearing properties.
      // `PkAccent.ink(raw)` is the same mistake wearing the accent type:
      // `ink` is for a colour that is *already* brightness-correct, not for a
      // palette tier. `PkPalette.brand` and `.neutral` are the split versions.
      final ink = RegExp(
        r'(\bcolor:\s*|PkAccent\.ink\(\s*)'
        r'PkPalette\.[A-Za-z]+([4-9]00)\b(?!\s*\.withValues)',
      );
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        var previous = '';
        for (final (number, line) in statements(file)) {
          // A `decoration:`/`BoxDecoration(` on the same statement means the
          // colour is an area, not a mark.
          final area =
              line.contains('decoration:') ||
              previous.contains('decoration:') ||
              previous.contains('BoxDecoration(');
          if (ink.hasMatch(line) && !area && !line.contains('Brightness.')) {
            offenders.add('${file.path}:$number');
          }
          previous = line;
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Ink follows the theme: pkStatusInk, context.pk.*, or the scheme:\n'
            '  ${offenders.join('\n  ')}',
      );
    });
  });

  group('UI-019 · rows keep their target', () {
    test('no `ListTile` builds a list row in a feature screen', () {
      // UI-019's exit gate. `ListTile` is Material's row, not Pockito's: it
      // brings its own height, its own padding, its own idea of what a
      // subtitle weighs, and it announces as separate fragments rather than as
      // one row. Thirty-eight of them were drawing settings, members, sheet
      // actions and Space rows beside `PkLedgerRow`s that looked almost but
      // not quite the same.
      //
      // A `PopupMenuItem`'s child is exempt by shape rather than by marker:
      // there, `ListTile` *is* the Material convention, the menu owns the
      // geometry, and a `PkLedgerRow` inside a popup would be the odd one out.
      final offenders = <String>[];
      for (final file in featureFiles) {
        final lines = file.readAsLinesSync();
        for (final (number, line) in statements(file)) {
          if (!RegExp(r'(?<![A-Za-z])ListTile\(').hasMatch(line)) continue;
          final before = lines
              .sublist((number - 9).clamp(0, lines.length), number)
              .join('\n');
          if (before.contains('PopupMenuItem')) continue;
          offenders.add('${file.path}:$number');
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkLedgerRow.management or PkDetailRow:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no `dense: true` shrinks a list row', () {
      // The sibling of the `VisualDensity.compact` rule. `dense` takes a
      // `ListTile` under the 48 px floor, and it was doing so on Home's
      // action-required rows, the first-run checklist and the role chooser —
      // three places where the reader is being asked to act.
      final offenders = <String>[];
      for (final file in [...featureFiles, ...componentFiles]) {
        for (final (number, line) in statements(file)) {
          if (RegExp(r'\bdense:\s*true').hasMatch(line)) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkLedgerRow.management, which is 56 with a 48 target:\n'
            '  ${offenders.join('\n  ')}',
      );
    });
  });

  group('UI-018 · feature code uses the field system', () {
    // The field system was built by UI-005 and then largely not adopted: at the
    // start of UI-018 `lib/ui/features` held 24 `DropdownButtonFormField` and
    // 20 raw `TextField` against 3 `PkAmountField` and 4 `PkSelectField`. The
    // settlement amount — the most consequential number in the product — was a
    // bare `TextField` styled `displayLarge`. These gates keep the components
    // in service now that the screens have moved onto them.
    test('no `DropdownButtonFormField` survives in a feature screen', () {
      // A menu renders an entity as a bare string, cannot show its icon or
      // colour, has no search past eight rows, and clips at large text sizes.
      // `PkSelectField` and `showPkOptionPicker` do all four.
      final offenders = <String>[];
      for (final file in featureFiles) {
        for (final (number, line) in statements(file)) {
          if (line.contains('DropdownButtonFormField')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkSelectField / PkSelectFormField with a picker:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no raw text field survives in a feature screen', () {
      // The last raw primitive. `PkAmountField` owned money, `PkSelectField` a
      // choice, `PkDateField` a date — and twenty screens still reached for
      // `TextField`/`TextFormField` for a name or an email, each deciding for
      // itself whether to validate at all (a `TextField` cannot) and how a
      // multiline label should sit. `PkTextField` is that case.
      //
      // Three inline numeric cells stay exempt and say why: a table cell has
      // no room for a floating label and a 48 px box.
      final offenders = <String>[];
      for (final file in featureFiles) {
        for (final (number, line) in statements(file)) {
          if (RegExp(r'\bTextF(orm)?Field\(').hasMatch(line)) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkTextField, or mark the cell `pk-exempt` with its reason:\n'
            '  ${offenders.join('\n  ')}',
      );
    });

    test('no feature screen paints its own currency prefix', () {
      // A currency symbol glued to a raw field is the signature of an amount
      // input that is not `PkAmountField` — and so has no tabular figures, no
      // currency-aware precision, and no cap on how far the 32 px number grows
      // with the reader's text scale.
      final offenders = <String>[];
      for (final file in featureFiles) {
        for (final (number, line) in statements(file)) {
          if (line.contains('prefixText')) {
            offenders.add('${file.path}:$number');
          }
        }
      }
      expect(
        offenders,
        isEmpty,
        reason:
            'Use PkAmountField, or mark a real exception with `pk-exempt`:\n'
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
