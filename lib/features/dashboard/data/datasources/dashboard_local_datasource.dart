import 'package:flutter/material.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import '../../domain/entities/dashboard_entity.dart';

class DashboardLocalDataSource {
  Future<DashboardEntity> getDashboardData() async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 100));

    return DashboardEntity(
      userName: 'Shihab Rahman',
      totalBalance: 2548.00,
      income: 10840.00,
      expenses: 1884.00,
      recentExpenses: [
        ExpenseEntity(
          title: 'Groceries',
          category: 'Manually',
          amount: 100.00,
          time: 'Today 12:00 PM',
          iconName: 'shopping_cart',
          backgroundColor: Color(0xFF6366F1),
        ),
        ExpenseEntity(
          title: 'Entertainment',
          category: 'Manually',
          amount: 100.00,
          time: 'Today 12:00 PM',
          iconName: 'movie',
          backgroundColor: Color(0xFFF59E0B),
        ),
        ExpenseEntity(
          title: 'Transportation',
          category: 'Manually',
          amount: 100.00,
          time: 'Today 12:00 PM',
          iconName: 'directions_car',
          backgroundColor: Color(0xFF8B5CF6),
        ),
        ExpenseEntity(
          title: 'Rent',
          category: 'Manually',
          amount: 100.00,
          time: 'Today 12:00 PM',
          iconName: 'home',
          backgroundColor: Color(0xFFF59E0B),
        ),
      ],
    );
  }
}
