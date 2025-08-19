import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:inovola_task/features/dashboard/domain/repositories/dashboard_repository_impl.dart';
import 'package:inovola_task/features/dashboard/domain/usecases/get_dashboard_data.dart';
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
            create: (context) => DashboardCubit(
              getDashboardData: GetDashboardData(
                repository: DashboardRepositoryImpl(
                  localDataSource: DashboardLocalDataSource(),
                ),
              ),
            )..loadDashboardData(),
            child: DashboardPage(),
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
