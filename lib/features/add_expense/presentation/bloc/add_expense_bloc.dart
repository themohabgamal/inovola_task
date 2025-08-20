import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/services/image_picking_service.dart';
import 'package:inovola_task/features/add_expense/data/services/currency_service.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/add_expense_usecase.dart';
import 'add_expense_event.dart';
import 'add_expense_state.dart';

/// BLoC responsible for managing the Add Expense flow.
/// Handles:
/// - Fetching categories
/// - Submitting a new expense
/// - Picking receipt image
/// - Handling currency conversion
class AddExpenseBloc extends Bloc<AddExpenseEvent, AddExpenseState> {
  final GetCategoriesUseCase _getCategories;
  final AddExpenseUseCase _addExpense;
  final ImagePickerService _imagePicker;
  final CurrencyService _currencyService;

  /// Cached exchange rates
  Map<String, double> _exchangeRates = {};

  /// Default selected currency
  String _selectedCurrency = 'USD';

  /// Last converted amount
  double _convertedAmount = 0.0;

  AddExpenseBloc({
    required GetCategoriesUseCase getCategoriesUseCase,
    required AddExpenseUseCase addExpenseUseCase,
    required ImagePickerService imagePickerService,
    CurrencyService? currencyService,
  })  : _getCategories = getCategoriesUseCase,
        _addExpense = addExpenseUseCase,
        _imagePicker = imagePickerService,
        _currencyService = currencyService ?? CurrencyService(),
        super(AddExpenseInitial()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<AddExpenseSubmitEvent>(_onAddExpense);
    on<PickReceiptImage>(_onPickReceiptImage);
    on<FetchExchangeRates>(_onFetchExchangeRates);
    on<CurrencyChanged>(_onCurrencyChanged);
  }

  // ------------------------
  // EVENT HANDLERS
  // ------------------------

  /// Handle picking a receipt image from gallery
  Future<void> _onPickReceiptImage(
    PickReceiptImage event,
    Emitter<AddExpenseState> emit,
  ) async {
    final file = await _imagePicker.pickImageFromGallery();
    if (file != null) {
      emit(AddExpenseReceiptPicked(file.name));
    }
  }

  /// Handle loading categories (and fetch exchange rates in parallel)
  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    emit(AddExpenseLoading());
    try {
      final categories = await _getCategories();
      // Fetch exchange rates as a follow-up action
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

  /// Handle expense submission
  Future<void> _onAddExpense(
    AddExpenseSubmitEvent event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is! AddExpenseCategoriesLoaded) return;

    final currentState = state as AddExpenseCategoriesLoaded;
    final categories = currentState.categories;

    emit(AddExpenseSubmitting(categories));

    try {
      final success = await _addExpense(event.expense);
      if (success) {
        emit(AddExpenseSuccess(categories));
      } else {
        emit(AddExpenseFailure('Failed to add expense', categories));
      }
    } catch (e) {
      emit(AddExpenseFailure(e.toString(), categories));
    }
  }

  /// Handle fetching exchange rates from service
  Future<void> _onFetchExchangeRates(
    FetchExchangeRates event,
    Emitter<AddExpenseState> emit,
  ) async {
    if (state is! AddExpenseCategoriesLoaded) return;

    final currentState = state as AddExpenseCategoriesLoaded;

    try {
      _exchangeRates = await CurrencyService.getConversionRates();

      emit(AddExpenseCategoriesLoaded(
        categories: currentState.categories,
        exchangeRates: _exchangeRates,
        selectedCurrency: _selectedCurrency,
        convertedAmount: _convertedAmount,
      ));
    } catch (e) {
      emit(ExchangeRatesError(e.toString(), currentState.categories));
    }
  }

  /// Handle currency change event
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

  // ------------------------
  // HELPERS
  // ------------------------

  /// Convert amount between two currencies
  double convertAmount(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;

    return amount * (toRate / fromRate);
  }

  /// Get the exchange rate between two currencies
  double getExchangeRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return 1.0;

    final fromRate = _exchangeRates[fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[toCurrency] ?? 1.0;

    return toRate / fromRate;
  }
}
