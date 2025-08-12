// import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
// import 'package:benevolent_crm_app/app/modules/converted_call/view/change_status_sheet.dart';
// import 'package:benevolent_crm_app/app/modules/others/controller/shedule_controller.dart';
// import 'package:benevolent_crm_app/app/modules/others/modals/schedule_request_model.dart';
// import 'package:benevolent_crm_app/app/modules/others/modals/shedule_modal.dart';
// import 'package:benevolent_crm_app/app/themes/app_color.dart';
// import 'package:benevolent_crm_app/app/themes/text_styles.dart';
// import 'package:benevolent_crm_app/app/utils/validators.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_button.dart';
// import 'package:benevolent_crm_app/app/widgets/custom_input_field.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ConvertedCallDetailPage extends StatefulWidget {
//   final ConvertedCall call;
//   const ConvertedCallDetailPage({super.key, required this.call});

//   @override
//   State<ConvertedCallDetailPage> createState() =>
//       _ConvertedCallDetailPageState();
// }

// class _ConvertedCallDetailPageState extends State<ConvertedCallDetailPage>
//     with SingleTickerProviderStateMixin {
//   late ConvertedCall call;
//   late List<String> notes;
//   final ScheduleController scheduleController = Get.put(ScheduleController());

//   @override
//   void initState() {
//     super.initState();
//     call = widget.call;
//     notes = [
//       "Called & discussed product features.",
//       "Client requested a follow-up in two weeks.",
//       "Sent brochure via email.",
//     ];
//     scheduleController.loadSchedules(call.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: AppColors.primaryColor,
//         title: Text(
//           call.name,
//           style: const TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _headerCard(),
//             const SizedBox(height: 16),
//             _actionRow(),
//             const SizedBox(height: 16),
//             _contactInfoCard(),
//             const SizedBox(height: 16),
//             _notesAndSchedulesTabView(),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _openScheduleBottomSheet(),
//         backgroundColor: AppColors.primaryColor,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _headerCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             backgroundColor: AppColors.primaryColor.withOpacity(0.15),
//             radius: 30,
//             child: Text(
//               call.name[0].toUpperCase(),
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 color: AppColors.primaryColor,
//               ),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(call.name, style: TextStyles.Text18700),
//                 const SizedBox(height: 4),
//                 Wrap(
//                   spacing: 8,
//                   children: [
//                     _infoChip(Icons.phone, call.phone),
//                     _infoChip(Icons.email, call.email),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoChip(IconData icon, String text) {
//     return Chip(
//       backgroundColor: AppColors.primaryColor.withOpacity(0.08),
//       avatar: Icon(icon, size: 16, color: AppColors.primaryColor),
//       label: Text(
//         text,
//         style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
//       ),
//     );
//   }

//   Widget _actionRow() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _actionButton(FontAwesomeIcons.whatsapp, "WhatsApp", _launchWhatsApp),
//           _actionButton(Icons.email_outlined, "Email", _launchEmail),
//           _actionButton(Icons.swap_horiz, "Status", _openChangeStatus),
//         ],
//       ),
//     );
//   }

//   Widget _actionButton(IconData icon, String label, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: AppColors.primaryColor.withOpacity(0.12),
//             child: Icon(icon, size: 18, color: AppColors.primaryColor),
//           ),
//           const SizedBox(height: 8),
//           Text(label, style: TextStyle(fontSize: 12, color: Colors.black54)),
//         ],
//       ),
//     );
//   }

//   Widget _contactInfoCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _infoRow(Icons.flag, "Status", call.status),
//           const Divider(),
//           _infoRow(Icons.campaign, "Campaign", call.campaign),
//         ],
//       ),
//     );
//   }

