import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/views/dashboard_error_view.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/views/dashboard_success_view.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/bottom_navigation.dart';
import '../bloc/dashboard_bloc.dart';
import 'views/dashboard_loading_view.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardLoadingView();
          } else if (state is DashboardError) {
            return DashboardErrorView(message: state.message);
          } else if (state is DashboardLoaded) {
            return DashboardSuccessView(dashboard: state.dashboard);
          }
          return Container();
        },
      ),
      bottomNavigationBar: BottomNavigation()
          .animate()
          .slideY(begin: 1, duration: 600.ms, curve: Curves.easeOutBack)
          .fadeIn(delay: 400.ms),
    );
  }
}
