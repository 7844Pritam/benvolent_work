import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastType { info, success, error, warning, loading }

class CustomSnackbar {
  static void show({
    required String title,
    required String message,

    ToastType type = ToastType.info,
  }) {
    final _toastColors = {
      ToastType.info: Colors.blue.shade100,
      ToastType.success: Colors.green.shade100,
      ToastType.error: Colors.red.shade100,
      ToastType.warning: Colors.orange.shade100,
      ToastType.loading: Colors.grey.shade200,
    };

    final _iconColors = {
      ToastType.info: Colors.blue,
      ToastType.success: Colors.green,
      ToastType.error: Colors.red,
      ToastType.warning: Colors.orange,
      ToastType.loading: Colors.grey,
    };

    final _icons = {
      ToastType.info: Icons.info_outline,
      ToastType.success: Icons.check_circle_outline,
      ToastType.error: Icons.error_outline,
      ToastType.warning: Icons.warning_amber_rounded,
      ToastType.loading: Icons.hourglass_bottom_rounded,
    };

    Get.snackbar(
      '',
      '',
      backgroundColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.zero,
      borderRadius: 0,
      isDismissible: true,
      animationDuration: const Duration(milliseconds: 300),
      duration: type == ToastType.loading
          ? const Duration(seconds: 5)
          : const Duration(seconds: 3),
      titleText: const SizedBox.shrink(),
      messageText: Container(
        decoration: BoxDecoration(
          color: _toastColors[type],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _iconColors[type]!, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: _iconColors[type]!.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(6),
              child: type == ToastType.loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: _iconColors[type],
                      ),
                    )
                  : Icon(_icons[type], color: _iconColors[type], size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _iconColors[type],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    message,
                    style: TextStyle(fontSize: 13.5, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
