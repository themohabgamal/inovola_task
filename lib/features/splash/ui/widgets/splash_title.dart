import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashTitle extends StatelessWidget {
  const SplashTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Inovola',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32.sp,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 800.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),
        SizedBox(height: 12.h),
        Text(
          'Preparing your dashboard',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
            letterSpacing: 0.5,
          ),
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 600.ms)
            .slideY(begin: 0.2, curve: Curves.easeOut),
      ],
    );
  }
}
