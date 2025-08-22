import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/expense_list_item.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/expense_tutorial_controller.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/pagination_controller.dart';

class ExpenseListController {
  final BuildContext context;
  final TickerProvider vsync;
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final bool isLoadingMore;
  final int itemsPerPage;
  final ScrollController? scrollController;

  static const String _tutorialShownKey = 'expense_tutorial_shown';
  late final PaginationController _paginationController;
  late final ExpenseTutorialController _tutorialController;

  ExpenseListController({
    required this.context,
    required this.vsync,
    required this.expenses,
    required this.hasMore,
    required this.isLoadingMore,
    required this.itemsPerPage,
    this.scrollController,
  });

  void initialize() {
    _paginationController = PaginationController(
      onLoadMore: _loadMoreExpenses,
      scrollController: scrollController,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore,
    );

    _tutorialController = ExpenseTutorialController(
      onTutorialComplete: () {},
    )..initialize(vsync);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialOnce();
    });
  }

  void updateWidget(covariant dynamic newWidget, covariant dynamic oldWidget) {
    if (newWidget.scrollController != oldWidget.scrollController) {
      _paginationController.updateScrollController(newWidget.scrollController);
    }
  }

  void dispose() {
    _paginationController.dispose();
    _tutorialController.dispose();
  }

  Widget buildList() {
    return _paginationController.buildPaginatedListWithColumn(
      itemCount: expenses.length,
      itemBuilder: (context, index) => _buildExpenseListItem(index),
    );
  }

  Widget _buildExpenseListItem(int index) {
    final expense = expenses[index];
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

  void _loadMoreExpenses() {
    context.read<DashboardBloc>().add(
          DashboardLoadMoreExpensesEvent(
            offset: expenses.length,
            limit: itemsPerPage,
          ),
        );
  }

  Future<void> _showTutorialOnce() async {
    if (expenses.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final hasShownTutorial = prefs.getBool(_tutorialShownKey) ?? false;

    if (!hasShownTutorial) {
      _tutorialController.showTutorialIfNeeded(
        hasExpenses: true,
        wasEmpty: false,
      );
      await prefs.setBool(_tutorialShownKey, true);
    }
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
            context.read<DashboardBloc>().add(
                  DashboardAddExpenseEvent(expense),
                );
          },
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
