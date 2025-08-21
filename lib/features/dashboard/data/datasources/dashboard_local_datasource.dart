import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardLocalDataSource {
  static const String _expensesBoxName = 'expenses_box';
  static const String _dashboardBoxName = 'dashboard_box';

  // Initialize Hive boxes
  Future<void> initializeBoxes() async {
    if (!Hive.isBoxOpen(_expensesBoxName)) {
      await Hive.openBox<ExpenseEntity>(_expensesBoxName);
    }
    if (!Hive.isBoxOpen(_dashboardBoxName)) {
      await Hive.openBox(_dashboardBoxName);
    }
  }

  Future<void> resetDashboardData() async {
    await initializeBoxes();

    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);
    final dashboardBox = Hive.box(_dashboardBoxName);

    // Clear all stored data
    await expensesBox.clear();
    await dashboardBox.clear();

    // Optionally, add fresh default values
    await dashboardBox.put('userName', 'Shihab Rahman');
    await dashboardBox.put('totalBalance', 6000.00);
    await dashboardBox.put('income', 10840.00);
  }

  Future<DashboardEntity> getDashboardData() async {
    await initializeBoxes();

    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);
    final dashboardBox = Hive.box(_dashboardBoxName);

    // Get stored dashboard data or use defaults
    final userName =
        dashboardBox.get('userName', defaultValue: 'Shihab Rahman') as String;
    final totalBalance =
        dashboardBox.get('totalBalance', defaultValue: 6000.00) as double;
    final income = dashboardBox.get('income', defaultValue: 10840.00) as double;

    // Get all expenses from Hive
    final allExpenses = expensesBox.values.toList();

    // Calculate total expenses
    final totalExpenses =
        allExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);

    // Get recent expenses (last 10 or all if less than 10)
    final recentExpenses = allExpenses.reversed.take(10).toList();

    // If no expenses exist in Hive, add some sample data
    if (recentExpenses.isEmpty) {
      await _addSampleExpenses();
      return getDashboardData(); // Recursive call to get the newly added data
    }

    return DashboardEntity(
      userName: userName,
      totalBalance: totalBalance,
      income: income,
      expenses: totalExpenses,
      recentExpenses: recentExpenses,
      currentFilter: 'This Month', // Default filter
    );
  }

  Future<void> _addSampleExpenses() async {
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);

    final sampleExpenses = [
      ExpenseEntity(
        title: 'Groceries',
        category: 'Manually',
        amount: 100.00,
        date: DateTime.now(),
        iconName: 'shopping_cart',
        backgroundColor: Color(0xFF6366F1),
        time: 'Today 12:00 PM',
      ),
      ExpenseEntity(
        title: 'Entertainment',
        category: 'Manually',
        amount: 100.00,
        date: DateTime.now().subtract(Duration(hours: 2)),
        iconName: 'movie',
        backgroundColor: Color(0xFFF59E0B),
        time: 'Today 10:00 AM',
      ),
      ExpenseEntity(
        title: 'Transportation',
        category: 'Manually',
        amount: 100.00,
        date: DateTime.now().subtract(Duration(hours: 5)),
        iconName: 'directions_car',
        backgroundColor: Color(0xFF8B5CF6),
        time: 'Today 7:00 AM',
      ),
      ExpenseEntity(
        title: 'Rent',
        category: 'Manually',
        amount: 100.00,
        date: DateTime.now().subtract(Duration(days: 1)),
        iconName: 'home',
        backgroundColor: Color(0xFFF59E0B),
        time: 'Yesterday 9:00 AM',
      ),
    ];

    for (final expense in sampleExpenses) {
      await expensesBox.add(expense);
    }
  }

  Future<void> updateDashboardData({
    String? userName,
    double? totalBalance,
    double? income,
  }) async {
    await initializeBoxes();
    final dashboardBox = Hive.box(_dashboardBoxName);

    if (userName != null) {
      await dashboardBox.put('userName', userName);
    }
    if (totalBalance != null) {
      await dashboardBox.put('totalBalance', totalBalance);
    }
    if (income != null) {
      await dashboardBox.put('income', income);
    }
  }

  Future<void> clearAllData() async {
    await initializeBoxes();
    final expensesBox = Hive.box<ExpenseEntity>(_expensesBoxName);
    final dashboardBox = Hive.box(_dashboardBoxName);

    await expensesBox.clear();
    await dashboardBox.clear();
  }
}
