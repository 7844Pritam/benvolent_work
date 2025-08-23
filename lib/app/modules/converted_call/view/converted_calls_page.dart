import 'package:benevolent_crm_app/app/modules/converted_call/modal/converted_call_model.dart';
import 'package:benevolent_crm_app/app/modules/others/screens/leads_details_page.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/widgets/converted_call_card.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
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
  final FiltersController _filters = Get.isRegistered<FiltersController>()
      ? Get.find<FiltersController>()
      : Get.put(FiltersController(), permanent: true);

  ConvertedCallsPage({super.key});
  List<Widget> _buildActiveFilterChips(BuildContext context) {
    final f = _controller.currentFilters.value;
    final chips = <Widget>[];

    if (f.agentId.isNotEmpty) {
      chips.add(
        _chip('Agent: ${f.agentId}', () => _controller.removeTag('agent_id')),
      );
    }
    if (f.fromDate.isNotEmpty || f.toDate.isNotEmpty) {
      final label =
          'Date: ${f.fromDate.isEmpty ? '...' : f.fromDate} → ${f.toDate.isEmpty ? '...' : f.toDate}';
      chips.add(_chip(label, () => _controller.removeTag('date_range')));
    }
    if (f.status.isNotEmpty) {
      final ids = f.status.split(',').where((e) => e.isNotEmpty).map(int.parse);
      for (final id in ids) {
        final name =
            _filters.statusList.firstWhereOrNull((s) => s.id == id)?.name ??
            'Status $id';
        chips.add(_chip(name, () => _controller.removeTag('status', id: id)));
      }
    }
    if (f.campaign.isNotEmpty) {
      final ids = f.campaign
          .split(',')
          .where((e) => e.isNotEmpty)
          .map(int.parse);
      for (final id in ids) {
        final name =
            _filters.campaignList.firstWhereOrNull((c) => c.id == id)?.name ??
            'Campaign $id';
        chips.add(_chip(name, () => _controller.removeTag('campaign', id: id)));
      }
    }
    if (f.source.isNotEmpty) {
      final ids = f.source.split(',').where((e) => e.isNotEmpty).map(int.parse);
      for (final id in ids) {
        final name =
            _filters.sourceList.firstWhereOrNull((s) => s.id == id)?.name ??
            'Source $id';
        chips.add(_chip(name, () => _controller.removeTag('source', id: id)));
      }
    }
    if (f.isFresh.isNotEmpty) {
      chips.add(
        _chip(
          'Fresh: ${f.isFresh == '1' ? 'Yes' : 'No'}',
          () => _controller.removeTag('is_fresh'),
        ),
      );
    }
    if (f.keyword.isNotEmpty) {
      chips.add(
        _chip('“${f.keyword}”', () => _controller.removeTag('keyword')),
      );
    }
    return chips;
  }

  Widget _chip(String label, VoidCallback onDeleted) {
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.close, size: 18),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

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
          Obx(
            () => Text(
              _controller.totalCount.value > 0
                  ? '(${_controller.totalCount.value})'
                  : 'No Calls',
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.filter, color: Colors.white),
            onPressed: () =>
                Get.to(() => const FilterPage(flag: "fromConvertedCalls")),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.fetchCalls(initial: true),
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

        // build chips
        final chips = _buildActiveFilterChips(context);

        // Build a flat list of widgets
        final List<Widget> slotted = [];

        // ✅ show chips at the top when filters are active
        if (chips.isNotEmpty) {
          slotted.add(
            _FilterChipsBar(chips: chips, onClear: _controller.clearFilters),
          );
        }

        final grouped = _groupCallsByDate(_controller.calls);
        final dateKeys = _sortedDateKeys(grouped);

        for (final key in dateKeys) {
          slotted.add(_DateHeader(label: key));
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
                  child: ConvertedCallCard(call: call),
                ),
              ),
            );
          }
        }

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

class _FilterChipsBar extends StatelessWidget {
  final List<Widget> chips;
  final Future<void> Function() onClear;
  const _FilterChipsBar({required this.chips, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(child: Wrap(spacing: 8, runSpacing: 6, children: chips)),
          if (chips.isNotEmpty)
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.filter_alt_off),
              label: const Text('Clear'),
            ),
        ],
      ),
    );
  }
}
