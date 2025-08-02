import 'package:flutter/material.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:lucide_icons/lucide_icons.dart';

class LeadDetailPage extends StatelessWidget {
  final Lead lead;

  const LeadDetailPage({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(title: Text(lead.name), elevation: 0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _leadHeaderCard(),
            const SizedBox(height: 16),
            _actionCard(),
            const SizedBox(height: 16),
            _contactInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _leadHeaderCard() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lead ID: ${lead.id}", style: _labelStyle()),
            const SizedBox(height: 8),
            Text(lead.name, style: _boldStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(
              "Campaign: ${lead.campaign}",
              style: TextStyle(color: AppThemes.backgroundColor),
            ),
            const SizedBox(height: 2),
            const Text(
              "Lead Date: 2024-05-28",
              style: TextStyle(color: AppThemes.backgroundColor),
            ),
          ],
        ),
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
            _actionButton(Icons.chat, "Whatsapp"),
            _actionButton(Icons.edit, "Change Status"),
            _actionButton(Icons.email, "Messages"),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField("Assign To", "Test Singh"),
            _contactField("Lead Contact", lead.phone),
            _contactField("Alternate Contact", "918853627910"),
            _contactFieldWithIcons("Additional Number", "918853627910"),
            _emailField("Email Id", "test9@gmail.com"),
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

  Widget _contactField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _labelStyle()),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: AppThemes.backgroundColor),
                ),
              ),
              Tooltip(
                message: 'Copy',
                child: IconButton(
                  icon: const Icon(Icons.copy, size: 18),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactFieldWithIcons(String title, String value) {
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
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(color: AppThemes.backgroundColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  LucideIcons.messageCircle,
                  color: Colors.green,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {},
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
              Expanded(
                child: Text(
                  email,
                  style: TextStyle(color: AppThemes.backgroundColor),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 18),
                onPressed: () {},
              ),
            ],
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
