part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboard;
  final bool isLoadingMore;
  DashboardLoaded(this.dashboard, {required this.isLoadingMore});
}

class DashboardError extends DashboardState {
  final String message;
  DashboardError(this.message);
}
