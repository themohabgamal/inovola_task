import 'package:hive/hive.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardLocalDataSource {
  static const String _expensesBoxName = 'expenses_box';
  static const String _dashboardBoxName = 'dashboard_box';

  // Private references to the opened boxes for direct access
  late final Box<ExpenseEntity> _expensesBox;
  late final Box _dashboardBox;

  /// Initializes and opens the Hive boxes.
  Future<void> initializeBoxes() async {
    _expensesBox = await Hive.openBox<ExpenseEntity>(_expensesBoxName);
    _dashboardBox = await Hive.openBox(_dashboardBoxName);
  }

  /// Resets the dashboard data by clearing and re-populating with default values.
  Future<void> resetDashboardData() async {
    await Future.wait([
      _expensesBox.clear(),
      _dashboardBox.clear(),
    ]);

    await _dashboardBox.putAll({
      'userName': 'Shihab Rahman',
      'totalBalance': 6000.00,
      'income': 10840.00,
    });
  }

  /// Fetches all dashboard data, including user info, balances, and expenses.
  Future<DashboardEntity> getDashboardData() async {
    final userName =
        _dashboardBox.get('userName', defaultValue: 'Shihab Rahman') as String;
    final totalBalance =
        _dashboardBox.get('totalBalance', defaultValue: 6000.00) as double;
    final income =
        _dashboardBox.get('income', defaultValue: 10840.00) as double;

    final allExpenses = _expensesBox.values.toList();

    // Calculate total expenses using `fold`
    final totalExpenses =
        allExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);

    // Get the last 10 expenses
    final recentExpenses = allExpenses.reversed.take(10).toList();

    return DashboardEntity(
      userName: userName,
      totalBalance: totalBalance,
      income: income,
      expenses: totalExpenses,
      recentExpenses: recentExpenses,
      currentFilter: 'This Month',
    );
  }

  /// Updates specific fields of the dashboard data.
  Future<void> updateDashboardData({
    String? userName,
    double? totalBalance,
    double? income,
  }) async {
    if (userName != null) {
      await _dashboardBox.put('userName', userName);
    }
    if (totalBalance != null) {
      await _dashboardBox.put('totalBalance', totalBalance);
    }
    if (income != null) {
      await _dashboardBox.put('income', income);
    }
  }

  /// Clears all data from both Hive boxes.
  Future<void> clearAllData() async {
    await Future.wait([
      _expensesBox.clear(),
      _dashboardBox.clear(),
    ]);
  }
}
