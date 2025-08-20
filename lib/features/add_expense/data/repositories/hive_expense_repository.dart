import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/expense_repository.dart';

class HiveExpenseRepository implements ExpenseRepository {
  static const String _expensesBoxName = 'expenses_box';
  static const String _categoriesBoxName = 'categories_box';

  // Initialize Hive boxes
  Future<void> _initializeBoxes() async {
    if (!Hive.isBoxOpen(_expensesBoxName)) {
      await Hive.openBox<ExpenseEntity>(_expensesBoxName);
    }
    if (!Hive.isBoxOpen(_categoriesBoxName)) {
      await Hive.openBox<CategoryEntity>(_categoriesBoxName);
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await _initializeBoxes();
    final categoriesBox = Hive.box<CategoryEntity>(_categoriesBoxName);

    if (categoriesBox.isEmpty) {}

    return categoriesBox.values.toList();
  }

  @override
  Future<bool> addExpense(ExpenseEntity expense) async {
    try {
      await _initializeBoxes();
      final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

      // Ensure the expense has proper data
      final enhancedExpense = ExpenseEntity(
        title: expense.title,
        category: expense.category,
        amount: expense.amount,
        date: expense.date,
        iconName: expense.iconName ?? _getIconForCategory(expense.category),
        backgroundColor: expense.backgroundColor,
        time: expense.time ?? _formatTime(expense.date),
      );

      // Add expense to Hive
      await expensesBox.add(enhancedExpense);

      // Simulate some processing delay
      await Future.delayed(const Duration(milliseconds: 500));

      return true;
    } catch (e) {
      print('Error adding expense: $e');
      return false;
    }
  }

  // Helper methods to get icon and color for categories
  String _getIconForCategory(String category) {
    final categoryData = _getCategoryData();
    return categoryData[category]?['icon'] ?? 'receipt';
  }

  Color _getColorForCategory(String category) {
    final categoryData = _getCategoryData();
    final colorString = categoryData[category]?['color'] ?? '0xFF9E9E9E';
    return Color(int.parse(colorString));
  }

  Map<String, Map<String, String>> _getCategoryData() {
    return {
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
    };
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final expenseDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeString = '$displayHour:$minute $period';

    if (expenseDate == today) {
      return 'Today $timeString';
    } else if (expenseDate == yesterday) {
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

  // Method to create a properly formatted expense
  ExpenseEntity createExpense({
    required String title,
    required String category,
    required double amount,
    DateTime? date,
  }) {
    final expenseDate = date ?? DateTime.now();

    return ExpenseEntity(
      title: title,
      category: category,
      amount: amount,
      date: expenseDate,
      iconName: _getIconForCategory(category),
      backgroundColor: _getColorForCategory(category),
      time: _formatTime(expenseDate),
    );
  }

  // Additional methods for expense management
  Future<List<ExpenseEntity>> getAllExpenses() async {
    await _initializeBoxes();
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);
    return expensesBox.values.toList();
  }

  Future<bool> updateExpense(int index, ExpenseEntity expense) async {
    try {
      await _initializeBoxes();
      final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

      // Ensure the updated expense has proper data
      final enhancedExpense = ExpenseEntity(
        title: expense.title,
        category: expense.category,
        amount: expense.amount,
        date: expense.date,
        iconName: expense.iconName ?? _getIconForCategory(expense.category),
        backgroundColor: expense.backgroundColor,
        time: expense.time ?? _formatTime(expense.date),
      );

      await expensesBox.putAt(index, enhancedExpense);
      return true;
    } catch (e) {
      print('Error updating expense: $e');
      return false;
    }
  }

  Future<bool> deleteExpense(int index) async {
    try {
      await _initializeBoxes();
      final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

      await expensesBox.deleteAt(index);
      return true;
    } catch (e) {
      print('Error deleting expense: $e');
      return false;
    }
  }

  Future<List<ExpenseEntity>> getExpensesByCategory(String category) async {
    await _initializeBoxes();
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

    return expensesBox.values
        .where((expense) => expense.category == category)
        .toList();
  }

  Future<List<ExpenseEntity>> getExpensesByDateRange(
      DateTime startDate, DateTime endDate) async {
    await _initializeBoxes();
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

    return expensesBox.values
        .where((expense) =>
            expense.date.isAfter(startDate.subtract(Duration(days: 1))) &&
            expense.date.isBefore(endDate.add(Duration(days: 1))))
        .toList();
  }

  Future<double> getTotalExpensesByCategory(String category) async {
    final expenses = await getExpensesByCategory(category);
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  Future<void> clearAllExpenses() async {
    await _initializeBoxes();
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);
    await expensesBox.clear();
  }

  Future<void> addCategory(CategoryEntity category) async {
    await _initializeBoxes();
    final categoriesBox = Hive.box<CategoryEntity>(_categoriesBoxName);
    await categoriesBox.add(category);
  }

  // Get available categories as a simple list
  List<String> getAvailableCategories() {
    return [
      'Groceries',
      'Entertainment',
      'Gas',
      'Shopping',
      'News Paper',
      'Transport',
      'Rent',
      'Food',
      'Health',
      'Education',
    ];
  }
}
