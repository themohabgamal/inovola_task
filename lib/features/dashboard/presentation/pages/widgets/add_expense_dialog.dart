import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_utils.dart';

void showAddExpenseDialog(BuildContext context) {
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                      iconName:
                          ExpenseUtils.getIconForCategory(selectedCategory),
                      backgroundColor:
                          ExpenseUtils.getColorForCategory(selectedCategory),
                      time: ExpenseUtils.formatTime(DateTime.now()),
                    );

                    context
                        .read<DashboardBloc>()
                        .add(DashboardAddExpenseEvent(expense));
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
