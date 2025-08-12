import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_details.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/widgets/converted_call_card.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../controller/converted_call_controller.dart';

class ConvertedCallsPage extends StatelessWidget {
  final ConvertedCallController _controller = Get.put(
    ConvertedCallController(),
  );

  ConvertedCallsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 52,
        backgroundColor: AppColors.primaryColor,
        title: const Text(
          'Converted Calls',
          style: TextStyle(color: Colors.white),
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 6,
            itemBuilder: (_, __) => const _CardShimmer(),
          );
        }

        // Build a flat list of widgets: [Header, items..., Header, items..., footer]
        final List<Widget> slotted = [];

        final grouped = _groupCallsByDate(_controller.calls);
        final dateKeys = _sortedDateKeys(grouped);

        for (final key in dateKeys) {
          // Date header
          slotted.add(_DateHeader(label: key));

          // Items under the date
          final items = grouped[key] ?? const <ConvertedCall>[];
          for (final call in items) {
            slotted.add(
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () =>
                      Get.to(() => ConvertedCallDetailPage(leadId: call.id)),
                  child: ConvertedCallCard(
                    call: call,
                  ), // already includes action chips
                ),
              ),
            );
          }
        }

        // Pagination footer region
        if (_controller.isPaginating.value) {
          slotted.add(
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Column(
                children: [_CardShimmer(), SizedBox(height: 8), _CardShimmer()],
              ),
            ),
          );
        } else if (!_controller.canLoadMore) {
          slotted.add(
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No more converted calls",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!_controller.isPaginating.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 80 &&
                      _controller.canLoadMore) {
                    _controller.fetchCalls();
                  }
                  return false;
                },
                child: ListView(padding: EdgeInsets.zero, children: slotted),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.fetchCalls(),
        child: const Icon(Icons.refresh),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Map<String, List<ConvertedCall>> _groupCallsByDate(
    List<ConvertedCall> calls,
  ) {
    final Map<String, List<ConvertedCall>> grouped = {};
    for (var call in calls) {
      final dt =
          _parseDateFlexible(call.createdDate) ??
          _parseDateFlexible(call.assignedDate) ??
          DateTime.now();
      final key = DateFormat('dd/MM/yyyy').format(dt);
      (grouped[key] ??= []).add(call);
    }

    grouped.forEach((_, list) {
      list.sort((a, b) {
        final da =
            _parseDateFlexible(a.createdDate) ??
            _parseDateFlexible(a.assignedDate) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        final db =
            _parseDateFlexible(b.createdDate) ??
            _parseDateFlexible(b.assignedDate) ??
            DateTime.fromMillisecondsSinceEpoch(0);
        return db.compareTo(da);
      });
    });

    return grouped;
  }

  List<String> _sortedDateKeys(Map<String, List<ConvertedCall>> grouped) {
    final keys = grouped.keys.toList();
    keys.sort((a, b) {
      final da = DateFormat('dd/MM/yyyy').parse(a);
      final db = DateFormat('dd/MM/yyyy').parse(b);
      return db.compareTo(da);
    });
    return keys;
  }

  DateTime? _parseDateFlexible(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final isoCandidate = raw.contains(' ') ? raw.replaceFirst(' ', 'T') : raw;
      final dt = DateTime.tryParse(isoCandidate);
      if (dt != null) return dt;
    } catch (_) {}
    for (final f in [
      DateFormat('yyyy-MM-dd HH:mm:ss'),
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd/MM/yyyy'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM/dd/yyyy'),
    ]) {
      try {
        return f.parseStrict(raw);
      } catch (_) {}
    }
    return null;
  }
}

// Simple shimmer placeholder for converted call cards (to mirror LeadCardShimmer)
class _CardShimmer extends StatelessWidget {
  const _CardShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      height: 100,
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
                fontWeight: FontWeight.w600,
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
