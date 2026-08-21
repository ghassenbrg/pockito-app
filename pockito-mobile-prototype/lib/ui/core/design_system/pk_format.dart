import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';

import '../../../domain/models/financial_models.dart';

abstract final class PkFormat {
  static String money(int amountMinor, String currency, {bool sign = false}) {
    final info = PockitoCurrencies.of(currency);
    final divisor = info.minorUnitScale;
    final value = amountMinor / divisor;
    final formatter = NumberFormat.currency(
      locale: 'en',
      symbol: info.symbol,
      decimalDigits: info.decimals,
    );
    final formatted = formatter.format(value.abs());
    if (amountMinor < 0) return '−$formatted';
    if (sign && amountMinor > 0) return '+$formatted';
    return formatted;
  }

  static String compactMoney(int amountMinor, String currency) {
    final info = PockitoCurrencies.of(currency);
    final divisor = info.minorUnitScale;
    return NumberFormat.compactCurrency(
      symbol: info.symbol,
      decimalDigits: 1,
    ).format(amountMinor / divisor);
  }

  /// [t] carries the locale's words for the two relative days; the rest of the
  /// format is delegated to [DateFormat], which is already locale-aware.
  static String shortDate(DateTime date, DateTime today, PkStrings t) {
    final clean = DateTime(date.year, date.month, date.day);
    final now = DateTime(today.year, today.month, today.day);
    if (clean == now) return t.today;
    if (clean == now.subtract(const Duration(days: 1))) return t.yesterday;
    return DateFormat('d MMM', t.localeName).format(date);
  }

  // i18n-exempt — a date pattern, not prose.
  static String longDate(DateTime date, PkStrings t) =>
      DateFormat('EEEE, d MMMM yyyy', t.localeName).format(date); // i18n-exempt
}
