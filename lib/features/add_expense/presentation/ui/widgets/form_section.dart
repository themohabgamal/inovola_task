import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/shared/widgets/app_text_field.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_bloc.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_event.dart';
import 'package:inovola_task/features/add_expense/presentation/bloc/add_expense_state.dart';
import 'package:inovola_task/features/add_expense/presentation/widgets/shimmer_widgets.dart';
import 'package:intl/intl.dart';

class FormSection extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final VoidCallback onDateSelected;

  const FormSection({
    super.key,
    required this.titleController,
    required this.amountController,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final TextEditingController _receiptController =
      TextEditingController(text: "Upload Image");
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        if (state is AddExpenseLoading) {
          return _buildShimmerForm();
        }
        return _buildForm();
      },
    );
  }

  Widget _buildShimmerForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Title',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        ShimmerTextField(),
        SizedBox(height: 16),
        Text('Amount',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        ShimmerTextField(),
        SizedBox(height: 16),
        Text('Date',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        ShimmerTextField(),
        Text('Image',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        ShimmerTextField(),
      ],
    );
  }

  Widget _buildForm() {
    return BlocBuilder<AddExpenseBloc, AddExpenseState>(
      builder: (context, state) {
        if (state is AddExpenseReceiptPicked) {
          _receiptController.text = state.receiptName;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: widget.titleController,
              label: "Title",
              hint: "Enter expense title",
              validator: (value) => (value == null || value.isEmpty)
                  ? "Please enter a title"
                  : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: widget.amountController,
              label: "Amount",
              hint: "\$0.00",
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter an amount";
                }
                if (double.tryParse(value) == null) {
                  return "Please enter a valid amount";
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: TextEditingController(
                text: DateFormat('MM/dd/yy').format(widget.selectedDate),
              ),
              textColor: Colors.grey,
              label: "Date",
              readOnly: true,
              onTap: widget.onDateSelected,
              suffixIcon: const Icon(Icons.calendar_today, size: 26),
            ),
            SizedBox(height: 16.h),
            AppTextField(
              controller: _receiptController,
              textColor: Colors.grey,
              label: "Attach Receipt",
              readOnly: true,
              onTap: () {
                context.read<AddExpenseBloc>().add(PickReceiptImage());
              },
              suffixIcon: const Icon(Icons.photo_camera_back, size: 26),
            ),
          ],
        );
      },
    );
  }
}
