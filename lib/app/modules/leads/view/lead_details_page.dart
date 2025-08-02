import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';

class LeadDetailsPage extends StatelessWidget {
  final Lead lead;

  const LeadDetailsPage({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lead: ${lead.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetail("Name", lead.name),
                _buildDetail("Email", lead.email),
                _buildDetail("Phone", lead.phone),

                const SizedBox(height: 16),
                ...[
                  const Text(
                    "Campaign Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppThemes.lightGrey,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  "Agents Assigned",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: AppThemes.lightGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppThemes.backgroundColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppThemes.backgroundColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
