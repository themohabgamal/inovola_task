import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class DashboardEntity {
  final String userName;
  final double totalBalance;
  final double income;
  final double expenses;
  final List<ExpenseEntity> recentExpenses;

  DashboardEntity({
    required this.userName,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.recentExpenses,
  });
}
