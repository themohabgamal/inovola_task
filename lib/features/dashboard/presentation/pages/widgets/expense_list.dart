import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_list_item.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_tutorial_controller.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/pagination_controller.dart';

class ExpenseList extends StatefulWidget {
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final bool isLoadingMore;
  final int itemsPerPage;
  final ScrollController? scrollController;

  const ExpenseList({
    Key? key,
    required this.expenses,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.itemsPerPage = 10,
    this.scrollController,
  }) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList>
    with TickerProviderStateMixin {
  late PaginationController _paginationController;
  late ExpenseTutorialController _tutorialController;
  List<ExpenseEntity> _previousExpenses = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _previousExpenses = List.from(widget.expenses);
  }

  void _initializeControllers() {
    _paginationController = PaginationController(
      onLoadMore: _loadMoreExpenses,
      scrollController: widget.scrollController,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
    );

    _tutorialController = ExpenseTutorialController(
      onTutorialComplete: () {},
    );

    _tutorialController.initialize(this);
  }

  void _loadMoreExpenses() {
    context.read<DashboardBloc>().add(
          DashboardLoadMoreExpensesEvent(
            offset: widget.expenses.length,
            limit: widget.itemsPerPage,
          ),
        );
  }

  @override
  void didUpdateWidget(ExpenseList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrollController != oldWidget.scrollController) {
      _paginationController.updateScrollController(widget.scrollController);
    }

    // Create a new controller instance to update its properties
    _paginationController = PaginationController(
      onLoadMore: _loadMoreExpenses,
      scrollController: widget.scrollController,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
    );

    _handleExpenseUpdates();
  }

  void _handleExpenseUpdates() {
    // We remove _checkForNewlyAddedExpense() as it's no longer needed
    // and causes the unwanted scroll behavior.
    _tutorialController.showTutorialIfNeeded(
      hasExpenses: widget.expenses.isNotEmpty,
      wasEmpty: _previousExpenses.isEmpty,
    );
    _previousExpenses = List.from(widget.expenses);
  }

  @override
  void dispose() {
    _paginationController.dispose();
    _tutorialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(DashboardRefreshEvent());
      },
      child: _paginationController.buildPaginatedListWithColumn(
        itemCount: widget.expenses.length,
        itemBuilder: (context, index) => _buildExpenseListItem(index),
      ),
    );
  }

  Widget _buildExpenseListItem(int index) {
    final expense = widget.expenses[index];
    final isFirstItem = index == 0;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.paddingS,
        left: AppDimens.paddingL,
        right: AppDimens.paddingL,
      ),
      child: _tutorialController.wrapWithTutorial(
        isFirstItem: isFirstItem,
        child: ExpenseListItem(
          expense: expense,
          onDelete: (expense) => _handleExpenseDelete(expense),
        ),
      ),
    );
  }

  void _handleExpenseDelete(ExpenseEntity expense) {
    context.read<DashboardBloc>().add(DashboardDeleteExpenseEvent(expense));
    _showUndoSnackBar(expense);
  }

  void _showUndoSnackBar(ExpenseEntity expense) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            context
                .read<DashboardBloc>()
                .add(DashboardAddExpenseEvent(expense));
          },
        ),
      ),
    );
  }
}
