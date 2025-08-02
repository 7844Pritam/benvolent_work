import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_details.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/widgets/converted_call_card.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controller/converted_call_controller.dart';

class ConvertedCallsPage extends StatelessWidget {
  final ConvertedCallController _controller = Get.put(
    ConvertedCallController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,

        centerTitle: true,
        title: const Text(
          "Converted Calls",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),

        actions: [
          IconButton(
            icon: const Icon(LucideIcons.filter, color: Colors.white),
            onPressed: () =>
                Get.to(() => const FilterPage(flag: "fromConvertedCalls")),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (!_controller.isPaginating.value &&
                scroll.metrics.pixels == scroll.metrics.maxScrollExtent &&
                _controller.canLoadMore) {
              _controller.fetchCalls();
            }
            return false;
          },
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount:
                _controller.calls.length +
                (_controller.isPaginating.value || !_controller.canLoadMore
                    ? 1
                    : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index < _controller.calls.length) {
                return GestureDetector(
                  onTap: () => Get.to(
                    () =>
                        ConvertedCallDetailPage(call: _controller.calls[index]),
                  ),
                  child: ConvertedCallCard(call: _controller.calls[index]),
                );
              } else if (_controller.isPaginating.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      "No more converted calls",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
