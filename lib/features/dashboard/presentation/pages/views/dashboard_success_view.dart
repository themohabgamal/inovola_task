import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/dashboard_balance_card.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/dashboard_content.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/dashboard_header.dart';

class DashboardSuccessView extends StatelessWidget {
  final DashboardEntity dashboard;
  const DashboardSuccessView({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            DashboardHeader(dashboard: dashboard),
            DashboardContent(dashboard: dashboard),
          ],
        ),
        DashboardBalanceCard(dashboard: dashboard),
      ],
    ).animate().fadeIn(duration: 500.ms, curve: Curves.easeOut);
  }
}
