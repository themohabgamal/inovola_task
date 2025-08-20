import 'package:get_it/get_it.dart';
import 'package:inovola_task/core/services/image_picking_service.dart';
import 'package:inovola_task/features/add_expense/data/repositories/hive_expense_repository.dart';
import 'package:inovola_task/features/add_expense/domain/usecases/add_expense_usecase.dart';
import 'package:inovola_task/features/add_expense/domain/usecases/get_categories_usecase.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:inovola_task/features/dashboard/domain/repositories/dashboard_repository_impl.dart';
import 'package:inovola_task/features/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // Data sources
  getIt.registerLazySingleton<DashboardLocalDataSource>(
    () => DashboardLocalDataSource(),
  );

  // Repository
  getIt.registerLazySingleton<DashboardRepositoryImpl>(
    () => DashboardRepositoryImpl(
      localDataSource: getIt(),
    ),
  );

  // Usecases
  getIt.registerLazySingleton<GetDashboardData>(
    () => GetDashboardData(repository: getIt()),
  );

  // Cubits
  getIt.registerFactory<DashboardBloc>(
    () => DashboardBloc(),
  );
  getIt.registerFactory<AddExpenseBloc>(
    () => AddExpenseBloc(
        imagePickerService: ImagePickerService(),
        addExpenseUseCase: AddExpenseUseCase(HiveExpenseRepository()),
        getCategoriesUseCase: GetCategoriesUseCase(HiveExpenseRepository())),
  );
}
