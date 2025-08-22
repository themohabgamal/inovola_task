import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';

class DashboardErrorWidget extends StatelessWidget {
  final String message;
  const DashboardErrorWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
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
}
