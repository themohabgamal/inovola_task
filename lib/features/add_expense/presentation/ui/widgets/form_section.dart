// lib/features/add_expense/presentation/widgets/form_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// lib/features/add_expense/presentation/widgets/form_section.dart
class FormSection extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final VoidCallback onDateSelected;
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;
  final List<String> currencyOptions;
  final VoidCallback onAmountChanged;
  final bool isLoadingRates; // Add this

  const FormSection({
    Key? key,
    required this.titleController,
    required this.amountController,
    required this.selectedDate,
    required this.onDateSelected,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.currencyOptions,
    required this.onAmountChanged,
    required this.isLoadingRates, // Add this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add New Expense',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        SizedBox(height: 16.h),
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: selectedCurrency != 'USD' ? '' : '\$',
                ),
                onChanged: (value) => onAmountChanged(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              flex: 1,
              child: isLoadingRates
                  ? _buildLoadingCurrencyDropdown()
                  : DropdownButtonFormField<String>(
                      value: selectedCurrency,
                      items: currencyOptions
                          .map((currency) => DropdownMenuItem(
                                value: currency,
                                child: Text(currency),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onCurrencyChanged(value);
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                    ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: onDateSelected,
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: DateFormat('yyyy-MM-dd').format(selectedDate),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCurrencyDropdown() {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Loading currencies...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }
}
