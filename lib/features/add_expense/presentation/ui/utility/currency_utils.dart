import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const defaultCurrencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD'];

const popularCurrencies = [
  'USD',
  'EUR',
  'GBP',
  'JPY',
  'CAD',
  'AUD',
  'CHF',
  'CNY',
  'INR',
  'KRW',
  'MXN',
  'BRL',
  'RUB',
  'SGD',
  'HKD',
  'NOK',
  'SEK',
  'DKK',
  'PLN',
  'CZK',
  'HUF',
  'RON',
  'BGN',
  'HRK',
  'ISK',
  'TRY',
  'ILS',
  'AED',
  'SAR',
  'QAR',
  'KWD',
  'BHD',
  'OMR',
  'JOD',
  'LBP',
  'EGP',
  'MAD',
  'DZD',
  'TND',
  'LYD',
  'ZAR',
  'NGN',
  'GHS',
  'KES',
  'UGX',
  'TZS',
  'RWF',
  'ETB',
  'MUR',
  'SCR',
];

List<String> buildSortedCurrencyList(List<String> allCurrencies) {
  final sortedList = <String>[];
  for (final popular in popularCurrencies) {
    if (allCurrencies.contains(popular) && !sortedList.contains(popular)) {
      sortedList.add(popular);
    }
  }
  return sortedList;
}

/// fallback loader if API fails
Future<void> loadFallbackCurrencies({
  required Function(List<String> currencies, Map<String, double> rates)
      onLoaded,
  required VoidCallback onError,
}) async {
  try {
    final fallbackRates = {
      'USD': 1.0,
      'EUR': 0.92,
      'EGP': 48.0,
      'GBP': 0.79,
    };
    onLoaded(fallbackRates.keys.toList(), fallbackRates);
  } catch (_) {
    onError();
  }
}

Future<double?> convertAmount({
  required TextEditingController amountController,
  required String selectedCurrency,
  required Map<String, double> conversionRates,
}) async {
  final amount = double.tryParse(amountController.text);
  if (amount == null || amount <= 0) return null;

  if (selectedCurrency == 'USD') return amount;

  final rate = conversionRates[selectedCurrency];
  if (rate == null || rate == 0) return null;

  return amount / rate;
}

Future<double> recalcConvertedAmount({
  required double amount,
  required String selectedCurrency,
  required Map<String, double> conversionRates,
}) async {
  if (selectedCurrency == 'USD') return amount;
  final rate = conversionRates[selectedCurrency];
  if (rate == null || rate == 0) return amount;
  return amount / rate;
}

/// Date utils
Future<DateTime?> selectDate(BuildContext context, DateTime initial) {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
}

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}

/// Category helpers
String getIconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'groceries':
      return 'shopping_cart';
    case 'entertainment':
      return 'movie';
    case 'gas':
      return 'local_gas_station';
    case 'transport':
      return 'directions_bus';
    default:
      return 'category';
  }
}

Color getColorForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'groceries':
      return Colors.indigo.shade400;
    case 'entertainment':
      return Colors.blue.shade400;
    case 'gas':
      return Colors.orange.shade400;
    case 'transport':
      return Colors.green.shade400;
    default:
      return Colors.grey.shade400;
  }
}
