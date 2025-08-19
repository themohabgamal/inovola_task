import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/core/shared/widgets/circle_rings_painter.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/balance_card.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/bottom_navigation.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/header_section.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/recent_expenses_section.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimens.dart';
import '../cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return _buildLoadingState();
          } else if (state is DashboardError) {
            return _buildErrorState(state.message);
          } else if (state is DashboardLoaded) {
            return _buildDashboard(context, state.dashboard);
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

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.primary,
          )
              .animate(onPlay: (controller) => controller.repeat())
              .rotate(duration: 1200.ms)
              .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0))
              .fadeIn(duration: 400.ms),
          SizedBox(height: 16.h),
          Text(
            'Loading your dashboard...',
            style: TextStyle(
              color: AppColors.secondaryLight,
              fontSize: 14.sp,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.3, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48.sp,
          )
              .animate()
              .scale(delay: 100.ms, duration: 500.ms, curve: Curves.elasticOut)
              .shake(delay: 600.ms, duration: 800.ms),
          SizedBox(height: 16.h),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.secondaryLight,
              fontSize: 16.sp,
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.2, curve: Curves.easeOut),
        ],
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, DashboardEntity dashboard) {
    return Stack(
      children: [
        Column(
          children: [
            // Blue gradient container with header
            _buildHeaderContainer(context, dashboard),
            // White container with recent expenses
            _buildContentContainer(dashboard),
          ],
        ),
        // Positioned balance card
        _buildBalanceCard(context, dashboard),
      ],
    ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut);
  }

  Widget _buildHeaderContainer(
      BuildContext context, DashboardEntity dashboard) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppDimens.radiusS),
              bottomRight: Radius.circular(AppDimens.radiusS),
            ),
            color: AppColors.primary,
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: AppDimens.paddingL + 40,
          ),
          child: Column(
            children: [
              HeaderSection(userName: dashboard.userName)
                  .animate()
                  .slideY(
                      begin: -0.5, duration: 600.ms, curve: Curves.easeOutBack)
                  .fadeIn(delay: 100.ms, duration: 500.ms),
              SizedBox(height: 106.h),
            ],
          ),
        )
            .animate()
            .slideY(begin: -0.3, duration: 700.ms, curve: Curves.easeOut)
            .fadeIn(duration: 500.ms),

        // Animated circle rings
        Positioned(
          top: -266,
          right: -30,
          child: CustomPaint(
            size: Size(500, 500),
            painter: CircleRingsPainter(),
          ).animate().fadeIn(delay: 200.ms, duration: 800.ms),
        ),
      ],
    );
  }

  Widget _buildContentContainer(DashboardEntity dashboard) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(top: 60.h),
        child: RecentExpensesSection(
          expenses: dashboard.recentExpenses,
        )
            .animate()
            .slideY(begin: 0.3, duration: 800.ms, curve: Curves.easeOutCubic)
            .fadeIn(delay: 500.ms, duration: 600.ms),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, DashboardEntity dashboard) {
    return Positioned(
      top: MediaQuery.of(context).padding.top +
          80 + // HeaderSection approximate height
          AppDimens.paddingL +
          AppDimens.paddingL -
          40,
      left: 0,
      right: 0,
      child: BalanceCard(
        totalBalance: dashboard.totalBalance,
        income: dashboard.income,
        expenses: dashboard.expenses,
      )
          .animate()
          .scale(
            begin: Offset(0.8, 0.8),
            duration: 700.ms,
            curve: Curves.elasticOut,
            delay: 300.ms,
          )
          .fadeIn(delay: 300.ms, duration: 500.ms)
          .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOutBack)
          .shimmer(
              color: Colors.white, duration: 2000.ms, curve: Curves.easeOut),
    );
  }
}

// Extension for additional animation utilities
extension DashboardAnimations on Widget {
  Widget get staggeredFadeIn => animate()
      .fadeIn(duration: 400.ms, curve: Curves.easeOut)
      .slideY(begin: 0.1, curve: Curves.easeOut);

  Widget get bouncyScale => animate().scale(
        begin: Offset(0.0, 0.0),
        duration: 600.ms,
        curve: Curves.elasticOut,
      );

  Widget get smoothSlide => animate()
      .slideX(begin: -0.1, duration: 500.ms, curve: Curves.easeOutCubic)
      .fadeIn(duration: 400.ms);
}
