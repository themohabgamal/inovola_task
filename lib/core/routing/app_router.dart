import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/core/services/image_picking_service.dart';
import 'package:inovola_task/features/add_expense/data/repositories/hive_expense_repository.dart';
import 'package:inovola_task/features/add_expense/domain/usecases/add_expense_usecase.dart';
import 'package:inovola_task/features/add_expense/domain/usecases/get_categories_usecase.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/add_expense_page.dart';
import 'package:inovola_task/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:inovola_task/features/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return _buildModernSlideTransitionRoute(
          builder: (_) => SplashScreen(),
          settings: settings,
        );

      case Routes.dashboardScreen:
        return _buildModernSlideTransitionRoute(
          builder: (_) => BlocProvider(
            create: (context) => DashboardCubit()..loadDashboardData(),
            child: DashboardPage(),
          ),
          settings: settings,
        );
      case Routes.addExpenseScreen:
        return _buildModernSlideTransitionRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddExpenseBloc(
                imagePickerService: ImagePickerService(),
                getCategoriesUseCase:
                    GetCategoriesUseCase(HiveExpenseRepository()),
                addExpenseUseCase: AddExpenseUseCase(HiveExpenseRepository())),
            child: const AddExpensePage(),
          ),
          settings: settings,
        );
      default:
        return _buildModernSlideTransitionRoute(
          builder: (_) => const Placeholder(),
          settings: settings,
        );
    }
  }

  static Route _buildModernSlideTransitionRoute({
    required WidgetBuilder builder,
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 550),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.fastEaseInToSlowEaseOut;
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.05),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.2, 1.0, curve: Curves.easeOutExpo),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
