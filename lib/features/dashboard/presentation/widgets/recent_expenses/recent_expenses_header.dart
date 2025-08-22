import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';

class RecentExpensesHeader extends StatelessWidget {
  final VoidCallback onSeeAll;

  const RecentExpensesHeader({
    super.key,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimens.paddingL,
        AppDimens.paddingM,
        AppDimens.paddingL,
        AppDimens.paddingM,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.recentExpenses,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: Text(
              AppStrings.seeAll,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
