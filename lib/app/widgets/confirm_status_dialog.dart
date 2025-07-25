import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmStatusDialog extends StatelessWidget {
  final String newStatus;
  final VoidCallback onConfirm;

  const ConfirmStatusDialog({
    super.key,
    required this.newStatus,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 8,
      backgroundColor: AppThemes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppThemes.primaryColor,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              "Confirm Status Change",
              style: TextStyles.Text16700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "Are you sure you want to change your status to:",
              style: TextStyles.Text14400,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "\"$newStatus\"",
              style: TextStyles.Text16700,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Yes, Change",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
