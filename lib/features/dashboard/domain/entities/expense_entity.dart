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

  ExpenseEntity({
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
    this.iconName,
    Color? backgroundColor,
    this.time,
  }) : backgroundColorHex = backgroundColor?.value ?? Colors.grey.value;

  /// Getter to convert stored int back into a Flutter [Color]
  Color get backgroundColor => Color(backgroundColorHex);
}
