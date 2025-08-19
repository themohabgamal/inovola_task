import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/core/shared/widgets/circle_rings_painter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expenses;

  const BalanceCard({
    Key? key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
      height: AppDimens.balanceCardHeight,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusL),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Padding(
              padding: EdgeInsets.all(AppDimens.paddingM).copyWith(
                  left: AppDimens.paddingL, right: AppDimens.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            AppStrings.totalBalance,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.white,
                                ),
                          ),
                          SizedBox(width: AppDimens.paddingXS),
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: AppColors.white,
                            size: AppDimens.iconS,
                          ),
                        ],
                      ),
                      Icon(
                        Icons.more_horiz,
                        color: AppColors.white,
                        size: AppDimens.iconM,
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimens.paddingS),
                  Text(
                    '\$ ${totalBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildIncomeExpenseItem(
                        context,
                        Icons.arrow_downward,
                        AppStrings.income,
                        income,
                      ),
                      _buildIncomeExpenseItem(
                        context,
                        Icons.arrow_upward,
                        AppStrings.expenses,
                        expenses,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: -60,
              left: 160,
              child: CustomPaint(
                size: Size(50, 50),
                painter: CircleRingsPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseItem(
    BuildContext context,
    IconData icon,
    String label,
    double amount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: AppDimens.paddingXS,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
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
