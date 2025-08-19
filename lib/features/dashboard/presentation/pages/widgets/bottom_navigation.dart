import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/routing/routes.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int)? onItemTapped;

  const BottomNavigation({
    Key? key,
    this.selectedIndex = 0,
    this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76.h + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem('assets/icons/home.svg', 0),
            _buildNavItem('assets/icons/analysis.svg', 1),
            _buildAddButton(context: context),
            _buildNavItem('assets/icons/wallet.svg', 2),
            _buildNavItem('assets/icons/user.svg', 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String iconPath, int index) {
    final bool isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped?.call(index),
      child: Container(
        padding: EdgeInsets.all(AppDimens.paddingM),
        child: SvgPicture.asset(
          iconPath,
          width: AppDimens.iconL,
          height: AppDimens.iconL,
          colorFilter: ColorFilter.mode(
            isActive ? AppColors.primary : AppColors.grey,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton({required BuildContext context}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, Routes.addExpenseScreen),
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          color: AppColors.white,
          size: AppDimens.iconL,
        ),
      ),
    );
  }
}
