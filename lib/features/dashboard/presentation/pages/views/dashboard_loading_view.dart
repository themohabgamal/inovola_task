import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class DashboardLoadingView extends StatelessWidget {
  const DashboardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with greeting and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildShimmerContainer(
                        width: 90.w,
                        height: 14.h,
                        borderRadius: 7.r,
                      ),
                      SizedBox(height: 4.h),
                      _buildShimmerContainer(
                        width: 130.w,
                        height: 18.h,
                        borderRadius: 9.r,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _buildShimmerContainer(
                        width: 75.w,
                        height: 24.h,
                        borderRadius: 12.r,
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey.shade400,
                        size: 16.sp,
                      ),
                      SizedBox(width: 12.w),
                      _buildShimmerContainer(
                        width: 32.w,
                        height: 32.h,
                        borderRadius: 16.r,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Balance Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w).copyWith(top: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Balance label with three dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildShimmerContainer(
                          width: 100.w,
                          height: 14.h,
                          borderRadius: 7.r,
                        ),
                        Icon(
                          Icons.more_horiz,
                          color: Colors.grey.shade400,
                          size: 20.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    // Balance amount
                    _buildShimmerContainer(
                      width: 160.w,
                      height: 32.h,
                      borderRadius: 16.r,
                    ),
                    SizedBox(height: 24.h),

                    // Income and Expenses row
                    Row(
                      children: [
                        // Income section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildShimmerContainer(
                                    width: 12.w,
                                    height: 12.h,
                                    borderRadius: 6.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  _buildShimmerContainer(
                                    width: 50.w,
                                    height: 12.h,
                                    borderRadius: 6.r,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              _buildShimmerContainer(
                                width: 90.w,
                                height: 16.h,
                                borderRadius: 8.r,
                              ),
                            ],
                          ),
                        ),

                        // Expenses section
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  _buildShimmerContainer(
                                    width: 12.w,
                                    height: 12.h,
                                    borderRadius: 6.r,
                                  ),
                                  SizedBox(width: 6.w),
                                  _buildShimmerContainer(
                                    width: 60.w,
                                    height: 12.h,
                                    borderRadius: 6.r,
                                  ),
                                ],
                              ),
                              SizedBox(height: 6.h),
                              _buildShimmerContainer(
                                width: 80.w,
                                height: 16.h,
                                borderRadius: 8.r,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Recent Expenses Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildShimmerContainer(
                    width: 130.w,
                    height: 18.h,
                    borderRadius: 9.r,
                  ),
                  _buildShimmerContainer(
                    width: 45.w,
                    height: 14.h,
                    borderRadius: 7.r,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Expense items list
              Expanded(
                child: ListView.separated(
                  itemCount: 4,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, index) => _buildExpenseItem(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseItem() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          // Category icon container
          _buildShimmerContainer(
            width: 40.w,
            height: 40.h,
            borderRadius: 10.r,
          ),
          SizedBox(width: 12.w),

          // Expense details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmerContainer(
                  width: 80.w,
                  height: 16.h,
                  borderRadius: 8.r,
                ),
                SizedBox(height: 4.h),
                _buildShimmerContainer(
                  width: 50.w,
                  height: 12.h,
                  borderRadius: 6.r,
                ),
              ],
            ),
          ),

          // Amount and time
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildShimmerContainer(
                width: 50.w,
                height: 16.h,
                borderRadius: 8.r,
              ),
              SizedBox(height: 4.h),
              _buildShimmerContainer(
                width: 75.w,
                height: 12.h,
                borderRadius: 6.r,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double width,
    required double height,
    required double borderRadius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
