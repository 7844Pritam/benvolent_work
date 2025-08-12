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
  String? _isFresh; // null = Any, '1' = Yes, '0' = No

  final List<String> filterOptions = [
    'Agent',
    'Date Range',
    'Status',
    'Campaign',
    'Keyword',
    'Sub Status',
    'Source',
    'Is Fresh',
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
      _isFresh = null; // reset radio
    });
  }

  Widget buildRightPanel() {
    switch (activeFilter) {
      case 'Agent':
        return Column(
          children: [
            'John Mitchell',
            'Sarah Johnson',
            'Michael Chen',
          ].map((name) => agentSingleSelectTile(name)).toList(),
        );

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
      case 'Is Fresh':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Show only fresh leads?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            // Any (clears filter)
            RadioListTile<String>(
              value: 'any',
              groupValue: _isFresh == null ? 'any' : _isFresh,
              onChanged: (_) => setState(() => _isFresh = null),
              title: const Text('Any'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),

            // Yes = '1'
            RadioListTile<String>(
              value: '1',
              groupValue: _isFresh ?? 'any',
              onChanged: (v) => setState(() => _isFresh = v),
              title: const Text('Yes'),
              dense: true,
              contentPadding: EdgeInsets.zero,
            ),

            // No = '0'
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
                      selectedSet: selectedStatuses,
                      id: subStatus.id ?? 0, // Handle null id
                    ),
                  )
                  .toList(),
            ),
          );
        });
      case 'Source':
        return Obx(() {
          return SingleChildScrollView(
            child: Column(
              children: _filtersController.sourceList
                  .map(
                    (source) => multiSelectTile(
                      label: source.name,
                      selectedSet: selectedSources, // <-- was selectedCampaigns
                      id: source.id,
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
                  .map(
                    (data) => multiSelectTile(
                      label: data.name,
                      id: data.id,
                      selectedSet: selectedCampaigns,
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

  Widget agentSingleSelectTile(String name) {
    final isSelected = selectedAgent == name;
    return GestureDetector(
      onTap: () => setState(() => selectedAgent = name),
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
                Container(
                  width: MediaQuery.of(context).size.width * 0.33,
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
                    if (_isApplying) return; // debounce
                    setState(() => _isApplying = true);

                    final controller1 = Get.find<LeadsController>();

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
                      await controller1.applyFilters(
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
                      print(e.toString());
                      // your snackbar already shows in controller on error, so this is optional
                    } finally {
                      // Always try to go back, even when no results
                      print(
                        "Applying filters10101101: ${controller1.currentFilters.value.toJson()}",
                      );
                      if (mounted) {
                        if (Get.key.currentState?.canPop() == true) {
                          Get.back();
                        } else {
                          // fallback in case of nested navigators
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
