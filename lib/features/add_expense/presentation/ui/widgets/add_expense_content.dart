import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_event.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/categories_section.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/form_section.dart';
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
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _submitExpense() {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final expense = ExpenseEntity(
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        category: _selectedCategory!.name,
        date: _selectedDate,
        time: _formatTime(_selectedDate),
        iconName: _getIconForCategory(_selectedCategory!.name),
        backgroundColor: _getColorForCategory(_selectedCategory!.name),
      );

      context.read<AddExpenseBloc>().add(AddExpenseSubmitEvent(expense));

      // Clear form after submission
      _titleController.clear();
      _amountController.clear();
      setState(() {
        _selectedCategory = null;
        _selectedDate = DateTime.now();
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
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

  // Helper method to format time
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final expenseDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeString = '$displayHour:$minute $period';

    if (expenseDate == today) {
      return 'Today $timeString';
    } else if (expenseDate == yesterday) {
      return 'Yesterday $timeString';
    } else {
      final monthNames = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${monthNames[dateTime.month - 1]} ${dateTime.day} $timeString';
    }
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
            // FormSection(
            //   titleController: _titleController,
            //   amountController: _amountController,
            //   selectedDate: _selectedDate,
            //   onDateSelected: _selectDate,
            // ),
            SizedBox(height: 18.h),
            CategoriesSection(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),

            // Preview Section
            if (_selectedCategory != null) ...[
              SizedBox(height: 18.h),
              _buildPreviewSection(),
            ],

            SizedBox(height: 32.h),
            SubmitButtonSection(
              onSubmit: _submitExpense,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewSection() {
    final categoryColor = _getColorForCategory(_selectedCategory!.name);
    final categoryIcon = _getIconForCategory(_selectedCategory!.name);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _getFlutterIcon(categoryIcon),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isEmpty
                          ? 'Enter title...'
                          : _titleController.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _titleController.text.isEmpty
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          _selectedCategory!.name,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '•',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatTime(_selectedDate),
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                _amountController.text.isEmpty
                    ? '\$0.00'
                    : '\$${_amountController.text}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _amountController.text.isEmpty
                          ? Colors.grey[400]
                          : Colors.black,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to convert string icon names to Flutter Icons
  IconData _getFlutterIcon(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'movie':
        return Icons.movie;
      case 'local_gas_station':
        return Icons.local_gas_station;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'newspaper':
        return Icons.newspaper;
      case 'directions_car':
        return Icons.directions_car;
      case 'home':
        return Icons.home;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_hospital':
        return Icons.local_hospital;
      case 'school':
        return Icons.school;
      case 'flight':
        return Icons.flight;
      case 'electrical_services':
        return Icons.electrical_services;
      case 'security':
        return Icons.security;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'checkroom':
        return Icons.checkroom;
      default:
        return Icons.receipt;
    }
  }
}
