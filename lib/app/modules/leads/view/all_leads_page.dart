import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/modules/leads/view/lead_details_page.dart';
import 'package:benevolent_crm_app/app/themes/app_themes.dart';
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
            return GestureDetector(
              onTap: () {
                Get.to(() => LeadDetailsPage(lead: lead));
              },
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lead ID : ${lead.id}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lead.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppThemes.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.group, color: Colors.red, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            "Test Singh",
                            style: TextStyle(color: AppThemes.primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.campaign, color: Colors.green, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            lead.phone,
                            style: TextStyle(color: AppThemes.primaryColor),
                          ), // or lead.campaignName
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.message_outlined,
                                size: 16,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                lead.statuses?.name ?? "No Status",
                                style: TextStyle(
                                  color: lead.statuses?.name == 'No Answer'
                                      ? Colors.red
                                      : Colors.orange,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // handle accept
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Accept',
                              style: TextStyle(color: AppThemes.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
