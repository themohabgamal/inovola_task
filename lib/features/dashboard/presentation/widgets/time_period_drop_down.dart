import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';

class TimePeriodDropdown extends StatefulWidget {
  final String? selectedPeriod;
  final Function(String)? onPeriodChanged;

  const TimePeriodDropdown({
    super.key,
    this.selectedPeriod,
    this.onPeriodChanged,
  });

  @override
  State<TimePeriodDropdown> createState() => _TimePeriodDropdownState();
}

class _TimePeriodDropdownState extends State<TimePeriodDropdown> {
  final List<Map<String, dynamic>> _timePeriods = [
    {'name': 'Last 7 Days', 'icon': Icons.today_outlined},
    {'name': 'This Month', 'icon': Icons.calendar_month_outlined},
    {'name': 'Last Month', 'icon': Icons.calendar_today_outlined},
    {'name': 'This Quarter', 'icon': Icons.date_range_outlined},
    {'name': 'Last Quarter', 'icon': Icons.date_range_outlined},
    {'name': 'This Year', 'icon': Icons.calendar_month},
    {'name': 'Last Year', 'icon': Icons.history},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        value: widget.selectedPeriod ?? 'This Month',
        onChanged: (String? newValue) {
          if (newValue != null && widget.onPeriodChanged != null) {
            widget.onPeriodChanged!(newValue);
          }
        },
        items: _timePeriods.map((period) {
          return DropdownMenuItem<String>(
            value: period['name'],
            child: Row(
              children: [
                Text(period['name'], style: AppTextStyles.font10Weight400Black),
              ],
            ),
          );
        }).toList(),
        buttonStyleData: ButtonStyleData(
          height: 40.h,
          width: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey[300]!,
              width: 1.5,
            ),
            color: Colors.white,
          ),
          elevation: 0,
        ),
        iconStyleData: IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 18.sp,
            color: Colors.grey[600],
          ),
          iconSize: 18.sp,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200.h,
          width: 200.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.white,
          ),
          offset: Offset(0, -5.h),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(40.r),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
      ),
    );
  }
}
