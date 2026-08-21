import 'package:flutter/material.dart';

import '../domain/models/financial_models.dart';
import '../l10n/app_localizations.dart';
import '../domain/repositories/pockito_repository.dart';

enum PrototypeState { ready, loading, empty, error, offline }

enum ActivityPeriod { all, thisMonth, previousMonth, custom }

extension ActivityPeriodLabel on ActivityPeriod {
  String get label => switch (this) {
    ActivityPeriod.all => 'Any time',
    ActivityPeriod.thisMonth => 'This month',
    ActivityPeriod.previousMonth => 'Last month',
    ActivityPeriod.custom => 'Custom range',
  };
}

/// One search result, whatever kind of thing it points at.
class PkSearchHit {
  const PkSearchHit({
    required this.id,
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.route,
    this.icon = Icons.search_rounded,
    this.colorIndex = 0,
    this.amountMinor,
    this.currency,
  });

  final String id;
  final String kind;
  final String title;
  final String subtitle;
  final String route;
  final IconData icon;
  final int colorIndex;
  final int? amountMinor;
  final String? currency;
}

class PockitoAppViewModel extends ChangeNotifier {
  PockitoAppViewModel({required this.repository}) {
    repository.addListener(_onRepositoryChanged);
  }

  final PockitoRepository repository;

  DateTime _selectedMonth = DateTime(2026, 8);
  DateTime get selectedMonth => _selectedMonth;

  PrototypeState _prototypeState = PrototypeState.ready;
  PrototypeState get prototypeState => _prototypeState;

  String _activityQuery = '';
  String get activityQuery => _activityQuery;

  Set<MoneyEventType> _activityTypes = {};
  Set<MoneyEventType> get activityTypes => Set.unmodifiable(_activityTypes);
  ActivityPeriod _activityPeriod = ActivityPeriod.all;
  ActivityPeriod get activityPeriod => _activityPeriod;
  DateTime? _activityFrom;
  DateTime? get activityFrom => _activityFrom;
  DateTime? _activityTo;
  DateTime? get activityTo => _activityTo;
  Set<String> _activityCategoryIds = {};
  Set<String> get activityCategoryIds => Set.unmodifiable(_activityCategoryIds);
  Set<String> _activityAccountIds = {};
  Set<String> get activityAccountIds => Set.unmodifiable(_activityAccountIds);
  Set<String> _activitySpaceIds = {};
  Set<String> get activitySpaceIds => Set.unmodifiable(_activitySpaceIds);
  Set<String> _activityTagIds = {};
  Set<String> get activityTagIds => Set.unmodifiable(_activityTagIds);
  Set<String> _activityPaymentMethodIds = {};
  Set<String> get activityPaymentMethodIds =>
      Set.unmodifiable(_activityPaymentMethodIds);

  /// Voided and draft rows are hidden by default: they are history, not
  /// today's ledger. The filter is what makes them reachable.
  bool _activityIncludeVoided = false;
  bool get activityIncludeVoided => _activityIncludeVoided;
  bool _activityIncludeDrafts = true;
  bool get activityIncludeDrafts => _activityIncludeDrafts;

  PkSort _activitySort = PkSort.dateDesc;
  PkSort get activitySort => _activitySort;

  /// How many rows Activity has materialised. Growing on demand keeps the
  /// first paint cheap however long the history is.
  static const pageSize = 40;
  int _activityLimit = pageSize;
  int get activityLimit => _activityLimit;

  final Map<String, PkSort> _listSorts = {};

  /// The sort a named list is using, defaulting to [fallback].
  PkSort sortFor(String list, PkSort fallback) => _listSorts[list] ?? fallback;

  void setSortFor(String list, PkSort value) {
    _listSorts[list] = value;
    notifyListeners();
  }

  final Map<String, String> _listQueries = {};

  String queryFor(String list) => _listQueries[list] ?? '';

  void setQueryFor(String list, String value) {
    _listQueries[list] = value;
    notifyListeners();
  }

