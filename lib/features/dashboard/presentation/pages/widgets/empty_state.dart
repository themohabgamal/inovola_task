import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';

class EmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const EmptyState({Key? key, required this.onAddPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text('No expenses yet',
              style: AppTextStyles.font14Weight600Black
                  .copyWith(color: Colors.grey)),
          SizedBox(height: 8),
          Text('Start tracking your expenses',
              style: AppTextStyles.font12Weight400Black
                  .copyWith(color: Colors.grey)),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onAddPressed,
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
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
}
