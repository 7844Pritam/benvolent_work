import 'package:benevolent_crm_app/app/modules/others/controller/notes_controller.dart';
import 'package:benevolent_crm_app/app/modules/others/controller/lead_details_controller.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/lead_details_response.dart';
import 'package:benevolent_crm_app/app/modules/profile/controller/profile_controller.dart';
import 'package:benevolent_crm_app/app/utils/helpers.dart';
import 'package:benevolent_crm_app/app/utils/hyper_links/hyper_links.dart';
import 'package:benevolent_crm_app/app/widgets/custom_select_field.dart';
import 'package:benevolent_crm_app/app/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:benevolent_crm_app/app/themes/text_styles.dart';
import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
import 'package:benevolent_crm_app/app/modules/others/controller/shedule_controller.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/shedule_modal.dart';
import 'package:benevolent_crm_app/app/modules/others/modals/schedule_request_model.dart';

import 'package:benevolent_crm_app/app/modules/others/screens/change_status_sheet.dart';

class LeadsDetailsPage extends StatefulWidget {
  final int leadId;
  final int agentId;
  const LeadsDetailsPage({
    super.key,
    required this.leadId,
    required this.agentId,
  });

  @override
  State<LeadsDetailsPage> createState() => _LeadsDetailsPageState();
}

class _LeadsDetailsPageState extends State<LeadsDetailsPage> {
  final LeadDetailsController c = Get.put(LeadDetailsController());
  final ScheduleController scheduleController = Get.put(ScheduleController());
  final NotesController notesController = Get.put(NotesController());
  final TextEditingController noteInputController = TextEditingController();
  final ProfileController _profileController = Get.find<ProfileController>();

  final List<String> notes = [
    "Called & discussed product features.",
    "Client requested a follow-up in two weeks.",
    "Sent brochure via email.",
  ];

  bool _schedulesLoaded = false;

  @override
  void initState() {
    super.initState();
    c.load(widget.leadId);
    print("000000000000000");
    print(_profileController.profile.value?.id.toString());
    print(widget.agentId);
    // _profileController.profile.value?.id == 4334;

    print("000000000000000");
    print("lead data ${c.lead.value?.lead.toJson()}");
    print("lead agent Id 7657657 ${c.lead.value?.lead.agentId}");
    print(_profileController.profile.value?.id.toString());
  }

  @override
  void dispose() {
    noteInputController.dispose();
    super.dispose();
  }

  bool _isMasked(String? value) {
    if (value == null || value.isEmpty) return false;
    return value.contains("*"); // adjust if your mask format is different
  }

  @override
  Widget build(BuildContext context) {
    print(c.statusName);
    setState(() {
      widget.agentId == 819;
    });
    print("lkdjflsdkjf");
    print(widget.agentId);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Obx(
          () => Text(
            c.model?.name ?? 'Lead #${widget.leadId}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: c.refreshLead,
          ),
        ],
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.errorMessage.value != null) {
          return _error(c.errorMessage.value!, c.refreshLead);
        }

        final Lead? lead = c.model;
        if (lead == null) return const Center(child: Text('No data'));

        if (!_schedulesLoaded) {
          _schedulesLoaded = true;
          scheduleController.loadSchedules(widget.leadId);
        }
        print("from uper");
        print(lead.agentId);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _headerCard(lead),
              const SizedBox(height: 16),
              _actionRow(lead),
              const SizedBox(height: 16),
              _contactInfoCard(lead),
              const SizedBox(height: 16),
              _notesAndSchedulesTabView(lead: lead),
              const SizedBox(height: 120),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: _openScheduleBottomSheet,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _headerCard(Lead lead) {
    final statusColor = _hexColor(lead.statuses?.color) ?? Colors.blueGrey;
    final campaignName = c.campaignName;
    final dateStr = lead.date != null
        ? DateFormat('yyyy-MM-dd').format(lead.date!)
        : '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        // border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lead ID
                Text(
                  "Lead ID: ${lead.id}",
                  style: TextStyles.Text14400.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),

                Text(
                  lead.name ?? '-',
                  style: TextStyles.Text18700.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),

                Obx(
                  () => Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _chip(
                        campaignName.isEmpty ? 'No Campaign' : campaignName,
                      ),
                      _chip(
                        'Status: ${c.statusName.trim().isEmpty ? 'None' : c.statusName}',
                        bg: statusColor.withOpacity(.15),
                        fg: statusColor,
                      ),
                      _chip('Date: $dateStr'),
                      if ((lead.priority ?? '').isNotEmpty)
                        _chip('Priority: ${lead.priority}'),
                      if (lead.isFresh == 1)
                        _chip(
                          'Fresh',
                          bg: Colors.green.withOpacity(.15),
                          fg: Colors.green,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Container(
          //   padding: const EdgeInsets.all(6),
          //   decoration: BoxDecoration(
          //     color: statusColor.withOpacity(.15),
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(Icons.circle, color: statusColor, size: 14),
          // ),
        ],
      ),
    );
  }

