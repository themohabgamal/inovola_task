import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/empty_state.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_list.dart';

class RecentExpensesSection extends StatelessWidget {
  final List<ExpenseEntity> expenses;

  const RecentExpensesSection({Key? key, required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
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
                onTap: () {
                  // Navigator.pushNamed(context, '/all-expenses');
                },
                child: Text(
                  AppStrings.seeAll,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: expenses.isEmpty
              ? EmptyState(onAddPressed: () {
                  Navigator.pushNamed(context, Routes.addExpenseScreen);
                })
              : ExpenseList(expenses: expenses),
        ),
      ],
    );
  }
}
