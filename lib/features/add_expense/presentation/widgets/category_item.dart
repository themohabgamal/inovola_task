import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';
import '../../domain/entities/category_entity.dart';

class CategoryItem extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    log(' ${category.icon}');
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(int.parse(category.color))
                  : Color(int.parse(category.color)).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: isSelected
                  ? Border.all(
                      color: Color(int.parse(category.color)),
                      width: 2,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                category.icon,
                style: TextStyle(
                  fontSize: 24.sp,
                  color: isSelected
                      ? Colors.white
                      : Color(int.parse(category.color)),
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            category.name,
            style: AppTextStyles.font10Weight500Black,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
