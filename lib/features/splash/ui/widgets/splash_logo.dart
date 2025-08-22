import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 120.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Image.asset(
          'assets/images/logo.png',
          width: 120.w,
          height: 120.h,
          fit: BoxFit.cover,
        ),
      ),
    )
        .animate()
        .scale(
          begin: Offset(0.5, 0.5),
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 600.ms)
        .then()
        .shimmer(
          color: Colors.white.withOpacity(0.4),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }
}
