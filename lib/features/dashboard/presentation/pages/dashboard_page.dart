import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/dashboard_error_widget.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/dashboard_success_widget.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/bottom_navigation.dart';
import '../bloc/dashboard_bloc.dart';
import '../widgets/dashboard_loading_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const DashboardLoadingWidget();
          } else if (state is DashboardError) {
            return DashboardErrorWidget(message: state.message);
          } else if (state is DashboardLoaded) {
            return DashboardSuccessWidget(dashboard: state.dashboard);
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
