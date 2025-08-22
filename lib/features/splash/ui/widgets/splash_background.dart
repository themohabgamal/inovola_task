import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _buildBackgroundDecoration(),
        child: _buildBackgroundPattern(),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primary,
          AppColors.primary.withOpacity(0.8),
          AppColors.secondary,
          AppColors.primary.withOpacity(0.9),
        ],
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Opacity(
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
    );
  }
}
