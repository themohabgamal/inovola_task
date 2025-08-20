import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:inovola_task/core/di/dependency_injection.dart';
import 'package:inovola_task/core/routing/app_router.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/core/services/hive_service.dart';
import 'package:inovola_task/core/theme/app_theme.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await HiveService.initHive();
  // Dependency Injection
  await initDependencies();
  final expensesBox = Hive.box<ExpenseEntity>('expenses_box');
  final dashboardBox = Hive.box('dashboard_box');

// clear all data
  await expensesBox.clear();
  await dashboardBox.clear();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: AppTheme.lightTheme,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: Routes.splashScreen,
        );
      },
    );
  }
}
