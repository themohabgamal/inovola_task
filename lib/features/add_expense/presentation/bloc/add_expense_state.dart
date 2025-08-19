import 'package:equatable/equatable.dart';
import '../../domain/entities/category_entity.dart';

abstract class AddExpenseState extends Equatable {
  const AddExpenseState();

  @override
  List<Object> get props => [];
}

class AddExpenseInitial extends AddExpenseState {}

class AddExpenseLoading extends AddExpenseState {}

class AddExpenseCategoriesLoaded extends AddExpenseState {
  final List<CategoryEntity> categories;

  const AddExpenseCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class AddExpenseSubmitting extends AddExpenseState {
  final List<CategoryEntity> categories;

  const AddExpenseSubmitting(this.categories);

  @override
  List<Object> get props => [categories];
}

class AddExpenseSuccess extends AddExpenseState {
  final List<CategoryEntity> categories;

  const AddExpenseSuccess(this.categories);

  @override
  List<Object> get props => [categories];
}

class AddExpenseFailure extends AddExpenseState {
  final String error;
  final List<CategoryEntity> categories;

  const AddExpenseFailure(this.error, this.categories);

  @override
  List<Object> get props => [error, categories];
}

class AddExpenseReceiptPicked extends AddExpenseState {
  final String receiptName;
  AddExpenseReceiptPicked(this.receiptName);
}
