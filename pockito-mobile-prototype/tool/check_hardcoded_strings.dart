// Fails the build when a user-facing string is written into `lib/ui` instead
// of an ARB file.
//
// A localised app is not one that *can* switch language — it is one where a
// new hardcoded string cannot be added without someone noticing. Retrofitting
// i18n across thousands of lines costs far more than a gate that says no on
// the day the literal is written.
//
// Run: dart run tool/check_hardcoded_strings.dart
// Add `--update-baseline` to record the current debt after an intentional
// migration step; the gate then only fails on *new* literals.
import 'dart:io';

/// Files whose literals are not user-facing.
const _exemptFiles = <String>{
  'lib/ui/previews/pockito_previews.dart', // developer-only widget previews
  'lib/ui/core/design_system/pk_icons.dart', // icon name lookup
  'lib/ui/core/design_system/pk_assets.dart', // asset paths
  'lib/ui/core/design_system/pk_tokens.dart', // design tokens
  'lib/ui/core/design_system/pk_theme.dart', // font families
};

/// Literals that are identifiers, not prose.
final _ignoredPatterns = <RegExp>[
  RegExp(r'^[a-z][a-z0-9_]*$'), // keys, enum-ish names
  RegExp(r'^[A-Z]{2,4}$'), // currency codes
  RegExp(r'^[\d\s.,:%+\-/·—–()€$¥£]*$'), // punctuation and numbers
  RegExp(r'^assets/'), // asset paths
  RegExp(r'^/[\w\-/:?=&.\$\{\}]*$'), // routes, including parameterised
  RegExp(r'^[a-z]+([A-Z][a-z]+)+$'), // lowerCamelCase identifiers
  RegExp(r'^[a-z][a-z0-9_]*_\$\{'), // widget keys built from an id
  RegExp(r'^\)'), // a fragment of a chained call, not a string
];

/// Whether the literal carries enough plain prose to be worth translating.
///
/// A Dart interpolation splits across the scanner's view, so
/// `'1 \${quote.from} = '` arrives as a fragment with no real sentence in it.
/// Requiring three plain words keeps genuine prose — including prose *with*
/// interpolation — and drops the fragments.
bool _isProse(String literal) {
  final withoutInterpolation = literal
      .replaceAll(RegExp(r'\$\{[^}]*\}'), ' ')
      .replaceAll(RegExp(r'\$\w+'), ' ');
  final words = RegExp(
    r'[A-Za-z][A-Za-z’\u0027-]*',
  ).allMatches(withoutInterpolation).map((m) => m.group(0)!).toList();
  return words.length >= 3 || (words.isNotEmpty && literal.length >= 24);
}

const _baselineFile = 'tool/hardcoded_strings_baseline.txt';

void main(List<String> args) {
  final update = args.contains('--update-baseline');
  final findings = <String>[];

  for (final entity in Directory('lib/ui').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final path = entity.path.replaceAll(r'\', '/');
    if (_exemptFiles.contains(path)) continue;
    final lines = entity.readAsLinesSync();
    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      // Skip comments, imports and anything already marked as exempt.
      final trimmed = line.trimLeft();
      if (trimmed.startsWith('//') ||
          trimmed.startsWith('import ') ||
          trimmed.startsWith('export ') ||
          line.contains('// i18n-exempt')) {
        continue;
      }
      for (final match in RegExp(r"'([^'\\\n]{2,})'").allMatches(line)) {
        final literal = match.group(1)!;
        // A key or a route is not prose; prose has a space or real words.
        if (_ignoredPatterns.any((pattern) => pattern.hasMatch(literal))) {
          continue;
        }
        if (!RegExp('[A-Za-z]').hasMatch(literal)) continue;
        if (!literal.contains(' ') && literal.length < 6) continue;
        if (!_isProse(literal)) continue;
        findings.add('$path:${index + 1}: $literal');
      }
    }
  }
  findings.sort();

  if (update) {
    File(_baselineFile).writeAsStringSync('${findings.join('\n')}\n');
    stdout.writeln('Baseline updated: ${findings.length} literals recorded.');
    return;
  }

  final baseline = File(_baselineFile).existsSync()
      ? File(
          _baselineFile,
        ).readAsLinesSync().where((line) => line.isNotEmpty).toSet()
      : <String>{};

  // Line numbers move as files are edited, so the baseline is compared on the
  // literal itself — the gate is about *new prose*, not about churn.
  String textOf(String finding) => finding.split(': ').skip(1).join(': ');
  final baselineTexts = baseline.map(textOf).toSet();
  final added = findings
      .where((finding) => !baselineTexts.contains(textOf(finding)))
      .toList();

  stdout.writeln(
    'Hardcoded user-facing strings in lib/ui: ${findings.length} '
    '(baseline ${baseline.length})',
  );
  if (added.isEmpty) {
    stdout.writeln('No new hardcoded strings. ✓');
    if (findings.length < baseline.length) {
      stdout.writeln(
        'Debt fell by ${baseline.length - findings.length}. Run with '
        '--update-baseline to lock the improvement in.',
      );
    }
    return;
  }
  stdout.writeln('\n${added.length} new hardcoded string(s):\n');
  for (final finding in added.take(40)) {
    stdout.writeln('  $finding');
  }
  if (added.length > 40) stdout.writeln('  … and ${added.length - 40} more');
  stdout.writeln(
    '\nMove these into lib/l10n/app_en.arb and lib/l10n/app_ja.arb, or mark '
    'the line `// i18n-exempt` when the string genuinely is not user-facing.',
  );
  exitCode = 1;
}