//   Widget _infoRow(IconData icon, String title, String value) {
//     return Row(
//       children: [
//         Icon(icon, size: 18, color: AppColors.primaryColor),
//         const SizedBox(width: 10),
//         Text("$title: ", style: TextStyles.Text13500),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(color: Colors.black87, fontSize: 14),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _notesAndSchedulesTabView() {
//     return DefaultTabController(
//       length: 2,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: Colors.grey.shade200),
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Column(
//           children: [
//             TabBar(
//               labelColor: AppColors.primaryColor,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: AppColors.primaryColor,
//               tabs: const [
//                 Tab(text: 'Notes'),
//                 Tab(text: 'Schedules'),
//               ],
//             ),
//             SizedBox(
//               height: 250,
//               child: TabBarView(children: [_notesTab(), _schedulesTab()]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _notesTab() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: const Icon(Icons.note_alt),
//           title: Text(
//             notes[index],
//             style: TextStyle(color: Colors.black87, fontSize: 14),
//           ),
//           trailing: IconButton(
//             icon: const Icon(Icons.delete),
//             onPressed: () => setState(() => notes.removeAt(index)),
//           ),
//         );
//       },
//     );
//   }

//   Widget _schedulesTab() {
//     return Obx(() {
//       final list = scheduleController.schedules;
//       if (scheduleController.isLoading.value) {
//         return const Center(child: CircularProgressIndicator());
//       } else if (list.isEmpty) {
//         return const Center(child: Text("No schedules found."));
//       }
//       return ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: list.length,
//         itemBuilder: (context, index) {
//           final item = list[index];
//           return ListTile(
//             leading: const Icon(Icons.event_note),
//             title: Text(
//               item.planToDo,
//               style: TextStyle(color: Colors.black87, fontSize: 14),
//             ),
//             subtitle: Text(
//               "${item.scheduleDate} • ${item.scheduleTime}",
//               style: TextStyle(fontSize: 12, color: Colors.black54),
//             ),
//             trailing: Wrap(
//               spacing: 8,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit),
//                   onPressed: () => _openScheduleBottomSheet(existing: item),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete),
//                   onPressed: () => scheduleController.deleteSchedule(item.id),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     });
//   }

//   void _openScheduleBottomSheet({ScheduleModel? existing}) {
//     final isEdit = existing != null;
//     bool dateError = false;
//     bool timeError = false;

//     final TextEditingController planToDoController = TextEditingController(
//       text: existing?.planToDo ?? '',
//     );
//     DateTime selectedDate =
//         DateTime.tryParse(existing?.scheduleDate ?? '') ?? DateTime.now();
//     TimeOfDay selectedTime = TimeOfDay(
//       hour: int.tryParse(existing?.scheduleTime.split(":")[0] ?? "10") ?? 10,
//       minute: int.tryParse(existing?.scheduleTime.split(":")[1] ?? "00") ?? 0,
//     );
//     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//     Get.bottomSheet(
//       StatefulBuilder(
//         builder: (context, setState) {
//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     isEdit ? "Edit Schedule" : "Create Schedule",
//                     style: TextStyles.Text18700,
//                   ),
//                   const SizedBox(height: 12),
//                   CustomInputField(
//                     label: "Plan To Do",
//                     controller: planToDoController,
//                     validator: (value) => Validators.validateEmpty(
//                       value,
//                       fieldName: "Plan To Do",
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Date & Time Pickers with selected values
//                   Row(
//                     children: [
//                       Expanded(
//                         child: TextButton.icon(
//                           onPressed: () async {
//                             final picked = await showDatePicker(
//                               context: context,
//                               initialDate: selectedDate,
//                               firstDate: DateTime.now().subtract(
//                                 const Duration(days: 365),
//                               ),
//                               lastDate: DateTime.now().add(
//                                 const Duration(days: 365),
//                               ),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 selectedDate = picked;
//                               });
//                             }
//                           },
//                           icon: const Icon(Icons.calendar_month),
//                           label: Text(
//                             DateFormat('EEE, MMM d, yyyy').format(selectedDate),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: TextButton.icon(
//                           onPressed: () async {
//                             final picked = await showTimePicker(
//                               context: context,
//                               initialTime: selectedTime,
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 selectedTime = picked;
//                               });
//                             }
//                           },
//                           icon: const Icon(Icons.access_time),
//                           label: Text(
//                             selectedTime.format(context),
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (dateError || timeError) ...[
//                     const SizedBox(height: 8),
//                     if (dateError)
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Please select a valid date",
//                           style: TextStyle(
//                             color: Colors.red.shade600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     if (timeError)
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Text(
//                           "Please select a valid time",
//                           style: TextStyle(
//                             color: Colors.red.shade600,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                   ],

//                   const SizedBox(height: 12),

//                   CustomButton(
//                     text: isEdit ? "Update" : "Create",
//                     onPressed: () async {
//                       if (!_formKey.currentState!.validate()) return;
//                       if (selectedDate == null || selectedTime == null) {
//                         setState(() {
//                           dateError = selectedDate == null;
//                           timeError = selectedTime == null;
//                         });
//                         return;
//                       }

//                       try {
//                         final model = ScheduleRequestModel(
//                           leadId: 591,
//                           scheduleDate: selectedDate
//                               .toString()
//                               .split(" ")
//                               .first,
//                           scheduleTime: selectedTime.format(context),
//                           planToDo: planToDoController.text.trim(),
//                         );
//                         if (isEdit) {
//                           await scheduleController.updateSchedule(
//                             existing.id,
//                             model,
//                           );
//                         } else {
//                           await scheduleController.addSchedule(model);
//                         }
//                         Get.back(); // close sheet after success
//                       } catch (e) {
//                         print(e);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       isScrollControlled: true,
//     );
//   }

//   void _launchWhatsApp() {
//     final url = Uri.parse("https://wa.me/${call.phone}?text=Hi ${call.name},");
//     launchUrl(url);
//   }

//   void _launchEmail() {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: call.email,
//       query: 'subject=Follow-up&body=Hi ${call.name},',
//     );
//     launchUrl(emailUri);
//   }

//   void _openChangeStatus() {
//     Get.bottomSheet(
//       DraggableScrollableSheet(
//         initialChildSize: 0.5,
//         minChildSize: 0.3,
//         maxChildSize: 0.9,
//         expand: false,
//         builder: (_, scrollController) {
//           return Container(
//             decoration: const BoxDecoration(
//               color: AppColors.primaryColor,
//               borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//             ),
//             child: SingleChildScrollView(
//               controller: scrollController,
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
//                 left: 16,
//                 right: 16,
//                 top: 16,
//               ),
//               child: ChangeStatusSheet(callId: call.id),
//             ),
//           );
//         },
//       ),
//       isScrollControlled: true,
//       enableDrag: true,
//       backgroundColor: Colors.transparent,
//     );
//   }
// }
