import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inovola_task/core/constants/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Color? textColor;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.font14Weight600Black),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: AppTextStyles.font12Weight400Black.copyWith(
            color: textColor ?? Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.font12Weight400Black.copyWith(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}
