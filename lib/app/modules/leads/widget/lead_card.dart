import 'package:benevolent_crm_app/app/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modals/leads_response.dart';
import '../view/lead_detail_page.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  const LeadCard({super.key, required this.lead});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Get.to(() => LeadDetailPage(lead: lead)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '#${lead.id}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
                _buildStatusTag(lead.lead.status.toString()),
              ],
            ),

            const SizedBox(height: 10),

            // 🧑 Lead Name
            Text(
              lead.lead.name,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            // 📄 Details
            _infoRow(Icons.person_outline, "Agent", lead.lead.agentName),
            _infoRow(Icons.phone, "Phone", lead.lead.phone),
            _infoRow(
              Icons.location_on_outlined,
              "Campaign",
              lead.lead.compaignId.toString(),
            ),
            _infoRow(
              Icons.calendar_month_outlined,
              "Date",
              lead.lead.date ?? "-",
            ),

            // 📎 View Details Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => Get.to(() => LeadDetailPage(lead: lead)),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text("View Details"),
                style: TextButton.styleFrom(
                  foregroundColor: AppThemes.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTag(String status) {
    final styles = {
      "New Lead": [Colors.orange.shade50, Colors.deepOrange],
      "Low Budget": [Colors.green.shade50, Colors.green.shade800],
      "Hot Lead": [Colors.red.shade50, Colors.red],
      "Premium": [Colors.deepPurple.shade50, Colors.deepPurple],
      "Urgent": [Colors.orange.shade50, Colors.orange],
    };
    final colors =
        styles[status] ?? [Colors.grey.shade100, Colors.grey.shade700];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors[0],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors[1], width: 0.6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: colors[1],
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
