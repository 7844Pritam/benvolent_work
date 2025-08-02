import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      "title": "Lead Assigned",
      "message": "You have a new lead assigned: John Doe",
      "time": "Just now",
      "icon": LucideIcons.userPlus,
    },
    {
      "title": "Call Reminder",
      "message": "Follow up with Alice Singh at 3:00 PM today.",
      "time": "1 hr ago",
      "icon": LucideIcons.phoneCall,
    },
    {
      "title": "Campaign Update",
      "message": "Summer Campaign has been updated.",
      "time": "Yesterday",
      "icon": LucideIcons.refreshCw,
    },
    {
      "title": "New Message",
      "message": "You received a new message from the admin.",
      "time": "2 days ago",
      "icon": LucideIcons.mail,
    },
    {
      "title": "Status Changed",
      "message": "Lead Sarah Sharma status changed to 'Interested'.",
      "time": "2 days ago",
      "icon": LucideIcons.edit2,
    },
    {
      "title": "Cold Call Added",
      "message": "Cold call added for Ankit Yadav.",
      "time": "3 days ago",
      "icon": LucideIcons.plusCircle,
    },
    {
      "title": "Follow Up Missed",
      "message": "You missed a follow-up with Ravi Mehta.",
      "time": "3 days ago",
      "icon": LucideIcons.alertCircle,
    },
    {
      "title": "New Comment",
      "message": "A comment was added to lead #2580.",
      "time": "4 days ago",
      "icon": LucideIcons.messageCircle,
    },
    {
      "title": "Lead Converted",
      "message": "Lead 'Priya Verma' has been converted.",
      "time": "5 days ago",
      "icon": LucideIcons.checkCircle,
    },
    {
      "title": "System Maintenance",
      "message": "Scheduled maintenance on Aug 5, 10 PM.",
      "time": "6 days ago",
      "icon": LucideIcons.settings,
    },
    {
      "title": "Reminder Set",
      "message": "Reminder set for follow-up with Aditya.",
      "time": "1 week ago",
      "icon": LucideIcons.clock,
    },
    {
      "title": "Account Synced",
      "message": "Google account successfully synced.",
      "time": "1 week ago",
      "icon": LucideIcons.check,
    },
    {
      "title": "New Login",
      "message": "Your account was accessed from a new device.",
      "time": "1 week ago",
      "icon": LucideIcons.monitor,
    },
    {
      "title": "Lead Archived",
      "message": "Old lead 'Neha Kapoor' has been archived.",
      "time": "1 week ago",
      "icon": LucideIcons.archive,
    },
    {
      "title": "Monthly Report",
      "message": "Your performance report is ready to view.",
      "time": "2 weeks ago",
      "icon": LucideIcons.barChart2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _notifications[index];
          return _buildNotificationCard(item);
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppThemes.primaryColor.withOpacity(0.1),
            child: Icon(item["icon"], color: AppThemes.primaryColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["title"],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item["message"],
                  style: const TextStyle(fontSize: 14.2, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  item["time"],
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
