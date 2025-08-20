import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Helpers {
  static Future<void> copyClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    CustomSnackbar.show(title: 'Copied to Clipboard', message: text);
  }

  static String formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat.yMMMEd().format(date);
    } catch (e, stackTrace) {
      print('Error formatting date: $e');
      print(stackTrace);
      return rawDate;
    }
  }

  static String getInitials(String name) {
    try {
      final parts = name.trim().split(' ');
      if (parts.length >= 2) {
        return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
      }
      if (parts.isNotEmpty && parts[0].isNotEmpty) {
        return parts[0][0].toUpperCase();
      }
      return '?';
    } catch (e, stackTrace) {
      print('Error getting initials: $e');
      print(stackTrace);
      return '?';
    }
  }

  static String normalizePhone(String input, {bool keepPlus = false}) {
    try {
      final digits = input.replaceAll(RegExp(r'[^0-9+]'), '');
      if (digits.startsWith('+'))
        return keepPlus ? digits : digits.substring(1);
      if (digits.length == 10) return keepPlus ? '+91$digits' : '91$digits';
      return keepPlus ? '+$digits' : digits;
    } catch (e, stackTrace) {
      print('Error normalizing phone number: $e');
      print(stackTrace);
      return input;
    }
  }
}
