import 'dart:ui';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  static const String _expensesBoxName = 'expenses_box';
  static const String _dashboardBoxName = 'dashboard_box';

  Box<ExpenseEntity>? _expenseBox;
  Box? _dashboardBox;
  String _currentFilter = 'This Month';
  List<ExpenseEntity> _allExpenses = [];
  List<ExpenseEntity> _currentPageExpenses = [];
  bool _hasMore = true;

  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardInitializeEvent>(_onInitialize);
    on<DashboardLoadEvent>(_onLoadDashboard);
    on<DashboardLoadMoreExpensesEvent>(_onLoadMoreExpenses);
    on<DashboardAddExpenseEvent>(_onAddExpense);
    on<DashboardUpdateInfoEvent>(_onUpdateInfo);
    on<DashboardDeleteExpenseEvent>(_onDeleteExpense);
    on<DashboardRefreshEvent>(_onRefresh);
    on<DashboardFilterChangedEvent>(_onFilterChanged);
    on<_DashboardDataChangedEvent>(_onDataChanged);

    // Initialize automatically
    add(DashboardInitializeEvent());
  }

  Future<void> _onInitialize(
    DashboardInitializeEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());

      // Open boxes if not already open
      if (!Hive.isBoxOpen(_expensesBoxName)) {
        _expenseBox = await Hive.openBox<ExpenseEntity>(_expensesBoxName);
      } else {
        _expenseBox = Hive.box<ExpenseEntity>(_expensesBoxName);
      }

      if (!Hive.isBoxOpen(_dashboardBoxName)) {
        _dashboardBox = await Hive.openBox(_dashboardBoxName);
      } else {
        _dashboardBox = Hive.box(_dashboardBoxName);
      }

      // Listen to box changes
      _expenseBox?.listenable().addListener(_onExpenseDataChanged);
      _dashboardBox?.listenable().addListener(_onDashboardDataChanged);

      // Load initial data
      add(DashboardLoadEvent());
    } catch (e) {
      emit(DashboardError('Failed to initialize dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMoreExpenses(
    DashboardLoadMoreExpensesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null || _dashboardBox == null || !_hasMore) {
        return;
      }

      // Get current state to maintain it during loading
      final currentState = state;
      if (currentState is DashboardLoaded) {
        // Emit loading state first (optional - for showing loading indicator)
        emit(DashboardLoaded(currentState.dashboard, isLoadingMore: true));
      }

      // Calculate next page
      final nextOffset = event.offset;
      final limit = event.limit;
      if (nextOffset >= _allExpenses.length) {
        _hasMore = false;
        return; // nothing more to load
      }

      final nextEndIndex = nextOffset + limit;
      final nextPageExpenses = _allExpenses.sublist(
        nextOffset,
        nextEndIndex > _allExpenses.length ? _allExpenses.length : nextEndIndex,
      );
      _currentPageExpenses.addAll(nextPageExpenses);
      _hasMore = nextEndIndex < _allExpenses.length;

      final userName = _dashboardBox!
          .get('userName', defaultValue: 'Shihab Rahman') as String;
      final income =
          _dashboardBox!.get('income', defaultValue: 10840.00) as double;

      final totalExpenses = _allExpenses.fold<double>(
          0.0, (sum, expense) => sum + expense.amount);
      final totalBalance = income - totalExpenses;

      final dashboard = DashboardEntity(
        userName: userName,
        totalBalance: totalBalance,
        income: income,
        expenses: totalExpenses,
        recentExpenses: _currentPageExpenses, // Combined list with new items
        currentFilter: _currentFilter,
        hasMore: _hasMore,
      );

      // Emit final state with isLoadingMore: false to show the new items
      emit(DashboardLoaded(dashboard, isLoadingMore: false));
    } catch (e) {
      emit(DashboardError('Failed to load more expenses: ${e.toString()}'));
    }
  }

  Future<void> _onLoadDashboard(
    DashboardLoadEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null || _dashboardBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      // 1. Get ALL expenses from the box
      final allExpensesFromBox = _expenseBox!.values.toList();

      // 2. Filter ALL expenses
      final filteredExpenses =
          _filterExpenses(allExpensesFromBox, _currentFilter);

      // 3. Sort the filtered expenses by date
      filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

      // 4. Store the sorted, filtered list to be used for all pagination
      _allExpenses = filteredExpenses;

      // 5. Calculate the current page
      final limit = event.limit;
      final offset = event.offset;

      _currentPageExpenses = _allExpenses.sublist(
        offset,
        offset + limit > _allExpenses.length
            ? _allExpenses.length
            : offset + limit,
      );

      _hasMore = _currentPageExpenses.length < _allExpenses.length;

      // Get dashboard data
      final userName = _dashboardBox!
          .get('userName', defaultValue: 'Shihab Rahman') as String;
      final income =
          _dashboardBox!.get('income', defaultValue: 10840.00) as double;

      final totalExpenses = _allExpenses.fold<double>(
          0.0, (sum, expense) => sum + expense.amount);
      final totalBalance = income - totalExpenses;

      final dashboard = DashboardEntity(
        userName: userName,
        totalBalance: totalBalance,
        income: income,
        expenses: totalExpenses,
        recentExpenses: _currentPageExpenses,
        currentFilter: _currentFilter,
        hasMore: _hasMore,
      );

      emit(DashboardLoaded(dashboard, isLoadingMore: !event.loadMore));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  Future<void> _onFilterChanged(
    DashboardFilterChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    _currentFilter = event.filter;
    add(DashboardLoadEvent());
  }

  List<ExpenseEntity> _filterExpenses(
      List<ExpenseEntity> expenses, String filter) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (filter) {
      case 'This Month':
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfMonth.subtract(Duration(days: 1))))
            .toList();

      case 'Last Month':
        final firstDayOfLastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDayOfLastMonth = DateTime(now.year, now.month, 0);
        return expenses
            .where((expense) =>
                expense.date
                    .isAfter(firstDayOfLastMonth.subtract(Duration(days: 1))) &&
                expense.date
                    .isBefore(lastDayOfLastMonth.add(Duration(days: 1))))
            .toList();

      case 'Last 7 Days':
        final sevenDaysAgo = today.subtract(Duration(days: 7));
        return expenses
            .where((expense) =>
                expense.date.isAfter(sevenDaysAgo.subtract(Duration(days: 1))))
            .toList();

      case 'This Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final firstMonthOfQuarter = (currentQuarter - 1) * 3 + 1;
        final firstDayOfQuarter = DateTime(now.year, firstMonthOfQuarter, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfQuarter.subtract(Duration(days: 1))))
            .toList();

      case 'Last Quarter':
        final currentQuarter = ((now.month - 1) ~/ 3) + 1;
        final lastQuarter = currentQuarter > 1 ? currentQuarter - 1 : 4;
        final year = currentQuarter > 1 ? now.year : now.year - 1;
        final firstMonthOfLastQuarter = (lastQuarter - 1) * 3 + 1;
        final lastMonthOfLastQuarter = lastQuarter * 3;
        final firstDayOfLastQuarter =
            DateTime(year, firstMonthOfLastQuarter, 1);
        final lastDayOfLastQuarter =
            DateTime(year, lastMonthOfLastQuarter + 1, 0);
        return expenses
            .where((expense) =>
                expense.date.isAfter(
                    firstDayOfLastQuarter.subtract(Duration(days: 1))) &&
                expense.date
                    .isBefore(lastDayOfLastQuarter.add(Duration(days: 1))))
            .toList();

      case 'This Year':
        final firstDayOfYear = DateTime(now.year, 1, 1);
        return expenses
            .where((expense) => expense.date
                .isAfter(firstDayOfYear.subtract(Duration(days: 1))))
            .toList();

      case 'Last Year':
        final firstDayOfLastYear = DateTime(now.year - 1, 1, 1);
        final lastDayOfLastYear = DateTime(now.year - 1, 12, 31);
        return expenses
            .where((expense) =>
                expense.date
                    .isAfter(firstDayOfLastYear.subtract(Duration(days: 1))) &&
                expense.date.isBefore(lastDayOfLastYear.add(Duration(days: 1))))
            .toList();

      default:
        return expenses;
    }
  }

  Future<void> _onAddExpense(
    DashboardAddExpenseEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      await _expenseBox!.add(event.expense);
      // Dashboard will automatically reload due to listener
    } catch (e) {
      emit(DashboardError('Failed to add expense: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateInfo(
    DashboardUpdateInfoEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_dashboardBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      if (event.userName != null) {
        await _dashboardBox!.put('userName', event.userName);
      }
      if (event.income != null) {
        await _dashboardBox!.put('income', event.income);
      }
      // Dashboard will automatically reload due to listener
    } catch (e) {
      emit(DashboardError('Failed to update dashboard: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteExpense(
    DashboardDeleteExpenseEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      // Find the Hive key of the expense
      final key = _expenseBox!.keys.firstWhere(
        (k) => _expenseBox!.get(k) == event.expense,
        orElse: () => null,
      );

      if (key != null) {
        await _expenseBox!.delete(key);
      }

      // No need to manually emit, listener will trigger DashboardLoadEvent
    } catch (e) {
      emit(DashboardError('Failed to delete expense: ${e.toString()}'));
    }
  }

  Future<void> _onRefresh(
    DashboardRefreshEvent event,
    Emitter<DashboardState> emit,
  ) async {
    add(DashboardLoadEvent());
  }

  Future<void> _onDataChanged(
    _DashboardDataChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    // Maintain current pagination state when data changes
    final currentItemCount = _currentPageExpenses.length;

    // If we have more items loaded than the default, maintain that state
    final limitToUse = currentItemCount > 10 ? currentItemCount : 10;

    add(DashboardLoadEvent(offset: 0, limit: limitToUse, loadMore: false));
  }

  void _onExpenseDataChanged() {
    // Reload dashboard when expenses change
    add(_DashboardDataChangedEvent());
  }

  void _onDashboardDataChanged() {
    // Reload dashboard when dashboard settings change
    add(_DashboardDataChangedEvent());
  }

  @override
  Future<void> close() {
    // Remove listeners before closing
    _expenseBox?.listenable().removeListener(_onExpenseDataChanged);
    _dashboardBox?.listenable().removeListener(_onDashboardDataChanged);
    return super.close();
  }
}
