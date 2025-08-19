part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardEntity dashboard;

  DashboardLoaded(this.dashboard);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardLoaded && other.dashboard == dashboard;
  }

  @override
  int get hashCode => dashboard.hashCode;
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardError && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
