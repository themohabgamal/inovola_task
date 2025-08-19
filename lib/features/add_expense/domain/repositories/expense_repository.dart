import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

import '../entities/category_entity.dart';

abstract class ExpenseRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<bool> addExpense(ExpenseEntity expense);
}
