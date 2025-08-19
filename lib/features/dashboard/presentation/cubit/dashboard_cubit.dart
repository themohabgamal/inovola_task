import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  static const String _expensesBoxName = 'expenses_box';
  static const String _dashboardBoxName = 'dashboard_box';

  Box<ExpenseEntity>? _expenseBox;
  Box? _dashboardBox;

  DashboardCubit() : super(DashboardInitial()) {
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    try {
      emit(DashboardLoading());

      // Open boxes if not already open
      if (!Hive.isBoxOpen(_expensesBoxName)) {
        _expenseBox = await Hive.openBox<ExpenseEntity>(_expensesBoxName);
      } else {
        _expenseBox = Hive.box<ExpenseEntity>(_expensesBoxName);
      }

      if (!Hive.isBoxOpen(_dashboardBoxName)) {
        _dashboardBox = await Hive.openBox(_dashboardBoxName);
      } else {
        _dashboardBox = Hive.box(_dashboardBoxName);
      }

      // Listen to expense box changes
      _expenseBox?.listenable().addListener(_onExpenseDataChanged);
      _dashboardBox?.listenable().addListener(_onDashboardDataChanged);

      // Load initial data
      await loadDashboardData();
    } catch (e) {
      emit(DashboardError('Failed to initialize dashboard: ${e.toString()}'));
    }
  }

  void _onExpenseDataChanged() {
    // Reload dashboard when expenses change
    loadDashboardData();
  }

  void _onDashboardDataChanged() {
    // Reload dashboard when dashboard settings change
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      if (_expenseBox == null || _dashboardBox == null) {
        await _initializeHive();
        return;
      }

      // Add sample data if no expenses exist
      if (_expenseBox!.isEmpty) {
        await _addSampleExpenses();
      }

      // Get dashboard data
      final userName = _dashboardBox!
          .get('userName', defaultValue: 'Shihab Rahman') as String;
      final income =
          _dashboardBox!.get('income', defaultValue: 10840.00) as double;

      // Get all expenses and calculate totals
      final allExpenses = _expenseBox!.values.toList();
      final totalExpenses =
          allExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
      final totalBalance = income - totalExpenses;

      // Get recent expenses (sorted by date, newest first)
      final sortedExpenses = List<ExpenseEntity>.from(allExpenses);
      sortedExpenses.sort((a, b) => b.date.compareTo(a.date));
      final recentExpenses = sortedExpenses.take(10).toList();

      final dashboard = DashboardEntity(
        userName: userName,
        totalBalance: totalBalance,
        income: income,
        expenses: totalExpenses,
        recentExpenses: recentExpenses,
      );

      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> _addSampleExpenses() async {
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
      await _expenseBox!.add(expense);
    }
  }

  Future<void> addExpense(ExpenseEntity expense) async {
    try {
      if (_expenseBox == null) {
        await _initializeHive();
        return;
      }

      await _expenseBox!.add(expense);
      // Dashboard will automatically reload due to listener
    } catch (e) {
      emit(DashboardError('Failed to add expense: ${e.toString()}'));
    }
  }

  Future<void> updateDashboardInfo({
    String? userName,
    double? income,
  }) async {
    try {
      if (_dashboardBox == null) {
        await _initializeHive();
        return;
      }

      if (userName != null) {
        await _dashboardBox!.put('userName', userName);
      }
      if (income != null) {
        await _dashboardBox!.put('income', income);
      }
      // Dashboard will automatically reload due to listener
    } catch (e) {
      emit(DashboardError('Failed to update dashboard: ${e.toString()}'));
    }
  }

  Future<void> deleteExpense(int index) async {
    try {
      if (_expenseBox == null) return;

      await _expenseBox!.deleteAt(index);
      // Dashboard will automatically reload due to listener
    } catch (e) {
      emit(DashboardError('Failed to delete expense: ${e.toString()}'));
    }
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  @override
  Future<void> close() {
    // Remove listeners before closing
    _expenseBox?.listenable().removeListener(_onExpenseDataChanged);
    _dashboardBox?.listenable().removeListener(_onDashboardDataChanged);
    return super.close();
  }
}
