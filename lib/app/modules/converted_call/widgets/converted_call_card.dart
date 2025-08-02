import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConvertedCallCard extends StatelessWidget {
  final ConvertedCall call;
  const ConvertedCallCard({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedDate = _formatDate(call.assignedDate);
    final initials = _getInitials(call.name);

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        call.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        call.email,
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(call.status),
              ],
            ),
            const SizedBox(height: 16),

            // Info Rows
            Wrap(
              runSpacing: 10,
              children: [
                _infoRow(Icons.phone_outlined, call.phone),
                _infoRow(Icons.campaign_outlined, "Campaign: ${call.campaign}"),
                _infoRow(
                  Icons.calendar_today_outlined,
                  "Assigned: $formattedDate",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: Colors.blueAccent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14.2, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hot':
        return Colors.redAccent;
      case 'interested':
        return Colors.green;
      case 'cold':
        return Colors.blueGrey;
      case 'junk':
        return Colors.grey;
      case 'new lead':
        return Colors.deepPurple;
      default:
        return Colors.blue;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'hot':
        return Icons.whatshot;
      case 'interested':
        return Icons.thumb_up_alt;
      case 'cold':
        return Icons.ac_unit;
      case 'junk':
        return Icons.delete;
      case 'new lead':
        return Icons.fiber_new;
      default:
        return Icons.label;
    }
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat.yMMMEd().format(date); // e.g., Aug 2, 2025
    } catch (_) {
      return rawDate;
    }
  }

  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length >= 2) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "?";
  }
}
