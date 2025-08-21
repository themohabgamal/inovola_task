import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/add_expense/data/repositories/helpers/hive_data_helpers.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseEntity expense;

  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // USD amount (converted amount)
    final String usdAmountText =
        '≈ ${(expense.convertedAmount ?? expense.amount).toStringAsFixed(2)} USD';

    // Amount in user's selected currency
    final String selectedCurrencyAmountText =
        '-${expense.amount.toStringAsFixed(2)} ${expense.currency ?? 'USD'}';

    return Container(
      height: AppDimens.expenseItemHeight != null
          ? AppDimens.expenseItemHeight! + 5
          : 73.h,
      padding: EdgeInsets.all(AppDimens.paddingS ?? 8.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground ?? Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusM ?? 12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color:
                    (expense.backgroundColor ?? Colors.grey).withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppDimens.radiusL ?? 20.0),
              ),
              child: Icon(
                HiveDataHelpers.getIconDataFromName(expense.iconName ?? ''),
                color: expense.backgroundColor ?? Colors.grey,
                size: AppDimens.iconM ?? 20.0,
              )),
          SizedBox(width: AppDimens.paddingM ?? 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  expense.title ?? 'No Title',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black ?? Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  expense.category ?? 'No Category',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display original amount with its currency if different from USD
              if (expense.currency != null && expense.currency != 'USD') ...[
                Text(
                  selectedCurrencyAmountText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black ?? Colors.black,
                      ),
                ),
                SizedBox(height: 2.h),
                // Display the converted USD amount as a subtitle
                Text(
                  usdAmountText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 11.sp,
                      ),
                ),
              ] else ...[
                // If currency is USD, show only USD amount
                Text(
                  usdAmountText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.black ?? Colors.black,
                      ),
                ),
                SizedBox(height: 2.h),
              ],

              // Always show time if available
              if (expense.time != null && expense.time!.isNotEmpty)
                Text(
                  expense.time!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 10.sp,
                      ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart_outlined;
      case 'movie':
        return Icons.movie_outlined;
      case 'directions_car':
        return Icons.directions_car_outlined;
      case 'home':
        return Icons.home_outlined;
      case 'local_gas_station':
        return Icons.local_gas_station_outlined;
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'newspaper':
        return Icons.newspaper_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'local_hospital':
        return Icons.local_hospital_outlined;
      case 'school':
        return Icons.school_outlined;
      case 'flight':
        return Icons.flight_outlined;
      case 'electrical_services':
        return Icons.electrical_services_outlined;
      case 'security':
        return Icons.security_outlined;
      case 'fitness_center':
        return Icons.fitness_center_outlined;
      case 'checkroom':
        return Icons.checkroom_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
