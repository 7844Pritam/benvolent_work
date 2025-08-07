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

  // Local dummy lists (start with some sample items)
  late List<String> notes;
  late List<Map<String, String>> schedules; // {id,title,datetime}

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Keep a local copy (UI-only). Replace with real data fetch later.
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

  // Helper to generate simple unique ids
  String _newId() => DateTime.now().millisecondsSinceEpoch.toString();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showMoreActions,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMenu,
        label: const Text("Add"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primaryColor,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Placeholder for refresh logic (e.g., re-fetch from backend)
          await Future.delayed(const Duration(milliseconds: 600));
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildAnimatedHeader(),
              const SizedBox(height: 16),
              _buildActionRow(),
              const SizedBox(height: 16),
              _contactInfoCard(),
              const SizedBox(height: 16),
              _modernNotesCard(),
              const SizedBox(height: 16),
              _modernSchedulesCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    // Nice card with avatar, basic info and chips
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryColor.withOpacity(0.15),
            child: Text(
              call.name.isNotEmpty ? call.name[0].toUpperCase() : "C",
              style: TextStyle(
                color: AppColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  call.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.backgroundColor,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _infoChip(Icons.phone, call.phone),
                    _infoChip(Icons.email, call.email),
                    _infoChip(Icons.campaign, call.campaign),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              // Example: toggle animation or favorite
              _controller.forward(from: 0);
              Get.snackbar(
                "Action",
                "Saved to favorites (demo)",
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.add_event,
              progress: _controller,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Chip(
      backgroundColor: AppColors.primaryColor.withOpacity(0.08),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      avatar: Icon(icon, size: 16, color: AppColors.primaryColor),
      label: Text(
        text,
        style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
      ),
    );
  }

  Widget _buildActionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionItem(FontAwesomeIcons.whatsapp, "WhatsApp", _launchWhatsApp),
          _actionItem(Icons.email_outlined, "Email", _launchEmail),
          _actionItem(Icons.swap_horiz, "Status", _openChangeStatus),
        ],
      ),
    );
  }

  Widget _actionItem(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _detailRow(Icons.phone, "Phone", call.phone, () => _launchWhatsApp()),
          const Divider(),
          _detailRow(Icons.email, "Email", call.email, _launchEmail),
          const Divider(),
          _detailRow(Icons.campaign, "Campaign", call.campaign, null),
          const Divider(),
          _detailRow(Icons.flag, "Status", call.status, _openChangeStatus),
        ],
      ),
    );
  }

  Widget _detailRow(
    IconData icon,
    String title,
    String value,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: _labelStyle()),
                  const SizedBox(height: 4),
                  Text(value, style: _valueStyle()),
                ],
              ),
            ),
            if (onTap != null) Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // -------------------- MODERN NOTES --------------------
  Widget _modernNotesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Notes", style: _boldStyle(fontSize: 16)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_comment_outlined),
                onPressed: () => _showAddNoteDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (notes.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  "No notes yet. Tap + to add one.",
                  style: _hintStyle(),
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: notes
                  .map(
                    (n) => GestureDetector(
                      onLongPress: () => _confirmDeleteNote(n),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.note,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(n, style: _valueStyle()),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => _editNote(n),
                              child: const Icon(Icons.edit, size: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  // -------------------- MODERN SCHEDULES --------------------
  Widget _modernSchedulesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Schedules", style: _boldStyle(fontSize: 16)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.event_available_outlined),
                onPressed: () => _showAddScheduleDialog(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (schedules.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text("No schedules yet.", style: _hintStyle()),
              ),
            )
          else
            Column(
              children: List.generate(schedules.length, (i) {
                final item = schedules[i];
                return Dismissible(
                  key: Key(item['id'] ?? _newId()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() {
                      schedules.removeAt(i);
                    });
                    Get.snackbar(
                      "Deleted",
                      "Schedule removed",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                      color: Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        // Timeline dot + line
                        Column(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 50,
                              color: Colors.grey.shade200,
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['title'] ?? "",
                                style: _boldStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.access_time, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    item['datetime'] ?? "",
                                    style: _valueStyle(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _showEditScheduleDialog(i),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }

  // -------------------- ACTIONS / DIALOGS --------------------

  void _showMoreActions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text("Share Contact"),
              onTap: () {
                Get.back();
                // Implement share (placeholder)
                Get.snackbar("Share", "Sharing contact (demo)");
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text("Delete Converted Call"),
              onTap: () {
                Get.back();
                // Implement delete
                Get.snackbar("Delete", "Deleted (demo)");
              },
            ),
          ],
        ),
      ),
      isDismissible: true,
    );
  }

  void _showAddMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text("Add Note"),
                onTap: () {
                  Navigator.pop(context);
                  _showAddNoteDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text("Add Schedule"),
                onTap: () {
                  Navigator.pop(context);
                  _showAddScheduleDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddNoteDialog() {
    final TextEditingController controller = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Add Note"),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Enter note"),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                setState(() => notes.insert(0, text));
                Get.back();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editNote(String existing) {
    final TextEditingController controller = TextEditingController(
      text: existing,
    );
    Get.dialog(
      AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(controller: controller, maxLines: 3),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newText = controller.text.trim();
              if (newText.isNotEmpty) {
                setState(() {
                  final idx = notes.indexOf(existing);
                  if (idx != -1) notes[idx] = newText;
                });
                Get.back();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteNote(String note) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Delete this note?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() => notes.remove(note));
              Get.back();
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog() {
    final TextEditingController title = TextEditingController();
    final TextEditingController datetime = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text("Add Schedule"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: datetime,
              decoration: const InputDecoration(hintText: "Date & Time"),
            ),
            const SizedBox(height: 6),
            Text(
              "Example: 2025-08-10 10:00 AM",
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final t = title.text.trim();
              final dt = datetime.text.trim();
              if (t.isNotEmpty && dt.isNotEmpty) {
                setState(
                  () => schedules.insert(0, {
                    "id": _newId(),
                    "title": t,
                    "datetime": dt,
                  }),
                );
                Get.back();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showEditScheduleDialog(int index) {
    final item = schedules[index];
    final title = TextEditingController(text: item['title']);
    final datetime = TextEditingController(text: item['datetime']);
    Get.dialog(
      AlertDialog(
        title: const Text("Edit Schedule"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(hintText: "Title"),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: datetime,
              decoration: const InputDecoration(hintText: "Date & Time"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final t = title.text.trim();
              final dt = datetime.text.trim();
              if (t.isNotEmpty && dt.isNotEmpty) {
                setState(() {
                  schedules[index] = {
                    "id": item['id'] ?? _newId(),
                    "title": t,
                    "datetime": dt,
                  };
                });
                Get.back();
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // -------------------- LAUNCHERS / STATUS --------------------

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
              color: Color.fromARGB(0, 255, 255, 255),
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

  // -------------------- STYLES --------------------
  TextStyle _labelStyle() {
    return const TextStyle(
      color: AppColors.primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );
  }

  TextStyle _boldStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.backgroundColor,
    );
  }

  TextStyle _valueStyle() {
    return const TextStyle(color: Colors.black87, fontSize: 14);
  }

  TextStyle _smallStyle() {
    return const TextStyle(fontSize: 12, color: Colors.black54);
  }

  TextStyle _hintStyle() {
    return TextStyle(fontSize: 13, color: Colors.grey.shade600);
  }
}
