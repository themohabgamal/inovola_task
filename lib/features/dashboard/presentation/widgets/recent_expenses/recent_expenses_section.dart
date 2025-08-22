import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/empty_state.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/expense_list/expense_list.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/recent_expenses/recent_expenses_header.dart';

class RecentExpensesSection extends StatefulWidget {
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final bool isLoadingMore;

  const RecentExpensesSection({
    super.key,
    required this.expenses,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (widget.hasMore && !widget.isLoadingMore && !_isRequestingMore) {
        setState(() => _isRequestingMore = true);

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

    if (oldWidget.isLoadingMore && !widget.isLoadingMore) {
      _isRequestingMore = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RecentExpensesHeader(
          onSeeAll: () {
            Navigator.pushNamed(context, Routes.addExpenseScreen);
          },
        ),
        Expanded(
          child: widget.expenses.isEmpty
              ? EmptyState(
                  onAddPressed: () {
                    Navigator.pushNamed(context, Routes.addExpenseScreen);
                  },
                )
              : ExpenseList(
                  expenses: widget.expenses,
                  hasMore: widget.hasMore,
                  isLoadingMore: widget.isLoadingMore,
                  scrollController: _scrollController,
                ),
        ),
      ],
    );
  }
}
