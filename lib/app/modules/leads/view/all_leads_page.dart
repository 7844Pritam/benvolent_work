import 'package:benevolent_crm_app/app/modules/others/screens/leads_details_page.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/modules/leads/widget/lead_card.dart';
import 'package:benevolent_crm_app/app/modules/cold_calls/widgets/cold_call_shimmer.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/view/converted_calls_page.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AllLeadsPage extends StatelessWidget {
  AllLeadsPage({super.key});

  final LeadsController _controller = Get.put(LeadsController());
  final FiltersController _filters = Get.isRegistered<FiltersController>()
      ? Get.find<FiltersController>()
      : Get.put(FiltersController(), permanent: true);

  List<Widget> _buildActiveFilterChips() {
    final f = _controller.currentFilters.value;
    final chips = <Widget>[];

    if (f.agentId.isNotEmpty) {
      chips.add(
        _chip('Agent: ${f.agentId}', () {
          _controller.removeTag('agent_id');
        }),
      );
    }

    if (f.fromDate.isNotEmpty || f.toDate.isNotEmpty) {
      final label =
          'Date: ${f.fromDate.isEmpty ? '…' : f.fromDate} → ${f.toDate.isEmpty ? '…' : f.toDate}';
      chips.add(_chip(label, () => _controller.removeTag('date_range')));
    }

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

    if (f.isFresh.isNotEmpty) {
      chips.add(
        _chip(
          'Fresh: ${f.isFresh == '1' ? 'Yes' : 'No'}',
          () => _controller.removeTag('is_fresh'),
        ),
      );
    }

    if (f.developerId.isNotEmpty) {
      chips.add(
        _chip(
          'Developer: ${f.developerId}',
          () => _controller.removeTag('developer'),
        ),
      );
    }
    if (f.propertyId.isNotEmpty) {
      chips.add(
        _chip(
          'Property: ${f.propertyId}',
          () => _controller.removeTag('property'),
        ),
      );
    }
    if (f.priority.isNotEmpty) {
      chips.add(
        _chip(
          'Priority: ${f.priority}',
          () => _controller.removeTag('priority'),
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

  Widget _chip(String label, VoidCallback onDeleted) => InputChip(
    label: Text(label),
    onDeleted: onDeleted,
    deleteIcon: const Icon(Icons.close, size: 18),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        title: const Text('Leads', style: TextStyle(color: Colors.white)),
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
          // Text(
          //   style: const TextStyle(color: Colors.white, fontSize: 22),
          //   _controller.totalCount.value > 0
          //       ? '(${_controller.totalCount.value})'
          //       : 'No Leads',
          // ),
          IconButton(
            icon: const Icon(LucideIcons.filter, color: Colors.white),

            onPressed: () =>
                Get.to(() => const FilterPage(flag: "fromAllLeads")),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.fetchLeads(reset: true),
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

        if (_controller.isLoading.value && _controller.leads.isEmpty) {
          return Column(
            children: [
              if (chips.isNotEmpty)
                _FilterChipsBar(
                  chips: chips,
                  onClear: _controller.clearAllFilters,
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

        if (_controller.noResults.value) {
          return Column(
            children: [
              if (chips.isNotEmpty)
                _FilterChipsBar(
                  chips: chips,
                  onClear: _controller.clearAllFilters,
                ),
              const Expanded(
                child: Center(child: Text('No leads match your filters.')),
              ),
            ],
          );
        }

        final dateKeys = _controller.groupedDateKeys;
        final grouped = _controller.groupedLeads;
        final widgets = <Widget>[];

        if (chips.isNotEmpty) {
          widgets.add(
            _FilterChipsBar(chips: chips, onClear: _controller.clearAllFilters),
          );
        }

        for (final key in dateKeys) {
          widgets.add(_DateHeader(label: key));
          final items = grouped[key] ?? const [];
          for (final lead in items) {
            widgets.add(const SizedBox(height: 8));
            widgets.add(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () => Get.to(ConvertedCallDetailPage(leadId: lead.id)),
                  child: LeadCard(lead: lead),
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
              padding: EdgeInsets.fromLTRB(16, 16, 16, 74),
              child: Center(child: Text('No more leads')),
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (s) {
            final atBottom =
                s.metrics.pixels >= (s.metrics.maxScrollExtent - 80);
            if (atBottom &&
                !_controller.isPaginating.value &&
                _controller.canLoadMore) {
              _controller.fetchLeads();
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
