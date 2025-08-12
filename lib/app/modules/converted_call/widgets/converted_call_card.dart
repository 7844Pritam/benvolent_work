import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modal/converted_call_model.dart';

class ConvertedCallCard extends StatelessWidget {
  final ConvertedCall call;
  const ConvertedCallCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatDate(call.assignedDate);
    final initials = _getInitials(call.name);

    return Material(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        call.email,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[700],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(call.status),
              ],
            ),

            const SizedBox(height: 14),

            // Info rows (keep campaign + assigned date)
            Wrap(
              runSpacing: 10,
              children: [
                _infoRow(Icons.campaign_outlined, "Campaign: ${call.campaign}"),
                _infoRow(
                  Icons.calendar_today_outlined,
                  "Assigned: $formattedDate",
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action chips (WhatsApp / Call / Email / Copy)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(
                  icon: FontAwesomeIcons.whatsapp,
                  label: 'WhatsApp',
                  fg: const Color(0xFF1FA855),
                  bg: const Color(0xFFE8F5E9),
                  onTap: () => _whatsapp(call.phone, 'Hi ${call.name}, '),
                ),
                _chip(
                  icon: Icons.call,
                  label: 'Call',
                  fg: const Color(0xFF1565C0),
                  bg: const Color(0xFFE3F2FD),
                  onTap: () => _call(call.phone),
                ),
                _chip(
                  icon: Icons.email_outlined,
                  label: 'Gmail',
                  fg: const Color(0xFFD32F2F),
                  bg: const Color(0xFFFFEBEE),
                  onTap: () => _email(
                    call.email,
                    subject: 'Regarding your inquiry',
                    body: 'Hi ${call.name},',
                  ),
                ),
                _chip(
                  icon: Icons.copy_rounded,
                  label: 'Copy',
                  fg: const Color(0xFF374151),
                  bg: const Color(0xFFF3F4F6),
                  onTap: () => _copy(
                    'Name: ${call.name}\nPhone: ${call.phone}\nEmail: ${call.email}\nCampaign: ${call.campaign}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- UI bits ---
  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.2, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required Color fg,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
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
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hot':
        return Colors.redAccent;
      case 'interested':
        return Colors.green;
      case 'cold':
        return Colors.blueGrey;
      case 'junk':
        return Colors.grey;
      case 'new lead':
        return Colors.deepPurple;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'hot':
        return Icons.whatshot;
      case 'interested':
        return Icons.thumb_up_alt;
      case 'cold':
        return Icons.ac_unit;
      case 'junk':
        return Icons.delete;
      case 'new lead':
        return Icons.fiber_new;
      default:
        return Icons.label;
    }
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat.yMMMEd().format(date);
    } catch (_) {
      return rawDate;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2)
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty)
      return parts[0][0].toUpperCase();
    return '?';
  }

  // --- actions ---
  Future<void> _whatsapp(String raw, String pre) async {
    final phone = _normalizePhone(raw);
    final text = Uri.encodeComponent(pre);
    final uri = Uri.parse('https://wa.me/$phone?text=$text');
    await _launch(uri);
  }

  Future<void> _call(String raw) async {
    final phone = _normalizePhone(raw, keepPlus: true);
    final uri = Uri(scheme: 'tel', path: phone);
    await _launch(uri);
  }

  Future<void> _email(
    String to, {
    String subject = '',
    String body = '',
  }) async {
    final uri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        if (subject.isNotEmpty) 'subject': subject,
        if (body.isNotEmpty) 'body': body,
      },
    );
    await _launch(uri);
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      'Converted call details copied',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _launch(Uri uri) async {
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

  // Simple phone normalizer; assumes +91 if 10 digits.
  String _normalizePhone(String input, {bool keepPlus = false}) {
    final digits = input.replaceAll(RegExp(r'[^0-9+]'), '');
    if (digits.startsWith('+')) return keepPlus ? digits : digits.substring(1);
    if (digits.length == 10) return keepPlus ? '+91$digits' : '91$digits';
    return keepPlus ? '+$digits' : digits;
  }
}
