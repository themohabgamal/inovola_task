import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/dashboard_balance_card.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/dashboard_content.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/dashboard_header.dart';

class DashboardSuccessWidget extends StatelessWidget {
  final DashboardEntity dashboard;
  final bool isLoadingMore;

  const DashboardSuccessWidget({
    super.key,
    required this.dashboard,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            DashboardHeader(dashboard: dashboard),
            DashboardContent(
              dashboard: dashboard,
              isLoadingMore: isLoadingMore, // Pass the loading state down
            ),
          ],
        ),
        DashboardBalanceCard(dashboard: dashboard),
      ],
    ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut);
  }
}
