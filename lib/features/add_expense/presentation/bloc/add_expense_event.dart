import 'package:equatable/equatable.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

abstract class AddExpenseEvent extends Equatable {
  const AddExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoriesEvent extends AddExpenseEvent {}

class PickReceiptImage extends AddExpenseEvent {}

class AddExpenseSubmitEvent extends AddExpenseEvent {
  final ExpenseEntity expense;

  const AddExpenseSubmitEvent(this.expense);

  @override
  List<Object> get props => [expense];
}
