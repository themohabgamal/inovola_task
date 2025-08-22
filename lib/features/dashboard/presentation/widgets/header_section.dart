// lib/features/dashboard/presentation/pages/widgets/header_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/core/constants/app_strings.dart';
import 'package:inovola_task/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/time_period_drop_down.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/user_avatar.dart';

class HeaderSection extends StatelessWidget {
  final String userName;
  final String selectedPeriod; // Add this parameter

  const HeaderSection({
    super.key,
    required this.userName,
    required this.selectedPeriod, // Make it required
  });

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
          TimePeriodDropdown(
            selectedPeriod: selectedPeriod, // Use the new parameter
            onPeriodChanged: (String newFilter) {
              context.read<DashboardBloc>().add(
                    DashboardFilterChangedEvent(newFilter),
                  );
            },
          )
        ],
      ),
    );
  }
}
