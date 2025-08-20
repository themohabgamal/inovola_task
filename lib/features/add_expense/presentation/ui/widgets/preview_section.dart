import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/category_utils.dart';

class PreviewSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final CategoryEntity? selectedCategory;
  final DateTime selectedDate;
  final String Function(DateTime) formatTime;

  const PreviewSection({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedCategory,
    required this.selectedDate,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor =
        CategoryUtils.getColorForCategory(selectedCategory!.name);
    final categoryIcon =
        CategoryUtils.getIconForCategory(selectedCategory!.name);

    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 8.h),
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
                  CategoryUtils.getFlutterIcon(categoryIcon),
                  color: categoryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: titleController,
                      builder: (context, value, child) {
                        return Text(
                          value.text.isEmpty ? 'Enter title...' : value.text,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: value.text.isEmpty
                                        ? Colors.grey[400]
                                        : Colors.black,
                                  ),
                        );
                      },
                    ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          selectedCategory!.name,
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
                          formatTime(selectedDate),
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
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: amountController,
                builder: (context, value, child) {
                  return Text(
                    value.text.isEmpty ? '\$0.00' : '\$${value.text}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: value.text.isEmpty
                              ? Colors.grey[400]
                              : Colors.black,
                        ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
