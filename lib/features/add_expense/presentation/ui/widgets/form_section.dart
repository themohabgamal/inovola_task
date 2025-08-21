import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inovola_task/core/shared/widgets/app_text_field.dart';
import 'package:inovola_task/features/add_expense/presentation/ui/widgets/shimmer_loading_widget.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';

class FormSection extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController amountController;
  final DateTime selectedDate;
  final VoidCallback onDateSelected;
  final String selectedCurrency;
  final Function(String) onCurrencyChanged;
  final List<String> currencyOptions;
  final VoidCallback onAmountChanged;
  final bool isLoadingRates;

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
    required this.isLoadingRates,
  }) : super(key: key);

  @override
  State<FormSection> createState() => _FormSectionState();
}

class _FormSectionState extends State<FormSection> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedImageName;

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImageName = image.name;
        });
      }
    } catch (e) {
      // Handle error
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          controller: widget.titleController,
          label: 'Title',
          hint: 'Enter expense title',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),

        SizedBox(height: 16.h),

        // Amount Field with Currency Dropdown
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppTextField(
                controller: widget.amountController,
                label: 'Amount',
                hint: '\$50,000',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Currency', style: AppTextStyles.font14Weight600Black),
                  const SizedBox(height: 8),
                  widget.isLoadingRates
                      ? const ShimmerLoadingContainer()
                      : Container(
                          height: 50.h,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: widget.selectedCurrency,
                              isExpanded: true,
                              items: widget.currencyOptions
                                  .map((currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(
                                          currency,
                                          style: AppTextStyles
                                              .font12Weight400Black,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  widget.onCurrencyChanged(value);
                                }
                              },
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Date Field
        AppTextField(
          controller: TextEditingController(
            text: DateFormat('MM/dd/yy').format(widget.selectedDate),
          ),
          label: 'Date',
          hint: '02/01/24',
          readOnly: true,
          onTap: widget.onDateSelected,
          suffixIcon: Icon(Icons.calendar_month, color: Colors.blue),
        ),

        SizedBox(height: 16.h),

        // Attach Receipt Section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attach Receipt', style: AppTextStyles.font14Weight600Black),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Text(
                        _selectedImageName ?? 'Upload image',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.font12Weight400Black.copyWith(
                          color: _selectedImageName != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
