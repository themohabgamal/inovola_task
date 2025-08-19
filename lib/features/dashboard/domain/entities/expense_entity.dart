import 'dart:ui';

class ExpenseEntity {
  final String title;
  final String category;
  final double amount;
  final String time;
  final String iconName;
  final Color backgroundColor;

  ExpenseEntity({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.iconName,
    required this.backgroundColor,
  });
}
