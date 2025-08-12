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
      appBar: AppBar(
        title: Text(lead.name, style: const TextStyle(color: Colors.white)),
        elevation: 0.5,
        backgroundColor: AppThemes.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lead ID: ${lead.id}", style: _labelStyle()),
            const SizedBox(height: 8),
            Text(lead.name, style: _boldStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text("Campaign: ${lead.id}", style: _valueStyle()),
            const SizedBox(height: 2),
            const Text(
              "Lead Date: 2024-05-28",
              style: TextStyle(color: Colors.grey),
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _actionButton(Icons.chat, "Whatsapp", onTap: () {}),
            _actionButton(Icons.edit, "Change Status", onTap: () {}),
            _actionButton(Icons.email, "Messages", onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _contactInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _detailField("Assign To", "Test Singh"),
            _contactField("Lead Contact", lead.name),
            _contactField("Alternate Contact", "918853627910"),
            _contactFieldWithIcons("Additional Number", "918853627910"),
            _emailField("Email Id", "test9@gmail.com"),
          ],
        ),
      ),
    );
  }

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
              Expanded(child: Text(value, style: _valueStyle())),
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
              Expanded(child: Text(value, style: _valueStyle())),
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
              Expanded(child: Text(email, style: _valueStyle())),
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

  TextStyle _valueStyle() {
    return TextStyle(color: AppThemes.backgroundColor, fontSize: 14);
  }
}
