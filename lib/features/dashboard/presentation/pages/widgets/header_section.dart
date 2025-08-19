import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/time_period_drop_down.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/user_avatar.dart';

class HeaderSection extends StatelessWidget {
  final String userName;

  const HeaderSection({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingL)
          .copyWith(top: AppDimens.paddingM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserAvatar(),
          SizedBox(width: AppDimens.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.goodMorning,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withValues(alpha: .8),
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  userName,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          TimePeriodDropdown()
        ],
      ),
    );
  }
}
