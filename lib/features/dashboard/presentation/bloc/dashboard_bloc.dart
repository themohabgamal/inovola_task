// dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/domain/services/dashboard_calculator_service.dart';
import 'package:inovola_task/features/dashboard/domain/services/expense_filter_service.dart';
import 'package:inovola_task/features/dashboard/domain/services/expense_pagination_service.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

/// Bloc for managing dashboard state and operations
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

    add(DashboardInitializeEvent());
  }

  /// Initializes Hive boxes and listeners
  Future<void> _onInitialize(
    DashboardInitializeEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      emit(DashboardLoading());

      // 👇 Ensure shimmer is shown for at least 800ms
      await Future.delayed(const Duration(milliseconds: 800));

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

      _expenseBox?.listenable().addListener(_onExpenseDataChanged);
      _dashboardBox?.listenable().addListener(_onDashboardDataChanged);

      add(DashboardLoadEvent());
    } catch (e) {
      emit(DashboardError('Failed to initialize dashboard: ${e.toString()}'));
    }
  }

  /// Loads more expenses for pagination
  Future<void> _onLoadMoreExpenses(
    DashboardLoadMoreExpensesEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null || _dashboardBox == null || !_hasMore) {
        return;
      }

      final currentState = state;
      if (currentState is DashboardLoaded) {
        emit(DashboardLoaded(currentState.dashboard, isLoadingMore: true));
      }

      final nextOffset = event.offset;
      final limit = event.limit;

      final nextPageResult = ExpensePaginationService.getExpensesPage(
        _allExpenses,
        nextOffset,
        limit,
      );

      _currentPageExpenses.addAll(nextPageResult.expenses);
      _hasMore = nextPageResult.hasMore;

      final userName = _dashboardBox!
          .get('userName', defaultValue: 'Shihab Rahman') as String;
      final income =
          _dashboardBox!.get('income', defaultValue: 10840.00) as double;

      final dashboard = DashboardCalculatorService.createDashboard(
        userName: userName,
        income: income,
        allExpenses: _allExpenses,
        recentExpenses: _currentPageExpenses,
        currentFilter: _currentFilter,
        hasMore: _hasMore,
      );

      emit(DashboardLoaded(dashboard, isLoadingMore: false));
    } catch (e) {
      emit(DashboardError('Failed to load more expenses: ${e.toString()}'));
    }
  }

  /// Loads dashboard data with expenses and pagination
  Future<void> _onLoadDashboard(
    DashboardLoadEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null || _dashboardBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      final allExpensesFromBox = _expenseBox!.values.toList();

      _allExpenses = ExpenseFilterService.filterExpenses(
          allExpensesFromBox, _currentFilter);

      _allExpenses.sort((a, b) => b.date.compareTo(a.date));

      final pageResult = ExpensePaginationService.getExpensesPage(
        _allExpenses,
        event.offset,
        event.limit,
      );

      _currentPageExpenses = pageResult.expenses;
      _hasMore = pageResult.hasMore;

      final userName = _dashboardBox!
          .get('userName', defaultValue: 'Shihab Rahman') as String;
      final income =
          _dashboardBox!.get('income', defaultValue: 10840.00) as double;

      final dashboard = DashboardCalculatorService.createDashboard(
        userName: userName,
        income: income,
        allExpenses: _allExpenses,
        recentExpenses: _currentPageExpenses,
        currentFilter: _currentFilter,
        hasMore: _hasMore,
      );

      emit(DashboardLoaded(dashboard, isLoadingMore: !event.loadMore));
    } catch (e) {
      emit(DashboardError('Failed to load dashboard data: ${e.toString()}'));
    }
  }

  /// Handles filter change and reload
  Future<void> _onFilterChanged(
    DashboardFilterChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    _currentFilter = event.filter;
    add(DashboardLoadEvent());
  }

  /// Adds a new expense
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
    } catch (e) {
      emit(DashboardError('Failed to add expense: ${e.toString()}'));
    }
  }

  /// Updates user info (name or income)
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
    } catch (e) {
      emit(DashboardError('Failed to update dashboard: ${e.toString()}'));
    }
  }

  /// Deletes an expense
  Future<void> _onDeleteExpense(
    DashboardDeleteExpenseEvent event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      if (_expenseBox == null) {
        add(DashboardInitializeEvent());
        return;
      }

      final key = _expenseBox!.keys.firstWhere(
        (k) => _expenseBox!.get(k) == event.expense,
        orElse: () => null,
      );

      if (key != null) {
        await _expenseBox!.delete(key);
      }
    } catch (e) {
      emit(DashboardError('Failed to delete expense: ${e.toString()}'));
    }
  }

  /// Refreshes dashboard
  Future<void> _onRefresh(
    DashboardRefreshEvent event,
    Emitter<DashboardState> emit,
  ) async {
    add(DashboardLoadEvent());
  }

  /// Handles Hive data change events
  Future<void> _onDataChanged(
    _DashboardDataChangedEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentItemCount = _currentPageExpenses.length;
    final limitToUse = currentItemCount > 10 ? currentItemCount : 10;

    add(DashboardLoadEvent(offset: 0, limit: limitToUse, loadMore: false));
  }

  /// Listener for expense box changes
  void _onExpenseDataChanged() {
    add(_DashboardDataChangedEvent());
  }

  /// Listener for dashboard box changes
  void _onDashboardDataChanged() {
    add(_DashboardDataChangedEvent());
  }

  /// Clean up listeners
  @override
  Future<void> close() {
    _expenseBox?.listenable().removeListener(_onExpenseDataChanged);
    _dashboardBox?.listenable().removeListener(_onDashboardDataChanged);
    return super.close();
  }
}
