// widgets/splash_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'splash_logo.dart';
import 'splash_title.dart';
import 'splash_progress_bar.dart';
import 'splash_loading_text.dart';

class SplashContent extends StatelessWidget {
  final Animation<double> progressAnimation;

  const SplashContent({
    super.key,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SplashLogo(),
          SizedBox(height: 40.h),
          SplashTitle(),
          SizedBox(height: 80.h),
          SplashProgressBar(progressAnimation: progressAnimation),
          SizedBox(height: 20.h),
          SplashLoadingText(progressAnimation: progressAnimation),
        ],
      ),
    );
  }
}
