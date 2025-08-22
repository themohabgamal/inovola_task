import 'package:flutter/material.dart';

class ExpenseUtils {
  static String formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return 'Today $displayHour:$minute $period';
  }

  static String getIconForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return 'shopping_cart';
      case 'Entertainment':
        return 'movie';
      case 'Transport':
        return 'directions_car';
      case 'Rent':
        return 'home';
      case 'Shopping':
        return 'shopping_bag';
      case 'Food':
        return 'restaurant';
      case 'Health':
        return 'local_hospital';
      case 'Education':
        return 'school';
      default:
        return 'receipt';
    }
  }

  static Color getColorForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return const Color(0xFF6366F1);
      case 'Entertainment':
        return const Color(0xFFF59E0B);
      case 'Transport':
        return const Color(0xFF8B5CF6);
      case 'Rent':
        return const Color(0xFFF97316);
      case 'Shopping':
        return const Color(0xFF3B82F6);
      case 'Food':
        return const Color(0xFF10B981);
      case 'Health':
        return const Color(0xFFEF4444);
      case 'Education':
        return const Color(0xFF06B6D4);
      default:
        return Colors.grey;
    }
  }
}
