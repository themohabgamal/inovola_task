import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/recent_expenses_section.dart';

class DashboardContent extends StatelessWidget {
  final DashboardEntity dashboard;
  const DashboardContent({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: AppColors.backgroundColor,
        padding: EdgeInsets.only(top: 40.h),
        child: RecentExpensesSection(
          expenses: dashboard.recentExpenses,
        )
            .animate()
            .slideY(begin: 0.3, duration: 800.ms, curve: Curves.easeOutCubic)
            .fadeIn(delay: 500.ms, duration: 600.ms),
      ),
    );
  }
}
