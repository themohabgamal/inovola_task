import '../entities/dashboard_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData {
  final DashboardRepository repository;

  GetDashboardData({required this.repository});

  Future<DashboardEntity> call() async {
    return await repository.getDashboardData();
  }
}
