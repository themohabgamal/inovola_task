import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_item.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/delete_confirmation_dialog.dart';

class ExpenseList extends StatefulWidget {
  final List<ExpenseEntity> expenses;

  const ExpenseList({Key? key, required this.expenses}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList>
    with TickerProviderStateMixin {
  late AnimationController _tutorialController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundOpacityAnimation;
  late ScrollController _scrollController;
  bool _hasShownTutorial = false;
  List<ExpenseEntity> _previousExpenses = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _previousExpenses = List.from(widget.expenses);
    _initializeTutorialAnimation();
  }

  void _initializeTutorialAnimation() {
    _tutorialController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _tutorialController,
      curve: Curves.easeInOut,
    ));

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tutorialController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(ExpenseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkForNewlyAddedExpense();
    _showTutorialIfNeeded();
  }

  void _checkForNewlyAddedExpense() {
    if (widget.expenses.length > _previousExpenses.length) {
      // Find the newly added expense by comparing with previous list
      final newExpenses = widget.expenses
          .where((expense) => !_previousExpenses
              .any((prev) => prev.hashCode == expense.hashCode))
          .toList();

      if (newExpenses.isNotEmpty) {
        // Always scroll to newly added items
        for (final newExpense in newExpenses) {
          _scrollToExpense(newExpense);
        }
      }
    }
    _previousExpenses = List.from(widget.expenses);
  }

  void _scrollToExpense(ExpenseEntity targetExpense) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetIndex = widget.expenses.indexWhere(
        (expense) => expense.hashCode == targetExpense.hashCode,
      );

      if (targetIndex != -1 && _scrollController.hasClients) {
        final itemHeight = 68.h + AppDimens.paddingS; // Item height + padding
        final targetOffset = targetIndex * itemHeight;

        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _showTutorialIfNeeded() {
    // Show tutorial for the first item when list is not empty
    // Reset tutorial state when expenses list changes significantly
    if (widget.expenses.isNotEmpty && mounted) {
      // Only show tutorial if it hasn't been shown for this session OR if list was previously empty
      if (!_hasShownTutorial || _previousExpenses.isEmpty) {
        _hasShownTutorial = true;

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _tutorialController.forward().then((_) {
              Future.delayed(const Duration(milliseconds: 500), () {
                if (mounted) {
                  _tutorialController.reverse();
                }
              });
            });
          }
        });
      }
    } else if (widget.expenses.isEmpty) {
      // Reset tutorial state when list becomes empty
      _hasShownTutorial = false;
    }
  }

  @override
  void dispose() {
    _tutorialController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTutorialIfNeeded();
    });

    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(DashboardRefreshEvent());
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        itemCount: widget.expenses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: AppDimens.paddingS),
            child: _buildDismissibleExpenseItem(context, index),
          );
        },
      ),
    );
  }

  Widget _buildDismissibleExpenseItem(BuildContext context, int index) {
    final expense = widget.expenses[index];
    final isFirstItem = index == 0;

    Widget dismissibleItem = Dismissible(
      key: Key('expense_${expense.hashCode}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => showDeleteConfirmation(context),
      onDismissed: (direction) => _handleExpenseDismiss(context, expense),
      background: _buildDismissBackground(),
      child: _buildRoundedExpenseItem(expense),
    );

    // Apply tutorial animation only to the first item
    if (isFirstItem) {
      return Stack(
        children: [
          // Animated delete background for tutorial
          AnimatedBuilder(
            animation: _backgroundOpacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _backgroundOpacityAnimation.value,
                child: _buildDismissBackground(),
              );
            },
          ),
          // Sliding expense item
          SlideTransition(
            position: _slideAnimation,
            child: dismissibleItem,
          ),
        ],
      );
    }

    return dismissibleItem;
  }

  Widget _buildRoundedExpenseItem(ExpenseEntity expense) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: ExpenseItem(expense: expense),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      height: 68.h,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void _handleExpenseDismiss(BuildContext context, ExpenseEntity expense) {
    context.read<DashboardBloc>().add(DashboardDeleteExpenseEvent(expense));

    _showUndoSnackBar(context, expense);
  }

  void _showUndoSnackBar(BuildContext context, ExpenseEntity expense) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Expense deleted'),
        backgroundColor: AppColors.primary,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
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
