// app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/di/dependency_injection.dart';
import 'package:inovola_task/core/routing/page_transition.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/add_expense_page.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:inovola_task/features/splash/ui/splash_screen.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashScreen:
        return PageTransitions.modernSlideTransition(
          builder: (_) => SplashScreen(),
          settings: settings,
        );

      case Routes.dashboardScreen:
        return PageTransitions.modernSlideTransition(
          builder: (_) => BlocProvider(
            create: (context) =>
                getIt<DashboardBloc>()..add(DashboardLoadEvent()),
            child: DashboardPage(),
          ),
          settings: settings,
        );

      case Routes.addExpenseScreen:
        return PageTransitions.modernSlideTransition(
          builder: (_) => BlocProvider(
            create: (context) => getIt<AddExpenseBloc>(),
            child: const AddExpensePage(),
          ),
          settings: settings,
        );

      default:
        return PageTransitions.modernSlideTransition(
          builder: (_) => const Placeholder(),
          settings: settings,
        );
    }
  }
}
