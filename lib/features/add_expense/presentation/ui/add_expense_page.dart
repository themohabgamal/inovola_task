import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inovola_task/core/shared/widgets/app_toasts.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_state.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/add_expense_content.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/add_expense_app_bar.dart';

class AddExpensePage extends StatelessWidget {
  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AddExpenseAppBar(),
      body: BlocListener<AddExpenseBloc, AddExpenseState>(
        listener: (context, state) {
          if (state is AddExpenseSuccess) {
            Navigator.pop(context);
          } else if (state is AddExpenseFailure) {
            AppToasts.showError(context, state.error);
          }
        },
        child: const AddExpenseContent(),
      ),
    );
  }
}
