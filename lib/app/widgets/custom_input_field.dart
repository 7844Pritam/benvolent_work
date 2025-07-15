import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;
  final TextEditingController? controller;
  final VoidCallback? onSuffixTap;

  const CustomInputField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
    this.controller,
    this.onSuffixTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(color: AppThemes.primaryColor),
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppThemes.lightGreyMore),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppThemes.primaryColor),
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(icon: suffixIcon!, onPressed: onSuffixTap)
                : null,
            errorText: errorText,
            focusColor: AppThemes.darkGrey,
            fillColor: Colors.red,
            labelStyle: TextStyles.label.copyWith(color: AppThemes.lightGrey),
          ),
        ),
        if (errorText != null) const SizedBox(height: 8),
      ],
    );
  }
}
