part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class DashboardInitializeEvent extends DashboardEvent {}

class DashboardLoadEvent extends DashboardEvent {}

class DashboardAddExpenseEvent extends DashboardEvent {
  final ExpenseEntity expense;
  DashboardAddExpenseEvent(this.expense);
}

class DashboardUpdateInfoEvent extends DashboardEvent {
  final String? userName;
  final double? income;

  DashboardUpdateInfoEvent({this.userName, this.income});
}

class DashboardDeleteExpenseEvent extends DashboardEvent {
  final ExpenseEntity expense;
  DashboardDeleteExpenseEvent(this.expense);
}

class DashboardRefreshEvent extends DashboardEvent {}

class DashboardFilterChangedEvent extends DashboardEvent {
  final String filter;
  DashboardFilterChangedEvent(this.filter);
}

class _DashboardDataChangedEvent extends DashboardEvent {}
