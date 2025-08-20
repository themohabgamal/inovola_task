import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/features/add_expense/data/services/currency_service.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_event.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/categories_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/form_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/submit_button_section.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

import '../utility/currency_utils.dart';
import 'conversion_info_section.dart';
import 'preview_section.dart';

class AddExpenseContent extends StatefulWidget {
  const AddExpenseContent({super.key});

  @override
  State<AddExpenseContent> createState() => _AddExpenseContentState();
}

class _AddExpenseContentState extends State<AddExpenseContent> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  CategoryEntity? _selectedCategory;
  String _selectedCurrency = 'USD';
  double? _convertedAmount;

  List<String> _currencyOptions = defaultCurrencies;
  bool _isLoadingRates = false;
  Map<String, double> _conversionRates = {};

  @override
  void initState() {
    super.initState();
    context.read<AddExpenseBloc>().add(LoadCategoriesEvent());
    _loadCurrencyOptions();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrencyOptions() async {
    setState(() => _isLoadingRates = true);

    try {
      final rates = await CurrencyService.getConversionRates();
      setState(() {
        _conversionRates = rates;
        _currencyOptions = buildSortedCurrencyList(rates.keys.toList());
        _isLoadingRates = false;
      });
    } catch (_) {
      await loadFallbackCurrencies(
        onLoaded: (currencies, rates) {
          setState(() {
            _conversionRates = rates;
            _currencyOptions = buildSortedCurrencyList(currencies);
            _isLoadingRates = false;
          });
        },
        onError: () => setState(() => _isLoadingRates = false),
      );
    }
  }

  Future<void> _convertAmount() async {
    final converted = await convertAmount(
      amountController: _amountController,
      selectedCurrency: _selectedCurrency,
      conversionRates: _conversionRates,
    );
    setState(() => _convertedAmount = converted);
  }

  void _onCurrencyChanged(String currency) {
    setState(() => _selectedCurrency = currency);
    _convertAmount();
  }

  void _submitExpense() async {
    if (!_formKey.currentState!.validate() || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 8),
            Text(_selectedCategory == null
                ? 'Please select a category'
                : 'Please enter a valid amount'),
          ]),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text)!;
    double convertedAmount = _convertedAmount ?? amount;

    if (_convertedAmount == null && _selectedCurrency != 'USD') {
      convertedAmount = await recalcConvertedAmount(
        amount: amount,
        selectedCurrency: _selectedCurrency,
        conversionRates: _conversionRates,
      );
    }

    final expense = ExpenseEntity(
      title: _titleController.text.trim(),
      amount: amount,
      currency: _selectedCurrency,
      convertedAmount: convertedAmount,
      category: _selectedCategory!.name,
      date: _selectedDate,
      time: formatTime(_selectedDate),
      iconName: getIconForCategory(_selectedCategory!.name),
      backgroundColor: getColorForCategory(_selectedCategory!.name),
    );

    context.read<AddExpenseBloc>().add(AddExpenseSubmitEvent(expense));

    _titleController.clear();
    _amountController.clear();
    setState(() {
      _selectedCategory = null;
      _selectedDate = DateTime.now();
      _selectedCurrency = 'USD';
      _convertedAmount = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(children: const [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Text('Expense added successfully!'),
        ]),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormSection(
              titleController: _titleController,
              amountController: _amountController,
              selectedDate: _selectedDate,
              onDateSelected: () async {
                final date = await selectDate(context, _selectedDate);
                if (date != null) setState(() => _selectedDate = date);
              },
              selectedCurrency: _selectedCurrency,
              onCurrencyChanged: _onCurrencyChanged,
              currencyOptions: _currencyOptions,
              onAmountChanged: _convertAmount,
              isLoadingRates: _isLoadingRates,
            ),
            SizedBox(height: 18.h),
            CategoriesSection(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) =>
                  setState(() => _selectedCategory = category),
            ),
            if (_selectedCategory != null) ...[
              SizedBox(height: 18.h),
              PreviewSection(
                titleController: _titleController,
                amountController: _amountController,
                selectedCategory: _selectedCategory!,
                selectedDate: _selectedDate,
                selectedCurrency: _selectedCurrency,
                convertedAmount: _convertedAmount,
              ),
            ],
            if (_convertedAmount != null && _selectedCurrency != 'USD') ...[
              SizedBox(height: 12.h),
              ConversionInfoSection(
                amountController: _amountController,
                selectedCurrency: _selectedCurrency,
                convertedAmount: _convertedAmount!,
              ),
            ],
            SizedBox(height: 32.h),
            SubmitButtonSection(onSubmit: _submitExpense),
          ],
        ),
      ),
    );
  }
}
