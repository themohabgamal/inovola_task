import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/add_expense/data/repositories/helpers/hive_data_helpers.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseEntity expense;

  const ExpenseItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final usdAmount =
        '≈ ${(expense.convertedAmount ?? expense.amount).toStringAsFixed(2)} USD';
    final localAmount =
        '-${expense.amount.toStringAsFixed(2)} ${expense.currency ?? 'USD'}';

    return Container(
      height: AppDimens.expenseItemHeight + 10,
      padding: EdgeInsets.all(AppDimens.paddingS),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          SizedBox(width: AppDimens.paddingM),
          _buildDetails(context),
          _buildAmounts(context, usdAmount, localAmount),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 38.r,
      height: 38.r,
      decoration: BoxDecoration(
        color: expense.backgroundColor.withValues(alpha: .2),
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: Icon(
        HiveDataHelpers.getIconDataFromName(expense.iconName ?? ''),
        color: expense.backgroundColor,
        size: AppDimens.iconM,
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            expense.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            expense.category,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAmounts(
    BuildContext context,
    String usdAmount,
    String localAmount,
  ) {
    final isUsd = expense.currency == null || expense.currency == 'USD';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isUsd ? usdAmount : localAmount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
        ),
        SizedBox(height: 2.h),
        if (!isUsd)
          Text(
            usdAmount,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 11.sp,
                ),
          ),
        if (expense.time?.isNotEmpty ?? false)
          Text(
            expense.time!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 10.sp,
                ),
          ),
      ],
    );
  }
}