  int get activityFilterCount =>
      _activityTypes.length +
      _activityCategoryIds.length +
      _activityAccountIds.length +
      _activitySpaceIds.length +
      _activityTagIds.length +
      _activityPaymentMethodIds.length +
      (_activityPeriod == ActivityPeriod.all ? 0 : 1) +
      (_activityIncludeVoided ? 1 : 0) +
      (_activityIncludeDrafts ? 0 : 1);

  void selectMonth(DateTime month) {
    _selectedMonth = DateTime(month.year, month.month);
    notifyListeners();
  }

  void setActivityQuery(String value) {
    _activityQuery = value;
    _activityLimit = pageSize;
    notifyListeners();
  }

  void setActivityTypes(Set<MoneyEventType> value) {
    _activityTypes = value;
    _activityLimit = pageSize;
    notifyListeners();
  }

  void setActivitySort(PkSort value) {
    _activitySort = value;
    notifyListeners();
  }

  void showMoreActivity() {
    _activityLimit += pageSize;
    notifyListeners();
  }

  void setActivityFilters({
    required Set<MoneyEventType> types,
    required ActivityPeriod period,
    DateTime? from,
    DateTime? to,
    required Set<String> categoryIds,
    required Set<String> accountIds,
    required Set<String> spaceIds,
    Set<String> tagIds = const {},
    Set<String> paymentMethodIds = const {},
    bool includeVoided = false,
    bool includeDrafts = true,
  }) {
    _activityTypes = {...types};
    _activityPeriod = period;
    _activityFrom = from;
    _activityTo = to;
    _activityCategoryIds = {...categoryIds};
    _activityAccountIds = {...accountIds};
    _activitySpaceIds = {...spaceIds};
    _activityTagIds = {...tagIds};
    _activityPaymentMethodIds = {...paymentMethodIds};
    _activityIncludeVoided = includeVoided;
    _activityIncludeDrafts = includeDrafts;
    _activityLimit = pageSize;
    notifyListeners();
  }

  void clearActivityFilters() {
    setActivityFilters(
      types: const {},
      period: ActivityPeriod.all,
      categoryIds: const {},
      accountIds: const {},
      spaceIds: const {},
    );
  }

  /// Removes one filter without touching the others.
  void removeActivityFilter({
    MoneyEventType? type,
    String? categoryId,
    String? accountId,
    String? spaceId,
    String? tagId,
    String? paymentMethodId,
    bool clearPeriod = false,
    bool clearVoided = false,
    bool clearDrafts = false,
  }) {
    if (type != null) _activityTypes.remove(type);
    if (categoryId != null) _activityCategoryIds.remove(categoryId);
    if (accountId != null) _activityAccountIds.remove(accountId);
    if (spaceId != null) _activitySpaceIds.remove(spaceId);
    if (tagId != null) _activityTagIds.remove(tagId);
    if (paymentMethodId != null) {
      _activityPaymentMethodIds.remove(paymentMethodId);
    }
    if (clearPeriod) {
      _activityPeriod = ActivityPeriod.all;
      _activityFrom = null;
      _activityTo = null;
    }
    if (clearVoided) _activityIncludeVoided = false;
    if (clearDrafts) _activityIncludeDrafts = true;
    _activityLimit = pageSize;
    notifyListeners();
  }

  /// Saves the filters as they stand, so a combination the user built once can
  /// be reapplied without rebuilding it.
  Future<SavedView> saveCurrentView(String name) => repository.saveView(
    SavedView(
      id: '',
      name: name,
      selections: {
        'types': _activityTypes.map((type) => type.name).toList(),
        'categories': _activityCategoryIds.toList(),
        'accounts': _activityAccountIds.toList(),
        'spaces': _activitySpaceIds.toList(),
        'tags': _activityTagIds.toList(),
        'paymentMethods': _activityPaymentMethodIds.toList(),
      },
      period: _activityPeriod.name,
      from: _activityFrom,
      to: _activityTo,
      query: _activityQuery,
      sort: _activitySort.name,
    ),
  );

