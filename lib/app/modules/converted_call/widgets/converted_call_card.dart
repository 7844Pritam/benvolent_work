import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:flutter/material.dart';

class ConvertedCallCard extends StatelessWidget {
  final ConvertedCall call;
  const ConvertedCallCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            call.name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          _infoRow(Icons.email, call.email),
          _infoRow(Icons.phone, call.phone),
          _infoRow(Icons.business, "Campaign: ${call.campaign}"),
          _infoRow(Icons.flag, "Status: ${call.status}"),
          _infoRow(Icons.calendar_today, "Assigned: ${call.assignedDate}"),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
