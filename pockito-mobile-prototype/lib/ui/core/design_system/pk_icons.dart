import 'package:flutter/material.dart';

import 'pk_labels.dart';

/// What an icon is *about*, which is how a reader looks for one.
///
/// Nobody browses an alphabetical wall of glyphs. They think "something to do
/// with food" and scan that neighbourhood, which is why the catalogue is
/// grouped and the groups are named in the reader's language.
enum PkIconGroup {
  money,
  food,
  home,
  transport,
  travel,
  health,
  leisure,
  shopping,
  work,
  people,
  other,
}

extension PkIconGroupStrings on PkIconGroup {
  String labelIn(PkStrings t) => switch (this) {
    PkIconGroup.money => t.iconGroupMoney,
    PkIconGroup.food => t.iconGroupFood,
    PkIconGroup.home => t.iconGroupHome,
    PkIconGroup.transport => t.iconGroupTransport,
    PkIconGroup.travel => t.iconGroupTravel,
    PkIconGroup.health => t.iconGroupHealth,
    PkIconGroup.leisure => t.iconGroupLeisure,
    PkIconGroup.shopping => t.iconGroupShopping,
    PkIconGroup.work => t.iconGroupWork,
    PkIconGroup.people => t.iconGroupPeople,
    PkIconGroup.other => t.iconGroupOther,
  };
}

/// One entry in the catalogue.
@immutable
class PkIconDef {
  const PkIconDef({
    required this.id,
    required this.icon,
    required this.group,
    this.keywords = const <String>[],
  });

  /// The value persisted on the record. **Never rename one**: add a new entry
  /// and leave the old id resolving, or every account and category already
  /// saved with it loses its mark.
  final String id;

  final IconData icon;
  final PkIconGroup group;

  /// Extra words that should find this icon, beyond its own id.
  final List<String> keywords;

  /// Whether this entry answers the query, which is matched against the id,
  /// the keywords and the group's name in the reader's language.
  bool matches(String query, PkStrings t) {
    if (query.isEmpty) return true;
    final needle = query.toLowerCase();
    return id.contains(needle) ||
        keywords.any((word) => word.contains(needle)) ||
        group.labelIn(t).toLowerCase().contains(needle);
  }
}

