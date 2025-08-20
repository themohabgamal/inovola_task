import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Font family constant
  static const String _fontFamily = 'Poppins';

  // Base colors
  static const Color _blackColor = Colors.black;
  static const Color _whiteColor = Colors.white;
  static const Color _greyColor = Colors.grey;

  // ==================== FONT SIZE 32 ====================

  static TextStyle get font32Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.2,
      );

  static TextStyle get font32Weight400White =>
      font32Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font32Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.2,
      );

  static TextStyle get font32Weight500White =>
      font32Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font32Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.2,
      );

  static TextStyle get font32Weight600White =>
      font32Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font32Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.2,
      );

  static TextStyle get font32Weight700White =>
      font32Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 28 ====================

  static TextStyle get font28Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.25,
      );

  static TextStyle get font28Weight400White =>
      font28Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font28Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.25,
      );

  static TextStyle get font28Weight500White =>
      font28Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font28Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.25,
      );

  static TextStyle get font28Weight600White =>
      font28Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font28Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.25,
      );

  static TextStyle get font28Weight700White =>
      font28Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 24 ====================

  static TextStyle get font24Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.3,
      );

  static TextStyle get font24Weight400White =>
      font24Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font24Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.3,
      );

  static TextStyle get font24Weight500White =>
      font24Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font24Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.3,
      );

  static TextStyle get font24Weight600White =>
      font24Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font24Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.3,
      );

  static TextStyle get font24Weight700White =>
      font24Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 20 ====================

  static TextStyle get font20Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.35,
      );

  static TextStyle get font20Weight400White =>
      font20Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font20Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.35,
      );

  static TextStyle get font20Weight500White =>
      font20Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font20Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.35,
      );

  static TextStyle get font20Weight600White =>
      font20Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font20Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.35,
      );

  static TextStyle get font20Weight700White =>
      font20Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 18 ====================

  static TextStyle get font18Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font18Weight400White =>
      font18Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font18Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font18Weight500White =>
      font18Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font18Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font18Weight600White =>
      font18Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font18Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font18Weight700White =>
      font18Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 16 ====================

  static TextStyle get font16Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font16Weight400White =>
      font16Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font16Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font16Weight500White =>
      font16Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font16Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font16Weight600White =>
      font16Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font16Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font16Weight700White =>
      font16Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 14 ====================
  static TextStyle get font14Weight400Grey => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: _greyColor,
        height: 1.5,
      );
  static TextStyle get font14Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font14Weight400White =>
      font14Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font14Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font14Weight500White =>
      font14Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font14Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font14Weight600White =>
      font14Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font14Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font14Weight700White =>
      font14Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 12 ====================

  static TextStyle get font12Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.5,
      );
  static TextStyle get font12Weight400Grey => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        color: _greyColor,
        height: 1.5,
      );

  static TextStyle get font12Weight400White =>
      font12Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font12Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font12Weight500White =>
      font12Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font12Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font12Weight600White =>
      font12Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font12Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.5,
      );

  static TextStyle get font12Weight700White =>
      font12Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 10 ====================

  static TextStyle get font10Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font10Weight400White =>
      font10Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font10Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font10Weight500White =>
      font10Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font10Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font10Weight600White =>
      font10Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font10Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font10Weight700White =>
      font10Weight700Black.copyWith(color: _whiteColor);

  // ==================== FONT SIZE 8 ====================

  static TextStyle get font8Weight400Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font8Weight400White =>
      font8Weight400Black.copyWith(color: _whiteColor);

  static TextStyle get font8Weight500Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 8.sp,
        fontWeight: FontWeight.w500,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font8Weight500White =>
      font8Weight500Black.copyWith(color: _whiteColor);

  static TextStyle get font8Weight600Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 8.sp,
        fontWeight: FontWeight.w600,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font8Weight600White =>
      font8Weight600Black.copyWith(color: _whiteColor);

  static TextStyle get font8Weight700Black => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 8.sp,
        fontWeight: FontWeight.w700,
        color: _blackColor,
        height: 1.4,
      );

  static TextStyle get font8Weight700White =>
      font8Weight700Black.copyWith(color: _whiteColor);
}