  void applySavedView(SavedView view) {
    _activityQuery = view.query;
    _activitySort = PkSort.values.firstWhere(
      (value) => value.name == view.sort,
      orElse: () => PkSort.dateDesc,
    );
    setActivityFilters(
      types: {
        for (final name in view.selections['types'] ?? const <String>[])
          MoneyEventType.values.firstWhere(
            (type) => type.name == name,
            orElse: () => MoneyEventType.expense,
          ),
      },
      period: ActivityPeriod.values.firstWhere(
        (value) => value.name == view.period,
        orElse: () => ActivityPeriod.all,
      ),
      from: view.from,
      to: view.to,
      categoryIds: {...?view.selections['categories']},
      accountIds: {...?view.selections['accounts']},
      spaceIds: {...?view.selections['spaces']},
      tagIds: {...?view.selections['tags']},
      paymentMethodIds: {...?view.selections['paymentMethods']},
    );
  }

  /// Every transaction that passes the current filters, in the current sort.
  ///
  /// Computed once per change rather than per build: Activity used to regroup
  /// the whole ledger into days on every frame.
  List<MoneyTransaction> get filteredTransactions {
    final cached = _filteredCache;
    if (cached != null) return cached;
    final query = _activityQuery.toLowerCase().trim();
    final source = _activityIncludeVoided
        ? repository.allTransactions
        : repository.transactions;
    final result = source.where((transaction) {
      if (!_activityIncludeDrafts && transaction.isDraft) return false;
      if (_activityTypes.isNotEmpty &&
          !_activityTypes.contains(transaction.type)) {
        return false;
      }
      final now = repository.today;
      final previous = DateTime(now.year, now.month - 1);
      final inPeriod = switch (_activityPeriod) {
        ActivityPeriod.all => true,
        ActivityPeriod.thisMonth =>
          transaction.occurredOn.year == now.year &&
              transaction.occurredOn.month == now.month,
        ActivityPeriod.previousMonth =>
          transaction.occurredOn.year == previous.year &&
              transaction.occurredOn.month == previous.month,
        ActivityPeriod.custom =>
          (_activityFrom == null ||
                  !transaction.occurredOn.isBefore(_activityFrom!)) &&
              (_activityTo == null ||
                  transaction.occurredOn.isBefore(
                    _activityTo!.add(const Duration(days: 1)),
                  )),
      };
      if (!inPeriod) return false;
      if (_activityCategoryIds.isNotEmpty &&
          !_activityCategoryIds.contains(transaction.categoryId)) {
        return false;
      }
      if (_activityAccountIds.isNotEmpty &&
          !_activityAccountIds.contains(transaction.fromAccountId) &&
          !_activityAccountIds.contains(transaction.toAccountId)) {
        return false;
      }
      if (_activityTagIds.isNotEmpty &&
          !transaction.tagIds.any(_activityTagIds.contains)) {
        return false;
      }
      if (_activityPaymentMethodIds.isNotEmpty &&
          !_activityPaymentMethodIds.contains(transaction.paymentMethodId)) {
        return false;
      }
      if (_activitySpaceIds.isNotEmpty) {
        final spaceId = transaction.splitId == null
            ? null
            : repository.sharedExpenseById(transaction.splitId!)?.spaceId;
        if (!_activitySpaceIds.contains(spaceId)) return false;
      }
      if (query.isEmpty) return true;
      final category = transaction.categoryId == null
          ? null
          : repository.categoryById(transaction.categoryId!);
      final accountId = transaction.fromAccountId ?? transaction.toAccountId;
      final account = accountId == null
          ? null
          : repository.accountById(accountId);
      return transaction.merchant.toLowerCase().contains(query) ||
          // A note is where the "why" lives, so it has to be searchable or
          // it may as well not have been written.
          transaction.note.toLowerCase().contains(query) ||
          (category?.name.toLowerCase().contains(query) ?? false) ||
          (account?.name.toLowerCase().contains(query) ?? false) ||
          transaction.tagIds.any(
            (id) =>
                repository.tagById(id)?.name.toLowerCase().contains(query) ??
                false,
          );
    }).toList()..sort(_comparator);
    _filteredCache = result;
    return result;
  }

