import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:benevolent_crm_app/app/modules/leads/modals/leads_response.dart';

class AllLeadsPage extends StatelessWidget {
  final LeadsController _controller = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Leads')),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.leads.isEmpty) {
          return const Center(child: Text("No leads found."));
        }

        return ListView.builder(
          itemCount: _controller.leads.length,
          itemBuilder: (context, index) {
            Lead lead = _controller.leads[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(lead.name.isNotEmpty ? lead.name[0] : '?'),
                ),
                title: Text(lead.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${lead.email}"),
                    Text("Phone: ${lead.phone}"),
                    Text("Priority: ${lead.priority}"),
                    if (lead.statuses != null)
                      Text("Status: ${lead.statuses?.name}"),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Optional: navigate to lead details
                  // Get.to(() => LeadDetailPage(lead: lead));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
