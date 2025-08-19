import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_item.dart';
import 'package:inovola_task/features/dashboard/presentation/cubit/dashboard_cubit.dart';

class RecentExpensesSection extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const RecentExpensesSection({Key? key, required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.paddingL,
            AppDimens.paddingM,
            AppDimens.paddingL,
            AppDimens.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.recentExpenses,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to see all expenses
                  // Navigator.pushNamed(context, '/all-expenses');
                },
                child: Text(
                  AppStrings.seeAll,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: expenses.isEmpty
              ? _buildEmptyState(context)
              : RefreshIndicator(
                  onRefresh: () async {
                    // Trigger refresh in the cubit
                    context.read<DashboardCubit>().refreshDashboard();
                  },
                  child: ListView.builder(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: AppDimens.paddingS),
                        child: Dismissible(
                          key: Key('expense_${expenses[index].hashCode}'),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await _showDeleteConfirmation(context);
                          },
                          onDismissed: (direction) {
                            // Delete expense from Hive via cubit
                            context.read<DashboardCubit>().deleteExpense(index);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Expense deleted'),
                                backgroundColor: Colors.red,
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    // You could implement undo functionality here
                                    context
                                        .read<DashboardCubit>()
                                        .refreshDashboard();
                                  },
                                ),
                              ),
                            );
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            color: Colors.red,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          child: ExpenseItem(expense: expenses[index]),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No expenses yet',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          SizedBox(height: 8),
          Text(
            'Start tracking your expenses',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _showAddExpenseDialog(context);
            },
            icon: Icon(Icons.add),
            label: Text('Add Expense'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete Expense'),
              content: Text('Are you sure you want to delete this expense?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                  child: Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showAddExpenseDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String selectedCategory = 'Groceries';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Expense'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      'Groceries',
                      'Entertainment',
                      'Transportation',
                      'Rent',
                      'Shopping',
                      'Food',
                      'Health',
                      'Education',
                    ].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      final expense = ExpenseEntity(
                        title: titleController.text,
                        category: selectedCategory,
                        amount: double.tryParse(amountController.text) ?? 0.0,
                        date: DateTime.now(),
                        iconName: _getIconForCategory(selectedCategory),
                        backgroundColor: _getColorForCategory(selectedCategory),
                        time: _formatTime(DateTime.now()),
                      );

                      context.read<DashboardCubit>().addExpense(expense);
                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Expense added successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _getIconForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return 'shopping_cart';
      case 'Entertainment':
        return 'movie';
      case 'Transportation':
        return 'directions_car';
      case 'Rent':
        return 'home';
      case 'Shopping':
        return 'shopping_bag';
      case 'Food':
        return 'restaurant';
      case 'Health':
        return 'local_hospital';
      case 'Education':
        return 'school';
      default:
        return 'receipt';
    }
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'Groceries':
        return Color(0xFF6366F1);
      case 'Entertainment':
        return Color(0xFFF59E0B);
      case 'Transportation':
        return Color(0xFF8B5CF6);
      case 'Rent':
        return Color(0xFFF97316);
      case 'Shopping':
        return Color(0xFF3B82F6);
      case 'Food':
        return Color(0xFF10B981);
      case 'Health':
        return Color(0xFFEF4444);
      case 'Education':
        return Color(0xFF06B6D4);
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return 'Today $displayHour:$minute $period';
  }
}
