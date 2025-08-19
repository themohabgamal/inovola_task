import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class HiveService {
  static Future<void> initHive() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(ExpenseEntityAdapter());
    Hive.registerAdapter(CategoryEntityAdapter());

    // Open boxes
    await Hive.openBox<ExpenseEntity>('expenses_box');
    await Hive.openBox<CategoryEntity>('categories_box');
    await Hive.openBox('dashboard_box');
  }

  static Future<void> closeHive() async {
    await Hive.close();
  }
}
