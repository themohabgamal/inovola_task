import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class ExpenseFilterService {
  /// Filters expenses based on the selected time period
  /// Returns a list of expenses that match the filter criteria
  static List<ExpenseEntity> filterExpenses(
      List<ExpenseEntity> expenses, String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case 'This Month':
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfMonth.subtract(Duration(days: 1))))
            .toList();

      case 'Last Month':
        final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        return expenses
            .where((expense) =>
                expense.date
                    .isAfter(firstDayOfLastMonth.subtract(Duration(days: 1))) &&
                expense.date
                    .isBefore(lastDayOfLastMonth.add(Duration(days: 1))))
            .toList();

      case 'Last 7 Days':
        final sevenDaysAgo = today.subtract(Duration(days: 7));
        return expenses
            .where((expense) =>
                expense.date.isAfter(sevenDaysAgo.subtract(Duration(days: 1))))
            .toList();

      case 'This Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final firstMonthOfQuarter = (currentQuarter - 1) * 3 + 1;
        final firstDayOfQuarter = DateTime(now.year, firstMonthOfQuarter, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfQuarter.subtract(Duration(days: 1))))
            .toList();

      case 'Last Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final lastQuarter = currentQuarter > 1 ? currentQuarter - 1 : 4;
        final year = currentQuarter > 1 ? now.year : now.year - 1;
        final firstMonthOfLastQuarter = (lastQuarter - 1) * 3 + 1;
        final lastMonthOfLastQuarter = lastQuarter * 3;
        final firstDayOfLastQuarter =
            DateTime(year, firstMonthOfLastQuarter, 1);
        final lastDayOfLastQuarter =
            DateTime(year, lastMonthOfLastQuarter + 1, 0);
        return expenses
            .where((expense) =>
                expense.date.isAfter(
                    firstDayOfLastQuarter.subtract(Duration(days: 1))) &&
                expense.date
                    .isBefore(lastDayOfLastQuarter.add(Duration(days: 1))))
            .toList();

      case 'This Year':
        final firstDayOfYear = DateTime(now.year, 1, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfYear.subtract(Duration(days: 1))))
            .toList();

      case 'Last Year':
        final firstDayOfLastYear = DateTime(now.year - 1, 1, 1);
        final lastDayOfLastYear = DateTime(now.year - 1, 12, 31);
        return expenses
            .where((expense) =>
                expense.date
                    .isAfter(firstDayOfLastYear.subtract(Duration(days: 1))) &&
                expense.date.isBefore(lastDayOfLastYear.add(Duration(days: 1))))
            .toList();

      default:
        return expenses;
    }
  }
}
