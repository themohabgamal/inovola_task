import 'package:inovola_task/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl({required this.localDataSource});

  @override
  Future<DashboardEntity> getDashboardData() async {
    return await localDataSource.getDashboardData();
  }
}
