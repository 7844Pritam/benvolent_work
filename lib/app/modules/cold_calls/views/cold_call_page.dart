import 'package:benevolent_crm_app/app/modules/cold_calls/controllers/cold_call_controller.dart';

import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_card.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_shimmer.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:collection/collection.dart';

class ColdCallPage extends StatelessWidget {
  ColdCallPage({super.key});

  final ColdCallController _controller = Get.put(ColdCallController());
  final FiltersController _filters = Get.isRegistered<FiltersController>()
      ? Get.find<FiltersController>()
      : Get.put(FiltersController(), permanent: true);

  List<Widget> _buildActiveFilterChips() {
    final f = _controller.currentFilters.value;
    final chips = <Widget>[];

    // if (f.agentId.isNotEmpty) {
    //   chips.add(
    //     _chip('Agent: ${f.agentId}', () {
    //       _controller.removeTag('agent_id');
    //     }),
    //   );
    // }
    if (f.agentId.isNotEmpty) {
      final ids = f.agentId.split(',').where((e) => e.trim().isNotEmpty);
      for (final raw in ids) {
        final id = int.tryParse(raw);
        final name = id == null
            ? 'Agent $raw'
            : (_filters.agentsList
                      .expand((group) => group.agents) // flatten all groups
                      .firstWhereOrNull((a) => a.id == id)
                      ?.name ??
                  'Agent $id');

        chips.add(
          _chip('Agent: $name', () {
            _controller.removeTag('agent_id');
          }),
        );
      }
    }

    // Date range
    if (f.fromDate.isNotEmpty || f.toDate.isNotEmpty) {
      final label =
          'Date: ${f.fromDate.isEmpty ? '…' : f.fromDate} → ${f.toDate.isEmpty ? '…' : f.toDate}';
      chips.add(_chip(label, () => _controller.removeTag('date_range')));
    }

    // Status (CSV of ids)
    if (f.status.isNotEmpty) {
      final ids = f.status.split(',').where((e) => e.trim().isNotEmpty);
      for (final raw in ids) {
        final id = int.tryParse(raw);
        final name = id == null
            ? 'Status $raw'
            : (_filters.statusList.firstWhereOrNull((s) => s.id == id)?.name ??
                  'Status $id');
        chips.add(_chip(name, () => _controller.removeTag('status', id: id)));
      }
    }

    // Campaign (CSV of ids)
    if (f.campaign.isNotEmpty) {
      final ids = f.campaign.split(',').where((e) => e.trim().isNotEmpty);
      for (final raw in ids) {
        final id = int.tryParse(raw);
        final name = id == null
            ? 'Campaign $raw'
            : (_filters.campaignList
                      .firstWhereOrNull((c) => c.id == id)
                      ?.name ??
                  'Campaign $id');
        chips.add(_chip(name, () => _controller.removeTag('campaign', id: id)));
      }
    }

    // Source (CSV of ids)
    if (f.source.isNotEmpty) {
      final ids = f.source.split(',').where((e) => e.trim().isNotEmpty);
      for (final raw in ids) {
        final id = int.tryParse(raw);
        final name = id == null
            ? 'Source $raw'
            : (_filters.sourceList.firstWhereOrNull((s) => s.id == id)?.name ??
                  'Source $id');
        chips.add(_chip(name, () => _controller.removeTag('source', id: id)));
      }
    }

    // Fresh
    if (f.isFresh.isNotEmpty) {
      chips.add(
        _chip(
          'Fresh: ${f.isFresh == '1' ? 'Yes' : 'No'}',
          () => _controller.removeTag('is_fresh'),
        ),
      );
    }

    // Keyword
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
        title: const Text('Cold Calls', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Obx(
            () => Text(
              _controller.totalCount.value > 0
                  ? '(${_controller.totalCount.value})'
                  : 'No Leads',
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.filter, color: Colors.white),
            onPressed: () =>
                Get.to(() => const FilterPage(flag: "fromColdCalls")),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.fetchColdCalls(reset: true),
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
        final chips = _buildActiveFilterChips();

        if (_controller.isLoading.value && _controller.coldCalls.isEmpty) {
          return Column(
            children: [
              if (chips.isNotEmpty)
                _FilterChipsBar(
                  chips: chips,
                  onClear: _controller.clearFilters,
                ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: 6,
                  itemBuilder: (_, __) => const ColdCallShimmer(),
                ),
              ),
            ],
          );
        }

        if (_controller.coldCalls.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (chips.isNotEmpty)
                _FilterChipsBar(
                  chips: chips,
                  onClear: _controller.clearFilters,
                ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.call_missed_outgoing,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'No cold calls available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        final dateKeys = _controller.groupedDateKeys;
        final grouped = _controller.groupedCalls;

        // Build flat list: [Header, items..., Header, items..., footer]
        final widgets = <Widget>[];

        if (chips.isNotEmpty) {
          widgets.add(
            _FilterChipsBar(chips: chips, onClear: _controller.clearFilters),
          );
        }

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
                child: ColdCallCard(call: call),
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
