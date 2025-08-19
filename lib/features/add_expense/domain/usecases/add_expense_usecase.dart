import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<bool> call(ExpenseEntity expense) async {
    return await repository.addExpense(expense);
  }
}
