import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/shared/widgets/circle_rings_painter.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/header_section.dart';

class DashboardHeader extends StatelessWidget {
  final DashboardEntity dashboard;
  const DashboardHeader({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
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
              HeaderSection(
                userName: dashboard.userName,
                selectedPeriod: dashboard.currentFilter,
              )
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
}