  int Function(MoneyTransaction, MoneyTransaction) get _comparator =>
      switch (_activitySort) {
        PkSort.dateAsc => (a, b) => a.occurredOn.compareTo(b.occurredOn),
        PkSort.amountDesc => (a, b) => b.amountMinor.compareTo(a.amountMinor),
        PkSort.amountAsc => (a, b) => a.amountMinor.compareTo(b.amountMinor),
        PkSort.nameAsc => (a, b) => a.merchant.toLowerCase().compareTo(
          b.merchant.toLowerCase(),
        ),
        PkSort.nameDesc => (a, b) => b.merchant.toLowerCase().compareTo(
          a.merchant.toLowerCase(),
        ),
        _ => (a, b) => b.occurredOn.compareTo(a.occurredOn),
      };

  List<MoneyTransaction>? _filteredCache;
  Map<DateTime, List<MoneyTransaction>>? _groupedCache;

  /// The visible page, grouped into days.
  ///
  /// Both the filter and the grouping are memoised and invalidated on change,
  /// so scrolling does not re-derive the whole ledger.
  Map<DateTime, List<MoneyTransaction>> get activityGroups {
    final cached = _groupedCache;
    if (cached != null) return cached;
    final groups = <DateTime, List<MoneyTransaction>>{};
    for (final transaction in filteredTransactions.take(_activityLimit)) {
      final day = DateTime(
        transaction.occurredOn.year,
        transaction.occurredOn.month,
        transaction.occurredOn.day,
      );
      groups.putIfAbsent(day, () => []).add(transaction);
    }
    _groupedCache = groups;
    return groups;
  }

  bool get hasMoreActivity => filteredTransactions.length > _activityLimit;

  /// Everything matching [query], across every kind of record.
  /// Everything the reader can reach by name.
  ///
  /// C-7: the search used to match entity names and nothing else, so a reader
  /// who typed "budget" — or 予算 — found a budget *called* that and could not
  /// find the Budgets screen at all. Destinations are now hits too, matched
  /// against synonyms the localisers own rather than a table of English words
  /// buried in Dart.
  /// The places a reader can be sent, with the words they might use to ask.
  ///
  /// (label, route, icon, synonyms). The synonyms come from the ARB bundles so
  /// a translator can add "家計" without touching Dart.
  List<(String, String, IconData, String)> _destinations(PkStrings t) => [
    (t.navHome, '/home', Icons.home_rounded, t.searchTermsHome),
    (
      t.navAccounts,
      '/accounts',
      Icons.account_balance_wallet_outlined,
      t.searchTermsAccounts,
    ),
    (t.navSpaces, '/spaces', Icons.group_outlined, t.searchTermsSpaces),
    (
      t.activityTitle,
      '/activity',
      Icons.receipt_long_outlined,
      t.searchTermsActivity,
    ),
    (
      t.homeBudgets,
      '/budgets',
      Icons.donut_large_rounded,
      t.searchTermsBudgets,
    ),
    (
      t.subscriptions,
      '/subscriptions',
      Icons.autorenew_rounded,
      t.searchTermsSubscriptions,
    ),
    (
      t.categories,
      '/categories',
      Icons.category_outlined,
      t.searchTermsCategories,
    ),
    (
      t.notifications,
      '/notifications',
      Icons.notifications_none_rounded,
      t.searchTermsNotifications,
    ),
    (
      t.preferences,
      '/settings/preferences',
      Icons.tune_rounded,
      t.searchTermsSettings,
    ),
    (t.assistant, '/ai', Icons.auto_awesome_rounded, t.searchTermsAssistant),
  ];

