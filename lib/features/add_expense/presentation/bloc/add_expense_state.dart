// lib/features/add_expense/presentation/bloc/add_expense_state.dart
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
  final Map<String, dynamic>? exchangeRates;
  final String selectedCurrency;
  final double convertedAmount;

  const AddExpenseCategoriesLoaded({
    required this.categories,
    this.exchangeRates,
    this.selectedCurrency = 'USD',
    this.convertedAmount = 0.0,
  });

  @override
  List<Object> get props => [
        categories,
        selectedCurrency,
        convertedAmount,
      ];
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
  const AddExpenseReceiptPicked(this.receiptName);
}

class ExchangeRatesLoading extends AddExpenseState {}

class ExchangeRatesError extends AddExpenseState {
  final String error;
  final List<CategoryEntity> categories;

  const ExchangeRatesError(this.error, this.categories);

  @override
  List<Object> get props => [error, categories];
}