  Widget _actionRow(Lead lead) {
    final phone = lead.phone ?? lead.altPhone ?? lead.additionalPhone ?? '';
    final name = lead.name ?? '';
    final email = lead.email ?? '';

    return _card(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _actionButton(
              FontAwesomeIcons.whatsapp,
              "WhatsApp",
              () => HyperLinksNew.openWhatsApp(phone, name),
            ),
            _actionButton(Icons.email_outlined, "Email", () {
              print("Opening email: $email");
              HyperLinksNew.openEmail(email, name);
            }),
            _actionButton(Icons.swap_horiz, "Status", _openChangeStatus),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard(Lead lead) {
    final agentName = (c.lead.value?.lead.agents.isNotEmpty ?? false)
        ? (c.lead.value!.lead.agents.first.fullName ?? '—')
        : '—';
    print("slkfsdlfkkdsfkdsfdsf 12121212");
    print(lead.agentId);

    return _card(
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.person, "Assign To", agentName),
            const Divider(),
            // if ()
            _copyRow(
              "Lead Contact",
              _profileController.profile.value!.id != widget.agentId
                  ? Helpers.maskPhoneNumber(lead.phone)
                  : lead.phone,
            ),
            _copyRow(
              "Alternate Contact",
              _profileController.profile.value!.id != widget.agentId
                  ? Helpers.maskPhoneNumber(lead.altPhone)
                  : lead.altPhone,
            ),
            _additionalNumberRow(
              _profileController.profile.value!.id != widget.agentId
                  ? Helpers.maskPhoneNumber(lead.additionalPhone)
                  : lead.additionalPhone,
            ),
            _copyRow(
              "Email",
              _profileController.profile.value!.id != widget.agentId
                  ? Helpers.maskEmail(lead.email)
                  : lead.email,
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesAndSchedulesTabView({required Lead lead}) {
    return DefaultTabController(
      length: 2,
      child: _card(
        Column(
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
              height: 350,
              child: TabBarView(children: [_notesTab(lead), _schedulesTab()]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notesTab(Lead lead) {
    final List<CommentEntry> comments = lead.newComments;

    return Column(
      children: [
        Expanded(
          child: comments.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.note_alt_outlined,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "No notes yet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Add a note below.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final cmt = comments[i];
                    return ListTile(
                      leading: const Icon(Icons.note_alt),
                      title: Text(
                        (cmt.text?.trim().isNotEmpty ?? false)
                            ? cmt.text!.trim()
                            : '—',
                      ),
                      subtitle:
                          (cmt.date != null || (cmt.time?.isNotEmpty ?? false))
                          ? Text(_fmtDateTime(cmt.date, cmt.time))
                          : null,
                    );
                  },
                ),
        ),

        const Divider(height: 1),

        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              // Text field
              Expanded(
                child: TextField(
                  controller: noteInputController,
                  maxLines: 3,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: "Write a note…",
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              Obx(() {
                final loading = notesController.isLoading.value;
                return ElevatedButton.icon(
                  onPressed: loading
                      ? null
                      : () async {
                          final text = noteInputController.text.trim();
                          if (text.isEmpty) {
                            CustomSnackbar.show(
                              title: "Note required",
                              message: "Please type something to save.",
                              type: ToastType.info,
                            );

                            return;
                          }

                          await notesController.addNotes(lead.id!, text);

                          if (!loading) {
                            await c.refreshLead();
                            noteInputController.clear();
                            FocusScope.of(context).unfocus();
                          }
                        },
                  icon: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send, size: 18, color: Colors.white),
                  label: Text(
                    loading ? "Saving…" : "Add",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  String _fmtDateTime(DateTime? d, String? t) {
    final dd = d == null
        ? ''
        : '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final tt = (t ?? '').trim();
    if (dd.isEmpty && tt.isEmpty) return '';
    if (dd.isEmpty) return tt;
    if (tt.isEmpty) return dd;
    return '$dd • $tt';
  }

  Widget _schedulesTab() {
    return Obx(() {
      if (scheduleController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      final list = scheduleController.schedules;
      if (list.isEmpty) return const Center(child: Text('No schedules found.'));
      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final s = list[i];
          return ListTile(
            leading: const Icon(Icons.event_note),
            title: Text(s.planToDo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${s.scheduleDate} • ${s.scheduleTime}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  '${s.comment ?? 'No comment'}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),

            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _openScheduleBottomSheet(existing: s),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => scheduleController.deleteSchedule(s.id),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _card(Widget child) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: child,
  );

  Widget _chip(String label, {Color? bg, Color? fg}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: bg ?? Colors.grey.shade100,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: (fg ?? Colors.grey).withOpacity(.35)),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: fg ?? Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 12.5,
      ),
    ),
  );

  Widget _actionButton(IconData icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor.withOpacity(0.12),
              child: Icon(icon, size: 18, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      );
  Widget _additionalNumberRow(String? value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Additional Number", style: TextStyles.Text13500),
            const SizedBox(width: 6),
            InkWell(
              onTap: () => _promptUpdateAdditionalNumber(value),
              child: const Icon(Icons.edit, size: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),

        Row(
          children: [
            Expanded(
              child: Text(
                (value?.isNotEmpty ?? false) ? value! : '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (value != null)
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: (value.isNotEmpty)
                    ? () async {
                        await Clipboard.setData(ClipboardData(text: value));
                        if (!mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Copied')));
                      }
                    : null,
              ),
            if (value != null)
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.whatsapp,
                  color: Colors.green,
                ),
                onPressed: () => HyperLinksNew.openWhatsApp(
                  Helpers.normalizePhone(value, keepPlus: true),
                  c.model?.name ?? '',
                ),
              ),
            if (value != null)
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                // onPressed: () => _openDialer(value),
                onPressed: () async {
                  await HyperLinksNew.openDialer(
                    Helpers.normalizePhone(value, keepPlus: true),
                  );
                },
              ),
          ],
        ),
      ],
    ),
  );

  void _promptUpdateAdditionalNumber(String? current) {
    final txt = TextEditingController(text: current ?? '');
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      Obx(() {
        final saving = c.isSavingPhone.value;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Update additional number", style: TextStyles.Text18700),
                const SizedBox(height: 12),
                CustomInputField(
                  label: "Additional phone",
                  controller: txt,
                  maxLength: 15,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final s = (v ?? '').trim();
                    if (s.isEmpty) return 'Please enter a number';
                    if (s.length < 6) return 'Number seems too short';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: saving ? null : () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: saving
                            ? null
                            : () async {
                                if (!formKey.currentState!.validate()) return;
                                await c.updateAdditionalPhone(
                                  leadId: widget.leadId,
                                  phone: txt.text.trim(),
                                );
                                Get.back();
                              },
                        child: saving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      }),
      isScrollControlled: true,
    );
  }

  Widget _infoRow(IconData icon, String title, String value) => Row(
    children: [
      Icon(icon, size: 18, color: AppColors.primaryColor),
      const SizedBox(width: 10),
      Text("$title: ", style: TextStyles.Text13500),
      Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
    ],
  );

  Widget _copyRow(String title, String? value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.Text13500),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Text(
                value?.isNotEmpty == true ? value! : '-',
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (value != null && value.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: (value.isEmpty)
                    ? null
                    : () async {
                        await Clipboard.setData(ClipboardData(text: value));
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

  Widget _error(String msg, VoidCallback retry) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 42),
          const SizedBox(height: 12),
          Text(msg, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: retry, child: const Text('Try again')),
        ],
      ),
    ),
  );

  Color? _hexColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    var s = hex.replaceAll('#', '');
    if (s.length == 6) s = 'FF$s';
    final v = int.tryParse(s, radix: 16);
    if (v == null) return null;
    return Color(v);
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
              color: AppColors.primaryColor,
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
              child: ChangeStatusSheet(
                leadId: widget.leadId,
                currentStatusId: c.model?.statuses?.id,
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openScheduleBottomSheet({ScheduleModel? existing}) {
    final isEdit = existing != null;

    final formKey = GlobalKey<FormState>();
    final planToDoController = TextEditingController(
      text: existing?.planToDo ?? 'Meeting',
    );
    final commentController = TextEditingController();
    DateTime selectedDate =
        DateTime.tryParse(existing?.scheduleDate ?? '') ?? DateTime.now();

    final parts = (existing?.scheduleTime ?? '10:00').split(':');
    TimeOfDay selectedTime = TimeOfDay(
      hour: int.tryParse(parts.first) ?? 10,
      minute: int.tryParse(parts.length > 1 ? parts[1] : '00') ?? 0,
    );

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setSheet) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isEdit ? "Edit Schedule" : "Create Schedule",
                    style: TextStyles.Text18700,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365),
                              ),
                            );
                            if (picked != null) {
                              setSheet(() => selectedDate = picked);
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                          label: Text(
                            DateFormat('EEE, MMM d, yyyy').format(selectedDate),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: selectedTime,
                            );
                            if (picked != null) {
                              setSheet(() => selectedTime = picked);
                            }
                          },
                          icon: const Icon(Icons.access_time),
                          label: Text(selectedTime.format(context)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  CustomSelectField<String>(
                    label: "Plan To Do",
                    value: planToDoController.text.isNotEmpty
                        ? planToDoController.text
                        : "Meeting",
                    items: ["Meeting", "Call Back"]
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      planToDoController.text = val ?? "";
                    },
                  ),
                  CustomInputField(
                    label: "Comment (optional)",
                    controller: commentController,
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: isEdit ? "Update" : "Schedule",
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final req = ScheduleRequestModel(
                        leadId: widget.leadId,
                        scheduleDate: DateFormat(
                          'yyyy-MM-dd',
                        ).format(selectedDate),
                        scheduleTime: selectedTime.format(context),
                        planToDo: planToDoController.text.trim(),
                        comment: commentController.text.trim(),
                      );

                      if (isEdit) {
                        await scheduleController.updateSchedule(
                          existing.id,
                          req,
                        );
                      } else {
                        await scheduleController.addSchedule(req);
                      }
                      await scheduleController.loadSchedules(widget.leadId);
                      Get.back();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
