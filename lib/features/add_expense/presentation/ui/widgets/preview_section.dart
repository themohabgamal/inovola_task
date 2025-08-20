import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';

// In your preview_section.dart file
class PreviewSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final CategoryEntity? selectedCategory;
  final DateTime selectedDate;
  final String selectedCurrency;
  final double conversionRate;
  final String Function(DateTime) formatTime;

  const PreviewSection({
    Key? key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.selectedCurrency,
    required this.conversionRate,
    required this.formatTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amount = double.tryParse(amountController.text) ?? 0;
    final convertedAmount = amount / conversionRate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Text(
          'Preview',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      titleController.text.isEmpty
                          ? 'No title'
                          : titleController.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '-\$${convertedAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (selectedCurrency != 'USD')
                        Text(
                          '${amount.toStringAsFixed(2)} $selectedCurrency',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Text(
                    selectedCategory?.name ?? 'No category',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Spacer(),
                  Text(
                    formatTime(selectedDate),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
