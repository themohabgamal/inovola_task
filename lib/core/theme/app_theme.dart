import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      fontFamily: 'Poppins',
      textTheme: TextTheme(
        displayLarge: AppTextStyles.font32Weight700White,
        displayMedium: AppTextStyles.font24Weight700Black,
        bodyLarge: AppTextStyles.font16Weight500Black,
        bodyMedium: AppTextStyles.font14Weight400Grey,
        bodySmall: AppTextStyles.font12Weight400Grey,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.white),
      ),
    );
  }
}
