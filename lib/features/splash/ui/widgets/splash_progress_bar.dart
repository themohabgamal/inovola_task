import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashProgressBar extends StatelessWidget {
  final Animation<double> progressAnimation;

  const SplashProgressBar({
    super.key,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 4.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2.r),
        color: Colors.white.withOpacity(0.2),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: progressAnimation,
            builder: (context, child) {
              return Container(
                width: 200.w * progressAnimation.value,
                height: 4.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.8),
                      Colors.white,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 500.ms)
        .slideX(begin: -0.3, curve: Curves.easeOut);
  }
}
