import 'package:benevolent_crm_app/app/modules/filters/view/filter_page.dart';
import 'package:benevolent_crm_app/app/modules/leads/widget/lead_card.dart';
import 'package:benevolent_crm_app/app/modules/leads/widget/lead_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';

class AllLeadsPage extends StatelessWidget {
  final LeadsController _controller = Get.put(LeadsController());

  AllLeadsPage({super.key});

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
            onPressed: () => Get.to(() => FilterPage(flag: "fromAllLeads")),
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
        if (_controller.noResults.value && _controller.leads.isEmpty) {
          return _EmptyState(
            onClearFilters: () => _controller.clearAllFilters(),
            onModifyFilters: () =>
                Get.to(() => FilterPage(flag: "fromAllLeads")),
          );
        }

        // Build a flat list of widgets: [Header, items..., Header, items..., footer]
        final List<Widget> slotted = [];

        final dateKeys = _controller.groupedDateKeys;
        final grouped = _controller.groupedLeads;

        for (final key in dateKeys) {
          // Date header
          slotted.add(_DateHeader(label: key));

          // Items under the date
          final items = grouped[key] ?? const [];
          for (final lead in items) {
            slotted.add(
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: LeadCard(lead: lead),
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
                children: [
                  LeadCardShimmer(),
                  SizedBox(height: 8),
                  LeadCardShimmer(),
                ],
              ),
            ),
          );
        } else if (!_controller.canLoadMore) {
          slotted.add(
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  "No more leads available",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Column(
          children: [
            // 🔍 Search bar (UI only here; hook to controller if needed)
            // AllLeadsPage.dart  ➜ inside build(), above the Search bar:
            Obx(() {
              final f = _controller.currentFilters.value;

              final hasAny =
                  (f.agentId?.isNotEmpty ?? false) ||
                  (f.status?.isNotEmpty ?? false) ||
                  (f.campaign?.isNotEmpty ?? false) ||
                  (f.keyword?.isNotEmpty ?? false) ||
                  (f.fromDate?.isNotEmpty ?? false) ||
                  (f.toDate?.isNotEmpty ?? false);

              if (!hasAny) return const SizedBox.shrink();

              // Build human-friendly date range
              String dateLabel() {
                if ((f.fromDate ?? '').isEmpty && (f.toDate ?? '').isEmpty)
                  return '';
                if ((f.fromDate ?? '').isNotEmpty &&
                    (f.toDate ?? '').isNotEmpty) {
                  return 'Date: ${f.fromDate} → ${f.toDate}';
                }
                if ((f.fromDate ?? '').isNotEmpty) return 'From: ${f.fromDate}';
                return 'To: ${f.toDate}';
              }

              final chips = <Widget>[];

              if ((f.agentId ?? '').isNotEmpty) {
                chips.add(
                  _ChipX(
                    label: 'Agent: ${f.agentId}',
                    onDelete: () => _controller.removeFilter('agent'),
                  ),
                );
              }
              if ((f.status ?? '').isNotEmpty) {
                chips.add(
                  _ChipX(
                    label: 'Status: ${f.status}',
                    onDelete: () => _controller.removeFilter('status'),
                  ),
                );
              }
              if ((f.campaign ?? '').isNotEmpty) {
                chips.add(
                  _ChipX(
                    label: 'Campaign: ${f.campaign}',
                    onDelete: () => _controller.removeFilter('campaign'),
                  ),
                );
              }
              if ((f.keyword ?? '').isNotEmpty) {
                chips.add(
                  _ChipX(
                    label: 'Keyword: ${f.keyword}',
                    onDelete: () => _controller.removeFilter('keyword'),
                  ),
                );
              }
              final dl = dateLabel();
              if (dl.isNotEmpty) {
                chips.add(
                  _ChipX(
                    label: dl,
                    onDelete: () => _controller.removeFilter('daterange'),
                  ),
                );
              }

              // Clear All chip at the end
              chips.add(
                _ChipOutlined(
                  label: 'Clear all',
                  onTap: () => _controller.clearAllFilters(),
                ),
              );

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Wrap(spacing: 8, runSpacing: 8, children: chips),
              );
            }),

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
                // onChanged: (q) => _controller.applySearch(q), // optional
              ),
            ),

            // 🔽 Sort option (kept as-is)
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

            // 📄 Grouped List
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (!_controller.isPaginating.value &&
                      scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 80 &&
                      _controller.canLoadMore) {
                    _controller.fetchLeads();
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
        onPressed: () => _controller.fetchLeads(reset: true),
        child: const Icon(Icons.refresh),
        backgroundColor: Theme.of(context).primaryColor,
      ),
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
// AllLeadsPage.dart  ➜ helpers at bottom

class _ChipX extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;
  const _ChipX({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return InputChip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      onDeleted: onDelete,
      deleteIcon: const Icon(Icons.close, size: 18),
      backgroundColor: Colors.grey.shade100,
      side: BorderSide(color: Colors.grey.shade300),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _ChipOutlined extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipOutlined({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onPressed: onTap,
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade400),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onClearFilters;
  final VoidCallback onModifyFilters;
  const _EmptyState({
    required this.onClearFilters,
    required this.onModifyFilters,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              "No leads found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Try clearing or adjusting your filters.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                OutlinedButton(
                  onPressed: onModifyFilters,
                  child: const Text("Modify filters"),
                ),
                ElevatedButton(
                  onPressed: onClearFilters,
                  child: const Text("Clear all"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
