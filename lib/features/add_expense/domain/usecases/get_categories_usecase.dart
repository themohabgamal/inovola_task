import '../entities/category_entity.dart';
import '../repositories/expense_repository.dart';

class GetCategoriesUseCase {
  final ExpenseRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
