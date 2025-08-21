import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';

import '../utility/category_utils.dart';
import '../utility/date_time_utils.dart';

class PreviewSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final CategoryEntity selectedCategory;
  final DateTime selectedDate;
  final String selectedCurrency;
  final double? convertedAmount;

  const PreviewSection({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.selectedCurrency,
    this.convertedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = getColorForCategory(selectedCategory.name);
    final categoryIcon = getIconForCategory(selectedCategory.name);

    return Container(
      padding: const EdgeInsets.all(16),
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
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  getFlutterIcon(categoryIcon),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titleController.text.isEmpty
                          ? 'Enter title...'
                          : titleController.text,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: titleController.text.isEmpty
                                ? Colors.grey[400]
                                : Colors.black,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 2.h,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          getFormattedDate(selectedDate),
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
              SizedBox(width: 8.w), // Add a small gap between the columns
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amountController.text.isEmpty
                        ? '0.00 $selectedCurrency'
                        : '${double.tryParse(amountController.text)?.toStringAsFixed(2) ?? 'Invalid'} $selectedCurrency',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: amountController.text.isEmpty
                              ? Colors.grey[400]
                              : Colors.black,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (convertedAmount != null)
                    Text(
                      '≈ \$${convertedAmount!.toStringAsFixed(2)} USD',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
