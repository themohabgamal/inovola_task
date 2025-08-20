import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_colors.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';
import 'package:inovola_task/features/add_expense/domain/entities/category_entity.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_state.dart';
import 'package:inovola_task/features/add_expense/presentation/widgets/category_item.dart';
import 'package:inovola_task/features/add_expense/presentation/widgets/shimmer_widgets.dart';

class CategoriesSection extends StatelessWidget {
  final CategoryEntity? selectedCategory;
  final Function(CategoryEntity) onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categories',
          style: AppTextStyles.font14Weight500Black,
        ),
        SizedBox(height: 16.h),
        BlocBuilder<AddExpenseBloc, AddExpenseState>(
          buildWhen: (previous, current) =>
              current is AddExpenseCategoriesLoaded ||
              current is AddExpenseSubmitting ||
              current is AddExpenseSuccess ||
              current is AddExpenseFailure,
          builder: (context, state) {
            if (state is AddExpenseLoading) {
              return const ShimmerCategoryGrid();
            }

            List<CategoryEntity> categories = [];
            if (state is AddExpenseCategoriesLoaded) {
              categories = state.categories;
            } else if (state is AddExpenseSubmitting) {
              categories = state.categories;
            } else if (state is AddExpenseSuccess) {
              categories = state.categories;
            } else if (state is AddExpenseFailure) {
              categories = state.categories;
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 4,
              ),
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Add Category feature coming soon!')),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                                style: BorderStyle.solid),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 24,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Add Category',
                          style: AppTextStyles.font10Weight500Black,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final category = categories[index];
                return CategoryItem(
                  category: category,
                  isSelected: selectedCategory?.name == category.name,
                  onTap: () => onCategorySelected(category),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
