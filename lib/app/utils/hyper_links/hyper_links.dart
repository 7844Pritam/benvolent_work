import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class HyperLinksNew {
  static void _showError(String msg) {
    CustomSnackbar.show(title: 'Error', message: msg);
  }

  static Future<void> openDialer(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      _showError('Phone number not available');
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone.trim());
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError('Unable to open dialer');
    }
  }

  static Future<void> openSms(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      _showError('Phone number not available');
      return;
    }
    final uri = Uri(scheme: 'sms', path: phone.trim());
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError('Unable to open SMS app');
    }
  }

  static Future<void> openWhatsApp(String? phone, String name) async {
    if (phone == null || phone.trim().isEmpty) {
      _showError('WhatsApp number not available');
      return;
    }
    final clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse(
      'whatsapp://send?phone=$clean&text=${Uri.encodeComponent("Hi $name,")}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError('Unable to open WhatsApp');
    }
  }

  static Future<void> openEmail(String? email, String name) async {
    if (email == null || email.trim().isEmpty) {
      _showError('Email not available');
      return;
    }
    final uri = Uri(
      scheme: 'mailto',
      path: email.trim(),
      query:
          'subject=${Uri.encodeComponent("Follow-up")}&body=${Uri.encodeComponent("Hi $name,")}',
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      _showError('Unable to open email app');
    }
  }
}