/// Every icon a category, account, Space, budget or subscription may wear.
///
/// Before this, `PkIcons.named` was a 21-entry `switch` with a `_ =>
/// Icons.category_outlined` fallback and no picker at all: anything a reader
/// named outside those twenty-one rendered as the same generic glyph, and they
/// had no way to choose one in the first place.
abstract final class PkIconCatalog {
  static const entries = <PkIconDef>[
    // ---- Money ---------------------------------------------------------
    PkIconDef(
      id: 'money.bank',
      icon: Icons.account_balance_rounded,
      group: PkIconGroup.money,
      keywords: ['bank', 'branch'],
    ),
    PkIconDef(
      id: 'money.card',
      icon: Icons.credit_card_rounded,
      group: PkIconGroup.money,
      keywords: ['card', 'credit', 'debit'],
    ),
    PkIconDef(
      id: 'money.wallet',
      icon: Icons.account_balance_wallet_rounded,
      group: PkIconGroup.money,
      keywords: ['wallet', 'purse'],
    ),
    PkIconDef(
      id: 'money.cash',
      icon: Icons.payments_outlined,
      group: PkIconGroup.money,
      keywords: ['cash', 'notes', 'bills'],
    ),
    PkIconDef(
      id: 'money.savings',
      icon: Icons.savings_outlined,
      group: PkIconGroup.money,
      keywords: ['savings', 'piggy', 'goal'],
    ),
    PkIconDef(
      id: 'money.income',
      icon: Icons.south_west_rounded,
      group: PkIconGroup.money,
      keywords: ['income', 'salary', 'pay', 'in'],
    ),
    PkIconDef(
      id: 'money.invest',
      icon: Icons.trending_up_rounded,
      group: PkIconGroup.money,
      keywords: ['invest', 'stocks', 'growth'],
    ),
    PkIconDef(
      id: 'money.receipt',
      icon: Icons.receipt_long_outlined,
      group: PkIconGroup.money,
      keywords: ['receipt', 'bill', 'invoice'],
    ),
    PkIconDef(
      id: 'money.tax',
      icon: Icons.account_balance_outlined,
      group: PkIconGroup.money,
      keywords: ['tax', 'government'],
    ),
    PkIconDef(
      id: 'money.crypto',
      icon: Icons.currency_bitcoin_rounded,
      group: PkIconGroup.money,
      keywords: ['crypto', 'bitcoin'],
    ),

    // ---- Food ----------------------------------------------------------
    PkIconDef(
      id: 'food.groceries',
      icon: Icons.shopping_cart_outlined,
      group: PkIconGroup.food,
      keywords: ['groceries', 'supermarket', 'cart'],
    ),
    PkIconDef(
      id: 'food.restaurant',
      icon: Icons.restaurant_rounded,
      group: PkIconGroup.food,
      keywords: ['restaurant', 'dining', 'eat'],
    ),
    PkIconDef(
      id: 'food.cafe',
      icon: Icons.local_cafe_outlined,
      group: PkIconGroup.food,
      keywords: ['cafe', 'coffee', 'tea'],
    ),
    PkIconDef(
      id: 'food.bakery',
      icon: Icons.bakery_dining_outlined,
      group: PkIconGroup.food,
      keywords: ['bakery', 'bread'],
    ),
    PkIconDef(
      id: 'food.takeaway',
      icon: Icons.takeout_dining_outlined,
      group: PkIconGroup.food,
      keywords: ['takeaway', 'delivery', 'takeout'],
    ),
    PkIconDef(
      id: 'food.drinks',
      icon: Icons.local_bar_outlined,
      group: PkIconGroup.food,
      keywords: ['drinks', 'bar', 'alcohol'],
    ),

    // ---- Home ----------------------------------------------------------
    PkIconDef(
      id: 'home.housing',
      icon: Icons.home_rounded,
      group: PkIconGroup.home,
      keywords: ['housing', 'rent', 'mortgage', 'house'],
    ),
    PkIconDef(
      id: 'home.utilities',
      icon: Icons.bolt_rounded,
      group: PkIconGroup.home,
      keywords: ['utilities', 'electricity', 'power', 'gas'],
    ),
    PkIconDef(
      id: 'home.water',
      icon: Icons.water_drop_outlined,
      group: PkIconGroup.home,
      keywords: ['water'],
    ),
    PkIconDef(
      id: 'home.internet',
      icon: Icons.wifi_rounded,
      group: PkIconGroup.home,
      keywords: ['internet', 'wifi', 'broadband'],
    ),
    PkIconDef(
      id: 'home.phone',
      icon: Icons.smartphone_rounded,
      group: PkIconGroup.home,
      keywords: ['phone', 'mobile'],
    ),
    PkIconDef(
      id: 'home.furniture',
      icon: Icons.chair_outlined,
      group: PkIconGroup.home,
      keywords: ['furniture', 'chair'],
    ),
    PkIconDef(
      id: 'home.repairs',
      icon: Icons.handyman_outlined,
      group: PkIconGroup.home,
      keywords: ['repairs', 'maintenance', 'tools'],
    ),
    PkIconDef(
      id: 'home.cleaning',
      icon: Icons.cleaning_services_outlined,
      group: PkIconGroup.home,
      keywords: ['cleaning', 'laundry'],
    ),

    // ---- Transport -----------------------------------------------------
    PkIconDef(
      id: 'transport.transit',
      icon: Icons.directions_transit_rounded,
      group: PkIconGroup.transport,
      keywords: ['transit', 'train', 'metro', 'subway'],
    ),
    PkIconDef(
      id: 'transport.bus',
      icon: Icons.directions_bus_outlined,
      group: PkIconGroup.transport,
      keywords: ['bus', 'coach'],
    ),
    PkIconDef(
      id: 'transport.car',
      icon: Icons.directions_car_outlined,
      group: PkIconGroup.transport,
      keywords: ['car', 'vehicle', 'parking'],
    ),
    PkIconDef(
      id: 'transport.fuel',
      icon: Icons.local_gas_station_outlined,
      group: PkIconGroup.transport,
      keywords: ['fuel', 'petrol', 'gas', 'charging'],
    ),
    PkIconDef(
      id: 'transport.taxi',
      icon: Icons.local_taxi_outlined,
      group: PkIconGroup.transport,
      keywords: ['taxi', 'ride', 'cab'],
    ),
    PkIconDef(
      id: 'transport.bike',
      icon: Icons.pedal_bike_outlined,
      group: PkIconGroup.transport,
      keywords: ['bike', 'bicycle', 'cycling'],
    ),

    // ---- Travel --------------------------------------------------------
    PkIconDef(
      id: 'travel.flight',
      icon: Icons.flight_rounded,
      group: PkIconGroup.travel,
      keywords: ['flight', 'plane', 'airline'],
    ),
    PkIconDef(
      id: 'travel.hotel',
      icon: Icons.hotel_outlined,
      group: PkIconGroup.travel,
      keywords: ['hotel', 'stay', 'accommodation'],
    ),
    PkIconDef(
      id: 'travel.luggage',
      icon: Icons.luggage_outlined,
      group: PkIconGroup.travel,
      keywords: ['luggage', 'trip', 'holiday', 'vacation'],
    ),
    PkIconDef(
      id: 'travel.map',
      icon: Icons.map_outlined,
      group: PkIconGroup.travel,
      keywords: ['map', 'sightseeing', 'tour'],
    ),

    // ---- Health --------------------------------------------------------
    PkIconDef(
      id: 'health.care',
      icon: Icons.favorite_outline_rounded,
      group: PkIconGroup.health,
      keywords: ['health', 'care', 'wellbeing'],
    ),
    PkIconDef(
      id: 'health.pharmacy',
      icon: Icons.medication_outlined,
      group: PkIconGroup.health,
      keywords: ['pharmacy', 'medicine', 'prescription'],
    ),
    PkIconDef(
      id: 'health.doctor',
      icon: Icons.local_hospital_outlined,
      group: PkIconGroup.health,
      keywords: ['doctor', 'hospital', 'clinic', 'dentist'],
    ),
    PkIconDef(
      id: 'health.fitness',
      icon: Icons.fitness_center_outlined,
      group: PkIconGroup.health,
      keywords: ['fitness', 'gym', 'sport'],
    ),

    // ---- Leisure -------------------------------------------------------
    PkIconDef(
      id: 'leisure.entertainment',
      icon: Icons.movie_outlined,
      group: PkIconGroup.leisure,
      keywords: ['entertainment', 'cinema', 'film', 'movie'],
    ),
    PkIconDef(
      id: 'leisure.music',
      icon: Icons.music_note_rounded,
      group: PkIconGroup.leisure,
      keywords: ['music', 'concert', 'streaming'],
    ),
    PkIconDef(
      id: 'leisure.games',
      icon: Icons.sports_esports_outlined,
      group: PkIconGroup.leisure,
      keywords: ['games', 'gaming'],
    ),
    PkIconDef(
      id: 'leisure.books',
      icon: Icons.menu_book_outlined,
      group: PkIconGroup.leisure,
      keywords: ['books', 'reading'],
    ),
    PkIconDef(
      id: 'leisure.hobby',
      icon: Icons.palette_outlined,
      group: PkIconGroup.leisure,
      keywords: ['hobby', 'craft', 'art'],
    ),
    PkIconDef(
      id: 'leisure.pets',
      icon: Icons.pets_rounded,
      group: PkIconGroup.leisure,
      keywords: ['pets', 'dog', 'cat', 'vet'],
    ),

    // ---- Shopping ------------------------------------------------------
    PkIconDef(
      id: 'shopping.general',
      icon: Icons.shopping_bag_outlined,
      group: PkIconGroup.shopping,
      keywords: ['shopping', 'retail'],
    ),
    PkIconDef(
      id: 'shopping.clothes',
      icon: Icons.checkroom_outlined,
      group: PkIconGroup.shopping,
      keywords: ['clothes', 'clothing', 'fashion'],
    ),
    PkIconDef(
      id: 'shopping.tech',
      icon: Icons.devices_outlined,
      group: PkIconGroup.shopping,
      keywords: ['tech', 'electronics', 'devices'],
    ),
    PkIconDef(
      id: 'shopping.gift',
      icon: Icons.card_giftcard_rounded,
      group: PkIconGroup.shopping,
      keywords: ['gift', 'present'],
    ),
    PkIconDef(
      id: 'shopping.beauty',
      icon: Icons.spa_outlined,
      group: PkIconGroup.shopping,
      keywords: ['beauty', 'cosmetics', 'salon'],
    ),

    // ---- Work ----------------------------------------------------------
    PkIconDef(
      id: 'work.office',
      icon: Icons.work_outline_rounded,
      group: PkIconGroup.work,
      keywords: ['work', 'office', 'business'],
    ),
    PkIconDef(
      id: 'work.education',
      icon: Icons.school_outlined,
      group: PkIconGroup.work,
      keywords: ['education', 'school', 'course', 'tuition'],
    ),
    PkIconDef(
      id: 'work.subscription',
      icon: Icons.autorenew_rounded,
      group: PkIconGroup.work,
      keywords: ['subscription', 'recurring', 'renewal'],
    ),
    PkIconDef(
      id: 'work.software',
      icon: Icons.terminal_rounded,
      group: PkIconGroup.work,
      keywords: ['software', 'tools', 'saas'],
    ),

    // ---- People --------------------------------------------------------
    PkIconDef(
      id: 'people.group',
      icon: Icons.group_outlined,
      group: PkIconGroup.people,
      keywords: ['group', 'people', 'members', 'shared'],
    ),
    PkIconDef(
      id: 'people.family',
      icon: Icons.family_restroom_rounded,
      group: PkIconGroup.people,
      keywords: ['family', 'household', 'kids'],
    ),
    PkIconDef(
      id: 'people.couple',
      icon: Icons.favorite_rounded,
      group: PkIconGroup.people,
      keywords: ['couple', 'partner', 'heart'],
    ),
    PkIconDef(
      id: 'people.donation',
      icon: Icons.volunteer_activism_outlined,
      group: PkIconGroup.people,
      keywords: ['donation', 'charity', 'giving'],
    ),

    // ---- Other ---------------------------------------------------------
    PkIconDef(
      id: 'other.category',
      icon: Icons.category_outlined,
      group: PkIconGroup.other,
      keywords: ['other', 'general', 'misc'],
    ),
    PkIconDef(
      id: 'other.link',
      icon: Icons.link_rounded,
      group: PkIconGroup.other,
      keywords: ['link', 'connection'],
    ),
    PkIconDef(
      id: 'other.star',
      icon: Icons.star_outline_rounded,
      group: PkIconGroup.other,
      keywords: ['star', 'favourite', 'important'],
    ),
    PkIconDef(
      id: 'other.tag',
      icon: Icons.sell_outlined,
      group: PkIconGroup.other,
      keywords: ['tag', 'label'],
    ),
  ];

