import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_card.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_shimmer.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
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
            onPressed: () => Get.to(FilterPage(flag: "fromColdCalls")),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => ConvertedCallsPage());
        },
        icon: const Icon(Icons.swap_horiz),
        label: const Text("Converted Calls"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (_, __) => const ColdCallShimmer(),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (!_controller.isPaginating.value &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent &&
                _controller.canLoadMore) {
              _controller.fetchColdCalls();
            }
            return false;
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _controller.coldCalls.length + 1,
            itemBuilder: (context, index) {
              if (index < _controller.coldCalls.length) {
                final call = _controller.coldCalls[index];
                return ColdCallCard(call: call);
              } else if (_controller.isPaginating.value) {
                return const Column(
                  children: [ColdCallShimmer(), ColdCallShimmer()],
                );
              } else if (!_controller.canLoadMore) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: Text('No more cold calls')),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      }),
    );
  }
}
