// expense_pagination_service.dart
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class ExpensePaginationService {
  /// Gets a page of expenses from the full list
  static PaginationResult getExpensesPage(
      List<ExpenseEntity> allExpenses, int offset, int limit) {
    if (offset >= allExpenses.length) {
      return PaginationResult([], false);
    }

    final endIndex = offset + limit;
    final pageExpenses = allExpenses.sublist(
      offset,
      endIndex > allExpenses.length ? allExpenses.length : endIndex,
    );

    final hasMore = endIndex < allExpenses.length;

    return PaginationResult(pageExpenses, hasMore);
  }
}

/// Result object for pagination operations
class PaginationResult {
  final List<ExpenseEntity> expenses;
  final bool hasMore;

  PaginationResult(this.expenses, this.hasMore);
}
