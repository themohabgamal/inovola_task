import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';

class DashboardCalculatorService {
  /// Calculates total expenses from a list of expenses
  static double calculateTotalExpenses(List<ExpenseEntity> expenses) {
    return expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  /// Creates a DashboardEntity from the provided data
  static DashboardEntity createDashboard({
    required String userName,
    required double income,
    required List<ExpenseEntity> allExpenses,
    required List<ExpenseEntity> recentExpenses,
    required String currentFilter,
    required bool hasMore,
  }) {
    final totalExpenses = calculateTotalExpenses(allExpenses);
    final totalBalance = income - totalExpenses;

    return DashboardEntity(
      userName: userName,
      totalBalance: totalBalance,
      income: income,
      expenses: totalExpenses,
      recentExpenses: recentExpenses,
      currentFilter: currentFilter,
      hasMore: hasMore,
    );
  }
}
