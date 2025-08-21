import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/empty_state.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_list.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';

class RecentExpensesSection extends StatefulWidget {
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final bool isLoadingMore;

  const RecentExpensesSection({
    Key? key,
    required this.expenses,
    this.hasMore = false,
    this.isLoadingMore = false,
  }) : super(key: key);

  @override
  State<RecentExpensesSection> createState() => _RecentExpensesSectionState();
}

class _RecentExpensesSectionState extends State<RecentExpensesSection> {
  late ScrollController _scrollController;
  bool _isRequestingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if we're near the bottom (200px from bottom)
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more if available and not already loading
      if (widget.hasMore && !widget.isLoadingMore && !_isRequestingMore) {
        print(
            'Loading more expenses... Current count: ${widget.expenses.length}');

        setState(() {
          _isRequestingMore = true;
        });

        context.read<DashboardBloc>().add(
              DashboardLoadMoreExpensesEvent(
                offset: widget.expenses.length,
                limit: 10,
              ),
            );
      }
    }
  }

  @override
  void didUpdateWidget(RecentExpensesSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset requesting flag when loading completes
    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _isRequestingMore = false;
    }
  }

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
          child: widget.expenses.isEmpty
              ? EmptyState(onAddPressed: () {
                  Navigator.pushNamed(context, Routes.addExpenseScreen);
                })
              : ExpenseList(
                  expenses: widget.expenses,
                  hasMore: widget.hasMore,
                  isLoadingMore: widget.isLoadingMore,
                  scrollController: _scrollController, // Pass the controller
                ),
        ),
      ],
    );
  }
}
