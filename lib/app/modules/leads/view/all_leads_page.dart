import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/widget/lead_card.dart';
import 'package:benevolent_crm_app/app/modules/leads/widget/lead_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';

class AllLeadsPage extends StatelessWidget {
  final LeadsController _controller = Get.put(LeadsController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 52,
        title: const Text('All Leads', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.filter, color: Colors.white),
            onPressed: () => Get.to(FilterPage(flag: "fromAllLeads")),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (_, __) => const LeadCardShimmer(),
          );
        }

        return Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  hintText: 'Search leads, agents, locations...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 🔽 Sort option
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    "Sort by:",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showSortPopup(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "High to Low",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📄 List
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!_controller.isPaginating.value &&
                      scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      _controller.canLoadMore) {
                    _controller.fetchLeads();
                  }
                  return false;
                },
                child: Obx(
                  () => ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: _controller.leads.length + 1,
                    itemBuilder: (context, index) {
                      if (index < _controller.leads.length) {
                        final lead = _controller.leads[index];
                        return LeadCard(lead: lead);
                      } else if (_controller.isPaginating.value) {
                        return const Column(
                          children: [LeadCardShimmer(), LeadCardShimmer()],
                        );
                      } else if (!_controller.canLoadMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Text(
                              "No more leads available",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showSortPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sort by"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: const Text("High to Low"), onTap: () => Get.back()),
            ListTile(title: const Text("Low to High"), onTap: () => Get.back()),
          ],
        ),
      ),
    );
  }
}
