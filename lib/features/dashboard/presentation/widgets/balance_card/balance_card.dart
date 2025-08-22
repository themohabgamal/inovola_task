import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/balance_card/balance_amount_item.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/balance_card/balance_background_painter.dart';

class BalanceCard extends StatelessWidget {
  final double totalBalance;
  final double income;
  final double expenses;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
  });

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
                left: AppDimens.paddingL,
                right: AppDimens.paddingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header Row
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

                  /// Balance
                  Text(
                    '\$ ${totalBalance.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const Spacer(),

                  /// Income & Expenses
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BalanceAmountItem(
                        icon: Icons.arrow_downward,
                        label: AppStrings.income,
                        amount: income,
                      ),
                      BalanceAmountItem(
                        icon: Icons.arrow_upward,
                        label: AppStrings.expenses,
                        amount: expenses,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Background Painter
            const Positioned(
              bottom: -60,
              left: 160,
              child: BalanceBackgroundPainter(),
            ),
          ],
        ),
      ),
    );
  }
}
