import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../repositories/helpers/hive_data_helpers.dart';

class HiveExpenseRepository implements ExpenseRepository {
  static const _expensesBoxName = 'expenses_box';
  static const _categoriesBoxName = 'categories_box';

  Future<Box<ExpenseEntity>> get _expenses async =>
      await Hive.openBox<ExpenseEntity>(_expensesBoxName);

  Future<Box<CategoryEntity>> get _categories async =>
      await Hive.openBox<CategoryEntity>(_categoriesBoxName);

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final box = await _categories;
    if (box.isEmpty) {
      await HiveDataHelpers.seedCategories(box);
    }
    return box.values.toList();
  }

  @override
  Future<bool> addExpense(ExpenseEntity expense) async {
    try {
      final box = await _expenses;
      await box.add(HiveDataHelpers.enhanceExpense(expense));
      return true;
    } catch (e) {
      debugPrint('Error adding expense: $e');
      return false;
    }
  }
}
