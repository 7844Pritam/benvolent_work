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
                _buildDetail("Priority", lead.priority),
                _buildDetail("Status", lead.statuses?.name ?? "N/A"),
                _buildDetail("Status Color", lead.statuses?.color ?? "N/A"),
                _buildDetail("Lead ID", lead.leadId),
                _buildDetail("Date", lead.date ?? "N/A"),
                _buildDetail("Type", lead.type),
                const SizedBox(height: 16),
                if (lead.campaign != null) ...[
                  const Text(
                    "Campaign Info",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: AppThemes.lightGrey,
                    ),
                  ),
                  _buildDetail("Campaign Name", lead.campaign!.name),
                  _buildDetail("Secondary Name", lead.campaign!.secondaryName),
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
                ...lead.agents.map(
                  (agent) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetail(
                          "Agent Name",
                          "${agent.firstName} ${agent.lastName}",
                        ),
                        _buildDetail("Email", agent.email),
                        _buildDetail("Phone", agent.phone.toString()),
                        _buildDetail("Department", agent.department),
                        _buildDetail("Status", agent.status),
                        const Divider(),
                      ],
                    ),
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
