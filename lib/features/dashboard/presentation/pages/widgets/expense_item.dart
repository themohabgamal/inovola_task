import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseEntity expense;

  const ExpenseItem({Key? key, required this.expense}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.expenseItemHeight,
      padding: EdgeInsets.all(AppDimens.paddingS),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
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
              color: expense.backgroundColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
            ),
            child: Icon(
              _getIconData(expense.iconName ?? ''),
              color: expense.backgroundColor,
              size: AppDimens.iconM,
            ),
          ),
          SizedBox(width: AppDimens.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  expense.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, color: AppColors.black),
                ),
                SizedBox(height: 2.h),
                Text(
                  expense.category,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '-\$${expense.amount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
              ),
              SizedBox(height: 2.h),
              Text(
                expense.time ?? '',
                style: Theme.of(context).textTheme.bodySmall,
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
