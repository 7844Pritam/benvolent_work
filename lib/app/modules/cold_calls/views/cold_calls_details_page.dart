import 'package:flutter/material.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/modals/cold_call_model.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ColdCallDetailPage extends StatelessWidget {
  final ColdCall call;

  const ColdCallDetailPage({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(call.name, style: TextStyle(color: Colors.white)),
        elevation: 0.5,
        backgroundColor: AppThemes.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerSection(),
            const SizedBox(height: 16),
            _actionSection(),
            const SizedBox(height: 16),
            _detailsSection(),
          ],
        ),
      ),
    );
  }

  Widget _headerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.person, size: 40, color: AppThemes.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cold Call ID: ${call.id}", style: _labelStyle()),
                const SizedBox(height: 6),
                Text(call.name, style: _boldStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text("Status: ${call.status}", style: _valueStyle()),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text("Date: ${call.date}", style: _valueStyle()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(Icons.call, "Call"),
          _actionButton(Icons.edit, "Status"),
          _actionButton(Icons.message, "Message"),
        ],
      ),
    );
  }

  Widget _detailsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailField(Icons.person_outline, "Agent", call.agent),
          _detailField(Icons.phone, "Phone", call.phone),
          _detailField(FontAwesomeIcons.bullhorn, "Source", call.source),
          _detailField(Icons.campaign, "Campaign", call.date),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: AppThemes.primaryColor.withOpacity(0.15),
          child: Icon(icon, color: AppThemes.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: _valueStyle()),
      ],
    );
  }

  Widget _detailField(IconData icon, String title, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppThemes.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _labelStyle()),
                const SizedBox(height: 4),
                Text(value ?? "-", style: _valueStyle()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _labelStyle() {
    return const TextStyle(
      color: AppThemes.primaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 13,
    );
  }

  TextStyle _boldStyle({double fontSize = 16}) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppThemes.backgroundColor,
    );
  }

  TextStyle _valueStyle() {
    return const TextStyle(color: Colors.black87, fontSize: 14);
  }
}
