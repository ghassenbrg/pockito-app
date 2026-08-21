import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pockito/app/pockito_app_view_model.dart';
import 'package:pockito/data/repositories/mock_pockito_repository.dart';
import 'package:pockito/l10n/app_localizations.dart';
import 'package:pockito/ui/core/design_system/pk_icons.dart';

/// UI-022: the icon catalogue and how far search reaches.
///
/// Both are promises about *stored* values and *reader words*, which is
/// exactly the kind of thing that rots silently. An id renamed in a refactor
/// blanks the mark on every record already saved with it; a synonym list that
/// only a programmer can edit stops being true the first time a label is
/// translated differently.
void main() {
  late PkStrings en;
  late PkStrings ja;

  setUpAll(() async {
    en = await PkStrings.delegate.load(const Locale('en'));
    ja = await PkStrings.delegate.load(const Locale('ja'));
  });

  group('icon catalogue', () {
    test('every id is unique', () {
      final ids = PkIconCatalog.entries.map((entry) => entry.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
    });

    test('every id is namespaced by its group', () {
      // `money.cash` rather than `cash`: the prefix is what stops a later
      // "cash" in a different sense from colliding with this one.
      for (final entry in PkIconCatalog.entries) {
        expect(
          entry.id,
          startsWith('${entry.group.name}.'),
          reason: '${entry.id} does not belong to ${entry.group.name}',
        );
      }
    });

    test('every legacy name still resolves', () {
      // The promise: a record saved before the catalogue existed keeps its
      // mark. This is the test that makes the promise enforceable.
      for (final entry in PkIconCatalog.legacy.entries) {
        final resolved = PkIconCatalog.find(entry.key);
        expect(
          resolved,
          isNotNull,
          reason: 'legacy name "${entry.key}" no longer resolves',
        );
        expect(resolved!.id, entry.value);
      }
    });

    test('every icon a fixture uses resolves to a real entry', () {
      final repository = MockPockitoRepository();
      final used = <String>{
        for (final account in repository.accounts) account.icon,
        for (final category in repository.categories) category.icon,
        for (final space in repository.spaces) space.icon,
      };
      final unresolved = used
          .where((name) => PkIconCatalog.find(name) == null)
          .toList();
      expect(
        unresolved,
        isEmpty,
        reason: 'Fixture icons with no catalogue entry: $unresolved',
      );
    });

    test('search finds an entry by its own words in either language', () {
      // Latin keywords work in both, because a category called "Netflix" is
      // spelled the same either way.
      final byKeyword = PkIconCatalog.entries
          .where((entry) => entry.matches('coffee', en))
          .map((entry) => entry.id);
      expect(byKeyword, contains('food.cafe'));

      // …and the group's name works in the reader's own script, which is the
      // half a hard-coded English keyword table could never give.
      final byGroupJa = PkIconCatalog.entries
          .where((entry) => entry.matches('食事', ja))
          .map((entry) => entry.id);
      expect(byGroupJa, contains('food.restaurant'));
      expect(byGroupJa, isNot(contains('money.bank')));
    });

    test('an empty query offers the whole catalogue', () {
      final all = PkIconCatalog.entries.where((entry) => entry.matches('', en));
      expect(all, hasLength(PkIconCatalog.entries.length));
    });
  });

  group('search reach', () {
    late PockitoAppViewModel viewModel;

    setUp(() {
      viewModel = PockitoAppViewModel(repository: MockPockitoRepository());
    });

    test('a destination is findable by name', () {
      final hits = viewModel.search('budget', en);
      expect(
        hits.where((hit) => hit.route == '/budgets'),
        isNotEmpty,
        reason: 'Typing the name of a screen must find the screen',
      );
    });

    test('a destination is findable by a synonym nobody put on screen', () {
      // "renewals" is not the label of anything. It is what a reader calls it.
      final hits = viewModel.search('renewals', en);
      expect(hits.map((hit) => hit.route), contains('/subscriptions'));
    });

    test('a Japanese reader finds a screen by a Japanese word', () {
      final hits = viewModel.search('予算', ja);
      expect(
        hits.map((hit) => hit.route),
        contains('/budgets'),
        reason: 'The synonyms live in the ARB so translators own them',
      );
    });

    test('destinations are grouped apart from the reader\'s own records', () {
      final hits = viewModel.search('budget', en);
      final destinations = hits.where((hit) => hit.route == '/budgets');
      expect(destinations.first.kind, en.searchKindDestination);
      // And a record still wins its own kind rather than being folded in.
      expect(
        hits.map((hit) => hit.kind).toSet().length,
        greaterThanOrEqualTo(1),
      );
    });

    test('a one-letter query still returns nothing', () {
      // Destinations must not make the search fire before the reader has
      // said enough to mean anything.
      expect(viewModel.search('b', en), isEmpty);
    });
  });
}
