import 'package:benevolent_crm_app/app/modules/cold_calls/views/cold_calls_details_page.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_card.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_shimmer.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controllers/cold_call_controller.dart';

class ColdCallPage extends StatelessWidget {
  final ColdCallController _controller = Get.put(ColdCallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Cold Calls', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.filter),
            onPressed: () => Get.to(() => FilterPage(flag: "fromColdCalls")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => ConvertedCallsPage()),
        icon: const Icon(Icons.swap_horiz),
        label: const Text("Converted Calls"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (_, __) => const ColdCallShimmer(),
          );
        }

        final dateKeys = _controller.groupedDateKeys;
        final grouped = _controller.groupedCalls;

        // Build flat list: [Header, items..., Header, items..., footer]
        final widgets = <Widget>[];
        for (final key in dateKeys) {
          widgets.add(_DateHeader(label: key));
          final items = grouped[key] ?? const [];
          for (final call in items) {
            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () => Get.to(() => ColdCallDetailPage(call: call)),
                  child: ColdCallCard(call: call), // updated to show icons
                ),
              ),
            );
          }
        }

        if (_controller.isPaginating.value) {
          widgets.add(
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [
                  ColdCallShimmer(),
                  SizedBox(height: 8),
                  ColdCallShimmer(),
                ],
              ),
            ),
          );
        } else if (!_controller.canLoadMore) {
          widgets.add(
            const Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 74,
              ),
              child: Center(child: Text('No more cold calls')),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!_controller.isPaginating.value &&
                scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent - 80 &&
                _controller.canLoadMore) {
              _controller.fetchColdCalls();
            }
            return false;
          },
          child: ListView(padding: EdgeInsets.zero, children: widgets),
        );
      }),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;
  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 12),
              child: Divider(height: 1),
            ),
          ),
        ],
      ),
    );
  }
}
