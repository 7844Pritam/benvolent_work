import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/change_status_sheet.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertedCallDetailPage extends StatefulWidget {
  final ConvertedCall call;
  const ConvertedCallDetailPage({super.key, required this.call});

  @override
  State<ConvertedCallDetailPage> createState() =>
      _ConvertedCallDetailPageState();
}

class _ConvertedCallDetailPageState extends State<ConvertedCallDetailPage>
    with SingleTickerProviderStateMixin {
  late ConvertedCall call;
  late List<String> notes;
  late List<Map<String, String>> schedules;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    call = widget.call;
    notes = [
      "Called & discussed product features.",
      "Client requested a follow-up in two weeks.",
      "Sent brochure via email.",
    ];
    schedules = [
      {
        "id": "s1",
        "title": "Follow-up Call",
        "datetime": "2025-08-10 10:00 AM",
      },
      {"id": "s2", "title": "Demo Meeting", "datetime": "2025-08-15 03:00 PM"},
    ];
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // String _newId() => DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        title: Text(
          call.name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _headerCard(),
            const SizedBox(height: 16),
            _actionRow(),
            const SizedBox(height: 16),
            _contactInfoCard(),
            const SizedBox(height: 16),
            _notesAndSchedulesTabView(),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor.withOpacity(0.15),
            radius: 30,
            child: Text(
              call.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(call.name, style: _boldStyle(fontSize: 18)),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: [
                    _infoChip(Icons.phone, call.phone),
                    _infoChip(Icons.email, call.email),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Chip(
      backgroundColor: AppColors.primaryColor.withOpacity(0.08),
      avatar: Icon(icon, size: 16, color: AppColors.primaryColor),
      label: Text(
        text,
        style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
      ),
    );
  }

  Widget _actionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionButton(FontAwesomeIcons.whatsapp, "WhatsApp", _launchWhatsApp),
          _actionButton(Icons.email_outlined, "Email", _launchEmail),
          _actionButton(Icons.swap_horiz, "Status", _openChangeStatus),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.primaryColor.withOpacity(0.12),
            child: Icon(icon, size: 18, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: _smallStyle()),
        ],
      ),
    );
  }

  Widget _contactInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(Icons.flag, "Status", call.status),
          const Divider(),
          _infoRow(Icons.campaign, "Campaign", call.campaign),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primaryColor),
        const SizedBox(width: 10),
        Text("$title: ", style: _labelStyle()),
        Expanded(child: Text(value, style: _valueStyle())),
      ],
    );
  }

  Widget _notesAndSchedulesTabView() {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            TabBar(
              labelColor: AppColors.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.primaryColor,
              tabs: const [
                Tab(text: 'Notes'),
                Tab(text: 'Schedules'),
              ],
            ),
            SizedBox(
              height: 250,
              child: TabBarView(children: [_notesTab(), _schedulesTab()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.note_alt),
          title: Text(notes[index], style: _valueStyle()),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => notes.removeAt(index)),
          ),
        );
      },
    );
  }

  Widget _schedulesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: schedules.length,
      itemBuilder: (context, index) {
        final item = schedules[index];
        return ListTile(
          leading: const Icon(Icons.event_note),
          title: Text(item['title'] ?? '', style: _valueStyle()),
          subtitle: Text(item['datetime'] ?? '', style: _smallStyle()),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => setState(() => schedules.removeAt(index)),
          ),
        );
      },
    );
  }

  void _launchWhatsApp() {
    final url = Uri.parse("https://wa.me/${call.phone}?text=Hi ${call.name},");
    launchUrl(url);
  }

  void _launchEmail() {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: call.email,
      query: 'subject=Follow-up&body=Hi ${call.name},',
    );
    launchUrl(emailUri);
  }

  void _openChangeStatus() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: ChangeStatusSheet(callId: call.id),
            ),
          );
        },
      ),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  TextStyle _labelStyle() => const TextStyle(
    color: AppColors.primaryColor,
    fontWeight: FontWeight.w500,
    fontSize: 13,
  );

  TextStyle _boldStyle({double fontSize = 16}) => TextStyle(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryColor,
  );

  TextStyle _valueStyle() =>
      const TextStyle(color: Colors.black87, fontSize: 14);

  TextStyle _smallStyle() =>
      const TextStyle(fontSize: 12, color: Colors.black54);
}
