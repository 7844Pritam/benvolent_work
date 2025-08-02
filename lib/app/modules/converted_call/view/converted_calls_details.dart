import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:flutter/material.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';

class ConvertedCallDetailPage extends StatelessWidget {
  final ConvertedCall call;
  const ConvertedCallDetailPage({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(elevation: 0.5, title: Text(call.name)),
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
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Converted Call ID: ${call.id}", style: _labelStyle()),
          const SizedBox(height: 8),
          Text(call.name, style: _boldStyle(fontSize: 20)),
          const SizedBox(height: 4),
          Text(
            "Campaign: ${call.campaign}",
            style: TextStyle(color: AppThemes.backgroundColor),
          ),
          const SizedBox(height: 2),
          Text(
            "Assigned Date: ${call.assignedDate}",
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _actionCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(Icons.chat, "Whatsapp"),
            _actionButton(Icons.swap_horiz, "Change Status"),
            _actionButton(Icons.email, "Email"),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField("Phone Number", call.phone),
            _detailField("Email", call.email),
            _detailField("Campaign", call.campaign),
            _detailField("Status", call.status),
            _detailField("Assigned Date", call.assignedDate),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppThemes.primaryColor.withOpacity(0.15),
          child: Icon(icon, color: AppThemes.primaryColor),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: AppThemes.backgroundColor)),
      ],
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
          Text(value, style: TextStyle(color: AppThemes.backgroundColor)),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      color: Colors.blueAccent,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );
  }

  TextStyle _boldStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemes.backgroundColor,
    );
  }
}