  static final Map<String, PkIconDef> _byId = {
    for (final entry in entries) entry.id: entry,
  };

  /// The names records were saved with before the catalogue existed.
  ///
  /// Kept forever rather than migrated: a stored value is a promise, and the
  /// cost of honouring it is this map.
  static const legacy = <String, String>{
    'bank': 'money.bank',
    'card': 'money.card',
    'wallet': 'money.wallet',
    'cash': 'money.cash',
    'savings': 'money.savings',
    'income': 'money.income',
    'receipt': 'money.receipt',
    'cart': 'food.groceries',
    'restaurant': 'food.restaurant',
    'housing': 'home.housing',
    'utilities': 'home.utilities',
    'transit': 'transport.transit',
    'travel': 'travel.flight',
    'health': 'health.care',
    'entertainment': 'leisure.entertainment',
    'shopping': 'shopping.general',
    'gift': 'shopping.gift',
    'education': 'work.education',
    'group': 'people.group',
    'heart': 'people.couple',
    'link': 'other.link',
  };

  /// The entry for an id, accepting both catalogue and legacy names.
  static PkIconDef? find(String id) => _byId[id] ?? _byId[legacy[id] ?? ''];

  static List<PkIconDef> inGroup(PkIconGroup group) =>
      entries.where((entry) => entry.group == group).toList();
}

abstract final class PkIcons {
  /// The glyph for a stored icon name.
  ///
  /// Unknown names still fall back rather than throwing — a record could carry
  /// anything — but the fallback is now the last resort rather than the answer
  /// for everything outside twenty-one hard-coded words.
  static IconData named(String name) =>
      PkIconCatalog.find(name)?.icon ?? Icons.category_outlined;
}
