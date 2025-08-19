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

  // Stored as int for Hive
  @HiveField(5)
  final int? _backgroundColorHex;

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
  }) : _backgroundColorHex = backgroundColor?.value;

  Color get backgroundColor =>
      _backgroundColorHex != null ? Color(_backgroundColorHex) : Colors.grey;
}
