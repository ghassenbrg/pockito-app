import 'package:flutter/material.dart';

abstract final class PkIcons {
  static IconData named(String name) => switch (name) {
    'bank' => Icons.account_balance_rounded,
    'card' => Icons.credit_card_rounded,
    'wallet' => Icons.account_balance_wallet_rounded,
    'cash' => Icons.payments_outlined,
    'savings' => Icons.savings_outlined,
    'cart' => Icons.shopping_cart_outlined,
    'restaurant' => Icons.restaurant_rounded,
    'transit' => Icons.directions_transit_rounded,
    'housing' => Icons.home_rounded,
    'utilities' => Icons.bolt_rounded,
    'health' => Icons.favorite_outline_rounded,
    'shopping' => Icons.shopping_bag_outlined,
    'entertainment' => Icons.movie_outlined,
    'travel' => Icons.flight_rounded,
    'education' => Icons.school_outlined,
    'gift' => Icons.card_giftcard_rounded,
    'receipt' => Icons.receipt_long_outlined,
    'income' => Icons.south_west_rounded,
    'link' => Icons.link_rounded,
    'group' => Icons.group_outlined,
    _ => Icons.category_outlined,
  };
}
