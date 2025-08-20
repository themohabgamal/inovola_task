import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/utils/date_utils.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_event.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/categories_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/form_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/preview_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/submit_button_section.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

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

  // Category data mapping for icons and colors
  final Map<String, Map<String, dynamic>> _categoryData = {
    'Groceries': {'icon': 'shopping_cart', 'color': Color(0xFF6366F1)},
    'Entertainment': {'icon': 'movie', 'color': Color(0xFF3B82F6)},
    'Gas': {'icon': 'local_gas_station', 'color': Color(0xFFEF4444)},
    'Shopping': {'icon': 'shopping_bag', 'color': Color(0xFFF59E0B)},
    'News Paper': {'icon': 'newspaper', 'color': Color(0xFF8B5CF6)},
    'Transport': {'icon': 'directions_car', 'color': Color(0xFF10B981)},
    'Rent': {'icon': 'home', 'color': Color(0xFFF97316)},
    'Food': {'icon': 'restaurant', 'color': Color(0xFF10B981)},
    'Health': {'icon': 'local_hospital', 'color': Color(0xFFEF4444)},
    'Education': {'icon': 'school', 'color': Color(0xFF06B6D4)},
    'Travel': {'icon': 'flight', 'color': Color(0xFF8B5CF6)},
    'Utilities': {'icon': 'electrical_services', 'color': Color(0xFFEF4444)},
    'Insurance': {'icon': 'security', 'color': Color(0xFF6366F1)},
    'Gym': {'icon': 'fitness_center', 'color': Color(0xFF10B981)},
    'Clothing': {'icon': 'checkroom', 'color': Color(0xFFF59E0B)},
  };

  @override
  void initState() {
    super.initState();
    context.read<AddExpenseBloc>().add(LoadCategoriesEvent());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null && mounted) {
      setState(() => _selectedDate = date);
    }
  }

  void _submitExpense() {
    if (!mounted) return;

    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      // Store values before clearing
      final title = _titleController.text.trim();
      final amount = double.parse(_amountController.text);
      final category = _selectedCategory!;

      final expense = ExpenseEntity(
        title: title,
        amount: amount,
        category: category.name,
        date: _selectedDate,
        time: DateTimeUtils.formatRelativeTime(_selectedDate),
        iconName: _getIconForCategory(category.name),
        backgroundColor: _getColorForCategory(category.name),
      );

      // Store context reference before any state changes
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // Add the expense to BLoC
      context.read<AddExpenseBloc>().add(AddExpenseSubmitEvent(expense));

      // Clear form first
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
      });

      // Show success message using stored reference
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Expense added successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (_selectedCategory == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('Please select a category'),
            ],
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // Helper method to get icon for category
  String _getIconForCategory(String categoryName) {
    return _categoryData[categoryName]?['icon'] ?? 'receipt';
  }

  // Helper method to get color for category
  Color _getColorForCategory(String categoryName) {
    return _categoryData[categoryName]?['color'] ?? Colors.grey;
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
              onDateSelected: _selectDate,
            ),
            SizedBox(height: 18.h),
            CategoriesSection(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                if (mounted) {
                  setState(() {
                    _selectedCategory = category;
                  });
                }
              },
            ),

            // Preview Section
            if (_selectedCategory != null) ...[
              PreviewSection(
                  titleController: _titleController,
                  amountController: _amountController,
                  selectedCategory: _selectedCategory,
                  selectedDate: _selectedDate,
                  formatTime: DateTimeUtils.formatRelativeTime),
            ],

            SizedBox(height: 8.h),
            SubmitButtonSection(
              onSubmit: _submitExpense,
            ),
          ],
        ),
      ),
    );
  }
}
