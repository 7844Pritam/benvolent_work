import 'package:flutter/material.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';

class ColdCallDetailPage extends StatelessWidget {
  final ColdCall call;

  const ColdCallDetailPage({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(call.name),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
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
            _detailsCard(),
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Cold Call ID: ${call.id}", style: _labelStyle()),
          const SizedBox(height: 8),
          Text(call.name, style: _boldStyle(fontSize: 20)),
          const SizedBox(height: 6),
          Text(
            "Status: ${call.status}",
            style: TextStyle(color: AppThemes.backgroundColor),
          ),
          Text(
            "Date: ${call.date}",
            style: TextStyle(color: AppThemes.backgroundColor),
          ),
        ],
      ),
    );
  }

  Widget _actionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(Icons.call, "Call"),
            _actionButton(Icons.edit, "Change Status"),
            _actionButton(Icons.message, "Message"),
          ],
        ),
      ),
    );
  }

  Widget _detailsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField("Agent", call.agent),
            _detailField("Phone", call.phone),
            _detailField("Source", call.source),
            _detailField("Campaign", call.date),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
          child: Icon(icon, color: AppThemes.primaryColor),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: AppThemes.backgroundColor)),
      ],
    );
  }

  Widget _detailField(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Text(
            value ?? "-",
            style: TextStyle(color: AppThemes.backgroundColor),
          ),
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
