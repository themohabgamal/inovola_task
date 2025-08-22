import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';

class BalanceAmountItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;

  const BalanceAmountItem({
    super.key,
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppDimens.paddingXS,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: AppColors.secondaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.white,
                size: AppDimens.iconS,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.white,
                  ),
            ),
          ],
        ),
        SizedBox(width: AppDimens.paddingS),
        Text(
          '\$ ${amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
