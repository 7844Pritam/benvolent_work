import 'package:benevolent_crm_app/app/modules/splash/views/splash_screen.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modals/leads_response.dart';
import '../view/lead_detail_page.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;

  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.to(() => LeadDetailPage(leadId: lead.id)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: ID and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${lead.id}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                _buildStatusTag(lead.name),
              ],
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              lead.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 12),

            _infoRow(
              Icons.person_outline,
              "Agent",
              lead.name == null ? lead.name : 'Unassigned',
            ),
            _infoRow(Icons.location_on_outlined, "Campaign", lead.name),
            _infoRow(Icons.calendar_month_outlined, "Date", lead.date),

            const SizedBox(height: 10),
            _actionsRow(context),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  // ---- UI bits ----
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    final styles = {
      "New Lead": [Colors.orange.shade50, Colors.deepOrange],
      "Low Budget": [Colors.green.shade50, Colors.green.shade800],
      "Hot Lead": [Colors.red.shade50, Colors.red],
      "Premium": [Colors.deepPurple.shade50, Colors.deepPurple],
      "Urgent": [Colors.orange.shade50, Colors.orange],
    };
    final colors =
        styles[status] ?? [Colors.grey.shade100, Colors.grey.shade700];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[0],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[1], width: 0.6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors[1],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // ---- Actions row (WhatsApp, Call, Email, Copy) ----
  Widget _actionsRow(BuildContext context) {
    final phone = lead.phone;
    final email = lead.email;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _chipButton(
          icon: FontAwesomeIcons.whatsapp,
          label: "WhatsApp",
          onTap: () => _openWhatsApp(phone, prefilled: "Hi ${lead.name}, "),
          bg: const Color(0xFFE8F5E9),
          fg: const Color(0xFF1FA855),
        ),
        _chipButton(
          icon: Icons.call,
          label: "Call",
          onTap: () => _makeCall(phone),
          bg: const Color(0xFFE3F2FD),
          fg: const Color(0xFF1565C0),
        ),
        _chipButton(
          icon: Icons.email_outlined,
          label: "Gmail",
          onTap: () => _sendEmail(
            email,
            subject: "Regarding your inquiry",
            body: "Hi ${lead.name},",
          ),
          bg: const Color(0xFFFFEBEE),
          fg: const Color(0xFFD32F2F),
        ),
        _chipButton(
          icon: Icons.copy_rounded,
          label: "Copy",
          onTap: () => _copyToClipboard(
            "Name: ${lead.name}\nPhone: $phone\nEmail: $email",
          ),
          bg: const Color(0xFFF3F4F6),
          fg: const Color(0xFF374151),
        ),
      ],
    );
  }

  Widget _chipButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color bg,
    required Color fg,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Helpers (actions) ----
  Future<void> _openWhatsApp(String raw, {String prefilled = ""}) async {
    final phone = _normalizePhone(raw);
    final text = Uri.encodeComponent(prefilled);
    final uri = Uri.parse('https://wa.me/$phone?text=$text');
    await _tryLaunch(uri);
  }

  Future<void> _makeCall(String raw) async {
    final phone = _normalizePhone(raw, keepPlus: true);
    final uri = Uri(scheme: 'tel', path: phone);
    await _tryLaunch(uri);
  }

  Future<void> _sendEmail(
    String to, {
    String subject = "",
    String body = "",
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );
    await _tryLaunch(uri);
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Lead details copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _tryLaunch(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar(
        'Action failed',
        'Could not open: $uri',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Simple phone normalizer; defaults to +91 if no country code.
  String _normalizePhone(String input, {bool keepPlus = false}) {
    final digits = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.startsWith('+')) return keepPlus ? digits : digits.substring(1);
    if (digits.length == 10) {
      return keepPlus ? '+91$digits' : '91$digits';
    }
    return keepPlus ? '+$digits' : digits;
  }
}
