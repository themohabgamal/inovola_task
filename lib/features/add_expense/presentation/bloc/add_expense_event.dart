// lib/features/add_expense/presentation/bloc/add_expense_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
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

class AddExpense extends AddExpenseEvent {
  final String title;
  final String category;
  final double amount;
  final String currency;
  final double convertedAmount; // Amount in USD
  final double exchangeRate;
  final DateTime date;
  final String? iconName;
  final Color? backgroundColor;
  final String? time;
  final String? receiptPath;

  AddExpense({
    required this.title,
    required this.category,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.date,
    this.iconName,
    this.backgroundColor,
    this.time,
    this.receiptPath,
  });

  @override
  List<Object> get props => [
        title,
        category,
        amount,
        currency,
        convertedAmount,
        exchangeRate,
        date,
      ];
}

class LoadExpenses extends AddExpenseEvent {}

class UpdateExpense extends AddExpenseEvent {
  final ExpenseEntity expense;
  final String title;
  final String category;
  final double amount;
  final String currency;
  final double convertedAmount;
  final double exchangeRate;
  final DateTime date;
  final String? iconName;
  final Color? backgroundColor;
  final String? time;
  final String? receiptPath;

  UpdateExpense({
    required this.expense,
    required this.title,
    required this.category,
    required this.amount,
    required this.currency,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.date,
    this.iconName,
    this.backgroundColor,
    this.time,
    this.receiptPath,
  });
}

class DeleteExpense extends AddExpenseEvent {
  final ExpenseEntity expense;

  DeleteExpense({required this.expense});
}

class FetchExchangeRates extends AddExpenseEvent {
  final String baseCurrency;

  FetchExchangeRates({this.baseCurrency = 'USD'});
}

class CurrencyChanged extends AddExpenseEvent {
  final String currency;

  CurrencyChanged(this.currency);

  @override
  List<Object> get props => [currency];
}
