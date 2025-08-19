import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/core/routing/routes.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/dashboard_page.dart';
import '../../../core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Single loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    // Start loading animation
    _loadingController.forward();

    // Navigate to dashboard when animation completes
    _loadingController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        Navigator.of(context).pushReplacementNamed(Routes.dashboardScreen);
      }
    });
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _loadingController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.8),
                  AppColors.secondary ?? AppColors.primary.withOpacity(0.7),
                  AppColors.primary.withOpacity(0.9),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Subtle background pattern
                _buildBackgroundPattern(),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      _buildLogo(),

                      SizedBox(height: 40.h),

                      // App title
                      _buildAppTitle(),

                      SizedBox(height: 80.h),

                      // Progress bar
                      _buildProgressBar(),

                      SizedBox(height: 20.h),

                      // Loading text
                      _buildLoadingText(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: Opacity(
        opacity: 0.1,
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
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

  Widget _buildAppTitle() {
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

  Widget _buildProgressBar() {
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
            animation: _progressAnimation,
            builder: (context, child) {
              return Container(
                width: 200.w * _progressAnimation.value,
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

  Widget _buildLoadingText() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        String loadingText = 'Initializing...';
        if (_progressAnimation.value > 0.3) {
          loadingText = 'Loading data...';
        }
        if (_progressAnimation.value > 0.7) {
          loadingText = 'Almost ready...';
        }
        if (_progressAnimation.value > 0.9) {
          loadingText = 'Welcome!';
        }

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
}
