import 'package:benevolent_crm_app/app/modules/cold_calls/controllers/cold_call_controller.dart';
import 'package:benevolent_crm_app/app/modules/converted_call/controller/converted_call_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/controllers/filters_controller.dart';
import 'package:benevolent_crm_app/app/modules/filters/widgets/date_range_bottom.dart';
import 'package:benevolent_crm_app/app/modules/leads/controller/leads_controller.dart';
import 'package:benevolent_crm_app/app/modules/leads/modals/leads_request.dart';
import 'package:benevolent_crm_app/app/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FilterPage extends StatefulWidget {
  final String flag;
  const FilterPage({super.key, required this.flag});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String selectedAgent = '';
  Set<int> selectedStatuses = {};
  Set<int> selectedSubStatuses = {};
  Set<int> selectedCampaigns = {};
  String selectedDateRange = '';
  Set<int> selectedSources = {};
  String keyword = '';
  String activeFilter = 'Agent';
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isApplying = false;
  final FiltersController _filtersController = Get.put(FiltersController());
  String? _isFresh;

  // NEW: track which campaignId sources are loaded for
  int? _sourcesForCampaignId;

  final List<String> filterOptions = [
    'Agent',
    'Date Range',
    'Status',
    'Campaign',
    'Source',
    'Fresh Leads',
    'Keyword',
    // 'Sub Status',
  ];

  void clearFilters() {
    setState(() {
      selectedAgent = '';
      selectedStatuses.clear();
      selectedSubStatuses.clear();
      selectedCampaigns.clear();
      selectedSources.clear();
      selectedDateRange = '';
      keyword = '';
      _fromDate = null;
      _toDate = null;
      _isFresh = null;

      // Also reset sources cache tracking
      _sourcesForCampaignId = null;
      _filtersController.sourceList.clear();
    });
  }

  // ----- UI BUILDERS -----

  Widget buildRightPanel() {
    switch (activeFilter) {
      case 'Agent':
        return Obx(() {
          if (_filtersController.isLoading.value &&
              _filtersController.agentsList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_filtersController.errorMessage.isNotEmpty) {
            return Text(_filtersController.errorMessage.value);
          }

          return Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _filtersController.agentsList.map((group) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (group.groupName.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              group.groupName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ...group.agents.map(
                          (agent) =>
                              agentSingleSelectTile(agent.name, id: agent.id),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        });

      case 'Status':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.statusList
                  .map(
                    (status) => multiSelectTile(
                      label: status.name,
                      selectedSet: selectedStatuses,
                      id: status.id,
                    ),
                  )
                  .toList(),
            ),
          );
        });

      case 'Fresh Leads':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Show only fresh leads?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            RadioListTile<String>(
              value: 'any',
              groupValue: _isFresh == null ? 'any' : _isFresh,
              onChanged: (_) => setState(() => _isFresh = null),
              title: const Text('All'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: '1',
              groupValue: _isFresh ?? 'any',
              onChanged: (v) => setState(() => _isFresh = v),
              title: const Text('Yes'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
            RadioListTile<String>(
              value: '0',
              groupValue: _isFresh ?? 'any',
              onChanged: (v) => setState(() => _isFresh = v),
              title: const Text('No'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        );

      case 'Sub Status':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.subStatusList
                  .map(
                    (subStatus) => multiSelectTile(
                      label: subStatus.subName,
                      selectedSet: selectedSubStatuses, // (optional fix)
                      id: subStatus.id,
                    ),
                  )
                  .toList(),
            ),
          );
        });

      case 'Campaign':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.campaignList
                  .map((data) => campaignTile(data.id, data.name))
                  .toList(),
            ),
          );
        });

      case 'Source':
        // Require exactly one campaign for sources
        if (selectedCampaigns.isEmpty) {
          return _hintBox(
            "Select a Campaign first",
            sub: "Pick a single campaign to view its sources.",
          );
        }
        if (selectedCampaigns.length > 1) {
          return _hintBox(
            "Multiple campaigns selected",
            sub: "Please select exactly one campaign to view sources.",
          );
        }

        final onlyCampaignId = selectedCampaigns.first;

        // Trigger fetch if the campaign changed
        if (_sourcesForCampaignId != onlyCampaignId) {
          _sourcesForCampaignId = onlyCampaignId;
          selectedSources.clear(); // reset previous selection
          _filtersController.sourceList.clear(); // clear stale results
          _filtersController.fetchSources(
            campaignId: onlyCampaignId.toString(),
          );
        }

        return Obx(() {
          if (_filtersController.isLoading.value &&
              _filtersController.sourceList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_filtersController.errorMessage.isNotEmpty) {
            return _hintBox(
              "Failed to load sources",
              sub: _filtersController.errorMessage.value,
              isError: true,
            );
          }
          if (_filtersController.sourceList.isEmpty) {
            return _hintBox("No sources found for this campaign");
          }

          return SingleChildScrollView(
            child: Column(
              children: _filtersController.sourceList
                  .map(
                    (source) => multiSelectTile(
                      label: source.name,
                      selectedSet: selectedSources,
                      id: source.id,
                    ),
                  )
                  .toList(),
            ),
          );
        });

      case 'Date Range':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => DateRangePickerBottomSheet(
                    onApply: (start, end) {
                      setState(() {
                        _fromDate = start;
                        _toDate = end;
                        selectedDateRange =
                            '${DateFormat.yMMMd().format(start)} - ${DateFormat.yMMMd().format(end)}';
                      });
                    },
                  ),
                );
              },
              icon: const Icon(Icons.date_range, color: Colors.white),
              label: const Text(
                "Pick Date Range",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 16),
            if (selectedDateRange.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        selectedDateRange,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => selectedDateRange = '');
                      },
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.black54,
                      ),
                      splashRadius: 18,
                    ),
                  ],
                ),
              ),
          ],
        );

      case 'Keyword':
        return TextField(
          onChanged: (val) => setState(() => keyword = val),
          decoration: InputDecoration(
            hintText: 'Enter keyword...',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        );

      default:
        return const Center(child: Text('Select a filter option'));
    }
  }

  // ---- Tiles ----
  Widget agentSingleSelectTile(String name, {required int id}) {
    final isSelected = selectedAgent == id.toString();
    return GestureDetector(
      onTap: () => setState(() => selectedAgent = id.toString()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Campaign tile with side-effects: clear sources when campaigns change
  Widget campaignTile(int id, String label) {
    final isSelected = selectedCampaigns.contains(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCampaigns.remove(id);
          } else {
            selectedCampaigns.add(id);
          }

          // Whenever campaign selection changes, reset sources
          _sourcesForCampaignId = null;
          selectedSources.clear();
          _filtersController.sourceList.clear();
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.purple.shade900 : Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget multiSelectTile({
    required String label,
    required Set<int> selectedSet,
    required int id,
  }) {
    final isSelected = selectedSet.contains(id);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedSet.remove(id);
          } else {
            selectedSet.add(id);
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.green.shade900 : Colors.grey.shade800,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // Small helper for hints/errors
  Widget _hintBox(String title, {String? sub, bool isError = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isError
            ? Colors.red.withOpacity(.06)
            : Colors.blue.withOpacity(.06)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: (isError ? Colors.red : Colors.blue).withOpacity(.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isError ? Colors.red.shade700 : Colors.blue.shade700,
            ),
          ),
          if (sub != null) ...[
            const SizedBox(height: 6),
            Text(sub, style: const TextStyle(color: Colors.black54)),
          ],
        ],
      ),
    );
  }

  // ----- BUILD -----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primaryColor,
        title: const Text("Filter", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left filter list
                Container(
                  width: MediaQuery.of(context).size.width * 0.40,
                  color: Colors.grey.shade100,
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: filterOptions.map((option) {
                      final isActive = activeFilter == option;
                      return GestureDetector(
                        onTap: () => setState(() => activeFilter = option),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.blue.shade100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isActive
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            option,
                            style: TextStyle(
                              color: isActive
                                  ? Colors.blue.shade800
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Right panel
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.white,
                    child: buildRightPanel(),
                  ),
                ),
              ],
            ),
          ),

          // Bottom actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: clearFilters,
                  icon: const Icon(Icons.clear, color: Colors.black54),
                  label: const Text(
                    'Clear Filters',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_isApplying) return;
                    setState(() => _isApplying = true);

                    dynamic controller1;
                    if (widget.flag == 'fromColdCalls') {
                      controller1 = Get.find<ColdCallController>();
                    } else if (widget.flag == 'fromConvertedCalls') {
                      controller1 = Get.find<ConvertedCallController>();
                    } else if (widget.flag == 'fromAllLeads') {
                      controller1 = Get.find<LeadsController>();
                    }

                    final statusCsv = selectedStatuses.isNotEmpty
                        ? selectedStatuses.join(',')
                        : '';
                    final campaignCsv = selectedCampaigns.isNotEmpty
                        ? selectedCampaigns.join(',')
                        : '';
                    final sourceCsv = selectedSources.isNotEmpty
                        ? selectedSources.join(',')
                        : '';

                    String fmt(DateTime? d) =>
                        d == null ? '' : DateFormat('yyyy-MM-dd').format(d);

                    try {
                      controller1?.applyFilters(
                        LeadRequestModel(
                          agentId: selectedAgent,
                          fromDate: fmt(_fromDate),
                          toDate: fmt(_toDate),
                          status: statusCsv,
                          campaign: campaignCsv,
                          source: sourceCsv,
                          isFresh: _isFresh ?? '',
                          keyword: keyword,
                          developerId: '',
                          propertyId: '',
                          priority: '',
                        ),
                      );
                    } catch (e) {
                      // optional: show error
                    } finally {
                      if (mounted) {
                        if (Get.key.currentState?.canPop() == true) {
                          Get.back();
                        } else {
                          Navigator.of(context).maybePop();
                        }
                      }
                      if (mounted) setState(() => _isApplying = false);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    elevation: 6,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
