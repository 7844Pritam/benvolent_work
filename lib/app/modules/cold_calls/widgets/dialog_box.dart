import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmConvertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final Future<void> Function() onConfirm;

  const ConfirmConvertDialog({
    super.key,
    this.title = 'Convert to Lead?',
    this.message =
        'This action will move this cold call into your leads list. You can continue managing it from there.',
    this.confirmText = 'Convert',
    this.cancelText = 'Cancel',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      backgroundColor: AppColors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Icon Circle ---
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppThemes.primaryGradient,
              ),
              child: const Icon(
                Icons.person_add_alt_1_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            // --- Title ---
            Text(
              title,
              style: TextStyles.Text18700.copyWith(
                color: AppColors.primaryColor,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // --- Description ---
            Text(
              message,
              style: TextStyles.Text14400.copyWith(color: AppColors.greyDark),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            // --- Buttons Row ---
            Row(
              children: [
                // Cancel Button
                Expanded(
                  child: TextButton(
                    onPressed: () => Get.back(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: AppColors.primaryColor.withOpacity(0.3),
                        ),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyles.Text14400.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Confirm Button with gradient
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      await onConfirm();
                    },
                    style:
                        ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ).copyWith(
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>(
                                (states) => null, // handled by Ink
                              ),
                        ),
                    child: Ink(
                      decoration: const BoxDecoration(
                        gradient: AppThemes.primaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Text(
                          confirmText,
                          style: TextStyles.Text14400.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
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