  List<PkSearchHit> search(String query, PkStrings t) {
    final needle = query.toLowerCase().trim();
    if (needle.length < 2) return const [];
    final hits = <PkSearchHit>[];
    for (final destination in _destinations(t)) {
      final terms = destination.$4.toLowerCase().split(',');
      final matched =
          destination.$1.toLowerCase().contains(needle) ||
          terms.any((term) => term.trim().contains(needle));
      if (!matched) continue;
      hits.add(
        PkSearchHit(
          id: 'go_${destination.$2}',
          kind: t.searchKindDestination,
          title: destination.$1,
          subtitle: '',
          route: destination.$2,
          icon: destination.$3,
        ),
      );
    }
    for (final account in repository.accounts.where(
      (item) => item.name.toLowerCase().contains(needle),
    )) {
      hits.add(
        PkSearchHit(
          id: account.id,
          kind: t.searchKindAccount,
          title: account.name,
          subtitle: '${account.type.name} · ${account.currency}',
          route: '/accounts/${account.id}',
          icon: Icons.account_balance_wallet_outlined,
          colorIndex: account.colorIndex,
          amountMinor: repository.accountBalance(account),
          currency: account.currency,
        ),
      );
    }
    for (final space in repository.spaces.where(
      (item) => item.name.toLowerCase().contains(needle),
    )) {
      hits.add(
        PkSearchHit(
          id: space.id,
          kind: t.searchKindSpace,
          title: space.name,
          subtitle: '${space.type.label} · ${space.members.length} members',
          route: '/spaces/${space.id}',
          icon: Icons.group_outlined,
          colorIndex: space.colorIndex,
        ),
      );
    }
    for (final category in repository.categories.where(
      (item) => item.name.toLowerCase().contains(needle),
    )) {
      hits.add(
        PkSearchHit(
          id: category.id,
          kind: t.searchKindCategory,
          title: category.name,
          subtitle: category.parentId == null
              ? 'Top-level category'
              : 'in ${repository.categoryById(category.parentId!)?.name ?? ''}',
          route: '/categories',
          icon: Icons.sell_outlined,
          colorIndex: category.colorIndex,
        ),
      );
    }
    for (final subscription in repository.subscriptions.where(
      (item) => item.name.toLowerCase().contains(needle),
    )) {
      hits.add(
        PkSearchHit(
          id: subscription.id,
          kind: t.searchKindRecurring,
          title: subscription.name,
          subtitle: subscription.kind == RecurringKind.subscription
              ? 'Subscription'
              : 'Recurring',
          route: '/subscriptions/${subscription.id}',
          icon: Icons.autorenew_rounded,
          amountMinor: subscription.amountMinor,
          currency: subscription.currency,
        ),
      );
    }
    for (final budget in repository.budgets.where(
      (item) => item.name.toLowerCase().contains(needle),
    )) {
      hits.add(
        PkSearchHit(
          id: budget.id,
          kind: t.searchKindBudget,
          title: budget.name,
          subtitle: '${budget.period.label} budget',
          route: '/budgets/${budget.id}',
          icon: Icons.donut_large_rounded,
          amountMinor: budget.limitMinor,
          currency: budget.currency,
        ),
      );
    }
    var matched = 0;
    for (final transaction in repository.transactions) {
      if (matched >= 25) break;
      final category = transaction.categoryId == null
          ? null
          : repository.categoryById(transaction.categoryId!);
      final hit =
          transaction.merchant.toLowerCase().contains(needle) ||
          transaction.note.toLowerCase().contains(needle) ||
          (category?.name.toLowerCase().contains(needle) ?? false);
      if (!hit) continue;
      matched++;
      hits.add(
        PkSearchHit(
          id: transaction.id,
          kind: t.searchKindActivity,
          title: transaction.merchant,
          subtitle: [
            category?.name,
            if (transaction.note.isNotEmpty) transaction.note,
          ].whereType<String>().join(' · '),
          route: '/activity/${transaction.id}',
          icon: Icons.receipt_long_outlined,
          colorIndex: category?.colorIndex ?? 0,
          amountMinor: transaction.amountMinor,
          currency: transaction.currency,
        ),
      );
    }
    return hits;
  }

  Future<void> simulateRefresh() async {
    _prototypeState = PrototypeState.loading;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 520));
    _prototypeState = PrototypeState.ready;
    notifyListeners();
  }

  void setPrototypeState(PrototypeState value) {
    _prototypeState = value;
    // The offline state is a repository fact, not a screen's opinion: writes
    // have to be refused at the source, not merely discouraged in the UI.
    repository.setOffline(value == PrototypeState.offline);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      repository.setThemeMode(mode.name);

  void _onRepositoryChanged() {
    _filteredCache = null;
    _groupedCache = null;
    notifyListeners();
  }

  @override
  void notifyListeners() {
    _filteredCache = null;
    _groupedCache = null;
    super.notifyListeners();
  }

  @override
  void dispose() {
    repository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
