import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:inovola_task/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/widgets/balance_card/balance_card.dart';

class DashboardBalanceCard extends StatelessWidget {
  final DashboardEntity dashboard;
  const DashboardBalanceCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 100,
      left: 0,
      right: 0,
      child: BalanceCard(
        totalBalance: dashboard.totalBalance,
        income: dashboard.income,
        expenses: dashboard.expenses,
      )
          .animate()
          .scale(
            begin: Offset(0.8, 0.8),
            duration: 700.ms,
            curve: Curves.elasticOut,
            delay: 300.ms,
          )
          .fadeIn(delay: 300.ms, duration: 500.ms)
          .slideY(begin: 0.2, duration: 600.ms, curve: Curves.easeOutBack)
          .shimmer(
              color: Colors.white, duration: 2000.ms, curve: Curves.easeOut),
    );
  }
}
