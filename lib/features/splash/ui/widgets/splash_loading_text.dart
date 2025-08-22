import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SplashLoadingText extends StatelessWidget {
  final Animation<double> progressAnimation;

  const SplashLoadingText({
    super.key,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (context, child) {
        String loadingText = _getLoadingText();

        return Text(
          loadingText,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
        );
      },
    ).animate().fadeIn(delay: 1200.ms, duration: 400.ms);
  }

  String _getLoadingText() {
    if (progressAnimation.value > 0.9) {
      return 'Welcome!';
    } else if (progressAnimation.value > 0.7) {
      return 'Almost ready...';
    } else if (progressAnimation.value > 0.3) {
      return 'Loading data...';
    } else {
      return 'Initializing...';
    }
  }
}
