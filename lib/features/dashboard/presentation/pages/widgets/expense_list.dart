import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
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

  // SharedPreferences key for tutorial state
  static const String _tutorialShownKey = 'expense_tutorial_shown';

  @override
  void initState() {
    super.initState();
    _initializeControllers();

    // Schedule tutorial check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialOnce();
    });
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

  Future<void> _showTutorialOnce() async {
    // Don't show tutorial if there are no expenses
    if (widget.expenses.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final hasShownTutorial = prefs.getBool(_tutorialShownKey) ?? false;

      if (!hasShownTutorial) {
        _tutorialController.showTutorialIfNeeded(
          hasExpenses: true,
          wasEmpty: false,
        );

        // Mark tutorial as shown
        await prefs.setBool(_tutorialShownKey, true);
      }
    } catch (e) {
      // Handle SharedPreferences error gracefully
      debugPrint('Error accessing SharedPreferences: $e');
      // Optionally show tutorial anyway if SharedPreferences fails
      // _tutorialController.showTutorialIfNeeded(hasExpenses: true, wasEmpty: false);
    }
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

    // Update scroll controller if changed
    if (widget.scrollController != oldWidget.scrollController) {
      _paginationController.updateScrollController(widget.scrollController);
    }

    // Update pagination controller with new properties
    _paginationController = PaginationController(
      onLoadMore: _loadMoreExpenses,
      scrollController: widget.scrollController,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
    );

    // Show tutorial only when expenses list changes from empty to having items
    if (oldWidget.expenses.isEmpty && widget.expenses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorialOnce();
      });
    }
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
        backgroundColor: AppColors.primary,
        content: const Text(
          'Expense deleted',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            context
                .read<DashboardBloc>()
                .add(DashboardAddExpenseEvent(expense));
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
