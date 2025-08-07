import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final VoidCallback? onSuffixTap;
  final String? Function(String?)? validator;
  final bool enabled;

  const CustomInputField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.onSuffixTap,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          style: const TextStyle(color: AppThemes.primaryColor),
          enabled: enabled,
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
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            suffixIcon: suffixIcon != null
                ? IconButton(icon: suffixIcon!, onPressed: onSuffixTap)
                : null,
            labelStyle: TextStyles.label.copyWith(color: AppThemes.lightGrey),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
