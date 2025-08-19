import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/usecases/get_dashboard_data.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardData getDashboardData;

  DashboardCubit({required this.getDashboardData}) : super(DashboardInitial());

  Future<void> loadDashboardData() async {
    try {
      emit(DashboardLoading());
      final dashboard = await getDashboardData();
      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
