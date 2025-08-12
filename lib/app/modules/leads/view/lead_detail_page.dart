// lib/app/modules/leads/view/lead_detail_page.dart
import 'package:benevolent_crm_app/app/modules/leads/controller/lead_details_controller.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/lead_details_response.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:benevolent_crm_app/app/themes/app_themes.dart';

import 'package:lucide_icons/lucide_icons.dart';

class LeadDetailPage extends StatefulWidget {
  final int leadId;
  const LeadDetailPage({super.key, required this.leadId});

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final LeadDetailsController c = Get.put(LeadDetailsController());
  final _date = DateFormat('yyyy-MM-dd');
  final _dateTime = DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    super.initState();
    c.load(widget.leadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Obx(() {
          final name = c.model?.name ?? 'Lead #${widget.leadId}';
          return Text(name, style: const TextStyle(color: Colors.white));
        }),
        elevation: 0.5,
        backgroundColor: AppThemes.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: c.refreshLead),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.errorMessage.value != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    LucideIcons.alertTriangle,
                    color: Colors.orange,
                    size: 46,
                  ),
                  const SizedBox(height: 12),
                  Text(c.errorMessage.value!, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: c.refreshLead,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          );
        }
        final lead = c.model;
        if (lead == null) {
          return const Center(child: Text('No data'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _leadHeaderCard(lead),
              const SizedBox(height: 16),
              _actionCard(lead),
              const SizedBox(height: 16),
              _contactInfoCard(lead),
              const SizedBox(height: 16),
              _metaCard(lead),
            ],
          ),
        );
      }),
    );
  }

  // ---------- Sections ----------

  Widget _leadHeaderCard(Lead lead) {
    final statusName = c.statusName;
    final statusColorHex = c.lead.value?.lead.statuses?.color; // e.g. #28B8DA
    final statusColor = _hexColor(statusColorHex) ?? Colors.blueGrey;
    final campaign = c.campaignName;
    final dateStr = lead.date != null ? _date.format(lead.date!) : '-';

    return _card(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kv('Lead ID', (lead.externalLeadId ?? lead.id?.toString() ?? '-')),
            const SizedBox(height: 8),
            Text(lead.name ?? '-', style: _boldStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip(label: campaign.isEmpty ? 'No Campaign' : campaign),
                _chip(
                  label: statusName.isEmpty ? 'No Status' : statusName,
                  bg: statusColor.withOpacity(.12),
                  fg: statusColor,
                ),
                _chip(label: 'Date: $dateStr'),
                if ((lead.priority ?? '').isNotEmpty)
                  _chip(label: 'Priority: ${lead.priority}'),
                if (lead.isFresh == 1)
                  _chip(
                    label: 'Fresh',
                    bg: Colors.green.withOpacity(.12),
                    fg: Colors.green,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(Lead lead) {
    final phone = lead.phone ?? lead.altPhone ?? lead.additionalPhone ?? '';
    return _card(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(
              Icons.chat,
              "WhatsApp",
              onTap: () => _openWhatsApp(phone),
            ),
            _actionButton(
              Icons.edit,
              "Change Status",
              onTap: () {
                // TODO: open your status bottom sheet
              },
            ),
            _actionButton(
              Icons.email,
              "Messages",
              onTap: () {
                // TODO: open messages view
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard(Lead lead) {
    final agentName = c.lead.value?.lead.agents.isNotEmpty == true
        ? (c.lead.value!.lead.agents.first.fullName ?? '—')
        : '—';

    return _card(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField("Assign To", agentName),
            _contactField(
              "Lead Contact",
              lead.phone ?? '-',
              copyValue: lead.phone,
            ),
            _contactField(
              "Alternate Contact",
              lead.altPhone ?? '-',
              copyValue: lead.altPhone,
            ),
            _contactFieldWithIcons(
              "Additional Number",
              lead.additionalPhone ?? '-',
            ),
            _emailField("Email", lead.email ?? '-'),
          ],
        ),
      ),
    );
  }

  Widget _metaCard(Lead lead) {
    final created = c.lead.value?.assignTime != null
        ? _dateTime.format(c.lead.value!.assignTime!)
        : '-';
    final sourceName = c.sourceName;
    final prop = lead.property;
    final propName = prop?.name ?? '-';
    final developerId = lead.developerId?.toString() ?? '-';

    return _card(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _kv('Assigned At', created),
            _kv('Source', sourceName.isEmpty ? '-' : sourceName),
            _kv('Property', propName),
            _kv('Developer ID', developerId),
            if ((lead.propertyPreference ?? '').isNotEmpty)
              _kv('Preference', lead.propertyPreference!),
            if ((lead.amount ?? '').isNotEmpty) _kv('Amount', lead.amount!),
            if ((lead.comment ?? '').isNotEmpty) _kv('Comment', lead.comment!),
          ],
        ),
      ),
    );
  }

  // ---------- Small pieces ----------

  Widget _card(Widget child) => Container(
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
      ],
    ),
    child: child,
  );

  Widget _actionButton(IconData icon, String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppThemes.primaryColor),
          ),
          const SizedBox(height: 6),
          Text(label, style: _valueStyle()),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: _valueStyle(),
          children: [
            TextSpan(text: '$k: ', style: _labelStyle()),
            TextSpan(text: v),
          ],
        ),
      ),
    );
  }

  Widget _detailField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Text(value, style: _valueStyle()),
        ],
      ),
    );
  }

  Widget _contactField(String title, String value, {String? copyValue}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(value, style: _valueStyle())),
              Tooltip(
                message: 'Copy',
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: copyValue == null || copyValue.isEmpty
                      ? null
                      : () async {
                          await Clipboard.setData(
                            ClipboardData(text: copyValue),
                          );
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied')),
                          );
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactFieldWithIcons(String title, String value) {
    final phone = value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: _labelStyle()),
              const SizedBox(width: 6),
              const Icon(Icons.edit, size: 16),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(value, style: _valueStyle())),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: value.isEmpty
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: value));
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied')));
                      },
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.messageCircle,
                  color: Colors.green,
                ),
                onPressed: () => _openSms(phone),
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () => _openDialer(phone),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emailField(String title, String email) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: Text(email, style: _valueStyle())),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: email.isEmpty
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: email));
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied')));
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip({required String label, Color? bg, Color? fg}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: (fg ?? Colors.grey).withOpacity(.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: fg ?? AppThemes.backgroundColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ---------- Styles ----------

  TextStyle _labelStyle() => const TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.w600,
    fontSize: 13,
  );

  TextStyle _boldStyle({double fontSize = 16}) => TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: AppThemes.backgroundColor,
  );

  TextStyle _valueStyle() =>
      TextStyle(color: AppThemes.backgroundColor, fontSize: 14);

  // ---------- Utilities ----------

  Color? _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var s = hex.replaceAll('#', '');
    if (s.length == 6) s = 'FF$s';
    final v = int.tryParse(s, radix: 16);
    if (v == null) return null;
    return Color(v);
  }

  Future<void> _openDialer(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final uri = Uri(scheme: 'tel', path: phone.trim());
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openSms(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    final uri = Uri(scheme: 'sms', path: phone.trim());
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.trim().isEmpty) return;
    // wa.me requires full number with country code, no plus
    final clean = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$clean');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
