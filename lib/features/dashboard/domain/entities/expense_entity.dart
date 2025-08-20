import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'expense_entity.g.dart';

@HiveType(typeId: 0)
class ExpenseEntity extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String? iconName;

  @HiveField(5)
  final int backgroundColorHex;

  @HiveField(6)
  final String? time;

  @HiveField(7)
  final String? currency;

  @HiveField(8)
  final double? convertedAmount; // Amount in USD

  @HiveField(9)
  final double? exchangeRate; // Rate used for conversion

  @HiveField(10)
  final String? receiptPath; // Path to receipt image

  ExpenseEntity({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.iconName,
    Color? backgroundColor,
    this.time,
    this.currency = 'USD',
    this.convertedAmount,
    this.exchangeRate,
    this.receiptPath,
  }) : backgroundColorHex = backgroundColor?.value ?? Colors.grey.value;

  /// Getter to convert stored int back into a Flutter [Color]
  Color get backgroundColor => Color(backgroundColorHex);

  /// Helper methods for currency display
  String get formattedAmount {
    final symbol = _getCurrencySymbol(safeCurrency);
    return '$symbol${amount.toStringAsFixed(2)}';
  }

  String get formattedConvertedAmount {
    if (convertedAmount == null) return '';
    return '\$${convertedAmount!.toStringAsFixed(2)} USD';
  }

  bool get isConverted => safeCurrency != 'USD' && convertedAmount != null;

  String get displayAmount {
    if (isConverted) {
      return '${formattedAmount} (${formattedConvertedAmount})';
    }
    return formattedAmount;
  }

  String _getCurrencySymbol(String currencyCode) {
    const symbols = {
      'USD': '\$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CAD': 'C\$',
      'AUD': 'A\$',
      'CHF': 'CHF',
      'CNY': '¥',
      'INR': '₹',
      'BRL': 'R\$',
      'MXN': '\$',
      'KRW': '₩',
      'SGD': 'S\$',
      'HKD': 'HK\$',
      'NOK': 'kr',
      'SEK': 'kr',
      'DKK': 'kr',
      'PLN': 'zł',
      'RUB': '₽',
      'TRY': '₺',
    };
    return symbols[currencyCode] ?? currencyCode;
  }

  /// Create a copy with updated values
  ExpenseEntity copyWith({
    String? title,
    String? category,
    double? amount,
    DateTime? date,
    String? iconName,
    Color? backgroundColor,
    String? time,
    String? currency,
    double? convertedAmount,
    double? exchangeRate,
    String? receiptPath,
  }) {
    return ExpenseEntity(
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      iconName: iconName ?? this.iconName,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      time: time ?? this.time,
      currency: currency ?? this.currency,
      convertedAmount: convertedAmount ?? this.convertedAmount,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      receiptPath: receiptPath ?? this.receiptPath,
    );
  }

  String get safeCurrency => currency ?? 'USD';
}
