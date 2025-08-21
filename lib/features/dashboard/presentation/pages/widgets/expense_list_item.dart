import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';
import 'package:inovola_task/features/dashboard/domain/entities/expense_entity.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/expense_item.dart';
import 'package:inovola_task/features/dashboard/presentation/pages/widgets/delete_confirmation_dialog.dart';

class ExpenseListItem extends StatelessWidget {
  final ExpenseEntity expense;
  final Function(ExpenseEntity) onDelete;

  const ExpenseListItem({
    Key? key,
    required this.expense,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('expense_${expense.hashCode}'),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _showDeleteConfirmation(context),
      onDismissed: (direction) => onDelete(expense),
      background: _buildDismissBackground(),
      child: _buildExpenseItem(),
    );
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDeleteConfirmation(context);
  }

  Widget _buildExpenseItem() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: ExpenseItem(expense: expense),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      height: 69.h,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}
