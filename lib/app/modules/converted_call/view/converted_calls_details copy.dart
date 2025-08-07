import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/change_status_sheet.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

class ConvertedCallDetailPage extends StatelessWidget {
  final ConvertedCall call;
  const ConvertedCallDetailPage({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0.5,
        title: Text(call.name, style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerCard(),
            const SizedBox(height: 16),
            _actionCard(),
            const SizedBox(height: 16),
            _contactInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _headerCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(
              Icons.person_outline,
              size: 40,
              color: AppColors.primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Converted Call ID: ${call.id}", style: _labelStyle()),
                  const SizedBox(height: 4),
                  Text(call.name, style: _boldStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.campaign_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text("Campaign: ${call.campaign}", style: _valueStyle()),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.date_range_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Assigned: ${call.assignedDate}",
                        style: _valueStyle(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(FontAwesomeIcons.whatsapp, "Whatsapp"),
            _actionButton(Icons.swap_horiz, "Change Status"),
            _actionButton(Icons.email_outlined, "Email"),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField(Icons.phone, "Phone Number", call.phone),
            _detailField(Icons.email, "Email", call.email),
            _detailField(Icons.campaign, "Campaign", call.campaign),
            _detailField(Icons.flag_outlined, "Status", call.status),
            _detailField(
              Icons.calendar_today,
              "Assigned Date",
              call.assignedDate,
            ),
          ],
        ),
      ),
    );
  }

  // Widget _actionButton(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 24,
  //         backgroundColor: AppColors.primaryColor.withOpacity(0.15),
  //         child: Icon(icon, color: AppColors.primaryColor),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(label, style: _valueStyle()),
  //     ],
  //   );
  // }
  Widget _actionButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        if (label == "Whatsapp") {
          final url = Uri.parse(
            "https://wa.me/${call.phone}?text=Hi ${call.name},",
          );
          launchUrl(url);
        } else if (label == "Email") {
          final Uri emailUri = Uri(
            scheme: 'mailto',
            path: call.email,
            query: 'subject=Follow-up&body=Hi ${call.name},',
          );
          launchUrl(emailUri);
        } else if (label == "Change Status") {
          Get.bottomSheet(
            DraggableScrollableSheet(
              initialChildSize: 0.5, // start at 50% height
              minChildSize: 0.3, // minimum height
              maxChildSize: 0.9, // maximum height
              expand: false,
              builder: (_, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(0, 255, 255, 255),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryColor.withOpacity(0.15),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: _valueStyle()),
        ],
      ),
    );
  }

  Widget _detailField(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
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
        ],
      ),
    );
  }

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
}
