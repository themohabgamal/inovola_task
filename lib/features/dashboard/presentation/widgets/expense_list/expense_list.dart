import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/expense_list/expense_list_controller.dart';

class ExpenseList extends StatefulWidget {
  final List<ExpenseEntity> expenses;
  final bool hasMore;
  final bool isLoadingMore;
  final int itemsPerPage;
  final ScrollController? scrollController;

  const ExpenseList({
    super.key,
    required this.expenses,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.itemsPerPage = 10,
    this.scrollController,
  });

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList>
    with TickerProviderStateMixin {
  late final ExpenseListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ExpenseListController(
      context: context,
      vsync: this,
      expenses: widget.expenses,
      hasMore: widget.hasMore,
      isLoadingMore: widget.isLoadingMore,
      itemsPerPage: widget.itemsPerPage,
      scrollController: widget.scrollController,
    )..initialize();
  }

  @override
  void didUpdateWidget(covariant ExpenseList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.updateWidget(widget, oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DashboardBloc>().add(DashboardRefreshEvent());
      },
      child: _controller.buildList(),
    );
  }
}
