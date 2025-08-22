import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import '../../../domain/entities/category_entity.dart';

class HiveDataHelpers {
  HiveDataHelpers._();
  static const _categoryData = {
    'Groceries': {'icon': 'shopping_cart', 'color': '0xFF6366F1'},
    'Entertainment': {'icon': 'movie', 'color': '0xFF3B82F6'},
    'Gas': {'icon': 'local_gas_station', 'color': '0xFFEF4444'},
    'Shopping': {'icon': 'shopping_bag', 'color': '0xFFF59E0B'},
    'News Paper': {'icon': 'newspaper', 'color': '0xFF8B5CF6'},
    'Transport': {'icon': 'directions_car', 'color': '0xFF10B981'},
    'Rent': {'icon': 'home', 'color': '0xFFF97316'},
    'Food': {'icon': 'restaurant', 'color': '0xFF10B981'},
    'Health': {'icon': 'local_hospital', 'color': '0xFFEF4444'},
    'Education': {'icon': 'school', 'color': '0xFF06B6D4'},
    'Bills': {'icon': 'receipt', 'color': '0xFF3B82F6'},
  };

// ✅ Consistent seeding
  static Future<void> seedCategories(Box<CategoryEntity> box) async {
    final categories = _categoryData.entries.map((entry) {
      final data = entry.value;
      return CategoryEntity(
        name: entry.key,
        icon: data['icon']!, // string (matches getIconDataFromName)
        color: data['color']!, // keep hex string directly
      );
    }).toList();
    await box.addAll(categories);
  }

// ✅ Use this when displaying
  static IconData getIconDataFromName(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'movie':
        return Icons.movie_outlined;
      case 'category':
        return Icons.newspaper;
      case 'local_gas_station':
        return Icons.local_gas_station_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'newspaper':
        return Icons.newspaper_outlined;
      case 'directions_car':
      case 'directions_bus':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'local_hospital':
        return Icons.local_hospital_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'receipt':
        return Icons.receipt_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  static ExpenseEntity enhanceExpense(ExpenseEntity expense) {
    return ExpenseEntity(
      title: expense.title,
      category: expense.category,
      amount: expense.amount,
      currency: expense.currency,
      convertedAmount: expense.convertedAmount,
      date: expense.date,
      iconName: expense.iconName ?? _getIconForCategory(expense.category),
      backgroundColor: expense.backgroundColor,
      time: expense.time ?? _formatTime(expense.date),
    );
  }

  static String _getIconForCategory(String category) {
    return _categoryData[category]?['icon'] ?? 'receipt';
  }

  static String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeString = '$displayHour:$minute $period';

    if (expenseDate.isAtSameMomentAs(today)) {
      return 'Today $timeString';
    } else if (expenseDate.isAtSameMomentAs(yesterday)) {
      return 'Yesterday $timeString';
    } else {
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${monthNames[dateTime.month - 1]} ${dateTime.day} $timeString';
    }
  }
}
