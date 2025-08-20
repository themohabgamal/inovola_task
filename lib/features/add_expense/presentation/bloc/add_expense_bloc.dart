// lib/features/add_expense/presentation/bloc/add_expense_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/services/image_picking_service.dart';
import 'package:inovola_task/features/add_expense/data/services/currency_service.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final GetCategoriesUseCase getCategoriesUseCase;
  final AddExpenseUseCase addExpenseUseCase;
  final ImagePickerService imagePickerService;
  final CurrencyService _currencyService;

  Map<String, dynamic> _exchangeRates = {};
  String _selectedCurrency = 'USD';
  double _convertedAmount = 0.0;

  AddExpenseBloc({
    required this.imagePickerService,
    required this.getCategoriesUseCase,
    required this.addExpenseUseCase,
  })  : _currencyService = CurrencyService(),
        super(AddExpenseInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddExpenseSubmitEvent>(_onAddExpense);
    on<PickReceiptImage>(_onPickReceiptImage);
    on<FetchExchangeRates>(_onFetchExchangeRates);
    on<CurrencyChanged>(_onCurrencyChanged);
  }

  Future<void> _onPickReceiptImage(
      PickReceiptImage event, Emitter<AddExpenseState> emit) async {
    final file = await imagePickerService.pickImageFromGallery();
    if (file != null) {
      emit(AddExpenseReceiptPicked(file.name));
    }
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(AddExpenseLoading());
    try {
      final categories = await getCategoriesUseCase();
      // Fetch exchange rates when loading categories
      add(FetchExchangeRates());
      emit(AddExpenseCategoriesLoaded(
        categories: categories,
        selectedCurrency: _selectedCurrency,
        convertedAmount: _convertedAmount,
      ));
    } catch (e) {
      emit(AddExpenseFailure(e.toString(), []));
    }
  }

  Future<void> _onAddExpense(
    AddExpenseSubmitEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is AddExpenseCategoriesLoaded) {
      final currentState = state as AddExpenseCategoriesLoaded;
      final currentCategories = currentState.categories;

      emit(AddExpenseSubmitting(currentCategories));

      try {
        final success = await addExpenseUseCase(event.expense);
        if (success) {
          emit(AddExpenseSuccess(currentCategories));
        } else {
          emit(AddExpenseFailure('Failed to add expense', currentCategories));
        }
      } catch (e) {
        emit(AddExpenseFailure(e.toString(), currentCategories));
      }
    }
  }

  Future<void> _onFetchExchangeRates(
    FetchExchangeRates event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is AddExpenseCategoriesLoaded) {
      final currentState = state as AddExpenseCategoriesLoaded;

      try {
        final rates =
            await _currencyService.getExchangeRates(event.baseCurrency);
        _exchangeRates = rates;

        emit(AddExpenseCategoriesLoaded(
          categories: currentState.categories,
          exchangeRates: rates,
          selectedCurrency: _selectedCurrency,
          convertedAmount: _convertedAmount,
        ));
      } catch (e) {
        emit(ExchangeRatesError(e.toString(), currentState.categories));
      }
    }
  }

  void _onCurrencyChanged(
    CurrencyChanged event,
    Emitter<AddExpenseState> emit,
  ) {
    _selectedCurrency = event.currency;

    if (state is AddExpenseCategoriesLoaded) {
      final currentState = state as AddExpenseCategoriesLoaded;

      emit(AddExpenseCategoriesLoaded(
        categories: currentState.categories,
        exchangeRates: _exchangeRates,
        selectedCurrency: _selectedCurrency,
        convertedAmount: _convertedAmount,
      ));
    }
  }

  // Helper method to convert amount
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    final rates = _exchangeRates['conversion_rates'];
    if (rates == null) return amount;

    final fromRate = rates[fromCurrency] ?? 1.0;
    final toRate = rates[toCurrency] ?? 1.0;

    return amount * (toRate / fromRate);
  }

  double getExchangeRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;

    final rates = _exchangeRates['conversion_rates'];
    if (rates == null) return 1.0;

    final fromRate = rates[fromCurrency] ?? 1.0;
    final toRate = rates[toCurrency] ?? 1.0;

    return toRate / fromRate;
  }
}
